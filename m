Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB1B64DA61
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLOLeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiLOLdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6BD2EF64
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gReR1hVJf9xBAZ4Dw92F4r0+VgwswRVcL7qHrzE1ZSo=;
        b=Em0REwSjCZYGWcCvhf7K9oepOmBuOA7LmDeyKgmf6O9dgCUcAxCtimF24+XzJiUfV9qnAA
        MfhEhj4Lcdx2eeZog5KxJJtcAnTifx/hYXzi1IktYlESeTFOhMF02bSQjzTkr+tnBL72SA
        w4OMeSapQoC9AHU7PN4Fdjr/i3N6tfw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515--G33fKGmPU2LDUkGZFb7-g-1; Thu, 15 Dec 2022 06:32:07 -0500
X-MC-Unique: -G33fKGmPU2LDUkGZFb7-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81747858F09;
        Thu, 15 Dec 2022 11:32:06 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E1812166B26;
        Thu, 15 Dec 2022 11:32:02 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v9 04/12] vhost: move iova_tree set to vhost_svq_start
Date:   Thu, 15 Dec 2022 12:31:36 +0100
Message-Id: <20221215113144.322011-5-eperezma@redhat.com>
In-Reply-To: <20221215113144.322011-1-eperezma@redhat.com>
References: <20221215113144.322011-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we don't know if we will use SVQ at qemu initialization, let's
allocate iova_tree only if needed. To do so, accept it at SVQ start, not
at initialization.

This will avoid to create it if the device does not support SVQ.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/virtio/vhost-shadow-virtqueue.h | 5 ++---
 hw/virtio/vhost-shadow-virtqueue.c | 9 ++++-----
 hw/virtio/vhost-vdpa.c             | 5 ++---
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.h b/hw/virtio/vhost-shadow-virtqueue.h
index d04c34a589..926a4897b1 100644
--- a/hw/virtio/vhost-shadow-virtqueue.h
+++ b/hw/virtio/vhost-shadow-virtqueue.h
@@ -126,11 +126,10 @@ size_t vhost_svq_driver_area_size(const VhostShadowVirtqueue *svq);
 size_t vhost_svq_device_area_size(const VhostShadowVirtqueue *svq);
 
 void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
-                     VirtQueue *vq);
+                     VirtQueue *vq, VhostIOVATree *iova_tree);
 void vhost_svq_stop(VhostShadowVirtqueue *svq);
 
-VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
-                                    const VhostShadowVirtqueueOps *ops,
+VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
                                     void *ops_opaque);
 
 void vhost_svq_free(gpointer vq);
diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index 3b05bab44d..4307296358 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -642,9 +642,10 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueue *svq, int svq_kick_fd)
  * @svq: Shadow Virtqueue
  * @vdev: VirtIO device
  * @vq: Virtqueue to shadow
+ * @iova_tree: Tree to perform descriptors translations
  */
 void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
-                     VirtQueue *vq)
+                     VirtQueue *vq, VhostIOVATree *iova_tree)
 {
     size_t desc_size, driver_size, device_size;
 
@@ -655,6 +656,7 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
     svq->last_used_idx = 0;
     svq->vdev = vdev;
     svq->vq = vq;
+    svq->iova_tree = iova_tree;
 
     svq->vring.num = virtio_queue_get_num(vdev, virtio_get_queue_index(vq));
     driver_size = vhost_svq_driver_area_size(svq);
@@ -712,18 +714,15 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
  * Creates vhost shadow virtqueue, and instructs the vhost device to use the
  * shadow methods and file descriptors.
  *
- * @iova_tree: Tree to perform descriptors translations
  * @ops: SVQ owner callbacks
  * @ops_opaque: ops opaque pointer
  */
-VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
-                                    const VhostShadowVirtqueueOps *ops,
+VhostShadowVirtqueue *vhost_svq_new(const VhostShadowVirtqueueOps *ops,
                                     void *ops_opaque)
 {
     VhostShadowVirtqueue *svq = g_new0(VhostShadowVirtqueue, 1);
 
     event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
-    svq->iova_tree = iova_tree;
     svq->ops = ops;
     svq->ops_opaque = ops_opaque;
     return svq;
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 3df2775760..691bcc811a 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -430,8 +430,7 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
     for (unsigned n = 0; n < hdev->nvqs; ++n) {
         VhostShadowVirtqueue *svq;
 
-        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
-                            v->shadow_vq_ops_opaque);
+        svq = vhost_svq_new(v->shadow_vq_ops, v->shadow_vq_ops_opaque);
         g_ptr_array_add(shadow_vqs, svq);
     }
 
@@ -1063,7 +1062,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_dev *dev)
             goto err;
         }
 
-        vhost_svq_start(svq, dev->vdev, vq);
+        vhost_svq_start(svq, dev->vdev, vq, v->iova_tree);
         ok = vhost_vdpa_svq_map_rings(dev, svq, &addr, &err);
         if (unlikely(!ok)) {
             goto err_map;
-- 
2.31.1

