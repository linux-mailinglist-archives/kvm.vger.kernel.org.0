Return-Path: <kvm+bounces-56537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD97CB3F7DF
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7FD020320B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E822EA72E;
	Tue,  2 Sep 2025 08:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="cUQ38nlx"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D549A2E8B7B;
	Tue,  2 Sep 2025 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800621; cv=none; b=qlnPAtd25UD8KRn4w+vBj1NVqcDAYgacGwr7+gzBWDG6hca9rWzLfX2GNVSikJghDxikWl5aTNiIvkaJa0BnbVV9JT0L5Hil6vTSbq9LGMsu88/ijnI97YNXIROIWY9BST9rX2Ek993k8v6cRHMa3DoNG/+sz6e0N5VRqJ2YcfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800621; c=relaxed/simple;
	bh=dwrG5IZYDXYoD9+oEiwigp/MhGkl8O8eBM7BT7aMgHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6F3YSTpibv93YI2OyvEj1oedF1wVksF/fuC5P6g98rG94qDpEavidHGnTfKUxqVYXmP/tC279rpDPFoV/YKMasUbALmkDY81vQPGfGFLLRyLZeWVqCoy/lDnqkngvgfaIno+8FqtYR3fHIhgWP0VjC7MnpBnnJYYsMbmYZR9hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=cUQ38nlx; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.tu-dortmund.de (rechenknecht2.kn.e-technik.tu-dortmund.de [129.217.186.41])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.9/8.18.1.10) with ESMTPSA id 58289x6V004012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Sep 2025 10:10:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756800608;
	bh=dwrG5IZYDXYoD9+oEiwigp/MhGkl8O8eBM7BT7aMgHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUQ38nlxON2+dUHnC7YPhiqCUV/sG2ck069Eedl8d4RrPp9kBMATIx+oQNMkgL0ZN
	 X69ABnd30SZFJdOOGEh6wGCfUG8fqiFGpYsf9LHH461wHj6Q48UBlnJL7UJAu7LS6m
	 0FZzPtvYOifQAHFf3F09bAJguTp4LcRE+EDFUCWg=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH 2/4] netdev queue flow control for TUN
Date: Tue,  2 Sep 2025 10:09:55 +0200
Message-ID: <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The netdev queue is stopped in tun_net_xmit after inserting an SKB into
the ring buffer if the ring buffer became full because of that. If the
insertion into the ptr_ring fails, the netdev queue is also stopped and
the SKB is dropped. However, this never happened in my testing. To ensure
that the ptr_ring change is available to the consumer before the netdev
queue stop, an smp_wmb() is used.

Then in tun_ring_recv, the new helper wake_netdev_queue is called in the
blocking wait queue and after consuming an SKB from the ptr_ring. This
helper first checks if the netdev queue has stopped. Then with the paired
smp_rmb() it is known that tun_net_xmit will not produce SKBs anymore.
With that knowledge, the helper can then wake the netdev queue if there is
at least a single spare slot in the ptr_ring by calling ptr_ring_spare
with cnt=1.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tun.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index cc6c50180663..735498e221d8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1060,13 +1060,21 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+	queue = netdev_get_tx_queue(dev, txq);
+	if (unlikely(ptr_ring_produce(&tfile->tx_ring, skb))) {
+		/* Paired with smp_rmb() in wake_netdev_queue. */
+		smp_wmb();
+		netif_tx_stop_queue(queue);
 		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
 	}
+	if (ptr_ring_full(&tfile->tx_ring)) {
+		/* Paired with smp_rmb() in wake_netdev_queue. */
+		smp_wmb();
+		netif_tx_stop_queue(queue);
+	}
 
 	/* dev->lltx requires to do our own update of trans_start */
-	queue = netdev_get_tx_queue(dev, txq);
 	txq_trans_cond_update(queue);
 
 	/* Notify and wake up reader process */
@@ -2110,6 +2118,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	return total;
 }
 
+static inline void wake_netdev_queue(struct tun_file *tfile)
+{
+	struct netdev_queue *txq;
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(tfile->tun)->dev;
+	txq = netdev_get_tx_queue(dev, tfile->queue_index);
+
+	if (netif_tx_queue_stopped(txq)) {
+		/* Paired with smp_wmb() in tun_net_xmit. */
+		smp_rmb();
+		if (ptr_ring_spare(&tfile->tx_ring, 1))
+			netif_tx_wake_queue(txq);
+	}
+	rcu_read_unlock();
+}
+
 static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -2139,7 +2165,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 			error = -EFAULT;
 			break;
 		}
-
+		wake_netdev_queue(tfile);
 		schedule();
 	}
 
@@ -2147,6 +2173,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	remove_wait_queue(&tfile->socket.wq.wait, &wait);
 
 out:
+	wake_netdev_queue(tfile);
 	*err = error;
 	return ptr;
 }
-- 
2.43.0


