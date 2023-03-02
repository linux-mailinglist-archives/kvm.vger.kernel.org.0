Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC296A8952
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCBTOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCBTO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:14:28 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C811714A
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 11:14:24 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h11so151261wrm.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4KhUA1XFJwwWEmsegyMuDUvMlSPYSVpzli4rf0vM6k=;
        b=LAOeKs2/Vj0fzaUFKWAkUHCUjXyuF6vteIzflhN1WmDJFGxdkVi1KdAHXqBBxrsGkf
         0Xf9JhF2LjzywpBPJVHZliMSrNjz0SNkNEtQIGZgjKh97Iyy5qc4RKJMcLpjx983xj1J
         ctG5lCLdmTASkJqbk4Y67uAsUwNbSGJeM5OGaqwVvyxFrmEzpzFMrzXJ4N5f7RArColm
         BFDh+tvygPdQCa4XgcsBiJUHo293XJONiSRHay0Gf8dEMvT+ZlctLKoGBLEd7TNNLGdd
         eXW6MBd55JIXn3AiyOVzRMdJqlGk8Uv6mF+CrFs1nRDTjc1GCO1iBDbKO8rLATHui1K7
         wEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4KhUA1XFJwwWEmsegyMuDUvMlSPYSVpzli4rf0vM6k=;
        b=LTqI3K/ia8/ZeCty6G5+JPUsx6V0+061jzfahnf6hLWS+Cbtvik4FjbzJThZv0nPjA
         wsSlHBB2acEELWR5kZgmIDYGk6z0+/5dEK0OLYoQ1J/udoR33aMZYB5X1noioOvnkv8d
         1HjNo4ySuTaC+APGVoQphLR3bJubyKErteG1bMjuF7R3YmcZ+PNVJTSlPe0wep9egwgp
         yVMOauhAEYHAv48o6IvhsrYnPh5Hmz2Xx+oF7k/4H8XmCLZYf99mYhxWV+mIXin8lF1a
         sXMH8kHpH4bGHVs4Ad7HhsF3WFVFmz5Fw98wCNAbfvxWTMHzjv3xmmH7ZS8w1Pdr9Duu
         YBmA==
X-Gm-Message-State: AO0yUKUXznKoMchL2enBRYvg07Q1THKwM7Eg2QwCXDOE8I8XWK4wTqO9
        NeRw455fh5VdEK5Hs8hYOIGKBA==
X-Google-Smtp-Source: AK7set+J7hPaeoVDz7pGoK2llCnE51OyeYKqtKAtDXjN9DSi5cTIjdmt/QOchoAhalDWwasrPlU24g==
X-Received: by 2002:a5d:6545:0:b0:2c7:cc8:782c with SMTP id z5-20020a5d6545000000b002c70cc8782cmr2351610wrv.1.1677784463241;
        Thu, 02 Mar 2023 11:14:23 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o1-20020a5d4081000000b002c71a32394dsm143563wrp.64.2023.03.02.11.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 11:14:21 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id ACDB71FFC8;
        Thu,  2 Mar 2023 19:08:49 +0000 (GMT)
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
Subject: [PATCH v4 20/26] gdbstub: move register helpers into standalone include
Date:   Thu,  2 Mar 2023 19:08:40 +0000
Message-Id: <20230302190846.2593720-21-alex.bennee@linaro.org>
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

These inline helpers are all used by target specific code so move them
out of the general header so we don't needlessly pollute the rest of
the API with target specific stuff.

Note we have to include cpu.h in semihosting as it was relying on a
side effect before.

Reviewed-by: Taylor Simpson <tsimpson@quicinc.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - update xtensa's import-core script as well
v4
  - checkpatch cleanups
