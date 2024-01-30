Return-Path: <kvm+bounces-7455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDB0842346
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F2D31C227C2
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC77967E9A;
	Tue, 30 Jan 2024 11:38:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2B67731;
	Tue, 30 Jan 2024 11:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614685; cv=none; b=ZyJxfagfvnPmb5IS+TMtX/Nm6lH05mCtls+YSJpTcrnYfa4yvGeGZCzwpDZV/FmVqA1Xa3zgEc0UF4DQvq7vE3mGs3CsG0A2dymZstLuefxpBwMoYIQePI9/NBnVTPq+Wf4yex3JFjXu0gnTUF90ujrES9KTwSGwAovUCvBYCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614685; c=relaxed/simple;
	bh=iIw9m8E+34rmyeAQdxJf1gG5mn3NGG9OKYzHsTrTvN4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xo2Q3SAiB+uB3k0hj/Gs7EJw/36JCzoMV8jAwGiiqcLobSTGfpFtc0/7/nvxa6NXRBOPp7HWifWm8CK0+BlRRC3aB389LCzxiY4dNcxfe0N1i+gwNzs1rx4v6QXZEj9hX4vGuhFm2CKvqo9zXTtXzjC9r04nkVUUynn3azFw23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TPNQz0vJ8z1Q8H5;
	Tue, 30 Jan 2024 19:36:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 1039C1A016B;
	Tue, 30 Jan 2024 19:38:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 19:38:00 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Alexander Duyck <alexanderduyck@fb.com>, Alexander
 Duyck <alexander.duyck@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <edumazet@google.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>
Subject: [PATCH net-next v4 2/5] page_frag: unify gfp bits for order 3 page allocation
Date: Tue, 30 Jan 2024 19:37:07 +0800
Message-ID: <20240130113710.34511-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240130113710.34511-1-linyunsheng@huawei.com>
References: <20240130113710.34511-1-linyunsheng@huawei.com>
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
index 88bf810394a5..8289a3d8c375 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2919,7 +2919,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
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


