Return-Path: <kvm+bounces-14653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA298A516E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFF391C223E4
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CE7129A7A;
	Mon, 15 Apr 2024 13:22:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1731292D0;
	Mon, 15 Apr 2024 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187335; cv=none; b=mO6UNihKTwuQwV2bdSheQwcut5ykO6oAZQP256iCbhdZ/kXYLqBU27+nkVomH/bcgfuWDWG1dmt5gl8J48MVgDEHB7PpVg59iBhGTuzUHrNjwEZP83DJRkHe4Fa0Z2og/95K6MN4BpwZpS+t5o1UDOah5eXl783wfRJhY/BquJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187335; c=relaxed/simple;
	bh=eqDEoVnxo3pfFcUCOdV+c9xX/tMqDpLoJ4qkomslvwk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqzp3b0+rfmrf6J/O5r23S/eeJpTKu3ADkuWSKUej/nIo1Zt6tpcM1lQThm3ZntfX3n30TIR/BwO5gBFsw2i2YTmEKoCFP1WHra8OMDspUXQ67sdkQdf5/BgURSXa9C1Fy5ff92CauyOEbIeGOHot+dkIF1FD6qWqMRsofG+cA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VJ76n6zTZz2CcKP;
	Mon, 15 Apr 2024 21:19:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 6021B140410;
	Mon, 15 Apr 2024 21:22:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 21:22:09 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Jeroen de Borst <jeroendb@google.com>, Praveen
 Kaligineedi <pkaligineedi@google.com>, Shailend Chand <shailend@google.com>,
	Eric Dumazet <edumazet@google.com>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Sunil
 Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>, hariprasad <hkelam@marvell.com>,
	Felix Fietkau <nbd@nbd.name>, Sean Wang <sean.wang@mediatek.com>, Mark Lee
	<Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
	<sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Alexander Duyck
	<alexander.duyck@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu
	<song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh
	<kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo
	<haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, David Howells
	<dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, Chuck Lever
	<chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <linux-nvme@lists.infradead.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, <linux-afs@lists.infradead.org>,
	<linux-nfs@vger.kernel.org>
Subject: [PATCH net-next v2 07/15] mm: page_frag: add '_va' suffix to page_frag API
Date: Mon, 15 Apr 2024 21:19:32 +0800
Message-ID: <20240415131941.51153-8-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240415131941.51153-1-linyunsheng@huawei.com>
References: <20240415131941.51153-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)

Currently most of the API for page_frag API is returning
'virtual address' as output or expecting 'virtual address'
as input, in order to differentiate the API handling between
'virtual address' and 'struct page', add '_va' suffix to the
corresponding API mirroring the page_pool_alloc_va() API of
the page_pool.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c      |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 ++--
 .../marvell/octeontx2/nic/otx2_common.c       |  2 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c    |  4 ++--
 drivers/nvme/host/tcp.c                       |  8 +++----
 drivers/nvme/target/tcp.c                     | 22 ++++++++---------
 drivers/vhost/net.c                           |  6 ++---
 include/linux/page_frag_cache.h               | 24 ++++++++++---------
 include/linux/skbuff.h                        |  2 +-
 kernel/bpf/cpumap.c                           |  2 +-
 mm/page_frag_cache.c                          | 10 ++++----
 mm/page_frag_test.c                           |  6 ++---
 net/core/skbuff.c                             | 15 ++++++------
 net/core/xdp.c                                |  2 +-
 net/rxrpc/txbuf.c                             | 15 ++++++------
 net/sunrpc/svcsock.c                          |  6 ++---
 19 files changed, 71 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index cd727e55ae0f..820874c1c570 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -687,7 +687,7 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
 
 	total_len = headroom + SKB_DATA_ALIGN(len) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	frame = page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
