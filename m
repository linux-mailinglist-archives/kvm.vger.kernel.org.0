Return-Path: <kvm+bounces-25170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37AEA961216
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88E76B2903E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826B61CE6EF;
	Tue, 27 Aug 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cak3OSvv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5371C7B63;
	Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772331; cv=none; b=WCpqImwa3+YX279inf7+nPy4WXwN3a2fBh7SFO/dlADRPDaeDPZfs7YMlKHuvGoIJbRKgGQhdOm2BUtdceBbgnSuTCS+UKuK8kyBVM0JK00GiZpps73y7pBwXiYrLu0gLz8yuF37/rFRYacQTtYkCoV3Y1FWuznNYVOsjiKSY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772331; c=relaxed/simple;
	bh=d9/vPD6r8m+ZxCw8Ldr1tJOIws2zgNGiJj0QcwdZ0ZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W2v/od1r/1gknp7CeIPq6dpxvDv4Ea5Cv+JZc7nD5NKCUVqE9J7V6pvK+A28LrF57zfDiMqCZMPDC1OsZCKUnOnS0c4i/VvdkTqnEP6A7aEEEZmTyZwF/ouFZtC2LIzZnQooVD2x5m0FdsGSo0SUGt2nit4WYcknS9I+vmDpGZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cak3OSvv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E414C4DE0B;
	Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772331;
	bh=d9/vPD6r8m+ZxCw8Ldr1tJOIws2zgNGiJj0QcwdZ0ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cak3OSvv44gMdI/2jjjY/FIEkx90oxMpbDYcdppKxHcOyfDT54PJ+2DKxDM12NkOu
	 XfV3slIsvBroNsJcdJWJ3VM6WqveqDTbUaz6LP8IOIbp1oxgwq1xcmcjXdj7jh7hrK
	 N/XzUEuAF/1OCfLUiCk383e2PFDXWTWhB/r6ZagEwiCuMA7yMJzFWzkdExthdxxWjn
	 i3LhV7ncCfeUMjf+6+uke6JUiNHP64eZYlkOG/YWZihjEkWoBIYt9Hlug1ohFWHy7b
	 7bWV08Qmqyp2dpt9k2IpYxkU7SHU6VKlWxqEliSkla/b5jlEnYSdP7QEYjUOPVloiu
	 Hp0YOfleAVoFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4X-007HOs-EW;
	Tue, 27 Aug 2024 16:25:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 10/11] KVM: arm64: Unify UNDEF injection helpers
Date: Tue, 27 Aug 2024 16:25:16 +0100
Message-Id: <20240827152517.3909653-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
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

We currently have two helpers (undef_access() and trap_undef()) that
do exactly the same thing: inject an UNDEF and return 'false' (as an
indication that PC should not be incremented).

We definitely could do with one less. Given that undef_access() is
used 80ish times, while trap_undef() is only used 30 times, the
latter loses the battle and is immediately sacrificed.

We also have a large number of instances where undef_access() is
open-coded. Let's also convert those.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 132 +++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 81 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b93ad721fb7f..a3f273f55777 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -61,8 +61,7 @@ static bool bad_trap(struct kvm_vcpu *vcpu,
 {
 	WARN_ONCE(1, "Unexpected %s\n", msg);
 	print_sys_reg_instr(params);
-	kvm_inject_undefined(vcpu);
-	return false;
+	return undef_access(vcpu, params, r);
 }
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -353,10 +352,8 @@ static bool access_dcgsw(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	if (!kvm_has_mte(vcpu->kvm)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_has_mte(vcpu->kvm))
+		return undef_access(vcpu, p, r);
 
 	/* Treat MTE S/W ops as we treat the classic ones: with contempt */
 	return access_dcsw(vcpu, p, r);
@@ -393,10 +390,8 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	u64 val, mask, shift;
 
 	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
-	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		return undef_access(vcpu, p, r);
 
 	BUG_ON(!p->is_write);
 
@@ -443,10 +438,8 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 {
 	bool g1;
 
-	if (!kvm_has_gicv3(vcpu->kvm)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_has_gicv3(vcpu->kvm))
+		return undef_access(vcpu, p, r);
 
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
@@ -511,14 +504,6 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
-static bool trap_undef(struct kvm_vcpu *vcpu,
-		       struct sys_reg_params *p,
-		       const struct sys_reg_desc *r)
-{
-	kvm_inject_undefined(vcpu);
-	return false;
-}
-
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -531,10 +516,8 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 {
 	u32 sr = reg_to_encoding(r);
 
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, LO, IMP)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, LO, IMP))
+		return undef_access(vcpu, p, r);
 
 	if (p->is_write && sr == SYS_LORID_EL1)
 		return write_to_read_only(vcpu, p, r);
@@ -1267,10 +1250,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		if (!vcpu_mode_priv(vcpu)) {
-			kvm_inject_undefined(vcpu);
-			return false;
-		}
+		if (!vcpu_mode_priv(vcpu))
+			return undef_access(vcpu, p, r);
 
 		__vcpu_sys_reg(vcpu, PMUSERENR_EL0) =
 			       p->regval & ARMV8_PMU_USERENR_MASK;
@@ -1412,8 +1393,7 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
-		kvm_inject_undefined(vcpu);
-		return false;
+		return undef_access(vcpu, p, r);
 	}
 
 	if (p->is_write)
@@ -2309,7 +2289,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	// DBGDTR[TR]X_EL0 share the same encoding
 	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
 
-	{ SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 },
+	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
@@ -2780,7 +2760,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
-	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
+	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
 	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HDFGWTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HAFGRTR_EL2, reset_val, 0),
@@ -2798,11 +2778,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SPSR_fiq), .access = trap_raz_wi,
 	  .visibility = hidden_user_visibility },
 
