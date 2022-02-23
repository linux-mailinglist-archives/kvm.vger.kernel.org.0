Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781674C0BE6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiBWFZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbiBWFZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:37 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DE46C1F1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:37 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d306e372e5so163255917b3.5
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=orMBAJTu5bZfo+ZjtAIW/XRZfJpT6yrC1YB1ci4mdhQ=;
        b=i488SXIT1e9g9PD4iGqqQ5k0m2F8EhUxsfxeEhnLAG3wqUbodJtbO+eBa1paYhzivd
         f6qEUMrlJuQyIim27Unr9cJtD2qOlwrJ3Vb92Q7HTAPrjZK/4FZKPxvkHiWfCGgfeGks
         wPJV2pOqdvyTeI1kLDQCnafd3hNR4RZrBUmWr4GBRfp9dxcFXFHOnNlY5ByTNaX9Ovn7
         medb8pTA3zAjMiK0tjiHROjMfziSZ3ZN7ikLLMgh9Do8+8uTWIEbihQ6o2v0V8CMkelT
         vayq0rCzDDSabPvpcm7/0+wlNG5uCJLTrXlA3oAlDMciITRnUAJzKr5xLZ2ttczqv0Td
         DGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=orMBAJTu5bZfo+ZjtAIW/XRZfJpT6yrC1YB1ci4mdhQ=;
        b=Mu1ygqrRKoKTxdZF8G0rzpXav1Lvq90+6I1YlsFnv7wJAQ1CYgYNXvbINSwxQ0O0V2
         zQWRP24u0wVxtZLn3/Sc8GbIFzobQkcckseXFosxSFXIY/TaGtZztIIrJRssBh+fOUnv
         UZfpc5oCiD51nLaW8cMi8HHByBhrnZ3AvzjRlX9u2zkGzsWYNDS4oAd76kSkoMgX23b1
         vWwD3I5jflHV1rVNCNCzvI3Chi3fqalW7WIsZIC5zOxcuRgzFSusZpHDlgm75ibdgi/o
         E0tHPCGXLO51et9FfpUW/rPiug3Plo/eE5h9tkDeSPNoeY2rUbHUWMH0gZkSqEK/V3Bh
         orjA==
X-Gm-Message-State: AOAM532puqeVbGs7Yz8BJgMo8zZnbjY84QXs5Z/iS1AMDw2xTq7ztvOB
        LmLePbZszr7f9VZ0IKEfY2aKc9H7o95k
X-Google-Smtp-Source: ABdhPJz6tUJjJr3TTCqxc+szuwfGgWLkVUJz81MU2cNZP+P/jcoAt0UrWZKKXpvg67XLb/VTmlwpxyNA5Syq
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:a4e8:0:b0:61e:1eb6:19bd with SMTP id
 g95-20020a25a4e8000000b0061e1eb619bdmr27268416ybi.168.1645593863676; Tue, 22
 Feb 2022 21:24:23 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:53 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-18-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 17/47] mm: asi: Aliased direct map for local non-sensitive allocations
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

This creates a second copy of the direct map, which mirrors the normal
direct map in the regular unrestricted kernel page tables. But in the
ASI restricted address spaces, the page tables for this aliased direct
map would be local to each process. So this aliased map can be used for
locally non-sensitive page allocations.

Because of the lack of available kernel virtual address space, we have
to reduce the max possible direct map size by half. That should be fine
with 5 level page tables but could be an issue with 4 level page tables
(as max 32 TB RAM could be supported instead of 64 TB).

An alternative vmap-style implementation of an aliased local region is
possible without this limitation, but that has some other compromises
and would be usable only if we trim down the types of structures marked
as local non-sensitive by limiting the designation to only those that
really are locally non-sensitive but globally sensitive.
That is certainly ideal and likely feasible, and would also allow
removal of some other relatively complex infrastructure introduced in
later patches. But we are including this implementation here just for
demonstration of a fully general mechanism.

