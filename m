Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2F366401
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhDUDXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234921AbhDUDWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mS0TetjvxCDMuUNV8aEU6v82bOl3+AkJEPuBC10Vtms=;
        b=ElfFHUece5I1xlaDV+HIufikUKuf/6kMuhMCCdpiUFmqc2rIBh6+RcmOl8C2Cqh7tutMoB
        HbUEmfZZ/LQNV3Ykd62Xhipz8in5XVnSBXgFLWbbpd+ZwF0AnisA56z3rXVLYbl/UegPGq
        W/YWW9J7Snbxhy6HA2aOvkOAB0qWjQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-x5mlWzcKPc62bhpak8SifA-1; Tue, 20 Apr 2021 23:22:21 -0400
X-MC-Unique: x5mlWzcKPc62bhpak8SifA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73B92343A3;
        Wed, 21 Apr 2021 03:22:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56D986064B;
        Wed, 21 Apr 2021 03:22:15 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 7/7] virtio-ring: store DMA metadata in desc_extra for split virtqueue
Date:   Wed, 21 Apr 2021 11:21:17 +0800
Message-Id: <20210421032117.5177-8-jasowang@redhat.com>
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For split virtqueue, we used to depend on the address, length and
flags stored in the descriptor ring for DMA unmapping. This is unsafe
for the case when we don't trust the device since the device can tries
to manipulate the behavior of virtio driver and swiotlb.

For safety, maintain the DMA address, DMA length, descriptor flags and
next filed of the non indirect descriptors in vring_desc_state_extra
when DMA API is used for virtio as we did for packed virtqueue and use
those metadata for performing DMA operations. Indirect descriptors
should be safe since they are using streaming mappings.

For the device that doesn't use DMA API, the behavior which use
descriptor table is unchanged to minimize the performance impact.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 100 +++++++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 16 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9800f1c9ce4c..b53ceb65f9cf 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -130,6 +130,7 @@ struct vring_virtqueue {
 
 			/* Per-descriptor state. */
 			struct vring_desc_state_split *desc_state;
+			struct vring_desc_extra *desc_extra;
 
 			/* DMA address and size information */
 			dma_addr_t queue_dma_addr;
@@ -364,8 +365,8 @@ static int vring_mapping_error(const struct vring_virtqueue *vq,
  * Split ring specific functions - *_split().
  */
 
-static void vring_unmap_one_split(const struct vring_virtqueue *vq,
-				  struct vring_desc *desc)
+static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
+					   struct vring_desc *desc)
 {
 	u16 flags;
 
@@ -389,6 +390,35 @@ static void vring_unmap_one_split(const struct vring_virtqueue *vq,
 	}
 }
 
+static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
+					  unsigned int i)
+{
+	struct vring_desc_extra *extra = vq->split.desc_extra;
+	u16 flags;
+
+	if (!vq->use_dma_api)
+		goto out;
+
+	flags = extra[i].flags;
+
+	if (flags & VRING_DESC_F_INDIRECT) {
+		dma_unmap_single(vring_dma_dev(vq),
+				 extra[i].addr,
+				 extra[i].len,
+				 (flags & VRING_DESC_F_WRITE) ?
+				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	} else {
+		dma_unmap_page(vring_dma_dev(vq),
+			       extra[i].addr,
+			       extra[i].len,
+			       (flags & VRING_DESC_F_WRITE) ?
+			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	}
+
+out:
+	return extra[i].next;
+}
+
 static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
 					       unsigned int total_sg,
 					       gfp_t gfp)
@@ -417,13 +447,28 @@ static inline unsigned int virtqueue_add_desc_split(struct virtqueue *vq,
 						    unsigned int i,
 						    dma_addr_t addr,
 						    unsigned int len,
-						    u16 flags)
+						    u16 flags,
+						    bool trust)
 {
+	struct vring_virtqueue *vring = to_vvq(vq);
+	struct vring_desc_extra *extra = vring->split.desc_extra;
+	u16 next;
+
 	desc[i].flags = cpu_to_virtio16(vq->vdev, flags);
 	desc[i].addr = cpu_to_virtio64(vq->vdev, addr);
 	desc[i].len = cpu_to_virtio32(vq->vdev, len);
 
-	return virtio16_to_cpu(vq->vdev, desc[i].next);
+	if (!trust) {
+		next = extra[i].next;
+		desc[i].next = cpu_to_virtio16(vq->vdev, next);
+
+		extra[i].addr = addr;
+		extra[i].len = len;
+		extra[i].flags = flags;
+	} else
+		next = virtio16_to_cpu(vq->vdev, desc[i].next);
+
+	return next;
 }
 
 static inline int virtqueue_add_split(struct virtqueue *_vq,
@@ -499,8 +544,12 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 				goto unmap_release;
 
 			prev = i;
+			/* Note that we trust indirect descriptor
+			 * table since it use stream DMA mapping.
+			 */
 			i = virtqueue_add_desc_split(_vq, desc, i, addr, sg->length,
-						     VRING_DESC_F_NEXT);
+						     VRING_DESC_F_NEXT,
+						     indirect || !vq->use_dma_api);
 		}
 	}
 	for (; n < (out_sgs + in_sgs); n++) {
@@ -510,14 +559,21 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 				goto unmap_release;
 
 			prev = i;
+			/* Note that we trust indirect descriptor
+			 * table since it use stream DMA mapping.
+			 */
 			i = virtqueue_add_desc_split(_vq, desc, i, addr,
 						     sg->length,
 						     VRING_DESC_F_NEXT |
-						     VRING_DESC_F_WRITE);
+						     VRING_DESC_F_WRITE,
+						     indirect || !vq->use_dma_api);
 		}
 	}
 	/* Last one doesn't continue. */
 	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
