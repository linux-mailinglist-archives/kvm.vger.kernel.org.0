Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3742A637D52
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiKXPxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiKXPxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F054F25
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhSLPDhzhFxcNenczXsbaDgqHh/5TPD4sy5gJvmX1zw=;
        b=VR2ZDb2xynfwkTZ9VXg4tnd0wzINhKZC8KmE7tJt31Zy6imTQI53nRwiJQ5+Vl2+JX99Rg
        JxLPZHndpE0UXjLjJzt0iviHI2bJm2ktiWfjpF7abGSJN3jBG6L9yfLDz4NJ+f2gGpTIr/
        ksRA4TcMilqimCsW7k+3OfONiduuXGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-EUNe_WFbMRmg49YabOmcBw-1; Thu, 24 Nov 2022 10:52:27 -0500
X-MC-Unique: EUNe_WFbMRmg49YabOmcBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86A9B811E75;
        Thu, 24 Nov 2022 15:52:26 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7706F111E3F8;
        Thu, 24 Nov 2022 15:52:23 +0000 (UTC)
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
Subject: [PATCH for 8.0 v8 06/12] vdpa: extract vhost_vdpa_svq_allocate_iova_tree
Date:   Thu, 24 Nov 2022 16:51:52 +0100
Message-Id: <20221124155158.2109884-7-eperezma@redhat.com>
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

It can be allocated either if all virtqueues must be shadowed or if
vdpa-net detects it can shadow only cvq.

Extract in its own function so we can reuse it.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 net/vhost-vdpa.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 88e0eec5fa..9ee3bc4cd3 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info = {
         .check_peer_type = vhost_vdpa_check_peer_type,
 };
 
+static int vhost_vdpa_get_iova_range(int fd,
+                                     struct vhost_vdpa_iova_range *iova_range)
+{
+    int ret = ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
+
+    return ret < 0 ? -errno : 0;
+}
+
+static VhostIOVATree *vhost_vdpa_svq_allocate_iova_tree(int vdpa_device_fd)
+{
+    struct vhost_vdpa_iova_range iova_range;
+
+    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
+    return vhost_iova_tree_new(iova_range.first, iova_range.last);
+}
+
 static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
 {
     VhostIOVATree *tree = v->iova_tree;
@@ -587,14 +603,6 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
     return nc;
 }
 
-static int vhost_vdpa_get_iova_range(int fd,
-                                     struct vhost_vdpa_iova_range *iova_range)
-{
-    int ret = ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
-
-    return ret < 0 ? -errno : 0;
-}
-
 static int vhost_vdpa_get_features(int fd, uint64_t *features, Error **errp)
 {
     int ret = ioctl(fd, VHOST_GET_FEATURES, features);
@@ -690,14 +698,11 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     }
 
     if (opts->x_svq) {
-        struct vhost_vdpa_iova_range iova_range;
-
         if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
             goto err_svq;
         }
 
-        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
-        iova_tree = vhost_iova_tree_new(iova_range.first, iova_range.last);
+        iova_tree = vhost_vdpa_svq_allocate_iova_tree(vdpa_device_fd);
     }
 
     ncs = g_malloc0(sizeof(*ncs) * queue_pairs);
-- 
2.31.1

