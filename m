Return-Path: <kvm+bounces-9266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D9585D002
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A901C20B54
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 05:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDE23D55B;
	Wed, 21 Feb 2024 05:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oJYMuUDa"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636773D0C8
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 05:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494220; cv=none; b=CjjMVuNy/Yk7Z5Sn7ol1C3lGQ6nIJlwYnCkId0qjpTk7doXPhS3X+ur7SpfQ6DZSZPj/iIX4rOigggSveZqm/bpHos8gasvVBj8/Lfhqshbb1ah2/FRwvu9uc0hX5eE968SK/oOo/7E+I8G9eLSCS++BZuHkWsBuPgvXdLPqtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494220; c=relaxed/simple;
	bh=ohZ5HNh3+AbhZtUPEYzsTEwYsRO0b4zg7BkWRCA1M6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX6dUhjfgPEjgsnJRgOhiwDVvh7Nmfr3pJVG5uhLSZSdNx3nFjOdUtCyz6FQMF5dixsjDMtElFmrZl+plircMN6wEXUDHTGaPVyd2ET8bvWRU/rlX8DSUDIfo7pwQU1YVu/Lwr+BCIOyOShSluQQ1a0XwtgLj9V61S6WmAOmevU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oJYMuUDa; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708494216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeMz6ixCWY/1TUllIvS9OwAED3X7tPlGIFKged/im1A=;
	b=oJYMuUDa4lorjzjLyP4W/y7ThUhnzjPTg1eB4MUsxt75hClMvcOy7W5XhtgPpwI/Z4vK9f
	Q2cvCYDT3VIRIO3EH6bfRd2UeplzRCqfbqNE5BAQq8jYAUnSfYsZMCdvCrM4hYZDZyHB3Q
	QI7HCZ7WCRhcFu35cRe8lW/4RIxoxpY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 09/10] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
Date: Wed, 21 Feb 2024 05:42:52 +0000
Message-ID: <20240221054253.3848076-10-oliver.upton@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
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
index 0be3c33676c3..dad6f0ee7c49 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -74,18 +74,11 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
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
 
@@ -611,8 +604,8 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (!vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
@@ -658,6 +651,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	if (cte->irq)
 		__vgic_put_lpi_locked(kvm, cte->irq);
 
+	/*
+	 * The irq refcount is guaranteed to be nonzero while holding the
+	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
+	 */
+	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
 	cte->db		= db;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 76abf3d946fe..df9e1aa1956c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -395,7 +395,8 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	/*
 	 * Grab a reference to the irq to reflect the fact that it is
-	 * now in the ap_list.
+	 * now in the ap_list. This is safe as the caller must already hold a
+	 * reference on the irq.
 	 */
 	vgic_get_irq_kref(irq);
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
-- 
2.44.0.rc0.258.g7320e95886-goog


