Return-Path: <kvm+bounces-6875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5528383B344
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:50:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A5251C209F0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC9C135A5C;
	Wed, 24 Jan 2024 20:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JLpaQYjc"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EBC1350EC
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129386; cv=none; b=fwxyD8o74Dcy0zjn/kO5/NmuTVSSuriIDxHduCBiVTfcgbSZe7AIUXJfoHKbBchv82zhtinF4i1Bw6K3kW//ymjl1SjZ9eeivoCC5gZgKl6WtwVxKyYDcAwtjWhO3JPyzsdE8WxgvjyHMoGdGhhuSRqNwiYWrK1Rx1+3TfZGe0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129386; c=relaxed/simple;
	bh=oTyMnOeo4+hRi1tWu/Z+DFCpY7MaGTv5BzKw4vMNwPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekN+HlbPCTm/WeZyURYXGHJ95Wqu3tovDk2fxNpDmMm8RvvhIF/zeASdUI/5w5/a+prY0iClNSk2FeBktweT5Omoy/goSzx/NfmQNrmRHP65B/Bnz9UHu80841akaEYcpXBQBAIdrnkqYATK6tbfHjas272eMfUN4a6Hp00Fa0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JLpaQYjc; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KW0iJG5RQGiIM6NdrK4b2D5XgcaBzPy7qVtrdzoHvOs=;
	b=JLpaQYjcQQrygzAoulCFPLVg7Z6i4rruEf8kIMEhvn7I6gut4CPwudnCZlAaA1sNMfil3d
	pJQEbxnlMVk5S/7mY5hgg6tzeTCnRpcSvAvWa6k+rIb/luD2YlENn/gpEXrTl/5CNP8MG2
	yH9TQQTmI6zYi4KRPjJbe/in0/8O+xY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 11/15] KVM: arm64: vgic-its: Lazily allocate LPI translation cache
Date: Wed, 24 Jan 2024 20:49:05 +0000
Message-ID: <20240124204909.105952-12-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/vgic/vgic-its.c  | 86 ++++++++++++++-------------------
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 38 insertions(+), 52 deletions(-)

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
index 8c026a530018..aec82d9a1b3c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -608,12 +608,20 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
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
+	struct vgic_translation_cache_entry *new, *victim;
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
 	phys_addr_t db;
 
@@ -621,10 +629,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (irq->hw)
 		return;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	new = victim = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
+	if (!new)
+		return;
 
-	if (unlikely(list_empty(&dist->lpi_translation_cache)))
-		goto out;
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	/*
 	 * We could have raced with another CPU caching the same
@@ -635,17 +644,15 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (__vgic_its_check_cache(dist, db, devid, eventid))
 		goto out;
 
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
+	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
+		/* Always reuse the last entry (LRU policy) */
+		victim = list_last_entry(&dist->lpi_translation_cache,
+				      typeof(*cte), entry);
+		list_del(&victim->entry);
+		dist->lpi_cache_count--;
+	} else {
+		victim = NULL;
+	}
 
 	/*
 	 * The irq refcount is guaranteed to be nonzero while holding the
@@ -654,16 +661,26 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
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
 
 out:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
+	/*
+	 * Caching the translation implies having an extra reference
+	 * to the interrupt, so drop the potential reference on what
+	 * was in the cache, and increment it on the new interrupt.
+	 */
+	if (victim && victim->irq)
+		vgic_put_irq(kvm, victim->irq);
+
+	kfree(victim);
 }
 
 void vgic_its_invalidate_cache(struct kvm *kvm)
@@ -1905,33 +1922,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
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
@@ -1978,8 +1968,6 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
-
-		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a6f6c1583662..70490a2a300d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -282,6 +282,7 @@ struct vgic_dist {
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
+	unsigned int		lpi_cache_count;
 
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
-- 
2.43.0.429.g432eaa2c6b-goog


