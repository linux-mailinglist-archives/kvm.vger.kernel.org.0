Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D314979B410
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjIKUsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbjIKU3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 16:29:41 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5591AE;
        Mon, 11 Sep 2023 13:29:35 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 4EC43100016;
        Mon, 11 Sep 2023 23:29:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 4EC43100016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694464174;
        bh=nsXACqgrMo/TkzQyUqX610VkTuWkN6yhc3auwK2JTIA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=jebv59E6sLJqhhbAU2zPHuw+aig1Zf2BUYem2sE7yiuFm/qZLpo6387FcfLPkfW6F
         sBKh1eUhKNtyFmTGfJTInScU72WZUSb0EdiJ7cIluADQCOA+f4TaxzqJDLl5laYbrB
         iMnjFMPbOpS3n3juSNDq7ylAvJl/dlXdGYkVtlwMDe2ZiTcs8ziUaWGvEb2hgoJRSh
         phcmr3r+K4OiCGEn3nxx7OWpXzfCC3qGZeOkPD2SHDX3GIwf2W3wWtpA2AtGNb2FrN
         TmFP9CzFbNUBM+GsApE17sEgqD2p3MOnYuedlplOqHCxT7Kxt8NayIC/6Dplk8KzZ1
         bymarKTsEE1jw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 11 Sep 2023 23:29:34 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 11 Sep 2023 23:29:33 +0300
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
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
        <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v8 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Date:   Mon, 11 Sep 2023 23:22:34 +0300
Message-ID: <20230911202234.1932024-5-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179791 [Sep 11 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/11 15:53:00 #21884588
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds handling of MSG_ZEROCOPY flag on transmission path:

1) If this flag is set and zerocopy transmission is possible (enabled
   in socket options and transport allows zerocopy), then non-linear
   skb will be created and filled with the pages of user's buffer.
   Pages of user's buffer are locked in memory by 'get_user_pages()'.
2) Replaces way of skb owning: instead of 'skb_set_owner_sk_safe()' it
   calls 'skb_set_owner_w()'. Reason of this change is that
   '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc' of socket, so
   to decrease this field correctly, proper skb destructor is needed:
   'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
