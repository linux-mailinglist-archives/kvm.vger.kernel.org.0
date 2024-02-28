Return-Path: <kvm+bounces-10229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4B286AC9B
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FC2E1C22507
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F84A135A5D;
	Wed, 28 Feb 2024 11:06:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B066145B2E;
	Wed, 28 Feb 2024 11:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709118371; cv=none; b=PLtVItBoB1jHnitAuImhJyZHSUPMR73XFnN33aApq7YGzRB/WfDzitJo5RMYUOcmkwPeYT2Ei/JElDinR3C/0JFhq6ay8NtmT39ZFPSOAE4FcnxJvY3me+cUkX0n+jlaIs6soI6a5fyYUcdN1hpCd9L5uDAMx8Tw0qFAubQpjE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709118371; c=relaxed/simple;
	bh=6IELK7zbKJPWClXDXnq8oMFddEyhBDObOrY/tD9skIU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XCFuipq+9FrL24yeAb+VOb2qZsHrkcMiaE1+wM3XNksQv79FaXS4da4pW/+kt0vJB/uNHdwxfWfpRTWzAUi5/sOxAhovNWhia61Tqw5rn1b1Es/1ugXFEMC4V40h95UGnLWq9KtbPxHkffQ/JI/kDXmtNSgzwBar02zpBd6TAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TlBL90Y4Dz1h0l4;
	Wed, 28 Feb 2024 19:03:45 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id E04971A016C;
	Wed, 28 Feb 2024 19:05:59 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 28 Feb
 2024 19:05:59 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <bjorn@kernel.org>,
	<magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>
CC: <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <xudingke@huawei.com>,
	<liwei395@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Date: Wed, 28 Feb 2024 19:05:56 +0800
Message-ID: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500008.china.huawei.com (7.185.36.136)

This patch set allows TUN to support the AF_XDP Tx zero-copy feature,
which can significantly reduce CPU utilization for XDP programs.

Since commit fc72d1d54dd9 ("tuntap: XDP transmission"), the pointer
ring has been utilized to queue different types of pointers by encoding
the type into the lower bits. Therefore, we introduce a new flag,
TUN_XDP_DESC_FLAG(0x2UL), which allows us to enqueue XDP descriptors
and differentiate them from XDP buffers and sk_buffs. Additionally, a
spin lock is added for enabling and disabling operations on the xsk pool.

The performance testing was performed on a Intel E5-2620 2.40GHz machine.
Traffic were generated/send through TUN(testpmd txonly with AF_XDP)
to VM (testpmd rxonly in guest).

+------+---------+---------+---------+
|      |   copy  |zero-copy| speedup |
+------+---------+---------+---------+
| UDP  |   Mpps  |   Mpps  |    %    |
| 64   |   2.5   |   4.0   |   60%   |
| 512  |   2.1   |   3.6   |   71%   |
| 1024 |   1.9   |   3.3   |   73%   |
+------+---------+---------+---------+

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/tun.c      | 177 +++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/net.c    |   4 +
 include/linux/if_tun.h |  32 ++++++++
 3 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bc80fc1d576e..7f4ff50b532c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -63,6 +63,7 @@
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <net/xdp.h>
+#include <net/xdp_sock_drv.h>
 #include <net/ip_tunnels.h>
 #include <linux/seq_file.h>
 #include <linux/uio.h>
@@ -86,6 +87,7 @@ static void tun_default_link_ksettings(struct net_device *dev,
 				       struct ethtool_link_ksettings *cmd);
 
 #define TUN_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
+#define TUN_XDP_BATCH 64
 
 /* TUN device flags */
 
