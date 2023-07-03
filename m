Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1774626D
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 20:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjGCScq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 14:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjGCScl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 14:32:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCB310D0
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 11:32:35 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fbdfda88f4so908625e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 11:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688409154; x=1691001154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2jBqwLYTVPATDHfEQY0x1Pdqr8EcmmmZ1uz1yNnpOk=;
        b=KRVWgYdroOLbfrpPlUEnPovRCeX/FnRYQy/HWjU85fZZnVwhhgrGD93/umv5cknqf5
         Vi6uJtFniwaPdV4SZpUzJNODrc0jLtp5TwHh6BKgwuT2nhCS/5bwjL4SC1LS0R0DMz2R
         BfTmeccdQtFqSNKl4SfGzURhSiMkf88h6lKDAe6Od1DlEnn0CT41RO5hJv5dg4cAAukO
         2kbrS8ToE+/vO5HvUwTMyWW6p0wZpr9L0e3Dvy59+il/cDt6ECVzUyeKTPPYzUGfsBlm
         z5GRBEA6+nyojYOJ9MDdnqOnFzqDl1moJrBnscfaulNWsBGzG/s3g1f09a1zRHGgyxui
         BF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688409154; x=1691001154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2jBqwLYTVPATDHfEQY0x1Pdqr8EcmmmZ1uz1yNnpOk=;
        b=RCYS0DgeijYCay9SGMqUE1EE3mFO6F6vhJsKqbjmeHxuIMOjiyCvj6FU61mYiDMvJT
         hIRJR6NPcMI7kqC4jMQ/NWh/nYl1GCwe5qo0BImvTAQ7LwAWUA6mtI2y+VdFS7kdiM8C
         pZRZXi64HOhn36XKpIkNoytz+KhpRHOumPOdDLPihuSQIZwVLZNa1e7CrSTD0PPiYMCr
         toFI/FoAtN9UWXpg4VY7LdIP5vao2S6PyV99/ylKfsSZ+iL7j/V5cs6UE9BZW016oooy
         l1dCb/Pa8jPS6BWeC0dYjFRz+L6uSLX/jPvzFeuZeUfy2hMsoBIwNgLWgCO50ulqaSlG
         QW9A==
X-Gm-Message-State: AC+VfDz5K2zNsEXQEAP2x+JmtKrjDDKLut7jzt7U1UtgUl/l6JSqfCQM
        lHh7gPsVGzvRDoxHRKguAcux5w==
X-Google-Smtp-Source: ACHHUZ5zsZoIjEv2zUIgeh7IU0oTrQdTcvHZIhRm+EzuqA+11ODSRm/jzYdF4Mvd9Kiyhesq/x7DQw==
X-Received: by 2002:a7b:ce16:0:b0:3fb:b1bf:7df3 with SMTP id m22-20020a7bce16000000b003fbb1bf7df3mr8758013wmc.16.1688409154345;
        Mon, 03 Jul 2023 11:32:34 -0700 (PDT)
Received: from localhost.localdomain ([176.176.178.91])
        by smtp.gmail.com with ESMTPSA id v4-20020a05600c214400b003fa95890484sm23095216wml.20.2023.07.03.11.32.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Jul 2023 11:32:34 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        kvm@vger.kernel.org, qemu-riscv@nongnu.org,
        Bin Meng <bin.meng@windriver.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
