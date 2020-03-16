Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CE1186FBF
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbgCPQOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23938 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732033AbgCPQOF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3HJ4BPrTTJoaZ0DIQ+Bm5OwC5QHXxR7lFDDNNHr42oA=;
        b=gY+hYduqDlhAL41eu4tcw2ZNookRJyIf+JQrgbwSbe6fyBiA5+p5wAfZDky5kvPQYUkcCn
        9A1kXLH5zI+v7PZJdIU39fi8kGoFvcXfMWwthd/bvLcCvmQ17/Fnmc7qXYggmneRLrANqP
        yb3z+TCZjXSbO7EWEZAQ6i3cTpg766k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-rmNVSgqBOqu8mMusX0_9Tg-1; Mon, 16 Mar 2020 12:07:35 -0400
X-MC-Unique: rmNVSgqBOqu8mMusX0_9Tg-1
Received: by mail-wr1-f69.google.com with SMTP id b12so9325985wro.4
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3HJ4BPrTTJoaZ0DIQ+Bm5OwC5QHXxR7lFDDNNHr42oA=;
        b=qKGr5XhJJNbN7z1GKsp4OstByVmCUIXEsbC93m8ro0wjQSJhLnaPVa0SeU4BOS55nT
         sTRIsHIW2bdVyCKiinsLD7HTyb2Au7AytVP3cEwxyTmBQ1WonAj9xKYWWkr0QfQAgOjo
         6TgwBT6NNdlDXjB8GP7k5pRDZt1ruPFcSP1uTk9vU+DQJ9GoG9fVk5bWBg6Jzt0Eqbfo
         dXVrDW0YlNossgQJjffvqhFs8IAccmlBYvXP4tbznt7i4nofCIV7w6wg0PSU5jRFuQtD
         yd5Dei2qfqOQnkzXHviMZgs6h8Uxr+UhCdAS9VeWsps0Oh+HS3x5F0osMd/mJ8+WQZ4o
         p7nA==
X-Gm-Message-State: ANhLgQ2EHPbpFQC62ha2Yw0x5azvryZVrqC0NAWhMJstXea2VTYlfHuT
        5WSuiegdHH8ja10VcnK2NgUysuc9HqQbiK6NA9tkmT8ed3omBlTiyspg+3k6Rn7W1clgCpMMEvg
        z2Yyt70TXq+N+
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr47284wrw.351.1584374852710;
        Mon, 16 Mar 2020 09:07:32 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtrKaxBzOd8Im5SmvT1u80g+l61wwRhiOvBIE54mUu/WaIr9u73VUZDQPx9shnTaY32+aclQQ==
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr47263wrw.351.1584374852435;
        Mon, 16 Mar 2020 09:07:32 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id 127sm68345wmd.38.2020.03.16.09.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:31 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 10/19] target/arm: Restrict ARMv4 cpus to TCG accel
Date:   Mon, 16 Mar 2020 17:06:25 +0100
Message-Id: <20200316160634.3386-11-philmd@redhat.com>
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

Only enable the following ARMv4 CPUs when TCG is available:

  - StrongARM (SA1100/1110)
  - OMAP1510 (TI925T)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak |  2 -
 target/arm/cpu.c                | 33 -----------------
 target/arm/cpu_v4.c             | 65 +++++++++++++++++++++++++++++++++
 hw/arm/Kconfig                  |  2 +
 target/arm/Kconfig              |  4 ++
 target/arm/Makefile.objs        |  2 +
 6 files changed, 73 insertions(+), 35 deletions(-)
 create mode 100644 target/arm/cpu_v4.c

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 8b89d8c4c0..0652396296 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -17,8 +17,6 @@ CONFIG_INTEGRATOR=y
 CONFIG_FSL_IMX31=y
 CONFIG_MUSICPAL=y
 CONFIG_MUSCA=y
-CONFIG_CHEETAH=y
-CONFIG_SX1=y
 CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index d2813eb81a..b08b6933be 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2459,36 +2459,6 @@ static void cortex_a15_initfn(Object *obj)
     define_arm_cp_regs(cpu, cortexa15_cp_reginfo);
 }
 
