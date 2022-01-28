Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAD749F9E7
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348678AbiA1MuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:50:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39634 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348657AbiA1MuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:50:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63157B8258F
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2530CC340E6;
        Fri, 28 Jan 2022 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374213;
        bh=teS7KN3kkjrB7NqmXo/HCiCLdeFHtuZcX4fT4zxZGOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtNHkH7WdcEy8F+9tJFwUC1vIcG/tjwK6hVrVzDQzxfnEVy1lT2kSf54JZTULZ198
         95JSCIism++qA/dbj7BfXolOQODvS4H+y9DqrsLqezB6C1us7Tb8PPAy4Dy9QX3tQq
         rDxA/Dhdg5FdvtwetXzpAOsQDbJj9qe3di9YYkZKBtaXeq51iVp/jNXgFHVAbXKhsr
         amCKCVhBWoluK5ZdcaXkwZGyy+GGrNYMjUiezxX05ENMihu32XQi0ON+9qel8JkVM/
         H8UNVRiB8qr7pJ7b3zV6XfONwQlYCciANQdGyYbhRBOv6syIw+XF4RK3Tw1t7FAdSF
         CvEr7EqfQtIwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQEd-003njR-00; Fri, 28 Jan 2022 12:20:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 64/64] KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
Date:   Fri, 28 Jan 2022 12:19:12 +0000
Message-Id: <20220128121912.509006-65-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
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
 arch/arm64/kvm/hyp/vhe/switch.c | 43 ++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/vhe/tlb.c    |  6 +++--
 arch/arm64/kvm/sys_regs.c       | 25 ++++++-------------
 3 files changed, 54 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index f469bf51b4be..686b37579d3b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -161,6 +161,47 @@ void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 	__deactivate_traps_common(vcpu);
 }
 
+static bool kvm_hyp_handle_tlbi_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
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
+	if (!vcpu_has_nv2(vcpu) ||
+	    !vcpu_is_el2(vcpu) ||
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
+static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_hyp_handle_tlbi_el1(vcpu, exit_code))
+		return true;
+
+	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
@@ -209,7 +250,7 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index c4389db4cc22..beb162468c0b 100644
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
index 351bcb429f25..5023ae566f7f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2839,6 +2839,8 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 virtual_vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	struct kvm_s2_mmu *mmu;
 
 	if (vcpu_has_nv(vcpu) && forward_traps(vcpu, HCR_TTLB))
 		return false;
@@ -2860,24 +2862,13 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
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
2.30.2

