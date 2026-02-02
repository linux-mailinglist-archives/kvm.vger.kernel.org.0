Return-Path: <kvm+bounces-69893-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cImeIYDwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69893-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A3853D0422
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8E19230046BB
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A3138E11C;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpu9nrxC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D19E38B9AB;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057823; cv=none; b=YU2c30AKxgM9pNe+JpV25hs8cQhdt3LtuFYJOT2d3em1JgBpZQDlyrpUsvB9sT91i/RL99KT0MNh+ZLFAEZSwvvNfnVN3phXHBvWRf7hX/Qs7hqRfqPfy55q8F/li6Djd3Eixf8FidbKyq6oemIjqyKEhbHphW7YaMuuuQWmJpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057823; c=relaxed/simple;
	bh=u/DpENLFgSB2Z5sBHRWJQh8KuazrZnHHl3Rf+5mSesM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsazAJFwvzFTLt6z9wv8DUlEYCNRiWuo3gB02t1+aUV2I4POA911w02f05mO9b+ez+fdVsMqCKzbTQoU7M4v/khj+o21NnIt0hPRG3yJoLVtYEMf0y9lctIGm6C0NbtIQzj7DetJng7kwUTEtV1NUTvX0hoY6k2n9JfljLwHIYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpu9nrxC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2532BC2BC86;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057823;
	bh=u/DpENLFgSB2Z5sBHRWJQh8KuazrZnHHl3Rf+5mSesM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpu9nrxCGvd5ekb9zqh/QFARXlUO7J9VKyLhFRrbR9vSGTBktffAnBO7WGpvkvNxK
	 yu1W37am5CGru9sVhPDSDP1KRjQe6cEjJHq+hTPtgPshSdjvAuZWBmM1khFMebvvIh
	 zTfRtJHC32GPUPJX4fjKKYu3etrfyzk7mW/LmGSdkNhaLlnUelIh0ZPUEJj2L3Zy2x
	 9WX9dR7fmgNPYHz7zTabuGOjfKm7rUTjb6laynqmQ5kDxvgGBET1qLPkd+9L23AeP0
	 vKVBxx+IBbbzpFzO/z/ap1nBOQcmialM82/k3506zuScyBsdLAM/13Vu29xyjSPC3e
	 praFTFqGUpY8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyth-00000007sAy-0xcF;
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
Subject: [PATCH v2 11/20] KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
Date: Mon,  2 Feb 2026 18:43:20 +0000
Message-ID: <20260202184329.2724080-12-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69893-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A3853D0422
X-Rspamd-Action: no action

A bunch of EL2 configuration are very similar to their EL1 counterpart,
with the added constraint that HCR_EL2.E2H being 1.

For us, this means HCR_EL2.E2H being RES1, which is something we can
statically evaluate.

Add a REQUIRES_E2H1 constraint, which allows us to express conditions
in a much simpler way (without extra code). Existing occurrences are
converted, before we add a lot more.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e41c2b83bc945..7d133954ae01b 100644
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
@@ -1284,6 +1270,7 @@ static struct resx compute_resx_bits(struct kvm *kvm,
 				     unsigned long require,
 				     unsigned long exclude)
 {
+	bool e2h0 = kvm_has_feat(kvm, FEAT_E2H0);
 	struct resx resx = {};
 
 	for (int i = 0; i < map_size; i++) {
@@ -1306,6 +1293,9 @@ static struct resx compute_resx_bits(struct kvm *kvm,
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


