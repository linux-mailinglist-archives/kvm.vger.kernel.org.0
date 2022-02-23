Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2860F4C0C21
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiBWF2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiBWF1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:20 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8053E6EB21
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:33 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a19-20020a25ca13000000b0061db44646b3so26600816ybg.2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Dq9qt2AUp1awc/cLmelSzNKRNDnSx+0iG/3BD+f2Pqw=;
        b=bPNyVJMg6CFD9HMFXRNSQizMrYjSNrjLiLhbm2g1SK1dzDwAFw9IVrAGvhhX45jt5Q
         MB3m8YKlJbAP43meWzITJhoGXfxoAhkBewEF4x4QZqaowTmjzbchko9N97X/yQbRhrNA
         ImSjY75jArlh3P4WvJxt6CSq2eFG/pUb6dFuicj5exLngzk9JG3+oOBNZTaiEkVgP1d8
         VW0rHsRZ6Lp5BNVpEKjEx5KJ5bw8GUJBEAXS5TOsXJl2K77U7oBnknsAPh1rXoSbln87
         yaf/9ms1aZYCgCW1qLWuFDH6hT7XNDObPyRg/4cz2jm+Z6IkcAJZ7HSdd02kUIZheQ2Z
         Pwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Dq9qt2AUp1awc/cLmelSzNKRNDnSx+0iG/3BD+f2Pqw=;
        b=RH6wFHeHl+zm7Da2PAoKxfcCJgtfwaJJqLToT5WZcZuRjTGCWFPXVHF1zK0ViUba40
         e0gb4QjgBopcSBhp/eNxt2Vz1NF6bRMunbPrgEIw1ghDzr//k97k/Qaxd99JcQbkMrFj
         OlLk6EVyKm7J0/uiRz5Vc/RAbZ7Dh+1OP8CU9uO1FIL6hOBFsiNEd+qgPQZG3M0IkTbF
         xcT+NrcU8cfQcBBWzCl4+7MsOqOJ+Pqb+6q6mK+VSUtdk0b6e0LGt8VWjqcWODGycQrJ
         dzAgB5L+J+pX0MDKoedKGLE3POPcX2WaTkzNa9edhl99FRJaYiD+m1vSfpc09tSgFNqF
         0mbw==
X-Gm-Message-State: AOAM5320firs+F4XSYhsKVtKnXo3VDzGK8Jo7jxvaiRPxqliDXM+k1IC
        WJHUbdkT/hwrlC+5O4C4GeEE501NgBp0
X-Google-Smtp-Source: ABdhPJzaqkidQawY7QCK9X5rVK71lVLf3wgt7MJ0n5efK7otIJAGSETfWRZjLt8X/bYBHlNaQvv9LeMoFDFo
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:d1c5:0:b0:2ca:287c:6b81 with SMTP id
 t188-20020a0dd1c5000000b002ca287c6b81mr28230447ywd.38.1645593926233; Tue, 22
 Feb 2022 21:25:26 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:21 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-46-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 45/47] mm: asi: Mapping global nonsensitive areas in asi_global_init
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
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

From: Ofir Weisse <oweisse@google.com>

There are several areas in memory which we consider non sensitive.
These areas should be mapped in every ASI domain. We map there areas
in asi_global_init(). We modified some of the linking scripts to
ensure these areas are starting and ending on page boundaries.

The areas:
 - _stext             --> _etext
 - __init_begin       --> __init_end
 - __start_rodata     --> __end_rodata
 - __start_once       --> __end_once
 - __start___ex_table --> __stop___ex_table
 - __start_asi_nonsensitive            --> __end_asi_nonsensitive
 - __start_asi_nonsensitive_readmostly -->
     __end_asi_nonsensitive_readmostly
 - __vvar_page --> + PAGE_SIZE
 - APIC_BASE   --> + PAGE_SIZE
 - phys_base   --> + PAGE_SIZE
 - __start___tracepoints_ptrs --> __stop___tracepoints_ptrs
 - __start___tracepoint_str   --> __stop___tracepoint_str
 - __per_cpu_asi_start        --> __per_cpu_asi_end (percpu)
 - irq_stack_backing_store    --> + sizeof(irq_stack_backing_store)
   (percpu)

