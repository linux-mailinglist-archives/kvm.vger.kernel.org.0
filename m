Return-Path: <kvm+bounces-69134-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NdsG+pbd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69134-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:19:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB2D881EB
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76D9130715FE
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F023382FE;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwmCywmB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3C33769C;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429856; cv=none; b=AKN+zdp0R5y9jFKO9jTW1PLP/3SZ4hHy8rKA3Yr8Fs+W5JLhpANT+EZL94jnCbK6O7q02bqydvne69R6LFDfIyfxzodF45W9+xNO5Ik8P6ITueyV2bqNrYhNmH/JlPY/3Izaj8JEgg5Zf3T0zYunCnX0DqdSC2R5nHFowXxECAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429856; c=relaxed/simple;
	bh=8SV61IKVNDuBON1I84focVHa2lv7M39kP3v6fPZu3JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ4qCooVhXH2+LM7sLVFss5QcJOgXw5s0tC5hXU/3uuNtzG3CHdaezisMCB6eDREFrm+LWlBwYKCbDRYlVKoTzY7Ai0AUX5bwc4W5M2LoVR/fMPUCnGaJh7jQBhlYu2UjAPlzopXB0vFI7k5UiO6yTbuuawizT3DfIzJ/kKL+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwmCywmB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FA6C116C6;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429856;
	bh=8SV61IKVNDuBON1I84focVHa2lv7M39kP3v6fPZu3JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwmCywmBeOqUkDvwaFxkcv3P2+JzMNVAlUFtKpcC/frkzYMZ8THUj285oQsllGPqk
	 dACnddUhBocioeDIOypVLCnyASnyBUfG/f6R8ife8l++SFWy/+cC+hrVHaEI9sSssE
	 exRFPPdgHOfOP2atGqL2XCnp0rjk4E0NAEBTNFFyQ9AHiicMtmt0relPlwdsRWGd41
	 p+6kF/I/xougHcBNa37MMQGzec39hIZcE0Gv6S1b3jj1gRJI+WlhWIV514jLO0A1fD
	 gOnJ/xJKA8WBRqlO1aeG3O3n8frMqY2F3hAqt68GOqgJ728kHhByjKeqbFjFguYjPl
	 EGGQNFjYe8zgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXC-00000005hx6-0yYK;
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
Subject: [PATCH 11/20] KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
Date: Mon, 26 Jan 2026 12:16:45 +0000
Message-ID: <20260126121655.1641736-12-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69134-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DEB2D881EB
X-Rspamd-Action: no action

A bunch of EL2 configuration are very similar to their EL1 counterpart,
with the added constraint that HCR_EL2.E2H being 1.

For us, this means HCR_EL2.E2H being RES1, which is something we can
statically evaluate.

Add a REQUIRES_E2H1 constraint, which allows us to express conditions
in a much simpler way (without extra code). Existing occurrences are
converted, before we add a lot more.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 4fac04d3132c0..1990cebc77c66 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -25,6 +25,7 @@ struct reg_bits_to_feat_map {
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
 #define	AS_RES1		BIT(4)	/* RES1 when not supported */
+#define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
 
 	unsigned long	flags;
 
@@ -311,21 +312,6 @@ static bool feat_trbe_mpam(struct kvm *kvm)
 		(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_MPAM));
 }
 
-static bool feat_asid2_e2h1(struct kvm *kvm)
-{
-	return kvm_has_feat(kvm, FEAT_ASID2) && !kvm_has_feat(kvm, FEAT_E2H0);
-}
-
-static bool feat_d128_e2h1(struct kvm *kvm)
-{
-	return kvm_has_feat(kvm, FEAT_D128) && !kvm_has_feat(kvm, FEAT_E2H0);
-}
-
-static bool feat_mec_e2h1(struct kvm *kvm)
-{
-	return kvm_has_feat(kvm, FEAT_MEC) && !kvm_has_feat(kvm, FEAT_E2H0);
-}
-
 static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
 {
 	return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
@@ -1045,15 +1031,15 @@ static const DECLARE_FEAT_MAP(sctlr2_desc, SCTLR2_EL1,
 			      sctlr2_feat_map, FEAT_SCTLR2);
 
 static const struct reg_bits_to_feat_map tcr2_el2_feat_map[] = {
-	NEEDS_FEAT(TCR2_EL2_FNG1	|
-		   TCR2_EL2_FNG0	|
-		   TCR2_EL2_A2,
-		   feat_asid2_e2h1),
-	NEEDS_FEAT(TCR2_EL2_DisCH1	|
-		   TCR2_EL2_DisCH0	|
-		   TCR2_EL2_D128,
-		   feat_d128_e2h1),
-	NEEDS_FEAT(TCR2_EL2_AMEC1, feat_mec_e2h1),
+	NEEDS_FEAT_FLAG(TCR2_EL2_FNG1	|
+			TCR2_EL2_FNG0	|
+			TCR2_EL2_A2,
+			REQUIRES_E2H1, FEAT_ASID2),
+	NEEDS_FEAT_FLAG(TCR2_EL2_DisCH1	|
+			TCR2_EL2_DisCH0	|
+			TCR2_EL2_D128,
+			REQUIRES_E2H1, FEAT_D128),
+	NEEDS_FEAT_FLAG(TCR2_EL2_AMEC1, REQUIRES_E2H1, FEAT_MEC),
 	NEEDS_FEAT(TCR2_EL2_AMEC0, FEAT_MEC),
 	NEEDS_FEAT(TCR2_EL2_HAFT, FEAT_HAFT),
 	NEEDS_FEAT(TCR2_EL2_PTTWI	|
@@ -1285,6 +1271,7 @@ struct resx compute_resx_bits(struct kvm *kvm,
 			      unsigned long require,
 			      unsigned long exclude)
 {
+	bool e2h0 = kvm_has_feat(kvm, FEAT_E2H0);
 	struct resx resx = {};
 
 	for (int i = 0; i < map_size; i++) {
@@ -1307,6 +1294,9 @@ struct resx compute_resx_bits(struct kvm *kvm,
 			match = idreg_feat_match(kvm, &map[i]);
 		}
 
+		if (map[i].flags & REQUIRES_E2H1)
+			match &= !e2h0;
+		
 		if (!match) {
 			if (map[i].flags & AS_RES1)
  				resx.res1 |= reg_feat_map_bits(&map[i]);
-- 
2.47.3


