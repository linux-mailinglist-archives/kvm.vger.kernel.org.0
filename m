Return-Path: <kvm+bounces-22145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 682D493AA73
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22E73285264
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 01:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79CC73471;
	Wed, 24 Jul 2024 01:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QGjH9x5l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C7487B0
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 01:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783485; cv=none; b=ZLJDA/uURzQvGbAjUUYXq1uITta13YIIYUO31VKH/4yEAXLRcH0sfb8QwGq0/ZxXn95pgHrbE90c2YzW4/mdS/YyiQmPKGPsxmYFRawUDUHEIHlapuoxvLHEwNZKPWqO9haZVpfFeSmXUIirLHmUBOYnTtB+cQAfgP7cOfhMSj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783485; c=relaxed/simple;
	bh=KfembDxKLcDx5Z4cJBECO+YU7Im+hzD8J6/VWlQTPAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kuynxpdwejkBiI6aGSOMRyK1Udzmd1XJxFbNnkgDUhU7rA0hmwKYqAh9bYfL4XioftCuN3FV+VrnMQJGDKqDao1PpPJa7OA/AM5xeax330FA8xldF9pEqkGMdnoF4AD3VypLnvwYAat2c+N8ezx/0iOvjerBLDNatRuzzJygtWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QGjH9x5l; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-65b985bb059so186115437b3.2
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783482; x=1722388282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l61walSFLT3wujjZG3IB9eT72Sms+glBrguecMkZhLU=;
        b=QGjH9x5lQQZqeX9Oe+KKBXGWdorteyZ3Ue6JQs0XCM7LVceIYG2yYWOu5ojIEn508P
         dJ83z62pAMKVbcw4VOnFSTjpeqO7WbehbWYkr6sdKUC08a2WXNR01wJU0qjFDeQIGRiQ
         v35LBroU+LO8PKf8ByOuRKQsmuHuUh9joVaLX9zVdvxDs7gBkDBSDxE448uBCjO6Z8tZ
         +ZSW+N4OGJmZF0L5jZWfbgVhCBre4okJS1P2AjPRAbG9py9H+d0hC8mvyqL6s9K0l5N8
         Vf4Zx6qGDu3MSdRkMbwwWrMmlrJRsOnPemZcWe8vDMrojFAOK8vEkS65L0x0P953lont
         FAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783482; x=1722388282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l61walSFLT3wujjZG3IB9eT72Sms+glBrguecMkZhLU=;
        b=L3edZWlfBi9sFmFiRQKCKg2x1Xf873BBnDaA0f1aPcTX/08Xh2Bim1cN6aR9FwufNI
         VamvmPjahvdJKplO/fOPnKjs8xq98CST/ZF45BcfmLXjqqf8P7xeFJWxox6duoZu3jFH
         jiHhTiH8x1Z7RQf9HSFDHjuHPDunmEU6krzhwqtfbOWGa9wavOfMauWXg0CwW9S9wc4z
         k7e3t9XYUSd+CkAAeWA1zluHsO00IW0k+64fBufaBoZK8sUbrZzOrdopLID7l6rRUdqf
         m1GXplqMOrOR6suB6MmI+i4ebFa+RallIhrMMIwrka0DsIsaw7bClryOgq+1b2luxfV3
         tWgA==
X-Forwarded-Encrypted: i=1; AJvYcCVM7WJH8rcIZE1bbkAvlMbmUL/qWcjqDpFQ5e4WueLtYbz7ZsRt2DoRT3yhmuYIg+sdGiwCSHmVQ8GLYNAQdeuNvEs4
X-Gm-Message-State: AOJu0YwmXGSYwkhuyRgLsD2d0uUivIuK+jofv9NOGwd1aNNLWD7lmNWA
	uJLXUcM3GGrq2W08Mdi92Gfx8EJ1pYdowkWxxrA0sKW7aJQrkkXqCxGM7gxX1y33iUsesrdoa+u
	2+h3tSfxlAUTxy9G8rg==
X-Google-Smtp-Source: AGHT+IEg/H2lbIriLQJuQZOeuvv/uRDEcOC7gwIqFMsyzw2ax8lq+eZHzig2mgaym4s4zLkdQm+/Llq7W+RvG6Hz
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:4286:b0:664:c5e0:6574 with
 SMTP id 00721157ae682-66a68f79a06mr2287047b3.9.1721783482414; Tue, 23 Jul
 2024 18:11:22 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:35 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-11-jthoughton@google.com>
