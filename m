Return-Path: <kvm+bounces-69142-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEiFJjpcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69142-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6618822D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B09E63078BDE
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3B1339859;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyq3PZsH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF013358C0;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429857; cv=none; b=pUxxfb1L6uVDykn/y/dyBpSDSmcU8Jg5ixwjFmU+5iGxnHXf1vx38i8zG2vhnY7MyAYt9QC4wULIZ/kppFEzG6lN298Ok8A1d5jG136/pk2IGRM85yNxTuk1UH5t9OV1M+HvuC6u5SlXyTEb1AMEwTbGjOwhAVynM/vzOOGKJq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429857; c=relaxed/simple;
	bh=V2DWQh0M6XeD4GoribxYipsGtJi13aVlLNE/slTnQGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsuIVMCkgu29dHTFw8B1N1tkkKgAixBbJd0Vhqu/w4exzTf26iSe5OSE4XvXlUp21pGpTUK23pz3jgZNWXOBZP1XjLcI0jrZirLohF2aOmBi3qInhAgSTbuGtgZNDJVvTFWIB44FNNV9uesBC1ekylYcrDt/gR772zJbUuBNKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyq3PZsH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5DAC19425;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429857;
	bh=V2DWQh0M6XeD4GoribxYipsGtJi13aVlLNE/slTnQGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyq3PZsHZHhRQnUsTYPRGOaMnm0Slg9i4K1dRBQt8VcVKhnht/AI8rrY/leAUJ1au
	 hijr5DRYNHQYtkIYaMJ1PYfQtwqmuU0r43XsfqLlXP0u5J/6p6nm/Tuso5FjmmMgu3
	 TUPypp29I3OorEq2f1LjaRc2yaxMdmPAFN0zJvdzY2r7F5XZFc7AEJbqadGogdZNxA
	 BhI5TmvV7g0fngqhDDO86rjPXwp2zOxT3TlvjbkKGRvs4TSXDueY5mA3qTdFv2zZ6F
	 U+RuudKSfyQakvofM8BfxM06ghusZbFMIoDSCw8TT38baKmBJGbussIP8WKrpEaQ07
	 ras6CA3nkQiPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXE-00000005hx6-0EEB;
	Mon, 26 Jan 2026 12:17:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 19/20] KVM: arm64: Add sanitisation to SCTLR_EL2
Date: Mon, 26 Jan 2026 12:16:53 +0000
Message-ID: <20260126121655.1641736-20-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69142-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D6618822D
X-Rspamd-Action: no action

