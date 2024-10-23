Return-Path: <kvm+bounces-29547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 474339ACDF7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68EC71C21743
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99937208984;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUhvltMR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6911205AAC;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695236; cv=none; b=N5pXB1rqBTmcFo0Szof/QzIcDb3yljbn4RwGS4rGpnF0O42FIP9TDlKIlecj6jD6he0IGLLMfaWuo+0gAsd9FL9rHGApsMHfyVOwQHWSXJ4/fVadEyvnJxc3YWYlDGqakLRU5fWDDku2sLwfdilxZIs/HL/YhR6zJeUTsZvJbJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695236; c=relaxed/simple;
	bh=ZIdV0IYdRcU2goxbfbCyfcqHM0/7fCtUsdkb6ElTh5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YzmDbIXl9Dfib3gAlyAfHiGwBsiD+jbsbVZlByaiheWVzyinRXjZgIGIHWoQ294UorGtK3vsNeOcv61ew7wYmPHhZW7IZ+qH+61TomwIg6XzOPkzy2WW0/f5hXj3run2UKlybeElEaRsGXipNaE+XG17pMpzPLu2++S6kMzC3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUhvltMR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FF1C4CECD;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695236;
	bh=ZIdV0IYdRcU2goxbfbCyfcqHM0/7fCtUsdkb6ElTh5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUhvltMRvl85hHrz/0Iagi3sgcbeYapU9MX3BQW16pW6R9Px/hEAplgAsujKQeDbH
	 +KUtWgxScNgBo1rfxv/ehQiA9lYmNPTCsfKjykZeOAmrs4R0V/CVt5yT1kmUkS9lmZ
	 wu1yA1qiil4pMzezVkIE18DmwXTbn46nGD80O+DzWplqwcJ2Ft9X3u3Id48wHVKpAz
	 2Bt47nqpBKlR0NQPIv13aXSuGpbklDREuHQzNW+zduROWD1qlJF8U2glEXq3jVvsDg
	 bDsTdBqleYVVIHV4Y1UZOdUBL+mpVOT/EumqzoxzjJTaVZJ6uZQOHwM6AWKNV7iH4v
	 vZSSK8kgnQDeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckE-0068vz-ME;
	Wed, 23 Oct 2024 15:53:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 25/37] KVM: arm64: Hide S1PIE registers from userspace when disabled for guests
Date: Wed, 23 Oct 2024 15:53:33 +0100
Message-Id: <20241023145345.1613824-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Mark Brown <broonie@kernel.org>

When the guest does not support S1PIE we should not allow any access
to the system registers it adds in order to ensure that we do not create
spurious issues with guest migration. Add a visibility operation for these
registers.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-3-376624fa829c@kernel.org
[maz: simplify by using __el2_visibility(), kvm_has_s1pie() throughout]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          |  3 +++
 arch/arm64/kvm/at.c                        |  4 +--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  2 +-
 arch/arm64/kvm/nested.c                    |  4 +--
 arch/arm64/kvm/sys_regs.c                  | 31 +++++++++++++++++-----
 5 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 197a7a08b3af5..9a6997827ad49 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1514,4 +1514,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_tcr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
 
+#define kvm_has_s1pie(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a9f665d5ceb0b..de7109111e404 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -95,7 +95,7 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 
 static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 {
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(vcpu->kvm))
 		return false;
 
 	switch (regime) {
@@ -1101,7 +1101,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
 	if (kvm_has_tcr2(vcpu->kvm)) {
 		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
-		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+		if (kvm_has_s1pie(vcpu->kvm)) {
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
 		}
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index c92c2c0b86aa8..a306ea70502c4 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -58,7 +58,7 @@ static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
 		return false;
 
 	vcpu = ctxt_to_vcpu(ctxt);
-	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
+	return kvm_has_s1pie(kern_hyp_va(vcpu->kvm));
 }
 
 static inline bool ctxt_has_tcrx(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e6d7114ef4d39..47be71279c304 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1080,7 +1080,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
 	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
 		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
 		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
@@ -1194,7 +1194,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= TCR2_EL2_AIE;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
 		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		res0 |= TCR2_EL2_PIE;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
 		res0 |= (TCR2_EL2_E0POE | TCR2_EL2_D128 |
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9b26514cf131f..85b465c9ec8fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -373,7 +373,7 @@ static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
 				  struct sys_reg_params *p,
 				  const struct sys_reg_desc *r)
 {
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+	if (!kvm_has_s1pie(vcpu->kvm)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -2365,6 +2365,21 @@ static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, tcr2_visibility);
 }
 
+static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd)
+{
+	if (kvm_has_s1pie(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *rd)
+{
+	return __el2_visibility(vcpu, rd, s1pie_visibility);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2604,8 +2619,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
-	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1 },
-	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
+	  .visibility = s1pie_visibility },
+	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1,
+	  .visibility = s1pie_visibility },
 	{ SYS_DESC(SYS_POR_EL1), NULL, reset_unknown, POR_EL1,
 	  .visibility = s1poe_visibility },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
@@ -2916,8 +2933,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
-	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
-	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG_FILTERED(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
+	EL2_REG_FILTERED(PIR_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
@@ -4807,7 +4826,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
 						HFGITR_EL2_ATS1E1WP);
 
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 
-- 
2.39.2


