Return-Path: <kvm+bounces-69136-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KTMNQRcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69136-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A2788200
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E12313085851
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9030E33769C;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pzrv69Iw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74073382E5;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429856; cv=none; b=Yo30a9UM6oCXfZD3ph4fStDAC4bdwPz/yoK0lM6Yyz1SRzJg8liriL6yjvAfQfdbzWrWzRaPLw1ah+x0Y1tQpCmX1UqW4FNP+qXMa1Vy0NGhPudE6HQD/5t4h48ZCNgkBUgSfhGSeYf/lJcd6spJqD5lYbvz+8Zp6INmGGFcVuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429856; c=relaxed/simple;
	bh=o+Azuxl+435ZLpfOEdegfUYGO8k5jHT7f0xTAjuorWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws+DGtZnRTg5vfxIG+e1a0m/AUX/sxtmUAEJAMlmQI6qh1jKZ99CBGP2r9x2PHe/LPOOlO5Y+TW4fTDV9h9ADqFfhAexlkz4vwNjNycri4EXMv6SqCUdiTgODweg0Gp0H4k6w7cgnO73di9e6jckW/U1Mm7pLzQ042c8FUwIQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pzrv69Iw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97566C116C6;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429856;
	bh=o+Azuxl+435ZLpfOEdegfUYGO8k5jHT7f0xTAjuorWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pzrv69IwL8pBSXX3IzH8yxYaicNcJbweSQnTZbN/jjjfCBKGI7hz92X5OUiQ/vicM
	 GIsyVzh/5NruBLSHGEPNlEa39wYouyrOe8GIB8d70xkltChZWH+jw8ItF7tk2X5hCb
	 u2CYJ3ibAYHmNXzUH1+e5rir1UoRbBc2JxgKRgPaNuS+AW36HXcrI/IbZ1hUmdA9O2
	 SUqUIo6xP08bcBPcMWm6MVOLQgU09ngSU7GGeKNXD9ewHPnQW0O3vLV+xuFfXwnIMi
	 7TZY9sPJzPa2gNfAv8DTnHW3QnmbZWBP3NR1hMdVXPoe+sR9pop5YsSG3BKTNxcD2/
	 +3BRlIvWPpe5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXC-00000005hx6-2wEH;
	Mon, 26 Jan 2026 12:17:34 +0000
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
Subject: [PATCH 13/20] KVM: arm64: Move RESx into individual register descriptors
Date: Mon, 26 Jan 2026 12:16:47 +0000
Message-ID: <20260126121655.1641736-14-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69136-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 40A2788200
X-Rspamd-Action: no action

Instead of hacking the RES1 bits at runtime, move them into the
register descriptors. This makes it significantly nicer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 7063fffc22799..d5871758f1fcc 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -30,6 +30,7 @@ struct reg_bits_to_feat_map {
 #define	RES0_WHEN_E2H1	BIT(7)	/* RES0 when E2H=1 and not supported */
 #define	RES1_WHEN_E2H0	BIT(8)	/* RES1 when E2H=0 and not supported */
 #define	RES1_WHEN_E2H1	BIT(9)	/* RES1 when E2H=1 and not supported */
+#define	FORCE_RESx	BIT(10)	/* Unconditional RESx */
 
 	unsigned long	flags;
 
@@ -107,6 +108,11 @@ struct reg_feat_map_desc {
  */
 #define NEEDS_FEAT(m, ...)	NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
 
+/* Declare fixed RESx bits */
+#define FORCE_RES0(m)		NEEDS_FEAT_FLAG(m, FORCE_RESx, enforce_resx)
+#define FORCE_RES1(m)		NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1, \
+						enforce_resx)
+
 /*
  * Declare the dependency between a non-FGT register, a set of
  * feature, and the set of individual bits it contains. This generates
@@ -230,6 +236,15 @@ struct reg_feat_map_desc {
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
 
+static bool enforce_resx(struct kvm *kvm)
+{
+	/*
+	 * Returning false here means that the RESx bits will be always
+	 * addded to the fixed set bit. Yes, this is counter-intuitive.
+	 */
+	return false;
+}
+
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
 	return !kvm_has_feat(kvm, FEAT_AA64EL3);
@@ -1009,6 +1024,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 		   HCR_EL2_TWEDEn,
 		   FEAT_TWED),
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
+	FORCE_RES0(HCR_EL2_RES0),
+	FORCE_RES1(HCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
@@ -1029,6 +1046,8 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 		   SCTLR2_EL1_CPTM	|
 		   SCTLR2_EL1_CPTM0,
 		   FEAT_CPA2),
+	FORCE_RES0(SCTLR2_EL1_RES0),
+	FORCE_RES1(SCTLR2_EL1_RES1),
 };
 
 static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
@@ -1054,6 +1073,8 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 		   TCR2_EL2_E0POE,
 		   FEAT_S1POE),
 	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
+	FORCE_RES0(TCR2_EL2_RES0),
+	FORCE_RES1(TCR2_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
@@ -1131,6 +1152,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   SCTLR_EL1_A		|
 		   SCTLR_EL1_M,
 		   FEAT_AA64EL1),
+	FORCE_RES0(SCTLR_EL1_RES0),
+	FORCE_RES1(SCTLR_EL1_RES1),
 };
 
 static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
@@ -1165,6 +1188,8 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 		   MDCR_EL2_TDE		|
 		   MDCR_EL2_TDRA,
 		   FEAT_AA64EL1),
+	FORCE_RES0(MDCR_EL2_RES0),
+	FORCE_RES1(MDCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
@@ -1203,6 +1228,8 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
 		   VTCR_EL2_SL0		|
 		   VTCR_EL2_T0SZ,
 		   FEAT_AA64EL1),
+	FORCE_RES0(VTCR_EL2_RES0),
+	FORCE_RES1(VTCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
@@ -1214,7 +1241,8 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 	u64 mask = 0;
 
 	for (int i = 0; i < map_size; i++)
-		mask |= map[i].bits;
+		if (!(map[i].flags & FORCE_RESx))
+			mask |= map[i].bits;
 
 	if (mask != ~resx)
 		kvm_err("Undefined %s behaviour, bits %016llx\n",
@@ -1447,28 +1475,22 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 		break;
 	case HCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
-		resx.res1 |= HCR_EL2_RES1;
 		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
 		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
-		resx.res1 |= SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
 		resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
-		resx.res1 |= TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
 		resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
-		resx.res1 |= SCTLR_EL1_RES1;
 		break;
 	case MDCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
-		resx.res1 |= MDCR_EL2_RES1;
 		break;
 	case VTCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
-		resx.res1 |= VTCR_EL2_RES1;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.47.3


