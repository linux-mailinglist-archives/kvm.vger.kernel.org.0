Return-Path: <kvm+bounces-25762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7564C96A2FC
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2B2A1F2A011
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0AB18BC39;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2rJYEhQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92D18B480;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377923; cv=none; b=CakEBd+M6M0Mek1MobpyITdTV+GWDD2IwFedRz0HLiLkj88E3TjsRWUwk1JLmpSo4nhzAzNUusGck6B61kUgoUuYU2O4Lhqd5zbxK88hV9iVECW4ZfCdTIu7nsFmYDK5yN88go8QL3fM6pSzf1VHX3zws0TtcbjD/3Uy663TgDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377923; c=relaxed/simple;
	bh=OvhoX5Eq9pPr4X9zaRtFKmT1okoKUM0ZuTkv+nYEtb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uw+Jhpt2BPdMkXR4LdH8XVz0GdBj/gfeJY8HJIO8DUgQez1hjv5Pv5gwDDGTXBjoOTKKTbkoFupUCRiriJzYO0MSy74XOB9KnqXqcDrDEfWbleAjczgwQ3tldbY48CgRAM4xxl6QJx+QhJdDepjZdlQ8NgBCPuGI0yiiJS/A5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2rJYEhQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E218C4CEC4;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377922;
	bh=OvhoX5Eq9pPr4X9zaRtFKmT1okoKUM0ZuTkv+nYEtb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2rJYEhQ3o4eps9Ba0LOKCb79xOiBW1rb6KdwRXQnhTBi0aucFyzlt7YahqTW/hBV
	 VMqtvRzX1TnAswViq1w0+E4dX4yhTGXZYBYngX+Rtc0oZJ5eaT+VkunBA/K84nAudg
	 v0LYHg9zBXYRBGcwfTwUTBb8ZNRvg8yF+GxcDc+cT/hAccChFEuQ2uej3Z0GlVRQnA
	 FFvaoVFKU0zRjbA/tPwBFUK4JEO6dlVoA/mPlXdusi4y3xsvsvRS1dAe93gb10cIl1
	 k3CaFWL9bQnl/xdUNRppjYCGUpPZzM9eHdUP8NBpFSIOs8So7yPm2NMD/QLqcQUR+p
	 bXt2eOI2Z4XBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc8-009Hr9-SH;
	Tue, 03 Sep 2024 16:38:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 11/16] KVM: arm64: Split S1 permission evaluation into direct and hierarchical parts
Date: Tue,  3 Sep 2024 16:38:29 +0100
Message-Id: <20240903153834.1909472-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The AArch64.S1DirectBasePermissions() pseudocode deals with both
direct and hierarchical S1 permission evaluation. While this is
probably convenient in the pseudocode, we would like a bit more
flexibility to slot things like indirect permissions.

To that effect, split the two permission check parts out of
handle_at_slow() and into their own functions. The permissions
are passed around in a new s1_perms type that contains the
individual permissions across the flow.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 164 ++++++++++++++++++++++++++------------------
 1 file changed, 99 insertions(+), 65 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 39f0e87a340e..68f5b89598ec 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -47,6 +47,10 @@ struct s1_walk_result {
 	bool	failed;
 };
 
+struct s1_perms {
+	bool	ur, uw, ux, pr, pw, px;
+};
+
 static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
 {
 	wr->fst		= fst;
@@ -747,111 +751,141 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	return sctlr & SCTLR_EL1_EPAN;
 }
 
-static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
+					  struct s1_walk_info *wi,
+					  struct s1_walk_result *wr,
+					  struct s1_perms *s1p)
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
+			s1p->pr = s1p->pw = true;
+			s1p->ur = s1p->uw = false;
 			break;
 		case 0b01:
-			pr = pw = ur = uw = true;
+			s1p->pr = s1p->pw = s1p->ur = s1p->uw = true;
 			break;
 		case 0b10:
-			pr = true;
-			pw = ur = uw = false;
+			s1p->pr = true;
+			s1p->pw = s1p->ur = s1p->uw = false;
 			break;
 		case 0b11:
