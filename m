Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72018621A13
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbiKHRJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiKHRJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:09:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD1C2643
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667927303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbLGvlgK5KAupOXrmEtNyHQVNOnV4itW0xTrDtMWhgA=;
        b=CrPxZKYfbAB7muUd+qhFS9bop/tr6tiE6Oj6igBw+SLT9Ym9WJJp+uGCfKYANNlrv9HDl5
        H9vJ976oj6VOFt06F4x8wsiku50F/oAHiHS6oAq/XS/vib95OllRasLprp9dQ9nVfhiPqo
        Np+L7jZXctThqb0ao+4x0Z6bEe5jXo8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-WmYhMhAtOh2QgFv8in7IMQ-1; Tue, 08 Nov 2022 12:08:16 -0500
X-MC-Unique: WmYhMhAtOh2QgFv8in7IMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EE772A59560;
        Tue,  8 Nov 2022 17:08:15 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85DE3C15BB5;
        Tue,  8 Nov 2022 17:08:12 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v6 04/10] vdpa: add vhost_vdpa_net_valid_svq_features
Date:   Tue,  8 Nov 2022 18:07:49 +0100
Message-Id: <20221108170755.92768-5-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-1-eperezma@redhat.com>
References: <20221108170755.92768-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It will be reused at vdpa device start so let's extract in its own function

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 net/vhost-vdpa.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index e370ecb8eb..d3b1de481b 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -106,6 +106,22 @@ VHostNetState *vhost_vdpa_get_vhost_net(NetClientState *nc)
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
@@ -675,15 +691,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const char *name,
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

