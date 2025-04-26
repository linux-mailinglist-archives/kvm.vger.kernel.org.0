Return-Path: <kvm+bounces-44444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77482A9DAAC
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCF5B171F3E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74DD254AFE;
	Sat, 26 Apr 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmNbvBdP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDD925485F;
	Sat, 26 Apr 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670540; cv=none; b=pWLKgIoHxvD2rPbpXWG5+aAPjt52K/A6kJDCA6OtOK2Wz66909TfZMAMR+u8yOM1KTwtnSSdmixaPEzeKOIO66H2zoMfV+vm96mr0y/rWwRw5eae93ALZYbN/5m0m295AIb0FfSD6JV89wvYVhB1NLpv1aEaOrjsE8wnaUTBHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670540; c=relaxed/simple;
	bh=NiapcThiPq9gOW7NZpCQbph6Vn3hSCtez+A4ACpqM7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ezb41q3sEG4QRWulEcEPHW6oa1foVAV9VrrklxF+uw0pwtbjhbgvMb5FTBgW5Mp7nM30dd803TFYV11KCV1esj/LziajxQiluGzNB3avgwzEg64Bt2T0S06VVfm6dPmiIrTIiBrQI4ja0EetG7XfWVTaJA/10NeTsTtJzWrBJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmNbvBdP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDF0C4CEEA;
	Sat, 26 Apr 2025 12:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670539;
	bh=NiapcThiPq9gOW7NZpCQbph6Vn3hSCtez+A4ACpqM7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmNbvBdPlOo4hOO748JPoukzUPoiFj2P9nbip15K7qOJSultzPCHVCJ5eVD0q4wAc
	 XYajZ/CyFbh3FQZ7+mp21BPyU6Rco6riwp8G2z5uQE88346rzPyiRYS3qzJ0eG2cb/
	 OB2dtcT9NQqM/0MaZczSG6dxZLqRW/WbSPwbx8FpuO+lGh7RLkKLiXrkRlAFUZq+Vd
	 Q8urb9EVLihOVfL6U5tSp7DsaXvxDa+XWD9aDXWesNBXpPuzRt+KiDjIBdmq10W35W
	 0JQLQVbQi5dWD/Upbis6zNl6vEYiUichW3UNlh4yLitl+9PwXsPXxv6V5liPBupcB3
	 tma5gm8SZFmfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeP-0092VH-Qv;
	Sat, 26 Apr 2025 13:28:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 32/42] KVM: arm64: Use FGT feature maps to drive RES0 bits
Date: Sat, 26 Apr 2025 13:28:26 +0100
Message-Id: <20250426122836.3341523-33-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Another benefit of mapping bits to features is that it becomes trivial
to define which bits should be handled as RES0.

Let's apply this principle to the guest's view of the FGT registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/config.c           |  46 +++++++++++
 arch/arm64/kvm/nested.c           | 129 +++---------------------------
 3 files changed, 57 insertions(+), 119 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59bfb049ce987..0eff513167868 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1611,6 +1611,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64*res1);
 void check_feature_map(void);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 8d567db03e8a5..a1451aacb14ac 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -616,3 +616,49 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 
 	kvm->arch.fgu[fgt] = val;
 }
+
+void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1)
+{
+	switch (reg) {
+	case HFGRTR_EL2:
+		*res0 = compute_res0_bits(kvm, hfgrtr_feat_map,
+					  ARRAY_SIZE(hfgrtr_feat_map), 0, 0);
+		*res0 |= hfgrtr_masks.res0;
+		*res1 = HFGRTR_EL2_RES1;
+		break;
+	case HFGWTR_EL2:
+		*res0 = compute_res0_bits(kvm, hfgwtr_feat_map,
+					  ARRAY_SIZE(hfgwtr_feat_map), 0, 0);
+		*res0 |= hfgwtr_masks.res0;
+		*res1 = HFGWTR_EL2_RES1;
+		break;
+	case HFGITR_EL2:
+		*res0 = compute_res0_bits(kvm, hfgitr_feat_map,
+					  ARRAY_SIZE(hfgitr_feat_map), 0, 0);
+		*res0 |= hfgitr_masks.res0;
+		*res1 = HFGITR_EL2_RES1;
+		break;
+	case HDFGRTR_EL2:
+		*res0 = compute_res0_bits(kvm, hdfgrtr_feat_map,
+					  ARRAY_SIZE(hdfgrtr_feat_map), 0, 0);
+		*res0 |= hdfgrtr_masks.res0;
+		*res1 = HDFGRTR_EL2_RES1;
+		break;
+	case HDFGWTR_EL2:
+		*res0 = compute_res0_bits(kvm, hdfgwtr_feat_map,
+					  ARRAY_SIZE(hdfgwtr_feat_map), 0, 0);
+		*res0 |= hdfgwtr_masks.res0;
+		*res1 = HDFGWTR_EL2_RES1;
+		break;
+	case HAFGRTR_EL2:
+		*res0 = compute_res0_bits(kvm, hafgrtr_feat_map,
+					  ARRAY_SIZE(hafgrtr_feat_map), 0, 0);
+		*res0 |= hafgrtr_masks.res0;
+		*res1 = HAFGRTR_EL2_RES1;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		*res0 = *res1 = 0;
+		break;
+	}
+}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 666df85230c9b..3d91a0233652b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1100,132 +1100,23 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
 
 	/* HFG[RW]TR_EL2 */
