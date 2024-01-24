Return-Path: <kvm+bounces-6876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D4183B345
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEDD21F2354A
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023BD1350F9;
	Wed, 24 Jan 2024 20:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iYYzZbwW"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBA3135A57
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129388; cv=none; b=Aazz4IT5Odve7LfDwyvDKBkwq6g9BUXTqXvSj5/H+z17ntO2WZtxj+shp0rOZ2tQZbtgb1KD3BgvW7eaRPRVR1HzbkYzrOKp8RuHm2nD/BYx3WYysoeq7q6JuNt/xq7gCX18T9dxZz/O/b+2nrLQNhZKeEU8OlCGcZXgBgpRieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129388; c=relaxed/simple;
	bh=V+Aqf0jjqyGa1E2qOjT62lbfoHRkavh2wOZwXZb04x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swuve9FUTFrIMpsMPNlba0IHDbDJiV9Qy4jAV4aYAAtp1NmOlue/xzSPeuk8b7XMeQmGU6YajH3cAeVeUj8OkEZPVuNTZEofcmIXzZzVsCbpGew9gqS3Rl0GzThbenhq84Ab2mVg4YtOJsb+MyH8eN6VB0cJ3xpeDN5v/vmGvZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iYYzZbwW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+2oom+tyocopN2F9E6bClPUUgz5VYwJmjrToVciJR0=;
	b=iYYzZbwWmhBMA5YW9/oAmiXQdY3D2dtGEYhfBuIagJoHWJjhRZEeG3LzXuqrzfASC4+Dr4
	+4n8tOkAAO5EzNw/BYxPJtmYEbyc2X/vHnDn4Dpw2Nr7Xuahg+1EvGqcoZhrm2Krk1cNhd
	0MqKB8njnktRx9R6wjkLqvCvFUNfFiM=
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
Subject: [PATCH 12/15] KVM: arm64: vgic-its: Pick cache victim based on usage count
Date: Wed, 24 Jan 2024 20:49:06 +0000
Message-ID: <20240124204909.105952-13-oliver.upton@linux.dev>
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
 arch/arm64/kvm/vgic/vgic-its.c | 42 ++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index aec82d9a1b3c..ed0c6c333a6c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -154,6 +154,7 @@ struct vgic_translation_cache_entry {
 	u32			devid;
 	u32			eventid;
 	struct vgic_irq		*irq;
+	atomic64_t		usage_count;
 };
 
 /**
@@ -577,13 +578,7 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
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
 
@@ -616,6 +611,30 @@ static unsigned int vgic_its_max_cache_size(struct kvm *kvm)
 	return atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
 }
 
+static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_dist *dist)
+{
+	struct vgic_translation_cache_entry *cte, *victim = NULL;
+	u64 min, tmp;
+
+	/*
+	 * Find the least used cache entry since the last cache miss, preferring
+	 * older entries in the case of a tie. Note that usage accounting is
+	 * deliberately non-atomic, so this is all best-effort.
+	 */
+	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
+		if (!cte->irq)
+			return cte;
+
+		tmp = atomic64_xchg_relaxed(&cte->usage_count, 0);
+		if (!victim || tmp <= min) {
+			victim = cte;
+			min = tmp;
+		}
+	}
+
+	return victim;
+}
+
 static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
@@ -645,9 +664,12 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		goto out;
 
 	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
-		/* Always reuse the last entry (LRU policy) */
-		victim = list_last_entry(&dist->lpi_translation_cache,
-				      typeof(*cte), entry);
+		victim = vgic_its_cache_victim(dist);
+		if (WARN_ON_ONCE(!victim)) {
+			victim = new;
+			goto out;
+		}
+
 		list_del(&victim->entry);
 		dist->lpi_cache_count--;
 	} else {
-- 
2.43.0.429.g432eaa2c6b-goog


