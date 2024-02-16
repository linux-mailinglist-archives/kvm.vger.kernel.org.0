Return-Path: <kvm+bounces-8898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B505B858584
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83F51C21523
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956451350ED;
	Fri, 16 Feb 2024 18:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRuFiYgz"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3AD13B2B0
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108938; cv=none; b=hH05fuf52irITPxQjJgc1DfZ8xpXHD5NRPQf4mUoRkE/eF26BCAS2trmtAFkUVKQCZuvlB4mpGI3bJX/nT7E4Ufwc+WxPYBTTnfOPLZZDNL9bV0SnGFdZ8Yc3pBeFSOn687cXtZRcUAsJUG8kACtrIOrFoHGl5vyC1llZoFZ558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108938; c=relaxed/simple;
	bh=D3m+FHFIaj+jhZ3odonI17F4V0pkUqn0ADel7SjBEng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNzcvm4Hd0ObsVT6+u10FPsIKMbNuvb++GU34WGNOlx3Cs/SDFvkk7Eqwyom89GPFPUWsW/SwX6H7CbziSB6Ea67VXGHa7eeC6BP15tMBkeZ+Ul5axTiSxXs6qAtuf4dDx4u5jOdvQhAhe8Q/Prw7xSiTX/yBPBMCIVEaDRjl2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRuFiYgz; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EffQNLJRTkroBiMKmKtexwMDjVwsGrj4DMlqwBeCnuY=;
	b=MRuFiYgzsOhaKh4Vv3717zkk2cwLeWkro5zgb5TFMYgHKAWwC/alTwHQuKZGS6PrsNNqhn
	yPzf5SIf86NlHT4vBoMmYoUHJPXFmatU9PQSIfZSJ154XjRNSNziyWYyhtideaooTXTpIW
	2gW16e1g78OLTxCsGrjj7DWuHLd9KJA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 05/10] KVM: arm64: vgic: Get rid of the LPI linked-list
Date: Fri, 16 Feb 2024 18:41:48 +0000
Message-ID: <20240216184153.2714504-6-oliver.upton@linux.dev>
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

All readers of LPI configuration have been transitioned to use the LPI
xarray. Get rid of the linked-list altogether.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 1 -
 arch/arm64/kvm/vgic/vgic-its.c  | 8 ++------
 arch/arm64/kvm/vgic/vgic.c      | 1 -
 include/kvm/arm_vgic.h          | 2 --
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 411719053107..e25672d6e846 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 9ce2edfadd11..0d1cfc776f47 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -58,7 +58,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		return ERR_PTR(ret);
 	}
 
-	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
 	raw_spin_lock_init(&irq->irq_lock);
 
@@ -74,10 +73,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * There could be a race with another vgic_add_lpi(), so we need to
 	 * check that we don't add a second list entry with the same LPI.
 	 */
-	list_for_each_entry(oldirq, &dist->lpi_list_head, lpi_list) {
-		if (oldirq->intid != intid)
-			continue;
-
+	oldirq = xa_load(&dist->lpi_xa, intid);
+	if (oldirq) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
@@ -99,7 +96,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
 	dist->lpi_list_count++;
 
 out_unlock:
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d90c42ff051d..e58ce68e325c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -121,7 +121,6 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	if (!kref_put(&irq->refcount, vgic_irq_release))
 		return;
 
-	list_del(&irq->lpi_list);
 	xa_erase(&dist->lpi_xa, irq->intid);
 	dist->lpi_list_count--;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 795b35656b54..aeff363e3ba6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -117,7 +117,6 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
-	struct list_head lpi_list;	/* Used to link all LPIs together */
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
@@ -277,7 +276,6 @@ struct vgic_dist {
 	/* Protects the lpi_list and the count value below. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
 	/* LPI translation cache */
-- 
2.44.0.rc0.258.g7320e95886-goog


