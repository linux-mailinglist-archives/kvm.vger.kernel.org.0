Return-Path: <kvm+bounces-29534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AD19ACDE9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6317C283A33
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8118D202F91;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6yEPskE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A61D0403;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695234; cv=none; b=Bugo1xtROzDI4i6agMEoU5Z2qh4BUJNc/Qb/j7uwfNGEcyQgL4AOFi4Y+77tHFRQkiDsx1sgOFbZ9zNYLbF6i7+rKxzaQzaeQaF52a2JV5J75wrZzBch2F07aJW0QPfXzs2v6nQqmhiuUeEZw11awhiTQJDtGDFkp32kcFvNQ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695234; c=relaxed/simple;
	bh=g7DUZCp9FUPLiWQYAaREnyMU/Dq1MVZ6wECKH3FQhRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z+kAilXuzuWkhe+VMrBxq1nnf7rnTuQOuNd7EBDUGn/BXweMGN44wHXVtKkRBUuANCNr1QGIDf9Ic4a17ncIKaPgCtRrFxWCw+13sZ3IOJ39armSGDO09XyNBJw973o4Q7U1wLI4IaUjUnNhzqg0/MAPUVAmfXtD2S7ht+mbbD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6yEPskE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB4C4CEE8;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695233;
	bh=g7DUZCp9FUPLiWQYAaREnyMU/Dq1MVZ6wECKH3FQhRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6yEPskE9dwxxlfWgBKHI5pX/jGjm+OfbGojfVuqn5u1XWkGwxwBeuQFXM6liRBfH
	 1vSCjXoCvbSupPps3Orns8iHVKPExURxc3YZ9TIe0idMg+1r2eski9WsJdYBDZMf9t
	 wRZ2scPxF+J6rCCQZpj1UH+1jeDgakIM4yHXhQqZXwH4lkURVDChwcqMm+CzMOPbq5
	 oH5a57KngipTL1zT+Wcef7zHqzC8vq4SUa4AMv3iUYkmRC1/toD9alSXUdmxLrj9Jz
	 4kbRxtK1npqdzTf8rwlyWm04bi3KuVsYedZuOroEAY+K62C/geI6gTGNWdbrE1h7/E
	 sB02DIFiNSzgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckB-0068vz-VB;
	Wed, 23 Oct 2024 15:53:52 +0100
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
Subject: [PATCH v5 12/37] KVM: arm64: Sanitise TCR2_EL2
Date: Wed, 23 Oct 2024 15:53:20 +0100
Message-Id: <20241023145345.1613824-13-maz@kernel.org>
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

TCR2_EL2 is a bag of control bits, all of which are only valid if
certain features are present, and RES0 otherwise.

Describe these constraints and register them with the masking
infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b20b3bfb9caec..b4b3ec88399b3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1179,6 +1179,28 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
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


