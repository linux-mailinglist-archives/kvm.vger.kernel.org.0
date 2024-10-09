Return-Path: <kvm+bounces-28329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC352997545
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 708C6285BFD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2841E47B7;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcA5rsou"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A054C1E3787;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500446; cv=none; b=KDow8u7VoE2U6yA9P2FRJz00LbOXIYYlt1XW8H8HQIPXiO51+n0X2hLYkm2kUZ3oc82KxrOEoTT49XtRhx5IRz1RBMJtcUSDFw/sXHSAAXBNIn6TR1g/s0R4TgrH2bmaj2TIeBDJJFfXjByGgJXz+XMV9mSp7VermjcO222+4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500446; c=relaxed/simple;
	bh=94ZxBE/fRbkOTF9bxMR8oYJg1g6c0hqbQxQqrdRz6CU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PmfbmIT8KMdCPFokWPiyiPzNOgIPdh6VeBcM1Sq6zgp73+C0vHihlw7DNFLFpQyKpolgOqTXMhBAJRvsbpnW0Xvyl4VYBFu+M13eaggzV4zkzOqsRj/CPrcgkj+SIPUpUuYMC5rhmEZnySCqFGBNVVRveBipjEVRHUEr4kTfYdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcA5rsou; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73427C4CEDB;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500446;
	bh=94ZxBE/fRbkOTF9bxMR8oYJg1g6c0hqbQxQqrdRz6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcA5rsouJF+qRZ4FVWyCdHc3QtxS3Kiitsm1A4yjV4cyr3PicpBqNb31fPjVbQ6U9
	 aTE1O/QrxRDXgPcR1hP+yYj6yftqm6ND5S0JqNlMC+30S4HWl/CU1VijiiDKoPRXWl
	 /zOSAw3ccOibG6B/95S3eTb1UiG6zPHqlaqbwMS1KZoNxAfi4ccOCgnFJ2qZT3VITJ
	 LCARfHeomEY/FJxUALnPVWQhsKefTDfUTlNqzLSEN+EJb0M+ef7v6NPtXCilbhyHAz
	 +Uc0ILonde2/agarxa7s2iCvzCMWYk5LurpWM04CWICCq+tMVaMXaApWKjdy7qvwd6
	 lN1WVO5qA9k1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvQ-001wcY-Ii;
	Wed, 09 Oct 2024 20:00:44 +0100
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
Subject: [PATCH v4 19/36] KVM: arm64: Split S1 permission evaluation into direct and hierarchical parts
Date: Wed,  9 Oct 2024 20:00:02 +0100
Message-Id: <20241009190019.3222687-20-maz@kernel.org>
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

The AArch64.S1DirectBasePermissions() pseudocode deals with both
direct and hierarchical S1 permission evaluation. While this is
probably convenient in the pseudocode, we would like a bit more
flexibility to slot things like indirect permissions.

To that effect, split the two permission check parts out of
handle_at_slow() and into their own functions. The permissions
are passed around as part of the walk_result structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 162 +++++++++++++++++++++++++++-----------------
 1 file changed, 98 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index b9d0992e91972..adcfce3f67f03 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -37,6 +37,12 @@ struct s1_walk_result {
 			u8	APTable;
 			bool	UXNTable;
 			bool	PXNTable;
+			bool	ur;
+			bool	uw;
+			bool	ux;
+			bool	pr;
+			bool	pw;
+			bool	px;
 		};
 		struct {
 			u8	fst;
@@ -764,111 +770,139 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	return sctlr & SCTLR_EL1_EPAN;
 }
 
