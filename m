Return-Path: <kvm+bounces-40642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F416A5944F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BB73188A7BA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421FD22540B;
	Mon, 10 Mar 2025 12:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p87juRiW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624C722C325;
	Mon, 10 Mar 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609519; cv=none; b=YnRRylh6sPH4BMaD0k0DhxwbtVvejgXR8x/RMi/j/fc2FAxXMVvcoKYcJBx3KW64k4Mg4/IqLau+GKwGgKls79rZ2cID+0tRZCRb5MVmW9Jg6kxPqdOai/mDtPDTsHVghP86sCfA+OWYY2FTXzTRPyUcqhZbRq+8nuoU1xFF38E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609519; c=relaxed/simple;
	bh=nS0xm85JaRgg3L1nxfB+IxEH1kFfGIUtGwrvFvcOd0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BsVWNwSwOczSralNzHGEuqRw6E4nVBVbbE/T7O92gy2PYbTGpO5uXsftDRMHCC0/iaF/EES53WdMIrYypmZ5qyBr6PA1wZHOSFXpZz66lYgrvXFbnWrLg1a5BZ2tE25mgmZ62/1LNhCE1ZQdI1hX5FI2DDMNppDyLNxhbvQVkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p87juRiW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F10C4CEED;
	Mon, 10 Mar 2025 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609517;
	bh=nS0xm85JaRgg3L1nxfB+IxEH1kFfGIUtGwrvFvcOd0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p87juRiWQLzWtkTPJj26LxPgcBtaO2OIDCn0v1N62ba4qDoL9DTjJYQvqMWvPfSyU
	 GrodmerwDMnxDOMbfdgIcklPkrd1mSH9y94xu/aXWAG1wkq+b9k8nxvgRuCddua6gx
	 P8++j/8RNTJ5Zi3zb/zDaR0uYg2RLXKMCCTDuot1a0GnwuJ632vfEKKmYqQSJeJ6Ui
	 2zc3QlYKJsk5g34TBW3adpGUVg/7XEZFtaAmIUtANrDoEJVA7C0zxYnyIy83QoHNm+
	 5kzWYWp5ztTH8/YzeHPB42+ii6rn2kWWSVjyfD2HlGMXhhBBBttNa2yv/DOKWzavL/
	 xFAbKEXnsKuPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC3-00CAea-UF;
	Mon, 10 Mar 2025 12:25:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 22/23] KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
Date: Mon, 10 Mar 2025 12:25:04 +0000
Message-Id: <20250310122505.2857610-23-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to other registers, describe which HCR_EL2 bit depends
on which feature, and use this to compute the RES0 status of these
bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 78 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c | 40 +--------------------
 2 files changed, 79 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index f88783bd9a2f1..15ec8bdc57055 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -77,6 +77,8 @@ struct reg_bits_to_feat_map {
 #define FEAT_THE		ID_AA64PFR1_EL1, THE, IMP
 #define FEAT_SME		ID_AA64PFR1_EL1, SME, IMP
 #define FEAT_GCS		ID_AA64PFR1_EL1, GCS, IMP
+#define FEAT_LS64		ID_AA64ISAR1_EL1, LS64, LS64
+#define FEAT_LS64_V		ID_AA64ISAR1_EL1, LS64, LS64_V
 #define FEAT_LS64_ACCDATA	ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA
 #define FEAT_RAS		ID_AA64PFR0_EL1, RAS, IMP
 #define FEAT_GICv3		ID_AA64PFR0_EL1, GIC, IMP
@@ -90,6 +92,16 @@ struct reg_bits_to_feat_map {
 #define FEAT_PAN2		ID_AA64MMFR1_EL1, PAN, PAN2
 #define FEAT_DPB2		ID_AA64ISAR1_EL1, DPB, DPB2
 #define FEAT_AMUv1		ID_AA64PFR0_EL1, AMU, IMP
+#define FEAT_CMOW		ID_AA64MMFR1_EL1, CMOW, IMP
+#define FEAT_D128		ID_AA64MMFR3_EL1, D128, IMP
+#define FEAT_DoubleFault2	ID_AA64PFR1_EL1, DF2, IMP
+#define FEAT_FPMR		ID_AA64PFR2_EL1, FPMR, IMP
+#define FEAT_MOPS		ID_AA64ISAR2_EL1, MOPS, IMP
+#define FEAT_NMI		ID_AA64PFR1_EL1, NMI, IMP
+#define FEAT_SCTLR2		ID_AA64MMFR3_EL1, SCTLRX, IMP
+#define FEAT_SYSREG128		ID_AA64ISAR2_EL1, SYSREG_128, IMP
+#define FEAT_TCR2		ID_AA64MMFR3_EL1, TCRX, IMP
+#define FEAT_XS			ID_AA64ISAR1_EL1, XS, IMP
 
 static bool feat_rasv1p1(struct kvm *kvm)
 {
@@ -110,6 +122,35 @@ static bool feat_pauth(struct kvm *kvm)
 	return kvm_has_pauth(kvm, PAuth);
 }
 
+static bool feat_pauth_lr(struct kvm *kvm)
+{
+	return kvm_has_pauth(kvm, PAuth_LR);
+}
+
+static bool feat_aderr(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ADERR, FEAT_ADERR) &&
+		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SDERR, FEAT_ADERR));
+}
+
+static bool feat_anerr(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ANERR, FEAT_ANERR) &&
+		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
+}
+
+static bool feat_sme_smps(struct kvm *kvm)
+{
+	/*
+	 * Revists this if KVM ever supports SME -- this really should
+	 * look at the guest's view of SMIDR_EL1. Funnily enough, this
+	 * is not captured in the JSON file, but only as a note in the
+	 * ARM ARM.
+	 */
+	return (kvm_has_feat(kvm, FEAT_SME) &&
+		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
+}
+
 static struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 	NEEDS_FEAT(HFGxTR_EL2_nAMAIR2_EL1	|
 		   HFGxTR_EL2_nMAIR2_EL1,
@@ -494,6 +535,35 @@ static struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
 		   FEAT_AMUv1),
 };
 
