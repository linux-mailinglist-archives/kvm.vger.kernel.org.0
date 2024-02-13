Return-Path: <kvm+bounces-8606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C61852C66
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B7F01F23404
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704B250251;
	Tue, 13 Feb 2024 09:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e7t7TNz2"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57500224DF
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816818; cv=none; b=p+8yBhKuCl64dAFnaIQdqW4R/E8on+810cvyFG2JM2R5F7pXZZHsPEoZJW+sZr2wEQldy+VvN38u3yG6HZVHOn28B645TboTZ9Zoh76i8WQVtdfk/OVun/aFMRIG12pN9n9BhnMaZLG1fuAUgXEl/H+mFKXGdiSC00cKnh2+K14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816818; c=relaxed/simple;
	bh=u654twAWO/lOhw5G+s6F5ghriBPc9GHm8+B9VReBiXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQYULhLAIb8297QsAJF20LpprEK8jUm9ULpSj+62BArw7Ze9kFfZbD1iA0Kpj4I+KMJxGb0ORm4Z1LtvYzit8yqliIjo2V17LV7krx8Em6KSitBTGoZB1MmMDlz+LMg0iFNPnubVXBlOvENZf4BiBGdCAnq9x3Jfaewo/0A9Ou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e7t7TNz2; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+lMHsCzsaKIbkTveh0NrGUV6sBBBNjPrb67/o/BF7Y=;
	b=e7t7TNz2VtcfBlVd5Mjzyd6gJKVWSV0ZzpRHdbUml7x9/IMMNdWc32TLtbmJenkRNzWM9J
	gUzOaUy8lrCvUK+H25jbrbFVoeSONJHlCVz7Jfs5LveG9YomxxWmOfqm3lI6uD4l6WwE3s
	/z4mrZYrT42YMUsJUS1OXlW36Q421Ic=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/23] KVM: arm64: vgic-its: Lazily allocate LPI translation cache
Date: Tue, 13 Feb 2024 09:32:49 +0000
Message-ID: <20240213093250.3960069-13-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reusing translation cache entries within a read-side critical section is
fundamentally incompatible with an rculist. As such, we need to allocate
a new entry to replace an eviction and free the removed entry
afterwards.

Take this as an opportunity to remove the eager allocation of
translation cache entries altogether in favor of a lazy allocation model
on cache miss.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |  3 --
 arch/arm64/kvm/vgic/vgic-its.c  | 96 +++++++++++++++------------------
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 45 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index e25672d6e846..660d5ce3b610 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -305,9 +305,6 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm))
-		vgic_lpi_translation_cache_init(kvm);
-
 	/*
 	 * If we have GICv4.1 enabled, unconditionnaly request enable the
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 50a9addebeed..a7ba20b57264 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -611,12 +611,20 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	return irq;
 }
 
+/* Default is 16 cached LPIs per vcpu */
+#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
+
+static unsigned int vgic_its_max_cache_size(struct kvm *kvm)
+{
+	return atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
+}
+
 static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
 {
+	struct vgic_translation_cache_entry *new, *victim = NULL;
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
 	phys_addr_t db;
 
@@ -624,10 +632,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (irq->hw)
 		return;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
+	if (!new)
+		return;
 
-	if (unlikely(list_empty(&dist->lpi_translation_cache)))
-		goto out;
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	/*
 	 * We could have raced with another CPU caching the same
@@ -635,22 +644,17 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * already
 	 */
 	db = its->vgic_its_base + GITS_TRANSLATER;
-	if (__vgic_its_check_cache(dist, db, devid, eventid))
+	if (__vgic_its_check_cache(dist, db, devid, eventid)) {
+		kfree(new);
 		goto out;
+	}
 
-	/* Always reuse the last entry (LRU policy) */
-	cte = list_last_entry(&dist->lpi_translation_cache,
-			      typeof(*cte), entry);
-
-	/*
-	 * Caching the translation implies having an extra reference
-	 * to the interrupt, so drop the potential reference on what
-	 * was in the cache, and increment it on the new interrupt.
-	 */
-	if (cte->irq) {
-		KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_victim, cte->db,
-				   cte->devid, cte->eventid, cte->irq->intid);
-		vgic_put_irq(kvm, cte->irq);
+	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
+		/* Always reuse the last entry (LRU policy) */
+		victim = list_last_entry(&dist->lpi_translation_cache,
+				      typeof(*cte), entry);
+		list_del(&victim->entry);
+		dist->lpi_cache_count--;
 	}
 
 	/*
@@ -660,16 +664,33 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
-	cte->db		= db;
-	cte->devid	= devid;
-	cte->eventid	= eventid;
-	cte->irq	= irq;
+	new->db		= db;
+	new->devid	= devid;
+	new->eventid	= eventid;
+	new->irq	= irq;
 
 	/* Move the new translation to the head of the list */
-	list_move(&cte->entry, &dist->lpi_translation_cache);
+	list_add(&new->entry, &dist->lpi_translation_cache);
+	dist->lpi_cache_count++;
 
 out:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	if (!victim)
+		return;
+
+	/*
+	 * Caching the translation implies having an extra reference
+	 * to the interrupt, so drop the potential reference on what
+	 * was in the cache, and increment it on the new interrupt.
+	 */
+	if (victim->irq) {
+		KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_victim, victim->db,
+				   victim->devid, victim->eventid, victim->irq->intid);
+		vgic_put_irq(kvm, victim->irq);
+	}
+
+	kfree(victim);
 }
 
 void vgic_its_invalidate_cache(struct kvm *kvm)
@@ -1917,33 +1938,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
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
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -1990,8 +1984,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
-
-		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 47035946648e..431d05c01a53 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -281,6 +281,7 @@ struct vgic_dist {
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
+	unsigned int		lpi_cache_count;
 
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
-- 
2.43.0.687.g38aa6559b0-goog


