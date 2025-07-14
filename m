Return-Path: <kvm+bounces-52314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B26B03DD2
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4BA017C90E
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435B924DCE3;
	Mon, 14 Jul 2025 11:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMyzyeru"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5A02475C3;
	Mon, 14 Jul 2025 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=OTyfhe7PH9bsZF6bXRjqcMtZT6xLWiXqi9TKg8HonIGLe4ekq7Di2ru3k+oE5wgORYbusNsJccJW9ndm5dHKcefj+iR6IW1zJQOfIYgW/Hoe3j2sK7PQNyNndD4f8P97qc8fpR2L9BaIgXOlKuh82YIyzDJMqUHZ31XgqRbZYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=+zOSkRloH1/QthlAEcGl0BR/Wd1JvbPUlP7kJNobEkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PwYTJW8ZIIIPjQSO6wARDrSiWqJzUrnGuU1cvLDlfCDyE/dFGTrbvHIm4s9zpEVVwfe3cG0GhJuEgBsmunv8vnafquBGRUNX7AeWML2eiv5fh7OnxTMZrG8/HEmBMc4ZGWsvyKvWORnOTWBneEESQ7ZdYZ4XgFQUba+hVkKsVqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMyzyeru; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6374C4CEF4;
	Mon, 14 Jul 2025 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494114;
	bh=+zOSkRloH1/QthlAEcGl0BR/Wd1JvbPUlP7kJNobEkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMyzyeruhryQo/k+uG41OevCsvfsemAlhYUsXpGT1k1ZFotyccV4fIiFgXJCPVKDF
	 Qmz1Ayq4UyR5VeEhzC+nhLN7FPGjcHbqsVXcPNHdHixofi65ynfOq57kffjThg83mM
	 5ouNKJMnHHH+71+FkA0CNy+l/Pq4qDbtUgyTcUhiORSJAoXf3/3T06ZSzl9efYkeva
	 ULj/Yyoq2ScA51kiI16/Jmfz9YIDVlYPWtbdXkNH7RSQsPsiY/k4KedGlPT7TJiGcD
	 NXDGDpdlvzFj0BNBtxcV6x3UGZO/KmYaUZxxIGHvf/ZhcS7XxRL9XSpIdNnY3NfdPR
	 mGgKINCmlR1tg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm4-00FVUo-VH;
	Mon, 14 Jul 2025 12:55:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/5] KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
Date: Mon, 14 Jul 2025 12:55:00 +0100
Message-Id: <20250714115503.3334242-3-maz@kernel.org>
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
affecting TCR2_EL2 to be driven by a table extracted from the 2025-06
JSON drop.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 48 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c | 20 +----------------
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 54911a93b0018..8265b722d442b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -131,6 +131,9 @@ struct reg_bits_to_feat_map {
 #define FEAT_SPMU		ID_AA64DFR1_EL1, SPMU, IMP
 #define FEAT_SPE_nVM		ID_AA64DFR2_EL1, SPE_nVM, IMP
 #define FEAT_STEP2		ID_AA64DFR2_EL1, STEP, IMP
+#define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
+#define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
+#define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -218,6 +221,21 @@ static bool feat_trbe_mpam(struct kvm *kvm)
 		(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_MPAM));
 }
 
+static bool feat_asid2_e2h1(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_ASID2) && !kvm_has_feat(kvm, FEAT_E2H0);
+}
+
+static bool feat_d128_e2h1(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_D128) && !kvm_has_feat(kvm, FEAT_E2H0);
+}
+
+static bool feat_mec_e2h1(struct kvm *kvm)
+{
+	return kvm_has_feat(kvm, FEAT_MEC) && !kvm_has_feat(kvm, FEAT_E2H0);
+}
+
 static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
 {
 	return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
@@ -832,6 +850,28 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
 };
 
+static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
+	NEEDS_FEAT(TCR2_EL2_FNG1	|
+		   TCR2_EL2_FNG0	|
+		   TCR2_EL2_A2,
+		   feat_asid2_e2h1),
+	NEEDS_FEAT(TCR2_EL2_DisCH1	|
+		   TCR2_EL2_DisCH0	|
+		   TCR2_EL2_D128,
+		   feat_d128_e2h1),
+	NEEDS_FEAT(TCR2_EL2_AMEC1, feat_mec_e2h1),
+	NEEDS_FEAT(TCR2_EL2_AMEC0, FEAT_MEC),
+	NEEDS_FEAT(TCR2_EL2_HAFT, FEAT_HAFT),
+	NEEDS_FEAT(TCR2_EL2_PTTWI	|
+		   TCR2_EL2_PnCH,
+		   FEAT_THE),
+	NEEDS_FEAT(TCR2_EL2_AIE, FEAT_AIE),
+	NEEDS_FEAT(TCR2_EL2_POE		|
+		   TCR2_EL2_E0POE,
+		   FEAT_S1POE),
+	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
+};
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 res0, const char *str)
 {
@@ -863,6 +903,8 @@ void __init check_feature_map(void)
 		       __HCRX_EL2_RES0, "HCRX_EL2");
 	check_feat_map(hcr_feat_map, ARRAY_SIZE(hcr_feat_map),
 		       HCR_EL2_RES0, "HCR_EL2");
+	check_feat_map(tcr2_el2_feat_map, ARRAY_SIZE(tcr2_el2_feat_map),
+		       TCR2_EL2_RES0, "TCR2_EL2");
 }
 
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
@@ -1077,6 +1119,12 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		*res0 |= HCR_EL2_RES0 | (mask & ~fixed);
 		*res1 = HCR_EL2_RES1 | (mask & fixed);
 		break;
+	case TCR2_EL2:
+		*res0 = compute_res0_bits(kvm, tcr2_el2_feat_map,
+					  ARRAY_SIZE(tcr2_el2_feat_map), 0, 0);
+		*res0 |= TCR2_EL2_RES0;
+		*res1 = TCR2_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 = *res1 = 0;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5b191f4dc5668..efb1f2caca626 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1663,25 +1663,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HFGITR2_EL2, res0, res1);
 
 	/* TCR2_EL2 */
-	res0 = TCR2_EL2_RES0;
-	res1 = TCR2_EL2_RES1;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
-		res0 |= (TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1 | TCR2_EL2_D128);
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, MEC, IMP))
-		res0 |= TCR2_EL2_AMEC1 | TCR2_EL2_AMEC0;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT))
-		res0 |= TCR2_EL2_HAFT;
-	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
-		res0 |= TCR2_EL2_PTTWI | TCR2_EL2_PnCH;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
-		res0 |= TCR2_EL2_AIE;
-	if (!kvm_has_s1poe(kvm))
-		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
-	if (!kvm_has_s1pie(kvm))
-		res0 |= TCR2_EL2_PIE;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
-		res0 |= (TCR2_EL2_E0POE | TCR2_EL2_D128 |
-			 TCR2_EL2_AMEC1 | TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1);
+	get_reg_fixed_bits(kvm, TCR2_EL2, &res0, &res1);
 	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
 
 	/* SCTLR_EL1 */
-- 
2.39.2