An altogether different alternative to a separate aliased region is also
possible by just partitioning the regular direct map (either statically
or dynamically via additional page-block types), which is certainly
feasible but would require more effort to implement properly.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/page.h          | 19 +++++++-
 arch/x86/include/asm/page_64.h       | 25 +++++++++-
 arch/x86/include/asm/page_64_types.h | 20 ++++++++
 arch/x86/kernel/e820.c               |  7 ++-
 arch/x86/mm/asi.c                    | 69 +++++++++++++++++++++++++++-
 arch/x86/mm/kaslr.c                  | 34 +++++++++++++-
 arch/x86/mm/mm_internal.h            |  2 +
 arch/x86/mm/physaddr.c               |  8 ++++
 include/linux/page-flags.h           |  3 ++
 include/trace/events/mmflags.h       |  3 +-
 security/Kconfig                     |  1 +
 11 files changed, 183 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 4d5810c8fab7..7688ba9d3542 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -18,6 +18,7 @@
 
 struct page;
 
+#include <linux/jump_label.h>
 #include <linux/range.h>
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
@@ -56,8 +57,24 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
 
 #ifndef __va
-#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
+
+#define ___va(x)		((void *)((unsigned long)(x)+PAGE_OFFSET))
+
+#ifndef CONFIG_ADDRESS_SPACE_ISOLATION
+#define __va(x)			___va(x)
+#else
+
+DECLARE_STATIC_KEY_FALSE(asi_local_map_initialized);
+void *asi_va(unsigned long pa);
+
+/*
+ * This might significantly increase the size of the jump table.
+ * If that turns out to be a problem, we should use a non-static branch.
+ */
+#define __va(x)		(static_branch_likely(&asi_local_map_initialized) \
+			 ? asi_va((unsigned long)(x)) : ___va(x))
 #endif
+#endif /* __va */
 
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 4bde0dc66100..2845eca02552 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -5,6 +5,7 @@
 #include <asm/page_64_types.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/jump_label.h>
 #include <asm/alternative.h>
 
 /* duplicated to the one in bootmem.h */
@@ -15,12 +16,34 @@ extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+extern unsigned long asi_local_map_base;
+DECLARE_STATIC_KEY_FALSE(asi_local_map_initialized);
+
+#else
+
+/* Should never be used if ASI is not enabled */
+#define asi_local_map_base (*(ulong *)NULL)
+
+#endif
+
 static inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
 	unsigned long y = x - __START_KERNEL_map;
+	unsigned long map_start = PAGE_OFFSET;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/*
+	 * This might significantly increase the size of the jump table.
+	 * If that turns out to be a problem, we should use a non-static branch.
+	 */
+	if (static_branch_likely(&asi_local_map_initialized) &&
+	    x > ASI_LOCAL_MAP)
+		map_start = ASI_LOCAL_MAP;
+#endif
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
-	x = y + ((x > y) ? phys_base : (__START_KERNEL_map - PAGE_OFFSET));
+	x = y + ((x > y) ? phys_base : (__START_KERNEL_map - map_start));
 
 	return x;
 }
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index e9e2c3ba5923..bd27ebe51a8c 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
+#include <asm/sparsemem.h>
+
 #ifndef __ASSEMBLY__
 #include <asm/kaslr.h>
 #endif
@@ -47,6 +49,24 @@
 #define __PAGE_OFFSET           __PAGE_OFFSET_BASE_L4
 #endif /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+#define __ASI_LOCAL_MAP_BASE (__PAGE_OFFSET +				       \
+			      ALIGN(_BITUL(MAX_PHYSMEM_BITS - 1), PGDIR_SIZE))
+
+#ifdef CONFIG_DYNAMIC_MEMORY_LAYOUT
+#define ASI_LOCAL_MAP		asi_local_map_base
+#else
+#define ASI_LOCAL_MAP		__ASI_LOCAL_MAP_BASE
+#endif
+
+#else /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+/* Should never be used if ASI is not enabled */
+#define ASI_LOCAL_MAP		(*(ulong *)NULL)
+
+#endif
+
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
 /* See Documentation/x86/x86_64/mm.rst for a description of the memory map. */
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index bc0657f0deed..e2ea4d6bfbdf 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -880,6 +880,11 @@ static void __init early_panic(char *msg)
 
 static int userdef __initdata;
 