The pgd's of the following addresses are cloned, modeled after KPTI:
 - CPU_ENTRY_AREA_BASE
 - ESPFIX_BASE_ADDR

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/kernel/head_64.S         | 12 +++++
 arch/x86/kernel/vmlinux.lds.S     |  2 +-
 arch/x86/mm/asi.c                 | 82 +++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h | 13 +++--
 4 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d8b3ebd2bb85..3d3874661895 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -574,9 +574,21 @@ SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+/* TODO: Find a way to mark .section for phys_base */
+/* Ideally, we want to map phys_base in .data..asi_non_sensitive. That doesn't
+ * seem to work properly. For now, we just make sure phys_base is in it's own
+ * page. */
+	.align PAGE_SIZE
+#endif
 SYM_DATA(phys_base, .quad 0x0)
 EXPORT_SYMBOL(phys_base)
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	.align PAGE_SIZE
+#endif
+
 #include "../../x86/xen/xen-head.S"
 
 	__PAGE_ALIGNED_BSS
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3d6dc12d198f..2b3668291785 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -148,8 +148,8 @@ SECTIONS
 	} :text =0xcccc
 
 	/* End of text section, which should occupy whole number of pages */
-	_etext = .;
 	. = ALIGN(PAGE_SIZE);
+	_etext = .;
 
 	X86_ALIGN_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 04628949e89d..7f2aa1823736 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -9,6 +9,7 @@
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
+#include <asm/processor.h> /* struct irq_stack */
 #include <asm/mmu_context.h>
 
 #include "mm_internal.h"
@@ -17,6 +18,24 @@
 #undef pr_fmt
 #define pr_fmt(fmt)     "ASI: " fmt
 
+#include <linux/extable.h>
+#include <asm-generic/sections.h>
+
+extern struct exception_table_entry __start___ex_table[];
+extern struct exception_table_entry __stop___ex_table[];
+
+extern const char __start_asi_nonsensitive[], __end_asi_nonsensitive[];
+extern const char __start_asi_nonsensitive_readmostly[],
+            __end_asi_nonsensitive_readmostly[];
+extern const char __per_cpu_asi_start[], __per_cpu_asi_end[];
+extern const char *__start___tracepoint_str[];
+extern const char *__stop___tracepoint_str[];
+extern const char *__start___tracepoints_ptrs[];
+extern const char *__stop___tracepoints_ptrs[];
+extern const char __vvar_page[];
+
+DECLARE_PER_CPU_PAGE_ALIGNED(struct irq_stack, irq_stack_backing_store);
+
 static struct asi_class asi_class[ASI_MAX_NUM] __asi_not_sensitive;
 static DEFINE_SPINLOCK(asi_class_lock __asi_not_sensitive);
 
