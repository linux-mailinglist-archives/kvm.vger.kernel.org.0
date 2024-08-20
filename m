Return-Path: <kvm+bounces-24617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 281119584CE
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88E14B23A07
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8F118FC6F;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q97plwhG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE4818F2C7;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150289; cv=none; b=lFM1SmCVSiEO/Sc+eK7T8c0uYrk/ask9j8drhJ2AGvK+EY6wCSjpvgUvzwEeTPllnmRXnLks8qxg5s8VSIM/6ykTzGtrAjtXHX/RDMM43jJjXf11QkCPWF1AtqGPejC1n8s4bjMUkXqF0pklonIIIC+sS0SvaOHyuo+lxTGD+BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150289; c=relaxed/simple;
	bh=0HDWUMEV7e9VhSdC07h/wonneH062olJyDKpb3VkYfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FH4CaLHCQ4osyF5bpOhWZBVXmhBcp2UNtMbbZ2ZoqlPM4hLGYj2vFCCkWcqlhw21yvdvAI8oAU8FNEV5KlmPXtEQykW6Jmq6s6DCygBYQSziHtz3I8EBu20cbuoeA2pt36JCyGPCBQJlH55OSDRsE1LhWIj2L1L3AtzitlsAkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q97plwhG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE887C4AF09;
	Tue, 20 Aug 2024 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150289;
	bh=0HDWUMEV7e9VhSdC07h/wonneH062olJyDKpb3VkYfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q97plwhGvS9wXFd+HxCXX8zs6w7sGVtE2I9f9Wg1HQ5B8ipB1o6rkbmC09S+wN99B
	 ll0aRDO0oHgWnys1ectk8K1fiiJCI54y7Bgny0J2oH3Ahj0zyPYd2XGk7a7DMIYZJo
	 tVIzxAWHkohlGJj1xxr9DsYC6MCSPb9dvry32EPMcGARNcLcTUWEz3sZ3578aGTsCo
	 Y9ZoOiVX75EwbxaAJroOlPUu3+VLnzkkUDA+V9HcI6aNiHeg9GKD+/b69OIEr39L74
	 OtEpPEFipHjZtRwNJkebFTIBCwbYg1uPNGfhtVx3c9UfC5Y4CX8Qsc+l2B1BzTSPQE
	 m8iZyRbWlwC1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFa-005Ea3-Vt;
	Tue, 20 Aug 2024 11:38:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v4 14/18] KVM: arm64: nv: Add SW walker for AT S1 emulation
Date: Tue, 20 Aug 2024 11:37:52 +0100
Message-Id: <20240820103756.3545976-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to plug the brokenness of our current AT implementation,
we need a SW walker that is going to... err.. walk the S1 tables
and tell us what it finds.

Of course, it builds on top of our S2 walker, and share similar
concepts. The beauty of it is that since it uses kvm_read_guest(),
it is able to bring back pages that have been otherwise evicted.

This is then plugged in the two AT S1 emulation functions as
a "slow path" fallback. I'm not sure it is that slow, but hey.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 610 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 608 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9865d29b3149..e037eb73738a 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -4,9 +4,408 @@
  * Author: Jintack Lim <jintack.lim@linaro.org>
  */
 
