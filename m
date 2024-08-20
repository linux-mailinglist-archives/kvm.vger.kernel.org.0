Return-Path: <kvm+bounces-24619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA719584CF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6836F1C24234
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3342318FC7B;
	Tue, 20 Aug 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNdYx8ae"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C13318F2D9;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150289; cv=none; b=skJLaUtPx1FEVaNmo8UbCYv/U0osJNsF1LYi17ka7D29Iv5XQ9sP/a3P+4g9nqjdUmBKfwLHE0QRK6I3xPR80v7fPA+xtIUlHObDo/qBD6dsUHho8m7NpRwxTE5WAfkIJXyrfKmDwcNUnvwczYnpsVZr/Z6M21pOUOV2ucBewEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150289; c=relaxed/simple;
	bh=k5pYh1Yp0jxWFeMrnF7ay2rjkHNJ1NpYhUlOrVS5zOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GmxhdY6uXPoGOGBPeFOHE2zWU0xHTPrnockTQBA5koIyn8UMcVxFgLw58FBH4CTS1RTvFV9FdSpirzsWOIobMHlV1OZ1MEQhcUMBqnxt97lFuRJgoFdcSF8m9EZi52/o5IIPbYFZcZn8kWXe5R6lL7QTECGakW7h+7WVSmi7nrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNdYx8ae; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD20BC4AF15;
	Tue, 20 Aug 2024 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150288;
	bh=k5pYh1Yp0jxWFeMrnF7ay2rjkHNJ1NpYhUlOrVS5zOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNdYx8ae1FeS9wBMHFq80Bad1BmdSagcDX0UaMwSqUysZWHg3E+RkkgG7d1qud6Mx
	 BeTjfVMVK/yD0QlfwTWCoer1YYLnT+R9hUkmPDtp073OMRVRGKVGbxQ7fZqj97yk+/
	 MzwHFZOmRwsmWG6ubKtEtPuFXSh8omKEKRKd1DJcUfyjT7i0nIA+7trhkGM9jI68ad
	 HxNp0PYt5Nl3XSyypQd0wBJKERFUF76+f0OYwQ7aAHII/uTUFxR4mua8d0216TNnAx
	 ew373uh3YvvN6cBLgpIpj/446EeajDWBzIepCzCQCl68yTAmHdGNl2KYqoEknPr5lu
	 fvPE3jDRL74nw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFb-005Ea3-77;
	Tue, 20 Aug 2024 11:38:07 +0100
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v4 15/18] KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
Date: Tue, 20 Aug 2024 11:37:53 +0100
Message-Id: <20240820103756.3545976-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Ensure that SCTLR_EL1.EPAN is RES0 when FEAT_PAN3 isn't supported.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9c8573493d80..133cc2f9530d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1178,6 +1178,14 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
+
+	/* SCTLR_EL1 */
+	res0 = SCTLR_EL1_RES0;
+	res1 = SCTLR_EL1_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
+		res0 |= SCTLR_EL1_EPAN;
+	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
+
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.39.2