-	res0 = res1 = 0;
-	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
-	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
-		res0 |= (HFGRTR_EL2_APDAKey | HFGRTR_EL2_APDBKey |
-			 HFGRTR_EL2_APGAKey | HFGRTR_EL2_APIAKey |
-			 HFGRTR_EL2_APIBKey);
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
-		res0 |= (HFGRTR_EL2_LORC_EL1 | HFGRTR_EL2_LOREA_EL1 |
-			 HFGRTR_EL2_LORID_EL1 | HFGRTR_EL2_LORN_EL1 |
-			 HFGRTR_EL2_LORSA_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
-	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
-		res0 |= (HFGRTR_EL2_SCXTNUM_EL1 | HFGRTR_EL2_SCXTNUM_EL0);
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP))
-		res0 |= HFGRTR_EL2_ICC_IGRPENn_EL1;
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
-		res0 |= (HFGRTR_EL2_ERRIDR_EL1 | HFGRTR_EL2_ERRSELR_EL1 |
-			 HFGRTR_EL2_ERXFR_EL1 | HFGRTR_EL2_ERXCTLR_EL1 |
-			 HFGRTR_EL2_ERXSTATUS_EL1 | HFGRTR_EL2_ERXMISCn_EL1 |
-			 HFGRTR_EL2_ERXPFGF_EL1 | HFGRTR_EL2_ERXPFGCTL_EL1 |
-			 HFGRTR_EL2_ERXPFGCDN_EL1 | HFGRTR_EL2_ERXADDR_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-		res0 |= HFGRTR_EL2_nACCDATA_EL1;
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		res0 |= (HFGRTR_EL2_nGCS_EL0 | HFGRTR_EL2_nGCS_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
-		res0 |= (HFGRTR_EL2_nSMPRI_EL1 | HFGRTR_EL2_nTPIDR2_EL0);
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
-		res0 |= HFGRTR_EL2_nRCWMASK_EL1;
-	if (!kvm_has_s1pie(kvm))
-		res0 |= (HFGRTR_EL2_nPIRE0_EL1 | HFGRTR_EL2_nPIR_EL1);
-	if (!kvm_has_s1poe(kvm))
-		res0 |= (HFGRTR_EL2_nPOR_EL0 | HFGRTR_EL2_nPOR_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
-		res0 |= HFGRTR_EL2_nS2POR_EL1;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
-		res0 |= (HFGRTR_EL2_nMAIR2_EL1 | HFGRTR_EL2_nAMAIR2_EL1);
-	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | hfgrtr_masks.res0, res1);
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hfgwtr_masks.res0, res1);
+	get_reg_fixed_bits(kvm, HFGRTR_EL2, &res0, &res1);
+	set_sysreg_masks(kvm, HFGRTR_EL2, res0, res1);
+	get_reg_fixed_bits(kvm, HFGWTR_EL2, &res0, &res1);
+	set_sysreg_masks(kvm, HFGWTR_EL2, res0, res1);
 
 	/* HDFG[RW]TR_EL2 */
-	res0 = res1 = 0;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
-		res0 |= HDFGRTR_EL2_OSDLR_EL1;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
-		res0 |= (HDFGRTR_EL2_PMEVCNTRn_EL0 | HDFGRTR_EL2_PMEVTYPERn_EL0 |
-			 HDFGRTR_EL2_PMCCFILTR_EL0 | HDFGRTR_EL2_PMCCNTR_EL0 |
-			 HDFGRTR_EL2_PMCNTEN | HDFGRTR_EL2_PMINTEN |
-			 HDFGRTR_EL2_PMOVS | HDFGRTR_EL2_PMSELR_EL0 |
-			 HDFGRTR_EL2_PMMIR_EL1 | HDFGRTR_EL2_PMUSERENR_EL0 |
-			 HDFGRTR_EL2_PMCEIDn_EL0);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
-		res0 |= (HDFGRTR_EL2_PMBLIMITR_EL1 | HDFGRTR_EL2_PMBPTR_EL1 |
-			 HDFGRTR_EL2_PMBSR_EL1 | HDFGRTR_EL2_PMSCR_EL1 |
-			 HDFGRTR_EL2_PMSEVFR_EL1 | HDFGRTR_EL2_PMSFCR_EL1 |
-			 HDFGRTR_EL2_PMSICR_EL1 | HDFGRTR_EL2_PMSIDR_EL1 |
-			 HDFGRTR_EL2_PMSIRR_EL1 | HDFGRTR_EL2_PMSLATFR_EL1 |
-			 HDFGRTR_EL2_PMBIDR_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
-		res0 |= (HDFGRTR_EL2_TRC | HDFGRTR_EL2_TRCAUTHSTATUS |
-			 HDFGRTR_EL2_TRCAUXCTLR | HDFGRTR_EL2_TRCCLAIM |
-			 HDFGRTR_EL2_TRCCNTVRn | HDFGRTR_EL2_TRCID |
-			 HDFGRTR_EL2_TRCIMSPECn | HDFGRTR_EL2_TRCOSLSR |
-			 HDFGRTR_EL2_TRCPRGCTLR | HDFGRTR_EL2_TRCSEQSTR |
-			 HDFGRTR_EL2_TRCSSCSRn | HDFGRTR_EL2_TRCSTATR |
-			 HDFGRTR_EL2_TRCVICTLR);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
-		res0 |= (HDFGRTR_EL2_TRBBASER_EL1 | HDFGRTR_EL2_TRBIDR_EL1 |
-			 HDFGRTR_EL2_TRBLIMITR_EL1 | HDFGRTR_EL2_TRBMAR_EL1 |
-			 HDFGRTR_EL2_TRBPTR_EL1 | HDFGRTR_EL2_TRBSR_EL1 |
-			 HDFGRTR_EL2_TRBTRG_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
-		res0 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
-			 HDFGRTR_EL2_nBRBDATA);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
-		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
-	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | hdfgrtr_masks.res0, res1);
-
-	/* Reuse the bits from the read-side and add the write-specific stuff */
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
-		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
-		res0 |= HDFGWTR_EL2_TRCOSLAR;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
-		res0 |= HDFGWTR_EL2_TRFCR_EL1;
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hdfgwtr_masks.res0, res1);
+	get_reg_fixed_bits(kvm, HDFGRTR_EL2, &res0, &res1);
+	set_sysreg_masks(kvm, HDFGRTR_EL2, res0, res1);
+	get_reg_fixed_bits(kvm, HDFGWTR_EL2, &res0, &res1);
+	set_sysreg_masks(kvm, HDFGWTR_EL2, res0, res1);
 
 	/* HFGITR_EL2 */
