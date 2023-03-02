Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991696A894A
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCBTOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCBTOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:24 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838721816E
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:22 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso39766wmo.0
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHqP0mS63nM1LMhj8fwJgrUBh7QK4PmkZnnhc4Xo7qc=;
        b=PDa/dcDpBdf7Yr/DlQC5v0nFm6bicQJa3gMfQr9zCWc/O2mMZdUA66hkUwZr3TWQQa
         ++eYUJCpL1OhQY7j9NaQyyIjvFQgS5xaZk3+XzPxaMLVXt2kz+M1aijI0+pSpWEAApQc
         PBY3jR0+j5DK2Q0QSMPeP0ymoF340mHvkakUHMIv05uJX1Hn6ruNPYEpErT73Xiqbrbx
         NqCf5JrB7+miCS8laKMpFsy3yGjibw+6EIbTKE+a6pLgU+0ZJKVQ3mTkDGnBOLkl5JzY
         anO0FFFqtKJXdfqfkiBkqGswtq3htwxR61fqNWsXLiZuRRz2zQsouFqvtHz/GrVhIJNT
         uhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHqP0mS63nM1LMhj8fwJgrUBh7QK4PmkZnnhc4Xo7qc=;
        b=TKD4aD9KW4nf+feZ6BHaGc4e3Fmg7grn7KUKZz6m+k7iAgLB/b7giMUROafMcS7D3m
         LL4YhKnvmeurc296jhh/3CAJKYyoPDvOWjH94LJMiRO+iK4S3CzDJ6fscafr5CSLjarK
         Z+zUyxCembpOjbHNWIc03tUW40gNTTTLSgOhE+8fCNfClVl/5T6XDXMK6kEHbkZfxY2p
         e+lUPnp1sOnOzjU7ASQLTO8GRSUp00Ecbhdxkklqp2cIRvGfaREHPcdUohUeUvwooect
         T7SNKsTDb954orTZ+Av0EdPba45gxvSTe5CuELrIJMSkwjJR1qD51Rrg+5ZmlmIBWFgg
         4Jxw==
X-Gm-Message-State: AO0yUKUZLfCiVijEvbIFJbbjA8YuQg9xwpIh3sPQmLdnWOPtZIfoICAd
        IF9kqPTOUnd8h03gWnIJSQMMTQ==
X-Google-Smtp-Source: AK7set8Ioc1FNmoloOZrAJ5xaY7xQfST/RYkOOsYeAnORIav+mBmvD9I+biCCDSCw4ATGgxCqKL+Og==
X-Received: by 2002:a05:600c:746:b0:3ea:e554:77fe with SMTP id j6-20020a05600c074600b003eae55477femr8390053wmn.12.1677784460910;
        Thu, 02 Mar 2023 11:14:20 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d670d000000b002c8476dde7asm120991wru.114.2023.03.02.11.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:20 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 3E8B91FFBE;
        Thu,  2 Mar 2023 19:08:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Weiwei Li <liweiwei@iscas.ac.cn>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Laurent Vivier <laurent@vivier.eu>,
        nicolas.eder@lauterbach.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        qemu-s390x@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Bin Meng <bin.meng@windriver.com>, Marek Vasut <marex@denx.de>,
        Greg Kurz <groug@kaod.org>, Song Gao <gaosong@loongson.cn>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Chris Wulff <crwulff@gmail.com>, qemu-riscv@nongnu.org,
        Michael Rolnik <mrolnik@gmail.com>, qemu-arm@nongnu.org,
        Cleber Rosa <crosa@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        mads@ynddal.dk, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 23/26] testing: probe gdb for supported architectures ahead of time
Date:   Thu,  2 Mar 2023 19:08:43 +0000
Message-Id: <20230302190846.2593720-24-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302190846.2593720-1-alex.bennee@linaro.org>
References: <20230302190846.2593720-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when we encounter a gdb that is old or not built with
multiarch in mind we fail rather messily. Try and improve the
situation by probing ahead of time and setting
HOST_GDB_SUPPORTS_ARCH=y in the relevant tcg configs. We can then skip
and give a more meaningful message if we don't run the test.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>

---
v4
  - convert script to python, use mapping to set arches
  - update MAINTAINERS
---
 MAINTAINERS                                   |  1 +
 configure                                     |  8 ++
 scripts/probe-gdb-support.py                  | 88 +++++++++++++++++++
 tests/tcg/aarch64/Makefile.target             |  2 +-
 tests/tcg/multiarch/Makefile.target           |  5 ++
 .../multiarch/system/Makefile.softmmu-target  |  6 +-
 tests/tcg/s390x/Makefile.target               |  2 +-
 7 files changed, 109 insertions(+), 3 deletions(-)
 create mode 100755 scripts/probe-gdb-support.py

