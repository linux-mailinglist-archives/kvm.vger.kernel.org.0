Return-Path: <kvm+bounces-21551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDB092FEF8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 193531F2130B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BB017BB2C;
	Fri, 12 Jul 2024 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a5xiMbl7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F41217B504
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803693; cv=none; b=XQMpErg/NAXGAt0lq2x+YFCYZwC1AcxTUGCeLD/zFuKQNp9YtqDn9KWp5dH59Y3rVlvjdPuJ+6mgvp49YnmwHCYuxzgyYM9kbtBxw3p6TBxQwlyO62pXWIpTvPfPsXY5CYeZtRTXfZo4YpB8u4KPx16nj7M9bjFcdERVJVqzFvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803693; c=relaxed/simple;
	bh=ab3ibfiu6/EobF/dt6nt6fNjyRlfI6Skav1gbyBbuUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uvgzc1OnFdNNwZGzcTfoWCn6Kg0AVo12rMbsOR31VQFaJYuas5KTZ/WHpeS6QXGv+rLaQxaOCbsP+XnuPqoP5vzNUhfVdxCp3JZ5JGv9csNV9d7/wcB1Ixf2w1Rwe5BiECoxPIVCvO3c1XancPofgz2mPmlQVe7Kmh8jtKIcWaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a5xiMbl7; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-367990b4beeso1258836f8f.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803690; x=1721408490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hLefymYBmXT6JRGt/rz6i03hx4/br+A6fWBCFOJPqqY=;
        b=a5xiMbl7t/jObyi6m/EVX+/kuN8XSBDPmMzJq57ZpE7OY3Lwip/A9y4m9X9vfpiaSf
         nHv19dAJxdWn4b9wkgJ6Z0dSvy0fGkwyIWo9OnQLR/2/ofnCDf3ztwcw658PrNYY00Ny
         grY8N9awDtn5okvPYA+8wN46h0hxuWv0RwIf8Q1gn1XaQ3nwqzrTrnIcGsrMjOC0YiGA
         018d8UsfB8iQALCBSEg784onShUChfgsFC/hFsSGzxlKXk1z4xMkZVeaA88E1uLipxP0
         IlNYPuPWuMe8MQLbLNZ3OJMDf3CsA3oxOjCvsYTjnBEHxfkVUi0wxhmFVuitN3tO1b0z
         gdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803690; x=1721408490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLefymYBmXT6JRGt/rz6i03hx4/br+A6fWBCFOJPqqY=;
        b=WlxEZiPBmYvFHqJl7dHQOrJSPQKHNEuA42QYWXLp2UDR2UxYl34uH2AZfKgZI6cn++
         BGIZ5PNzMcv6RlnThOVj8/1JlueXRVnVD1eMuvz/i7UZyDUstYe1ObXCEokmoKpnIRG2
         gQuKvWQXETivbPDnD/ghTEYcaQe3K0wqNvfRDTv6x4G2V5W4f2cQtzcAH0S+XOvMQEHv
         KmSjxLqfTd3E/U26nKgPxkHLz0d2YPtBH3rSRsHvPoOinYsccYQNoKFYsO87Op0FLlsl
         jGZVgwkkyi+f3/DECDJfZ7xsK5O5XULCggvvYGcKAmeEToyJF8AwEWUh7sK2VK3vzg84
         lvxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbSdOVdKPeIMsJGAGPDBfgtt6S/HNB5f35WpPzkyfu4+DrNvTAA0fXQ68sQGOJGHLjP4Xy9khSZwl0weEctDzX1CtG
X-Gm-Message-State: AOJu0YwpvU+7Ic+SCH0OifiyZoOhaqTnTb+yzbPbxZiBAfr+8sbVa4/X
	1+77o+JhCiOcPfwHm9MwqoadR+A8/r7I0ao+UEZlY9nJkQEeFkxsUq3uq0pUGhiL8+HXot7oU0N
	ap52VbT1yVQ==
