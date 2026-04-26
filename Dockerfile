FROM debian:trixie-slim

# Bootstrap: fetch tools needed to set up the repo
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download GPG key with correct permissions
RUN curl -fsSL https://www.lesbonscomptes.com/pages/lesbonscomptes.gpg \
    | gpg --dearmor -o /usr/share/keyrings/lesbonscomptes.gpg && \
    chmod 644 /usr/share/keyrings/lesbonscomptes.gpg

# Add Recoll repository
ADD https://www.recoll.org/pages/recoll-trixie.sources /etc/apt/sources.list.d/

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        recollcmd \
        python3-recoll \
        poppler-utils \
        antiword \
        unrtf \
        python3-mutagen \
        libimage-exiftool-perl \
        libjson-perl \
        python3-rarfile \
        python3-py7zr \
        ghostscript \
        untex \
        python3-lxml \
        libreoffice \
        jupyter-nbconvert \
        gunicorn \
        aspell \
        aspell-en \
        file \
        xz-utils \
        zstd \
        bzip2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download Recoll Web UI
RUN curl -fsSL https://framagit.org/medoc92/recollwebui/-/archive/master/recollwebui-master.tar.gz \
    | tar -xzf -

WORKDIR /recollwebui-master
EXPOSE 8080
CMD ["/usr/bin/gunicorn", "webui-wsgi:application", "--bind", "0.0.0.0:8080"]
