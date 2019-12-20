Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2570127CE8
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfLTObE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:31:04 -0500
Received: from foss.arm.com ([217.140.110.172]:51318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbfLTObD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:31:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FE4D12FC;
        Fri, 20 Dec 2019 06:31:03 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 370353F718;
        Fri, 20 Dec 2019 06:31:01 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 14/18] KVM: arm64: spe: Provide guest virtual interrupts for SPE
Date:   Fri, 20 Dec 2019 14:30:21 +0000
Message-Id: <20191220143025.33853-15-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon the exit of a guest, let's determine if the SPE device has generated
an interrupt - if so we'll inject a virtual interrupt to the guest.

Upon the entry and exit of a guest we'll also update the state of the
physical IRQ such that it is active when a guest interrupt is pending
and the guest is running.

Finally we map the physical IRQ to the virtual IRQ such that the guest
can deactivate the interrupt when it handles the interrupt.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 include/kvm/arm_spe.h |  6 ++++
 virt/kvm/arm/arm.c    |  5 ++-
 virt/kvm/arm/spe.c    | 71 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 9c65130d726d..91b2214f543a 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -37,6 +37,9 @@ static inline bool kvm_arm_support_spe_v1(void)
 						      ID_AA64DFR0_PMSVER_SHIFT);
 }
 
+void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu);
+inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
+
 int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
@@ -49,6 +52,9 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu);
 #define kvm_arm_support_spe_v1()	(false)
 #define kvm_arm_spe_irq_initialized(v)	(false)
 
+static inline void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu) {}
+static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu) {}
+
 static inline int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
 					  struct kvm_device_attr *attr)
 {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 340d2388ee2c..a66085c8e785 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -741,6 +741,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		preempt_disable();
 
 		kvm_pmu_flush_hwstate(vcpu);
+		kvm_spe_flush_hwstate(vcpu);
 
 		local_irq_disable();
 
@@ -782,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
+			kvm_spe_sync_hwstate(vcpu);
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_hwstate(vcpu);
@@ -816,11 +818,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_arm_clear_debug(vcpu);
 
 		/*
-		 * We must sync the PMU state before the vgic state so
+		 * We must sync the PMU and SPE state before the vgic state so
 		 * that the vgic can properly sample the updated state of the
 		 * interrupt line.
 		 */
 		kvm_pmu_sync_hwstate(vcpu);
+		kvm_spe_sync_hwstate(vcpu);
 
 		/*
 		 * Sync the vgic state before syncing the timer state because
diff --git a/virt/kvm/arm/spe.c b/virt/kvm/arm/spe.c
index 83ac2cce2cc3..097ed39014e4 100644
--- a/virt/kvm/arm/spe.c
+++ b/virt/kvm/arm/spe.c
@@ -35,6 +35,68 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void set_spe_irq_phys_active(struct arm_spe_kvm_info *info,
+					   bool active)
+{
+	int r;
+	r = irq_set_irqchip_state(info->physical_irq, IRQCHIP_STATE_ACTIVE,
+				  active);
+	WARN_ON(r);
+}
+
+void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_spe *spe = &vcpu->arch.spe;
+	bool phys_active = false;
+	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
+
+	if (!kvm_arm_spe_v1_ready(vcpu))
+		return;
+
+	if (irqchip_in_kernel(vcpu->kvm))
+		phys_active = kvm_vgic_map_is_active(vcpu, spe->irq_num);
+
+	phys_active |= spe->irq_level;
+
+	set_spe_irq_phys_active(info, phys_active);
+}
+
+void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_spe *spe = &vcpu->arch.spe;
+	u64 pmbsr;
+	int r;
+	bool service;
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
+
+	if (!kvm_arm_spe_v1_ready(vcpu))
+		return;
+
+	set_spe_irq_phys_active(info, false);
+
+	pmbsr = ctxt->sys_regs[PMBSR_EL1];
+	service = !!(pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT));
+	if (spe->irq_level == service)
+		return;
+
+	spe->irq_level = service;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		r = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+					spe->irq_num, service, spe);
+		WARN_ON(r);
+	}
+}
+
+static inline bool kvm_arch_arm_spe_v1_get_input_level(int vintid)
+{
+	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
+	struct kvm_spe *spe = &vcpu->arch.spe;
+
+	return spe->irq_level;
+}
+
 static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_arm_support_spe_v1())
@@ -48,6 +110,7 @@ static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		int ret;
+		struct arm_spe_kvm_info *info;
 
 		/*
 		 * If using the SPE with an in-kernel virtual GIC
@@ -57,10 +120,18 @@ static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
 
+		info = arm_spe_get_kvm_info();
+		if (!info->physical_irq)
+			return -ENODEV;
+
 		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq_num,
 					 &vcpu->arch.spe);
 		if (ret)
 			return ret;
+
+		ret = kvm_vgic_map_phys_irq(vcpu, info->physical_irq,
+					    vcpu->arch.spe.irq_num,
+					    kvm_arch_arm_spe_v1_get_input_level);
 	}
 
 	vcpu->arch.spe.created = true;
-- 
2.21.0

