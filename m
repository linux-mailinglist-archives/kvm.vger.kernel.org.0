Return-Path: <kvm+bounces-29373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDD79AA09F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17F6FB23017
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2D719D8B2;
	Tue, 22 Oct 2024 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DjcUD7/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20B019D083
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594595; cv=none; b=cR0MJbZsJJM+uuF35YSog3fhoHW8vnN9P2fqSlTuW+i1trYRqe0ddtuJT3zmSpLVypm2BUCCb8pBhcpKfckHCkoz521uwUAqfcCxEifxF+vUpSdQZHEco+HdliBuuQoJOYrWQ3lUcr27vV1Z/ooPlp9qUr7mfhLMs9JFtnuLAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594595; c=relaxed/simple;
	bh=1Z5UScpG+BInmbuwnjQb4DYLB0wPDLPR+Hkmew9RU94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ipp/SQwi24BMetRO5fWIoyeYjTYNjzMY2YjlOHZxIv5TJ4F3lBl0kUvSbuoBr8HVLup2iMA6L3VPF21rcntrrtflvBOIc1jFtkCTWHsSO1gis2Q/k5ykR6W/hGCSPHNktn2p/R0pWLTM7IjsVxFfsFmCGp4Z14bp/ORdTvzY9DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DjcUD7/q; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a99f629a7aaso991509666b.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594592; x=1730199392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pf3uq1o/PXtMWzbvWkPU0TjSlCT93/aG9VyjOMqKoJo=;
        b=DjcUD7/qP67AIGatD2aSTuhvCc/AoZ7kE/RtqMY+sUQBeV8lCvxnfSVZqx8Yse6gZC
         I7rhwaXIqYGaz+hM/fEolbfyY/tOM4UzfQbJcI2NCZWKTeBqc/Ys0Gpma3csEO70IxUo
         krC5p99U2gWc5Qwyo/imziRqSHvmtlORLQs8h4zAA4AkcwHYCqoRPitX0zRB/aWwheIj
         5xUevTvTiTdfFm00vC93wghdxm0IKKKAN+hTjVGLxiVcwo447K9UOIjkrj0PTegGYMdw
         IgSwq6KjVbRhZwYgRB7rhQ99c+9j4q+J//KgKrHuNm3fhKo26J+9E8TXv8LDiPRkvivl
         f8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594592; x=1730199392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pf3uq1o/PXtMWzbvWkPU0TjSlCT93/aG9VyjOMqKoJo=;
        b=M9yIW/OIfqWq8M/yrAo9ywh6s5bJj7yxLqWGS14LhREIEg78olBksfHAaoOTaVdkiY
         UXaaoo5sWIfA/IU2Hc3IJjvGvvv1Ff0D/ckRvGS/X4WGxkPMj/s+lIyrH7jPBpuiJRMT
         GspqWOEADnWfWXwQpoObaOGeN7egLJ0o5cHQoC/yMD7TqdqH+NMIlxafJGarEWklowhT
         PTDP910VaI2pr+8Vqrx3j8wVfv1Io4cJuaWE3Vzai1WUNTLmu2Uz6NOxQxKwymVxSNen
         +uD+MqvBF3z4iA3lZHrQOHsHgl3Gqhffm58mW2RXFUVuJ919KPdwxiVe6rJr/rQCRz6j
         gWvA==
X-Forwarded-Encrypted: i=1; AJvYcCVPZ41AkUZlJ6CQjOphYZEUG/1tRZV2yWiYQ9DwYFzDhJ586jHWOuE7aA+DctTfl9aFkOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGG1y2tIEevw5sjtT52WlmabDeC4jUO/vmUVgwDPG9AedRYxmm
	cF1f9Lw51PqumbLZ7zB0O121yTqOtLzaAL2JQQtK3mY3oupzZmZkZOpUr4OEvps=
X-Google-Smtp-Source: AGHT+IFr+0mLMKe2JQJOUJSSxtHXWPXM2EDoaQ4nyTBJKccw5XUwjD1MaeL5ICuPvGV4e9NH5KWjRQ==
X-Received: by 2002:a17:906:c116:b0:a9a:1575:23e3 with SMTP id a640c23a62f3a-a9aaa5428e4mr236057266b.19.1729594592209;
        Tue, 22 Oct 2024 03:56:32 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9155a1c9sm323018666b.129.2024.10.22.03.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id C52CB5FBDC;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 13/20] tests/tcg: enable basic testing for aarch64_be-linux-user
