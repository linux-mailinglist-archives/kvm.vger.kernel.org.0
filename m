Return-Path: <kvm+bounces-19278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AC8902D9A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8579286E3E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A36C4C8C;
	Tue, 11 Jun 2024 00:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OrPu6qzy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE51DFF8
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065330; cv=none; b=EUrGubBpxxCYGDowu1jnbWPeIVMz7k0TLH4kJtCUsLZjpyKy8825o61pEsvkdfFMqPBZ16gg+HLFsrpabUwO8lQ254EBx7C6zhCfwACQA0g3XLA3GOrGyJOPMDn2pAtrsbZcofjaX6Yz+r82Zqw+CEW/rK4TB73oJ5VFjXj7DV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065330; c=relaxed/simple;
	bh=oPj+n2FyBmyWGVpjuxt/APf/qjEnAU4qM2A+VTS1N9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l9Xf2zoQlmaKs4wn5qAcBz1O3sd+U/ex/OyzJN+MnnGm9umUdKVbUAZyOkHJocIWfEjL9HKh6g/bwCKJCoAKOLPIWVvLwRrSs+1/7rKp+qlEiNQWneAt2urwicp7o7zWg6Zk0C4m00yd2+2IzS80JLBvtmY6SELmaFz534si/JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OrPu6qzy; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a27e501d4so87750717b3.3
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065326; x=1718670126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo+Bu7unBE5gh64FI+uJOzLCwIq9hY4QKBbILo2rDFQ=;
        b=OrPu6qzyICtBBFp4OY0Ztyj+I9YuFRnwpDbQN/N/fM2kkLeI4m16F1GEAEbeF9gNtX
         n3ptcUjdPSXF18Kav80ypFDDHPb/s5XzMqT3hl62aCD0W+Ca7eVDI2w13qTMss6GOIqR
         SXZwrddcMfHn0n26YmKoJOpK8YCLjVF88aPhxBC72U1ukC1J5DZatt1TU/9cROcrC9Xl
         ipMmVBJdv+968mbYOi5rfveLnYkpJf1n1Yi+cqwJVEt5L4dMgOn8hVUlBimp2PPrqwbr
         T5PQZ0nHdIxHljDV0/x0/NluYIknKMZAlttcCn67S+6cgE1iX9QvXyH3V6aHaTYaRfi9
         /FKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065326; x=1718670126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo+Bu7unBE5gh64FI+uJOzLCwIq9hY4QKBbILo2rDFQ=;
        b=S2qu0tw30DUsH3X6fxTpg0n1Sfp3e6RvY2JuPVR6xg13ZNt7tRBNao/lihO6QTIU0S
         eSAhrLlMuplkkWz+bX3N4xKDA5aWY7YZYJtNJh8LhzOe5ChZwQ/9V6ryL4Zaj4gfbyQJ
         RwpcbG1nh44uy+E/idddSbWC7/wOBYEFu4ry5IVAzQaDtlH91apYWiJgosgLTTe7LFRf
         heDVQmmu3ILGEOP9R4pA4+AMlFD7i2C3gFlA/P1EIapsYdZ+37G0V3/wZq1gQsiBHPmF
         zJm/wFOdDMsImonbqePFGIej6MiRoYJvwebZawX+ZKmSKeU295m9+6MbdY4SzrkziQcq
         jGnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP9FeyokdBIEYN3i2XuSw/W2jtwAuRyVusn5gVU5qY2bihklra2PpoVvumQxGUQLOUqT//AF2VQ0tOv7vwqDtj0Uco
X-Gm-Message-State: AOJu0YxvlDZtghHWTdDRycRs2hyJ2mB2sjQltumuIB98hf+KS8rhfbJV
	tD1WgH98IG5hwoI51Gc9G10HQ2mlvxTCHyD+0GTEWvYt7lSBVcFDSWkHO6JTE2kO+ExtStIxqzl
	QlTphZDzRSnqmxCXQZQ==
X-Google-Smtp-Source: AGHT+IHtj7SNMMi/3/i8/52lNUvR2VRVAA2etM4uu9yTrGn4HRUJ3FOW4k35Dt1nhJu9v+3Qc8XwmxSl151ooVW/
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:648a:b0:62d:1a1e:8583 with
 SMTP id 00721157ae682-62d1a1e8835mr7101357b3.9.1718065325888; Mon, 10 Jun
 2024 17:22:05 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:44 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-9-jthoughton@google.com>
Subject: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate in aging
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
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

Implement aging with the new mmu_notifier_test_clear_young_fast_only()
notifier. For architectures that do not support this notifier, this
becomes a no-op. For architectures that do implement it, it should be
fast enough to make aging worth it.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---

Notes:
    should_look_around() can sometimes use two notifiers now instead of one.
    
    This simply comes from restricting myself from not changing
    mmu_notifier_clear_young() to return more than just "young or not".
    
    I could change mmu_notifier_clear_young() (and
    mmu_notifier_test_young()) to return if it was fast or not. At that
    point, I could just as well combine all the notifiers into one notifier,
    like what was in v2 and v3.

 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 include/linux/mmzone.h                        |   6 +-
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 185 ++++++++++++++----
 4 files changed, 164 insertions(+), 42 deletions(-)

diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 33e068830497..1e578e0c4c0c 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -48,6 +48,10 @@ Values Components
        verified on x86 varieties other than Intel and AMD. If it is
        disabled, the multi-gen LRU will suffer a negligible
        performance degradation.
+0x0008 Continuously clear the accessed bit in secondary MMU page
+       tables instead of waiting until eviction time. This results in
+       accurate page age information for pages that are mainly used by
+       a secondary MMU.
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
index 8f9c9590a42c..869824ef5f3b 100644
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
index 2e34de9cd0d4..348f3ffc8d5d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -56,6 +56,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2579,6 +2580,21 @@ static bool should_clear_pmd_young(void)
 	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
 }
 
