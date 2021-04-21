Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC36A3663FD
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 05:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhDUDW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 23:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234882AbhDUDWf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 23:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AbiiXanJPfz96ay/qiIqUUYDY4TZVIjkqLicSiV3UY4=;
        b=d8focXnKZQ8YR3m+rpvWP2W0MwXCUM4kqt2Xr2R2w1kN8w6au7YPyvytXdWBHeBJSBcsCm
        etrwnvDMtbzn7O7fWaTva2SwP96SaKxvp7fn/afkOgsJhl8VfP6iuMGaQK9RR6goWXU/kG
        tX0HuUgdgL3J/5nZ1DNVpDqJKKzn8iM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-kVxw3Ia9OT-ZVocFCigZRw-1; Tue, 20 Apr 2021 23:22:01 -0400
X-MC-Unique: kVxw3Ia9OT-ZVocFCigZRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74573343A3;
        Wed, 21 Apr 2021 03:21:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADFAE5B4A6;
        Wed, 21 Apr 2021 03:21:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: [RFC PATCH 4/7] virtio_ring: secure handling of mapping errors
Date:   Wed, 21 Apr 2021 11:21:14 +0800
Message-Id: <20210421032117.5177-5-jasowang@redhat.com>
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
References: <20210421032117.5177-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