Sanitise SCTLR_EL2 the usual way. The most important aspect of
this is that we benefit from SCTLR_EL2.SPAN being RES1 when
HCR_EL2.E2H==0.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/config.c           | 82 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c           |  4 ++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9dca94e4361f0..c82b071ade2a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -495,7 +495,6 @@ enum vcpu_sysreg {
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
 	/* EL2 registers */
-	SCTLR_EL2,	/* System Control Register (EL2) */
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
@@ -526,6 +525,7 @@ enum vcpu_sysreg {
 
 	/* Anything from this can be RES0/RES1 sanitised */
 	MARKER(__SANITISED_REG_START__),
+	SCTLR_EL2,	/* System Control Register (EL2) */
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
 	SCTLR2_EL2,	/* System Control Register 2 (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index eebafb90bcf62..562513a4683e2 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1130,6 +1130,84 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
 			      sctlr_el1_feat_map, FEAT_AA64EL1);
 
+static const struct reg_bits_to_feat_map sctlr_el2_feat_map[] = {
+	NEEDS_FEAT_FLAG(SCTLR_EL2_CP15BEN,
+			RES0_WHEN_E2H1 | RES1_WHEN_E2H0 | REQUIRES_E2H1,
+			FEAT_AA32EL0),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_ITD	|
+			SCTLR_EL2_SED,
+			RES1_WHEN_E2H1 | RES0_WHEN_E2H0 | REQUIRES_E2H1,
+			FEAT_AA32EL0),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_BT0, REQUIRES_E2H1, FEAT_BTI),
+	NEEDS_FEAT(SCTLR_EL2_BT, FEAT_BTI),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_CMOW, REQUIRES_E2H1, FEAT_CMOW),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_TSCXT,
+			RES0_WHEN_E2H0 | RES1_WHEN_E2H1 | REQUIRES_E2H1,
+			feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EIS	|
+			SCTLR_EL2_EOS,
+			AS_RES1, FEAT_ExS),
+	NEEDS_FEAT(SCTLR_EL2_EnFPM, FEAT_FPMR),
+	NEEDS_FEAT(SCTLR_EL2_IESB, FEAT_IESB),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EnALS, REQUIRES_E2H1, FEAT_LS64),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EnAS0, REQUIRES_E2H1, FEAT_LS64_ACCDATA),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EnASR, REQUIRES_E2H1, FEAT_LS64_V),
+	NEEDS_FEAT(SCTLR_EL2_nAA, FEAT_LSE2),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_LSMAOE	|
+			SCTLR_EL2_nTLSMD,
+			AS_RES1 | REQUIRES_E2H1, FEAT_LSMAOC),
+	NEEDS_FEAT(SCTLR_EL2_EE, FEAT_MixedEnd),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_E0E, REQUIRES_E2H1, feat_mixedendel0),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_MSCEn, REQUIRES_E2H1, FEAT_MOPS),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_ATA0	|
+			SCTLR_EL2_TCF0,
+			REQUIRES_E2H1, FEAT_MTE2),
+	NEEDS_FEAT(SCTLR_EL2_ATA	|
+		   SCTLR_EL2_TCF,
+		   FEAT_MTE2),
+	NEEDS_FEAT(SCTLR_EL2_ITFSB, feat_mte_async),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_TCSO0, REQUIRES_E2H1, FEAT_MTE_STORE_ONLY),
+	NEEDS_FEAT(SCTLR_EL2_TCSO,
+		   FEAT_MTE_STORE_ONLY),
+	NEEDS_FEAT(SCTLR_EL2_NMI	|
+		   SCTLR_EL2_SPINTMASK,
+		   FEAT_NMI),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_SPAN,	AS_RES1 | REQUIRES_E2H1, FEAT_PAN),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EPAN, REQUIRES_E2H1, FEAT_PAN3),
+	NEEDS_FEAT(SCTLR_EL2_EnDA	|
+		   SCTLR_EL2_EnDB	|
+		   SCTLR_EL2_EnIA	|
+		   SCTLR_EL2_EnIB,
+		   feat_pauth),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_EnTP2, REQUIRES_E2H1, FEAT_SME),
+	NEEDS_FEAT(SCTLR_EL2_EnRCTX, FEAT_SPECRES),
+	NEEDS_FEAT(SCTLR_EL2_DSSBS, FEAT_SSBS),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_TIDCP, REQUIRES_E2H1, FEAT_TIDCP1),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_TWEDEL	|
+			SCTLR_EL2_TWEDEn,
+			REQUIRES_E2H1, FEAT_TWED),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_nTWE	|
+			SCTLR_EL2_nTWI,
+			AS_RES1 | REQUIRES_E2H1, FEAT_AA64EL2),
+	NEEDS_FEAT_FLAG(SCTLR_EL2_UCI	|
+			SCTLR_EL2_UCT	|
+			SCTLR_EL2_DZE	|
+			SCTLR_EL2_SA0,
+			REQUIRES_E2H1, FEAT_AA64EL2),
+	NEEDS_FEAT(SCTLR_EL2_WXN	|
+		   SCTLR_EL2_I		|
+		   SCTLR_EL2_SA		|
+		   SCTLR_EL2_C		|
+		   SCTLR_EL2_A		|
+		   SCTLR_EL2_M,
+		   FEAT_AA64EL2),
+	FORCE_RES0(SCTLR_EL2_RES0),
+	FORCE_RES1(SCTLR_EL2_RES1),
+};
+
+static const DECLARE_FEAT_MAP(sctlr_el2_desc, SCTLR_EL2,
+			      sctlr_el2_feat_map, FEAT_AA64EL2);
+
 static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 	NEEDS_FEAT(MDCR_EL2_EBWE, FEAT_Debugv8p9),
 	NEEDS_FEAT(MDCR_EL2_TDOSA, FEAT_DoubleLock),
@@ -1249,6 +1327,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&sctlr2_desc);
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
+	check_reg_desc(&sctlr_el2_desc);
 	check_reg_desc(&mdcr_el2_desc);
 	check_reg_desc(&vtcr_el2_desc);
 }
@@ -1454,6 +1533,9 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 	case SCTLR_EL1:
 		resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
 		break;
+	case SCTLR_EL2:
+		resx = compute_reg_resx_bits(kvm, &sctlr_el2_desc, 0, 0);
+		break;
 	case MDCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
 		break;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 96e899dbd9192..ed710228484f3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1766,6 +1766,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx = get_reg_fixed_bits(kvm, SCTLR_EL1);
 	set_sysreg_masks(kvm, SCTLR_EL1, resx);
 
+	/* SCTLR_EL2 */
+	resx = get_reg_fixed_bits(kvm, SCTLR_EL2);
+	set_sysreg_masks(kvm, SCTLR_EL2, resx);
+
 	/* SCTLR2_ELx */
 	resx = get_reg_fixed_bits(kvm, SCTLR2_EL1);
 	set_sysreg_masks(kvm, SCTLR2_EL1, resx);
-- 
2.47.3


