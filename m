Return-Path: <kvm+bounces-8902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C53385858C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31410282DF7
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CFD148313;
	Fri, 16 Feb 2024 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LlwyUY4z"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5349C1474BB
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108946; cv=none; b=ey/AGbOhWychN2BP+It/GgOoqzdH58y8PA162Eazdu5mGxU138GZx0PTlzZ/gm4M8W4bZ9LIj7x1uXfsfLuQmA0Rop0a/hQ/5G939/ttpPE2tgSBT5h7vwyb+JKLpZFeB3JWAp+6sitxU01SacHC0rpZVv62V5KTETfyaROioy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108946; c=relaxed/simple;
	bh=0+9hvpIMVuumxZZRLzdSlgvQCBBmw4uMTPz59W0JCTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+YPydUkAerk7qP8m/CJGvyTEztjJrZ0PejEvisHqqdjkAaP+LvEL13D7UnikWrC5bP64hTR6HE3JELLjyo9Eempn8LULANC3ut3lOVVcUyu7XCD8MWAeX/Q9MRJLT/jywO3OQ4FG7PH658Ip/g9s0RpeRCrCIJZUL3z8PR8loE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LlwyUY4z; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9exRx46WJAI7PPjinT5FzyCoHPJk8OWrIMcDrv8MJtA=;
	b=LlwyUY4zVt9oeDsGjl2cESfGbvcBUqxmU9X0jYGPlk4hY4xItlonwv/uzIe7LzX3lnVt68
	vFjohrhpxUXrXI6UrVnZG+79PnUpoPLOvYkHiYPA0HGpUNmt0TaFN81eGP5B8MddedUgPs
	NG/hqEjrnCXoUTbmcxfw3U94Vul/1e4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 09/10] KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
Date: Fri, 16 Feb 2024 18:41:52 +0000
Message-ID: <20240216184153.2714504-10-oliver.upton@linux.dev>
In-Reply-To: <20240216184153.2714504-1-oliver.upton@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
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
index 27a7451ad8b9..c3d1bca0b458 100644
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
 
@@ -609,8 +602,8 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	if (irq)
-		vgic_get_irq_kref(irq);
+	if (!vgic_try_get_irq_kref(irq))
+		irq = NULL;
 
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
@@ -656,6 +649,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
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
2.44.0.rc0.258.g7320e95886-goog


