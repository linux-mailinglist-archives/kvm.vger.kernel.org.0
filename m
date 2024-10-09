Return-Path: <kvm+bounces-28343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C82F997553
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C453285C96
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDDA1E9060;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrcNGcWd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6DC1E7C35;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500449; cv=none; b=ZV1MEiKffkoVCjBQ1tq3asgkhyph/7JIOyE5okEINogr7re/uM/2LPqLGyY3T9lLZixuVck6mBkzUBONQamBiVVkyCfqgQZENgbS+pQzmqTvbYUzY/X//K6rgIxtcMTlUYXnNUn4z+E5ekykbsQHgb58m+3eTt9xP4fkyc5WVBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500449; c=relaxed/simple;
	bh=+xEIeihYDTLNgHX0Kx0PlmjayYOTWJBinDs8rqkaSOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AanTkMyNRCWgU3fKxIVgq+nG0Pp0mN7pQraJBLCtColRu7U/S//rGJhuwDE6lkSMgzS7ZqiWfMBQy/H4aaL0xK2eInWo7OyB7zS6bjTmJad38qpXMDxx2faxnlFa+W2L+E7axSPtyM6THhTafezG5ZbdR3m9FlqaeK5plR7O7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrcNGcWd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE4C4CECE;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500449;
	bh=+xEIeihYDTLNgHX0Kx0PlmjayYOTWJBinDs8rqkaSOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrcNGcWdZDD1eN+N/Ca32CZTHIvNhfl0P9eCoYY+4BiGxuhiSTKOSRmClSCUbvgVF
	 2tv9EFaUhFShMOLNQ2a+WnsHti8CwsCdfriyjqtYrnLWHMhzPmez4q9YKWDdW3dfc+
	 q+thHR+2hlBoot3mVtzclVoX0/xmpqoGDV6gmWCCi5Z1a84hMgYau00AxsYyPko0z0
	 KorZhtkvryyvhKGqHo+2nbvOQtDU0MdZXaFIQOvOSAHEJf0RAXhHwm3uE8D4ik9rp+
	 MIQmimm2jnVghhMvAGRrvIbi/JfHbTLDfMO3zL8TCfWfD1jv6yDwGo5ZnF7qXeqUxK
	 ft4j8ExRHCNlw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvT-001wcY-Og;
	Wed, 09 Oct 2024 20:00:47 +0100
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
Subject: [PATCH v4 33/36] KVM: arm64: Disable hierarchical permissions when POE is enabled
Date: Wed,  9 Oct 2024 20:00:16 +0100
Message-Id: <20241009190019.3222687-34-maz@kernel.org>
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

The hierarchical permissions must be disabled when POE is enabled
in the translation regime used for a given table walk.

We store the two enable bits in the s1_walk_info structure so that
they can be retrieved down the line, as they will be useful.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 4921284eeedff..301399f17983f 100644
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
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+		wi->poe = wi->e0poe = false;
+		return;
+	}
+
+	switch (wi->regime) {
+	case TR_EL2:
+	case TR_EL20:
+		val = vcpu_read_sys_reg(vcpu, TCR2_EL2);
+		wi->poe = val & TCR2_EL2_POE;
+		wi->e0poe = val & TCR2_EL2_E0POE;
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


