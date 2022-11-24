Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE5637D54
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiKXPxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiKXPxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CED10060
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vUhr69+TgZmndftT7btVTmABb13n2gplbiYWMXh4Xjw=;
        b=Mr0R/6hR0wOwzM4EkccLI3nvCPSzsTIFlBOQif4b9joSTLdaWHs1fU0udND+pxNWX1A3Ni
        L6kHzu8kRdQOhLnIKzZJD9ds/kl1FUh6P5EM8x6lg9aYxnzmE4OwNKE77KfiK9Sw+XtZUy
        6V56zpz5QLp7KnODQIKOiz9uYe3eZfs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-8pIWLS0SPW2xxUKQUZ5Lrg-1; Thu, 24 Nov 2022 10:52:33 -0500
X-MC-Unique: 8pIWLS0SPW2xxUKQUZ5Lrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4654C1C05EC0;
        Thu, 24 Nov 2022 15:52:33 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3450B111F3B6;
        Thu, 24 Nov 2022 15:52:30 +0000 (UTC)
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
Subject: [PATCH for 8.0 v8 08/12] vdpa: allocate SVQ array unconditionally
Date:   Thu, 24 Nov 2022 16:51:54 +0100
Message-Id: <20221124155158.2109884-9-eperezma@redhat.com>
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

SVQ may run or not in a device depending on runtime conditions (for
example, if the device can move CVQ to its own group or not).

Allocate the SVQ array unconditionally at startup, since its hard to
move this allocation elsewhere.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/virtio/vhost-vdpa.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
index 6f2dabd0bf..ed360b7fdf 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -546,10 +546,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev *dev)
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

