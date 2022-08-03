Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22E8589124
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiHCRTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiHCRTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3970653D1F
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659547145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=teEvkmaXnJDu+MYlIAEDQQW7Rkz2f8TRd1LEgOhTJIY=;
        b=OKpBYT3/wAh9PEAhkGwlU5EIQsHAObN3nwguJH/COnFaNX3963YXqrM8ptBtpDPOFQeMr+
        NHO58HZhQy8/N5Tdo4SU/5+iOmJBGpOiOiBtUx5IDnK/Hr6XlkfuwCAc6uyFbRpuD8KLnv
        LWRB39qvjxdkGRc2tdW0vJX/PSjtWVc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-ufOuDDrjNF-e8XedZcot8g-1; Wed, 03 Aug 2022 13:18:59 -0400
X-MC-Unique: ufOuDDrjNF-e8XedZcot8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AAFD3C10248;
        Wed,  3 Aug 2022 17:18:44 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B91261121314;
        Wed,  3 Aug 2022 17:18:41 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Parav Pandit <parav@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: [PATCH v3 6/7] vhost_net: Add NetClientInfo prepare callback
Date:   Wed,  3 Aug 2022 19:18:20 +0200
Message-Id: <20220803171821.481336-7-eperezma@redhat.com>
In-Reply-To: <20220803171821.481336-1-eperezma@redhat.com>
References: <20220803171821.481336-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used by the backend to perform actions before the device is
started.

In particular, vdpa will use it to isolate CVQ in its own ASID if
possible, and start SVQ unconditionally only in CVQ.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/net/net.h  | 2 ++
 hw/net/vhost_net.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/net.h b/include/net/net.h
index a8d47309cd..efa6448886 100644
--- a/include/net/net.h
+++ b/include/net/net.h
@@ -44,6 +44,7 @@ typedef struct NICConf {
 
 typedef void (NetPoll)(NetClientState *, bool enable);
 typedef bool (NetCanReceive)(NetClientState *);
+typedef void (NetPrepare)(NetClientState *);
 typedef int (NetLoad)(NetClientState *);
 typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, size_t);
 typedef ssize_t (NetReceiveIOV)(NetClientState *, const struct iovec *, int);
@@ -72,6 +73,7 @@ typedef struct NetClientInfo {
     NetReceive *receive_raw;
     NetReceiveIOV *receive_iov;
     NetCanReceive *can_receive;
+    NetPrepare *prepare;
     NetLoad *load;
     NetCleanup *cleanup;
     LinkStatusChanged *link_status_changed;
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index a9bf72dcda..bbbb6d759b 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -244,6 +244,10 @@ static int vhost_net_start_one(struct vhost_net *net,
     struct vhost_vring_file file = { };
     int r;
 
+    if (net->nc->info->prepare) {
+        net->nc->info->prepare(net->nc);
+    }
+
     r = vhost_dev_enable_notifiers(&net->dev, dev);
     if (r < 0) {
         goto fail_notifiers;
-- 
2.31.1