-	res0 = hfgitr_masks.res0;
-	res1 = HFGITR_EL2_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
-		res0 |= HFGITR_EL2_DCCVADP;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
-		res0 |= (HFGITR_EL2_ATS1E1RP | HFGITR_EL2_ATS1E1WP);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
-		res0 |= (HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
-			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS |
-			 HFGITR_EL2_TLBIVAALE1OS | HFGITR_EL2_TLBIVALE1OS |
-			 HFGITR_EL2_TLBIVAAE1OS | HFGITR_EL2_TLBIASIDE1OS |
-			 HFGITR_EL2_TLBIVAE1OS | HFGITR_EL2_TLBIVMALLE1OS);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
-		res0 |= (HFGITR_EL2_TLBIRVAALE1 | HFGITR_EL2_TLBIRVALE1 |
-			 HFGITR_EL2_TLBIRVAAE1 | HFGITR_EL2_TLBIRVAE1 |
-			 HFGITR_EL2_TLBIRVAALE1IS | HFGITR_EL2_TLBIRVALE1IS |
-			 HFGITR_EL2_TLBIRVAAE1IS | HFGITR_EL2_TLBIRVAE1IS |
-			 HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
-			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, IMP))
-		res0 |= (HFGITR_EL2_CFPRCTX | HFGITR_EL2_DVPRCTX |
-			 HFGITR_EL2_CPPRCTX);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
-		res0 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		res0 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
-			 HFGITR_EL2_nGCSEPP);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX))
-		res0 |= HFGITR_EL2_COSPRCTX;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
-		res0 |= HFGITR_EL2_ATS1E1A;
+	get_reg_fixed_bits(kvm, HFGITR_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
 
 	/* HAFGRTR_EL2 - not a lot to see here */
-	res0 = hafgrtr_masks.res0;
-	res1 = HAFGRTR_EL2_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
-		res0 |= ~(res0 | res1);
+	get_reg_fixed_bits(kvm, HAFGRTR_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
 
 	/* TCR2_EL2 */
-- 
2.39.2


