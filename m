Return-Path: <kvm+bounces-6877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C06D083B346
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702BF2858F2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F139135A70;
	Wed, 24 Jan 2024 20:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AmSufSwg"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188A135A60
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129390; cv=none; b=QNjRc5bPy5SlWOC8ERbXGvJIU8ZnIXdKsVnHKcrQXVKDp9q+qIckshhLRMObQYZl8MGLK4wPQg0J4kkooDdzWXV4GngBebAZkke6bbxDgmwLP03GXi/XOApooGGUUw68QAV8wz5OiJcyNNS8mwos9AGaRI+4HfL74fjFxkzaZsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129390; c=relaxed/simple;
	bh=LORJbe3ID83LnrxDienlFK/6XzGGKHhuqfuKs+CQORc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZadVWgZIwaxtsX1MmxlH2d7EYqOx9VWk3jSdtI7QM44U/uGNwsQ35I15u9krUFYQjcpKvFioD4Kgl9v2buOfwgXOdip/sZLbmKzXOnyc1g/1Kl2LaLAnFnPrxVV0u/MyVyh0dxGMwfvlGiZhHIUNlR876+919SPmDtMYE+ASdlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AmSufSwg; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63nbbU4EZtlCwl4weak8AD8fCWTldEW9ao3X+RGpuoY=;
	b=AmSufSwgUm2HFHsMVWwFSzd10TloPd+vqBg8wXFah6BUnjCwaFO3VMVvyxiUJe/+BMQm09
	3v03q0ZJ1Ui82Sem/qAa3Yz230lFyZURagEQKTm1xaLTgn1gz6JKT2UXKfSSJL+Jjh/Q8F
	24kqDd58srdJr3/v+akoXwF6QYvhOKE=
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
Subject: [PATCH 13/15] KVM: arm64: vgic-its: Protect cached vgic_irq pointers with RCU
Date: Wed, 24 Jan 2024 20:49:07 +0000
Message-ID: <20240124204909.105952-14-oliver.upton@linux.dev>
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

RCU readers of the LPI translation cache will be able to run in parallel
with a cache invalidation, which clears the RCU pointer. Start using RCU
protection on the cached irq pointer in light of this.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ed0c6c333a6c..79b35fdaa1cd 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -153,7 +153,7 @@ struct vgic_translation_cache_entry {
 	phys_addr_t		db;
 	u32			devid;
 	u32			eventid;
-	struct vgic_irq		*irq;
+	struct vgic_irq __rcu	*irq;
 	atomic64_t		usage_count;
 };
 
@@ -571,7 +571,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
 		 */
-		if (!cte->irq)
+		if (!rcu_access_pointer(cte->irq))
 			break;
 
 		if (cte->db != db || cte->devid != devid ||
@@ -579,7 +579,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 			continue;
 
 		atomic64_inc(&cte->usage_count);
-		return cte->irq;
+		return rcu_dereference(cte->irq);
 	}
 
 	return NULL;
@@ -622,7 +622,7 @@ static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_di
 	 * deliberately non-atomic, so this is all best-effort.
 	 */
 	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
-		if (!cte->irq)
+		if (!rcu_access_pointer(cte->irq))
 			return cte;
 
 		tmp = atomic64_xchg_relaxed(&cte->usage_count, 0);
@@ -653,6 +653,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		return;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	/*
 	 * We could have raced with another CPU caching the same
@@ -686,12 +687,13 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	new->db		= db;
 	new->devid	= devid;
 	new->eventid	= eventid;
-	new->irq	= irq;
+	rcu_assign_pointer(new->irq, irq);
 
 	/* Move the new translation to the head of the list */
 	list_add(&new->entry, &dist->lpi_translation_cache);
 
 out:
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	/*
@@ -712,19 +714,21 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
 		/*
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
 		 */
-		if (!cte->irq)
+		if (!rcu_access_pointer(cte->irq))
 			break;
 
 		vgic_put_irq(kvm, cte->irq);
-		cte->irq = NULL;
+		rcu_assign_pointer(cte->irq, NULL);
 	}
 
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-- 
2.43.0.429.g432eaa2c6b-goog