---
 include/exec/gdbstub.h                 |  86 ---------------------
 include/gdbstub/helpers.h              | 103 +++++++++++++++++++++++++
 semihosting/syscalls.c                 |   1 +
 target/alpha/gdbstub.c                 |   2 +-
 target/arm/gdbstub.c                   |   1 +
 target/arm/gdbstub64.c                 |   2 +-
 target/arm/tcg/helper-a64.c            |   2 +-
 target/arm/tcg/m_helper.c              |   1 +
 target/avr/gdbstub.c                   |   2 +-
 target/cris/gdbstub.c                  |   2 +-
 target/hexagon/gdbstub.c               |   2 +-
 target/hppa/gdbstub.c                  |   2 +-
 target/i386/gdbstub.c                  |   2 +-
 target/i386/whpx/whpx-all.c            |   2 +-
 target/loongarch/gdbstub.c             |   1 +
 target/m68k/gdbstub.c                  |   2 +-
 target/m68k/helper.c                   |   1 +
 target/m68k/m68k-semi.c                |   1 +
 target/microblaze/gdbstub.c            |   2 +-
 target/mips/gdbstub.c                  |   2 +-
 target/mips/tcg/sysemu/mips-semi.c     |   1 +
 target/nios2/cpu.c                     |   2 +-
 target/nios2/nios2-semi.c              |   1 +
 target/openrisc/gdbstub.c              |   2 +-
 target/openrisc/interrupt.c            |   2 +-
 target/openrisc/mmu.c                  |   2 +-
 target/ppc/cpu_init.c                  |   2 +-
 target/ppc/gdbstub.c                   |   1 +
 target/riscv/gdbstub.c                 |   1 +
 target/rx/gdbstub.c                    |   2 +-
 target/s390x/gdbstub.c                 |   1 +
 target/s390x/helper.c                  |   2 +-
 target/sh4/gdbstub.c                   |   2 +-
 target/sparc/gdbstub.c                 |   2 +-
 target/tricore/gdbstub.c               |   2 +-
 target/xtensa/core-dc232b.c            |   2 +-
 target/xtensa/core-dc233c.c            |   2 +-
 target/xtensa/core-de212.c             |   2 +-
 target/xtensa/core-de233_fpu.c         |   2 +-
 target/xtensa/core-dsp3400.c           |   2 +-
 target/xtensa/core-fsf.c               |   2 +-
 target/xtensa/core-lx106.c             |   2 +-
 target/xtensa/core-sample_controller.c |   2 +-
 target/xtensa/core-test_kc705_be.c     |   2 +-
 target/xtensa/core-test_mmuhifi_c3.c   |   2 +-
 target/xtensa/gdbstub.c                |   2 +-
 target/xtensa/helper.c                 |   2 +-
 target/xtensa/import_core.sh           |   2 +-
 48 files changed, 149 insertions(+), 121 deletions(-)
 create mode 100644 include/gdbstub/helpers.h

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index 8fff5450ed..bb8a3928dd 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -110,92 +110,6 @@ void gdb_register_coprocessor(CPUState *cpu,
                               gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
                               int num_regs, const char *xml, int g_pos);
 