+#include <linux/kvm_host.h>
+
+#include <asm/esr.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+enum trans_regime {
+	TR_EL10,
+	TR_EL20,
+	TR_EL2,
+};
+
+struct s1_walk_info {
+	u64	     		baddr;
+	enum trans_regime	regime;
+	unsigned int		max_oa_bits;
+	unsigned int		pgshift;
+	unsigned int		txsz;
+	int 	     		sl;
+	bool	     		hpd;
+	bool	     		be;
+	bool	     		s2;
+};
+
+struct s1_walk_result {
+	union {
+		struct {
+			u64	desc;
+			u64	pa;
+			s8	level;
+			u8	APTable;
+			bool	UXNTable;
+			bool	PXNTable;
+		};
+		struct {
+			u8	fst;
+			bool	ptw;
+			bool	s2;
+		};
+	};
+	bool	failed;
+};
+
+static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
+{
+	wr->fst		= fst;
+	wr->ptw		= ptw;
+	wr->s2		= s2;
+	wr->failed	= true;
+}
+
+#define S1_MMU_DISABLED		(-127)
+
+static int get_ia_size(struct s1_walk_info *wi)
+{
+	return 64 - wi->txsz;
+}
+
+/* Return true if the IPA is out of the OA range */
+static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
+{
+	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
+}
+
+/* Return the translation regime that applies to an AT instruction */
+static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 op)
+{
+	/*
+	 * We only get here from guest EL2, so the translation
+	 * regime AT applies to is solely defined by {E2H,TGE}.
+	 */
+	switch (op) {
+	case OP_AT_S1E2R:
+	case OP_AT_S1E2W:
+		return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
+		break;
+	default:
+		return (vcpu_el2_e2h_is_set(vcpu) &&
+			vcpu_el2_tge_is_set(vcpu)) ? TR_EL20 : TR_EL10;
+	}
+}
+
+static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
+			 struct s1_walk_result *wr, u64 va)
+{
+	u64 hcr, sctlr, tcr, tg, ps, ia_bits, ttbr;
+	unsigned int stride, x;
+	bool va55, tbi, lva, as_el0;
+
+	hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	wi->regime = compute_translation_regime(vcpu, op);
+	as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
+
+	va55 = va & BIT(55);
+
+	if (wi->regime == TR_EL2 && va55)
+		goto addrsz;
+
+	wi->s2 = wi->regime == TR_EL10 && (hcr & (HCR_VM | HCR_DC));
+
+	switch (wi->regime) {
+	case TR_EL10:
+		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL1);
+		ttbr	= (va55 ?
+			   vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
+			   vcpu_read_sys_reg(vcpu, TTBR0_EL1));
+		break;
+	case TR_EL2:
+	case TR_EL20:
+		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL2);
+		ttbr	= (va55 ?
+			   vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
+			   vcpu_read_sys_reg(vcpu, TTBR0_EL2));
+		break;
+	default:
+		BUG();
+	}
+
+	tbi = (wi->regime == TR_EL2 ?
+	       FIELD_GET(TCR_EL2_TBI, tcr) :
+	       (va55 ?
+		FIELD_GET(TCR_TBI1, tcr) :
+		FIELD_GET(TCR_TBI0, tcr)));
+
+	if (!tbi && (u64)sign_extend64(va, 55) != va)
+		goto addrsz;
+
+	va = (u64)sign_extend64(va, 55);
+
+	/* Let's put the MMU disabled case aside immediately */
+	switch (wi->regime) {
+	case TR_EL10:
+		/*
+		 * If dealing with the EL1&0 translation regime, 3 things
+		 * can disable the S1 translation:
+		 *
+		 * - HCR_EL2.DC = 1
+		 * - HCR_EL2.{E2H,TGE} = {0,1}
+		 * - SCTLR_EL1.M = 0
+		 *
+		 * The TGE part is interesting. If we have decided that this
+		 * is EL1&0, then it means that either {E2H,TGE} == {1,0} or
+		 * {0,x}, and we only need to test for TGE == 1.
+		 */
+		if (hcr & (HCR_DC | HCR_TGE)) {
+			wr->level = S1_MMU_DISABLED;
+			break;
+		}
+		fallthrough;
+	case TR_EL2:
+	case TR_EL20:
+		if (!(sctlr & SCTLR_ELx_M))
+			wr->level = S1_MMU_DISABLED;
+		break;
+	}
+
+	if (wr->level == S1_MMU_DISABLED) {
+		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))
+			goto addrsz;
+
+		wr->pa = va;
+		return 0;
+	}
+
+	wi->be = sctlr & SCTLR_ELx_EE;
+
+	wi->hpd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HPDS, IMP);
+	wi->hpd &= (wi->regime == TR_EL2 ?
+		    FIELD_GET(TCR_EL2_HPD, tcr) :
+		    (va55 ?
+		     FIELD_GET(TCR_HPD1, tcr) :
+		     FIELD_GET(TCR_HPD0, tcr)));
+
+	/* Someone was silly enough to encode TG0/TG1 differently */
+	if (va55) {
+		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_TG1_MASK, tcr);
+
+		switch (tg << TCR_TG1_SHIFT) {
+		case TCR_TG1_4K:
+			wi->pgshift = 12;	 break;
+		case TCR_TG1_16K:
+			wi->pgshift = 14;	 break;
+		case TCR_TG1_64K:
+		default:	    /* IMPDEF: treat any other value as 64k */
+			wi->pgshift = 16;	 break;
+		}
+	} else {
+		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
+		tg = FIELD_GET(TCR_TG0_MASK, tcr);
+
+		switch (tg << TCR_TG0_SHIFT) {
+		case TCR_TG0_4K:
+			wi->pgshift = 12;	 break;
+		case TCR_TG0_16K:
+			wi->pgshift = 14;	 break;
+		case TCR_TG0_64K:
+		default:	    /* IMPDEF: treat any other value as 64k */
+			wi->pgshift = 16;	 break;
+		}
+	}
+
+	/* R_PLCGL, R_YXNYW */
+	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
+		if (wi->txsz > 39)
+			goto transfault_l0;
+	} else {
+		if (wi->txsz > 48 || (BIT(wi->pgshift) == SZ_64K && wi->txsz > 47))
+			goto transfault_l0;
+	}
+
+	/* R_GTJBY, R_SXWGM */
+	switch (BIT(wi->pgshift)) {
+	case SZ_4K:
+		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT);
+		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
+		break;
+	case SZ_16K:
+		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT);
+		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
+		break;
+	case SZ_64K:
+		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, VARange, 52);
+		break;
+	}
+
+	if ((lva && wi->txsz < 12) || (!lva && wi->txsz < 16))
+		goto transfault_l0;
+
+	ia_bits = get_ia_size(wi);
+
+	/* R_YYVYV, I_THCZK */
+	if ((!va55 && va > GENMASK(ia_bits - 1, 0)) ||
+	    (va55 && va < GENMASK(63, ia_bits)))
+		goto transfault_l0;
+
+	/* I_ZFSYQ */
+	if (wi->regime != TR_EL2 &&
+	    (tcr & (va55 ? TCR_EPD1_MASK : TCR_EPD0_MASK)))
+		goto transfault_l0;
+
+	/* R_BNDVG and following statements */
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
+	    as_el0 && (tcr & (va55 ? TCR_E0PD1 : TCR_E0PD0)))
+		goto transfault_l0;
+
+	/* AArch64.S1StartLevel() */
+	stride = wi->pgshift - 3;
+	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
+
+	ps = (wi->regime == TR_EL2 ?
+	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
+
+	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps));
+
+	/* Compute minimal alignment */
+	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
+
+	wi->baddr = ttbr & TTBRx_EL1_BADDR;
+
+	/* R_VPBBF */
+	if (check_output_size(wi->baddr, wi))
+		goto addrsz;
+
+	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
+
+	return 0;
+
+addrsz:				/* Address Size Fault level 0 */
+	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(0), false, false);
+	return -EFAULT;
+
+transfault_l0:			/* Translation Fault level 0 */
+	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(0), false, false);
+	return -EFAULT;
+}
+
+static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+		   struct s1_walk_result *wr, u64 va)
+{
+	u64 va_top, va_bottom, baddr, desc;
+	int level, stride, ret;
+
+	level = wi->sl;
+	stride = wi->pgshift - 3;
+	baddr = wi->baddr;
+
+	va_top = get_ia_size(wi) - 1;
+
+	while (1) {
+		u64 index, ipa;
+
+		va_bottom = (3 - level) * stride + wi->pgshift;
+		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
+
+		ipa = baddr | index;
+
+		if (wi->s2) {
+			struct kvm_s2_trans s2_trans = {};
+
+			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
+			if (ret) {
+				fail_s1_walk(wr,
+					     (s2_trans.esr & ~ESR_ELx_FSC_LEVEL) | level,
+					     true, true);
+				return ret;
+			}
+
+			if (!kvm_s2_trans_readable(&s2_trans)) {
+				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level),
+					     true, true);
+
+				return -EPERM;
+			}
+
+			ipa = kvm_s2_trans_output(&s2_trans);
+		}
+
+		ret = kvm_read_guest(vcpu->kvm, ipa, &desc, sizeof(desc));
+		if (ret) {
+			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level),
+				     true, false);
+			return ret;
+		}
+
+		if (wi->be)
+			desc = be64_to_cpu((__force __be64)desc);
+		else
+			desc = le64_to_cpu((__force __le64)desc);
+
+		/* Invalid descriptor */
+		if (!(desc & BIT(0)))
+			goto transfault;
+
+		/* Block mapping, check validity down the line */
+		if (!(desc & BIT(1)))
+			break;
+
+		/* Page mapping */
+		if (level == 3)
+			break;
+
+		/* Table handling */
+		if (!wi->hpd) {
+			wr->APTable  |= FIELD_GET(S1_TABLE_AP, desc);
+			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, desc);
+			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
+		}
+
+		baddr = desc & GENMASK_ULL(47, wi->pgshift);
+
+		/* Check for out-of-range OA */
+		if (check_output_size(baddr, wi))
+			goto addrsz;
+
+		/* Prepare for next round */
+		va_top = va_bottom - 1;
+		level++;
+	}
+
+	/* Block mapping, check the validity of the level */
+	if (!(desc & BIT(1))) {
+		bool valid_block = false;
+
+		switch (BIT(wi->pgshift)) {
+		case SZ_4K:
+			valid_block = level == 1 || level == 2;
+			break;
+		case SZ_16K:
+		case SZ_64K:
+			valid_block = level == 2;
+			break;
+		}
+
+		if (!valid_block)
+			goto transfault;
+	}
+
+	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
+		goto addrsz;
+
+	va_bottom += contiguous_bit_shift(desc, wi, level);
+
+	wr->failed = false;
+	wr->level = level;
+	wr->desc = desc;
+	wr->pa = desc & GENMASK(47, va_bottom);
+	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
+
+	return 0;
+
+addrsz:
+	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(level), true, false);
+	return -EINVAL;
+transfault:
+	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(level), true, false);
+	return -ENOENT;
+}
+
 struct mmu_config {
 	u64	ttbr0;
 	u64	ttbr1;
@@ -188,6 +587,16 @@ static u8 compute_sh(u8 attr, u64 desc)
 	return sh;
 }
 
