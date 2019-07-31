Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B1C7C5B2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbfGaPIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44798 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388562AbfGaPI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so65978169edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BL5Bv5lW/jYayEJoRe2+9QezMkCC+60ESskc5jI43rc=;
        b=Z+QZrz8RxaQVkEmqQR+P3He1RAcsz276GYydPQCrBvVFzTQKhJYu7NE41afsSGcW6+
         PEkJHs8N+UZO3AYfKlsxwVJLTOvBwiOb7PnAjByNuwdd5U2faK6XX8qM7PxvuCxO/mbu
         tGAo18iJgYPJ1Ot5DSRbXJIlTHuucTq2ZxCKM1dP5WZHTSE1FnneQRwt/g0J7LAxwo9y
         1kEtDf3Gtz6f8i1Dcl7z5jwv2Di5k2T62pCpUzzd1Hc8x6HKFWlkGzFRwJd9NLtmsaB8
         eZcrNUzOtJQwWsRlLRsolI/HegBB7F8KhoBR5T1awdNiOE/MGBOV2CCucAo20gDECZFx
         G0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BL5Bv5lW/jYayEJoRe2+9QezMkCC+60ESskc5jI43rc=;
        b=DiqUuJORnXV5wTxbcryPZl6uks5jlyuHQ08soyCqlBWIyKn9GKIHkzVPAcGTpiTj0d
         XhrKoHVK8pR1azIrk8jNmfkjo3I+3WxRn3fC4O9e43YGynNT3N6FMFvhjwm/zOpT/t0s
         pLGXKrLrbOTGPe66aTdOMKZc7h1oM2UXYQq2W/x0zkq9cGu4rNGMYUxQQy4V8IJwVYKi
         xuEJ0Kqa9kKjjFnZ0O83jRMrAhsg2TZYmivMSKvhvaeNHzti1OfNY8mNfjfoYG1mnwan
         KRiPqXyDINFFoba86o9owNe3YdrQHlKz7HQgnNF/c/KfKqHBZi57EqDYsQXQAqB79lb3
         GECw==
X-Gm-Message-State: APjAAAVh37Uaq317GI3wqClYmR2+WRSBEbsVreuSVqzuirCzXTsab2bH
        XcQ8WBkywsp7khS3arOyDqw=
X-Google-Smtp-Source: APXvYqznZSrsxmfkB4pexMYFvT9i/MDUnejlA2skN/Nit1TPuevFqcmrEwStP937D+YpXbOTCbclHw==
X-Received: by 2002:a17:906:604c:: with SMTP id p12mr94494193ejj.26.1564585706687;
        Wed, 31 Jul 2019 08:08:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t16sm8546953ejr.83.2019.07.31.08.08.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 5011C101C44; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 14/59] x86/mm: Add hooks to allocate and free encrypted pages
Date:   Wed, 31 Jul 2019 18:07:28 +0300
Message-Id: <20190731150813.26289-15-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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

The patch relies on page_address() to return virtual address of the page
mapping with the current KeyID. It will be implemented later in the
patchset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h | 17 ++++++++
 arch/x86/mm/mktme.c          | 83 ++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index 52b115b30a42..a61b45fca4b1 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -43,6 +43,23 @@ static inline int vma_keyid(struct vm_area_struct *vma)
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
 #define mktme_keyid_mask()	((phys_addr_t)0)
 #define mktme_nr_keyids()	0
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index d02867212e33..8015e7822c9b 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <asm/mktme.h>
 
 /* Mask to extract KeyID from physical address. */
@@ -55,3 +56,85 @@ int __vma_keyid(struct vm_area_struct *vma)
 	pgprotval_t prot = pgprot_val(vma->vm_page_prot);
 	return (prot & mktme_keyid_mask()) >> mktme_keyid_shift();
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
+	 *
+	 * Flush cache lines with KeyID-0. page_address() returns virtual
+	 * address of the page mapping with the current (zero) KeyID.
+	 */
+	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
+
+	for (i = 0; i < (1 << order); i++) {
+		/* All pages coming out of the allocator should have KeyID 0 */
+		WARN_ON_ONCE(lookup_page_ext(page)->keyid);
+
+		/*
+		 * Change KeyID. From now on page_address() will return address
+		 * of the page mapping with the new KeyID.
+		 *
+		 * We don't need barrier() before the KeyID change because
+		 * clflush_cache_range() above stops compiler from reordring
+		 * past the point with mb().
+		 *
+		 * And we don't need a barrier() after the assignment because
+		 * any future reference of KeyID (i.e. from page_address())
+		 * will create address dependency and compiler is not allow to
+		 * mess with this.
+		 */
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
+	 *
+	 * Flush cache lines with non-0 KeyID. page_address() returns virtual
+	 * address of the page mapping with the current (non-zero) KeyID.
+	 */
+	clflush_cache_range(page_address(page), PAGE_SIZE * (1UL << order));
+
+	for (i = 0; i < (1 << order); i++) {
+		/* Check if the page has reasonable KeyID */
+		WARN_ON_ONCE(!lookup_page_ext(page)->keyid);
+		WARN_ON_ONCE(lookup_page_ext(page)->keyid > mktme_nr_keyids());
+
+		/*
+		 * Switch the page back to zero KeyID.
+		 *
+		 * We don't need barrier() before the KeyID change because
+		 * clflush_cache_range() above stops compiler from reordring
+		 * past the point with mb().
+		 *
+		 * And we don't need a barrier() after the assignment because
+		 * any future reference of KeyID (i.e. from page_address())
+		 * will create address dependency and compiler is not allow to
+		 * mess with this.
+		 */
+		lookup_page_ext(page)->keyid = 0;
+		page++;
+	}
+}
-- 
2.21.0

