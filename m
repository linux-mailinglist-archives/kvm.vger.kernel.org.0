Return-Path: <kvm+bounces-16796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DBD8BDB60
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 532941C215A2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4C177F30;
	Tue,  7 May 2024 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdKxo+O3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C1A71B3A;
	Tue,  7 May 2024 06:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062978; cv=none; b=Na7OvryLTmv8At474OQ33rwWQ5p21DeRgyb37XDv0hmL0Mj22LLLChrwScGuvYf8bWkM3W8tNOOBv0AWLeIaAty1+4PsSffHPmqOE7QEw7bsz72QineASjFUqwPrUuCr+1rjDOoxXzYturSOzhjx+ab3tOONaUPwc2Hr09Z9NpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062978; c=relaxed/simple;
	bh=TL0UZXMfyUTYYFYNxhfZM0gx/hJkCl1fIxqe8cLgHB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=jgiGH4OWFkV3ZTrhKMyTK6VX+IMqGQY+Dj/7Z4MTCv/S62HGXK8PU/rXXsX+r1fezrj4rkJ0FF+mWwYrXf6uYiOXA/Uoir2twSwzmFYIg7uebSQQskYq5F5S8wWUIaRuPARYBNwsVqFbdJi7pDStvogebgZtJNQKCLtspUv+gPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdKxo+O3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715062974; x=1746598974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TL0UZXMfyUTYYFYNxhfZM0gx/hJkCl1fIxqe8cLgHB0=;
  b=DdKxo+O36SyUhE0W7MSwC43ZvL++v0DmAj3qS3B5SVMsRMMhuBFM9RHI
   2Q0jtXvBTl+e7JShS+350r2gA0s5SmbOTzURCaWdv6nrcW4GBBRKLPPLx
   T50IskMtycQ0gbbexB+tbiZo0M5nHfnUVu4/tnHgca+0Uf1NmLrpymI0O
   EvGkcr3A3neo1C4O8TGHyK6kxuB0A44Rcl4SfGE3KgsmVD709oxt5oEhh
   4ZSfU9Bhp6JrMzd0Wob1q7XWCs/1LiyaYaBXNoCeVRopJZz/xRMkRmfeP
   x8ay+r8wNAtJuVm3v1qMT+pDDwhQqoGamoYjlrZnIqs7htDMEXRQcSfqh
   A==;
X-CSE-ConnectionGUID: OUec294VRwuXogdB6eGP/Q==
X-CSE-MsgGUID: ULSFlFI1SjKZkYTKhK4Jgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10720354"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10720354"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:22:53 -0700
X-CSE-ConnectionGUID: /8n9UBt7RNevDb1XsRFpXw==
X-CSE-MsgGUID: XGQwIr8gRyGZnywFHvC53w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="65857923"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:22:48 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: iommu@lists.linux.dev,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	corbet@lwn.net,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	baolu.lu@linux.intel.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in non-coherent domains
Date: Tue,  7 May 2024 14:22:12 +0800
Message-Id: <20240507062212.20535-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240507061802.20184-1-yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Flush CPU cache on DMA pages before mapping them into the first
non-coherent domain (domain that does not enforce cache coherency, i.e. CPU
caches are not force-snooped) and after unmapping them from the last
domain.

Devices attached to non-coherent domains can execute non-coherent DMAs
(DMAs that lack CPU cache snooping) to access physical memory with CPU
caches bypassed.

Such a scenario could be exploited by a malicious guest, allowing them to
access stale host data in memory rather than the data initialized by the
host (e.g., zeros) in the cache, thus posing a risk of information leakage
attack.

Furthermore, the host kernel (e.g. a ksm thread) might encounter
inconsistent data between the CPU cache and memory (left by a malicious
guest) after a page is unpinned for DMA but before it's recycled.

Therefore, it is required to flush the CPU cache before a page is
accessible to non-coherent DMAs and after the page is inaccessible to
non-coherent DMAs.

