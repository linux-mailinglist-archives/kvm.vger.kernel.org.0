Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB542637D4A
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKXPxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKXPxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568F6132F77
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FrNEK9BW9vrejue8PJ2vXmvbvlWh0jBFggXf0s4JdU=;
        b=HCVbRT0Q/maavS8zsccV/9CeEDMMT7RWpf/Az88mQpWNxl93KS1zxko5JbH0lVgLjAyx6f
        Yw5xg3mrX3Ksfhjhe3zYpdbUCVLfArSFczugE9nwMr/XfJVmo3FmUMvaLh78VryPs/Mz13
        FU+qXqv2NdrMZhzXUbk7FqTQCZ8KM2s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-FPglt4DFOp2_Nqm4mCBFmg-1; Thu, 24 Nov 2022 10:52:20 -0500
X-MC-Unique: FPglt4DFOp2_Nqm4mCBFmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEBCE1C05B0F;
        Thu, 24 Nov 2022 15:52:19 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE661111DCE6;
        Thu, 24 Nov 2022 15:52:16 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Jason Wang <jasowang@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH for 8.0 v8 04/12] vhost: move iova_tree set to vhost_svq_start
Date:   Thu, 24 Nov 2022 16:51:50 +0100
Message-Id: <20221124155158.2109884-5-eperezma@redhat.com>
In-Reply-To: <20221124155158.2109884-1-eperezma@redhat.com>
References: <20221124155158.2109884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