@@ -412,6 +431,7 @@ void asi_unload_module(struct module* module)
 static int __init asi_global_init(void)
 {
 	uint i, n;
+        int err = 0;
 
 	if (!boot_cpu_has(X86_FEATURE_ASI))
 		return 0;
@@ -436,6 +456,68 @@ static int __init asi_global_init(void)
 
         pcpu_map_asi_reserved_chunk();
 
+
+	/*
+	 * TODO: We need to ensure that all the sections mapped below are
+	 * actually page-aligned by the linker. For now, we temporarily just
+	 * align the start/end addresses here, but that is incorrect as the
+	 * rest of the page could potentially contain sensitive data.
+	 */
+#define MAP_SECTION(start, end)                                   \
+        pr_err("%s:%d mapping 0x%lx --> 0x%lx",                   \
+               __FUNCTION__, __LINE__, start, end);               \
+       err = asi_map(ASI_GLOBAL_NONSENSITIVE,                    \
+                     (void*)((unsigned long)(start) & PAGE_MASK),\
+                      PAGE_ALIGN((unsigned long)(end)) -          \
+                     ((unsigned long)(start) & PAGE_MASK));      \
+       BUG_ON(err);
+
+#define MAP_SECTION_PERCPU(start, size)                                  \
+        pr_err("%s:%d mapping PERCPU 0x%lx --> 0x%lx",                   \
+               __FUNCTION__, __LINE__, start, (unsigned long)start+size); \
+       err = asi_map_percpu(ASI_GLOBAL_NONSENSITIVE,                     \
+                     (void*)((unsigned long)(start) & PAGE_MASK),        \
+                      PAGE_ALIGN((unsigned long)(size)));                \
+       BUG_ON(err);
+
+        MAP_SECTION(_stext, _etext);
+        MAP_SECTION(__init_begin, __init_end);
+        MAP_SECTION(__start_rodata, __end_rodata);
+        MAP_SECTION(__start_once, __end_once);
+        MAP_SECTION(__start___ex_table, __stop___ex_table);
+        MAP_SECTION(__start_asi_nonsensitive, __end_asi_nonsensitive);
+        MAP_SECTION(__start_asi_nonsensitive_readmostly,
+                    __end_asi_nonsensitive_readmostly);
+        MAP_SECTION(__vvar_page, __vvar_page + PAGE_SIZE);
+        MAP_SECTION(APIC_BASE, APIC_BASE + PAGE_SIZE);
+        MAP_SECTION(&phys_base, &phys_base + PAGE_SIZE);
+
+       /* TODO: add a build flag to enable disable mapping only when
+        * instrumentation is used */
+        MAP_SECTION(__start___tracepoints_ptrs, __stop___tracepoints_ptrs);
+        MAP_SECTION(__start___tracepoint_str, __stop___tracepoint_str);
+
+	MAP_SECTION_PERCPU((void*)__per_cpu_asi_start,
+	 		   __per_cpu_asi_end - __per_cpu_asi_start);
+
+	MAP_SECTION_PERCPU(&irq_stack_backing_store,
+			   sizeof(irq_stack_backing_store));
+
+	/* We have to map the stack canary into ASI. This is far from ideal, as
+	* attackers can use L1TF to steal the canary value, and then perhaps
+	* mount some other attack including a buffer overflow. This is a price
+	* we must pay to use ASI.
+	*/
+	MAP_SECTION_PERCPU(&fixed_percpu_data, PAGE_SIZE);
+
+#define CLONE_INIT_PGD(addr) \
+        asi_clone_pgd(asi_global_nonsensitive_pgd, init_mm.pgd, addr);
+
+        CLONE_INIT_PGD(CPU_ENTRY_AREA_BASE);
+#ifdef CONFIG_X86_ESPFIX64
+        CLONE_INIT_PGD(ESPFIX_BASE_ADDR);
+#endif
+
 	return 0;
 }
 subsys_initcall(asi_global_init)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 0a931aedc285..7152ce3613f5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -235,8 +235,10 @@
 #define TRACE_PRINTKS()	 __start___trace_bprintk_fmt = .;      \
 			 KEEP(*(__trace_printk_fmt)) /* Trace_printk fmt' pointer */ \
 			 __stop___trace_bprintk_fmt = .;
-#define TRACEPOINT_STR() __start___tracepoint_str = .;	\
+#define TRACEPOINT_STR() . = ALIGN(PAGE_SIZE);          \
+                         __start___tracepoint_str = .;	\
 			 KEEP(*(__tracepoint_str)) /* Trace_printk fmt' pointer */ \
+                         . = ALIGN(PAGE_SIZE);          \
 			 __stop___tracepoint_str = .;
 #else
 #define TRACE_PRINTKS()
@@ -348,8 +350,10 @@
 	MEM_KEEP(init.data*)						\
 	MEM_KEEP(exit.data*)						\
 	*(.data.unlikely)						\
+	. = ALIGN(PAGE_SIZE);						\
 	__start_once = .;						\
 	*(.data.once)							\
+	. = ALIGN(PAGE_SIZE);						\
 	__end_once = .;							\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
@@ -453,9 +457,10 @@
 		*(.rodata) *(.rodata.*)					\
 		SCHED_DATA						\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
-		. = ALIGN(8);						\
+                . = ALIGN(PAGE_SIZE);	        			\
 		__start___tracepoints_ptrs = .;				\
 		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
+                . = ALIGN(PAGE_SIZE);	        			\
 		__stop___tracepoints_ptrs = .;				\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
@@ -671,11 +676,13 @@
  */
 #define EXCEPTION_TABLE(align)						\
 	. = ALIGN(align);						\
+        . = ALIGN(PAGE_SIZE);                                           \
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
 		__start___ex_table = .;					\
 		KEEP(*(__ex_table))					\
+                . = ALIGN(PAGE_SIZE);                                   \
 		__stop___ex_table = .;					\
-	}
+	}                                                               \
 
 /*
  * .BTF
-- 
2.35.1.473.g83b2b277ed-goog

