Return-Path: <kvm+bounces-21554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F069B92FEFE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FF531F2357C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E4317C7D3;
	Fri, 12 Jul 2024 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CuGiG1m4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DBC17C7B6
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803702; cv=none; b=ELJjKZhMu3Ht5jEj5iZXbl0AmDxjUiNk+Q4c2VCInYOPbFVClFvJGpyhSg3EXZ+thiwtTRA02mHnzAAeMh6lBZJ0vxQkosGAEkytIF6GcmXjNuv1GlG1j0xqTDsxqLj6Vy7u+dm45B+9PBqx/008ick3cbKLXBKgcXtXX+3Kd4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803702; c=relaxed/simple;
	bh=pTXcmnTga+Jc6ez8CkNFqLYlbuHN6bbyvm/QWL3+3+8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCpkeaJ6FdjeSEqjpNP1YRqyKRtz076pRSx+Bsq2K+mCv7VqqhwjHSY7G3BByIWzKmrCncplXWm9vxz1hL0OMAZSnGLmmpADkYuQz8EKL/7hWO6cxj8WvsA2eDm8nwIZ7c5xIhQNMG6mAserZztuLs1wgf9sMEUv3C6w8xVh0qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CuGiG1m4; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-36793373454so1384018f8f.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803699; x=1721408499; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tuve7JnQEpqqfaMLOqszce9B8olVou/+ZFnfWaWBcIQ=;
        b=CuGiG1m4fOCxF522E/LffzR4MHhnjoQKhJOF9fv/eLZ3rjSdNqdIkXej5+QLMbvXfa
         VMffGza/vDTmAN4GcCjSuHGxq/9wHt4PdngbvFP41Y6JtYd3FMuj4JiAbYyZkOFsJPF7
         o/t3YDaYmfuQbSTgEehtq9K8/38ZtYJSPm7cAIAGgJ3IlB9fuxyBju6W+BStl0zPLqBO
         qZeRUyn7pXMkccb9udkdrjLeoQRoyePXQRoKKt+8CFB6isfLqugCgQEfJM95NcNQB8GI
         n6fWRzxiDXaLIA9EjLeRB98Z+83SGWR9QG1mVI3ZW7bq5z+3jg9/y8aA9FNK9GtW0WE7
         DLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803699; x=1721408499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tuve7JnQEpqqfaMLOqszce9B8olVou/+ZFnfWaWBcIQ=;
        b=ni8v+EuMs/Pm+NlYn69Bwawz9jvJJmKRrzOm8h4me78LRzv0ierpx6GgwUXer8pTCA
         AwclguEsMCRqKs+7Woz4zM3YZe8usc97XF3oLLs8zP53n5LgPJh5dkBYjmp412uAJDgs
         hvuc4nwmGpWQt+1pMu8/DiSJQqQ3U0xAB7SFJ+2BRFB3UTCrqkxxznDlWCn8/RmV1xI7
         NFQW0ZlpBhF8mvfeYEZ/lD8g0SVzBV/obHiEeHSphWH0e9MomzguvPcAS/B/q/jOKGNv
         4y+C7VUFmOHOV3/WAtfJ4m3skr3ASa+jKiWrknvkt9YTd9i8jdkGlk6wEj5s9tX1k8jl
         EWjw==
X-Forwarded-Encrypted: i=1; AJvYcCXccz5Bw8A6WLeHAXw+X9sTm2LRMA4I7BugMYAyiKy2HtCyTemO1Fmh2gK8ygAyGcqGJm7p7W9wq0selzLVGMMC3bGr
X-Gm-Message-State: AOJu0YymDwEtqATq+lq6AiRuqt+Tiewg13l0qWAhIpfMWhKbQclkEQl5
	k6DBUOXzL4XY+YUb1IV5G2TjHtS479f2eEyk3hMPCbHk9EW6vlZahflyhrHSNft2iGcPWJc5/h5
	FduBc2J8MLQ==
