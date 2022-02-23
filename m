Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA00B4C0BB6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbiBWFYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbiBWFYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:52 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9596A033
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:04 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae11460so162180387b3.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rf+PEwSCAjx96OEampym4lZ49QLmyoHK2vvPo63tKDU=;
        b=ClDNkRcR05xwUIt+/3suGkjgzNs7jx8crmYYSBy7YIfyMwXpzxpsuO7L5+YX8vxRfh
         1E4PSbB3uEBG+XkPHeMZghVckls3s0XgENlVkTaPWZjkwqbjhFcBMXRc0pNft0u4lgb5
         OHkuB86fnETxs+Q/fn9lSwDJhVOhXOzfA1+wbVB6gzJyDg9tXEAFaT4CQ0u+HBjQvZbK
         xaLThn55HGR54AO8ID3Zi3c8s3jxcmEzd75ic5aZDYq6ErsSaIKBY/8EVr+KDDNXwZv5
         bVHGd/T3R6cR1QrhXBnqEawoY6M01XywGeiIoQ1z1l9A03h+cXgMumLSGriK6mCj3H15
         pxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rf+PEwSCAjx96OEampym4lZ49QLmyoHK2vvPo63tKDU=;
        b=TWS0cCz8A+OhmZD2/8xVhmuCL/FEZejQzsc1AF0KCWPxPOVzH9OS1BZAsIbpvWi0e5
         UbTsr593hCyMj/KsI9eN/kuA4e5V5+IKbSQdid32i4iEoUPfN/n0IF+oI6AdazYiJBcE
         O5CInHSyYM6ztTsjh+88D61ic5G8OF+HUwHyyizZ6E+6upwFJHYh/zosKLuWmV85xLhI
         6X1LKTM/S7AXvhLvzXWAvky15cbXahmQ+63AwAWxCtuu8VjXSNSH3jMyfENHdZfxjbGW
         tQEmOLuJHhD6VQEN1n0JHgxiJ62pU0VX8/s1MkZPWze9JYWhhbgnaZwRReZVj94kphCz
         SolA==
X-Gm-Message-State: AOAM531jNedDZQr7BiqWSBZHAKfwFo9WJRibuxgful0ShgB4YaZnXR6o
        unW10KfnndNfZD0EOF61QsA1OyROpj4l
X-Google-Smtp-Source: ABdhPJxAE8giXqGIDJh7Mviar4JsaaTJZtQQuDBTZF65UTbW8rTNqxt0+PJdM/jBytNMKHkW6V66FJSXIQ6n
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a05:6902:108:b0:621:165e:5c1e with SMTP id
 o8-20020a056902010800b00621165e5c1emr25436069ybh.204.1645593843385; Tue, 22
 Feb 2022 21:24:03 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:44 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-9-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 08/47] mm: asi: Add basic infrastructure for global
 non-sensitive mappings
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

A pseudo-PGD is added to store global non-sensitive ASI mappings.
Actual ASI PGDs copy entries from this pseudo-PGD during asi_init().

Memory can be mapped as globally non-sensitive by calling asi_map()
with ASI_GLOBAL_NONSENSITIVE.

Page tables allocated for global non-sensitive mappings are never
freed.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h | 12 ++++++++++++
 arch/x86/mm/asi.c          | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/mm/init_64.c      | 26 +++++++++++++++++---------
 arch/x86/mm/mm_internal.h  |  3 +++
 include/asm-generic/asi.h  |  5 +++++
 mm/init-mm.c               |  2 ++
 6 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 521b40d1864b..64c2b4d1dba2 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -15,6 +15,8 @@
 #define ASI_MAX_NUM_ORDER	2
 #define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
 
