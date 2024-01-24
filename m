Return-Path: <kvm+bounces-6864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0AC83B338
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C856D28369A
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378051350EC;
	Wed, 24 Jan 2024 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bxCj97vD"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0871350D6
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129370; cv=none; b=LDKShtdUGHbOmGd2RAkc6tPiYvhDUPYTtMKPcJpyttk3/UVf6Zi/evCbW7dZApNQd0s+l8RcOAwRHHJBjmMwXoQzV3Psmgn/Nq2oQ9Jya0GwKNzvj4H2+6oLSe93VnuUCNbunbHMXWpGJTjaFGgMI5NADqtj3/YBc6uiGRAq8ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129370; c=relaxed/simple;
	bh=PdNfihDw36AYZxr6ju2QEwA0g69yapalLlGfGIOnoZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8fRPORK/ssOxQ0NrRclKFA60RReyjAJLQeH6ldnEXJlh1jNSF5L32stjloV+05uLLl58uLxM/FXnuLlGuBJk+UnBIU7v9HihhsmcDJnfNFrl+S180jfs08I0AsPO6SeZtBJBG7eWJaSOQMSaOma2mLjQrUJjLQ/OdOpCfowBDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bxCj97vD; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnI9sUjZ8H7mxRuV1VRi9CrF4BbT2F07UGflwBcqAWw=;
	b=bxCj97vDt8gAugnT3u4Gbfgyeju+jDaY6QCzqsEOwuHbQqhZNeUjQYcsuX26D1pHyl1fqs
	bl8c1LaPh9cN6VSRHPCDhQGt+UaDN47RpJloQuRnRYTaynPpXAzCcOGdwLov7xgiSmuWRT
	PthOCBvVCPqr+rjQCW4F6JanfNiNxnE=
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
Subject: [PATCH 01/15] KVM: arm64: vgic: Store LPIs in an xarray
Date: Wed, 24 Jan 2024 20:48:55 +0000
Message-ID: <20240124204909.105952-2-oliver.upton@linux.dev>
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

Using a linked-list for LPIs is less than ideal as it of course requires
iterative searches to find a particular entry. An xarray is a better
data structure for this use case, as it provides faster searches and can
still handle a potentially sparse range of INTID allocations.

Start by storing LPIs in an xarray, punting usage of the xarray to a
subsequent change.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c  | 13 +++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  1 +
 include/kvm/arm_vgic.h          |  2 ++
 4 files changed, 19 insertions(+)

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
index e2764d0ffa9f..f152d670113f 100644
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
@@ -86,6 +92,13 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
+	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
+	if (ret) {
+		xa_release(&dist->lpi_xa, intid);
+		kfree(irq);
+		return ERR_PTR(ret);
+	}
+
 	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
 	dist->lpi_list_count++;
 
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
2.43.0.429.g432eaa2c6b-goog


