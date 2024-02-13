Return-Path: <kvm+bounces-8604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B13852C62
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8CCFB23E0A
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FACA4DA19;
	Tue, 13 Feb 2024 09:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jazLFqqx"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9453FE22
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816813; cv=none; b=FEXJ30ubxWoLIq4t8A6OMkTh4p1L9mI6kn5ZZklk7dllW5zU7iEhK7dai0wxazXX7MppnNAygiW1tMLjTX+DuPwLMMx/LxRiRbPRCe8rLDBf+9vUC1Nh19ao/4ErTz09PPmC3lSIEKzpBLC0oqtWtd0cTuFeohZPHhrfv02k8r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816813; c=relaxed/simple;
	bh=vk23VxPinLQAfnq8uTzaCqEThe7jwZl09foYlDKigqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCu0ARBnyL/Wes+Jz1XEEWihW9gk7cTJDoebUqL2EubS5Tq0QLVgr/qFr3QdU6aUDjNYgBObtEqdNvHfwqGWYOaS2BE8XWOI8DejU5vYc+olL+/4uc9DuGxo5EigonCPB2MWoEEX7cgy8PSBlF8mxnokHXt38RBfYpw1dXTijl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jazLFqqx; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw7Zntu0i50/45BH/WcBGp2LvuWwU+qxBI8D9y8HogY=;
	b=jazLFqqxgtjzkcxj1dc01Z4YBDKx8CvNw9zqpJpY6FjkPxtrbnhpejwlDxidZ7Kq8tXaXb
	91T712fapp4jgvLZo/42Dhp1S3DBz/2cpv3OwOdQj0XnYmVZ0aaLyrJYTAA/3WZmPadSn2
	l5iY+4M2h6Rg4VWGdqFUqZVxtbdv30g=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 10/23] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
Date: Tue, 13 Feb 2024 09:32:47 +0000
Message-ID: <20240213093250.3960069-11-oliver.upton@linux.dev>
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

It will soon be possible for get() and put() calls to happen in
parallel, which means in most cases we must ensure the refcount is
nonzero when taking a new reference. Switch to using
vgic_try_get_irq_kref() where necessary, and document the few conditions
where an IRQ's refcount is guaranteed to be nonzero.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 18 ++++++++----------
 arch/arm64/kvm/vgic/vgic.c     |  3 ++-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 048226812974..6b9634cec77f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -75,18 +75,11 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * check that we don't add a second list entry with the same LPI.
 	 */
 	oldirq = xa_load(&dist->lpi_xa, intid);
-	if (oldirq) {
+	if (vgic_try_get_irq_kref(oldirq)) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
 
-		/*
-		 * This increases the refcount, the caller is expected to
-		 * call vgic_put_irq() on the returned pointer once it's
-		 * finished with the IRQ.
-		 */
-		vgic_get_irq_kref(irq);
-
 		goto out_unlock;
 	}
 
@@ -610,8 +603,8 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (!vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
@@ -660,6 +653,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 		__vgic_put_lpi_locked(kvm, cte->irq);
 	}
 
+	/*
+	 * The irq refcount is guaranteed to be nonzero while holding the
+	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
+	 */
+	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
 	cte->db		= db;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 128ae53a0a55..2a288d6c0be7 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -394,7 +394,8 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	/*
 	 * Grab a reference to the irq to reflect the fact that it is
-	 * now in the ap_list.
+	 * now in the ap_list. This is safe as the caller must already hold a
+	 * reference on the irq.
 	 */
 	vgic_get_irq_kref(irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
-- 
2.43.0.687.g38aa6559b0-goog