-static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
+					  struct s1_walk_info *wi,
+					  struct s1_walk_result *wr)
 {
-	bool perm_fail, ur, uw, ux, pr, pw, px;
-	struct s1_walk_result wr = {};
-	struct s1_walk_info wi = {};
-	int ret, idx;
-
-	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
-	if (ret)
-		goto compute_par;
-
-	if (wr.level == S1_MMU_DISABLED)
-		goto compute_par;
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-
-	ret = walk_s1(vcpu, &wi, &wr, vaddr);
-
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-
-	if (ret)
-		goto compute_par;
-
-	/* FIXME: revisit when adding indirect permission support */
-	/* AArch64.S1DirectBasePermissions() */
-	if (wi.regime != TR_EL2) {
-		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr.desc)) {
+	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
+	if (wi->regime != TR_EL2) {
+		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
 		case 0b00:
-			pr = pw = true;
-			ur = uw = false;
+			wr->pr = wr->pw = true;
+			wr->ur = wr->uw = false;
 			break;
 		case 0b01:
-			pr = pw = ur = uw = true;
+			wr->pr = wr->pw = wr->ur = wr->uw = true;
 			break;
 		case 0b10:
-			pr = true;
-			pw = ur = uw = false;
+			wr->pr = true;
+			wr->pw = wr->ur = wr->uw = false;
 			break;
 		case 0b11:
-			pr = ur = true;
-			pw = uw = false;
+			wr->pr = wr->ur = true;
+			wr->pw = wr->uw = false;
 			break;
 		}
 
-		switch (wr.APTable) {
+		/* We don't use px for anything yet, but hey... */
+		wr->px = !((wr->desc & PTE_PXN) || wr->uw);
+		wr->ux = !(wr->desc & PTE_UXN);
+	} else {
+		wr->ur = wr->uw = wr->ux = false;
+
+		if (!(wr->desc & PTE_RDONLY)) {
+			wr->pr = wr->pw = true;
+		} else {
+			wr->pr = true;
+			wr->pw = false;
+		}
+
+		/* XN maps to UXN */
+		wr->px = !(wr->desc & PTE_UXN);
+	}
+}
+
+static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
+						struct s1_walk_info *wi,
+						struct s1_walk_result *wr)
+{
+	/* Hierarchical part of AArch64.S1DirectBasePermissions() */
+	if (wi->regime != TR_EL2) {
+		switch (wr->APTable) {
 		case 0b00:
 			break;
 		case 0b01:
-			ur = uw = false;
+			wr->ur = wr->uw = false;
 			break;
 		case 0b10:
-			pw = uw = false;
+			wr->pw = wr->uw = false;
 			break;
 		case 0b11:
-			pw = ur = uw = false;
+			wr->pw = wr->ur = wr->uw = false;
 			break;
 		}
 
-		/* We don't use px for anything yet, but hey... */
-		px = !((wr.desc & PTE_PXN) || wr.PXNTable || uw);
-		ux = !((wr.desc & PTE_UXN) || wr.UXNTable);
+		wr->px &= !wr->PXNTable;
+		wr->ux &= !wr->UXNTable;
+	} else {
+		if (wr->APTable & BIT(1))
+			wr->pw = false;
 
-		if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
-			bool pan;
+		/* XN maps to UXN */
+		wr->px &= !wr->UXNTable;
+	}
+}
 
-			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
-			pw &= !pan;
-			pr &= !pan;
-		}
-	} else {
-		ur = uw = ux = false;
+static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
+				   struct s1_walk_info *wi,
+				   struct s1_walk_result *wr)
+{
+	compute_s1_direct_permissions(vcpu, wi, wr);
 
-		if (!(wr.desc & PTE_RDONLY)) {
-			pr = pw = true;
-		} else {
-			pr = true;
-			pw = false;
-		}
+	if (!wi->hpd)
+		compute_s1_hierarchical_permissions(vcpu, wi, wr);
 
-		if (wr.APTable & BIT(1))
-			pw = false;
+	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
+		bool pan;
 
-		/* XN maps to UXN */
-		px = !((wr.desc & PTE_UXN) || wr.UXNTable);
+		pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
+		pan &= wr->ur || wr->uw || (pan3_enabled(vcpu, wi->regime) && wr->ux);
+		wr->pw &= !pan;
+		wr->pr &= !pan;
 	}
+}
+
+static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct s1_walk_result wr = {};
+	struct s1_walk_info wi = {};
+	bool perm_fail = false;
+	int ret, idx;
+
+	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
+	if (ret)
+		goto compute_par;
+
+	if (wr.level == S1_MMU_DISABLED)
+		goto compute_par;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	ret = walk_s1(vcpu, &wi, &wr, vaddr);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (ret)
+		goto compute_par;
 
-	perm_fail = false;
+	compute_s1_permissions(vcpu, op, &wi, &wr);
 
 	switch (op) {
 	case OP_AT_S1E1RP:
 	case OP_AT_S1E1R:
 	case OP_AT_S1E2R:
-		perm_fail = !pr;
+		perm_fail = !wr.pr;
 		break;
 	case OP_AT_S1E1WP:
 	case OP_AT_S1E1W:
 	case OP_AT_S1E2W:
-		perm_fail = !pw;
+		perm_fail = !wr.pw;
 		break;
 	case OP_AT_S1E0R:
-		perm_fail = !ur;
+		perm_fail = !wr.ur;
 		break;
 	case OP_AT_S1E0W:
-		perm_fail = !uw;
+		perm_fail = !wr.uw;
 		break;
 	case OP_AT_S1E1A:
 	case OP_AT_S1E2A:
-- 
2.39.2


