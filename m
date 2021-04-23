Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A6B368E8E
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 10:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhDWILh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 04:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241494AbhDWILb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 04:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619165454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AbiiXanJPfz96ay/qiIqUUYDY4TZVIjkqLicSiV3UY4=;
        b=Qxn8dH5e0Gcz+jJOcH/4Vwkk/vZVrnt3b6paZgHNXUeta//4EY54XDNLiZhdn8tTpnd9kp
        h9OER97PRZGZeAQEI6cgJcSIU6+vcffdXQdVRvM7QLC++KZsR++Gl54feOd2y2M2rMkpDC
        +JpXRFxlRlj6RXIIZOe6uaDpfGlxfD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-7tMPmJ3NOxm71u2hmQMyvw-1; Fri, 23 Apr 2021 04:10:52 -0400
X-MC-Unique: 7tMPmJ3NOxm71u2hmQMyvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE8F318397AA;
        Fri, 23 Apr 2021 08:10:50 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-225.pek2.redhat.com [10.72.13.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D30365C5E0;
        Fri, 23 Apr 2021 08:10:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org
Subject: [RFC PATCH V2 4/7] virtio_ring: secure handling of mapping errors
Date:   Fri, 23 Apr 2021 16:09:39 +0800
Message-Id: <20210423080942.2997-5-jasowang@redhat.com>
In-Reply-To: <20210423080942.2997-1-jasowang@redhat.com>
References: <20210423080942.2997-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should not depend on the DMA address, length and flag of descriptor
table since they could be wrote with arbitrary value by the device. So
this patch switches to use the stored one in desc_extra.

Note that the indirect descriptors are fine since they are read-only
streaming mappings.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0cdd965dba58..5509c2643fb1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1213,13 +1213,16 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 unmap_release:
 	err_idx = i;
 	i = head;
+	curr = vq->free_head;
 
 	vq->packed.avail_used_flags = avail_used_flags;
 
 	for (n = 0; n < total_sg; n++) {
 		if (i == err_idx)
 			break;
-		vring_unmap_desc_packed(vq, &desc[i]);
+		vring_unmap_state_packed(vq,
+					 &vq->packed.desc_extra[curr]);
+		curr = vq->packed.desc_extra[curr].next;
 		i++;
 		if (i >= vq->packed.vring.num)
 			i = 0;
-- 
2.25.1