-#ifdef NEED_CPU_H
-#include "cpu.h"
-
-/*
- * The GDB remote protocol transfers values in target byte order. As
- * the gdbstub may be batching up several register values we always
- * append to the array.
- */
-
-static inline int gdb_get_reg8(GByteArray *buf, uint8_t val)
-{
-    g_byte_array_append(buf, &val, 1);
-    return 1;
-}
-
-static inline int gdb_get_reg16(GByteArray *buf, uint16_t val)
-{
-    uint16_t to_word = tswap16(val);
-    g_byte_array_append(buf, (uint8_t *) &to_word, 2);
-    return 2;
-}
-
-static inline int gdb_get_reg32(GByteArray *buf, uint32_t val)
-{
-    uint32_t to_long = tswap32(val);
-    g_byte_array_append(buf, (uint8_t *) &to_long, 4);
-    return 4;
-}
-
-static inline int gdb_get_reg64(GByteArray *buf, uint64_t val)
-{
-    uint64_t to_quad = tswap64(val);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    return 8;
-}
-
-static inline int gdb_get_reg128(GByteArray *buf, uint64_t val_hi,
-                                 uint64_t val_lo)
-{
-    uint64_t to_quad;
-#if TARGET_BIG_ENDIAN
-    to_quad = tswap64(val_hi);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    to_quad = tswap64(val_lo);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-#else
-    to_quad = tswap64(val_lo);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    to_quad = tswap64(val_hi);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-#endif
-    return 16;
-}
-
-static inline int gdb_get_zeroes(GByteArray *array, size_t len)
-{
-    guint oldlen = array->len;
-    g_byte_array_set_size(array, oldlen + len);
-    memset(array->data + oldlen, 0, len);
-
-    return len;
-}
-
-/**
- * gdb_get_reg_ptr: get pointer to start of last element
- * @len: length of element
- *
- * This is a helper function to extract the pointer to the last
- * element for additional processing. Some front-ends do additional
- * dynamic swapping of the elements based on CPU state.
- */
-static inline uint8_t * gdb_get_reg_ptr(GByteArray *buf, int len)
-{
-    return buf->data + buf->len - len;
-}
-
-#if TARGET_LONG_BITS == 64
-#define gdb_get_regl(buf, val) gdb_get_reg64(buf, val)
-#define ldtul_p(addr) ldq_p(addr)
-#else
-#define gdb_get_regl(buf, val) gdb_get_reg32(buf, val)
-#define ldtul_p(addr) ldl_p(addr)
-#endif
-
-#endif /* NEED_CPU_H */
-
 /**
  * gdbserver_start: start the gdb server
  * @port_or_device: connection spec for gdb
diff --git a/include/gdbstub/helpers.h b/include/gdbstub/helpers.h
new file mode 100644
index 0000000000..c573aef2dc
--- /dev/null
+++ b/include/gdbstub/helpers.h
@@ -0,0 +1,103 @@
+/*
+ * gdbstub helpers
+ *
+ * These are all used by the various frontends and have to be host
+ * aware to ensure things are store in target order.
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef _GDBSTUB_HELPERS_H_
+#define _GDBSTUB_HELPERS_H_
+
+#ifdef NEED_CPU_H
+#include "cpu.h"
+
+/*
+ * The GDB remote protocol transfers values in target byte order. As
+ * the gdbstub may be batching up several register values we always
+ * append to the array.
+ */
+
+static inline int gdb_get_reg8(GByteArray *buf, uint8_t val)
+{
+    g_byte_array_append(buf, &val, 1);
+    return 1;
+}
+
+static inline int gdb_get_reg16(GByteArray *buf, uint16_t val)
+{
+    uint16_t to_word = tswap16(val);
+    g_byte_array_append(buf, (uint8_t *) &to_word, 2);
+    return 2;
+}
+
+static inline int gdb_get_reg32(GByteArray *buf, uint32_t val)
+{
+    uint32_t to_long = tswap32(val);
+    g_byte_array_append(buf, (uint8_t *) &to_long, 4);
+    return 4;
+}
+
+static inline int gdb_get_reg64(GByteArray *buf, uint64_t val)
+{
+    uint64_t to_quad = tswap64(val);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    return 8;
+}
+
+static inline int gdb_get_reg128(GByteArray *buf, uint64_t val_hi,
+                                 uint64_t val_lo)
+{
+    uint64_t to_quad;
+#if TARGET_BIG_ENDIAN
+    to_quad = tswap64(val_hi);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    to_quad = tswap64(val_lo);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+#else
+    to_quad = tswap64(val_lo);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    to_quad = tswap64(val_hi);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+#endif
+    return 16;
+}
+
+static inline int gdb_get_zeroes(GByteArray *array, size_t len)
+{
+    guint oldlen = array->len;
+    g_byte_array_set_size(array, oldlen + len);
+    memset(array->data + oldlen, 0, len);
+
+    return len;
+}
+
+/**
+ * gdb_get_reg_ptr: get pointer to start of last element
+ * @len: length of element
+ *
+ * This is a helper function to extract the pointer to the last
+ * element for additional processing. Some front-ends do additional
+ * dynamic swapping of the elements based on CPU state.
+ */
+static inline uint8_t *gdb_get_reg_ptr(GByteArray *buf, int len)
+{
+    return buf->data + buf->len - len;
+}
+
+#if TARGET_LONG_BITS == 64
+#define gdb_get_regl(buf, val) gdb_get_reg64(buf, val)
+#define ldtul_p(addr) ldq_p(addr)
+#else
+#define gdb_get_regl(buf, val) gdb_get_reg32(buf, val)
+#define ldtul_p(addr) ldl_p(addr)
+#endif
+
+#else
+#error "gdbstub helpers should only be included by target specific code"
+#endif
+
+#endif /* _GDBSTUB_HELPERS_H_ */
diff --git a/semihosting/syscalls.c b/semihosting/syscalls.c
index e89992cf90..d69078899a 100644
--- a/semihosting/syscalls.c
+++ b/semihosting/syscalls.c
@@ -8,6 +8,7 @@
 
 #include "qemu/osdep.h"
 #include "exec/gdbstub.h"
