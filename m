Return-Path: <kvm+bounces-28322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C11699753F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBEB0B24E42
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF2A1E32B1;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtVw/Bgs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC911E2319;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500445; cv=none; b=PsRKTiCs2ulYR6kehhBwcoAnNhbAFrI2ephrOW6hBssitwhBNQmBCsn+uYgR4aR38939gxcvdraOYUQR3+bJHmDAkgvAlfPC5uffhWMRibc5I/f8EOPf32ZOFFXpFCzJR6Qwibjt6bsYodIwkQ37yLSge1OVgYfIxTVKrcpiD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500445; c=relaxed/simple;
	bh=g7DUZCp9FUPLiWQYAaREnyMU/Dq1MVZ6wECKH3FQhRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t67u6LPoJdOcLyg9k01ehr5FxFyuaHctce5AGxYAE+euKZ1SiZAM6ORbC5Swft+k9wGF3B533GJZT/gnUyUlehxv46oUDO+anW1FCBCEyylkGNlN6hnou5Zs45q0BTVAYWCNHGmyk+PRkcUSNXxHrRkMGBbO6IwtSHZgXo1gHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtVw/Bgs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7186C4CECC;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500444;
	bh=g7DUZCp9FUPLiWQYAaREnyMU/Dq1MVZ6wECKH3FQhRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtVw/BgsVE6j2WtbLWHA6fIsQcjYzbJ1wMjkZ3QrqNg2PTBQyHj1hbJqNbxY1tJdP
	 KFwKHD1ezySGax0QYuPJ1PZUefbgCzPLgszHYDjXDCb3oZxPAxC7wEbgGPOB3YsGb0
	 jYZESabcebupUn3WIpk5H7+Z+TPV2hlTLnK65qlirvtzWDqlsEG2oU2J1LqQQkb2yg
	 fLuQ+nlTI6idFkubpO7TzEzZSFc99Rz5nyuaGTaeJYp5WpUKghfoxaY1puQhJz90Td
	 uiqAKi/1N46zlan3nstuzLyHJT3/CkGGhXUOKbRl0IFdMuW4EidHp45Ta6eLEltKhl
	 Fvdp4QQYlcz9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvP-001wcY-2I;
	Wed, 09 Oct 2024 20:00:43 +0100
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
Subject: [PATCH v4 12/36] KVM: arm64: Sanitise TCR2_EL2
Date: Wed,  9 Oct 2024 19:59:55 +0100
Message-Id: <20241009190019.3222687-13-maz@kernel.org>
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


