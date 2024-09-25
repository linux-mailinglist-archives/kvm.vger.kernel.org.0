Return-Path: <kvm+bounces-27473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4C798655A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E1591C244C5
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DD082499;
	Wed, 25 Sep 2024 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K2yMx7dw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5243D0A9
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284306; cv=none; b=IxO4gfKFLd3JPh/wFZiUruoH46ORLOkG/ZY82BsT1Lcn3vh032RSo9vQCnYDoJKvCf8LU19seaLs47K2D+/q6V9kCiodp5kfL0W3p7xiGCLlup1/WM1WG879QDQiomThy7UOBDLUPhBtgkqPX+lCTVaWV/Yhq2ggiqL8WfRevCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284306; c=relaxed/simple;
	bh=sSm/9Vnpe0c5KVdK+sQHwIZ6tJywvbLZUfI5KYQ2tQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVi3x9PkN8HBum+fR3z2+5TMKsdXfBNCZbGHLL4Wpue+8uBn7jPYnOOIDr5KgyeHB5R1fPxop0ZFay0mX1MbAeHQo+fvojZCR3ZKIJ/drOxzhjtm0X84JZYVXu4hqyLqbaD8MQga/tsBvD98C4laZuFk+M6fVeGLHPVJQyrcXEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K2yMx7dw; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-374c326c638so4535f8f.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284302; x=1727889102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3Onvi9UHbad6ukc7arbUZKYIPfwRyBIrmeNY5wtelU=;
        b=K2yMx7dwVDt2uVo8lqxzJgFMNRK6Czk/lRCAL3JV6gew92Lv1Qdbc8pzcK2zLQg9S+
         66mq9/tAU6s19EHSpl7Qup4fLngbIyhInuOXqA9xsJ+pIqtRjl6nu/vyB9bgYfBiSd6a
         ZaDD6o6MO9psO1AhdYjnB42QDiSo1LD5z8CAgLBjWiUjMJtsVbY2zIlMjnsEnNhgHq4/
         9mQmTruBSTZs4fzSMLGQIx/sYAufhwz9navx/1G1/0bRNE0caR/tokAE7v+RgD4Nh6oq
         EwWJp0q8zYDyeIg1Dp2P4lm2/t7zk1lwEIr0sY079GPsM+svP8NK+vJhFwk3Ir2VEJvY
         WWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284302; x=1727889102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3Onvi9UHbad6ukc7arbUZKYIPfwRyBIrmeNY5wtelU=;
        b=VG+M4jVytcm1R0YeZ2vCmb3CQcIAFwknq8sWyuKH8ZEe0qBEnanEL0MUPKbv7i98kr
         boJTDV96F2tNHZ32pSQCMxO84Bq1vWP6r5dNlC5u6vKt1VAeZyO5pHCa3/K45oxO0A4z
         mQWZ0JXE4rrITo7lDfgkyLIq7NhdjXM5JYKRhCEoxiWZKxVKK7HDB8vhezm/BoXpq2u1
         5IW6Q5RxWdLXj935kIQgjkptCrl8wfVAb5z/C9FSBs0aK0vIrjywxB1tMPe7tzLuleOS
         LFyZuPg7+THLH87Hw875eaXVYYT8z2DVet/kDud7RfKT4icdhX7c7R3/J8OJJleYe9gi
         NCaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjLPdyQpHi/crI7mBnRwB2YO3HZZrqlBoK57PZGjG3DFVlyi+/S3svsI/8G0ZZvopC//U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW/4PXNt3k5rJvmRHKAlUUWAJZB+TreZKg6yUJPTN4tjE+W0EI
	MvSP8/ZBOGpQVURY9rs3DGTEZJ7gdvhzwAPZgi92jv6Vdtxtn7FIR15T4pKXpCo=
X-Google-Smtp-Source: AGHT+IGU9YspaaYUHAocJNpuK/dESiOM4/xW0oakkSg3HjbqR0jo4IN7CZSLTTUEdfpSOxiESLD4oA==
X-Received: by 2002:adf:e341:0:b0:371:9377:975f with SMTP id ffacd0b85a97d-37cc248404amr1850453f8f.25.1727284302309;
        Wed, 25 Sep 2024 10:11:42 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2c13cesm4508393f8f.29.2024.09.25.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:41 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6E4A45F920;
	Wed, 25 Sep 2024 18:11:40 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	devel@lists.libvirt.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH 01/10] testing: bump mips64el cross to bookworm and allow to fail