+#include "cpu.h"
 #include "semihosting/guestfd.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/console.h"
diff --git a/target/alpha/gdbstub.c b/target/alpha/gdbstub.c
index 7db14f4431..0f8fa150f8 100644
--- a/target/alpha/gdbstub.c
+++ b/target/alpha/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 2f806512d0..05d6eb802a 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "internals.h"
 #include "cpregs.h"
 
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index 07a6746944..48d2888b6f 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -20,7 +20,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "internals.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
index 0972a4bdd0..c3edf163be 100644
--- a/target/arm/tcg/helper-a64.c
+++ b/target/arm/tcg/helper-a64.c
@@ -20,7 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/units.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/host-utils.h"
 #include "qemu/log.h"
diff --git a/target/arm/tcg/m_helper.c b/target/arm/tcg/m_helper.c
index f94e87e728..e05da83af5 100644
--- a/target/arm/tcg/m_helper.c
+++ b/target/arm/tcg/m_helper.c
@@ -9,6 +9,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "internals.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/main-loop.h"
 #include "qemu/bitops.h"
diff --git a/target/avr/gdbstub.c b/target/avr/gdbstub.c
index 1c1b908c92..150344d8b9 100644
--- a/target/avr/gdbstub.c
+++ b/target/avr/gdbstub.c
@@ -19,7 +19,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/cris/gdbstub.c b/target/cris/gdbstub.c
index 2418d575b1..25c0ca33a5 100644
--- a/target/cris/gdbstub.c
+++ b/target/cris/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/hexagon/gdbstub.c b/target/hexagon/gdbstub.c
index d152d01bfe..46083da620 100644
--- a/target/hexagon/gdbstub.c
+++ b/target/hexagon/gdbstub.c
@@ -16,7 +16,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "cpu.h"
 #include "internal.h"
 
