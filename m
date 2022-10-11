Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9F5FB09A
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 12:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJKKmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 06:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJKKmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 06:42:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21A843634
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 03:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665484930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtxKFnWxYar2cgRx3GrYp3WJGhmrWZQWUyc94CiOZQI=;
        b=hYZhgGJXabpSoJRHR2TWcB5pGY/OE4mpO/l7EqyujwcytG/CYAKWO/NJl1pTQSUTCWPh56
        exaNt2L6MTRO8LgFa92rJOeGuqJ3xc5/skQrJpbIz2umZV+m2RTLP30JUMA56SJ7mF7vou
        FLxqUIXqUtdGzIbDGmMX77ajvG4p0Nw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-dv2X6QnjPzeSZfnb0bWTwA-1; Tue, 11 Oct 2022 06:42:07 -0400
X-MC-Unique: dv2X6QnjPzeSZfnb0bWTwA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02BA580280D;
        Tue, 11 Oct 2022 10:42:07 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5452492B09;
        Tue, 11 Oct 2022 10:42:03 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Cindy Lu <lulu@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Harpreet Singh Anand <hanand@xilinx.com>
Subject: [PATCH v5 2/6] vdpa: Allocate SVQ unconditionally
Date:   Tue, 11 Oct 2022 12:41:50 +0200
Message-Id: <20221011104154.1209338-3-eperezma@redhat.com>
In-Reply-To: <20221011104154.1209338-1-eperezma@redhat.com>
References: <20221011104154.1209338-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVQ may run or not in a device depending on runtime conditions (for
example, if the device can move CVQ to its own group or not).

Allocate the resources unconditionally, and decide later if to use them
or not.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost-vdpa.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 7f0ff4df5b..d966966131 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -410,6 +410,21 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
     int r;
     bool ok;
 
+    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
+    for (unsigned n = 0; n < hdev->nvqs; ++n) {
+        g_autoptr(VhostShadowVirtqueue) svq;
+
+        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
+                            v->shadow_vq_ops_opaque);
+        if (unlikely(!svq)) {
+            error_setg(errp, "Cannot create svq %u", n);
+            return -1;
+        }
+        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
+    }
+
+    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
+
     if (!v->shadow_vqs_enabled) {
         return 0;
     }
@@ -426,20 +441,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
         return -1;
     }
 
-    shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
-    for (unsigned n = 0; n < hdev->nvqs; ++n) {
-        g_autoptr(VhostShadowVirtqueue) svq;
-
-        svq = vhost_svq_new(v->iova_tree, v->shadow_vq_ops,
-                            v->shadow_vq_ops_opaque);
-        if (unlikely(!svq)) {
-            error_setg(errp, "Cannot create svq %u", n);
-            return -1;
-        }
-        g_ptr_array_add(shadow_vqs, g_steal_pointer(&svq));
-    }
-
-    v->shadow_vqs = g_steal_pointer(&shadow_vqs);
     return 0;
 }
 
@@ -580,10 +581,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev *dev)
     struct vhost_vdpa *v = dev->opaque;
     size_t idx;
 
-    if (!v->shadow_vqs) {
-        return;
-    }
-
     for (idx = 0; idx < v->shadow_vqs->len; ++idx) {
         vhost_svq_stop(g_ptr_array_index(v->shadow_vqs, idx));
     }
-- 
2.31.1

