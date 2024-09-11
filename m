Return-Path: <kvm+bounces-26531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2299754BB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C79B2823BF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A32F1AC45E;
	Wed, 11 Sep 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWEHFIeT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EF81AB6FB;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062722; cv=none; b=IDdFpD0o+gS3EV9WCVZsCp7kC9ijMQNo6VJn+QG8rpmv07HsCDthzO9x1AUSvMIFA6s915bJgQVh3YEsIbb/XhBHsWcpQOyWOR2I9uNR4BOqCEcqLoa4bS2TIbyn7GicTe08sQhftMcAoqgQQZy2FD9at2QPxmoZ+JdIjSlvQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062722; c=relaxed/simple;
	bh=qQWDVBIloxoZhqiqEm32EkEZjmCLRGOgrGKelqihYxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T8M4Juj/xZWYjxA5d6LRVxCGh0CYImlCaPG1sGC3BsumWDAdGNzXE6iKEqYsIh0Kj9WJ4IeM9r+9zeKygz1ZjOtdpkilq2Izc7wcspzIPES5mTF/GVL17Wmp3/EAtZUrAdi5MMQD8G5GORc9ihBNX3HxkacuySpyI28n869z7eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWEHFIeT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC2AC4CEC0;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062722;
	bh=qQWDVBIloxoZhqiqEm32EkEZjmCLRGOgrGKelqihYxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWEHFIeTZVpcdZ5PfePhcu3QQG0xbvGz0rGYhJ3HfvAjyqONnRF6C4etTlWnZtHlb
	 PcsYtGyEAY3bcPawGpW6G3REuLq5IhbQnenGOFZ2Eit07XRtGEhq5bVSqqRU0xIZdH
	 HrFB9xx1hAVzmzSXc7k9qIMBU551BP3y//+Dw7VPpltqac6qRP6izj/zbzkQPV6Y4a
	 4o0NCgUE8J/3YOYlDeHUKGxTcdKrc2gUXeIX36aZBDSaAOxnlrXxyuSHy5WrhMVywD
	 jiFPP6GCR/4hPD1VmWNPO2CmwhbkkqlW+Knsqw+j+mAHoMe82lAs9nBwN4gZ3cloAJ
	 pv0NBlN0RzoUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlI-00C7tL-Cs;
	Wed, 11 Sep 2024 14:52:00 +0100
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
Subject: [PATCH v3 20/24] KVM: arm64: Implement AT S1PIE support
Date: Wed, 11 Sep 2024 14:51:47 +0100
Message-Id: <20240911135151.401193-21-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
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
 arch/arm64/kvm/at.c | 119 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9a922054d76cf..8a5e1c4682619 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -779,6 +779,9 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
 		return false;
 
+	if (s1pie_enabled(vcpu, regime))
+		return true;
+
 	if (regime == TR_EL10)
 		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	else
@@ -862,12 +865,126 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
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


