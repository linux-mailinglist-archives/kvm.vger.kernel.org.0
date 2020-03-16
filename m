Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57B5186FC0
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgCPQOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39527 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732040AbgCPQOG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL60xHob88fQ7VIPeFS5XLuacMMTzsdimp2PvDIHEac=;
        b=Oo6nfQ4DOuUz9FVKy0wBOpiJINWWk/XWN9VY3uuaVLQ35itOhLaVnkzXnbBZsuJAmRxnY8
        GBqa9RNjW+QH4xjs/vPvfvHSoZc5LmuRcKIbpk3CK3kkVlPrQbPpY0btXrDxDhjuiPvNC6
        ZpzPe0qNXDbMjnsliQj/2/4Fpk+Atsc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-7FZ9GyoIPCeJvCk4Fx_BUQ-1; Mon, 16 Mar 2020 12:07:46 -0400
X-MC-Unique: 7FZ9GyoIPCeJvCk4Fx_BUQ-1
Received: by mail-wm1-f70.google.com with SMTP id s20so5175328wmj.2
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wL60xHob88fQ7VIPeFS5XLuacMMTzsdimp2PvDIHEac=;
        b=o11I/Bv+0D69GSKxIksnaYy0QBa5ZCC4/At4uKbOr03BmDq6jhx3vNSKk5omNQe7oL
         cPd56DyYZded9Kq/K5RuVT48DstSt0al6m3sGkl71kLf/0JdgHayP9CmXOWcWtnZckk4
         9sMsDxLEzgU3tkSv/qLvoKKpg5nDhdQYJNPqYi9x1f1ZjfT+oEqdbJhuLmYUa6y3ZgsI
         v7El7VdfkOOHHSlZfMkcMi2uMyI2F9EqeOsQlq0c8lmiRkwo496C93EZ+/90B1t2dBOG
         IKal7n9XcrvLxwFOXDITS9EIYNI4RRGjpcOfUFzJ/plctNBpqxRCJjDvKlsV+aKy9mti
         /z4A==
X-Gm-Message-State: ANhLgQ1wWFH9C7D7Z+MT/qv2V26vXPVgH2BlVNwuEwWYW+kQlvg+F9tv
        6I5rDUvt4aM2BpoIYCp1zfd8PrTZRZ3KWGAtcDY5g72Q2qLNqHlyo6EWUPnOokpEakYc6yhc0gu
        JMnPKxYEvxVS2
X-Received: by 2002:a1c:7e57:: with SMTP id z84mr27973265wmc.148.1584374863912;
        Mon, 16 Mar 2020 09:07:43 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuuel+IgN0ODwNbK6ZFzKt+p1vYcd4ktsX8FiFd1ybGIsy2EPitjEqzcxIwOwndB4N0aPiXAg==
X-Received: by 2002:a1c:7e57:: with SMTP id z84mr27973218wmc.148.1584374863467;
        Mon, 16 Mar 2020 09:07:43 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id 96sm549814wrm.63.2020.03.16.09.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:42 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 12/19] target/arm: Restrict ARMv6 cpus to TCG accel
Date:   Mon, 16 Mar 2020 17:06:27 +0100
Message-Id: <20200316160634.3386-13-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a cpu based on (at least) the ARMv7 architecture.

Only enable the following ARMv6 CPUs when TCG is available:

  - ARM1136
  - ARM1176
  - ARM11MPCore
  - Cortex-M0

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak |   2 -
 target/arm/cpu.c                | 137 -------------------------
 target/arm/cpu_v6.c             | 171 ++++++++++++++++++++++++++++++++
 hw/arm/Kconfig                  |   2 +
 target/arm/Kconfig              |   4 +
 target/arm/Makefile.objs        |   1 +
 6 files changed, 178 insertions(+), 139 deletions(-)
 create mode 100644 target/arm/cpu_v6.c

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index f176a98296..3aa27f3b40 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -13,9 +13,7 @@ CONFIG_ARM_VIRT=y
 CONFIG_CUBIEBOARD=y
 CONFIG_EXYNOS4=y
 CONFIG_HIGHBANK=y
-CONFIG_FSL_IMX31=y
 CONFIG_MUSCA=y
-CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
 CONFIG_VEXPRESS=y
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index f1d1ba8451..34908828a0 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1834,135 +1834,6 @@ static ObjectClass *arm_cpu_class_by_name(const char *cpu_model)
 /* CPU models. These are not needed for the AArch64 linux-user build. */
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
 
