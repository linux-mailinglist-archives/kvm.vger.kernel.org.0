Return-Path: <kvm+bounces-61880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF40C2D4FC
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F01E9189CC86
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0C53254AC;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZA7rPNkt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72532255D;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188931; cv=none; b=TbmeuiNjrhVOemanJ4x01RN/z7FiKY7nXU//8Ve70TrmQCR58nGcXV6GbjgQGUk2VZ9I8BWB+AVou4ovjoXzT5QN+1NRQT5Nbh3z9k4YsvzvDZfcOJnJkDLrZMk0sEIx3+4DnnUcbtHqd6V+yObFJ+JpgQj2mvWq0MKwWFoAKgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188931; c=relaxed/simple;
	bh=ExB1yEjtLfP3X2YfSpZ/UdxJUO+P0+U9gqTpdL+W5z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmE/LwTLqcNF8ZaLNrmd2r4Nu73FndbS1HbtqmnnzhQX9o/eF57vpGJbUPOIQ3W6j4d0Xs1Cpx8X+1uMJgHFzmHwWPPewHC8aaZsxEDUEnC/pu+eSnlyoGiAdMAAO6/8QlTKKuTMSE3VrxlGyPkFPi6k93tFwiPGpwSd8jfBwV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZA7rPNkt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF21EC4CEE7;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188931;
	bh=ExB1yEjtLfP3X2YfSpZ/UdxJUO+P0+U9gqTpdL+W5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZA7rPNktnp2D41azPYIxMIdARtDouu2LmD8SwX+uXDVUJ8W/dBzLxVKJrTP4K2pFZ
	 Fo1MvfChmyZDvFwYD4yv3KpSBFnOuvI7cpyxfvW1JeEsKbFryf16G5ov0BQvq56eOj
	 YUV8lz+zFZd7DmmrlKAZPUMctAcWYWhi1vrlLbFoEc7TO/Rnp3ngw997rzBWH1hG6M
	 pPhNUdj7PVl1Vwm7A+ZY2Vg4gBsVjxbMzXy0EexMGPKH6pvWYL3y0qeoArtQWMykOq
	 fCxNa9KJABKLU1Ru+u7snPUjzm3AEODhwbtcpQOkcRpjx6klNVnVL0ECI1xNw8fRc1
	 wAyNTm/Bxg3Xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq5-000000021VN-3lmH;
	Mon, 03 Nov 2025 16:55:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 22/33] KVM: arm64: Invert ap_list sorting to push active interrupts out
Date: Mon,  3 Nov 2025 16:55:06 +0000
Message-ID: <20251103165517.2960148-23-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having established that pending interrupts should have priority
to be moved into the LRs over the active interrupts, implement this
in the ap_list sorting.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 570cc8fe42b87..56c61e17e1e88 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -270,10 +270,7 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
  * well, the first items in the list being the first things populated in the
  * LRs.
  *
- * A hard rule is that active interrupts can never be pushed out of the LRs
- * (and therefore take priority) since we cannot reliably trap on deactivation
- * of IRQs and therefore they have to be present in the LRs.
- *
+ * Pending, non-active interrupts must be placed at the head of the list.
  * Otherwise things should be sorted by the priority field and the GIC
  * hardware support will take care of preemption of priority groups etc.
  *
@@ -298,21 +295,21 @@ static int vgic_irq_cmp(void *priv, const struct list_head *a,
 	raw_spin_lock(&irqa->irq_lock);
 	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
-	if (irqa->active || irqb->active) {
-		ret = (int)irqb->active - (int)irqa->active;
-		goto out;
-	}
+	penda = irqa->enabled && irq_is_pending(irqa) && !irqa->active;
+	pendb = irqb->enabled && irq_is_pending(irqb) && !irqb->active;
 
-	penda = irqa->enabled && irq_is_pending(irqa);
-	pendb = irqb->enabled && irq_is_pending(irqb);
+	ret = (int)pendb - (int)penda;
+	if (ret)
+		goto out;
 
-	if (!penda || !pendb) {
-		ret = (int)pendb - (int)penda;
+	/* Both pending and enabled, sort by priority (lower number first) */
+	ret = (int)irqa->priority - (int)irqb->priority;
+	if (ret)
 		goto out;
-	}
 
-	/* Both pending and enabled, sort by priority */
-	ret = irqa->priority - irqb->priority;
+	/* Finally, HW bit active interrupts have priority over non-HW ones */
+	ret = (int)irqb->hw - (int)irqa->hw;
+
 out:
 	raw_spin_unlock(&irqb->irq_lock);
 	raw_spin_unlock(&irqa->irq_lock);
-- 
2.47.3


