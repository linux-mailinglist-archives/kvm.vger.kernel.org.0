Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAF64DA68
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLOLeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiLOLds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CC42BB09
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJM5bMQK66LBjQHzGpr59PzU4BEc4YKDsnGoL7YGzBU=;
        b=Z18/1zC7sssfxJtpogvgs+VtIzf0sekO6D9OwxlTrPMe9MhxJ19zGdrO5TPBbgVEbqAwlC
        B25rS1eth1zC0lEOvmm6nvfM/6fyvYYvj5R4dgRlir/wUj8sP6Y1r36Pc3JCvn7Qx6IpuR
        slJQRPMyYgx+xagJsVskmLPeNRbiSE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-hgG2_VNUMgmMREg0BDfy2g-1; Thu, 15 Dec 2022 06:32:21 -0500
X-MC-Unique: hgG2_VNUMgmMREg0BDfy2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3B91811E9C;
        Thu, 15 Dec 2022 11:32:19 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E29BC2166B26;
        Thu, 15 Dec 2022 11:32:15 +0000 (UTC)
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
Subject: [PATCH v9 07/12] vdpa: move SVQ vring features check to net/
Date:   Thu, 15 Dec 2022 12:31:39 +0100
Message-Id: <20221215113144.322011-8-eperezma@redhat.com>
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

The next patches will start control SVQ if possible. However, we don't
know if that will be possible at qemu boot anymore.

Since the moved checks will be already evaluated at net/ to know if it
is ok to shadow CVQ, move them.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/virtio/vhost-vdpa.c | 32 ++------------------------------
 net/vhost-vdpa.c       |  3 ++-
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 9b7f4ef083..5039d9bb2f 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -389,29 +389,9 @@ static int vhost_vdpa_get_dev_features(struct vhost_dev *dev,
     return ret;
 }
 
-static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
-                               Error **errp)
+static void vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v)
 {
     g_autoptr(GPtrArray) shadow_vqs = NULL;
-    uint64_t dev_features, svq_features;
-    int r;
-    bool ok;
-
-    if (!v->shadow_vqs_enabled) {
-        return 0;
-    }
-
-    r = vhost_vdpa_get_dev_features(hdev, &dev_features);
-    if (r != 0) {
-        error_setg_errno(errp, -r, "Can't get vdpa device features");
-        return r;
-    }
-
-    svq_features = dev_features;
-    ok = vhost_svq_valid_features(svq_features, errp);
-    if (unlikely(!ok)) {
-        return -1;
-    }
 
     shadow_vqs = g_ptr_array_new_full(hdev->nvqs, vhost_svq_free);
     for (unsigned n = 0; n < hdev->nvqs; ++n) {
@@ -422,7 +402,6 @@ static int vhost_vdpa_init_svq(struct vhost_dev *hdev, struct vhost_vdpa *v,
     }
 
     v->shadow_vqs = g_steal_pointer(&shadow_vqs);
-    return 0;
 }
 
 static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
@@ -447,10 +426,7 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
     dev->opaque =  opaque ;
     v->listener = vhost_vdpa_memory_listener;
     v->msg_type = VHOST_IOTLB_MSG_V2;
-    ret = vhost_vdpa_init_svq(dev, v, errp);
-    if (ret) {
-        goto err;
-    }
+    vhost_vdpa_init_svq(dev, v);
 
     if (!vhost_vdpa_first_dev(dev)) {
         return 0;
@@ -460,10 +436,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
                                VIRTIO_CONFIG_S_DRIVER);
 
     return 0;
-
-err:
-    ram_block_discard_disable(false);
-    return ret;
 }
 
 static void vhost_vdpa_host_notifier_uninit(struct vhost_dev *dev,
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index b6462f0192..e829ef1f43 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -118,9 +118,10 @@ static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error **errp)
     if (invalid_dev_features) {
         error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
                    invalid_dev_features);
+        return false;
     }
 
-    return !invalid_dev_features;
+    return vhost_svq_valid_features(features, errp);
 }
 
 static int vhost_vdpa_net_check_device_id(struct vhost_net *net)
-- 
2.31.1

