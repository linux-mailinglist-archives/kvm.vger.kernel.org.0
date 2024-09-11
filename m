Return-Path: <kvm+bounces-26523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C46D99754B2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F2661F22385
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961431AAE06;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eniJJ7W1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ECF1A4B6E;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062720; cv=none; b=qeX+WVKvBJhFyTn5+VlRdXDX+zaiKrH7LMespN5EAVzf5IrpcCZhBQYYfCt1kCg1L9BqQ3dVA8ru6XIwJfPFkxo1ifg219OcQO+17ySphMDiLBOiVqxAlDMqlkavD09l/WM0Bj+oZs+q+3tIlTI/sxjBjwbssljMyf4IMMqg2Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062720; c=relaxed/simple;
	bh=j3MRUKRWtRAJZkC8zV5u5etxXLxKO0gKd2ISADHupEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWUHqYi4KbLWxSEIfsRSdKd/AC6Ffo6E7OpkfZVayI9Cm/i/8wRgqgxY/MTVy92LQFBIExd7Q0qvwanykf1bd7EELQOEoV0KIukDmbXdf4RGuXUsij1G6J6qC/agNsyiHDDC4RnbrDpeGEIk/gGkK0n0h4CnpQs+ayfc2BO+hkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eniJJ7W1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60018C4CECD;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062720;
	bh=j3MRUKRWtRAJZkC8zV5u5etxXLxKO0gKd2ISADHupEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eniJJ7W16J8g5p6RnWco1+fySP0/AJ1NA31DCG7Ns8p+mmh8h6tIkgntxt/SI3/uu
	 adc7GBDyB0WgXVm4Dg53TV9zWXi76X4bHk5VwPg5kUWcDvWDRVJWfHIsStoGrEx9BJ
	 Uz31Os7sV1clEVsW9u8PBpHNGOBU6vS0gXkzp8KyuIBOdCtGPlKwy56HPsvO92xLxc
	 8j5SMVKL15zPd+RCqCspgJkqatnaDi5KfGFXcttbUDSAFi4Ig9qjmHkyGiK5s2eWjj
	 mjfX5hGV0WuiO8aJW4dvo6+GznXOPAnZIZUf6RC4GDtGCb7CIQRTCtEdRztHKz9WdQ
	 j7dS/kDyPQ01w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlG-00C7tL-Fv;
	Wed, 11 Sep 2024 14:51:58 +0100
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
Subject: [PATCH v3 11/24] KVM: arm64: Sanitise TCR2_EL2
Date: Wed, 11 Sep 2024 14:51:38 +0100
Message-Id: <20240911135151.401193-12-maz@kernel.org>
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

TCR2_EL2 is a bag of control bits, all of which are only valid if
certain features are present, and RES0 otherwise.

Describe these constraints and register them with the masking
infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fd9ddd0d31400..a566efd6ca4f2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1183,6 +1183,28 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= ~(res0 | res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
 
+	/* TCR2_EL2 */
+	res0 = TCR2_EL2_RES0;
+	res1 = TCR2_EL2_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
+		res0 |= (TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1 | TCR2_EL2_D128);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, MEC, IMP))
+		res0 |= TCR2_EL2_AMEC1 | TCR2_EL2_AMEC0;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT))
+		res0 |= TCR2_EL2_HAFT;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
+		res0 |= TCR2_EL2_PTTWI | TCR2_EL2_PnCH;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
+		res0 |= TCR2_EL2_AIE;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		res0 |= TCR2_EL2_PIE;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
+		res0 |= (TCR2_EL2_E0POE | TCR2_EL2_D128 |
+			 TCR2_EL2_AMEC1 | TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1);
+	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
+
 	/* SCTLR_EL1 */
 	res0 = SCTLR_EL1_RES0;
 	res1 = SCTLR_EL1_RES1;
-- 
2.39.2


