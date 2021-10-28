Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA53043DFD3
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhJ1LTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhJ1LTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 07:19:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9F561107;
        Thu, 28 Oct 2021 11:16:45 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mg3Om-002BtD-6g; Thu, 28 Oct 2021 12:16:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, broonie@kernel.org,
        kernel-team@android.com
Subject: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
Date:   Thu, 28 Oct 2021 12:16:37 +0100
Message-Id: <20211028111640.3663631-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028111640.3663631-1-maz@kernel.org>
References: <20211028111640.3663631-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SVE host tracking in KVM is pretty involved. It relies on a
set of flags tracking the ownership of the SVE register, as well
as that of the EL0 access.

It is also pretty scary: __hyp_sve_save_host() computes
a thread_struct pointer and obtains a sve_state which gets directly
accessed without further ado, even on nVHE. How can this even work?

The answer to that is that it doesn't, and that this is mostly dead
code. Closer examination shows that on executing a syscall, userspace
loses its SVE state entirely. This is part of the ABI. Another
thing to notice is that although the kernel provides helpers such as
kernel_neon_begin()/end(), they only deal with the FP/NEON state,
and not SVE.

Given that you can only execute a guest as the result of a syscall,
and that the kernel cannot use SVE by itself, it becomes pretty
obvious that there is never any host SVE state to save, and that
this code is only there to increase confusion.

Get rid of the TIF_SVE tracking and host save infrastructure altogether.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       |  1 -
 arch/arm64/kvm/fpsimd.c                 | 17 +++++-----------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++----------------------
 3 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1363c1ff66fb..e24d960244d9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -410,7 +410,6 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_FP_ENABLED		(1 << 1) /* guest FP regs loaded */
 #define KVM_ARM64_FP_HOST		(1 << 2) /* host FP regs loaded */
-#define KVM_ARM64_HOST_SVE_IN_USE	(1 << 3) /* backup for host TIF_SVE */
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..38ca332c10fe 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -73,15 +73,11 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
+	BUG_ON(test_thread_flag(TIF_SVE));
 
-	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-			      KVM_ARM64_HOST_SVE_IN_USE |
-			      KVM_ARM64_HOST_SVE_ENABLED);
+	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
-	if (test_thread_flag(TIF_SVE))
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
-
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }
@@ -115,13 +111,11 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
-	bool host_has_sve = system_supports_sve();
-	bool guest_has_sve = vcpu_has_sve(vcpu);
 
 	local_irq_save(flags);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		if (guest_has_sve) {
+		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
 			/* Restore the VL that was saved when bound to the CPU */
@@ -131,7 +125,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		}
 
 		fpsimd_save_and_flush_cpu_state();
-	} else if (has_vhe() && host_has_sve) {
+	} else if (has_vhe() && system_supports_sve()) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
 		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
@@ -145,8 +139,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
-	update_thread_flag(TIF_SVE,
-			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
+	update_thread_flag(TIF_SVE, 0);
 
 	local_irq_restore(flags);
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..722dfde7f1aa 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -207,16 +207,6 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 	return __get_fault_info(esr, &vcpu->arch.fault);
 }
 
-static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
-{
-	struct thread_struct *thread;
-
-	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
-			      uw.fpsimd_state);
-
-	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
-}
-
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
@@ -228,21 +218,14 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
-	bool sve_guest, sve_host;
+	bool sve_guest;
 	u8 esr_ec;
 	u64 reg;
 
 	if (!system_supports_fpsimd())
 		return false;
 
-	if (system_supports_sve()) {
-		sve_guest = vcpu_has_sve(vcpu);
-		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
-	} else {
-		sve_guest = false;
-		sve_host = false;
-	}
-
+	sve_guest = vcpu_has_sve(vcpu);
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
 	if (esr_ec != ESR_ELx_EC_FP_ASIMD &&
 	    esr_ec != ESR_ELx_EC_SVE)
@@ -269,11 +252,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	isb();
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
-		if (sve_host)
-			__hyp_sve_save_host(vcpu);
-		else
-			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
-
+		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
 	}
 
-- 
2.30.2

