FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    novnc websockify \
    dbus-x11 x11-utils x11-xserver-utils x11-apps \
    sudo xterm vim net-tools curl wget git tzdata \
 && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

# (اختیاری ولی خوب) xstartup برای XFCE
RUN mkdir -p /root/.vnc && \
    printf '#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Render فقط یک پورت رو public می‌کند (PORT)
EXPOSE 5901
EXPOSE 6080

CMD bash -lc '\
  : "${PORT:=6080}"; \
  vncserver :1 -localhost yes -SecurityTypes None -geometry 1024x768 -depth 24 --I-KNOW-THIS-IS-INSECURE; \
  websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT} localhost:5901; \
'
