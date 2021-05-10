Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B40C3795CB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhEJR36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhEJR3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:29:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44D16157F;
        Mon, 10 May 2021 17:28:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Gs-000Uqg-MQ; Mon, 10 May 2021 18:00:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v4 66/66] KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
Date:   Mon, 10 May 2021 17:59:20 +0100
Message-Id: <20210510165920.1913477-67-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to the way ARMv8.4-NV suppresses traps when accessing EL2
system registers, we can't track when the guest changes its
HCR_EL2.TGE setting. This means we always trap EL1 TLBIs,
even if they don't affect any guest.

This obviously has a huge impact on performance, as we handle
TLBI traps as a normal exit, and a normal VHE host issues
thousands of TLBIs when booting (and quite a few when running
userspace).

A cheap way to reduce the overhead is to handle the limited
case of {E2H,TGE}=={1,1} as a guest fixup, as we already have
the right mmu configuration in place. Just execute the decoded
instruction right away and return to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 36 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c    |  6 ++++--
 arch/arm64/kvm/sys_regs.c       | 25 ++++++++---------------
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3e7d996b54d..67f8b7d89db6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -166,6 +166,39 @@ void deactivate_traps_vhe_put(void)
 	__deactivate_traps_common();
 }
 
+static bool __hyp_handle_tlbi_el1(struct kvm_vcpu *vcpu)
+{
+	u32 instr;
+	u64 val;
+
+	/*
+	 * Ideally, we would never trap on EL1 TLB invalidations when the
+	 * guest's HCR_EL2.{E2H,TGE} == {1,1}. But "thanks" to ARMv8.4, we
+	 * don't trap writes to HCR_EL2, meaning that we can't track
+	 * changes to the virtual TGE bit. So we leave HCR_EL2.TTLB set on
+	 * the host. Oopsie...
+	 *
+	 * In order to speed-up EL1 TLBIs from the vEL2 guest when TGE is
+	 * set, try and handle these invalidation as quickly as possible,
+	 * without fully exiting (unless this needs forwarding).
+	 */
+	if (kvm_vcpu_trap_get_class(vcpu) != ESR_ELx_EC_SYS64 ||
+	    !vcpu_mode_el2(vcpu) ||
+	    (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_E2H | HCR_TGE)) != (HCR_E2H | HCR_TGE))
+		return false;
+
+	instr = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	if (sys_reg_Op0(instr) != TLBI_Op0 ||
+	    sys_reg_Op1(instr) != TLBI_Op1_EL1)
+		return false;
+
+	val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+	__kvm_tlb_el1_instr(NULL, val, instr);
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
 static bool __hyp_handle_eret(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
@@ -259,6 +292,9 @@ static bool fixup_guest_exit_vhe(struct kvm_vcpu *vcpu, u64 *exit_code,
 	if (*exit_code == ARM_EXCEPTION_TRAP) {
 		if (__hyp_handle_eret(vcpu))
 			return true;
+
+		if (__hyp_handle_tlbi_el1(vcpu))
+			return true;
 	}
 
 	return fixup_guest_exit(vcpu, exit_code);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 001ac9f2f1b5..583255aa35ec 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -201,7 +201,8 @@ void __kvm_tlb_el1_instr(struct kvm_s2_mmu *mmu, u64 val, u64 sys_encoding)
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	if (mmu)
+		__tlb_switch_to_guest(mmu, &cxt);
 
 	/*
 	 * Execute the same instruction as the guest hypervisor did,
@@ -240,5 +241,6 @@ void __kvm_tlb_el1_instr(struct kvm_s2_mmu *mmu, u64 val, u64 sys_encoding)
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	if (mmu)
+		__tlb_switch_to_host(&cxt);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 084230f6b993..6d0776737b76 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2721,6 +2721,8 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 virtual_vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	struct kvm_s2_mmu *mmu;
 
 	/*
 	 * If we're here, this is because we've trapped on a EL1 TLBI
@@ -2739,24 +2741,13 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	mutex_lock(&vcpu->kvm->lock);
 
-	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_E2H | HCR_TGE)) != (HCR_E2H | HCR_TGE)) {
-		u64 virtual_vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-		struct kvm_s2_mmu *mmu;
-
-		mmu = lookup_s2_mmu(vcpu->kvm, virtual_vttbr, HCR_VM);
-		if (mmu)
-			__kvm_tlb_el1_instr(mmu, p->regval, sys_encoding);
+	mmu = lookup_s2_mmu(vcpu->kvm, virtual_vttbr, HCR_VM);
+	if (mmu)
+		__kvm_tlb_el1_instr(mmu, p->regval, sys_encoding);
 
-		mmu = lookup_s2_mmu(vcpu->kvm, virtual_vttbr, 0);
-		if (mmu)
-			__kvm_tlb_el1_instr(mmu, p->regval, sys_encoding);
-	} else {
-		/*
-		 * ARMv8.4-NV allows the guest to change TGE behind
-		 * our back, so we always trap EL1 TLBIs from vEL2...
-		 */
-		__kvm_tlb_el1_instr(&vcpu->kvm->arch.mmu, p->regval, sys_encoding);
-	}
+	mmu = lookup_s2_mmu(vcpu->kvm, virtual_vttbr, 0);
+	if (mmu)
+		__kvm_tlb_el1_instr(mmu, p->regval, sys_encoding);
 
 	mutex_unlock(&vcpu->kvm->lock);
 
-- 
2.29.2

