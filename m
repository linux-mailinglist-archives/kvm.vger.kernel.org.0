Return-Path: <kvm+bounces-13581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F8F898C50
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 395381C2339C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47ACB1304B7;
	Thu,  4 Apr 2024 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dmHMxhro"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B8712FF89
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248649; cv=none; b=RMRNqhKHGy+lD2B00DFPxZd5M2V1wSW/b8d/WgYaAOC93rWz+hBkwkaoVVxV4dz3cDdbIFG0zj1dUtsUJSd1hCd1Z7RMC2OqnZo81HcCoVqnIShpgo6avejwiufFWhlEbV/O9ibuubRbU9/jA5ptE9KDsASDEvsPv3OzwbYcxso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248649; c=relaxed/simple;
	bh=gWXAtNL1jekuOMsqBd4bLsfbAVqcNuhBIDRPoGpv2CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKY6MiQ6D10zlaXdALHJXxI4zYiapeW0rqTasOtmUR0u+OrH+c1Z4IW9GPtRT4vj5o//BhApERmpazzwaHHdq0dw7rIe2TWbkJZ6Q+zhNxvHYLLB36kmK3SM6r+FG+LX6M1BnGHDUvXsRf/V37ZxLRO1foQZxS9nGyz4UCb/ddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dmHMxhro; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712248646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gj+Px0USJVRdve0zHf2NII4M17BtyxK6NDqebl44nSI=;
	b=dmHMxhroa3EfssSaAdICuuaJN0CY/mRan/uEV1gbkKoJQI3C55QxJFDZ/1rRVLal5qQN+i
	lB+8YiGeA48PLDfxqpVHTC9WnEyeIQD/h89iYWG/rXJlzL8MqcPdc2leKgIKHLZ+90j/OW
	XLO0wdt3nalRBvbrGugQR+rNKSLXhJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-OWEUhaqDPT6N364ahGpEZQ-1; Thu, 04 Apr 2024 12:37:22 -0400
X-MC-Unique: OWEUhaqDPT6N364ahGpEZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7141101A531;
	Thu,  4 Apr 2024 16:37:21 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.101])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8272E3C21;
	Thu,  4 Apr 2024 16:37:17 +0000 (UTC)
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
Subject: [PATCH v1 3/5] s390/uv: convert PG_arch_1 users to only work on small folios
Date: Thu,  4 Apr 2024 18:36:40 +0200
Message-ID: <20240404163642.1125529-4-david@redhat.com>
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

Now that make_folio_secure() may only set PG_arch_1 for small folios,
let's convert relevant remaining UV code to only work on (small) folios
and simply reject large folios early. This way, we'll never end up
touching PG_arch_1 on tail pages of a large folio in UV code.

The folio_get()/folio_put() for functions that are documented to already
hold a folio reference look weird and it should probably be removed.
Similarly, uv_destroy_owned_page() and uv_convert_owned_from_secure()
should really consume a folio reference instead. But these are cleanups for
another day.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h |  1 +
 arch/s390/kernel/uv.c        | 39 +++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 54d015bcd8e3..b64384872c0f 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -214,6 +214,7 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
 #define pfn_to_phys(pfn)	((pfn) << PAGE_SHIFT)
 
 #define phys_to_page(phys)	pfn_to_page(phys_to_pfn(phys))
+#define phys_to_folio(phys)	page_folio(phys_to_page(phys))
 #define page_to_phys(page)	pfn_to_phys(page_to_pfn(page))
 #define folio_to_phys(page)	pfn_to_phys(folio_pfn(folio))
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index adcbd4b13035..9c0113b26735 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -134,14 +134,17 @@ static int uv_destroy_page(unsigned long paddr)
  */
 int uv_destroy_owned_page(unsigned long paddr)
 {
-	struct page *page = phys_to_page(paddr);
+	struct folio *folio = phys_to_folio(paddr);
 	int rc;
 
-	get_page(page);
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
 
@@ -169,14 +172,17 @@ int uv_convert_from_secure(unsigned long paddr)
  */
 int uv_convert_owned_from_secure(unsigned long paddr)
 {
-	struct page *page = phys_to_page(paddr);
+	struct folio *folio = phys_to_folio(paddr);
 	int rc;
 
-	get_page(page);
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
 
@@ -457,33 +463,34 @@ EXPORT_SYMBOL_GPL(gmap_destroy_page);
  */
 int arch_make_page_accessible(struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	int rc = 0;
 
-	/* Hugepage cannot be protected, so nothing to do */
-	if (PageHuge(page))
+	/* Large folios cannot be protected, so nothing to do */
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


