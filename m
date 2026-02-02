Return-Path: <kvm+bounces-69895-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGHpJuPwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69895-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:45:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 24DECD045F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D9BC3060F9A
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF0138B9AB;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aShLhAte"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3B38E106;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057823; cv=none; b=sIBpTKCGPWbeZc9DVvLtH3z1t4KRi0bkxv37gtbPXzC9DUQJ3lLewAAA/zbOTyycnvYM6skY8HvU2zwbyMYHcWjPSa+VSAJIoePGPHGhN8YNeHZXdDU+pP4MbOlS1iTZB2doN+amjdaT73KOF8xoBaW4hyJ7UnTasxVJqZVeKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057823; c=relaxed/simple;
	bh=mya2aNm0MFtu4TDLCNnLunOt1rwd+05YOh2F8NM3xkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbyQowzhJcvoepSfcJxU8jOFf9K3IoGOrJNwi/WZfj9qZOz9ADuqYoN5GasM0p9UhRg9qaFmZrV7ZtyC/dKS9n7crsNg9DVdAS83yvRfdawPAkdqHCmejCmhX6m/0/BuW6cS0t94UctsoP0bDTBYo944FzurRbq/WARy4ioQ+4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aShLhAte; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94284C2BCB0;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057823;
	bh=mya2aNm0MFtu4TDLCNnLunOt1rwd+05YOh2F8NM3xkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aShLhAteHsow1yBXQE9b4PrezL5yg/Ot+AKxO1o/sJPnRAICs3p8vPvBZ3HWsIHbf
	 8b+c/dijXdpNUWWzOeXwxGriwFnNHArYQDB0GeEHLdyj6WPWOq1jpLkkVE8xT4pBg5
	 kRi3422MKHYmpZ7YfyDT42OSYjL8ZYu07ycwfxPoG5OOXfoBraUXlodXmX9u3zLa/Q
	 Iw81+xwNTxoPaZMCNS+JD4+hr55Q3h6RIXLOgUz6SgBGF0XdTqd+iptXuy/shw4BvN
	 BjkNqrluEFoLguDw7580TWL55Y9pejHmaiayuwqa9XsZF4QxECx/u3rR1Al8rrfv9u
	 +SdmXxkvdczjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyth-00000007sAy-2rEU;
	Mon, 02 Feb 2026 18:43:41 +0000
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
Subject: [PATCH v2 13/20] KVM: arm64: Move RESx into individual register descriptors
Date: Mon,  2 Feb 2026 18:43:22 +0000
Message-ID: <20260202184329.2724080-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69895-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 24DECD045F
X-Rspamd-Action: no action

Instead of hacking the RES1 bits at runtime, move them into the
register descriptors. This makes it significantly nicer.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 48 +++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 7e8e42c1cee4a..474d5c8038c24 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -28,6 +28,7 @@ struct reg_bits_to_feat_map {
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
 #define	RES1_WHEN_E2H0	BIT(6)	/* RES1 when E2H=0 and not supported */
 #define	RES1_WHEN_E2H1	BIT(7)	/* RES1 when E2H=1 and not supported */
+#define	FORCE_RESx	BIT(8)	/* Unconditional RESx */
 
 	unsigned long	flags;
 
@@ -87,6 +88,12 @@ struct reg_feat_map_desc {
 		.match = (fun),				\
 	}
 
+#define __NEEDS_FEAT_0(m, f, w, ...)			\
+	{						\
+		.w	= (m),				\
+		.flags = (f),				\
+	}
+
 #define __NEEDS_FEAT_FLAG(m, f, w, ...)			\
 	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, w, __VA_ARGS__)
 
@@ -105,10 +112,14 @@ struct reg_feat_map_desc {
  */
 #define NEEDS_FEAT(m, ...)	NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
 
+/* Declare fixed RESx bits */
+#define FORCE_RES0(m)		NEEDS_FEAT_FLAG(m, FORCE_RESx)
+#define FORCE_RES1(m)		NEEDS_FEAT_FLAG(m, FORCE_RESx | AS_RES1)
+
 /*
- * Declare the dependency between a non-FGT register, a set of
- * feature, and the set of individual bits it contains. This generates
- * a struct reg_feat_map_desc.
+ * Declare the dependency between a non-FGT register, a set of features,
+ * and the set of individual bits it contains. This generates a struct
+ * reg_feat_map_desc.
  */
 #define DECLARE_FEAT_MAP(n, r, m, f)					\
 	struct reg_feat_map_desc n = {					\
@@ -1007,6 +1018,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 		   HCR_EL2_TWEDEn,
 		   FEAT_TWED),
 	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
+	FORCE_RES0(HCR_EL2_RES0),
+	FORCE_RES1(HCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
@@ -1027,6 +1040,8 @@ static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
 		   SCTLR2_EL1_CPTM	|
 		   SCTLR2_EL1_CPTM0,
 		   FEAT_CPA2),
+	FORCE_RES0(SCTLR2_EL1_RES0),
+	FORCE_RES1(SCTLR2_EL1_RES1),
 };
 
 static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
@@ -1052,6 +1067,8 @@ static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
 		   TCR2_EL2_E0POE,
 		   FEAT_S1POE),
 	NEEDS_FEAT(TCR2_EL2_PIE, FEAT_S1PIE),
+	FORCE_RES0(TCR2_EL2_RES0),
+	FORCE_RES1(TCR2_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
@@ -1129,6 +1146,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 		   SCTLR_EL1_A		|
 		   SCTLR_EL1_M,
 		   FEAT_AA64EL1),
+	FORCE_RES0(SCTLR_EL1_RES0),
+	FORCE_RES1(SCTLR_EL1_RES1),
 };
 
 static const DECLARE_FEAT_MAP(sctlr_el1_desc, SCTLR_EL1,
@@ -1163,6 +1182,8 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
 		   MDCR_EL2_TDE		|
 		   MDCR_EL2_TDRA,
 		   FEAT_AA64EL1),
+	FORCE_RES0(MDCR_EL2_RES0),
+	FORCE_RES1(MDCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
@@ -1201,6 +1222,8 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
 		   VTCR_EL2_SL0		|
 		   VTCR_EL2_T0SZ,
 		   FEAT_AA64EL1),
+	FORCE_RES0(VTCR_EL2_RES0),
+	FORCE_RES1(VTCR_EL2_RES1),
 };
 
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
@@ -1211,8 +1234,14 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 {
 	u64 mask = 0;
 
+	/*
+	 * Don't account for FORCE_RESx that are architectural, and
+	 * therefore part of the resx parameter. Other FORCE_RESx bits
+	 * are implementation choices, and therefore accounted for.
+	 */
 	for (int i = 0; i < map_size; i++)
-		mask |= map[i].bits;
+		if (!((map[i].flags & FORCE_RESx) && (map[i].bits & resx)))
+			mask |= map[i].bits;
 
 	if (mask != ~resx)
 		kvm_err("Undefined %s behaviour, bits %016llx\n",
@@ -1284,13 +1313,16 @@ static struct resx compute_resx_bits(struct kvm *kvm,
 		if (map[i].flags & exclude)
 			continue;
 
-		switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
+		switch (map[i].flags & (FORCE_RESx | CALL_FUNC | FIXED_VALUE)) {
 		case CALL_FUNC | FIXED_VALUE:
 			map[i].fval(kvm, &resx);
 			continue;
 		case CALL_FUNC:
 			match = map[i].match(kvm);
 			break;
+		case FORCE_RESx:
+			match = false;
+			break;
 		default:
 			match = idreg_feat_match(kvm, &map[i]);
 		}
@@ -1434,28 +1466,22 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
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


