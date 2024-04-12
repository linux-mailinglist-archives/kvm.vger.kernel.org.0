Return-Path: <kvm+bounces-14538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E02F8A3080
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 057F91F239EC
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6507812FB38;
	Fri, 12 Apr 2024 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMdhIxsY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2063712F5B1
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931741; cv=none; b=ozJ5MUyg5oWtJHwbf/TG8FXyqGENUnONVr6C+VRHy5Uc2GSP3hFXeZmbe44VSup4WnJ4uhsgsWgZX2VFifYVfFF8HyEQyScImEJmWyCxnra2tf0TKXkJcpt6+Mlu3ZE9yansVMN92gjRkRGsInHGvID/KDC8V6lwQNmD/gqeUcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931741; c=relaxed/simple;
	bh=IOUaMgAMDyPKIRLMCkvfgNrlkwlLkCurHBnDB1JP31U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0y1IyHFUpJsYep9Uv2nSKF+nXNTJRA1y487Z8cQ7Nof2UeqHqfczKFxnGrX59chlCCcTYeWDV+BcRvVRsD6+4dqxplILQ6URHs8yiVXns1C7mTScoXMyRaPbAbeagULl3bdZH4lzSTEXv1yzNY9XyxcAcu1At2YgjS+s7nFgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMdhIxsY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppsViCrPayPuYElY5iEdpfo5QgbpE7OrtZfdnZgX7ms=;
	b=aMdhIxsY4Ys+7UBaLpTjR2bWJIpRVNeptptgkmUvCSa9SL8FIZcFKdRtG6AxLgNS8nkhOj
	5nGQDDnPAN3e3ikzMDSGejkLRwXr6QMMyYKVZFGBRX5Q89o3e1Hu6OCGITRbn+JV5kcOfD
	9p+Aky/MuXgX3L/k5voHG3tr3BISJEI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-mGdE6oLKP3WmzI2aFwwpWg-1; Fri, 12 Apr 2024 10:22:17 -0400
X-MC-Unique: mGdE6oLKP3WmzI2aFwwpWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D99188ACA2;
	Fri, 12 Apr 2024 14:22:17 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 85A9E40C6DAE;
	Fri, 12 Apr 2024 14:22:13 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 09/10] s390/uv: implement HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
Date: Fri, 12 Apr 2024 16:21:19 +0200
Message-ID: <20240412142120.220087-10-david@redhat.com>
In-Reply-To: <20240412142120.220087-1-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Let's also implement HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE, so we can convert
arch_make_page_accessible() to be a simple wrapper around
arch_make_folio_accessible(). Unfortuantely, we cannot do that in the
header.

There are only two arch_make_page_accessible() calls remaining in gup.c.
We can now drop HAVE_ARCH_MAKE_PAGE_ACCESSIBLE completely form core-MM.
We'll handle that separately, once the s390x part landed.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h |  3 +++
 arch/s390/kernel/uv.c        | 18 +++++++++++-------
 arch/s390/mm/fault.c         | 14 ++++++++------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index b64384872c0f..03bbc782e286 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -162,6 +162,7 @@ static inline int page_reset_referenced(unsigned long addr)
 #define _PAGE_ACC_BITS		0xf0	/* HW access control bits	*/
 
 struct page;
+struct folio;
 void arch_free_page(struct page *page, int order);
 void arch_alloc_page(struct page *page, int order);
 
@@ -174,6 +175,8 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define HAVE_ARCH_ALLOC_PAGE
 
 #if IS_ENABLED(CONFIG_PGSTE)
+int arch_make_folio_accessible(struct folio *folio);
+#define HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
 int arch_make_page_accessible(struct page *page);
 #define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 #endif
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index b456066d72da..fa62fa0e369f 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -498,14 +498,13 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
 EXPORT_SYMBOL_GPL(gmap_destroy_page);
 
 /*
- * To be called with the page locked or with an extra reference! This will
- * prevent gmap_make_secure from touching the page concurrently. Having 2
- * parallel make_page_accessible is fine, as the UV calls will become a
- * no-op if the page is already exported.
+ * To be called with the folio locked or with an extra reference! This will
+ * prevent gmap_make_secure from touching the folio concurrently. Having 2
+ * parallel arch_make_folio_accessible is fine, as the UV calls will become a
+ * no-op if the folio is already exported.
  */
-int arch_make_page_accessible(struct page *page)
+int arch_make_folio_accessible(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	int rc = 0;
 
 	/* See gmap_make_secure(): large folios cannot be secure */
@@ -537,8 +536,13 @@ int arch_make_page_accessible(struct page *page)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(arch_make_page_accessible);
+EXPORT_SYMBOL_GPL(arch_make_folio_accessible);
 
+int arch_make_page_accessible(struct page *page)
+{
+	return arch_make_folio_accessible(page_folio(page));
+}
+EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index c421dd44ffbe..a1ba58460593 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -491,6 +491,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	unsigned long addr = get_fault_address(regs);
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
+	struct folio *folio;
 	struct page *page;
 	struct gmap *gmap;
 	int rc;
@@ -538,17 +539,18 @@ void do_secure_storage_access(struct pt_regs *regs)
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
+		folio = phys_to_folio(addr);
+		if (unlikely(!folio_try_get(folio)))
 			break;
-		rc = arch_make_page_accessible(page);
-		put_page(page);
+		rc = arch_make_folio_accessible(folio);
+		folio_put(folio);
 		if (rc)
 			BUG();
 		break;
-- 
2.44.0


