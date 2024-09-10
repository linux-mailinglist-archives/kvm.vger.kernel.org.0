Return-Path: <kvm+bounces-26407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3AC9746B3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C1EC1F241E9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8D61BD514;
	Tue, 10 Sep 2024 23:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N02rKgPe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7471BD016
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011900; cv=none; b=Hu7oydtYi2uhE3iikJcLkq1QRzpF3Sm4U7jETISoxHpTYzm9lWcqfmGxRMVdP1ZQSzw/yVp1WaCpmeCQ5A4NdgNpbPtNk5YNhhuYaOhwrgh9svQEjzyj7fuvpTA2ggWNpIyfo/r7PFAatlpgOwnGixrkxiZ/kNO+fnLP/EBs38g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011900; c=relaxed/simple;
	bh=u+HSX5D8aSxjlCK0wmIZa9ZvzIze1ENSWav1reSe9Gs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VX7xxHgPYUd5/vqYs+HFoSXec6w4bj0RAH8b4/GFA5c+lMElFd7CHBQRH4mypJF0X9QT9x4LSPRGcYXFE2Xv2TespnWXC5r0ilnL9Ob/16XKjbWnm1I6gPjWuxOGa8V5B0l2M+t3bDyv8Dva+Ht8s3Uty/zNvTNDpr24iVB0w+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N02rKgPe; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-778702b9f8fso246371a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011898; x=1726616698; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3koUG4NR7/VYilG4JhqRWXEMHNTy5kmn0YA+V+1Maxk=;
        b=N02rKgPe4gMe+IEIOKmGdDRpAYjqdFB7ydop3Jgha2MDrmuOfG01ntQZGFRazzMol+
         TQ3WqbJUUemImVsoR5s2/wMqqcSJN6dAMY3tGnnmjS0f3e7ZoKhrTviLCKIZwWV+Hx7i
         ymDeeb4Gi/g74JzT4IZ6zj2SX8DJQZ9bzZB2DztjQSAtaoZfspoXbmj/5IAKX23oT/rn
         QItTWk+gLS0Tvyfmtt3gq1sf1/jejc1vCGMzJycWim9Kl8mk7xxzLbt1CwFA4Zb1eY4A
         ax/38DUR73Ut5cDOPPQOmVJdxZjfOEQUDH5oiTwPszgLsrmoDJupvfyFA1joeOhlN9B4
         XBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011898; x=1726616698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3koUG4NR7/VYilG4JhqRWXEMHNTy5kmn0YA+V+1Maxk=;
        b=aYDe0IGvzm0ruRTdxbXc7n+caFaIhoOEnRza9cRmRXBmhFEzvVNOsWgiW6RfzXLQLl
         gRS8KQrOJBvNpTrctAeY1SLDZUskyY9VPT3GIUr/a2YbmMI0CNxKBbsiDyAp5JGlQLQP
         jJdwd2dzvjcY0cJHafob6VpOJskCjnvIx8yTg6dVVBo3ZUdjUwsosvjLMGT7+4YUFPGM
         tbVpvM709/rnG/4KN34TIB0aZyUKG81AMNfTZ+93I7jfV6zo9dW8l6bXMybGq/XdFELa
         FdFQQKItII/wtagv7lImDAAfScK6qwxHbOSN3PrJ6PYwvV3mHCQ39QfJaB+t1r/vW4v+
         hvZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXX7lhZtknWGlNOXn3Z6HAeWjxnJcNkdrI4z13Dx5VGAFKkEFPqVR2ndpEve2eS0ukrgSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvmYbWNpSByyB3Ca1/Vw31Fj/pmyGtr2WyG8Ke2gyzKASgziGc
	1IguDqRn8rSmMV0QdNMQe3XyNsZozq1mDF+5hDgomgurhp4LTuJw9rhgbClFlW7A9jO9gmbEb/a
	dahPMhvJ3DUDjOLbtJeAw5g==
X-Google-Smtp-Source: AGHT+IEDqZZk8irFHoo8VNnnGmulx1leYo1hJT0YyoAnYorw/TvU2WADq0CylGqiF1u5/YMn1zVKE8FaP8ki3Qm88w==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a63:8f5e:0:b0:6e3:a2ac:efd4 with SMTP
 id 41be03b00d2f7-7db088941ecmr7238a12.6.1726011897848; Tue, 10 Sep 2024
 16:44:57 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:46 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <768488c67540aa18c200d7ee16e75a3a087022d4.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 15/39] KVM: guest_memfd: hugetlb: allocate and truncate
 from hugetlb
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

If HugeTLB is requested at guest_memfd creation time, HugeTLB pages
will be used to back guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 252 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 239 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 31e1115273e1..2e6f12e2bac8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,8 @@
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/memcontrol.h>
+#include <linux/mempolicy.h>
 
 #include "kvm_mm.h"
 
@@ -29,6 +31,13 @@ static struct kvm_gmem_hugetlb *kvm_gmem_hgmem(struct inode *inode)
 	return inode->i_mapping->i_private_data;
 }
 