@@ -146,6 +148,9 @@ struct tun_file {
 	struct tun_struct *detached;
 	struct ptr_ring tx_ring;
 	struct xdp_rxq_info xdp_rxq;
+	struct xsk_buff_pool *xsk_pool;
+	spinlock_t pool_lock;	/* Protects xsk pool enable/disable */
+	u32 nb_descs;
 };
 
 struct tun_page {
@@ -614,6 +619,8 @@ void tun_ptr_free(void *ptr)
 		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
 
 		xdp_return_frame(xdpf);
+	} else if (tun_is_xdp_desc_frame(ptr)) {
+		return;
 	} else {
 		__skb_array_destroy_skb(ptr);
 	}
@@ -631,6 +638,37 @@ static void tun_queue_purge(struct tun_file *tfile)
 	skb_queue_purge(&tfile->sk.sk_error_queue);
 }
 
+static void tun_set_xsk_pool(struct tun_file *tfile, struct xsk_buff_pool *pool)
+{
+	if (!pool)
+		return;
+
+	spin_lock(&tfile->pool_lock);
+	xsk_pool_set_rxq_info(pool, &tfile->xdp_rxq);
+	tfile->xsk_pool = pool;
+	spin_unlock(&tfile->pool_lock);
+}
+
+static void tun_clean_xsk_pool(struct tun_file *tfile)
+{
+	spin_lock(&tfile->pool_lock);
+	if (tfile->xsk_pool) {
+		void *ptr;
+
+		while ((ptr = ptr_ring_consume(&tfile->tx_ring)) != NULL)
+			tun_ptr_free(ptr);
+
+		if (tfile->nb_descs) {
+			xsk_tx_completed(tfile->xsk_pool, tfile->nb_descs);
+			if (xsk_uses_need_wakeup(tfile->xsk_pool))
+				xsk_set_tx_need_wakeup(tfile->xsk_pool);
+			tfile->nb_descs = 0;
+		}
+		tfile->xsk_pool = NULL;
+	}
+	spin_unlock(&tfile->pool_lock);
+}
+
 static void __tun_detach(struct tun_file *tfile, bool clean)
 {
 	struct tun_file *ntfile;
@@ -648,6 +686,11 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		u16 index = tfile->queue_index;
 		BUG_ON(index >= tun->numqueues);
 
+		ntfile = rtnl_dereference(tun->tfiles[tun->numqueues - 1]);
+		/* Stop xsk zc xmit */
+		tun_clean_xsk_pool(tfile);
+		tun_clean_xsk_pool(ntfile);
+
 		rcu_assign_pointer(tun->tfiles[index],
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
@@ -668,6 +711,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
+		tun_set_xsk_pool(ntfile, xsk_get_pool_from_qid(tun->dev, index));
 		tun_set_real_num_queues(tun);
 	} else if (tfile->detached && clean) {
 		tun = tun_enable_queue(tfile);
@@ -801,6 +845,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 		if (tfile->xdp_rxq.queue_index    != tfile->queue_index)
 			tfile->xdp_rxq.queue_index = tfile->queue_index;
+		tun_set_xsk_pool(tfile, xsk_get_pool_from_qid(dev, tfile->queue_index));
 	} else {
 		/* Setup XDP RX-queue info, for new tfile getting attached */
 		err = xdp_rxq_info_reg(&tfile->xdp_rxq,
@@ -1221,11 +1266,50 @@ static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	return 0;
 }
 
+static int tun_xsk_pool_enable(struct net_device *netdev,
+			       struct xsk_buff_pool *pool,
+			       u16 qid)
+{
+	struct tun_struct *tun = netdev_priv(netdev);
+	struct tun_file *tfile;
+
+	if (qid >= tun->numqueues)
+		return -EINVAL;
+
+	tfile = rtnl_dereference(tun->tfiles[qid]);
+	tun_set_xsk_pool(tfile, pool);
+
+	return 0;
+}
+
+static int tun_xsk_pool_disable(struct net_device *netdev, u16 qid)
+{
+	struct tun_struct *tun = netdev_priv(netdev);
+	struct tun_file *tfile;
+
+	if (qid >= MAX_TAP_QUEUES)
+		return -EINVAL;
+
+	tfile = rtnl_dereference(tun->tfiles[qid]);
+	if (tfile)
+		tun_clean_xsk_pool(tfile);
+	return 0;
+}
+
+static int tun_xsk_pool_setup(struct net_device *dev, struct xsk_buff_pool *pool,
+			      u16 qid)
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
+		return tun_xsk_pool_setup(dev, xdp->xsk.pool, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -1330,6 +1414,19 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
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
@@ -1346,6 +1443,7 @@ static const struct net_device_ops tap_netdev_ops = {
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_bpf		= tun_xdp,
 	.ndo_xdp_xmit		= tun_xdp_xmit,
+	.ndo_xsk_wakeup		= tun_xsk_wakeup,
 	.ndo_change_carrier	= tun_net_change_carrier,
 };
 
@@ -1403,7 +1501,8 @@ static void tun_net_initialize(struct net_device *dev)
 		/* Currently tun does not support XDP, only tap does. */
 		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
 				    NETDEV_XDP_ACT_REDIRECT |
-				    NETDEV_XDP_ACT_NDO_XMIT;
+				    NETDEV_XDP_ACT_NDO_XMIT |
+				    NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 		break;
 	}
@@ -2058,11 +2157,11 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 				struct tun_file *tfile,
-				struct xdp_frame *xdp_frame,
+				void *addr,
+				size_t size,
 				struct iov_iter *iter)
 {
 	int vnet_hdr_sz = 0;
-	size_t size = xdp_frame->len;
 	size_t ret;
 
 	if (tun->flags & IFF_VNET_HDR) {
@@ -2077,7 +2176,7 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
 	}
 
-	ret = copy_to_iter(xdp_frame->data, size, iter) + vnet_hdr_sz;
+	ret = copy_to_iter(addr, size, iter) + vnet_hdr_sz;
 
 	preempt_disable();
 	dev_sw_netstats_tx_add(tun->dev, 1, ret);
@@ -2240,8 +2339,20 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 	if (tun_is_xdp_frame(ptr)) {
 		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
 
-		ret = tun_put_user_xdp(tun, tfile, xdpf, to);
+		ret = tun_put_user_xdp(tun, tfile, xdpf->data, xdpf->len, to);
 		xdp_return_frame(xdpf);
+	} else if (tun_is_xdp_desc_frame(ptr)) {
+		struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
+		void *data;
+
+		spin_lock(&tfile->pool_lock);
+		if (tfile->xsk_pool) {
+			data = xsk_buff_raw_get_data(tfile->xsk_pool, desc->addr);
+			ret = tun_put_user_xdp(tun, tfile, data, desc->len, to);
+		} else {
+			ret = 0;
+		}
+		spin_unlock(&tfile->pool_lock);
 	} else {
 		struct sk_buff *skb = ptr;
 
@@ -2654,6 +2765,10 @@ static int tun_ptr_peek_len(void *ptr)
 			struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
 
 			return xdpf->len;
+		} else if (tun_is_xdp_desc_frame(ptr)) {
+			struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
+
+			return desc->len;
 		}
 		return __skb_array_len_with_tag(ptr);
 	} else {
@@ -2661,6 +2776,54 @@ static int tun_ptr_peek_len(void *ptr)
 	}
 }
 
