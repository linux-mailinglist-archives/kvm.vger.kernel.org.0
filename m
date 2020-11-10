Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3AB2AD7B4
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732079AbgKJNgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730983AbgKJNgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 08:36:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB15221741;
        Tue, 10 Nov 2020 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605015391;
        bh=UnuvpvNqBY49OPvH8MnUgcJPD8InUHyYLFIXIB87S0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ecz89znhlo9bnfibB2QX+WO+jW6UFVFlJGSwNsX7LBtzFNYnOliKrqg05RyYY2cCk
         N1sjAQOTHoWVroR2X3h5SMqjCWpOmTmrRJAthNLIWSOwhtgmzVye6xqBg/+7Meia6Y
         Ka86eW8/Sxjv65fCoMXd0PLzUvz79fTi1xpfwV78=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcToz-009SZy-RY; Tue, 10 Nov 2020 13:36:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 4/9] KVM: arm64: Map AArch32 cp15 register to AArch64 sysregs
Date:   Tue, 10 Nov 2020 13:36:14 +0000
Message-Id: <20201110133619.451157-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110133619.451157-1-maz@kernel.org>
References: <20201110133619.451157-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move all the cp15 registers over to their AArch64 counterpart.
This requires the annotation of a few of them (such as the usual
DFAR/IFAR vs FAR_EL1), and a new helper that generates mask/shift
pairs for the various configurations.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 114 ++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index afdf18d694cb..ab66101c855e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -128,6 +128,24 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
+{
+	switch (r->aarch32_map) {
+	case AA32_LO:
+		*mask = GENMASK_ULL(31, 0);
+		*shift = 0;
+		break;
+	case AA32_HI:
+		*mask = GENMASK_ULL(63, 32);
+		*shift = 32;
+		break;
+	default:
+		*mask = GENMASK_ULL(63, 0);
+		*shift = 0;
+		break;
+	}
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
@@ -138,26 +156,21 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
-	u64 val;
-	int reg = r->reg;
+	u64 val, mask, shift;
 
 	BUG_ON(!p->is_write);
 
-	/* See the 32bit mapping in kvm_host.h */
-	if (p->is_aarch32)
-		reg = r->reg / 2;
+	get_access_mask(r, &mask, &shift);
 
-	if (!p->is_aarch32 || !p->is_32bit) {
-		val = p->regval;
+	if (~mask) {
+		val = vcpu_read_sys_reg(vcpu, r->reg);
+		val &= ~mask;
 	} else {
-		val = vcpu_read_sys_reg(vcpu, reg);
-		if (r->reg % 2)
-			val = (p->regval << 32) | (u64)lower_32_bits(val);
-		else
-			val = ((u64)upper_32_bits(val) << 32) |
-				lower_32_bits(p->regval);
+		val = 0;
 	}
-	vcpu_write_sys_reg(vcpu, val, reg);
+
+	val |= (p->regval & (mask >> shift)) << shift;
+	vcpu_write_sys_reg(vcpu, val, r->reg);
 
 	kvm_toggle_cache(vcpu, was_enabled);
 	return true;
@@ -167,17 +180,13 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
+	u64 mask, shift;
+
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
-
-	if (p->is_aarch32) {
-		if (r->Op2 & 2)
-			p->regval = upper_32_bits(p->regval);
-		else
-			p->regval = lower_32_bits(p->regval);
-	}
+	get_access_mask(r, &mask, &shift);
+	p->regval = (vcpu_read_sys_reg(vcpu, r->reg) & mask) >> shift;
 
 	return true;
 }
@@ -1264,10 +1273,6 @@ static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	int reg = r->reg;
 
-	/* See the 32bit mapping in kvm_host.h */
-	if (p->is_aarch32)
-		reg = r->reg / 2;
-
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, reg);
 	else
@@ -1919,20 +1924,29 @@ static const struct sys_reg_desc cp14_64_regs[] = {
  */
 static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 0), Op2( 1), access_ctr },
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 1), access_actlr },
-	{ Op1( 0), CRn( 1), CRm( 0), Op2( 3), access_actlr },
-	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
-	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
-	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
-	{ Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, c2_TTBCR2 },
-	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, c3_DACR },
-	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, c5_DFSR },
-	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, c5_IFSR },
-	{ Op1( 0), CRn( 5), CRm( 1), Op2( 0), access_vm_reg, NULL, c5_ADFSR },
-	{ Op1( 0), CRn( 5), CRm( 1), Op2( 1), access_vm_reg, NULL, c5_AIFSR },
-	{ Op1( 0), CRn( 6), CRm( 0), Op2( 0), access_vm_reg, NULL, c6_DFAR },
-	{ Op1( 0), CRn( 6), CRm( 0), Op2( 2), access_vm_reg, NULL, c6_IFAR },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, SCTLR_EL1 },
+	/* ACTLR */
+	{ AA32(LO), Op1( 0), CRn( 1), CRm( 0), Op2( 1), access_actlr, NULL, ACTLR_EL1 },
+	/* ACTLR2 */
+	{ AA32(HI), Op1( 0), CRn( 1), CRm( 0), Op2( 3), access_actlr, NULL, ACTLR_EL1 },
+	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
+	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, TTBR1_EL1 },
+	/* TTBCR */
+	{ AA32(LO), Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, TCR_EL1 },
+	/* TTBCR2 */
+	{ AA32(HI), Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, TCR_EL1 },
+	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, DACR32_EL2 },
+	/* DFSR */
+	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, ESR_EL1 },
+	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, IFSR32_EL2 },
+	/* ADFSR */
+	{ Op1( 0), CRn( 5), CRm( 1), Op2( 0), access_vm_reg, NULL, AFSR0_EL1 },
+	/* AIFSR */
+	{ Op1( 0), CRn( 5), CRm( 1), Op2( 1), access_vm_reg, NULL, AFSR1_EL1 },
+	/* DFAR */
+	{ AA32(LO), Op1( 0), CRn( 6), CRm( 0), Op2( 0), access_vm_reg, NULL, FAR_EL1 },
+	/* IFAR */
+	{ AA32(HI), Op1( 0), CRn( 6), CRm( 0), Op2( 2), access_vm_reg, NULL, FAR_EL1 },
 
 	/*
 	 * DC{C,I,CI}SW operations:
@@ -1958,15 +1972,19 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
 
-	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
-	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
-	{ Op1( 0), CRn(10), CRm( 3), Op2( 0), access_vm_reg, NULL, c10_AMAIR0 },
-	{ Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, c10_AMAIR1 },
+	/* PRRR/MAIR0 */
+	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
+	/* NMRR/MAIR1 */
+	{ AA32(HI), Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, MAIR_EL1 },
+	/* AMAIR0 */
+	{ AA32(LO), Op1( 0), CRn(10), CRm( 3), Op2( 0), access_vm_reg, NULL, AMAIR_EL1 },
+	/* AMAIR1 */
+	{ AA32(HI), Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, AMAIR_EL1 },
 
 	/* ICC_SRE */
 	{ Op1( 0), CRn(12), CRm(12), Op2( 5), access_gic_sre },
 
-	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
+	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, CONTEXTIDR_EL1 },
 
 	/* Arch Tmers */
 	{ SYS_DESC(SYS_AARCH32_CNTP_TVAL), access_arch_timer },
@@ -2041,14 +2059,14 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
 	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
-	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, c0_CSSELR },
+	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, CSSELR_EL1 },
 };
 
 static const struct sys_reg_desc cp15_64_regs[] = {
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
 	{ Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
 	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
-	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR1 },
+	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
 	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
 	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
 	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
-- 
2.28.0

