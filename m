Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C564DA64
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLOLeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiLOLds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C762EF6D
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Rfuwpr+kShoJMYQJoTJHzLoWWsJJtsbRxz+cbi+3HQ=;
        b=WH3sh/X0EOHrZOPqDXLS3yxxWoxLYIQUl+fx8mEQGf2N3VjHv39ugbatAVDGMlVAQ0b0ml
        tpIHCrlbMmHPxq7vU+KW4nB4VKA9YP7JqWggMoMKVO9LHgnlUP+bsO5nZ+P8z9VQ3D0wjF
        ve6mME90txqs/NTBLPFICCkn0doBSM0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-ByS1VDxMM7208FTfBg8kGw-1; Thu, 15 Dec 2022 06:32:16 -0500
X-MC-Unique: ByS1VDxMM7208FTfBg8kGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9168F3C11046;
        Thu, 15 Dec 2022 11:32:15 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E469F2166B26;
        Thu, 15 Dec 2022 11:32:11 +0000 (UTC)
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
Subject: [PATCH v9 06/12] vdpa: request iova_range only once
Date:   Thu, 15 Dec 2022 12:31:38 +0100
Message-Id: <20221215113144.322011-7-eperezma@redhat.com>
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

Currently iova range is requested once per queue pair in the case of
net. Reduce the number of ioctls asking it once at initialization and
reusing that value for each vhost_vdpa.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 hw/virtio/vhost-vdpa.c | 15 ---------------
 net/vhost-vdpa.c       | 27 ++++++++++++++-------------
 2 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 691bcc811a..9b7f4ef083 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -365,19 +365,6 @@ static int vhost_vdpa_add_status(struct vhost_dev *dev, uint8_t status)
     return 0;
 }
 
-static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
-{
-    int ret = vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
-                              &v->iova_range);
-    if (ret != 0) {
-        v->iova_range.first = 0;
-        v->iova_range.last = UINT64_MAX;
-    }
-
-    trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
-                                    v->iova_range.last);
-}
-
 /*
  * The use of this function is for requests that only need to be
  * applied once. Typically such request occurs at the beginning
@@ -465,8 +452,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, void *opaque, Error **errp)
         goto err;
     }
 
-    vhost_vdpa_get_iova_range(v);
-
     if (!vhost_vdpa_first_dev(dev)) {
         return 0;
     }
diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 2c0ff6d7b0..b6462f0192 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -541,14 +541,15 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net_svq_ops = {
 };
 
 static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
-                                           const char *device,
-                                           const char *name,
-                                           int vdpa_device_fd,
-                                           int queue_pair_index,
-                                           int nvqs,
-                                           bool is_datapath,
-                                           bool svq,
-                                           VhostIOVATree *iova_tree)
+                                       const char *device,
+                                       const char *name,
+                                       int vdpa_device_fd,
+                                       int queue_pair_index,
+                                       int nvqs,
+                                       bool is_datapath,
+                                       bool svq,
+                                       struct vhost_vdpa_iova_range iova_range,
+                                       VhostIOVATree *iova_tree)
 {
     NetClientState *nc = NULL;
     VhostVDPAState *s;
@@ -567,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
+    s->vhost_vdpa.iova_range = iova_range;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
         s->cvq_cmd_out_buffer = qemu_memalign(qemu_real_host_page_size(),
@@ -646,6 +648,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     int vdpa_device_fd;
     g_autofree NetClientState **ncs = NULL;
     g_autoptr(VhostIOVATree) iova_tree = NULL;
+    struct vhost_vdpa_iova_range iova_range;
     NetClientState *nc;
     int queue_pairs, r, i = 0, has_cvq = 0;
 
@@ -689,14 +692,12 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
         return queue_pairs;
     }
 
+    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
     if (opts->x_svq) {
-        struct vhost_vdpa_iova_range iova_range;
-
         if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
             goto err_svq;
         }
 
-        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
         iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
     }
 
@@ -705,7 +706,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     for (i = 0; i < queue_pairs; i++) {
         ncs[i] = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
                                      vdpa_device_fd, i, 2, true, opts->x_svq,
-                                     iova_tree);
+                                     iova_range, iova_tree);
         if (!ncs[i])
             goto err;
     }
@@ -713,7 +714,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     if (has_cvq) {
         nc = net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
                                  vdpa_device_fd, i, 1, false,
-                                 opts->x_svq, iova_tree);
+                                 opts->x_svq, iova_range, iova_tree);
         if (!nc)
             goto err;
     }
-- 
2.31.1

