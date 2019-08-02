Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B17F52D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 12:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfHBKhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 06:37:48 -0400
Received: from foss.arm.com ([217.140.110.172]:49386 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfHBKhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 06:37:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FBC51597;
        Fri,  2 Aug 2019 03:37:46 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0613F71F;
        Fri,  2 Aug 2019 03:37:45 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Tangnianyao <tangnianyao@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
Date:   Fri,  2 Aug 2019 11:37:08 +0100
Message-Id: <20190802103709.70148-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802103709.70148-1-maz@kernel.org>
References: <20190802103709.70148-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit commit 328e56647944 ("KVM: arm/arm64: vgic: Defer
touching GICH_VMCR to vcpu_load/put"), we leave ICH_VMCR_EL2 (or
its GICv2 equivalent) loaded as long as we can, only syncing it
back when we're scheduled out.

There is a small snag with that though: kvm_vgic_vcpu_pending_irq(),
which is indirectly called from kvm_vcpu_check_block(), needs to
evaluate the guest's view of ICC_PMR_EL1. At the point were we
call kvm_vcpu_check_block(), the vcpu is still loaded, and whatever
changes to PMR is not visible in memory until we do a vcpu_put().

Things go really south if the guest does the following:

	mov x0, #0	// or any small value masking interrupts
	msr ICC_PMR_EL1, x0

	[vcpu preempted, then rescheduled, VMCR sampled]

	mov x0, #ff	// allow all interrupts
	msr ICC_PMR_EL1, x0
	wfi		// traps to EL2, so samping of VMCR

	[interrupt arrives just after WFI]

Here, the hypervisor's view of PMR is zero, while the guest has enabled
its interrupts. kvm_vgic_vcpu_pending_irq() will then say that no
interrupts are pending (despite an interrupt being received) and we'll
block for no reason. If the guest doesn't have a periodic interrupt
firing once it has blocked, it will stay there forever.

To avoid this unfortuante situation, let's resync VMCR from
kvm_arch_vcpu_blocking(), ensuring that a following kvm_vcpu_check_block()
will observe the latest value of PMR.

This has been found by booting an arm64 Linux guest with the pseudo NMI
feature, and thus using interrupt priorities to mask interrupts instead
of the usual PSTATE masking.

Cc: stable@vger.kernel.org # 4.12
Fixes: 328e56647944 ("KVM: arm/arm64: vgic: Defer touching GICH_VMCR to vcpu_load/put")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/arm.c          | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-v2.c |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-v3.c |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c    | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 6 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 46bbc949c20a..7a30524a80ee 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,6 +350,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
+void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index acc43242a310..d9a650bfaf22 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -323,6 +323,17 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If we're about to block (most likely because we've just hit a
+	 * WFI), we need to sync back the state of the GIC CPU interface
+	 * so that we have the lastest PMR and group enables. This ensures
+	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
+	 * whether we have pending interrupts.
+	 */
+	preempt_disable();
+	kvm_vgic_vmcr_sync(vcpu);
+	preempt_enable();
+
 	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 6dd5ad706c92..96aab77d0471 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -484,10 +484,17 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
 		       kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
 
-void vgic_v2_put(struct kvm_vcpu *vcpu)
+void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 
 	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
+}
+
+void vgic_v2_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	vgic_v2_vmcr_sync(vcpu);
 	cpu_if->vgic_apr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c2c9ce009f63..0c653a1e5215 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -662,12 +662,17 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 		__vgic_v3_activate_traps(vcpu);
 }
 
-void vgic_v3_put(struct kvm_vcpu *vcpu)
+void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
+}
+
+void vgic_v3_put(struct kvm_vcpu *vcpu)
+{
+	vgic_v3_vmcr_sync(vcpu);
 
 	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 04786c8ec77e..13d4b38a94ec 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -919,6 +919,17 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		vgic_v3_put(vcpu);
 }
 
+void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		return;
+
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_vmcr_sync(vcpu);
+	else
+		vgic_v3_vmcr_sync(vcpu);
+}
+
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 3b7525deec80..797e05004d80 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -193,6 +193,7 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
 void vgic_v2_put(struct kvm_vcpu *vcpu);
+void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
 
 void vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu);
@@ -223,6 +224,7 @@ bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
 void vgic_v3_put(struct kvm_vcpu *vcpu);
+void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
-- 
2.20.1

