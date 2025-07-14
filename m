Return-Path: <kvm+bounces-52316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3ECB03DD1
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC6351A600D7
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BAA24DCE8;
	Mon, 14 Jul 2025 11:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0WZiJON"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D67F248867;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=aFIchfMtuEWBJJm8xcJqESuJDFi0Zbv6Fs5yL5K27M+TRg4eCYyjXnrje68IflHMdNESiNadXsZbSA3rqNgGiuRA3T9QDE1X3mf4GTeEQUItFF0tK5+YzfBwqcloBG0ipsG5fW5qy9NhqZRXA0I4hFwsvED5yEQDhcHhk9Ikoas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=bna4wvszicgMNefOYBgXUx2bw0kd/B9OP3jI567laK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RnhkGDJsEwevKe0cxMRAwcDUsgHntFrXPIVXBYYi28nIlDV5aWmDEEHIaAdQjsbKHxvhJnd/OHMaH9Mf5QGxJmCFVtOTjoZAHoUbB1fwzr5sBHm/9Qj6EJQQoxMDo3nRuvgbhav7MM4QyrxfVw+qOOSeSZSl3yJXyd213+JzE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0WZiJON; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131B5C4CEF8;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494115;
	bh=bna4wvszicgMNefOYBgXUx2bw0kd/B9OP3jI567laK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0WZiJONfXo77B4Erwmxg3HE6MqFsEeEs/1Xe4ty5GfMzvNZs40naBbeNSntIlOHO
	 deVtpnarJvztD3fmO3KfS1C4H40TRKfJspl4KvKfkLXGJu/Y1B0rVbqCKrBZliJRqQ
	 tiOpcDeQS7fiPWF1DvOYl7NTlQNm0OVuxWnTxp/w2QuCWG0Lx2PS4XIAfpSpcgqq4S
	 l2DIhZJfl7hoG6SZLIqF3POL1H/vsheT1Vzz2CywAjCyHITwML07uOtEdTbbYNB7Ua
	 HcgVus3X6NIwgeJEI5g7bug09ce1mTO/iQpjKsUZmu8bsDDDMMGW05jxIXUaxPLrGk
	 5aB8U4I8P8dRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm5-00FVUo-4L;
	Mon, 14 Jul 2025 12:55:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/5] KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
Date: Mon, 14 Jul 2025 12:55:01 +0100
Message-Id: <20250714115503.3334242-4-maz@kernel.org>
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
affecting SCTLR_EL1 to be driven by a table extracted from the 2025-06
JSON drop

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 106 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c |   5 +-
 2 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 8265b722d442b..540308429ffe7 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -134,6 +134,20 @@ struct reg_bits_to_feat_map {
 #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
+#define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
+#define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
+#define FEAT_IESB		ID_AA64MMFR2_EL1, IESB, IMP
+#define FEAT_LSE2		ID_AA64MMFR2_EL1, AT, IMP
+#define FEAT_LSMAOC		ID_AA64MMFR2_EL1, LSM, IMP
+#define FEAT_MixedEnd		ID_AA64MMFR0_EL1, BIGEND, IMP
+#define FEAT_MixedEndEL0	ID_AA64MMFR0_EL1, BIGENDEL0, IMP
+#define FEAT_MTE2		ID_AA64PFR1_EL1, MTE, MTE2
+#define FEAT_MTE_ASYNC		ID_AA64PFR1_EL1, MTE_frac, ASYNC
+#define FEAT_MTE_STORE_ONLY	ID_AA64PFR2_EL1, MTESTOREONLY, IMP
+#define FEAT_PAN		ID_AA64MMFR1_EL1, PAN, IMP
+#define FEAT_PAN3		ID_AA64MMFR1_EL1, PAN, PAN3
+#define FEAT_SSBS		ID_AA64PFR1_EL1, SSBS, IMP
+#define FEAT_TIDCP1		ID_AA64MMFR1_EL1, TIDCP1, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -241,6 +255,16 @@ static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
 	return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
 }
 
+static bool feat_mixedendel0(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_MixedEnd) || kvm_has_feat(kvm, FEAT_MixedEndEL0);
+}
+
+static bool feat_mte_async(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_MTE2) && kvm_has_feat_enum(kvm, FEAT_MTE_ASYNC);
+}
+
 static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
 {
 	/* This is purely academic: AArch32 and NV are mutually exclusive */
@@ -872,6 +896,80 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
 };
 
