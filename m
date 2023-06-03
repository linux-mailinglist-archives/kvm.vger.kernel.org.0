Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F207212DC
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjFCUzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 16:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjFCUzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 16:55:05 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E681B3;
        Sat,  3 Jun 2023 13:54:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E6C6C5FD3B;
        Sat,  3 Jun 2023 23:54:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1685825688;
        bh=s7f/CfLQJryGc9if2/VYU5WFEpGy8lqbWfJnGVRm084=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=RycjFhViTCCFq7j0f484NCTdGFhR5aOYYJyrnGolcXq19hWg1MDLtcNa2f5NNUGEu
         cBqptqlP4FZzR9rZubfb8PhQCA30pChiPty3bxB+/nELqpRVsf6LKsSnvUMUhlsM+e
         skJ5TVarQ7GGpNbj0ppLHcCgMa/C8GVPg578oXNlkxkTrnYoxiYPadHsrJAz8tNu1D
         mdwZK62T8RqgAzifwok2MYd5Kyg6nqIDTi1EyCM6wvgotlBj8lmA+L7PfGsYoZXwpW
         0RzzQMbi30g0aPKC0JSb2UG0Tmoi5XQlXyyhhUSAnvcXUSxbE7TKgWYjC4OEpdgCs+
         8U1nfszD18U2g==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  3 Jun 2023 23:54:48 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v4 11/17] vsock/virtio: support MSG_ZEROCOPY for transport
Date:   Sat, 3 Jun 2023 23:49:33 +0300
Message-ID: <20230603204939.1598818-12-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add 'msgzerocopy_allow()' callback for virtio transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 6053d8341091..d9ffa16dda69 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -438,6 +438,11 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_msgzerocopy_allow(void)
+{
+	return true;
+}
+
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
@@ -484,6 +489,8 @@ static struct virtio_transport virtio_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.msgzerocopy_allow        = virtio_transport_msgzerocopy_allow,
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
-- 
2.25.1

