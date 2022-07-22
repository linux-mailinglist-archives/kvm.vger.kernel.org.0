Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5146357E27D
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbiGVNnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiGVNnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 09:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53C087E01D
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 06:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658497423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Le7Hgc2vUuS2ywF+v5z7y32fvz0IBUd34jg+USfjtsQ=;
        b=T4lpq7dGgkykhaEFHNCE1ovuGhpU5juZiyKLsYVOl5dVL17GDeH/c1scvSaK1sdqC83KOd
        394UaC8wgeigyGceimNqEvnKhayaf+aC8YULYH2gqRwuhCpdcJmPAPex9Bn5SAx0qpumcl
        o114lJd3Rzsr1qnkyc8XzwMYd+YPuhM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-5_yV2SY8NqqwuRFwdi8PIg-1; Fri, 22 Jul 2022 09:43:41 -0400
X-MC-Unique: 5_yV2SY8NqqwuRFwdi8PIg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72D80811E7A;
        Fri, 22 Jul 2022 13:43:40 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A426E401E7B;
        Fri, 22 Jul 2022 13:43:37 +0000 (UTC)
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
Subject: [PATCH v2 6/7] vhost_net: Add NetClientInfo prepare callback
Date:   Fri, 22 Jul 2022 15:43:17 +0200
Message-Id: <20220722134318.3430667-7-eperezma@redhat.com>
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
index ad9e80083a..37aecff8f7 100644
--- a/include/net/net.h
+++ b/include/net/net.h
@@ -44,6 +44,7 @@ typedef struct NICConf {
 
 typedef void (NetPoll)(NetClientState *, bool enable);
 typedef bool (NetCanReceive)(NetClientState *);
+typedef void (NetPrepare)(NetClientState *);
 typedef int (NetStart)(NetClientState *);
 typedef ssize_t (NetReceive)(NetClientState *, const uint8_t *, size_t);
 typedef ssize_t (NetReceiveIOV)(NetClientState *, const struct iovec *, int);
@@ -72,6 +73,7 @@ typedef struct NetClientInfo {
     NetReceive *receive_raw;
     NetReceiveIOV *receive_iov;
     NetCanReceive *can_receive;
+    NetPrepare *prepare;
     NetStart *start;
     NetCleanup *cleanup;
     LinkStatusChanged *link_status_changed;
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index ddd9ee0441..0fc892c22b 100644
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