3) Adds new callback to 'struct virtio_transport': 'can_msgzerocopy'.
   If this callback is set, then transport needs extra check to be able
   to send provided number of buffers in zerocopy mode. Currently, the
   only transport that needs this callback set is virtio, because this
   transport adds new buffers to the virtio queue and we need to check,
   that number of these buffers is less than size of the queue (it is
   required by virtio spec). vhost and loopback transports don't need
   this check.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v5(big patchset) -> v1:
  * Refactorings of 'if' conditions.
  * Remove extra blank line.
  * Remove 'frag_off' field unneeded init.
  * Add function 'virtio_transport_fill_skb()' which fills both linear
    and non-linear skb with provided data.
 v1 -> v2:
  * Use original order of last four arguments in 'virtio_transport_alloc_skb()'.
 v2 -> v3:
  * Add new transport callback: 'msgzerocopy_check_iov'. It checks that
    provided 'iov_iter' with data could be sent in a zerocopy mode.
    If this callback is not set in transport - transport allows to send
    any 'iov_iter' in zerocopy mode. Otherwise - if callback returns 'true'
    then zerocopy is allowed. Reason of this callback is that in case of
    G2H transmission we insert whole skb to the tx virtio queue and such
    skb must fit to the size of the virtio queue to be sent in a single
    iteration (may be tx logic in 'virtio_transport.c' could be reworked
    as in vhost to support partial send of current skb). This callback
    will be enabled only for G2H path. For details pls see comment 
    'Check that tx queue...' below.
 v3 -> v4:
  * 'msgzerocopy_check_iov' moved from 'struct vsock_transport' to
    'struct virtio_transport' as it is virtio specific callback and
    never needed in other transports.
 v4 -> v5:
  * 'msgzerocopy_check_iov' renamed to 'can_msgzerocopy' and now it
    uses number of buffers to send as input argument. I think there is
    no need to pass iov to this callback (at least today, it is used only
    by guest side of virtio transport), because the only thing that this
    callback does is comparison of number of buffers to be inserted to
    the tx queue and size of this queue.
  * Remove any checks for type of current 'iov_iter' with payload (is it
    'iovec' or 'ubuf'). These checks left from the earlier versions where I
    didn't use already implemented kernel API which handles every type of
    'iov_iter'.
 v5 -> v6:
  * Refactor 'virtio_transport_fill_skb()'.
  * Add 'WARN_ON_ONCE()' and comment on invalid combination of destination
    socket and payload in 'virtio_transport_alloc_skb()'. 
 v7 -> v8:
  * Move '+1' addition from 'can_msgzerocopy' callback body to the caller.
    This addition means packet header.
  * In 'virtio_transport_can_zcopy()' rename 'max_to_send' argument to
    'pkt_len'.
  * Update commit message by adding details about new 'can_msgzerocopy'
    callback.
  * In 'virtio_transport_init_hdr()' move 'len' argument directly after
    'info'.
  * Add comment about processing last skb in tx loop.
  * Update comment for 'can_msgzerocopy' callback for more details.

 include/linux/virtio_vsock.h            |   9 +
 net/vmw_vsock/virtio_transport.c        |  32 +++
 net/vmw_vsock/virtio_transport_common.c | 256 ++++++++++++++++++------
 3 files changed, 239 insertions(+), 58 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index a91fbdf233e4..ebb3ce63d64d 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -160,6 +160,15 @@ struct virtio_transport {
 
 	/* Takes ownership of the packet */
 	int (*send_pkt)(struct sk_buff *skb);
+
+	/* Used in MSG_ZEROCOPY mode. Checks, that provided data
+	 * (number of buffers) could be transmitted with zerocopy
+	 * mode. If this callback is not implemented for the current
+	 * transport - this means that this transport doesn't need
+	 * extra checks and can perform zerocopy transmission by
+	 * default.
+	 */
+	bool (*can_msgzerocopy)(int bufs_num);
 };
 
 ssize_t
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 73d730156349..09ba3128e759 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -455,6 +455,37 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_can_msgzerocopy(int bufs_num)
+{
+	struct virtio_vsock *vsock;
+	bool res = false;
+
+	rcu_read_lock();
+
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (vsock) {
+		struct virtqueue *vq = vsock->vqs[VSOCK_VQ_TX];
+
+		/* Check that tx queue is large enough to keep whole
+		 * data to send. This is needed, because when there is
+		 * not enough free space in the queue, current skb to
+		 * send will be reinserted to the head of tx list of
+		 * the socket to retry transmission later, so if skb
+		 * is bigger than whole queue, it will be reinserted
+		 * again and again, thus blocking other skbs to be sent.
+		 * Each page of the user provided buffer will be added
+		 * as a single buffer to the tx virtqueue, so compare
+		 * number of pages against maximum capacity of the queue.
+		 */
+		if (bufs_num <= vq->num_max)
+			res = true;
+	}
+
+	rcu_read_unlock();
+
+	return res;
+}
+
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
@@ -504,6 +535,7 @@ static struct virtio_transport virtio_transport = {
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
+	.can_msgzerocopy = virtio_transport_can_msgzerocopy,
 };
 
 static bool virtio_transport_seqpacket_allow(u32 remote_cid)
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 3a48e48a99ac..e358f118b07e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -37,73 +37,110 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 	return container_of(t, struct virtio_transport, transport);
 }
 
