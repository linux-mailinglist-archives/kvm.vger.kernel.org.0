Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DDE7C628
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGaPVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:05 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41679 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729675AbfGaPTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:19:50 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so66012380eds.8
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hC2uwgXxojO8zk/Rcrr6mceJUJW70ppjchwtq4ruRCg=;
        b=0XV6P/gt+Sg4f27WCDZfMiz3yUD8gmqmXbpUkqw2qeKte/64P4ld/yFj9TtHQsxMva
         Sbd6SFVGZn15wA2StFIL5OKo0viglmdPGCy3S9nsnoLjxmIaz4pZPHVNhzJMBFiEItzK
         GGFxIZHfCywnX+w1VFB8az1H4FFBZ0dEp86xAnm0F7Jfw3TX8bJ2UwJ4MOp6xtqistdS
         ci1LlbxLwNn2UPtS72pBvzNbUsUQSbVvUvjpSYYoWOORZ9uWxZOyAGcJabNrh3zrp7Ty
         xsBZdp44F7iwElj0Db5RusDWd82dGLl/6L2fkZUDkulyOvXwh+aBdW95+eM1LPwVFqZZ
         pCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hC2uwgXxojO8zk/Rcrr6mceJUJW70ppjchwtq4ruRCg=;
        b=BMpY1ZQV17zvIoTy0qFOEeEqo1nVW1v9bzj2bZfVW2HLBDOSmBFvC5Ubozh9gs/x+r
         OxYFGD2q2D3DQltFF9/vRulXmkLlIGc79YikOXxxwRrCHFM6dFuPaDtIO/uPbus7h1fP
         ruovnYDz984AocOE3lfjafdahYuNVxna9joPrdLEzJVlDKp0tlQ4IZkFZnEQ9gkov/02
         e+/0JzBlRs/xnHXxgv1VGR7PkBJi/giv145fxMUiByWYgJqUAe8+BNabyLKcF7ZBxlqG
         LJO3Lxd93IEo1IPBvdWZEYz5x5qMLcYGL+B3elhuTgIerSEEyDy6W+Qw5Wf8EI18FI2P
         Z5cg==
X-Gm-Message-State: APjAAAWqP2oiyMCRivet/6skHhXFxerFBNXbq/nNq1jZXX3wEmDE6RP7
        j/V5YF5wArlD2Enr89ICcHI=
X-Google-Smtp-Source: APXvYqz5v5Tv2OUvZrbCEWIRRAB8vEgVkF30Jl6xeuTpZr0HJyo73/wTXum206aQYtxXoB+6KiDpDg==
X-Received: by 2002:a17:906:9447:: with SMTP id z7mr29540487ejx.165.1564586039736;
        Wed, 31 Jul 2019 08:13:59 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g11sm12443173ejm.86.2019.07.31.08.13.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 488B9104606; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 48/59] iommu/vt-d: Support MKTME in DMA remapping
Date:   Wed, 31 Jul 2019 18:08:02 +0300
Message-Id: <20190731150813.26289-49-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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
index ac4172c02244..32d22872656b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -867,6 +867,28 @@ static void free_context_table(struct intel_iommu *iommu)
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
+	*pteval &= ~mktme_keyid_mask();
+	*pteval |= keyid << mktme_keyid_shift();
+#endif
+}
+
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				      unsigned long pfn, int *target_level)
 {
@@ -893,7 +915,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			break;
 
 		if (!dma_pte_present(pte)) {
-			uint64_t pteval;
+			phys_addr_t pteval;
 
 			tmp_page = alloc_pgtable_page(domain->nid);
 
@@ -901,7 +923,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				return NULL;
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
-			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			pteval = (virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			set_pte_mktme_keyid(virt_to_dma_pfn(tmp_page), &pteval);
 			if (cmpxchg64(&pte->val, 0ULL, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
 				free_pgtable_page(tmp_page);
@@ -2214,6 +2237,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 			}
 
 		}
+		set_pte_mktme_keyid(phys_pfn, &pteval);
+
 		/* We don't need lock here, nobody else
 		 * touches the iova range
 		 */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index f2ae8a006ff8..8fbb9353d5a6 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -22,6 +22,8 @@
 
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
+#include <asm/page.h>
+
 
 /*
  * VT-d hardware uses 4KiB page size regardless of host page size.
@@ -608,7 +610,12 @@ static inline void dma_clear_pte(struct dma_pte *pte)
 static inline u64 dma_pte_addr(struct dma_pte *pte)
 {
 #ifdef CONFIG_64BIT
-	return pte->val & VTD_PAGE_MASK;
+	u64 addr = pte->val;
+	addr &= VTD_PAGE_MASK;
+#ifdef CONFIG_X86_INTEL_MKTME
+	addr &= ~mktme_keyid_mask();
+#endif
+	return addr;
 #else
 	/* Must have a full atomic 64-bit read */
 	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
-- 
2.21.0

