#!/bin/sh

echo "Running BYOB app setup..."

# Install Python packages
echo "Installing Python packages..."
python3 -m pip install CMake==3.18.4
python3 -m pip install -r requirements.txt

# Build Docker images
echo "Building Docker images - this will take a while, please be patient..."
cd docker-pyinstaller
docker build -f Dockerfile-py3-amd64 -t nix-amd64 .
docker build -f Dockerfile-py3-i386 -t nix-i386 .
docker build -f Dockerfile-py3-win32 -t win-x32 .

read -p "To use some Byob features, you must reboot your system. If this is not your first time running this script, please answer no. Reboot now? [Y/n]: " agreeTo
#Reboots system if user answers Yes
case $agreeTo in
    y|Y|yes|Yes|YES)
    echo "Rebooting..."
    sleep 1
    sudo reboot now
    exit
    ;;
#Runs app if user answers No
    n|N|no|No|NO)
    cd ..
    echo "Running C2 server with locally hosted web app GUI...";
    echo "Navigate to http://127.0.0.1:5000 and set up your user to get started.";
    python3 run.py
    exit
    ;;
esac