-	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_IFSR32_EL2), undef_access, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
 	EL2_REG_REDIR(ESR_EL2, reset_val, 0),
-	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), undef_access, reset_val, FPEXC32_EL2, 0x700 },
 
 	EL2_REG_REDIR(FAR_EL2, reset_val, 0),
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
@@ -2812,7 +2792,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
-	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
+	{ SYS_DESC(SYS_RMR_EL2), undef_access },
 
 	EL2_REG_VNCR(ICH_HCR_EL2, reset_val, 0),
 
@@ -2848,10 +2828,8 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
-	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
 
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -2920,10 +2898,8 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 limit, vttbr;
 
-	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
 
 	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 	limit = BIT_ULL(kvm_get_pa_bits(vcpu->kvm));
@@ -2948,10 +2924,8 @@ static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	u64 base, range, tg, num, scale;
 	int shift;
 
-	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
 
 	/*
 	 * Because the shadow S2 structure doesn't necessarily reflect that
@@ -3019,10 +2993,8 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
-	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
 
 	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
 				   &(union tlbi_info) {
@@ -3062,10 +3034,8 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	WARN_ON(!vcpu_is_el2(vcpu));
 
-	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
+	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
 
 	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
 				   &(union tlbi_info) {
@@ -3173,14 +3143,14 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1IS, handle_ripas2e1is),
 
-	SYS_INSN(TLBI_ALLE2OS, trap_undef),
-	SYS_INSN(TLBI_VAE2OS, trap_undef),
+	SYS_INSN(TLBI_ALLE2OS, undef_access),
+	SYS_INSN(TLBI_VAE2OS, undef_access),
 	SYS_INSN(TLBI_ALLE1OS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2OS, trap_undef),
+	SYS_INSN(TLBI_VALE2OS, undef_access),
 	SYS_INSN(TLBI_VMALLS12E1OS, handle_vmalls12e1is),
 
-	SYS_INSN(TLBI_RVAE2IS, trap_undef),
-	SYS_INSN(TLBI_RVALE2IS, trap_undef),
+	SYS_INSN(TLBI_RVAE2IS, undef_access),
+	SYS_INSN(TLBI_RVALE2IS, undef_access),
 
 	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
@@ -3192,10 +3162,10 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1, handle_ripas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1OS, handle_ripas2e1is),
-	SYS_INSN(TLBI_RVAE2OS, trap_undef),
-	SYS_INSN(TLBI_RVALE2OS, trap_undef),
-	SYS_INSN(TLBI_RVAE2, trap_undef),
-	SYS_INSN(TLBI_RVALE2, trap_undef),
+	SYS_INSN(TLBI_RVAE2OS, undef_access),
+	SYS_INSN(TLBI_RVALE2OS, undef_access),
+	SYS_INSN(TLBI_RVAE2, undef_access),
+	SYS_INSN(TLBI_RVALE2, undef_access),
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 
@@ -3204,19 +3174,19 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1ISNXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1ISNXS, handle_ripas2e1is),
 
-	SYS_INSN(TLBI_ALLE2OSNXS, trap_undef),
-	SYS_INSN(TLBI_VAE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_ALLE2OSNXS, undef_access),
+	SYS_INSN(TLBI_VAE2OSNXS, undef_access),
 	SYS_INSN(TLBI_ALLE1OSNXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_VALE2OSNXS, undef_access),
 	SYS_INSN(TLBI_VMALLS12E1OSNXS, handle_vmalls12e1is),
 
-	SYS_INSN(TLBI_RVAE2ISNXS, trap_undef),
-	SYS_INSN(TLBI_RVALE2ISNXS, trap_undef),
-	SYS_INSN(TLBI_ALLE2ISNXS, trap_undef),
-	SYS_INSN(TLBI_VAE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_RVAE2ISNXS, undef_access),
+	SYS_INSN(TLBI_RVALE2ISNXS, undef_access),
+	SYS_INSN(TLBI_ALLE2ISNXS, undef_access),
+	SYS_INSN(TLBI_VAE2ISNXS, undef_access),
 
 	SYS_INSN(TLBI_ALLE1ISNXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_VALE2ISNXS, undef_access),
 	SYS_INSN(TLBI_VMALLS12E1ISNXS, handle_vmalls12e1is),
 	SYS_INSN(TLBI_IPAS2E1OSNXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2E1NXS, handle_ipas2e1is),
@@ -3226,14 +3196,14 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1NXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1NXS, handle_ripas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1OSNXS, handle_ripas2e1is),
-	SYS_INSN(TLBI_RVAE2OSNXS, trap_undef),
-	SYS_INSN(TLBI_RVALE2OSNXS, trap_undef),
-	SYS_INSN(TLBI_RVAE2NXS, trap_undef),
-	SYS_INSN(TLBI_RVALE2NXS, trap_undef),
-	SYS_INSN(TLBI_ALLE2NXS, trap_undef),
-	SYS_INSN(TLBI_VAE2NXS, trap_undef),
+	SYS_INSN(TLBI_RVAE2OSNXS, undef_access),
+	SYS_INSN(TLBI_RVALE2OSNXS, undef_access),
+	SYS_INSN(TLBI_RVAE2NXS, undef_access),
+	SYS_INSN(TLBI_RVALE2NXS, undef_access),
+	SYS_INSN(TLBI_ALLE2NXS, undef_access),
+	SYS_INSN(TLBI_VAE2NXS, undef_access),
 	SYS_INSN(TLBI_ALLE1NXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2NXS, trap_undef),
+	SYS_INSN(TLBI_VALE2NXS, undef_access),
 	SYS_INSN(TLBI_VMALLS12E1NXS, handle_vmalls12e1is),
 };
 
-- 
2.39.2


