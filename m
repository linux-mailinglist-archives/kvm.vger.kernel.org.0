Return-Path: <kvm+bounces-15565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 904068AD588
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4603B28370B
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D3515697A;
	Mon, 22 Apr 2024 20:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UECSjid5"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D9A156876
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816154; cv=none; b=txfDpm4dublA1F1pkbMktM+C/PX+6iYku32gStFklUjd/YksozDIa+YnwF57URqx4IHDlfYZTyUB/EHCrstEe4hUaPObfmBSmXPYRqElXF6WhMNa29hn6Ps8Hdu4qIwnuAxZjudR07ZmtLrbpagDLj1Q3di/kUj7HktHy3Wh1Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816154; c=relaxed/simple;
	bh=SuI4fxsdPpu7RBL4gjUxe0Wb6CeSWwxc/FCW80mAiYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkAaM/0C/hi1gVOlP6RcPCQ51Xpl/KSGjGycryWz/+DXhAPnjPQUNmzrJOG0V62Orz7VxyeaGIihLG86mnZROA/pAqULMVA6k1nBC+lR0yyZqVQJN/iG7fYA8USY9LAVMFLNsMojo01U0KCF2STlhYZQhaY2hE1TphWryDeHGi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UECSjid5; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qgtcLU3++/q2Ge4zJnuAcQCCP6r1NOlAwbU69hgH/YA=;
	b=UECSjid5DXIAJ2sVnu8sI8GtMlL3aaqBzuulciy6E5a5rptLeczcJowMmFJ3az0+Vewr0J
	4uQ31CJmCSzQ4Tnn9lA1sav5ODmINifxjl9jT/n8NDKGbUOJMTqyLM6XBtcz/0HfRNj+VT
	aGRkowfipnWBwGZATYyDkCL19m93Pm0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 11/19] KVM: arm64: vgic-its: Rip out the global translation cache
Date: Mon, 22 Apr 2024 20:01:50 +0000
Message-ID: <20240422200158.2606761-12-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The MSI injection fast path has been transitioned away from the global
translation cache. Rip it out.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |   7 --
 arch/arm64/kvm/vgic/vgic-its.c  | 121 ++------------------------------
 arch/arm64/kvm/vgic/vgic.h      |   2 -
 include/kvm/arm_vgic.h          |   3 -
 4 files changed, 4 insertions(+), 129 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f20941f83a07..6ee42f395253 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
@@ -305,9 +304,6 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm))
-		vgic_lpi_translation_cache_init(kvm);
-
 	/*
 	 * If we have GICv4.1 enabled, unconditionally request enable the
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
@@ -361,9 +357,6 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_has_its(kvm))
-		vgic_lpi_translation_cache_destroy(kvm);
-
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9a517faa43ae..bb7f4fd35b2b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -149,14 +149,6 @@ struct its_ite {
 	u32 event_id;
 };
 
-struct vgic_translation_cache_entry {
-	struct list_head	entry;
-	phys_addr_t		db;
-	u32			devid;
-	u32			eventid;
-	struct vgic_irq		*irq;
-};
-
 /**
  * struct vgic_its_abi - ITS abi ops and settings
  * @cte_esz: collection table entry size
@@ -568,96 +560,34 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       struct vgic_irq *irq)
 {
 	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
 	struct vgic_irq *old;
-	unsigned long flags;
-	phys_addr_t db;
 
 	/* Do not cache a directly injected interrupt */
 	if (irq->hw)
 		return;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-
-	if (unlikely(list_empty(&dist->lpi_translation_cache)))
-		goto out;
-
-	db = its->vgic_its_base + GITS_TRANSLATER;
-
-	/* Always reuse the last entry (LRU policy) */
-	cte = list_last_entry(&dist->lpi_translation_cache,
-			      typeof(*cte), entry);
-
-	/*
-	 * Caching the translation implies having an extra reference
-	 * to the interrupt, so drop the potential reference on what
-	 * was in the cache, and increment it on the new interrupt.
-	 */
-	if (cte->irq)
-		vgic_put_irq(kvm, cte->irq);
-
 	/*
 	 * The irq refcount is guaranteed to be nonzero while holding the
 	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
 	 */
 	lockdep_assert_held(&its->its_lock);
-
-	/*
-	 * Yes, two references are necessary at the moment:
-	 *  - One for the global LPI translation cache
-	 *  - Another for the translation cache belonging to @its
-	 *
-	 * This will soon disappear.
-	 */
-	vgic_get_irq_kref(irq);
 	vgic_get_irq_kref(irq);
 
-	cte->db		= db;
-	cte->devid	= devid;
-	cte->eventid	= eventid;
-	cte->irq	= irq;
-
-	/* Move the new translation to the head of the list */
-	list_move(&cte->entry, &dist->lpi_translation_cache);
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
 	/*
-	 * The per-ITS cache is a perfect cache, so it may already have an
-	 * identical translation even if it were missing from the global
-	 * cache. Ensure we don't leak a reference if that is the case.
+	 * We could have raced with another CPU caching the same
+	 * translation behind our back, ensure we don't leak a
+	 * reference if that is the case.
 	 */
 	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 	if (old)
 		vgic_put_irq(kvm, old);
-
-out:
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
 static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
 	struct kvm *kvm = its->dev->kvm;
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
-	unsigned long flags, idx;
 	struct vgic_irq *irq;
-
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
-		/*
-		 * If we hit a NULL entry, there is nothing after this
-		 * point.
-		 */
-		if (!cte->irq)
-			break;
-
-		vgic_put_irq(kvm, cte->irq);
-		cte->irq = NULL;
-	}
-
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	unsigned long idx;
 
 	xa_for_each(&its->translation_cache, idx, irq) {
 		xa_erase(&its->translation_cache, idx);
@@ -1880,47 +1810,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
 	return ret;
 }
 
-/* Default is 16 cached LPIs per vcpu */
-#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
-
-void vgic_lpi_translation_cache_init(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	unsigned int sz;
-	int i;
-
-	if (!list_empty(&dist->lpi_translation_cache))
-		return;
-
-	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
-
-	for (i = 0; i < sz; i++) {
-		struct vgic_translation_cache_entry *cte;
-
-		/* An allocation failure is not fatal */
-		cte = kzalloc(sizeof(*cte), GFP_KERNEL_ACCOUNT);
-		if (WARN_ON(!cte))
-			break;
-
-		INIT_LIST_HEAD(&cte->entry);
-		list_add(&cte->entry, &dist->lpi_translation_cache);
-	}
-}
-
-void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte, *tmp;
-
-	vgic_its_invalidate_all_caches(kvm);
-
-	list_for_each_entry_safe(cte, tmp,
-				 &dist->lpi_translation_cache, entry) {
-		list_del(&cte->entry);
-		kfree(cte);
-	}
-}
-
 #define INITIAL_BASER_VALUE						  \
 	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
 	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
@@ -1953,8 +1842,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
-
-		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e5cda1eb4bcf..407640c24049 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -335,8 +335,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
-void vgic_lpi_translation_cache_init(struct kvm *kvm);
-void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 void vgic_its_invalidate_all_caches(struct kvm *kvm);
 
 /* GICv4.1 MMIO interface */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c15e7fcccb86..76ed097500c0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -286,9 +286,6 @@ struct vgic_dist {
 #define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
 
-	/* LPI translation cache */
-	struct list_head	lpi_translation_cache;
-
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
 
-- 
2.44.0.769.g3c40516874-goog


