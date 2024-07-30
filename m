Return-Path: <kvm+bounces-22701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1282E942102
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA747286367
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE8F18DF82;
	Tue, 30 Jul 2024 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ta+UA34c"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A52218C91A;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368856; cv=none; b=PtUZs5M/KuaQOai443Zw2ZdB+Me6qEzI32BQHM8r3nWo6Bglte6SvuQ9AaJY1Xc2HPgHsmACUnSaPKQHcTlLVHcww7bPzpAAi5K5ubl8g/Br8wDMfsYG+G63CmBo7pZy35ApFdL49NyKBzL20JlDpHnlMHm/YQjg+J0Z5PdNCMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368856; c=relaxed/simple;
	bh=sZVCHvOMntY6RWXoNv2G++KJTPRWx0zhNILz+uaFA3E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hYcIqxgMTuXh2+2ETcIj/JFns/GiKVzlZCL0vWxtzcwhOVra9JX+IN14AZttNXuN/4lyju/6RabrzqEtAt68I6eOf7eu1RaIint5M5Kmv6FiOBWlAJzWVZzoGFMUk7CGx1ScVMtfxOi50q6yWVB+03KO+zDCHFjc29rDpO2bxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ta+UA34c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B66D2C4AF0E;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368855;
	bh=sZVCHvOMntY6RWXoNv2G++KJTPRWx0zhNILz+uaFA3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ta+UA34cXVlqJjDD/i+IITwjTfxsDdmZ9h6IT4Ioeu/R5nth+rpRMSv2qZYWxlLp4
	 52qaQr3jOntUd2IQORIIf2Q3B0CE8WtDsXlwOpyCA/mpBcQIJfByUymgCq+nmy/ie6
	 9mgMrN/vrR1+Wy75qxBhT59uWMjkznU5oJ1wx5EFMFvYZADv43VFQGu57R1DlbvnDk
	 lR+2tOV0cWgsCdq+cO6Xsg5oiu9pta+dvAbYGQtTxfPTPmd5saSpXh0s0JbrKcI0ka
	 E4n/w5XWZAapAQDaggyHkAZX0ABLVbHi8MPDzS0/zJWi5wdWk6oF5e76yPsNs5wBVN
	 Vew1crABqPqeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D72C52D1F;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Tue, 30 Jul 2024 21:47:32 +0200
Subject: [PATCH net-next v4 2/2] vsock/virtio: avoid queuing packets when
 intermediate queue is empty
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-pinna-v4-2-5c9179164db5@outlook.com>
References: <20240730-pinna-v4-0-5c9179164db5@outlook.com>
In-Reply-To: <20240730-pinna-v4-0-5c9179164db5@outlook.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Marco Pinna <marco.pinn95@gmail.com>, 
 Luigi Leonardi <luigi.leonardi@outlook.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368854; l=4306;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=gxGPFhruB/r9MuLoDFfpJxFjk4iZ5PBNCbtbWoujVr0=;
 b=cgRt0jFaa7gqMYhJ0aY3ZM9aiaao5Hwe8nVF8K/iWvn3yvJWPjLAC9uquUeda9o9nC5DQN7Lb
 TPuN0pTZs6uB9ss0MjvovgZ6fqkP4P6F7JyUhkDX9aIoxo0CnrK+Vdu
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

When the driver needs to send new packets to the device, it always
queues the new sk_buffs into an intermediate queue (send_pkt_queue)
and schedules a worker (send_pkt_work) to then queue them into the
virtqueue exposed to the device.

This increases the chance of batching, but also introduces a lot of
latency into the communication. So we can optimize this path by
adding a fast path to be taken when there is no element in the
intermediate queue, there is space available in the virtqueue,
and no other process that is sending packets (tx_lock held).

The following benchmarks were run to check improvements in latency and
throughput. The test bed is a host with Intel i7-10700KF CPU @ 3.80GHz
and L1 guest running on QEMU/KVM with vhost process and all vCPUs
pinned individually to pCPUs.

- Latency
   Tool: Fio version 3.37-56
   Mode: pingpong (h-g-h)
   Test runs: 50
   Runtime-per-test: 50s
   Type: SOCK_STREAM

In the following fio benchmark (pingpong mode) the host sends
a payload to the guest and waits for the same payload back.

fio process pinned both inside the host and the guest system.

Before: Linux 6.9.8

Payload 64B:

	1st perc.	overall		99th perc.
Before	12.91		16.78		42.24		us
After	9.77		13.57		39.17		us

Payload 512B:

	1st perc.	overall		99th perc.
Before	13.35		17.35		41.52		us
After	10.25		14.11		39.58		us

Payload 4K:

	1st perc.	overall		99th perc.
Before	14.71		19.87		41.52		us
After	10.51		14.96		40.81		us

- Throughput
   Tool: iperf-vsock

The size represents the buffer length (-l) to read/write
P represents the number of parallel streams

P=1
	4K	64K	128K
Before	6.87	29.3	29.5 Gb/s
After	10.5	39.4	39.9 Gb/s

P=2
	4K	64K	128K
Before	10.5	32.8	33.2 Gb/s
After	17.8	47.7	48.5 Gb/s

P=4
	4K	64K	128K
Before	12.7	33.6	34.2 Gb/s
After	16.9	48.1	50.5 Gb/s

The performance improvement is related to this optimization,
I used a ebpf kretprobe on virtio_transport_send_skb to check
that each packet was sent directly to the virtqueue

Co-developed-by: Marco Pinna <marco.pinn95@gmail.com>
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 net/vmw_vsock/virtio_transport.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f641e906f351..f992f9a216f0 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -208,6 +208,28 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+/* Caller need to hold RCU for vsock.
+ * Returns 0 if the packet is successfully put on the vq.
+ */
+static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struct sk_buff *skb)
+{
+	struct virtqueue *vq = vsock->vqs[VSOCK_VQ_TX];
+	int ret;
+
+	/* Inside RCU, can't sleep! */
+	ret = mutex_trylock(&vsock->tx_lock);
+	if (unlikely(ret == 0))
+		return -EBUSY;
+
+	ret = virtio_transport_send_skb(skb, vq, vsock);
+	if (ret == 0)
+		virtqueue_kick(vq);
+
+	mutex_unlock(&vsock->tx_lock);
+
+	return ret;
+}
+
 static int
 virtio_transport_send_pkt(struct sk_buff *skb)
 {
@@ -231,11 +253,20 @@ virtio_transport_send_pkt(struct sk_buff *skb)
 		goto out_rcu;
 	}
 
-	if (virtio_vsock_skb_reply(skb))
-		atomic_inc(&vsock->queued_replies);
+	/* If send_pkt_queue is empty, we can safely bypass this queue
+	 * because packet order is maintained and (try) to put the packet
+	 * on the virtqueue using virtio_transport_send_skb_fast_path.
+	 * If this fails we simply put the packet on the intermediate
+	 * queue and schedule the worker.
+	 */
+	if (!skb_queue_empty_lockless(&vsock->send_pkt_queue) ||
+	    virtio_transport_send_skb_fast_path(vsock, skb)) {
+		if (virtio_vsock_skb_reply(skb))
+			atomic_inc(&vsock->queued_replies);
 
-	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
-	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+		virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
+		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
+	}
 
 out_rcu:
 	rcu_read_unlock();

-- 
2.45.2



