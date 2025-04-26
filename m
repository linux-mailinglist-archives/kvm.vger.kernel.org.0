Return-Path: <kvm+bounces-44454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0952BA9DAB2
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482A71790AA
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6DB2566F9;
	Sat, 26 Apr 2025 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuQ9qeuK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3072561AC;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670544; cv=none; b=eKVNCjJMUN3/cxXGtUPR8k3i06LwcKSlT6yiwWEMQDdEnYjqzkWuBYC+mu7XD/4guu9gsddl9A1onbAUMzWU0RihrKMkDpkh9Wdx8nhQoBQI77Ln8MzyWKsUNxaRiDi7QtzxTsmQAYA9gnC7SxnmIdCRLepBa7zXUwO4HTpyIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670544; c=relaxed/simple;
	bh=4WYD9k5iZXYoTz9SVu8G5PaJMteBaRIKSX4S+mBaJms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NIc3LrMO0f8Z8Zk7ffodWX38ScKYl6x+WdnvkZhYfFsjTl1WTn0XMTjpg82Mf2YAeEEqghvuK2J7Akt6AjJvr3RgMj1i7AoWwjwO8GDZebX6ORjMiYErDwXHrVvgAsBOUtxyQ54vuXSqD2GvJHh3ZsTpEVvxLKuW8wgM4O3RDwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuQ9qeuK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAE8C4CEEC;
	Sat, 26 Apr 2025 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670543;
	bh=4WYD9k5iZXYoTz9SVu8G5PaJMteBaRIKSX4S+mBaJms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuQ9qeuK8FhDnFHQ8t1m9Av6l1+bEpEVPBP31N1O3fYTYj0xpDpR9fpoo2Zaazd82
	 RNI/jPCnmeT1QjRae5D39668HSD3D9l5nFkaXwEMIq3Sjz4YEFIf7xCeKwcrTj4ma3
	 Uhn0T7HDQ3T4WMNsqZLJePoij2cTIpJWV0Z/ywJS2zMORJEc0CabtlVHoZkCvfFNoe
	 P6GTf2YnMUH+oXvD639jh1xNkV+Z8hrXVw8g/9tF9/N4Fzo+yINeCrQkSnxFzglqqA
	 xz0xPbYd4a2pfb/iToBvljpN6Mg8tl5fjYzkQWsAc7BflN8GU9tuZk2IKDeR1peBRi
	 xHuOZW5PKYspw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeT-0092VH-M0;
	Sat, 26 Apr 2025 13:29:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 41/42] KVM: arm64: Add FGT descriptors for FEAT_FGT2
Date: Sat, 26 Apr 2025 13:28:35 +0100
Message-Id: <20250426122836.3341523-42-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Bulk addition of all the FGT2 traps reported with EC == 0x18,
as described in the 2025-03 JSON drop.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 83 +++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 9c7ecfccbd6e9..f7678af272bbb 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1385,6 +1385,24 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AIDR_EL1, 		HFGRTR, AIDR_EL1, 1),
 	SR_FGT(SYS_AFSR1_EL1, 		HFGRTR, AFSR1_EL1, 1),
 	SR_FGT(SYS_AFSR0_EL1, 		HFGRTR, AFSR0_EL1, 1),
+
+	/* HFGRTR2_EL2, HFGWTR2_EL2 */
+	SR_FGT(SYS_ACTLRALIAS_EL1,	HFGRTR2, nACTLRALIAS_EL1, 0),
+	SR_FGT(SYS_ACTLRMASK_EL1,	HFGRTR2, nACTLRMASK_EL1, 0),
+	SR_FGT(SYS_CPACRALIAS_EL1,	HFGRTR2, nCPACRALIAS_EL1, 0),
+	SR_FGT(SYS_CPACRMASK_EL1,	HFGRTR2, nCPACRMASK_EL1, 0),
+	SR_FGT(SYS_PFAR_EL1,		HFGRTR2, nPFAR_EL1, 0),
+	SR_FGT(SYS_RCWSMASK_EL1,	HFGRTR2, nRCWSMASK_EL1, 0),
+	SR_FGT(SYS_SCTLR2ALIAS_EL1,	HFGRTR2, nSCTLRALIAS2_EL1, 0),
+	SR_FGT(SYS_SCTLR2MASK_EL1,	HFGRTR2, nSCTLR2MASK_EL1, 0),
+	SR_FGT(SYS_SCTLRALIAS_EL1,	HFGRTR2, nSCTLRALIAS_EL1, 0),
+	SR_FGT(SYS_SCTLRMASK_EL1,	HFGRTR2, nSCTLRMASK_EL1, 0),
+	SR_FGT(SYS_TCR2ALIAS_EL1,	HFGRTR2, nTCR2ALIAS_EL1, 0),
+	SR_FGT(SYS_TCR2MASK_EL1,	HFGRTR2, nTCR2MASK_EL1, 0),
+	SR_FGT(SYS_TCRALIAS_EL1,	HFGRTR2, nTCRALIAS_EL1, 0),
+	SR_FGT(SYS_TCRMASK_EL1,		HFGRTR2, nTCRMASK_EL1, 0),
+	SR_FGT(SYS_ERXGSR_EL1,		HFGRTR2, nERXGSR_EL1, 0),
+
 	/* HFGITR_EL2 */
 	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
 	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
@@ -1494,6 +1512,11 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_IC_IVAU, 		HFGITR, ICIVAU, 1),
 	SR_FGT(SYS_IC_IALLU, 		HFGITR, ICIALLU, 1),
 	SR_FGT(SYS_IC_IALLUIS, 		HFGITR, ICIALLUIS, 1),