Date: Wed, 25 Sep 2024 18:11:31 +0100
Message-Id: <20240925171140.1307033-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mips64el cross setup is very broken for bullseye which has now
entered LTS support so is unlikely to be fixed. While we still can't
build the container for bookworm due to a single missing dependency
that will hopefully get fixed in due course. For the sake of keeping
the CI green we mark it as allow_fail for the time being.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>
---
 .gitlab-ci.d/container-cross.yml                      |  3 +++
 tests/docker/dockerfiles/debian-mips64el-cross.docker | 10 ++++------
 tests/lcitool/refresh                                 |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/.gitlab-ci.d/container-cross.yml b/.gitlab-ci.d/container-cross.yml
index 34c0e729ad..c567926182 100644
--- a/.gitlab-ci.d/container-cross.yml
+++ b/.gitlab-ci.d/container-cross.yml
@@ -49,6 +49,9 @@ i686-debian-cross-container:
 mips64el-debian-cross-container:
   extends: .container_job_template
   stage: containers
+  # Currently waiting for Debian to fix:
+  #  libgl1-mesa-dri:mips64el : Depends: libllvm15:mips64el but it is not going to be installed
+  allow_failure: true
   variables:
     NAME: debian-mips64el-cross
 
diff --git a/tests/docker/dockerfiles/debian-mips64el-cross.docker b/tests/docker/dockerfiles/debian-mips64el-cross.docker
index 2862785692..69d6e8cd11 100644
--- a/tests/docker/dockerfiles/debian-mips64el-cross.docker
+++ b/tests/docker/dockerfiles/debian-mips64el-cross.docker
@@ -1,10 +1,10 @@
 # THIS FILE WAS AUTO-GENERATED
 #
-#  $ lcitool dockerfile --layers all --cross-arch mips64el debian-11 qemu
+#  $ lcitool dockerfile --layers all --cross-arch mips64el debian-12 qemu
 #
 # https://gitlab.com/libvirt/libvirt-ci
 
-FROM docker.io/library/debian:11-slim
+FROM docker.io/library/debian:12-slim
 
 RUN export DEBIAN_FRONTEND=noninteractive && \
     apt-get update && \
@@ -48,16 +48,15 @@ RUN export DEBIAN_FRONTEND=noninteractive && \
                       python3-opencv \
                       python3-pillow \
                       python3-pip \
-                      python3-setuptools \
                       python3-sphinx \
                       python3-sphinx-rtd-theme \
                       python3-venv \
-                      python3-wheel \
                       python3-yaml \
                       rpm2cpio \
                       sed \
                       socat \
                       sparse \
+                      swtpm \
                       tar \
                       tesseract-ocr \
                       tesseract-ocr-eng \
@@ -69,8 +68,6 @@ RUN export DEBIAN_FRONTEND=noninteractive && \
     dpkg-reconfigure locales && \
     rm -f /usr/lib*/python3*/EXTERNALLY-MANAGED
 
-RUN /usr/bin/pip3 install tomli
-
 ENV CCACHE_WRAPPERSDIR "/usr/libexec/ccache-wrappers"
 ENV LANG "en_US.UTF-8"
 ENV MAKE "/usr/bin/make"
@@ -143,6 +140,7 @@ RUN export DEBIAN_FRONTEND=noninteractive && \
                       libvdeplug-dev:mips64el \
                       libvirglrenderer-dev:mips64el \
                       libvte-2.91-dev:mips64el \
+                      libxdp-dev:mips64el \
                       libzstd-dev:mips64el \
                       nettle-dev:mips64el \
                       systemtap-sdt-dev:mips64el \
diff --git a/tests/lcitool/refresh b/tests/lcitool/refresh
index 92381f3c46..a78219f7bc 100755
--- a/tests/lcitool/refresh
+++ b/tests/lcitool/refresh
@@ -166,7 +166,7 @@ try:
                                             "x86_64-linux-user,"
                                             "i386-softmmu,i386-linux-user"))
 
-    generate_dockerfile("debian-mips64el-cross", "debian-11",
+    generate_dockerfile("debian-mips64el-cross", "debian-12",
                         cross="mips64el",
                         trailer=cross_build("mips64el-linux-gnuabi64-",
                                             "mips64el-softmmu,mips64el-linux-user"))
-- 
2.39.5


