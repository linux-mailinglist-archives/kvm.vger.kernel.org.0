Return-Path: <kvm+bounces-8894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A0F85857B
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:42:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7AE1C21397
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9791B1369B0;
	Fri, 16 Feb 2024 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H/JVGd4/"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297441353EA
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108931; cv=none; b=oKrRaoqTYHUiLlylTobnnBMVNXyJE2rcNjnJQGmtHheXDp8QjmMVoFoIK0UD2uD8yzpupQOILcRhNQKoGq6/Lyzv2g0GgkCxRb585XQpn2XFuezFASnw6PjBOagBVfNlTHIeGO0QwsKvVodXMpTOEk4CFYVQjpWfvlfTkDAZ49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108931; c=relaxed/simple;
	bh=dH0k6IN0MHlaNID2kd6SHBELB8QrefZu66kvwU5n4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbP+XNs35cAGNolGVSj+M1Ll0/EGFPZdRHP9s8lMe4hb2VdSx/T2oCmKoxEfBdsL4ijRHqLcW9pF0BCXeBH0fwXqg2/oMdapiteVJo9uhf2BJeO4+4C+qaO3EbVZR60D/vKdhczJCuH7WQnADzjjIpznFHQyaZvHUYSF/uWI1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H/JVGd4/; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQ663bMVQErfiC1nnRDiwhyxZXGKefti52HAGa4Tyg4=;
	b=H/JVGd4/7Qq9RFnGveFyggh0J3Hiz/SYlGE4oLCu0pRw3RL+NYbIT9UL+2eGUevSFydFmQ
	PChqNQZt1fy48ANP9BQdYkMZZY2UaaMHjgyxXAX09BXBszi6N6AdOjz0n4yFyxssgBGdGf
	+wOUy0mYdWR1ebkABIDqrOxY2J1j9AU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
Date: Fri, 16 Feb 2024 18:41:44 +0000
Message-ID: <20240216184153.2714504-2-oliver.upton@linux.dev>
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

Using a linked-list for LPIs is less than ideal as it of course requires
iterative searches to find a particular entry. An xarray is a better
data structure for this use case, as it provides faster searches and can
still handle a potentially sparse range of INTID allocations.

Start by storing LPIs in an xarray, punting usage of the xarray to a
subsequent change.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c  | 16 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  1 +
 include/kvm/arm_vgic.h          |  2 ++
 4 files changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index e949e1d0fd9f..411719053107 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -56,6 +56,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
+	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
 }
 
 /* CREATION */
@@ -366,6 +367,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
+
+	xa_destroy(&dist->lpi_xa);
 }
 
 static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e2764d0ffa9f..fb2d3c356984 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -52,6 +52,12 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 
+	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(irq);
+		return ERR_PTR(ret);
+	}
+
 	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
 	raw_spin_lock_init(&irq->irq_lock);
@@ -86,12 +92,22 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
+	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
+	if (ret) {
+		xa_release(&dist->lpi_xa, intid);
+		kfree(irq);
+		goto out_unlock;
+	}
+
 	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
 	dist->lpi_list_count++;
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
+	if (ret)
+		return ERR_PTR(ret);
+
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index db2a95762b1b..c126014f8395 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -131,6 +131,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 		return;
 
 	list_del(&irq->lpi_list);
+	xa_erase(&dist->lpi_xa, irq->intid);
 	dist->lpi_list_count--;
 
 	kfree(irq);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cc38e836f54..795b35656b54 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
+#include <linux/xarray.h>
 #include <kvm/iodev.h>
 #include <linux/list.h>
 #include <linux/jump_label.h>
@@ -275,6 +276,7 @@ struct vgic_dist {
 
 	/* Protects the lpi_list and the count value below. */
 	raw_spinlock_t		lpi_list_lock;
+	struct xarray		lpi_xa;
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
-- 
2.44.0.rc0.258.g7320e95886-goog


