Return-Path: <kvm+bounces-42402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 531B9A7832E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9127316C84A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D3E2135D0;
	Tue,  1 Apr 2025 20:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="a4v7bm8b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B113212A;
	Tue,  1 Apr 2025 20:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743538440; cv=none; b=N143wvAXMgs5AnZDqKctovbSIe1jUK3vWZ+x1G7m8rzJl0EtMUKPsQrShNBy4UGiQu69QdxMeO6vTxGB74VXr1wLYf0rUDWCYqKmCHzGxl7VxQomJfIAK9urQVI040pwbkC8SmA/O2Tric1ascN6aeEUwR44i+9nCwpRqrH8EcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743538440; c=relaxed/simple;
	bh=xIukMokWqGIO0Piiex8r6UKKugymvOTtUTqiK2HO3lY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TTglVgpdsqgmpooJihcFyRodDPmDx8pIZYUPc72SDsdZdHs2AoprGxgQCFwZqu0ucYfrfym1yjCB28UQUwEGt/iaGj6ePJFRggIElb958KXpbJmCnJr/0qwx0P7VR0vScxdOD9gVuuhN0tWVZPz/X77/srwdHI7rBFnMbT6xvFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=a4v7bm8b; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743538439; x=1775074439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=grg7HgwkYOsDDxkskMb2VZiR76/MifH64emaphfZUPg=;
  b=a4v7bm8bZg3FSoZSx+WondL/GZxFtZRE285H2JptfxBF31hInkp+L/ef
   Tsj27/4NGFLj2zyK7pA0TxNj9rkLMjy74EvEVme4/UA2c5v6HQbG6VowT
   Kqapp9pHHDLKfAkhzGdr1E87r/g7vcvIeXAm+IvGTn6T9cGZZbxaIRHK9
   M=;
X-IronPort-AV: E=Sophos;i="6.14,294,1736812800"; 
   d="scan'208";a="485691106"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:13:55 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:33099]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.254:2525] with esmtp (Farcaster)
 id 4bfd118a-a928-41f8-95b5-a09364cefa05; Tue, 1 Apr 2025 20:13:53 +0000 (UTC)
X-Farcaster-Flow-ID: 4bfd118a-a928-41f8-95b5-a09364cefa05
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 1 Apr 2025 20:13:53 +0000
Received: from ip-10-253-83-51.amazon.com (10.253.83.51) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 1 Apr 2025 20:13:51 +0000
From: Alexander Graf <graf@amazon.com>
To: <netdev@vger.kernel.org>
CC: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <kvm@vger.kernel.org>, Asias He
	<asias@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Paolo Abeni
	<pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, "David S . Miller" <davem@davemloft.net>,
	<nh-open-source@amazon.com>
Subject: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Date: Tue, 1 Apr 2025 20:13:49 +0000
Message-ID: <20250401201349.23867-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
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
 net/vmw_vsock/virtio_transport.c | 70 +++++++++-----------------------
 1 file changed, 19 insertions(+), 51 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..54030c729767 100644
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
 
@@ -172,6 +176,12 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		bool reply;
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
@@ -184,17 +194,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
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
 
@@ -203,9 +202,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 out:
 	mutex_unlock(&vsock->tx_lock);
-
-	if (restart_rx)
-		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
 /* Caller need to hold RCU for vsock.
@@ -261,9 +257,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 	 */
 	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
 	    virtio_transport_send_skb_fast_path(vsock, skb)) {
-		if (virtio_vsock_skb_reply(skb))
-			atomic_inc(&vsock->queued_replies);
-
 		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 	}
@@ -277,7 +270,7 @@ static int
 virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
-	int cnt = 0, ret;
+	int ret;
 
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
@@ -286,17 +279,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
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
 
@@ -367,18 +350,6 @@ static void virtio_transport_tx_work(struct work_struct *work)
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
@@ -613,6 +584,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 	struct virtio_vsock *vsock =
 		container_of(work, struct virtio_vsock, rx_work);
 	struct virtqueue *vq;
+	int pkts = 0;
 
 	vq = vsock->vqs[VSOCK_VQ_RX];
 
@@ -627,11 +599,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
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
 
@@ -675,8 +645,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 	vsock->rx_buf_max_nr = 0;
 	mutex_unlock(&vsock->rx_lock);
 
-	atomic_set(&vsock->queued_replies, 0);
-
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
 	if (ret < 0)
 		return ret;
-- 
2.47.1


