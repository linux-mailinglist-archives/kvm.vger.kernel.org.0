Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617D92BB4A5
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgKTS4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:56:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729114AbgKTS4S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VvYPxnElcsRqPRB3x32KT+7TZhu7baplHklcHyJ3ntU=;
        b=eQYOHYjLtpLUgXKMMaUZcjCc59Rx9qizh940KInVxW+mjOByhKyt+KHbSz3S4T2Ctm8t7C
        dRWBFKT1Sioz/tJLBudUY4UJMJzlXsTGlVm73zFp8AW50pvqDQO6Rw7gF2L+ayARNl3NDU
        kKczoV5eDN9SUNfN2Tvva6hFaI7rrdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-mtyRzA7kNwS9vj-lQSG9zQ-1; Fri, 20 Nov 2020 13:56:15 -0500
X-MC-Unique: mtyRzA7kNwS9vj-lQSG9zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1189184215D;
        Fri, 20 Nov 2020 18:56:11 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6785C1D5;
        Fri, 20 Nov 2020 18:55:53 +0000 (UTC)
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
Subject: [RFC PATCH 21/27] vhost: Add vhost_virtqueue_memory_unmap
Date:   Fri, 20 Nov 2020 19:50:59 +0100
Message-Id: <20201120185105.279030-22-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is not a huge gain but helps in later changes.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 9a3c580dcf..eafbbaa751 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -812,6 +812,21 @@ static int vhost_virtqueue_set_addr(struct vhost_dev *dev,
     return 0;
 }
 
+static void vhost_virtqueue_memory_unmap(struct vhost_dev *dev,
+                                        struct vhost_virtqueue *vq,
+                                        bool used_is_dirty)
+{
+    if (vq->used) {
+        vhost_memory_unmap(dev, vq->used, vq->used_size, used_is_dirty, 0);
+    }
+    if (vq->avail) {
+        vhost_memory_unmap(dev, vq->avail, vq->avail_size, 0, 0);
+    }
+    if (vq->desc) {
+        vhost_memory_unmap(dev, vq->desc, vq->desc_size, 0, 0);
+    }
+}
+
 static int vhost_dev_set_features(struct vhost_dev *dev,
                                   bool enable_log)
 {
@@ -1301,21 +1316,21 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
     vq->desc = vhost_memory_map(dev, a, &l, false);
     if (!vq->desc || l != s) {
         r = -ENOMEM;
-        goto fail_alloc_desc;
+        goto fail_alloc;
     }
     vq->avail_size = s = l = virtio_queue_get_avail_size(vdev, idx);
     vq->avail_phys = a = virtio_queue_get_avail_addr(vdev, idx);
     vq->avail = vhost_memory_map(dev, a, &l, false);
     if (!vq->avail || l != s) {
         r = -ENOMEM;
-        goto fail_alloc_avail;
+        goto fail_alloc;
     }
     vq->used_size = s = l = virtio_queue_get_used_size(vdev, idx);
     vq->used_phys = a = virtio_queue_get_used_addr(vdev, idx);
     vq->used = vhost_memory_map(dev, a, &l, true);
     if (!vq->used || l != s) {
         r = -ENOMEM;
-        goto fail_alloc_used;
+        goto fail_alloc;
     }
 
     r = vhost_virtqueue_set_addr(dev, vq, vhost_vq_index, dev->log_enabled);
@@ -1358,15 +1373,7 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
 fail_vector:
 fail_kick:
 fail_alloc:
-    vhost_memory_unmap(dev, vq->used, virtio_queue_get_used_size(vdev, idx),
-                       0, 0);
-fail_alloc_used:
-    vhost_memory_unmap(dev, vq->avail, virtio_queue_get_avail_size(vdev, idx),
-                       0, 0);
-fail_alloc_avail:
-    vhost_memory_unmap(dev, vq->desc, virtio_queue_get_desc_size(vdev, idx),
-                       0, 0);
-fail_alloc_desc:
+    vhost_virtqueue_memory_unmap(dev, vq, false);
     return r;
 }
 
@@ -1408,12 +1415,7 @@ static void vhost_virtqueue_stop(struct vhost_dev *dev,
                                                 vhost_vq_index);
     }
 
-    vhost_memory_unmap(dev, vq->used, virtio_queue_get_used_size(vdev, idx),
-                       1, virtio_queue_get_used_size(vdev, idx));
-    vhost_memory_unmap(dev, vq->avail, virtio_queue_get_avail_size(vdev, idx),
-                       0, virtio_queue_get_avail_size(vdev, idx));
-    vhost_memory_unmap(dev, vq->desc, virtio_queue_get_desc_size(vdev, idx),
-                       0, virtio_queue_get_desc_size(vdev, idx));
+    vhost_virtqueue_memory_unmap(dev, vq, true);
 }
 
 static void vhost_eventfd_add(MemoryListener *listener,
-- 
2.18.4

