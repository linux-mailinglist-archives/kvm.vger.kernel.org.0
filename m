Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BE4186FC1
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732057AbgCPQOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52082 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732042AbgCPQOI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dfDnran3E3vJVzOwh1qQwExgfNmDOU0PLsSJKRIuHk=;
        b=h/RNaxcIdC6WuLrzZcV6pabIH0dFhy4ICMTs6l8iZ+PwS0cRFDZA3xtXKOWG/PF4faynVZ
        p8ANWsvGHUIEiFYrX8xgRRJDAjDt2BTfgxs/O0xFt4Y0PwuYl4GhFawQrnsW418EbFGaGd
        yVi6BMl5Jdp0tcrOlQ/pYwITYJShUDU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-v9GxkLPgOnOuvfFri4MKtg-1; Mon, 16 Mar 2020 12:07:58 -0400
X-MC-Unique: v9GxkLPgOnOuvfFri4MKtg-1
Received: by mail-wm1-f69.google.com with SMTP id f207so5991238wme.6
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2dfDnran3E3vJVzOwh1qQwExgfNmDOU0PLsSJKRIuHk=;
        b=p9SEIApwHIVfQI3j1QTb1PSwTdn/YpFdonyFLyEyXEyE16dKn2PxRjgp8PKbBwsCJy
         TeOiraJeb875WkXfBYH/778CgE78IC9gzKQYbJcrb8Rseh6IZVl6BuO4pOfvctoGEreK
         eBJjk4+g2wHZJQroWLnVxlqB+CiBuRG+56Z0oTopX62+PtJvrT9pO1O9ocB0V+gRIhG6
         XRSucx0XlwJNCQqmnoqYDHGYgdOZWikRg3MC7bCvKK+H5MsGm14MP8NRbUuPVTmlWGLC
         W9UoIDuSIckLUDgTOeYNghzulIwO8FALIaP+9sdg2Xfe6ei0Kn8AAmnn15BV1Y81hrE9
         0kDg==
X-Gm-Message-State: ANhLgQ3izfyqeLSw405aFYYV7oPfZ7RfcU33D01xSHL105RvWO7HLqr6
        Vv1hrUDS6syj6/xG9+ziJMkDma9PLmnnxbmJcKjvjw8y94AyWzbHyMRjwym7HI6GcChc1bAtOCx
        adL/bSFYugXBx
X-Received: by 2002:a1c:a70f:: with SMTP id q15mr29224309wme.66.1584374875543;
        Mon, 16 Mar 2020 09:07:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvvUsowZLHDxnYfDB3bDiW71se1HIHUXOcWI+nMKioBIiFsS1gl8oiiU5/RpwkxKCUDyY8mEA==
X-Received: by 2002:a1c:a70f:: with SMTP id q15mr29224211wme.66.1584374874213;
        Mon, 16 Mar 2020 09:07:54 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id u25sm215843wml.17.2020.03.16.09.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 14/19] target/arm: Restrict ARMv7 M-profile cpus to TCG accel
Date:   Mon, 16 Mar 2020 17:06:29 +0100
Message-Id: <20200316160634.3386-15-philmd@redhat.com>
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

A KVM-only build won't be able to run M-profile cpus.

Only enable the following ARMv7 M-Profile CPUs when TCG is available:

  - Cortex-M3
  - Cortex-M4
  - Cortex-M33

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak |   8 --
 target/arm/cpu.c                | 176 ---------------------------
 target/arm/cpu_v7m.c            | 207 ++++++++++++++++++++++++++++++++
 target/arm/Kconfig              |   1 +
 target/arm/Makefile.objs        |   1 +
 5 files changed, 209 insertions(+), 184 deletions(-)
 create mode 100644 target/arm/cpu_v7m.c

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 3aa27f3b40..511d74da58 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -12,19 +12,11 @@ CONFIG_ARM_V7M=y
 CONFIG_ARM_VIRT=y
 CONFIG_CUBIEBOARD=y
 CONFIG_EXYNOS4=y
-CONFIG_HIGHBANK=y
-CONFIG_MUSCA=y
-CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
 CONFIG_VEXPRESS=y
 CONFIG_ZYNQ=y
-CONFIG_NETDUINO2=y
-CONFIG_NETDUINOPLUS2=y
-CONFIG_MPS2=y
 CONFIG_RASPI=y
 CONFIG_SABRELITE=y
