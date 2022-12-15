Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2D764DA62
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiLOLeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiLOLdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CC32EF66
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qh9IFx0k8h0cmNyHPydWbPOxeOqSM/5ev2W0OwNyZ2c=;
        b=WMqS3UZZiUv1J0/iwoK2gZ3igvdYiKWijkR8OHPk0fVsVQ4IJbudBo3mhLP2J4mF4zoWzO
        rwEflpEVnzHkp/uZfACo1LYzeKqQ4RmEYBNMyoyoma64HUIgpck1M1besOSmbrsLqWeHiG
        +YzdMMEjExtHyfjmn06AIFy+LGXJ5mw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-2rSAVxALPyuwjl16BpoheQ-1; Thu, 15 Dec 2022 06:32:12 -0500
X-MC-Unique: 2rSAVxALPyuwjl16BpoheQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E8C51C09B67;
        Thu, 15 Dec 2022 11:32:11 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D39382166B29;
        Thu, 15 Dec 2022 11:32:06 +0000 (UTC)
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
Subject: [PATCH v9 05/12] vdpa: add vhost_vdpa_net_valid_svq_features
Date:   Thu, 15 Dec 2022 12:31:37 +0100
Message-Id: <20221215113144.322011-6-eperezma@redhat.com>
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

It will be reused at vdpa device start so let's extract in its own
function.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 net/vhost-vdpa.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 260e474863..2c0ff6d7b0 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -107,6 +107,22 @@ VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
     return s->vhost_net;
 }
 
+static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error **errp)
+{
+    uint64_t invalid_dev_features =
+        features & ~vdpa_svq_device_features &
+        /* Transport are all accepted at this point */
+        ~MAKE_64BIT_MASK(VIRTIO_TRANSPORT_F_START,
+                         VIRTIO_TRANSPORT_F_END - VIRTIO_TRANSPORT_F_START);
+
+    if (invalid_dev_features) {
+        error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
+                   invalid_dev_features);
+    }
+
+    return !invalid_dev_features;
+}
+
 static int vhost_vdpa_net_check_device_id(struct vhost_net *net)
 {
     uint32_t device_id;
@@ -676,15 +692,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
     if (opts->x_svq) {
         struct vhost_vdpa_iova_range iova_range;
 
-        uint64_t invalid_dev_features =
-            features & ~vdpa_svq_device_features &
-            /* Transport are all accepted at this point */
-            ~MAKE_64BIT_MASK(VIRTIO_TRANSPORT_F_START,
-                             VIRTIO_TRANSPORT_F_END - VIRTIO_TRANSPORT_F_START);
-
-        if (invalid_dev_features) {
-            error_setg(errp, "vdpa svq does not work with features 0x%" PRIx64,
-                       invalid_dev_features);
+        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
             goto err_svq;
         }
 
-- 
2.31.1

