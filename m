Return-Path: <kvm+bounces-17041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6718C0463
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 20:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98A1DB23529
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 18:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334FB130AD3;
	Wed,  8 May 2024 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqolmFLy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA8C130A64
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715193020; cv=none; b=AhR/gbK/HIruFg8DS9I3jQ6G7IxEcAfQyI8gWOGgAKKqSPJJUuZKhOCQfyy0rlMVx/jzpgfLX7JEyrZ1TOJHvMx0834NaThwiQQf5NovvkUM51eY4k0QbsHdxAKaH22MZ/z8RT270UJFHtq9/TFrveyKBj2lvJ5GP5zHk3mruqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715193020; c=relaxed/simple;
	bh=9cMxw+0FUPFscli9SRIp15T5tvpY7n1JYHRqVPxhLQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHdNdsGjM/aQUvLGpL2Gis0ZOcVOFFnYFg+VHqR+S01YIOrWda7evxKiCLyYZGX2UjouGoLsWlKvjdK9f3K61seQQk2ZfITSgGJSNMcm2gxtMJA06Y9IpfDxtES6gDHZbji4nSP8HFzYYZ2hzj1zMp+DYaG5HCX6U1+Mn+3kQh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqolmFLy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715193018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYWABkGxV8MYRWHh8nd3DHUSmm6awTOHiljU31Nr1kM=;
	b=aqolmFLyiCKur/L8AxnNt7vvV6YIHoBrTVtSLIpEZqiLVpTbxnz4hICnBwvcbSBJexjrtt
	XKstOWPl0Shpieuq4lE6LuejB43JdxmOFPTp62p+fFRbPMd1C+8VNvPywqVQE4yAcuE/hK
	AHqMUQKh/afMPXJ3NCT4DNOl0Xz+5/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-C9cFn8fZOBah3jYfTssNEg-1; Wed, 08 May 2024 14:30:13 -0400
X-MC-Unique: C9cFn8fZOBah3jYfTssNEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD905800262;
	Wed,  8 May 2024 18:30:12 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5545C1000DB4;
	Wed,  8 May 2024 18:30:09 +0000 (UTC)
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
Subject: [PATCH v3 04/10] s390/uv: convert PG_arch_1 users to only work on small folios
Date: Wed,  8 May 2024 20:29:49 +0200
Message-ID: <20240508182955.358628-5-david@redhat.com>
In-Reply-To: <20240508182955.358628-1-david@redhat.com>
References: <20240508182955.358628-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Now that make_folio_secure() may only set PG_arch_1 for small folios,
let's convert relevant remaining UV code to only work on (small) folios
and simply reject large folios early. This way, we'll never end up
touching PG_arch_1 on tail pages of a large folio in UV code.

The folio_get()/folio_put() for functions that are documented to already
hold a folio reference look weird; likely they are required to make
concurrent gmap_make_secure() back off because the caller might only hold
an implicit reference due to the page mapping. So leave that alone for now.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h |  2 ++
 arch/s390/kernel/uv.c        | 41 ++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 224ff9d433ea..ecbf4b626f46 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -247,7 +247,9 @@ static inline unsigned long __phys_addr(unsigned long x, bool is_31bit)
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
2.45.0