Subject: [PATCH v6 10/11] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Secondary MMUs are currently consulted for access/age information at
eviction time, but before then, we don't get accurate age information.
That is, pages that are mostly accessed through a secondary MMU (like
guest memory, used by KVM) will always just proceed down to the oldest
generation, and then at eviction time, if KVM reports the page to be
young, the page will be activated/promoted back to the youngest
generation.

The added feature bit (0x8), if disabled, will make MGLRU behave as if
there are no secondary MMUs subscribed to MMU notifiers except at
eviction time.

Implement aging with the new mmu_notifier_clear_young_fast_only()
notifier. For architectures that do not support this notifier, this
becomes a no-op. For architectures that do implement it, it should be
fast enough to make aging worth it (usually the case if the notifier is
implemented locklessly).

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 include/linux/mmzone.h                        |   6 +-
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 148 ++++++++++++++----
 4 files changed, 127 insertions(+), 42 deletions(-)

diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 33e068830497..e1862407652c 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -48,6 +48,10 @@ Values Components
        verified on x86 varieties other than Intel and AMD. If it is
        disabled, the multi-gen LRU will suffer a negligible
        performance degradation.
+0x0008 Clear the accessed bit in secondary MMU page tables when aging
+       instead of waiting until eviction time. This results in accurate
+       page age information for pages that are mainly used by a
+       secondary MMU.
 [yYnN] Apply to all the components above.
 ====== ===============================================================
 
@@ -56,7 +60,7 @@ E.g.,
 
     echo y >/sys/kernel/mm/lru_gen/enabled
     cat /sys/kernel/mm/lru_gen/enabled
-    0x0007
+    0x000f
     echo 5 >/sys/kernel/mm/lru_gen/enabled
     cat /sys/kernel/mm/lru_gen/enabled
     0x0005
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 586a8f0104d7..ee82e635e75b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -400,6 +400,7 @@ enum {
 	LRU_GEN_CORE,
 	LRU_GEN_MM_WALK,
 	LRU_GEN_NONLEAF_YOUNG,
+	LRU_GEN_SECONDARY_MMU_WALK,
 	NR_LRU_GEN_CAPS
 };
 
@@ -557,7 +558,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -576,8 +577,9 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
+	return false;
 }
 
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
diff --git a/mm/rmap.c b/mm/rmap.c
index e8fc5ecb59b2..24a3ff639919 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -870,13 +870,10 @@ static bool folio_referenced_one(struct folio *folio,
 			continue;
 		}
 
-		if (pvmw.pte) {
-			if (lru_gen_enabled() &&
-			    pte_young(ptep_get(pvmw.pte))) {
-				lru_gen_look_around(&pvmw);
+		if (lru_gen_enabled() && pvmw.pte) {
+			if (lru_gen_look_around(&pvmw))
 				referenced++;
-			}
-
+		} else if (pvmw.pte) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte))
 				referenced++;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2e34de9cd0d4..e4fa52c8f714 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -56,6 +56,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2579,6 +2580,11 @@ static bool should_clear_pmd_young(void)
 	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
 }
 
+static bool should_walk_secondary_mmu(void)
+{
+	return get_cap(LRU_GEN_SECONDARY_MMU_WALK);
+}
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -3276,7 +3282,8 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3291,10 +3298,15 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	/* try to avoid unnecessary memory loads */
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
-static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
@@ -3309,6 +3321,10 @@ static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	/* try to avoid unnecessary memory loads */
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
@@ -3317,10 +3333,6 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 {
 	struct folio *folio;
 
-	/* try to avoid unnecessary memory loads */
-	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-		return NULL;
-
 	folio = pfn_folio(pfn);
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
@@ -3343,6 +3355,26 @@ static bool suitable_to_scan(int total, int young)
 	return young * n >= total;
 }
 
+static bool lru_gen_notifier_clear_young(struct mm_struct *mm,
+					 unsigned long start,
+					 unsigned long end)
+{
+	return should_walk_secondary_mmu() &&
+		mmu_notifier_clear_young_fast_only(mm, start, end);
+}
+
+static bool lru_gen_pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					      unsigned long addr,
+					      pmd_t *pmd)
+{
+	bool young = pmdp_test_and_clear_young(vma, addr, pmd);
+
+	if (lru_gen_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE))
+		young = true;
+
+	return young;
+}
+
 static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
@@ -3357,8 +3389,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	struct mm_struct *mm = args->mm;
 
