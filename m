Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151D21EE570
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgFDNeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgFDNeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 09:34:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50046207F7;
        Thu,  4 Jun 2020 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591277646;
        bh=+JJdpvErLuCFaTF3oWAo65vqniAHR2Y2NhleefKGwlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2uRxr4VvsE1XYjqmMGJkaeIrFJIVc+7vzDhv6o8kVTo/9/hxflS/PDotccGOULDK
         D+zTuc2Y/SvdrGJ645ej+ygX6FcxrT64XjrWB4hu/WEHFRwXcnUfU31cNyi1l8EU93
         PkRpu2KaehZwQGKtV1QtXXjxAJzetu0PBXk1ocFo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jgq0S-000G3O-SU; Thu, 04 Jun 2020 14:34:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 2/3] KVM: arm64: Handle PtrAuth traps early
Date:   Thu,  4 Jun 2020 14:33:53 +0100
Message-Id: <20200604133354.1279412-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200604133354.1279412-1-maz@kernel.org>
References: <20200604133354.1279412-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current way we deal with PtrAuth is a bit heavy handed:

- We forcefully save the host's keys on each vcpu_load()
- Handling the PtrAuth trap forces us to go all the way back
  to the exit handling code to just set the HCR bits

Overall, this is pretty heavy handed. A better approach would be
to handle it the same way we deal with the FPSIMD registers:

- On vcpu_load() disable PtrAuth for the guest
- On first use, save the host's keys, enable PtrAuth in the
  guest

Crutially, this can happen as a fixup, which is done very early
on exit. We can then reenter the guest immediately without
leaving the hypervisor role.

Another thing is that it simplify the rest of the host handling:
exiting all the way to the host means that the only possible
outcome for this trap is to inject an UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c         | 17 +----------
 arch/arm64/kvm/handle_exit.c | 17 ++---------
 arch/arm64/kvm/hyp/switch.c  | 59 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c    | 13 +++-----
 4 files changed, 68 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 152049c5055d..14b747266607 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -337,12 +337,6 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -376,17 +370,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	if (vcpu_has_ptrauth(vcpu)) {
-		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
-
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
-
+	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
-	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 065251efa2e6..5a02d4c90559 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,25 +162,14 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-/*
- * Handle the guest trying to use a ptrauth instruction, or trying to access a
- * ptrauth register.
- */
-void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
-{
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_enable(vcpu);
-	else
-		kvm_inject_undefined(vcpu);
-}
-
 /*
  * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP).
+ * a NOP). If we get here, it is that we didn't fixup ptrauth on exit, and all
+ * that we can do is give the guest an UNDEF.
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_arm_vcpu_ptrauth_trap(vcpu);
+	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c07a45643cd4..2a50b3771c3b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -490,6 +490,62 @@ static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_hsr(vcpu));
+	u32 ec = kvm_vcpu_trap_get_class(vcpu);
+	struct kvm_cpu_context *ctxt;
+	u64 val;
+
+	if (!vcpu_has_ptrauth(vcpu))
+		return false;
+
+	switch (ec) {
+	case ESR_ELx_EC_PAC:
+		break;
+	case ESR_ELx_EC_SYS64:
+		switch (sysreg) {
+		case SYS_APIAKEYLO_EL1:
+		case SYS_APIAKEYHI_EL1:
+		case SYS_APIBKEYLO_EL1:
+		case SYS_APIBKEYHI_EL1:
+		case SYS_APDAKEYLO_EL1:
+		case SYS_APDAKEYHI_EL1:
+		case SYS_APDBKEYLO_EL1:
+		case SYS_APDBKEYHI_EL1:
+		case SYS_APGAKEYLO_EL1:
+		case SYS_APGAKEYHI_EL1:
+			break;
+		default:
+			return false;
+		}
+		break;
+	default:
+		return false;
+	}
+
+	ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	__ptrauth_save_key(ctxt->sys_regs, APIA);
+	__ptrauth_save_key(ctxt->sys_regs, APIB);
+	__ptrauth_save_key(ctxt->sys_regs, APDA);
+	__ptrauth_save_key(ctxt->sys_regs, APDB);
+	__ptrauth_save_key(ctxt->sys_regs, APGA);
+
+	vcpu_ptrauth_enable(vcpu);
+
+	val = read_sysreg(hcr_el2);
+	val |= (HCR_API | HCR_APK);
+	write_sysreg(val, hcr_el2);
+
+	return true;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -524,6 +580,9 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (__hyp_handle_fpsimd(vcpu))
 		return true;
 
+	if (__hyp_handle_ptrauth(vcpu))
+		return true;
+
 	if (!__populate_fault_info(vcpu))
 		return true;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad1d57501d6d..564995084cf8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1034,16 +1034,13 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *rd)
 {
-	kvm_arm_vcpu_ptrauth_trap(vcpu);
-
 	/*
-	 * Return false for both cases as we never skip the trapped
-	 * instruction:
-	 *
-	 * - Either we re-execute the same key register access instruction
-	 *   after enabling ptrauth.
-	 * - Or an UNDEF is injected as ptrauth is not supported/enabled.
+	 * If we land here, that is because we didn't fixup the access on exit
+	 * by allowing the PtrAuth sysregs. The only way this happens is when
+	 * the guest does not have PtrAuth support enabled.
 	 */
+	kvm_inject_undefined(vcpu);
+
 	return false;
 }
 
-- 
2.26.2

