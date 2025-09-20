Return-Path: <kvm+bounces-58299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 943AEB8C9C4
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E4558321F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D9A2F546E;
	Sat, 20 Sep 2025 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Zc2EPRcY"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host10-snip4-1.eps.apple.com [57.103.86.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938D2AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376959; cv=none; b=nXxY9OCUd19xiW+Ioud+sV5WLoxwiIU3yrXmEmVhpR85O62ueMokwCOyIT8ztSVfx+vLf16/eQy/vYmIqg6zKLYQD1Gqa4FDb9RQ5HOsKgajpodDp4wYVJUrzd46ylRhg0OBzCtBnEfY+D1cLdE3MaV/dJu64//YAIdb/09R3l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376959; c=relaxed/simple;
	bh=MFk5AnL4z9nDFdpL0F5b7SEfujUCMllxcyVyI9fgh4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJBF0t+q+wwxAMgKYNH24L/1gSiaIdVJVA0C+37a9NS3rlHfv1m9yVEU6JnRMSXPdSFPDUBgO4Qfgu//s9QcIf8g/GLLyoVTqygu8g/SbyPEbltLyu6fP+H+S7jHFhlFqTbjjIqfx+pxBE2PFOkbJlb2qQnNeqD1olxtcPWOS9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Zc2EPRcY; arc=none smtp.client-ip=57.103.86.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 22EE518172E5;
	Sat, 20 Sep 2025 14:02:31 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=RIbyW/RgHdh0N1x4qF0XxenCSE6fxcG8n2n/TzQgyVQ=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Zc2EPRcYzKo/D6xyV8WZjMMctdWIsmMog2EyI0Oe+E6PK/zbSC0jYoFIxRt9ig5Bw5NR/YgsyrhkLIzeWtFaJHdPOubD6Bmhc9LWV6BRHvFi8dhVV9hoybtHDPAGX7ehLdUWaWRb5PvuB5jVwJypZLm0is90u9/MJzjtebYhvi/+xUs6yO4DC0UmImw6FESThGDhG4GRobBhxxnpekvNGt4S2OjkXPMmo/pYcgL9wg1O4UFoFCFC6zCq0fkhfESE71pmWlGPu2yldhjnz/pc/+JkD5mBcHcBv/qLmcJDrrtZgFrcjZ84cfJEnraPFoipD7cfwTxswY6MvT9dDVTp/Q==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 42F5018172B6;
	Sat, 20 Sep 2025 14:01:57 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Alexander Graf <agraf@csgraf.de>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 10/23] whpx: interrupt controller support
Date: Sat, 20 Sep 2025 16:01:11 +0200
Message-ID: <20250920140124.63046-11-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250920140124.63046-1-mohamed@unpredictable.fr>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfXyQpQeB/47l0h
 9BVlWsHzI30usic2syo90Nt1dmlH0Fd2B2/YuI7hSlHXbviaw3JbTJXi6N/jnGKfnYRLehhfCSs
 jauXZjTGTwRk4bIKrA9mT12WSjJ9v7Bzpykz1VtdAvZNDECZSm3RPd8Pu+RCOXtC++9EPR+OPE5
 J+a+I1uPQyJ/AsCL7zKnBggHEKUczgfcVtKpFVfgCOCZtS8JeOOz0opu7riDbs6rMLRw/58zT79
 xwd0W+Z4UNy0ycdoKniOwC5MkOfGGADug90sf5Tz6H1t7lwEdOTC1PTdL/WKfGV2VQt96Z6og=