-static void arm1136_r2_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-    /* What qemu calls "arm1136_r2" is actually the 1136 r0p2, ie an
-     * older core than plain "arm1136". In particular this does not
-     * have the v6K features.
-     * These ID register values are correct for 1136 but may be wrong
-     * for 1136_r2 (in particular r0p2 does not actually implement most
-     * of the ID registers).
-     */
-
-    cpu->dtb_compatible = "arm,arm1136";
-    set_feature(&cpu->env, ARM_FEATURE_V6);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
-    cpu->midr = 0x4107b362;
-    cpu->reset_fpsid = 0x410120b4;
-    cpu->isar.mvfr0 = 0x11111111;
-    cpu->isar.mvfr1 = 0x00000000;
-    cpu->ctr = 0x1dd20d2;
-    cpu->reset_sctlr = 0x00050078;
-    cpu->id_pfr0 = 0x111;
-    cpu->id_pfr1 = 0x1;
-    cpu->isar.id_dfr0 = 0x2;
-    cpu->id_afr0 = 0x3;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222110;
-    cpu->isar.id_isar0 = 0x00140011;
-    cpu->isar.id_isar1 = 0x12002111;
-    cpu->isar.id_isar2 = 0x11231111;
-    cpu->isar.id_isar3 = 0x01102131;
-    cpu->isar.id_isar4 = 0x141;
-    cpu->reset_auxcr = 7;
-}
-
-static void arm1136_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm1136";
-    set_feature(&cpu->env, ARM_FEATURE_V6K);
-    set_feature(&cpu->env, ARM_FEATURE_V6);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
-    cpu->midr = 0x4117b363;
-    cpu->reset_fpsid = 0x410120b4;
-    cpu->isar.mvfr0 = 0x11111111;
-    cpu->isar.mvfr1 = 0x00000000;
-    cpu->ctr = 0x1dd20d2;
-    cpu->reset_sctlr = 0x00050078;
-    cpu->id_pfr0 = 0x111;
-    cpu->id_pfr1 = 0x1;
-    cpu->isar.id_dfr0 = 0x2;
-    cpu->id_afr0 = 0x3;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222110;
-    cpu->isar.id_isar0 = 0x00140011;
-    cpu->isar.id_isar1 = 0x12002111;
-    cpu->isar.id_isar2 = 0x11231111;
-    cpu->isar.id_isar3 = 0x01102131;
-    cpu->isar.id_isar4 = 0x141;
-    cpu->reset_auxcr = 7;
-}
-
-static void arm1176_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm1176";
-    set_feature(&cpu->env, ARM_FEATURE_V6K);
-    set_feature(&cpu->env, ARM_FEATURE_VAPA);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
-    set_feature(&cpu->env, ARM_FEATURE_EL3);
-    cpu->midr = 0x410fb767;
-    cpu->reset_fpsid = 0x410120b5;
-    cpu->isar.mvfr0 = 0x11111111;
-    cpu->isar.mvfr1 = 0x00000000;
-    cpu->ctr = 0x1dd20d2;
-    cpu->reset_sctlr = 0x00050078;
-    cpu->id_pfr0 = 0x111;
-    cpu->id_pfr1 = 0x11;
-    cpu->isar.id_dfr0 = 0x33;
-    cpu->id_afr0 = 0;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222100;
-    cpu->isar.id_isar0 = 0x0140011;
-    cpu->isar.id_isar1 = 0x12002111;
-    cpu->isar.id_isar2 = 0x11231121;
-    cpu->isar.id_isar3 = 0x01102131;
-    cpu->isar.id_isar4 = 0x01141;
-    cpu->reset_auxcr = 7;
-}
-
-static void arm11mpcore_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm11mpcore";
-    set_feature(&cpu->env, ARM_FEATURE_V6K);
-    set_feature(&cpu->env, ARM_FEATURE_VAPA);
-    set_feature(&cpu->env, ARM_FEATURE_MPIDR);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x410fb022;
-    cpu->reset_fpsid = 0x410120b4;
-    cpu->isar.mvfr0 = 0x11111111;
-    cpu->isar.mvfr1 = 0x00000000;
-    cpu->ctr = 0x1d192992; /* 32K icache 32K dcache */
-    cpu->id_pfr0 = 0x111;
-    cpu->id_pfr1 = 0x1;
-    cpu->isar.id_dfr0 = 0;
-    cpu->id_afr0 = 0x2;
-    cpu->isar.id_mmfr0 = 0x01100103;
-    cpu->isar.id_mmfr1 = 0x10020302;
-    cpu->isar.id_mmfr2 = 0x01222000;
-    cpu->isar.id_isar0 = 0x00100011;
-    cpu->isar.id_isar1 = 0x12002111;
-    cpu->isar.id_isar2 = 0x11221011;
-    cpu->isar.id_isar3 = 0x01102131;
-    cpu->isar.id_isar4 = 0x141;
-    cpu->reset_auxcr = 1;
-}
-
 static void cortex_m0_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -2452,14 +2323,6 @@ static void arm_max_initfn(Object *obj)
 
 static const ARMCPUInfo arm_cpus[] = {
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
-    /* What QEMU calls "arm1136-r2" is actually the 1136 r0p2, i.e. an
-     * older core than plain "arm1136". In particular this does not
-     * have the v6K features.
-     */
-    { .name = "arm1136-r2",  .initfn = arm1136_r2_initfn },
-    { .name = "arm1136",     .initfn = arm1136_initfn },
-    { .name = "arm1176",     .initfn = arm1176_initfn },
-    { .name = "arm11mpcore", .initfn = arm11mpcore_initfn },
     { .name = "cortex-m0",   .initfn = cortex_m0_initfn,
                              .class_init = arm_v7m_class_init },
     { .name = "cortex-m3",   .initfn = cortex_m3_initfn,
diff --git a/target/arm/cpu_v6.c b/target/arm/cpu_v6.c
new file mode 100644
index 0000000000..1c73c881f3
--- /dev/null
+++ b/target/arm/cpu_v6.c
@@ -0,0 +1,171 @@
+/*
+ * ARM generic helpers.
+ *
+ * This code is licensed under the GNU GPL v2 or later.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "internals.h"
+
+/* CPU models. These are not needed for the AArch64 linux-user build. */
+#if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
+
+static void arm1136_r2_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    /*
+     * What qemu calls "arm1136_r2" is actually the 1136 r0p2, ie an
+     * older core than plain "arm1136". In particular this does not
+     * have the v6K features.
+     * These ID register values are correct for 1136 but may be wrong
+     * for 1136_r2 (in particular r0p2 does not actually implement most
+     * of the ID registers).
+     */
+
+    cpu->dtb_compatible = "arm,arm1136";
+    set_feature(&cpu->env, ARM_FEATURE_V6);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
+    cpu->midr = 0x4107b362;
+    cpu->reset_fpsid = 0x410120b4;
+    cpu->isar.mvfr0 = 0x11111111;
+    cpu->isar.mvfr1 = 0x00000000;
+    cpu->ctr = 0x1dd20d2;
+    cpu->reset_sctlr = 0x00050078;
+    cpu->id_pfr0 = 0x111;
+    cpu->id_pfr1 = 0x1;
+    cpu->isar.id_dfr0 = 0x2;
+    cpu->id_afr0 = 0x3;
+    cpu->isar.id_mmfr0 = 0x01130003;
+    cpu->isar.id_mmfr1 = 0x10030302;
+    cpu->isar.id_mmfr2 = 0x01222110;
+    cpu->isar.id_isar0 = 0x00140011;
+    cpu->isar.id_isar1 = 0x12002111;
+    cpu->isar.id_isar2 = 0x11231111;
+    cpu->isar.id_isar3 = 0x01102131;
+    cpu->isar.id_isar4 = 0x141;
+    cpu->reset_auxcr = 7;
+}
+
+static void arm1136_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm1136";
+    set_feature(&cpu->env, ARM_FEATURE_V6K);
+    set_feature(&cpu->env, ARM_FEATURE_V6);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
+    cpu->midr = 0x4117b363;
+    cpu->reset_fpsid = 0x410120b4;
+    cpu->isar.mvfr0 = 0x11111111;
+    cpu->isar.mvfr1 = 0x00000000;
+    cpu->ctr = 0x1dd20d2;
+    cpu->reset_sctlr = 0x00050078;
+    cpu->id_pfr0 = 0x111;
+    cpu->id_pfr1 = 0x1;
+    cpu->isar.id_dfr0 = 0x2;
+    cpu->id_afr0 = 0x3;
+    cpu->isar.id_mmfr0 = 0x01130003;
+    cpu->isar.id_mmfr1 = 0x10030302;
+    cpu->isar.id_mmfr2 = 0x01222110;
+    cpu->isar.id_isar0 = 0x00140011;
+    cpu->isar.id_isar1 = 0x12002111;
+    cpu->isar.id_isar2 = 0x11231111;
+    cpu->isar.id_isar3 = 0x01102131;
+    cpu->isar.id_isar4 = 0x141;
+    cpu->reset_auxcr = 7;
+}
+
+static void arm1176_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm1176";
+    set_feature(&cpu->env, ARM_FEATURE_V6K);
+    set_feature(&cpu->env, ARM_FEATURE_VAPA);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
+    set_feature(&cpu->env, ARM_FEATURE_EL3);
+    cpu->midr = 0x410fb767;
+    cpu->reset_fpsid = 0x410120b5;
+    cpu->isar.mvfr0 = 0x11111111;
+    cpu->isar.mvfr1 = 0x00000000;
+    cpu->ctr = 0x1dd20d2;
+    cpu->reset_sctlr = 0x00050078;
+    cpu->id_pfr0 = 0x111;
+    cpu->id_pfr1 = 0x11;
+    cpu->isar.id_dfr0 = 0x33;
+    cpu->id_afr0 = 0;
+    cpu->isar.id_mmfr0 = 0x01130003;
+    cpu->isar.id_mmfr1 = 0x10030302;
+    cpu->isar.id_mmfr2 = 0x01222100;
+    cpu->isar.id_isar0 = 0x0140011;
+    cpu->isar.id_isar1 = 0x12002111;
+    cpu->isar.id_isar2 = 0x11231121;
+    cpu->isar.id_isar3 = 0x01102131;
+    cpu->isar.id_isar4 = 0x01141;
+    cpu->reset_auxcr = 7;
+}
+
+static void arm11mpcore_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm11mpcore";
+    set_feature(&cpu->env, ARM_FEATURE_V6K);
+    set_feature(&cpu->env, ARM_FEATURE_VAPA);
+    set_feature(&cpu->env, ARM_FEATURE_MPIDR);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    cpu->midr = 0x410fb022;
+    cpu->reset_fpsid = 0x410120b4;
+    cpu->isar.mvfr0 = 0x11111111;
+    cpu->isar.mvfr1 = 0x00000000;
+    cpu->ctr = 0x1d192992; /* 32K icache 32K dcache */
+    cpu->id_pfr0 = 0x111;
+    cpu->id_pfr1 = 0x1;
+    cpu->isar.id_dfr0 = 0;
+    cpu->id_afr0 = 0x2;
+    cpu->isar.id_mmfr0 = 0x01100103;
+    cpu->isar.id_mmfr1 = 0x10020302;
+    cpu->isar.id_mmfr2 = 0x01222000;
+    cpu->isar.id_isar0 = 0x00100011;
+    cpu->isar.id_isar1 = 0x12002111;
+    cpu->isar.id_isar2 = 0x11221011;
+    cpu->isar.id_isar3 = 0x01102131;
+    cpu->isar.id_isar4 = 0x141;
+    cpu->reset_auxcr = 1;
+}
+
+static const ARMCPUInfo arm_v6_cpus[] = {
+    /*
+     * What QEMU calls "arm1136-r2" is actually the 1136 r0p2, i.e.
+     * an older core than plain "arm1136". In particular this does
+     * not have the v6K features.
+     */
+    { .name = "arm1136-r2",  .initfn = arm1136_r2_initfn },
+    { .name = "arm1136",     .initfn = arm1136_initfn },
+    { .name = "arm1176",     .initfn = arm1176_initfn },
+    { .name = "arm11mpcore", .initfn = arm11mpcore_initfn },
+    { .name = NULL }
+};
+
+static void arm_v6_cpu_register_types(void)
+{
+    const ARMCPUInfo *info = arm_v6_cpus;
+
+    while (info->name) {
+        arm_cpu_register(info);
+        info++;
+    }
+}
+
+type_init(arm_v6_cpu_register_types)
+
+#endif
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 3b78471de0..e87dd611f2 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -113,6 +113,7 @@ config NETDUINOPLUS2
 
 config NSERIES
     bool
+    select ARM_V6
     select OMAP
     select TMP105   # tempature sensor
     select BLIZZARD # LCD/TV controller
@@ -367,6 +368,7 @@ config FSL_IMX25
 
 config FSL_IMX31
     bool
+    select ARM_V6
     select SERIAL
     select IMX
     select IMX_I2C
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index 028d8382fe..df5f8dff42 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -6,5 +6,9 @@ config ARM_V5
     depends on TCG
     bool
 
+config ARM_V6
+    depends on TCG
+    bool
+
 config ARM_V7M
     bool
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index f66f7f1158..0473c559c6 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -70,6 +70,7 @@ obj-y += m_helper.o
 
 obj-$(CONFIG_ARM_V4) += cpu_v4.o
 obj-$(CONFIG_ARM_V5) += cpu_v5.o
+obj-$(CONFIG_ARM_V6) += cpu_v6.o
 
 obj-$(CONFIG_SOFTMMU) += psci.o
 
-- 
2.21.1