Subject: [PATCH v2 07/16] target/riscv: Move TCG-specific files to target/riscv/tcg/
Date:   Mon,  3 Jul 2023 20:31:36 +0200
Message-Id: <20230703183145.24779-8-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230703183145.24779-1-philmd@linaro.org>
References: <20230703183145.24779-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move TCG-specific files to the a new 'tcg' sub-directory. Add
stubs for riscv_cpu_[get/set]_fflags and riscv_raise_exception().
Adapt meson rules.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/riscv/{ => tcg}/XVentanaCondOps.decode |  0
 target/riscv/{ => tcg}/insn16.decode          |  0
 target/riscv/{ => tcg}/insn32.decode          |  0
 target/riscv/{ => tcg}/xthead.decode          |  0
 target/riscv/{ => tcg}/bitmanip_helper.c      |  0
 target/riscv/{ => tcg}/crypto_helper.c        |  0
 target/riscv/{ => tcg}/fpu_helper.c           |  0
 target/riscv/{ => tcg}/m128_helper.c          |  0
 target/riscv/{ => tcg}/op_helper.c            |  0
 target/riscv/tcg/tcg-stub.c                   | 25 +++++++++++++++++++
 target/riscv/{ => tcg}/translate.c            |  0
 target/riscv/{ => tcg}/vector_helper.c        |  0
 target/riscv/{ => tcg}/zce_helper.c           |  0
 target/riscv/meson.build                      | 18 +------------
 target/riscv/tcg/meson.build                  | 19 ++++++++++++++
 15 files changed, 45 insertions(+), 17 deletions(-)
 rename target/riscv/{ => tcg}/XVentanaCondOps.decode (100%)
 rename target/riscv/{ => tcg}/insn16.decode (100%)
 rename target/riscv/{ => tcg}/insn32.decode (100%)
 rename target/riscv/{ => tcg}/xthead.decode (100%)
 rename target/riscv/{ => tcg}/bitmanip_helper.c (100%)
 rename target/riscv/{ => tcg}/crypto_helper.c (100%)
 rename target/riscv/{ => tcg}/fpu_helper.c (100%)
 rename target/riscv/{ => tcg}/m128_helper.c (100%)
 rename target/riscv/{ => tcg}/op_helper.c (100%)
 create mode 100644 target/riscv/tcg/tcg-stub.c
 rename target/riscv/{ => tcg}/translate.c (100%)
 rename target/riscv/{ => tcg}/vector_helper.c (100%)
 rename target/riscv/{ => tcg}/zce_helper.c (100%)
 create mode 100644 target/riscv/tcg/meson.build