+static u8 combine_sh(u8 s1_sh, u8 s2_sh)
+{
+	if (s1_sh == ATTR_OSH || s2_sh == ATTR_OSH)
+		return ATTR_OSH;
+	if (s1_sh == ATTR_ISH || s2_sh == ATTR_ISH)
+		return ATTR_ISH;
+
+	return ATTR_NSH;
+}
+
 static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 			   struct kvm_s2_trans *tr)
 {
@@ -260,11 +669,185 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
 	par |= tr->output & GENMASK(47, 12);
 	par |= FIELD_PREP(SYS_PAR_EL1_SH,
-			  compute_sh(final_attr, tr->desc));
+			  combine_sh(FIELD_GET(SYS_PAR_EL1_SH, s1_par),
+				     compute_sh(final_attr, tr->desc)));
+
+	return par;
+}
+
+static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
+			  enum trans_regime regime)
+{
+	u64 par;
+
+	if (wr->failed) {
+		par = SYS_PAR_EL1_RES1;
+		par |= SYS_PAR_EL1_F;
+		par |= FIELD_PREP(SYS_PAR_EL1_FST, wr->fst);
+		par |= wr->ptw ? SYS_PAR_EL1_PTW : 0;
+		par |= wr->s2 ? SYS_PAR_EL1_S : 0;
+	} else if (wr->level == S1_MMU_DISABLED) {
+		/* MMU off or HCR_EL2.DC == 1 */
+		par  = SYS_PAR_EL1_NSE;
+		par |= wr->pa & GENMASK_ULL(47, 12);
+
+		if (regime == TR_EL10 &&
+		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
+			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
+					  MEMATTR(WbRaWa, WbRaWa));
+			par |= FIELD_PREP(SYS_PAR_EL1_SH, ATTR_NSH);
+		} else {
+			par |= FIELD_PREP(SYS_PAR_EL1_ATTR, 0); /* nGnRnE */
+			par |= FIELD_PREP(SYS_PAR_EL1_SH, ATTR_OSH);
+		}
+	} else {
+		u64 mair, sctlr;
+		u8 sh;
+
+		par  = SYS_PAR_EL1_NSE;
+
+		mair = (regime == TR_EL10 ?
+			vcpu_read_sys_reg(vcpu, MAIR_EL1) :
+			vcpu_read_sys_reg(vcpu, MAIR_EL2));
+
+		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
+		mair &= 0xff;
+
+		sctlr = (regime == TR_EL10 ?
+			 vcpu_read_sys_reg(vcpu, SCTLR_EL1) :
+			 vcpu_read_sys_reg(vcpu, SCTLR_EL2));
+
+		/* Force NC for memory if SCTLR_ELx.C is clear */
+		if (!(sctlr & SCTLR_EL1_C) && !MEMATTR_IS_DEVICE(mair))
+			mair = MEMATTR(NC, NC);
+
+		par |= FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
+		par |= wr->pa & GENMASK_ULL(47, 12);
+
+		sh = compute_sh(mair, wr->desc);
+		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
+	}
 
 	return par;
 }
 