+u64 __init set_phys_mem_limit(u64 size)
+{
+	return e820__range_remove(size, ULLONG_MAX - size, E820_TYPE_RAM, 1);
+}
+
 /* The "mem=nopentium" boot option disables 4MB page tables on 32-bit kernels: */
 static int __init parse_memopt(char *p)
 {
@@ -905,7 +910,7 @@ static int __init parse_memopt(char *p)
 	if (mem_size == 0)
 		return -EINVAL;
 
-	e820__range_remove(mem_size, ULLONG_MAX - mem_size, E820_TYPE_RAM, 1);
+	set_phys_mem_limit(mem_size);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	max_mem_size = mem_size;
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 58d1c532274a..38eaa650bac1 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -22,6 +22,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(asi_cpu_state);
 
 __aligned(PAGE_SIZE) pgd_t asi_global_nonsensitive_pgd[PTRS_PER_PGD];
 
+DEFINE_STATIC_KEY_FALSE(asi_local_map_initialized);
+EXPORT_SYMBOL(asi_local_map_initialized);
+
+unsigned long asi_local_map_base __ro_after_init;
+EXPORT_SYMBOL(asi_local_map_base);
+
 int asi_register_class(const char *name, uint flags,
 		       const struct asi_hooks *ops)
 {
@@ -181,8 +187,44 @@ static void asi_free_pgd(struct asi *asi)
 
 static int __init set_asi_param(char *str)
 {
-	if (strcmp(str, "on") == 0)
+	if (strcmp(str, "on") == 0) {
+		/* TODO: We should eventually add support for KASAN. */
+		if (IS_ENABLED(CONFIG_KASAN)) {
+			pr_warn("ASI is currently not supported with KASAN");
+			return 0;
+		}
+
+		/*
+		 * We create a second copy of the direct map for the aliased
+		 * ASI Local Map, so we can support only half of the max
+		 * amount of RAM. That should be fine with 5 level page tables
+		 * but could be an issue with 4 level page tables.
+		 *
+		 * An alternative vmap-style implementation of an aliased local
+		 * region is possible without this limitation, but that has
+		 * some other compromises and would be usable only if
+		 * we trim down the types of structures marked as local
+		 * non-sensitive by limiting the designation to only those that
+		 * really are locally non-sensitive but globally sensitive.
+		 * That is certainly ideal and likely feasible, and would also
+		 * allow removal of some other relatively complex infrastructure
+		 * introduced in later patches. But we are including this
+		 * implementation here just for demonstration of a fully general
+		 * mechanism.
+		 *
+		 * An altogether different alternative to a separate aliased
+		 * region is also possible by just partitioning the regular
+		 * direct map (either statically or dynamically via additional
+		 * page-block types), which is certainly feasible but would
+		 * require more effort to implement properly.
+		 */
+		if (set_phys_mem_limit(MAXMEM / 2))
+			pr_warn("Limiting Memory Size to %llu", MAXMEM / 2);
+
+		asi_local_map_base = __ASI_LOCAL_MAP_BASE;
+
 		setup_force_cpu_cap(X86_FEATURE_ASI);
+	}
 
 	return 0;
 }
@@ -190,6 +232,8 @@ early_param("asi", set_asi_param);
 
 static int __init asi_global_init(void)
 {
+	uint i, n;
+
 	if (!boot_cpu_has(X86_FEATURE_ASI))
 		return 0;
 
@@ -203,6 +247,14 @@ static int __init asi_global_init(void)
 				    VMALLOC_GLOBAL_NONSENSITIVE_END,
 				    "ASI Global Non-sensitive vmalloc");
 
+	/* TODO: We should also handle memory hotplug. */
+	n = DIV_ROUND_UP(PFN_PHYS(max_pfn), PGDIR_SIZE);
+	for (i = 0; i < n; i++)
+		swapper_pg_dir[pgd_index(ASI_LOCAL_MAP) + i] =
+			swapper_pg_dir[pgd_index(PAGE_OFFSET) + i];
+
+	static_branch_enable(&asi_local_map_initialized);
+
 	return 0;
 }
 subsys_initcall(asi_global_init)
@@ -236,7 +288,11 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 	if (asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) {
 		uint i;
 
-		for (i = KERNEL_PGD_BOUNDARY; i < PTRS_PER_PGD; i++)
+		for (i = KERNEL_PGD_BOUNDARY; i < pgd_index(ASI_LOCAL_MAP); i++)
+			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
+
+		for (i = pgd_index(VMALLOC_GLOBAL_NONSENSITIVE_START);
+		     i < PTRS_PER_PGD; i++)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
 	}
 
@@ -534,3 +590,12 @@ void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
 	/* Later patches will do a more optimized flush. */
 	flush_tlb_kernel_range((ulong)addr, (ulong)addr + len);
 }