diff --git a/MAINTAINERS b/MAINTAINERS
index c7a8e2307f..8d0113b8f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2739,6 +2739,7 @@ F: include/gdbstub/*
 F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/
 F: scripts/feature_to_c.sh
+F: scripts/probe-gdb-support.py
 
 Memory API
 M: Paolo Bonzini <pbonzini@redhat.com>
diff --git a/configure b/configure
index 50a0b80b27..f0cd3923f3 100755
--- a/configure
+++ b/configure
@@ -230,6 +230,7 @@ stack_protector=""
 safe_stack=""
 use_containers="yes"
 gdb_bin=$(command -v "gdb-multiarch" || command -v "gdb")
+gdb_arches=""
 
 if test -e "$source_path/.git"
 then
@@ -2392,6 +2393,7 @@ if test -n "$gdb_bin"; then
     gdb_version=$($gdb_bin --version | head -n 1)
     if version_ge ${gdb_version##* } 9.1; then
         echo "HAVE_GDB_BIN=$gdb_bin" >> $config_host_mak
+        gdb_arches=$("$source_path/scripts/probe-gdb-support.py" $gdb_bin)
     else
         gdb_bin=""
     fi
@@ -2516,6 +2518,12 @@ for target in $target_list; do
       write_target_makefile "build-tcg-tests-$target" >> "$config_target_mak"
       echo "BUILD_STATIC=$build_static" >> "$config_target_mak"
       echo "QEMU=$PWD/$qemu" >> "$config_target_mak"
+
+      # will GDB work with these binaries?
+      if test "${gdb_arches#*$arch}" != "$gdb_arches"; then
+          echo "HOST_GDB_SUPPORTS_ARCH=y" >> "$config_target_mak"
+      fi
+
       echo "run-tcg-tests-$target: $qemu\$(EXESUF)" >> Makefile.prereqs
       tcg_tests_targets="$tcg_tests_targets $target"
   fi
diff --git a/scripts/probe-gdb-support.py b/scripts/probe-gdb-support.py
new file mode 100755
index 0000000000..c786b7620e
--- /dev/null
+++ b/scripts/probe-gdb-support.py
@@ -0,0 +1,88 @@
+#!/usr/bin/env python3
+# coding: utf-8
+#
+# Probe gdb for supported architectures.
+#
+# This is required to support testing of the gdbstub as its hard to
+# handle errors gracefully during the test. Instead this script when
+# passed a GDB binary will probe its architecture support and return a
+# string of supported arches, stripped of guff.
+#
+# Copyright 2023 Linaro Ltd
+#
+# Author: Alex Bennée <alex.bennee@linaro.org>
+#
+# This work is licensed under the terms of the GNU GPL, version 2 or later.
+# See the COPYING file in the top-level directory.
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+import argparse
+import re
+from subprocess import check_output, STDOUT
+
+# mappings from gdb arch to QEMU target
+mappings = {
+    "alpha" : "alpha",
+    "aarch64" : ["aarch64", "aarch64_be"],
+    "armv7": "arm",
+    "armv8-a" : ["aarch64", "aarch64_be"],
+    "avr" : "avr",
+    "cris" : "cris",
+    # hexagon?
+    "hppa1.0" : "hppa",
+    "i386" : "i386",
+    "i386:x86-64" : "x86_64",
+    # loongarch?
+    "m68k" : "m68k",
+    "MicroBlaze" : "microblaze",
+    "mips:isa64" : ["mips64", "mips64el"],
+    "nios2" : "nios2",
+    "or1k" : "or1k",
+    "powerpc:common" : "ppc",
+    "powerpc:common64" : "ppc64",
+    "riscv:rv32" : "riscv32",
+    "riscv:rv64" : "riscv64",
+    "s390:64-bit" : "s390x",
+    "sh4" : ["sh4", "sh4eb"],
+    "sparc": "sparc",
+    "sparc:v8plus": "sparc32plus",
+    "sparc:v9a" : "sparc64",
+    # no tricore in upstream gdb
+    "xtensa" : ["xtensa", "xtensaeb"]
+}
+
+def do_probe(gdb):
+    gdb_out = check_output([gdb,
+                            "-ex", "set architecture",
+                            "-ex", "quit"], stderr=STDOUT)
+
+    m = re.search(r"Valid arguments are (.*)",
+                  gdb_out.decode("utf-8"))
+
+    valid_arches = set()
+
+    if m.group(1):
+        for arch in m.group(1).split(", "):
+            if arch in mappings:
+                mapping = mappings[arch]
+                if isinstance(mapping, str):
+                    valid_arches.add(mapping)
+                else:
+                    for entry in mapping:
+                        valid_arches.add(entry)
+
+    return valid_arches
+
+def main() -> None:
+    parser = argparse.ArgumentParser(description='Probe GDB Architectures')
+    parser.add_argument('gdb', help='Path to GDB binary.')
+
+    args = parser.parse_args()
+
+    supported = do_probe(args.gdb)
+
+    print(" ".join(supported))
+
+if __name__ == '__main__':
+    main()
diff --git a/tests/tcg/aarch64/Makefile.target b/tests/tcg/aarch64/Makefile.target
index db122ab4ff..9e91a20b0d 100644
--- a/tests/tcg/aarch64/Makefile.target
+++ b/tests/tcg/aarch64/Makefile.target
@@ -81,7 +81,7 @@ sha512-vector: sha512.c
 
 TESTS += sha512-vector
 
-ifneq ($(HAVE_GDB_BIN),)
+ifeq ($(HOST_GDB_SUPPORTS_ARCH),y)
 GDB_SCRIPT=$(SRC_PATH)/tests/guest-debug/run-test.py
 
 run-gdbstub-sysregs: sysregs
diff --git a/tests/tcg/multiarch/Makefile.target b/tests/tcg/multiarch/Makefile.target
index ae8b3d7268..373db69648 100644
--- a/tests/tcg/multiarch/Makefile.target
+++ b/tests/tcg/multiarch/Makefile.target
@@ -64,6 +64,7 @@ run-test-mmap-%: test-mmap
 	$(call run-test, test-mmap-$*, $(QEMU) -p $* $<, $< ($* byte pages))
 
 ifneq ($(HAVE_GDB_BIN),)
+ifeq ($(HOST_GDB_SUPPORTS_ARCH),y)
 GDB_SCRIPT=$(SRC_PATH)/tests/guest-debug/run-test.py
 
 run-gdbstub-sha1: sha1
@@ -87,6 +88,10 @@ run-gdbstub-thread-breakpoint: testthread
 		--bin $< --test $(MULTIARCH_SRC)/gdbstub/test-thread-breakpoint.py, \
 	hitting a breakpoint on non-main thread)
 
+else
+run-gdbstub-%:
+	$(call skip-test, "gdbstub test $*", "no guest arch support")
+endif
 else
 run-gdbstub-%:
 	$(call skip-test, "gdbstub test $*", "need working gdb")
diff --git a/tests/tcg/multiarch/system/Makefile.softmmu-target b/tests/tcg/multiarch/system/Makefile.softmmu-target
index 368b64d531..5f432c95f3 100644
--- a/tests/tcg/multiarch/system/Makefile.softmmu-target
+++ b/tests/tcg/multiarch/system/Makefile.softmmu-target
@@ -15,6 +15,7 @@ MULTIARCH_TEST_SRCS=$(wildcard $(MULTIARCH_SYSTEM_SRC)/*.c)
 MULTIARCH_TESTS = $(patsubst $(MULTIARCH_SYSTEM_SRC)/%.c, %, $(MULTIARCH_TEST_SRCS))
 
 ifneq ($(HAVE_GDB_BIN),)
+ifeq ($(HOST_GDB_SUPPORTS_ARCH),y)
 GDB_SCRIPT=$(SRC_PATH)/tests/guest-debug/run-test.py
 
 run-gdbstub-memory: memory
@@ -26,7 +27,10 @@ run-gdbstub-memory: memory
 		"-monitor none -display none -chardev file$(COMMA)path=$<.out$(COMMA)id=output $(QEMU_OPTS)" \
 		--bin $< --test $(MULTIARCH_SRC)/gdbstub/memory.py, \
 	softmmu gdbstub support)
-
+else
+run-gdbstub-%:
+	$(call skip-test, "gdbstub test $*", "no guest arch support")
+endif
 else
 run-gdbstub-%:
 	$(call skip-test, "gdbstub test $*", "need working gdb")
diff --git a/tests/tcg/s390x/Makefile.target b/tests/tcg/s390x/Makefile.target
index 72ad309b27..b7f576f983 100644
--- a/tests/tcg/s390x/Makefile.target
+++ b/tests/tcg/s390x/Makefile.target
@@ -51,7 +51,7 @@ $(Z15_TESTS): CFLAGS+=-march=z15 -O2
 TESTS+=$(Z15_TESTS)
 endif
 
-ifneq ($(HAVE_GDB_BIN),)
+ifeq ($(HOST_GDB_SUPPORTS_ARCH),y)
 GDB_SCRIPT=$(SRC_PATH)/tests/guest-debug/run-test.py
 
 run-gdbstub-signals-s390x: signals-s390x
-- 
2.39.2

