Return-Path: <kvm+bounces-28347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A4E997557
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14CF51F22152
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6AF1E9078;
	Wed,  9 Oct 2024 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SF5dQxfz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDA51E8847;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500450; cv=none; b=VBWJ+LvlSohZU3gqs0rS6l0cVQue+MinzkrL7Nt89mErXH9Xsyg8Kmdko/lNfex0os4CXoOOmHZEAjRKpPEAvx6ZIOhjkihYQ6C7UiYrDWCHg+uXAOVnSqacuCLMlbff9OsLCeo0xphYdZAZ1Tk268lsy85RgaNEnpLvwrXw5x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500450; c=relaxed/simple;
	bh=QpEhq3ybWToqA/q2mXhj4+m/zIZ+OWYJ/Jj2ev2ZLPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AyIKR+UoQJ63egwoe7BixyIONH3LzZZRMoa5QbMyJwSRSFHf5NNEx+qyhHE+hyD+L2cx570ua4cl0BAJVYbyCmfVopcaLm5GNNzXLko3fAIOpv+Y5e1Kq1R+Xasqodklb0G8Q5E1bzl1kGMRUfmoXT2ctmvwsdsoa/8MkRegu1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SF5dQxfz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEE2C4CECE;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500450;
	bh=QpEhq3ybWToqA/q2mXhj4+m/zIZ+OWYJ/Jj2ev2ZLPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF5dQxfz25WRyEC1QuEabOJJwS1YTwE9tFgMoFaNyDF38GQ01jjZIm5JP5xYOnmQH
	 Jar6AGJM+tHfrBFwP1kRXuzPwnAlT2h35rN1CSi0CbHFG/dzSDcasskLLZmMrNZxna
	 FIUfsP3RB7mG5PvEHumPfR0FETR+ydrRAosxY3cMm+p35Ewp6opXWA8J9QiR7rqy/r
	 i7FmIGHybqFiBS+2+eJFw6aJw02XXcl6DLfDNHtwkJDOKZ+SzxydMZlNMCcEH8UQ1P
	 5a1oN6dkfS2lICMxaKdPtltjKqMnabWTtClsiHkndZJYpw4mK20s6Ow6M30y9Oo+I1
	 22KGLuRatkTOg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvU-001wcY-CA;
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
Subject: [PATCH v4 36/36] KVM: arm64: Handle WXN attribute
Date: Wed,  9 Oct 2024 20:00:19 +0100
Message-Id: <20241009190019.3222687-37-maz@kernel.org>
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
index 415f668ab2cd6..b8f3eb8d0956d 100644
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


