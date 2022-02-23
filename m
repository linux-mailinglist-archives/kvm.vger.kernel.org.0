Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAD24C0BF7
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiBWF0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiBWFZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E8F6C96F
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:42 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so26693279ybg.8
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KctzOijb2lPzQRsVweA+t5lqX+AMon2xx7uJ8sEe3V0=;
        b=o6x+fXjXHT+YmW/ZEagw0M3GAQliRWz6GkGaqA4u+vbUpzhuqjZg6dpP5meVpt0ROf
         kKIgOplxmZwcy8fpFEZTWPlgRlLYr6BEMXfWuy6EkVszZL1eiXWI04tPu/Bave36tyh0
         Pg/rLhImfsoHjz3O2aw8506JPbQ7x/tOlKAxNgPJdEMnSjZ93q2iD4DVERcopQg4JNYp
         GNKE8XJSp9XzGQ0dIwkM6cgZOM8UkwzVOfAn0JxbE5VvBEVsLLUtWn7Lc0a3H+tJ18Mo
         xFRsJWo21wVW8cCrGTePkWMS8ReiZ3Pptclz1bJcEt4nXmu0gRlgbulAgKKuDIl4DXV3
         55IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KctzOijb2lPzQRsVweA+t5lqX+AMon2xx7uJ8sEe3V0=;
        b=b0dafnJfQzJ7ON/oc58L74POSE18JKy2EqdjuCAinNx0YzREmZUVrdq3Qi+H/kQcr9
         dtfN+cJFsgKrWX0slOf/020Vn2m/h2/xkHbZUr8gm6NphM57zVZD6FLxFrHF/hrpNzBm
         PjM2f4u+IAfp9OSpza2lIlqJGfPS6VYHROupRMQNPNdRH1WvHI+4BuSzEqA17KjGvUnu
         5Ohx9+tXij5wORbSxH65FgqUtvTgkq6vyvf+vZ7tcB37pYPuZRXfQFML3eP2ymHJNyN7
         7DxofBv5H0ohVIdB/hutN5UM+LUkmenDWld7dEcM5tnq6AsCuQlZLS44exWD6lOsU5nM
         GPbg==
X-Gm-Message-State: AOAM531gPXphyXnMfE6N91Ef27tOg3/6x7Ei914kkIZYMBad+6tLqPAn
        kmDQHk01OQtSYS/FT45QRTOkP6duztCq
X-Google-Smtp-Source: ABdhPJz4jScT7T8fgZ/6SCKV/MEmg4Vf6MpNhLflLFYdfY4h7Ie3CFO275rWWB7jrjHpkdQgBhPjBxZoyl00
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:d90b:0:b0:61d:e8c7:82ff with SMTP id
 q11-20020a25d90b000000b0061de8c782ffmr26287345ybg.171.1645593870304; Tue, 22
 Feb 2022 21:24:30 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:56 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-21-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 20/47] mm: asi: Support for locally non-sensitive vmalloc allocations
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new flag, VM_LOCAL_NONSENSITIVE is added to designate locally
non-sensitive vmalloc/vmap areas. When using the __vmalloc /
__vmalloc_node APIs, if the corresponding GFP flag is specified, the
VM flag is automatically added. When using the __vmalloc_node_range API,
either flag can be specified independently. The VM flag will only map
the vmalloc area as non-sensitive, while the GFP flag will only map the
underlying direct map area as non-sensitive.

When using the __vmalloc_node_range API, instead of VMALLOC_START/END,
VMALLOC_LOCAL_NONSENSITIVE_START/END should be used. This is the range
that will have different ASI page tables for each process, thereby
providing the local mapping.

A command line parameter vmalloc_local_nonsensitive_percent is added to
specify the approximate division between the per-process and global
vmalloc ranges. Note that regular/sensitive vmalloc/vmap allocations
are not restricted by this division and can go anywhere in the entire
vmalloc range. The division only applies to non-sensitive allocations.

Since no attempt is made to balance regular/sensitive allocations across
the division, it is possible that one of these ranges gets filled up
by regular allocations, leaving no room for the non-sensitive
allocations for which that range was designated. But since the vmalloc
range is fairly large, so hopefully that will not be a problem in
practice. If that assumption turns out to be incorrect, we could
implement a more sophisticated scheme.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h              |  2 +
 arch/x86/include/asm/page_64.h          |  2 +
 arch/x86/include/asm/pgtable_64_types.h |  7 ++-
 arch/x86/mm/asi.c                       | 57 ++++++++++++++++++
 include/asm-generic/asi.h               |  5 ++
 include/linux/vmalloc.h                 |  6 ++
 mm/vmalloc.c                            | 78 ++++++++++++++++++++-----
 7 files changed, 142 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index f11010c0334b..e3cbf6d8801e 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -46,6 +46,8 @@ DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
 
 extern pgd_t asi_global_nonsensitive_pgd[];
 
