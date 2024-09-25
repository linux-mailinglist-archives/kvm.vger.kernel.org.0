Return-Path: <kvm+bounces-27476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D61CC98655D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96FEE281AF8
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34501369BC;
	Wed, 25 Sep 2024 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tF40LMqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2780884A2C
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284311; cv=none; b=tgATTVow+RyktMgZ+OqHiWVGwVei7vhNW6sOxT/EAJNyojWajRPksBn58JEhlbEO1Q/wX5fdeD49TosjcOIQlprx1L8L7Y9RWY+l4it5y65+ypUTdIYuwOner8Pk1rfbHUVorfEkqfVfl/z98vdAtUMUXThybd5//WCpmb/zNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284311; c=relaxed/simple;
	bh=3ocp18cipe28Y1G4M2yx66dkQYTqfF/PEb1KxGFg+rU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iSyMAnorUrz+3gc8RDIKnpN4bFA4XpnlqPaabXFXdMw0kEeGy+zK4JhwqBj60/HaDXAT3CjHXqeigrnq4MTkBZ91dWxR2RRU+3fQNBQBy/ZwUrS5KV1YbJmbxKIrLWdZ6kF4gXrgI0H63Zdmxj44CT54SI5ADYEbYqVxgP0iPHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tF40LMqk; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-37cc4e718ecso27476f8f.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284307; x=1727889107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXjwiUjPDmRUKmjejukivCx1FVXlutJ/frWtXF30WgI=;
        b=tF40LMqk2ISNDRwNasCuRpLI7/vY247CWXBRfajCHNuTRl1Pq46zeG+jJc2z1AE9hp
         P0YKxZaGucZ6/n2RMe7Wt8aFdjQXLIRbjP4GkXmqfaf19dktvGAKywu+KlmYwM859oaY
         c9w7rRmylpW7UxIg+zAK95PdrBz9uWCFFRT2y2tyhc7+9a+x6s3azoby0qy0TJ2/bCEI
         D9pbJdG2/voi5r6rI1ViJVizk//Ec8Kn5+JPZOjNQnIQrBowyI2WgFQN02yTrEuNEPVO
         xw/a6JhBIDw94qMjXhJFasptAXSjTIVWPANxqVqzVTLi3sqS9JOgido/yLna58AelI9f
         vuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284307; x=1727889107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXjwiUjPDmRUKmjejukivCx1FVXlutJ/frWtXF30WgI=;
        b=ZQkXKNXwjVWHn07okOUq+Nbs1RGe1gf9sUr6h1a390eY0XoRkB+2gDbfHNAao4z6Ey
         6I2GSZeBBftxC9Jgg9aORxxIlZ65XE2oeP2rT3aoeF3GBhe8D/TBTTzuwjXVia2RbYCJ
         EafizR9DOK2beElXBqjGuDXU/ax0tQjcoNj7GaKZyVw8mp9FmObQWp4YXUftlCiVyCjI
         E413NB7L+Aq0FXT+z1TuwCm29i+Fee5A/h6qSC/CYuY3DecGtFfQ2p8gW0qwA5EaI0Ki
         USJSbrQJ0M7hCaLpqTr9czddn2PNKzcsu+CgS0N9C8rScBhp0rAOe5oYCTjJEkL6/l8d
         fJnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGzuHhnupAo4ptE7JTi4jWseM6VtTPMCVrgLxeq8GLAJmxwyLLbXZNUraSpBnvMi5Zzus=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrhBBJ4IhykKn5SQec1T0aQ4cnETPc12NDUfvcsJ1sC60jo/2k
	lyTEGaN2YxBCa918e9e0ywFLjVMXsG0Joaq8gM6b6TuMgmL1WIs+8y6GvjLxk1s=
X-Google-Smtp-Source: AGHT+IHV6HV/eWaJfeffMpjzbiz3n6OhSG/OKMDSorPfnryDAPUV5GyUbaXuXJP53F/aVYvFjacx1g==
X-Received: by 2002:a5d:6685:0:b0:374:c977:7453 with SMTP id ffacd0b85a97d-37cc24762e0mr2263987f8f.25.1727284307287;
        Wed, 25 Sep 2024 10:11:47 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e90274aa0sm35547145e9.0.2024.09.25.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8619C5F92F;
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
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH 02/10] tests/docker: Fix microblaze atomics
Date: Wed, 25 Sep 2024 18:11:32 +0100
Message-Id: <20240925171140.1307033-3-alex.bennee@linaro.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

GCC produces invalid code for microblaze atomics.

The fix is unfortunately not upstream, so fetch it from an external
location and apply it locally.

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
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


