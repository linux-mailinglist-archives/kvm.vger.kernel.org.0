Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAB186FD0
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732077AbgCPQQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:16:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49248 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732036AbgCPQQE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UM67HGSwESPGxRuh3RiuHLraRXWOuFjnUtJ3FzN+nLQ=;
        b=crgjBQH8sPzF2rkQad3zrqLiEldMCZ8MP+qg2PPBXCIiKrqVf6hiSL6tFhbTcRXDMy46M9
        yyZtZ25gWEDNGlIK9z8lg4VEnO1rsgBaHER3bORBjEL1DvRgv+5H2jGrqWJPR/369FJxUO
        tesenLA9k9ylYCjEN77Cwxj7G8C2BY4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-X7U_cRTlPPGNuD_rtjc-OA-1; Mon, 16 Mar 2020 12:07:40 -0400
X-MC-Unique: X7U_cRTlPPGNuD_rtjc-OA-1
Received: by mail-wm1-f69.google.com with SMTP id f9so3240552wme.7
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UM67HGSwESPGxRuh3RiuHLraRXWOuFjnUtJ3FzN+nLQ=;
        b=eLGuRUQBHF81b6pSvISf+RbqYk4IiszdIwPkdAW0K7000NrxZLOExVvaKEBIh+i1vB
         s3dSVPLfDkK/XLHUv9fp5EJsE8mnf3VG+I0yALsToYulfruqEmE3x3Dg/1ewLy5JPHik
         q3HoV25TT0ETYNZizfppCbQqE3uG9xzJZSI/yxrUJBI4MNE/1dmqDi20qwNAOokp6nSF
         19gFEylaLxjW8Z/wUvTKe0ysXqdRLr28zSvho4FuaDuVHR12Vv5cJ1r93q1oYZk55iW/
         nYnFY7V2nJPe4hDtFVk1mzCR0RpWHFD1znlSbejbKv469mGofxhpma860OGUv5ZNIVjy
         CFxg==
X-Gm-Message-State: ANhLgQ0pU8cD7ee0Plw8aIvVuo7B0lVHKy6KELlmpXJqIdLMAq0O/Bkx
        J7HBiAhTm26EElTEnl3f0RuiL/IIX5wtvepqc3CsdS72CeAzhtmBGnRC0b9BjWtsYUmyB7vI1d1
        OgjAxgBWfYRCc
X-Received: by 2002:adf:83c4:: with SMTP id 62mr73134wre.105.1584374858400;
        Mon, 16 Mar 2020 09:07:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtXZX9N7W7nmymhGKQDv0dc2RHYo7/YhqqMhSWsSZSwUHWK8VJ3cRt1paRdEbEfaNcAsNZgcg==
X-Received: by 2002:adf:83c4:: with SMTP id 62mr73091wre.105.1584374857928;
        Mon, 16 Mar 2020 09:07:37 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id w204sm241548wma.1.2020.03.16.09.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:37 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 11/19] target/arm: Restrict ARMv5 cpus to TCG accel
Date:   Mon, 16 Mar 2020 17:06:26 +0100
Message-Id: <20200316160634.3386-12-philmd@redhat.com>
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

Only enable the following ARMv5 CPUs when TCG is available:

  - ARM926
  - ARM946
  - ARM1026
  - XScale (PXA250/255/260/261/262/270)

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak |  12 --
 target/arm/cpu.c                | 234 ----------------------------
 target/arm/cpu_v5.c             | 266 ++++++++++++++++++++++++++++++++
 hw/arm/Kconfig                  |   7 +
 target/arm/Kconfig              |   4 +
 target/arm/Makefile.objs        |   1 +
 6 files changed, 278 insertions(+), 246 deletions(-)
 create mode 100644 target/arm/cpu_v5.c

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 0652396296..f176a98296 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -13,32 +13,20 @@ CONFIG_ARM_VIRT=y
 CONFIG_CUBIEBOARD=y
 CONFIG_EXYNOS4=y
 CONFIG_HIGHBANK=y
-CONFIG_INTEGRATOR=y
 CONFIG_FSL_IMX31=y
-CONFIG_MUSICPAL=y
 CONFIG_MUSCA=y
 CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
-CONFIG_VERSATILE=y
 CONFIG_VEXPRESS=y
 CONFIG_ZYNQ=y