+static bool is_kvm_gmem_hugetlb(struct inode *inode)
+{
+	u64 flags = (u64)inode->i_private;
+
+	return flags & KVM_GUEST_MEMFD_HUGETLB;
+}
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -58,6 +67,9 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
+/**
+ * Use the uptodate flag to indicate that the folio is prepared for KVM's usage.
+ */
 static inline void kvm_gmem_mark_prepared(struct folio *folio)
 {
 	folio_mark_uptodate(folio);
@@ -72,13 +84,18 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
 	int r;
 
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
+	if (folio_test_hugetlb(folio)) {
+		folio_zero_user(folio, folio->index << PAGE_SHIFT);
+	} else {
+		unsigned long nr_pages, i;
+
+		nr_pages = folio_nr_pages(folio);
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+	}
 
 	/*
 	 * Preparing huge folios should always be safe, since it should
@@ -103,6 +120,174 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
+static int kvm_gmem_get_mpol_node_nodemask(gfp_t gfp_mask,
+					   struct mempolicy **mpol,
+					   nodemask_t **nodemask)
+{
+	/*
+	 * TODO: mempolicy would probably have to be stored on the inode, use
+	 * task policy for now.
+	 */
+	*mpol = get_task_policy(current);
+
+	/* TODO: ignore interleaving (set ilx to 0) for now. */
+	return policy_node_nodemask(*mpol, gfp_mask, 0, nodemask);
+}
+
+static struct folio *kvm_gmem_hugetlb_alloc_folio(struct hstate *h,
+						  struct hugepage_subpool *spool)
+{
+	bool memcg_charge_was_prepared;
+	struct mem_cgroup *memcg;
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	struct folio *folio;
+	gfp_t gfp_mask;
+	int ret;
+	int nid;
+
+	gfp_mask = htlb_alloc_mask(h);
+
+	memcg = get_mem_cgroup_from_current();
+	ret = mem_cgroup_hugetlb_try_charge(memcg,
+					    gfp_mask | __GFP_RETRY_MAYFAIL,
+					    pages_per_huge_page(h));
+	if (ret == -ENOMEM)
+		goto err;
+
+	memcg_charge_was_prepared = ret != -EOPNOTSUPP;
+
+	/* Pages are only to be taken from guest_memfd subpool and nowhere else. */
+	if (hugepage_subpool_get_pages(spool, 1))
+		goto err_cancel_charge;
+
+	nid = kvm_gmem_get_mpol_node_nodemask(htlb_alloc_mask(h), &mpol,
+					      &nodemask);
+	/*
+	 * charge_cgroup_reservation is false because we didn't make any cgroup
+	 * reservations when creating the guest_memfd subpool.
+	 *
+	 * use_hstate_resv is true because we reserved from global hstate when
+	 * creating the guest_memfd subpool.
+	 */
+	folio = hugetlb_alloc_folio(h, mpol, nid, nodemask, false, true);
+	mpol_cond_put(mpol);
+
+	if (!folio)
+		goto err_put_pages;
+
+	hugetlb_set_folio_subpool(folio, spool);
+
+	if (memcg_charge_was_prepared)
+		mem_cgroup_commit_charge(folio, memcg);
+
+out:
+	mem_cgroup_put(memcg);
+
+	return folio;
+
+err_put_pages:
+	hugepage_subpool_put_pages(spool, 1);
+
+err_cancel_charge:
+	if (memcg_charge_was_prepared)
+		mem_cgroup_cancel_charge(memcg, pages_per_huge_page(h));
+
+err:
+	folio = ERR_PTR(-ENOMEM);
+	goto out;
+}
+
+static int kvm_gmem_hugetlb_filemap_add_folio(struct address_space *mapping,
+					      struct folio *folio, pgoff_t index,
+					      gfp_t gfp)
+{
+	int ret;
+
+	__folio_set_locked(folio);
+	ret = __filemap_add_folio(mapping, folio, index, gfp, NULL);
+	if (unlikely(ret)) {
+		__folio_clear_locked(folio);
+		return ret;
+	}
+
+	/*
+	 * In hugetlb_add_to_page_cache(), there is a call to
+	 * folio_clear_hugetlb_restore_reserve(). This is handled when the pages
+	 * are removed from the page cache in unmap_hugepage_range() ->
+	 * __unmap_hugepage_range() by conditionally calling
+	 * folio_set_hugetlb_restore_reserve(). In kvm_gmem_hugetlb's usage of
+	 * hugetlb, there are no VMAs involved, and pages are never taken from
+	 * the surplus, so when pages are freed, the hstate reserve must be
+	 * restored. Hence, this function makes no call to
+	 * folio_clear_hugetlb_restore_reserve().
+	 */
+
+	/* mark folio dirty so that it will not be removed from cache/inode */
+	folio_mark_dirty(folio);
+
+	return 0;
+}
+
+static struct folio *kvm_gmem_hugetlb_alloc_and_cache_folio(struct inode *inode,
+							    pgoff_t index)
+{
+	struct kvm_gmem_hugetlb *hgmem;
+	struct folio *folio;
+	int ret;
+
+	hgmem = kvm_gmem_hgmem(inode);
+	folio = kvm_gmem_hugetlb_alloc_folio(hgmem->h, hgmem->spool);
+	if (IS_ERR(folio))
+		return folio;
+
+	/* TODO: Fix index here to be aligned to huge page size. */
+	ret = kvm_gmem_hugetlb_filemap_add_folio(
+		inode->i_mapping, folio, index, htlb_alloc_mask(hgmem->h));
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	spin_lock(&inode->i_lock);
+	inode->i_blocks += blocks_per_huge_page(hgmem->h);
+	spin_unlock(&inode->i_lock);
+
+	return folio;
+}
+
+static struct folio *kvm_gmem_get_hugetlb_folio(struct inode *inode,
+						pgoff_t index)
+{
+	struct address_space *mapping;
+	struct folio *folio;
+	struct hstate *h;
+	pgoff_t hindex;
+	u32 hash;
+
+	h = kvm_gmem_hgmem(inode)->h;
+	hindex = index >> huge_page_order(h);
+	mapping = inode->i_mapping;
+
+	/* To lock, we calculate the hash using the hindex and not index. */
+	hash = hugetlb_fault_mutex_hash(mapping, hindex);
+	mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+	/*
+	 * The filemap is indexed with index and not hindex. Taking lock on
+	 * folio to align with kvm_gmem_get_regular_folio()
+	 */
+	folio = filemap_lock_folio(mapping, index);
+	if (!IS_ERR(folio))
+		goto out;
+
+	folio = kvm_gmem_hugetlb_alloc_and_cache_folio(inode, index);
+out:
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -114,8 +299,10 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
-	/* TODO: Support huge pages. */
-	return filemap_grab_folio(inode->i_mapping, index);
+	if (is_kvm_gmem_hugetlb(inode))
+		return kvm_gmem_get_hugetlb_folio(inode, index);
+	else
+		return filemap_grab_folio(inode->i_mapping, index);
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
@@ -240,6 +427,35 @@ static void kvm_gmem_hugetlb_truncate_folios_range(struct inode *inode,
 	spin_unlock(&inode->i_lock);
 }
 
+static void kvm_gmem_hugetlb_truncate_range(struct inode *inode, loff_t lstart,
+					    loff_t lend)
+{
+	loff_t full_hpage_start;
+	loff_t full_hpage_end;
+	unsigned long hsize;
+	struct hstate *h;
+
+	h = kvm_gmem_hgmem(inode)->h;
+	hsize = huge_page_size(h);
+
+	full_hpage_start = round_up(lstart, hsize);
+	full_hpage_end = round_down(lend, hsize);
+
+	if (lstart < full_hpage_start) {
+		hugetlb_zero_partial_page(h, inode->i_mapping, lstart,
+					  full_hpage_start);
+	}
+
+	if (full_hpage_end > full_hpage_start) {
+		kvm_gmem_hugetlb_truncate_folios_range(inode, full_hpage_start,
+						       full_hpage_end);
+	}
+
+	if (lend > full_hpage_end) {
+		hugetlb_zero_partial_page(h, inode->i_mapping, full_hpage_end,
+					  lend);
+	}
+}
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
@@ -257,7 +473,12 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
-	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
+	if (is_kvm_gmem_hugetlb(inode)) {
+		kvm_gmem_hugetlb_truncate_range(inode, offset, offset + len);
+	} else {
+		truncate_inode_pages_range(inode->i_mapping, offset,
+					   offset + len - 1);
+	}
 
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
@@ -279,8 +500,15 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 
 	filemap_invalidate_lock_shared(mapping);
 
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
+	if (is_kvm_gmem_hugetlb(inode)) {
+		unsigned long hsize = huge_page_size(kvm_gmem_hgmem(inode)->h);
+
+		start = round_down(offset, hsize) >> PAGE_SHIFT;
+		end = round_down(offset + len, hsize) >> PAGE_SHIFT;
+	} else {
+		start = offset >> PAGE_SHIFT;
+		end = (offset + len) >> PAGE_SHIFT;
+	}
 
 	r = 0;
 	for (index = start; index < end; ) {
@@ -408,9 +636,7 @@ static void kvm_gmem_hugetlb_teardown(struct inode *inode)
 
 static void kvm_gmem_evict_inode(struct inode *inode)
 {
-	u64 flags = (u64)inode->i_private;
-
-	if (flags & KVM_GUEST_MEMFD_HUGETLB)
+	if (is_kvm_gmem_hugetlb(inode))
 		kvm_gmem_hugetlb_teardown(inode);
 	else
 		truncate_inode_pages_final(inode->i_mapping);
@@ -827,7 +1053,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 
 	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
-		*max_order = 0;
+		*max_order = folio_order(folio);
 
 	*is_prepared = folio_test_uptodate(folio);
 	return folio;
-- 
2.46.0.598.g6f2099f65c-goog


