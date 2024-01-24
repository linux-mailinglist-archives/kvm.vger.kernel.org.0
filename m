Return-Path: <kvm+bounces-6817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE2183A5A7
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EC58293143
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2F3182B9;
	Wed, 24 Jan 2024 09:38:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015918026;
	Wed, 24 Jan 2024 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089111; cv=none; b=sccQI6Dl4HovtAYxCuEBkq22Jb2Zrdc9NsEAorbeaF0oQ7Rmuu6nGcWz3kWPlthck7icDmMeW5sZua2u+ZVhSLfIbRkXKrY7iXKkHDI6EpLvrIJvtnTPee7RDfQCcIVCgLeZWwaRRl/hhtjJ+ZNykF0M9OEGbpHJuXDhvPkGjOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089111; c=relaxed/simple;
	bh=T5ayTAfouFBwjrJF6QUSu4ZMjvzqmBUY0gCa9PlsZ8M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gA/NNnvNTUM1/mHk9D8kcq8CDC2PfAuM+CAIMrIQbtT1KyMVRJYjPPe+noU/H5g/v3t53zOHYX/9aLJ2R5r+bqkworRFBTXPbvr2OFiI56W8/VfIl3btC2dbWFT+B8+IWcvJ8QV7uQ8H5H/yqf3Fvuvvuxi76RJOyP4k+keJKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TKf4s273Mz1xmgG;
	Wed, 24 Jan 2024 17:37:33 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id AD6DC1A016F;
	Wed, 24 Jan 2024 17:38:10 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 24 Jan
 2024 17:37:57 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
	<magnus.karlsson@intel.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
Date: Wed, 24 Jan 2024 17:37:55 +0800
Message-ID: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500008.china.huawei.com (7.185.36.136)

Now the zero-copy feature of AF_XDP socket is supported by some
drivers, which can reduce CPU utilization on the xdp program.
This patch set allows tun to support AF_XDP Rx zero-copy feature.

This patch tries to address this by:
- Use peek_len to consume a xsk->desc and get xsk->desc length.
- When the tun support AF_XDP Rx zero-copy, the vq's array maybe empty.
So add a check for empty vq's array in vhost_net_buf_produce().
- add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
- add tun_put_user_desc function to copy the Rx data to VM

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/tun.c   | 165 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/net.c |  18 +++--
 2 files changed, 176 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index afa5497f7c35..248b0f8e07d1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -77,6 +77,7 @@
 #include <net/ax25.h>
 #include <net/rose.h>
 #include <net/6lowpan.h>
+#include <net/xdp_sock_drv.h>
 
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
@@ -145,6 +146,10 @@ struct tun_file {
 	struct tun_struct *detached;
 	struct ptr_ring tx_ring;
 	struct xdp_rxq_info xdp_rxq;
+	struct xdp_desc desc;
+	/* protects xsk pool */
+	spinlock_t pool_lock;
+	struct xsk_buff_pool *pool;
 };
 
 struct tun_page {
@@ -208,6 +213,8 @@ struct tun_struct {
 	struct bpf_prog __rcu *xdp_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
+	/* tracks AF_XDP ZC enabled queues */
+	unsigned long *af_xdp_zc_qps;
 	struct ethtool_link_ksettings link_ksettings;
 	/* init args */
 	struct file *file;
@@ -795,6 +802,8 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 	tfile->queue_index = tun->numqueues;
 	tfile->socket.sk->sk_shutdown &= ~RCV_SHUTDOWN;
+	tfile->desc.len = 0;
+	tfile->pool = NULL;
 
 	if (tfile->detached) {
 		/* Re-attach detached tfile, updating XDP queue_index */
@@ -989,6 +998,13 @@ static int tun_net_init(struct net_device *dev)
 		return err;
 	}
 
+	tun->af_xdp_zc_qps = bitmap_zalloc(MAX_TAP_QUEUES, GFP_KERNEL);
+	if (!tun->af_xdp_zc_qps) {
+		security_tun_dev_free_security(tun->security);
+		free_percpu(dev->tstats);
+		return -ENOMEM;
+	}
+
 	tun_flow_init(tun);
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
@@ -1009,6 +1025,7 @@ static int tun_net_init(struct net_device *dev)
 		tun_flow_uninit(tun);
 		security_tun_dev_free_security(tun->security);
 		free_percpu(dev->tstats);
+		bitmap_free(tun->af_xdp_zc_qps);
 		return err;
 	}
 	return 0;
@@ -1222,11 +1239,77 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return 0;
 }
 
