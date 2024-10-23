Return-Path: <kvm+bounces-29556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 303CE9ACE00
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E24DE283FA1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B400920A5F2;
	Wed, 23 Oct 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOPgSy4o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B946C209F3E;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695238; cv=none; b=Qg25gfAgSN/i9UZ6BKgdLFXKIHiXvZrBao6UsUb2q7d/0NPrX6vr+ZlbhQ5xuGKbsvWrLCFzL5E324ut/cnK0A+eyoGVVf0TRFuht2BYB2Fsn+3/A8w1tlN7hDfmymmrWopratFQ+UqkiPVdVSE49UIuDL8A5c+lWh/3qbVviPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695238; c=relaxed/simple;
	bh=wZ18w5uzFaEd+9v97fcSC0+OL0V2c3KqXQJR4zHPEoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZeMWZp7egk2PZCzwmJwyEjWY56Fx1gjth4eeIuwE1t6IuZRu95/Zp8Zfo+8UmCReG73vnKTrsewh48BGj4YjPz7U1G+u97n1bCFvYry2b1VACg4jgkHBbCnuWsdMr/Z4Og2h+isLPRUH6KawKpzj6kPFa/V2IcVIbYxO1TcJRXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOPgSy4o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EEAC4CEE7;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695238;
	bh=wZ18w5uzFaEd+9v97fcSC0+OL0V2c3KqXQJR4zHPEoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOPgSy4oftIXJPtFQ51XQfT6nCXwyWt1potE1fACSFECbVyY40Bga7VI/L9yKf0Tk
	 wSq1jeN8vXdYnK7asMYbrvED4u5XfoLCgG22/bgb6LQ5pcJRrh9G4waMWnN1pRye79
	 Pm9ZgF/5WsqcSVMJXkn3RCIQg6Xork2Bb2b+g/DBmiHdR1bLx++bW76l8W7D6A3Z/6
	 nspY/287qpolZC+CJxY/CvTkW3IeS+B7TQDPQWoHjLlwY6pmQw23wxIEVLhWKU73ii
	 HYwuCGiCmmdoUoNRRMkuLG3hbYtrLIlwXtU9maZhKz72M45UcnwOytZZAhKRmVTO+1
	 eHEVg4bQkGKJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckG-0068vz-SP;
	Wed, 23 Oct 2024 15:53:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 35/37] KVM: arm64: Make PAN conditions part of the S1 walk context
Date: Wed, 23 Oct 2024 15:53:43 +0100
Message-Id: <20241023145345.1613824-36-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Move the conditions describing PAN as part of the s1_walk_info
structure, in an effort to declutter the permission processing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8d1dc6327ec5b..2ab2c3578c3a0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -26,6 +26,7 @@ struct s1_walk_info {
 	bool	     		hpd;
 	bool			e0poe;
 	bool			poe;
+	bool			pan;
 	bool	     		be;
 	bool	     		s2;
 };
@@ -151,6 +152,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 
 	wi->regime = compute_translation_regime(vcpu, op);
 	as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
+	wi->pan = (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) &&
+		  (*vcpu_cpsr(vcpu) & PSR_PAN_BIT);
 
 	va55 = va & BIT(55);
 
@@ -1020,10 +1023,12 @@ static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
+static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 				   struct s1_walk_info *wi,
 				   struct s1_walk_result *wr)
 {
+	bool pan;
+
 	if (!s1pie_enabled(vcpu, wi->regime))
 		compute_s1_direct_permissions(vcpu, wi, wr);
 	else
@@ -1032,14 +1037,10 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
 	if (!wi->hpd)
 		compute_s1_hierarchical_permissions(vcpu, wi, wr);
 
-	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
-		bool pan;
-
-		pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-		pan &= wr->ur || wr->uw || (pan3_enabled(vcpu, wi->regime) && wr->ux);
-		wr->pw &= !pan;
-		wr->pr &= !pan;
-	}
+	pan = wi->pan && (wr->ur || wr->uw ||
+			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
+	wr->pw &= !pan;
+	wr->pr &= !pan;
 }
 
 static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
@@ -1065,7 +1066,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	if (ret)
 		goto compute_par;
 
-	compute_s1_permissions(vcpu, op, &wi, &wr);
+	compute_s1_permissions(vcpu, &wi, &wr);
 
 	switch (op) {
 	case OP_AT_S1E1RP:
-- 
2.39.2


