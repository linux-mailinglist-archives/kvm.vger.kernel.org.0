Return-Path: <kvm+bounces-31294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8EE9C21EB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 888CF2821D2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465631990BA;
	Fri,  8 Nov 2024 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hWTmL9wU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E51957F8
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082848; cv=none; b=ts6GmODMjaWKS7ht91M05/6Hjt4gLeB0XTQzSFlGIkIKaeECpcCVpdocnHFxmQAKl4o8FSgU9Mhh7+zg/MkYWcW37ysX5pCI7rYXgSh9uaoG/cpt0hQvKf8zUBzCiG9fPf0Q8wF7kpExrWQGQYbQlivY0QyMH4LiTepAjF3o4bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082848; c=relaxed/simple;
	bh=d2QcORg6zlNcGw1o7eu5QsAzxTV0Ye4JUEEm3NCj+zQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vyz4Bj5sMX8R3/F/yrM0nmv6fwg+8imUuT0AW31GT3GQ8GyyvKpqcm0BE0bYkybmZ2Gx4IkJ54EbHtK3x91MjGDqEsiE9NnvYv8bno1mhLCwzPuDw1IdTDvA1975CG7U72mprxyRnc9OJ6O6gizE/5VI/ZICXqWF10kp58Y4IK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hWTmL9wU; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4314c6ca114so16520795e9.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082845; x=1731687645; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl2W4EtzrNZ1cJuCyrufhU34bgPSAtiEFnUtuMhqv3Y=;
        b=hWTmL9wU2tlqzazUqXr97Y/J42qsCJvTWBAfH8dJxJ02SBLT83hlzW4vcKD42JU5tP
         L5EQ4+g/mCGwOXUUCX2LgoB0E1UXv/lVfOoqmv3LkOUi+B8BvzPm05T/dGXqnZRTZrCL
         CA4TmNJRg7JsXUGY0pDbxkZiQ8vhMXiBSB5jOV8cMOTVgifkqwdkUz/Nsh3Q7icJ7v9/
         /qJO8S9LvLw1FMHFYWJEm9oxg2ZMezfwGJpXdQqaZE3pWdZVBHhDnnq8Hlm6ylttSDY6
         eszSCXH9NE+ZWglZG9pH7EDra0NtaC0evlYgIfpDHxHtscWfzbl7JLwYcLUiGRNgYr9J
         kzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082845; x=1731687645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl2W4EtzrNZ1cJuCyrufhU34bgPSAtiEFnUtuMhqv3Y=;
        b=Vig/Wv7NawfCMbvVB2Nc6bohF4IISKBwb74uxwNO5l0XVQWDAttLxrUI9BS6DQsYmQ
         751k4QMhvHRtaxvgyy//wqv/Of2b57KNDjZaU57mFnUFOb4X7fzo3CkdSqRKMAmshYu+
         Rat7cE05HQaSSRigQAO2OrN17FlXKqZ3KUnUGcNYmwGE0Jok9LoVs4xcITlAXBImmgnm
         j68tC58HROhz0f/2bvp4y69KQcwlm86E95hpzx4q0ueQ+RViuKkTqvohqwnyzIrZdjT3
         1D1UHFaM2wU/kOsPP4aKGP2Wl8XR3zcNvQtBoZlRmENQpABrtAN0hCBE6G+SKumjPUjo
         0hgw==
X-Gm-Message-State: AOJu0YyKCZdeJ53AgkB/HpTkhQs2yGAP7a4batHBy3hZohLUD70U6Cyb
	Ra58q0dP6wicULSXrW5vrBcdPxzNoWM5guL0Bj0yuUpcHhjgGT04sK2T+GXzZhnIoTfnEhkF+A=
	=
X-Google-Smtp-Source: AGHT+IGpbTMLKH3Z//v+mS0oCFNNN5K9KgwxRuxW+vMV7GiwPseAyRHtw03enomMXvu4TmjvVSMQK6Mc+A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4a21:b0:431:43e6:adfc with SMTP id
 5b1f17b1804b1-432b7527703mr24725e9.8.1731082844948; Fri, 08 Nov 2024 08:20:44
 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:31 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-2-tabba@google.com>
