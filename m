Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850DB2BB493
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbgKTSyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:54:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729175AbgKTSyg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBP6ZYk56FcgCXgaWqpbvzcgYqNFQcFTrZnQ3USZwTQ=;
        b=QLgW7ThkHg9++LdDA7A4xuZD2t4QbDVsCdYuwFze2SH/swZU6G8R/G1TWnKiHokSKv/9IG
        b+Kk9KVzl/mYk+elhAaPzolgrWMmv/2eszT3QYuOVBKO4v2E52V+ygGve1jp9O3Bc+8hwk
        MV5sRFzn7gAZp4t/zRQKlQvR/4rZVAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-lEeqo5FhPaaoSZsN_h9FbQ-1; Fri, 20 Nov 2020 13:54:31 -0500
X-MC-Unique: lEeqo5FhPaaoSZsN_h9FbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64E8B184215F;
        Fri, 20 Nov 2020 18:54:28 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD0785C1D5;
        Fri, 20 Nov 2020 18:54:08 +0000 (UTC)
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
Subject: [RFC PATCH 13/27] vhost: Send buffers to device
Date:   Fri, 20 Nov 2020 19:50:51 +0100
Message-Id: <20201120185105.279030-14-eperezma@redhat.com>
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
 hw/virtio/vhost-sw-lm-ring.h |   3 +
 hw/virtio/vhost-sw-lm-ring.c | 134 +++++++++++++++++++++++++++++++++--
 hw/virtio/vhost.c            |  59 ++++++++++++++-
 3 files changed, 189 insertions(+), 7 deletions(-)

diff --git a/hw/virtio/vhost-sw-lm-ring.h b/hw/virtio/vhost-sw-lm-ring.h
index 86dc081b93..29d21feaf4 100644
--- a/hw/virtio/vhost-sw-lm-ring.h
+++ b/hw/virtio/vhost-sw-lm-ring.h
@@ -18,6 +18,9 @@
 typedef struct VhostShadowVirtqueue VhostShadowVirtqueue;
 
 bool vhost_vring_kick(VhostShadowVirtqueue *vq);
+int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem);
+void vhost_vring_write_addr(const VhostShadowVirtqueue *vq,
+	                    struct vhost_vring_addr *addr);
 
 VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx);
 
diff --git a/hw/virtio/vhost-sw-lm-ring.c b/hw/virtio/vhost-sw-lm-ring.c
index cd7b5ba772..aed005c2d9 100644
--- a/hw/virtio/vhost-sw-lm-ring.c
+++ b/hw/virtio/vhost-sw-lm-ring.c
@@ -9,6 +9,7 @@
 
 #include "hw/virtio/vhost-sw-lm-ring.h"
 #include "hw/virtio/vhost.h"
+#include "hw/virtio/virtio-access.h"
 
 #include "standard-headers/linux/vhost_types.h"
 #include "standard-headers/linux/virtio_ring.h"
@@ -19,21 +20,140 @@ typedef struct VhostShadowVirtqueue {
     struct vring vring;
     EventNotifier hdev_notifier;
     VirtQueue *vq;
+    VirtIODevice *vdev;
+
+    /* Map for returning guest's descriptors */
+    VirtQueueElement **ring_id_maps;
+
+    /* Next head to expose to device */
+    uint16_t avail_idx_shadow;
+
+    /* Number of descriptors added since last notification */
+    uint16_t num_added;
+
+    /* Next free descriptor */
+    uint16_t free_head;
 
     vring_desc_t descs[];
 } VhostShadowVirtqueue;
 
-static inline bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
+static bool vhost_vring_should_kick_rcu(VhostShadowVirtqueue *vq)
 {
-    return virtio_queue_get_used_notify_split(vq->vq);
+    VirtIODevice *vdev = vq->vdev;
+    vq->num_added = 0;
+
+    smp_rmb();
+    return !(vq->vring.used->flags
+             & virtio_tswap16(vdev, VRING_USED_F_NO_NOTIFY));
 }
 
+static bool vhost_vring_should_kick(VhostShadowVirtqueue *vq)
+{
+    RCU_READ_LOCK_GUARD();
+    return vhost_vring_should_kick_rcu(vq);
+}
+
+
 bool vhost_vring_kick(VhostShadowVirtqueue *vq)
 {
     return vhost_vring_should_kick(vq) ? event_notifier_set(&vq->hdev_notifier)
                                        : true;
 }
 
