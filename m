Return-Path: <kvm+bounces-18209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF5F8D1BF2
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 15:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B329B2379B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 13:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740F116F8E1;
	Tue, 28 May 2024 12:59:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3765B16F84A;
	Tue, 28 May 2024 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901151; cv=none; b=YsDcbD+rnTbv+o42j8RNtthDWijPY2IDmh5aB0IS2knuGhrBYB60FBIiD1Y0KHxIf05o9J8aZCIlhulhbrsIaMbL3/IZb5M0rtGuj5U1e14nVBu1mo9t/JnBh2CCHfX89IoLa3bkREkqIxPgu1OuKZFGKPRIbsWtSeqVp5pnElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901151; c=relaxed/simple;
	bh=jIGeIgNwugHZLzikxCCnMT3AwFLdvWGJXgs5PnGmXSU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1cwQCl6w9Ce9GWB6ray9FH1mwWopiDO5MfF7xjC7LStPyo3OHqPjSeFxhqv48dGw5QyuSevytn9KIVcuInvV3rqAFeVCelGdxZC08b1Nan9JE2fiWUNs2bPN+Yq9GcNqPTf4xGic0QZbhzKluUOAxnETY3HtkI+KIjcUByuDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VpXcB3L0NzckN8;
	Tue, 28 May 2024 20:57:46 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id E15211400D1;
	Tue, 28 May 2024 20:59:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 28 May 2024 20:59:06 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexander Duyck <alexander.duyck@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, David
 Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, Trond
 Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker
	<anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
	<jlayton@kernel.org>, Neil Brown <neilb@suse.de>, Olga Kornievskaia
	<kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>, <kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-afs@lists.infradead.org>,
	<linux-nfs@vger.kernel.org>
Subject: [PATCH net-next v5 07/13] mm: page_frag: avoid caller accessing 'page_frag_cache' directly
Date: Tue, 28 May 2024 20:55:57 +0800
Message-ID: <20240528125604.63048-8-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240528125604.63048-1-linyunsheng@huawei.com>
References: <20240528125604.63048-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
index c6fde197a6eb..6ac3a25089d1 100644
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
index bb9f5aa84631..641255136105 100644
--- a/mm/page_frag_test.c
+++ b/mm/page_frag_test.c
@@ -337,7 +337,7 @@ static int __init page_frag_test_init(void)
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
2.30.0