-CONFIG_EMCRAFT_SF2=y
-CONFIG_MICROBIT=y
 CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
 CONFIG_ALLWINNER_H3=y
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 84be8792f6..dfa7e64c7e 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -573,31 +573,6 @@ bool arm_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     return true;
 }
 
-#if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
-static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
-{
-    CPUClass *cc = CPU_GET_CLASS(cs);
-    ARMCPU *cpu = ARM_CPU(cs);
-    CPUARMState *env = &cpu->env;
-    bool ret = false;
-
-    /* ARMv7-M interrupt masking works differently than -A or -R.
-     * There is no FIQ/IRQ distinction. Instead of I and F bits
-     * masking FIQ and IRQ interrupts, an exception is taken only
-     * if it is higher priority than the current execution priority
-     * (which depends on state like BASEPRI, FAULTMASK and the
-     * currently active exception).
-     */
-    if (interrupt_request & CPU_INTERRUPT_HARD
-        && (armv7m_nvic_can_take_pending_exception(env->nvic))) {
-        cs->exception_index = EXCP_IRQ;
-        cc->do_interrupt(cs);
-        ret = true;
-    }
-    return ret;
-}
-#endif
-
 void arm_cpu_update_virq(ARMCPU *cpu)
 {
     /*
@@ -1834,147 +1809,6 @@ static ObjectClass *arm_cpu_class_by_name(const char *cpu_model)
 /* CPU models. These are not needed for the AArch64 linux-user build. */
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
 
-static void cortex_m0_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-    set_feature(&cpu->env, ARM_FEATURE_V6);
-    set_feature(&cpu->env, ARM_FEATURE_M);
-
-    cpu->midr = 0x410cc200;
-}
-
-static void cortex_m3_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-    set_feature(&cpu->env, ARM_FEATURE_V7);
-    set_feature(&cpu->env, ARM_FEATURE_M);
-    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
-    cpu->midr = 0x410fc231;
-    cpu->pmsav7_dregion = 8;
-    cpu->id_pfr0 = 0x00000030;
-    cpu->id_pfr1 = 0x00000200;
-    cpu->isar.id_dfr0 = 0x00100000;
-    cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00000030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x00000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
-    cpu->isar.id_isar0 = 0x01141110;
-    cpu->isar.id_isar1 = 0x02111000;
-    cpu->isar.id_isar2 = 0x21112231;
-    cpu->isar.id_isar3 = 0x01111110;
-    cpu->isar.id_isar4 = 0x01310102;
-    cpu->isar.id_isar5 = 0x00000000;
-    cpu->isar.id_isar6 = 0x00000000;
-}
-
-static void cortex_m4_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    set_feature(&cpu->env, ARM_FEATURE_V7);
-    set_feature(&cpu->env, ARM_FEATURE_M);
-    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
-    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x410fc240; /* r0p0 */
-    cpu->pmsav7_dregion = 8;
-    cpu->isar.mvfr0 = 0x10110021;
-    cpu->isar.mvfr1 = 0x11000011;
-    cpu->isar.mvfr2 = 0x00000000;
-    cpu->id_pfr0 = 0x00000030;
-    cpu->id_pfr1 = 0x00000200;
-    cpu->isar.id_dfr0 = 0x00100000;
-    cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00000030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x00000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
-    cpu->isar.id_isar0 = 0x01141110;
-    cpu->isar.id_isar1 = 0x02111000;
-    cpu->isar.id_isar2 = 0x21112231;
-    cpu->isar.id_isar3 = 0x01111110;
-    cpu->isar.id_isar4 = 0x01310102;
-    cpu->isar.id_isar5 = 0x00000000;
-    cpu->isar.id_isar6 = 0x00000000;
-}
-
-static void cortex_m7_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    set_feature(&cpu->env, ARM_FEATURE_V7);
-    set_feature(&cpu->env, ARM_FEATURE_M);
-    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
-    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x411fc272; /* r1p2 */
-    cpu->pmsav7_dregion = 8;
-    cpu->isar.mvfr0 = 0x10110221;
-    cpu->isar.mvfr1 = 0x12000011;
-    cpu->isar.mvfr2 = 0x00000040;
-    cpu->id_pfr0 = 0x00000030;
-    cpu->id_pfr1 = 0x00000200;
-    cpu->isar.id_dfr0 = 0x00100000;
-    cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00100030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
-    cpu->isar.id_isar0 = 0x01101110;
-    cpu->isar.id_isar1 = 0x02112000;
-    cpu->isar.id_isar2 = 0x20232231;
-    cpu->isar.id_isar3 = 0x01111131;
-    cpu->isar.id_isar4 = 0x01310132;
-    cpu->isar.id_isar5 = 0x00000000;
-    cpu->isar.id_isar6 = 0x00000000;
-}
-
-static void cortex_m33_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    set_feature(&cpu->env, ARM_FEATURE_V8);
-    set_feature(&cpu->env, ARM_FEATURE_M);
-    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
-    set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
-    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x410fd213; /* r0p3 */
-    cpu->pmsav7_dregion = 16;
-    cpu->sau_sregion = 8;
-    cpu->isar.mvfr0 = 0x10110021;
-    cpu->isar.mvfr1 = 0x11000011;
-    cpu->isar.mvfr2 = 0x00000040;
-    cpu->id_pfr0 = 0x00000030;
-    cpu->id_pfr1 = 0x00000210;
-    cpu->isar.id_dfr0 = 0x00200000;
-    cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00101F40;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
-    cpu->isar.id_isar0 = 0x01101110;
-    cpu->isar.id_isar1 = 0x02212000;
-    cpu->isar.id_isar2 = 0x20232232;
-    cpu->isar.id_isar3 = 0x01111131;
-    cpu->isar.id_isar4 = 0x01310132;
-    cpu->isar.id_isar5 = 0x00000000;
-    cpu->isar.id_isar6 = 0x00000000;
-    cpu->clidr = 0x00000000;
-    cpu->ctr = 0x8000c000;
-}
-
-static void arm_v7m_class_init(ObjectClass *oc, void *data)
-{
-    ARMCPUClass *acc = ARM_CPU_CLASS(oc);
-    CPUClass *cc = CPU_CLASS(oc);
-
-    acc->info = data;
-#ifndef CONFIG_USER_ONLY
-    cc->do_interrupt = arm_v7m_cpu_do_interrupt;
-#endif
-
-    cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
-}
-
 static const ARMCPRegInfo cortexa8_cp_reginfo[] = {
     { .name = "L2LOCKDOWN", .cp = 15, .crn = 9, .crm = 0, .opc1 = 1, .opc2 = 0,
       .access = PL1_RW, .type = ARM_CP_CONST, .resetvalue = 0 },
@@ -2274,16 +2108,6 @@ static void arm_max_initfn(Object *obj)
 
 static const ARMCPUInfo arm_cpus[] = {
 #if !defined(CONFIG_USER_ONLY) || !defined(TARGET_AARCH64)
-    { .name = "cortex-m0",   .initfn = cortex_m0_initfn,
-                             .class_init = arm_v7m_class_init },
-    { .name = "cortex-m3",   .initfn = cortex_m3_initfn,
-                             .class_init = arm_v7m_class_init },
-    { .name = "cortex-m4",   .initfn = cortex_m4_initfn,
-                             .class_init = arm_v7m_class_init },
-    { .name = "cortex-m7",   .initfn = cortex_m7_initfn,
-                             .class_init = arm_v7m_class_init },
-    { .name = "cortex-m33",  .initfn = cortex_m33_initfn,
-                             .class_init = arm_v7m_class_init },
     { .name = "cortex-a7",   .initfn = cortex_a7_initfn },
     { .name = "cortex-a8",   .initfn = cortex_a8_initfn },
     { .name = "cortex-a9",   .initfn = cortex_a9_initfn },
diff --git a/target/arm/cpu_v7m.c b/target/arm/cpu_v7m.c
new file mode 100644
index 0000000000..529259b9cd
--- /dev/null
+++ b/target/arm/cpu_v7m.c
@@ -0,0 +1,207 @@
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
+static bool arm_v7m_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
+{
+    CPUClass *cc = CPU_GET_CLASS(cs);
+    ARMCPU *cpu = ARM_CPU(cs);
+    CPUARMState *env = &cpu->env;
+    bool ret = false;
+
+    /*
+     * ARMv7-M interrupt masking works differently than -A or -R.
+     * There is no FIQ/IRQ distinction. Instead of I and F bits
+     * masking FIQ and IRQ interrupts, an exception is taken only
+     * if it is higher priority than the current execution priority
+     * (which depends on state like BASEPRI, FAULTMASK and the
+     * currently active exception).
+     */
+    if (interrupt_request & CPU_INTERRUPT_HARD
+        && (armv7m_nvic_can_take_pending_exception(env->nvic))) {
+        cs->exception_index = EXCP_IRQ;
+        cc->do_interrupt(cs);
+        ret = true;
+    }
+    return ret;
+}
+
+static void cortex_m0_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    set_feature(&cpu->env, ARM_FEATURE_V6);
+    set_feature(&cpu->env, ARM_FEATURE_M);
+
+    cpu->midr = 0x410cc200;
+}
+
+static void cortex_m3_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    set_feature(&cpu->env, ARM_FEATURE_V7);
+    set_feature(&cpu->env, ARM_FEATURE_M);
+    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
+    cpu->midr = 0x410fc231;
+    cpu->pmsav7_dregion = 8;
+    cpu->id_pfr0 = 0x00000030;
+    cpu->id_pfr1 = 0x00000200;
+    cpu->isar.id_dfr0 = 0x00100000;
+    cpu->id_afr0 = 0x00000000;
+    cpu->isar.id_mmfr0 = 0x00000030;
+    cpu->isar.id_mmfr1 = 0x00000000;
+    cpu->isar.id_mmfr2 = 0x00000000;
+    cpu->isar.id_mmfr3 = 0x00000000;
+    cpu->isar.id_isar0 = 0x01141110;
+    cpu->isar.id_isar1 = 0x02111000;
+    cpu->isar.id_isar2 = 0x21112231;
+    cpu->isar.id_isar3 = 0x01111110;
+    cpu->isar.id_isar4 = 0x01310102;
+    cpu->isar.id_isar5 = 0x00000000;
+    cpu->isar.id_isar6 = 0x00000000;
+}
+
+static void cortex_m4_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    set_feature(&cpu->env, ARM_FEATURE_V7);
+    set_feature(&cpu->env, ARM_FEATURE_M);
+    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
+    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
+    cpu->midr = 0x410fc240; /* r0p0 */
+    cpu->pmsav7_dregion = 8;
+    cpu->isar.mvfr0 = 0x10110021;
+    cpu->isar.mvfr1 = 0x11000011;
+    cpu->isar.mvfr2 = 0x00000000;
+    cpu->id_pfr0 = 0x00000030;
+    cpu->id_pfr1 = 0x00000200;
+    cpu->isar.id_dfr0 = 0x00100000;
+    cpu->id_afr0 = 0x00000000;
+    cpu->isar.id_mmfr0 = 0x00000030;
+    cpu->isar.id_mmfr1 = 0x00000000;
+    cpu->isar.id_mmfr2 = 0x00000000;
+    cpu->isar.id_mmfr3 = 0x00000000;
+    cpu->isar.id_isar0 = 0x01141110;
+    cpu->isar.id_isar1 = 0x02111000;
+    cpu->isar.id_isar2 = 0x21112231;
+    cpu->isar.id_isar3 = 0x01111110;
+    cpu->isar.id_isar4 = 0x01310102;
+    cpu->isar.id_isar5 = 0x00000000;
+    cpu->isar.id_isar6 = 0x00000000;
+}
+
+static void cortex_m7_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    set_feature(&cpu->env, ARM_FEATURE_V7);
+    set_feature(&cpu->env, ARM_FEATURE_M);
+    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
+    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
+    cpu->midr = 0x411fc272; /* r1p2 */
+    cpu->pmsav7_dregion = 8;
+    cpu->isar.mvfr0 = 0x10110221;
+    cpu->isar.mvfr1 = 0x12000011;
+    cpu->isar.mvfr2 = 0x00000040;
+    cpu->id_pfr0 = 0x00000030;
+    cpu->id_pfr1 = 0x00000200;
+    cpu->isar.id_dfr0 = 0x00100000;
+    cpu->id_afr0 = 0x00000000;
+    cpu->isar.id_mmfr0 = 0x00100030;
+    cpu->isar.id_mmfr1 = 0x00000000;
+    cpu->isar.id_mmfr2 = 0x01000000;
+    cpu->isar.id_mmfr3 = 0x00000000;
+    cpu->isar.id_isar0 = 0x01101110;
+    cpu->isar.id_isar1 = 0x02112000;
+    cpu->isar.id_isar2 = 0x20232231;
+    cpu->isar.id_isar3 = 0x01111131;
+    cpu->isar.id_isar4 = 0x01310132;
+    cpu->isar.id_isar5 = 0x00000000;
+    cpu->isar.id_isar6 = 0x00000000;
+}
+
+static void cortex_m33_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    set_feature(&cpu->env, ARM_FEATURE_V8);
+    set_feature(&cpu->env, ARM_FEATURE_M);
+    set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
+    set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
+    set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
+    cpu->midr = 0x410fd213; /* r0p3 */
+    cpu->pmsav7_dregion = 16;
+    cpu->sau_sregion = 8;
+    cpu->isar.mvfr0 = 0x10110021;
+    cpu->isar.mvfr1 = 0x11000011;
+    cpu->isar.mvfr2 = 0x00000040;
+    cpu->id_pfr0 = 0x00000030;
+    cpu->id_pfr1 = 0x00000210;
+    cpu->isar.id_dfr0 = 0x00200000;
+    cpu->id_afr0 = 0x00000000;
+    cpu->isar.id_mmfr0 = 0x00101F40;
+    cpu->isar.id_mmfr1 = 0x00000000;
+    cpu->isar.id_mmfr2 = 0x01000000;
+    cpu->isar.id_mmfr3 = 0x00000000;
+    cpu->isar.id_isar0 = 0x01101110;
+    cpu->isar.id_isar1 = 0x02212000;
+    cpu->isar.id_isar2 = 0x20232232;
+    cpu->isar.id_isar3 = 0x01111131;
+    cpu->isar.id_isar4 = 0x01310132;
+    cpu->isar.id_isar5 = 0x00000000;
+    cpu->isar.id_isar6 = 0x00000000;
+    cpu->clidr = 0x00000000;
+    cpu->ctr = 0x8000c000;
+}
+
+static void arm_v7m_class_init(ObjectClass *oc, void *data)
+{
+    ARMCPUClass *acc = ARM_CPU_CLASS(oc);
+    CPUClass *cc = CPU_CLASS(oc);
+
+    acc->info = data;
+#ifndef CONFIG_USER_ONLY
+    cc->do_interrupt = arm_v7m_cpu_do_interrupt;
+#endif
+
+    cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
+}
+
+static const ARMCPUInfo arm_v7m_cpus[] = {
+    { .name = "cortex-m0",   .initfn = cortex_m0_initfn,
+                             .class_init = arm_v7m_class_init },
+    { .name = "cortex-m3",   .initfn = cortex_m3_initfn,
+                             .class_init = arm_v7m_class_init },
+    { .name = "cortex-m4",   .initfn = cortex_m4_initfn,
+                             .class_init = arm_v7m_class_init },
+    { .name = "cortex-m7",   .initfn = cortex_m7_initfn,
+                             .class_init = arm_v7m_class_init },
+    { .name = "cortex-m33",  .initfn = cortex_m33_initfn,
+                             .class_init = arm_v7m_class_init },
+    { .name = NULL }
+};
+
+static void arm_v7m_cpu_register_types(void)
+{
+    const ARMCPUInfo *info = arm_v7m_cpus;
+
+    while (info->name) {
+        arm_cpu_register(info);
+        info++;
+    }
+}
+
+type_init(arm_v7m_cpu_register_types)
+
+#endif
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index 9768f9180f..929e252d89 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -15,4 +15,5 @@ config ARM_V7R
     bool
 
 config ARM_V7M
+    depends on TCG
     bool
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index a2508f0655..a0df58526b 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -72,6 +72,7 @@ obj-$(CONFIG_ARM_V4) += cpu_v4.o
 obj-$(CONFIG_ARM_V5) += cpu_v5.o
 obj-$(CONFIG_ARM_V6) += cpu_v6.o
 obj-$(CONFIG_ARM_V7R) += cpu_v7r.o
+obj-$(CONFIG_ARM_V7M) += cpu_v7m.o
 
 obj-$(CONFIG_SOFTMMU) += psci.o
 
-- 
2.21.1