+static int tun_xsk_pool_enable(struct net_device *netdev,
+			       struct xsk_buff_pool *pool,
+			       u16 qid)
+{
+	struct tun_struct *tun = netdev_priv(netdev);
+	struct tun_file *tfile;
+	unsigned long flags;
+
+	rcu_read_lock();
+	tfile = rtnl_dereference(tun->tfiles[qid]);
+	if (!tfile) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+
+	spin_lock_irqsave(&tfile->pool_lock, flags);
+	xsk_pool_set_rxq_info(pool, &tfile->xdp_rxq);
+	tfile->pool = pool;
+	spin_unlock_irqrestore(&tfile->pool_lock, flags);
+
+	rcu_read_unlock();
+	set_bit(qid, tun->af_xdp_zc_qps);
+
+	return 0;
+}
+
+static int tun_xsk_pool_disable(struct net_device *netdev, u16 qid)
+{
+	struct tun_struct *tun = netdev_priv(netdev);
+	struct tun_file *tfile;
+	unsigned long flags;
+
+	if (!test_bit(qid, tun->af_xdp_zc_qps))
+		return 0;
+
+	clear_bit(qid, tun->af_xdp_zc_qps);
+
+	rcu_read_lock();
+	tfile = rtnl_dereference(tun->tfiles[qid]);
+	if (!tfile) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	spin_lock_irqsave(&tfile->pool_lock, flags);
+	if (tfile->desc.len) {
+		xsk_tx_completed(tfile->pool, 1);
+		tfile->desc.len = 0;
+	}
+	tfile->pool = NULL;
+	spin_unlock_irqrestore(&tfile->pool_lock, flags);
+
+	rcu_read_unlock();
+	return 0;
+}
+
+int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *pool,
+		       u16 qid)
+{
+	return pool ? tun_xsk_pool_enable(dev, pool, qid) :
+		tun_xsk_pool_disable(dev, qid);
+}
+
 static int tun_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return tun_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_XSK_POOL:
+		return tun_xsk_pool_setup(dev, xdp->xsk.pool,
+					   xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -1331,6 +1414,19 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 	return nxmit;
 }
 
+static int tun_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct tun_file *tfile;
+
+	rcu_read_lock();
+	tfile = rcu_dereference(tun->tfiles[qid]);
+	if (tfile)
+		__tun_xdp_flush_tfile(tfile);
+	rcu_read_unlock();
+	return 0;
+}
+
 static const struct net_device_ops tap_netdev_ops = {
 	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
@@ -1347,6 +1443,7 @@ static const struct net_device_ops tap_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_bpf		= tun_xdp,
 	.ndo_xdp_xmit		= tun_xdp_xmit,
+	.ndo_xsk_wakeup		= tun_xsk_wakeup,
 	.ndo_change_carrier	= tun_net_change_carrier,
 };
 
@@ -1404,7 +1501,8 @@ static void tun_net_initialize(struct net_device *dev)
 		/* Currently tun does not support XDP, only tap does. */
 		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
 				    NETDEV_XDP_ACT_REDIRECT |
-				    NETDEV_XDP_ACT_NDO_XMIT;
+				    NETDEV_XDP_ACT_NDO_XMIT |
+				    NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 		break;
 	}
@@ -2213,6 +2311,37 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	return ptr;
 }
 
