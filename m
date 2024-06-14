Return-Path: <kvm+bounces-19689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2650908DC3
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58B01280C32
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B369249647;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wj5aSNmt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8AC4A29;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376377; cv=none; b=A0GQimW7ngRYt5fTh/HrJQ536mDi/XqSEUEsgIzRLBuWXbaSVTHWukSZEFjS+2At7kClX45LVBgl29Fmyzf62foHRa8Veo/A6cTySI9bp28ROl6+3L/f/+rbO0YNBCG8qCuYAewsb67eZk2DD0PdVVuZkGJDE+hBocqxlD7f8jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376377; c=relaxed/simple;
	bh=xCyHJ/Q7SmrKeXMW51ba2ZiceT5IKwZnrNDSGlcCYvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m12/w/tGj3Fq/vUt0WUCGUTeJ4XPD9pslDF8fAhZEnv7gJodirlsBlDjE8hZSMWHsIx1zwx6ZUHSfkMVf6UMTli8VsgmC38jEifWY8jucVCiOSBqpEZkr9E72B8fRJjs7iC9QydSKawW1ONLD/PsMvdPBY3Sl7MBaFkbr71QLfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wj5aSNmt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D0DC3277B;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376376;
	bh=xCyHJ/Q7SmrKeXMW51ba2ZiceT5IKwZnrNDSGlcCYvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wj5aSNmtlcVLNELKpjOgydCpEVzQYllJ2Vim3BciZYEoEjxiPmC+ErgOYC6MuESRw
	 kTndAFzyOKofD3qogCdeoZAPhBwtfKAkK0Djz8qYGjIvIVhwFBpU+0s0+P1q/2iAK4
	 AL0yy6gG5a7b3VYFK0dLcMr+uv7YHgVaoOR/p/EtjnIwh7H+8xuQbvBw7ptztWPSaR
	 dV6hzJgufCXljjzwJF95W9rylGzIfii67tX7Vw+M421R1xymJhYQvKhuBEh1oySnBL
	 bGDDd6HIa3s3dTHpvxa/dRTAxaMXNfv4w5y05MBplBQ25c8fGPFX77rCR86aUonFEF
	 q/tE+RvYc96Gw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8By-003wb4-UT;
	Fri, 14 Jun 2024 15:46:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 06/16] KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
Date: Fri, 14 Jun 2024 15:45:42 +0100
Message-Id: <20240614144552.2773592-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Due to the way FEAT_NV2 suppresses traps when accessing EL2
system registers, we can't track when the guest changes its
HCR_EL2.TGE setting. This means we always trap EL1 TLBIs,
even if they don't affect any L2 guest.

Given that invalidating the EL2 TLBs doesn't require any messing
with the shadow stage-2 page-tables, we can simply emulate the
instructions early and return directly to the guest.

This is conditioned on the instruction being an EL1 one and
the guest's HCR_EL2.{E2H,TGE} being {1,1} (indicating that
the instruction targets the EL2 S1 TLBs), or the instruction
being one of the EL2 ones (which are not ambiguous).

