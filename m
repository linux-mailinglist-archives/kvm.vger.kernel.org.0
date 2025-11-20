Return-Path: <kvm+bounces-63881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D674C750A2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 1C8DE315C5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FFB3AA1B8;
	Thu, 20 Nov 2025 15:30:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1536C0C2;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652612; cv=none; b=YfkDFKvDz0MQ4Ij9c2Yg301CxtR7NGkXOIhSkttACUBLXVFJsGBrKbtyKROMRakOsMBW+zzpBoZlwN2JgD437jjPY1BgFzIGBkstmotLpzC4GYUe6e+kXJY0/w4QyfoX1IHpkYWu8cU2G0zqLygWKIrnLT/FoOSyP3/3ydhe9tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652612; c=relaxed/simple;
	bh=k/tQZZTHDwqHfW5FcO+N2Hvs0IxAV0hy2fbsJrwuic4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecm920DYYLdBCvlhHzO6z2dpJz2d9MCuHCXTPOF4OlpkV6Gz/XIP+Z9Tfx3R/7P6/ZoRbfooLf8U/wbJr6dJaPGtyWKyXvgHsfgWxIffPUznPVgmXjm+hPqu3KOwHBom1dhOzIJwzpE+Sscm6BJc8bsMdo3mJck8XWtdvBS4Qpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8C005406
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 16:29:58 +0100 (CET)
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v6 3/8] tun/tap: add synchronized ring produce/consume with queue management
Date: Thu, 20 Nov 2025 16:29:08 +0100
Message-ID: <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement new ring buffer produce and consume functions for tun and tap
drivers that provide lockless producer-consumer synchronization and
netdev queue management to prevent ptr_ring tail drop and permanent
starvation.

- tun_ring_produce(): Produces packets to the ptr_ring with proper memory
  barriers and proactively stops the netdev queue when the ring is about
  to become full.

- __tun_ring_consume() / __tap_ring_consume(): Internal consume functions
  that check if the netdev queue was stopped due to a full ring, and wake
  it when space becomes available. Uses memory barriers to ensure proper
  ordering between producer and consumer.

- tun_ring_consume() / tap_ring_consume(): Wrapper functions that acquire
  the consumer lock before calling the internal consume functions.

Key features:
- Proactive queue stopping using __ptr_ring_full_next() to stop the queue
  before it becomes completely full.
- Not stopping the queue when the ptr_ring is full already, because if
  the consumer empties all entries in the meantime, stopping the queue
  would cause permanent starvation.
- Conditional queue waking using __ptr_ring_consume_created_space() to
  wake the queue only when space is actually created in the ring.
- Prevents permanent starvation by ensuring the queue is also woken when
  the ring becomes empty, which can happen when racing the producer.

NB: __always_unused on unused functions, to be removed later in the
series to not break bisectability.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c |  63 +++++++++++++++++++++++++++++
 drivers/net/tun.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1197f245e873..c370a02789eb 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -753,6 +753,69 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	return ret ? ret : total;
 }
 
+/*
+ * Consume a packet from the transmit ring. Callers must hold
+ * the consumer_lock of the ptr_ring. If the ring was full and the
+ * queue was stopped, this may wake up the queue if space is created.
+ */
+static void *__tap_ring_consume(struct tap_queue *q)
+{
+	struct ptr_ring *ring = &q->ring;
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool stopped;
+	void *ptr;
+
+	ptr = __ptr_ring_peek(ring);
+	if (!ptr)
+		return ptr;
+
+	/* Paired with smp_wmb() in the ring producer path. Ensures we
+	 * see any updated netdev queue state caused by a full ring.
+	 * Needed for proper synchronization between the ring and the
+	 * netdev queue.
+	 */
+	smp_rmb();
+	rcu_read_lock();
+	dev = rcu_dereference(q->tap)->dev;
+	txq = netdev_get_tx_queue(dev, q->queue_index);
+	stopped = netif_tx_queue_stopped(txq);
+
+	/* Ensures the read for a stopped queue completes before the
+	 * discard, so that we don't miss the window to wake the queue if
+	 * needed.
+	 */
+	smp_rmb();
+	__ptr_ring_discard_one(ring);
+
+	/* If the queue was stopped (meaning the producer couldn't have
+	 * inserted new entries just now), and we have actually created
+	 * space in the ring, or the ring is now empty (due to a race
+	 * with the producer), then it is now safe to wake the queue.
+	 */
+	if (unlikely(stopped &&
+		     (__ptr_ring_consume_created_space(ring) ||
+		      __ptr_ring_empty(ring)))) {
+		/* Paired with smp_rmb() in tun_ring_produce. */
+		smp_wmb();
+		netif_tx_wake_queue(txq);
+	}
+	rcu_read_unlock();
+
+	return ptr;
+}
+
+static __always_unused void *tap_ring_consume(struct tap_queue *q)
+{
+	void *ptr;
+
+	spin_lock(&q->ring.consumer_lock);
+	ptr = __tap_ring_consume(q);
+	spin_unlock(&q->ring.consumer_lock);
+
+	return ptr;
+}
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8192740357a0..3b9d8d406ff5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -999,6 +999,107 @@ static unsigned int run_ebpf_filter(struct tun_struct *tun,
 	return len;
 }
 