-CONFIG_MAINSTONE=y
-CONFIG_GUMSTIX=y
-CONFIG_SPITZ=y
-CONFIG_TOSA=y
-CONFIG_Z2=y
-CONFIG_COLLIE=y
-CONFIG_ASPEED_SOC=y
 CONFIG_NETDUINO2=y
 CONFIG_NETDUINOPLUS2=y
 CONFIG_MPS2=y
 CONFIG_RASPI=y
-CONFIG_DIGIC=y
 CONFIG_SABRELITE=y
 CONFIG_EMCRAFT_SF2=y
 CONFIG_MICROBIT=y
-CONFIG_FSL_IMX25=y
 CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
 CONFIG_ALLWINNER_H3=y
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index b08b6933be..f1d1ba8451 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1834,86 +1834,6 @@ static ObjectClass *arm_cpu_class_by_name(const char *cpu_model)
 /* CPU models. These are not needed for the AArch64 linux-user build. */
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
 
-static void arm926_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm926";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
-    cpu->midr = 0x41069265;
-    cpu->reset_fpsid = 0x41011090;
-    cpu->ctr = 0x1dd20d2;
-    cpu->reset_sctlr = 0x00090078;
-
-    /*
-     * ARMv5 does not have the ID_ISAR registers, but we can still
-     * set the field to indicate Jazelle support within QEMU.
-     */
-    cpu->isar.id_isar1 = FIELD_DP32(cpu->isar.id_isar1, ID_ISAR1, JAZELLE, 1);
-    /*
-     * Similarly, we need to set MVFR0 fields to enable vfp and short vector
-     * support even though ARMv5 doesn't have this register.
-     */
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSHVEC, 1);
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSP, 1);
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPDP, 1);
-}
-
-static void arm946_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm946";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_PMSA);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x41059461;
-    cpu->ctr = 0x0f004006;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void arm1026_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "arm,arm1026";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_AUXCR);
-    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
-    cpu->midr = 0x4106a262;
-    cpu->reset_fpsid = 0x410110a0;
-    cpu->ctr = 0x1dd20d2;
-    cpu->reset_sctlr = 0x00090078;
-    cpu->reset_auxcr = 1;
-
-    /*
-     * ARMv5 does not have the ID_ISAR registers, but we can still
-     * set the field to indicate Jazelle support within QEMU.
-     */
-    cpu->isar.id_isar1 = FIELD_DP32(cpu->isar.id_isar1, ID_ISAR1, JAZELLE, 1);
-    /*
-     * Similarly, we need to set MVFR0 fields to enable vfp and short vector
-     * support even though ARMv5 doesn't have this register.
-     */
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSHVEC, 1);
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSP, 1);
-    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPDP, 1);
-
-    {
-        /* The 1026 had an IFAR at c6,c0,0,1 rather than the ARMv6 c6,c0,0,2 */
-        ARMCPRegInfo ifar = {
-            .name = "IFAR", .cp = 15, .crn = 6, .crm = 0, .opc1 = 0, .opc2 = 1,
-            .access = PL1_RW,
-            .fieldoffset = offsetof(CPUARMState, cp15.ifar_ns),
-            .resetvalue = 0
-        };
-        define_one_arm_cp_reg(cpu, &ifar);
-    }
-}
-
 static void arm1136_r2_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -2459,144 +2379,6 @@ static void cortex_a15_initfn(Object *obj)
     define_arm_cp_regs(cpu, cortexa15_cp_reginfo);
 }
 
