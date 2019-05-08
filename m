Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A113217BCD
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfEHOop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:57649 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfEHOom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656527"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 4C59F79C; Wed,  8 May 2019 17:44:29 +0300 (EEST)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 13/62] x86/mm: Add hooks to allocate and free encrypted pages
Date:   Wed,  8 May 2019 17:43:33 +0300
Message-Id: <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hook up into page allocator to allocate and free encrypted page
properly.

The hardware/CPU does not enforce coherency between mappings of the same
physical page with different KeyIDs or encryption keys.
We are responsible for cache management.

Flush cache on allocating encrypted page and on returning the page to
the free pool.

prep_encrypted_page() also takes care about zeroing the page. We have to
do this after KeyID is set for the page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h | 17 +++++++++++++
 arch/x86/mm/mktme.c          | 49 ++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index b5afa31b4526..6e604126f0bc 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -40,6 +40,23 @@ static inline int vma_keyid(struct vm_area_struct *vma)
 	return __vma_keyid(vma);
 }
 
+#define prep_encrypted_page prep_encrypted_page
+void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero);
+static inline void prep_encrypted_page(struct page *page, int order,
+		int keyid, bool zero)
+{
+	if (keyid)
+		__prep_encrypted_page(page, order, keyid, zero);
+}
+
+#define HAVE_ARCH_FREE_PAGE
+void free_encrypted_page(struct page *page, int order);
+static inline void arch_free_page(struct page *page, int order)
+{
+	if (page_keyid(page))
+		free_encrypted_page(page, order);
+}
+
 #else
 #define mktme_keyid_mask	((phys_addr_t)0)
 #define mktme_nr_keyids		0
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index d4a1a9e9b1c0..43489c098e60 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/mktme.h>
 
 /* Mask to extract KeyID from physical address. */
@@ -37,3 +38,51 @@ int __vma_keyid(struct vm_area_struct *vma)
 	pgprotval_t prot = pgprot_val(vma->vm_page_prot);
 	return (prot & mktme_keyid_mask) >> mktme_keyid_shift;
 }
+
+/* Prepare page to be used for encryption. Called from page allocator. */
+void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
+{
+	int i;
+
+	/*
+	 * The hardware/CPU does not enforce coherency between mappings
+	 * of the same physical page with different KeyIDs or
+	 * encryption keys. We are responsible for cache management.
+	 */
+	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
+
+	for (i = 0; i < (1 << order); i++) {
+		/* All pages coming out of the allocator should have KeyID 0 */
+		WARN_ON_ONCE(lookup_page_ext(page)->keyid);
+		lookup_page_ext(page)->keyid = keyid;
+
+		/* Clear the page after the KeyID is set. */
+		if (zero)
+			clear_highpage(page);
+
+		page++;
+	}
+}
+
+/*
+ * Handles freeing of encrypted page.
+ * Called from page allocator on freeing encrypted page.
+ */
+void free_encrypted_page(struct page *page, int order)
+{
+	int i;
+
+	/*
+	 * The hardware/CPU does not enforce coherency between mappings
+	 * of the same physical page with different KeyIDs or
+	 * encryption keys. We are responsible for cache management.
+	 */
+	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
+
+	for (i = 0; i < (1 << order); i++) {
+		/* Check if the page has reasonable KeyID */
+		WARN_ON_ONCE(lookup_page_ext(page)->keyid > mktme_nr_keyids);
+		lookup_page_ext(page)->keyid = 0;
+		page++;
+	}
+}
-- 
2.20.1