X-Google-Smtp-Source: AGHT+IGmoS0wFSTyq42rNb9s8Sa7gNvWrt/+iS9kYwcQcp6CEEUakdBFKNvwNThuXyaWVj/Pb47/G/lt1+tIwQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:adf:e692:0:b0:367:9b1f:c59b with SMTP id
 ffacd0b85a97d-367ceac4433mr15745f8f.9.1720803689929; Fri, 12 Jul 2024
 10:01:29 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:31 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-13-144b319a40d8@google.com>
Subject: [PATCH 13/26] mm: asi: Functions to map/unmap a memory range into ASI
 page tables
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

From: Junaid Shahid <junaids@google.com>

Two functions, asi_map() and asi_map_gfp(), are added to allow mapping
memory into ASI page tables. The mapping will be identical to the one
for the same virtual address in the unrestricted page tables. This is
necessary to allow switching between the page tables at any arbitrary
point in the kernel.

Another function, asi_unmap() is added to allow unmapping memory mapped
via asi_map*

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h |   5 +
 arch/x86/mm/asi.c          | 238 ++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/mm/tlb.c          |   5 +
 include/asm-generic/asi.h  |  13 +++
 include/linux/pgtable.h    |   3 +
 mm/internal.h              |   2 +
 mm/vmalloc.c               |  32 +++---
 7 files changed, 284 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 1a19a925300c9..9aad843eb6dfa 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -135,6 +135,11 @@ void asi_relax(void);
 /* Immediately exit the restricted address space if in it */
 void asi_exit(void);
 
+int  asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags);
+int  asi_map(struct asi *asi, void *addr, size_t len);
+void asi_unmap(struct asi *asi, void *addr, size_t len);
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len);
+
 static inline void asi_init_thread_state(struct thread_struct *thread)
 {
 	thread->asi_state.intr_nest_depth = 0;
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 8798aab667489..e43b206450ad9 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -9,6 +9,9 @@
 #include <asm/cmdline.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
+#include <asm/traps.h>
+
+#include "../../../mm/internal.h"
 
 static struct asi_class asi_class[ASI_MAX_NUM];
 static DEFINE_SPINLOCK(asi_class_lock);
@@ -98,7 +101,6 @@ EXPORT_SYMBOL_GPL(asi_unregister_class);
  */
 static_assert(!IS_ENABLED(CONFIG_PARAVIRT));
 #define DEFINE_ASI_PGTBL_ALLOC(base, level)				\
-__maybe_unused								\
 static level##_t * asi_##level##_alloc(struct asi *asi,			\
 				       base##_t *base, ulong addr,	\
 				       gfp_t flags)			\
@@ -338,3 +340,237 @@ void asi_init_mm_state(struct mm_struct *mm)
 	memset(mm->asi, 0, sizeof(mm->asi));
 	mutex_init(&mm->asi_init_lock);
 }
