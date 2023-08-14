Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791BE77C275
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 23:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjHNVeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 17:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjHNVdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 17:33:35 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7810E5;
        Mon, 14 Aug 2023 14:33:30 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 85292120007;
        Tue, 15 Aug 2023 00:33:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 85292120007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1692048808;
        bh=MBounFMBW1tDI3meXdkzMeH8webyIoxfoyl+WrLFLo0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=N/0rrmyzjvUDbywfWf4msf8v8P46RubJzpSJnw/kwCVztms86qKv4dSr3BqOOz27H
         0shPTXQji+1YyyJxqX3Oyp9HPWuS1sAUODOLaZE/yPZEbLRnqvAUkyU1bIgF+zf7BS
         mOp47iN1LvZVcqly6JAvrSTh/DEzjI2qBfHssc9XvQs54ylZkhfT0u1NRsB53KDkOO
         CLM5vvG9OZpKtbpb08x0eUL+8vLQi+DFhfUn5SUPlR3dnwgrnQ3KiQ5bc31NIJK9dA
         1FeQvmhjIHvU9pNxS6pJuc91mFSq8vQbK/a4QzsAmdefoa2NCvr7NI3mhSfmwxjpqu
         qXwNsOVFxPcZw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 15 Aug 2023 00:33:28 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 15 Aug 2023 00:33:24 +0300
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
Subject: [PATCH net-next v6 1/4] vsock/virtio/vhost: read data from non-linear skb
Date:   Tue, 15 Aug 2023 00:27:17 +0300
Message-ID: <20230814212720.3679058-2-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230814212720.3679058-1-AVKrasnov@sberdevices.ru>
References: <20230814212720.3679058-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179236 [Aug 14 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 526 526 7a6a9b19f6b9b3921b5701490f189af0e0cd5310, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/14 17:33:00 #21612035
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is preparation patch for MSG_ZEROCOPY support. It adds handling of
non-linear skbs by replacing direct calls of 'memcpy_to_msg()' with
'skb_copy_datagram_iter()'. Main advantage of the second one is that it
can handle paged part of the skb by using 'kmap()' on each page, but if
there are no pages in the skb, it behaves like simple copying to iov
iterator. This patch also adds new field to the control block of skb -
this value shows current offset in the skb to read next portion of data
(it doesn't matter linear it or not). Idea behind this field is that
'skb_copy_datagram_iter()' handles both types of skb internally - it
just needs an offset from which to copy data from the given skb. This
offset is incremented on each read from skb. This approach allows to
simplify handling of both linear and non-linear skbs, because for
linear skb we need to call 'skb_pull()' after reading data from it,
while in non-linear case we need to update 'data_len'.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Changelog:
 v5(big patchset) -> v1:
  * Merge 'virtio_transport_common.c' and 'vhost/vsock.c' patches into
    this single patch.
  * Commit message update: grammar fix and remark that this patch is
    MSG_ZEROCOPY preparation.
  * Use 'min_t()' instead of comparison using '<>' operators.
 v1 -> v2:
  * R-b tag added.
 v3 -> v4:
  * R-b tag removed due to rebase:
    * Part for 'virtio_transport_stream_do_peek()' is changed.
    * Part for 'virtio_transport_seqpacket_do_peek()' is added.
  * Comments about sleep in 'memcpy_to_msg()' now describe sleep in
    'skb_copy_datagram_iter()'.
 v5 -> v6:
  * Commit message update.
  * Rename 'frag_off' to 'offset' in 'virtio_vsock_skb_cb'.

 drivers/vhost/vsock.c                   | 14 +++++++----
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 32 +++++++++++++++----------
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 817d377a3f36..83711aad855c 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -114,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		struct sk_buff *skb;
 		unsigned out, in;
 		size_t nbytes;
+		u32 offset;
 		int head;
 
 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
@@ -156,7 +157,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
-		payload_len = skb->len;
+		offset = VIRTIO_VSOCK_SKB_CB(skb)->offset;
+		payload_len = skb->len - offset;
 		hdr = virtio_vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
@@ -197,8 +199,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
-		if (nbytes != payload_len) {
+		if (skb_copy_datagram_iter(skb,
+					   offset,
+					   &iov_iter,
+					   payload_len)) {
 			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
@@ -212,13 +216,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		skb_pull(skb, payload_len);
+		VIRTIO_VSOCK_SKB_CB(skb)->offset += payload_len;
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
 		 * to send it with the next available buffer.
 		 */
-		if (skb->len > 0) {
+		if (VIRTIO_VSOCK_SKB_CB(skb)->offset < skb->len) {
 			hdr->flags |= cpu_to_le32(flags_to_restore);
 
 			/* We are queueing the same skb to handle
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..a91fbdf233e4 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,7 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	u32 offset;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 352d042b130b..3e08d52a9355 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -364,9 +364,10 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 		spin_unlock_bh(&vvs->rx_lock);
 
 		/* sk_lock is held by caller so no one else can dequeue.
-		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 		 */
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->offset,
+					     &msg->msg_iter, bytes);
 		if (err)
 			goto out;
 
@@ -410,25 +411,27 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
 		skb = skb_peek(&vvs->rx_queue);
 
-		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		bytes = min_t(size_t, len - total,
+			      skb->len - VIRTIO_VSOCK_SKB_CB(skb)->offset);
 
 		/* sk_lock is held by caller so no one else can dequeue.
-		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb,
+					     VIRTIO_VSOCK_SKB_CB(skb)->offset,
+					     &msg->msg_iter, bytes);
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		skb_pull(skb, bytes);
 
-		if (skb->len == 0) {
+		VIRTIO_VSOCK_SKB_CB(skb)->offset += bytes;
+
+		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->offset) {
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 
 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
@@ -492,9 +495,10 @@ virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
 			spin_unlock_bh(&vvs->rx_lock);
 
 			/* sk_lock is held by caller so no one else can dequeue.
-			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 			 */
-			err = memcpy_to_msg(msg, skb->data, bytes);
+			err = skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->offset,
+						     &msg->msg_iter, bytes);
 			if (err)
 				return err;
 
@@ -553,11 +557,13 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				int err;
 
 				/* sk_lock is held by caller so no one else can dequeue.
-				 * Unlock rx_lock since memcpy_to_msg() may sleep.
+				 * Unlock rx_lock since skb_copy_datagram_iter() may sleep.
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				err = skb_copy_datagram_iter(skb, 0,
+							     &msg->msg_iter,
+							     bytes_to_copy);
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
-- 
2.25.1