+	frame = page_frag_alloc_va(&rx->page_cache, total_len, GFP_ATOMIC);
 	if (!frame) {
 		u64_stats_update_begin(&rx->statss);
 		rx->xdp_alloc_fails++;
@@ -700,7 +700,7 @@ static int gve_xdp_redirect(struct net_device *dev, struct gve_rx_ring *rx,
 
 	err = xdp_do_redirect(dev, &new, xdp_prog);
 	if (err)
-		page_frag_free(frame);
+		page_frag_free_va(frame);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 8bb743f78fcb..399b317c509d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -126,7 +126,7 @@ ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, struct ice_tx_buf *tx_buf)
 		dev_kfree_skb_any(tx_buf->skb);
 		break;
 	case ICE_TX_BUF_XDP_TX:
-		page_frag_free(tx_buf->raw_buf);
+		page_frag_free_va(tx_buf->raw_buf);
 		break;
 	case ICE_TX_BUF_XDP_XMIT:
 		xdp_return_frame(tx_buf->xdpf);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index feba314a3fe4..6379f57d8228 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -148,7 +148,7 @@ static inline int ice_skb_pad(void)
  * @ICE_TX_BUF_DUMMY: dummy Flow Director packet, unmap and kfree()
  * @ICE_TX_BUF_FRAG: mapped skb OR &xdp_buff frag, only unmap DMA
  * @ICE_TX_BUF_SKB: &sk_buff, unmap and consume_skb(), update stats
- * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free(), stats
+ * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free_va(), stats
  * @ICE_TX_BUF_XDP_XMIT: &xdp_frame, unmap and xdp_return_frame(), stats
  * @ICE_TX_BUF_XSK_TX: &xdp_buff on XSk queue, xsk_buff_free(), stats
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index df072ce767b1..c34cc02ad578 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -288,7 +288,7 @@ ice_clean_xdp_tx_buf(struct device *dev, struct ice_tx_buf *tx_buf,
 
 	switch (tx_buf->type) {
 	case ICE_TX_BUF_XDP_TX:
-		page_frag_free(tx_buf->raw_buf);
+		page_frag_free_va(tx_buf->raw_buf);
 		break;
 	case ICE_TX_BUF_XDP_XMIT:
 		xdp_return_frame_bulk(tx_buf->xdpf, bq);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 3161a13079fe..c35b8f675b48 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -303,7 +303,7 @@ static bool ixgbevf_clean_tx_irq(struct ixgbevf_q_vector *q_vector,
 
 		/* free the skb */
 		if (ring_is_xdp(tx_ring))
-			page_frag_free(tx_buffer->data);
+			page_frag_free_va(tx_buffer->data);
 		else
 			napi_consume_skb(tx_buffer->skb, napi_budget);
 
@@ -2413,7 +2413,7 @@ static void ixgbevf_clean_tx_ring(struct ixgbevf_ring *tx_ring)
 
 		/* Free all the Tx ring sk_buffs */
 		if (ring_is_xdp(tx_ring))
-			page_frag_free(tx_buffer->data);
+			page_frag_free_va(tx_buffer->data);
 		else
 			dev_kfree_skb_any(tx_buffer->skb);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a85ac039d779..8eb5820b8a70 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -553,7 +553,7 @@ static int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 	*dma = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, *dma))) {
-		page_frag_free(buf);
+		page_frag_free_va(buf);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index 7063c78bd35f..c4228719f8a4 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -142,8 +142,8 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
 		dma_addr_t addr;
 		void *buf;
 
-		buf = page_frag_alloc(&q->cache, q->buf_size,
-				      GFP_ATOMIC | GFP_DMA32);
+		buf = page_frag_alloc_va(&q->cache, q->buf_size,
+					 GFP_ATOMIC | GFP_DMA32);
 		if (!buf)
 			break;
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index fdbcdcedcee9..79eddd74bfbb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -500,7 +500,7 @@ static void nvme_tcp_exit_request(struct blk_mq_tag_set *set,
 {
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
-	page_frag_free(req->pdu);
+	page_frag_free_va(req->pdu);
 }
 
 static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
@@ -514,7 +514,7 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 	struct nvme_tcp_queue *queue = &ctrl->queues[queue_idx];
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
-	req->pdu = page_frag_alloc(&queue->pf_cache,
+	req->pdu = page_frag_alloc_va(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
 	if (!req->pdu)
@@ -1331,7 +1331,7 @@ static void nvme_tcp_free_async_req(struct nvme_tcp_ctrl *ctrl)
 {
 	struct nvme_tcp_request *async = &ctrl->async_req;
 
-	page_frag_free(async->pdu);
+	page_frag_free_va(async->pdu);
 }
 
 static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
@@ -1340,7 +1340,7 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
 	struct nvme_tcp_request *async = &ctrl->async_req;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
-	async->pdu = page_frag_alloc(&queue->pf_cache,
+	async->pdu = page_frag_alloc_va(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
 	if (!async->pdu)
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index a5422e2c979a..ea356ce22672 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1462,24 +1462,24 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	c->queue = queue;
 	c->req.port = queue->port->nport;
 
-	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
+	c->cmd_pdu = page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->cmd_pdu)
 		return -ENOMEM;
 	c->req.cmd = &c->cmd_pdu->cmd;
 
-	c->rsp_pdu = page_frag_alloc(&queue->pf_cache,
+	c->rsp_pdu = page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->rsp_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->rsp_pdu)
 		goto out_free_cmd;
 	c->req.cqe = &c->rsp_pdu->cqe;
 
-	c->data_pdu = page_frag_alloc(&queue->pf_cache,
+	c->data_pdu = page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->data_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->data_pdu)
 		goto out_free_rsp;
 
-	c->r2t_pdu = page_frag_alloc(&queue->pf_cache,
+	c->r2t_pdu = page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->r2t_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->r2t_pdu)
 		goto out_free_data;
@@ -1494,20 +1494,20 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 
 	return 0;
 out_free_data:
-	page_frag_free(c->data_pdu);
+	page_frag_free_va(c->data_pdu);
 out_free_rsp:
-	page_frag_free(c->rsp_pdu);
+	page_frag_free_va(c->rsp_pdu);
 out_free_cmd:
-	page_frag_free(c->cmd_pdu);
+	page_frag_free_va(c->cmd_pdu);
 	return -ENOMEM;
 }
 
 static void nvmet_tcp_free_cmd(struct nvmet_tcp_cmd *c)
 {
-	page_frag_free(c->r2t_pdu);
-	page_frag_free(c->data_pdu);
-	page_frag_free(c->rsp_pdu);
-	page_frag_free(c->cmd_pdu);
+	page_frag_free_va(c->r2t_pdu);
+	page_frag_free_va(c->data_pdu);
+	page_frag_free_va(c->rsp_pdu);
+	page_frag_free_va(c->cmd_pdu);
 }
 
 static int nvmet_tcp_alloc_cmds(struct nvmet_tcp_queue *queue)
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c64ded183f8d..96d5ca299552 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -682,8 +682,8 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 		return -ENOSPC;
 
 	buflen += SKB_DATA_ALIGN(len + pad);
-	buf = page_frag_alloc_align(&net->pf_cache, buflen, GFP_KERNEL,
-				    SMP_CACHE_BYTES);
+	buf = page_frag_alloc_va_align(&net->pf_cache, buflen, GFP_KERNEL,
+				       SMP_CACHE_BYTES);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
@@ -730,7 +730,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	return 0;
 
 err:
-	page_frag_free(buf);
+	page_frag_free_va(buf);
 	return ret;
 }
 
diff --git a/include/linux/page_frag_cache.h b/include/linux/page_frag_cache.h
index cc0ede0912f3..9d5d86b2d3ab 100644
--- a/include/linux/page_frag_cache.h
+++ b/include/linux/page_frag_cache.h
@@ -25,27 +25,29 @@ struct page_frag_cache {
 
 void page_frag_cache_drain(struct page_frag_cache *nc);
 void __page_frag_cache_drain(struct page *page, unsigned int count);
-void *page_frag_alloc(struct page_frag_cache *nc, unsigned int fragsz,
-		      gfp_t gfp_mask);
+void *page_frag_alloc_va(struct page_frag_cache *nc, unsigned int fragsz,
+			 gfp_t gfp_mask);
 
-static inline void *__page_frag_alloc_align(struct page_frag_cache *nc,
-					    unsigned int fragsz, gfp_t gfp_mask,
-					    unsigned int align)
+static inline void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
+					       unsigned int fragsz,
+					       gfp_t gfp_mask,
+					       unsigned int align)
 {
 	nc->offset = ALIGN(nc->offset, align);
 
-	return page_frag_alloc(nc, fragsz, gfp_mask);
+	return page_frag_alloc_va(nc, fragsz, gfp_mask);
 }
 
-static inline void *page_frag_alloc_align(struct page_frag_cache *nc,
-					  unsigned int fragsz, gfp_t gfp_mask,
-					  unsigned int align)
+static inline void *page_frag_alloc_va_align(struct page_frag_cache *nc,
+					     unsigned int fragsz,
+					     gfp_t gfp_mask,
+					     unsigned int align)
 {
 	WARN_ON_ONCE(!is_power_of_2(align));
 
-	return __page_frag_alloc_align(nc, fragsz, gfp_mask, align);
+	return __page_frag_alloc_va_align(nc, fragsz, gfp_mask, align);
 }
 
-void page_frag_free(void *addr);
+void page_frag_free_va(void *addr);
 
 #endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 43c704589deb..cc80600dcedf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3343,7 +3343,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
 
 static inline void skb_free_frag(void *addr)
 {
-	page_frag_free(addr);
+	page_frag_free_va(addr);
 }
 
 void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index a8e34416e960..3a6a237e7dd3 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -322,7 +322,7 @@ static int cpu_map_kthread_run(void *data)
 
 			/* Bring struct page memory area to curr CPU. Read by
 			 * build_skb_around via page_is_pfmemalloc(), and when
-			 * freed written by page_frag_free call.
+			 * freed written by page_frag_free_va call.
 			 */
 			prefetchw(page);
 		}
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index b4408187e1ab..50511d8522d0 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -61,8 +61,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
-void *page_frag_alloc(struct page_frag_cache *nc, unsigned int fragsz,
-		      gfp_t gfp_mask)
+void *page_frag_alloc_va(struct page_frag_cache *nc, unsigned int fragsz,
+			 gfp_t gfp_mask)
 {
 	unsigned int size, offset;
 	struct page *page;
@@ -128,16 +128,16 @@ void *page_frag_alloc(struct page_frag_cache *nc, unsigned int fragsz,
 
 	return nc->va + offset;
 }
-EXPORT_SYMBOL(page_frag_alloc);
+EXPORT_SYMBOL(page_frag_alloc_va);
 
 /*
  * Frees a page fragment allocated out of either a compound or order 0 page.
  */
-void page_frag_free(void *addr)
+void page_frag_free_va(void *addr)
 {
 	struct page *page = virt_to_head_page(addr);
 
 	if (unlikely(put_page_testzero(page)))
 		free_unref_page(page, compound_order(page));
 }
-EXPORT_SYMBOL(page_frag_free);
+EXPORT_SYMBOL(page_frag_free_va);
diff --git a/mm/page_frag_test.c b/mm/page_frag_test.c
index ebfd1c3dae8f..cab05b8a2e77 100644
--- a/mm/page_frag_test.c
+++ b/mm/page_frag_test.c
@@ -260,7 +260,7 @@ static int page_frag_pop_thread(void *arg)
 
 		if (obj) {
 			nr--;
-			page_frag_free(obj);
+			page_frag_free_va(obj);
 		} else {
 			cond_resched();
 		}
@@ -289,13 +289,13 @@ static int page_frag_push_thread(void *arg)
 		int ret;
 
 		size = clamp(size, 4U, 4096U);
-		va = page_frag_alloc(&test_frag, size, GFP_KERNEL);
+		va = page_frag_alloc_va(&test_frag, size, GFP_KERNEL);
 		if (!va)
 			continue;
 
 		ret = objpool_push(va, pool);
 		if (ret) {
-			page_frag_free(va);
+			page_frag_free_va(va);
 			cond_resched();
 		} else {
 			nr--;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 676e2d857f02..139a193853cc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -312,7 +312,7 @@ void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align)
 
 	fragsz = SKB_DATA_ALIGN(fragsz);
 
-	return __page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC, align);
+	return __page_frag_alloc_va_align(&nc->page, fragsz, GFP_ATOMIC, align);
 }
 EXPORT_SYMBOL(__napi_alloc_frag_align);
 
@@ -324,14 +324,15 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align)
 	if (in_hardirq() || irqs_disabled()) {
 		struct page_frag_cache *nc = this_cpu_ptr(&netdev_alloc_cache);
 
-		data = __page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align);
+		data = __page_frag_alloc_va_align(nc, fragsz, GFP_ATOMIC,
+						  align);
 	} else {
 		struct napi_alloc_cache *nc;
 
 		local_bh_disable();
 		nc = this_cpu_ptr(&napi_alloc_cache);
-		data = __page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC,
-					       align);
+		data = __page_frag_alloc_va_align(&nc->page, fragsz, GFP_ATOMIC,
+						  align);
 		local_bh_enable();
 	}
 	return data;
