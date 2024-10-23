Return-Path: <kvm+bounces-29480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6879AC902
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 386CA283646
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF701ABECA;
	Wed, 23 Oct 2024 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m1DZQxX5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3E61AB6C7
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683252; cv=none; b=E+EQOeIACBlmHSTp0Y5Qoim1S3Nt+FnvT34jUUXRSQkNTOMdKeRzf7UhTnSMqDgC9yTCPyU2JckWtmJD9MiA3lQdYxnT7vgeNlhOb32JDyRXnaSq3Sr2PgjLL1B/E/cuEIyEeoCx2l43jwCY7Mu6m4ywk5B2RtsKOg/q5mkoMPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683252; c=relaxed/simple;
	bh=0eFsYAly1/qNyLw7uhoTDRrzQM6B2msfiCoMYRmVpDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgHLg+V9rW/91SmnQrYNLTO/8EZslGXbdM3Vu11pDgI5HVDSmZZ7r3o4yLbtlnLZlTPVRcJZhTP8QizoDnHOh//nIZHQAy/n2a2HTTvM5pu7dhJxa7TqlDzXCjICFB3AGxIIycZjS4QaQv8LDDsP4q8xzDRf4ScvMEplIyVQqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m1DZQxX5; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cb6b2b7127so3031698a12.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683249; x=1730288049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XNjfi7hRi9preQg6Skm6jboyJIHM73C5JCjrQ/Fxa0=;
        b=m1DZQxX5heZt2Sn/mspxoxpwm+ewV71/DAfaL8cyemEM8r+J2zBLLuzTQtrocQ+2gX
         94IGJCeZz5iFdjDqxtAlEWTMWMK/M55o409sa56f/Bfjkzb1HyR9eCGwO9lQuYaHWxXD
         NN3vPjYGWdqqq+vxG+ti4mNxuD3RzbiXkIvZxwDL7pl6Y6AW1M5lutHZz0qgsgmrSRbd
         Y+ducYLtV4GUusO5dVDPKoIC2j3ak5MMVoYnVykk9AmTTkOEGLIr/QaWNbP5d1V1z+Rk
         tsVqsujA34EhTdbW0spT5dEuu6LjI6ScSRoWq767QPr/DernpNegsdO3axrjCdw7Z63D
         2H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683249; x=1730288049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XNjfi7hRi9preQg6Skm6jboyJIHM73C5JCjrQ/Fxa0=;
        b=RE37ht+SreS4J8RxYfaOQ9sM/5+z6ONRXxg7X6jqKQ1ZwCDkG8y49OQLhPjJBXoPP2
         3BzYWAtabnpPVIwilsHkh3fod5h1DkrzcsmyjdqodtSDenjyGSnqiLIVFlZ0udjIPq0o
         6TlILauolG0NmX/715PFY/b+AjonHfZnFdLjLPTMpTNIUh6yeO08vCfHn5wO338dyv4Q
         bOUWb7lntGyZ7U5VAwh45gaGXxUZtZ9o2Uc8/K9atZOLPEk0ZCKQoygXX0QFlq77ucRF
         GcOH9uALKBm+HxGzVMXJD69YuvSU21QcYnLgqjFPHft1GSHZGQbI5joYpOJa/PcRrH+d
         bHoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRDMzryNedpYCQApQsNzYUJmsrdowGhfTv+R0Z9csnHAZ8HSJgjE8nX+fBP7jpPhR5Ajc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeotnQo9KsmncFCNOrvCRG6kFEnGrScSG2B/wQgd3HXDaJLjCv
	cOsh71AX+EUcS/M2H7pxtnjZciURmgIhAC0vIHhk7p5oS1Cjase46DSM9T0JmlA=
