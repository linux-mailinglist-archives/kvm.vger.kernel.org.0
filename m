Return-Path: <kvm+bounces-24596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4195A958398
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF7DB1F24317
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E02418E027;
	Tue, 20 Aug 2024 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFuDPLqc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C0F18DF9C;
	Tue, 20 Aug 2024 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148376; cv=none; b=GO92QYcmg5H/quPKq/OagJk/ZNwL5TqR/5+SXhDWbjy+GOV/WZ+5r81KC3uFE3mBjJv2UfeHAlXomh7bJ2AQm+zjegnNvBpf7aGI0FU4k3NnGM+sf9RkXKqliHgzpItiCAKFiqFv4CtwzccZcm1feWC3/4ABvZrWFNJfXE/W9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148376; c=relaxed/simple;
	bh=N/NszJnC50UIOKoSwK5FhseAsipaQ50EUH0eqkLU8+E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4mfhhZks8Wopynn0+6rLaT1Ho0oos/EpuSWrKX7sUZmqwQPk79EM0j7f1yCmdo5u/luFees5euQT4UTF+1L1DeuRSsosW9/WNCeRqXGae7eadx/Qy+a6dcJd/lN0gYzvEi4rUFtmeGC4T+taV0Flym7gHEjAroFDlG8hpjWvDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFuDPLqc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252AAC4AF09;
	Tue, 20 Aug 2024 10:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148376;
	bh=N/NszJnC50UIOKoSwK5FhseAsipaQ50EUH0eqkLU8+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFuDPLqcyzjeWo577iKYpUVIMa+vgBUopR+WC64j7VVEU9KWpa5KqIW7rELpP2NDu
	 phjNZipJbzLyoAPIGVhiTmx8+Sa0HYQgI8jf7maXfo1B0lj4kFQOz9qWy9L5RrAq+Q
	 G7R2QMSWkStB98ME4/XIGU3/t5R/JfmxVYHjkdDq2tCI2UggxJVlr/OPSJSIzRV8nq
	 zIb25/QbDHGAypw2N23jGZcv+PmsU9vV62v9L9t+ScL63uvI/lP1+lu8HtL2Ueq6Cn
	 t70VdJNBoXVRu/ps6aQKQC0bl8CE3tXTal8j1hx2DEJgVAIP+A5uxRy2Zcl+8cx2r+
	 EGyv589xKqQgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLki-005Dk2-Gi;
	Tue, 20 Aug 2024 11:06:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 08/12] KVM: arm64: Add trap routing information for ICH_HCR_EL2
Date: Tue, 20 Aug 2024 11:03:45 +0100
Message-Id: <20240820100349.3544850-9-maz@kernel.org>
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

The usual song and dance. Anything that is a trap, any register
it traps. Note that we don't handle the registers added by
FEAT_NMI for now.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 77 ++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..63a2ce76619f 100644
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
@@ -378,6 +385,36 @@ static const struct trap_bits coarse_trap_bits[] = {
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
+	[CGT_ICH_HCR_TALL0] = {
+		.index		= ICH_HCR_EL2,
+		.value		= ICH_HCR_TALL0,
+		.mask		= ICH_HCR_TALL0,
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
@@ -387,7 +424,6 @@ static const struct trap_bits coarse_trap_bits[] = {
 		}
 
 static const enum cgt_group_id *coarse_control_combo[] = {
-	MCB(CGT_HCR_IMO_FMO,		CGT_HCR_IMO, CGT_HCR_FMO),
 	MCB(CGT_HCR_TID2_TID4,		CGT_HCR_TID2, CGT_HCR_TID4),
 	MCB(CGT_HCR_TTLB_TTLBIS,	CGT_HCR_TTLB, CGT_HCR_TTLBIS),
 	MCB(CGT_HCR_TTLB_TTLBOS,	CGT_HCR_TTLB, CGT_HCR_TTLBOS),
@@ -402,6 +438,9 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
 	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
 	MCB(CGT_MDCR_TDCC_TDE_TDA,	CGT_MDCR_TDCC, CGT_MDCR_TDE, CGT_MDCR_TDA),
+
+	MCB(CGT_HCR_IMO_FMO_ICH_HCR_TC,	CGT_HCR_IMO, CGT_HCR_FMO, CGT_ICH_HCR_TC),
+	MCB(CGT_ICH_HCR_TC_TDIR,	CGT_ICH_HCR_TC, CGT_ICH_HCR_TDIR),
 };
 
 typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
@@ -536,9 +575,9 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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
@@ -1108,6 +1147,34 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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