+#define ASI_GLOBAL_NONSENSITIVE	(&init_mm.asi[0])
+
 struct asi_state {
 	struct asi *curr_asi;
 	struct asi *target_asi;
@@ -41,6 +43,8 @@ struct asi {
 
 DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
 
+extern pgd_t asi_global_nonsensitive_pgd[];
+
 void asi_init_mm_state(struct mm_struct *mm);
 
 int  asi_register_class(const char *name, uint flags,
@@ -117,6 +121,14 @@ static inline void asi_intr_exit(void)
 	}
 }
 
+#define INIT_MM_ASI(init_mm)						\
+	.asi = {							\
+		[0] = {							\
+			.pgd = asi_global_nonsensitive_pgd,		\
+			.mm = &init_mm					\
+		}							\
+	},
+
 static inline pgd_t *asi_pgd(struct asi *asi)
 {
 	return asi->pgd;
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 84d220cbdcfc..d381ae573af9 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -1,11 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/init.h>
+#include <linux/memblock.h>
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 
+#include "mm_internal.h"
 #include "../../../mm/internal.h"
 
 #undef pr_fmt
@@ -17,6 +19,8 @@ static DEFINE_SPINLOCK(asi_class_lock);
 DEFINE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
 EXPORT_PER_CPU_SYMBOL_GPL(asi_cpu_state);
 
+__aligned(PAGE_SIZE) pgd_t asi_global_nonsensitive_pgd[PTRS_PER_PGD];
+
 int asi_register_class(const char *name, uint flags,
 		       const struct asi_hooks *ops)
 {
@@ -160,12 +164,17 @@ static void asi_free_pgd_range(struct asi *asi, uint start, uint end)
  * Free the page tables allocated for the given ASI instance.
  * The caller must ensure that all the mappings have already been cleared
  * and appropriate TLB flushes have been issued before calling this function.
+ *
+ * For standard non-sensitive ASI classes, the page tables shared with the
+ * master pseudo-PGD are not freed.
  */
 static void asi_free_pgd(struct asi *asi)
 {
 	VM_BUG_ON(asi->mm == &init_mm);
 
-	asi_free_pgd_range(asi, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD);
+	if (!(asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE))
+		asi_free_pgd_range(asi, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD);
+
 	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
 }
 
@@ -178,6 +187,24 @@ static int __init set_asi_param(char *str)
 }
 early_param("asi", set_asi_param);
 
+static int __init asi_global_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
+	preallocate_toplevel_pgtbls(asi_global_nonsensitive_pgd,
+				    PAGE_OFFSET,
+				    PAGE_OFFSET + PFN_PHYS(max_possible_pfn) - 1,
+				    "ASI Global Non-sensitive direct map");
+
+	preallocate_toplevel_pgtbls(asi_global_nonsensitive_pgd,
+				    VMALLOC_START, VMALLOC_END,
+				    "ASI Global Non-sensitive vmalloc");
+
+	return 0;
+}
+subsys_initcall(asi_global_init)
+
 int asi_init(struct mm_struct *mm, int asi_index)
 {
 	struct asi *asi = &mm->asi[asi_index];
@@ -202,6 +229,13 @@ int asi_init(struct mm_struct *mm, int asi_index)
 	asi->class = &asi_class[asi_index];
 	asi->mm = mm;
 
+	if (asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) {
+		uint i;
+
+		for (i = KERNEL_PGD_BOUNDARY; i < PTRS_PER_PGD; i++)
+			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(asi_init);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 36098226a957..ebd512c64ed0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1277,18 +1277,15 @@ static void __init register_page_bootmem_info(void)
 #endif
 }
 
-/*
- * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
- * Only the level which needs to be synchronized between all page-tables is
- * allocated because the synchronization can be expensive.
- */
-static void __init preallocate_vmalloc_pages(void)
+void __init preallocate_toplevel_pgtbls(pgd_t *pgd_table,
+					ulong start, ulong end,
+					const char *name)
 {
 	unsigned long addr;
 	const char *lvl;
 
-	for (addr = VMALLOC_START; addr <= VMALLOC_END; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
-		pgd_t *pgd = pgd_offset_k(addr);
+	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
+		pgd_t *pgd = pgd_offset_pgd(pgd_table, addr);
 		p4d_t *p4d;
 		pud_t *pud;
 
@@ -1324,7 +1321,18 @@ static void __init preallocate_vmalloc_pages(void)
 	 * The pages have to be there now or they will be missing in
 	 * process page-tables later.
 	 */
-	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
+	panic("Failed to pre-allocate %s pages for %s area\n", lvl, name);
+}
+
+/*
+ * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
+ * Only the level which needs to be synchronized between all page-tables is
+ * allocated because the synchronization can be expensive.
+ */
+static void __init preallocate_vmalloc_pages(void)
+{
+	preallocate_toplevel_pgtbls(init_mm.pgd, VMALLOC_START, VMALLOC_END,
+				    "vmalloc");
 }
 
 void __init mem_init(void)
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index 3f37b5c80bb3..a1e8c523ab08 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -19,6 +19,9 @@ unsigned long kernel_physical_mapping_change(unsigned long start,
 					     unsigned long page_size_mask);
 void zone_sizes_init(void);
 
+void preallocate_toplevel_pgtbls(pgd_t *pgd_table, ulong start, ulong end,
+				 const char *name);
+
 extern int after_bootmem;
 
 void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 7da91cbe075d..012691e29895 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -12,6 +12,8 @@
 #define ASI_MAX_NUM_ORDER		0
 #define ASI_MAX_NUM			0
 
+#define ASI_GLOBAL_NONSENSITIVE		NULL
+
 #ifndef _ASSEMBLY_
 
 struct asi_hooks {};
@@ -63,8 +65,11 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb) { }
 static inline
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 
+#define INIT_MM_ASI(init_mm)
+
 #define static_asi_enabled() false
 
+
 #endif  /* !_ASSEMBLY_ */
 
 #endif /* !CONFIG_ADDRESS_SPACE_ISOLATION */
diff --git a/mm/init-mm.c b/mm/init-mm.c
index b4a6f38fb51d..47a6a66610fb 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <asm/mmu.h>
+#include <asm/asi.h>
 
 #ifndef INIT_MM_CONTEXT
 #define INIT_MM_CONTEXT(name)
@@ -38,6 +39,7 @@ struct mm_struct init_mm = {
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
+	INIT_MM_ASI(init_mm)
 	INIT_MM_CONTEXT(init_mm)
 };
 
-- 
2.35.1.473.g83b2b277ed-goog

