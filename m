Return-Path: <kvm+bounces-25171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F37961215
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D73A5282169
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897471CE6F9;
	Tue, 27 Aug 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qg7oAmIU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22751CCB34;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772331; cv=none; b=WhW9wvVLEPWSxfkIbnaKvKUsFsPTNlwR1DVlqxXN7CUW4xf7gIRV/Ag89ULcYyJj+XvnQmIlG09KkY10/Hp7xROPUEFs3+Lu4h5ZXAM16b9KlefnJrY4ptlAnbukCmKauMiyWKqkx/65ZynaAqns1ApLxOaN0siCoGjsf9ks+sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772331; c=relaxed/simple;
	bh=onM4pexPIemFKu2u3Qt4AjJBY/ijVLRCBbGeKAw8SUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sWBaOoQ8HT1l2QtlJ68n9iRa7Uj77JquwEwqJrSoTAUGgAYFPKaKD8beRE9Ad2JRKQ3RBx9NH2VE4lcS6Xm3hUpCjxLmznvCjAoeQBW/JrxFQAccxL1grqi7FsmUH5VCFMApcEjU0acGxhe4a25MBMuYLTzXhzcc9o6w40u4kO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qg7oAmIU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D34DC4DDF2;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772330;
	bh=onM4pexPIemFKu2u3Qt4AjJBY/ijVLRCBbGeKAw8SUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg7oAmIU5rh64WR2ykR4Vtpr5lxT0ScioWv9XSF//4XSWtewvVATSaG3o3CeuGagy
	 4D8LpjMJqi2A/1FHSwwJ9oKOd+6wQnOhdpWHEeSvjhB7U4hT5S73uZHCQBazwJNVZr
	 qioHgupWVEDusZ4WMvXs2ZBacf4YfSs1V53p7IwqXXXSnXC1G35CdMhSa0d2OBPQJF
	 TDqst64muvfEMRpYhmg1TeuLH6N4lWn1gt6o/ZbzvLraFTAdv/vWmKfDD1BAVjPI/H
	 /czHqltzPfyjlgaEqAhAWfROKb+6+ERzTpDT3VVstZU3HwrBO1mqKII8CVp/NupY2R
	 tAY9nXIxwOsxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4W-007HOs-NW;
	Tue, 27 Aug 2024 16:25:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 07/11] KVM: arm64: Add trap routing information for ICH_HCR_EL2
Date: Tue, 27 Aug 2024 16:25:13 +0100
Message-Id: <20240827152517.3909653-8-maz@kernel.org>
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

