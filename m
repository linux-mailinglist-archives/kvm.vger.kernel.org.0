Return-Path: <kvm+bounces-17007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C986D8BFEF1
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D20D1F20584
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFF6127E0E;
	Wed,  8 May 2024 13:37:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9A86AE2;
	Wed,  8 May 2024 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715175425; cv=none; b=DjfWDw07fFDW6b2UN+ebp14h7yO08rDyGTKP+7dgpQsPZ5lrxzuxLs/apxMGUFM/KY5jxC/h5OARZlPr4wqXhroEb7QfHJE0uccc8nDNXLzRBMmiwkToB4v7oJseBLGux+m5mlAz+IItBo1gplNNcDf+N/rnv5+ZaALlUI9B8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715175425; c=relaxed/simple;
	bh=aUMv2EyZWKJgCD0BZ6yrbkGsvXQDS9HIZgEmv9GZke0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtXOzXZe9xbVKI3Z4ppNAIuEXPEbLVMifLx5NuCMojsoQwFSRMvdgerKbR/VFoHOIHW2jDy3R/8bLWBP86idQz71nFISExgjuh4nFnPlK9YyRKIR06nCmc3/58SnAV+qC1tsPIVh/zUiVZWjaUJMMb1LEELSVD+5rf1oM2IoEew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VZGLd3YXtztTBx;
	Wed,  8 May 2024 21:33:29 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B419C1800B8;
	Wed,  8 May 2024 21:36:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 8 May 2024 21:36:55 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexander Duyck <alexander.duyck@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet
	<edumazet@google.com>, David Howells <dhowells@redhat.com>, Marc Dionne
	<marc.dionne@auristor.com>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, Chuck
 Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-afs@lists.infradead.org>, <linux-nfs@vger.kernel.org>
Subject: [PATCH net-next v3 07/13] mm: page_frag: avoid caller accessing 'page_frag_cache' directly
Date: Wed, 8 May 2024 21:34:02 +0800
Message-ID: <20240508133408.54708-8-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240508133408.54708-1-linyunsheng@huawei.com>
References: <20240508133408.54708-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)

Use appropriate frag_page API instead of caller accessing
'page_frag_cache' directly.

CC: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/vhost/net.c             |  2 +-
 include/linux/page_frag_cache.h | 10 ++++++++++
 mm/page_frag_test.c             |  2 +-
 net/core/skbuff.c               |  6 +++---
 net/rxrpc/conn_object.c         |  4 +---
 net/rxrpc/local_object.c        |  4 +---
 net/sunrpc/svcsock.c            |  6 ++----
 7 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6691fac01e0d..b2737dc0dc50 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1325,7 +1325,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 			vqs[VHOST_NET_VQ_RX]);
 
 	f->private_data = n;
-	n->pf_cache.va = NULL;
+	page_frag_cache_init(&n->pf_cache);
 
 	return 0;
 }
diff --git a/include/linux/page_frag_cache.h b/include/linux/page_frag_cache.h
index a5747cf7a3a1..024ff73a7ea4 100644
--- a/include/linux/page_frag_cache.h
+++ b/include/linux/page_frag_cache.h
@@ -23,6 +23,16 @@ struct page_frag_cache {
 	bool pfmemalloc;
 };
 
+static inline void page_frag_cache_init(struct page_frag_cache *nc)
+{
+	nc->va = NULL;
+}
+
+static inline bool page_frag_cache_is_pfmemalloc(struct page_frag_cache *nc)
+{
+	return !!nc->pfmemalloc;
+}
+
 void page_frag_cache_drain(struct page_frag_cache *nc);
 void __page_frag_cache_drain(struct page *page, unsigned int count);
 void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
diff --git a/mm/page_frag_test.c b/mm/page_frag_test.c
index 92eb288aab75..8a974d0588bf 100644
--- a/mm/page_frag_test.c
+++ b/mm/page_frag_test.c
@@ -329,7 +329,7 @@ static int __init page_frag_test_init(void)
 	u64 duration;
 	int ret;
 
-	test_frag.va = NULL;
+	page_frag_cache_init(&test_frag);
 	atomic_set(&nthreads, 2);
 	init_completion(&wait);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index dca4e7445348..caee22db1cc7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -741,12 +741,12 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 	if (in_hardirq() || irqs_disabled()) {
 		nc = this_cpu_ptr(&netdev_alloc_cache);
 		data = page_frag_alloc_va(nc, len, gfp_mask);
-		pfmemalloc = nc->pfmemalloc;
+		pfmemalloc = page_frag_cache_is_pfmemalloc(nc);
 	} else {
 		local_bh_disable();
 		nc = this_cpu_ptr(&napi_alloc_cache.page);
 		data = page_frag_alloc_va(nc, len, gfp_mask);
-		pfmemalloc = nc->pfmemalloc;
+		pfmemalloc = page_frag_cache_is_pfmemalloc(nc);
 		local_bh_enable();
 	}
 
@@ -834,7 +834,7 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 		len = SKB_HEAD_ALIGN(len);
 
 		data = page_frag_alloc_va(&nc->page, len, gfp_mask);
-		pfmemalloc = nc->page.pfmemalloc;
+		pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
 	}
 
 	if (unlikely(!data))
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 1539d315afe7..694c4df7a1a3 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -337,9 +337,7 @@ static void rxrpc_clean_up_connection(struct work_struct *work)
 	 */
 	rxrpc_purge_queue(&conn->rx_queue);
 
-	if (conn->tx_data_alloc.va)
-		__page_frag_cache_drain(virt_to_page(conn->tx_data_alloc.va),
-					conn->tx_data_alloc.pagecnt_bias);
+	page_frag_cache_drain(&conn->tx_data_alloc);
 	call_rcu(&conn->rcu, rxrpc_rcu_free_connection);
 }
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 504453c688d7..a8cffe47cf01 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -452,9 +452,7 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 #endif
 	rxrpc_purge_queue(&local->rx_queue);
 	rxrpc_purge_client_connections(local);
-	if (local->tx_alloc.va)
-		__page_frag_cache_drain(virt_to_page(local->tx_alloc.va),
-					local->tx_alloc.pagecnt_bias);
+	page_frag_cache_drain(&local->tx_alloc);
 }
 
 /*
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 42d20412c1c3..4b1e87187614 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1609,7 +1609,6 @@ static void svc_tcp_sock_detach(struct svc_xprt *xprt)
 static void svc_sock_free(struct svc_xprt *xprt)
 {
 	struct svc_sock *svsk = container_of(xprt, struct svc_sock, sk_xprt);
-	struct page_frag_cache *pfc = &svsk->sk_frag_cache;
 	struct socket *sock = svsk->sk_sock;
 
 	trace_svcsock_free(svsk, sock);
@@ -1619,8 +1618,7 @@ static void svc_sock_free(struct svc_xprt *xprt)
 		sockfd_put(sock);
 	else
 		sock_release(sock);
-	if (pfc->va)
-		__page_frag_cache_drain(virt_to_head_page(pfc->va),
-					pfc->pagecnt_bias);
+
+	page_frag_cache_drain(&svsk->sk_frag_cache);
 	kfree(svsk);
 }
-- 
2.33.0