+static void vhost_vring_write_descs(VhostShadowVirtqueue *vq,
+                                    const struct iovec *iovec,
+                                    size_t num, bool more_descs, bool write)
+{
+    uint16_t i = vq->free_head, last = vq->free_head;
+    unsigned n;
+    const VirtIODevice *vdev = vq->vdev;
+    uint16_t flags = write ? virtio_tswap16(vdev, VRING_DESC_F_WRITE) : 0;
+    vring_desc_t *descs = vq->vring.desc;
+
+    if (num == 0) {
+        return;
+    }
+
+    for (n = 0; n < num; n++) {
+        if (more_descs || (n + 1 < num)) {
+            descs[i].flags = flags | virtio_tswap16(vdev, VRING_DESC_F_NEXT);
+        } else {
+            descs[i].flags = flags;
+        }
+        descs[i].addr = virtio_tswap64(vdev, (hwaddr)iovec[n].iov_base);
+        descs[i].len = virtio_tswap32(vdev, iovec[n].iov_len);
+
+        last = i;
+        i = virtio_tswap16(vdev, descs[i].next);
+    }
+
+    vq->free_head = virtio_tswap16(vdev, descs[last].next);
+}
+
+/* virtqueue_add:
+ * @vq: The #VirtQueue
+ * @elem: The #VirtQueueElement
+ *
+ * Add an avail element to a virtqueue.
+ */
+static int vhost_vring_add_split(VhostShadowVirtqueue *vq,
+                                 const VirtQueueElement *elem)
+{
+    int head;
+    unsigned avail_idx;
+    const VirtIODevice *vdev;
+    vring_avail_t *avail;
+
+    RCU_READ_LOCK_GUARD();
+    vdev = vq->vdev;
+    avail = vq->vring.avail;
+
+    head = vq->free_head;
+
+    /* We need some descriptors here */
+    assert(elem->out_num || elem->in_num);
+
+    vhost_vring_write_descs(vq, elem->out_sg, elem->out_num,
+                   elem->in_num > 0, false);
+    vhost_vring_write_descs(vq, elem->in_sg, elem->in_num, false, true);
+
+    /* Put entry in available array (but don't update avail->idx until they
+     * do sync). */
+    avail_idx = vq->avail_idx_shadow & (vq->vring.num - 1);
+    avail->ring[avail_idx] = virtio_tswap16(vdev, head);
+    vq->avail_idx_shadow++;
+
+    /* Expose descriptors to device */
+    smp_wmb();
+    avail->idx = virtio_tswap16(vdev, vq->avail_idx_shadow);
+
+    /* threoretically possible. Kick just in case */
+    if (unlikely(vq->num_added++ == (uint16_t)-1)) {
+        vhost_vring_kick(vq);
+    }
+
+    return head;
+}
+
+int vhost_vring_add(VhostShadowVirtqueue *vq, VirtQueueElement *elem)
+{
+    int host_head = vhost_vring_add_split(vq, elem);
+    if (vq->ring_id_maps[host_head]) {
+        g_free(vq->ring_id_maps[host_head]);
+    }
+
+    vq->ring_id_maps[host_head] = elem;
+    return 0;
+}
+
+void vhost_vring_write_addr(const VhostShadowVirtqueue *vq,
+                            struct vhost_vring_addr *addr)
+{
+    addr->desc_user_addr = (uint64_t)vq->vring.desc;
+    addr->avail_user_addr = (uint64_t)vq->vring.avail;
+    addr->used_user_addr = (uint64_t)vq->vring.used;
+}
+
 VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
 {
     struct vhost_vring_file file = {
@@ -43,9 +163,11 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
     unsigned num = virtio_queue_get_num(dev->vdev, idx);
     size_t ring_size = vring_size(num, VRING_DESC_ALIGN_SIZE);
     VhostShadowVirtqueue *svq;
-    int r;
+    int r, i;
 
     svq = g_malloc0(sizeof(*svq) + ring_size);
+    svq->ring_id_maps = g_new0(VirtQueueElement *, num);
+    svq->vdev = dev->vdev;
     svq->vq = vq;
 
     r = event_notifier_init(&svq->hdev_notifier, 0);
@@ -55,8 +177,9 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
     r = dev->vhost_ops->vhost_set_vring_kick(dev, &file);
     assert(r == 0);
 
-    vhost_virtqueue_mask(dev, dev->vdev, idx, true);
-    vhost_virtqueue_pending(dev, idx);
+    vring_init(&svq->vring, num, svq->descs, VRING_DESC_ALIGN_SIZE);
+    for (i = 0; i < num - 1; i++)
+        svq->descs[i].next = virtio_tswap16(dev->vdev, i + 1);
 
     return svq;
 }
@@ -64,5 +187,6 @@ VhostShadowVirtqueue *vhost_sw_lm_shadow_vq(struct vhost_dev *dev, int idx)
 void vhost_sw_lm_shadow_vq_free(VhostShadowVirtqueue *vq)
 {
     event_notifier_cleanup(&vq->hdev_notifier);
+    g_free(vq->ring_id_maps);
     g_free(vq);
 }
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 9352c56bfa..304e0baa61 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -956,8 +956,34 @@ static void handle_sw_lm_vq(VirtIODevice *vdev, VirtQueue *vq)
     uint16_t idx = virtio_get_queue_index(vq);
 
     VhostShadowVirtqueue *svq = hdev->sw_lm_shadow_vq[idx];
+    VirtQueueElement *elem;
 
-    vhost_vring_kick(svq);
+    /*
+     * Make available all buffers as possible.
+     */
+    do {
+        if (virtio_queue_get_notification(vq)) {
+            virtio_queue_set_notification(vq, false);
+        }
+
+        while (true) {
+            int r;
+            if (virtio_queue_full(vq)) {
+                break;
+            }
+
+            elem = virtqueue_pop(vq, sizeof(*elem));
+            if (!elem) {
+                break;
+            }
+
+            r = vhost_vring_add(svq, elem);
+            assert(r >= 0);
+            vhost_vring_kick(svq);
+        }
+
+        virtio_queue_set_notification(vq, true);
+    } while(!virtio_queue_empty(vq));
 }
 
 static void vhost_handle_call(EventNotifier *n)
