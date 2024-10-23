Return-Path: <kvm+bounces-29559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C76F9ACE03
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECE24B282AA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC4720697F;
	Wed, 23 Oct 2024 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atBq4JQG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0BF20A5E2;
	Wed, 23 Oct 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695239; cv=none; b=nc3WDX5tGnNt/XRxg1S5udyXi8bbJdr4Vrm9sDv2s0srILlJJHO1lYe4ylEFVcoWA82Xk2EczuexCQK2ukB7JHLeHK50XYwobmg7bbDa9GQ7eFZqZNJ2upZcHLWS0tzPVtS5izO+bsE+hYVXZwTXaQNC05isk4g5niEgsryAD8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695239; c=relaxed/simple;
	bh=HaAMbLjHvEBYTJntSK9g1Kuu6XtJwMzo1Mxh7bO9MCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FM3L0f8mGxTH9K2NpE7ntjosEh3FaR6dMfMMrZz+AoAcwlejskOUIlM9Y08TI08ylFhwErhJY0/UAIJVI13YX6yXc0+4NKGCtFk4H4EOpi8ifOdyO7wO5ScT3LfIXNXHk6J8TNzuoZdgHudAT040FY1bVCDXWftYJ8oNXftLw28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atBq4JQG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB4DC4CEE4;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695239;
	bh=HaAMbLjHvEBYTJntSK9g1Kuu6XtJwMzo1Mxh7bO9MCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atBq4JQG3ggj5KST+dQkFG81JJ7LTjW/JovGWPYHIjx3JJv+nlRQxIPReTasJnglC
	 e8rLfqFWZBGrVKvc+/U5h54FPEz4fppMy25sN31OwLOlYPWQgfU7miAZcUd4KtlBfu
	 2UvtuHsH+Arr9vuIp4QLzX/6icHnVVswsVzy2pDV0pdv9asccN16DGWf/HyeMvDQhT
	 m1buXKPT1oBw6ajsiDdgmCy110PDb4ygvpwkE4r3um5yKpsEoDTSwem2444+DVKiP0
	 KXRGayyUTiirLx74ipGUmqVeaY5PQuvJdbs02XQi6OQVca586fUYbbU3QlzLAQiIDi
	 p04suHE+BVeQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckH-0068vz-8T;
	Wed, 23 Oct 2024 15:53:57 +0100
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
Subject: [PATCH v5 37/37] KVM: arm64: Handle WXN attribute
Date: Wed, 23 Oct 2024 15:53:45 +0100
Message-Id: <20241023145345.1613824-38-maz@kernel.org>
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

Until now, we didn't really care about WXN as it didn't have an
effect on the R/W permissions (only the execution could be droppped),
and therefore not of interest for AT.

However, with S1POE, WXN can revoke the Write permission if an
overlay is active and that execution is allowed. This *is* relevant
to AT.

Add full handling of WXN so that we correctly handle this case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index d300cd1a0d8a7..8c5d7990e5b31 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -40,10 +40,12 @@ struct s1_walk_result {
 			u8	APTable;
 			bool	UXNTable;
 			bool	PXNTable;
+			bool	uwxn;
 			bool	uov;
 			bool	ur;
 			bool	uw;
 			bool	ux;
+			bool	pwxn;
 			bool	pov;
 			bool	pr;
 			bool	pw;
@@ -847,6 +849,8 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 					  struct s1_walk_info *wi,
 					  struct s1_walk_result *wr)
 {
+	bool wxn;
+
 	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
 	if (wi->regime != TR_EL2) {
 		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
@@ -884,6 +888,17 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 		wr->px = !(wr->desc & PTE_UXN);
 	}
 
+	switch (wi->regime) {
+	case TR_EL2:
+	case TR_EL20:
+		wxn = (vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_WXN);
+		break;
+	case TR_EL10:
+		wxn = (__vcpu_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_WXN);
+		break;
+	}
+
+	wr->pwxn = wr->uwxn = wxn;
 	wr->pov = wi->poe;
 	wr->uov = wi->e0poe;
 }
@@ -935,6 +950,16 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
 		(wr)->ux = (x);		\
 	} while (0)
 
+#define set_priv_wxn(wr, v)		\
+	do {				\
+		(wr)->pwxn = (v);	\
+	} while (0)
+
+#define set_unpriv_wxn(wr, v)		\
+	do {				\
+		(wr)->uwxn = (v);	\
+	} while (0)
+
 /* Similar to AArch64.S1IndirectBasePermissions(), without GCS  */
 #define set_perms(w, wr, ip)						\
 	do {								\
@@ -989,6 +1014,10 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
 			set_ ## w ## _perms((wr), false, false, false);	\
 			break;						\
 		}							\
+									\
+		/* R_HJYGR */						\
+		set_ ## w ## _wxn((wr), ((ip) == 0b0110));		\
+									\
 	} while (0)
 
 static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
@@ -1090,6 +1119,22 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 	if (wi->poe || wi->e0poe)
 		compute_s1_overlay_permissions(vcpu, wi, wr);
 
+	/* R_QXXPC */
+	if (wr->pwxn) {
+		if (!wr->pov && wr->pw)
+			wr->px = false;
+		if (wr->pov && wr->px)
+			wr->pw = false;
+	}
+
+	/* R_NPBXC */
+	if (wr->uwxn) {
+		if (!wr->uov && wr->uw)
+			wr->ux = false;
+		if (wr->uov && wr->ux)
+			wr->uw = false;
+	}
+
 	pan = wi->pan && (wr->ur || wr->uw ||
 			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
 	wr->pw &= !pan;
-- 
2.39.2


