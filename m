Return-Path: <kvm+bounces-60206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3739FBE4E18
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FB425E14D4
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A0522172C;
	Thu, 16 Oct 2025 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="YVxCeOcP"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster4-host4-snip4-3.eps.apple.com [57.103.78.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78122129B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636335; cv=none; b=U5wzcSVGh7sJ+CViXrAth7JUR8D1GR9wSPNAQds5I42qWCvJsQ30dzmMk7i/wsEOvsVVKJXtexfVvw3BX34bcYfOHERBBX4XQbSXTOZMW+PFsqsTb57o/ukmKtqRetpCKyowGrz96woRxYFBHso3g+rwA4Lw2k9XfhSD2Jn/WDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636335; c=relaxed/simple;
	bh=1WjmBW2V5eUNgtLKVSG2j6Kmm+bcyVDXYXheV/KDs6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO8ffryznyvqMWH2ncKvXoyNGBDY99xqU2TZIhe2NPgfCdt7SagzCoCxPisdT3LkzIFoAZNMMXom5StnAz1HPCCNi0J5BV/VMyu9e6FfHty3RQO9CN5TrRzUqzHHJLcn3k/RHMZJTksCnGGjcbV8UZ+rZP5DB0bMwiuFcCjSEMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=YVxCeOcP; arc=none smtp.client-ip=57.103.78.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id D8366180010C;
	Thu, 16 Oct 2025 17:38:46 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=f1Z0855rxWC8aWlMygVlNk2Raub+pFBguy0c0e+7YsA=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=YVxCeOcPgC7eFtGfwu+6jklZCm8VRuwhxa2ggVLu6BLkJtz07Ut/bx6viMFprizgAxqENb/81hkrxqE8iW2ErBpPk4y3qhYTzEE10gdoWCr65OIPFZl9VABFrJg7EsIf92tZkIW5RW0ktbcodl8wtYaeClZFEnESYbpVWr81H2VzMnU0f/l34ezUAbFuSufMQUXSqbAlOpBrrW/aFk6zmvRb+JrnhfJ8zZosd/SycNAyBSeGBy9HqfaZTS9C9esjvI7rrr1wqsz37vH8XhrKd9AaaoYjRYmDIe2uAlgHvl1x2Fh9wK3sjQ8KacZsQt4XbAc7TFu2GPjzBBussrj4gg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id C70DF1800146;
	Thu, 16 Oct 2025 17:38:42 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 11/24] whpx: interrupt controller support
Date: Thu, 16 Oct 2025 19:37:50 +0200
Message-ID: <20251016173803.65764-12-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX/E3Ko7SWmTey
 AsRgmQziWIq06V+QoFLnHea1sMuxEq40eaQqqeKFzDQG5TaXJRtD4rHVv62MD1p7UfbL4gWHyo8
 uFa33L2cV/bBxMmB+1PHVGIAseEbftoNcjXGLEALvXDHYKVe0o/0WodqqnUD29bleqhyjVQJjJ6
 sYC5aKmlhMKZnfEcR7R0RnAJl6fI93fXKrB+Vnh0KoQ6WdGd2Gaf4AcB46GF4jDtEnhFmjuEf6l
 Dx1mXxq55UiUlvvhDPtwuAjn7RwzJH4tIWta+KiDuK1IoXj/viMw18eeAfVTFbaN5kQ/756YQ=
X-Proofpoint-GUID: p9hmbxmcfFFYrj6TZJzJqvTK6uNpbrS7
X-Proofpoint-ORIG-GUID: p9hmbxmcfFFYrj6TZJzJqvTK6uNpbrS7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 clxscore=1030 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABdfMSWa9TpUTuMKapii4iZRd/23qzf/AbGD5E8TQdsdmwNbcOApl+Y0QWu80tIiy6AsZriYNXaCQ/8Whd2q4m86+4bS+6MYVa3ye73H6qPReWg7M6/cdmCPu9gItnt8wMU7XBQJ+mtCWhgnDr8nxu0C4tCmFKMblQwn/BAwH05T3/80ktDw0K2/RhmE0emex4Q94exBnfFqYsDl4Z5aY5TXBRFaXuz3F7DYhLfIw3Sz/uw2aYiemiXdw7tB25xgDGPCu9MOgT5rOdaI8IKIL18Cj55kCRULd25YZm8HXM4CiAJ8IESnvDRt7fO4gYVhFcNTpW5S5dz2NewEcB9Ssd4PRQ/sPPI1LLDfCxo5I7icWbwzyGce38UYxTwZpC5SC8l76gcA8BMHdmWTTWJqlEB8em7Kr6LMyMIUzPXE/cN/6/bLwSjZ07zv4jxi9/6OJW7VQ9RcOBHUXqtc+brqZSUPh5kcgHOWyShbHQ80UzSylknGLIgg/Iw+sxjtT4zHxicFVIfgF3PW5cjZkUoFZ5ghb4DTRpvEBQx+OeyeAMv8XF0jqzsKDBPnLAp/8gItFbTNOJO5mgIBya1ItOoamywhtg7h3BLBcc1b5QRnKe9VR2TCGmPBs2S7HdkqAp7lbZVWWBx806hYWBQLICuR7xgkR2eR94MyVGQHwgoU1NK/+30R17fvMq0fxrTtaiggOn8orUF2obdo2Z9Xl/7fEOg/G9pA6Q0Sl4rh3CbgNRvRkTo3LUSguQ3Z1fHTIbg55k/yXNfqi/CyB43F+fYg7gsIc/v9FNJdXj9TO2ROvFrKlkO5oLNieRASg69KYe/cgLYSZQXAyg29PHSNJtJdtYyDHlNtfwXruHhzKuqjHbbIB71ZHbdza9QUCbZCeuJlyQbVWbqzldFo1AiBjhTQPwDJj5OmxrBH8=

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
index 61d7bab803..9121eb37eb 100644
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
@@ -2105,6 +2106,8 @@ static void finalize_gic_version(VirtMachineState *vms)
         /* KVM w/o kernel irqchip can only deal with GICv2 */
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
         accel_name = "KVM with kernel-irqchip=off";
+    } else if (whpx_enabled()) {
+        gics_supported |= VIRT_GIC_VERSION_3_MASK;
     } else if (tcg_enabled() || hvf_enabled() || qtest_enabled())  {
         gics_supported |= VIRT_GIC_VERSION_2_MASK;
         if (module_object_class_by_name("arm-gicv3")) {
diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
index 2d0df6da86..1fd1e329e8 100644
--- a/hw/intc/arm_gicv3_common.c
+++ b/hw/intc/arm_gicv3_common.c
@@ -32,6 +32,7 @@
 #include "gicv3_internal.h"
 #include "hw/arm/linux-boot-if.h"
 #include "system/kvm.h"
+#include "system/whpx.h"
 
 
 static void gicv3_gicd_no_migration_shift_bug_post_load(GICv3State *cs)
@@ -663,6 +664,8 @@ const char *gicv3_class_name(void)
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
index faae20b93d..96742df090 100644
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
index 38aa1961c5..5f4af811f6 100644
--- a/include/hw/intc/arm_gicv3_common.h
+++ b/include/hw/intc/arm_gicv3_common.h
@@ -310,6 +310,9 @@ typedef struct ARMGICv3CommonClass ARMGICv3CommonClass;
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


