Return-Path: <kvm+bounces-67281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2071FD00217
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD7FB3028FFA
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6398333E348;
	Wed,  7 Jan 2026 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="MZSj2aIN"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB012EC08C;
	Wed,  7 Jan 2026 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819979; cv=none; b=KoOIruqpjxWgR9z68DAfGJhdEcnaIeXn0aD9eMdM/qv/eVo8MsBnsG19SQ5XRjZQZB+SzEVC6Jca8V9/9csZDgfznaz/KpBhtu5dU4m1f6PdQUv1MFwLm22JhlulNrB3kAqQpmj19qhcPFQ1kvh/a5gTaQS5tsUwszKQN81S5hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819979; c=relaxed/simple;
	bh=HCYmM7s6dRW4FQSt1RT7rihNxVFUvMIz4wDTbzVtfKY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujKpfQvXUkasSzD8S9yj25wuDQJZxuD/4Q0h/gMi8QY38sNMILnHaLvZpo2a75sc2BGfPIWAa9p63ubdWHVKTb8ZQMmJvnAXWWlMamjGJpVmspy1H6Lrvf3qxIdm/KZdNN7+KHLwamZxGC15Smox9MpSxdIOg/xm/PpTXJdmHLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=MZSj2aIN; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9L026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819961;
	bh=HCYmM7s6dRW4FQSt1RT7rihNxVFUvMIz4wDTbzVtfKY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=MZSj2aINfNzYv20xgimT8AkTfn37kMqJ7jcnfk34vLqS0dL90WgOOC5a2rrJolemK
	 WszEobn7ee4EvEkozDEisv/rwCmto6DSeYse+CGdkcRbW1IvLKxZFn7zprO6cJRiMa
	 zfCpTr4uAaovfiq2+0MffQrkD0km4mP1ok/YiVFc=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with netdev queue wakeup
Date: Wed,  7 Jan 2026 22:04:42 +0100
Message-ID: <20260107210448.37851-4-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_consume()
and wake the corresponding netdev subqueue when consuming an entry frees
space in the underlying ptr_ring.

Stopping of the netdev queue when the ptr_ring is full will be introduced
in an upcoming commit.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c | 23 ++++++++++++++++++++++-
 drivers/net/tun.c | 25 +++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1197f245e873..2442cf7ac385 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	return ret ? ret : total;
 }
 
+static void *tap_ring_consume(struct tap_queue *q)
+{
+	struct ptr_ring *ring = &q->ring;
+	struct net_device *dev;
+	void *ptr;
+
+	spin_lock(&ring->consumer_lock);
+
+	ptr = __ptr_ring_consume(ring);
+	if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
+		rcu_read_lock();
+		dev = rcu_dereference(q->tap)->dev;
+		netif_wake_subqueue(dev, q->queue_index);
+		rcu_read_unlock();
+	}
+
+	spin_unlock(&ring->consumer_lock);
+
+	return ptr;
+}
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
@@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
 					TASK_INTERRUPTIBLE);
 
 		/* Read frames from the queue */
-		skb = ptr_ring_consume(&q->ring);
+		skb = tap_ring_consume(q);
 		if (skb)
 			break;
 		if (noblock) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8192740357a0..7148f9a844a4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	return total;
 }
 
+static void *tun_ring_consume(struct tun_file *tfile)
+{
+	struct ptr_ring *ring = &tfile->tx_ring;
+	struct net_device *dev;
+	void *ptr;
+
+	spin_lock(&ring->consumer_lock);
+
+	ptr = __ptr_ring_consume(ring);
+	if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1))) {
+		rcu_read_lock();
+		dev = rcu_dereference(tfile->tun)->dev;
+		netif_wake_subqueue(dev, tfile->queue_index);
+		rcu_read_unlock();
+	}
+
+	spin_unlock(&ring->consumer_lock);
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
@@ -2131,7 +2152,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ptr = ptr_ring_consume(&tfile->tx_ring);
+		ptr = tun_ring_consume(tfile);
 		if (ptr)
 			break;
 		if (signal_pending(current)) {
-- 
2.43.0