diff --git a/target/riscv/XVentanaCondOps.decode b/target/riscv/tcg/XVentanaCondOps.decode
similarity index 100%
rename from target/riscv/XVentanaCondOps.decode
rename to target/riscv/tcg/XVentanaCondOps.decode
diff --git a/target/riscv/insn16.decode b/target/riscv/tcg/insn16.decode
similarity index 100%
rename from target/riscv/insn16.decode
rename to target/riscv/tcg/insn16.decode
diff --git a/target/riscv/insn32.decode b/target/riscv/tcg/insn32.decode
similarity index 100%
rename from target/riscv/insn32.decode
rename to target/riscv/tcg/insn32.decode
diff --git a/target/riscv/xthead.decode b/target/riscv/tcg/xthead.decode
similarity index 100%
rename from target/riscv/xthead.decode
rename to target/riscv/tcg/xthead.decode
diff --git a/target/riscv/bitmanip_helper.c b/target/riscv/tcg/bitmanip_helper.c
similarity index 100%
rename from target/riscv/bitmanip_helper.c
rename to target/riscv/tcg/bitmanip_helper.c
diff --git a/target/riscv/crypto_helper.c b/target/riscv/tcg/crypto_helper.c
similarity index 100%
rename from target/riscv/crypto_helper.c
rename to target/riscv/tcg/crypto_helper.c
diff --git a/target/riscv/fpu_helper.c b/target/riscv/tcg/fpu_helper.c
similarity index 100%
rename from target/riscv/fpu_helper.c
rename to target/riscv/tcg/fpu_helper.c
diff --git a/target/riscv/m128_helper.c b/target/riscv/tcg/m128_helper.c
similarity index 100%
rename from target/riscv/m128_helper.c
rename to target/riscv/tcg/m128_helper.c
diff --git a/target/riscv/op_helper.c b/target/riscv/tcg/op_helper.c
similarity index 100%
rename from target/riscv/op_helper.c
rename to target/riscv/tcg/op_helper.c
diff --git a/target/riscv/tcg/tcg-stub.c b/target/riscv/tcg/tcg-stub.c
new file mode 100644
index 0000000000..dfe42ae2ac
--- /dev/null
+++ b/target/riscv/tcg/tcg-stub.c
@@ -0,0 +1,25 @@
+/*
+ * QEMU RISC-V TCG stubs
+ *
+ * Copyright (c) 2023 Linaro
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+
+target_ulong riscv_cpu_get_fflags(CPURISCVState *env)
+{
+    g_assert_not_reached();
+}
+
+void riscv_cpu_set_fflags(CPURISCVState *env, target_ulong)
+{
+    g_assert_not_reached();
+}
+
+G_NORETURN void riscv_raise_exception(CPURISCVState *env,
+                                      uint32_t exception, uintptr_t pc)
+{
+    g_assert_not_reached();
+}
diff --git a/target/riscv/translate.c b/target/riscv/tcg/translate.c
similarity index 100%
rename from target/riscv/translate.c
rename to target/riscv/tcg/translate.c
diff --git a/target/riscv/vector_helper.c b/target/riscv/tcg/vector_helper.c
similarity index 100%
rename from target/riscv/vector_helper.c
rename to target/riscv/tcg/vector_helper.c
diff --git a/target/riscv/zce_helper.c b/target/riscv/tcg/zce_helper.c
similarity index 100%
rename from target/riscv/zce_helper.c
rename to target/riscv/tcg/zce_helper.c
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index 8967dfaded..8ef47f43f9 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -1,34 +1,18 @@
-# FIXME extra_args should accept files()
-gen = [
-  decodetree.process('insn16.decode', extra_args: ['--static-decode=decode_insn16', '--insnwidth=16']),
-  decodetree.process('insn32.decode', extra_args: '--static-decode=decode_insn32'),
-  decodetree.process('xthead.decode', extra_args: '--static-decode=decode_xthead'),
-  decodetree.process('XVentanaCondOps.decode', extra_args: '--static-decode=decode_XVentanaCodeOps'),
-]
-
 riscv_ss = ss.source_set()
 riscv_system_ss = ss.source_set()
 
-riscv_ss.add(gen)
 riscv_ss.add(files(
   'cpu.c',
   'cpu_helper.c',
   'csr.c',
-  'fpu_helper.c',
   'gdbstub.c',
-  'op_helper.c',
-  'vector_helper.c',
-  'bitmanip_helper.c',
-  'translate.c',
-  'm128_helper.c',
-  'crypto_helper.c',
-  'zce_helper.c'
 ))
 
 riscv_system_ss.add(files(
   'debug.c',
 ))
 
+subdir('tcg')
 subdir('sysemu')
 
 target_arch += {'riscv': riscv_ss}
diff --git a/target/riscv/tcg/meson.build b/target/riscv/tcg/meson.build
new file mode 100644
index 0000000000..65670493b1
--- /dev/null
+++ b/target/riscv/tcg/meson.build
@@ -0,0 +1,19 @@
+# FIXME extra_args should accept files()
+gen = [
+  decodetree.process('insn16.decode', extra_args: ['--static-decode=decode_insn16', '--insnwidth=16']),
+  decodetree.process('insn32.decode', extra_args: '--static-decode=decode_insn32'),
+  decodetree.process('xthead.decode', extra_args: '--static-decode=decode_xthead'),
+  decodetree.process('XVentanaCondOps.decode', extra_args: '--static-decode=decode_XVentanaCodeOps'),
+]
+riscv_ss.add(when: 'CONFIG_TCG', if_true: gen)
+
+riscv_ss.add(when: 'CONFIG_TCG', if_true: files(
+  'fpu_helper.c',
+  'op_helper.c',
+  'vector_helper.c',
+  'bitmanip_helper.c',
+  'translate.c',
+  'm128_helper.c',
+  'crypto_helper.c',
+  'zce_helper.c',
+), if_false: files('tcg-stub.c'))
-- 
2.38.1

