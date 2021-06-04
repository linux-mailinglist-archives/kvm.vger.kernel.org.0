Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016AA39B235
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 07:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFDF4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 01:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhFDF4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 01:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622786070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11TQ6i9OVoMbPFRqUnwUHbTRfc/PohdFDbCQomllfUE=;
        b=dDA/8tpdrqP2HJtCx0YR/ROEfV06zPs/GNciQZdo6pIB0n0ypg9hnMAsS72im+5jjFIu1K
        zUMMJ+e5fiGmC7qgbEZ8BM7aRG3YYlPR8vnuMydB46uBELD6sU6AXP24mfoK3VB+GVCuKC
        7JTELwJzsczRXSqBXjFPdGJMi4gYfBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-fXW_oB-uPKa9DV4LccIoBw-1; Fri, 04 Jun 2021 01:54:29 -0400
X-MC-Unique: fXW_oB-uPKa9DV4LccIoBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D606C180FD71;
        Fri,  4 Jun 2021 05:54:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C77EC5D9CC;
        Fri,  4 Jun 2021 05:54:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com, luto@kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 3/7] virtio-ring: factor out desc_extra allocation
Date:   Fri,  4 Jun 2021 13:53:46 +0800
Message-Id: <20210604055350.58753-4-jasowang@redhat.com>
In-Reply-To: <20210604055350.58753-1-jasowang@redhat.com>
References: <20210604055350.58753-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A helper is introduced for the logic of allocating the descriptor
extra data. This will be reused by split virtqueue.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c25ea5776687..0cdd965dba58 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1550,6 +1550,25 @@ static void *virtqueue_detach_unused_buf_packed(struct virtqueue *_vq)
 	return NULL;
 }
 
+static struct vring_desc_extra *vring_alloc_desc_extra(struct vring_virtqueue *vq,
+						       unsigned int num)
+{
+	struct vring_desc_extra *desc_extra;
+	unsigned int i;
+
+	desc_extra = kmalloc_array(num, sizeof(struct vring_desc_extra),
+				   GFP_KERNEL);
+	if (!desc_extra)
+		return NULL;
+
+	memset(desc_extra, 0, num * sizeof(struct vring_desc_extra));
+
+	for (i = 0; i < num - 1; i++)
+		desc_extra[i].next = i + 1;
+
+	return desc_extra;
+}
+
 static struct virtqueue *vring_create_virtqueue_packed(
 	unsigned int index,
 	unsigned int num,
@@ -1567,7 +1586,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	struct vring_packed_desc_event *driver, *device;
 	dma_addr_t ring_dma_addr, driver_event_dma_addr, device_event_dma_addr;
 	size_t ring_size_in_bytes, event_size_in_bytes;
-	unsigned int i;
 
 	ring_size_in_bytes = num * sizeof(struct vring_packed_desc);
 
@@ -1650,18 +1668,10 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	/* Put everything in free lists. */
 	vq->free_head = 0;
 
-	vq->packed.desc_extra = kmalloc_array(num,
-			sizeof(struct vring_desc_extra),
-			GFP_KERNEL);
+	vq->packed.desc_extra = vring_alloc_desc_extra(vq, num);
 	if (!vq->packed.desc_extra)
 		goto err_desc_extra;
 
-	memset(vq->packed.desc_extra, 0,
-		num * sizeof(struct vring_desc_extra));
-
-	for (i = 0; i < num - 1; i++)
-		vq->packed.desc_extra[i].next = i + 1;
-
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback) {
 		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
-- 
2.25.1