+/* Produce a packet into the transmit ring. If the ring becomes full, the
+ * netdev queue is stopped until the consumer wakes it again.
+ */
+static __always_unused int tun_ring_produce(struct ptr_ring *ring,
+					    struct netdev_queue *queue,
+					    struct sk_buff *skb)
+{
+	int ret;
+
+	spin_lock(&ring->producer_lock);
+
+	/* Pairs with smp_wmb() in __tun_ring_consume/__tap_ring_consume.
+	 * Ensures that freed space by the consumer is visible.
+	 */
+	smp_rmb();
+
+	/* Do not stop the netdev queue if the ptr_ring is full already.
+	 * The consumer could empty out the ptr_ring in the meantime
+	 * without noticing the stopped netdev queue, resulting in a
+	 * stopped netdev queue and an empty ptr_ring. In this case the
+	 * netdev queue would stay stopped forever.
+	 */
+	if (unlikely(!__ptr_ring_full(ring) &&
+		     __ptr_ring_full_next(ring)))
+		netif_tx_stop_queue(queue);
+
+	/* Note: __ptr_ring_produce has an internal smp_wmb() to synchronize the
+	 * state with the consumer. This ensures that after adding an entry to
+	 * the ring, any stopped queue state is visible to the consumer after
+	 * dequeueing.
+	 */
+	ret = __ptr_ring_produce(ring, skb);
+
+	spin_unlock(&ring->producer_lock);
+
+	return ret;
+}
+
+/*
+ * Consume a packet from the transmit ring. Callers must hold
+ * the consumer_lock of the ptr_ring. If the ring was full and the
+ * queue was stopped, this may wake up the queue if space is created.
+ */
+static void *__tun_ring_consume(struct tun_file *tfile)
+{
+	struct ptr_ring *ring = &tfile->tx_ring;
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool stopped;
+	void *ptr;
+
+	ptr = __ptr_ring_peek(ring);
+	if (!ptr)
+		return ptr;
+
+	/* Paired with smp_wmb() in the ring producer path. Ensures we
+	 * see any updated netdev queue state caused by a full ring.
+	 * Needed for proper synchronization between the ring and the
+	 * netdev queue.
+	 */
+	smp_rmb();
+	rcu_read_lock();
+	dev = rcu_dereference(tfile->tun)->dev;
+	txq = netdev_get_tx_queue(dev, tfile->queue_index);
+	stopped = netif_tx_queue_stopped(txq);
+
+	/* Ensures the read for a stopped queue completes before the
+	 * discard, so that we don't miss the window to wake the queue if
+	 * needed.
+	 */
+	smp_rmb();
+	__ptr_ring_discard_one(ring);
+
+	/* If the queue was stopped (meaning the producer couldn't have
+	 * inserted new entries just now), and we have actually created
+	 * space in the ring, or the ring is now empty (due to a race
+	 * with the producer), then it is now safe to wake the queue.
+	 */
+	if (unlikely(stopped &&
+		     (__ptr_ring_consume_created_space(ring) ||
+		      __ptr_ring_empty(ring)))) {
+		/* Paired with smp_rmb() in tun_ring_produce. */
+		smp_wmb();
+		netif_tx_wake_queue(txq);
+	}
+	rcu_read_unlock();
+
+	return ptr;
+}
+
+static void __always_unused *tun_ring_consume(struct tun_file *tfile)
+{
+	void *ptr;
+
+	spin_lock(&tfile->tx_ring.consumer_lock);
+	ptr = __tun_ring_consume(tfile);
+	spin_unlock(&tfile->tx_ring.consumer_lock);
+
+	return ptr;
+}
+
 /* Net device start xmit */
 static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.43.0