-	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
+	pte = pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl);
 	if (!pte)
 		return false;
 	if (!spin_trylock(ptl)) {
@@ -3376,11 +3409,11 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
+		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent)) {
+		if (!pte_young(ptent) && !mm_has_notifiers(mm)) {
 			walk->mm_stats[MM_LEAF_OLD]++;
 			continue;
 		}
@@ -3389,8 +3422,14 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE) &&
+		    !pte_young(ptent)) {
+			walk->mm_stats[MM_LEAF_OLD]++;
+			continue;
+		}
+
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(args->vma, addr, pte + i);
 
 		young++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3456,22 +3495,25 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		pfn = get_pmd_pfn(pmd[i], vma, addr);
-		if (pfn == -1)
-			goto next;
-
-		if (!pmd_trans_huge(pmd[i])) {
-			if (should_clear_pmd_young())
+		if (pmd_present(pmd[i]) && !pmd_trans_huge(pmd[i])) {
+			if (should_clear_pmd_young() &&
+			    !should_walk_secondary_mmu())
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
 
+		pfn = get_pmd_pfn(pmd[i], vma, addr, pgdat);
+		if (pfn == -1)
+			goto next;
+
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
 		if (!folio)
 			goto next;
 
-		if (!pmdp_test_and_clear_young(vma, addr, pmd + i))
+		if (!lru_gen_pmdp_test_and_clear_young(vma, addr, pmd + i)) {
+			walk->mm_stats[MM_LEAF_OLD]++;
 			goto next;
+		}
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
 
@@ -3528,19 +3570,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		}
 
 		if (pmd_trans_huge(val)) {
-			unsigned long pfn = pmd_pfn(val);
 			struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
+			unsigned long pfn = get_pmd_pfn(val, vma, addr, pgdat);
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (!pmd_young(val)) {
-				walk->mm_stats[MM_LEAF_OLD]++;
+			if (pfn == -1)
 				continue;
-			}
 
-			/* try to avoid unnecessary memory loads */
-			if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+			if (!pmd_young(val) && !mm_has_notifiers(args->mm)) {
+				walk->mm_stats[MM_LEAF_OLD]++;
 				continue;
+			}
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 			continue;
@@ -3548,7 +3589,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (should_clear_pmd_young() && !should_walk_secondary_mmu()) {
 			if (!pmd_young(val))
 				continue;
 
@@ -3994,6 +4035,31 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  *                          rmap/PT walk feedback
  ******************************************************************************/
 
+static bool should_look_around(struct vm_area_struct *vma, unsigned long addr,
+			       pte_t *pte, int *young)
+{
+	int secondary_young = mmu_notifier_clear_young(
+				vma->vm_mm, addr, addr + PAGE_SIZE);
+
+	/*
+	 * Look around if (1) the PTE is young or (2) the secondary PTE was
+	 * young and one of the "fast" MMUs of one of the secondary MMUs
+	 * reported that the page was young.
+	 */
+	if (pte_young(ptep_get(pte))) {
+		ptep_test_and_clear_young(vma, addr, pte);
+		*young = true;
+		return true;
+	}
+
+	if (secondary_young) {
+		*young = true;
+		return mm_has_fast_young_notifiers(vma->vm_mm);
+	}
+
+	return false;
+}
+
 /*
  * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
@@ -4001,7 +4067,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
 	unsigned long start;
@@ -4019,16 +4085,20 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	struct mm_struct *mm = pvmw->vma->vm_mm;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
+	if (!should_look_around(vma, addr, pte, &young))
+		return young;
+
 	if (spin_is_contended(pvmw->ptl))
-		return;
+		return young;
 
 	/* exclude special VMAs containing anon pages from COW */
 	if (vma->vm_flags & VM_SPECIAL)
-		return;
+		return young;
 
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
@@ -4036,6 +4106,9 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
+	if (end - start == PAGE_SIZE)
+		return young;
+
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
@@ -4049,7 +4122,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	/* folio_update_gen() requires stable folio_memcg() */
 	if (!mem_cgroup_trylock_pages(memcg))
-		return;
+		return young;
 
 	arch_enter_lazy_mmu_mode();
 
@@ -4059,19 +4132,23 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent))
+		if (!pte_young(ptent) && !mm_has_notifiers(mm))
 			continue;
 
 		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE) &&
+		    !pte_young(ptent))
+			continue;
+
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(vma, addr, pte + i);
 
 		young++;
 
@@ -4101,6 +4178,8 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+
+	return young;
 }
 
 /******************************************************************************
@@ -5137,6 +5216,9 @@ static ssize_t enabled_show(struct kobject *kobj, struct kobj_attribute *attr, c
 	if (should_clear_pmd_young())
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
+	if (should_walk_secondary_mmu())
+		caps |= BIT(LRU_GEN_SECONDARY_MMU_WALK);
+
 	return sysfs_emit(buf, "0x%04x\n", caps);
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


