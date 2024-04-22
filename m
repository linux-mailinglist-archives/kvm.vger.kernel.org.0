Return-Path: <kvm+bounces-15560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E955D8AD583
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2397E1C20E61
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29325156666;
	Mon, 22 Apr 2024 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ci2LQg+m"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86D71553A9
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816146; cv=none; b=K9GWrDXnvz61sHiXpMC03KeoucHwHmZAW78hjQBlZNs7eS6EZ7eiQYh/MODPgSGJzRWEXspwvaUlF6goAiDGCZGKE81WpSCpABGU7zSL+Z4o+jwZp9yOHNXj701ue/FnyU8233XziqnZVxWT6yZE0thtVFbABlmVilLMSmiYbsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816146; c=relaxed/simple;
	bh=zG63o15LRk+e2MYjWHdaBOfQdW03SEcOdCMeWX/fSKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbEBgbr39T9Wb818OwDTwa1BshPOzzUCtUJFlIsNL4H0c2s512Pa0fpcYtNi5iBaBoxULZ30jDY/xOWLBag9ScXz6SVLxcrClK9Nm6yfp4Vd/Vo/3bdj9s1D48ZqPNhzYA8vk75pgkWdjpzxI636jKziQlbNzVaLY9iMmcidcJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ci2LQg+m; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14PdoBY6DBvxeFCDd7CHv10z+/kvHkQikySC0UlY6qc=;
	b=ci2LQg+mN/X2kWvZIgjCxagvwQ6g4zR3qS/VVa2iL9oRdNsASv2mTubMSVMVX8PQlDj+Et
	2hzjNGpigLcTcTkhjFitNchWI3d4EB+ppWKJVkvCx76HqKoBUG3nlPYNlKsAIV5farx8x8
	+H8LNGNvfVCO3Okbze5h+ofbLiINKEM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 06/19] KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
Date: Mon, 22 Apr 2024 20:01:45 +0000
Message-ID: <20240422200158.2606761-7-oliver.upton@linux.dev>
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

The last user has been transitioned to walking the LPI xarray directly.
Cut the wart off, and get rid of the now unneeded lpi_count while doing
so.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 48 ----------------------------------
 arch/arm64/kvm/vgic/vgic.c     |  1 -
 arch/arm64/kvm/vgic/vgic.h     |  1 -
 include/kvm/arm_vgic.h         |  1 -
 4 files changed, 51 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5025ac968d27..441134ad674e 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -86,11 +86,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	if (ret) {
 		xa_release(&dist->lpi_xa, intid);
 		kfree(irq);
-		goto out_unlock;
 	}
 
-	atomic_inc(&dist->lpi_count);
-
 out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
@@ -316,51 +313,6 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	return 0;
 }
 
-/*
- * Create a snapshot of the current LPIs targeting @vcpu, so that we can
- * enumerate those LPIs without holding any lock.
- * Returns their number and puts the kmalloc'ed array into intid_ptr.
- */
-int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	XA_STATE(xas, &dist->lpi_xa, GIC_LPI_OFFSET);
-	struct vgic_irq *irq;
-	unsigned long flags;
-	u32 *intids;
-	int irq_count, i = 0;
-
-	/*
-	 * There is an obvious race between allocating the array and LPIs
-	 * being mapped/unmapped. If we ended up here as a result of a
-	 * command, we're safe (locks are held, preventing another
-	 * command). If coming from another path (such as enabling LPIs),
-	 * we must be careful not to overrun the array.
-	 */
-	irq_count = atomic_read(&dist->lpi_count);
-	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
-	if (!intids)
-		return -ENOMEM;
-
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	rcu_read_lock();
-
-	xas_for_each(&xas, irq, VGIC_LPI_MAX_INTID) {
-		if (i == irq_count)
-			break;
-		/* We don't need to "get" the IRQ, as we hold the list lock. */
-		if (vcpu && irq->target_vcpu != vcpu)
-			continue;
-		intids[i++] = irq->intid;
-	}
-
-	rcu_read_unlock();
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
-	*intid_ptr = intids;
-	return i;
-}
-
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 4ec93587c8cd..e3ee1bc1214a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -126,7 +126,6 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	__xa_erase(&dist->lpi_xa, irq->intid);
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 
-	atomic_dec(&dist->lpi_count);
 	kfree_rcu(irq, rcu);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index e0c77e1bd9f6..060dfd96b41f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -331,7 +331,6 @@ static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
 }
 
 bool vgic_lpis_enabled(struct kvm_vcpu *vcpu);
-int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8eb72721dac1..ac7f15ec1586 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -279,7 +279,6 @@ struct vgic_dist {
 
 #define LPI_XA_MARK_DEBUG_ITER	XA_MARK_0
 	struct xarray		lpi_xa;
-	atomic_t		lpi_count;
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
-- 
2.44.0.769.g3c40516874-goog


