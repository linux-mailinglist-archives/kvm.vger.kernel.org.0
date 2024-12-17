Return-Path: <kvm+bounces-33934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD089F4BD0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E909C188A18A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718DC1F9A9C;
	Tue, 17 Dec 2024 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQLaGQxS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7161F4E20;
	Tue, 17 Dec 2024 13:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440519; cv=none; b=VnoUCZZmwCDSbtKB7Nx2eYNkm6Rw9wWtJtr5O+3VzrkYCMla8bco3OVihJQX80i2Cq2TVyIrXZiuEiJKtRs+qV3l4oK+76QuA7vEsJaWvNqnB6ab/W4FpQ/9pPYh8WUv3fn15KGOWfm9ot/c8CS9XW2fTcevg2oNL7COWUv4I7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440519; c=relaxed/simple;
	bh=4U8OAdjLoa135LlF1quSDl0hGi9037MUkClj3CmMSko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8cdQJV9aLpMUi8xfZGHx7wnlTIhZKxxR0drDjRfqW1iyPQY6lXfmr2DH+ot1kchDR/JhC+OcKY3lT5CXTgHyBfo/nhX+M6A/onp6xQv5NJ5ESoj3nl7RJqDAU8RoN1ZP5wQJRBFXlpRdvRJ9EEROZaSZ9P9Wn/ZZr8C8H8+etQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQLaGQxS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6E5C4CED3;
	Tue, 17 Dec 2024 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734440519;
	bh=4U8OAdjLoa135LlF1quSDl0hGi9037MUkClj3CmMSko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQLaGQxSJJQ2WghREDHbtFQtI9QIm41ygcqLm2OKUJcDxB/Jc4SYcLlNryVx5HVhR
	 kMXPLcj0G9iQfpFdRmj/36BU/xsh/BqDAkL9VNHDx09KOM2SDO2kkG3VDxWwiy4BUm
	 OFO285LFsxdQHR/MML3tvO5QB3+vig34drtSzzDCfRCYLyNJsewQVfRNPtUBj9UT46
	 JslUNMuz/jabpCwftz6ja6emA6pjhKHAjsVWiPvOkKZXgU5FEm5hcOlr5e0ihWtivO
	 KPbHri1v/etWBw/iIb/IHrzW71V8yreEm01Qo/eGvpQh5iNdVFIvIQh8by4NQxqpbY
	 l1mOohs29P5wg==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 10/17] mm/hmm: let users to tag specific PFN with DMA mapped bit
Date: Tue, 17 Dec 2024 15:00:28 +0200
Message-ID: <536d27ff1bbf2bd53f3340909ccae109ded7af83.1734436840.git.leon@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1734436840.git.leon@kernel.org>
References: <cover.1734436840.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new sticky flag (HMM_PFN_DMA_MAPPED), which isn't overwritten
by HMM range fault. Such flag allows users to tag specific PFNs with
information if this specific PFN was already DMA mapped.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/hmm.h | 17 +++++++++++++++
 mm/hmm.c            | 51 ++++++++++++++++++++++++++++-----------------
 2 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 126a36571667..a1ddbedc19c0 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,8 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
+ *                      to mark that page is already DMA mapped
  *
  * On input:
  * 0                 - Return the current state of the page, do not fault it.
@@ -36,6 +38,13 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+
+	/*
+	 * Sticky flags, carried from input to output,
+	 * don't forget to update HMM_PFN_INOUT_FLAGS
+	 */
+	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
+
 	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 8),
 
 	/* Input flags */
@@ -57,6 +66,14 @@ static inline struct page *hmm_pfn_to_page(unsigned long hmm_pfn)
 	return pfn_to_page(hmm_pfn & ~HMM_PFN_FLAGS);
 }
 
+/*
+ * hmm_pfn_to_phys() - return physical address pointed to by a device entry
+ */
+static inline phys_addr_t hmm_pfn_to_phys(unsigned long hmm_pfn)
+{
+	return __pfn_to_phys(hmm_pfn & ~HMM_PFN_FLAGS);
+}
+
 /*
  * hmm_pfn_to_map_order() - return the CPU mapping size order
  *
diff --git a/mm/hmm.c b/mm/hmm.c
index 7e0229ae4a5a..da5743f6d854 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -39,13 +39,20 @@ enum {
 	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
 };
 
+enum {
+	/* These flags are carried from input-to-output */
+	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED,
+};
+
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 			 struct hmm_range *range, unsigned long cpu_flags)
 {
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
 
-	for (; addr < end; addr += PAGE_SIZE, i++)
-		range->hmm_pfns[i] = cpu_flags;
+	for (; addr < end; addr += PAGE_SIZE, i++) {
+		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		range->hmm_pfns[i] |= cpu_flags;
+	}
 	return 0;
 }
 
@@ -202,8 +209,10 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_vma_fault(addr, end, required_fault, walk);
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++)
-		hmm_pfns[i] = pfn | cpu_flags;
+	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+		hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		hmm_pfns[i] |= pfn | cpu_flags;
+	}
 	return 0;
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -230,14 +239,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	unsigned long cpu_flags;
 	pte_t pte = ptep_get(ptep);
 	uint64_t pfn_req_flags = *hmm_pfn;
+	uint64_t new_pfn_flags = 0;
 
 	if (pte_none_mostly(pte)) {
 		required_fault =
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
 		if (required_fault)
 			goto fault;
-		*hmm_pfn = 0;
-		return 0;
+		goto out;
 	}
 
 	if (!pte_present(pte)) {
@@ -253,16 +262,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
-			*hmm_pfn = swp_offset_pfn(entry) | cpu_flags;
-			return 0;
+			new_pfn_flags = swp_offset_pfn(entry) | cpu_flags;
+			goto out;
 		}
 
 		required_fault =
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
-		if (!required_fault) {
-			*hmm_pfn = 0;
-			return 0;
-		}
+		if (!required_fault)
+			goto out;
 
 		if (!non_swap_entry(entry))
 			goto fault;
@@ -304,11 +311,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			pte_unmap(ptep);
 			return -EFAULT;
 		}
-		*hmm_pfn = HMM_PFN_ERROR;
-		return 0;
+		new_pfn_flags = HMM_PFN_ERROR;
+		goto out;
 	}
 
-	*hmm_pfn = pte_pfn(pte) | cpu_flags;
+	new_pfn_flags = pte_pfn(pte) | cpu_flags;
+out:
+	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
 fault:
@@ -448,8 +457,10 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 		}
 
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-		for (i = 0; i < npages; ++i, ++pfn)
-			hmm_pfns[i] = pfn | cpu_flags;
+		for (i = 0; i < npages; ++i, ++pfn) {
+			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+			hmm_pfns[i] |= pfn | cpu_flags;
+		}
 		goto out_unlock;
 	}
 
@@ -507,8 +518,10 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
-	for (; addr < end; addr += PAGE_SIZE, i++, pfn++)
-		range->hmm_pfns[i] = pfn | cpu_flags;
+	for (; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+		range->hmm_pfns[i] |= pfn | cpu_flags;
+	}
 
 	spin_unlock(ptl);
 	return 0;
-- 
2.47.0


