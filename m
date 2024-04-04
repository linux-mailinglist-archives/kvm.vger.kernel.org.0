Return-Path: <kvm+bounces-13580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB4C898C4B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0B7D28A51C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55D612F59F;
	Thu,  4 Apr 2024 16:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LvChVScC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AB712E1C7
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248645; cv=none; b=hIppDpCF+Ux1ziASb0FecCno/saIOBBQsxz7z6hVmwcd6NG6/N2pKE9BG4lyOMVpKCxj7SCgNwJtQiuwjvO4gqQ2kL7k6oJH7pplg0DnGzVKXKanUE/QiE47ksAs8fu5wjNRsTLv2JMT87HKdUb8awGBBhMIanEwodZnfnDFBDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248645; c=relaxed/simple;
	bh=3ds6qOcJAMp9Bcy8VHb/SlJBggTO4aUFH1a88oPcEWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGl0tIpFsH/+RjfynIOusjC9Dr+rndQ+0Tk7vvyZX/LTudlFBIXe8fr+RFioTSu4tCXlGrCeXc70hEzrzwSPtlSULZmGFGznPrAD9BoCqMu3E4vQkxm5SqcGJIWrNpnKeNsjVrmTpCKynlA69fh5rF8Dlziw7kGSuzWyMyg3NSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LvChVScC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712248641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YqMhB+a0hiEG+4rkQzSAJvqocE9H8po4mJ+mzkWYDBs=;
	b=LvChVScCfS4gEyhgMw+Zn0n8Tpk8AeSQzlFzcmo1828iLGpCJBDYjJ7pU7EM4rwuv8yye1
	q2DEN7VBmfqxCkocVGOe6g6Z96ycOpjDQ90QBcZ3ZAkGjiSl5GQC6ojkPBtRscx+76ZGpY
	HZFZ8GgnUrB6kAoHZQG5aD0kdHMHGeM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-eqwsHOp0NrySS1NYBlY5wA-1; Thu,
 04 Apr 2024 12:37:18 -0400
X-MC-Unique: eqwsHOp0NrySS1NYBlY5wA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2581E28116C5;
	Thu,  4 Apr 2024 16:37:17 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.101])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E09A5827;
	Thu,  4 Apr 2024 16:37:13 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v1 2/5] s390/uv: convert gmap_make_secure() to work on folios
Date: Thu,  4 Apr 2024 18:36:39 +0200
Message-ID: <20240404163642.1125529-3-david@redhat.com>
In-Reply-To: <20240404163642.1125529-1-david@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

We have various goals that require gmap_make_secure() to only work on
folios. We want to limit the use of page_mapcount() to the places where it
is absolutely necessary, we want to avoid using page flags of tail
pages, and we want to remove page_has_private().

So, let's convert gmap_make_secure() to folios. While s390x makes sure
to never have PMD-mapped THP in processes that use KVM -- by remapping
them using PTEs in thp_split_walk_pmd_entry()->split_huge_pmd() -- we might
still find PTE-mapped THPs and could end up working on tail pages of
such large folios for now.

To handle that cleanly, let's simply split any PTE-mapped large folio,
so we can be sure that we are always working with small folios and never
on tail pages.

There is no real change: splitting will similarly fail on unexpected folio
references, just like it would already when we try to freeze the folio
refcount.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h |  1 +
 arch/s390/kernel/uv.c        | 66 ++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 9381879f7ecf..54d015bcd8e3 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -215,6 +215,7 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
 
 #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
 #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
+#define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
 
 static inline void *pfn_to_virt(unsigned long pfn)
 {
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 7401838b960b..adcbd4b13035 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -181,36 +181,36 @@ int uv_convert_owned_from_secure(unsigned long paddr)
 }
 
 /*
- * Calculate the expected ref_count for a page that would otherwise have no
+ * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
  * the kernel, but with some slight modifications. We know that a secure
- * page can not be a huge page for example.
+ * folio can only be a small folio for example.
  */