The usual song and dance. Anything that is a trap, any register
it traps. Note that we don't handle the registers added by
FEAT_NMI for now.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 71 ++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..e63be2058173 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -85,12 +85,17 @@ enum cgt_group_id {
 
 	CGT_HCRX_TCR2En,
 
+	CGT_ICH_HCR_TC,
+	CGT_ICH_HCR_TALL0,
+	CGT_ICH_HCR_TALL1,
+	CGT_ICH_HCR_TDIR,
+
 	/*
 	 * Anything after this point is a combination of coarse trap
 	 * controls, which must all be evaluated to decide what to do.
 	 */
 	__MULTIPLE_CONTROL_BITS__,
-	CGT_HCR_IMO_FMO = __MULTIPLE_CONTROL_BITS__,
+	CGT_HCR_IMO_FMO_ICH_HCR_TC = __MULTIPLE_CONTROL_BITS__,
 	CGT_HCR_TID2_TID4,
 	CGT_HCR_TTLB_TTLBIS,
 	CGT_HCR_TTLB_TTLBOS,
@@ -105,6 +110,8 @@ enum cgt_group_id {
 	CGT_MDCR_TDE_TDRA,
 	CGT_MDCR_TDCC_TDE_TDA,
 
+	CGT_ICH_HCR_TC_TDIR,
+
 	/*
 	 * Anything after this point requires a callback evaluating a
 	 * complex trap condition. Ugly stuff.
@@ -378,6 +385,30 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCRX_EL2_TCR2En,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_ICH_HCR_TC] = {
+		.index		= ICH_HCR_EL2,
+		.value		= ICH_HCR_TC,
+		.mask		= ICH_HCR_TC,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_ICH_HCR_TALL0] = {
+		.index		= ICH_HCR_EL2,
+		.value		= ICH_HCR_TALL0,
+		.mask		= ICH_HCR_TALL0,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_ICH_HCR_TALL1] = {
+		.index		= ICH_HCR_EL2,
+		.value		= ICH_HCR_TALL1,
+		.mask		= ICH_HCR_TALL1,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_ICH_HCR_TDIR] = {
+		.index		= ICH_HCR_EL2,
+		.value		= ICH_HCR_TDIR,
+		.mask		= ICH_HCR_TDIR,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 };
 
 #define MCB(id, ...)						\
@@ -387,7 +418,6 @@ static const struct trap_bits coarse_trap_bits[] = {
 		}
 
 static const enum cgt_group_id *coarse_control_combo[] = {
-	MCB(CGT_HCR_IMO_FMO,		CGT_HCR_IMO, CGT_HCR_FMO),
 	MCB(CGT_HCR_TID2_TID4,		CGT_HCR_TID2, CGT_HCR_TID4),
 	MCB(CGT_HCR_TTLB_TTLBIS,	CGT_HCR_TTLB, CGT_HCR_TTLBIS),
 	MCB(CGT_HCR_TTLB_TTLBOS,	CGT_HCR_TTLB, CGT_HCR_TTLBOS),
@@ -402,6 +432,9 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
 	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
 	MCB(CGT_MDCR_TDCC_TDE_TDA,	CGT_MDCR_TDCC, CGT_MDCR_TDE, CGT_MDCR_TDA),
+
+	MCB(CGT_HCR_IMO_FMO_ICH_HCR_TC,	CGT_HCR_IMO, CGT_HCR_FMO, CGT_ICH_HCR_TC),
+	MCB(CGT_ICH_HCR_TC_TDIR,	CGT_ICH_HCR_TC, CGT_ICH_HCR_TDIR),
 };
 
 typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
@@ -536,9 +569,9 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CSSELR_EL1,		CGT_HCR_TID2_TID4),
 	SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
 		      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
-	SR_TRAP(SYS_ICC_SGI0R_EL1,	CGT_HCR_IMO_FMO),
-	SR_TRAP(SYS_ICC_ASGI1R_EL1,	CGT_HCR_IMO_FMO),
-	SR_TRAP(SYS_ICC_SGI1R_EL1,	CGT_HCR_IMO_FMO),
+	SR_TRAP(SYS_ICC_SGI0R_EL1,	CGT_HCR_IMO_FMO_ICH_HCR_TC),
+	SR_TRAP(SYS_ICC_ASGI1R_EL1,	CGT_HCR_IMO_FMO_ICH_HCR_TC),
+	SR_TRAP(SYS_ICC_SGI1R_EL1,	CGT_HCR_IMO_FMO_ICH_HCR_TC),
 	SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
 		      sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
 	SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
@@ -1108,6 +1141,34 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
 	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
+	/*
+	 * IMPDEF choice:
+	 * We treat ICC_SRE_EL2.{SRE,Enable) and ICV_SRE_EL1.SRE as
+	 * RAO/WI. We therefore never consider ICC_SRE_EL2.Enable for
+	 * ICC_SRE_EL1 access, and always handle it locally.
+	 */
+	SR_TRAP(SYS_ICC_AP0R0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_AP0R1_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_AP0R2_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_AP0R3_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_AP1R0_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_AP1R1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_AP1R2_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_AP1R3_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_BPR0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_BPR1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_CTLR_EL1,	CGT_ICH_HCR_TC),
+	SR_TRAP(SYS_ICC_DIR_EL1,	CGT_ICH_HCR_TC_TDIR),
+	SR_TRAP(SYS_ICC_EOIR0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_EOIR1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_HPPIR0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_HPPIR1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_IAR0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_IAR1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_IGRPEN0_EL1,	CGT_ICH_HCR_TALL0),
+	SR_TRAP(SYS_ICC_IGRPEN1_EL1,	CGT_ICH_HCR_TALL1),
+	SR_TRAP(SYS_ICC_PMR_EL1,	CGT_ICH_HCR_TC),
+	SR_TRAP(SYS_ICC_RPR_EL1,	CGT_ICH_HCR_TC),
 };
 
 static DEFINE_XARRAY(sr_forward_xa);
-- 
2.39.2