X-Google-Smtp-Source: AGHT+IE/LeQCdWU5upInTaAHGJKI73E8a+vH6WinMVUM+08W4ltowKkHhgsLti9XyJHiOTCwn2ccsqpZeVTo4A==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6000:14c:b0:360:727b:8b5d with SMTP
 id ffacd0b85a97d-367cea738dbmr25058f8f.6.1720803698587; Fri, 12 Jul 2024
 10:01:38 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:34 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-16-144b319a40d8@google.com>
Subject: [PATCH 16/26] mm: asi: Map non-user buddy allocations as nonsensitive
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

This is just simplest possible page_alloc patch I could come up with to
demonstrate ASI working in a "denylist" mode: we map the direct map into
the restricted address space, except pages allocated with GFP_USER.

Pages must be asi_unmap()'d before they can be re-allocated. This
requires a TLB flush, which can't generally be done from the free path
(requires IRQs on), so pages that need unmapping are freed via a
workqueue.

This solution is silly for at least the following reasons:

 - If the async queue gets long, we'll run out of allocatable memory.
 - We don't batch the TLB flushing or worker wakeups at all.
 - We drop FPI flags and skip the pcplists.

Internally at Google we've so far found with plenty of extra complexity
we're able to make the principle work for the workloads we've tested so
far, but it seems likely we'll hit a wall where tuning gets impossible.
So instead for the [PATCH] version I hope to come up with an
implementation that instead just makes the allocator more deeply aware
of sensitivity, most likely this will look a bit like an extra
"dimension" like movability etc. This was discussed at LSF/MM/BPF [1]
but I haven't made time to experiment on it yet.

With this smarter approach, it should also be possible to remove the
pageflag, as other contextual information will let us know if a page
is mapped in the restricted address space (the page tables also reflect
this status...).

[1] https://youtu.be/WD9-ey8LeiI

The main thing in here that is "real" and may warrant discussion is
__GFP_SENSITIVE (or at least, some sort of allocator switch to determine
sensitivity, in an "allowlist" model we would probably have the
opposite, and in future iterations we might want additional options for
different "types" of sensitivity). I think we need this as an extension
to the allocation API; the main alternative would be to infer from
context of the allocation whether the data should be treated as
sensitive; however I think we will have contexts where both sensitive
and nonsensitive data needs to be allocatable.

If there are concerns about __GFP flags specifically, rather than just
the general problem of expanding the allocator API, we could always just
provide an API like __alloc_pages_sensitive or something, implemented
with ALLOC_ flags internally.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/asi.c              |  33 +++++++++-
 include/linux/gfp_types.h      |  15 ++++-
 include/linux/page-flags.h     |   9 +++
 include/trace/events/mmflags.h |  12 +++-
 mm/page_alloc.c                | 143 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/builtin-kmem.c      |   1 +
 6 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 807d51497f43a..6e106f25abbb9 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -5,6 +5,8 @@
 #include <linux/spinlock.h>
 
 #include <linux/init.h>
+#include <linux/pgtable.h>
+
 #include <asm/asi.h>
 #include <asm/cmdline.h>
 #include <asm/pgalloc.h>
@@ -102,10 +104,17 @@ EXPORT_SYMBOL_GPL(asi_unregister_class);
  *    allocator from interrupts and the page allocator ultimately calls this
  *    code.
  *  - They support customizing the allocation flags.
+ *  - They avoid infinite recursion when the page allocator calls back to
+ *    asi_map
  *
  * On the other hand, they do not use the normal page allocation infrastructure,
  * that means that PTE pages do not have the PageTable type nor the PagePgtable
  * flag and we don't increment the meminfo stat (NR_PAGETABLE) as they do.
+ *
+ * As an optimisation we attempt to map the pagetables in
+ * ASI_GLOBAL_NONSENSITIVE, but this can fail, and for simplicity we don't do
+ * anything about that. This means it's invalid to access ASI pagetables from a
+ * critical section.
  */
 static_assert(!IS_ENABLED(CONFIG_PARAVIRT));
 #define DEFINE_ASI_PGTBL_ALLOC(base, level)				\
