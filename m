Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE02517C19
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEHOrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:57670 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbfEHOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:51 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2019 07:44:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 474571101; Wed,  8 May 2019 17:44:31 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 51/62] iommu/vt-d: Support MKTME in DMA remapping
Date:   Wed,  8 May 2019 17:44:11 +0300
Message-Id: <20190508144422.13171-52-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

When MKTME is enabled, keyid is stored in the high order bits of physical
address. For DMA transactions targeting encrypted physical memory, keyid
must be included in the IOVA to physical address translation.

This patch appends page keyid when setting up the IOMMU PTEs. On the
reverse direction, keyid bits are cleared in the physical address lookup.
Mapping functions of both DMA ops and IOMMU ops are covered.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 29 +++++++++++++++++++++++++++--
 include/linux/intel-iommu.h |  9 ++++++++-
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 28cb713d728c..1ff7e87e25f1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -862,6 +862,28 @@ static void free_context_table(struct intel_iommu *iommu)
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
+static inline void set_pte_mktme_keyid(unsigned long phys_pfn,
+		phys_addr_t *pteval)
+{
+	unsigned long keyid;
+
+	if (!pfn_valid(phys_pfn))
+		return;
+
+	keyid = page_keyid(pfn_to_page(phys_pfn));
+
+#ifdef CONFIG_X86_INTEL_MKTME
+	/*
+	 * When MKTME is enabled, set keyid in PTE such that DMA
+	 * remapping will include keyid in the translation from IOVA
+	 * to physical address. This applies to both user and kernel
+	 * allocated DMA memory.
+	 */
+	*pteval &= ~mktme_keyid_mask;
+	*pteval |= keyid << mktme_keyid_shift;
+#endif
+}
+
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				      unsigned long pfn, int *target_level)
 {
@@ -888,7 +910,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			break;
 
 		if (!dma_pte_present(pte)) {
-			uint64_t pteval;
+			phys_addr_t pteval;
 
 			tmp_page = alloc_pgtable_page(domain->nid);
 
@@ -896,7 +918,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				return NULL;
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
-			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			pteval = (virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			set_pte_mktme_keyid(virt_to_dma_pfn(tmp_page), &pteval);
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
@@ -2289,6 +2312,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			}
 
 		}
+		set_pte_mktme_keyid(phys_pfn, &pteval);
+
 		/* We don't need lock here, nobody else
 		 * touches the iova range
 		 */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index fa364de9db18..48a377a2b896 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -34,6 +34,8 @@
 
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
+#include <asm/page.h>
+
 
 /*
  * VT-d hardware uses 4KiB page size regardless of host page size.
@@ -603,7 +605,12 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK;
+	u64 addr = pte->val;
+	addr &= VTD_PAGE_MASK;
+#ifdef CONFIG_X86_INTEL_MKTME
+	addr &= ~mktme_keyid_mask;
+#endif
+	return addr;
 #else
 	/* Must have a full atomic 64-bit read */
 	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
-- 
2.20.1

