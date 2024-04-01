Return-Path: <kvm+bounces-13291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB87C8945C7
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A71B0281D91
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BA9537EE;
	Mon,  1 Apr 2024 19:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvxGfDVu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D458D3A1C2
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712001254; cv=none; b=uh/UBER3llfwiU+fmqF0pLL7DyHKpSRaojPrwjvqwxHRbQFHvGeqnnfHvU/DmYl8dQbeLbi3o3vYw5afY1c+Y371cmU5tgSB7g8LE3po+ADrkEsiGgcJ1CtIa7vy7lw/ajDwJcoGPd3uCJeU9dpwEpDGXRphCEl4RexwIAVZJ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712001254; c=relaxed/simple;
	bh=scWXpCAT9dT7ypzrNF9sUQ6d/qzac4JOJZnG/vZg+6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPelW9ykOwO3vsRKdl2/UEJ8+B7S5QJK8kIiZy6VkrP6Uhs7cFiVE+/LrJoUD7bHZttn7o6W84pYKLjrTL8gLgFE6s2BLFo9xJzVtt4I4uaCN2yHDLnC0189yw8jtQ3tQpIjhu0RharFSL9MqBi9IMkBP6S0wFx2A4YY+e4AhgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvxGfDVu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712001251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krAekByOofHdP2r+nyjt4OOMwmwtcMCyd3rWh6waJ7g=;
	b=QvxGfDVunc8PsDkcfNPpBZtUMzFUHz4ZSmQNeyquClu7LIr1xl0242dEHCFncqtcW9ksqR
	aE56BKUEly6PfDRHiOG8fNQ4K+hUqcXUW13oZUqGPENIheuC5qYR8z2iFK6SOcjWWggWFz
	7da5idH0CkaBZIkKs53RYp3VZGQ60aM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-Zu2Ij7VjNVOwDclD1ztE_g-1; Mon,
 01 Apr 2024 15:54:10 -0400
X-MC-Unique: Zu2Ij7VjNVOwDclD1ztE_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0E833826110;
	Mon,  1 Apr 2024 19:54:09 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.212])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 605938CED;
	Mon,  1 Apr 2024 19:54:09 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	reinette.chatre@intel.com
Subject: [PATCH 2/2] vfio/pci: Pass eventfd context object through irqfd
Date: Mon,  1 Apr 2024 13:54:03 -0600
Message-ID: <20240401195406.3720453-3-alex.williamson@redhat.com>
In-Reply-To: <20240401195406.3720453-1-alex.williamson@redhat.com>
References: <20240401195406.3720453-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Further avoid lookup of the context object by passing it through the
irqfd data field.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 33 ++++++++++++-------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 31dbc2d061f3..d52825a096ad 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -85,19 +85,14 @@ vfio_irq_ctx_alloc(struct vfio_pci_core_device *vdev, unsigned long index)
 /*
  * INTx
  */
-static void vfio_send_intx_eventfd(void *opaque, void *unused)
+static void vfio_send_intx_eventfd(void *opaque, void *data)
 {
 	struct vfio_pci_core_device *vdev = opaque;
 
 	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
-		struct vfio_pci_irq_ctx *ctx;
-		struct eventfd_ctx *trigger;
+		struct vfio_pci_irq_ctx *ctx = data;
+		struct eventfd_ctx *trigger = READ_ONCE(ctx->trigger);
 
-		ctx = vfio_irq_ctx_get(vdev, 0);
-		if (WARN_ON_ONCE(!ctx))
-			return;
-
-		trigger = READ_ONCE(ctx->trigger);
 		if (likely(trigger))
 			eventfd_signal(trigger);
 	}
@@ -167,11 +162,11 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
  * a signal is necessary, which can then be handled via a work queue
  * or directly depending on the caller.
  */
-static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
+static int vfio_pci_intx_unmask_handler(void *opaque, void *data)
 {
 	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
-	struct vfio_pci_irq_ctx *ctx;
+	struct vfio_pci_irq_ctx *ctx = data;
 	unsigned long flags;
 	int ret = 0;
 
@@ -187,10 +182,6 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 		goto out_unlock;
 	}
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (WARN_ON_ONCE(!ctx))
-		goto out_unlock;
-
 	if (ctx->masked && !vdev->virq_disabled) {
 		/*
 		 * A pending interrupt here would immediately trigger,
@@ -214,10 +205,12 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 
 static void __vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
+
 	lockdep_assert_held(&vdev->igate);
 
-	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
-		vfio_send_intx_eventfd(vdev, NULL);
+	if (vfio_pci_intx_unmask_handler(vdev, ctx) > 0)
+		vfio_send_intx_eventfd(vdev, ctx);
 }
 
 void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
@@ -249,7 +242,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	if (ret == IRQ_HANDLED)
-		vfio_send_intx_eventfd(vdev, NULL);
+		vfio_send_intx_eventfd(vdev, ctx);
 
 	return ret;
 }
@@ -604,7 +597,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		if (fd >= 0)
 			return vfio_virqfd_enable((void *) vdev,
 						  vfio_pci_intx_unmask_handler,
-						  vfio_send_intx_eventfd, NULL,
+						  vfio_send_intx_eventfd, ctx,
 						  &ctx->unmask, fd);
 
 		vfio_virqfd_disable(&ctx->unmask);
@@ -671,11 +664,11 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_send_intx_eventfd(vdev, NULL);
+		vfio_send_intx_eventfd(vdev, vfio_irq_ctx_get(vdev, 0));
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t trigger = *(uint8_t *)data;
 		if (trigger)
-			vfio_send_intx_eventfd(vdev, NULL);
+			vfio_send_intx_eventfd(vdev, vfio_irq_ctx_get(vdev, 0));
 	}
 	return 0;
 }
-- 
2.44.0