+static ssize_t tun_put_user_desc(struct tun_struct *tun,
+				 struct tun_file *tfile,
+				 struct xdp_desc *desc,
+				 struct iov_iter *iter)
+{
+	size_t size = desc->len;
+	int vnet_hdr_sz = 0;
+	size_t ret;
+
+	if (tun->flags & IFF_VNET_HDR) {
+		struct virtio_net_hdr_mrg_rxbuf gso = { 0 };
+
+		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
+		if (unlikely(iov_iter_count(iter) < vnet_hdr_sz))
+			return -EINVAL;
+		if (unlikely(copy_to_iter(&gso, sizeof(gso), iter) !=
+			     sizeof(gso)))
+			return -EFAULT;
+		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
+	}
+
+	ret = copy_to_iter(xsk_buff_raw_get_data(tfile->pool, desc->addr),
+			   size, iter) + vnet_hdr_sz;
+
+	preempt_disable();
+	dev_sw_netstats_tx_add(tun->dev, 1, ret);
+	preempt_enable();
+
+	return ret;
+}
+
 static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 			   struct iov_iter *to,
 			   int noblock, void *ptr)
@@ -2226,6 +2355,22 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (!ptr) {
+		/* Read frames from xsk's desc */
+		if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
+			spin_lock(&tfile->pool_lock);
+			if (tfile->pool) {
+				ret = tun_put_user_desc(tun, tfile, &tfile->desc, to);
+				xsk_tx_completed(tfile->pool, 1);
+				if (xsk_uses_need_wakeup(tfile->pool))
+					xsk_set_tx_need_wakeup(tfile->pool);
+				tfile->desc.len = 0;
+			} else {
+				ret = -EBADFD;
+			}
+			spin_unlock(&tfile->pool_lock);
+			return ret;
+		}
+
 		/* Read frames from ring */
 		ptr = tun_ring_recv(tfile, noblock, &err);
 		if (!ptr)
@@ -2311,6 +2456,7 @@ static void tun_free_netdev(struct net_device *dev)
 
 	BUG_ON(!(list_empty(&tun->disabled)));
 
+	bitmap_free(tun->af_xdp_zc_qps);
 	free_percpu(dev->tstats);
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
@@ -2666,7 +2812,19 @@ static int tun_peek_len(struct socket *sock)
 	if (!tun)
 		return 0;
 
-	ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
+	if (test_bit(tfile->queue_index, tun->af_xdp_zc_qps)) {
+		spin_lock(&tfile->pool_lock);
+		if (tfile->pool && xsk_tx_peek_desc(tfile->pool, &tfile->desc)) {
+			xsk_tx_release(tfile->pool);
+			ret = tfile->desc.len;
+			/* The length of desc must be greater than 0 */
+			if (!ret)
+				xsk_tx_completed(tfile->pool, 1);
+		}
+		spin_unlock(&tfile->pool_lock);
+	} else {
+		ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
+	}
 	tun_put(tun);
 
 	return ret;
@@ -3469,8 +3627,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 
 	mutex_init(&tfile->napi_mutex);
 	RCU_INIT_POINTER(tfile->tun, NULL);
+	spin_lock_init(&tfile->pool_lock);
 	tfile->flags = 0;
 	tfile->ifindex = 0;
+	tfile->pool = NULL;
+	tfile->desc.len = 0;
 
 	init_waitqueue_head(&tfile->socket.wq.wait);
 
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..a1f143ad2341 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -169,9 +169,10 @@ static int vhost_net_buf_is_empty(struct vhost_net_buf *rxq)
 
 static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
 {
-	void *ret = vhost_net_buf_get_ptr(rxq);
-	++rxq->head;
-	return ret;
+	if (rxq->tail == rxq->head)
+		return NULL;
+
+	return rxq->queue[rxq->head++];
 }
 
 static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
@@ -993,12 +994,19 @@ static void handle_tx(struct vhost_net *net)
 
 static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 {
+	struct socket *sock = sk->sk_socket;
 	struct sk_buff *head;
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	if (rvq->rx_ring) {
+		len = vhost_net_buf_peek(rvq);
+		if (likely(len))
+			return len;
+	}
+
+	if (sock->ops->peek_len)
+		return sock->ops->peek_len(sock);
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
-- 
2.33.0


