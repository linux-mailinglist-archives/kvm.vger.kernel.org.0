Return-Path: <kvm+bounces-2079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2147F13FA
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE8191C21626
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231561C697;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvVHphcB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3449D1B289;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0364C4339A;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485853;
	bh=6u11QXjgqJMDYP2X9l7rpWyf4uML6UFJraQrpzj0q8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvVHphcBxGcLnxRrZ3QXweZg4Z8Pl3kJ/REiSNYhGnRxzWzJuAMlfRD76lKkJv3Sn
	 I3zDQeNcWBizuGcz9ushqZ4HHSx8NXRC9szqeCxu7s0czolcoC7hP7ky7vB2o0NIso
	 RqUHvwJflyG8Ailu4gG+ZIrsdc7Dq9inlbs9Vtoe02IL3yedbyQD79DRXndj+Eff3h
	 FFctgO39HsVYwB7G8OaeGhb/1lvAcGF+D7sM9Fnugv4oI1OxDZFXcgLXi9sxtI9uBJ
	 mBOXv9ZSTLdmkiUHa9xMA4GfImvjscsmFJJYYFGh+5al2vo3mnmYTa4VBaFdpUJvuc
	 BBcC9A/n3HXrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5439-00EjnU-2B;
	Mon, 20 Nov 2023 13:10:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 08/43] KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
Date: Mon, 20 Nov 2023 13:09:52 +0000
Message-Id: <20231120131027.854038-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add two helpers to deal with EL2 registers are are either redirected
to the VNCR page, or that are redirected to their EL1 counterpart.

In either cases, no trap is expected.

THe relevant register descriptors are repainted accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 65 ++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a529ce5ba987..c31fddc1591d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1891,6 +1891,32 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static bool bad_vncr_trap(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	/*
+	 * We really shouldn't be here, and this is likely the result
+	 * of a misconfigured trap, as this register should target the
+	 * VNCR page, and nothing else.
+	 */
+	return bad_trap(vcpu, p, r,
+			"trap of VNCR-backed register");
+}
+
+static bool bad_redir_trap(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	/*
+	 * We really shouldn't be here, and this is likely the result
+	 * of a misconfigured trap, as this register should target the
+	 * corresponding EL1, and nothing else.
+	 */
+	return bad_trap(vcpu, p, r,
+			"trap of EL2 register redirected to EL1");
+}
+
 #define EL2_REG(name, acc, rst, v) {		\
 	SYS_DESC(SYS_##name),			\
 	.access = acc,				\
@@ -1900,6 +1926,9 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
+#define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
+
 /*
  * EL{0,1}2 registers are the EL2 view on an EL0 or EL1 register when
  * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
@@ -2524,32 +2553,32 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
-	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
-	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
+	EL2_REG_VNCR(VPIDR_EL2, reset_unknown, 0),
+	EL2_REG_VNCR(VMPIDR_EL2, reset_unknown, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HCR_EL2, access_rw, reset_hcr, 0),
+	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
 	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
-	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HFGRTR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HFGWTR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
+	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGRTR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGWTR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
-	EL2_REG(HCRX_EL2, access_rw, reset_val, 0),
+	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
-	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
+	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
+	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
-	EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
-	EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
-	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
-	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
+	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
+	EL2_REG_VNCR(HDFGWTR_EL2, reset_val, 0),
+	EL2_REG_REDIR(SPSR_EL2, reset_val, 0),
+	EL2_REG_REDIR(ELR_EL2, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
 	/* AArch32 SPSR_* are RES0 if trapped from a NV guest */
@@ -2565,10 +2594,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
-	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
+	EL2_REG_REDIR(ESR_EL2, reset_val, 0),
 	{ SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x700 },
 
-	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
+	EL2_REG_REDIR(FAR_EL2, reset_val, 0),
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
@@ -2581,7 +2610,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
-	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
+	EL2_REG_VNCR(CNTVOFF_EL2, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
 	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
-- 
2.39.2


