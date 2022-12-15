Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDF064DA66
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 12:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiLOLeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 06:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLOLdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 06:33:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1382EF78
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 03:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671103948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xgz+q+nkh20Rxi7Ya77r3f1WK5Zz4XbA/xuiyyNphGI=;
        b=cDQGo9o5tHDz20PQ3MPBj9CxwmV+OnHtrEkGGo1oI6vA6cLeDXiJ1wi0RY0BaBaLgYa5Jh
        HfSW1BQay06UOcHp4Xl9CKnS3zJCtfcN8Ltq2bQVMCu/4geMS5mkLOnjlxvasneLvEpDBi
        g8WH31L3Oo5S+DCfVAcLpb7tcf54J9k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-3DVIKixCND-7Fahk1cNZDA-1; Thu, 15 Dec 2022 06:32:25 -0500
X-MC-Unique: 3DVIKixCND-7Fahk1cNZDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81C3E80234E;
        Thu, 15 Dec 2022 11:32:24 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31AF12166B26;
        Thu, 15 Dec 2022 11:32:20 +0000 (UTC)
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
Subject: [PATCH v9 08/12] vdpa: allocate SVQ array unconditionally
Date:   Thu, 15 Dec 2022 12:31:40 +0100
Message-Id: <20221215113144.322011-9-eperezma@redhat.com>
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
index 5039d9bb2f..86e1fa8e9e 100644
--- a/hw/virtio/vhost-vdpa.c
+++ b/hw/virtio/vhost-vdpa.c
@@ -532,10 +532,6 @@ static void vhost_vdpa_svq_cleanup(struct vhost_dev *dev)
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