X-Proofpoint-ORIG-GUID: y1E2HZm72yfEd2p5ezt2xi449dW7LB5U
X-Proofpoint-GUID: y1E2HZm72yfEd2p5ezt2xi449dW7LB5U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 spamscore=0 clxscore=1030 bulkscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABtHCQ1FDdsNo6bMjk0qb9iAEbwHx4m9HFDch/nHd4bE2kLFUVnFKExE3wL7pfzdbpHdPSI439eRQURpVAZKDCw+0P1aJn8Or1dF58+4b9lpi2cuBT77LLm462M6CcOcHHr/Qh2MtOMttYbWM+0za33bWGUOPTxyFZ4wNtefYSuU8ek2G32sxVt4VH/DqJspSd9Sl9w6/ySnGgbXwp8CUdFGUk8I42d37ryXZvXkxCd9riXv0W6skehjzcUCDT0nHkV2kl5xPFfFF1Q6xy/f2BYImHOGCsMuSaORiXtssvrRoRsr3d2qPyKvU2SyS8mWlCa3Xe0hRqztMjy1WRJ1j86+ndPn+o9/y9NzAM7XSd2I1ekC051QV2urxYWnCs5tURET22JRZqTgYp99a9417l2AsM6f8xha0TvPjQid4vBKyi3HoP2DjtEqKAM3xtnXRXUPd6k2KGZTor7Ppkldf5Faa9nmKCPHNeC9UoCt9Dp1fCQSTWT5sP0L9XIn+uVKEGuI8C74lDpknog6vGsor43DzLZ+FXpEQcNymTDZCDTU02h/SIj6XT3+l9Y17zknyVh1VhtoHmX2kHEidS/+XVeP1hsvGwADf/PFr3DdVyEV5mSY1KibUi3GVAjxP+brq7BzSAC0hyKW35qjwCK9cAn5K3F3wLT/Y0//ePDudt/+Yhh6L2rrFikpV1hec5+OlKHun3LHI5Nbo9dZQKqnZd8/xi0NngCwqiIrs3OU21eqJxmPGbKPH8rI9kfs/8KKOiJVKusWr8R4047Ggt/TdT9+8RO+RcKEAs7ZTNfox+NnaCerQTqT3Fxw4TTbbDzJVcy+zDsGPpEEtDW+4P4M6m7bNMEFzNc0FrK4y7Ktx9HyVD3LGY1yriIREhDZULQeLZIsk3HCk5

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/virt.c                      |   3 +
 hw/intc/arm_gicv3_common.c         |   3 +
 hw/intc/arm_gicv3_whpx.c           | 239 +++++++++++++++++++++++++++++
 hw/intc/meson.build                |   1 +
 include/hw/intc/arm_gicv3_common.h |   3 +
 5 files changed, 249 insertions(+)
 create mode 100644 hw/intc/arm_gicv3_whpx.c

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 01274ec804..36f6cfe25c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -47,6 +47,7 @@
 #include "system/tcg.h"
 #include "system/kvm.h"
 #include "system/hvf.h"
+#include "system/whpx.h"
 #include "system/qtest.h"
 #include "system/system.h"
 #include "hw/loader.h"
@@ -2091,6 +2092,8 @@ static void finalize_gic_version(VirtMachineState *vms)
         /* KVM w/o kernel irqchip can only deal with GICv2 */
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
         accel_name = "KVM with kernel-irqchip=off";
