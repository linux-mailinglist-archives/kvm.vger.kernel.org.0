Return-Path: <kvm+bounces-14539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B888A3084
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CBE61F21C9C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4283F127E27;
	Fri, 12 Apr 2024 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfkz7xIk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A242F12FF65
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931745; cv=none; b=M6AjrcqUgetILxqhFS970hha1PhCU//Ts0/LRlowc6KtmmI/1wKLOwIVeS1fH4qiKAzRcTcLBsQYLMX85mvRwKjNMeIxfjUDbSdrym2G2LbZVvJr7+oRAr3lNp2ZqFBJOHi3fb3crLFa2DjY+P6++gzXoM8G2o/v1ozrqWkCsAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931745; c=relaxed/simple;
	bh=99Ad/+yB0OLA/IFjrcV/K2AG1wlKX5wXTkCVbDGwEvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuvrcMQwUgwc9TMQZ7iPhAaAEQVOhDueE591FsnspPWbjIXifgaBa29T7BmMVaVANfHiLw8xNMb7iFIvgukdKfFuR/9MCEVunbNrQ3doS4dM3sPNCu0rifc0TVwBJg9+PMLMt6rAeQzZI/7ZoNlvx17rHXOVanN2mUeTxlai/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vfkz7xIk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cpOMdQ9TDo+1riOUh5uN9s2I/iRoxNLS/xmy35f9UDw=;
	b=Vfkz7xIkpILo+aaW5XHJg2zeAciKPYYgO+nfYMzodgh10uWOcJWVww/1itu8kW81f4x9AW
	2Ep3lO3XhsXGuN+z4QFgjT+C+gcWTGI+CFDNrMafmlj+YHzUft0r8huT1q/rMmcqkVsibR
	p7xQP2ltkPQrXHGX7sGbty6C2vr+UMs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-j_llUqp9NHy2U8GxkF2GCg-1; Fri,
 12 Apr 2024 10:22:13 -0400
X-MC-Unique: j_llUqp9NHy2U8GxkF2GCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 262EF3C00086;
	Fri, 12 Apr 2024 14:22:13 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA370400D276;
	Fri, 12 Apr 2024 14:22:09 +0000 (UTC)
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
Subject: [PATCH v2 08/10] s390/uv: convert uv_convert_owned_from_secure() to uv_convert_from_secure_(folio|pte)()
Date: Fri, 12 Apr 2024 16:21:18 +0200
Message-ID: <20240412142120.220087-9-david@redhat.com>
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

Let's do the same as we did for uv_destroy_(folio|pte)() and
have the following variants:

(1) uv_convert_from_secure(): "low level" helper that operates on paddr
and does not mess with folios.

(2) uv_convert_from_secure_folio(): Consumes a folio to which we hold a
reference.

(3) uv_convert_from_secure_pte(): Consumes a PTE that holds a reference
through the mapping.

Unfortunately we need uv_convert_from_secure_pte(), because pfn_folio()
and friends are not available in pgtable.h.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/pgtable.h |  6 +++---
 arch/s390/include/asm/uv.h      |  4 ++--
 arch/s390/kernel/uv.c           | 18 +++++++++++++-----
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 97e040617c29..5ffc4828c25a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1149,7 +1149,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_from_secure_pte(res);
 	return res;
 }
 
@@ -1167,7 +1167,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
 	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_from_secure_pte(res);
 	return res;
 }
 
@@ -1206,7 +1206,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	 * if this is not a mm teardown, the slower export is used as
 	 * fallback instead.
 	 */
-	uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	uv_convert_from_secure_pte(res);
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index a1bef30066ef..0679445cac0b 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -485,7 +485,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_folio(struct folio *folio);
 int uv_destroy_pte(pte_t pte);
-int uv_convert_owned_from_secure(unsigned long paddr);
+int uv_convert_from_secure_pte(pte_t pte);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
 void setup_uv(void);
@@ -508,7 +508,7 @@ static inline int uv_destroy_pte(pte_t pte)
 	return 0;
 }
 
-static inline int uv_convert_owned_from_secure(unsigned long paddr)
+static inline int uv_convert_from_secure_pte(pte_t pte)
 {
 	return 0;
 }
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 61c1ce51c883..b456066d72da 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -178,11 +178,10 @@ static int uv_convert_from_secure(unsigned long paddr)
 }
 
 /*
- * The caller must already hold a reference to the page
+ * The caller must already hold a reference to the folio.
  */
-int uv_convert_owned_from_secure(unsigned long paddr)
+static int uv_convert_from_secure_folio(struct folio *folio)
 {
-	struct folio *folio = phys_to_folio(paddr);
 	int rc;
 
 	/* See gmap_make_secure(): large folios cannot be secure */
@@ -190,13 +189,22 @@ int uv_convert_owned_from_secure(unsigned long paddr)
 		return 0;
 
 	folio_get(folio);
-	rc = uv_convert_from_secure(paddr);
+	rc = uv_convert_from_secure(folio_to_phys(folio));
 	if (!rc)
 		clear_bit(PG_arch_1, &folio->flags);
 	folio_put(folio);
 	return rc;
 }
 
+/*
+ * The present PTE still indirectly holds a folio reference through the mapping.
+ */
+int uv_convert_from_secure_pte(pte_t pte)
+{
+	VM_WARN_ON(!pte_present(pte));
+	return uv_convert_from_secure_folio(pfn_folio(pte_pfn(pte)));
+}
+
 /*
  * Calculate the expected ref_count for a folio that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
@@ -481,7 +489,7 @@ int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
 	 * we instead try to export the page.
 	 */
 	if (rc)
-		rc = uv_convert_owned_from_secure(page_to_phys(page));
+		rc = uv_convert_from_secure_folio(folio);
 	folio_put(folio);
 out:
 	mmap_read_unlock(gmap->mm);
-- 
2.44.0


