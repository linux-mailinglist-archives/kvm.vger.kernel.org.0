Return-Path: <kvm+bounces-56539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 425E5B3F7DE
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72D104877E8
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E862E8B8C;
	Tue,  2 Sep 2025 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="EegUHrcw"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECC22E6CC8;
	Tue,  2 Sep 2025 08:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800621; cv=none; b=JrL0+vqBJxbMZFeDqLALkh6G9dIx9WYETzL6/rFhTjQpIsAl+n4iKaZ62SYdkeYWufZnm36cqgjIqhwUml2uwOZJCJHWshoBzzzH2oAB+OvN+EsU0CJDO/yYVc0iwAb3+CygBEcwUW7UN/rb2ys/EOKmfyxRZcWVGJ21q2h5AWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800621; c=relaxed/simple;
	bh=HBmY7vQEFqMz0J92IFcKEfGWzZs1VRvbCj8tHQAbbmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEkskU+R1ORWBh7b5JwYVGMMvT5kuGiXP/VLGOYZgn+q3iOtZtLIYnimyyBv2BkkqW0P0L1EpBlQteVrW1DIpgtCCGtnvThiLOFIUOs5QlZfiXEL9ZTMVOv1ijl2H9n9sjBXxpok1RimmirUw/VOJ35Rc5RuSHCBXQKsZTnbOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=EegUHrcw; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.tu-dortmund.de (rechenknecht2.kn.e-technik.tu-dortmund.de [129.217.186.41])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.9/8.18.1.10) with ESMTPSA id 58289x6X004012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Sep 2025 10:10:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756800609;
	bh=HBmY7vQEFqMz0J92IFcKEfGWzZs1VRvbCj8tHQAbbmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EegUHrcwUh0aQhfQjkGSzOf+cHnbd2xM6k+4P+8WighQWlkQFGY6fQUY2GJxn1zjR
	 T+i7Urfqo96REY/LIlJycWq0w1ethRU+ms4YaOX9t9R8ZvagrDhrp9hY+gtJxpEH/C
	 B65rGm4xSs1AOOCuGyFxe/xHV5qRSSe3tm2QBNJo=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH 3/4] netdev queue flow control for TAP
Date: Tue,  2 Sep 2025 10:09:56 +0200
Message-ID: <20250902080957.47265-4-simon.schippers@tu-dortmund.de>
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

Stopping the netdev queue is done in tun_net_xmit, as TAP uses this method
as its ndo_start_xmit.

To wake the queue, the new helper wake_netdev_queue is called in
tap_do_read. This is done in the blocking wait queue and after consuming
an SKB from the ptr_ring. This helper first checks if the netdev queue has
stopped. Then with the smp_rmb(), which is paired with the smp_wmb() of
tun_net_xmit, it is known that tun_net_xmit will not produce SKBs anymore.
With that knowledge, the helper can then wake the netdev queue if there is
at least a single spare slot. This check is done by calling the method
ptr_ring_spare.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1197f245e873..4d874672bcd7 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -753,6 +753,24 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	return ret ? ret : total;
 }
 
+static inline void wake_netdev_queue(struct tap_queue *q)
+{
+	struct netdev_queue *txq;
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(q->tap)->dev;
+	txq = netdev_get_tx_queue(dev, q->queue_index);
+
+	if (netif_tx_queue_stopped(txq)) {
+		/* Paired with smp_wmb() in tun_net_xmit. */
+		smp_rmb();
+		if (ptr_ring_spare(&q->ring, 1))
+			netif_tx_wake_queue(txq);
+	}
+	rcu_read_unlock();
+}
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
@@ -785,12 +803,16 @@ static ssize_t tap_do_read(struct tap_queue *q,
 			ret = -ERESTARTSYS;
 			break;
 		}
+		wake_netdev_queue(q);
+
 		/* Nothing to read, let's sleep */
 		schedule();
 	}
 	if (!noblock)
 		finish_wait(sk_sleep(&q->sk), &wait);
 
+	wake_netdev_queue(q);
+
 put:
 	if (skb) {
 		ret = tap_put_user(q, skb, to);
-- 
2.43.0


