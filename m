Return-Path: <kvm+bounces-52315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A94DB03DD3
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15B554A013F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4699924DCE6;
	Mon, 14 Jul 2025 11:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQOS2dCZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D61C2475CB;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=ORQw0VDAHE8kkPdICB+9PYTtFgb+6sb76KqX0y3QJvtAWc66Q05f6OpqpvmeESTqlagWhRdbdWmnEw8SptTRSOn8uzVnd1174zSZjuBYopxh7GfmzGCLkrDCmK1/kn37Pj1ANq9bnRxd2Dn00IIsLejNY3iKMh7YyIOEBqn7+3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=TxhxnXhTETlZWTOKMW2p2YioB6itKYKM1Txb0VT8JEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lhgtQkuofjkjgXeX4lizWDHv+V3gwrOKEnPJWpfCMXbhiJsAd1r4zYWfwXIP0bTgemq/7MaLytCnvPBXw+5L9jGFw6AD8pGdB8Wa8PREs6OxGInN79HbH6kOrWcIcsP41aNEOsLc0FNgoziWvesyKhzJSAI361PpbnpFF67fBxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQOS2dCZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B9BC4CEF6;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494115;
	bh=TxhxnXhTETlZWTOKMW2p2YioB6itKYKM1Txb0VT8JEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQOS2dCZBWJ1RA588gNd8qUce0wQ0No+ACo3rtAZmbJAerwyncSgSUXB0t35L6psx
	 Uq0Ihha+F3TGmOH7P1sc37WfiwmMcN1tiX89qo+gfe5YCjD59iGNMEUBQSvFoIYMiv
	 CcsO/KuIwPtqzEPrJoDhTnNMaewTCsJ3pcXbF25eYFYw6sDaEG3icHjgHzjgP2h2j9
	 Z5Awzthihm1KlH7P+fccrX6gkJ+Z6Yft7qGosn3vBJUcBQRvr58ezPDaHs6XDiUcoZ
	 /P4qxDXoHdWDfSFWjqreII1xICGo+O2YOt6ItGo/9amrYvOxsBuFghgRz9DLI1yyEZ
	 rTVoP84PUkIqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm5-00FVUo-A1;
	Mon, 14 Jul 2025 12:55:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/5] KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
Date: Mon, 14 Jul 2025 12:55:02 +0100
Message-Id: <20250714115503.3334242-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714115503.3334242-1-maz@kernel.org>
References: <20250714115503.3334242-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As for other registers, convert the determination of the RES0 bits
affecting MDCR_EL2 to be driven by a table extracted from the 2025-06
JSON drop

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 63 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c | 35 +----------------------
 2 files changed, 64 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 540308429ffe7..6ea968c1624e4 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -89,6 +89,7 @@ struct reg_bits_to_feat_map {
 #define FEAT_RASv2		ID_AA64PFR0_EL1, RAS, V2
 #define FEAT_GICv3		ID_AA64PFR0_EL1, GIC, IMP
 #define FEAT_LOR		ID_AA64MMFR1_EL1, LO, IMP
+#define FEAT_SPEv1p2		ID_AA64DFR0_EL1, PMSVer, V1P2
 #define FEAT_SPEv1p4		ID_AA64DFR0_EL1, PMSVer, V1P4
 #define FEAT_SPEv1p5		ID_AA64DFR0_EL1, PMSVer, V1P5
 #define FEAT_ATS1A		ID_AA64ISAR2_EL1, ATS1A, IMP
@@ -148,6 +149,8 @@ struct reg_bits_to_feat_map {
 #define FEAT_PAN3		ID_AA64MMFR1_EL1, PAN, PAN3
 #define FEAT_SSBS		ID_AA64PFR1_EL1, SSBS, IMP
 #define FEAT_TIDCP1		ID_AA64MMFR1_EL1, TIDCP1, IMP
+#define FEAT_FGT		ID_AA64MMFR0_EL1, FGT, IMP
+#define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -265,6 +268,27 @@ static bool feat_mte_async(struct kvm *kvm)
 	return kvm_has_feat(kvm, FEAT_MTE2) && kvm_has_feat_enum(kvm, FEAT_MTE_ASYNC);
 }
 
+#define check_pmu_revision(k, r)					\
+	({								\
+		(kvm_has_feat((k), ID_AA64DFR0_EL1, PMUVer, r) &&	\
+		 !kvm_has_feat((k), ID_AA64DFR0_EL1, PMUVer, IMP_DEF));	\
+	})
+
+static bool feat_pmuv3p1(struct kvm *kvm)
+{
+	return check_pmu_revision(kvm, V3P1);
+}
+
+static bool feat_pmuv3p5(struct kvm *kvm)
+{
+	return check_pmu_revision(kvm, V3P5);
+}
+
+static bool feat_pmuv3p7(struct kvm *kvm)
+{
+	return check_pmu_revision(kvm, V3P7);
+}
+
 static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
 {
 	/* This is purely academic: AArch32 and NV are mutually exclusive */
@@ -970,6 +994,37 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   FEAT_AA64EL1),
 };
 