@@ -114,8 +123,11 @@ static level##_t * asi_##level##_alloc(struct asi *asi,			\
 				       gfp_t flags)			\
 {									\
 	if (unlikely(base##_none(*base))) {				\
-		ulong pgtbl = get_zeroed_page(flags);			\
+		/* Stop asi_map calls causing recursive allocation */	\
+		gfp_t pgtbl_gfp = flags | __GFP_SENSITIVE;		\
+		ulong pgtbl = get_zeroed_page(pgtbl_gfp);		\
 		phys_addr_t pgtbl_pa;					\
+		int err;						\
 									\
 		if (!pgtbl)						\
 			return NULL;					\
@@ -129,6 +141,16 @@ static level##_t * asi_##level##_alloc(struct asi *asi,			\
 		}							\
 									\
 		mm_inc_nr_##level##s(asi->mm);				\
+									\
+		err = asi_map_gfp(ASI_GLOBAL_NONSENSITIVE,		\
+				  (void *)pgtbl, PAGE_SIZE, flags);	\
+		if (err)						\
+			/* Should be rare. Spooky. */			\
+			pr_warn_ratelimited("Created sensitive ASI %s (%pK, maps %luK).\n",\
+				#level, (void *)pgtbl, addr);		\
+		else							\
+			__SetPageGlobalNonSensitive(virt_to_page(pgtbl));\
+									\
 	}								\
 out:									\
 	VM_BUG_ON(base##_leaf(*base));					\
@@ -469,6 +491,9 @@ static bool follow_physaddr(
  * reason for this is that we don't want to unexpectedly undo mappings that
  * weren't created by the present caller.
  *
+ * This must not be called from the critical section, as ASI's pagetables are
+ * not guaranteed to be mapped in the restricted address space.
+ *
  * If the source mapping is a large page and the range being mapped spans the
  * entire large page, then it will be mapped as a large page in the ASI page
  * tables too. If the range does not span the entire huge page, then it will be
@@ -492,6 +517,9 @@ int __must_check asi_map_gfp(struct asi *asi, void *addr, unsigned long len, gfp
 	if (!static_asi_enabled())
 		return 0;
 
+	/* ASI pagetables might be sensitive. */
+	WARN_ON_ONCE(asi_in_critical_section());
+
 	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
 	VM_BUG_ON(!IS_ALIGNED(len, PAGE_SIZE));
 	VM_BUG_ON(!fault_in_kernel_space(start)); /* Misnamed, ignore "fault_" */
@@ -591,6 +619,9 @@ void asi_unmap(struct asi *asi, void *addr, size_t len)
 	if (!static_asi_enabled() || !len)
 		return;
 
+	/* ASI pagetables might be sensitive. */
+	WARN_ON_ONCE(asi_in_critical_section());
+
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(len & ~PAGE_MASK);
 	VM_BUG_ON(!fault_in_kernel_space(start)); /* Misnamed, ignore "fault_" */
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 13becafe41df0..d33953a1c9b28 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -55,6 +55,7 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
+	___GFP_SENSITIVE_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -95,6 +96,11 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define ___GFP_SENSITIVE BIT(___GFP_SENSITIVE_BIT)
+#else
+#define ___GFP_SENSITIVE 0
+#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -284,6 +290,12 @@ enum {
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
+/*
+ * Allocate sensitive memory, i.e. do not map it into ASI's restricted address
+ * space.
+ */
+#define __GFP_SENSITIVE	((__force gfp_t)___GFP_SENSITIVE)
+
 /* Room for N __GFP_FOO bits */
 #define __GFP_BITS_SHIFT ___GFP_LAST_BIT
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
@@ -365,7 +377,8 @@ enum {
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM | __GFP_NOWARN)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
-#define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | \
+			 __GFP_HARDWALL | __GFP_SENSITIVE)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 57fa58899a661..d4842cd1fb59a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,6 +135,9 @@ enum pageflags {
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	PG_arch_2,
 	PG_arch_3,
+#endif
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	PG_global_nonsensitive,
 #endif
 	__NR_PAGEFLAGS,
 
@@ -642,6 +645,12 @@ FOLIO_TEST_CLEAR_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(idle, FOLIO_HEAD_PAGE)
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+__PAGEFLAG(GlobalNonSensitive, global_nonsensitive, PF_ANY);
+#else
+__PAGEFLAG_FALSE(GlobalNonSensitive, global_nonsensitive);
+#endif
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index d55e53ac91bd2..416a79fe1a66d 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -50,7 +50,8 @@
 	gfpflag_string(__GFP_RECLAIM),		\
 	gfpflag_string(__GFP_DIRECT_RECLAIM),	\
 	gfpflag_string(__GFP_KSWAPD_RECLAIM),	\
-	gfpflag_string(__GFP_ZEROTAGS)
+	gfpflag_string(__GFP_ZEROTAGS),		\
+	gfpflag_string(__GFP_SENSITIVE)
 
 #ifdef CONFIG_KASAN_HW_TAGS
 #define __def_gfpflag_names_kasan ,			\
@@ -95,6 +96,12 @@
 #define IF_HAVE_PG_ARCH_X(_name)
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define IF_HAVE_ASI(_name) ,{1UL << PG_##_name, __stringify(_name)}
+#else
+#define IF_HAVE_ASI(_name)
+#endif
+
 #define DEF_PAGEFLAG_NAME(_name) { 1UL <<  PG_##_name, __stringify(_name) }
 
 #define __def_pageflag_names						\
@@ -125,7 +132,8 @@ IF_HAVE_PG_HWPOISON(hwpoison)						\
 IF_HAVE_PG_IDLE(idle)							\
 IF_HAVE_PG_IDLE(young)							\
 IF_HAVE_PG_ARCH_X(arch_2)						\
-IF_HAVE_PG_ARCH_X(arch_3)
+IF_HAVE_PG_ARCH_X(arch_3)						\
+IF_HAVE_ASI(global_nonsensitive)
 
 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14d39f34d3367..1e71ee9ae178c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1081,6 +1081,8 @@ static void kernel_init_pages(struct page *page, int numpages)
 	kasan_enable_current();
 }
 
+static bool asi_async_free_enqueue(struct page *page, unsigned int order);
+
 __always_inline bool free_pages_prepare(struct page *page,
 			unsigned int order)
 {
@@ -1177,7 +1179,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	debug_pagealloc_unmap_pages(page, 1 << order);
 
-	return true;
+	return !asi_async_free_enqueue(page, order);
 }
 
 /*
@@ -4364,6 +4366,136 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+
+struct asi_async_free_cpu_state {
+	struct work_struct work;
+	struct list_head to_free;
+};
+static DEFINE_PER_CPU(struct asi_async_free_cpu_state, asi_async_free_cpu_state);
+
+static bool async_free_work_initialized;
+
+static void asi_async_free_work_fn(struct work_struct *work)
+{
+	struct asi_async_free_cpu_state *cpu_state =
+		container_of(work, struct asi_async_free_cpu_state, work);
+	struct page *page, *tmp;
+	struct list_head to_free = LIST_HEAD_INIT(to_free);
+
+	local_irq_disable();
+	list_splice_init(&cpu_state->to_free, &to_free);
+	local_irq_enable(); /* IRQs must be on for asi_unmap. */
+
+	/* Use _safe because __free_the_page uses .lru */
+	list_for_each_entry_safe(page, tmp, &to_free, lru) {
+		unsigned long order = page_private(page);
+
+		asi_unmap(ASI_GLOBAL_NONSENSITIVE, page_to_virt(page),
+			  PAGE_SIZE << order);
+		for (int i = 0; i < (1 << order); i++)
+			__ClearPageGlobalNonSensitive(page + i);
+
+		/*
+		 * Note weird loop-de-loop here, we might already have called
+		 * __free_pages_ok for this page, but now we've cleared
+		 * PageGlobalNonSensitive so it won't end up back on the queue
+		 * again.
+		 */
+		__free_pages_ok(page, order, FPI_NONE);
+		cond_resched();
+	}
+}
+
+/* Returns true if the page was queued for asynchronous freeing. */
+static bool asi_async_free_enqueue(struct page *page, unsigned int order)
+{
+	struct asi_async_free_cpu_state *cpu_state;
+	unsigned long flags;
+
+	if (!PageGlobalNonSensitive(page))
+		return false;
+
+	local_irq_save(flags);
+	cpu_state = this_cpu_ptr(&asi_async_free_cpu_state);
+	set_page_private(page, order);
+	list_add(&page->lru, &cpu_state->to_free);
+	local_irq_restore(flags);
+
+	return true;
+}
+
+static int __init asi_page_alloc_init(void)
+{
+	int cpu;
+
+	if (!static_asi_enabled())
+		return 0;
+
+	for_each_possible_cpu(cpu) {
+		struct asi_async_free_cpu_state *cpu_state
+			= &per_cpu(asi_async_free_cpu_state, cpu);
+
+		INIT_WORK(&cpu_state->work, asi_async_free_work_fn);
+		INIT_LIST_HEAD(&cpu_state->to_free);
+	}
+
+	/*
+	 * This function is called before SMP is initialized, so we can assume
+	 * that this is the only running CPU at this point.
+	 */
+
+	barrier();
+	async_free_work_initialized = true;
+	barrier();
+
+	return 0;
+}
+early_initcall(asi_page_alloc_init);
+
+static int asi_map_alloced_pages(struct page *page, uint order, gfp_t gfp_mask)
+{
+
+	if (!static_asi_enabled())
+		return 0;
+
+	if (!(gfp_mask & __GFP_SENSITIVE)) {
+		int err = asi_map_gfp(
+			ASI_GLOBAL_NONSENSITIVE, page_to_virt(page),
+			PAGE_SIZE * (1 << order), gfp_mask);
+		uint i;
+
+		if (err)
+			return err;
+
+		for (i = 0; i < (1 << order); i++)
+			__SetPageGlobalNonSensitive(page + i);
+	}
+
+	return 0;
+}
+
+#else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
+static inline
+int asi_map_alloced_pages(struct page *pages, uint order, gfp_t gfp_mask)
+{
+	return 0;
+}
+
+static inline
+bool asi_unmap_freed_pages(struct page *page, unsigned int order)
+{
+	return true;
+}
+
+static bool asi_async_free_enqueue(struct page *page, unsigned int order)
+{
+	return false;
+}
+
+#endif
+
 /*
  * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
  * @gfp: GFP flags for the allocation
@@ -4551,6 +4683,10 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
 		return NULL;
 
+	/* Clear out old (maybe sensitive) data before reallocating as nonsensitive. */
+	if (!static_asi_enabled() && !(gfp & __GFP_SENSITIVE))
+		gfp |= __GFP_ZERO;
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -4597,6 +4733,11 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
 
+	if (page && unlikely(asi_map_alloced_pages(page, order, gfp))) {
+		__free_pages(page, order);
+		page = NULL;
+	}
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 9714327fd0ead..912497b7b1c3f 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -682,6 +682,7 @@ static const struct {
 	{ "__GFP_RECLAIM",		"R" },
 	{ "__GFP_DIRECT_RECLAIM",	"DR" },
 	{ "__GFP_KSWAPD_RECLAIM",	"KR" },
+	{ "__GFP_SENSITIVE",		"S" },
 };
 
 static size_t max_gfp_len;

-- 
2.45.2.993.g49e7a77208-goog