+    } else if (whpx_enabled()) {
+        gics_supported |= VIRT_GIC_VERSION_3_MASK;
     } else if (tcg_enabled() || hvf_enabled() || qtest_enabled())  {
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
         if (module_object_class_by_name("arm-gicv3")) {
diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
index e438d8c042..8b85b60c9b 100644
--- a/hw/intc/arm_gicv3_common.c
+++ b/hw/intc/arm_gicv3_common.c
@@ -32,6 +32,7 @@
 #include "gicv3_internal.h"
 #include "hw/arm/linux-boot-if.h"
 #include "system/kvm.h"
+#include "system/whpx.h"
 
 
 static void gicv3_gicd_no_migration_shift_bug_post_load(GICv3State *cs)
@@ -662,6 +663,8 @@ const char *gicv3_class_name(void)
 {
     if (kvm_irqchip_in_kernel()) {
         return "kvm-arm-gicv3";
+    } else if (whpx_enabled()) {
+        return TYPE_WHPX_GICV3;
     } else {
         if (kvm_enabled()) {
             error_report("Userspace GICv3 is not supported with KVM");
diff --git a/hw/intc/arm_gicv3_whpx.c b/hw/intc/arm_gicv3_whpx.c
new file mode 100644
index 0000000000..88a05e5901
--- /dev/null
+++ b/hw/intc/arm_gicv3_whpx.c
@@ -0,0 +1,239 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM Generic Interrupt Controller using HVF platform support
+ *
+ * Copyright (c) 2025 Mohamed Mediouni
+ * Based on vGICv3 KVM code by Pavel Fedin
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "hw/intc/arm_gicv3_common.h"
+#include "qemu/error-report.h"
+#include "qemu/module.h"
+#include "system/runstate.h"
+#include "system/whpx.h"
+#include "system/whpx-internal.h"
+#include "gicv3_internal.h"
+#include "vgic_common.h"
+#include "qom/object.h"
+#include "target/arm/cpregs.h"
+
+#include "hw/arm/bsa.h"
+#include <winhvplatform.h>
+#include <winhvplatformdefs.h>
+#include <winnt.h>
+
+struct WHPXARMGICv3Class {
+    ARMGICv3CommonClass parent_class;
+    DeviceRealize parent_realize;
+    ResettablePhases parent_phases;
+};
+
+typedef struct WHPXARMGICv3Class WHPXARMGICv3Class;
+
+/* This is reusing the GICv3State typedef from ARM_GICV3_ITS_COMMON */
+DECLARE_OBJ_CHECKERS(GICv3State, WHPXARMGICv3Class,
+                     WHPX_GICV3, TYPE_WHPX_GICV3);
+
+/* TODO: Implement GIC state save-restore */
+static void whpx_gicv3_check(GICv3State *s)
+{
+}
+
+static void whpx_gicv3_put(GICv3State *s)
+{
+    whpx_gicv3_check(s);
+}
+
+static void whpx_gicv3_get(GICv3State *s)
+{
+}
+
+static void whpx_gicv3_set_irq(void *opaque, int irq, int level)
+{
+    struct whpx_state *whpx = &whpx_global;
+
+    GICv3State *s = (GICv3State *)opaque;
+    if (irq > s->num_irq) {
+        return;
+    }
+    WHV_INTERRUPT_TYPE interrupt_type = WHvArm64InterruptTypeFixed;
+    WHV_INTERRUPT_CONTROL interrupt_control = {
+    interrupt_type = WHvArm64InterruptTypeFixed,
+    .RequestedVector = GIC_INTERNAL + irq, .InterruptControl.Asserted = level};
+
+    whp_dispatch.WHvRequestInterrupt(whpx->partition, &interrupt_control,
+         sizeof(interrupt_control));
+}
+
+static void whpx_gicv3_icc_reset(CPUARMState *env, const ARMCPRegInfo *ri)
+{
+    GICv3State *s;
+    GICv3CPUState *c;
+
+    c = (GICv3CPUState *)env->gicv3state;
+    s = c->gic;
+
+    c->icc_pmr_el1 = 0;
+    /*
+     * Architecturally the reset value of the ICC_BPR registers
+     * is UNKNOWN. We set them all to 0 here; when the kernel
+     * uses these values to program the ICH_VMCR_EL2 fields that
+     * determine the guest-visible ICC_BPR register values, the
+     * hardware's "writing a value less than the minimum sets
+     * the field to the minimum value" behaviour will result in
+     * them effectively resetting to the correct minimum value
+     * for the host GIC.
+     */
+    c->icc_bpr[GICV3_G0] = 0;
+    c->icc_bpr[GICV3_G1] = 0;
+    c->icc_bpr[GICV3_G1NS] = 0;
+
+    c->icc_sre_el1 = 0x7;
+    memset(c->icc_apr, 0, sizeof(c->icc_apr));
+    memset(c->icc_igrpen, 0, sizeof(c->icc_igrpen));
+
+    if (s->migration_blocker) {
+        return;
+    }
+
+    c->icc_ctlr_el1[GICV3_S] = c->icc_ctlr_el1[GICV3_NS];
+}
+
+static void whpx_gicv3_reset_hold(Object *obj, ResetType type)
+{
+    GICv3State *s = ARM_GICV3_COMMON(obj);
+    WHPXARMGICv3Class *kgc = WHPX_GICV3_GET_CLASS(s);
+
+    if (kgc->parent_phases.hold) {
+        kgc->parent_phases.hold(obj, type);
+    }
+
+    whpx_gicv3_put(s);
+}
+
+
+/*
+ * CPU interface registers of GIC needs to be reset on CPU reset.
+ * For the calling arm_gicv3_icc_reset() on CPU reset, we register
+ * below ARMCPRegInfo. As we reset the whole cpu interface under single
+ * register reset, we define only one register of CPU interface instead
+ * of defining all the registers.
+ */
+static const ARMCPRegInfo gicv3_cpuif_reginfo[] = {
+    { .name = "ICC_CTLR_EL1", .state = ARM_CP_STATE_BOTH,
+      .opc0 = 3, .opc1 = 0, .crn = 12, .crm = 12, .opc2 = 4,
+      /*
+       * If ARM_CP_NOP is used, resetfn is not called,
+       * So ARM_CP_NO_RAW is appropriate type.
+       */
+      .type = ARM_CP_NO_RAW,
+      .access = PL1_RW,
+      .readfn = arm_cp_read_zero,
+      .writefn = arm_cp_write_ignore,
+      /*
+       * We hang the whole cpu interface reset routine off here
+       * rather than parcelling it out into one little function
+       * per register
+       */
+      .resetfn = whpx_gicv3_icc_reset,
+    },
+};
+
+static void whpx_set_reg(CPUState *cpu, WHV_REGISTER_NAME reg, WHV_REGISTER_VALUE val)
+{
+    struct whpx_state *whpx = &whpx_global;
+    HRESULT hr;
+    hr = whp_dispatch.WHvSetVirtualProcessorRegisters(whpx->partition, cpu->cpu_index,
+         &reg, 1, &val);
+
+    if (FAILED(hr)) {
+        error_report("WHPX: Failed to set register %08x, hr=%08lx", reg, hr);
+    }
+}
+
+static void whpx_gicv3_realize(DeviceState *dev, Error **errp)
+{
+    GICv3State *s = WHPX_GICV3(dev);
+    WHPXARMGICv3Class *kgc = WHPX_GICV3_GET_CLASS(s);
+    Error *local_err = NULL;
+    int i;
+
+    kgc->parent_realize(dev, &local_err);
+    if (local_err) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    if (s->revision != 3) {
+        error_setg(errp, "unsupported GIC revision %d for platform GIC",
+                   s->revision);
+    }
+
+    if (s->security_extn) {
+        error_setg(errp, "the platform vGICv3 does not implement the "
+                   "security extensions");
+        return;
+    }
+
+    if (s->nmi_support) {
+        error_setg(errp, "NMI is not supported with the platform GIC");
+        return;
+    }
+
+    if (s->nb_redist_regions > 1) {
+        error_setg(errp, "Multiple VGICv3 redistributor regions are not "
+                   "supported by WHPX");
+        error_append_hint(errp, "A maximum of %d VCPUs can be used",
+                          s->redist_region_count[0]);
+        return;
+    }
+
+    gicv3_init_irqs_and_mmio(s, whpx_gicv3_set_irq, NULL);
+
+    for (i = 0; i < s->num_cpu; i++) {
+        CPUState *cpu_state = qemu_get_cpu(i);
+        ARMCPU *cpu = ARM_CPU(cpu_state);
+        WHV_REGISTER_VALUE val = {.Reg64 = 0x080A0000 + (GICV3_REDIST_SIZE * i)};
+        whpx_set_reg(cpu_state, WHvArm64RegisterGicrBaseGpa, val);
+        define_arm_cp_regs(cpu, gicv3_cpuif_reginfo);
+    }
+
+    if (s->maint_irq) {
+        error_setg(errp, "Nested virtualisation not currently supported by WHPX.");
+        return;
+    }
+}
+
+static void whpx_gicv3_class_init(ObjectClass *klass, const void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    ResettableClass *rc = RESETTABLE_CLASS(klass);
+    ARMGICv3CommonClass *agcc = ARM_GICV3_COMMON_CLASS(klass);
+    WHPXARMGICv3Class *kgc = WHPX_GICV3_CLASS(klass);
+
+    agcc->pre_save = whpx_gicv3_get;
+    agcc->post_load = whpx_gicv3_put;
+
+    device_class_set_parent_realize(dc, whpx_gicv3_realize,
+                                    &kgc->parent_realize);
+    resettable_class_set_parent_phases(rc, NULL, whpx_gicv3_reset_hold, NULL,
+                                       &kgc->parent_phases);
+}
+
+static const TypeInfo whpx_arm_gicv3_info = {
+    .name = TYPE_WHPX_GICV3,
+    .parent = TYPE_ARM_GICV3_COMMON,
+    .instance_size = sizeof(GICv3State),
+    .class_init = whpx_gicv3_class_init,
+    .class_size = sizeof(WHPXARMGICv3Class),
+};
+
+static void whpx_gicv3_register_types(void)
+{
+    type_register_static(&whpx_arm_gicv3_info);
+}
+
+type_init(whpx_gicv3_register_types)
diff --git a/hw/intc/meson.build b/hw/intc/meson.build
index 3efb276b6e..13bf79d6e5 100644
--- a/hw/intc/meson.build
+++ b/hw/intc/meson.build
@@ -41,6 +41,7 @@ specific_ss.add(when: 'CONFIG_APIC', if_true: files('apic.c', 'apic_common.c'))
 arm_common_ss.add(when: 'CONFIG_ARM_GIC', if_true: files('arm_gicv3_cpuif_common.c'))
 arm_common_ss.add(when: 'CONFIG_ARM_GICV3', if_true: files('arm_gicv3_cpuif.c'))
 specific_ss.add(when: 'CONFIG_ARM_GIC_KVM', if_true: files('arm_gic_kvm.c'))
+specific_ss.add(when: ['CONFIG_WHPX', 'TARGET_AARCH64'], if_true: files('arm_gicv3_whpx.c'))
 specific_ss.add(when: ['CONFIG_ARM_GIC_KVM', 'TARGET_AARCH64'], if_true: files('arm_gicv3_kvm.c', 'arm_gicv3_its_kvm.c'))
 arm_common_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('armv7m_nvic.c'))
 specific_ss.add(when: 'CONFIG_GRLIB', if_true: files('grlib_irqmp.c'))
diff --git a/include/hw/intc/arm_gicv3_common.h b/include/hw/intc/arm_gicv3_common.h
index 572d971d22..c645cd84f8 100644
--- a/include/hw/intc/arm_gicv3_common.h
+++ b/include/hw/intc/arm_gicv3_common.h
@@ -309,6 +309,9 @@ typedef struct ARMGICv3CommonClass ARMGICv3CommonClass;
 DECLARE_OBJ_CHECKERS(GICv3State, ARMGICv3CommonClass,
                      ARM_GICV3_COMMON, TYPE_ARM_GICV3_COMMON)
 
+/* Types for GICv3 kernel-irqchip */
+#define TYPE_WHPX_GICV3 "whpx-arm-gicv3"
+
 struct ARMGICv3CommonClass {
     /*< private >*/
     SysBusDeviceClass parent_class;
-- 
2.50.1 (Apple Git-155)


