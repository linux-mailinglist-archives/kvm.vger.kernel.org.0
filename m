Return-Path: <kvm+bounces-29779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8359B1E70
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:27:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CEB2B21D76
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079081917F6;
	Sun, 27 Oct 2024 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCkLbrpn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178631684AC;
	Sun, 27 Oct 2024 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038949; cv=none; b=KIzE/8gZi8Jd15ThWJ+xItWnpjuKVTZM+ZWpefiTP7K0bpCdo41nnnb+BKJP2BURhyI0YsHLulSFV6fyp3+q6ahWqNvk13e0KQQZWcPObo+3GuXUaWr2ouGJmBpeeLzNkJYQxaKLA7M0ck+OgLBKsSaNrH9QeKNNfMHoejNbe+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038949; c=relaxed/simple;
	bh=LyGbooKE736rWckmyvuR6Y2aUxxUKiIhQ25bI43LeHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTnNwAdpMpFuyAf2SIG2nyz0PArQJK4GvrKwJljfOKXff4GiH2oURWzL+50kzzqbK3vDUbv8lHryE4NBd0Ng/h6tAI28qIPyw8SVHzJaFwtaEYfbARQY2doZ3hKU7WVXuBpxt3fx3yJg+cc1qivD62psabV3GQS5QAXsn4wRNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCkLbrpn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBC4C4CEC3;
	Sun, 27 Oct 2024 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038948;
	bh=LyGbooKE736rWckmyvuR6Y2aUxxUKiIhQ25bI43LeHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCkLbrpnlImhB9B2714xCMDVyAnzWG7MsfR2tObG6bSGDFDz4Bf4CI0mqKt+rhuYq
	 oH9+qokY2xOMGvGOGy85p6vNn6z9dqDdwZ9MAzJ/Y7n8iQv0e0nn5FsdeSoMXGJcFj
	 B+Zi8xW0UVh0uK/OidgiacDE2NCdMWAyryo2eQ61nfECpDk59aRsqWtCbWH4zdhzfH
	 EE5mWIwZYs2U2XkGvGVAKEq7GkstM4Q+7cbJ824WG2VF+/8pl7vlytQS/XVuNbujES
	 urNdKuuovQ1egFVlgv0jTDSmxVbzWG5blHyNDBWJJkFVst1jo9u8sMvdVfv9ThBNkJ
	 kD4ta2u0CCROg==
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
	linux-mm@kvack.org
Subject: [PATCH 10/18] mm/hmm: let users to tag specific PFN with DMA mapped bit
Date: Sun, 27 Oct 2024 16:21:10 +0200
Message-ID: <6c79710ccc5d9fec36172fea13498e30132a0600.1730037276.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730037276.git.leon@kernel.org>
References: <cover.1730037276.git.leon@kernel.org>
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
 include/linux/hmm.h | 14 ++++++++++++++
 mm/hmm.c            | 34 +++++++++++++++++++++-------------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 126a36571667..5dd655f6766b 100644
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
@@ -36,6 +38,10 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+
+	/* Sticky flag, carried from Input to Output */
+	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
+
 	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 8),
 
 	/* Input flags */
@@ -57,6 +63,14 @@ static inline struct page *hmm_pfn_to_page(unsigned long hmm_pfn)
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
index 7e0229ae4a5a..2a0c34d7cb2b 100644
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
2.46.2


