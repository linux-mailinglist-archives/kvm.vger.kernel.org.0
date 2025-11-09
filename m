Return-Path: <kvm+bounces-62445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DE8FEC443EB
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B2F924E7CCC
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5F730CD8E;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPJx8+V7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0730B511;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708595; cv=none; b=Xn+YKs5lY0RYFXv0IfUHnCmrcWYck0zKlbygWf7DcIoooSuXZDbLgy5cPtDk0AebyiXwXiqKfiKSXvW8cCsbDCoj88MFifswZxFObnvt8oHuVq/pBCWBp8ifNK8TeqRVrFva3UBl4kSfsB+HqsuRliifrWq5YLLfJj/XqWIM2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708595; c=relaxed/simple;
	bh=ExB1yEjtLfP3X2YfSpZ/UdxJUO+P0+U9gqTpdL+W5z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwPKYqjRiIewvBl4DxOtPWrg4t7mgyWLYanXItt5jR+2FsQ6s9UQDhcfFhkNaBduM2EmZXXsv1IHHyHLscPcNTIEpMvgKKz0jHNULlal4cG+imR1VDsok9fnbMs3OdtdfA+bbCVXK/NWVcV4AkoA3bcycLVRdm8/KRetta6krss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPJx8+V7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEF9C4CEF7;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708595;
	bh=ExB1yEjtLfP3X2YfSpZ/UdxJUO+P0+U9gqTpdL+W5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPJx8+V7s7fWwj4j9lE2LEIJ6pk8nJh8b7unc0M/0sqtRy2y6Se/3KnIY46FXiLl8
	 1GkVtgQV+sWfRnlweL0I60aZPdXao3/i6cLm06g3hXX0Avo7IAoEosh3c7hjuWF+xu
	 8rvU7A0nF/VKNsJI1F6XwmrQ33AMXMNSeye1UKGoXsIRm50Ur/xTejQdk1dgTODIjE
	 0oTiboDPEp/sSelP550aRGl4NeeD5KM97p+mUVxLaW6yAOL8rlf0NQhNjCl69bRn6E
	 BbbvqwfmQ6HP7Yt1YYQaAEDUgq1v1c2gZI8qDHoSM4iPNZ77VC62Xd2SRI5/0/4r3P
	 KGky1Xhb2Bzmg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91l-00000003exw-34Hh;
	Sun, 09 Nov 2025 17:16:33 +0000
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
Subject: [PATCH v2 23/45] KVM: arm64: Invert ap_list sorting to push active interrupts out
Date: Sun,  9 Nov 2025 17:15:57 +0000
Message-ID: <20251109171619.1507205-24-maz@kernel.org>
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