+static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	bool perm_fail, ur, uw, ux, pr, pw, px;
+	struct s1_walk_result wr = {};
+	struct s1_walk_info wi = {};
+	int ret, idx;
+
+	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
+	if (ret)
+		goto compute_par;
+
+	if (wr.level == S1_MMU_DISABLED)
+		goto compute_par;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	ret = walk_s1(vcpu, &wi, &wr, vaddr);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (ret)
+		goto compute_par;
+
+	/* FIXME: revisit when adding indirect permission support */
+	/* AArch64.S1DirectBasePermissions() */
+	if (wi.regime != TR_EL2) {
+		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr.desc)) {
+		case 0b00:
+			pr = pw = true;
+			ur = uw = false;
+			break;
+		case 0b01:
+			pr = pw = ur = uw = true;
+			break;
+		case 0b10:
+			pr = true;
+			pw = ur = uw = false;
+			break;
+		case 0b11:
+			pr = ur = true;
+			pw = uw = false;
+			break;
+		}
+
+		switch (wr.APTable) {
+		case 0b00:
+			break;
+		case 0b01:
+			ur = uw = false;
+			break;
+		case 0b10:
+			pw = uw = false;
+			break;
+		case 0b11:
+			pw = ur = uw = false;
+			break;
+		}
+
+		/* We don't use px for anything yet, but hey... */
+		px = !((wr.desc & PTE_PXN) || wr.PXNTable || uw);
+		ux = !((wr.desc & PTE_UXN) || wr.UXNTable);
+
+		if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
+			bool pan;
+
+			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
+			pan &= ur || uw;
+			pw &= !pan;
+			pr &= !pan;
+		}
+	} else {
+		ur = uw = ux = false;
+
+		if (!(wr.desc & PTE_RDONLY)) {
+			pr = pw = true;
+		} else {
+			pr = true;
+			pw = false;
+		}
+
+		if (wr.APTable & BIT(1))
+			pw = false;
+
+		/* XN maps to UXN */
+		px = !((wr.desc & PTE_UXN) || wr.UXNTable);
+	}
+
+	perm_fail = false;
+
+	switch (op) {
+	case OP_AT_S1E1RP:
+	case OP_AT_S1E1R:
+	case OP_AT_S1E2R:
+		perm_fail = !pr;
+		break;
+	case OP_AT_S1E1WP:
+	case OP_AT_S1E1W:
+	case OP_AT_S1E2W:
+		perm_fail = !pw;
+		break;
+	case OP_AT_S1E0R:
+		perm_fail = !ur;
+		break;
+	case OP_AT_S1E0W:
+		perm_fail = !uw;
+		break;
+	default:
+		BUG();
+	}
+
+	if (perm_fail)
+		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false, false);
+
+compute_par:
+	return compute_par_s1(vcpu, &wr, wi.regime);
+}
+
 /*
  * Return the PAR_EL1 value as the result of a valid translation.
  *
@@ -352,10 +935,29 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	return par;
 }
 
+static bool par_check_s1_perm_fault(u64 par)
+{
+	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
+
+	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM &&
+		 !(par & SYS_PAR_EL1_S));
+}
+
 void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
 
+	/*
+	 * If PAR_EL1 reports that AT failed on a S1 permission fault, we
+	 * know for sure that the PTW was able to walk the S1 tables and
+	 * there's nothing else to do.
+	 *
+	 * If AT failed for any other reason, then we must walk the guest S1
+	 * to emulate the instruction.
+	 */
+	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
+		par = handle_at_slow(vcpu, op, vaddr);
+
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
 }
 
@@ -407,6 +1009,10 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		isb();
 	}
 
+	/* We failed the translation, let's replay it in slow motion */
+	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
+		par = handle_at_slow(vcpu, op, vaddr);
+
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
 }
 
@@ -463,7 +1069,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* Check the access permission */
 	if (!out.esr &&
 	    ((!write && !out.readable) || (write && !out.writable)))
-		out.esr = ESR_ELx_FSC_PERM | (out.level & 0x3);
+		out.esr = ESR_ELx_FSC_PERM_L(out.level & 0x3);
 
 	par = compute_par_s12(vcpu, par, &out);
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
-- 
2.39.2