+void asi_vmalloc_init(void);
+
 int  asi_init_mm_state(struct mm_struct *mm);
 void asi_free_mm_state(struct mm_struct *mm);
 
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 2845eca02552..b17574349572 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -18,6 +18,8 @@ extern unsigned long vmemmap_base;
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 
+extern unsigned long vmalloc_global_nonsensitive_start;
+extern unsigned long vmalloc_local_nonsensitive_end;
 extern unsigned long asi_local_map_base;
 DECLARE_STATIC_KEY_FALSE(asi_local_map_initialized);
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 0fc380ba25b8..06793f7ef1aa 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -142,8 +142,13 @@ extern unsigned int ptrs_per_p4d;
 #define VMALLOC_END		(VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1)
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
-#define VMALLOC_GLOBAL_NONSENSITIVE_START	VMALLOC_START
+
+#define VMALLOC_LOCAL_NONSENSITIVE_START	VMALLOC_START
+#define VMALLOC_LOCAL_NONSENSITIVE_END		vmalloc_local_nonsensitive_end
+
+#define VMALLOC_GLOBAL_NONSENSITIVE_START	vmalloc_global_nonsensitive_start
 #define VMALLOC_GLOBAL_NONSENSITIVE_END		VMALLOC_END
+
 #endif
 
 #define MODULES_VADDR		(__START_KERNEL_map + KERNEL_IMAGE_SIZE)
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 3ba0971a318d..91e5ff1224ff 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/memcontrol.h>
+#include <linux/moduleparam.h>
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
@@ -28,6 +29,17 @@ EXPORT_SYMBOL(asi_local_map_initialized);
 unsigned long asi_local_map_base __ro_after_init;
 EXPORT_SYMBOL(asi_local_map_base);
 
+unsigned long vmalloc_global_nonsensitive_start __ro_after_init;
+EXPORT_SYMBOL(vmalloc_global_nonsensitive_start);
+
+unsigned long vmalloc_local_nonsensitive_end __ro_after_init;
+EXPORT_SYMBOL(vmalloc_local_nonsensitive_end);
+
+/* Approximate percent only. Rounded to PGDIR_SIZE boundary. */
+static uint vmalloc_local_nonsensitive_percent __ro_after_init = 50;
+core_param(vmalloc_local_nonsensitive_percent,
+	   vmalloc_local_nonsensitive_percent, uint, 0444);
+
 int asi_register_class(const char *name, uint flags,
 		       const struct asi_hooks *ops)
 {
@@ -307,6 +319,10 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 		     i++)
 			set_pgd(asi->pgd + i, mm->asi[0].pgd[i]);
 
+		for (i = pgd_index(VMALLOC_LOCAL_NONSENSITIVE_START);
+		     i <= pgd_index(VMALLOC_LOCAL_NONSENSITIVE_END); i++)
+			set_pgd(asi->pgd + i, mm->asi[0].pgd[i]);
+
 		for (i = pgd_index(VMALLOC_GLOBAL_NONSENSITIVE_START);
 		     i < PTRS_PER_PGD; i++)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
@@ -432,6 +448,10 @@ void asi_free_mm_state(struct mm_struct *mm)
 			   pgd_index(ASI_LOCAL_MAP +
 				     PFN_PHYS(max_possible_pfn)) + 1);
 
+	asi_free_pgd_range(&mm->asi[0],
+			   pgd_index(VMALLOC_LOCAL_NONSENSITIVE_START),
+			   pgd_index(VMALLOC_LOCAL_NONSENSITIVE_END) + 1);
+
 	free_page((ulong)mm->asi[0].pgd);
 }
 
@@ -671,3 +691,40 @@ void asi_sync_mapping(struct asi *asi, void *start, size_t len)
 		for (; addr < end; addr = pgd_addr_end(addr, end))
 			asi_clone_pgd(asi->pgd, asi->mm->asi[0].pgd, addr);
 }
