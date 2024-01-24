Return-Path: <kvm+bounces-6870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C00C483B33F
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79801283AA5
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CED1350DD;
	Wed, 24 Jan 2024 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XcVgE3Vg"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802A21350CA
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129377; cv=none; b=CJInGtTUh0FE2EpgnEftOmRtSjaSS6CyOFOaH2wK1GUeTgTGDpzDILzo9aaiQ9KWAF0T0R1L5dk7n4fmItUkmQNhhV6wc+dx5ccKkcio7sryDJfE2sNrVhmsASAsKAjrkluE/h31HKY2QnupGwGbCpefD9W8EBUu8mQLCi3oxHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129377; c=relaxed/simple;
	bh=Yci9UjKWnyQCjg1gteyPivkD77+UxH3VnJgIayCPj4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK/OYcLJh3iI4GTr2sU7pdX0y0xrk6CS+lt9FEw5bKnYNoqbY0g5fUKU9zUisUFli3JfRX5FNwWESSMVDmoJBffO9LK8k2pYpg6LOh6ylapmmErvOsCJ1uuVsI95maTnfi/rNg7aatSrp6/03fYC8iqyrvg9f+fPMGXBKuFQCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XcVgE3Vg; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrQ+PVEC9XhGPAIG43CquUH33xiU8286LZeimDf+tfE=;
	b=XcVgE3VgULstQEd6lTi1Iv7You3egtz/rN9kfGrDlz3W7rAqPQKIIz1QetaUv4w8sd0kbc
	0ZduumdAP8sR03fdgB7AYV9ov9ti8tKwOb3Nl+c0mSRQEhBT3byFUHK6SVt2Xnkl/Ti5jN
	GwJ/1ZrumKK/p3h/6uLrK50NDKkNd0c=
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
Subject: [PATCH 06/15] KVM: arm64: vgic: Use atomics to count LPIs
Date: Wed, 24 Jan 2024 20:49:00 +0000
Message-ID: <20240124204909.105952-7-oliver.upton@linux.dev>
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

Switch to using atomics for LPI accounting, allowing vgic_irq references
to be dropped in parallel.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
 arch/arm64/kvm/vgic/vgic-its.c   | 4 ++--
 arch/arm64/kvm/vgic/vgic.c       | 2 +-
 include/kvm/arm_vgic.h           | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 85606a531dc3..389025ce7749 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -149,7 +149,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", dist->lpi_list_count);
+		seq_printf(s, "nr_lpis:\t%d\n", atomic_read(&dist->lpi_count));
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 0486d3779d11..1d912a595b71 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -97,7 +97,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		return ERR_PTR(ret);
 	}
 
-	dist->lpi_list_count++;
+	atomic_inc(&dist->lpi_count);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
@@ -342,7 +342,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	 * command). If coming from another path (such as enabling LPIs),
 	 * we must be careful not to overrun the array.
 	 */
-	irq_count = READ_ONCE(dist->lpi_list_count);
+	irq_count = atomic_read(&dist->lpi_count);
 	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
 	if (!intids)
 		return -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e58ce68e325c..5988d162b765 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -122,7 +122,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 		return;
 
 	xa_erase(&dist->lpi_xa, irq->intid);
-	dist->lpi_list_count--;
+	atomic_dec(&dist->lpi_count);
 
 	kfree(irq);
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 39037db3fa90..e944536feee8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -274,10 +274,10 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-	/* Protects the lpi_list and the count value below. */
+	/* Protects the lpi_list. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	int			lpi_list_count;
+	atomic_t		lpi_count;
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
-- 
2.43.0.429.g432eaa2c6b-goog