-static int expected_page_refs(struct page *page)
+static int expected_folio_refs(struct folio *folio)
 {
 	int res;
 
-	res = page_mapcount(page);
-	if (PageSwapCache(page)) {
+	res = folio_mapcount(folio);
+	if (folio_test_swapcache(folio)) {
 		res++;
-	} else if (page_mapping(page)) {
+	} else if (folio_mapping(folio)) {
 		res++;
-		if (page_has_private(page))
+		if (folio_has_private(folio))
 			res++;
 	}
 	return res;
 }
 
-static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
+static int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 {
 	int expected, cc = 0;
 
-	if (PageWriteback(page))
+	if (folio_test_writeback(folio))
 		return -EAGAIN;
-	expected = expected_page_refs(page);
-	if (!page_ref_freeze(page, expected))
+	expected = expected_folio_refs(folio);
+	if (!folio_ref_freeze(folio, expected))
 		return -EBUSY;
-	set_bit(PG_arch_1, &page->flags);
+	set_bit(PG_arch_1, &folio->flags);
 	/*
 	 * If the UVC does not succeed or fail immediately, we don't want to
 	 * loop for long, or we might get stall notifications.
@@ -220,9 +220,9 @@ static int make_page_secure(struct page *page, struct uv_cb_header *uvcb)
 	 * -EAGAIN and we let the callers deal with it.
 	 */
 	cc = __uv_call(0, (u64)uvcb);
-	page_ref_unfreeze(page, expected);
+	folio_ref_unfreeze(folio, expected);
 	/*
-	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * Return -ENXIO if the folio was not mapped, -EINVAL for other errors.
 	 * If busy or partially completed, return -EAGAIN.
 	 */
 	if (cc == UVC_CC_OK)
@@ -277,7 +277,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	bool local_drain = false;
 	spinlock_t *ptelock;
 	unsigned long uaddr;
-	struct page *page;
+	struct folio *folio;
 	pte_t *ptep;
 	int rc;
 
@@ -306,33 +306,49 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	if (!ptep)
 		goto out;
 	if (pte_present(*ptep) && !(pte_val(*ptep) & _PAGE_INVALID) && pte_write(*ptep)) {
-		page = pte_page(*ptep);
+		folio = page_folio(pte_page(*ptep));
 		rc = -EAGAIN;
-		if (trylock_page(page)) {
+
+		/* We might get PTE-mapped large folios; split them first. */
+		if (folio_test_large(folio)) {
+			rc = -E2BIG;
+		} else if (folio_trylock(folio)) {
 			if (should_export_before_import(uvcb, gmap->mm))
-				uv_convert_from_secure(page_to_phys(page));
-			rc = make_page_secure(page, uvcb);
-			unlock_page(page);
+				uv_convert_from_secure(folio_to_phys(folio));
+			rc = make_folio_secure(folio, uvcb);
+			folio_unlock(folio);
 		}
 
 		/*
-		 * Once we drop the PTL, the page may get unmapped and
+		 * Once we drop the PTL, the folio may get unmapped and
 		 * freed immediately. We need a temporary reference.
 		 */
-		if (rc == -EAGAIN)
-			get_page(page);
+		if (rc == -EAGAIN || rc == -E2BIG)
+			folio_get(folio);
 	}
 	pte_unmap_unlock(ptep, ptelock);
 out:
 	mmap_read_unlock(gmap->mm);
 
+	if (rc == -E2BIG) {
+		/*
+		 * Splitting might fail with -EBUSY due to unexpected folio
+		 * references, just like make_folio_secure(). So handle it
+		 * ahead of time without the PTL being held.
+		 */
+		folio_lock(folio);
+		rc = split_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
 	if (rc == -EAGAIN) {
 		/*
 		 * If we are here because the UVC returned busy or partial
 		 * completion, this is just a useless check, but it is safe.
 		 */
-		wait_on_page_writeback(page);
-		put_page(page);
+		folio_wait_writeback(folio);
+		folio_put(folio);
 	} else if (rc == -EBUSY) {
 		/*
 		 * If we have tried a local drain and the page refcount
-- 
2.44.0


