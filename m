Return-Path: <kvm+bounces-69890-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADujOnDxgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69890-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:48:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5542DD04BF
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EFE3306CED6
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F8338BF9D;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPxKjrdu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994FC387358;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057822; cv=none; b=OsKPq6k9qSPJ4TwHSODEgVf/gvE6ITRjA1g/Shu4Ubri1z3/QppP+JDJrOChqelVN4/hdbnFdihC874uwpmO6egqMGc9SIjxGt3knyO7TTvZ/O2D5R2pKTMB0NGeEZFzsjKOL/t5V3VsRSOsEoets02bzxrzKbK7GTFB54UU4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057822; c=relaxed/simple;
	bh=CZHG7pAQsKiF+5kKucrA/3/G3NtJVZITV6rYwtH+oZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnFq2+wqJfbvHIORX0UHKr3XmqCHvL+wz6XLpBYVY91gZmkb+qdL6+FtLpFCuIKPM7lseAAhcEWIZIBF6eo1tfq/wglsG22uM1QrZRDhxmwCKG35vDnABLEhCllZ3Fo+TxZuhsBLkdzJBWuB6GvwgNakom5e6Q0ICAnSlFGaoGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPxKjrdu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7666FC116C6;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057822;
	bh=CZHG7pAQsKiF+5kKucrA/3/G3NtJVZITV6rYwtH+oZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPxKjrdu2ox21SY9CAAwjOQ+/KNdTk/7XUUgSqUhOFvviWSXGrSNnlyVcT/Tzm6ZH
	 Hu0dX8p8ZaFgyqqgLDslUwlxxTKKiyTaLctPNyn2w9slKU5WU+hCHpf/wScP9l6YAL
	 0Gm+ytUf8nlV12incPrt1Vy+TTJLeL0VBXboUI8qffp80kREqZzP8TVd6y8xgzJocH
	 G1VkCGRMzVzZypvKUeJ28VNVPWyS6/cG5SyLkJf7ru83R6WVjv0W1BgdXSaPNsCL3/
	 n6j4T26i04PQzQIKl+YKYMmdhoArbBakCP/GoDfc0rCFRCkLHrx6MXrGmU98ZQ6Y9Q
	 cYUOd2/WPU62w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytg-00000007sAy-2LC7;
	Mon, 02 Feb 2026 18:43:40 +0000
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
Subject: [PATCH v2 08/20] KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported features
Date: Mon,  2 Feb 2026 18:43:17 +0000
Message-ID: <20260202184329.2724080-9-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69890-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5542DD04BF
X-Rspamd-Action: no action

A bunch of SCTLR_EL1 bits must be set to RES1 when the controlling
feature is not present. Add the AS_RES1 qualifier where needed.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index bc8e6460c3fb1..2ca85c986ff14 100644
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