However, the CPU cache is not flushed immediately when the page is unmapped
from the last non-coherent domain. Instead, the flushing is performed
lazily, right before the page is unpinned.
Take the following example to illustrate the process. The CPU cache is
flushed right before step 2 and step 5.
1. A page is mapped into a coherent domain.
2. The page is mapped into a non-coherent domain.
3. The page is unmapped from the non-coherent domain e.g.due to hot-unplug.
4. The page is unmapped from the coherent domain.
5. The page is unpinned.

Reasons for adopting this lazily flushing design include:
- There're several unmap paths and only one unpin path. Lazily flush before
  unpin wipes out the inconsistency between cache and physical memory
  before a page is globally visible and produces code that is simpler, more
  maintainable and easier to backport.
- Avoid dividing a large unmap range into several smaller ones or
  allocating additional memory to hold IOVA to HPA relationship.

Unlike "has_noncoherent_domain" flag used in vfio_iommu, the
"noncoherent_domain_cnt" counter is implemented in io_pagetable to track
whether an iopt has non-coherent domains attached.
Such a difference is because in iommufd only hwpt of type paging contains
flag "enforce_cache_coherency" and iommu domains in io_pagetable has no
flag "enforce_cache_coherency" as that in vfio_domain.
A counter in io_pagetable can avoid traversing ioas->hwpt_list and holding
ioas->mutex.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Closes: https://lore.kernel.org/lkml/20240109002220.GA439767@nvidia.com
Fixes: e8d57210035b ("iommufd: Add kAPI toward external drivers for physical devices")
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 19 +++++++++--
 drivers/iommu/iommufd/io_pagetable.h    |  5 +++
 drivers/iommu/iommufd/iommufd_private.h |  1 +
 drivers/iommu/iommufd/pages.c           | 44 +++++++++++++++++++++++--
 4 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 33d142f8057d..e3099d732c5c 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -14,12 +14,18 @@ void iommufd_hwpt_paging_destroy(struct iommufd_object *obj)
 		container_of(obj, struct iommufd_hwpt_paging, common.obj);
 
 	if (!list_empty(&hwpt_paging->hwpt_item)) {
+		struct io_pagetable *iopt = &hwpt_paging->ioas->iopt;
 		mutex_lock(&hwpt_paging->ioas->mutex);
 		list_del(&hwpt_paging->hwpt_item);
 		mutex_unlock(&hwpt_paging->ioas->mutex);
 
-		iopt_table_remove_domain(&hwpt_paging->ioas->iopt,
-					 hwpt_paging->common.domain);
+		iopt_table_remove_domain(iopt, hwpt_paging->common.domain);
+
+		if (!hwpt_paging->enforce_cache_coherency) {
+			down_write(&iopt->domains_rwsem);
+			iopt->noncoherent_domain_cnt--;
+			up_write(&iopt->domains_rwsem);
+		}
 	}
 
 	if (hwpt_paging->common.domain)
@@ -176,6 +182,12 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			goto out_abort;
 	}
 
+	if (!hwpt_paging->enforce_cache_coherency) {
+		down_write(&ioas->iopt.domains_rwsem);
+		ioas->iopt.noncoherent_domain_cnt++;
+		up_write(&ioas->iopt.domains_rwsem);
+	}
+
 	rc = iopt_table_add_domain(&ioas->iopt, hwpt->domain);
 	if (rc)
 		goto out_detach;
@@ -183,6 +195,9 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	return hwpt_paging;
 
 out_detach:
+	down_write(&ioas->iopt.domains_rwsem);
+	ioas->iopt.noncoherent_domain_cnt--;
+	up_write(&ioas->iopt.domains_rwsem);
 	if (immediate_attach)
 		iommufd_hw_pagetable_detach(idev);
 out_abort:
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 0ec3509b7e33..557da8fb83d9 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -198,6 +198,11 @@ struct iopt_pages {
 	void __user *uptr;
 	bool writable:1;
 	u8 account_mode;
+	/*
+	 * CPU cache flush is required before mapping the pages to or after
+	 * unmapping it from a noncoherent domain
+	 */
+	bool cache_flush_required:1;
 
 	struct xarray pinned_pfns;
 	/* Of iopt_pages_access::node */
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 991f864d1f9b..fc77fd43b232 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -53,6 +53,7 @@ struct io_pagetable {
 	struct rb_root_cached reserved_itree;
 	u8 disable_large_pages;
 	unsigned long iova_alignment;
+	unsigned int noncoherent_domain_cnt;
 };
 
 void iopt_init_table(struct io_pagetable *iopt);
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 528f356238b3..8f4b939cba5b 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -272,6 +272,17 @@ struct pfn_batch {
 	unsigned int total_pfns;
 };
 
+static void iopt_cache_flush_pfn_batch(struct pfn_batch *batch)
+{
+	unsigned long cur, i;
+
+	for (cur = 0; cur < batch->end; cur++) {
+		for (i = 0; i < batch->npfns[cur]; i++)
+			arch_clean_nonsnoop_dma(PFN_PHYS(batch->pfns[cur] + i),
+						PAGE_SIZE);
+	}
+}
+
 static void batch_clear(struct pfn_batch *batch)
 {
 	batch->total_pfns = 0;
@@ -637,10 +648,18 @@ static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
 	while (npages) {
 		size_t to_unpin = min_t(size_t, npages,
 					batch->npfns[cur] - first_page_off);
+		unsigned long pfn = batch->pfns[cur] + first_page_off;
+
+		/*
+		 * Lazily flushing CPU caches when a page is about to be
+		 * unpinned if the page was mapped into a noncoherent domain
+		 */
+		if (pages->cache_flush_required)
+			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
+						to_unpin << PAGE_SHIFT);
 
 		unpin_user_page_range_dirty_lock(
-			pfn_to_page(batch->pfns[cur] + first_page_off),
-			to_unpin, pages->writable);
+			pfn_to_page(pfn), to_unpin, pages->writable);
 		iopt_pages_sub_npinned(pages, to_unpin);
 		cur++;
 		first_page_off = 0;
@@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
 {
 	unsigned long done_end_index;
 	struct pfn_reader pfns;
+	bool cache_flush_required;
 	int rc;
 
 	lockdep_assert_held(&area->pages->mutex);
 
+	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
+			       !area->pages->cache_flush_required;
+
+	if (cache_flush_required)
+		area->pages->cache_flush_required = true;
+
 	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
 			      iopt_area_last_index(area));
 	if (rc)
@@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
 
 	while (!pfn_reader_done(&pfns)) {
 		done_end_index = pfns.batch_start_index;
+		if (cache_flush_required)
+			iopt_cache_flush_pfn_batch(&pfns.batch);
+
 		rc = batch_to_domain(&pfns.batch, domain, area,
 				     pfns.batch_start_index);
 		if (rc)
@@ -1413,6 +1442,7 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 	unsigned long unmap_index;
 	struct pfn_reader pfns;
 	unsigned long index;
+	bool cache_flush_required;
 	int rc;
 
 	lockdep_assert_held(&area->iopt->domains_rwsem);
@@ -1426,9 +1456,19 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 	if (rc)
 		goto out_unlock;
 
+	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
+			       !pages->cache_flush_required;
+
+	if (cache_flush_required)
+		pages->cache_flush_required = true;
+
 	while (!pfn_reader_done(&pfns)) {
 		done_first_end_index = pfns.batch_end_index;
 		done_all_end_index = pfns.batch_start_index;
+
+		if (cache_flush_required)
+			iopt_cache_flush_pfn_batch(&pfns.batch);
+
 		xa_for_each(&area->iopt->domains, index, domain) {
 			rc = batch_to_domain(&pfns.batch, domain, area,
 					     pfns.batch_start_index);
-- 
2.17.1


