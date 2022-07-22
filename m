Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6229B57E27B
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbiGVNnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 09:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGVNnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 09:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCD515A164
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658497421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7rDU0TrnGPIY2QjCynmatMau7Yu8EJvOtJEYx1mzxU=;
        b=Ne6RJ/1MhqVrJKcPfLCLzntlCQ9H64s7wE5wk8UySmfpue7n2aBeR7HMXM4pi0L+OKLbl+
        /gBM9J/IBlgU9sW67FoLcUbR/UVmjV9c4/rLtmeUKq0ekSp++mveXDSac7DZwrwiB3+HpX
        zdRGhI5b8nOBnFGIMs5FkukeIAiZCvo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-XeEANJcWPM-okgkgfHrTuw-1; Fri, 22 Jul 2022 09:43:38 -0400
X-MC-Unique: XeEANJcWPM-okgkgfHrTuw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69956811E7A;
        Fri, 22 Jul 2022 13:43:37 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8CC9492C3B;
        Fri, 22 Jul 2022 13:43:34 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Cindy Lu <lulu@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 5/7] vdpa: Store x-svq parameter in VhostVDPAState
Date:   Fri, 22 Jul 2022 15:43:16 +0200
Message-Id: <20220722134318.3430667-6-eperezma@redhat.com>
In-Reply-To: <20220722134318.3430667-1-eperezma@redhat.com>
References: <20220722134318.3430667-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 net/vhost-vdpa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
index 8203200c2a..6c1c64f9b1 100644
--- a/net/vhost-vdpa.c
+++ b/net/vhost-vdpa.c
@@ -36,6 +36,9 @@ typedef struct VhostVDPAState {
 
     /* Control commands shadow buffers */
     void *cvq_cmd_out_buffer, *cvq_cmd_in_buffer;
+
+    /* The device always have SVQ enabled */
+    bool always_svq;
     bool started;
 } VhostVDPAState;
 
@@ -565,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
 
     s->vhost_vdpa.device_fd = vdpa_device_fd;
     s->vhost_vdpa.index = queue_pair_index;
+    s->always_svq = svq;
     s->vhost_vdpa.shadow_vqs_enabled = svq;
     s->vhost_vdpa.iova_tree = iova_tree;
     if (!is_datapath) {
-- 
2.31.1