-/* Returns a new packet on success, otherwise returns NULL.
- *
- * If NULL is returned, errp is set to a negative errno.
- */
-static struct sk_buff *
-virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
-			   size_t len,
-			   u32 src_cid,
-			   u32 src_port,
-			   u32 dst_cid,
-			   u32 dst_port)
-{
-	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
-	struct virtio_vsock_hdr *hdr;
-	struct sk_buff *skb;
-	void *payload;
-	int err;
+static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
+				       size_t pkt_len)
+{
+	const struct virtio_transport *t_ops;
+	struct iov_iter *iov_iter;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
+	if (!info->msg)
+		return false;
 
-	hdr = virtio_vsock_hdr(skb);
-	hdr->type	= cpu_to_le16(info->type);
-	hdr->op		= cpu_to_le16(info->op);
-	hdr->src_cid	= cpu_to_le64(src_cid);
-	hdr->dst_cid	= cpu_to_le64(dst_cid);
-	hdr->src_port	= cpu_to_le32(src_port);
-	hdr->dst_port	= cpu_to_le32(dst_port);
-	hdr->flags	= cpu_to_le32(info->flags);
-	hdr->len	= cpu_to_le32(len);
+	iov_iter = &info->msg->msg_iter;
 
-	if (info->msg && len > 0) {
-		payload = skb_put(skb, len);
-		err = memcpy_from_msg(payload, info->msg, len);
-		if (err)
-			goto out;
+	if (iov_iter->iov_offset)
+		return false;
 
-		if (msg_data_left(info->msg) == 0 &&
-		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
-			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+	/* We can't send whole iov. */
+	if (iov_iter->count > pkt_len)
+		return false;
 
-			if (info->msg->msg_flags & MSG_EOR)
-				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
-		}
+	/* Check that transport can send data in zerocopy mode. */
+	t_ops = virtio_transport_get_ops(info->vsk);
+
+	if (t_ops->can_msgzerocopy) {
+		int pages_in_iov = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
+		int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
+
+		/* +1 is for packet header. */
+		return t_ops->can_msgzerocopy(pages_to_send + 1);
 	}
 
-	if (info->reply)
-		virtio_vsock_skb_set_reply(skb);
+	return true;
+}
 
-	trace_virtio_transport_alloc_pkt(src_cid, src_port,
-					 dst_cid, dst_port,
-					 len,
-					 info->type,
-					 info->op,
-					 info->flags);
+static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
+					   struct sk_buff *skb,
+					   struct msghdr *msg,
+					   bool zerocopy)
+{
+	struct ubuf_info *uarg;
 
-	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
-		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
-		goto out;
+	if (msg->msg_ubuf) {
+		uarg = msg->msg_ubuf;
+		net_zcopy_get(uarg);
+	} else {
+		struct iov_iter *iter = &msg->msg_iter;
+		struct ubuf_info_msgzc *uarg_zc;
+
+		uarg = msg_zerocopy_realloc(sk_vsock(vsk),
+					    iter->count,
+					    NULL);
+		if (!uarg)
+			return -1;
+
+		uarg_zc = uarg_to_msgzc(uarg);
+		uarg_zc->zerocopy = zerocopy ? 1 : 0;
 	}
 
-	return skb;
+	skb_zcopy_init(skb, uarg);
 
-out:
-	kfree_skb(skb);
-	return NULL;
+	return 0;
+}
+
+static int virtio_transport_fill_skb(struct sk_buff *skb,
+				     struct virtio_vsock_pkt_info *info,
+				     size_t len,
+				     bool zcopy)
+{
+	void *payload;
+	int err;
+
+	if (zcopy)
+		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
+					       &info->msg->msg_iter,
+					       len);
+
+	payload = skb_put(skb, len);
+	err = memcpy_from_msg(payload, info->msg, len);
+	if (err)
+		return -1;
+
+	if (msg_data_left(info->msg))
+		return 0;
+
+	return 0;
+}
+
+static void virtio_transport_init_hdr(struct sk_buff *skb,
+				      struct virtio_vsock_pkt_info *info,
+				      size_t payload_len,
+				      u32 src_cid,
+				      u32 src_port,
+				      u32 dst_cid,
+				      u32 dst_port)
+{
+	struct virtio_vsock_hdr *hdr;
+
+	hdr = virtio_vsock_hdr(skb);
+	hdr->type	= cpu_to_le16(info->type);
+	hdr->op		= cpu_to_le16(info->op);
+	hdr->src_cid	= cpu_to_le64(src_cid);
+	hdr->dst_cid	= cpu_to_le64(dst_cid);
+	hdr->src_port	= cpu_to_le32(src_port);
+	hdr->dst_port	= cpu_to_le32(dst_port);
+	hdr->flags	= cpu_to_le32(info->flags);
+	hdr->len	= cpu_to_le32(payload_len);
 }
 
 static void virtio_transport_copy_nonlinear_skb(const struct sk_buff *skb,
@@ -214,6 +251,77 @@ static u16 virtio_transport_get_type(struct sock *sk)
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
 }
 