+	if (!indirect && vq->use_dma_api)
+		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags =
+			~VRING_DESC_F_NEXT;
 
 	if (indirect) {
 		/* Now that the indirect table is filled in, map it. */
@@ -530,7 +586,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 		virtqueue_add_desc_split(_vq, vq->split.vring.desc,
 					 head, addr,
 					 total_sg * sizeof(struct vring_desc),
-			                 VRING_DESC_F_INDIRECT);
+					 VRING_DESC_F_INDIRECT,
+					 !vq->use_dma_api);
 	}
 
 	/* We're using some buffers from the free list. */
@@ -538,8 +595,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 
 	/* Update free pointer */
 	if (indirect)
-		vq->free_head = virtio16_to_cpu(_vq->vdev,
-					vq->split.vring.desc[head].next);
+		vq->free_head = vq->split.desc_extra[head].next;
 	else
 		vq->free_head = i;
 
@@ -584,8 +640,11 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	for (n = 0; n < total_sg; n++) {
 		if (i == err_idx)
 			break;
-		vring_unmap_one_split(vq, &desc[i]);
-		i = virtio16_to_cpu(_vq->vdev, desc[i].next);
+		if (indirect) {
+			vring_unmap_one_split_indirect(vq, &desc[i]);
+			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
+		} else
+			i = vring_unmap_one_split(vq, i);
 	}
 
 	if (indirect)
@@ -639,14 +698,15 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	i = head;
 
 	while (vq->split.vring.desc[i].flags & nextflag) {
-		vring_unmap_one_split(vq, &vq->split.vring.desc[i]);
-		i = virtio16_to_cpu(vq->vq.vdev, vq->split.vring.desc[i].next);
+		vring_unmap_one_split(vq, i);
+		i = vq->split.desc_extra[i].next;
 		vq->vq.num_free++;
 	}
 
-	vring_unmap_one_split(vq, &vq->split.vring.desc[i]);
+	vring_unmap_one_split(vq, i);
 	vq->split.vring.desc[i].next = cpu_to_virtio16(vq->vq.vdev,
 						vq->free_head);
+	vq->split.desc_extra[i].next = vq->free_head;
 	vq->free_head = head;
 
 	/* Plus final descriptor */
@@ -669,7 +729,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
 
 		for (j = 0; j < len / sizeof(struct vring_desc); j++)
-			vring_unmap_one_split(vq, &indir_desc[j]);
+			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
 
 		kfree(indir_desc);
 		vq->split.desc_state[head].indir_desc = NULL;
@@ -2140,6 +2200,10 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	if (!vq->split.desc_state)
 		goto err_state;
 
+	vq->split.desc_extra = vring_alloc_desc_extra(vq, vring.num);
+	if (!vq->split.desc_extra)
+		goto err_extra;
+
 	/* Put everything in free lists. */
 	vq->free_head = 0;
 	for (i = 0; i < vring.num-1; i++)
@@ -2150,6 +2214,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	return &vq->vq;
 
+err_extra:
+	kfree(vq->split.desc_state);
 err_state:
 	kfree(vq);
 	return NULL;
@@ -2233,8 +2299,10 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 					 vq->split.queue_dma_addr);
 		}
 	}
-	if (!vq->packed_ring)
+	if (!vq->packed_ring) {
 		kfree(vq->split.desc_state);
+		kfree(vq->split.desc_extra);
+	}
 	list_del(&_vq->list);
 	kfree(vq);
 }
-- 
2.25.1

