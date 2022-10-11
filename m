Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7E5FB09C
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 12:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJKKmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 06:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJKKmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 06:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12138B2EC
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 03:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665484938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDZ5MXKrLbAEkwEFC6uq+6MhbbVzqnB1xuVU606XNaI=;
        b=ZJtjQZBWhSq5txsLPpa3roLLRDY6v9YZqOiQhx9uRpU6Wj4ut0wY7SZUO1wtSlCtbvcRos
        dWNE3QniNgXCwjTCkYtVPEvEKv1h4NcVgVhT8+d5xZJ2L/f7Mlzxh5HmhT28i/BHe6E7ax
        3Ej6eFCn7xMX5aBoYZxkYiRgAk3g8tQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-73xvM9L7MfOUAYKbbzjZHg-1; Tue, 11 Oct 2022 06:42:15 -0400
X-MC-Unique: 73xvM9L7MfOUAYKbbzjZHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DE321C05AE9;
        Tue, 11 Oct 2022 10:42:14 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5106D492B09;
        Tue, 11 Oct 2022 10:42:11 +0000 (UTC)
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
Subject: [PATCH v5 4/6] vdpa: Store x-svq parameter in VhostVDPAState
Date:   Tue, 11 Oct 2022 12:41:52 +0200
Message-Id: <20221011104154.1209338-5-eperezma@redhat.com>
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

CVQ can be shadowed two ways:
- Device has x-svq=on parameter (current way)
- The device can isolate CVQ in its own vq group

QEMU needs to check for the second condition dynamically, because CVQ
index is not known at initialization time. Since this is dynamic, the
CVQ isolation could vary with different conditions, making it possible
to go from "not isolated group" to "isolated".

Saving the cmdline parameter in an extra field so we never disable CVQ
SVQ in case the device was started with cmdline.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 net/vhost-vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 025fbbc41b..e8c78e4813 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -38,6 +38,8 @@ typedef struct VhostVDPAState {
     void *cvq_cmd_out_buffer;
     virtio_net_ctrl_ack *status;
 
+    /* The device always have SVQ enabled */
+    bool always_svq;
     bool started;
 } VhostVDPAState;
 
@@ -600,6 +602,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
 
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
+    s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
-- 
2.31.1

