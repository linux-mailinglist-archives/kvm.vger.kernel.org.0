Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8F7446FA
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjGAGjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGAGjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:39:02 -0400
X-Greylist: delayed 619 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Jun 2023 23:38:59 PDT
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7C2118;
        Fri, 30 Jun 2023 23:38:59 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id E3CAB100003;
        Sat,  1 Jul 2023 09:28:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E3CAB100003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688192915;
        bh=KtR+snAmemDx/QdrmLGfvVQlJ5kcP+i64AE/km7ksjQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=de9t4ZvQkesOquo/75JI+uekiz4u7gN/D7MHlurmTNJLny5T5WHUjW+iBWXXYprfF
         x322yXOf1z2B6rRE89rfoG6GAcrk5eQnzGbJeuOzWX5BrES/3na8lEyVYKSXqm4OVp
         /wBagkhN1Kfrh0xHN5f0p2S3VrV3gj/rlB8GRtiF2sj35HtIS72MoUcajdoC+Zhpxm
         bYWWAgAGlfUYZgh/9j/dxRuFoqsmYasc1a6joEI2a6OcznCHabcFrKVoOCcH4eCsIy
         HgfwUExrOu4uv2WoIUZej05eDizgZ9E7/d8wP/7gmpQLJLQOUQqLUjvkCTqsI/ZL8l
         wkmu8V93wix4g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:28:35 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:28:16 +0300
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
Subject: [RFC PATCH v5 01/17] vsock/virtio: read data from non-linear skb
Date:   Sat, 1 Jul 2023 09:22:54 +0300
Message-ID: <20230701062310.3397129-2-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 517 517 b0056c19d8e10afbb16cb7aad7258dedb0179a79, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/01 04:02:00 #21597763
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

This is preparation patch for non-linear skbuff handling. It replaces
direct calls of 'memcpy_to_msg()' with 'skb_copy_datagram_iter()'. Main
advantage of the second one is that is can handle paged part of the skb
by using 'kmap()' on each page, but if there are no pages in the skb,
it behaves like simple copying to iov iterator. This patch also adds
new field to the control block of skb - this value shows current offset
in the skb to read next portion of data (it doesn't matter linear it or
not). Idea is that 'skb_copy_datagram_iter()' handles both types of
skb internally - it just needs an offset from which to copy data from
the given skb. This offset is incremented on each read from skb. This
approach allows to avoid special handling of non-linear skbs:
1) We can't call 'skb_pull()' on it, because it updates 'data' pointer.
2) We need to update 'data_len' also on each read from this skb.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Changelog:
 v4 -> v5:
  * Use local variable for 'frag_off' in stream dequeue calback.
  * R-b from Bobby Eshleman removed due to patch update.

 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 30 ++++++++++++++++++-------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..17dbb7176e37 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,7 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	u32 frag_off;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..e5683af23e60 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -355,7 +355,7 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 	spin_lock_bh(&vvs->rx_lock);
 
 	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
-		off = 0;
+		off = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
 
 		if (total == len)
 			break;
@@ -370,7 +370,10 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 			 */
 			spin_unlock_bh(&vvs->rx_lock);
 
-			err = memcpy_to_msg(msg, skb->data + off, bytes);
+			err = skb_copy_datagram_iter(skb, off,
+						     &msg->msg_iter,
+						     bytes);
+
 			if (err)
 				goto out;
 
@@ -411,27 +414,35 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	}
 
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
+		u32 skb_rest_len;
+
 		skb = skb_peek(&vvs->rx_queue);
 
 		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		skb_rest_len = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
+
+		if (bytes > skb_rest_len)
+			bytes = skb_rest_len;
 
 		/* sk_lock is held by caller so no one else can dequeue.
 		 * Unlock rx_lock since memcpy_to_msg() may sleep.
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb,
+					     VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
+					     &msg->msg_iter, bytes);
+
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		skb_pull(skb, bytes);
 
-		if (skb->len == 0) {
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += bytes;
+
+		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->frag_off) {
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 
 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
@@ -503,7 +514,10 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				err = skb_copy_datagram_iter(skb, 0,
+							     &msg->msg_iter,
+							     bytes_to_copy);
+
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
-- 
2.25.1