+
+void *asi_va(unsigned long pa)
+{
+	struct page *page = pfn_to_page(PHYS_PFN(pa));
+
+	return (void *)(pa + (PageLocalNonSensitive(page)
+			      ? ASI_LOCAL_MAP : PAGE_OFFSET));
+}
+EXPORT_SYMBOL(asi_va);
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 557f0fe25dff..2e68ce84767c 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -48,6 +48,7 @@ static const unsigned long vaddr_end = CPU_ENTRY_AREA_BASE;
 static __initdata struct kaslr_memory_region {
 	unsigned long *base;
 	unsigned long size_tb;
+	unsigned long extra_bytes;
 } kaslr_regions[] = {
 	{ &page_offset_base, 0 },
 	{ &vmalloc_base, 0 },
@@ -57,7 +58,7 @@ static __initdata struct kaslr_memory_region {
 /* Get size in bytes used by the memory region */
 static inline unsigned long get_padding(struct kaslr_memory_region *region)
 {
-	return (region->size_tb << TB_SHIFT);
+	return (region->size_tb << TB_SHIFT) + region->extra_bytes;
 }
 
 /* Initialize base and padding for each memory region randomized with KASLR */
@@ -69,6 +70,8 @@ void __init kernel_randomize_memory(void)
 	struct rnd_state rand_state;
 	unsigned long remain_entropy;
 	unsigned long vmemmap_size;
+	unsigned int max_physmem_bits = MAX_PHYSMEM_BITS -
+					!!boot_cpu_has(X86_FEATURE_ASI);
 
 	vaddr_start = pgtable_l5_enabled() ? __PAGE_OFFSET_BASE_L5 : __PAGE_OFFSET_BASE_L4;
 	vaddr = vaddr_start;
@@ -85,7 +88,7 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_memory_enabled())
 		return;
 
-	kaslr_regions[0].size_tb = 1 << (MAX_PHYSMEM_BITS - TB_SHIFT);
+	kaslr_regions[0].size_tb = 1 << (max_physmem_bits - TB_SHIFT);
 	kaslr_regions[1].size_tb = VMALLOC_SIZE_TB;
 
 	/*
@@ -100,6 +103,18 @@ void __init kernel_randomize_memory(void)
 	if (memory_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = memory_tb;
 
+	if (boot_cpu_has(X86_FEATURE_ASI)) {
+		ulong direct_map_size = kaslr_regions[0].size_tb << TB_SHIFT;
+
+		/* Reserve additional space for the ASI Local Map */
+		direct_map_size = round_up(direct_map_size, PGDIR_SIZE);
+		direct_map_size *= 2;
+		VM_BUG_ON(direct_map_size % (1UL << TB_SHIFT));
+
+		kaslr_regions[0].size_tb = direct_map_size >> TB_SHIFT;
+		kaslr_regions[0].extra_bytes = PGDIR_SIZE;
+	}
+
 	/*
 	 * Calculate the vmemmap region size in TBs, aligned to a TB
 	 * boundary.
@@ -136,6 +151,21 @@ void __init kernel_randomize_memory(void)
 		vaddr = round_up(vaddr + 1, PUD_SIZE);
 		remain_entropy -= entropy;
 	}
+
+	/*
+	 * This ensures that the ASI Local Map does not share a PGD entry with
+	 * the regular direct map, and also that the alignment of the two
+	 * regions is the same.
+	 *
+	 * We are relying on the fact that the region following the ASI Local
+	 * Map will be the local non-sensitive portion of the VMALLOC region.
+	 * If that were not the case and the next region was a global one,
+	 * then we would need extra padding after the ASI Local Map to ensure
+	 * that it doesn't share a PGD entry with that global region.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_ASI))
+		asi_local_map_base = page_offset_base + PGDIR_SIZE +
+				     ((kaslr_regions[0].size_tb / 2) << TB_SHIFT);
 }
 
 void __meminit init_trampoline_kaslr(void)
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index a1e8c523ab08..ace1d0b6d2d9 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -28,4 +28,6 @@ void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
 
 extern unsigned long tlb_single_page_flush_ceiling;
 
+u64 set_phys_mem_limit(u64 size);
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fc3f3d3e2ef2..2cd6cee942da 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -21,6 +21,9 @@ unsigned long __phys_addr(unsigned long x)
 		x = y + phys_base;
 
 		VIRTUAL_BUG_ON(y >= KERNEL_IMAGE_SIZE);
+	} else if (cpu_feature_enabled(X86_FEATURE_ASI) && x > ASI_LOCAL_MAP) {
+		x -= ASI_LOCAL_MAP;
+		VIRTUAL_BUG_ON(!phys_addr_valid(x));
 	} else {
 		x = y + (__START_KERNEL_map - PAGE_OFFSET);
 
@@ -28,6 +31,7 @@ unsigned long __phys_addr(unsigned long x)
 		VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));
 	}
 
+	VIRTUAL_BUG_ON(!pfn_valid(x >> PAGE_SHIFT));
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
@@ -54,6 +58,10 @@ bool __virt_addr_valid(unsigned long x)
 
 		if (y >= KERNEL_IMAGE_SIZE)
 			return false;
+	} else if (cpu_feature_enabled(X86_FEATURE_ASI) && x > ASI_LOCAL_MAP) {
+		x -= ASI_LOCAL_MAP;
+		if (!phys_addr_valid(x))
+			return false;
 	} else {
 		x = y + (__START_KERNEL_map - PAGE_OFFSET);
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a07434cc679c..e5223a05c41a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -143,6 +143,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 	PG_global_nonsensitive,
+	PG_local_nonsensitive,
 #endif
 	__NR_PAGEFLAGS,
 
@@ -547,8 +548,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 __PAGEFLAG(GlobalNonSensitive, global_nonsensitive, PF_ANY);
+__PAGEFLAG(LocalNonSensitive, local_nonsensitive, PF_ANY);
 #else
 __PAGEFLAG_FALSE(GlobalNonSensitive, global_nonsensitive);
+__PAGEFLAG_FALSE(LocalNonSensitive, local_nonsensitive);
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 73a49197ef54..96e61d838bec 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -129,7 +129,8 @@ IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
 IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")	\
-IF_HAVE_ASI(PG_global_nonsensitive,	"global_nonsensitive")
+IF_HAVE_ASI(PG_global_nonsensitive,	"global_nonsensitive")		\
+IF_HAVE_ASI(PG_local_nonsensitive,	"local_nonsensitive")
 
 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
diff --git a/security/Kconfig b/security/Kconfig
index e89c2658e6cf..070a948b5266 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -70,6 +70,7 @@ config ADDRESS_SPACE_ISOLATION
 	default n
 	depends on X86_64 && !UML && SLAB && !NEED_PER_CPU_KM
 	depends on !PARAVIRT
+	depends on !MEMORY_HOTPLUG
 	help
 	   This feature provides the ability to run some kernel code
 	   with a reduced kernel address space. This can be used to
-- 
2.35.1.473.g83b2b277ed-goog

