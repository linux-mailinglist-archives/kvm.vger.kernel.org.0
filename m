Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82483663F5
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbhDUDW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:22:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234730AbhDUDWV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Iy/gnaCvLxp4h+bVzLUI8j+eO2vvAPrkrWPiAFq8VY=;
        b=ZcssfHL1E9+4eHU32shjnojF3rO0y2aPstY3Lj7KT3Mee8VYUY/P3u5J+42IyRzhggccbQ
        Q2Yo3uMOLQtGkeKlw9//zaq5FjArHslltmfrx6OHTAo3ZggQg2bjYppC+cTeulk6UNK9sO
        8MpwnIZP4IDhOF7nWDjKLdEXLdqOd9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-tMhfc-cVNlqf6YP-srmgbg-1; Tue, 20 Apr 2021 23:21:44 -0400
X-MC-Unique: tMhfc-cVNlqf6YP-srmgbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBACC18397B2;
        Wed, 21 Apr 2021 03:21:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0DC45B4A6;
        Wed, 21 Apr 2021 03:21:38 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 2/7] virtio_ring: rename vring_desc_extra_packed
Date:   Wed, 21 Apr 2021 11:21:12 +0800
Message-Id: <20210421032117.5177-3-jasowang@redhat.com>
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vring_desc_extra_packed to vring_desc_extra since the structure
are pretty generic which could be reused by split virtqueue as well.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e1e9ed42e637..c25ea5776687 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -77,7 +77,7 @@ struct vring_desc_state_packed {
 	u16 last;			/* The last desc state in a list. */
 };
 
-struct vring_desc_extra_packed {
+struct vring_desc_extra {
 	dma_addr_t addr;		/* Buffer DMA addr. */
 	u32 len;			/* Buffer length. */
 	u16 flags;			/* Descriptor flags. */
@@ -166,7 +166,7 @@ struct vring_virtqueue {
 
 			/* Per-descriptor state. */
 			struct vring_desc_state_packed *desc_state;
-			struct vring_desc_extra_packed *desc_extra;
+			struct vring_desc_extra *desc_extra;
 
 			/* DMA address and size information */
 			dma_addr_t ring_dma_addr;
@@ -912,7 +912,7 @@ static struct virtqueue *vring_create_virtqueue_split(
  */
 
 static void vring_unmap_state_packed(const struct vring_virtqueue *vq,
-				     struct vring_desc_extra_packed *state)
+				     struct vring_desc_extra *state)
 {
 	u16 flags;
 
@@ -1651,13 +1651,13 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->free_head = 0;
 
 	vq->packed.desc_extra = kmalloc_array(num,
-			sizeof(struct vring_desc_extra_packed),
+			sizeof(struct vring_desc_extra),
 			GFP_KERNEL);
 	if (!vq->packed.desc_extra)
 		goto err_desc_extra;
 
 	memset(vq->packed.desc_extra, 0,
-		num * sizeof(struct vring_desc_extra_packed));
+		num * sizeof(struct vring_desc_extra));
 
 	for (i = 0; i < num - 1; i++)
 		vq->packed.desc_extra[i].next = i + 1;
-- 
2.25.1

