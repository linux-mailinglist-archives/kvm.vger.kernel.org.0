Return-Path: <kvm+bounces-14540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D15B8A3087
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A49C41F21745
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4CFB1311A7;
	Fri, 12 Apr 2024 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0cJPCxI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485D131186
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931749; cv=none; b=q/bjjtrKlZTNj5ryYstoi4mQD7j8x8oBtHzZDszGF/KwyBGlqftUIC0KYtbeXbHCthTA/gZ/ZbTkbZHujE2VVXSmC4DM+nXqcM1c8CbIP68P0mSqNnGFyNdmolOVVGIWQ9jK9ZiLKwXFAZ3xp6URY84QdueDSzhr6Emoasw/2YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931749; c=relaxed/simple;
	bh=u4jveH2EIzl1xqJEs2ZcFZUQ2YbXX3eXQ3sMb6x71k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbNS5ht0Dk36IuFkORExsxTDAK7zullshKvudikWY9wzZ5zxpwrxPl10kc0n3WtDecDTPcg8lF6iXDo2wVTu8exX5P0/YWdrz6eB4rio52vHpYDYRA28AwMe0h7qfia1lCN6I94hS34pDtknAtsHKJbutYMVglAueZ7jrTptUAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0cJPCxI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWRmug5O+fgsfYD+sP/4mX7PdwrqikXbqWpiomCHNOQ=;
	b=N0cJPCxIWNClkkrgGjLQ/eYIIxDPLR0j5FzvEfT/kV643KHooUuZDy8sF35mw0AkQV6Dc/
	rfKOLWZeWjX52pqx/idrHeGUnBZ4hPjbnt/sWyEJ7UgWyboWzJ4vwg4ovwcRBgGQS9yTR6
	p/IRqbapNTwt50cdWcTqlv8bcQDlU2s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-rBEa3xiWN8m0NTwYBymYPQ-1; Fri, 12 Apr 2024 10:22:21 -0400
X-MC-Unique: rBEa3xiWN8m0NTwYBymYPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3F1C80021A;
	Fri, 12 Apr 2024 14:22:20 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 841B140C6CBF;
	Fri, 12 Apr 2024 14:22:17 +0000 (UTC)
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
Subject: [PATCH v2 10/10] s390/hugetlb: convert PG_arch_1 code to work on folio->flags
Date: Fri, 12 Apr 2024 16:21:20 +0200
Message-ID: <20240412142120.220087-11-david@redhat.com>
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

Let's make it clearer that we are always working on folio flags and
never page flags of tail pages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c        | 4 ++--
 arch/s390/mm/hugetlbpage.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 0351cb139df4..9eea05cd93b7 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2648,7 +2648,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 {
 	pmd_t *pmd = (pmd_t *)pte;
 	unsigned long start, end;
-	struct page *page = pmd_page(*pmd);
+	struct folio *folio = page_folio(pmd_page(*pmd));
 
 	/*
 	 * The write check makes sure we do not set a key on shared
@@ -2663,7 +2663,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 	start = pmd_val(*pmd) & HPAGE_MASK;
 	end = start + HPAGE_SIZE - 1;
 	__storage_key_init_range(start, end);
-	set_bit(PG_arch_1, &page->flags);
+	set_bit(PG_arch_1, &folio->flags);
 	cond_resched();
 	return 0;
 }
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index c2e8242bd15d..a32047315f9a 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -121,7 +121,7 @@ static inline pte_t __rste_to_pte(unsigned long rste)
 
 static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned long size, paddr;
 
 	if (!mm_uses_skeys(mm) ||
@@ -129,16 +129,16 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 		return;
 
 	if ((rste & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3) {
-		page = pud_page(__pud(rste));
+		folio = page_folio(pud_page(__pud(rste)));
 		size = PUD_SIZE;
 		paddr = rste & PUD_MASK;
 	} else {
-		page = pmd_page(__pmd(rste));
+		folio = page_folio(pmd_page(__pmd(rste)));
 		size = PMD_SIZE;
 		paddr = rste & PMD_MASK;
 	}
 
-	if (!test_and_set_bit(PG_arch_1, &page->flags))
+	if (!test_and_set_bit(PG_arch_1, &folio->flags))
 		__storage_key_init_range(paddr, paddr + size - 1);
 }
 
-- 
2.44.0