X-Google-Smtp-Source: AGHT+IHbBHuAhyUoRAK6Z+ouKhhEjsA1T4wrJBvMTAuUApw84TIFTJaW/QBSBiQQ9GXdgQDRf9QMxg==
X-Received: by 2002:a05:6402:434c:b0:5c4:51b3:d75f with SMTP id 4fb4d7f45d1cf-5cb8af72080mr1849170a12.24.1729683248677;
        Wed, 23 Oct 2024 04:34:08 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb766710d1sm2661378a12.90.2024.10.23.04.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:07 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 11D8C5F8AD;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 01/18] tests/docker: Fix microblaze atomics
Date: Wed, 23 Oct 2024 12:33:49 +0100
Message-Id: <20241023113406.1284676-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

GCC produces invalid code for microblaze atomics.

The fix is unfortunately not upstream, so fetch it from an external
location and apply it locally.

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20241022105614.839199-2-alex.bennee@linaro.org>
Message-Id: <20240919152308.10440-1-iii@linux.ibm.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .../debian-microblaze-cross.d/build-toolchain.sh          | 8 ++++++++
 tests/docker/dockerfiles/debian-toolchain.docker          | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/tests/docker/dockerfiles/debian-microblaze-cross.d/build-toolchain.sh b/tests/docker/dockerfiles/debian-microblaze-cross.d/build-toolchain.sh
index 23ec0aa9a7..c5cd0aa931 100755
--- a/tests/docker/dockerfiles/debian-microblaze-cross.d/build-toolchain.sh
+++ b/tests/docker/dockerfiles/debian-microblaze-cross.d/build-toolchain.sh
@@ -10,6 +10,8 @@ TOOLCHAIN_INSTALL=/usr/local
 TOOLCHAIN_BIN=${TOOLCHAIN_INSTALL}/bin
 CROSS_SYSROOT=${TOOLCHAIN_INSTALL}/$TARGET/sys-root
 
+GCC_PATCH0_URL=https://raw.githubusercontent.com/Xilinx/meta-xilinx/refs/tags/xlnx-rel-v2024.1/meta-microblaze/recipes-devtools/gcc/gcc-12/0009-Patch-microblaze-Fix-atomic-boolean-return-value.patch
+
 export PATH=${TOOLCHAIN_BIN}:$PATH
 
 #
@@ -31,6 +33,12 @@ mv gcc-11.2.0 src-gcc
 mv musl-1.2.2 src-musl
 mv linux-5.10.70 src-linux
 
+#
+# Patch gcc
+#
+
+wget -O - ${GCC_PATCH0_URL} | patch -d src-gcc -p1
+
 mkdir -p bld-hdr bld-binu bld-gcc bld-musl
 mkdir -p ${CROSS_SYSROOT}/usr/include
 
diff --git a/tests/docker/dockerfiles/debian-toolchain.docker b/tests/docker/dockerfiles/debian-toolchain.docker
index 687a97fec4..ab4ce29533 100644
--- a/tests/docker/dockerfiles/debian-toolchain.docker
+++ b/tests/docker/dockerfiles/debian-toolchain.docker
@@ -10,6 +10,8 @@ FROM docker.io/library/debian:11-slim
 # ??? The build-dep isn't working, missing a number of
 # minimal build dependiencies, e.g. libmpc.
 
+RUN sed 's/^deb /deb-src /' </etc/apt/sources.list >/etc/apt/sources.list.d/deb-src.list
+
 RUN apt update && \
     DEBIAN_FRONTEND=noninteractive apt install -yy eatmydata && \
     DEBIAN_FRONTEND=noninteractive eatmydata \
@@ -33,6 +35,11 @@ RUN cd /root && ./build-toolchain.sh
 # and the build trees by restoring the original image,
 # then copying the built toolchain from stage 0.
 FROM docker.io/library/debian:11-slim
+RUN apt update && \
+    DEBIAN_FRONTEND=noninteractive apt install -yy eatmydata && \
+    DEBIAN_FRONTEND=noninteractive eatmydata \
+    apt install -y --no-install-recommends \
+        libmpc3
 COPY --from=0 /usr/local /usr/local
 # As a final step configure the user (if env is defined)
 ARG USER
-- 
2.39.5


