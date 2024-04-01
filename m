Return-Path: <kvm+bounces-13292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C268945C8
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D56021C2158C
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273675490C;
	Mon,  1 Apr 2024 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVF1v1jc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B453453815
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712001255; cv=none; b=INoubG09n/1P/ZS3qwEFKtX+nc7PhLnd9wxfbdUAHP1k4OpbHeJwlePqOpVh7Jbi1ikKMah3lF+WFv3xGuWthaUtntFBU13U08YncxxWgV/B6ZmAW8oF5EaGZA5CHHVttacu90hSi0k9axcCiOMC7u3oNJ5wGAWee1QFoT2qo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712001255; c=relaxed/simple;
	bh=dIsv37sU5HBNzLY8lG5xYNtcRdTtNnWAM9pg9UrTHpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwd0N3gzpaDuBLM74ZHoUXLBYAXrPdgA4qcOM5o8B/nREu5BSGSnNxR+YkUKhRue/YUyl5GISW569OKQ5fx1Yp+K8gdc1RZmA1Fo1m9NEJerYr8SQ9I8+l7IjfX/qX+nuy8NNaBhYAPYmYyg0GZtMq3rxQ7Q8gjoyWCsj+GJSXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVF1v1jc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712001252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/uyDVxT4iwOoBDoCAwurlZPZi/G45C62gi5+EAdIGw=;
	b=EVF1v1jcgNoLtzAdFmnLXZuUSAJQcF61agLtTVGEp4xVe4pQtVfIkrgL9AfaaOlHAMn6s8
	b+jYYFKX1nK2v28mR7drgfp1fX+e5NnXx9wBrgEmJNfSnHy2Tk9cNH5i/xGD/9IDSGnsq4
	9H6mpomNbSlqnDE/Ei64AFmEjSHTFr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-KTuArTVRMou_zIFcBhy9qw-1; Mon, 01 Apr 2024 15:54:09 -0400
X-MC-Unique: KTuArTVRMou_zIFcBhy9qw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4713C851784;
	Mon,  1 Apr 2024 19:54:09 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.212])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB20E8177;
	Mon,  1 Apr 2024 19:54:08 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	reinette.chatre@intel.com
Subject: [PATCH 1/2] vfio/pci: Pass eventfd context to IRQ handler
Date: Mon,  1 Apr 2024 13:54:02 -0600
Message-ID: <20240401195406.3720453-2-alex.williamson@redhat.com>
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

Create a link back to the vfio_pci_core_device on the eventfd context
object to avoid lookups in the interrupt path.  The context is known
valid in the interrupt handler.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index fb5392b749ff..31dbc2d061f3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -23,11 +23,12 @@
 #include "vfio_pci_priv.h"
 
 struct vfio_pci_irq_ctx {
-	struct eventfd_ctx	*trigger;
-	struct virqfd		*unmask;
-	struct virqfd		*mask;
-	char			*name;
-	bool			masked;
+	struct vfio_pci_core_device	*vdev;
+	struct eventfd_ctx		*trigger;
+	struct virqfd			*unmask;
+	struct virqfd			*mask;
+	char				*name;
+	bool				masked;
 	struct irq_bypass_producer	producer;
 };
 
@@ -228,15 +229,11 @@ void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
-	struct vfio_pci_core_device *vdev = dev_id;
-	struct vfio_pci_irq_ctx *ctx;
+	struct vfio_pci_irq_ctx *ctx = dev_id;
+	struct vfio_pci_core_device *vdev = ctx->vdev;
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	ctx = vfio_irq_ctx_get(vdev, 0);
-	if (WARN_ON_ONCE(!ctx))
-		return ret;
-
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	if (!vdev->pci_2_3) {
@@ -282,6 +279,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	ctx->name = name;
 	ctx->trigger = trigger;
+	ctx->vdev = vdev;
 
 	/*
 	 * Fill the initial masked state based on virq_disabled.  After
@@ -312,7 +310,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
-			  irqflags, ctx->name, vdev);
+			  irqflags, ctx->name, ctx);
 	if (ret) {
 		vdev->irq_type = VFIO_PCI_NUM_IRQS;
 		kfree(name);
@@ -358,7 +356,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 	if (ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		free_irq(pdev->irq, vdev);
+		free_irq(pdev->irq, ctx);
 		if (ctx->trigger)
 			eventfd_ctx_put(ctx->trigger);
 		kfree(ctx->name);
-- 
2.44.0


