Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798A92BB4A3
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgKTSzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729799AbgKTSzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZxEbXIS4zyXv2m5LGIw7P1HSVQ2S2HneDTGUSzuoD4=;
        b=gaezpIIcgD92Wl5AM82iwozS3ajF2dMW3DowHwHFa592D6GKwC4T50ETOyc1Az73HWAQGL
        lcEvQ9ZJ389sCTrxLctbeqEcxKW+p/qJ5yMP6GaswvT7kvHMBpC+XHkdmdRdg2IjTZMEpM
        isJW0ERJpAWEIX+it78SmmeOluC+LOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-TAvJhVXkPzytOL7DCgwuCw-1; Fri, 20 Nov 2020 13:55:46 -0500
X-MC-Unique: TAvJhVXkPzytOL7DCgwuCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A68DA8030A3;
        Fri, 20 Nov 2020 18:55:43 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 146EB5C1D5;
        Fri, 20 Nov 2020 18:55:30 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: [RFC PATCH 19/27] vhost: add vhost_vring_get_buf_rcu
Date:   Fri, 20 Nov 2020 19:50:57 +0100
Message-Id: <20201120185105.279030-20-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost-sw-lm-ring.h |  1 +
 hw/virtio/vhost-sw-lm-ring.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.h
index 03257d60c1..429a125558 100644
--- a/hw/virtio/vhost-sw-lm-ring.h
+++ b/hw/virtio/vhost-sw-lm-ring.h
@@ -19,6 +19,7 @@ typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
 
 bool vhost_vring_kick(VhostShadowVirtqueue *vq);
 int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem);
+VirtQueueElement *vhost_vring_get_buf_rcu(VhostShadowVirtqueue *vq, size_t sz);
 
 /* Called within rcu_read_lock().  */
 void vhost_vring_set_notification_rcu(VhostShadowVirtqueue *vq, bool enable);
diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index 3652889d8e..4fafd1b278 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -187,6 +187,35 @@ int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem)
     return 0;
 }
 
+VirtQueueElement *vhost_vring_get_buf_rcu(VhostShadowVirtqueue *vq, size_t sz)
+{
+    const vring_used_t *used = vq->vring.used;
+    VirtQueueElement *ret;
+    vring_used_elem_t used_elem;
+    uint16_t last_used;
+
+    if (!vhost_vring_poll_rcu(vq)) {
+        return NULL;
+    }
+
+    last_used = vq->used_idx & (vq->vring.num - 1);
+    used_elem.id = virtio_tswap32(vq->vdev, used->ring[last_used].id);
+    used_elem.len = virtio_tswap32(vq->vdev, used->ring[last_used].len);
+
+    if (unlikely(used_elem.id >= vq->vring.num)) {
+        virtio_error(vq->vdev, "Device says index %u is available",
+                     used_elem.id);
+        return NULL;
+    }
+
+    ret = vq->ring_id_maps[used_elem.id];
+    ret->len = used_elem.len;
+
+    vq->used_idx++;
+
+    return ret;
+}
+
 void vhost_vring_write_addr(const VhostShadowVirtqueue *vq,
                             struct vhost_vring_addr *addr)
 {
-- 
2.18.4

