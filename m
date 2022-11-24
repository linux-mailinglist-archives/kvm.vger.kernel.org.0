Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7EA637D4B
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiKXPx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiKXPxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10F0131833
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLU39RtuBP+GapQRx/xyrSR9LCcfBeflobv1obIr0ZE=;
        b=LG9VsmmDGj/CI1qQ5byh/ccnKWJ5/DItylwPuKXgDuLd1IXg3tOZt/okt36aiFA80qYbNj
        C2VU2NBTwLrdvSDnOwuQuAGoklNnQaoWoHldIWdOWmYi2OuKg1gEhT2+ett274VS/CltSR
        uv9dr3rWs/cRXyXCiPzQavoOKZB7L2E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-CopEi7jLNsaV5SEWHQEFuA-1; Thu, 24 Nov 2022 10:52:17 -0500
X-MC-Unique: CopEi7jLNsaV5SEWHQEFuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 674341C05B0C;
        Thu, 24 Nov 2022 15:52:16 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E2A1111DCE8;
        Thu, 24 Nov 2022 15:52:13 +0000 (UTC)
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
Subject: [PATCH for 8.0 v8 03/12] vhost: allocate SVQ device file descriptors at device start
Date:   Thu, 24 Nov 2022 16:51:49 +0100
Message-Id: <20221124155158.2109884-4-eperezma@redhat.com>
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

The next patches will start control SVQ if possible. However, we don't
know if that will be possible at qemu boot anymore.

Delay device file descriptors until we know it at device start. This
will avoid to create them if the device does not support SVQ.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 31 ++------------------------
 hw/virtio/vhost-vdpa.c             | 35 ++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index 264ddc166d..3b05bab44d 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -715,43 +715,18 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
  * @iova_tree: Tree to perform descriptors translations
  * @ops: SVQ owner callbacks
  * @ops_opaque: ops opaque pointer
- *
- * Returns the new virtqueue or NULL.
- *
- * In case of error, reason is reported through error_report.
  */
 VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
                                     const VhostShadowVirtqueueOps *ops,
                                     void *ops_opaque)
 {
-    g_autofree VhostShadowVirtqueue *svq = g_new0(VhostShadowVirtqueue, 1);
-    int r;
-
-    r = event_notifier_init(&svq->hdev_kick, 0);
-    if (r != 0) {
-        error_report("Couldn't create kick event notifier: %s (%d)",
-                     g_strerror(errno), errno);
-        goto err_init_hdev_kick;
-    }
-
-    r = event_notifier_init(&svq->hdev_call, 0);
-    if (r != 0) {
-        error_report("Couldn't create call event notifier: %s (%d)",
-                     g_strerror(errno), errno);
-        goto err_init_hdev_call;
-    }
+    VhostShadowVirtqueue *svq = g_new0(VhostShadowVirtqueue, 1);
 
     event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
     svq->iova_tree = iova_tree;
     svq->ops = ops;
     svq->ops_opaque = ops_opaque;
-    return g_steal_pointer(&svq);
-
-err_init_hdev_call:
-    event_notifier_cleanup(&svq->hdev_kick);
-
-err_init_hdev_kick:
-    return NULL;
+    return svq;
 }
 
 /**
@@ -763,7 +738,5 @@ void vhost_svq_free(gpointer pvq)
 {
     VhostShadowVirtqueue *vq = pvq;
     vhost_svq_stop(vq);
-    event_notifier_cleanup(&vq->hdev_kick);
-    event_notifier_cleanup(&vq->hdev_call);
     g_free(vq);
 }
diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 7f0ff4df5b..3df2775760 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -428,15 +428,11 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
 
     shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
     for (unsigned n = 0; n < hdev->nvqs; ++n) {
-        g_autoptr(VhostShadowVirtqueue) svq;
+        VhostShadowVirtqueue *svq;
 
         svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
                             v->shadow_vq_ops_opaque);
-        if (unlikely(!svq)) {
-            error_setg(errp, "Cannot create svq %u", n);
-            return -1;
-        }
-        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
+        g_ptr_array_add(shadow_vqs, svq);
     }
 
     v->shadow_vqs = g_steal_pointer(&shadow_vqs);
@@ -864,11 +860,23 @@ static int vhost_vdpa_svq_set_fds(struct vhost_dev *dev,
     const EventNotifier *event_notifier = &svq->hdev_kick;
     int r;
 
+    r = event_notifier_init(&svq->hdev_kick, 0);
+    if (r != 0) {
+        error_setg_errno(errp, -r, "Couldn't create kick event notifier");
+        goto err_init_hdev_kick;
+    }
+
+    r = event_notifier_init(&svq->hdev_call, 0);
+    if (r != 0) {
+        error_setg_errno(errp, -r, "Couldn't create call event notifier");
+        goto err_init_hdev_call;
+    }
+
     file.fd = event_notifier_get_fd(event_notifier);
     r = vhost_vdpa_set_vring_dev_kick(dev, &file);
     if (unlikely(r != 0)) {
         error_setg_errno(errp, -r, "Can't set device kick fd");
-        return r;
+        goto err_init_set_dev_fd;
     }
 
     event_notifier = &svq->hdev_call;
@@ -876,8 +884,18 @@ static int vhost_vdpa_svq_set_fds(struct vhost_dev *dev,
     r = vhost_vdpa_set_vring_dev_call(dev, &file);
     if (unlikely(r != 0)) {
         error_setg_errno(errp, -r, "Can't set device call fd");
+        goto err_init_set_dev_fd;
     }
 
+    return 0;
+
+err_init_set_dev_fd:
+    event_notifier_set_handler(&svq->hdev_call, NULL);
+
+err_init_hdev_call:
+    event_notifier_cleanup(&svq->hdev_kick);
+
+err_init_hdev_kick:
     return r;
 }
 
@@ -1089,6 +1107,9 @@ static void vhost_vdpa_svqs_stop(struct vhost_dev *dev)
     for (unsigned i = 0; i < v->shadow_vqs->len; ++i) {
         VhostShadowVirtqueue *svq = g_ptr_array_index(v->shadow_vqs, i);
         vhost_vdpa_svq_unmap_rings(dev, svq);
+
+        event_notifier_cleanup(&svq->hdev_kick);
+        event_notifier_cleanup(&svq->hdev_call);
     }
 }
 
-- 
2.31.1

