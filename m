Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C5437A3D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfFFQzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:12 -0400
Received: from foss.arm.com ([217.140.101.70]:50744 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfFFQzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61377165C;
        Thu,  6 Jun 2019 09:55:11 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92B173F690;
        Thu,  6 Jun 2019 09:55:09 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Subject: [PATCH 3/8] KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
Date:   Thu,  6 Jun 2019 17:54:50 +0100
Message-Id: <20190606165455.162478-4-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a successful translation, preserve the parameters in the LPI
translation cache. Each translation is reusing the last slot
in the list, naturally evincting the least recently used entry.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 41 ++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 5758504fd934..bc370b6c5afa 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -538,6 +538,45 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
+				       u32 devid, u32 eventid,
+				       struct vgic_irq *irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_translation_cache_entry *cte;
+	unsigned long flags;
+
+	/* Do not cache a directly injected interrupt */
+	if (irq->hw)
+		return;
+
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
+	/* Always reuse the last entry (LRU policy) */
+	cte = list_last_entry(&dist->lpi_translation_cache,
+			      typeof(*cte), entry);
+
+	/*
+	 * Caching the translation implies having an extra reference
+	 * to the interrupt, so drop the potential reference on what
+	 * was in the cache, and increment it on the new interrupt.
+	 */
+	if (cte->irq)
+		__vgic_put_lpi_locked(kvm, cte->irq);
+
+	vgic_get_irq_kref(irq);
+
+	cte->db		= its->vgic_its_base + GITS_TRANSLATER;
+	cte->devid	= devid;
+	cte->eventid	= eventid;
+	cte->irq	= irq;
+
+	/* Move the new translation to the head of the list */
+	list_move(&cte->entry, &dist->lpi_translation_cache);
+
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+}
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq)
 {
@@ -558,6 +597,8 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
+	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
+
 	*irq = ite->irq;
 	return 0;
 }
-- 
2.20.1

