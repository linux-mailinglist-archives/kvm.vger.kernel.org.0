Return-Path: <kvm+bounces-43230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCB7A88031
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6C351890FDB
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 12:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2764D29DB96;
	Mon, 14 Apr 2025 12:15:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8818A6A9;
	Mon, 14 Apr 2025 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744632903; cv=none; b=mJWPPgjajJspBsTXHLqdvkrmuDu3lN5+lZ2V9kQrE5swyNYOsmd9INWb+61465hOk4bRLSfYT7zlJnQ/uVSO0OY1p3yjsgNXMR/x93gDDQCvhBzVhQx9tLQO6mSQnz+NnIcUz5PaKli/5DxiKtIIu85Fbou1OBnOAijsytY+njk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744632903; c=relaxed/simple;
	bh=Vh1XYNk1Pgd7/7fao+EL3a14mR2DGRdB6cj8+UPIOGo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G4uKOiLzo4yqERVkdYJ0lVShA+qJsmQimRBLHjF1RhhF3r73sbgDmM5VRAbWDgbX9IRXJEkrF/U8ChGQCpWvr4Z3cnTJWrbcvNd4mW8u9B704mFWOlTSpsRlWsQVytLCquKVhADzoAwzHatNZydj+re0SYIKXc9KmgDpRyum0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZbmTN4kPBz27hSp;
	Mon, 14 Apr 2025 20:15:36 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id 3309B140257;
	Mon, 14 Apr 2025 20:14:55 +0800 (CST)
Received: from localhost.localdomain (10.90.30.45) by
 dggpemf200006.china.huawei.com (7.185.36.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 14 Apr 2025 20:14:54 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yishai Hadas
	<yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>, Josef
 Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Gao Xiang
	<xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Neil
 Brown <neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
	<Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
	<andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard
 Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song
	<yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo
	<haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
	<anna@kernel.org>
CC: Yunsheng Lin <linyunsheng@huawei.com>, Luiz Capitulino
	<luizcap@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-mm@kvack.org>,
	<linux-nfs@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3] mm: alloc_pages_bulk: support both simple and full-featured API
Date: Mon, 14 Apr 2025 20:08:11 +0800
Message-ID: <20250414120819.3053967-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf200006.china.huawei.com (7.185.36.61)

As mentioned in [1], it seems odd to check NULL elements in
the middle of page bulk allocating, and it seems caller can
do a better job of bulk allocating pages into a whole array
sequentially without checking NULL elements first before
doing the page bulk allocation for most of existing users
by passing 'page_array + allocated' and 'nr_pages - allocated'
when calling subsequent page bulk alloc API so that NULL
checking can be avoided, see the pattern in mm/mempolicy.c.

Through analyzing of existing bulk allocation API users, it
seems only the fs users are depending on the assumption of
populating only NULL elements, see:
commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
commit d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
commit f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
commit 88e4d41a264d ("SUNRPC: Use __alloc_bulk_pages() in svc_init_buffer()")

The current API adds a mental burden for most users. For most
users, their code would be much cleaner if the interface accepts
an uninitialised array with length, and were told how many pages
had been stored in that array, so support one simple and one
full-featured to meet the above different use cases as below:
- alloc_pages_bulk() would be given an uninitialised array of page
  pointers and a required count and would return the number of
  pages that were allocated.
- alloc_pages_bulk_refill() would be given an initialised array
  of page pointers some of which might be NULL. It would attempt
  to allocate pages for the non-NULL pointers, return 0 if all
  pages are allocated, -EAGAIN if at least one page allocated,
  ok to try again immediately or -ENOMEM if don't bother trying
  again soon, which provides a more consistent semantics than the
  current API as mentioned in [2], at the cost of the pages might
  be getting re-ordered to make the implementation simpler.

Change the existing fs users to use the full-featured API, except
for the one for svc_init_buffer() in net/sunrpc/svc.c. Other
existing callers can use the simple API as they seems to be passing
all NULL elements via memset, kzalloc, etc, only remove unnecessary
memset for existing users calling the simple API in this patch.

The test result for xfstests full test:
Before this patch:
btrfs/default: 1061 tests, 3 failures, 290 skipped, 13152 seconds
  Failures: btrfs/012 btrfs/226
  Flaky: generic/301: 60% (3/5)
Totals: 1073 tests, 290 skipped, 13 failures, 0 errors, 12540s

nfs/loopback: 530 tests, 3 failures, 392 skipped, 3942 seconds
  Failures: generic/464 generic/551
  Flaky: generic/650: 40% (2/5)
