Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2D2BB4A4
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgKTS4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729711AbgKTSz7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DG7n1lY/Hiobxg4WLGYVhL1ajHj2aBFA91adPYMLFP4=;
        b=hr5HywkecDV8lg6slb9GYi4eC8+cGgYIt5mw8mGL36uwboOhVFc/DITgOOouMoJxODCnfi
        Auzhom8Lleji2kQgkMUp+LlJXM98ltR50ASf3swHGMme/WFFHoZpVeUd7nTMvfpcbAx4r5
        X6pYqVgeY5DaP5R02UiN+6kiXTWd1M0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-twp43SyfNR6F-fyrLqtTQA-1; Fri, 20 Nov 2020 13:55:56 -0500
X-MC-Unique: twp43SyfNR6F-fyrLqtTQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7487C801B1E;
        Fri, 20 Nov 2020 18:55:53 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B4585C1D5;
        Fri, 20 Nov 2020 18:55:43 +0000 (UTC)
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
Subject: [RFC PATCH 20/27] vhost: Return used buffers
Date:   Fri, 20 Nov 2020 19:50:58 +0100
Message-Id: <20201120185105.279030-21-eperezma@redhat.com>
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
 hw/virtio/vhost-sw-lm-ring.h |  3 +++
 hw/virtio/vhost-sw-lm-ring.c | 14 +++++++----
 hw/virtio/vhost.c            | 46 +++++++++++++++++++++++++++++++++---
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.h
index 429a125558..0c4fa772c7 100644
--- a/hw/virtio/vhost-sw-lm-ring.h
+++ b/hw/virtio/vhost-sw-lm-ring.h
@@ -17,6 +17,9 @@
 
 typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
 
+VirtIODevice *vhost_vring_vdev(VhostShadowVirtqueue *svq);
+VirtQueue *vhost_vring_vdev_vq(VhostShadowVirtqueue *svq);
+
 bool vhost_vring_kick(VhostShadowVirtqueue *vq);
 int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem);
 VirtQueueElement *vhost_vring_get_buf_rcu(VhostShadowVirtqueue *vq, size_t sz);
diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index 4fafd1b278..244c722910 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -46,6 +46,16 @@ typedef struct VhostShadowVirtqueue {
     vring_desc_t descs[];
 } VhostShadowVirtqueue;
 
+VirtIODevice *vhost_vring_vdev(VhostShadowVirtqueue *svq)
+{
+    return svq->vdev;
+}
+
+VirtQueue *vhost_vring_vdev_vq(VhostShadowVirtqueue *svq)
+{
+    return svq->vq;
+}
+
 static bool vhost_vring_should_kick_rcu(VhostShadowVirtqueue *vq)
 {
     VirtIODevice *vdev = vq->vdev;
@@ -179,10 +189,6 @@ static int vhost_vring_add_split(VhostShadowVirtqueue *vq,
 int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem)
 {
     int host_head = vhost_vring_add_split(vq, elem);
-    if (vq->ring_id_maps[host_head]) {
-        g_free(vq->ring_id_maps[host_head]);
-    }
-
     vq->ring_id_maps[host_head] = elem;
     return 0;
 }
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index ac2bc14190..9a3c580dcf 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -986,17 +986,50 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, VirtQueue *vq)
     } while(!virtio_queue_empty(vq));
 }
 
+static void handle_sw_lm_vq_call(struct vhost_dev *hdev,
+                                 VhostShadowVirtqueue *svq)
+{
+    VirtQueueElement *elem;
+    VirtIODevice *vdev = vhost_vring_vdev(svq);
+    VirtQueue *vq = vhost_vring_vdev_vq(svq);
+    uint16_t idx = virtio_get_queue_index(vq);
+
+    RCU_READ_LOCK_GUARD();
+    /*
+     * Make used all buffers as possible.
+     */
+    do {
+        unsigned i = 0;
+
+        vhost_vring_set_notification_rcu(svq, false);
+        while (true) {
+            elem = vhost_vring_get_buf_rcu(svq, sizeof(*elem));
+            if (!elem) {
+                break;
+            }
+
+            assert(i < virtio_queue_get_num(vdev, idx));
+            virtqueue_fill(vq, elem, elem->len, i++);
+        }
+
+        virtqueue_flush(vq, i);
+        virtio_notify_irqfd(vdev, vq);
+
+        vhost_vring_set_notification_rcu(svq, true);
+    } while (vhost_vring_poll_rcu(svq));
+}
+
 static void vhost_handle_call(EventNotifier *n)
 {
     struct vhost_virtqueue *hvq = container_of(n,
                                               struct vhost_virtqueue,
                                               masked_notifier);
     struct vhost_dev *vdev = hvq->dev;
-    int idx = vdev->vq_index + (hvq == &vdev->vqs[0] ? 0 : 1);
-    VirtQueue *vq = virtio_get_queue(vdev->vdev, idx);
+    int idx = hvq == &vdev->vqs[0] ? 0 : 1;
+    VhostShadowVirtqueue *vq = vdev->sw_lm_shadow_vq[idx];
 
     if (event_notifier_test_and_clear(n)) {
-        virtio_notify_irqfd(vdev->vdev, vq);
+        handle_sw_lm_vq_call(vdev, vq);
     }
 }
 
@@ -1028,6 +1061,7 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
 
     for (idx = 0; idx < dev->nvqs; ++idx) {
         struct vhost_virtqueue *vq = &dev->vqs[idx];
+        unsigned num = virtio_queue_get_num(dev->vdev, idx);
         struct vhost_vring_addr addr = {
             .index = idx,
         };
@@ -1044,6 +1078,12 @@ static int vhost_sw_live_migration_start(struct vhost_dev *dev)
         r = dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
         assert(r == 0);
 
+        r = vhost_backend_update_device_iotlb(dev, addr.used_user_addr,
+                                              addr.used_user_addr,
+                                              sizeof(vring_used_elem_t) * num,
+                                              IOMMU_RW);
+        assert(r == 0);
+
         r = dev->vhost_ops->vhost_set_vring_base(dev, &s);
         assert(r == 0);
     }
-- 
2.18.4

