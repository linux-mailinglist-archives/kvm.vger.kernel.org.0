Return-Path: <kvm+bounces-69140-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKUdJiNcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69140-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB308821E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C141130BACBC
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA5338F55;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpuoD4He"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690643358B5;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429857; cv=none; b=frA2jGDTcFwsIwVUbyJ3BnfJZOT3JgJGZVi3pyoxR3MTWOvoprQ0WtUW1EO8g8BplEkU8HpSg27aVoDrg17A2gzYvk23QmIj8v7++QHJpHLhTVIqhypLrb4lPzMOfAmAi+WAK2PD7/cdqW1ZObM4GVRxTN1c76+OZEvbxrKcvdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429857; c=relaxed/simple;
	bh=v+Wqx+4/XO3egmad6OXeeaqyteYWH6WtPys8ogWMaBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBR6z3Z+TfCtNrJSAbLOH/2YyoVt+5zYXvKe+qQLexTtxLIPfP+62F3QWrwGoW6MQKj28GlMcAqaKAjRsB/wzeu7J9WZIaUQwfYF362L7Ck3EoSViaDzuBiOgfwieTr0kL99kJEmmFMrKg6dwyO+0difkTzCT27A1X+XA8alWZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpuoD4He; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCF9C2BC86;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429857;
	bh=v+Wqx+4/XO3egmad6OXeeaqyteYWH6WtPys8ogWMaBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpuoD4He9ak/IbdBZL0OGgJgoeUSWF8WYq0pE/s4Hp2EHGk0uwq/dSHFdpDL27mc5
	 FaJrymSWPF4UzPRG/DoG4rGrjY68/R9Twx+H8zB3M+16jk40civ/oHoW5FgTfggBYq
	 kVwBdmvgdEg1oJIqgOJLufK1/iS+1X4qmYHfX9ofwHQmJDAtO9SO9pyuC+WDsjS2ig
	 /MlB3x1DOFSgYX+0aNoBTi6oERX/kg8lTC78xLBDpwV9Y3Di5yCjhPpiyLK5qSOE9v
	 8FZtKudR8lTkVtE5neDMd5oB0wwfbKcbm1JdxbbtEbQzL3WNnGdV2hulDij/28dPpC
	 vXmcKlF4HGiUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXD-00000005hx6-2Ubq;
	Mon, 26 Jan 2026 12:17:35 +0000
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
Subject: [PATCH 17/20] KVM: arm64: Remove all traces of FEAT_TME
Date: Mon, 26 Jan 2026 12:16:51 +0000
Message-ID: <20260126121655.1641736-18-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69140-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3AB308821E
X-Rspamd-Action: no action

FEAT_TME has been dropped from the architecture. Retrospectively.
I'm sure someone is crying somewhere, but most of us won't.

Clean-up time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c                         |  7 -------
 arch/arm64/kvm/nested.c                         |  5 -----
 arch/arm64/tools/sysreg                         | 12 +++---------
 tools/perf/Documentation/perf-arm-spe.txt       |  1 -
 tools/testing/selftests/kvm/arm64/set_id_regs.c |  1 -
 5 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0c037742215ac..f892098b70c0b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -184,7 +184,6 @@ struct reg_feat_map_desc {
 #define FEAT_RME		ID_AA64PFR0_EL1, RME, IMP
 #define FEAT_MPAM		ID_AA64PFR0_EL1, MPAM, 1
 #define FEAT_S2FWB		ID_AA64MMFR2_EL1, FWB, IMP
-#define FEAT_TME		ID_AA64ISAR0_EL1, TME, IMP
 #define FEAT_TWED		ID_AA64MMFR1_EL1, TWED, IMP
 #define FEAT_E2H0		ID_AA64MMFR4_EL1, E2H0, IMP
 #define FEAT_SRMASK		ID_AA64MMFR4_EL1, SRMASK, IMP
@@ -997,7 +996,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_FIEN, feat_rasv1p1),
 	NEEDS_FEAT(HCR_EL2_GPF, FEAT_RME),
 	NEEDS_FEAT(HCR_EL2_FWB, FEAT_S2FWB),