+
+	/* HFGITR2_EL2 */
+	SR_FGT(SYS_DC_CIGDVAPS,		HFGITR2, nDCCIVAPS, 0),
+	SR_FGT(SYS_DC_CIVAPS,		HFGITR2, nDCCIVAPS, 0),
+	
 	/* HDFGRTR_EL2 */
 	SR_FGT(SYS_PMBIDR_EL1, 		HDFGRTR, PMBIDR_EL1, 1),
 	SR_FGT(SYS_PMSNEVFR_EL1, 	HDFGRTR, nPMSNEVFR_EL1, 0),
@@ -1886,6 +1909,59 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_DBGBCRn_EL1(13), 	HDFGRTR, DBGBCRn_EL1, 1),
 	SR_FGT(SYS_DBGBCRn_EL1(14), 	HDFGRTR, DBGBCRn_EL1, 1),
 	SR_FGT(SYS_DBGBCRn_EL1(15), 	HDFGRTR, DBGBCRn_EL1, 1),
+
+	/* HDFGRTR2_EL2 */
+	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 0),
+	SR_FGT(SYS_MDSTEPOP_EL1,	HDFGRTR2, nMDSTEPOP_EL1, 0),
+	SR_FGT(SYS_PMCCNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT_RANGE(SYS_PMEVCNTSVRn_EL1(0),
+		     SYS_PMEVCNTSVRn_EL1(30),
+		     HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMICNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMECR_EL1,		HDFGRTR2, nPMECR_EL1, 0),
+	SR_FGT(SYS_PMIAR_EL1,		HDFGRTR2, nPMIAR_EL1, 0),
+	SR_FGT(SYS_PMICFILTR_EL0,	HDFGRTR2, nPMICFILTR_EL0, 0),
+	SR_FGT(SYS_PMICNTR_EL0,		HDFGRTR2, nPMICNTR_EL0, 0),
+	SR_FGT(SYS_PMSSCR_EL1,		HDFGRTR2, nPMSSCR_EL1, 0),
+	SR_FGT(SYS_PMUACR_EL1,		HDFGRTR2, nPMUACR_EL1, 0),
+	SR_FGT(SYS_SPMACCESSR_EL1,	HDFGRTR2, nSPMACCESSR_EL1, 0),
+	SR_FGT(SYS_SPMCFGR_EL1,		HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMDEVARCH_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCGCRn_EL1(0),	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCGCRn_EL1(1),	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMIIDR_EL1,		HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCNTENCLR_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMCNTENSET_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMCR_EL0,		HDFGRTR2, nSPMCR_EL0, 0),
+	SR_FGT(SYS_SPMDEVAFF_EL1,	HDFGRTR2, nSPMDEVAFF_EL1, 0),
+	/*
+	 * We have up to 64 of these registers in ranges of 16, banked via
+	 * SPMSELR_EL0.BANK. We're only concerned with the accessors here,
+	 * not the architectural registers.
+	 */
+	SR_FGT_RANGE(SYS_SPMEVCNTRn_EL0(0),
+		     SYS_SPMEVCNTRn_EL0(15),
+		     HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT_RANGE(SYS_SPMEVFILT2Rn_EL0(0),
+		     SYS_SPMEVFILT2Rn_EL0(15),
+		     HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT_RANGE(SYS_SPMEVFILTRn_EL0(0),
+		     SYS_SPMEVFILTRn_EL0(15),
+		     HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT_RANGE(SYS_SPMEVTYPERn_EL0(0),
+		     SYS_SPMEVTYPERn_EL0(15),
+		     HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMINTENCLR_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMINTENSET_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMOVSCLR_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMOVSSET_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMSCR_EL1,		HDFGRTR2, nSPMSCR_EL1, 0),
+	SR_FGT(SYS_SPMSELR_EL0,		HDFGRTR2, nSPMSELR_EL0, 0),
+	SR_FGT(SYS_TRCITECR_EL1,	HDFGRTR2, nTRCITECR_EL1, 0),
+	SR_FGT(SYS_PMBMAR_EL1,		HDFGRTR2, nPMBMAR_EL1, 0),
+	SR_FGT(SYS_PMSDSFR_EL1,		HDFGRTR2, nPMSDSFR_EL1, 0),
+	SR_FGT(SYS_TRBMPAM_EL1,		HDFGRTR2, nTRBMPAM_EL1, 0),
+
 	/*
 	 * HDFGWTR_EL2
 	 *
@@ -1896,12 +1972,19 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	 * read-side mappings, and only the write-side mappings that
 	 * differ from the read side, and the trap handler will pick
 	 * the correct shadow register based on the access type.
+	 *
+	 * Same model applies to the FEAT_FGT2 registers.
 	 */
 	SR_FGT(SYS_TRFCR_EL1,		HDFGWTR, TRFCR_EL1, 1),
 	SR_FGT(SYS_TRCOSLAR,		HDFGWTR, TRCOSLAR, 1),
 	SR_FGT(SYS_PMCR_EL0,		HDFGWTR, PMCR_EL0, 1),
 	SR_FGT(SYS_PMSWINC_EL0,		HDFGWTR, PMSWINC_EL0, 1),
 	SR_FGT(SYS_OSLAR_EL1,		HDFGWTR, OSLAR_EL1, 1),
+
+	/* HDFGWTR_EL2 */
+	SR_FGT(SYS_PMZR_EL0,		HDFGWTR2, nPMZR_EL0, 0),
+	SR_FGT(SYS_SPMZR_EL0,		HDFGWTR2, nSPMEVCNTRn_EL0, 0),
+
 	/*
 	 * HAFGRTR_EL2
 	 */
-- 
2.39.2


