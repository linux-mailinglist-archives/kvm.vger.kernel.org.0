Return-Path: <kvm+bounces-28330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 828C7997546
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A45AF1C222EF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5601E47C9;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="We14Ac1B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84781E3DD5;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500446; cv=none; b=gYcAez3+Faa977MCSCl38kIRgleLwvP4vr55nnXeLWewBi56Zn8JRR6o/RGO64xRmmMWlLVdhTxlMiMFEK3OiYaPMEdxTBBRViEF0kt+8oTzamQWk/9XaL/DAxRNPPL1LYEvUGEpDIaND8+uM2dBWBn+tf1LcL8Xa9Kq9CDXqVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500446; c=relaxed/simple;
	bh=t5+ESdUFFUdCGyZIUjbqtV8WtvkmdsB4SAcVKjsOytc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wv7jssKMy/p4wZgRB1QBvUmN0UTfsHKE5SuzaIc1P5fOSnxLAc5wZH1WAHgHlBq1vorFU06rhuIJ2ms97/5xgD17oXYAgQkPBg0r5FUoq05rtpDdSW7yu0tz/k4Eh3Mokam3CPfMkKyIvYqXPCgfCB1RfSY02HcBP7OIpH3av08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=We14Ac1B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD71C4CEE5;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500446;
	bh=t5+ESdUFFUdCGyZIUjbqtV8WtvkmdsB4SAcVKjsOytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We14Ac1BBvnduVnRmzzSPQaa9LIwcKdDZWuY9Gw6S7+gYadlW4GEob73zRLmagQ2Z
	 SztNmF4SePXXf2FDjighHYO+RSpCTPZgM4oHUx76cM20atLSImk5s/5OzXy7nHpJzp
	 lXoCzxs4KR+OphFwEptm2LUx/Fei/nTV8PI85kdHgzkWwjXlxrRUEfCCzQq5yvXpkp
	 A50li2UxWYVn5LSO7N3xEyPLQN1wMv2TCef5rEabecftNKNP/W5J9+t+iuYqHK4JNA
	 Dcm5wDI6hNj6qH/rda40n7ZJeePXG31GcNLMoJgwjuZxCOyfAFvKB7eKqYGTGJOzBR
	 a6GGvmcscwWMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvQ-001wcY-Qj;
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
Subject: [PATCH v4 20/36] KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
Date: Wed,  9 Oct 2024 20:00:03 +0100
Message-Id: <20241009190019.3222687-21-maz@kernel.org>
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