+static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
+	NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
+	NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
+	NEEDS_FEAT(MDCR_EL2_PMEE, FEAT_EBEP),
+	NEEDS_FEAT(MDCR_EL2_TDCC, FEAT_FGT),
+	NEEDS_FEAT(MDCR_EL2_MTPME, FEAT_MTPMU),
+	NEEDS_FEAT(MDCR_EL2_HPME	|
+		   MDCR_EL2_HPMN	|
+		   MDCR_EL2_TPMCR	|
+		   MDCR_EL2_TPM,
+		   FEAT_PMUv3),
+	NEEDS_FEAT(MDCR_EL2_HPMD, feat_pmuv3p1),
+	NEEDS_FEAT(MDCR_EL2_HCCD	|
+		   MDCR_EL2_HLP,
+		   feat_pmuv3p5),
+	NEEDS_FEAT(MDCR_EL2_HPMFZO, feat_pmuv3p7),
+	NEEDS_FEAT(MDCR_EL2_PMSSE, FEAT_PMUv3_SS),
+	NEEDS_FEAT(MDCR_EL2_E2PB	|
+		   MDCR_EL2_TPMS,
+		   FEAT_SPE),
+	NEEDS_FEAT(MDCR_EL2_HPMFZS, FEAT_SPEv1p2),
+	NEEDS_FEAT(MDCR_EL2_EnSPM, FEAT_SPMU),
+	NEEDS_FEAT(MDCR_EL2_EnSTEPOP, FEAT_STEP2),
+	NEEDS_FEAT(MDCR_EL2_E2TB, FEAT_TRBE),
+	NEEDS_FEAT(MDCR_EL2_TTRF, FEAT_TRF),
+	NEEDS_FEAT(MDCR_EL2_TDA		|
+		   MDCR_EL2_TDE		|
+		   MDCR_EL2_TDRA,
+		   FEAT_AA64EL1),
+};
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -1005,6 +1060,8 @@ void __init check_feature_map(void)
 		       TCR2_EL2_RES0, "TCR2_EL2");
 	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
 		       SCTLR_EL1_RES0, "SCTLR_EL1");
+	check_feat_map(mdcr_el2_feat_map, ARRAY_SIZE(mdcr_el2_feat_map),
+		       MDCR_EL2_RES0, "MDCR_EL2");
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1231,6 +1288,12 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 |= SCTLR_EL1_RES0;
 		*res1 = SCTLR_EL1_RES1;
 		break;
+	case MDCR_EL2:
+		*res0 = compute_res0_bits(kvm, mdcr_el2_feat_map,
+					  ARRAY_SIZE(mdcr_el2_feat_map), 0, 0);
+		*res0 |= MDCR_EL2_RES0;
+		*res1 = MDCR_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index bca4b5d4b9898..77f92d79d442f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1671,40 +1671,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
 
 	/* MDCR_EL2 */
-	res0 = MDCR_EL2_RES0;
-	res1 = MDCR_EL2_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
-		res0 |= (MDCR_EL2_HPMN | MDCR_EL2_TPMCR |
-			 MDCR_EL2_TPM | MDCR_EL2_HPME);
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
-		res0 |= MDCR_EL2_E2PB | MDCR_EL2_TPMS;
-	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
-		res0 |= MDCR_EL2_EnSPM;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P1))
-		res0 |= MDCR_EL2_HPMD;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
-		res0 |= MDCR_EL2_TTRF;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
-		res0 |= MDCR_EL2_HCCD | MDCR_EL2_HLP;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
-		res0 |= MDCR_EL2_E2TB;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
-		res0 |= MDCR_EL2_TDCC;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, MTPMU, IMP) ||
-	    kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
-		res0 |= MDCR_EL2_MTPME;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P7))
-		res0 |= MDCR_EL2_HPMFZO;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
-		res0 |= MDCR_EL2_PMSSE;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
-		res0 |= MDCR_EL2_HPMFZS;
-	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP))
-		res0 |= MDCR_EL2_PMEE;
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
-		res0 |= MDCR_EL2_EBWE;
-	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, STEP, IMP))
-		res0 |= MDCR_EL2_EnSTEPOP;
+	get_reg_fixed_bits(kvm, MDCR_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
 
 	/* CNTHCTL_EL2 */
-- 
2.39.2


