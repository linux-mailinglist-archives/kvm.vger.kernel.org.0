Return-Path: <kvm+bounces-29557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A499ACE01
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B73CF1C237CD
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FDF20A5F1;
	Wed, 23 Oct 2024 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubi+QkmL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5902209F45;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695238; cv=none; b=mgLcxHsvIjmWRd9UEhqtU5EySPu7Wno9ccFmRo4K0UkKIcmio5uzxNS30i12a2GgpZUxmNZz40mi7/KxiXnK06ZODNMGZ2nAUi2QjawLqVS51ptdroDpJq6tTXYm+we2gUVJ3k/PYjPewDn+DI6MwVpUCgeqFa/pDMPllE2oF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695238; c=relaxed/simple;
	bh=l2iJmram/7F50cBafm2LbS3iBb2YLddO4eliTdm5KZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bCoQlK0S4Ypbf4vISSVSWsDMEpLQV7jQBNcAXzq+JGeeNUFXsHRCPV7D3AK58EjX6eJNgufaWDXRVP/92AV9cXgl58bX7RPvNTYT4gTZ7eoVrNv/O122ydpi4lTL0OUcoca5N+Q6IMvSVRsputTWvjIS6AH0+wBF1W7Wb/FwtB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubi+QkmL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF0AC4CEE5;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695238;
	bh=l2iJmram/7F50cBafm2LbS3iBb2YLddO4eliTdm5KZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubi+QkmLV6Y2ngbH2kLUsqgJaeH9GtkJsDzRYdyfF0IAIBdpBNfkcSyI6tbsvYxqO
	 0cMqWx+M41WI0IBm6w+Xt/fAL3nxRIcLehQNIiU9NeeiM/Ddyn9oQyagZfRTeHfwnc
	 Yjn/3A1KwR0iAvrOxoovj6krGJOJ+20up6l+SQoVuHbdeIaNqvQ6rtS/YIuUodw7T0
	 77JpjU43a8F/X4w0zryjxn9Nv6w+U9TbNFUfpgKGfuP5m5EqrqzfTb2S53JXAophWJ
	 pY0iWgjT5ZDlVVj7tZ9YwGdBIrelaceZiy5xjrSDOdfHTl99iUnXxBOEREybOg5OUO
	 NK7GCiTj2vApQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckG-0068vz-LQ;
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
Subject: [PATCH v5 34/37] KVM: arm64: Disable hierarchical permissions when POE is enabled
Date: Wed, 23 Oct 2024 15:53:42 +0100
Message-Id: <20241023145345.1613824-35-maz@kernel.org>
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

The hierarchical permissions must be disabled when POE is enabled
in the translation regime used for a given table walk.

We store the two enable bits in the s1_walk_info structure so that
they can be retrieved down the line, as they will be useful.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index ef1643faedeb4..8d1dc6327ec5b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -24,6 +24,8 @@ struct s1_walk_info {
 	unsigned int		txsz;
 	int 	     		sl;
 	bool	     		hpd;
+	bool			e0poe;
+	bool			poe;
 	bool	     		be;
 	bool	     		s2;
 };
@@ -110,6 +112,34 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	}
 }
 
+static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
+{
+	u64 val;
+
+	if (!kvm_has_s1poe(vcpu->kvm)) {
+		wi->poe = wi->e0poe = false;
+		return;
+	}
+
+	switch (wi->regime) {
+	case TR_EL2:
+	case TR_EL20:
+		val = vcpu_read_sys_reg(vcpu, TCR2_EL2);
+		wi->poe = val & TCR2_EL2_POE;
+		wi->e0poe = (wi->regime == TR_EL20) && (val & TCR2_EL2_E0POE);
+		break;
+	case TR_EL10:
+		if (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) {
+			wi->poe = wi->e0poe = false;
+			return;
+		}
+
+		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
+		wi->poe = val & TCR2_EL1x_POE;
+		wi->e0poe = val & TCR2_EL1x_E0POE;
+	}
+}
+
 static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
@@ -206,6 +236,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 	/* R_JHSVW */
 	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
 
+	/* Do we have POE? */
+	compute_s1poe(vcpu, wi);
+
+	/* R_BVXDG */
+	wi->hpd |= (wi->poe || wi->e0poe);
+
 	/* Someone was silly enough to encode TG0/TG1 differently */
 	if (va55) {
 		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
-- 
2.39.2


