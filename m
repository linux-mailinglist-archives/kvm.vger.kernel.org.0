Return-Path: <kvm+bounces-20828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3D092393E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A426F1C215F8
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14004158A13;
	Tue,  2 Jul 2024 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DERWykst"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81415250C;
	Tue,  2 Jul 2024 09:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911417; cv=none; b=tFEDaRbXU/0QeO8bstGEptPJNr/y/auX+ucm4cGjC0trxCctIXGaRxMelRSVg5Zmwk0ICIc3//uMnt4jQWNBeLdFz3hZfGA72rVnibCSKuLUkg9IFJZrXHLWpATrYFp5L9VCCL5hhyfvNfmFEIDBYouDB17m6iTJ8jCgT8gRrXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911417; c=relaxed/simple;
	bh=r8LbBOjlbH4F69KVmFsNaHjJ/rODIFYYIWRpcAsJOVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ts0E8LPx3qQz8m8dY+KfJlFDZrmGjISCethTVYlQtEKe4WCWJ9fC1l58SLOo1U6iEWUPRnHE/MwB5asfpUbRAnWKC+k9b5OieM/8f8EFAcKMh5L9KZOBwsITaymu4hGvFPkr7jOg5H/Ny8XkWfmDVcZlrsZu8ZwJb0XYEEt70sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DERWykst; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E09C4AF0E;
	Tue,  2 Jul 2024 09:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911416;
	bh=r8LbBOjlbH4F69KVmFsNaHjJ/rODIFYYIWRpcAsJOVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DERWykstv7XxGRlK5d+9zV0EQM0MK52hTvvioFtFjlLgY6y7WByKUa78ayxSb4kv4
	 I+xUVII03CJetjfBvTMv9CMMhQJfzVzLz89kaGypwXqqSFHhbw4Gb2EbFJGDnfX17l
	 0aC4Byhh+gWLSP7xqntoErbx/0yPnHiKuF5CB/Xs9/iSM9GN7ebAkO6YOTDfK+Sr8y
	 dJtkIzyXzi0gzX+IoPLVGBHI3F2b9pwZ+KO31UXjhbL9I3Iuq75SeGIsrKaVl1FT3q
	 sHBmNAh3u7+dpLJB9+kZkDVxWvxbuHf4tfrlHP2fR8bQCt2MPqKJJkSIF05sdFYODC
	 r+/wFzkIKdacg==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 05/18] mm/hmm: let users to tag specific PFN with DMA mapped bit
Date: Tue,  2 Jul 2024 12:09:35 +0300
Message-ID: <769b6266d5e8638322f25550dd01a85515bf9d08.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new sticky flag (HMM_PFN_DMA_MAPPED), which isn't overwritten
by HMM range fault. Such flag allows users to tag specific PFNs with information
if this specific PFN was already DMA mapped.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/hmm.h |  4 ++++
 mm/hmm.c            | 34 +++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 126a36571667..2999697db83a 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,8 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
+ * 			to mark that page is already DMA mapped
  *
  * On input:
  * 0                 - Return the current state of the page, do not fault it.
@@ -36,6 +38,8 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+	/* Sticky lag, carried from Input to Output */
+	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
 	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 8),
 
 	/* Input flags */
diff --git a/mm/hmm.c b/mm/hmm.c
index 93aebd9cc130..03aeb9929d9e 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -44,8 +44,10 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 {
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
 
-	for (; addr < end; addr += PAGE_SIZE, i++)
-		range->hmm_pfns[i] = cpu_flags;
+	for (; addr < end; addr += PAGE_SIZE, i++) {
+		range->hmm_pfns[i] &= HMM_PFN_DMA_MAPPED;
+		range->hmm_pfns[i] |= cpu_flags;
+	}
 	return 0;
 }
 
@@ -202,8 +204,10 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_vma_fault(addr, end, required_fault, walk);
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++)
-		hmm_pfns[i] = pfn | cpu_flags;
+	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+		hmm_pfns[i] &= HMM_PFN_DMA_MAPPED;
+		hmm_pfns[i] |= pfn | cpu_flags;
+	}
 	return 0;
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -236,7 +240,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
 		if (required_fault)
 			goto fault;
-		*hmm_pfn = 0;
+		*hmm_pfn = *hmm_pfn & HMM_PFN_DMA_MAPPED;
 		return 0;
 	}
 
@@ -253,14 +257,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
-			*hmm_pfn = swp_offset_pfn(entry) | cpu_flags;
+			*hmm_pfn = (*hmm_pfn & HMM_PFN_DMA_MAPPED) | swp_offset_pfn(entry) | cpu_flags;
 			return 0;
 		}
 
 		required_fault =
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
 		if (!required_fault) {
-			*hmm_pfn = 0;
+			*hmm_pfn = *hmm_pfn & HMM_PFN_DMA_MAPPED;
 			return 0;
 		}
 
@@ -304,11 +308,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 			pte_unmap(ptep);
 			return -EFAULT;
 		}
-		*hmm_pfn = HMM_PFN_ERROR;
+		*hmm_pfn = (*hmm_pfn & HMM_PFN_DMA_MAPPED) | HMM_PFN_ERROR;
 		return 0;
 	}
 
-	*hmm_pfn = pte_pfn(pte) | cpu_flags;
+	*hmm_pfn = (*hmm_pfn & HMM_PFN_DMA_MAPPED) | pte_pfn(pte) | cpu_flags;
 	return 0;
 
 fault:
@@ -448,8 +452,10 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 		}
 
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-		for (i = 0; i < npages; ++i, ++pfn)
-			hmm_pfns[i] = pfn | cpu_flags;
+		for (i = 0; i < npages; ++i, ++pfn) {
+			hmm_pfns[i] &= HMM_PFN_DMA_MAPPED;
+			hmm_pfns[i] |= pfn | cpu_flags;
+		}
 		goto out_unlock;
 	}
 
@@ -507,8 +513,10 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
-	for (; addr < end; addr += PAGE_SIZE, i++, pfn++)
-		range->hmm_pfns[i] = pfn | cpu_flags;
+	for (; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+		range->hmm_pfns[i] &= HMM_PFN_DMA_MAPPED;
+		range->hmm_pfns[i] |= pfn | cpu_flags;
+	}
 
 	spin_unlock(ptl);
 	return 0;
-- 
2.45.2


