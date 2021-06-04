Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529DD39B23F
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 07:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFDF4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 01:56:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhFDF4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 01:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622786088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pueseaxcZOwlP6qfuGPWprIWYCt1cs/IoMkOSoirRnc=;
        b=e/Nt80wkAbUC0wSfGrca2r527U9xDA0rkxDRg4+wRSZxQkLlWnBtJB0f+oGPRTYW3MU9vy
        z9I+CN7Vox0ZvGBa421ShdBPovdPI3XPuuVbBuy+pngX3quxyaVHPwis8wg8jEl5RXQz+e
        MksOZIRxhgZ5FxuUmDf8lVKrqj+xMKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-JS9x8z55MG6idP8Pa9MdVQ-1; Fri, 04 Jun 2021 01:54:46 -0400
X-MC-Unique: JS9x8z55MG6idP8Pa9MdVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCFC518C;
        Fri,  4 Jun 2021 05:54:45 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F2D55D9CC;
        Fri,  4 Jun 2021 05:54:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com, luto@kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5/7] virtio_ring: introduce virtqueue_desc_add_split()
Date:   Fri,  4 Jun 2021 13:53:48 +0800
Message-Id: <20210604055350.58753-6-jasowang@redhat.com>
In-Reply-To: <20210604055350.58753-1-jasowang@redhat.com>
References: <20210604055350.58753-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces a helper for storing descriptor in the
descriptor table for split virtqueue.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 39 ++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5509c2643fb1..11dfa0dc8ec1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -412,6 +412,20 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
 	return desc;
 }
 
+static inline unsigned int virtqueue_add_desc_split(struct virtqueue *vq,
+						    struct vring_desc *desc,
+						    unsigned int i,
+						    dma_addr_t addr,
+						    unsigned int len,
+						    u16 flags)
+{
+	desc[i].flags = cpu_to_virtio16(vq->vdev, flags);
+	desc[i].addr = cpu_to_virtio64(vq->vdev, addr);
+	desc[i].len = cpu_to_virtio32(vq->vdev, len);
+
+	return virtio16_to_cpu(vq->vdev, desc[i].next);
+}
+
 static inline int virtqueue_add_split(struct virtqueue *_vq,
 				      struct scatterlist *sgs[],
 				      unsigned int total_sg,
@@ -484,11 +498,9 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			if (vring_mapping_error(vq, addr))
 				goto unmap_release;
 
-			desc[i].flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_NEXT);
-			desc[i].addr = cpu_to_virtio64(_vq->vdev, addr);
-			desc[i].len = cpu_to_virtio32(_vq->vdev, sg->length);
 			prev = i;
-			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
+			i = virtqueue_add_desc_split(_vq, desc, i, addr, sg->length,
+						     VRING_DESC_F_NEXT);
 		}
 	}
 	for (; n < (out_sgs + in_sgs); n++) {
@@ -497,11 +509,11 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			if (vring_mapping_error(vq, addr))
 				goto unmap_release;
 
-			desc[i].flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_NEXT | VRING_DESC_F_WRITE);
-			desc[i].addr = cpu_to_virtio64(_vq->vdev, addr);
-			desc[i].len = cpu_to_virtio32(_vq->vdev, sg->length);
 			prev = i;
-			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
+			i = virtqueue_add_desc_split(_vq, desc, i, addr,
+						     sg->length,
+						     VRING_DESC_F_NEXT |
+						     VRING_DESC_F_WRITE);
 		}
 	}
 	/* Last one doesn't continue. */
@@ -515,13 +527,10 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 		if (vring_mapping_error(vq, addr))
 			goto unmap_release;
 
-		vq->split.vring.desc[head].flags = cpu_to_virtio16(_vq->vdev,
-				VRING_DESC_F_INDIRECT);
-		vq->split.vring.desc[head].addr = cpu_to_virtio64(_vq->vdev,
-				addr);
-
-		vq->split.vring.desc[head].len = cpu_to_virtio32(_vq->vdev,
-				total_sg * sizeof(struct vring_desc));
+		virtqueue_add_desc_split(_vq, vq->split.vring.desc,
+					 head, addr,
+					 total_sg * sizeof(struct vring_desc),
+			                 VRING_DESC_F_INDIRECT);
 	}
 
 	/* We're using some buffers from the free list. */
-- 
2.25.1