+static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
+	NEEDS_FEAT(SCTLR_EL1_CP15BEN	|
+		   SCTLR_EL1_ITD	|
+		   SCTLR_EL1_SED,
+		   FEAT_AA32EL0),
+	NEEDS_FEAT(SCTLR_EL1_BT0	|
+		   SCTLR_EL1_BT1,
+		   FEAT_BTI),
+	NEEDS_FEAT(SCTLR_EL1_CMOW, FEAT_CMOW),
+	NEEDS_FEAT(SCTLR_EL1_TSCXT, feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT(SCTLR_EL1_EIS	|
+		   SCTLR_EL1_EOS,
+		   FEAT_ExS),
+	NEEDS_FEAT(SCTLR_EL1_EnFPM, FEAT_FPMR),
+	NEEDS_FEAT(SCTLR_EL1_IESB, FEAT_IESB),
+	NEEDS_FEAT(SCTLR_EL1_EnALS, FEAT_LS64),
+	NEEDS_FEAT(SCTLR_EL1_EnAS0, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT(SCTLR_EL1_EnASR, FEAT_LS64_V),
+	NEEDS_FEAT(SCTLR_EL1_nAA, FEAT_LSE2),
+	NEEDS_FEAT(SCTLR_EL1_LSMAOE	|
+		   SCTLR_EL1_nTLSMD,
+		   FEAT_LSMAOC),
+	NEEDS_FEAT(SCTLR_EL1_EE, FEAT_MixedEnd),
+	NEEDS_FEAT(SCTLR_EL1_E0E, feat_mixedendel0),
+	NEEDS_FEAT(SCTLR_EL1_MSCEn, FEAT_MOPS),
+	NEEDS_FEAT(SCTLR_EL1_ATA0	|
+		   SCTLR_EL1_ATA	|
+		   SCTLR_EL1_TCF0	|
+		   SCTLR_EL1_TCF,
+		   FEAT_MTE2),
+	NEEDS_FEAT(SCTLR_EL1_ITFSB, feat_mte_async),
+	NEEDS_FEAT(SCTLR_EL1_TCSO0	|
+		   SCTLR_EL1_TCSO,
+		   FEAT_MTE_STORE_ONLY),
+	NEEDS_FEAT(SCTLR_EL1_NMI	|
+		   SCTLR_EL1_SPINTMASK,
+		   FEAT_NMI),
+	NEEDS_FEAT(SCTLR_EL1_SPAN, FEAT_PAN),
+	NEEDS_FEAT(SCTLR_EL1_EPAN, FEAT_PAN3),
+	NEEDS_FEAT(SCTLR_EL1_EnDA	|
+		   SCTLR_EL1_EnDB	|
+		   SCTLR_EL1_EnIA	|
+		   SCTLR_EL1_EnIB,
+		   feat_pauth),
+	NEEDS_FEAT(SCTLR_EL1_EnTP2, FEAT_SME),
+	NEEDS_FEAT(SCTLR_EL1_EnRCTX, FEAT_SPECRES),
+	NEEDS_FEAT(SCTLR_EL1_DSSBS, FEAT_SSBS),
+	NEEDS_FEAT(SCTLR_EL1_TIDCP, FEAT_TIDCP1),
+	NEEDS_FEAT(SCTLR_EL1_TME0	|
+		   SCTLR_EL1_TME	|
+		   SCTLR_EL1_TMT0	|
+		   SCTLR_EL1_TMT,
+		   FEAT_TME),
+	NEEDS_FEAT(SCTLR_EL1_TWEDEL	|
+		   SCTLR_EL1_TWEDEn,
+		   FEAT_TWED),
+	NEEDS_FEAT(SCTLR_EL1_UCI	|
+		   SCTLR_EL1_EE		|
+		   SCTLR_EL1_E0E	|
+		   SCTLR_EL1_WXN	|
+		   SCTLR_EL1_nTWE	|
+		   SCTLR_EL1_nTWI	|
+		   SCTLR_EL1_UCT	|
+		   SCTLR_EL1_DZE	|
+		   SCTLR_EL1_I		|
+		   SCTLR_EL1_UMA	|
+		   SCTLR_EL1_SA0	|
+		   SCTLR_EL1_SA		|
+		   SCTLR_EL1_C		|
+		   SCTLR_EL1_A		|
+		   SCTLR_EL1_M,
+		   FEAT_AA64EL1),
+};
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -905,6 +1003,8 @@ void __init check_feature_map(void)
 		       HCR_EL2_RES0, "HCR_EL2");
 	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
 		       TCR2_EL2_RES0, "TCR2_EL2");
+	check_feat_map(sctlr_el1_feat_map, ARRAY_SIZE(sctlr_el1_feat_map),
+		       SCTLR_EL1_RES0, "SCTLR_EL1");
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1125,6 +1225,12 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 |= TCR2_EL2_RES0;
 		*res1 = TCR2_EL2_RES1;
 		break;
+	case SCTLR_EL1:
+		*res0 = compute_res0_bits(kvm, sctlr_el1_feat_map,
+					  ARRAY_SIZE(sctlr_el1_feat_map), 0, 0);
+		*res0 |= SCTLR_EL1_RES0;
+		*res1 = SCTLR_EL1_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index efb1f2caca626..bca4b5d4b9898 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1667,10 +1667,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
 
 	/* SCTLR_EL1 */
-	res0 = SCTLR_EL1_RES0;
-	res1 = SCTLR_EL1_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
-		res0 |= SCTLR_EL1_EPAN;
+	get_reg_fixed_bits(kvm, SCTLR_EL1, &res0, &res1);
 	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
 
 	/* MDCR_EL2 */
-- 
2.39.2