+#ifdef CONFIG_HAVE_KVM_YOUNG_FAST_ONLY_NOTIFIER
+#include <linux/kvm_host.h>
+static bool should_walk_secondary_mmu(void)
+{
+	return kvm_arch_young_notifier_likely_fast() &&
+	       get_cap(LRU_GEN_SECONDARY_MMU_WALK);
+}
+#else
+static bool should_walk_secondary_mmu(void)
+{
+	return false;
+}
+#endif
+
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -3276,7 +3292,8 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3291,10 +3308,15 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
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
 
@@ -3309,6 +3331,10 @@ static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	/* try to avoid unnecessary memory loads */
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
@@ -3317,10 +3343,6 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 {
 	struct folio *folio;
 
-	/* try to avoid unnecessary memory loads */
-	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-		return NULL;
-
 	folio = pfn_folio(pfn);
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
@@ -3343,6 +3365,43 @@ static bool suitable_to_scan(int total, int young)
 	return young * n >= total;
 }
 
+static bool lru_gen_notifier_test_clear_young(struct mm_struct *mm,
+					      unsigned long start,
+					      unsigned long end,
+					      bool clear)
+{
+	return should_walk_secondary_mmu() &&
+		(mmu_notifier_test_clear_young_fast_only(
+				mm, start, end, clear) &
+		 MMU_NOTIFIER_FAST_YOUNG);
+}
+
+static bool lru_gen_notifier_test_young(struct mm_struct *mm,
+					unsigned long addr)
+{
+	return lru_gen_notifier_test_clear_young(mm, addr, addr + PAGE_SIZE,
+						 false);
+}
+
+static bool lru_gen_notifier_clear_young(struct mm_struct *mm,
+					 unsigned long start,
+					 unsigned long end)
+{
+	return lru_gen_notifier_test_clear_young(mm, start, end, true);
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
@@ -3357,8 +3416,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	struct mm_struct *mm = args->mm;
 
-	pte = pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &ptl);
+	pte = pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl);
 	if (!pte)
 		return false;
 	if (!spin_trylock(ptl)) {
@@ -3376,11 +3436,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
+		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent)) {
+		if (!pte_young(ptent) &&
+		    !lru_gen_notifier_test_young(mm, addr)) {
 			walk->mm_stats[MM_LEAF_OLD]++;
 			continue;
 		}
@@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE);
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(args->vma, addr, pte + i);
 
 		young++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3456,22 +3518,25 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
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
 
@@ -3528,19 +3593,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
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
@@ -3548,7 +3612,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (should_clear_pmd_young() && !should_walk_secondary_mmu()) {
 			if (!pmd_young(val))
 				continue;
 
@@ -3994,6 +4058,47 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  *                          rmap/PT walk feedback
  ******************************************************************************/
 
+static bool should_look_around(struct vm_area_struct *vma, unsigned long addr,
+			       pte_t *pte, int *young)
+{
+	int notifier_result = MMU_NOTIFIER_FAST_FAILED;
+	bool notifier_was_fast = false;
+	bool secondary_young = false;
+
+	if (should_walk_secondary_mmu()) {
+		notifier_result =
+			mmu_notifier_test_clear_young_fast_only(
+					vma->vm_mm, addr, addr + PAGE_SIZE,
+					/*clear=*/true);
+	}
+
+	if (notifier_result & MMU_NOTIFIER_FAST_FAILED)
+		secondary_young = mmu_notifier_clear_young(vma->vm_mm, addr,
+							   addr + PAGE_SIZE);
+	else {
+		secondary_young = notifier_result & MMU_NOTIFIER_FAST_YOUNG;
+		notifier_was_fast = true;
+	}
+
+	/*
+	 * Look around if (1) the PTE is young or (2) the secondary PTE was
+	 * young and the results were gathered fast (so look-around will
+	 * probably be accurate).
+	 */
+	if (pte_young(ptep_get(pte))) {
+		ptep_test_and_clear_young(vma, addr, pte);
+		*young = true;
+		return true;
+	}
+
+	if (secondary_young) {
+		*young = true;
+		return notifier_was_fast;
+	}
+
+	return false;
+}
+
 /*
  * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
@@ -4001,7 +4106,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
 	unsigned long start;
@@ -4019,16 +4124,20 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4036,6 +4145,9 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
+	if (end - start == PAGE_SIZE)
+		return young;
+
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
@@ -4049,7 +4161,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	/* folio_update_gen() requires stable folio_memcg() */
 	if (!mem_cgroup_trylock_pages(memcg))
-		return;
+		return young;
 
 	arch_enter_lazy_mmu_mode();
 
@@ -4059,19 +4171,21 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent))
+		if (!pte_young(ptent) &&
+		    !lru_gen_notifier_test_young(mm, addr))
 			continue;
 
 		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE);
+		if (pte_young(ptent))
+			ptep_test_and_clear_young(vma, addr, pte + i);
 
 		young++;
 
@@ -4101,6 +4215,8 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+
+	return young;
 }
 
 /******************************************************************************
@@ -5137,6 +5253,9 @@ static ssize_t enabled_show(struct kobject *kobj, struct kobj_attribute *attr, c
 	if (should_clear_pmd_young())
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
+	if (should_walk_secondary_mmu())
+		caps |= BIT(LRU_GEN_SECONDARY_MMU_WALK);
+
 	return sysfs_emit(buf, "0x%04x\n", caps);
 }
 
-- 
2.45.2.505.gda0bf45e8d-goog


