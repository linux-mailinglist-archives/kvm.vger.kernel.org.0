Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6865B186FCE
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgCPQQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:16:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22891 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732021AbgCPQQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:16:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruq5flSyrIJQ0ARl8BHVFpMVJrCuW/pkqeZBiZJSNHg=;
        b=KCglB/pK8QUOhHk7/3NFHSG0h9/UGSU4ZnsWatuco8FgS+8CAH7UX0sMnjTKX6J3A1MVm4
        smQs8xiPXTy/MB5MerOeAovzXnclEQEPrQuF00l7nGehUiOriWoi8N0Y3qhsaR1Ss6wQy5
        bxCqSHFSxq90/qKah3+Obks4bKj97rI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-WZ9kpkZ5MUKHN4a3UUHkrg-1; Mon, 16 Mar 2020 12:07:50 -0400
X-MC-Unique: WZ9kpkZ5MUKHN4a3UUHkrg-1
Received: by mail-wr1-f71.google.com with SMTP id w11so9254638wrp.20
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruq5flSyrIJQ0ARl8BHVFpMVJrCuW/pkqeZBiZJSNHg=;
        b=Gy+4qJSORUwBUhkgSFWxIvDAYZKUkd1gTshy2adX1s4U0WnVic3kcFhatJLL2b6JLl
         ftBiufG+rBdbZFfxYwIHAOZCxRpP7UBb5NYXWgn7z6tFpm4zokR/BDo6HExwk6q9dG01
         paa/slJv7N25W4i/UtHaMB9T8ycoVRp4J77Ia2iLRmB0HSTimGaAWNrX6ys0PyMOZYzv
         OyjXmNNcjBdBRjeg43peyEa/S7h5WdwIMYEeMREdqu4F3E2TWEMMjSdI80QW5iYfzsnl
         VkhpLCDFtffm3qrVonR3C90JVpFUBSVN1kS4trjUIbabI3Nwz6Tchy8t7YUu3ky+RTsY
         wdzw==
X-Gm-Message-State: ANhLgQ1uR0bvxQwwjIsUPcTDebOtbE2LSwXxCHBLX1fi4PrwUVwngqpT
        HzeezqQaP8/PzIlymh+6oJHuq1BnR+TVKDbRuUrOyD5jHhVJWj5pM9HyGGQZF0EyoCHkvT05+Xn
        6IAvy/rLE8ays
X-Received: by 2002:a5d:5089:: with SMTP id a9mr63910wrt.187.1584374869131;
        Mon, 16 Mar 2020 09:07:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsH9erD+/AzduZt6/2G1VOVoVwqiEnP7oEPNYJjE5gdXKGGdo2hHizz2wb54XtGoBPo2ebMbQ==
X-Received: by 2002:a5d:5089:: with SMTP id a9mr63883wrt.187.1584374868815;
        Mon, 16 Mar 2020 09:07:48 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id k9sm494508wrd.74.2020.03.16.09.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:48 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 13/19] target/arm: Restrict ARMv7 R-profile cpus to TCG accel
Date:   Mon, 16 Mar 2020 17:06:28 +0100
Message-Id: <20200316160634.3386-14-philmd@redhat.com>
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

A KVM-only build won't be able to run R-profile cpus.

Only enable the following ARMv7 R-Profile CPUs when TCG is available:

  - Cortex-R5
  - Cortex-R5F

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/aarch64-softmmu.mak |  1 -
 target/arm/cpu.c                    | 51 ------------------
 target/arm/cpu_v7r.c                | 83 +++++++++++++++++++++++++++++
 hw/arm/Kconfig                      |  1 +
 target/arm/Kconfig                  |  4 ++
 target/arm/Makefile.objs            |  1 +
 6 files changed, 89 insertions(+), 52 deletions(-)
 create mode 100644 target/arm/cpu_v7r.c

diff --git a/default-configs/aarch64-softmmu.mak b/default-configs/aarch64-softmmu.mak
index 958b1e08e4..a4202f5681 100644
--- a/default-configs/aarch64-softmmu.mak
+++ b/default-configs/aarch64-softmmu.mak
@@ -3,6 +3,5 @@
 # We support all the 32 bit boards so need all their config
 include arm-softmmu.mak
 
