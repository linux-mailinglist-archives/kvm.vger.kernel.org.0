Return-Path: <kvm+bounces-23066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F1A946121
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673C71F21721
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB411A34B7;
	Fri,  2 Aug 2024 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhTudOSc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5921A34AA
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722614214; cv=none; b=Qhf08HwBsRtZD/2GxkgxSJVEh3lGZWoTCHBZYrtnFAp5fj+k9lVS1ERb2H16umxP5k62vr7KhSVE7ex9E0ipSqgLweIkhPCMl7M66I2V49CFeYbzPQ3xbqhUWp/VROyJFQQ3dNoeF9KC8ZpNukn+ShIHW/jKHKmCZcZsdhiCPxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722614214; c=relaxed/simple;
	bh=B9QpgUZqHBSgII4REwP9lD0/53JlrVZdILJpl6GeaCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBv7747G1gASF+PgVUKa3Mm/YOSIr1mU60ZSsWl887xCx1SDevEjTYe/B3Zmdzb/oEQOqbn3YxQFn5vgwB9N9YGo9J4Bz2O/4M+ZDpn3wBEHSDD+OAwyVL+ojw/HcFak4tmpAKGbr/SiPbEbvnQ7zJtyjdPgXp/3ejGwrbuqfcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhTudOSc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722614211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XisBOloUEP3qStGU5kEnvOleMULjhsDMvLI1Qb38ywI=;
	b=HhTudOSczoDCzNBQBnIpia1CQZtRqjMaQQvctcz8uWfl66KLPLUyn1ol+K/k191SmfJMPC
	dNrmVHXMqvC+ubNoXK0PsnTG0RTa8SC64T5iDnWwQ16YMJtictZtzwmkevfTyKqs+6yRnt
	Hl2lreAjSkmNVDvvDQGeRkcDoFO/0aE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-7fMx_I3IMvS20EQpewJYGQ-1; Fri,
 02 Aug 2024 11:56:48 -0400
X-MC-Unique: 7fMx_I3IMvS20EQpewJYGQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 833C51955D4D;
	Fri,  2 Aug 2024 15:56:45 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.192.113])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B30F4300018D;
	Fri,  2 Aug 2024 15:56:39 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH v1 11/11] mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk
Date: Fri,  2 Aug 2024 17:55:24 +0200
Message-ID: <20240802155524.517137-12-david@redhat.com>
In-Reply-To: <20240802155524.517137-1-david@redhat.com>
References: <20240802155524.517137-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Let's simplify by reusing folio_walk. Keep the existing behavior by
handling migration entries and zeropages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/ksm.c | 63 ++++++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 47 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 0f5b2bba4ef0..8e53666bc7b0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -608,47 +608,6 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
-			struct mm_walk *walk)
-{
-	struct page *page = NULL;
-	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int ret;
-
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
-		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		page = vm_normal_page(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
-
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			page = pfn_swap_entry_to_page(entry);
-	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (page && PageKsm(page)) || is_ksm_zero_pte(ptent);
-	pte_unmap_unlock(pte, ptl);
-	return ret;
-}
-
-static const struct mm_walk_ops break_ksm_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
-static const struct mm_walk_ops break_ksm_lock_vma_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_WRLOCK,
-};
-
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -665,16 +624,26 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-	const struct mm_walk_ops *ops = lock_vma ?
-				&break_ksm_lock_vma_ops : &break_ksm_ops;
+
+	if (lock_vma)
+		vma_start_write(vma);
 
 	do {
-		int ksm_page;
+		bool ksm_page = false;
+		struct folio_walk fw;
+		struct folio *folio;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
-			return ksm_page;
+		folio = folio_walk_start(&fw, vma, addr,
+					 FW_MIGRATION | FW_ZEROPAGE);
+		if (folio) {
+			/* Small folio implies FW_LEVEL_PTE. */
+			if (!folio_test_large(folio) &&
+			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
+				ksm_page = true;
+			folio_walk_end(&fw, vma);
+		}
+
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-- 
2.45.2


