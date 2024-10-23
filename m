Return-Path: <kvm+bounces-29493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 006979AC916
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA6F2838B6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2A51AB521;
	Wed, 23 Oct 2024 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="afi9JAQT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2F1B85C2
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683263; cv=none; b=ed5YBBUdNr0nnp3szt4r7gg7/qw3JTbom2N9+J1PLXooaBy/BwrL3/3+sn+5bf9TmIAmTr12jfKy0D8P/nM3gRg3jSreiXFXnO/nwEP2VrudJs2zHwSkfURY9K0Seo+eqR5xh1RlMmDNoSN/55G7Xg8elE7+1xp/1/1fg5ZJzoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683263; c=relaxed/simple;
	bh=AeUHNfvNpzJXFdGx7S9rrFlmswpeyN87DwibnAkZUfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7iur++mMfIGRoXtzvbJtl7vzSUeK2t/ER8JO/Az5LJq4ua2Si9TDlCt9bTNCNTZrOC8OygGASgIDnjuHk8ocsvD0SwdcJan9hqaTfSnCyxr1jYQ62LEt4o9gIHKdl/WNnKx8rTGyMj4GVCm65tnZafCz8TF968XuYlUsYlhms8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=afi9JAQT; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c40aea5c40so612783a12.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683260; x=1730288060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pLXAr/OU0jkbK3hvA7jKCluJF6NjbiqDXh6Q2a0Cto=;
        b=afi9JAQT6CkYTEJRqbjvFi7fcljeLkggUdtmlg40teBY7vTEi3+m6uyfbOjsk6dyc5
         xqRyeAm+qDMSdMVNJctVuNTGKya++EOak2WaduQvEGblouTKXcMy8hl4u56aDJJwWEJa
         OH11On3K1/bcsKVISjML4xshV2M9GuMGyiTLjJCLMc+btEJQOe3Ei3+eOEqAfftmGRj6
         kMUp+isQjxoWDgc1kj0i5w03/m/VJw03/ep4qPusSYa6xwzQe0GybO4iCt2ix+ZeoX8l
         1gWHQ/9yCBWz2jDs90HAc2RS2jlYifyMC+j5iOh5js7hBOdqavpqtGhRdyvT102+IgiJ
         4fhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683260; x=1730288060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7pLXAr/OU0jkbK3hvA7jKCluJF6NjbiqDXh6Q2a0Cto=;
        b=v7r93bBOLnJny58hepQSxVolhCp1/svFhOXAsSJgOgmfnQDciKX8Ob5NleVzryPOtz
         ulgx78cTHlAIpHGfl+QF3f8lj75SE/yfKYA+ePzDfXtbeFSFYVrpfnoCRuqiCjXOm63P
         q/VsE+d8rm6ZybTdW/5k/EGnJ1kAnM2D6vXAiP2GIaEz3VooRmwuNYjyaUETs0KiBnPG
         dfIPw2NDwc3FU0a8ylBZCLNXoX+IuoLQN3iBIDD4W0m+msg0Uc+i/OjlB6Aji2JUhxCR
         i1O8i5Z6MNkzfxzQ5+JA/HJOJEb8c0+pq608Yf6IUdq2aErVrKwQ0Qw8tHYL97Ed3wFC
         tWtg==
X-Forwarded-Encrypted: i=1; AJvYcCX1ZO2G8NBi7Pg9yFLyv+zGKH3p/FEiCQkfuiXpQPElR7RRqOGdmG++MDEy2t//od/QYgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhrO1i987dOq0PR07N4XFE13ZjCox0LmxNs5dDW228FgM9Gukx
	MYUIuyEyYqX0gIi24miIbBFoN7EFdjB569DhsnltP6efkH/quui74VGLBbeW6S0=
X-Google-Smtp-Source: AGHT+IHYuCpsrlKmDqqGYIBBNa+vFGcIlA5SXBodkYMC+HhiJM5pz5ipdH/LGWzv9nLWvjwuCPYAbQ==
X-Received: by 2002:a05:6402:42d2:b0:5c9:60a:5025 with SMTP id 4fb4d7f45d1cf-5cb8b53d00dmr2462019a12.9.1729683259827;
        Wed, 23 Oct 2024 04:34:19 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c6b18csm4250181a12.62.2024.10.23.04.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 397B25FABE;
	Wed, 23 Oct 2024 12:34:08 +0100 (BST)
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
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 13/18] tests/tcg: enable basic testing for aarch64_be-linux-user
Date: Wed, 23 Oct 2024 12:34:01 +0100
Message-Id: <20241023113406.1284676-14-alex.bennee@linaro.org>
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

We didn't notice breakage of aarch64_be because we don't have any TCG
tests for it. However while the existing aarch64 compiler can target
big-endian builds no one packages a BE libc. Instead we bang some
rocks together to do the most basic of hello world with a nostdlib
syscall test.

Message-Id: <20241022105614.839199-14-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - fix checkpatch complaints
v3
  - fix libc typo
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
index 0000000000..cbe5fa0b2d
--- /dev/null
+++ b/tests/tcg/aarch64_be/Makefile.target
@@ -0,0 +1,17 @@
+# -*- Mode: makefile -*-
+#
+# A super basic AArch64 BE makefile. As we don't have any big-endian
+# libc available the best we can do is a basic Hello World.
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