Subject: [RFC PATCH v1 01/10] mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: David Hildenbrand <david@redhat.com>

Let's make the function name match "folio_isolate_lru()", and add some
kernel doc.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/hugetlb.h |  4 ++--
 mm/gup.c                |  2 +-
 mm/hugetlb.c            | 23 ++++++++++++++++++++---
 mm/mempolicy.c          |  2 +-
 mm/migrate.c            |  6 +++---
 5 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ae4fe8615bb6..b0cf8dbfeb6a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -153,7 +153,7 @@ bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-bool isolate_hugetlb(struct folio *folio, struct list_head *list);
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -414,7 +414,7 @@ static inline pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 	return NULL;
 }
 
-static inline bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+static inline bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	return false;
 }
diff --git a/mm/gup.c b/mm/gup.c
index 28ae330ec4dd..40bbcffca865 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2301,7 +2301,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 
 		if (folio_test_hugetlb(folio)) {
-			isolate_hugetlb(folio, movable_folio_list);
+			folio_isolate_hugetlb(folio, movable_folio_list);
 			continue;
 		}
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cec4b121193f..e17bb2847572 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2868,7 +2868,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		isolated = isolate_hugetlb(old_folio, list);
+		isolated = folio_isolate_hugetlb(old_folio, list);
 		ret = isolated ? 0 : -EBUSY;
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
@@ -2953,7 +2953,7 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (folio_ref_count(folio) && isolate_hugetlb(folio, list))
+	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
 		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
@@ -7396,7 +7396,24 @@ __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
-bool isolate_hugetlb(struct folio *folio, struct list_head *list)
+/**
+ * folio_isolate_hugetlb: try to isolate an allocated hugetlb folio
+ * @folio: the folio to isolate
+ * @list: the list to add the folio to on success
+ *
+ * Isolate an allocated (refcount > 0) hugetlb folio, marking it as
+ * isolated/non-migratable, and moving it from the active list to the
+ * given list.
+ *
+ * Isolation will fail if @folio is not an allocated hugetlb folio, or if
+ * it is already isolated/non-migratable.
+ *
+ * On success, an additional folio reference is taken that must be dropped
+ * using folio_putback_active_hugetlb() to undo the isolation.
+ *
+ * Return: True if isolation worked, otherwise False.
+ */
+bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
 	bool ret = true;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index bb37cd1a51d8..41bdff67757c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -647,7 +647,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	 */
 	if ((flags & MPOL_MF_MOVE_ALL) ||
 	    (!folio_likely_mapped_shared(folio) && !hugetlb_pmd_shared(pte)))
-		if (!isolate_hugetlb(folio, qp->pagelist))
+		if (!folio_isolate_hugetlb(folio, qp->pagelist))
 			qp->nr_failed++;
 unlock:
 	spin_unlock(ptl);
diff --git a/mm/migrate.c b/mm/migrate.c
index dfb5eba3c522..55585b5f57ec 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -136,7 +136,7 @@ static void putback_movable_folio(struct folio *folio)
  *
  * This function shall be used whenever the isolated pageset has been
  * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
- * and isolate_hugetlb().
+ * and folio_isolate_hugetlb().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -177,7 +177,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 	bool isolated, lru;
 
 	if (folio_test_hugetlb(folio))
-		return isolate_hugetlb(folio, list);
+		return folio_isolate_hugetlb(folio, list);
 
 	lru = !__folio_test_movable(folio);
 	if (lru)
@@ -2208,7 +2208,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 		return -EACCES;
 
 	if (folio_test_hugetlb(folio)) {
-		if (isolate_hugetlb(folio, pagelist))
+		if (folio_isolate_hugetlb(folio, pagelist))
 			return 1;
 	} else if (folio_isolate_lru(folio)) {
 		list_add_tail(&folio->lru, pagelist);
-- 
2.47.0.277.g8800431eea-goog


