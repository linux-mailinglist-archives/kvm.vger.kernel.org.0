Return-Path: <kvm+bounces-69131-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNGzAsdbd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69131-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:19:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6424881E3
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5898F305B470
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497C3337B8E;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThUj+RoH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7378B3370EC;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429855; cv=none; b=EovF2n1EYfb1PeKdNVUOCHziFSPLj4AZDSnNq3nkj9cTwvAQBy9RUjJgaUBSWf36JIb8XbsFzUJ4OBowG6qLB6pwT8Si9US7U/8xOPYZs+GNKZ6jlKtssS40dbDByq2Tz0HOfrCUlG95AOojX48zs6UTEfaZ0K8FvJ/cxLM4zUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429855; c=relaxed/simple;
	bh=y57eypVaqnVgq3cxgx+jkvg59wcWPCxI619OLu3MS/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp+kmUB7jUryffqgMZ85CCMe6ZckT6GXmbH+0EoMZUhpdjg6ue/oGy4hYLXBSAXQ8F2PuHksDQMs88i1krZ8SZJufmQKe0ShS0NYKGPJIcS4BqWM2QQ7AN1nGJB0nwjIm9ib/N9A0LyiU5odcDJbJ64BL/25gC7lMfUdUN6QNRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThUj+RoH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4901DC4AF0B;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429855;
	bh=y57eypVaqnVgq3cxgx+jkvg59wcWPCxI619OLu3MS/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThUj+RoHAhJbCX5ENfAgxA2rpSz2ag1dE1DkeciOi0cxdE+7sJr4OFZpH/5IBPEcS
	 Uylx2iPIev5R1POCXHtVxZ4XwqM1rZY+My3WM6qDWx5jZT0ygsEueDbK+E39aeJuZJ
	 Qj0tSXPN678DVuqwfAqqrNiDKFluc53Md/dzRoLJk8N+Hz/HwV0pfMI5JK8M0S2ccf
	 Zoyc6i3teMqU1hRQk9LyuEcWwnvZrtUytMWJCBPqkjNrA9aRC6V21KY4SNd4CTKeB8
	 LYCv1HlBT3iA6iaIvqFNkWoYXSI1BDxWLGRPZvZT5kdMM3Udj+ZFoaqPV0reOugvnk
	 vNvrLbviOIg5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXB-00000005hx6-2Aqw;
	Mon, 26 Jan 2026 12:17:33 +0000
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
Subject: [PATCH 08/20] KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported features
Date: Mon, 26 Jan 2026 12:16:42 +0000
Message-ID: <20260126121655.1641736-9-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69131-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: A6424881E3
X-Rspamd-Action: no action

A bunch of SCTLR_EL1 bits must be set to RES1 when the controling
feature is not present. Add the AS_RES1 qualifier where needed.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6a4674fabf865..68ed5af2b4d53 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1085,27 +1085,28 @@ static const DECLARE_FEAT_MAP(tcr2_el2_desc, TCR2_EL2,
 			      tcr2_el2_feat_map, FEAT_TCR2);
 
 static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
-	NEEDS_FEAT(SCTLR_EL1_CP15BEN	|
-		   SCTLR_EL1_ITD	|
-		   SCTLR_EL1_SED,
-		   FEAT_AA32EL0),
+	NEEDS_FEAT(SCTLR_EL1_CP15BEN, FEAT_AA32EL0),
+	NEEDS_FEAT_FLAG(SCTLR_EL1_ITD	|
+			SCTLR_EL1_SED,
+			AS_RES1, FEAT_AA32EL0),
 	NEEDS_FEAT(SCTLR_EL1_BT0	|
 		   SCTLR_EL1_BT1,
 		   FEAT_BTI),
 	NEEDS_FEAT(SCTLR_EL1_CMOW, FEAT_CMOW),
-	NEEDS_FEAT(SCTLR_EL1_TSCXT, feat_csv2_2_csv2_1p2),
-	NEEDS_FEAT(SCTLR_EL1_EIS	|
-		   SCTLR_EL1_EOS,
-		   FEAT_ExS),
+	NEEDS_FEAT_FLAG(SCTLR_EL1_TSCXT,
+			AS_RES1, feat_csv2_2_csv2_1p2),
+	NEEDS_FEAT_FLAG(SCTLR_EL1_EIS	|
+			SCTLR_EL1_EOS,
+			AS_RES1, FEAT_ExS),
 	NEEDS_FEAT(SCTLR_EL1_EnFPM, FEAT_FPMR),
 	NEEDS_FEAT(SCTLR_EL1_IESB, FEAT_IESB),
 	NEEDS_FEAT(SCTLR_EL1_EnALS, FEAT_LS64),
 	NEEDS_FEAT(SCTLR_EL1_EnAS0, FEAT_LS64_ACCDATA),
 	NEEDS_FEAT(SCTLR_EL1_EnASR, FEAT_LS64_V),
 	NEEDS_FEAT(SCTLR_EL1_nAA, FEAT_LSE2),
-	NEEDS_FEAT(SCTLR_EL1_LSMAOE	|
-		   SCTLR_EL1_nTLSMD,
-		   FEAT_LSMAOC),
+	NEEDS_FEAT_FLAG(SCTLR_EL1_LSMAOE	|
+			SCTLR_EL1_nTLSMD,
+			AS_RES1, FEAT_LSMAOC),
 	NEEDS_FEAT(SCTLR_EL1_EE, FEAT_MixedEnd),
 	NEEDS_FEAT(SCTLR_EL1_E0E, feat_mixedendel0),
 	NEEDS_FEAT(SCTLR_EL1_MSCEn, FEAT_MOPS),
@@ -1121,7 +1122,8 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
 	NEEDS_FEAT(SCTLR_EL1_NMI	|
 		   SCTLR_EL1_SPINTMASK,
 		   FEAT_NMI),
-	NEEDS_FEAT(SCTLR_EL1_SPAN, FEAT_PAN),
+	NEEDS_FEAT_FLAG(SCTLR_EL1_SPAN,
+			AS_RES1, FEAT_PAN),
 	NEEDS_FEAT(SCTLR_EL1_EPAN, FEAT_PAN3),
 	NEEDS_FEAT(SCTLR_EL1_EnDA	|
 		   SCTLR_EL1_EnDB	|
-- 
2.47.3