-static void pxa250_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    cpu->midr = 0x69052100;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa255_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    cpu->midr = 0x69052d00;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa260_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    cpu->midr = 0x69052903;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa261_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    cpu->midr = 0x69052d05;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa262_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    cpu->midr = 0x69052d06;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270a0_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054110;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270a1_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054111;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270b0_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054112;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270b1_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054113;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270c0_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054114;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
-static void pxa270c5_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cpu->dtb_compatible = "marvell,xscale";
-    set_feature(&cpu->env, ARM_FEATURE_V5);
-    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
-    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
-    cpu->midr = 0x69054117;
-    cpu->ctr = 0xd172172;
-    cpu->reset_sctlr = 0x00000078;
-}
-
 #ifndef TARGET_AARCH64
 /* -cpu max: if KVM is enabled, like -cpu host (best possible with this host);
  * otherwise, a CPU with as many features enabled as our emulation supports.
@@ -2670,9 +2452,6 @@ static void arm_max_initfn(Object *obj)
 
 static const ARMCPUInfo arm_cpus[] = {
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
-    { .name = "arm926",      .initfn = arm926_initfn },
-    { .name = "arm946",      .initfn = arm946_initfn },
-    { .name = "arm1026",     .initfn = arm1026_initfn },
     /* What QEMU calls "arm1136-r2" is actually the 1136 r0p2, i.e. an
      * older core than plain "arm1136". In particular this does not
      * have the v6K features.
@@ -2697,19 +2476,6 @@ static const ARMCPUInfo arm_cpus[] = {
     { .name = "cortex-a8",   .initfn = cortex_a8_initfn },
     { .name = "cortex-a9",   .initfn = cortex_a9_initfn },
     { .name = "cortex-a15",  .initfn = cortex_a15_initfn },
-    { .name = "pxa250",      .initfn = pxa250_initfn },
-    { .name = "pxa255",      .initfn = pxa255_initfn },
-    { .name = "pxa260",      .initfn = pxa260_initfn },
-    { .name = "pxa261",      .initfn = pxa261_initfn },
-    { .name = "pxa262",      .initfn = pxa262_initfn },
-    /* "pxa270" is an alias for "pxa270-a0" */
-    { .name = "pxa270",      .initfn = pxa270a0_initfn },
-    { .name = "pxa270-a0",   .initfn = pxa270a0_initfn },
-    { .name = "pxa270-a1",   .initfn = pxa270a1_initfn },
-    { .name = "pxa270-b0",   .initfn = pxa270b0_initfn },
-    { .name = "pxa270-b1",   .initfn = pxa270b1_initfn },
-    { .name = "pxa270-c0",   .initfn = pxa270c0_initfn },
-    { .name = "pxa270-c5",   .initfn = pxa270c5_initfn },
 #ifndef TARGET_AARCH64
     { .name = "max",         .initfn = arm_max_initfn },
 #endif
diff --git a/target/arm/cpu_v5.c b/target/arm/cpu_v5.c
new file mode 100644
index 0000000000..7a231ef649
--- /dev/null
+++ b/target/arm/cpu_v5.c
@@ -0,0 +1,266 @@
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
+static void arm926_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm926";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
+    cpu->midr = 0x41069265;
+    cpu->reset_fpsid = 0x41011090;
+    cpu->ctr = 0x1dd20d2;
+    cpu->reset_sctlr = 0x00090078;
+
+    /*
+     * ARMv5 does not have the ID_ISAR registers, but we can still
+     * set the field to indicate Jazelle support within QEMU.
+     */
+    cpu->isar.id_isar1 = FIELD_DP32(cpu->isar.id_isar1, ID_ISAR1, JAZELLE, 1);
+    /*
+     * Similarly, we need to set MVFR0 fields to enable vfp and short vector
+     * support even though ARMv5 doesn't have this register.
+     */
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSHVEC, 1);
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSP, 1);
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPDP, 1);
+}
+
+static void arm946_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm946";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_PMSA);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    cpu->midr = 0x41059461;
+    cpu->ctr = 0x0f004006;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void arm1026_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "arm,arm1026";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_AUXCR);
+    set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
+    set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
+    cpu->midr = 0x4106a262;
+    cpu->reset_fpsid = 0x410110a0;
+    cpu->ctr = 0x1dd20d2;
+    cpu->reset_sctlr = 0x00090078;
+    cpu->reset_auxcr = 1;
+
+    /*
+     * ARMv5 does not have the ID_ISAR registers, but we can still
+     * set the field to indicate Jazelle support within QEMU.
+     */
+    cpu->isar.id_isar1 = FIELD_DP32(cpu->isar.id_isar1, ID_ISAR1, JAZELLE, 1);
+    /*
+     * Similarly, we need to set MVFR0 fields to enable vfp and short vector
+     * support even though ARMv5 doesn't have this register.
+     */
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSHVEC, 1);
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPSP, 1);
+    cpu->isar.mvfr0 = FIELD_DP32(cpu->isar.mvfr0, MVFR0, FPDP, 1);
+
+    {
+        /* The 1026 had an IFAR at c6,c0,0,1 rather than the ARMv6 c6,c0,0,2 */
+        ARMCPRegInfo ifar = {
+            .name = "IFAR", .cp = 15, .crn = 6, .crm = 0, .opc1 = 0, .opc2 = 1,
+            .access = PL1_RW,
+            .fieldoffset = offsetof(CPUARMState, cp15.ifar_ns),
+            .resetvalue = 0
+        };
+        define_one_arm_cp_reg(cpu, &ifar);
+    }
+}
+
+static void pxa250_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    cpu->midr = 0x69052100;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa255_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    cpu->midr = 0x69052d00;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa260_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    cpu->midr = 0x69052903;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa261_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    cpu->midr = 0x69052d05;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa262_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    cpu->midr = 0x69052d06;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270a0_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054110;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270a1_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054111;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270b0_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054112;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270b1_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054113;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270c0_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054114;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static void pxa270c5_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cpu->dtb_compatible = "marvell,xscale";
+    set_feature(&cpu->env, ARM_FEATURE_V5);
+    set_feature(&cpu->env, ARM_FEATURE_XSCALE);
+    set_feature(&cpu->env, ARM_FEATURE_IWMMXT);
+    cpu->midr = 0x69054117;
+    cpu->ctr = 0xd172172;
+    cpu->reset_sctlr = 0x00000078;
+}
+
+static const ARMCPUInfo arm_v5_cpus[] = {
+    { .name = "arm926",      .initfn = arm926_initfn },
+    { .name = "arm946",      .initfn = arm946_initfn },
+    { .name = "arm1026",     .initfn = arm1026_initfn },
+    { .name = "pxa250",      .initfn = pxa250_initfn },
+    { .name = "pxa255",      .initfn = pxa255_initfn },
+    { .name = "pxa260",      .initfn = pxa260_initfn },
+    { .name = "pxa261",      .initfn = pxa261_initfn },
+    { .name = "pxa262",      .initfn = pxa262_initfn },
+    /* "pxa270" is an alias for "pxa270-a0" */
+    { .name = "pxa270",      .initfn = pxa270a0_initfn },
+    { .name = "pxa270-a0",   .initfn = pxa270a0_initfn },
+    { .name = "pxa270-a1",   .initfn = pxa270a1_initfn },
+    { .name = "pxa270-b0",   .initfn = pxa270b0_initfn },
+    { .name = "pxa270-b1",   .initfn = pxa270b1_initfn },
+    { .name = "pxa270-c0",   .initfn = pxa270c0_initfn },
+    { .name = "pxa270-c5",   .initfn = pxa270c5_initfn },
+    { .name = NULL }
+};
+
+static void arm_v5_cpu_register_types(void)
+{
+    const ARMCPUInfo *info = arm_v5_cpus;
+
+    while (info->name) {
+        arm_cpu_register(info);
+        info++;
+    }
+}
+
+type_init(arm_v5_cpu_register_types)
+
+#endif
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 7fc0cff776..3b78471de0 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -38,6 +38,7 @@ config CUBIEBOARD
 
 config DIGIC
     bool
