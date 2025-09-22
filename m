Return-Path: <kvm+bounces-58418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0025AB93746
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909FD1907FA6
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A5731AF3E;
	Mon, 22 Sep 2025 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="AcPd6d97"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FF1275B13;
	Mon, 22 Sep 2025 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579431; cv=none; b=YQl76CwhKSmKnVCErprsrmbykDNR+FBHJuS2lf8rOmgymhxBDqFRRUjHL+GbF4nHpaGNLjCK4xpVcGRNb+FHPXfuY8Yhgy5W2kCVtBgOHzk+rgRmw266aBn6U58DJvInQ7m+zl+JGtKqW+HjSnsmu6jLJ7Pnh5ZD/PyaGU1dflo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579431; c=relaxed/simple;
	bh=REBZqS6e4wRdWD+7hW/SpQ4itfFDNainpjcwtocQKbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FV3A4BX/9qXY0y58AJnStwu8fFpzi2PXUPSrc0qHmcPYqWb5hk+BuDJI6RFFcUQsPq8NcAcT2ZU4bzQhvhQ6qe531hjHwhcdKQjXknWbrIiGnXM7w/N8ELiq2kPvGfB/7RynsGx5lTbHVxzaYtQ0d/Q5KpkaACIWMqhm4oen5js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=AcPd6d97; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4ed003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579426;
	bh=REBZqS6e4wRdWD+7hW/SpQ4itfFDNainpjcwtocQKbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcPd6d97+fFDBsnDH4VaeUdvo/pL9mBI6aTNg0ahTO50boBqOQ4D1Say40qTU6qf/
	 lZDydUgmGDWRkYRavJWkyFGcBz6/d4Q0xfHd/VkUb5vBxTmFcpSYkrGYHZrD8fkxDl
	 2hiylrD27wXJdrv8/I+Q9gtouuCA59moY/CQiWLI=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 3/8] TUN, TAP & vhost_net: Stop netdev queue before reaching a full ptr_ring
Date: Tue, 23 Sep 2025 00:15:48 +0200
Message-ID: <20250922221553.47802-4-simon.schippers@tu-dortmund.de>
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

Stop the netdev queue ahead of __ptr_ring_produce when
__ptr_ring_full_next signals the ring is about to fill. Due to the
smp_wmb() of __ptr_ring_produce the consumer is guaranteed to be able to
notice the stopped netdev queue after seeing the new ptr_ring entry. As
both __ptr_ring_full_next and __ptr_ring_produce need the producer_lock,
the lock is held during the execution of both methods.

dev->lltx is disabled to ensure that tun_net_xmit is not called even
though the netdev queue is stopped (which happened in my testing,
resulting in rare packet drops). Consequently, the update of trans_start
in tun_net_xmit is also removed.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tun.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 86a9e927d0ff..c6b22af9bae8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -931,7 +931,7 @@ static int tun_net_init(struct net_device *dev)
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
 			       NETIF_F_HW_VLAN_STAG_TX);
-	dev->lltx = true;
+	dev->lltx = false;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
@@ -1060,14 +1060,18 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	nf_reset_ct(skb);
 
-	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
+	queue = netdev_get_tx_queue(dev, txq);
+
+	spin_lock(&tfile->tx_ring.producer_lock);
+	if (__ptr_ring_full_next(&tfile->tx_ring))
+		netif_tx_stop_queue(queue);
+
+	if (unlikely(__ptr_ring_produce(&tfile->tx_ring, skb))) {
+		spin_unlock(&tfile->tx_ring.producer_lock);
 		drop_reason = SKB_DROP_REASON_FULL_RING;
 		goto drop;
 	}
-
-	/* dev->lltx requires to do our own update of trans_start */
-	queue = netdev_get_tx_queue(dev, txq);
-	txq_trans_cond_update(queue);
+	spin_unlock(&tfile->tx_ring.producer_lock);
 
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
-- 
2.43.0


