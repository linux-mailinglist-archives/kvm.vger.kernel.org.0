Return-Path: <kvm+bounces-27478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FCD98655F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8601B22784
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6698854656;
	Wed, 25 Sep 2024 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dTzgVNuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE312B176
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284311; cv=none; b=OGIuZUpugPbq9uElFkWwa3zbcYMbmPMGhV4tuX6QiKbdXJyVfKgx4iGl0hQU7L+8pLbcKLG5y/m5VzXdulo8qEonptuj59iJ13LlIQpt0p9o+b+mLQ4Z6b7KDRTtbmDtCksUQjg8ziVQgINM5UngKW25YRChCOMFUBh3ydgen4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284311; c=relaxed/simple;
	bh=Z4cZsFtosR7h9PTMPmcmZ3THu8mm76XIlX05rHkyhaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DK1VeQHSolNTdzOvuU69StGG7iGXqh8STWbhCFf5P8W4xkP7g9kn9HABFPt/TlU8shdcxJuwfK5o/nyosm2CcN82+lkJOkmPBcCikfHYpcpPqWGzbsG2HWXvUEBGfCj1vXT765451+/bWK9AT0a020uoykRqrulR7+vSwXr6GTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dTzgVNuA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42ca6ba750eso884125e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284308; x=1727889108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KaJivYDlItR4YIDqMIuLxegmAwwZvWWIxpxaaVqdrBQ=;
        b=dTzgVNuAXBEEflLNiebDkbMkgH5WinXm8i9zbRlHofzMUgFFXRKvgNSlZz1AbmQIql
         poxdYMVzo+1v6CtAQ4NxxKCg6r9SlxcEO7Bm2Cx/hfYZb+3G95dMPUTi2FKwNTBJUBjh
         OZsvgLPK7nufiP29edgtBD8Wvz4bW0eb6YNy728U3gJvOYe6SQ2YLMQJ2hYerMdCQdWd
         /t2xS6F5/5Fi1915Co6YSv+qsPiy5TFgmWWDwHhGVN3EsU5Nsc5CUDfMS27eI4V8VpYG
         eZXTDWDFlxX7ulveAVfWNhbaH3jO/bax4yn3fv8xXazXd9OfHyuERZen2fGzf2hMlp1V
         h9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284308; x=1727889108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KaJivYDlItR4YIDqMIuLxegmAwwZvWWIxpxaaVqdrBQ=;
        b=Ka7gKwOnf1ilkqDoYZYou32mp/qLhtWfjEXX/P9ERap5ZE6yRW72p6drSX8ikEvR+V
         HvOToSwqpySTUOEyDdqi9NzeSVWptm0rXOLi8SnSyf9f08b5B2TLDMYi1iuWZdE5mIZO
         mQTgIAdEbX9tjMhI6foIzCuqubmprRPL0nJZufHaHG9cuQ2BGJ+NKZuLmt1vqV4jUd+o
         umrTqdZH049735CVP2nM/sQ0YOwqs6ODPb64KSPvLJY9J+ZdbneXjr7gsYLP/sgwXD5/
         ZYgtHOyHxt4wmztnGQ+N1xrUBtoAaNqXj3RfcvCZWiAu234mYB0CE4QCXGjftF3cJJ9p
         WHKA==
X-Forwarded-Encrypted: i=1; AJvYcCWynyuM4Sp8T0aObbx+ccCCCq7urmE6ug2VroraxbVexfW3+wCDyMKmEFwOZW/2yVrLuDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YztO8dA1iluRHCOzSfCrHtYy4+OhBS1LYE4uy025ARYRGeHIDvC
	X55jWJe+CRaEj1H365+AEMjujS5HQ1ERWzpczG/Aw8+de+FzukJIq+RR7gS3ra0=
X-Google-Smtp-Source: AGHT+IGEUdwdXmmXxyj5s5u8wIU8mWo+iyIURbnXAseiU9n2QlRwwUQiN93/e4JQ8cQ12tQq4BVfKQ==
X-Received: by 2002:a05:600c:3542:b0:424:895c:b84b with SMTP id 5b1f17b1804b1-42f521cb7b9mr2431035e9.4.1727284308140;
        Wed, 25 Sep 2024 10:11:48 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e969f1fe4sm24113855e9.14.2024.09.25.10.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4FA755FAAF;
	Wed, 25 Sep 2024 18:11:41 +0100 (BST)
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
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH 10/10] tests/tcg: enable basic testing for aarch64_be-linux-user
Date: Wed, 25 Sep 2024 18:11:40 +0100
Message-Id: <20240925171140.1307033-11-alex.bennee@linaro.org>
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

We didn't notice breakage of aarch64_be because we don't have any TCG
tests for it. However while the existing aarch64 compiler can target
big-endian builds no one packages a BE libc. Instead we bang some
rocks together to do the most basic of hello world with a nostdlib
syscall test.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 configure                            |  5 ++++
 tests/tcg/aarch64_be/hello.c         | 35 ++++++++++++++++++++++++++++
 tests/tcg/Makefile.target            |  7 +++++-
 tests/tcg/aarch64_be/Makefile.target | 17 ++++++++++++++
 4 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 tests/tcg/aarch64_be/hello.c
 create mode 100644 tests/tcg/aarch64_be/Makefile.target

diff --git a/configure b/configure
index aa7aae70fa..1aebf8ece0 100755
--- a/configure
+++ b/configure
@@ -1274,6 +1274,7 @@ probe_target_compiler() {
   target_arch=${1%%-*}
   case $target_arch in
     aarch64) container_hosts="x86_64 aarch64" ;;
+    aarch64_be) container_hosts="x86_64 aarch64" ;;
     alpha) container_hosts=x86_64 ;;
     arm) container_hosts="x86_64 aarch64" ;;
     hexagon) container_hosts=x86_64 ;;
@@ -1303,6 +1304,10 @@ probe_target_compiler() {
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
index 0000000000..93c6074db1
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
+int write(int fd, char * buf, int len)
+{
+    register int x0 __asm__("x0") = fd;
+    register char * x1 __asm__("x1") = buf;
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


