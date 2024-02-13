Return-Path: <kvm+bounces-8608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E72852CB2
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0249C28A6CC
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3F851C3E;
	Tue, 13 Feb 2024 09:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dZHpG1G4"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7069A51027
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817117; cv=none; b=OqEHPPgopM/H9y7FnFepGyb4ITZ3vmXaUOL0Z0entEpzzzYTL6NfdGnTiQoik0hrUppbrkOqIXmtpzLT0TIQN9wkedJddPdYByj4seui2qRBL39cJ+/klHzb9sVN+YCboPWBqSCNl1uPouVNwLGyQOl1fzwNHWCRk2obiLrV2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817117; c=relaxed/simple;
	bh=iYPy+Djc7SztwYSE8UN83cn8sXnT9Xu1HwT7l4kGpr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3WkyvJgfvQ8kO8+FdmEZi9yXoMKMh/iu79G3B70iurdTmos8Mb7rB+mMDrEt8v8UiYhm/ZLbfoAzcLK2l5KH4Zp8zXaNAPKwu+sK96RGudXs/aoLnFdOaGKm7378unh7MOk+a1iY8OTrc3p6jKrImxBqZMAvkRnlpNG+gC5y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dZHpG1G4; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzXQU++wkXrnCgv+wzrV4DGhnpKBtk4FI4+/K2Mli/0=;
	b=dZHpG1G41vsXh+Cd0nri7mL23uzEzEJ70EEubkmZ69krO3yyr+812ExcHaaBN0tAiYO/1j
	mWbk+z49WB6RF7XK+zWtdsHBak3IzYRe5ZZ6A+c6lVvY4iSgqVimAHVnBcZnoQY/JcJ+jy
	rWrWEvDJuv4QY3UsXTWBGjkZRgjx9ik=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 14/23] KVM: arm64: vgic-its: Protect cached vgic_irq pointers with RCU
Date: Tue, 13 Feb 2024 09:37:38 +0000
Message-ID: <20240213093747.3960866-1-oliver.upton@linux.dev>
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

RCU readers of the LPI translation cache will be able to run in parallel
with a cache invalidation, which clears the RCU pointer. Start using RCU
protection on the cached irq pointer in light of this.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 35926d5ae561..99042ecc9c85 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -156,7 +156,7 @@ struct vgic_translation_cache_entry {
 	phys_addr_t		db;
 	u32			devid;
 	u32			eventid;
-	struct vgic_irq		*irq;
+	struct vgic_irq __rcu	*irq;
 	atomic64_t		usage_count;
 };
 
@@ -574,7 +574,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 		 * If we hit a NULL entry, there is nothing after this
 		 * point.
 		 */
-		if (!cte->irq)
+		if (!rcu_access_pointer(cte->irq))
 			break;
 
 		if (cte->db != db || cte->devid != devid ||
@@ -582,7 +582,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 			continue;
 
 		atomic64_inc(&cte->usage_count);
-		return cte->irq;
+		return rcu_dereference(cte->irq);
 	}
 
 	return NULL;
@@ -629,7 +629,7 @@ static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_di
 		tmp = atomic64_read(&cte->usage_count);
 		max = max(max, tmp);
 
-		if (!cte->irq) {
+		if (!rcu_access_pointer(cte->irq)) {
 			victim = cte;
 			break;
 		}
@@ -663,6 +663,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		return;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	/*
 	 * We could have raced with another CPU caching the same
@@ -693,27 +694,32 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	new->db		= db;
 	new->devid	= devid;
 	new->eventid	= eventid;
-	new->irq	= irq;
+	rcu_assign_pointer(new->irq, irq);
 
 	/* Move the new translation to the head of the list */
 	list_add(&new->entry, &dist->lpi_translation_cache);
 	dist->lpi_cache_count++;
 
 out:
+	rcu_read_unlock();
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	if (!victim)
 		return;
 
+	synchronize_rcu();
+
 	/*
 	 * Caching the translation implies having an extra reference
 	 * to the interrupt, so drop the potential reference on what
-	 * was in the cache, and increment it on the new interrupt.
+	 * was in the cache.
 	 */
 	if (victim->irq) {
+		struct vgic_irq *irq = rcu_dereference_raw(victim->irq);
+
 		KVM_VM_TRACE_EVENT(kvm, vgic_its_trans_cache_victim, victim->db,
-				   victim->devid, victim->eventid, victim->irq->intid);
-		vgic_put_irq(kvm, victim->irq);
+				   victim->devid, victim->eventid, irq->intid);
+		vgic_put_irq(kvm, irq);
 	}
 
 	kfree(victim);
@@ -726,19 +732,21 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
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
2.43.0.687.g38aa6559b0-goog


