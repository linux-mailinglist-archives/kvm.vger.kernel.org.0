Return-Path: <kvm+bounces-62426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DD6C443BE
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:16:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C2F83B3E8A
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21D3306B00;
	Sun,  9 Nov 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qd0BhEfe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2311305953;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708591; cv=none; b=B+XqpebRLLntGn4U8JcrTGAwUiHwyZ1ZMHD3Mh3g+UsyUj846f1hxKybgOyaqMY9az9zSIRlb75wBts2eXDKoJFr0ngIZAQbn6O7rfAbUEDN5MIt1dn0TiOKmeZj2yBWeQk7k24vksc2ZPf9P30Erb5Sr/ipy7UWNVqVtpKeewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708591; c=relaxed/simple;
	bh=OMxD2PYcmSUFGf3eaSzIGAaXKeRPy9/qh6982gD/Xp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+hHR7JJ3k/AprJBlHlMsc1DPr2Rtwpmohh7Si1WoxCscfsIc2/m39qvDRZHMVd3RFjNCj4Awo6o9zHXrUGOGunf0Qi+3n/5siU2TkTGbllCiy2JBUeHFtTj6dhn50HCEElE+KAzCDEoppnAR7pjxz2He+hqv7LH9klnL9A7hQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qd0BhEfe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D37C16AAE;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708590;
	bh=OMxD2PYcmSUFGf3eaSzIGAaXKeRPy9/qh6982gD/Xp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qd0BhEfegc1iMWoMO05wAYc3i7EJNt+c3LH7xwg8XxeO1ARZh0Oga1o0Ig5NofqUd
	 kl37R4UBMiwYcQ+RszbHR2WjfTUc79faKIx3+HzgZm8+rxsPsAJ5So/KJ+GYwN1v4o
	 jaKTxYuaQ6NFbtka7HEG/FCd5vMIvU74/DgzrFRrn1W8Ds10eHb3lU+Tk2wkztw674
	 rfhC/+VlaE9+TaxCZXYXn/O/Ep9Xa/XQWjTecuKrHCBSJyt4qfm22Q/q0GxlVEcnTZ
	 +YzFirwzm040D3zVr1O/RBYHxbJGFJ++djixiFe7bGGaEGxtVmidrGSwhz7Rm2A7ue
	 oYjidzl6WGz9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91g-00000003exw-29H9;
	Sun, 09 Nov 2025 17:16:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 03/45] irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
Date: Sun,  9 Nov 2025 17:15:37 +0000
Message-ID: <20251109171619.1507205-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It is all good and well to scream about spurious vGIC maintenance
interrupts. It would be even better to output the reason why, which
is already checked, but not printed out.

The unsuspecting kernel tinkerer thanks you.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 032d66dceb8ec..4607f4943b19a 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -411,12 +411,15 @@ static void __exception_irq_entry aic_handle_irq(struct pt_regs *regs)
 	if (is_kernel_in_hyp_mode() &&
 	    (read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EL2_En) &&
 	    read_sysreg_s(SYS_ICH_MISR_EL2) != 0) {
+		u64 val;
+
 		generic_handle_domain_irq(aic_irqc->hw_domain,
 					  AIC_FIQ_HWIRQ(AIC_VGIC_MI));
 
 		if (unlikely((read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EL2_En) &&
-			     read_sysreg_s(SYS_ICH_MISR_EL2))) {
-			pr_err_ratelimited("vGIC IRQ fired and not handled by KVM, disabling.\n");
+			     (val = read_sysreg_s(SYS_ICH_MISR_EL2)))) {
+			pr_err_ratelimited("vGIC IRQ fired and not handled by KVM (MISR=%llx), disabling.\n",
+					   val);
 			sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EL2_En, 0);
 		}
 	}
-- 
2.47.3


