Return-Path: <kvm+bounces-65670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 219E1CB3A39
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AC9B30E47E4
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636BF327C18;
	Wed, 10 Dec 2025 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOhBaf3R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD36329393;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765387834; cv=none; b=faeOveERO85YQifn66j7kgFpFY0tIwtmJ9t7A3O6kNM6QvYJgqu0AmDdR50bckx9QIkQYPhX9Jrs6WcY0R/fklBFGGF3ZaH7JDKxZCHNEhLO1P/9YjQeRDDC4fR6fhqMg/ygZsxIOy+S5g4yOh5uczSn/7w4uUViZnwA2TnozJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765387834; c=relaxed/simple;
	bh=2NiH2ZW8Mz5g+N04+8fT1dv90YzRDycSHgqkWxoUYQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWz4S6ozGNgZtmYoxQEeMLSOTtQfi3Hb12U6VK6yTx0sTsK5Lsw3F/JGeu9tqSY9+Wwv1F8+6+UgZQtaDqsa7W3I7GxpBkf8CgtjB1L1KtSsAiwemw1Cpgfn9JDNJNQ+oF6WTvS636zXgAWnLVHBgsbvokxFmivf4uPe0qIlMDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOhBaf3R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96928C4AF09;
	Wed, 10 Dec 2025 17:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765387833;
	bh=2NiH2ZW8Mz5g+N04+8fT1dv90YzRDycSHgqkWxoUYQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOhBaf3ROkUswKlLrHZTBu8tFXMfvyboZc/Z/7cgi/Q/Z/O40Jc0B2NCeqBMaiOjD
	 ajaV9bhe+kVAl5JJTdGxJdANaZPAOvAbxoeABF8LWWH9F8v8wpktoBWKUq0DkoPrWp
	 NcLjNMLsKgiWNc/u/5+NGaV7x1muDpJV7JSo7pA4k416aNC2QRDMP5C9PWuArdAxRU
	 iGrDeu5SWNCXkWQKvQJRFo4LJujvnksQHIFSHiLZ17fu5jfVQwDRHOaqtHCj8BnZWI
	 tWkPat0M23McLs2f6y9xkZFzGy5fbjNwgPr646Y2JF3JrjGPMS0K7cCnGmu6WzyocO
	 R890j+HETcauQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vTO1H-0000000BnnB-2Drd;
	Wed, 10 Dec 2025 17:30:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: [PATCH v2 5/6] KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
Date: Wed, 10 Dec 2025 17:30:23 +0000
Message-ID: <20251210173024.561160-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Describe all the VTCR_EL2 fields and their respective configurations,
making sure that we correctly ignore the bits that are not defined
for a given guest configuration.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 69 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c |  3 +-
 2 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 3845b188551b6..9c04f895d3769 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -141,6 +141,7 @@ struct reg_feat_map_desc {
 #define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
 #define FEAT_AA64EL2		ID_AA64PFR0_EL1, EL2, IMP
 #define FEAT_AA64EL3		ID_AA64PFR0_EL1, EL3, IMP
+#define FEAT_SEL2		ID_AA64PFR0_EL1, SEL2, IMP
 #define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
 #define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
 #define FEAT_S1POE		ID_AA64MMFR3_EL1, S1POE, IMP
@@ -202,6 +203,8 @@ struct reg_feat_map_desc {
 #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
+#define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
+#define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
 #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
 #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
 #define FEAT_IESB		ID_AA64MMFR2_EL1, IESB, IMP
@@ -219,6 +222,7 @@ struct reg_feat_map_desc {
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
+#define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -362,6 +366,28 @@ static bool feat_pmuv3p9(struct kvm *kvm)
 	return check_pmu_revision(kvm, V3P9);
 }
 
+#define has_feat_s2tgran(k, s)						\
+  ((kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, TGRAN##s) && \
+    kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s, IMP))		     ||	\
+   kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, IMP))
+
+static bool feat_lpa2(struct kvm *kvm)
+{
+	return ((kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)    ||
+		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP))	&&
+		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)   ||
+		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))	&&
+		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4_2, 52_BIT)  ||
+		 !has_feat_s2tgran(kvm, 4))				&&
+		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16_2, 52_BIT) ||
+		 !has_feat_s2tgran(kvm, 16)));
+}
+
+static bool feat_vmid16(struct kvm *kvm)
+{
+	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
+}
+
 static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
 {
 	/* This is purely academic: AArch32 and NV are mutually exclusive */
@@ -1168,6 +1194,44 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
 
+static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
+	NEEDS_FEAT(VTCR_EL2_HDBSS, FEAT_HDBSS),
+	NEEDS_FEAT(VTCR_EL2_HAFT, FEAT_HAFT),
+	NEEDS_FEAT(VTCR_EL2_TL0		|
+		   VTCR_EL2_TL1		|
+		   VTCR_EL2_AssuredOnly	|
+		   VTCR_EL2_GCSH,
+		   FEAT_THE),
+	NEEDS_FEAT(VTCR_EL2_D128, FEAT_D128),
+	NEEDS_FEAT(VTCR_EL2_S2POE, FEAT_S2POE),
+	NEEDS_FEAT(VTCR_EL2_S2PIE, FEAT_S2PIE),
+	NEEDS_FEAT(VTCR_EL2_SL2		|
+		   VTCR_EL2_DS,
+		   feat_lpa2),
+	NEEDS_FEAT(VTCR_EL2_NSA		|
+		   VTCR_EL2_NSW,
+		   FEAT_SEL2),
+	NEEDS_FEAT(VTCR_EL2_HWU62	|
+		   VTCR_EL2_HWU61	|
+		   VTCR_EL2_HWU60	|
+		   VTCR_EL2_HWU59,
+		   FEAT_HPDS2),
+	NEEDS_FEAT(VTCR_EL2_HD, ID_AA64MMFR1_EL1, HAFDBS, DBM),
+	NEEDS_FEAT(VTCR_EL2_HA, ID_AA64MMFR1_EL1, HAFDBS, AF),
+	NEEDS_FEAT(VTCR_EL2_VS, feat_vmid16),
+	NEEDS_FEAT(VTCR_EL2_PS		|
+		   VTCR_EL2_TG0		|
+		   VTCR_EL2_SH0		|
+		   VTCR_EL2_ORGN0	|
+		   VTCR_EL2_IRGN0	|
+		   VTCR_EL2_SL0		|
+		   VTCR_EL2_T0SZ,
+		   FEAT_AA64EL1),
+};
+
+static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
+			      vtcr_el2_feat_map, FEAT_AA64EL2);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1211,6 +1275,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
 	check_reg_desc(&mdcr_el2_desc);
+	check_reg_desc(&vtcr_el2_desc);
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1425,6 +1490,10 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
 		*res1 = MDCR_EL2_RES1;
 		break;
+	case VTCR_EL2:
+		*res0 = compute_reg_res0_bits(kvm, &vtcr_el2_desc, 0, 0);
+		*res1 = VTCR_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e1ef8930c97b3..606cebcaa7c09 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1719,8 +1719,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
 
 	/* VTCR_EL2 */
-	res0 = GENMASK(63, 32) | GENMASK(30, 20);
-	res1 = BIT(31);
+	get_reg_fixed_bits(kvm, VTCR_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
 
 	/* VMPIDR_EL2 */
-- 
2.47.3


