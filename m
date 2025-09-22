Return-Path: <kvm+bounces-58420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F27B9375B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D8727B2303
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3765031D389;
	Mon, 22 Sep 2025 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="qHOopKzw"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7906227876A;
	Mon, 22 Sep 2025 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579432; cv=none; b=uIzEzO++XBLJSUMPi4vRpF620FGe5gbRzEy+zj7FUWnfAtOl71cxXQRUEqRhP5TCOHpJYmooGHom6ojoy4/DQdXm/8cZmfqkcUNh5FcSeegCZy4x+iA4SUsrpyQ13BYPOTCwVwqK2xFmKfnHdKoYzaCQRzAzHUOagvbtMqSoZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579432; c=relaxed/simple;
	bh=V+PhwFYWszbBXgU4tk0LQIa75F+W369ypV6Mf0SMujk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Czx79+vBKmm2wLRfUBU7gSuuOnKSK79ma9bl6nQKlnsaWmEOlJa6F8UAkF+8asfd5xEsWWORWjOqfqz7PAsPES3s7V5LC+rFrh+PMBUfLZvDOVY4yM2omgdiksRimvIX6PBC9CNrwTj7fVciAY9DPYEqtMJQqJvSAtKL6ycZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=qHOopKzw; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4ef003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579426;
	bh=V+PhwFYWszbBXgU4tk0LQIa75F+W369ypV6Mf0SMujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHOopKzw0deAfiXZsLK/nqv7nyVPFWw4uKo3c1M6/LnHpjmn52MQkI7JABdQQopah
	 MOvru5fzwIbah4vSFj41z1ym68i2LZo+CevKfEVv4cl/YT9sk496iVDEM2NQh54Ftz
	 q2aJddPTvE7f57kq+ay9GJwrsdwtcFIVK+YcV58o=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after consuming an entry
Date: Tue, 23 Sep 2025 00:15:49 +0200
Message-ID: <20250922221553.47802-5-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new wrappers tun_ring_consume/tap_ring_consume deal with consuming an
entry of the ptr_ring and then waking the netdev queue when entries got
invalidated to be used again by the producer.
To avoid waking the netdev queue when the ptr_ring is full, it is checked
if the netdev queue is stopped before invalidating entries. Like that the
netdev queue can be safely woken after invalidating entries.

The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
__ptr_ring_produce within tun_net_xmit guarantees that the information
about the netdev queue being stopped is visible after __ptr_ring_peek is
called.

The netdev queue is also woken after resizing the ptr_ring.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/tun.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1197f245e873..f8292721a9d6 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -753,6 +753,46 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	return ret ? ret : total;
 }
 
+static struct sk_buff *tap_ring_consume(struct tap_queue *q)
+{
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool will_invalidate;
+	bool stopped;
+	void *ptr;
+
+	spin_lock(&q->ring.consumer_lock);
+	ptr = __ptr_ring_peek(&q->ring);
+	if (!ptr) {
+		spin_unlock(&q->ring.consumer_lock);
+		return ptr;
+	}
+
+	/* Check if the queue stopped before zeroing out, so no ptr get
+	 * produced in the meantime, because this could result in waking
+	 * even though the ptr_ring is full. The order of the operations
+	 * is ensured by barrier().
+	 */
+	will_invalidate = __ptr_ring_will_invalidate(&q->ring);
+	if (unlikely(will_invalidate)) {
+		rcu_read_lock();
+		dev = rcu_dereference(q->tap)->dev;
+		txq = netdev_get_tx_queue(dev, q->queue_index);
+		stopped = netif_tx_queue_stopped(txq);
+	}
+	barrier();
+	__ptr_ring_discard_one(&q->ring, will_invalidate);
+
+	if (unlikely(will_invalidate)) {
+		if (stopped)
+			netif_tx_wake_queue(txq);
+		rcu_read_unlock();
+	}
+	spin_unlock(&q->ring.consumer_lock);
+
+	return ptr;
+}
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
@@ -774,7 +814,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
 					TASK_INTERRUPTIBLE);
 
 		/* Read frames from the queue */
-		skb = ptr_ring_consume(&q->ring);
+		skb = tap_ring_consume(q);
 		if (skb)
 			break;
 		if (noblock) {
@@ -1207,6 +1247,8 @@ int tap_queue_resize(struct tap_dev *tap)
 	ret = ptr_ring_resize_multiple_bh(rings, n,
 					  dev->tx_queue_len, GFP_KERNEL,
 					  __skb_array_destroy_skb);
+	if (netif_running(dev))
+		netif_tx_wake_all_queues(dev);
 
 	kfree(rings);
 	return ret;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c6b22af9bae8..682df8157b55 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2114,13 +2114,53 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	return total;
 }
 
+static void *tun_ring_consume(struct tun_file *tfile)
+{
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool will_invalidate;
+	bool stopped;
+	void *ptr;
+
+	spin_lock(&tfile->tx_ring.consumer_lock);
+	ptr = __ptr_ring_peek(&tfile->tx_ring);
+	if (!ptr) {
+		spin_unlock(&tfile->tx_ring.consumer_lock);
+		return ptr;
+	}
+
+	/* Check if the queue stopped before zeroing out, so no ptr get
+	 * produced in the meantime, because this could result in waking
+	 * even though the ptr_ring is full. The order of the operations
+	 * is ensured by barrier().
+	 */
+	will_invalidate = __ptr_ring_will_invalidate(&tfile->tx_ring);
+	if (unlikely(will_invalidate)) {
+		rcu_read_lock();
+		dev = rcu_dereference(tfile->tun)->dev;
+		txq = netdev_get_tx_queue(dev, tfile->queue_index);
+		stopped = netif_tx_queue_stopped(txq);
+	}
+	barrier();
+	__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
+
+	if (unlikely(will_invalidate)) {
+		if (stopped)
+			netif_tx_wake_queue(txq);
+		rcu_read_unlock();
+	}
+	spin_unlock(&tfile->tx_ring.consumer_lock);
+
+	return ptr;
+}
+
 static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	void *ptr = NULL;
 	int error = 0;
 
-	ptr = ptr_ring_consume(&tfile->tx_ring);
+	ptr = tun_ring_consume(tfile);
 	if (ptr)
 		goto out;
 	if (noblock) {
@@ -2132,7 +2172,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ptr = ptr_ring_consume(&tfile->tx_ring);
+		ptr = tun_ring_consume(tfile);
 		if (ptr)
 			break;
 		if (signal_pending(current)) {
@@ -3621,6 +3661,9 @@ static int tun_queue_resize(struct tun_struct *tun)
 					  dev->tx_queue_len, GFP_KERNEL,
 					  tun_ptr_free);
 
+	if (netif_running(dev))
+		netif_tx_wake_all_queues(dev);
+
 	kfree(rings);
 	return ret;
 }
-- 
2.43.0