Totals: 542 tests, 392 skipped, 12 failures, 0 errors, 3799s

After this patch:
btrfs/default: 1061 tests, 2 failures, 290 skipped, 13446 seconds
  Failures: btrfs/012 btrfs/226
Totals: 1069 tests, 290 skipped, 10 failures, 0 errors, 12853s

nfs/loopback: 530 tests, 3 failures, 392 skipped, 4103 seconds
  Failures: generic/464 generic/551
  Flaky: generic/650: 60% (3/5)
Totals: 542 tests, 392 skipped, 13 failures, 0 errors, 3933s

The stress test also suggest there is no regression for the erofs
too.

Using the simple API also enable the caller to not zero the array
before calling the page bulk allocating API, which has about 1~2 ns
performance improvement for time_bench_page_pool03_slow() test case
of page_pool in a x86 vm system, this reduces some performance impact
of fixing the DMA API misuse problem in [3], performance improves
from 87.886 ns to 86.429 ns.

Also a temporary patch to enable the using of full-featured API in
page_pool suggests that the new full-featured API doesn't seem to have
noticeable performance impact for the existing users, like SUNRPC, btrfs
and erofs.

1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
2. https://lore.kernel.org/all/180818a1-b906-4a0b-89d3-34cb71cc26c9@huawei.com/
3. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
CC: Jesper Dangaard Brouer <hawk@kernel.org>
CC: Luiz Capitulino <luizcap@redhat.com>
CC: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Neil Brown <neilb@suse.de>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V3:
1. Provide both simple and full-featured API as suggested by NeilBrown.
2. Do the fs testing as suggested in V2.

V2:
1. Drop RFC tag.
2. Fix a compile error for xfs.
3. Defragmemt the page_array for SUNRPC and btrfs.
---
 drivers/vfio/pci/mlx5/cmd.c       |  2 --
 drivers/vfio/pci/virtio/migrate.c |  2 --
 fs/btrfs/extent_io.c              | 21 +++++++++---------
 fs/erofs/zutil.c                  | 11 +++++----
 include/linux/gfp.h               | 37 +++++++++++++++++++++++++++++++
 include/trace/events/sunrpc.h     | 12 +++++-----
 kernel/bpf/arena.c                |  1 -
 mm/page_alloc.c                   | 32 +++++---------------------
 net/core/page_pool.c              |  3 ---
 net/sunrpc/svc_xprt.c             | 12 ++++++----
 10 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 11eda6b207f1..fb094527715f 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -446,8 +446,6 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 		if (ret)
 			goto err_append;
 		buf->allocated_length += filled * PAGE_SIZE;
-		/* clean input for another bulk allocation */
-		memset(page_list, 0, filled * sizeof(*page_list));
 		to_fill = min_t(unsigned int, to_alloc,
 				PAGE_SIZE / sizeof(*page_list));
 	} while (to_alloc > 0);
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
index 197f5e51c474..51ef15703900 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -623,21 +623,22 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
 			   bool nofail)
 {
 	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
-	unsigned int allocated;
-
-	for (allocated = 0; allocated < nr_pages;) {
-		unsigned int last = allocated;
+	int ret;
 
-		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
-		if (unlikely(allocated == last)) {
+	do {
+		ret = alloc_pages_bulk_refill(gfp, nr_pages, page_array);
+		if (unlikely(ret == -ENOMEM)) {
 			/* No progress, fail and do cleanup. */
-			for (int i = 0; i < allocated; i++) {
-				__free_page(page_array[i]);
-				page_array[i] = NULL;
+			for (int i = 0; i < nr_pages; i++) {
+				if (page_array[i]) {
+					__free_page(page_array[i]);
+					page_array[i] = NULL;
+				}
 			}
 			return -ENOMEM;
 		}
-	}
+	} while (ret == -EAGAIN);
+
 	return 0;
 }
 
diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index 55ff2ab5128e..6ce11a8a261c 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -68,7 +68,7 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 	struct page **tmp_pages = NULL;
 	struct z_erofs_gbuf *gbuf;
 	void *ptr, *old_ptr;
-	int last, i, j;
+	int ret, i, j;
 
 	mutex_lock(&gbuf_resize_mutex);
 	/* avoid shrinking gbufs, since no idea how many fses rely on */
@@ -86,12 +86,11 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
 		for (j = 0; j < gbuf->nrpages; ++j)
 			tmp_pages[j] = gbuf->pages[j];
 		do {
-			last = j;
-			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
-					     tmp_pages);
-			if (last == j)
+			ret = alloc_pages_bulk_refill(GFP_KERNEL, nrpages,
+						      tmp_pages);
+			if (ret == -ENOMEM)
 				goto out;
-		} while (j != nrpages);
+		} while (ret == -EAGAIN);
 
 		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
 		if (!ptr)
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index c9fa6309c903..cf6100981fd6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -244,6 +244,43 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
 #define alloc_pages_bulk(_gfp, _nr_pages, _page_array)		\
 	__alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _page_array)
 