-CONFIG_XLNX_ZYNQMP_ARM=y
 CONFIG_XLNX_VERSAL=y
 CONFIG_SBSA_REF=y
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 34908828a0..84be8792f6 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1975,55 +1975,6 @@ static void arm_v7m_class_init(ObjectClass *oc, void *data)
     cc->cpu_exec_interrupt = arm_v7m_cpu_exec_interrupt;
 }
 
-static const ARMCPRegInfo cortexr5_cp_reginfo[] = {
-    /* Dummy the TCM region regs for the moment */
-    { .name = "ATCM", .cp = 15, .opc1 = 0, .crn = 9, .crm = 1, .opc2 = 0,
-      .access = PL1_RW, .type = ARM_CP_CONST },
-    { .name = "BTCM", .cp = 15, .opc1 = 0, .crn = 9, .crm = 1, .opc2 = 1,
-      .access = PL1_RW, .type = ARM_CP_CONST },
-    { .name = "DCACHE_INVAL", .cp = 15, .opc1 = 0, .crn = 15, .crm = 5,
-      .opc2 = 0, .access = PL1_W, .type = ARM_CP_NOP },
-    REGINFO_SENTINEL
-};
-
-static void cortex_r5_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    set_feature(&cpu->env, ARM_FEATURE_V7);
-    set_feature(&cpu->env, ARM_FEATURE_V7MP);
-    set_feature(&cpu->env, ARM_FEATURE_PMSA);
-    set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->midr = 0x411fc153; /* r1p3 */
-    cpu->id_pfr0 = 0x0131;
-    cpu->id_pfr1 = 0x001;
-    cpu->isar.id_dfr0 = 0x010400;
-    cpu->id_afr0 = 0x0;
-    cpu->isar.id_mmfr0 = 0x0210030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01200000;
-    cpu->isar.id_mmfr3 = 0x0211;
-    cpu->isar.id_isar0 = 0x02101111;
-    cpu->isar.id_isar1 = 0x13112111;
-    cpu->isar.id_isar2 = 0x21232141;
-    cpu->isar.id_isar3 = 0x01112131;
-    cpu->isar.id_isar4 = 0x0010142;
-    cpu->isar.id_isar5 = 0x0;
-    cpu->isar.id_isar6 = 0x0;
-    cpu->mp_is_up = true;
-    cpu->pmsav7_dregion = 16;
-    define_arm_cp_regs(cpu, cortexr5_cp_reginfo);
-}
-
-static void cortex_r5f_initfn(Object *obj)
-{
-    ARMCPU *cpu = ARM_CPU(obj);
-
-    cortex_r5_initfn(obj);
-    cpu->isar.mvfr0 = 0x10110221;
-    cpu->isar.mvfr1 = 0x00000011;
-}
-
 static const ARMCPRegInfo cortexa8_cp_reginfo[] = {
     { .name = "L2LOCKDOWN", .cp = 15, .crn = 9, .crm = 0, .opc1 = 1, .opc2 = 0,
       .access = PL1_RW, .type = ARM_CP_CONST, .resetvalue = 0 },
@@ -2333,8 +2284,6 @@ static const ARMCPUInfo arm_cpus[] = {
                              .class_init = arm_v7m_class_init },
     { .name = "cortex-m33",  .initfn = cortex_m33_initfn,
                              .class_init = arm_v7m_class_init },
-    { .name = "cortex-r5",   .initfn = cortex_r5_initfn },
-    { .name = "cortex-r5f",  .initfn = cortex_r5f_initfn },
     { .name = "cortex-a7",   .initfn = cortex_a7_initfn },
     { .name = "cortex-a8",   .initfn = cortex_a8_initfn },
     { .name = "cortex-a9",   .initfn = cortex_a9_initfn },
diff --git a/target/arm/cpu_v7r.c b/target/arm/cpu_v7r.c
new file mode 100644
index 0000000000..9576844b5c
--- /dev/null
+++ b/target/arm/cpu_v7r.c
@@ -0,0 +1,83 @@
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
+static const ARMCPRegInfo cortexr5_cp_reginfo[] = {
+    /* Dummy the TCM region regs for the moment */
+    { .name = "ATCM", .cp = 15, .opc1 = 0, .crn = 9, .crm = 1, .opc2 = 0,
+      .access = PL1_RW, .type = ARM_CP_CONST },
+    { .name = "BTCM", .cp = 15, .opc1 = 0, .crn = 9, .crm = 1, .opc2 = 1,
+      .access = PL1_RW, .type = ARM_CP_CONST },
+    { .name = "DCACHE_INVAL", .cp = 15, .opc1 = 0, .crn = 15, .crm = 5,
+      .opc2 = 0, .access = PL1_W, .type = ARM_CP_NOP },
+    REGINFO_SENTINEL
+};
+
+static void cortex_r5_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    set_feature(&cpu->env, ARM_FEATURE_V7);
+    set_feature(&cpu->env, ARM_FEATURE_V7MP);
+    set_feature(&cpu->env, ARM_FEATURE_PMSA);
+    set_feature(&cpu->env, ARM_FEATURE_PMU);
+    cpu->midr = 0x411fc153; /* r1p3 */
+    cpu->id_pfr0 = 0x0131;
+    cpu->id_pfr1 = 0x001;
+    cpu->isar.id_dfr0 = 0x010400;
+    cpu->id_afr0 = 0x0;
+    cpu->isar.id_mmfr0 = 0x0210030;
+    cpu->isar.id_mmfr1 = 0x00000000;
+    cpu->isar.id_mmfr2 = 0x01200000;
+    cpu->isar.id_mmfr3 = 0x0211;
+    cpu->isar.id_isar0 = 0x02101111;
+    cpu->isar.id_isar1 = 0x13112111;
+    cpu->isar.id_isar2 = 0x21232141;
+    cpu->isar.id_isar3 = 0x01112131;
+    cpu->isar.id_isar4 = 0x0010142;
+    cpu->isar.id_isar5 = 0x0;
+    cpu->isar.id_isar6 = 0x0;
+    cpu->mp_is_up = true;
+    cpu->pmsav7_dregion = 16;
+    define_arm_cp_regs(cpu, cortexr5_cp_reginfo);
+}
+
+static void cortex_r5f_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    cortex_r5_initfn(obj);
+    cpu->isar.mvfr0 = 0x10110221;
+    cpu->isar.mvfr1 = 0x00000011;
+}
+
+static const ARMCPUInfo arm_v7r_cpus[] = {
+    { .name = "cortex-r5",   .initfn = cortex_r5_initfn },
+    { .name = "cortex-r5f",  .initfn = cortex_r5f_initfn },
+    { .name = NULL }
+};
+
+static void arm_v7r_cpu_register_types(void)
+{
+    const ARMCPUInfo *info = arm_v7r_cpus;
+
+    while (info->name) {
+        arm_cpu_register(info);
+        info++;
+    }
+}
+
+type_init(arm_v7r_cpu_register_types)
+
+#endif
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index e87dd611f2..d0903d8544 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -340,6 +340,7 @@ config XLNX_ZYNQMP_ARM
     bool
     select AHCI
     select ARM_GIC
+    select ARM_V7R
     select CADENCE
     select DDC
     select DPCD
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index df5f8dff42..9768f9180f 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -10,5 +10,9 @@ config ARM_V6
     depends on TCG
     bool
 
+config ARM_V7R
+    depends on TCG
+    bool
+
 config ARM_V7M
     bool
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index 0473c559c6..a2508f0655 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -71,6 +71,7 @@ obj-y += m_helper.o
 obj-$(CONFIG_ARM_V4) += cpu_v4.o
 obj-$(CONFIG_ARM_V5) += cpu_v5.o
 obj-$(CONFIG_ARM_V6) += cpu_v6.o
+obj-$(CONFIG_ARM_V7R) += cpu_v7r.o
 
 obj-$(CONFIG_SOFTMMU) += psci.o
 
-- 
2.21.1

