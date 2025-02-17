Return-Path: <kvm+bounces-38368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B7BA3832A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 13:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB98C188500A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 12:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530E221C177;
	Mon, 17 Feb 2025 12:38:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F627218E85;
	Mon, 17 Feb 2025 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739795936; cv=none; b=pDYCS0ya6uVxa916Vo1XVaI+CMl2huP86jQRl+HlhPyOl7BQdMLjaSMTtO4FTPFQBH/7YxQez0nzrLJSX+KwcXx+mtA8+YKTPd2dPoW8s2k0HMhQeu84MVXTETIbLI1qLd9vuPVSRJ37RiIJ4bwy2WDPgnKS4i6XKRT/iNdfMC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739795936; c=relaxed/simple;
	bh=jtBh+0XSHsZRj0wRyLE3pJ+jqzyYvfhHbJnuhElAk/8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eKPc86+aSc3P9VLQRt5j2AlrcTTVJCifvm/7TCoYQxWuxutfT6EbYGfSfVVbseNpgRv+vLXwg+WicObMuSPZolpc7hiSRnHcFAMx1OXfSXVHpeyIY4ezmIdT1cPWq1rzdtbgP3qEb0b3fuM/t0QfuGPNTNS5PmFZ/g3IFmCePQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4YxMYZ2qlTz1wn6x;
	Mon, 17 Feb 2025 20:34:58 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 505561A0188;
	Mon, 17 Feb 2025 20:38:51 +0800 (CST)
Received: from localhost.localdomain (10.90.30.45) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Feb 2025 20:38:50 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Chris
 Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
	<dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Trond Myklebust
	<trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>
CC: Yunsheng Lin <linyunsheng@huawei.com>, Luiz Capitulino
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-xfs@vger.kernel.org>,
	<linux-mm@kvack.org>, <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
Subject: [RFC] mm: alloc_pages_bulk: remove assumption of populating only NULL elements
Date: Mon, 17 Feb 2025 20:31:23 +0800
Message-ID: <20250217123127.3674033-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf200006.china.huawei.com (7.185.36.61)

As mentioned in [1], it seems odd to check NULL elements in
the middle of page bulk allocating, and it seems caller can
do a better job of bulk allocating pages into a whole array
sequentially without checking NULL elements first before
doing the page bulk allocation.

Remove the above checking also enable the caller to not
zero the array before calling the page bulk allocating API,
which has about 1~2 ns performance improvement for the test
case of time_bench_page_pool03_slow() for page_pool in a
x86 vm system, this reduces some performance impact of
fixing the DMA API misuse problem in [2], performance
improves from 87.886 ns to 86.429 ns.

1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
CC: Jesper Dangaard Brouer <hawk@kernel.org>
CC: Luiz Capitulino <luizcap@redhat.com>
CC: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/vfio/pci/virtio/migrate.c |  2 --
 fs/btrfs/extent_io.c              |  8 +++++---
 fs/erofs/zutil.c                  | 12 ++++++------
 fs/xfs/xfs_buf.c                  |  9 +++++----
 mm/page_alloc.c                   | 32 +++++--------------------------
 net/core/page_pool.c              |  3 ---
 net/sunrpc/svc_xprt.c             |  9 +++++----
 7 files changed, 26 insertions(+), 49 deletions(-)

diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index ba92bb4e9af9..9f003a237dec 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -91,8 +91,6 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
 		if (ret)
 			goto err_append;
 		buf->allocated_length += filled * PAGE_SIZE;
