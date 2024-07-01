Return-Path: <kvm+bounces-20802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C2D91E26D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 16:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9BBD284096
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C88F16849D;
	Mon,  1 Jul 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9C40zRj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A079915F3FA;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719844086; cv=none; b=kCg4ZV4i2rAZE2+3THC/w2hrHIdHgSDY58+FfgKTr8TTlV8VktihExkNuMD6HtzQyIxNXo/ngGAIF/ZYFjimUVDUbflpWlwIReKF3TCoAYqnSBVGzN4lZJrU1MFKB0J/vBAhjD3vrjaXbQRuXSweqo10wH3Vjga3M4Jzgw9Eq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719844086; c=relaxed/simple;
	bh=cO+U5fy0210QAleviJD0TpGfHml+/ICxMKehAe43lxQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qg/CUDWdDBxsZAM144zL95IIM4iiBmEWuk1cDCfyNcscxhvy9mFRjBSo5j6JAwXyoDP2SdzlS5Oc8EbniUYpnk4xodcqZje/vWBGM3KbMbfBSqr9wgxwKtrBlTvxvkXKaZaPTgCyPjaPw+bXe+XtIlz2BtafRbsa5xqwUaA3QK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9C40zRj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57955C32786;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719844086;
	bh=cO+U5fy0210QAleviJD0TpGfHml+/ICxMKehAe43lxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N9C40zRjCoi74Ropui8m7VS/jGf/9CRqyfHNRlnjIdKmL95RrSQSVdBmCh+ixXPcX
	 nxuFVZHqqRt0KwNMnJLdO9jI0HFQ//Qfraqd49HoON3SC7PS/HcukIF6Ncs3a1rHxZ
	 jnJgc/0miohuDJHKbosqCDX7PDYNcas3ZC/+gJFPaToks8Q965n8pr0ImtJjcsDalx
	 skVauATFRPPc9kM7jC0WF2hIIM25eVsYVTl3TIYdhTtyxcRqY5TtUrghvma4cef4eq
	 tCk9Td2BbVKcnmRL2cAxtshg+yqPUYZo8w+ZP9hn5jCVVt40xuz9ROl0c8AJcLyoNF
	 +wR1Kvd3/WvEg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D843C3065D;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Mon, 01 Jul 2024 16:28:03 +0200
Subject: [PATCH PATCH net-next v2 2/2] vsock/virtio: avoid enqueue packets
 when work queue is empty
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240701-pinna-v2-2-ac396d181f59@outlook.com>
References: <20240701-pinna-v2-0-ac396d181f59@outlook.com>
In-Reply-To: <20240701-pinna-v2-0-ac396d181f59@outlook.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>, 
 Marco Pinna <marco.pinn95@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719844084; l=3479;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=GA02f18Cj/aP6NuiYKwDxd8jhvyHHo4xf9Dp0GABN8Y=;
 b=tozpxjjXLLGqTf7c1FE6SvuVWpoCDfR4hw83uc1rQKmw7qyffBkeCjCyxfi5deNB/BbSTa8/d
 qZkxj5qevYlAzxDfRbeWBwzcZJXUXNKEfiGodhebXzgFbNF+YmafNH9
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Marco Pinna <marco.pinn95@gmail.com>

Introduce an optimization in virtio_transport_send_pkt:
when the work queue (send_pkt_queue) is empty the packet is
put directly in the virtqueue reducing latency.

In the following benchmark (pingpong mode) the host sends
a payload to the guest and waits for the same payload back.

All vCPUs pinned individually to pCPUs.
vhost process pinned to a pCPU
fio process pinned both inside the host and the guest system.

Host CPU: Intel i7-10700KF CPU @ 3.80GHz
Tool: Fio version 3.37-56
Env: Phys host + L1 Guest
Payload: 512
Runtime-per-test: 50s
Mode: pingpong (h-g-h)
Test runs: 50
Type: SOCK_STREAM

Before (Linux 6.8.11)
------
mean(1st percentile):    380.56 ns
mean(overall):           780.83 ns
mean(99th percentile):  8300.24 ns

After
------
mean(1st percentile):   370.59 ns
mean(overall):          720.66 ns
mean(99th percentile): 7600.27 ns

Same setup, using 4K payload:

Before (Linux 6.8.11)
------
mean(1st percentile):    458.84 ns
mean(overall):          1650.17 ns
mean(99th percentile): 42240.68 ns

After
------
mean(1st percentile):    450.12 ns
mean(overall):          1460.84 ns
mean(99th percentile): 37632.45 ns

virtqueue.

Throughput: iperf-vsock

Before (Linux 6.8.11)
G2H 28.7 Gb/s

After
G2H 40.8 Gb/s

The performance improvement is related to this optimization,
I checked that each packet was put directly on the vq
avoiding the work queue.

Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
---
 net/vmw_vsock/virtio_transport.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index a74083d28120..3815aa8d956b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -213,6 +213,7 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr;
 	struct virtio_vsock *vsock;
+	bool use_worker = true;
 	int len = skb->len;
 
 	hdr = virtio_vsock_hdr(skb);
@@ -234,8 +235,41 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 	if (virtio_vsock_skb_reply(skb))
 		atomic_inc(&vsock->queued_replies);
 
-	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
-	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+	/* If the workqueue (send_pkt_queue) is empty there is no need to enqueue the packet.
+	 * Just put it on the virtqueue using virtio_transport_send_skb.
+	 */
+	if (skb_queue_empty_lockless(&vsock->send_pkt_queue)) {
+		bool restart_rx = false;
+		struct virtqueue *vq;
+		int ret;
+
+		/* Inside RCU, can't sleep! */
+		ret = mutex_trylock(&vsock->tx_lock);
+		if (unlikely(ret == 0))
+			goto out_worker;
+
+		/* Driver is being removed, no need to enqueue the packet */
+		if (!vsock->tx_run)
+			goto out_rcu;
+
+		vq = vsock->vqs[VSOCK_VQ_TX];
+
+		if (!virtio_transport_send_skb(skb, vq, vsock, &restart_rx)) {
+			use_worker = false;
+			virtqueue_kick(vq);
+		}
+
+		mutex_unlock(&vsock->tx_lock);
+
+		if (restart_rx)
+			queue_work(virtio_vsock_workqueue, &vsock->rx_work);
+	}
+
+out_worker:
+	if (use_worker) {
+		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
+		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+	}
 
 out_rcu:
 	rcu_read_unlock();

-- 
2.45.2



