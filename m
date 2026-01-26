Return-Path: <kvm+bounces-69132-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gP6GDoBbd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69132-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50616881AA
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A485F3007224
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F1C337BB3;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKeI1YGi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F0337100;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429855; cv=none; b=CiOB3BgRFN2euGFyRuurkBTfwthJP8sluupaH6R/lQfadtOwDRjtKNt3kjvTyWdJJLbjqEoWFWFUw2IgcnSt4mDunVs/R6b1Cnzpm8+JJYGqsKweRCNnjpD5jb4/MUPZY8oJMbv+eLTGhbcfzUY9GLoZaeowmzh01livlEQ+dQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429855; c=relaxed/simple;
	bh=PTm8YLSVe/WgrlU0lr7yyZgygsqs+ZiX1K/HFlMRjgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXApxb/hlCQeE2MecqmbzNnt9mZrXrAPSc0//XA3CUSQc2Bm9GBuG3fey8GinmqAa6zCNj0uS0MPSyOnsqL5UnCzzjr9Rcpwdfezv0qnBDOeQybFijON8cc92BiHPKcYovV9uAwTY6eCn3bYIqZ4jKpeXbU98mzpEV57IqIl9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKeI1YGi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8112DC2BC86;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429855;
	bh=PTm8YLSVe/WgrlU0lr7yyZgygsqs+ZiX1K/HFlMRjgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKeI1YGiUCHg53hwDL6qa8q11IrKaaJ7wzrHvlohWybi5vEbJr9A6Z1cCwBgWDq7O
	 mdFZ14MXOuF+q0nJibyQEMnAI2nxJ/R/Cu32SwT41fy6uw3hQRPEbqELiqZmpNNLrz
	 YwyQabzcoRux1N7Iand2Eejq1J1pdeoEcly3YDxZ3Ow0wsALWTn/1a12Ho3WfAZnKm
	 RHSidpZf06RP03dHJQTfimSXD4wWdrp2cWfWpY78W5ORLVikTkxtoJxz6+GwsSrkxi
	 lo+TDCRhRWaFrIHKvPq7gY6HdVWdqDA7KRpxaliYIA+2SfePkjn3UmP1v4INhNOBHP
	 nH8x3CREQZYqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXB-00000005hx6-37fT;
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
Subject: [PATCH 09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
Date: Mon, 26 Jan 2026 12:16:43 +0000
Message-ID: <20260126121655.1641736-10-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69132-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr_el2.rw:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 50616881AA
X-Rspamd-Action: no action

Now that we have the AS_RES1 constraint, it becomes trivial to express
the HCR_EL2.RW behaviour.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 68ed5af2b4d53..39487182057a3 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -389,19 +389,6 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
-static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
-{
-	/* This is purely academic: AArch32 and NV are mutually exclusive */
-	if (bits) {
-		if (kvm_has_feat(kvm, FEAT_AA32EL1))
-			*bits &= ~HCR_EL2_RW;
-		else
-			*bits |= HCR_EL2_RW;
-	}
-
-	return true;
-}
-
 static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
 {
 	if (bits) {
@@ -967,7 +954,7 @@ static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
 
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
-	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
+	NEEDS_FEAT_FLAG(HCR_EL2_RW, AS_RES1, FEAT_AA32EL1),
 	NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
 	NEEDS_FEAT(HCR_EL2_AMO		|
 		   HCR_EL2_BSU		|
-- 
2.47.3