+
+static bool is_page_within_range(unsigned long addr, unsigned long page_size,
+				 unsigned long range_start, unsigned long range_end)
+{
+	unsigned long page_start = ALIGN_DOWN(addr, page_size);
+	unsigned long page_end = page_start + page_size;
+
+	return page_start >= range_start && page_end <= range_end;
+}
+
+static bool follow_physaddr(
+	pgd_t *pgd_table, unsigned long virt,
+	phys_addr_t *phys, unsigned long *page_size, ulong *flags)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	/* This may be written using lookup_address_in_*, see kcl/675039. */
+
+	*page_size = PGDIR_SIZE;
+	pgd = pgd_offset_pgd(pgd_table, virt);
+	if (!pgd_present(*pgd))
+		return false;
+	if (pgd_leaf(*pgd)) {
+		*phys = PFN_PHYS(pgd_pfn(*pgd)) | (virt & ~PGDIR_MASK);
+		*flags = pgd_flags(*pgd);
+		return true;
+	}
+
+	*page_size = P4D_SIZE;
+	p4d = p4d_offset(pgd, virt);
+	if (!p4d_present(*p4d))
+		return false;
+	if (p4d_leaf(*p4d)) {
+		*phys = PFN_PHYS(p4d_pfn(*p4d)) | (virt & ~P4D_MASK);
+		*flags = p4d_flags(*p4d);
+		return true;
+	}
+
+	*page_size = PUD_SIZE;
+	pud = pud_offset(p4d, virt);
+	if (!pud_present(*pud))
+		return false;
+	if (pud_leaf(*pud)) {
+		*phys = PFN_PHYS(pud_pfn(*pud)) | (virt & ~PUD_MASK);
+		*flags = pud_flags(*pud);
+		return true;
+	}
+
+	*page_size = PMD_SIZE;
+	pmd = pmd_offset(pud, virt);
+	if (!pmd_present(*pmd))
+		return false;
+	if (pmd_leaf(*pmd)) {
+		*phys = PFN_PHYS(pmd_pfn(*pmd)) | (virt & ~PMD_MASK);
+		*flags = pmd_flags(*pmd);
+		return true;
+	}
+
+	*page_size = PAGE_SIZE;
+	pte = pte_offset_map(pmd, virt);
+	if (!pte)
+		return false;
+
+	if (!pte_present(*pte)) {
+		pte_unmap(pte);
+		return false;
+	}
+
+	*phys = PFN_PHYS(pte_pfn(*pte)) | (virt & ~PAGE_MASK);
+	*flags = pte_flags(*pte);
+
+	pte_unmap(pte);
+	return true;
+}
+
+/*
+ * Map the given range into the ASI page tables. The source of the mapping is
+ * the regular unrestricted page tables. Can be used to map any kernel memory.
+ *
+ * The caller MUST ensure that the source mapping will not change during this
+ * function. For dynamic kernel memory, this is generally ensured by mapping the
+ * memory within the allocator.
+ *
+ * If this fails, it may leave partial mappings behind. You must asi_unmap them,
+ * bearing in mind asi_unmap's requirements on the calling context. Part of the
+ * reason for this is that we don't want to unexpectedly undo mappings that
+ * weren't created by the present caller.
+ *
+ * If the source mapping is a large page and the range being mapped spans the
+ * entire large page, then it will be mapped as a large page in the ASI page
+ * tables too. If the range does not span the entire huge page, then it will be
+ * mapped as smaller pages. In that case, the implementation is slightly
+ * inefficient, as it will walk the source page tables again for each small
+ * destination page, but that should be ok for now, as usually in such cases,
+ * the range would consist of a small-ish number of pages.
+ *
+ * Note that upstream
+ * (https://lore.kernel.org/all/20210317155843.c15e71f966f1e4da508dea04@linux-foundation.org/)
+ * vmap_p4d_range supports huge mappings. It is probably possible to use that
+ * logic instead of custom mapping duplication logic in later versions of ASI.
+ */
+int __must_check asi_map_gfp(struct asi *asi, void *addr, unsigned long len, gfp_t gfp_flags)
+{
+	unsigned long virt;
+	unsigned long start = (size_t)addr;
+	unsigned long end = start + len;
+	unsigned long page_size;
+
+	if (!static_asi_enabled())
+		return 0;
+
+	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
+	VM_BUG_ON(!IS_ALIGNED(len, PAGE_SIZE));
+	VM_BUG_ON(!fault_in_kernel_space(start)); /* Misnamed, ignore "fault_" */
+
+	gfp_flags &= GFP_RECLAIM_MASK;
+
+	if (asi->mm != &init_mm)
+		gfp_flags |= __GFP_ACCOUNT;
+
+	for (virt = start; virt < end; virt = ALIGN(virt + 1, page_size)) {
+		pgd_t *pgd;
+		p4d_t *p4d;
+		pud_t *pud;
+		pmd_t *pmd;
+		pte_t *pte;
+		phys_addr_t phys;
+		ulong flags;
+
+		if (!follow_physaddr(asi->mm->pgd, virt, &phys, &page_size, &flags))
+			continue;
+
+#define MAP_AT_LEVEL(base, BASE, level, LEVEL) {				\
+			if (base##_leaf(*base)) {				\
+				if (WARN_ON_ONCE(PHYS_PFN(phys & BASE##_MASK) !=\
+						 base##_pfn(*base)))		\
+					return -EBUSY;				\
+				continue;					\
+			}							\
+										\
+			level = asi_##level##_alloc(asi, base, virt, gfp_flags);\
+			if (!level)						\
+				return -ENOMEM;					\
+										\
+			if (page_size >= LEVEL##_SIZE &&			\
+			    (level##_none(*level) || level##_leaf(*level)) &&	\
+			    is_page_within_range(virt, LEVEL##_SIZE,		\
+						 start, end)) {			\
+				page_size = LEVEL##_SIZE;			\
+				phys &= LEVEL##_MASK;				\
+										\
+				if (!level##_none(*level)) {			\
+					if (WARN_ON_ONCE(level##_pfn(*level) != \
+							 PHYS_PFN(phys))) {	\
+						return -EBUSY;			\
+					}					\
+				} else {					\
+					set_##level(level,			\
+						    __##level(phys | flags));	\
+				}						\
+				continue;					\
+			}							\
+		}
+
+		pgd = pgd_offset_pgd(asi->pgd, virt);
+
+		MAP_AT_LEVEL(pgd, PGDIR, p4d, P4D);
+		MAP_AT_LEVEL(p4d, P4D, pud, PUD);
+		MAP_AT_LEVEL(pud, PUD, pmd, PMD);
+		/*
+		 * If a large page is going to be partially mapped
+		 * in 4k pages, convert the PSE/PAT bits.
+		 */
+		if (page_size >= PMD_SIZE)
+			flags = protval_large_2_4k(flags);
+		MAP_AT_LEVEL(pmd, PMD, pte, PAGE);
+
+		VM_BUG_ON(true); /* Should never reach here. */
+	}
+
+	return 0;
+#undef MAP_AT_LEVEL
+}
+
+int __must_check asi_map(struct asi *asi, void *addr, unsigned long len)
+{
+	return asi_map_gfp(asi, addr, len, GFP_KERNEL);
+}
+
+/*
+ * Unmap a kernel address range previously mapped into the ASI page tables.
+ *
+ * The area being unmapped must be a whole previously mapped region (or regions)
+ * Unmapping a partial subset of a previously mapped region is not supported.
+ * That will work, but may end up unmapping more than what was asked for, if
+ * the mapping contained huge pages. A later patch will remove this limitation
+ * by splitting the huge mapping in the ASI page table in such a case. For now,
+ * vunmap_pgd_range() will just emit a warning if this situation is detected.
+ *
+ * This might sleep, and cannot be called with interrupts disabled.
+ */
+void asi_unmap(struct asi *asi, void *addr, size_t len)
+{
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	pgtbl_mod_mask mask = 0;
+
+	if (!static_asi_enabled() || !len)
+		return;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len & ~PAGE_MASK);
+	VM_BUG_ON(!fault_in_kernel_space(start)); /* Misnamed, ignore "fault_" */
+
+	vunmap_pgd_range(asi->pgd, start, end, &mask);
+
+	/* We don't support partial unmappings - b/270310049 */
+	if (mask & PGTBL_P4D_MODIFIED) {
+		VM_WARN_ON(!IS_ALIGNED((ulong)addr, P4D_SIZE));
+		VM_WARN_ON(!IS_ALIGNED((ulong)len, P4D_SIZE));
+	} else if (mask & PGTBL_PUD_MODIFIED) {
+		VM_WARN_ON(!IS_ALIGNED((ulong)addr, PUD_SIZE));
+		VM_WARN_ON(!IS_ALIGNED((ulong)len, PUD_SIZE));
+	} else if (mask & PGTBL_PMD_MODIFIED) {
+		VM_WARN_ON(!IS_ALIGNED((ulong)addr, PMD_SIZE));
+		VM_WARN_ON(!IS_ALIGNED((ulong)len, PMD_SIZE));
+	}
+
+	asi_flush_tlb_range(asi, addr, len);
+}
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index e80cd67a5239e..36087d6238e6f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1026,6 +1026,11 @@ inline_or_noinstr u16 asi_pcid(struct asi *asi, u16 asid)
 	return kern_pcid(asid) | ((asi->index + 1) << ASI_PCID_BITS_SHIFT);
 }
 
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
+{
+	flush_tlb_kernel_range((ulong)addr, (ulong)addr + len);
+}
+
 #else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 
 u16 asi_pcid(struct asi *asi, u16 asid) { return kern_pcid(asid); }
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index fa0bbf899a094..3956f995fe6a1 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_GENERIC_ASI_H
 #define __ASM_GENERIC_ASI_H
 
+#include <linux/types.h>
+
 #ifndef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
 
 #define ASI_MAX_NUM_ORDER		0
@@ -58,6 +60,17 @@ static inline int asi_intr_nest_depth(void) { return 0; }
 
 static inline void asi_intr_exit(void) { }
 
+static inline int asi_map(struct asi *asi, void *addr, size_t len)
+{
+	return 0;
+}
+
+static inline
+void asi_unmap(struct asi *asi, void *addr, size_t len) { }
+
+static inline
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
+
 #define static_asi_enabled() false
 
 static inline void asi_check_boottime_disable(void) { }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 85fc7554cd52b..4884dfc6e699b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1788,6 +1788,9 @@ typedef unsigned int pgtbl_mod_mask;
 #ifndef pmd_leaf
 #define pmd_leaf(x)	false
 #endif
+#ifndef pte_leaf
+#define pte_leaf(x)	1
+#endif
 
 #ifndef pgd_leaf_size
 #define pgd_leaf_size(x) (1ULL << PGDIR_SHIFT)
diff --git a/mm/internal.h b/mm/internal.h
index 07ad2675a88b4..8a8f98e119dfa 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -217,6 +217,8 @@ void unmap_page_range(struct mmu_gather *tlb,
 void page_cache_ra_order(struct readahead_control *, struct file_ra_state *,
 		unsigned int order);
 void force_page_cache_ra(struct readahead_control *, unsigned long nr);
+void vunmap_pgd_range(pgd_t *pgd_table, unsigned long addr, unsigned long end,
+		      pgtbl_mod_mask *mask);
 static inline void force_page_cache_readahead(struct address_space *mapping,
 		struct file *file, pgoff_t index, unsigned long nr_to_read)
 {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 125427cbdb87b..7a8daf5afb7cc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -419,6 +419,24 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 	} while (p4d++, addr = next, addr != end);
 }
 
+void vunmap_pgd_range(pgd_t *pgd_table, unsigned long addr, unsigned long end,
+		      pgtbl_mod_mask *mask)
+{
+	unsigned long next;
+	pgd_t *pgd = pgd_offset_pgd(pgd_table, addr);
+
+	BUG_ON(addr >= end);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_bad(*pgd))
+			*mask |= PGTBL_PGD_MODIFIED;
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		vunmap_p4d_range(pgd, addr, next, mask);
+	} while (pgd++, addr = next, addr != end);
+}
+
 /*
  * vunmap_range_noflush is similar to vunmap_range, but does not
  * flush caches or TLBs.
@@ -433,21 +451,9 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
  */
 void __vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	unsigned long next;
-	pgd_t *pgd;
-	unsigned long addr = start;
 	pgtbl_mod_mask mask = 0;
 
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_bad(*pgd))
-			mask |= PGTBL_PGD_MODIFIED;
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		vunmap_p4d_range(pgd, addr, next, &mask);
-	} while (pgd++, addr = next, addr != end);
+	vunmap_pgd_range(init_mm.pgd, start, end, &mask);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);

-- 
2.45.2.993.g49e7a77208-goog