-			pr = ur = true;
-			pw = uw = false;
+			s1p->pr = s1p->ur = true;
+			s1p->pw = s1p->uw = false;
 			break;
 		}
 
-		switch (wr.APTable) {
+		/* We don't use px for anything yet, but hey... */
+		s1p->px = !((wr->desc & PTE_PXN) || s1p->uw);
+		s1p->ux = !(wr->desc & PTE_UXN);
+	} else {
+		s1p->ur = s1p->uw = s1p->ux = false;
+
+		if (!(wr->desc & PTE_RDONLY)) {
+			s1p->pr = s1p->pw = true;
+		} else {
+			s1p->pr = true;
+			s1p->pw = false;
+		}
+
+		/* XN maps to UXN */
+		s1p->px = !(wr->desc & PTE_UXN);
+	}
+}
+
+static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
+						struct s1_walk_info *wi,
+						struct s1_walk_result *wr,
+						struct s1_perms *s1p)
+{
+	/* Hierarchical part of AArch64.S1DirectBasePermissions() */
+	if (wi->regime != TR_EL2) {
+		switch (wr->APTable) {
 		case 0b00:
 			break;
 		case 0b01:
-			ur = uw = false;
+			s1p->ur = s1p->uw = false;
 			break;
 		case 0b10:
-			pw = uw = false;
+			s1p->pw = s1p->uw = false;
 			break;
 		case 0b11:
-			pw = ur = uw = false;
+			s1p->pw = s1p->ur = s1p->uw = false;
 			break;
 		}
 
-		/* We don't use px for anything yet, but hey... */
-		px = !((wr.desc & PTE_PXN) || wr.PXNTable || uw);
-		ux = !((wr.desc & PTE_UXN) || wr.UXNTable);
-
-		if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
-			bool pan;
-
-			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
-			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
-			pw &= !pan;
-			pr &= !pan;
-		}
+		s1p->px &= !wr->PXNTable;
+		s1p->ux &= !wr->UXNTable;
 	} else {
-		ur = uw = ux = false;
+		if (wr->APTable & BIT(1))
+			s1p->pw = false;
 
-		if (!(wr.desc & PTE_RDONLY)) {
-			pr = pw = true;
-		} else {
-			pr = true;
-			pw = false;
-		}
+		/* XN maps to UXN */
+		s1p->px &= !wr->UXNTable;
+	}
+}
 
-		if (wr.APTable & BIT(1))
-			pw = false;
+static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
+				   struct s1_walk_info *wi,
+				   struct s1_walk_result *wr,
+				   struct s1_perms *s1p)
+{
+	compute_s1_direct_permissions(vcpu, wi, wr, s1p);
+	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
 
-		/* XN maps to UXN */
-		px = !((wr.desc & PTE_UXN) || wr.UXNTable);
+	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
+		bool pan;
+
+		pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
+		pan &= s1p->ur || s1p->uw || (pan3_enabled(vcpu, wi->regime) && s1p->ux);
+		s1p->pw &= !pan;
+		s1p->pr &= !pan;
 	}
+}
+
+static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct s1_walk_result wr = {};
+	struct s1_walk_info wi = {};
+	struct s1_perms s1p = {};
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
+	compute_s1_permissions(vcpu, op, &wi, &wr, &s1p);
 
 	switch (op) {
 	case OP_AT_S1E1RP:
 	case OP_AT_S1E1R:
 	case OP_AT_S1E2R:
-		perm_fail = !pr;
+		perm_fail = !s1p.pr;
 		break;
 	case OP_AT_S1E1WP:
 	case OP_AT_S1E1W:
 	case OP_AT_S1E2W:
-		perm_fail = !pw;
+		perm_fail = !s1p.pw;
 		break;
 	case OP_AT_S1E0R:
-		perm_fail = !ur;
+		perm_fail = !s1p.ur;
 		break;
 	case OP_AT_S1E0W:
-		perm_fail = !uw;
+		perm_fail = !s1p.uw;
 		break;
 	case OP_AT_S1E1A:
 	case OP_AT_S1E2A:
-- 
2.39.2


