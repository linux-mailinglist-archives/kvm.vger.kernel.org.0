Return-Path: <kvm+bounces-13310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC288947C0
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7C028385D
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314425D8F6;
	Mon,  1 Apr 2024 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LtYLFYhF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9048E58AC1
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014206; cv=none; b=pfJ12WHOAef+fn37TB3dzO7Sq3h67B8/WL6zysk+Klia9zQfMp4IXjAM5zRB/BmA3bxZdhKTaFX7R0g4+XCNF0/cXdyEAV06BNmauXWxqP/PblO+Qt1D9KqzRhYGteKk57HK7HiYg2Rf1QCqJ60lC5faEBEz1kAX5K9IFbJHH80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014206; c=relaxed/simple;
	bh=WmcsQL1jAwPB2bQpwPfReVNE8AqM+O4XaG6OyvFYBYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mj2MG6PeQzzoxursWXwTgzEs1dT9OcLLQwF590GwzjP++xlm/U4Bnx7ZRKazJmh4s1AZ2+KreH3P5xkvwPVsjQnITI5CCe7mYuNqB4zBPxPmaUS/eNFAUwH7068MT/QRpDSpGaun3319f7pbtx4ARP+04gNtAF+7KFuSaK0rU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LtYLFYhF; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so5418003276.3
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014202; x=1712619002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WpAS/uks+xeMlZlwJrS/cYcvCVm3xLsD9iJKs+t5VOw=;
        b=LtYLFYhFlgEdTD9SON2aVF74U88Svqr5IDehFiQ1CE8pJNPpbBR2bS8mST2vJYBexN
         vgCcPTdzbkGkWaMm9OKRQdm6tsFHwLBpPYtMxeXuOXE8pN5SYuUhPtqPD+F6zkmsNeky
         UHJgAdjBHpH1zdfDujmtDGhcocBg5YLuRb54UbOlYPggWoI+aeWiPy96qe1fAeuMV3F0
         r30K0kysAthcgfzArrdZh1NDDhPQa/ZOJrJ0ETQY24NuAoorJircpQYLR+BC2GY+zQV5
         Iin6VrAQZd+Tk+i9wDgEns1zHb/aLkL4wwOwmjffBvzeWOnvV+WcU1XLl/dCqa3ZPgOL
         gmjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014202; x=1712619002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WpAS/uks+xeMlZlwJrS/cYcvCVm3xLsD9iJKs+t5VOw=;
        b=PHP8Pg0CsFTDef2qFcyY4+ETdegXl9c7tc/O3aDPnzXwK2hfUDhuPBbxrpoVnWLc92
         kxzCN6wZ4dEVnZZe/T5orHsJ8WwsIBZHqtJ3H2lPUHeXj3UmvPVDhy+wkIEV6HQvjdx5
         CyRyYIzk5ZgMdyJGojfCZTqEj5CdalxzvGRTvdkqvAOwiJq3yRQhZ40uUTD1gRWIrrMw
         ANRe/cIQqCjRoUHM/PL+j7xgO2ZTVkTfWBJgZQPRKyo4cJLz4/3clzlyKe284kvowe7L
         oFfq09/yPKleFQvIfwHmrFKouGc7t/A4cRSM47Eg081hk1EEVSwwt1Q7Mq8IwCbS2wU5
         w7LA==
X-Forwarded-Encrypted: i=1; AJvYcCUryk/sFmpu2UeFgcZiPr8TdYmnLVZ9+lOK3J0LCB4oXoLSGg1boQZnUrs26CphQwNWbAxw7oUjBu2SBm9v2qZl2PKY
X-Gm-Message-State: AOJu0Yx2vUXh4foq44xFrW67109NLet2jlizdYtSZHuelu+RxgmqgJDI
	9cTFSNNyKvx+W1mA3SZlNxcqiekgcALn6moqT21pI0R5h2e1LNW6r110Yo+u4YRbiEFyVd6Q6Z4
	dZivz0caXQWcmxbyh7w==
X-Google-Smtp-Source: AGHT+IFDD8pqYO4xCu07bbvePXFmo0Pl8SwWr49Tzn/Rs0hc66IZhVLSZQfRP6lopGz4i0uv+3xgxtfkPILQecVq
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2202:b0:dcd:59a5:7545 with
 SMTP id dm2-20020a056902220200b00dcd59a57545mr764461ybb.10.1712014202562;
 Mon, 01 Apr 2024 16:30:02 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:46 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-8-jthoughton@google.com>
Subject: [PATCH v3 7/7] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yu Zhao <yuzhao@google.com>

Use mmu_notifier_{test,clear}_young_bitmap() to handle KVM PTEs in
batches when the fast path is supported. This reduces the contention on
kvm->mmu_lock when the host is under heavy memory pressure.

