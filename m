Return-Path: <kvm+bounces-28345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8D1997555
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCCA91C20DB4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A511E7C08;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOu4wdTU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B901E7C3F;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500450; cv=none; b=jcyLv9h2ETLA43Pow/ibITBV6qhRpmEmazM397EXBvkBg887fQIL9Aa/IRQtOJxMC8y5+eccOg9WGF0iUwMEvh1QLGqHhkc8GC4is9EHv62Gfcd8PVyaUG0W0k4/jYPnxAeeaEAiVcx4PlR8wqTqFjhHrPb35hOEMR2Yz2Cas1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500450; c=relaxed/simple;
	bh=S+4M6AqxYHPECoZd/6otmEP6eUdum4OgU87CLXx3t/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cPsGZGJdGDyrNu70xnryaqd+zYaedM8aHxy4pFMsDRW2g7A6YbtZByM/mXCL4r8WbmaKY6ulsSVnB16wpcqw8oXkHVi8KRt6Wnr6rrPHRcbZ48nwnZr/w1DouyndxLA5fZD7Lw0EG99pDMIiARIm6I5OixRcS1EAAQ/ZPRyo4Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOu4wdTU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBCC4CECF;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500449;
	bh=S+4M6AqxYHPECoZd/6otmEP6eUdum4OgU87CLXx3t/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOu4wdTUiNh5KBiW/FnUcmsYXXFJ2fC1DTwN6DM172mEPILIK0BA2450fnqBl2TAj
	 Xqaob6MX7WMpU7OpaUpMrRqLBK0dPAKp1SSPj1hwkdmkfRkoEABUAPrQpEw9SXvRZD
	 P1zjGk4WvYJ0DI9AnhLC5Kj2pNFW8thsii/lodlr9E4W5Zvi071uBTCDCW5zB40w7W
	 C9t5QhicbPWbpM3AnU5/Kr1U5gEO1fT8zHj7k78+/27NqcS80aBVPlVrZIbSq+Wj1R
	 G05WPmTFuR/a8Uq2QRs03AqpUfYrc6x7vFjyijWPnV61zQvD/LnJeAwP2WORjFtiXn
	 d9qWe9K2FlNhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvT-001wcY-Vg;
	Wed, 09 Oct 2024 20:00:48 +0100
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
Subject: [PATCH v4 34/36] KVM: arm64: Make PAN conditions part of the S1 walk context
Date: Wed,  9 Oct 2024 20:00:17 +0100
Message-Id: <20241009190019.3222687-35-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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
index 301399f17983f..4ab87d75807ff 100644
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


