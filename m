Return-Path: <kvm+bounces-25763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A9A96A2FE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 179E3B26E62
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF21418BC3B;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqEPQbKi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E044618B48E;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377923; cv=none; b=TSOXypIjdoUbKYxOYBt2XxrIB7IaW/cJLSXSp6ibxNfK2MkkRs2RBb/PaCuOsl6H3xCpe+zQ38gvPFqYQKogIFF5dBy/r9w2f1DKsSro290SAKo3IFuy1N5pXNCVbGYhlwD93zRladLZsBZSMCIjwC879F+yy8smlPWADnvSKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377923; c=relaxed/simple;
	bh=pkgmJHcizaayhEd8ulbsug6NNeEqXrEZOAYWnTYo7WI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZHQP3tnFi6CCBxUQmS+8qp3/eEfy/iCz41AMOAHAGrnsln9b6DWQtql4sLqVjQtJ2c1vXMX0JBvl8jWv8qNu/uBU84e1+a3b3KDy/2IZNByyvUQLPjhogxigHfsTrrTENjBOp/o3ciyPWDR3/WQOrYY+u0UAtdSie/Ygmc6jPkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqEPQbKi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C2FC4CEC6;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377922;
	bh=pkgmJHcizaayhEd8ulbsug6NNeEqXrEZOAYWnTYo7WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqEPQbKiTXtXY00FiVzQObkuMfds8kZVTvJiqA749FUSy93G7YkE/Rxlbs8CxpPrt
	 soLipd7nKxdGWa7j3B1J8D7Qdf3auUuDxdHwhxmnRYiOfx9N4XALeORQ3KshonijlJ
	 +H/h1YtJ+1X17uFp6K7k2gjMzx5QQ4qxs/6a9ORQTCM1csD6uO7E8Ld475Utuk2P8M
	 4R+SK9JdsoXoX1o/mdmbe8RQ/l0mzqJriNPL70NN0pdnFO+FiDp8ZnKk6YzB3cM+lB
	 HHEFosAzMdC0UmcRSCjrSV0BNdxmU4cnFEb9qCwLAZrWuuJiG7xncm0nkK7jvwAJgV
	 vGeIfXh2hdwNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc9-009Hr9-2j;
	Tue, 03 Sep 2024 16:38:41 +0100
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
Subject: [PATCH v2 12/16] KVM: arm64: Implement AT S1PIE support
Date: Tue,  3 Sep 2024 16:38:30 +0100
Message-Id: <20240903153834.1909472-13-maz@kernel.org>
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

It doesn't take much effort to imple,emt S1PIE support in AT.
This is only a matter of using the AArch64.S1IndirectBasePermissions()
encodings for the permission, ignoring GCS which has no impact on AT,
and enforce FEAT_PAN3 being enabled as this is a requirement of
FEAT_S1PIE.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 136 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 135 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 68f5b89598ec..bd7e1b32b049 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -736,6 +736,23 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 	return par;
 }
 
+static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		return false;
+
+	switch (regime) {
+	case TR_EL2:
+	case TR_EL20:
+		return __vcpu_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
+	case TR_EL10:
+		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
+			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
+	default:
+		BUG();
+	}
+}
+
 static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 {
 	u64 sctlr;
@@ -743,6 +760,9 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
 		return false;
 
+	if (s1pie_enabled(vcpu, regime))
+		return true;
+
 	if (regime == TR_EL10)
 		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	else
@@ -826,12 +846,126 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
 	}
 }
 