+static void tun_peek_xsk(struct tun_file *tfile)
+{
+	struct xsk_buff_pool *pool;
+	u32 i, batch, budget;
+	void *frame;
+
+	if (!ptr_ring_empty(&tfile->tx_ring))
+		return;
+
+	spin_lock(&tfile->pool_lock);
+	pool = tfile->xsk_pool;
+	if (!pool) {
+		spin_unlock(&tfile->pool_lock);
+		return;
+	}
+
+	if (tfile->nb_descs) {
+		xsk_tx_completed(pool, tfile->nb_descs);
+		if (xsk_uses_need_wakeup(pool))
+			xsk_set_tx_need_wakeup(pool);
+	}
+
+	spin_lock(&tfile->tx_ring.producer_lock);
+	budget = min_t(u32, tfile->tx_ring.size, TUN_XDP_BATCH);
+
+	batch = xsk_tx_peek_release_desc_batch(pool, budget);
+	if (!batch) {
+		tfile->nb_descs = 0;
+		spin_unlock(&tfile->tx_ring.producer_lock);
+		spin_unlock(&tfile->pool_lock);
+		return;
+	}
+
+	tfile->nb_descs = batch;
+	for (i = 0; i < batch; i++) {
+		/* Encode the XDP DESC flag into lowest bit for consumer to differ
+		 * XDP desc from XDP buffer and sk_buff.
+		 */
+		frame = tun_xdp_desc_to_ptr(&pool->tx_descs[i]);
+		/* The budget must be less than or equal to tx_ring.size,
+		 * so enqueuing will not fail.
+		 */
+		__ptr_ring_produce(&tfile->tx_ring, frame);
+	}
+	spin_unlock(&tfile->tx_ring.producer_lock);
+	spin_unlock(&tfile->pool_lock);
+}
+
 static int tun_peek_len(struct socket *sock)
 {
 	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
@@ -2671,6 +2834,9 @@ static int tun_peek_len(struct socket *sock)
 	if (!tun)
 		return 0;
 
+	if (sock_flag(&tfile->sk, SOCK_XDP))
+		tun_peek_xsk(tfile);
+
 	ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
 	tun_put(tun);
 
@@ -3473,6 +3639,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	}
 
 	mutex_init(&tfile->napi_mutex);
