Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A145F7A24AD
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbjIOR3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbjIOR2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:28:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492BE1FF5;
        Fri, 15 Sep 2023 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yD9ktfId0rEPTuzY1QWVmcz2oEdRPlEREsQSBWfYTjA=; b=HX7V942nk7CHODHYQIA5tKfGxK
        cqfI5oqlGmQtDriP6IOkzJVbb4aQ9RVu+dirfylSh9gv/23r1hv78HpgIe6qdGAv9305ibm/CcUiP
        Cy7+3Mb8ROXAJWT218q0vG0yenqlmVqwmpfUAiqkSYIU1i8d6Kllw2K8786NlWuL+qk9sic5Q84av
        vz6Tnnu+8qAIDYA6k0PurN9+jHhz8oS1Zz1yC7jBuK7KTc9AMNsD0E2OnAnjGA97omR5Dc2FrvaBt
        NHsa8YRE+hRQ5/zTc7ddCWQ201F0sGDveVYd+7PeKe+MhfDy0+FawWBchRl7RY8NXygzu1sr3awRc
        EYMtiwEg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhCcI-00B2xv-MV; Fri, 15 Sep 2023 17:28:30 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 3/3] s390: Convert arch_make_page_accessible() to arch_make_folio_accessible()
Date:   Fri, 15 Sep 2023 18:28:28 +0100
Message-Id: <20230915172829.2632994-4-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230915172829.2632994-1-willy@infradead.org>
References: <20230915172829.2632994-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With all users now using arch_make_folio_accessible(), move the loop
over each page from common code into the only implementation.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/s390/include/asm/page.h |  5 ++--
 arch/s390/kernel/uv.c        | 46 +++++++++++++++++++++++-------------
 arch/s390/mm/fault.c         | 15 ++++++------
 include/linux/mm.h           | 20 ++--------------
 4 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index cfec0743314e..4f1b7107f0d9 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -162,6 +162,7 @@ static inline int page_reset_referenced(unsigned long addr)
 #define _PAGE_ACC_BITS		0xf0	/* HW access control bits	*/
 
 struct page;
+struct folio;
 void arch_free_page(struct page *page, int order);
 void arch_alloc_page(struct page *page, int order);
 void arch_set_page_dat(struct page *page, int order);
@@ -175,8 +176,8 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define HAVE_ARCH_ALLOC_PAGE
 
 #if IS_ENABLED(CONFIG_PGSTE)
-int arch_make_page_accessible(struct page *page);
-#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
+int arch_make_folio_accessible(struct folio *folio);
+#define arch_make_folio_accessible arch_make_folio_accessible
 #endif
 
 #define __PAGE_OFFSET		0x0UL
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index fc07bc39e698..dadf29469b46 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -426,46 +426,58 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
 EXPORT_SYMBOL_GPL(gmap_destroy_page);
 
 /*
- * To be called with the page locked or with an extra reference! This will
- * prevent gmap_make_secure from touching the page concurrently. Having 2
- * parallel make_page_accessible is fine, as the UV calls will become a
- * no-op if the page is already exported.
+ * To be called with the folio locked or with an extra reference! This will
+ * prevent gmap_make_secure from touching the folio concurrently. Having 2
+ * parallel make_folio_accessible is fine, as the UV calls will become a
+ * no-op if the folio is already exported.
+ *
+ * Returns 0 on success or negative errno.
  */
-int arch_make_page_accessible(struct page *page)
+int arch_make_folio_accessible(struct folio *folio)
 {
-	int rc = 0;
+	unsigned long i, nr = folio_nr_pages(folio);
+	unsigned long pfn = folio_pfn(folio);
+	int err = 0;
 
 	/* Hugepage cannot be protected, so nothing to do */
-	if (PageHuge(page))
+	if (folio_test_hugetlb(folio))
 		return 0;
 
 	/*
 	 * PG_arch_1 is used in 3 places:
 	 * 1. for kernel page tables during early boot
 	 * 2. for storage keys of huge pages and KVM
-	 * 3. As an indication that this page might be secure. This can
+	 * 3. As an indication that this folio might be secure. This can
 	 *    overindicate, e.g. we set the bit before calling
 	 *    convert_to_secure.
 	 * As secure pages are never huge, all 3 variants can co-exists.
 	 */
-	if (!test_bit(PG_arch_1, &page->flags))
+	if (!test_bit(PG_arch_1, &folio->flags))
 		return 0;
 
-	rc = uv_pin_shared(page_to_phys(page));
-	if (!rc) {
-		clear_bit(PG_arch_1, &page->flags);
+	for (i = 0; i < nr; i++) {
+		err = uv_pin_shared((pfn + i) * PAGE_SIZE);
+		if (err)
+			break;
+	}
+	if (!err) {
+		clear_bit(PG_arch_1, &folio->flags);
 		return 0;
 	}
 
-	rc = uv_convert_from_secure(page_to_phys(page));
-	if (!rc) {
-		clear_bit(PG_arch_1, &page->flags);
+	for (i = 0; i < nr; i++) {
+		err = uv_convert_from_secure((pfn + i) * PAGE_SIZE);
+		if (err)
+			break;
+	}
+	if (!err) {
+		clear_bit(PG_arch_1, &folio->flags);
 		return 0;
 	}
 
-	return rc;
+	return err;
 }
-EXPORT_SYMBOL_GPL(arch_make_page_accessible);
+EXPORT_SYMBOL_GPL(arch_make_folio_accessible);
 
 #endif
 
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index b678295931c3..ac707e5d58ab 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -588,6 +588,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct folio *folio;
 	struct gmap *gmap;
 	int rc;
 
@@ -643,17 +644,17 @@ void do_secure_storage_access(struct pt_regs *regs)
 			mmap_read_unlock(mm);
 			break;
 		}
-		if (arch_make_page_accessible(page))
+		folio = page_folio(page);
+		if (arch_make_folio_accessible(folio))
 			send_sig(SIGSEGV, current, 0);
-		put_page(page);
+		folio_put(folio);
 		mmap_read_unlock(mm);
 		break;
 	case KERNEL_FAULT:
-		page = phys_to_page(addr);
-		if (unlikely(!try_get_page(page)))
-			break;
-		rc = arch_make_page_accessible(page);
-		put_page(page);
+		folio = page_folio(phys_to_page(addr));
+		folio_get(folio);
+		rc = arch_make_folio_accessible(folio);
+		folio_put(folio);
 		if (rc)
 			BUG();
 		break;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf5d0b1b16f4..55d3e466d3cb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2139,26 +2139,10 @@ static inline int folio_estimated_sharers(struct folio *folio)
 	return page_mapcount(folio_page(folio, 0));
 }
 
-#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
-static inline int arch_make_page_accessible(struct page *page)
-{
-	return 0;
-}
-#endif
-
-#ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
+#ifndef arch_make_folio_accessible
 static inline int arch_make_folio_accessible(struct folio *folio)
 {
-	int ret;
-	long i, nr = folio_nr_pages(folio);
-
-	for (i = 0; i < nr; i++) {
-		ret = arch_make_page_accessible(folio_page(folio, i));
-		if (ret)
-			break;
-	}
-
-	return ret;
+	return 0;
 }
 #endif
 
-- 
2.40.1