+static struct reg_bits_to_feat_map hcrx_feat_map[] = {
+	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
+	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
+	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
+	NEEDS_FEAT(HCRX_EL2_EnIDCP128, FEAT_SYSREG128),
+	NEEDS_FEAT(HCRX_EL2_EnSDERR, feat_aderr),
+	NEEDS_FEAT(HCRX_EL2_TMEA, FEAT_DoubleFault2),
+	NEEDS_FEAT(HCRX_EL2_EnSNERR, feat_anerr),
+	NEEDS_FEAT(HCRX_EL2_D128En, FEAT_D128),
+	NEEDS_FEAT(HCRX_EL2_PTTWI, FEAT_THE),
+	NEEDS_FEAT(HCRX_EL2_SCTLR2En, FEAT_SCTLR2),
+	NEEDS_FEAT(HCRX_EL2_TCR2En, FEAT_TCR2),
+	NEEDS_FEAT(HCRX_EL2_MSCEn		|
+		   HCRX_EL2_MCE2,
+		   FEAT_MOPS),
+	NEEDS_FEAT(HCRX_EL2_CMOW, FEAT_CMOW),
+	NEEDS_FEAT(HCRX_EL2_VFNMI		|
+		   HCRX_EL2_VINMI		|
+		   HCRX_EL2_TALLINT,
+		   FEAT_NMI),
+	NEEDS_FEAT(HCRX_EL2_SMPME, feat_sme_smps),
+	NEEDS_FEAT(HCRX_EL2_FGTnXS		|
+		   HCRX_EL2_FnXS,
+		   FEAT_XS),
+	NEEDS_FEAT(HCRX_EL2_EnASR, FEAT_LS64_V),
+	NEEDS_FEAT(HCRX_EL2_EnALS, FEAT_LS64),
+	NEEDS_FEAT(HCRX_EL2_EnAS0, FEAT_LS64_ACCDATA),
+};
+
 static void __init check_feat_map(struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -521,6 +591,8 @@ void __init check_feature_map(void)
 		       hdfgwtr_masks.res0, hdfgwtr_masks.str);
 	check_feat_map(hafgrtr_feat_map, ARRAY_SIZE(hafgrtr_feat_map),
 		       hafgrtr_masks.res0, hafgrtr_masks.str);
+	check_feat_map(hcrx_feat_map, ARRAY_SIZE(hcrx_feat_map),
+		       __HCRX_EL2_RES0, "HCRX_EL2");
 }
 
 static bool idreg_feat_match(struct kvm *kvm, struct reg_bits_to_feat_map *map)
@@ -656,6 +728,12 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 |= hafgrtr_masks.res0;
 		*res1 = HAFGRTR_EL2_RES1;
 		break;
+	case HCRX_EL2:
+		*res0 = compute_res0_bits(kvm, hcrx_feat_map,
+					  ARRAY_SIZE(hcrx_feat_map), 0, 0);
+		*res0 |= __HCRX_EL2_RES0;
+		*res1 = __HCRX_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 74df066f9ab3f..984940781a4cf 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1039,45 +1039,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
 
 	/* HCRX_EL2 */
-	res0 = __HCRX_EL2_RES0;
-	res1 = __HCRX_EL2_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
-		res0 |= HCRX_EL2_PACMEn;
-	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
-		res0 |= HCRX_EL2_EnFPM;
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
-		res0 |= HCRX_EL2_GCSEn;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, SYSREG_128, IMP))
-		res0 |= HCRX_EL2_EnIDCP128;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ADERR, DEV_ASYNC))
-		res0 |= (HCRX_EL2_EnSDERR | HCRX_EL2_EnSNERR);
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, DF2, IMP))
-		res0 |= HCRX_EL2_TMEA;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
-		res0 |= HCRX_EL2_D128En;
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
-		res0 |= HCRX_EL2_PTTWI;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SCTLRX, IMP))
-		res0 |= HCRX_EL2_SCTLR2En;
-	if (!kvm_has_tcr2(kvm))
-		res0 |= HCRX_EL2_TCR2En;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
-		res0 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, CMOW, IMP))
-		res0 |= HCRX_EL2_CMOW;
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
-		res0 |= (HCRX_EL2_VFNMI | HCRX_EL2_VINMI | HCRX_EL2_TALLINT);
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP) ||
-	    !(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS))
-		res0 |= HCRX_EL2_SMPME;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))
-		res0 |= (HCRX_EL2_FGTnXS | HCRX_EL2_FnXS);
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
-		res0 |= HCRX_EL2_EnASR;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
-		res0 |= HCRX_EL2_EnALS;
-	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-		res0 |= HCRX_EL2_EnAS0;
+	get_reg_fixed_bits(kvm, HCRX_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
 
 	/* HFG[RW]TR_EL2 */
-- 
2.39.2