An existing selftest can quickly demonstrate the effectiveness of
this patch. On a generic workstation equipped with 128 CPUs and 256GB
DRAM:

  $ sudo max_guest_memory_test -c 64 -m 250 -s 250

  MGLRU         run2
  ------------------
  Before [1]    ~64s
  After         ~51s

  kswapd (MGLRU before)
    100.00%  balance_pgdat
      100.00%  shrink_node
        100.00%  shrink_one
          99.99%  try_to_shrink_lruvec
            99.71%  evict_folios
              97.29%  shrink_folio_list
  ==>>          13.05%  folio_referenced
                  12.83%  rmap_walk_file
                    12.31%  folio_referenced_one
                      7.90%  __mmu_notifier_clear_young
                        7.72%  kvm_mmu_notifier_clear_young
                          7.34%  _raw_write_lock

  kswapd (MGLRU after)
    100.00%  balance_pgdat
      100.00%  shrink_node
        100.00%  shrink_one
          99.99%  try_to_shrink_lruvec
            99.59%  evict_folios
              80.37%  shrink_folio_list
  ==>>          3.74%  folio_referenced
                  3.59%  rmap_walk_file
                    3.19%  folio_referenced_one
                      2.53%  lru_gen_look_around
                        1.06%  __mmu_notifier_test_clear_young

[1] "mm: rmap: Don't flush TLB after checking PTE young for page
    reference" was included so that the comparison is apples to
    apples.
    https://lore.kernel.org/r/20220706112041.3831-1-21cnbao@gmail.com/

Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 include/linux/mmzone.h                        |   6 +-
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 183 ++++++++++++++----
 4 files changed, 159 insertions(+), 45 deletions(-)

diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 33e068830497..0ae2a6d4d94c 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -48,6 +48,10 @@ Values Components
        verified on x86 varieties other than Intel and AMD. If it is
        disabled, the multi-gen LRU will suffer a negligible
        performance degradation.
+0x0008 Clearing the accessed bit in KVM page table entries in large
+       batches, when KVM MMU sets it (e.g., on x86_64). This can
+       improve the performance of guests when the host is under memory
+       pressure.
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
index c11b7cde81ef..a98de5106990 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -397,6 +397,7 @@ enum {
 	LRU_GEN_CORE,
 	LRU_GEN_MM_WALK,
 	LRU_GEN_NONLEAF_YOUNG,
+	LRU_GEN_KVM_MMU_WALK,
 	NR_LRU_GEN_CAPS
 };
 
@@ -554,7 +555,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -573,8 +574,9 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
+	return false;
 }
 
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
diff --git a/mm/rmap.c b/mm/rmap.c
index 56b313aa2ebf..41e9fc25684e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -871,13 +871,10 @@ static bool folio_referenced_one(struct folio *folio,
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
index 293120fe54f3..fd65f3466dfc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -56,6 +56,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2596,6 +2597,11 @@ static bool should_clear_pmd_young(void)
 	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
 }
 
+static bool should_walk_kvm_mmu(void)
+{
+	return get_cap(LRU_GEN_KVM_MMU_WALK);
+}
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -3293,7 +3299,8 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3308,10 +3315,15 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
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
 
@@ -3326,6 +3338,10 @@ static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	/* try to avoid unnecessary memory loads */
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
@@ -3334,10 +3350,6 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 {
 	struct folio *folio;
 
-	/* try to avoid unnecessary memory loads */
-	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-		return NULL;
-
 	folio = pfn_folio(pfn);
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
@@ -3352,6 +3364,52 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	return folio;
 }
 