+
+void __init asi_vmalloc_init(void)
+{
+	uint start_index = pgd_index(VMALLOC_START);
+	uint end_index = pgd_index(VMALLOC_END);
+	uint global_start_index;
+
+	if (!boot_cpu_has(X86_FEATURE_ASI)) {
+		vmalloc_global_nonsensitive_start = VMALLOC_START;
+		vmalloc_local_nonsensitive_end = VMALLOC_END;
+		return;
+	}
+
+	if (vmalloc_local_nonsensitive_percent == 0) {
+		vmalloc_local_nonsensitive_percent = 1;
+		pr_warn("vmalloc_local_nonsensitive_percent must be non-zero");
+	}
+
+	if (vmalloc_local_nonsensitive_percent >= 100) {
+		vmalloc_local_nonsensitive_percent = 99;
+		pr_warn("vmalloc_local_nonsensitive_percent must be less than 100");
+	}
+
+	global_start_index = start_index + (end_index - start_index) *
+			     vmalloc_local_nonsensitive_percent / 100;
+	global_start_index = max(global_start_index, start_index + 1);
+
+	vmalloc_global_nonsensitive_start = -(PTRS_PER_PGD - global_start_index)
+					    * PGDIR_SIZE;
+	vmalloc_local_nonsensitive_end = vmalloc_global_nonsensitive_start - 1;
+
+	pr_debug("vmalloc_global_nonsensitive_start = %llx",
+		 vmalloc_global_nonsensitive_start);
+
+	VM_BUG_ON(vmalloc_local_nonsensitive_end >= VMALLOC_END);
+	VM_BUG_ON(vmalloc_global_nonsensitive_start <= VMALLOC_START);
+}
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index a1c8ebff70e8..7c50d8b64fa4 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -18,6 +18,9 @@
 #define VMALLOC_GLOBAL_NONSENSITIVE_START	VMALLOC_START
 #define VMALLOC_GLOBAL_NONSENSITIVE_END		VMALLOC_END
 
+#define VMALLOC_LOCAL_NONSENSITIVE_START	VMALLOC_START
+#define VMALLOC_LOCAL_NONSENSITIVE_END		VMALLOC_END
+
 #ifndef _ASSEMBLY_
 
 struct asi_hooks {};
@@ -36,6 +39,8 @@ static inline int asi_init_mm_state(struct mm_struct *mm) { return 0; }
 
 static inline void asi_free_mm_state(struct mm_struct *mm) { }
 
