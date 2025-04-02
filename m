Return-Path: <kvm+bounces-42478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A597A791D4
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C8A87A4EFC
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E6A23C8CC;
	Wed,  2 Apr 2025 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XQJ0SxeE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C723770B;
	Wed,  2 Apr 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743606414; cv=none; b=q3kDDoyoiNiicGoXHshOiZikTa4vv5By9VJ/1U8VLCaltRAyapGzSjM5sjG2WpgRhsZqs7m42/KGtgC63Db7GEkcpm1p9wzU9U2W33ZQCbAQtUBqkoFxyO+6017wdz3CBuHie+/JxDx0UFp4A1UVG/Vy0Y/Q3sOoJVW/0+6xdRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743606414; c=relaxed/simple;
	bh=Cd9WUFaImNakrWY4hPwsrUO7MAImh0WQoTTF62j9ghs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LDzMQrLQJwgGIAdp2aUiF1gmLb10pCo3Z7cJFMTYq0zTfBu47WBV4vs+deuNrlfiWqlPeI5DrvBZOjCA3L+8+hMtWtxFTmhuYjVhh60DXnODcgpR4wDJx6jjJbI8WmRBOoilPFtaJakYRW2CphRTFE+0hJmNeXL1HCw40gYxcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XQJ0SxeE; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743606412; x=1775142412;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AZQELU/wg3cnT13N+6pYfjCzETNN0h8wOyhW1tj6qO8=;
  b=XQJ0SxeEUhkp/1P2OvFu2uyvwW6XM2H72tf4pLtlkcNKp88XrKSSOKnc
   T4ijn3huSNrZi8FRFxAc5Yl5zpcgkZb7qQkfuJSVgpQaf0k0pF7Q08QpZ
   OhdJK7fH0/Gkj0gf9DY5m+8+BU4x2fHBEFg6xVPkHHVoFqWVQKGffEv2S
   0=;
X-IronPort-AV: E=Sophos;i="6.15,182,1739836800"; 
   d="scan'208";a="187458710"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 15:06:51 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:35752]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.46:2525] with esmtp (Farcaster)
 id c08aa470-760f-489c-baf8-33e03603c6a8; Wed, 2 Apr 2025 15:06:51 +0000 (UTC)
X-Farcaster-Flow-ID: c08aa470-760f-489c-baf8-33e03603c6a8
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 15:06:50 +0000
Received: from ip-10-253-83-51.amazon.com (10.253.83.51) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 2 Apr 2025 15:06:48 +0000
From: Alexander Graf <graf@amazon.com>
To: <netdev@vger.kernel.org>
CC: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <kvm@vger.kernel.org>, Asias He
	<asias@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Paolo Abeni
	<pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, "David S . Miller" <davem@davemloft.net>,
	<nh-open-source@amazon.com>, Simon Horman <horms@kernel.org>
Subject: [PATCH v3] vsock/virtio: Remove queued_replies pushback logic
Date: Wed, 2 Apr 2025 15:06:46 +0000
Message-ID: <20250402150646.42855-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)

Ever since the introduction of the virtio vsock driver, it included
pushback logic that blocks it from taking any new RX packets until the
TX queue backlog becomes shallower than the virtqueue size.

This logic works fine when you connect a user space application on the
hypervisor with a virtio-vsock target, because the guest will stop
receiving data until the host pulled all outstanding data from the VM.

With Nitro Enclaves however, we connect 2 VMs directly via vsock:

  Parent      Enclave

    RX -------- TX
    TX -------- RX

This means we now have 2 virtio-vsock backends that both have the pushback
logic. If the parent's TX queue runs full at the same time as the
Enclave's, both virtio-vsock drivers fall into the pushback path and
no longer accept RX traffic. However, that RX traffic is TX traffic on
the other side which blocks that driver from making any forward
progress. We're now in a deadlock.

To resolve this, let's remove that pushback logic altogether and rely on
higher levels (like credits) to ensure we do not consume unbounded
memory.

RX and TX queues share the same work queue. To prevent starvation of TX
by an RX flood and vice versa now that the pushback logic is gone, let's
deliberately reschedule RX and TX work after a fixed threshold (256) of
packets to process.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Signed-off-by: Alexander Graf <graf@amazon.com>

---

v1 -> v2:

  - Rework to use fixed threshold

v2 -> v3:

  - Remove superfluous reply variable
