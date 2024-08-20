Return-Path: <kvm+bounces-24598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B83D795839A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13C1BB2263E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0925118E050;
	Tue, 20 Aug 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4HztAp/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4118E042;
	Tue, 20 Aug 2024 10:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148380; cv=none; b=MLlftr3fzISCDSoB6jstsvVawmNaRNdp0YGQVG5ppge7+qxs3LDS/b2E5XqP9hx7BohjBrH8NmaELiT/PzRen9WuDapYMiinvSdJi56DYmKdQfqcSbteIuow0csiEtobIPzIWNm0lCucwAREEaajZqzH/dfhuYLuxRkVydq1Uac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148380; c=relaxed/simple;
	bh=C2eTDO+fdqtzHl2Tx3ckQlZjE8ZMHfX2DHTU0kgJmfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZG/aJ+G+QXR16dB1/7nX4CyATubJjd7EqziFlAH3et45FXMfNeyF6EDITx6OU2zA04UsMEEc/Ba5iYMgb0cHh88lXW8TTLP3qyUP+TaqKuTz5t+S/h3niOn97wGPTfd8YIPtU5gIyHQiYijcQCyc0A6toXYGoIqq8oC7A54q6MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4HztAp/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE104C4AF10;
	Tue, 20 Aug 2024 10:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148380;
	bh=C2eTDO+fdqtzHl2Tx3ckQlZjE8ZMHfX2DHTU0kgJmfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4HztAp/xqdT81xdKsFef2be4O14Vh8G8240bzIq8kdreci5SDxiZTmE0WvS793xA
	 PZlzeHceHXijWdQISIbxubjFVJNVdVwl9cYSvIWo8suaao40Q6Vf7mECYZ/De4Dzni
	 R7DFhV6jEF3V3oaVGiR8MnE/JPbXoDdcdlcO5MoU759F9d5Blm0CYwWthXS5FNWRkg
	 1CPmGSftgOsI1fMHHIRcbViYKWMMWwTtIsT0v0ddGM/Dtq3vY8qcxOSkIivf+9gWvp
	 vOEHHSJagTetxeLB1uZRdrY7HAzVgzVweD/d6ZFF5Zi6brOLZmUSMmIM7lNclUJ4pP
	 ZpQe3vRx1IBfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkn-005Dk2-E3;
	Tue, 20 Aug 2024 11:06:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 10/12] KVM: arm64: Make most GICv3 accesses UNDEF if they trap
Date: Tue, 20 Aug 2024 11:03:47 +0100
Message-Id: <20240820100349.3544850-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We don't expect to trap any GICv3 register for host handling,
apart from ICC_SRE_EL1 and the SGI registers. If they trap,
that's because the guest is playing with us despite being
told it doesn't have a GICv3.

If it does, UNDEF is what it will get.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 ++
 arch/arm64/kvm/sys_regs.c       | 74 +++++++++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.h       |  7 ++++
 3 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index a01138a663ae..a0291f4b0eb9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1120,6 +1120,9 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	bool is_read;
 	u32 sysreg;
 
+	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return 0;
+
 	esr = kvm_vcpu_get_esr(vcpu);
 	if (vcpu_mode_is_32bit(vcpu)) {
 		if (!kvm_condition_valid(vcpu)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c14fea3abc1b..ba6075973a36 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -47,6 +47,13 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val);
 
+static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
 static bool bad_trap(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *params,
 		     const struct sys_reg_desc *r,
@@ -484,6 +491,9 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
+	if (!kvm_has_gicv3(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
@@ -1344,14 +1354,6 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	  .reset = reset_pmevtyper,					\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
-static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	kvm_inject_undefined(vcpu);
-
-	return false;
-}
-
 /* Macro to expand the AMU counter and type registers*/
 #define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), undef_access }
 #define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), undef_access }
@@ -2454,6 +2456,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SPSR_EL1), access_spsr},
 	{ SYS_DESC(SYS_ELR_EL1), access_elr},
 
+	{ SYS_DESC(SYS_ICC_PMR_EL1), undef_access },
+
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
@@ -2508,18 +2512,31 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
 	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
 
-	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
-	{ SYS_DESC(SYS_ICC_EOIR0_EL1), read_from_write_only },
-	{ SYS_DESC(SYS_ICC_HPPIR0_EL1), write_to_read_only },
-	{ SYS_DESC(SYS_ICC_DIR_EL1), read_from_write_only },
-	{ SYS_DESC(SYS_ICC_RPR_EL1), write_to_read_only },
+	{ SYS_DESC(SYS_ICC_IAR0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_EOIR0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_HPPIR0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_BPR0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP0R0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP0R1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP0R2_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP0R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP1R0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_DIR_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
 	{ SYS_DESC(SYS_ICC_ASGI1R_EL1), access_gic_sgi },
 	{ SYS_DESC(SYS_ICC_SGI0R_EL1), access_gic_sgi },
-	{ SYS_DESC(SYS_ICC_IAR1_EL1), write_to_read_only },
-	{ SYS_DESC(SYS_ICC_EOIR1_EL1), read_from_write_only },
-	{ SYS_DESC(SYS_ICC_HPPIR1_EL1), write_to_read_only },
+	{ SYS_DESC(SYS_ICC_IAR1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_EOIR1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_HPPIR1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_BPR1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_CTLR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
+	{ SYS_DESC(SYS_ICC_IGRPEN0_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), undef_access },
 
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
@@ -3394,6 +3411,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	/* TTBCR2 */
 	{ AA32(HI), Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, TCR_EL1 },
 	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, DACR32_EL2 },
+	{ CP15_SYS_DESC(SYS_ICC_PMR_EL1), undef_access },
 	/* DFSR */
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, ESR_EL1 },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, IFSR32_EL2 },
@@ -3443,8 +3461,28 @@ static const struct sys_reg_desc cp15_regs[] = {
 	/* AMAIR1 */
 	{ AA32(HI), Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, AMAIR_EL1 },
 
-	/* ICC_SRE */
-	{ Op1( 0), CRn(12), CRm(12), Op2( 5), access_gic_sre },
+	{ CP15_SYS_DESC(SYS_ICC_IAR0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_EOIR0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_HPPIR0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_BPR0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP0R0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP0R1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP0R2_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP0R3_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP1R0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_DIR_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_IAR1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_EOIR1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_HPPIR1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_BPR1_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_CTLR_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
+	{ CP15_SYS_DESC(SYS_ICC_IGRPEN0_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_IGRPEN1_EL1), undef_access },
 
 	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, CONTEXTIDR_EL1 },
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 7c9b4eb0baa6..dfb2ec83b284 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -250,4 +250,11 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+#define CP15_SYS_DESC(reg)				\
+	.name = #reg,					\
+	.aarch32_map = AA32_DIRECT,			\
+	Op0(0), Op1(sys_reg_Op1(reg)),			\
+	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
+	Op2(sys_reg_Op2(reg))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.39.2


