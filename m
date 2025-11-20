Return-Path: <kvm+bounces-63918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 57897C75B4E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6A1C84EBB4A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A716E3644C3;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mz9J7lWA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64041E98EF;
	Thu, 20 Nov 2025 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659556; cv=none; b=CsRJ83nted733XgKY/80WPuYZb6Y3N27ZUkJTD8ozcgbNhoiEvcR6XDVBGegnmYaAALXB/sVCJaMWNDaB/08+pLCn3leqXU7UjWfvafOi6pQYEJtFuxWQao8hTdS9jApGa8wG11Mc53+xoOlbdFh3YoLsKYdgCsFoTr7nDkv2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659556; c=relaxed/simple;
	bh=37Xd3+8ZfcOqWQuQNM+hELSmr/Jv6uq4o8vA91D2Anc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VseGvREZgVpJNPBgK0D3UW69lb2MqNK3e7CytKm/q2c4O0/YDdWPRPS9pJMxLqs/1no/W0KDuaonwjOnZgxz6hTiOBB/uSlyV2Hr+O42U7DLugu7Ssbj6/oqYTX6iM5LZ44mrPw0HubwsSJ/IvJ/Hq9ux0ysJQxFB4y+QEk+jeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mz9J7lWA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0C0C116C6;
	Thu, 20 Nov 2025 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659556;
	bh=37Xd3+8ZfcOqWQuQNM+hELSmr/Jv6uq4o8vA91D2Anc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz9J7lWA5gy2GR5AA+RU6MpWech/czmilitXTmkXKuEgvTan/PJwrtip+KyVTYBYZ
	 A3nUS5PktEKMffTgP+ElfnSHai/mr5RrxLsPawWWwZxyTnR011UwJXmTd55ePmCzYm
	 WE6MRQyTSK4G7pEh1m8/0pc0Xp+t4QLPtqpHUyelPQRziNkmrsY8IZALEweoux21Vy
	 6KddcRN/U/Rj1B4Ko/3aaWWU8PNY5O7zq1MJ55gPr6fovs6BMgi30zrOF7Ih31BVyD
	 LNt1O6Dbiqnkmmah3nxlZNtKCB0bTLpScfzBGYAWOptELoOk3GxFfLfy/DSI3Pe1ch
	 qyiE4BF1S42eg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pq-00000006y6g-1wrY;
	Thu, 20 Nov 2025 17:25:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 03/49] irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
Date: Thu, 20 Nov 2025 17:24:53 +0000
Message-ID: <20251120172540.2267180-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It is all good and well to scream about spurious vGIC maintenance
interrupts. It would be even better to output the reason why, which
is already checked, but not printed out.

The unsuspecting kernel tinkerer thanks you.

Tested-by: Fuad Tabba <tabba@google.com>
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


