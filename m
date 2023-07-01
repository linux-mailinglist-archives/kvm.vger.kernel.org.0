Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D2974472B
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjGAGjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjGAGjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:39:24 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2BF4239;
        Fri, 30 Jun 2023 23:39:13 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id AAF74120005;
        Sat,  1 Jul 2023 09:28:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru AAF74120005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688192917;
        bh=C4H+wApJQrD5oBvAIFQn1rVYvXO7cAQ8ZFLo0nPthkM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=fwkxqMMYnMcZ5yna0XDVnWh2qjWaBZQ8XYiVxyQQJazczF8l2tcmpCnsiVBkOGdIu
         YRznkoboE5UTywwbkP+v1I5FRRLnfr04np/1WAPWvuB0qTz/YK/WI7Ndb4UlKMXjAK
         YA3T+j8tP+wJ7IiOgf43u2pBEaT2uPM4O3ASmn4DyCV5L5aux9Y6fIULInUWtMFU15
         3pNWgruA5tSEyWisq+L6UZB3tB76dSzRgB2gj0FX5Y1raoAvCNy6vR6xcW5NEufhbN
         DjlrkGyWEsB8TOkOJvKpbn4tjDNUGa7fd8PiTjhUoiyBHqt6EL2Xlse4zN8sHTlXas
         CSlMqos6CjWzg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:28:36 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:28:17 +0300
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
Subject: [RFC PATCH v5 02/17] vhost/vsock: read data from non-linear skb
Date:   Sat, 1 Jul 2023 09:22:55 +0300
Message-ID: <20230701062310.3397129-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230701062310.3397129-1-AVKrasnov@sberdevices.ru>
References: <20230701062310.3397129-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178380 [Jun 30 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 517 517 b0056c19d8e10afbb16cb7aad7258dedb0179a79, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/01 00:58:00 #21597365
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

This adds copying to guest's virtio buffers from non-linear skbs. Such
skbs are created by protocol layer when MSG_ZEROCOPY flags is used. It
replaces call of 'copy_to_iter()' to 'skb_copy_datagram_iter()'- second
function can read data from non-linear skb. Also this patch uses field
'frag_off' from skb control block. This field shows current offset to
read data from skb which could be both linear or not.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Changelog:
 v4 -> v5:
  * Use local variable for 'frag_off'.
  * Update commit message by adding some details about 'frag_off' field.
  * R-b from Bobby Eshleman removed due to patch update.

 drivers/vhost/vsock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..cb00e0e059e4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -114,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		struct sk_buff *skb;
 		unsigned out, in;
 		size_t nbytes;
+		u32 frag_off;
 		int head;
 
 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
@@ -156,7 +157,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
-		payload_len = skb->len;
+		frag_off = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
+		payload_len = skb->len - frag_off;
 		hdr = virtio_vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
@@ -197,8 +199,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
-		if (nbytes != payload_len) {
+		if (skb_copy_datagram_iter(skb,
+					   frag_off,
+					   &iov_iter,
+					   payload_len)) {
 			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
@@ -212,13 +216,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		skb_pull(skb, payload_len);
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += payload_len;
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
 		 * to send it with the next available buffer.
 		 */
-		if (skb->len > 0) {
+		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off < skb->len) {
 			hdr->flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same skb to handle
-- 
2.25.1

