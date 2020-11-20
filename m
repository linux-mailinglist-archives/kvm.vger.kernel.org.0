Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D029C2BB4A6
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 20:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgKTS4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 13:56:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728466AbgKTS4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 13:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605898600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTSVtxwsFfunaFRmsiJCHQSu2dQDXIap/g3V71hKaPI=;
        b=F9nhvc2IVK05wD3qnCCiNscMOhWYcpb0TqxjNLq+M9/9ZU89g0t597IdbfqkPYy8yGFsyT
        tsdcm0mEMFJGpw7Ec6mEUT1419A6b25NbefMPitsCxUheD/Hbbjv7kIwuyIHw3Gq5CEla+
        j19CGEmZA4/V/olEg0ty3owPsT1Il0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-xXhwUuTlODSMizKH-YZFMg-1; Fri, 20 Nov 2020 13:56:39 -0500
X-MC-Unique: xXhwUuTlODSMizKH-YZFMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4524A100C602;
        Fri, 20 Nov 2020 18:56:36 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-88.ams2.redhat.com [10.36.112.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A8FF5C1D5;
        Fri, 20 Nov 2020 18:56:12 +0000 (UTC)
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
Subject: [RFC PATCH 22/27] vhost: Add vhost_virtqueue_memory_map
Date:   Fri, 20 Nov 2020 19:51:00 +0100
Message-Id: <20201120185105.279030-23-eperezma@redhat.com>
In-Reply-To: <20201120185105.279030-1-eperezma@redhat.com>
References: <20201120185105.279030-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make it symmetric with _unmap.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost.c | 68 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index eafbbaa751..f640d4edf0 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -827,6 +827,42 @@ static void vhost_virtqueue_memory_unmap(struct vhost_dev *dev,
     }
 }
 
+static int vhost_virtqueue_memory_map(struct vhost_dev *dev,
+                                      struct vhost_virtqueue *vq,
+                                      unsigned int vhost_vq_index)
+{
+    int r;
+    hwaddr a, l, s;
+
+    a = vq->desc_phys;
+    s = l = vq->desc_size;
+    vq->desc = vhost_memory_map(dev, a, &l, false);
+    if (!vq->desc || l != s) {
+        return -ENOMEM;
+    }
+
+    a = vq->avail_phys;
+    s = l = vq->avail_size;
+    vq->avail = vhost_memory_map(dev, a, &l, false);
+    if (!vq->avail || l != s) {
+        return -ENOMEM;
+    }
+
+    a = vq->used_phys;
+    s = l = vq->used_size;
+    vq->used = vhost_memory_map(dev, a, &l, true);
+    if (!vq->used || l != s) {
+        return -ENOMEM;
+    }
+
+    r = vhost_virtqueue_set_addr(dev, vq, vhost_vq_index, dev->log_enabled);
+    if (r < 0) {
+        return -errno;
+    }
+
+    return 0;
+}
+
 static int vhost_dev_set_features(struct vhost_dev *dev,
                                   bool enable_log)
 {
@@ -1271,7 +1307,7 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
     BusState *qbus = BUS(qdev_get_parent_bus(DEVICE(vdev)));
     VirtioBusState *vbus = VIRTIO_BUS(qbus);
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(vbus);
-    hwaddr s, l, a;
+    hwaddr a;
     int r;
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_file file = {
@@ -1311,31 +1347,15 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
         }
     }
 
-    vq->desc_size = s = l = virtio_queue_get_desc_size(vdev, idx);
+    vq->desc_size = virtio_queue_get_desc_size(vdev, idx);
     vq->desc_phys = a;
-    vq->desc = vhost_memory_map(dev, a, &l, false);
-    if (!vq->desc || l != s) {
-        r = -ENOMEM;
-        goto fail_alloc;
-    }
-    vq->avail_size = s = l = virtio_queue_get_avail_size(vdev, idx);
-    vq->avail_phys = a = virtio_queue_get_avail_addr(vdev, idx);
-    vq->avail = vhost_memory_map(dev, a, &l, false);
-    if (!vq->avail || l != s) {
-        r = -ENOMEM;
-        goto fail_alloc;
-    }
-    vq->used_size = s = l = virtio_queue_get_used_size(vdev, idx);
-    vq->used_phys = a = virtio_queue_get_used_addr(vdev, idx);
-    vq->used = vhost_memory_map(dev, a, &l, true);
-    if (!vq->used || l != s) {
-        r = -ENOMEM;
-        goto fail_alloc;
-    }
+    vq->avail_size = virtio_queue_get_avail_size(vdev, idx);
+    vq->avail_phys = virtio_queue_get_avail_addr(vdev, idx);
+    vq->used_size = virtio_queue_get_used_size(vdev, idx);
+    vq->used_phys = virtio_queue_get_used_addr(vdev, idx);
 
-    r = vhost_virtqueue_set_addr(dev, vq, vhost_vq_index, dev->log_enabled);
-    if (r < 0) {
-        r = -errno;
+    r = vhost_virtqueue_memory_map(dev, vq, vhost_vq_index);
+    if (r) {
         goto fail_alloc;
     }
 
-- 
2.18.4