+#define pi_idx(v, r, i)	((__vcpu_sys_reg((v), (r)) >> ((i) * 4)) & 0xf)
+
+#define set_priv_perms(p, r, w, x)	\
+	do {				\
+		(p)->pr = (r);		\
+		(p)->pw = (w);		\
+		(p)->px = (x);		\
+	} while (0)
+
+#define set_unpriv_perms(p, r, w, x)	\
+	do {				\
+		(p)->ur = (r);		\
+		(p)->uw = (w);		\
+		(p)->ux = (x);		\
+	} while (0)
+
+/* Similar to AArch64.S1IndirectBasePermissions(), without GCS  */
+#define set_perms(w, p, ip)						\
+	do {								\
+		switch ((ip)) {						\
+		case 0b0000:						\
+			set_ ## w ## _perms((p), false, false, false);	\
+			break;						\
+		case 0b0001:						\
+			set_ ## w ## _perms((p), true , false, false);	\
+			break;						\
+		case 0b0010:						\
+			set_ ## w ## _perms((p), false, false, true );	\
+			break;						\
+		case 0b0011:						\
+			set_ ## w ## _perms((p), true , false, true );	\
+			break;						\
+		case 0b0100:						\
+			set_ ## w ## _perms((p), false, false, false);	\
+			break;						\
+		case 0b0101:						\
+			set_ ## w ## _perms((p), true , true , false);	\
+			break;						\
+		case 0b0110:						\
+			set_ ## w ## _perms((p), true , true , true );	\
+			break;						\
+		case 0b0111:						\
+			set_ ## w ## _perms((p), true , true , true );	\
+			break;						\
+		case 0b1000:						\
+			set_ ## w ## _perms((p), true , false, false);	\
+			break;						\
+		case 0b1001:						\
+			set_ ## w ## _perms((p), true , false, false);	\
+			break;						\
+		case 0b1010:						\
+			set_ ## w ## _perms((p), true , false, true );	\
+			break;						\
+		case 0b1011:						\
+			set_ ## w ## _perms((p), false, false, false);	\
+			break;						\
+		case 0b1100:						\
+			set_ ## w ## _perms((p), true , true , false);	\
+			break;						\
+		case 0b1101:						\
+			set_ ## w ## _perms((p), false, false, false);	\
+			break;						\
+		case 0b1110:						\
+			set_ ## w ## _perms((p), true , true , true );	\
+			break;						\
+		case 0b1111:						\
+			set_ ## w ## _perms((p), false, false, false);	\
+			break;						\
+		}							\
+	} while (0)
+
+static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
+					    struct s1_walk_info *wi,
+					    struct s1_walk_result *wr,
+					    struct s1_perms *s1p)
+{
+	u8 up, pp, idx;
+
+	idx = (FIELD_GET(GENMASK(54, 53), wr->desc) << 2	|
+	       FIELD_GET(BIT(51), wr->desc) << 1		|
+	       FIELD_GET(BIT(6), wr->desc));
+
+	switch (wi->regime) {
+	case TR_EL10:
+		pp = pi_idx(vcpu, PIR_EL1, idx);
+		up = pi_idx(vcpu, PIRE0_EL1, idx);
+		break;
+	case TR_EL20:
+		pp = pi_idx(vcpu, PIR_EL2, idx);
+		up = pi_idx(vcpu, PIRE0_EL2, idx);
+		break;
+	case TR_EL2:
+		pp = pi_idx(vcpu, PIR_EL2, idx);
+		up = 0;
+		break;
+	}
+
+	set_perms(priv, s1p, pp);
+
+	if (wi->regime != TR_EL2)
+		set_perms(unpriv, s1p, up);
+	else
+		set_unpriv_perms(s1p, false, false, false);
+
+	if (s1p->px && s1p->uw) {
+		set_priv_perms(s1p, false, false, false);
+		set_unpriv_perms(s1p, false, false, false);
+	}
+}
+
 static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
 				   struct s1_walk_info *wi,
 				   struct s1_walk_result *wr,
 				   struct s1_perms *s1p)
 {
-	compute_s1_direct_permissions(vcpu, wi, wr, s1p);
+	if (!s1pie_enabled(vcpu, wi->regime))
+		compute_s1_direct_permissions(vcpu, wi, wr, s1p);
+	else
+		compute_s1_indirect_permissions(vcpu, wi, wr, s1p);
+
 	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
 
 	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
-- 
2.39.2