+static bool test_spte_young(struct mm_struct *mm, unsigned long addr, unsigned long end,
+			    unsigned long *bitmap, unsigned long *last)
+{
+	if (*last > addr)
+		goto done;
+
+	*last = end - addr > MIN_LRU_BATCH * PAGE_SIZE ?
+		addr + MIN_LRU_BATCH * PAGE_SIZE - 1 : end - 1;
+	bitmap_zero(bitmap, MIN_LRU_BATCH);
+
+	mmu_notifier_test_young_bitmap(mm, addr, *last + 1, bitmap);
+done:
+	return test_bit((*last - addr) / PAGE_SIZE, bitmap);
+}
+
+static void clear_spte_young(struct mm_struct *mm, unsigned long addr,
+			     unsigned long *bitmap, unsigned long *last)
+{
+	int i;
+	unsigned long start, end = *last + 1;
+
+	if (addr + PAGE_SIZE != end)
+		return;
+
+	i = find_last_bit(bitmap, MIN_LRU_BATCH);
+	if (i == MIN_LRU_BATCH)
+		return;
+
+	start = end - (i + 1) * PAGE_SIZE;
+
+	i = find_first_bit(bitmap, MIN_LRU_BATCH);
+
+	end -= i * PAGE_SIZE;
+
+	mmu_notifier_clear_young_bitmap(mm, start, end, bitmap);
+}
+
+static void skip_spte_young(struct mm_struct *mm, unsigned long addr,
+			    unsigned long *bitmap, unsigned long *last)
+{
+	if (*last > addr)
+		__clear_bit((*last - addr) / PAGE_SIZE, bitmap);
+
+	clear_spte_young(mm, addr, bitmap, last);
+}
+
 static bool suitable_to_scan(int total, int young)
 {
 	int n = clamp_t(int, cache_line_size() / sizeof(pte_t), 2, 8);
@@ -3367,6 +3425,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
+	DECLARE_BITMAP(bitmap, MIN_LRU_BATCH);
+	unsigned long last = 0;
 	int total = 0;
 	int young = 0;
 	struct lru_gen_mm_walk *walk = args->private;
@@ -3386,6 +3446,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	arch_enter_lazy_mmu_mode();
 restart:
 	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
+		bool ret;
 		unsigned long pfn;
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
@@ -3393,21 +3454,28 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
-		if (pfn == -1)
+		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
+		if (pfn == -1) {
+			skip_spte_young(args->vma->vm_mm, addr, bitmap, &last);
 			continue;
+		}
 
-		if (!pte_young(ptent)) {
+		ret = test_spte_young(args->vma->vm_mm, addr, end, bitmap, &last);
+		if (!ret && !pte_young(ptent)) {
+			skip_spte_young(args->vma->vm_mm, addr, bitmap, &last);
 			walk->mm_stats[MM_LEAF_OLD]++;
 			continue;
 		}
 
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
-		if (!folio)
+		if (!folio) {
+			skip_spte_young(args->vma->vm_mm, addr, bitmap, &last);
 			continue;
+		}
 
-		if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		clear_spte_young(args->vma->vm_mm, addr, bitmap, &last);
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(args->vma, addr, pte + i);
 
 		young++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3473,22 +3541,24 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		pfn = get_pmd_pfn(pmd[i], vma, addr);
-		if (pfn == -1)
-			goto next;
-
-		if (!pmd_trans_huge(pmd[i])) {
-			if (should_clear_pmd_young())
+		if (pmd_present(pmd[i]) && !pmd_trans_huge(pmd[i])) {
+			if (should_clear_pmd_young() && !mm_has_notifiers(args->mm))
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
+		if (!pmdp_clear_young_notify(vma, addr, pmd + i)) {
+			walk->mm_stats[MM_LEAF_OLD]++;
 			goto next;
+		}
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
 
@@ -3545,19 +3615,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
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
@@ -3565,7 +3634,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (should_clear_pmd_young() && !mm_has_notifiers(args->mm)) {
 			if (!pmd_young(val))
 				continue;
 
@@ -3646,6 +3715,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 	struct lruvec *lruvec = walk->lruvec;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
+	if (!should_walk_kvm_mmu() && mm_has_notifiers(mm))
+		return;
+
 	walk->next_addr = FIRST_USER_ADDRESS;
 
 	do {
@@ -4011,6 +4083,23 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  *                          rmap/PT walk feedback
  ******************************************************************************/
 
+static bool should_look_around(struct vm_area_struct *vma, unsigned long addr,
+			       pte_t *pte, int *young)
+{
+	int ret = mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+
+	if (pte_young(ptep_get(pte))) {
+		ptep_test_and_clear_young(vma, addr, pte);
+		*young = true;
+		return true;
+	}
+
+	if (ret)
+		*young = true;
+
+	return ret & MMU_NOTIFIER_YOUNG_FAST;
+}
+
 /*
  * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
@@ -4018,12 +4107,14 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
 	unsigned long start;
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
+	DECLARE_BITMAP(bitmap, MIN_LRU_BATCH);
+	unsigned long last = 0;
 	int young = 0;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
@@ -4040,12 +4131,15 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
+	if (!should_look_around(pvmw->vma, addr, pte, &young))
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
@@ -4053,6 +4147,9 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
+	if (end - start == PAGE_SIZE)
+		return young;
+
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
@@ -4066,29 +4163,38 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	/* folio_update_gen() requires stable folio_memcg() */
 	if (!mem_cgroup_trylock_pages(memcg))
-		return;
+		return young;
 
 	arch_enter_lazy_mmu_mode();
 
 	pte -= (addr - start) / PAGE_SIZE;
 
 	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+		bool ret;
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, vma, addr);
-		if (pfn == -1)
+		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
+		if (pfn == -1) {
+			skip_spte_young(vma->vm_mm, addr, bitmap, &last);
 			continue;
+		}
 
-		if (!pte_young(ptent))
+		ret = test_spte_young(pvmw->vma->vm_mm, addr, end, bitmap, &last);
+		if (!ret && !pte_young(ptent)) {
+			skip_spte_young(pvmw->vma->vm_mm, addr, bitmap, &last);
 			continue;
+		}
 
 		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
-		if (!folio)
+		if (!folio) {
+			skip_spte_young(vma->vm_mm, addr, bitmap, &last);
 			continue;
+		}
 
-		if (!ptep_test_and_clear_young(vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		clear_spte_young(vma->vm_mm, addr, bitmap, &last);
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(vma, addr, pte + i);
 
 		young++;
 
@@ -4118,6 +4224,8 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+
+	return young;
 }
 
 /******************************************************************************
@@ -5154,6 +5262,9 @@ static ssize_t enabled_show(struct kobject *kobj, struct kobj_attribute *attr, c
 	if (should_clear_pmd_young())
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
+	if (should_walk_kvm_mmu())
+		caps |= BIT(LRU_GEN_KVM_MMU_WALK);
+
 	return sysfs_emit(buf, "0x%04x\n", caps);
 }
 
-- 
2.44.0.478.gd926399ef9-goog


