# This is a sample Dockerfile you can modify to deploy your own app based on face_recognition

#FROM python:3.10.3-slim-bullseye
FROM python:3.6.15-slim-bullseye 
RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS


# The rest of this file just runs an example script.

# If you wanted to use this Dockerfile to run your own app instead, maybe you would do this:
# COPY . /root/your_app_or_whatever
# RUN cd /root/your_app_or_whatever && \
#     pip3 install -r requirements.txt
# RUN whatever_command_you_run_to_start_your_app
RUN mkdir -p /notebooks/emotions
ADD . /notebooks/emotions
WORKDIR /notebooks/emotions
RUN pip3 install -r requirements.txt && \
    python3 setup.py install

RUN pip3 install opencv-python-headless==4.1.2.30 
#if you want to run the live webcam examples

#CMD cd /root/face_recognition/examples && \
#    python3 recognize_faces_in_pictures.py
#RUN mkdir /notebooks
WORKDIR /notebooks
CMD jupyter notebook --no-browser --ip 0.0.0.0 --port 8888 --allow-root emotions
