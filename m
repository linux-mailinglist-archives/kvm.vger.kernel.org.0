Return-Path: <kvm+bounces-29558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADC19ACE02
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E60911F24951
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CCC20A5F7;
	Wed, 23 Oct 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EH6y4mkg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC107209F4B;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695238; cv=none; b=c749R4HJAVPG3l+5txKR49rUKDuZ6j1Lub4N6AEzaIyi3Sed8V7+NxmGjuhFLEMOgriM1z52tN0G26cksGMhFIwrkONuPk9cymuWorwKvIDX/pC3kBzHeK/ePCO1mrwvKRTk076Av1g8mLu5p/bLxnw1+rYW9fC8YigD3RGlnNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695238; c=relaxed/simple;
	bh=IELrSxwq0YYfqTQ+7AffvzDHFrt+2D5q6aQ08Totfc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KnKXVWykTcL5Ed09rjPyu+fa9FDCmmXecqyZjE2bEcYOYKCsaWOnh8rg/DRyIgmBgancfCTljQfE8xqDMB+4INNOn5NUY4luQLuyo824dLsjIcYJlpsI+KqphZzMSPIgT887RqbdnqJ8yi66IV0hVNkkO6vQzMs6rRQbSb52xAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EH6y4mkg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3FAC4CECD;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695238;
	bh=IELrSxwq0YYfqTQ+7AffvzDHFrt+2D5q6aQ08Totfc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EH6y4mkgpXVlJPcAaQ66p/3bN7Ex2nMFSEB0BfsKg5FqtlVoi/3Qepd6Y6U5H4eMk
	 nPG+IqQ4KB7wSdBqo1hztsQqQ9+ZM68AJmu3HvP0WKWKB/6eiRy4msvc6CV/HTourM
	 5vQGGDm67wLY2Y8Tf12qgPFlCENS7VGWJzQRk+dpswPKhw3Fu00pzsrWRNwc7KlYCp
	 0MtidjZ0zhCwIC0SCoP3mZQ6X0p/TkIdInWx5DvZvcz3Xa3f5hsbTuGFBQ/qqtwjL6
	 Phx9htQXejFO2+fscDAmgeHtLCDVREBpETQij5NWWJMzuYvUynHB4jdPtLZS435lhh
	 GG+EC+TjNiWtw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckH-0068vz-2N;
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
Subject: [PATCH v5 36/37] KVM: arm64: Handle stage-1 permission overlays
Date: Wed, 23 Oct 2024 15:53:44 +0100
Message-Id: <20241023145345.1613824-37-maz@kernel.org>
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

We now have the intrastructure in place to emulate S1POE:

- direct permissions are always overlay-capable
- indirect permissions are overlay-capable if the permissions are
  in the 0b0xxx range
- the overlays are strictly substractive

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 2ab2c3578c3a0..d300cd1a0d8a7 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -40,9 +40,11 @@ struct s1_walk_result {
 			u8	APTable;
 			bool	UXNTable;
 			bool	PXNTable;
+			bool	uov;
 			bool	ur;
 			bool	uw;
 			bool	ux;
+			bool	pov;
 			bool	pr;
 			bool	pw;
 			bool	px;
@@ -881,6 +883,9 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
 		/* XN maps to UXN */
 		wr->px = !(wr->desc & PTE_UXN);
 	}
+
+	wr->pov = wi->poe;
+	wr->uov = wi->e0poe;
 }
 
 static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
@@ -1016,6 +1021,9 @@ static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
 	else
 		set_unpriv_perms(wr, false, false, false);
 
+	wr->pov = wi->poe && !(pp & BIT(3));
+	wr->uov = wi->e0poe && !(up & BIT(3));
+
 	/* R_VFPJF */
 	if (wr->px && wr->uw) {
 		set_priv_perms(wr, false, false, false);
@@ -1023,6 +1031,48 @@ static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void compute_s1_overlay_permissions(struct kvm_vcpu *vcpu,
+					   struct s1_walk_info *wi,
+					   struct s1_walk_result *wr)
+{
+	u8 idx, pov_perms, uov_perms;
+
+	idx = FIELD_GET(PTE_PO_IDX_MASK, wr->desc);
+
+	switch (wi->regime) {
+	case TR_EL10:
+		pov_perms = perm_idx(vcpu, POR_EL1, idx);
+		uov_perms = perm_idx(vcpu, POR_EL0, idx);
+		break;
+	case TR_EL20:
+		pov_perms = perm_idx(vcpu, POR_EL2, idx);
+		uov_perms = perm_idx(vcpu, POR_EL0, idx);
+		break;
+	case TR_EL2:
+		pov_perms = perm_idx(vcpu, POR_EL2, idx);
+		uov_perms = 0;
+		break;
+	}
+
+	if (pov_perms & ~POE_RXW)
+		pov_perms = POE_NONE;
+
+	if (wi->poe && wr->pov) {
+		wr->pr &= pov_perms & POE_R;
+		wr->px &= pov_perms & POE_X;
+		wr->pw &= pov_perms & POE_W;
+	}
+
+	if (uov_perms & ~POE_RXW)
+		uov_perms = POE_NONE;
+
+	if (wi->e0poe && wr->uov) {
+		wr->ur &= uov_perms & POE_R;
+		wr->ux &= uov_perms & POE_X;
+		wr->uw &= uov_perms & POE_W;
+	}
+}
+
 static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 				   struct s1_walk_info *wi,
 				   struct s1_walk_result *wr)
@@ -1037,6 +1087,9 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 	if (!wi->hpd)
 		compute_s1_hierarchical_permissions(vcpu, wi, wr);
 
+	if (wi->poe || wi->e0poe)
+		compute_s1_overlay_permissions(vcpu, wi, wr);
+
 	pan = wi->pan && (wr->ur || wr->uw ||
 			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
 	wr->pw &= !pan;
-- 
2.39.2