-static void ti925t_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-    set_feature(&cpu->env, ARM_FEATURE_V4T);
-    set_feature(&cpu->env, ARM_FEATURE_OMAPCP);
-    cpu->midr = ARM_CPUID_TI925T;
-    cpu->ctr = 0x5109149;
-    cpu->reset_sctlr = 0x00000070;
-}
-
-static void sa1100_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "intel,sa1100";
-    set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x4401A11B;
-    cpu->reset_sctlr = 0x00000070;
-}
-
-static void sa1110_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-    set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x6901B119;
-    cpu->reset_sctlr = 0x00000070;
-}
-
 static void pxa250_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -2727,9 +2697,6 @@ static const ARMCPUInfo arm_cpus[] = {
     { .name = "cortex-a8",   .initfn = cortex_a8_initfn },
     { .name = "cortex-a9",   .initfn = cortex_a9_initfn },
     { .name = "cortex-a15",  .initfn = cortex_a15_initfn },
-    { .name = "ti925t",      .initfn = ti925t_initfn },
-    { .name = "sa1100",      .initfn = sa1100_initfn },
-    { .name = "sa1110",      .initfn = sa1110_initfn },
     { .name = "pxa250",      .initfn = pxa250_initfn },
     { .name = "pxa255",      .initfn = pxa255_initfn },
     { .name = "pxa260",      .initfn = pxa260_initfn },
diff --git a/target/arm/cpu_v4.c b/target/arm/cpu_v4.c
new file mode 100644
index 0000000000..1de00a03ee
--- /dev/null
+++ b/target/arm/cpu_v4.c
@@ -0,0 +1,65 @@
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
+static void ti925t_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    set_feature(&cpu->env, ARM_FEATURE_V4T);
+    set_feature(&cpu->env, ARM_FEATURE_OMAPCP);
+    cpu->midr = ARM_CPUID_TI925T;
+    cpu->ctr = 0x5109149;
+    cpu->reset_sctlr = 0x00000070;
+}
+
+static void sa1100_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "intel,sa1100";
+    set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    cpu->midr = 0x4401A11B;
+    cpu->reset_sctlr = 0x00000070;
+}
+
+static void sa1110_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    cpu->midr = 0x6901B119;
+    cpu->reset_sctlr = 0x00000070;
+}
+
+static const ARMCPUInfo arm_v4_cpus[] = {
+    { .name = "ti925t",      .initfn = ti925t_initfn },
+    { .name = "sa1100",      .initfn = sa1100_initfn },
+    { .name = "sa1110",      .initfn = sa1110_initfn },
+    { .name = NULL }
+};
+
+static void arm_v4_cpu_register_types(void)
+{
+    const ARMCPUInfo *info = arm_v4_cpus;
+
+    while (info->name) {
+        arm_cpu_register(info);
+        info++;
+    }
+}
+
+type_init(arm_v4_cpu_register_types)
+
+#endif
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index e3d7e7694a..7fc0cff776 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -28,6 +28,7 @@ config ARM_VIRT
 
 config CHEETAH
     bool
+    select ARM_V4
     select OMAP
     select TSC210X
 
@@ -242,6 +243,7 @@ config COLLIE
 
 config SX1
     bool
+    select ARM_V4
     select OMAP
 
 config VERSATILE
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index e68c71a6ff..0d496d318a 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -1,2 +1,6 @@
+config ARM_V4
+    depends on TCG
+    bool
+
 config ARM_V7M
     bool
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index fa278bb4c1..bc0f63ebbc 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -68,6 +68,8 @@ obj-y += crypto_helper.o
 obj-y += iwmmxt_helper.o vec_helper.o neon_helper.o
 obj-y += m_helper.o
 
+obj-$(CONFIG_ARM_V4) += cpu_v4.o
+
 obj-$(CONFIG_SOFTMMU) += psci.o
 
 obj-$(TARGET_AARCH64) += translate-a64.o helper-a64.o
-- 
2.21.1

