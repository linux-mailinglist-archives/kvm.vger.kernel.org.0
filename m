Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7283E366400
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhDUDXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234913AbhDUDWv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hoojy8FYOBs7XLo+S/qLf7Fvtx0zhibi9/ME4wYJTig=;
        b=cmhqP0TQxawLYgwR9eD2MA3i4EgqjQuH3w+M3Ti6XBuVF+LVa9faXNhcrpxlU1cmkKYeHy
        2NwEAaYJcJGniup4cS6hP+aGLc17B2gmXKCGcQ75DsU4CE/StjZfD/dF/CwALCOuJrbi0h
        j2T3D/txDG1vX5ZnSrQxP+flc9JxskM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-sNW5xQT6NIOK9xVj046-AA-1; Tue, 20 Apr 2021 23:22:16 -0400
X-MC-Unique: sNW5xQT6NIOK9xVj046-AA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C83D6801984;
        Wed, 21 Apr 2021 03:22:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 860E16064B;
        Wed, 21 Apr 2021 03:22:04 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 6/7] virtio: use err label in __vring_new_virtqueue()
Date:   Wed, 21 Apr 2021 11:21:16 +0800
Message-Id: <20210421032117.5177-7-jasowang@redhat.com>
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using error label for unwind in __vring_new_virtqueue. This is useful
for future refacotring.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 11dfa0dc8ec1..9800f1c9ce4c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2137,10 +2137,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 
 	vq->split.desc_state = kmalloc_array(vring.num,
 			sizeof(struct vring_desc_state_split), GFP_KERNEL);
-	if (!vq->split.desc_state) {
-		kfree(vq);
-		return NULL;
-	}
+	if (!vq->split.desc_state)
+		goto err_state;
 
 	/* Put everything in free lists. */
 	vq->free_head = 0;
@@ -2151,6 +2149,10 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 
 	list_add_tail(&vq->vq.list, &vdev->vqs);
 	return &vq->vq;
+
+err_state:
+	kfree(vq);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
 
-- 
2.25.1

