Return-Path: <kvm+bounces-15561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BB98AD584
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788FE1C21222
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0C915539E;
	Mon, 22 Apr 2024 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XkcedJlE"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4BD15622E
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816147; cv=none; b=HN3zBvvTKmqf24VNh/qHsa6W46YS1rwiO1ogYe06nSN2nk6k9Nq/ANMZ/QJa8rHqF1fCklrZXhugR2nKZyU12Ay/hRu7y8CwwWuBwQNo87JwvzLB6cawQKi04iJEHnpLLaNmeBAjE5KPnc1suCv4q1IA3xAo4uvUzCz8PCR5rxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816147; c=relaxed/simple;
	bh=50IrnoFzd8fFsVs7HOhdKt/ApAyXFHJpCUSRqRNTTnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfrUhRlZgLYi6Gx1MzJMjFZfpcMvALN6VHtGtZlO9FfB8s6aYN2IM+drfscXeALduiVao0f6rxPwY8C5zZNIXQRgbYl/aBFaP59AhKC5j8NVTVnxReXYv2qqEu2Y90G07jCKOy8YwzcC2z1NxDIZRuW5aZrmeL05HLa61cUII5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XkcedJlE; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gLIsL1S94gAKC9UMyVFju+2u53ba3+G2tsBIszS8xtE=;
	b=XkcedJlEGYZdTpj8HiPiYtgSj9QiX732hqfZY5B4WF5LKkNYtM79+B61Q5TM3TngdIZ334
	q3gfWFZnauigWLtBchJT68Ic6EYIqMAt97MQebWW7ffUM587bHKtWjWu8YzaKgcFbl3RSm
	5ornkYbKtDG08yvKS/HACUiEBy77pBY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 07/19] KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
Date: Mon, 22 Apr 2024 20:01:46 +0000
Message-ID: <20240422200158.2606761-8-oliver.upton@linux.dev>
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

As the current LPI translation cache is global, the corresponding
invalidation helpers are also globally-scoped. In anticipation of
constructing a translation cache per ITS, add a helper for scoped cache
invalidations.

We still need to support global invalidations when LPIs are toggled on
a redistributor, as a property of the translation cache is that all
stored LPIs are known to be delieverable.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 46 ++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic.h         |  2 +-
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 441134ad674e..2caa30bf20c7 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -23,6 +23,8 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+static struct kvm_device_ops kvm_arm_vgic_its_ops;
+
 static int vgic_its_save_tables_v0(struct vgic_its *its);
 static int vgic_its_restore_tables_v0(struct vgic_its *its);
 static int vgic_its_commit_v0(struct vgic_its *its);
@@ -616,8 +618,9 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-void vgic_its_invalidate_cache(struct kvm *kvm)
+static void vgic_its_invalidate_cache(struct vgic_its *its)
 {
+	struct kvm *kvm = its->dev->kvm;
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
 	unsigned long flags;
@@ -639,6 +642,24 @@ void vgic_its_invalidate_cache(struct kvm *kvm)
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
+void vgic_its_invalidate_all_caches(struct kvm *kvm)
+{
+	struct kvm_device *dev;
+	struct vgic_its *its;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(dev, &kvm->devices, vm_node) {
+		if (dev->ops != &kvm_arm_vgic_its_ops)
+			continue;
+
+		its = dev->private;
+		vgic_its_invalidate_cache(its);
+	}
+
+	rcu_read_unlock();
+}
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq)
 {
@@ -826,7 +847,7 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
 		return 0;
@@ -863,7 +884,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = collection_to_vcpu(kvm, collection);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return update_affinity(ite->irq, vcpu);
 }
@@ -1110,7 +1131,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 }
 
 /* Requires the its_lock to be held. */
-static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
+static void vgic_its_free_device(struct kvm *kvm, struct vgic_its *its,
+				 struct its_device *device)
 {
 	struct its_ite *ite, *temp;
 
@@ -1122,7 +1144,7 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
 		its_free_ite(kvm, ite);
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	list_del(&device->dev_list);
 	kfree(device);
@@ -1134,7 +1156,7 @@ static void vgic_its_free_device_list(struct kvm *kvm, struct vgic_its *its)
 	struct its_device *cur, *temp;
 
 	list_for_each_entry_safe(cur, temp, &its->device_list, dev_list)
-		vgic_its_free_device(kvm, cur);
+		vgic_its_free_device(kvm, its, cur);
 }
 
 /* its lock must be held */
@@ -1193,7 +1215,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * by removing the mapping and re-establishing it.
 	 */
 	if (device)
-		vgic_its_free_device(kvm, device);
+		vgic_its_free_device(kvm, its, device);
 
 	/*
 	 * The spec does not say whether unmapping a not-mapped device
@@ -1224,7 +1246,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 	} else {
 		struct kvm_vcpu *vcpu;
 
@@ -1395,7 +1417,7 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		vgic_put_irq(kvm, irq);
 	}
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_cache(its);
 
 	return 0;
 }
@@ -1747,7 +1769,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 	if (!its->enabled)
-		vgic_its_invalidate_cache(kvm);
+		vgic_its_invalidate_cache(its);
 
 	/*
 	 * Try to process any pending commands. This function bails out early
@@ -1880,7 +1902,7 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte, *tmp;
 
-	vgic_its_invalidate_cache(kvm);
+	vgic_its_invalidate_all_caches(kvm);
 
 	list_for_each_entry_safe(cte, tmp,
 				 &dist->lpi_translation_cache, entry) {
@@ -2372,7 +2394,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 
 	ret = vgic_its_restore_itt(its, dev);
 	if (ret) {
-		vgic_its_free_device(its->dev->kvm, dev);
+		vgic_its_free_device(its->dev->kvm, its, dev);
 		return ret;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c15ee1df036a..a3983a631b5a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -277,7 +277,7 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 			return;
 
 		vgic_flush_pending_lpis(vcpu);
-		vgic_its_invalidate_cache(vcpu->kvm);
+		vgic_its_invalidate_all_caches(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
 	} else {
 		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 060dfd96b41f..e5cda1eb4bcf 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -337,7 +337,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
-void vgic_its_invalidate_cache(struct kvm *kvm);
+void vgic_its_invalidate_all_caches(struct kvm *kvm);
 
 /* GICv4.1 MMIO interface */
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
-- 
2.44.0.769.g3c40516874-goog


