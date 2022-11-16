Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7961862C1CD
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 16:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiKPPHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 10:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiKPPHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 10:07:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8790931FAA
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 07:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668611181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuVSmmtk6tStl4tlJ6zRf9QVt9d6pPui6elY2DjbyVY=;
        b=MdzlqCccba/J/en9jAsAloOb2DIriAWA9ZS2voCrLNTDsBhZWfiR0bmjFfAQDZ/7eQhTGE
        PXDK72IAA+b1+RYgiAWnM5aBUQF4lbvUA6pOOgg/ulotDntQNHdVCb5AlLVV/8jLY1ZEdc
        gvRAq1fceL591trjdj5V0tU+ieXOq1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-9Lin8lTmPBqNakiiklHMAw-1; Wed, 16 Nov 2022 10:06:17 -0500
X-MC-Unique: 9Lin8lTmPBqNakiiklHMAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EB21185A7A8;
        Wed, 16 Nov 2022 15:06:17 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60E80140EBF3;
        Wed, 16 Nov 2022 15:06:13 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH for 8.0 v7 03/10] vhost: Allocate SVQ device file descriptors at device start
Date:   Wed, 16 Nov 2022 16:05:49 +0100
Message-Id: <20221116150556.1294049-4-eperezma@redhat.com>
In-Reply-To: <20221116150556.1294049-1-eperezma@redhat.com>
References: <20221116150556.1294049-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

Delay device file descriptors until we know it at device start.

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