EL1 TLBIs issued with HCR_EL2.{E2H,TGE}={1,0} are not handled
here, and cause a full exit so that they can be handled in
the context of a VMID.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 55 +++++++++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h     | 17 +++++++++
 arch/arm64/kvm/hyp/vhe/switch.c     | 51 +++++++++++++++++++++++++-
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 6f770405574f..76b88c640602 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -117,6 +117,61 @@ extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_s2_unmap(struct kvm *kvm);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
+static inline bool kvm_supported_tlbi_s1e1_op(struct kvm_vcpu *vpcu, u32 instr)
+{
+	struct kvm *kvm = vpcu->kvm;
+	u8 CRm = sys_reg_CRm(instr);
+
+	if (!(sys_reg_Op0(instr) == TLBI_Op0 &&
+	      sys_reg_Op1(instr) == TLBI_Op1_EL1))
+		return false;
+
+	if (!(sys_reg_CRn(instr) == TLBI_CRn_XS ||
+	      (sys_reg_CRn(instr) == TLBI_CRn_nXS &&
+	       kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))))
+		return false;
+
+	if (CRm == TLBI_CRm_nROS &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		return false;
+
+	if ((CRm == TLBI_CRm_RIS || CRm == TLBI_CRm_ROS ||
+	     CRm == TLBI_CRm_RNS) &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		return false;
+
+	return true;
+}
+
+static inline bool kvm_supported_tlbi_s1e2_op(struct kvm_vcpu *vpcu, u32 instr)
+{
+	struct kvm *kvm = vpcu->kvm;
+	u8 CRm = sys_reg_CRm(instr);
+
+	if (!(sys_reg_Op0(instr) == TLBI_Op0 &&
+	      sys_reg_Op1(instr) == TLBI_Op1_EL2))
+		return false;
+
+	if (!(sys_reg_CRn(instr) == TLBI_CRn_XS ||
+	      (sys_reg_CRn(instr) == TLBI_CRn_nXS &&
+	       kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))))
+		return false;
+
+	if (CRm == TLBI_CRm_IPAIS || CRm == TLBI_CRm_IPAONS)
+		return false;
+
+	if (CRm == TLBI_CRm_nROS &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		return false;
+
+	if ((CRm == TLBI_CRm_RIS || CRm == TLBI_CRm_ROS ||
+	     CRm == TLBI_CRm_RNS) &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		return false;
+
+	return true;
+}
+
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
 #ifdef CONFIG_ARM64_PTR_AUTH
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index af3b206fa423..be4152819456 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -654,6 +654,23 @@
 #define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
 
 /* TLBI instructions */
+#define TLBI_Op0	1
+
+#define TLBI_Op1_EL1	0	/* Accessible from EL1 or higher */
+#define TLBI_Op1_EL2	4	/* Accessible from EL2 or higher */
+
+#define TLBI_CRn_XS	8	/* Extra Slow (the common one) */
+#define TLBI_CRn_nXS	9	/* not Extra Slow (which nobody uses)*/
+
+#define TLBI_CRm_IPAIS	0	/* S2 Inner-Shareable */
+#define TLBI_CRm_nROS	1	/* non-Range, Outer-Sharable */
+#define TLBI_CRm_RIS	2	/* Range, Inner-Sharable */
+#define TLBI_CRm_nRIS	3	/* non-Range, Inner-Sharable */
+#define TLBI_CRm_IPAONS	4	/* S2 Outer and Non-Shareable */
+#define TLBI_CRm_ROS	5	/* Range, Outer-Sharable */
+#define TLBI_CRm_RNS	6	/* Range, Non-Sharable */
+#define TLBI_CRm_nRNS	7	/* non-Range, Non-Sharable */
+
 #define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
 #define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
 #define OP_TLBI_ASIDE1OS		sys_insn(1, 0, 8, 1, 2)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d7af5f46f22a..3f4a96939dfd 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -262,10 +262,59 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	int ret = -EINVAL;
+	u32 instr;
+	u64 val;
+
+	/*
+	 * Ideally, we would never trap on EL2 S1 TLB invalidations using
+	 * the EL1 instructions when the guest's HCR_EL2.{E2H,TGE}=={1,1}.
+	 * But "thanks" to FEAT_NV2, we don't trap writes to HCR_EL2,
+	 * meaning that we can't track changes to the virtual TGE bit. So we
+	 * have to leave HCR_EL2.TTLB set on the host. Oopsie...
+	 *
+	 * Try and handle these invalidation as quickly as possible, without
+	 * fully exiting. Note that we don't need to consider any forwarding
+	 * here, as having E2H+TGE set is the very definition of being
+	 * InHost.
+	 *
+	 * For the lesser hypervisors out there that have failed to get on
+	 * with the VHE program, we can also handle the nVHE style of EL2
+	 * invalidation.
+	 */
+	if (!(is_hyp_ctxt(vcpu)))
+		return false;
+
+	instr = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+
+	if ((kvm_supported_tlbi_s1e1_op(vcpu, instr) &&
+	     vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) ||
+	    kvm_supported_tlbi_s1e2_op (vcpu, instr))
+		ret = __kvm_tlbi_s1e2(NULL, val, instr);
+
+	if (ret)
+		return false;
+
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
+static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_hyp_handle_tlbi_el2(vcpu, exit_code))
+		return true;
+
+	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
-- 
2.39.2


