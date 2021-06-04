Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E5839B22E
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 07:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFDF4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 01:56:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229794AbhFDF4B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 01:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622786055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdzRn3Pr0rYI0rGRBMCl0SRE17R3Lml0KXCJ6hRRlik=;
        b=MBAHHzbzrgbxANPUvBwVtbVCyStsgBMM8uG3anByIt1aSuASICedh3DDnh3sXZ0KuUzBrh
        wo5vvPM5qMeOq4io98CIYrC2cFoXbEQzRuuAibrxEe0JXJDUij2QZD4C7KKZpl4AvA3LEe
        XCqhcqiXzUIix/gXTkTkAi/qlYydX6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-MJ6-MkspMX-jJrtIKj1Mjg-1; Fri, 04 Jun 2021 01:54:12 -0400
X-MC-Unique: MJ6-MkspMX-jJrtIKj1Mjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94FC0801817;
        Fri,  4 Jun 2021 05:54:10 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D80695E26F;
        Fri,  4 Jun 2021 05:54:03 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com, luto@kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 1/7] virtio-ring: maintain next in extra state for packed virtqueue
Date:   Fri,  4 Jun 2021 13:53:44 +0800
Message-Id: <20210604055350.58753-2-jasowang@redhat.com>
In-Reply-To: <20210604055350.58753-1-jasowang@redhat.com>
References: <20210604055350.58753-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

