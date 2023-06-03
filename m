Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984B47212DA
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjFCUzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjFCUzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 16:55:05 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D381B1;
        Sat,  3 Jun 2023 13:54:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 309645FD3C;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1685825689;
        bh=26CL2gVE0g6kFd3ZFQdsGyNdyslfGmT/ZpPrRg3+nfI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=BKAbES7BoLlidpvw0rMtqdqB7xEXtgBURTVI82QeFolK4flgEV0OAt8pV9oMaKNMz
         G2bAelQ+UFia3yG6r0Sgbkso9tH0EJvEOrv3Oqdx9kU4YNtOAm5Qv66PI7Y61b5YqN
         FY07PX5itx9jBaOa4ekgBC+omDbdDXZCX8vRWlzXg23Rc/+/CRhW/rFg/fnVXbdFtt
         bRQiCz6elxUCfTWOcpa39yp30jI35ajzDyh8eIKXNbWtMyVhGPgM13+JcmFKbFaq9g
         oX0O+zH0GKH9U2Q/HqFll/NFiyHFYNCXjtZ0FvniLjLiViWUDJUkINLGTs4qMD5Pho
         aNOsouh71frMA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
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
Subject: [RFC PATCH v4 12/17] vsock/loopback: support MSG_ZEROCOPY for transport
Date:   Sat, 3 Jun 2023 23:49:34 +0300
Message-ID: <20230603204939.1598818-13-AVKrasnov@sberdevices.ru>
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

Add 'msgzerocopy_allow()' callback for loopback transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/vsock_loopback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 5c6360df1f31..a2e4aeda2d92 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -47,6 +47,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 }
 
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
+static bool vsock_loopback_msgzerocopy_allow(void);
 
 static struct virtio_transport loopback_transport = {
 	.transport = {
@@ -92,11 +93,18 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.msgzerocopy_allow        = vsock_loopback_msgzerocopy_allow,
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
+static bool vsock_loopback_msgzerocopy_allow(void)
+{
+	return true;
+}
+
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
 {
 	return true;
-- 
2.25.1

