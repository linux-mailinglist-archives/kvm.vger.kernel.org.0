Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0A25C5F4
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgICP52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgICPz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:55:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40770206EB;
        Thu,  3 Sep 2020 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148556;
        bh=+d5yRirkWJi4nfpAdhWaHUqFaI6Y4YjU38BcHqu0mfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NibJbE4rMMCsw7WnDGNJ9A9a5O2D/ExuaHLblGkEbYoUajxGDqQhRZSn6eWN4dqhG
         YC1C3jsSMsL76MGEwsEhkzshukhwU0avoYsjOMDDbcmCYGUDcOsDUFmfwUGX9DlXGy
         pGJPmgw+Zxq39B8YWY5rMG8uy5FhQvmkODlr9p08=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr8F-008vT9-2t; Thu, 03 Sep 2020 16:26:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel implementation
Date:   Thu,  3 Sep 2020 16:26:09 +0100
Message-Id: <20200903152610.1078827-23-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rVIC (reduced Virtual Interrupt Controller), and its rVID
(reduced Virtual Interrupt Distributor) companion are the two
parts of a PV interrupt controller architecture, aiming at supporting
VMs with minimal interrupt requirements.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |    7 +-
 arch/arm64/include/asm/kvm_irq.h  |    2 +
 arch/arm64/include/uapi/asm/kvm.h |    9 +
 arch/arm64/kvm/Makefile           |    2 +-
 arch/arm64/kvm/arm.c              |    3 +
 arch/arm64/kvm/hypercalls.c       |    7 +
 arch/arm64/kvm/rvic-cpu.c         | 1073 +++++++++++++++++++++++++++++
 include/kvm/arm_rvic.h            |   41 ++
 include/linux/irqchip/irq-rvic.h  |    4 +
 include/uapi/linux/kvm.h          |    2 +
 10 files changed, 1148 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/rvic-cpu.c
 create mode 100644 include/kvm/arm_rvic.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5dd92873d40f..381d3ff6e0b7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_rvic.h>
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
@@ -102,6 +103,7 @@ struct kvm_arch {
 	enum kvm_irqchip_type	irqchip_type;
 	bool			irqchip_finalized;
 	struct kvm_irqchip_flow	irqchip_flow;
+	void			*irqchip_data;
 	struct vgic_dist	vgic;
 
 	/* Mandated version of PSCI */
@@ -324,7 +326,10 @@ struct kvm_vcpu_arch {
 	} host_debug_state;
 
 	/* VGIC state */
-	struct vgic_cpu vgic_cpu;
+	union {
+		struct vgic_cpu vgic_cpu;
+		struct rvic rvic;
+	};
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
 
diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 05fbe5241642..bb1666093f80 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -11,11 +11,13 @@ enum kvm_irqchip_type {
 	IRQCHIP_USER,		/* Implemented in userspace */
 	IRQCHIP_GICv2,		/* v2 on v2, or v2 on v3 */
 	IRQCHIP_GICv3,		/* v3 on v3 */
+	IRQCHIP_RVIC,		/* PV irqchip */
 };
 
 #define irqchip_in_kernel(k)	((k)->arch.irqchip_type != IRQCHIP_USER)
 #define irqchip_is_gic_v2(k)	((k)->arch.irqchip_type == IRQCHIP_GICv2)
 #define irqchip_is_gic_v3(k)	((k)->arch.irqchip_type == IRQCHIP_GICv3)
+#define irqchip_is_rvic(k)	((k)->arch.irqchip_type == IRQCHIP_RVIC)
 
 #define irqchip_finalized(k)	((k)->arch.irqchip_finalized)
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb23f060..9fc26c84903f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -335,6 +335,15 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
+/*
+ * Device Control API: ARM RVIC. We only use the group, not the group
+ * attributes. They must be set to 0 for now.
+ */
+#define KVM_DEV_ARM_RVIC_GRP_NR_IRQS	0
+#define   KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK	0xffff
+#define   KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK	(0xffff << 16)
+#define KVM_DEV_ARM_RVIC_GRP_INIT	1
+
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
 #define KVM_ARM_IRQ_VCPU2_MASK		0xf
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 99977c1972cc..e378293ce99b 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 inject_fault.o regmap.o va_layout.o hyp.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
-	 aarch32.o arch_timer.o \
+	 aarch32.o arch_timer.o rvic-cpu.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0d4c8de27d1e..bf0b11bdce84 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -41,6 +41,7 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_rvic.h>
 
 #ifdef REQUIRES_VIRT
 __asm__(".arch_extension	virt");
@@ -1402,6 +1403,8 @@ static int init_subsystems(void)
 	switch (err) {
 	case 0:
 		vgic_present = true;
+		if (kvm_register_rvic_device())
+			kvm_err("Failed to register rvic device type\n");
 		break;
 	case -ENODEV:
 	case -ENXIO:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 550dfa3e53cd..f6620be74ce5 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -8,6 +8,9 @@
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_rvic.h>
+
+#include <linux/irqchip/irq-rvic.h>
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
@@ -62,6 +65,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		if (gpa != GPA_INVALID)
 			val = gpa;
 		break;
+	case SMC64_RVIC_BASE ... SMC64_RVIC_LAST:
+		return kvm_rvic_handle_hcall(vcpu);
+	case SMC64_RVID_BASE ... SMC64_RVID_LAST:
+		return kvm_rvid_handle_hcall(vcpu);
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/arch/arm64/kvm/rvic-cpu.c b/arch/arm64/kvm/rvic-cpu.c
new file mode 100644
index 000000000000..5fb200c637d9
--- /dev/null
+++ b/arch/arm64/kvm/rvic-cpu.c
@@ -0,0 +1,1073 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * rVIC/rVID PV interrupt controller implementation for KVM/arm64.
+ *
+ * Copyright 2020 Google LLC.
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_rvic.h>
+
+#include <linux/irqchip/irq-rvic.h>
+
+/* FIXME: lock/unlock_all_vcpus */
+#include "vgic/vgic.h"
+
+#define kvm_vcpu_to_rvic(v)	(&(v)->arch.rvic)
+#define kvm_rvic_to_vcpu(r)	(container_of((r), struct kvm_vcpu, arch.rvic))
+
+#define rvic_nr_untrusted(r)	((r)->nr_total - (r)->nr_trusted)
+
+struct rvic_vm_data {
+	u16		nr_trusted;
+	u16		nr_total;
+	spinlock_t	lock;
+	/* Map is a dynamically allocated array of (total-trusted) elements */
+	struct {
+		u16	target_vcpu;
+		u16	intid;
+	} rvid_map[];
+};
+
+/*
+ * rvic_irq state machine:
+ *
+ * idle <- S/C -> pending
+ *  ^          /    ^
+ *  |         /     |
+ * U/M       A     U/M
+ *  |       /       |
+ *  v     v         V
+ * masked <- S/C -> masked+pending
+ *
+ * [S]: Set Pending, [C]: Clear Pending
+ * [U]: Unmask, [M]: Mask
+ * [A]: Ack
+ */
+
+static struct rvic_irq *rvic_get_irq(struct rvic *rvic, unsigned int intid)
+{
+	if (intid >= rvic->nr_total)
+		return NULL;
+	return &rvic->irqs[intid];
+}
+
+static bool rvic_irq_queued(struct rvic_irq *irq)
+{
+	return !list_empty(&irq->delivery_entry);
+}
+
+/* RVIC primitives. They all imply that the RVIC lock is held */
+static void __rvic_enable(struct rvic *rvic)
+{
+	rvic->enabled = true;
+}
+
+static void __rvic_disable(struct rvic *rvic)
+{
+	rvic->enabled = false;
+}
+
+static bool __rvic_is_enabled(struct rvic *rvic)
+{
+	return rvic->enabled;
+}
+
+static void __rvic_set_pending(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	if (!__rvic_is_enabled(rvic)) {
+		pr_debug("dropping intid %u\n", intid);
+		return;
+	}
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	irq->pending = true;
+	if (!irq->masked && !rvic_irq_queued(irq))
+		list_add_tail(&irq->delivery_entry, &rvic->delivery);
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+}
+
+static void __rvic_clear_pending(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	irq->pending = false;
+	list_del_init(&irq->delivery_entry);
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+}
+
+static bool __rvic_is_pending(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+	bool pend;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	pend = irq->pending;
+	spin_unlock_irqrestore(&irq->lock, flags);
+
+	return pend;
+}
+
+static void __rvic_set_masked(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	irq->masked = true;
+	if (irq->pending)
+		list_del_init(&irq->delivery_entry);
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+}
+
+static void __rvic_clear_masked(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+
+	irq->masked = false;
+	if (__rvic_is_enabled(rvic) && irq->pending && !rvic_irq_queued(irq))
+		list_add_tail(&irq->delivery_entry, &rvic->delivery);
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+}
+
+static unsigned int __rvic_ack(struct rvic *rvic)
+{
+	unsigned int intid = ~0U;
+	struct rvic_irq *irq;
+
+	if (!__rvic_is_enabled(rvic))
+		return intid;
+
+	irq = list_first_entry_or_null(&rvic->delivery, struct rvic_irq,
+				       delivery_entry);
+	if (irq) {
+		intid = irq->intid;
+		__rvic_set_masked(rvic, intid);
+		__rvic_clear_pending(rvic, intid);
+	}
+
+	return intid;
+}
+
+static bool __rvic_can_signal(struct rvic *rvic)
+{
+	return __rvic_is_enabled(rvic) && !list_empty(&rvic->delivery);
+}
+
+static void __rvic_resample(struct rvic *rvic, unsigned int intid)
+{
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+	bool pending;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	if (irq->get_line_level) {
+		pending = irq->get_line_level(irq->intid);
+
+		/*
+		 * As part of the resampling, tickle the GIC so that
+		 * new interrupts can trickle in.
+		 */
+		if (!pending && irq->host_irq)
+			irq_set_irqchip_state(irq->host_irq,
+					      IRQCHIP_STATE_ACTIVE, false);
+	} else {
+		pending = irq->line_level;
+	}
+
+	spin_unlock_irqrestore(&irq->lock, flags);
+
+	if (pending)
+		__rvic_set_pending(rvic, intid);
+}
+
+/*
+ * rVIC hypercall handling. All functions assume they are being called
+ * from the vcpu thread that triggers the hypercall.
+ */
+static void __rvic_kick_vcpu(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
+			    bool was_signaling)
+{
+	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
+	bool signal = __rvic_can_signal(rvic);
+
+	/* We're hitting our own rVIC: update HCR_VI locally */
+	if (vcpu == target) {
+		if (signal)
+			*vcpu_hcr(vcpu) |= HCR_VI;
+		else
+			*vcpu_hcr(vcpu) &= ~HCR_VI;
+
+		return;
+	}
+
+	/*
+	 * Remote rVIC case:
+	 *
+	 * We kick even if the interrupt disappears, as ISR_EL1.I must
+	 * always reflect the state of the rVIC. This forces a reload
+	 * of the vcpu state, making it consistent.
+	 *
+	 * This avoids modifying the target's own copy of HCR_EL2, as
+	 * we are in a cross-vcpu call, and changing it from under its
+	 * feet is dodgy.
+	 */
+	if (was_signaling != signal)
+		__rvic_kick_vcpu(target);
+}
+
+static void rvic_version(struct kvm_vcpu *vcpu)
+{
+	/* ALP0.3 is the name of the game */
+	smccc_set_retval(vcpu, RVIC_STATUS_SUCCESS, RVIC_VERSION(0, 3), 0, 0);
+}
+
+static void rvic_info(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long what = smccc_get_arg1(vcpu);
+	unsigned long a0, a1;
+
+	switch (what) {
+	case RVIC_INFO_KEY_NR_TRUSTED_INTERRUPTS:
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
+		a1 = rvic->nr_trusted;
+		break;
+	case RVIC_INFO_KEY_NR_UNTRUSTED_INTERRUPTS:
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
+		a1 = rvic_nr_untrusted(rvic);
+		break;
+	default:
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 0);
+		a1 = 0;
+		break;
+	}
+
+	smccc_set_retval(vcpu, a0, a1, 0, 0);
+}
+
+static void rvic_enable(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long flags;
+	bool was_signaling;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	was_signaling = __rvic_can_signal(rvic);
+	__rvic_enable(rvic);
+	__rvic_sync_hcr(vcpu, rvic, was_signaling);
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
+			 0, 0, 0);
+}
+
+static void rvic_disable(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long flags;
+	bool was_signaling;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	was_signaling = __rvic_can_signal(rvic);
+	__rvic_disable(rvic);
+	__rvic_sync_hcr(vcpu, rvic, was_signaling);
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
+			 0, 0, 0);
+}
+
+typedef void (*rvic_action_fn_t)(struct rvic *, unsigned int);
+
+static int validate_rvic_call(struct kvm_vcpu *vcpu, struct rvic **rvicp,
+			      unsigned int *intidp)
+{
+	unsigned long mpidr = smccc_get_arg1(vcpu);
+	unsigned int intid = smccc_get_arg2(vcpu);
+	struct kvm_vcpu *target;
+	struct rvic *rvic;
+
+	/* FIXME: The spec distinguishes between invalid MPIDR and invalid CPU */
+
+	target = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
+	if (!target) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_INVALID_CPU, 0),
+				 0, 0, 0);
+		return -1;
+	}
+
+	rvic = kvm_vcpu_to_rvic(target);
+	if (intid >= rvic->nr_total) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 1),
+				 0, 0, 0);
+		return -1;
+	}
+
+	*rvicp = rvic;
+	*intidp = intid;
+
+	return 0;
+}
+
+static void __rvic_action(struct kvm_vcpu *vcpu, rvic_action_fn_t action,
+			  bool check_enabled)
+{
+	struct rvic *rvic;
+	unsigned long a0;
+	unsigned long flags;
+	int intid;
+
+	if (validate_rvic_call(vcpu, &rvic, &intid))
+		return;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	if (unlikely(check_enabled && !__rvic_is_enabled(rvic))) {
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_DISABLED, 0);
+	} else {
+		bool was_signaling = __rvic_can_signal(rvic);
+		action(rvic, intid);
+		__rvic_sync_hcr(vcpu, rvic, was_signaling);
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
+	}
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, a0, 0, 0, 0);
+}
+
+static void rvic_set_masked(struct kvm_vcpu *vcpu)
+{
+	__rvic_action(vcpu, __rvic_set_masked, false);
+}
+
+static void rvic_clear_masked(struct kvm_vcpu *vcpu)
+{
+	__rvic_action(vcpu, __rvic_clear_masked, false);
+}
+
+static void rvic_clear_pending(struct kvm_vcpu *vcpu)
+{
+	__rvic_action(vcpu, __rvic_clear_pending, false);
+}
+
+static void rvic_signal(struct kvm_vcpu *vcpu)
+{
+	__rvic_action(vcpu, __rvic_set_pending, true);
+}
+
+static void rvic_is_pending(struct kvm_vcpu *vcpu)
+{
+	unsigned long flags;
+	struct rvic *rvic;
+	int intid;
+	bool res;
+
+	if (validate_rvic_call(vcpu, &rvic, &intid))
+		return;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	res = __rvic_is_pending(rvic, intid);
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0),
+			 res, 0, 0);
+}
+
+/*
+ * Ack and Resample are the only "interesting" operations that are
+ * strictly per-CPU.
+ */
+static void rvic_acknowledge(struct kvm_vcpu *vcpu)
+{
+	unsigned long a0, a1;
+	unsigned long flags;
+	unsigned int intid;
+	struct rvic *rvic;
+
+	rvic = kvm_vcpu_to_rvic(vcpu);
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	if (unlikely(!__rvic_is_enabled(rvic))) {
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_DISABLED, 0);
+		a1 = 0;
+	} else {
+		intid = __rvic_ack(rvic);
+		__rvic_sync_hcr(vcpu, rvic, true);
+		if (unlikely(intid >= rvic->nr_total)) {
+			a0 = RVIx_STATUS_PACK(RVIC_STATUS_NO_INTERRUPTS, 0);
+			a1 = 0;
+		} else {
+			a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
+			a1 = intid;
+		}
+	}
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, a0, a1, 0, 0);
+}
+
+static void rvic_resample(struct kvm_vcpu *vcpu)
+{
+	unsigned int intid = smccc_get_arg1(vcpu);
+	unsigned long flags;
+	unsigned long a0;
+	struct rvic *rvic;
+
+	rvic = kvm_vcpu_to_rvic(vcpu);
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	if (unlikely(intid >= rvic->nr_trusted)) {
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_ERROR_PARAMETER, 0);
+	} else {
+		__rvic_resample(rvic, intid);
+
+		/*
+		 * Don't bother finding out if we were signalling, we
+		 * will update HCR_EL2 anyway as we are guaranteed not
+		 * to be in a cross-call.
+		 */
+		__rvic_sync_hcr(vcpu, rvic, true);
+		a0 = RVIx_STATUS_PACK(RVIC_STATUS_SUCCESS, 0);
+	}
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	smccc_set_retval(vcpu, a0, 0, 0, 0);
+}
+
+int kvm_rvic_handle_hcall(struct kvm_vcpu *vcpu)
+{
+	pr_debug("RVIC: HC %08x", (unsigned int)smccc_get_function(vcpu));
+	switch (smccc_get_function(vcpu)) {
+	case SMC64_RVIC_VERSION:
+		rvic_version(vcpu);
+		break;
+	case SMC64_RVIC_INFO:
+		rvic_info(vcpu);
+		break;
+	case SMC64_RVIC_ENABLE:
+		rvic_enable(vcpu);
+		break;
+	case SMC64_RVIC_DISABLE:
+		rvic_disable(vcpu);
+		break;
+	case SMC64_RVIC_SET_MASKED:
+		rvic_set_masked(vcpu);
+		break;
+	case SMC64_RVIC_CLEAR_MASKED:
+		rvic_clear_masked(vcpu);
+		break;
+	case SMC64_RVIC_IS_PENDING:
+		rvic_is_pending(vcpu);
+		break;
+	case SMC64_RVIC_SIGNAL:
+		rvic_signal(vcpu);
+		break;
+	case SMC64_RVIC_CLEAR_PENDING:
+		rvic_clear_pending(vcpu);
+		break;
+	case SMC64_RVIC_ACKNOWLEDGE:
+		rvic_acknowledge(vcpu);
+		break;
+	case SMC64_RVIC_RESAMPLE:
+		rvic_resample(vcpu);
+		break;
+	default:
+		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
+		break;
+	}
+
+	return 1;
+}
+
+static void rvid_version(struct kvm_vcpu *vcpu)
+{
+	/* ALP0.3 is the name of the game */
+	smccc_set_retval(vcpu, RVID_STATUS_SUCCESS, RVID_VERSION(0, 3), 0, 0);
+}
+
+static void rvid_map(struct kvm_vcpu *vcpu)
+{
+	unsigned long input = smccc_get_arg1(vcpu);
+	unsigned long mpidr = smccc_get_arg2(vcpu);
+	unsigned int intid = smccc_get_arg3(vcpu);
+	unsigned long flags;
+	struct rvic_vm_data *data;
+	struct kvm_vcpu *target;
+
+	data = vcpu->kvm->arch.irqchip_data;
+
+	if (input > rvic_nr_untrusted(data)) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 0),
+				 0, 0, 0);
+		return;
+	}
+
+	/* FIXME: different error from RVIC. Why? */
+	target = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
+	if (!target) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 1),
+				 0, 0, 0);
+		return;
+	}
+
+	if (intid < data->nr_trusted || intid >= data->nr_total) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 2),
+				 0, 0, 0);
+		return;
+	}
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->rvid_map[input].target_vcpu	= target->vcpu_id;
+	data->rvid_map[input].intid		= intid;
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	smccc_set_retval(vcpu, 0, 0, 0, 0);
+}
+
+static void rvid_unmap(struct kvm_vcpu *vcpu)
+{
+	unsigned long input = smccc_get_arg1(vcpu);
+	unsigned long flags;
+	struct rvic_vm_data *data;
+
+	data = vcpu->kvm->arch.irqchip_data;
+
+	if (input > rvic_nr_untrusted(data)) {
+		smccc_set_retval(vcpu, RVIx_STATUS_PACK(RVID_STATUS_ERROR_PARAMETER, 0),
+				 0, 0, 0);
+		return;
+	}
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->rvid_map[input].target_vcpu	= 0;
+	data->rvid_map[input].intid		= 0;
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	smccc_set_retval(vcpu, 0, 0, 0, 0);
+}
+
+int kvm_rvid_handle_hcall(struct kvm_vcpu *vcpu)
+{
+	pr_debug("RVID: HC %08x", (unsigned int)smccc_get_function(vcpu));
+	switch (smccc_get_function(vcpu)) {
+	case SMC64_RVID_VERSION:
+		rvid_version(vcpu);
+		break;
+	case SMC64_RVID_MAP:
+		rvid_map(vcpu);
+		break;
+	case SMC64_RVID_UNMAP:
+		rvid_unmap(vcpu);
+		break;
+	default:
+		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
+		break;
+	}
+
+	return 1;
+}
+
+/*
+ * KVM internal interface to the rVIC
+ */
+
+/* This *must* be called from the vcpu thread */
+static void rvic_flush_signaling_state(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	__rvic_sync_hcr(vcpu, rvic, true);
+
+	spin_unlock_irqrestore(&rvic->lock, flags);
+}
+
+/* This can be called from any context */
+static void rvic_vcpu_inject_irq(struct kvm_vcpu *vcpu, unsigned int intid,
+				 bool level)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long flags;
+	bool prev;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+
+	if (WARN_ON(intid >= rvic->nr_total))
+		goto out;
+
+	/*
+	 * Although really ugly, this should be safe as we hold the
+	 * rvic lock, and the only path that uses this information is
+	 * resample, which takes this lock too.
+	 */
+	if (!rvic->irqs[intid].get_line_level)
+		rvic->irqs[intid].line_level = level;
+
+	if (level) {
+		prev = __rvic_can_signal(rvic);
+		__rvic_set_pending(rvic, intid);
+		if (prev != __rvic_can_signal(rvic))
+			__rvic_kick_vcpu(vcpu);
+	}
+out:
+	spin_unlock_irqrestore(&rvic->lock, flags);
+}
+
+static int rvic_inject_irq(struct kvm *kvm, unsigned int cpu,
+			   unsigned int intid, bool level, void *owner)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
+	struct rvic *rvic;
+
+	if (unlikely(!vcpu))
+		return -EINVAL;
+
+	rvic = kvm_vcpu_to_rvic(vcpu);
+	if (unlikely(intid >= rvic->nr_total))
+		return -EINVAL;
+
+	/* Ignore interrupt owner for now */
+	rvic_vcpu_inject_irq(vcpu, intid, level);
+	return 0;
+}
+
+static int rvic_inject_userspace_irq(struct kvm *kvm, unsigned int type,
+				     unsigned int cpu,
+				     unsigned int intid, bool level)
+{
+	struct rvic_vm_data *data = kvm->arch.irqchip_data;
+	unsigned long flags;
+	u16 output;
+
+	switch (type) {
+	case KVM_ARM_IRQ_TYPE_SPI:
+		/*
+		 * Userspace can only inject interrupts that are
+		 * translated by the rvid, so the cpu parameter is
+		 * irrelevant and we override it when resolving the
+		 * translation.
+		 */
+		if (intid >= rvic_nr_untrusted(data))
+			return -EINVAL;
+
+		spin_lock_irqsave(&data->lock, flags);
+		output = data->rvid_map[intid].intid;
+		cpu = data->rvid_map[intid].target_vcpu;
+		spin_unlock_irqrestore(&data->lock, flags);
+
+		/* Silently ignore unmapped interrupts */
+		if (output < data->nr_trusted)
+			return 0;
+
+		return rvic_inject_irq(kvm, cpu, output, level, NULL);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int rvic_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct rvic_vm_data *data = vcpu->kvm->arch.irqchip_data;
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	int i;
+
+	/* irqchip not ready yet, we will come back later */
+	if (!data)
+		return 0;
+
+	if (WARN_ON(rvic->irqs))
+		return -EINVAL;
+
+	spin_lock_init(&rvic->lock);
+	INIT_LIST_HEAD(&rvic->delivery);
+	rvic->nr_trusted	= data->nr_trusted;
+	rvic->nr_total		= data->nr_total;
+	rvic->enabled		= false;
+
+	rvic->irqs = kcalloc(rvic->nr_total, sizeof(*rvic->irqs), GFP_ATOMIC);
+	if (!rvic->irqs)
+		return -ENOMEM;
+
+	for (i = 0; i < rvic->nr_total; i++) {
+		struct rvic_irq *irq = &rvic->irqs[i];
+
+		spin_lock_init(&irq->lock);
+		INIT_LIST_HEAD(&irq->delivery_entry);
+		irq->get_line_level	= NULL;
+		irq->intid		= i;
+		irq->host_irq		= 0;
+		irq->pending		= false;
+		irq->masked		= true;
+		irq->line_level		= false;
+	}
+
+	return 0;
+}
+
+static void rvic_destroy(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	mutex_lock(&kvm->lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+
+		INIT_LIST_HEAD(&rvic->delivery);
+		kfree(rvic->irqs);
+		rvic->irqs = NULL;
+	}
+
+	mutex_unlock(&kvm->lock);
+}
+
+static int rvic_pending_irq(struct kvm_vcpu *vcpu)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	unsigned long flags;
+	bool res;
+
+	spin_lock_irqsave(&rvic->lock, flags);
+	res = __rvic_can_signal(rvic);
+	spin_unlock_irqrestore(&rvic->lock, flags);
+
+	return res;
+}
+
+static int rvic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
+			     u32 intid, bool (*get_line_level)(int))
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	irq->host_irq = host_irq;
+	irq->get_line_level = get_line_level;
+	spin_unlock_irqrestore(&irq->lock, flags);
+
+	return 0;
+}
+
+static int rvic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int intid)
+{
+	struct rvic *rvic = kvm_vcpu_to_rvic(vcpu);
+	struct rvic_irq *irq = rvic_get_irq(rvic, intid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->lock, flags);
+	irq->host_irq = 0;
+	irq->get_line_level = NULL;
+	spin_unlock_irqrestore(&irq->lock, flags);
+
+	return 0;
+}
+
+static int rvic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id,
+			      int level, bool line_status)
+{
+	/* Abuse the userspace interface to perform the routing*/
+	return rvic_inject_userspace_irq(kvm, KVM_ARM_IRQ_TYPE_SPI, 0,
+					 e->irqchip.pin, level);
+}
+
+static int rvic_set_msi(struct kvm_kernel_irq_routing_entry *e,
+			struct kvm *kvm, int irq_source_id,
+			int level, bool line_status)
+{
+	return -ENODEV;
+}
+
+static int rvic_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+				 struct kvm *kvm, int irq_source_id,
+				 int level, bool line_status)
+{
+	if (e->type != KVM_IRQ_ROUTING_IRQCHIP)
+		return -EWOULDBLOCK;
+
+	return rvic_irqfd_set_irq(e, kvm, irq_source_id, level, line_status);
+}
+
+static const struct kvm_irqchip_flow rvic_irqchip_flow = {
+	.irqchip_destroy		= rvic_destroy,
+	.irqchip_vcpu_init		= rvic_vcpu_init,
+	/* Nothing to do on block/unblock */
+	/* Nothing to do on load/put */
+	.irqchip_vcpu_pending_irq	= rvic_pending_irq,
+	.irqchip_vcpu_flush_hwstate	= rvic_flush_signaling_state,
+	/* Nothing tp do on sync_hwstate */
+	.irqchip_inject_irq		= rvic_inject_irq,
+	.irqchip_inject_userspace_irq	= rvic_inject_userspace_irq,
+	/* No reset_mapped_irq as we allow spurious interrupts */
+	.irqchip_map_phys_irq		= rvic_map_phys_irq,
+	.irqchip_unmap_phys_irq		= rvic_unmap_phys_irq,
+	.irqchip_irqfd_set_irq		= rvic_irqfd_set_irq,
+	.irqchip_set_msi		= rvic_set_msi,
+	.irqchip_set_irq_inatomic	= rvic_set_irq_inatomic,
+};
+
+static int rvic_setup_default_irq_routing(struct kvm *kvm)
+{
+	struct rvic_vm_data *data = kvm->arch.irqchip_data;
+	unsigned int nr = rvic_nr_untrusted(data);
+	struct kvm_irq_routing_entry *entries;
+	int i, ret;
+
+	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		entries[i].gsi = i;
+		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+		entries[i].u.irqchip.irqchip = 0;
+		entries[i].u.irqchip.pin = i;
+	}
+	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
+	kfree(entries);
+	return ret;
+}
+
+/* Device management */
+static int rvic_device_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm *kvm = dev->kvm;
+	struct kvm_vcpu *vcpu;
+	int i, ret;
+
+	if (irqchip_in_kernel(kvm))
+		return -EEXIST;
+
+	ret = -EBUSY;
+	if (!lock_all_vcpus(kvm))
+		return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.has_run_once)
+			goto out_unlock;
+	}
+
+	ret = 0;
+
+	/*
+	 * The good thing about not having any HW is that you don't
+	 * get the limitations of the HW...
+	 */
+	kvm->arch.max_vcpus		= KVM_MAX_VCPUS;
+	kvm->arch.irqchip_type		= IRQCHIP_RVIC;
+	kvm->arch.irqchip_flow		= rvic_irqchip_flow;
+	kvm->arch.irqchip_data		= NULL;
+
+out_unlock:
+	unlock_all_vcpus(kvm);
+	return ret;
+}
+
+static void rvic_device_destroy(struct kvm_device *dev)
+{
+	kfree(dev->kvm->arch.irqchip_data);
+	kfree(dev);
+}
+
+static int rvic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	struct rvic_vm_data *data;
+	struct kvm_vcpu *vcpu;
+	u32 __user *uaddr, val;
+	u16 trusted, total;
+	int i, ret = -ENXIO;
+
+	mutex_lock(&dev->kvm->lock);
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
+		if (attr->attr)
+			break;
+
+		if (dev->kvm->arch.irqchip_data) {
+			ret = -EBUSY;
+			break;
+		}
+
+		uaddr = (u32 __user *)(uintptr_t)attr->addr;
+		if (get_user(val, uaddr)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		trusted = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK, val);
+		total   = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK, val);
+		if (total < trusted || trusted < 32 || total < 64 ||
+		    trusted % 32 || total % 32 || total > 2048) {
+			ret = -EINVAL;
+			break;
+		}
+
+		data = kzalloc(struct_size(data, rvid_map, (total - trusted)),
+			       GFP_KERNEL);
+		if (!data) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		data->nr_trusted = trusted;
+		data->nr_total = total;
+		spin_lock_init(&data->lock);
+		/* Default to no mapping */
+		for (i = 0; i < (total - trusted); i++) {
+			/*
+			 * an intid < nr_trusted is invalid as the
+			 * result of a translation through the rvid,
+			 * hence the input in unmapped.
+			 */
+			data->rvid_map[i].target_vcpu = 0;
+			data->rvid_map[i].intid = 0;
+		}
+
+		dev->kvm->arch.irqchip_data = data;
+
+		ret = 0;
+		break;
+
+	case KVM_DEV_ARM_RVIC_GRP_INIT:
+		if (attr->attr)
+			break;
+
+		if (!dev->kvm->arch.irqchip_data)
+			break;
+
+		ret = 0;
+
+		/* Init the rvic on any already created vcpu */
+		kvm_for_each_vcpu(i, vcpu, dev->kvm) {
+			ret = rvic_vcpu_init(vcpu);
+			if (ret)
+				break;
+		}
+
+		if (!ret)
+			ret = rvic_setup_default_irq_routing(dev->kvm);
+		if (!ret)
+			dev->kvm->arch.irqchip_finalized = true;
+		break;
+
+	default:
+		break;
+	}
+
+	mutex_unlock(&dev->kvm->lock);
+
+	return ret;
+}
+
+static int rvic_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	struct rvic_vm_data *data;
+	u32 __user *uaddr, val;
+	int ret = -ENXIO;
+
+	mutex_lock(&dev->kvm->lock);
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
+		if (attr->attr)
+			break;
+
+		data = dev->kvm->arch.irqchip_data;
+		if (!data)
+			break;
+
+		val  = FIELD_PREP(KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK,
+					 data->nr_trusted);
+		val |= FIELD_PREP(KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK,
+					 data->nr_total);
+
+		uaddr = (u32 __user *)(uintptr_t)attr->addr;
+		ret = put_user(val, uaddr);
+		break;
+
+	default:
+		break;
+	}
+
+	mutex_unlock(&dev->kvm->lock);
+
+	return ret;
+}
+
+static int rvic_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
+	case KVM_DEV_ARM_RVIC_GRP_INIT:
+		if (attr->attr)
+			break;
+		ret = 0;
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static const struct kvm_device_ops rvic_dev_ops = {
+	.name		= "kvm-arm-rvic",
+	.create		= rvic_device_create,
+	.destroy	= rvic_device_destroy,
+	.set_attr	= rvic_set_attr,
+	.get_attr	= rvic_get_attr,
+	.has_attr	= rvic_has_attr,
+};
+
+int kvm_register_rvic_device(void)
+{
+	return kvm_register_device_ops(&rvic_dev_ops, KVM_DEV_TYPE_ARM_RVIC);
+}
diff --git a/include/kvm/arm_rvic.h b/include/kvm/arm_rvic.h
new file mode 100644
index 000000000000..9e67a83fa384
--- /dev/null
+++ b/include/kvm/arm_rvic.h
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * rVIC/rVID PV interrupt controller implementation for KVM/arm64.
+ *
+ * Copyright 2020 Google LLC.
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#ifndef __KVM_ARM_RVIC_H__
+#define __KVM_ARM_RVIC_H__
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct kvm_vcpu;
+
+struct rvic_irq {
+	spinlock_t		lock;
+	struct list_head	delivery_entry;
+	bool			(*get_line_level)(int intid);
+	unsigned int		intid;
+	unsigned int		host_irq;
+	bool			pending;
+	bool			masked;
+	bool			line_level; /* If get_line_level == NULL */
+};
+
+struct rvic {
+	spinlock_t		lock;
+	struct list_head	delivery;
+	struct rvic_irq		*irqs;
+	unsigned int		nr_trusted;
+	unsigned int		nr_total;
+	bool			enabled;
+};
+
+int kvm_rvic_handle_hcall(struct kvm_vcpu *vcpu);
+int kvm_rvid_handle_hcall(struct kvm_vcpu *vcpu);
+int kvm_register_rvic_device(void);
+
+#endif
diff --git a/include/linux/irqchip/irq-rvic.h b/include/linux/irqchip/irq-rvic.h
index 4545c1e89741..b188773729fb 100644
--- a/include/linux/irqchip/irq-rvic.h
+++ b/include/linux/irqchip/irq-rvic.h
@@ -57,6 +57,8 @@
 #define SMC64_RVIC_ACKNOWLEDGE		SMC64_RVIC_FN(9)
 #define SMC64_RVIC_RESAMPLE		SMC64_RVIC_FN(10)
 
+#define SMC64_RVIC_LAST			SMC64_RVIC_RESAMPLE
+
 #define RVIC_INFO_KEY_NR_TRUSTED_INTERRUPTS	0
 #define RVIC_INFO_KEY_NR_UNTRUSTED_INTERRUPTS	1
 
@@ -82,6 +84,8 @@
 #define SMC64_RVID_MAP			SMC64_RVID_FN(1)
 #define SMC64_RVID_UNMAP		SMC64_RVID_FN(2)
 
+#define SMC64_RVID_LAST			SMC64_RVID_UNMAP
+
 #define RVID_VERSION(M, m)		RVIx_VERSION((M), (m))
 
 #define RVID_VERSION_MAJOR(v)		RVIx_VERSION_MAJOR((v))
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..6d245d2dc9e6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1264,6 +1264,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_ARM_RVIC,
+#define KVM_DEV_TYPE_ARM_RVIC		KVM_DEV_TYPE_ARM_RVIC
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.27.0