+    select ARM_V5
     select PTIMER
     select PFLASH_CFI02
 
@@ -67,6 +68,7 @@ config HIGHBANK
 
 config INTEGRATOR
     bool
+    select ARM_V5
     select ARM_TIMER
     select INTEGRATOR_DEBUG
     select PL011 # UART
@@ -93,6 +95,7 @@ config MUSCA
 
 config MUSICPAL
     bool
+    select ARM_V5
     select BITBANG_I2C
     select MARVELL_88W8618
     select PTIMER
@@ -132,6 +135,7 @@ config OMAP
 
 config PXA2XX
     bool
+    select ARM_V5
     select FRAMEBUFFER
     select I2C
     select SERIAL
@@ -248,6 +252,7 @@ config SX1
 
 config VERSATILE
     bool
+    select ARM_V5
     select ARM_TIMER # sp804
     select PFLASH_CFI01
     select LSI_SCSI_PCI
@@ -354,6 +359,7 @@ config XLNX_VERSAL
 
 config FSL_IMX25
     bool
+    select ARM_V5
     select IMX
     select IMX_FEC
     select IMX_I2C
@@ -376,6 +382,7 @@ config FSL_IMX6
 
 config ASPEED_SOC
     bool
+    select ARM_V5
     select DS1338
     select FTGMAC100
     select I2C
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index 0d496d318a..028d8382fe 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -2,5 +2,9 @@ config ARM_V4
     depends on TCG
     bool
 
+config ARM_V5
+    depends on TCG
+    bool
+
 config ARM_V7M
     bool
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index bc0f63ebbc..f66f7f1158 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -69,6 +69,7 @@ obj-y += iwmmxt_helper.o vec_helper.o neon_helper.o
 obj-y += m_helper.o
 
 obj-$(CONFIG_ARM_V4) += cpu_v4.o
+obj-$(CONFIG_ARM_V5) += cpu_v5.o
 
 obj-$(CONFIG_SOFTMMU) += psci.o
 
-- 
2.21.1

