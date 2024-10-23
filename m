Return-Path: <kvm+bounces-29542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 159DF9ACDF1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4500D1C241F7
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6902205AD5;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efj1SHc8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F39202F69;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695235; cv=none; b=uSBTGMuvmYjSVQW+IItxaUBfSACZMZ2cmb+yQF7XFfIAdFgsJ9NdyOsULxzPhR64zCrTnjVsZV4+6yweZV9Ke4uMGOXi+AwM6fQg+3kjb8jCmZPQXA0Q494w1uy7k62DLgudfcpaFTFSTs9m9M+VPdewSmimZwizH2JLdAvTcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695235; c=relaxed/simple;
	bh=t5+ESdUFFUdCGyZIUjbqtV8WtvkmdsB4SAcVKjsOytc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=beyMscSqJ5fDJF53LblcZHvJpLobpw3NEs7ldjllSN2KGlhqBzTldR8EBA13xwc1kl+lq/x0Qpso8wWI8I7b7bd3UygXW51w0TWFkjojRR1HXu5MWh3r6fvu7lhxjZyhp2ETki4PIt4q4HWt2JYI3qp5GE1sUYtrDFrNkJMF6nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efj1SHc8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5000CC4CEE7;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695235;
	bh=t5+ESdUFFUdCGyZIUjbqtV8WtvkmdsB4SAcVKjsOytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efj1SHc8LKdko7sK5Ys9C2HM50c9jxprEC8yM+mPMpB0PnM8b1TdIUvcUz4Q9hJ8P
	 8lfFE8Rh7F1n6yxOX4wfpa4STjaaT5JTbCy/A7Sa09zdUck+EZTd/xAayheIJuE7bA
	 9l8Jm0mS6qFclkH6nf3p0tQqSnNxsOFcyEoQiw5YlvZezTAYigOEPdC80A3JnW/in7
	 KjVdbL7mJ+A+GFPohN2QVAPO3ApkPtOUzh+WGm/ZGVDF3ErsWR+OvxkUuXlmnuwt3g
	 Yx3B7ZLFnLYDGADEHnn+7+/kRt0AvGZolxTVCOYEirF0wpoNCZ4LWqNQsJA96GJoJ3
	 nbixPLD/0f1+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckD-0068vz-Jz;
	Wed, 23 Oct 2024 15:53:53 +0100
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
Subject: [PATCH v5 20/37] KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
Date: Wed, 23 Oct 2024 15:53:28 +0100
Message-Id: <20241023145345.1613824-21-maz@kernel.org>
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

S1PIE implicitly disables hierarchical permissions, as specified in
R_JHSVW, by making TCR_ELx.HPDn RES1.

Add a predicate for S1PIE being enabled for a given translation regime,
and emulate this behaviour by forcing the hpd field to true if S1PIE
is enabled for that translation regime.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index adcfce3f67f03..f5bd750288ff5 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -93,6 +93,23 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 	}
 }
 
+static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		return false;
+
+	switch (regime) {
+	case TR_EL2:
+	case TR_EL20:
+		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
+	case TR_EL10:
+		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
+			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
+	default:
+		BUG();
+	}
+}
+
 static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
@@ -186,6 +203,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 		    (va55 ?
 		     FIELD_GET(TCR_HPD1, tcr) :
 		     FIELD_GET(TCR_HPD0, tcr)));
+	/* R_JHSVW */
+	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
 
 	/* Someone was silly enough to encode TG0/TG1 differently */
 	if (va55) {
-- 
2.39.2