@@ -975,6 +1001,11 @@ static void vhost_handle_call(EventNotifier *n)
     }
 }
 
+static void vhost_virtqueue_stop(struct vhost_dev *dev,
+                                 struct VirtIODevice *vdev,
+                                 struct vhost_virtqueue *vq,
+                                 unsigned idx);
+
 static int vhost_sw_live_migration_stop(struct vhost_dev *dev)
 {
     int idx;
@@ -991,17 +1022,41 @@ static int vhost_sw_live_migration_stop(struct vhost_dev *dev)
 
 static int vhost_sw_live_migration_start(struct vhost_dev *dev)
 {
-    int idx;
+    int idx, r;
+
+    assert(dev->vhost_ops->vhost_set_vring_enable);
+    dev->vhost_ops->vhost_set_vring_enable(dev, false);
 
     for (idx = 0; idx < dev->nvqs; ++idx) {
         struct vhost_virtqueue *vq = &dev->vqs[idx];
+        struct vhost_vring_addr addr = {
+            .index = idx,
+        };
+        struct vhost_vring_state s = {
+            .index = idx,
+        };
+
+        vhost_virtqueue_stop(dev, dev->vdev, &dev->vqs[idx], idx);
 
         dev->sw_lm_shadow_vq[idx] = vhost_sw_lm_shadow_vq(dev, idx);
         event_notifier_set_handler(&vq->masked_notifier, vhost_handle_call);
+
+        vhost_vring_write_addr(dev->sw_lm_shadow_vq[idx], &addr);
+        r = dev->vhost_ops->vhost_set_vring_addr(dev, &addr);
+        assert(r == 0);
+
+        r = dev->vhost_ops->vhost_set_vring_base(dev, &s);
+        assert(r == 0);
     }
 
+    dev->vhost_ops->vhost_set_vring_enable(dev, true);
     vhost_dev_disable_notifiers(dev, dev->vdev);
 
+    for (idx = 0; idx < dev->nvqs; ++idx) {
+        vhost_virtqueue_mask(dev, dev->vdev, idx, true);
+        vhost_virtqueue_pending(dev, idx);
+    }
+
     return 0;
 }
 
-- 
2.18.4

