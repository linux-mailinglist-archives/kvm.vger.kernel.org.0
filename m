Return-Path: <kvm+bounces-14535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C778A3076
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2A85284C5E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FE012C46A;
	Fri, 12 Apr 2024 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGnbV8R4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968312C475
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931729; cv=none; b=aMrPtWiR1/5220wraU2uEEhqCEg/Zy5nVLEj/Pez1zfCmAmQuEsBvQmQG+YvaHATpfzgHN376K6QdbsFh2b1lix7klR7/TRzbTzJdgqGfVkpwo/wFmiNBliOzZiznO2dZbiVhby+hDWyUTHK9fd+PgfP3eLF5lgcfp4hEGqGA6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931729; c=relaxed/simple;
	bh=NYIsyAKTyDfXL1OBDe7AcstW++1OcYH4oDp5YUoFpOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9RnCUb/n8HU/jCV/20202PtuiKif0UQ0wQqLmSN/8Wv9u8w1oOUMY7Tg5wvcQ8y8EAXmSrSfRgGytx0a6p+2Gh7FYSgB81yu3PvrDHVZ/j8K6gphCwDQc0sZrBIkdGTGKtPTlUpLT3iwaFa8rixkpDoaaqCtgz5763v0tzCyak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VGnbV8R4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DKeQI6yMk4WrSKY3ISFL+eRa3o1/6tdDeS8ur8VVlk=;
	b=VGnbV8R4bzcuJconFWHliQT/x3u4f2hqwb8ueb++ioHpRYJq2yPuTFg2TtTYUqF12trz+0
	BHPqmEUDT9J9xCNP7U0+8mkYTQE4u2WZzUqc4zFce3z0OOLczRrvvjWVsLgY+SCalirYi5
	CC6MSISwjxKyeyv7QllwCpZsDkd3GWw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-BlVDikT7O-igiyZtvUI5pw-1; Fri, 12 Apr 2024 10:22:00 -0400
X-MC-Unique: BlVDikT7O-igiyZtvUI5pw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 391BF802E4D;
	Fri, 12 Apr 2024 14:21:59 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 867AB40C6CC0;
	Fri, 12 Apr 2024 14:21:56 +0000 (UTC)
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
Subject: [PATCH v2 04/10] s390/uv: convert PG_arch_1 users to only work on small folios
Date: Fri, 12 Apr 2024 16:21:14 +0200
Message-ID: <20240412142120.220087-5-david@redhat.com>
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

Now that make_folio_secure() may only set PG_arch_1 for small folios,
let's convert relevant remaining UV code to only work on (small) folios
and simply reject large folios early. This way, we'll never end up
touching PG_arch_1 on tail pages of a large folio in UV code.

The folio_get()/folio_put() for functions that are documented to already
hold a folio reference look weird; likely they are required to make
concurrent gmap_make_secure() back off because the caller might only hold
an implicit reference due to the page mapping. So leave that alone for now.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h |  2 ++
 arch/s390/kernel/uv.c        | 41 ++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 9381879f7ecf..b64384872c0f 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -214,7 +214,9 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
 #define pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
 
 #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
+#define phys_to_folio(phys)	page_folio(phys_to_page(phys))
 #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
+#define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
 
 static inline void *pfn_to_virt(unsigned long pfn)
 {
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 3c6d86e3e828..914dcec27329 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -135,14 +135,18 @@ static int uv_destroy_page(unsigned long paddr)
  */
 int uv_destroy_owned_page(unsigned long paddr)
 {
-	struct page *page = phys_to_page(paddr);
+	struct folio *folio = phys_to_folio(paddr);
 	int rc;
 
-	get_page(page);
+	/* See gmap_make_secure(): large folios cannot be secure */
+	if (unlikely(folio_test_large(folio)))
+		return 0;
+
+	folio_get(folio);
 	rc = uv_destroy_page(paddr);
 	if (!rc)
-		clear_bit(PG_arch_1, &page->flags);
-	put_page(page);
+		clear_bit(PG_arch_1, &folio->flags);
+	folio_put(folio);
 	return rc;
 }
 
@@ -170,14 +174,18 @@ int uv_convert_from_secure(unsigned long paddr)
  */
 int uv_convert_owned_from_secure(unsigned long paddr)
 {
-	struct page *page = phys_to_page(paddr);
+	struct folio *folio = phys_to_folio(paddr);
 	int rc;
 
-	get_page(page);
+	/* See gmap_make_secure(): large folios cannot be secure */
+	if (unlikely(folio_test_large(folio)))
+		return 0;
+
+	folio_get(folio);
 	rc = uv_convert_from_secure(paddr);
 	if (!rc)
-		clear_bit(PG_arch_1, &page->flags);
-	put_page(page);
+		clear_bit(PG_arch_1, &folio->flags);
+	folio_put(folio);
 	return rc;
 }
 
@@ -479,33 +487,34 @@ EXPORT_SYMBOL_GPL(gmap_destroy_page);
  */
 int arch_make_page_accessible(struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	int rc = 0;
 
-	/* Hugepage cannot be protected, so nothing to do */
-	if (PageHuge(page))
+	/* See gmap_make_secure(): large folios cannot be secure */
+	if (unlikely(folio_test_large(folio)))
 		return 0;
 
 	/*
 	 * PG_arch_1 is used in 3 places:
 	 * 1. for kernel page tables during early boot
 	 * 2. for storage keys of huge pages and KVM
-	 * 3. As an indication that this page might be secure. This can
+	 * 3. As an indication that this small folio might be secure. This can
 	 *    overindicate, e.g. we set the bit before calling
 	 *    convert_to_secure.
 	 * As secure pages are never huge, all 3 variants can co-exists.
 	 */
-	if (!test_bit(PG_arch_1, &page->flags))
+	if (!test_bit(PG_arch_1, &folio->flags))
 		return 0;
 
-	rc = uv_pin_shared(page_to_phys(page));
+	rc = uv_pin_shared(folio_to_phys(folio));
 	if (!rc) {
-		clear_bit(PG_arch_1, &page->flags);
+		clear_bit(PG_arch_1, &folio->flags);
 		return 0;
 	}
 
-	rc = uv_convert_from_secure(page_to_phys(page));
+	rc = uv_convert_from_secure(folio_to_phys(folio));
 	if (!rc) {
-		clear_bit(PG_arch_1, &page->flags);
+		clear_bit(PG_arch_1, &folio->flags);
 		return 0;
 	}
 
-- 
2.44.0


