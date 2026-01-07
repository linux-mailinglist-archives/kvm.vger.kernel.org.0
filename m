Return-Path: <kvm+bounces-67286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1288CD001F5
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 459223038699
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DE1342C9A;
	Wed,  7 Jan 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="fd2Hco7e"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42E033ADA2;
	Wed,  7 Jan 2026 21:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819980; cv=none; b=a2I/bm+f0vnV76GvMaVRhHpT4BwlDU8/5yeVDqfPiFjnYQm9DvGSNOJmEEZJ97ZYE5/FjCEjUpArSX7rTUP0htdQU1TDvPlgdx/ZklHCF65y4EKZvQe1zG7XvM3WlaFS5s23b23NfouW7PzinNyEwpzUPUvgI0D/TUkVCtpoEqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819980; c=relaxed/simple;
	bh=ek1z7wPVwY/RL+3lP3ES8isx76ej3dySxD1Usm9nlMM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd4OyNrCGPFL5ElQ8Y7vQcGdC1RtDBwmOV42KXXOx4eeqngkHXZvpEIgVVLXQlaxDEUTpzJYO3eh/dckwI5wOxMiF3LzUzrAXHejcW35OrNgs1a2O8+cimVQ5wPbvvj4Xh47nGn/lBFQsI8eFcbhewLimu3B4PadbjwXmD76bwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=fd2Hco7e; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9X026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819964;
	bh=ek1z7wPVwY/RL+3lP3ES8isx76ej3dySxD1Usm9nlMM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fd2Hco7eBApgutlmX/fYDbwXKtsij9SMRhL6m0GIzT4XD6+PTcRKadTa3DcjK5p5T
	 MOcX0C6calTyOUdoa/2BvBvPYdySrb/yIFMCOGTmzRn1PbHWYx6dSsTCT1Iua3mdOg
	 zGrY2OFjdvbgKORtqVTjq3AdfS8A7i2IQAWkPGhQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring tail-drop when qdisc is present
Date: Wed,  7 Jan 2026 22:04:48 +0100
Message-ID: <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
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

This commit prevents tail-drop when a qdisc is present and the ptr_ring
becomes full. Once an entry is successfully produced and the ptr_ring
reaches capacity, the netdev queue is stopped instead of dropping
subsequent packets.

If producing an entry fails anyways, the tun_net_xmit returns
NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected because
LLTX is enabled and the transmit path operates without the usual locking.
As a result, concurrent calls to tun_net_xmit() are not prevented.

The existing __{tun,tap}_ring_consume functions free space in the
ptr_ring and wake the netdev queue. Races between this wakeup and the
queue-stop logic could leave the queue stopped indefinitely. To prevent
this, a memory barrier is enforced (as discussed in a similar
implementation in [1]), followed by a recheck that wakes the queue if
space is already available.

If no qdisc is present, the previous tail-drop behavior is preserved.

+-------------------------+-----------+---------------+----------------+
| pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
| Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
| 10M packets             |           |               |                |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
|           +-------------+-----------+---------------+----------------+
|           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+
| TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
|  +        +-------------+-----------+---------------+----------------+
| vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
+-----------+-------------+-----------+---------------+----------------+

[1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.org/

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 71b6981d07d7..74d7fd09e9ba 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *queue;
 	struct tun_file *tfile;
 	int len = skb->len;
+	bool qdisc_present;
+	int ret;
 
 	rcu_read_lock();
 	tfile = rcu_dereference(tun->tfiles[txq]);
@@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+	queue = netdev_get_tx_queue(dev, txq);
+	qdisc_present = !qdisc_txq_has_no_queue(queue);
+
+	spin_lock(&tfile->tx_ring.producer_lock);
+	ret = __ptr_ring_produce(&tfile->tx_ring, skb);
+	if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present) {
+		netif_tx_stop_queue(queue);
+		/* Avoid races with queue wake-up in
+		 * __{tun,tap}_ring_consume by waking if space is
+		 * available in a re-check.
+		 * The barrier makes sure that the stop is visible before
+		 * we re-check.
+		 */
+		smp_mb__after_atomic();
+		if (!__ptr_ring_produce_peek(&tfile->tx_ring))
+			netif_tx_wake_queue(queue);
+	}
+	spin_unlock(&tfile->tx_ring.producer_lock);
+
+	if (ret) {
+		/* If a qdisc is attached to our virtual device,
+		 * returning NETDEV_TX_BUSY is allowed.
+		 */
+		if (qdisc_present) {
+			rcu_read_unlock();
+			return NETDEV_TX_BUSY;
+		}
 		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
 	}
 
 	/* dev->lltx requires to do our own update of trans_start */
-	queue = netdev_get_tx_queue(dev, txq);
 	txq_trans_cond_update(queue);
 
 	/* Notify and wake up reader process */
-- 
2.43.0


