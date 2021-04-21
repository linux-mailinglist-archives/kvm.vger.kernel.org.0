Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5002C3663F3
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhDUDWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:22:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234707AbhDUDWT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdzRn3Pr0rYI0rGRBMCl0SRE17R3Lml0KXCJ6hRRlik=;
        b=R0Zxb8oR0rDMuGhyo2iPKkr65rLOIiFt00nwzy1hxtXiDipZvUpZ9RgMe1yNL1+W/cYGqN
        Uc5YQjQeuTwuQkP1FvK/a3ZjzbxxdnfqlN4d9tPac/KnAjB40vPuIFk7W/wZFJtVx7SBk9
        R/xwspIv+PBkXP8QsprUV8Sl9Sp66Y0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-0FUvAeeUNxqC5sFm2_2Kpg-1; Tue, 20 Apr 2021 23:21:39 -0400
X-MC-Unique: 0FUvAeeUNxqC5sFm2_2Kpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4842888EF23;
        Wed, 21 Apr 2021 03:21:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 120565B4A6;
        Wed, 21 Apr 2021 03:21:31 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 1/7] virtio-ring: maintain next in extra state for packed virtqueue
Date:   Wed, 21 Apr 2021 11:21:11 +0800
Message-Id: <20210421032117.5177-2-jasowang@redhat.com>
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch moves next from vring_desc_state_packed to
vring_desc_desc_extra_packed. This makes it simpler to let extra state
to be reused by split virtqueue.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..e1e9ed42e637 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -74,7 +74,6 @@ struct vring_desc_state_packed {
 	void *data;			/* Data for callback. */
 	struct vring_packed_desc *indir_desc; /* Indirect descriptor, if any. */
 	u16 num;			/* Descriptor list length. */
-	u16 next;			/* The next desc state in a list. */
 	u16 last;			/* The last desc state in a list. */
 };
 
@@ -82,6 +81,7 @@ struct vring_desc_extra_packed {
 	dma_addr_t addr;		/* Buffer DMA addr. */
 	u32 len;			/* Buffer length. */
 	u16 flags;			/* Descriptor flags. */
+	u16 next;			/* The next desc state in a list. */
 };
 
 struct vring_virtqueue {
@@ -1061,7 +1061,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 				1 << VRING_PACKED_DESC_F_USED;
 	}
 	vq->packed.next_avail_idx = n;
-	vq->free_head = vq->packed.desc_state[id].next;
+	vq->free_head = vq->packed.desc_extra[id].next;
 
 	/* Store token and indirect buffer state. */
 	vq->packed.desc_state[id].num = 1;
@@ -1169,7 +1169,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 					le16_to_cpu(flags);
 			}
 			prev = curr;
-			curr = vq->packed.desc_state[curr].next;
+			curr = vq->packed.desc_extra[curr].next;
 
 			if ((unlikely(++i >= vq->packed.vring.num))) {
 				i = 0;
@@ -1290,7 +1290,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 	/* Clear data ptr. */
 	state->data = NULL;
 
-	vq->packed.desc_state[state->last].next = vq->free_head;
+	vq->packed.desc_extra[state->last].next = vq->free_head;
 	vq->free_head = id;
 	vq->vq.num_free += state->num;
 
@@ -1299,7 +1299,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 		for (i = 0; i < state->num; i++) {
 			vring_unmap_state_packed(vq,
 				&vq->packed.desc_extra[curr]);
-			curr = vq->packed.desc_state[curr].next;
+			curr = vq->packed.desc_extra[curr].next;
 		}
 	}
 
@@ -1649,8 +1649,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
 
 	/* Put everything in free lists. */
 	vq->free_head = 0;
-	for (i = 0; i < num-1; i++)
-		vq->packed.desc_state[i].next = i + 1;
 
 	vq->packed.desc_extra = kmalloc_array(num,
 			sizeof(struct vring_desc_extra_packed),
@@ -1661,6 +1659,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	memset(vq->packed.desc_extra, 0,
 		num * sizeof(struct vring_desc_extra_packed));
 
+	for (i = 0; i < num - 1; i++)
+		vq->packed.desc_extra[i].next = i + 1;
+
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback) {
 		vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
-- 
2.25.1

