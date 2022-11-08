Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C420621A1C
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiKHRJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiKHRJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:09:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7818926E2
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667927312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKrm51MPsHbsyvUVRf3Ad+9rEofD1VH/kz0ZEyERCM4=;
        b=dzWxVmEP3/v20IyYz1ouvpBM2Zn15p48Yg1o5ReYgkP/eEfTwFENz9fLON6S1BHSYTP6iA
        ZtXJl4oDYy5yLs8yE1i2YdMoFKIE3GYf4omlEDH5XKy0TbTjTa9DD0zHP36CJDX9jIn8wM
        pUU0lVWCaUMMmAd+E8T1l9r9cRlSOgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-xIcNgP1AMn6e-zhfcik56Q-1; Tue, 08 Nov 2022 12:08:29 -0500
X-MC-Unique: xIcNgP1AMn6e-zhfcik56Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D490887B2A0;
        Tue,  8 Nov 2022 17:08:28 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0F92C16922;
        Tue,  8 Nov 2022 17:08:25 +0000 (UTC)
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
Subject: [PATCH v6 08/10] vdpa: Store x-svq parameter in VhostVDPAState
Date:   Tue,  8 Nov 2022 18:07:53 +0100
Message-Id: <20221108170755.92768-9-eperezma@redhat.com>
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
index ca1acc0410..85a318faca 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -38,6 +38,8 @@ typedef struct VhostVDPAState {
     void *cvq_cmd_out_buffer;
     virtio_net_ctrl_ack *status;
 
+    /* The device always have SVQ enabled */
+    bool always_svq;
     bool started;
 } VhostVDPAState;
 
@@ -566,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
 
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
+    s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
-- 
2.31.1