-	NEEDS_FEAT(HCR_EL2_TME, FEAT_TME),
 	NEEDS_FEAT(HCR_EL2_TWEDEL	|
 		   HCR_EL2_TWEDEn,
 		   FEAT_TWED),
@@ -1109,11 +1107,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 	NEEDS_FEAT(SCTLR_EL1_EnRCTX, FEAT_SPECRES),
 	NEEDS_FEAT(SCTLR_EL1_DSSBS, FEAT_SSBS),
 	NEEDS_FEAT(SCTLR_EL1_TIDCP, FEAT_TIDCP1),
-	NEEDS_FEAT(SCTLR_EL1_TME0	|
-		   SCTLR_EL1_TME	|
-		   SCTLR_EL1_TMT0	|
-		   SCTLR_EL1_TMT,
-		   FEAT_TME),
 	NEEDS_FEAT(SCTLR_EL1_TWEDEL	|
 		   SCTLR_EL1_TWEDEn,
 		   FEAT_TWED),
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 75a23f1c56d13..96e899dbd9192 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1505,11 +1505,6 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 	u64 orig_val = val;
 
 	switch (reg) {
-	case SYS_ID_AA64ISAR0_EL1:
-		/* Support everything but TME */
-		val &= ~ID_AA64ISAR0_EL1_TME;
-		break;
-
 	case SYS_ID_AA64ISAR1_EL1:
 		/* Support everything but LS64 and Spec Invalidation */
 		val &= ~(ID_AA64ISAR1_EL1_LS64	|
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 969a75615d612..650d7d477087e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1856,10 +1856,7 @@ UnsignedEnum	31:28	RDM
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	27:24	TME
-	0b0000	NI
-	0b0001	IMP
-EndEnum
+Res0	27:24
 UnsignedEnum	23:20	ATOMIC
 	0b0000	NI
 	0b0010	IMP
@@ -2432,10 +2429,7 @@ Field	57	EPAN
 Field	56	EnALS
 Field	55	EnAS0
 Field	54	EnASR
-Field	53	TME
-Field	52	TME0
-Field	51	TMT
-Field	50	TMT0
+Res0	53:50
 Field	49:46	TWEDEL
 Field	45	TWEDEn
 Field	44	DSSBS
@@ -3840,7 +3834,7 @@ Field	43	NV1
 Field	42	NV
 Field	41	API
 Field	40	APK
-Field	39	TME
+Res0	39
 Field	38	MIOCNCE
 Field	37	TEA
 Field	36	TERR
diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Documentation/perf-arm-spe.txt
index 8b02e5b983fa9..201a82bec0de4 100644
--- a/tools/perf/Documentation/perf-arm-spe.txt
+++ b/tools/perf/Documentation/perf-arm-spe.txt
@@ -176,7 +176,6 @@ and inv_event_filter are:
   bit 10    - Remote access (FEAT_SPEv1p4)
   bit 11    - Misaligned access (FEAT_SPEv1p1)
   bit 12-15 - IMPLEMENTATION DEFINED events (when implemented)
-  bit 16    - Transaction (FEAT_TME)
   bit 17    - Partial or empty SME or SVE predicate (FEAT_SPEv1p1)
   bit 18    - Empty SME or SVE predicate (FEAT_SPEv1p1)
   bit 19    - L2D access (FEAT_SPEv1p4)
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index c4815d3658167..73de5be58bab0 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -91,7 +91,6 @@ static const struct reg_ftr_bits ftr_id_aa64isar0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SM3, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA3, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, RDM, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, TME, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, ATOMIC, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, CRC32, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR0_EL1, SHA2, 0),
-- 
2.47.3


