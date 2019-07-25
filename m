Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D58752D6
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfGYPgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:36:42 -0400
Received: from foss.arm.com ([217.140.110.172]:59600 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbfGYPgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 11:36:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCD12168F;
        Thu, 25 Jul 2019 08:36:40 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17A513F71A;
        Thu, 25 Jul 2019 08:36:38 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
Subject: [PATCH v3 08/10] KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
Date:   Thu, 25 Jul 2019 16:35:41 +0100
Message-Id: <20190725153543.24386-9-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725153543.24386-1-maz@kernel.org>
References: <20190725153543.24386-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

On a successful translation, preserve the parameters in the LPI
translation cache. Each translation is reusing the last slot
in the list, naturally evicting the least recently used entry.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 86 ++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d3e90a9d0a7a..e61d3ea0ab40 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -535,6 +535,90 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
+					       phys_addr_t db,
+					       u32 devid, u32 eventid)
+{
+	struct vgic_translation_cache_entry *cte;
+
+	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+		/*
+		 * If we hit a NULL entry, there is nothing after this
+		 * point.
+		 */
+		if (!cte->irq)
+			break;
+
+		if (cte->db != db || cte->devid != devid ||
+		    cte->eventid != eventid)
+			continue;
+
+		/*
+		 * Move this entry to the head, as it is the most
+		 * recently used.
+		 */
+		if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
+			list_move(&cte->entry, &dist->lpi_translation_cache);
+
+		return cte->irq;
+	}
+
+	return NULL;
+}
+
+static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
+				       u32 devid, u32 eventid,
+				       struct vgic_irq *irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_translation_cache_entry *cte;
+	unsigned long flags;
+	phys_addr_t db;
+
+	/* Do not cache a directly injected interrupt */
+	if (irq->hw)
+		return;
+
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
+	if (unlikely(list_empty(&dist->lpi_translation_cache)))
+		goto out;
+
+	/*
+	 * We could have raced with another CPU caching the same
+	 * translation behind our back, so let's check it is not in
+	 * already
+	 */
+	db = its->vgic_its_base + GITS_TRANSLATER;
+	if (__vgic_its_check_cache(dist, db, devid, eventid))
+		goto out;
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
+	cte->db		= db;
+	cte->devid	= devid;
+	cte->eventid	= eventid;
+	cte->irq	= irq;
+
+	/* Move the new translation to the head of the list */
+	list_move(&cte->entry, &dist->lpi_translation_cache);
+
+out:
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+}
+
 void vgic_its_invalidate_cache(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -578,6 +662,8 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
+	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
+
 	*irq = ite->irq;
 	return 0;
 }
-- 
2.20.1