-		/* clean input for another bulk allocation */
-		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
 				PAGE_SIZE / sizeof(*page_list));
 	} while (to_alloc > 0);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2fae67f8fa3..d0466d795cca 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -626,10 +626,12 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
 	unsigned int allocated;
 
 	for (allocated = 0; allocated < nr_pages;) {
-		unsigned int last = allocated;
+		unsigned int new_allocated;
 
-		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
-		if (unlikely(allocated == last)) {
+		new_allocated = alloc_pages_bulk(gfp, nr_pages - allocated,
+						 page_array + allocated);
+		allocated += new_allocated;
+		if (unlikely(!new_allocated)) {
 			/* No progress, fail and do cleanup. */
 			for (int i = 0; i < allocated; i++) {
 				__free_page(page_array[i]);
diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index 55ff2ab5128e..1c50b5e27371 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -85,13 +85,13 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 
 		for (j = 0; j < gbuf->nrpages; ++j)
 			tmp_pages[j] = gbuf->pages[j];
-		do {
-			last = j;
-			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
-					     tmp_pages);
-			if (last == j)
+
+		for (last = j; last < nrpages; last += j) {
+			j = alloc_pages_bulk(GFP_KERNEL, nrpages - last,
+					     tmp_pages + last);
+			if (!j)
 				goto out;
-		} while (j != nrpages);
+		}
 
 		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
 		if (!ptr)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..9e1ce0ab9c35 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -377,16 +377,17 @@ xfs_buf_alloc_pages(
 	 * least one extra page.
 	 */
 	for (;;) {
-		long	last = filled;
+		long	alloc;
 
-		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
-					  bp->b_pages);
+		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
+					 bp->b_pages + refill);
+		refill += alloc;
 		if (filled == bp->b_page_count) {
 			XFS_STATS_INC(bp->b_mount, xb_page_found);
 			break;
 		}
 
-		if (filled != last)
+		if (alloc)
 			continue;
 
 		if (flags & XBF_READ_AHEAD) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 579789600a3c..e0309532b6c4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4541,9 +4541,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * This is a batched version of the page allocator that attempts to
  * allocate nr_pages quickly. Pages are added to the page_array.
  *
- * Note that only NULL elements are populated with pages and nr_pages
- * is the maximum number of pages that will be stored in the array.
- *
  * Returns the number of pages in the array.
  */
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
@@ -4559,29 +4556,18 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	int nr_populated = 0, nr_account = 0;
-
-	/*
-	 * Skip populated array elements to determine if any pages need
-	 * to be allocated before disabling IRQs.
-	 */
-	while (nr_populated < nr_pages && page_array[nr_populated])
-		nr_populated++;
+	int nr_populated = 0;
 
 	/* No pages requested? */
 	if (unlikely(nr_pages <= 0))
 		goto out;
 
-	/* Already populated array? */
-	if (unlikely(nr_pages - nr_populated == 0))
-		goto out;
-
 	/* Bulk allocator does not support memcg accounting. */
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT))
 		goto failed;
 
 	/* Use the single page allocator for one page. */
-	if (nr_pages - nr_populated == 1)
+	if (nr_pages == 1)
 		goto failed;
 
 #ifdef CONFIG_PAGE_OWNER
@@ -4653,24 +4639,16 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
-
-		/* Skip existing pages */
-		if (page_array[nr_populated]) {
-			nr_populated++;
-			continue;
-		}
-
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
-			if (!nr_account) {
+			if (!nr_populated) {
 				pcp_spin_unlock(pcp);
 				goto failed_irq;
 			}
 			break;
 		}
-		nr_account++;
 
 		prep_new_page(page, 0, gfp, 0);
 		set_page_refcounted(page);
@@ -4680,8 +4658,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
 
-	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_populated);
+	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_populated);
 
 out:
 	return nr_populated;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f5e908c9e7ad..ae9e8c78e4bb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -536,9 +536,6 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
 	if (unlikely(pool->alloc.count > 0))
 		return pool->alloc.cache[--pool->alloc.count];
 
-	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
-	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
-
 	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
 					 (struct page **)pool->alloc.cache);
 	if (unlikely(!nr_pages))
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index ae25405d8bd2..6321a4d2f2be 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -663,9 +663,10 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
 		pages = RPCSVC_MAXPAGES;
 	}
 
-	for (filled = 0; filled < pages; filled = ret) {
-		ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
-		if (ret > filled)
+	for (filled = 0; filled < pages; filled += ret) {
+		ret = alloc_pages_bulk(GFP_KERNEL, pages - filled,
+				       rqstp->rq_pages + filled);
+		if (ret)
 			/* Made progress, don't sleep yet */
 			continue;
 
@@ -674,7 +675,7 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
 			set_current_state(TASK_RUNNING);
 			return false;
 		}
-		trace_svc_alloc_arg_err(pages, ret);
+		trace_svc_alloc_arg_err(pages, filled);
 		memalloc_retry_wait(GFP_KERNEL);
 	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
-- 
2.33.0


