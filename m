Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1704737A41
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfFFQzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:20 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50816 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbfFFQzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C699168F;
        Thu,  6 Jun 2019 09:55:19 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF79B3F690;
        Thu,  6 Jun 2019 09:55:17 -0700 (PDT)
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
Subject: [PATCH 7/8] KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI injection
Date:   Thu,  6 Jun 2019 17:54:54 +0100
Message-Id: <20190606165455.162478-8-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When performing an MSI injection, let's first check if the translation
is already in the cache. If so, let's inject it quickly without
going through the whole translation process.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 58 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  1 +
 2 files changed, 59 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index bd76683781e8..3021cbf89b70 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -600,6 +600,42 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
+static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
+					     u32 devid, u32 eventid)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_translation_cache_entry *cte;
+	struct vgic_irq *irq = NULL;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+
+	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+		/*
+		 * If we hit a NULL entry, there is nothing after this
+		 * point.
+		 */
+		if (!cte->irq)
+			break;
+
+		if (cte->db == db &&
+		    cte->devid == devid &&
+		    cte->eventid == eventid) {
+			/*
+			 * Move this entry to the head, as it is the
+			 * most recently used.
+			 */
+			list_move(&cte->entry, &dist->lpi_translation_cache);
+			irq = cte->irq;
+			break;
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	return irq;
+}
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq)
 {
@@ -683,6 +719,25 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_irq *irq;
+	unsigned long flags;
+	phys_addr_t db;
+
+	db = (u64)msi->address_hi << 32 | msi->address_lo;
+	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
+
+	if (!irq)
+		return -1;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	irq->pending_latch = true;
+	vgic_queue_irq_unlock(kvm, irq, flags);
+
+	return 0;
+}
+
 /*
  * Queries the KVM IO bus framework to get the ITS pointer from the given
  * doorbell address.
@@ -694,6 +749,9 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 	struct vgic_its *its;
 	int ret;
 
+	if (!vgic_its_inject_cached_translation(kvm, msi))
+		return 1;
+
 	its = vgic_msi_to_its(kvm, msi);
 	if (IS_ERR(its))
 		return PTR_ERR(its);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 04335e997907..fb2c83d6f748 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -317,6 +317,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_its_invalidate_cache(struct kvm *kvm);
 
-- 
2.20.1