+/*
+ * alloc_pages_bulk_refill_noprof - Refill order-0 pages to an array
+ * @gfp: GFP flags for the allocation when refilling
+ * @nr_pages: The size of refilling array
+ * @page_array: The array to refill order-0 pages
+ *
+ * Note that only NULL elements are populated with pages and the pages might
+ * get re-ordered.
+ *
+ * Return 0 if all pages are refilled, -EAGAIN if at least one page is refilled,
+ * ok to try again immediately or -ENOMEM if no page is refilled and don't
+ * bother trying again soon.
+ */
+static inline int alloc_pages_bulk_refill_noprof(gfp_t gfp, int nr_pages,
+						 struct page **page_array)
+{
+	int allocated = 0, i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (page_array[i]) {
+			swap(page_array[allocated], page_array[i]);
+			allocated++;
+		}
+	}
+
+	i = alloc_pages_bulk_noprof(gfp, numa_mem_id(), NULL,
+				    nr_pages - allocated,
+				    page_array + allocated);
+	if (likely(allocated + i == nr_pages))
+		return 0;
+
+	return i ? -EAGAIN : -ENOMEM;
+}
+
+#define alloc_pages_bulk_refill(...)				\
+	alloc_hooks(alloc_pages_bulk_refill_noprof(__VA_ARGS__))
+
 static inline unsigned long
 alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, unsigned long nr_pages,
 				   struct page **page_array)
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 5d331383047b..cb8899f1cbdc 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -2143,23 +2143,23 @@ TRACE_EVENT(svc_wake_up,
 TRACE_EVENT(svc_alloc_arg_err,
 	TP_PROTO(
 		unsigned int requested,
-		unsigned int allocated
+		int ret
 	),
 
-	TP_ARGS(requested, allocated),
+	TP_ARGS(requested, ret),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, requested)
-		__field(unsigned int, allocated)
+		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		__entry->requested = requested;
-		__entry->allocated = allocated;
+		__entry->ret = ret;
 	),
 
-	TP_printk("requested=%u allocated=%u",
-		__entry->requested, __entry->allocated)
+	TP_printk("requested=%u ret=%d",
+		__entry->requested, __entry->ret)
 );
 
 DECLARE_EVENT_CLASS(svc_deferred_event,
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 0d56cea71602..9022c4440814 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -445,7 +445,6 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 			return 0;
 	}
 
-	/* zeroing is needed, since alloc_pages_bulk() only fills in non-zero entries */
 	pages = kvcalloc(page_cnt, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d7cfcfa2b077..59a4fe23e62a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4784,9 +4784,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * This is a batched version of the page allocator that attempts to
  * allocate nr_pages quickly. Pages are added to the page_array.
  *
- * Note that only NULL elements are populated with pages and nr_pages
- * is the maximum number of pages that will be stored in the array.
- *
  * Returns the number of pages in the array.
  */
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
@@ -4802,29 +4799,18 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
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
@@ -4896,24 +4882,16 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
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
@@ -4923,8 +4901,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
 
-	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
+	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_populated);
+	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_populated);
 
 out:
 	return nr_populated;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 7745ad924ae2..2431d2f6d610 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -541,9 +541,6 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
 	if (unlikely(pool->alloc.count > 0))
 		return pool->alloc.cache[--pool->alloc.count];
 
-	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
-	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
-
 	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
 					 (struct page **)pool->alloc.cache);
 	if (unlikely(!nr_pages))
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index ae25405d8bd2..1191686fc0af 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -653,7 +653,8 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
 	struct xdr_buf *arg = &rqstp->rq_arg;
-	unsigned long pages, filled, ret;
+	unsigned long pages;
+	int ret;
 
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
@@ -663,9 +664,12 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
 		pages = RPCSVC_MAXPAGES;
 	}
 
-	for (filled = 0; filled < pages; filled = ret) {
-		ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
-		if (ret > filled)
+	while (true) {
+		ret = alloc_pages_bulk_refill(GFP_KERNEL, pages, rqstp->rq_pages);
+		if (!ret)
+			break;
+
+		if (ret == -EAGAIN)
 			/* Made progress, don't sleep yet */
 			continue;
 
-- 
2.33.0