---
 net/vmw_vsock/virtio_transport.c | 73 +++++++++-----------------------
 1 file changed, 19 insertions(+), 54 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..6ae30bf8c85c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -26,6 +26,12 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 static struct virtio_transport virtio_transport; /* forward declaration */
 
+/*
+ * Max number of RX packets transferred before requeueing so we do
+ * not starve TX traffic because they share the same work queue.
+ */
+#define VSOCK_MAX_PKTS_PER_WORK 256
+
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue *vqs[VSOCK_VQ_MAX];
@@ -44,8 +50,6 @@ struct virtio_vsock {
 	struct work_struct send_pkt_work;
 	struct sk_buff_head send_pkt_queue;
 
-	atomic_t queued_replies;
-
 	/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
 	 * must be accessed with rx_lock held.
 	 */
@@ -158,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		container_of(work, struct virtio_vsock, send_pkt_work);
 	struct virtqueue *vq;
 	bool added = false;
-	bool restart_rx = false;
+	int pkts = 0;
 
 	mutex_lock(&vsock->tx_lock);
 
@@ -169,32 +173,24 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 	for (;;) {
 		struct sk_buff *skb;
-		bool reply;
 		int ret;
 
+		if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
+			/* Allow other works on the same queue to run */
+			queue_work(virtio_vsock_workqueue, work);
+			break;
+		}
+
 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
 		if (!skb)
 			break;
 
-		reply = virtio_vsock_skb_reply(skb);
-
 		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
 		if (ret < 0) {
 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
 			break;
 		}
 
-		if (reply) {
-			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
-			int val;
-
-			val = atomic_dec_return(&vsock->queued_replies);
-
-			/* Do we now have resources to resume rx processing? */
-			if (val + 1 == virtqueue_get_vring_size(rx_vq))
-				restart_rx = true;
-		}
-
 		added = true;
 	}
 
@@ -203,9 +199,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 out:
 	mutex_unlock(&vsock->tx_lock);
-
-	if (restart_rx)
-		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
 /* Caller need to hold RCU for vsock.
@@ -261,9 +254,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 	 */
 	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
 	    virtio_transport_send_skb_fast_path(vsock, skb)) {
-		if (virtio_vsock_skb_reply(skb))
-			atomic_inc(&vsock->queued_replies);
-
 		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 	}
@@ -277,7 +267,7 @@ static int
 virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
-	int cnt = 0, ret;
+	int ret;
 
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
@@ -286,17 +276,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 		goto out_rcu;
 	}
 
-	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
-
-	if (cnt) {
-		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
-		int new_cnt;
-
-		new_cnt = atomic_sub_return(cnt, &vsock->queued_replies);
-		if (new_cnt + cnt >= virtqueue_get_vring_size(rx_vq) &&
-		    new_cnt < virtqueue_get_vring_size(rx_vq))
-			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
-	}
+	virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
 
 	ret = 0;
 
@@ -367,18 +347,6 @@ static void virtio_transport_tx_work(struct work_struct *work)
 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 }
 
-/* Is there space left for replies to rx packets? */
-static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
-{
-	struct virtqueue *vq = vsock->vqs[VSOCK_VQ_RX];
-	int val;
-
-	smp_rmb(); /* paired with atomic_inc() and atomic_dec_return() */
-	val = atomic_read(&vsock->queued_replies);
-
-	return val < virtqueue_get_vring_size(vq);
-}
-
 /* event_lock must be held */
 static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 				       struct virtio_vsock_event *event)
@@ -613,6 +581,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 	struct virtio_vsock *vsock =
 		container_of(work, struct virtio_vsock, rx_work);
 	struct virtqueue *vq;
+	int pkts = 0;
 
 	vq = vsock->vqs[VSOCK_VQ_RX];
 
@@ -627,11 +596,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
 			struct sk_buff *skb;
 			unsigned int len;
 
-			if (!virtio_transport_more_replies(vsock)) {
-				/* Stop rx until the device processes already
-				 * pending replies.  Leave rx virtqueue
-				 * callbacks disabled.
-				 */
+			if (++pkts > VSOCK_MAX_PKTS_PER_WORK) {
+				/* Allow other works on the same queue to run */
+				queue_work(virtio_vsock_workqueue, work);
 				goto out;
 			}
 
@@ -675,8 +642,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->rx_buf_max_nr = 0;
 	mutex_unlock(&vsock->rx_lock);
 
-	atomic_set(&vsock->queued_replies, 0);
-
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
 	if (ret < 0)
 		return ret;
-- 
2.47.1