@@ -741,12 +742,12 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 
 	if (in_hardirq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
-		data = page_frag_alloc(nc, len, gfp_mask);
+		data = page_frag_alloc_va(nc, len, gfp_mask);
 		pfmemalloc = nc->pfmemalloc;
 	} else {
 		local_bh_disable();
 		nc = this_cpu_ptr(&napi_alloc_cache.page);
-		data = page_frag_alloc(nc, len, gfp_mask);
+		data = page_frag_alloc_va(nc, len, gfp_mask);
 		pfmemalloc = nc->pfmemalloc;
 		local_bh_enable();
 	}
@@ -834,7 +835,7 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 	} else {
 		len = SKB_HEAD_ALIGN(len);
 
-		data = page_frag_alloc(&nc->page, len, gfp_mask);
+		data = page_frag_alloc_va(&nc->page, len, gfp_mask);
 		pfmemalloc = nc->page.pfmemalloc;
 	}
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 41693154e426..245a2d011aeb 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -391,7 +391,7 @@ void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		page_pool_put_full_page(page->pp, page, napi_direct);
 		break;
 	case MEM_TYPE_PAGE_SHARED:
-		page_frag_free(data);
+		page_frag_free_va(data);
 		break;
 	case MEM_TYPE_PAGE_ORDER0:
 		page = virt_to_page(data); /* Assumes order0 page*/
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index eb640875bf07..f2fa98360789 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -34,8 +34,8 @@ struct rxrpc_txbuf *rxrpc_alloc_data_txbuf(struct rxrpc_call *call, size_t data_
 
 	data_align = max_t(size_t, data_align, L1_CACHE_BYTES);
 	mutex_lock(&call->conn->tx_data_alloc_lock);
-	buf = page_frag_alloc_align(&call->conn->tx_data_alloc, total, gfp,
-				    data_align);
+	buf = page_frag_alloc_va_align(&call->conn->tx_data_alloc, total, gfp,
+				       data_align);
 	mutex_unlock(&call->conn->tx_data_alloc_lock);
 	if (!buf) {
 		kfree(txb);
@@ -97,17 +97,18 @@ struct rxrpc_txbuf *rxrpc_alloc_ack_txbuf(struct rxrpc_call *call, size_t sack_s
 	if (!txb)
 		return NULL;
 
-	buf = page_frag_alloc(&call->local->tx_alloc,
-			      sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
+	buf = page_frag_alloc_va(&call->local->tx_alloc,
+				 sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
 	if (!buf) {
 		kfree(txb);
 		return NULL;
 	}
 
 	if (sack_size) {
-		buf2 = page_frag_alloc(&call->local->tx_alloc, sack_size, gfp);
+		buf2 = page_frag_alloc_va(&call->local->tx_alloc, sack_size,
+					  gfp);
 		if (!buf2) {
-			page_frag_free(buf);
+			page_frag_free_va(buf);
 			kfree(txb);
 			return NULL;
 		}
@@ -181,7 +182,7 @@ static void rxrpc_free_txbuf(struct rxrpc_txbuf *txb)
 			  rxrpc_txbuf_free);
 	for (i = 0; i < txb->nr_kvec; i++)
 		if (txb->kvec[i].iov_base)
-			page_frag_free(txb->kvec[i].iov_base);
+			page_frag_free_va(txb->kvec[i].iov_base);
 	kfree(txb);
 	atomic_dec(&rxrpc_nr_txbuf);
 }
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 6b3f01beb294..42d20412c1c3 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1222,8 +1222,8 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
 	/* The stream record marker is copied into a temporary page
 	 * fragment buffer so that it can be included in rq_bvec.
 	 */
-	buf = page_frag_alloc(&svsk->sk_frag_cache, sizeof(marker),
-			      GFP_KERNEL);
+	buf = page_frag_alloc_va(&svsk->sk_frag_cache, sizeof(marker),
+				 GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	memcpy(buf, &marker, sizeof(marker));
@@ -1235,7 +1235,7 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret = sock_sendmsg(svsk->sk_sock, &msg);
-	page_frag_free(buf);
+	page_frag_free_va(buf);
 	if (ret < 0)
 		return ret;
 	*sentp += ret;
-- 
2.33.0