Date: Tue, 22 Oct 2024 11:56:07 +0100
Message-Id: <20241022105614.839199-14-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We didn't notice breakage of aarch64_be because we don't have any TCG
tests for it. However while the existing aarch64 compiler can target
big-endian builds no one packages a BE libc. Instead we bang some
rocks together to do the most basic of hello world with a nostdlib
syscall test.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - fix checkpatch complaints
---
 configure                            |  5 ++++
 tests/tcg/aarch64_be/hello.c         | 35 ++++++++++++++++++++++++++++
 tests/tcg/Makefile.target            |  7 +++++-
 tests/tcg/aarch64_be/Makefile.target | 17 ++++++++++++++
 4 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 tests/tcg/aarch64_be/hello.c
 create mode 100644 tests/tcg/aarch64_be/Makefile.target

diff --git a/configure b/configure
index 72d1a94225..7dd3400ccb 100755
--- a/configure
+++ b/configure
@@ -1418,6 +1418,7 @@ probe_target_compiler() {
   target_arch=${1%%-*}
   case $target_arch in
     aarch64) container_hosts="x86_64 aarch64" ;;
+    aarch64_be) container_hosts="x86_64 aarch64" ;;
     alpha) container_hosts=x86_64 ;;
     arm) container_hosts="x86_64 aarch64" ;;
     hexagon) container_hosts=x86_64 ;;
@@ -1447,6 +1448,10 @@ probe_target_compiler() {
     case $target_arch in
       # debian-all-test-cross architectures
 
+      aarch64_be)
+        container_image=debian-all-test-cross
+        container_cross_prefix=aarch64-linux-gnu-
+        ;;
       hppa|m68k|mips|riscv64|sparc64)
         container_image=debian-all-test-cross
         ;;
diff --git a/tests/tcg/aarch64_be/hello.c b/tests/tcg/aarch64_be/hello.c
new file mode 100644
index 0000000000..a9b2ab45de
--- /dev/null
+++ b/tests/tcg/aarch64_be/hello.c
@@ -0,0 +1,35 @@
+/*
+ * Non-libc syscall hello world for Aarch64 BE
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#define __NR_write 64
+#define __NR_exit 93
+
+int write(int fd, char *buf, int len)
+{
+    register int x0 __asm__("x0") = fd;
+    register char *x1 __asm__("x1") = buf;
+    register int x2 __asm__("x2") = len;
+    register int x8 __asm__("x8") = __NR_write;
+
+    asm volatile("svc #0" : : "r"(x0), "r"(x1), "r"(x2), "r"(x8));
+
+    return len;
+}
+
+void exit(int ret)
+{
+    register int x0 __asm__("x0") = ret;
+    register int x8 __asm__("x8") = __NR_exit;
+
+    asm volatile("svc #0" : : "r"(x0), "r"(x8));
+    __builtin_unreachable();
+}
+
+void _start(void)
+{
+    write(1, "Hello World\n", 12);
+    exit(0);
+}
diff --git a/tests/tcg/Makefile.target b/tests/tcg/Makefile.target
index 2da70b2fcf..9722145b97 100644
--- a/tests/tcg/Makefile.target
+++ b/tests/tcg/Makefile.target
@@ -103,9 +103,14 @@ ifeq ($(filter %-softmmu, $(TARGET)),)
 # then the target. If there are common tests shared between
 # sub-targets (e.g. ARM & AArch64) then it is up to
 # $(TARGET_NAME)/Makefile.target to include the common parent
-# architecture in its VPATH.
+# architecture in its VPATH. However some targets are so minimal we
+# can't even build the multiarch tests.
+ifneq ($(filter $(TARGET_NAME),aarch64_be),)
+-include $(SRC_PATH)/tests/tcg/$(TARGET_NAME)/Makefile.target
+else
 -include $(SRC_PATH)/tests/tcg/multiarch/Makefile.target
 -include $(SRC_PATH)/tests/tcg/$(TARGET_NAME)/Makefile.target
+endif
 
 # Add the common build options
 CFLAGS+=-Wall -Werror -O0 -g -fno-strict-aliasing
diff --git a/tests/tcg/aarch64_be/Makefile.target b/tests/tcg/aarch64_be/Makefile.target
new file mode 100644
index 0000000000..297d2cf71c
--- /dev/null
+++ b/tests/tcg/aarch64_be/Makefile.target
@@ -0,0 +1,17 @@
+# -*- Mode: makefile -*-
+#
+# A super basic AArch64 BE makefile. As we don't have any big-endian
+#l ibc available the best we can do is a basic Hello World.
+
+AARCH64BE_SRC=$(SRC_PATH)/tests/tcg/aarch64_be
+VPATH += $(AARCH64BE_SRC)
+
+AARCH64BE_TEST_SRCS=$(notdir $(wildcard $(AARCH64BE_SRC)/*.c))
+AARCH64BE_TESTS=$(AARCH64BE_TEST_SRCS:.c=)
+#MULTIARCH_TESTS = $(MULTIARCH_SRCS:.c=)
+
+# We need to specify big-endian cflags
+CFLAGS +=-mbig-endian -ffreestanding
+LDFLAGS +=-nostdlib
+
+TESTS += $(AARCH64BE_TESTS)
-- 
2.39.5