+static inline void asi_vmalloc_init(void) { }
+
 static inline
 int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 {
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 5f85690f27b6..2b4eafc21fa5 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -41,8 +41,10 @@ struct notifier_block;		/* in notifier.h */
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 #define VM_GLOBAL_NONSENSITIVE	0x00000800	/* Similar to __GFP_GLOBAL_NONSENSITIVE */
+#define VM_LOCAL_NONSENSITIVE	0x00001000	/* Similar to __GFP_LOCAL_NONSENSITIVE */
 #else
 #define VM_GLOBAL_NONSENSITIVE	0
+#define VM_LOCAL_NONSENSITIVE	0
 #endif
 
 /* bits [20..32] reserved for arch specific ioremap internals */
@@ -67,6 +69,10 @@ struct vm_struct {
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* Valid if flags contain VM_*_NONSENSITIVE */
+	struct asi		*asi;
+#endif
 };
 
 struct vmap_area {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f13bfe7e896b..ea94d8a1e2e9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2391,18 +2391,25 @@ void __init vmalloc_init(void)
 	 */
 	vmap_init_free_space();
 	vmap_initialized = true;
+
+	asi_vmalloc_init();
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
 static int asi_map_vm_area(struct vm_struct *area)
 {
 	if (!static_asi_enabled())
 		return 0;
 
 	if (area->flags & VM_GLOBAL_NONSENSITIVE)
-		return asi_map(ASI_GLOBAL_NONSENSITIVE, area->addr,
-			       get_vm_area_size(area));
+		area->asi = ASI_GLOBAL_NONSENSITIVE;
+	else if (area->flags & VM_LOCAL_NONSENSITIVE)
+		area->asi = ASI_LOCAL_NONSENSITIVE;
+	else
+		return 0;
 
-	return 0;
+	return asi_map(area->asi, area->addr, get_vm_area_size(area));
 }
 
 static void asi_unmap_vm_area(struct vm_struct *area)
@@ -2415,11 +2422,17 @@ static void asi_unmap_vm_area(struct vm_struct *area)
 	 * the case when the existing flush from try_purge_vmap_area_lazy()
 	 * and/or vm_unmap_aliases() happens non-lazily.
 	 */
-	if (area->flags & VM_GLOBAL_NONSENSITIVE)
-		asi_unmap(ASI_GLOBAL_NONSENSITIVE, area->addr,
-			  get_vm_area_size(area), true);
+	if (area->flags & (VM_GLOBAL_NONSENSITIVE | VM_LOCAL_NONSENSITIVE))
+		asi_unmap(area->asi, area->addr, get_vm_area_size(area), true);
 }
 
+#else
+
+static inline int asi_map_vm_area(struct vm_struct *area) { return 0; }
+static inline void asi_unmap_vm_area(struct vm_struct *area) { }
+
+#endif
+
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
@@ -2463,6 +2476,15 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	if (unlikely(!size))
 		return NULL;
 
+	if (static_asi_enabled()) {
+		VM_BUG_ON((flags & VM_LOCAL_NONSENSITIVE) &&
+			  !(start >= VMALLOC_LOCAL_NONSENSITIVE_START &&
+			    end <= VMALLOC_LOCAL_NONSENSITIVE_END));
+
+		VM_BUG_ON((flags & VM_GLOBAL_NONSENSITIVE) &&
+			  start < VMALLOC_GLOBAL_NONSENSITIVE_START);
+	}
+
 	if (flags & VM_IOREMAP)
 		align = 1ul << clamp_t(int, get_count_order_long(size),
 				       PAGE_SHIFT, IOREMAP_MAX_ORDER);
@@ -3073,8 +3095,22 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (WARN_ON_ONCE(!size))
 		return NULL;
 
-	if (static_asi_enabled() && (vm_flags & VM_GLOBAL_NONSENSITIVE))
-		gfp_mask |= __GFP_ZERO;
+	if (static_asi_enabled()) {
+		VM_BUG_ON((vm_flags & (VM_LOCAL_NONSENSITIVE |
+				       VM_GLOBAL_NONSENSITIVE)) ==
+			  (VM_LOCAL_NONSENSITIVE | VM_GLOBAL_NONSENSITIVE));
+
+		if ((vm_flags & VM_LOCAL_NONSENSITIVE) &&
+		    !mm_asi_enabled(current->mm)) {
+			vm_flags &= ~VM_LOCAL_NONSENSITIVE;
+
+			if (end == VMALLOC_LOCAL_NONSENSITIVE_END)
+				end = VMALLOC_END;
+		}
+
+		if (vm_flags & (VM_GLOBAL_NONSENSITIVE | VM_LOCAL_NONSENSITIVE))
+			gfp_mask |= __GFP_ZERO;
+	}
 
 	if ((size >> PAGE_SHIFT) > totalram_pages()) {
 		warn_alloc(gfp_mask, NULL,
@@ -3166,11 +3202,19 @@ void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, int node, const void *caller)
 {
 	ulong vm_flags = 0;
+	ulong start = VMALLOC_START, end = VMALLOC_END;
 
-	if (static_asi_enabled() && (gfp_mask & __GFP_GLOBAL_NONSENSITIVE))
-		vm_flags |= VM_GLOBAL_NONSENSITIVE;
+	if (static_asi_enabled()) {
+		if (gfp_mask & __GFP_GLOBAL_NONSENSITIVE) {
+			vm_flags |= VM_GLOBAL_NONSENSITIVE;
+			start = VMALLOC_GLOBAL_NONSENSITIVE_START;
+		} else if (gfp_mask & __GFP_LOCAL_NONSENSITIVE) {
+			vm_flags |= VM_LOCAL_NONSENSITIVE;
+			end = VMALLOC_LOCAL_NONSENSITIVE_END;
+		}
+	}
 
-	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
+	return __vmalloc_node_range(size, align, start, end,
 				gfp_mask, PAGE_KERNEL, vm_flags, node, caller);
 }
 /*
@@ -3678,9 +3722,15 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	/* verify parameters and allocate data structures */
 	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
 
-	if (static_asi_enabled() && (flags & VM_GLOBAL_NONSENSITIVE)) {
-		vmalloc_start = VMALLOC_GLOBAL_NONSENSITIVE_START;
-		vmalloc_end = VMALLOC_GLOBAL_NONSENSITIVE_END;
+	if (static_asi_enabled()) {
+		VM_BUG_ON((flags & (VM_LOCAL_NONSENSITIVE |
+				    VM_GLOBAL_NONSENSITIVE)) ==
+			  (VM_LOCAL_NONSENSITIVE | VM_GLOBAL_NONSENSITIVE));
+
+		if (flags & VM_GLOBAL_NONSENSITIVE)
+			vmalloc_start = VMALLOC_GLOBAL_NONSENSITIVE_START;
+		else if (flags & VM_LOCAL_NONSENSITIVE)
+			vmalloc_end = VMALLOC_LOCAL_NONSENSITIVE_END;
 	}
 
 	vmalloc_start = ALIGN(vmalloc_start, align);
-- 
2.35.1.473.g83b2b277ed-goog

