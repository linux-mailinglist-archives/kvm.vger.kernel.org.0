Return-Path: <kvm+bounces-31930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA519CDC90
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 11:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 952C71F22800
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F731B4F09;
	Fri, 15 Nov 2024 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="lDPVSNrB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A55818950A;
	Fri, 15 Nov 2024 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731666625; cv=none; b=h8/rewGa8A3qBPihJGuChtyF8SBlnURpQTzc7NR8LvncvPQ57t047dor1DBNJ9zlPotTvhtGGlHnGNoyoVMYpBRTDfPfcGpHh8/nyNxoaYfGOkp4Zoqns9hrZfRirJGxIcwIhPc1dRUIimpAbtLtqmXzwc3YP1s6deLnuXAdE+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731666625; c=relaxed/simple;
	bh=4vNgn+SsJajunpKXuBkZ//5pvqR9w+o+EcfCWsemrGQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o+4H83ducNF5wmlIvDgT3Pgibbh8TtyO5Y4OHaDtmF5AwH+sxnjdrP3uSpWUZ5OkWyLWjavneV/Hh06d1lFIBcd+Za9dSEUGgzurCgNsjRRO79WZnxnF1sY+mhn21KFEvYWVPGw82OC5la0bd7WjXDLVyEPcyq2qCa3eWMydtIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=lDPVSNrB; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731666622; x=1763202622;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nj6S1uQvHPGOTiJGqSfDYPUjpMdCEBMRTMmFsqU5FDo=;
  b=lDPVSNrBXdMuOD1p54HCK/AYRlgHaF7Oezqy2DNnhMTSxiZuMD0FnUaw
   rVyfctIZ76Jykt06ElF9ED+z4FFwpfxQV3RrFAHxK5gd4Gt6gGGRjUNEp
   odLAH+L7nvZ64WE2qd63Ch7iCtPoekF6/yOv5u+0EXpegGdQvPHv1XeFX
   M=;
X-IronPort-AV: E=Sophos;i="6.12,156,1728950400"; 
   d="scan'208";a="147826196"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:30:20 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:15220]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.2:2525] with esmtp (Farcaster)
 id e0f35240-8bc2-40ae-9f40-746d1c98b040; Fri, 15 Nov 2024 10:30:20 +0000 (UTC)
X-Farcaster-Flow-ID: e0f35240-8bc2-40ae-9f40-746d1c98b040
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 15 Nov 2024 10:30:20 +0000
Received: from ip-10-253-83-51.amazon.com (10.253.83.51) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 15 Nov 2024 10:30:18 +0000
From: Alexander Graf <graf@amazon.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<kvm@vger.kernel.org>, Asias He <asias@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski
	<kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller"
	<davem@davemloft.net>, Stefano Garzarella <sgarzare@redhat.com>, "Stefan
 Hajnoczi" <stefanha@redhat.com>
Subject: [PATCH] vsock/virtio: Remove queued_replies pushback logic
Date: Fri, 15 Nov 2024 10:30:16 +0000
Message-ID: <20241115103016.86461-1-graf@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
progress. We're not in a deadlock.

To resolve this, let's remove that pushback logic altogether and rely on
higher levels (like credits) to ensure we do not consume unbounded
memory.

Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 net/vmw_vsock/virtio_transport.c | 51 ++------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 64a07acfef12..53e79779886c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -44,8 +44,6 @@ struct virtio_vsock {
 	struct work_struct send_pkt_work;
 	struct sk_buff_head send_pkt_queue;
 
-	atomic_t queued_replies;
-
 	/* The following fields are protected by rx_lock.  vqs[VSOCK_VQ_RX]
 	 * must be accessed with rx_lock held.
 	 */
@@ -171,17 +169,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		virtio_transport_deliver_tap_pkt(skb);
 
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
 
@@ -218,9 +205,6 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 		goto out_rcu;
 	}
 
-	if (virtio_vsock_skb_reply(skb))
-		atomic_inc(&vsock->queued_replies);
-
 	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 
@@ -233,7 +217,7 @@ static int
 virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
-	int cnt = 0, ret;
+	int ret;
 
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
@@ -242,17 +226,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
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
 
@@ -323,18 +297,6 @@ static void virtio_transport_tx_work(struct work_struct *work)
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
@@ -581,14 +543,6 @@ static void virtio_transport_rx_work(struct work_struct *work)
 			struct sk_buff *skb;
 			unsigned int len;
 
-			if (!virtio_transport_more_replies(vsock)) {
-				/* Stop rx until the device processes already
-				 * pending replies.  Leave rx virtqueue
-				 * callbacks disabled.
-				 */
-				goto out;
-			}
-
 			skb = virtqueue_get_buf(vq, &len);
 			if (!skb)
 				break;
@@ -735,7 +689,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->rx_buf_nr = 0;
 	vsock->rx_buf_max_nr = 0;
-	atomic_set(&vsock->queued_replies, 0);
 
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