diff --git a/target/hppa/gdbstub.c b/target/hppa/gdbstub.c
index 729c37b2ca..48a514384f 100644
--- a/target/hppa/gdbstub.c
+++ b/target/hppa/gdbstub.c
@@ -19,7 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int hppa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
index 786971284a..ebb000df6a 100644
--- a/target/i386/gdbstub.c
+++ b/target/i386/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "include/gdbstub/helpers.h"
 
 #ifdef TARGET_X86_64
 static const int gpr_map[16] = {
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 3d0c0b375f..52af81683c 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -12,7 +12,7 @@
 #include "cpu.h"
 #include "exec/address-spaces.h"
 #include "exec/ioport.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/accel.h"
 #include "sysemu/whpx.h"
 #include "sysemu/cpus.h"
diff --git a/target/loongarch/gdbstub.c b/target/loongarch/gdbstub.c
index a4d1e28e36..fa3e034d15 100644
--- a/target/loongarch/gdbstub.c
+++ b/target/loongarch/gdbstub.c
@@ -10,6 +10,7 @@
 #include "cpu.h"
 #include "internals.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 uint64_t read_fcc(CPULoongArchState *env)
 {
diff --git a/target/m68k/gdbstub.c b/target/m68k/gdbstub.c
index eb2d030e14..1e5f033a12 100644
--- a/target/m68k/gdbstub.c
+++ b/target/m68k/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 4621cf2402..3b3a6ea8bd 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -23,6 +23,7 @@
 #include "exec/exec-all.h"
 #include "exec/gdbstub.h"
 #include "exec/helper-proto.h"
+#include "gdbstub/helpers.h"
 #include "fpu/softfloat.h"
 #include "qemu/qemu-print.h"
 
diff --git a/target/m68k/m68k-semi.c b/target/m68k/m68k-semi.c
index 87b1314925..f753710d7d 100644
--- a/target/m68k/m68k-semi.c
+++ b/target/m68k/m68k-semi.c
@@ -21,6 +21,7 @@
 
 #include "cpu.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "hw/boards.h"
diff --git a/target/microblaze/gdbstub.c b/target/microblaze/gdbstub.c
index 8143fcae88..29ac6e9c0f 100644
--- a/target/microblaze/gdbstub.c
+++ b/target/microblaze/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 /*
  * GDB expects SREGs in the following order:
diff --git a/target/mips/gdbstub.c b/target/mips/gdbstub.c
index f1c2a2cf6d..62d7b72407 100644
--- a/target/mips/gdbstub.c
+++ b/target/mips/gdbstub.c
@@ -20,7 +20,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "internal.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "fpu_helper.h"
 
 int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
diff --git a/target/mips/tcg/sysemu/mips-semi.c b/target/mips/tcg/sysemu/mips-semi.c
index 85f0567a7f..4e6e759057 100644
--- a/target/mips/tcg/sysemu/mips-semi.c
+++ b/target/mips/tcg/sysemu/mips-semi.c
@@ -21,6 +21,7 @@
 #include "cpu.h"
 #include "qemu/log.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "semihosting/semihost.h"
 #include "semihosting/console.h"
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index cff30823da..bc5cbf81c2 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -23,7 +23,7 @@
 #include "qapi/error.h"
 #include "cpu.h"
 #include "exec/log.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "hw/qdev-properties.h"
 
 static void nios2_cpu_set_pc(CPUState *cs, vaddr value)
diff --git a/target/nios2/nios2-semi.c b/target/nios2/nios2-semi.c
index f76e8588c5..113b3f22aa 100644
--- a/target/nios2/nios2-semi.c
+++ b/target/nios2/nios2-semi.c
@@ -24,6 +24,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "qemu/log.h"
diff --git a/target/openrisc/gdbstub.c b/target/openrisc/gdbstub.c
index 095bf76c12..d1074a0581 100644
--- a/target/openrisc/gdbstub.c
+++ b/target/openrisc/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int openrisc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/openrisc/interrupt.c b/target/openrisc/interrupt.c
index c31c6f12c4..3887812810 100644
--- a/target/openrisc/interrupt.c
+++ b/target/openrisc/interrupt.c
@@ -21,7 +21,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #ifndef CONFIG_USER_ONLY
 #include "hw/loader.h"
diff --git a/target/openrisc/mmu.c b/target/openrisc/mmu.c
index 0b8afdbacf..603c26715e 100644
--- a/target/openrisc/mmu.c
+++ b/target/openrisc/mmu.c
@@ -22,7 +22,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #include "hw/loader.h"
 
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index d62ffe8a6f..0ce2e3c91d 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -20,7 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "disas/dis-asm.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "kvm_ppc.h"
 #include "sysemu/cpus.h"
 #include "sysemu/hw_accel.h"
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index 1a0b9ca82c..d2bc1d7c53 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "internal.h"
 
 static int ppc_gdb_register_len_apple(int n)
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 6e7bbdbd5e..a542683901 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -18,6 +18,7 @@
 
 #include "qemu/osdep.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "cpu.h"
 
 struct TypeSize {
diff --git a/target/rx/gdbstub.c b/target/rx/gdbstub.c
index 7eb2059a84..d7e0e6689b 100644
--- a/target/rx/gdbstub.c
+++ b/target/rx/gdbstub.c
@@ -17,7 +17,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/s390x/gdbstub.c b/target/s390x/gdbstub.c
index a5d69d0e0b..0cb69395b4 100644
--- a/target/s390x/gdbstub.c
+++ b/target/s390x/gdbstub.c
@@ -23,6 +23,7 @@
 #include "s390x-internal.h"
 #include "exec/exec-all.h"
 #include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/bitops.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/tcg.h"
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index 473c8e51b0..2b363aa959 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -21,7 +21,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "s390x-internal.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/timer.h"
 #include "hw/s390x/ioinst.h"
 #include "hw/s390x/pv.h"
diff --git a/target/sh4/gdbstub.c b/target/sh4/gdbstub.c
index 3488f68e32..d8e199fc06 100644
--- a/target/sh4/gdbstub.c
+++ b/target/sh4/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 /* Hint: Use "set architecture sh4" in GDB to see fpu registers */
 /* FIXME: We should use XML for this.  */
diff --git a/target/sparc/gdbstub.c b/target/sparc/gdbstub.c
index 5d1e808e8c..a1c8fdc4d5 100644
--- a/target/sparc/gdbstub.c
+++ b/target/sparc/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 #ifdef TARGET_ABI32
 #define gdb_get_rega(buf, val) gdb_get_reg32(buf, val)
diff --git a/target/tricore/gdbstub.c b/target/tricore/gdbstub.c
index 3a27a7e65d..e8f8e5e6ea 100644
--- a/target/tricore/gdbstub.c
+++ b/target/tricore/gdbstub.c
@@ -18,7 +18,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 
 #define LCX_REGNUM         32
diff --git a/target/xtensa/core-dc232b.c b/target/xtensa/core-dc232b.c
index c982d09c24..9aba2667e3 100644
--- a/target/xtensa/core-dc232b.c
+++ b/target/xtensa/core-dc232b.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #include "qemu/timer.h"
 
diff --git a/target/xtensa/core-dc233c.c b/target/xtensa/core-dc233c.c
index 595ab9a90f..9b0a625063 100644
--- a/target/xtensa/core-dc233c.c
+++ b/target/xtensa/core-dc233c.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-dc233c/core-isa.h"
diff --git a/target/xtensa/core-de212.c b/target/xtensa/core-de212.c
index 50c995ba79..b08fe22e65 100644
--- a/target/xtensa/core-de212.c
+++ b/target/xtensa/core-de212.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-de212/core-isa.h"
diff --git a/target/xtensa/core-de233_fpu.c b/target/xtensa/core-de233_fpu.c
index 41af8057fb..8845cdb592 100644
--- a/target/xtensa/core-de233_fpu.c
+++ b/target/xtensa/core-de233_fpu.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-de233_fpu/core-isa.h"
diff --git a/target/xtensa/core-dsp3400.c b/target/xtensa/core-dsp3400.c
index 81e425c568..c0f94b9e27 100644
--- a/target/xtensa/core-dsp3400.c
+++ b/target/xtensa/core-dsp3400.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-dsp3400/core-isa.h"
diff --git a/target/xtensa/core-fsf.c b/target/xtensa/core-fsf.c
index 3327c50b4f..310be8d61f 100644
--- a/target/xtensa/core-fsf.c
+++ b/target/xtensa/core-fsf.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-fsf/core-isa.h"
diff --git a/target/xtensa/core-lx106.c b/target/xtensa/core-lx106.c
index 7a771d09a6..7f71d088f3 100644
--- a/target/xtensa/core-lx106.c
+++ b/target/xtensa/core-lx106.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-lx106/core-isa.h"
diff --git a/target/xtensa/core-sample_controller.c b/target/xtensa/core-sample_controller.c
index fd5de5576b..8867001aac 100644
--- a/target/xtensa/core-sample_controller.c
+++ b/target/xtensa/core-sample_controller.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-sample_controller/core-isa.h"
diff --git a/target/xtensa/core-test_kc705_be.c b/target/xtensa/core-test_kc705_be.c
index 294c16f2f4..bd082f49aa 100644
--- a/target/xtensa/core-test_kc705_be.c
+++ b/target/xtensa/core-test_kc705_be.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-test_kc705_be/core-isa.h"
diff --git a/target/xtensa/core-test_mmuhifi_c3.c b/target/xtensa/core-test_mmuhifi_c3.c
index c0e5d32d1e..3090dd01ed 100644
--- a/target/xtensa/core-test_mmuhifi_c3.c
+++ b/target/xtensa/core-test_mmuhifi_c3.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-test_mmuhifi_c3/core-isa.h"
diff --git a/target/xtensa/gdbstub.c b/target/xtensa/gdbstub.c
index b6696063e5..4b3bfb7e59 100644
--- a/target/xtensa/gdbstub.c
+++ b/target/xtensa/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/log.h"
 
 enum {
diff --git a/target/xtensa/helper.c b/target/xtensa/helper.c
index 2aa9777a8e..dbeb97a953 100644
--- a/target/xtensa/helper.c
+++ b/target/xtensa/helper.c
@@ -29,7 +29,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
diff --git a/target/xtensa/import_core.sh b/target/xtensa/import_core.sh
index b4c15556c2..17dfec8957 100755
--- a/target/xtensa/import_core.sh
+++ b/target/xtensa/import_core.sh
@@ -41,7 +41,7 @@ tar -xf "$OVERLAY" -O binutils/xtensa-modules.c | \
 cat <<EOF > "${TARGET}.c"
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-$NAME/core-isa.h"
-- 
2.39.2