+	spin_lock_init(&tfile->pool_lock);
 	RCU_INIT_POINTER(tfile->tun, NULL);
 	tfile->flags = 0;
 	tfile->ifindex = 0;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 077e74421558..eb83764be26c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -202,6 +202,10 @@ static int vhost_net_buf_peek_len(void *ptr)
 		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
 
 		return xdpf->len;
+	} else if (tun_is_xdp_desc_frame(ptr)) {
+		struct xdp_desc *desc = tun_ptr_to_xdp_desc(ptr);
+
+		return desc->len;
 	}
 
 	return __skb_array_len_with_tag(ptr);
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 043d442994b0..4142453b5e52 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -6,10 +6,12 @@
 #ifndef __IF_TUN_H
 #define __IF_TUN_H
 
+#include <uapi/linux/if_xdp.h>
 #include <uapi/linux/if_tun.h>
 #include <uapi/linux/virtio_net.h>
 
 #define TUN_XDP_FLAG 0x1UL
+#define TUN_XDP_DESC_FLAG 0x2UL
 
 #define TUN_MSG_UBUF 1
 #define TUN_MSG_PTR  2
@@ -43,6 +45,21 @@ static inline struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
 }
 
+static inline bool tun_is_xdp_desc_frame(void *ptr)
+{
+	return (unsigned long)ptr & TUN_XDP_DESC_FLAG;
+}
+
+static inline void *tun_xdp_desc_to_ptr(struct xdp_desc *desc)
+{
+	return (void *)((unsigned long)desc | TUN_XDP_DESC_FLAG);
+}
+
+static inline struct xdp_desc *tun_ptr_to_xdp_desc(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~TUN_XDP_DESC_FLAG);
+}
+
 void tun_ptr_free(void *ptr);
 #else
 #include <linux/err.h>
@@ -75,6 +92,21 @@ static inline struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 	return NULL;
 }
 
+static inline bool tun_is_xdp_desc_frame(void *ptr)
+{
+	return false;
+}
+
+static inline void *tun_xdp_desc_to_ptr(struct xdp_desc *desc)
+{
+	return NULL;
+}
+
+static inline struct xdp_frame *tun_ptr_to_xdp_desc(void *ptr)
+{
+	return NULL;
+}
+
 static inline void tun_ptr_free(void *ptr)
 {
 }
-- 
2.41.0