+static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
+						  struct virtio_vsock_pkt_info *info,
+						  size_t payload_len,
+						  bool zcopy,
+						  u32 src_cid,
+						  u32 src_port,
+						  u32 dst_cid,
+						  u32 dst_port)
+{
+	struct sk_buff *skb;
+	size_t skb_len;
+
+	skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
+
+	if (!zcopy)
+		skb_len += payload_len;
+
+	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	virtio_transport_init_hdr(skb, info, payload_len, src_cid, src_port,
+				  dst_cid, dst_port);
+
+	/* If 'vsk' != NULL then payload is always present, so we
+	 * will never call '__zerocopy_sg_from_iter()' below without
+	 * setting skb owner in 'skb_set_owner_w()'. The only case
+	 * when 'vsk' == NULL is VIRTIO_VSOCK_OP_RST control message
+	 * without payload.
+	 */
+	WARN_ON_ONCE(!(vsk && (info->msg && payload_len)) && zcopy);
+
+	/* Set owner here, because '__zerocopy_sg_from_iter()' uses
+	 * owner of skb without check to update 'sk_wmem_alloc'.
+	 */
+	if (vsk)
+		skb_set_owner_w(skb, sk_vsock(vsk));
+
+	if (info->msg && payload_len > 0) {
+		int err;
+
+		err = virtio_transport_fill_skb(skb, info, payload_len, zcopy);
+		if (err)
+			goto out;
+
+		if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
+			struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
+
+			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+
+			if (info->msg->msg_flags & MSG_EOR)
+				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+		}
+	}
+
+	if (info->reply)
+		virtio_vsock_skb_set_reply(skb);
+
+	trace_virtio_transport_alloc_pkt(src_cid, src_port,
+					 dst_cid, dst_port,
+					 payload_len,
+					 info->type,
+					 info->op,
+					 info->flags);
+
+	return skb;
+out:
+	kfree_skb(skb);
+	return NULL;
+}
+
 /* This function can only be used on connecting/connected sockets,
  * since a socket assigned to a transport is required.
  *
@@ -222,10 +330,12 @@ static u16 virtio_transport_get_type(struct sock *sk)
 static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 					  struct virtio_vsock_pkt_info *info)
 {
+	u32 max_skb_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
 	u32 src_cid, src_port, dst_cid, dst_port;
 	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
 	u32 pkt_len = info->pkt_len;
+	bool can_zcopy = false;
 	u32 rest_len;
 	int ret;
 
@@ -254,15 +364,30 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
 		return pkt_len;
 
+	if (info->msg) {
+		/* If zerocopy is not enabled by 'setsockopt()', we behave as
+		 * there is no MSG_ZEROCOPY flag set.
+		 */
+		if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY))
+			info->msg->msg_flags &= ~MSG_ZEROCOPY;
+
+		if (info->msg->msg_flags & MSG_ZEROCOPY)
+			can_zcopy = virtio_transport_can_zcopy(info, pkt_len);
+
+		if (can_zcopy)
+			max_skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
+					    (MAX_SKB_FRAGS * PAGE_SIZE));
+	}
+
 	rest_len = pkt_len;
 
 	do {
 		struct sk_buff *skb;
 		size_t skb_len;
 
-		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
+		skb_len = min(max_skb_len, rest_len);
 
-		skb = virtio_transport_alloc_skb(info, skb_len,
+		skb = virtio_transport_alloc_skb(vsk, info, skb_len, can_zcopy,
 						 src_cid, src_port,
 						 dst_cid, dst_port);
 		if (!skb) {
@@ -270,6 +395,21 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 			break;
 		}
 
+		/* We process buffer part by part, allocating skb on
+		 * each iteration. If this is last skb for this buffer
+		 * and MSG_ZEROCOPY mode is in use - we must allocate
+		 * completion for the current syscall.
+		 */
+		if (info->msg && info->msg->msg_flags & MSG_ZEROCOPY &&
+		    skb_len == rest_len && info->op == VIRTIO_VSOCK_OP_RW) {
+			if (virtio_transport_init_zcopy_skb(vsk, skb,
+							    info->msg,
+							    can_zcopy)) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
 		ret = t_ops->send_pkt(skb);
@@ -985,7 +1125,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!t)
 		return -ENOTCONN;
 
-	reply = virtio_transport_alloc_skb(&info, 0,
+	reply = virtio_transport_alloc_skb(NULL, &info, 0, false,
 					   le64_to_cpu(hdr->dst_cid),
 					   le32_to_cpu(hdr->dst_port),
 					   le64_to_cpu(hdr->src_cid),
-- 
2.25.1

