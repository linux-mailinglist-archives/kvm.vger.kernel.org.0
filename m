Return-Path: <kvm+bounces-6730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E431838C54
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 11:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6757D1C231E3
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 10:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0465C914;
	Tue, 23 Jan 2024 10:44:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E1D5C8F6;
	Tue, 23 Jan 2024 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006649; cv=none; b=fO1YEu+N51uNSs3AWlf/rOZuaz8roNwo9Fa1OG7FX1OSZnwWOVszBWjgq2SBHEwVqfDqUSXHl5oUUEgeMXwPHF1aglhe75w3qq1v56tgWYFrx4J4uyA7IBoJ/Xa7XJJMg2DERFBR5ODEvbT2w+kC+ioW5Y6BF2ZV1wGSObQT/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006649; c=relaxed/simple;
	bh=FrFxf73uzHkT6S2ikGi0LCQhmYLQu2afl4OSVxrrdOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xn2FeA7XASZhT/EFPoLgKi5YO4tWJonFzidq56W4+K/LSza8f7mYP/1HcubvcfiRE6fsD0IncUYjXllmIpxqgogYuYz3Jqvi2hCwv58SmomZZ5GwNO/2nh7iqcuY4Z5vqDvbKVaMIGqENfzkPwOQ2WNKykhWpZgoQ7ZfCI1tqr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TK3Z422B9z29kHr;
	Tue, 23 Jan 2024 18:42:20 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B05A8140153;
	Tue, 23 Jan 2024 18:43:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Jan 2024 18:43:35 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexander Duyck <alexanderduyck@fb.com>, Alexander
 Duyck <alexander.duyck@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <edumazet@google.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>
Subject: [PATCH net-next v3 2/5] page_frag: unify gfp bits for order 3 page allocation
Date: Tue, 23 Jan 2024 18:42:47 +0800
Message-ID: <20240123104250.9103-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240123104250.9103-1-linyunsheng@huawei.com>
References: <20240123104250.9103-1-linyunsheng@huawei.com>
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

Currently there seems to be three page frag implementions
which all try to allocate order 3 page, if that fails, it
then fail back to allocate order 0 page, and each of them
all allow order 3 page allocation to fail under certain
condition by using specific gfp bits.

The gfp bits for order 3 page allocation are different
between different implementation, __GFP_NOMEMALLOC is
or'd to forbid access to emergency reserves memory for
__page_frag_cache_refill(), but it is not or'd in other
implementions, __GFP_DIRECT_RECLAIM is masked off to avoid
direct reclaim in skb_page_frag_refill(), but it is not
masked off in __page_frag_cache_refill().

This patch unifies the gfp bits used between different
implementions by or'ing __GFP_NOMEMALLOC and masking off
__GFP_DIRECT_RECLAIM for order 3 page allocation to avoid
possible pressure for mm.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
CC: Alexander Duyck <alexander.duyck@gmail.com>
---
 drivers/vhost/net.c | 2 +-
 mm/page_alloc.c     | 4 ++--
 net/core/sock.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..e574e21cc0ca 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -670,7 +670,7 @@ static bool vhost_net_page_frag_refill(struct vhost_net *net, unsigned int sz,
 		/* Avoid direct reclaim but allow kswapd to wake */
 		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
-					  __GFP_NORETRY,
+					  __GFP_NORETRY | __GFP_NOMEMALLOC,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c0f7e67c4250..636145c29f70 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4685,8 +4685,8 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 	gfp_t gfp = gfp_mask;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-	gfp_mask |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY |
-		    __GFP_NOMEMALLOC;
+	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
+		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
 	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask,
 				PAGE_FRAG_CACHE_MAX_ORDER);
 	nc->size = page ? PAGE_FRAG_CACHE_MAX_SIZE : PAGE_SIZE;
diff --git a/net/core/sock.c b/net/core/sock.c
index 158dbdebce6a..d4bc4269d7d7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2908,7 +2908,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 		/* Avoid direct reclaim but allow kswapd to wake */
 		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
-					  __GFP_NORETRY,
+					  __GFP_NORETRY | __GFP_NOMEMALLOC,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
-- 
2.33.0


