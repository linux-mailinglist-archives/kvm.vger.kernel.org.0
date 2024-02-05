Return-Path: <kvm+bounces-8011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08398849AE4
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 13:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0F381F236E3
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 12:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1459F45033;
	Mon,  5 Feb 2024 12:46:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488F1CAA2;
	Mon,  5 Feb 2024 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707137164; cv=none; b=g1qwUCh8OnuU8E1fmT8hKWwUyLgn8OqXVmjrYlBs2Uu26yXSQQeI5HrI8jGdq3PwAgukH7GKU6XnZX8XxbYrLyvvOhimqjkLSSwwqA9IXGyhoC70TIkQc7QE05YQCyuMxwgagVJnW81hwhLWwiQvHyDcEj8NU6rjiMtIuW3/SCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707137164; c=relaxed/simple;
	bh=nN0hXC2rCPqcNLu07ELbr6FXn/yhkJ6KwF/VMli0qYo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpavDykORWJ+MNkUX4pHluBi8CcKJ4mqOPxtZBzVudhb8aXIf1X8UhYIEkHMzmBDsv/mgYxuA7n1e8vbMDvTrO6FAqiLEzS1LKJTg+lLIqIuTs7u0ZL/kG33ByFfEd3EJX+QicPkQy8NZ98208WS/QEdp1A8DyPRWHZ0wZkxmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4TT5hD3kdwz1vtDM;
	Mon,  5 Feb 2024 20:45:32 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id CB9001A0172;
	Mon,  5 Feb 2024 20:45:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 20:45:59 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexander Duyck <alexanderduyck@fb.com>, Alexander
 Duyck <alexander.duyck@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>, <linux-mm@kvack.org>
Subject: [PATCH net-next v5 2/5] page_frag: unify gfp bits for order 3 page allocation
Date: Mon, 5 Feb 2024 20:45:02 +0800
Message-ID: <20240205124506.57670-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240205124506.57670-1-linyunsheng@huawei.com>
References: <20240205124506.57670-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)

Currently there seems to be three page frag implementations
which all try to allocate order 3 page, if that fails, it
then fail back to allocate order 0 page, and each of them
all allow order 3 page allocation to fail under certain
condition by using specific gfp bits.

The gfp bits for order 3 page allocation are different
between different implementation, __GFP_NOMEMALLOC is
or'd to forbid access to emergency reserves memory for
__page_frag_cache_refill(), but it is not or'd in other
implementions, __GFP_DIRECT_RECLAIM is masked off to avoid
direct reclaim in vhost_net_page_frag_refill(), but it is
not masked off in __page_frag_cache_refill().

This patch unifies the gfp bits used between different
implementions by or'ing __GFP_NOMEMALLOC and masking off
__GFP_DIRECT_RECLAIM for order 3 page allocation to avoid
possible pressure for mm.

Leave the gfp unifying for page frag implementation in sock.c
for now as suggested by Paolo Abeni.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
CC: Alexander Duyck <alexander.duyck@gmail.com>
---
 drivers/vhost/net.c | 2 +-
 mm/page_alloc.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.33.0


