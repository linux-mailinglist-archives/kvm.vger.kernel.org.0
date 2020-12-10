Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348DF2D61EB
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392404AbgLJQbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391738AbgLJQFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:05:09 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3F523D5A;
        Thu, 10 Dec 2020 16:04:06 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONo-0008Di-Hx; Thu, 10 Dec 2020 16:01:33 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 61/66] KVM: arm64: nv: Synchronize PSTATE early on exit
Date:   Thu, 10 Dec 2020 15:59:57 +0000
Message-Id: <20201210160002.1407373-62-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The NV code relies on predicates such as is_hyp_ctxt() being
reliable. In turn, is_hyp_ctxt() relies on things like PSTATE
and the virtual HCR_EL2 being accurate.

But with ARMv8.4-NV removing trapping for a large part of the
EL2 system registers (among which HCR_EL2), we can't use such
trapping to synchronize the rest of the state.

Let's look at the following sequence for a VHE guest:

 (1) enter guest in host EL0
 (2) guest traps to guest vEL2 (no hypervisor intervention)
 (3) guest clears virtual HCR_EL2.TGE (no trap either)
 (4) host interrupt fires, exit
 (5) is_hyp_ctxt() now says "guest" (PSTATE.M==EL1 and TGE==0)

It is obvious that such behaviour would be rather unfortunate,
and lead to interesting, difficult to catch bugs specially if
preemption kicks in (yes, I wasted a whole week chasing this one).

In order to preserve the invariant that a guest entered in host
context must exit in the same context, we must make sure that
is_hyp_ctxt() works correctly. Since we can always observe the
guest value of HCR_EL2.{E2H,TGE} in the VNCR_EL2 page, we solely
need to synchronize PSTATE as early as possible.

This basically amounts to moving from_hw_pstate() as close
as possible to the guest exit point, and fixup_guest_exit()
seems as good a place as any.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 16 ++++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 26 ++--------
 arch/arm64/kvm/hyp/nvhe/switch.c           |  8 ++-
 arch/arm64/kvm/hyp/vhe/switch.c            | 57 +++++++++++++++++++++-
 4 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e5e201314c87..3b56841eb328 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -407,11 +407,11 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Return true when we were able to fixup the guest exit and should return to
- * the guest, false when we should restore the host state and return to the
- * main run loop.
+ * Prologue for the guest fixup, populating ESR_EL2 and fixing up PC
+ * if required.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline void fixup_guest_exit_prologue(struct kvm_vcpu *vcpu,
+					     u64 *exit_code)
 {
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
@@ -430,7 +430,15 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
+}
 
+/*
+ * Return true when we were able to fixup the guest exit and should return to
+ * the guest, false when we should restore the host state and return to the
+ * main run loop.
+ */
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 92715fa01e88..1931c8667d52 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -51,32 +51,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, SPSR_EL1)	= read_sysreg_el1(SYS_SPSR);
 }
 
-static inline u64 from_hw_pstate(const struct kvm_cpu_context *ctxt)
-{
-	u64 reg = read_sysreg_el2(SYS_SPSR);
-
-	if (__is_hyp_ctxt(ctxt)) {
-		u64 mode = reg & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
-		switch (mode) {
-		case PSR_MODE_EL1t:
-			mode = PSR_MODE_EL2t;
-			break;
-		case PSR_MODE_EL1h:
-			mode = PSR_MODE_EL2h;
-			break;
-		}
-
-		return (reg & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
-	}
-
-	return reg;
-}
-
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
+	/* On VHE, PSTATE is saved in fixup_guest_exit_vhe() */
+	if (!has_vhe())
+		ctxt->regs.pstate 	= read_sysreg_el2(SYS_SPSR);
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
-	ctxt->regs.pstate		= from_hw_pstate(ctxt);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 07bf5c03631b..fb49757d3446 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -166,6 +166,12 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+static bool fixup_guest_exit_nvhe(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	fixup_guest_exit_prologue(vcpu, exit_code);
+	return fixup_guest_exit(vcpu, exit_code);
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -219,7 +225,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit_nvhe(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d9dc470c7790..4d80596e32a5 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -156,12 +156,60 @@ void deactivate_traps_vhe_put(void)
 	__deactivate_traps_common();
 }
 
+static bool fixup_guest_exit_vhe(struct kvm_vcpu *vcpu, u64 *exit_code,
+				 bool hyp_ctxt)
+{
+	u64 pstate = read_sysreg_el2(SYS_SPSR);
+
+	/*
+	 * Sync pstate back as early as possible, so that is_hyp_ctxt()
+	 * reflects the exact context. It is otherwise possible to get
+	 * confused with a VHE guest and ARMv8.4-NV, such as:
+	 *
+	 * (1) enter guest in host EL0
+	 * (2) guest traps to guest vEL2 (no hypervisor intervention)
+	 * (3) guest clears virtual HCR_EL2.TGE (no trap either)
+	 * (4) host interrupt fires, exit
+	 * (5) is_hyp_ctxt() now says "guest" (pstate.M==EL1 and TGE==0)
+	 *
+	 * If host preemption occurs, vcpu_load/put() will be very confused.
+	 *
+	 * Consider this as the prologue before the fixup prologue...
+	 */
+
+	if (unlikely(hyp_ctxt)) {
+		u64 mode = pstate & PSR_MODE_MASK;
+
+		switch (mode) {
+		case PSR_MODE_EL1t:
+			mode = PSR_MODE_EL2t;
+			break;
+		case PSR_MODE_EL1h:
+			mode = PSR_MODE_EL2h;
+			break;
+		}
+
+		pstate = (pstate & ~PSR_MODE_MASK) | mode;
+	}
+
+	*vcpu_cpsr(vcpu) = pstate;
+
+	fixup_guest_exit_prologue(vcpu, exit_code);
+
+	if (*exit_code == ARM_EXCEPTION_TRAP) {
+		/* more to come here */
+	}
+
+	return fixup_guest_exit(vcpu, exit_code);
+}
+
 /* Switch to the guest for VHE systems running in EL2 */
 static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
+	bool hyp_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
@@ -188,12 +236,19 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
+	/*
+	 * Being in HYP context or not is an invariant here. If we enter in
+	 * a given context, we exit in the same context. We can thus only
+	 * sample the context once.
+	 */
+	WRITE_ONCE(hyp_ctxt, is_hyp_ctxt(vcpu));
+
 	do {
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit_vhe(vcpu, &exit_code, READ_ONCE(hyp_ctxt)));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.29.2

