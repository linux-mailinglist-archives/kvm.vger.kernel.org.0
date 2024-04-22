Return-Path: <kvm+bounces-15564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D588AD587
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2A01C20AD5
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F8E156897;
	Mon, 22 Apr 2024 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rCD3pEQz"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34095155731
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816153; cv=none; b=fNWs2QXVuuY4aro8EgHWKVeX0HL67U8TGAH3V+9XsYWTJp6hlQh2xD35ThotSCXyh8zryKwkeHReoFBN5vV4HdWF90ivftojwOGWhJHZTe0tsJJXTUk8qAuT8lOp+mS6mzOIaYhOq5JPXlFXr5+jbPtd4BygcnjPhg4w2e7ir/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816153; c=relaxed/simple;
	bh=nGhzZ9GWTIjotPUyiZLVadvCJNmbAZhS6LCkfdZah58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0lAKt+3X9ZN3GyLmq3P4USrIKmjT6grJTSaZMgsU0x3Nq76nCq5RU5c8rzShY9olk+ltl0Ot6Q0anpd+H7eOcYd261Nl98ovNtVnHgWdd0y7SfmegxkGn3nbLhjKzqLwcSA7+4p0ULaclqUpf+9skZliNTlIf+cfJ4QeJVs5Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rCD3pEQz; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGdk+14LQERtGFZqNrN+p4vCqZJLwBmxN0cPz/Q1hns=;
	b=rCD3pEQzgdE5botKMtfP4DR1pDWwvYbR+1+tmb9iLnjAA7hB/Gqu1cyWJpQIJhE59IMKfn
	9tSjV9GFMiHFE9BuFJEj6X0YspAyzMjofjOEr9s9k+rLCYr4J+Ah2v5NJXXTbGQRG0VXVz
	uP/WvwCyd7DxM0S9R8cPVkeK+HTS5J4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 10/19] KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
Date: Mon, 22 Apr 2024 20:01:49 +0000
Message-ID: <20240422200158.2606761-11-oliver.upton@linux.dev>
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

Everything is in place to switch to per-ITS translation caches. Start
using the per-ITS cache to avoid the lock serialization related to the
global translation cache. Explicitly check for out-of-range device and
event IDs as the cache index is packed based on the range the ITS
actually supports.

Take the RCU read lock to protect against the returned descriptor being
freed while trying to take a reference on it, as it is no longer
necessary to acquire the lpi_list_lock.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 63 +++++++++-------------------------
 1 file changed, 17 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 237e92016c1b..9a517faa43ae 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -251,8 +251,10 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 
 #define GIC_LPI_OFFSET 8192
 
-#define VITS_TYPER_IDBITS 16
-#define VITS_TYPER_DEVBITS 16
+#define VITS_TYPER_IDBITS		16
+#define VITS_MAX_EVENTID		(BIT(VITS_TYPER_IDBITS) - 1)
+#define VITS_TYPER_DEVBITS		16
+#define VITS_MAX_DEVID			(BIT(VITS_TYPER_DEVBITS) - 1)
 #define VITS_DTE_MAX_DEVID_OFFSET	(BIT(14) - 1)
 #define VITS_ITE_MAX_EVENTID_OFFSET	(BIT(16) - 1)
 
@@ -536,51 +538,27 @@ static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
 
 }
 
-static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
-					       phys_addr_t db,
-					       u32 devid, u32 eventid)
-{
-	struct vgic_translation_cache_entry *cte;
-
-	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
-		/*
-		 * If we hit a NULL entry, there is nothing after this
-		 * point.
-		 */
-		if (!cte->irq)
-			break;
-
-		if (cte->db != db || cte->devid != devid ||
-		    cte->eventid != eventid)
-			continue;
-
-		/*
-		 * Move this entry to the head, as it is the most
-		 * recently used.
-		 */
-		if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
-			list_move(&cte->entry, &dist->lpi_translation_cache);
-
-		return cte->irq;
-	}
-
-	return NULL;
-}
-
 static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 					     u32 devid, u32 eventid)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
+	struct vgic_its *its;
 	struct vgic_irq *irq;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	if (devid > VITS_MAX_DEVID || eventid > VITS_MAX_EVENTID)
+		return NULL;
+
+	its = __vgic_doorbell_to_its(kvm, db);
+	if (IS_ERR(its))
+		return NULL;
 
-	irq = __vgic_its_check_cache(dist, db, devid, eventid);
+	rcu_read_lock();
+
+	irq = xa_load(&its->translation_cache, cache_key);
 	if (!vgic_try_get_irq_kref(irq))
 		irq = NULL;
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	rcu_read_unlock();
 
 	return irq;
 }
@@ -605,14 +583,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (unlikely(list_empty(&dist->lpi_translation_cache)))
 		goto out;
 
-	/*
-	 * We could have raced with another CPU caching the same
-	 * translation behind our back, so let's check it is not in
-	 * already
-	 */
 	db = its->vgic_its_base + GITS_TRANSLATER;
-	if (__vgic_its_check_cache(dist, db, devid, eventid))
-		goto out;
 
 	/* Always reuse the last entry (LRU policy) */
 	cte = list_last_entry(&dist->lpi_translation_cache,
@@ -958,7 +929,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
-		if (id >= BIT_ULL(VITS_TYPER_DEVBITS))
+		if (id > VITS_MAX_DEVID)
 			return false;
 		break;
 	case GITS_BASER_TYPE_COLLECTION:
-- 
2.44.0.769.g3c40516874-goog


