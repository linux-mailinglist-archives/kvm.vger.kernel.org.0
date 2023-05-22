Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2E70B6CA
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjEVHpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjEVHos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:44:48 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FF3B7;
        Mon, 22 May 2023 00:44:46 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 532815FD4C;
        Mon, 22 May 2023 10:44:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1684741483;
        bh=n4r9aHu9NSWUDBJ4vitSNOAZW3rWO4qiwbbSKgMv+xY=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=JlIcZWZPGEtVR+9s4bXY+Go/5EEh7XWrEDc5DrwWKpMNaNDUfrenNx9758Sc1g27Q
         dGnx6LiuK87ZzJPIjVvdadb4rtdDYTtANJGNOlaJiMWIyX21F+QYA0Qd9QCe7ljr00
         4o1TjtBgFYNOaTgBM3ox/zMyL43C5vMKBAsWvW/0alefmMhqymjnit4uLo1X36IjQ+
         APjnvvf6f06+kHCc+JytFARrKT2MG3bf3aGglR0bSPE6fb8HZ1JjNtEFPrPhv/TcL8
         fCt6d7HQaApAQtvQBiX33O1vgShaYvwvd3Q5GRYyNmmZnedAh4GV9gxt7V3xon6IVu
         MXcv8TXk/An4Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 22 May 2023 10:44:43 +0300 (MSK)
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
Subject: [RFC PATCH v3 01/17] vsock/virtio: read data from non-linear skb
Date:   Mon, 22 May 2023 10:39:34 +0300
Message-ID: <20230522073950.3574171-2-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is preparation patch for non-linear skbuff handling. It replaces
direct calls of 'memcpy_to_msg()' with 'skb_copy_datagram_iter()'. Main
advantage of the second one is that is can handle paged part of the skb
by using 'kmap()' on each page, but if there are no pages in the skb,
it behaves like simple copying to iov iterator. This patch also removes
'skb_pull()' calls, because it updates 'data' pointer of the skb (it is
wrong thing to do with non-linear skb). Instead of updating 'data' and
'len' fields of skb, it adds new field to the control block of the skb:
this value shows current offset to read next data from skb (no matter
that this skb is linear or not), after each read from skb this field is
incremented and once it reaches 'len', skb is considered done.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

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
index e4878551f140..16effa8d55d2 100644
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
 
@@ -414,24 +417,28 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		skb = skb_peek(&vvs->rx_queue);
 
 		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		if (bytes > skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off)
+			bytes = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
 
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
@@ -503,7 +510,10 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
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

