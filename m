Return-Path: <kvm+bounces-8607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D93852C69
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 830991F24ADB
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FEB151028;
	Tue, 13 Feb 2024 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kv8VMoYw"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF3364C5
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816819; cv=none; b=pHNyeOxdZAjfG1QYDfq+NuXGxwucZkfPfN5G2BjkZFFSw2cpMUTltCciLpjKCC295hHDxMe7pk7D/o/DSr2OA2yR1uLNBn1p7kKPFuVyOOhmpDFVe2C+JN+HpC8OH3DOttS6D2mj0Pq5ag96OxJXsJLRmA2rAv0HgqLklVlS8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816819; c=relaxed/simple;
	bh=Qi8rU6NjOkVcx9TX1/O9p73F+ULC5MIdl/I9CDfvIew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsmiMYczPi3RM7gIZISGgDedbmy/i0i4dQEX8qHoeyRXAjNmDUuQZLyglgG1PTmoJmXYi3ngMEdvDN2gIuuBV7NY46/jiKrTNSGV00TpBwh6aIPM04mTrKZ6DRj2q1fxmHlO9+Alu8cXuSZx9RBwfbSFTWuGn/6x0N/1tteANxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kv8VMoYw; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKECb1eTQQJ/f0GKxMxXWqmjCFHiATDCrLFETxE2qgY=;
	b=Kv8VMoYwDOw5o/4ifDv6LsdWhzI+zrP+hXZ/dyggg6voxrWhMxjS3n2slHUN6XjTEoqdYA
	dQuL0Hu9I6PuXqEFLSppH2l3M8sTV/qJmjOHGnCDT3mXHmHde1DdJLi7H/mz2ONCtgqeki
	OIZDsSupblvzEtuDnC7WHJDgthL8+mY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 13/23] KVM: arm64: vgic-its: Pick cache victim based on usage count
Date: Tue, 13 Feb 2024 09:32:50 +0000
Message-ID: <20240213093250.3960069-14-oliver.upton@linux.dev>
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

To date the translation cache LRU policy relies on the ordering of the
linked-list to pick the victim, as entries are moved to the head of the
list on every cache hit. These sort of transformations are incompatible
with an rculist, necessitating a different strategy for recording usage
in-place.

Count the number of cache hits since the last translation cache miss for
every entry. The preferences for selecting a victim are as follows:

 - Invalid entries over valid entries

 - Valid entry with the lowest usage count

 - In the case of a tie, pick the entry closest to the tail (oldest)

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 46 ++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index a7ba20b57264..35926d5ae561 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -157,6 +157,7 @@ struct vgic_translation_cache_entry {
 	u32			devid;
 	u32			eventid;
 	struct vgic_irq		*irq;
+	atomic64_t		usage_count;
 };
 
 /**
@@ -580,13 +581,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 		    cte->eventid != eventid)
 			continue;
 
-		/*
-		 * Move this entry to the head, as it is the most
-		 * recently used.
-		 */
-		if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
-			list_move(&cte->entry, &dist->lpi_translation_cache);
-
+		atomic64_inc(&cte->usage_count);
 		return cte->irq;
 	}
 
@@ -619,6 +614,36 @@ static unsigned int vgic_its_max_cache_size(struct kvm *kvm)
 	return atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
 }
 
+static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_dist *dist,
+								  s64 *max_usage)
+{
+	struct vgic_translation_cache_entry *cte, *victim = NULL;
+	s64 min, tmp, max = S64_MIN;
+
+	/*
+	 * Find the least used cache entry since the last cache miss, preferring
+	 * older entries in the case of a tie. Return the max usage count seen
+	 * during the scan to initialize the new cache entry.
+	 */
+	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+		tmp = atomic64_read(&cte->usage_count);
+		max = max(max, tmp);
+
+		if (!cte->irq) {
+			victim = cte;
+			break;
+		}
+
+		if (!victim || tmp <= min) {
+			victim = cte;
+			min = tmp;
+		}
+	}
+
+	*max_usage = max;
+	return victim;
+}
+
 static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
@@ -627,6 +652,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	unsigned long flags;
 	phys_addr_t db;
+	s64 usage = 0;
 
 	/* Do not cache a directly injected interrupt */
 	if (irq->hw)
@@ -650,9 +676,8 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	}
 
 	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
-		/* Always reuse the last entry (LRU policy) */
-		victim = list_last_entry(&dist->lpi_translation_cache,
-				      typeof(*cte), entry);
+		victim = vgic_its_cache_victim(dist, &usage);
+
 		list_del(&victim->entry);
 		dist->lpi_cache_count--;
 	}
@@ -664,6 +689,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
+	atomic64_set(&new->usage_count, usage);
 	new->db		= db;
 	new->devid	= devid;
 	new->eventid	= eventid;
-- 
2.43.0.687.g38aa6559b0-goog


