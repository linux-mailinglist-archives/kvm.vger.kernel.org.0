Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3C14C0BF9
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiBWF0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238185AbiBWFZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:38 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD176C921
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:39 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d6bca75aa2so141248237b3.18
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1WKa+KZIcaa+dJcFTsqZOSts6oD//SyJ1kbRYfoMX2c=;
        b=sZHRLO9kxK5TzWD0X0seDuzrMm3IaK4jRNNmTtrhccA0nwFV9CPHeE86cjQT27AmkI
         v7sdoVjafaJDxmnspYK1IJDte5ixXIP4NlIpzJcvsi6oStzTdw2xXhTTK6hSh2PE8S4p
         mF1cpkFTM3aKbNKaOvkN2Z8/pjjAmAg7yV5uvedIm/mcA50u4mXY9mOc7gt5zMPS72Jb
         jLpByILet1L0UsVaxDROFUGR6gYkZbc/Z5Ipq4VnAgrCI+T/jtIuqYuHmNGwLB/tOVe/
         jw6HvYSt2X5Np3Q4sH2T+yBRKnSfg6rhn+2SA7NrFtkru9npVZHpssAQN1BJYkVWWTVb
         OPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1WKa+KZIcaa+dJcFTsqZOSts6oD//SyJ1kbRYfoMX2c=;
        b=gkPZsJOMdSUuJMM1JHifFjBV/sR2RbqqgG+qqUx9GhFwKprgqU3/M7T0GwfCxiekup
         xGWsaJn87HC6ocRDihPakY3Ob3dDHjRYtqLODNtymUiSjs3TF2QimdQ/5BMUybYYP/Ok
         hgKZiV8ybdk4zfWPr5be3o2kN7mzqKm4zfqvSjEM0a3IlyiuRtjdP/TELBwqhf2X29BC
         A1mXxViYXtsTAsfGHR/cpzgHYDKEzeEKuGD7ohNjU1SNnmpZdoRgltol7r1Kr548e0iC
         eNZ2RTP5+qqB62qk1b4VSljf/BtcYRA9m6Kfm5Ijpuein8yH0CSjtXrUnGr3pnTkroiF
         4noQ==
X-Gm-Message-State: AOAM531XirV/BhVI//JavWf13belizr6g4MWkNfcUWat5pqSdVXtJWFC
        mMu6vFsH59Oa8Hz1OJqFABs8qq9s+IrN
X-Google-Smtp-Source: ABdhPJzkV7QmjkoELH2kQlDpniWdBZ4HcBwkQjVMUj/MiMOJhgvGDpbnFOCshsSuGHfkjD35goEqd0h2ttTQ
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:7848:0:b0:2ca:287c:6ce3 with SMTP id
 t69-20020a817848000000b002ca287c6ce3mr26938064ywc.392.1645593865848; Tue, 22
 Feb 2022 21:24:25 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:54 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-19-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 18/47] mm: asi: Support for pre-ASI-init local
 non-sensitive allocations
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

Local non-sensitive allocations can be made before an actual ASI
instance is initialized. To support this, a process-wide pseudo-PGD
is created, which contains mappings for all locally non-sensitive
allocations. Memory can be mapped into this pseudo-PGD by using
ASI_LOCAL_NONSENSITIVE when calling asi_map(). The mappings will be
copied to an actual ASI PGD when an ASI instance is initialized in
that process, by copying all the PGD entries in the local
non-sensitive range from the pseudo-PGD to the ASI PGD. In addition,
the page fault handler will copy any new PGD entries that get added
after the initialization of the ASI instance.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |  6 +++-
 arch/x86/mm/asi.c          | 74 +++++++++++++++++++++++++++++++++++++-
 arch/x86/mm/fault.c        |  7 ++++
 include/asm-generic/asi.h  | 12 ++++++-
 kernel/fork.c              |  8 +++--
 5 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index f69e1f2f09a4..f11010c0334b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -16,6 +16,7 @@
 #define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
 
 #define ASI_GLOBAL_NONSENSITIVE	(&init_mm.asi[0])
+#define ASI_LOCAL_NONSENSITIVE	(&current->mm->asi[0])
 
 struct asi_state {
 	struct asi *curr_asi;
@@ -45,7 +46,8 @@ DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
 
 extern pgd_t asi_global_nonsensitive_pgd[];
 
-void asi_init_mm_state(struct mm_struct *mm);
+int  asi_init_mm_state(struct mm_struct *mm);
+void asi_free_mm_state(struct mm_struct *mm);
 
 int  asi_register_class(const char *name, uint flags,
 			const struct asi_hooks *ops);
@@ -61,6 +63,8 @@ int  asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags);
 int  asi_map(struct asi *asi, void *addr, size_t len);
 void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb);
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len);
+void asi_sync_mapping(struct asi *asi, void *addr, size_t len);
+void asi_do_lazy_map(struct asi *asi, size_t addr);
 
 static inline void asi_init_thread_state(struct thread_struct *thread)
 {
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 38eaa650bac1..3ba0971a318d 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -73,6 +73,17 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+static void asi_clone_pgd(pgd_t *dst_table, pgd_t *src_table, size_t addr)
+{
+	pgd_t *src = pgd_offset_pgd(src_table, addr);
+	pgd_t *dst = pgd_offset_pgd(dst_table, addr);
+
+	if (!pgd_val(*dst))
+		set_pgd(dst, *src);
+	else
+		VM_BUG_ON(pgd_val(*dst) != pgd_val(*src));
+}
+
 #ifndef mm_inc_nr_p4ds
 #define mm_inc_nr_p4ds(mm)	do {} while (false)
 #endif
@@ -291,6 +302,11 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 		for (i = KERNEL_PGD_BOUNDARY; i < pgd_index(ASI_LOCAL_MAP); i++)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
 
+		for (i = pgd_index(ASI_LOCAL_MAP);
+		     i <= pgd_index(ASI_LOCAL_MAP + PFN_PHYS(max_possible_pfn));
+		     i++)
+			set_pgd(asi->pgd + i, mm->asi[0].pgd[i]);
+
 		for (i = pgd_index(VMALLOC_GLOBAL_NONSENSITIVE_START);
 		     i < PTRS_PER_PGD; i++)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
@@ -379,7 +395,7 @@ void asi_exit(void)
 }
 EXPORT_SYMBOL_GPL(asi_exit);
 
-void asi_init_mm_state(struct mm_struct *mm)
+int asi_init_mm_state(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 
@@ -395,6 +411,28 @@ void asi_init_mm_state(struct mm_struct *mm)
 				  memcg->use_asi;
 		css_put(&memcg->css);
 	}
+
+	if (!mm->asi_enabled)
+		return 0;
+
+	mm->asi[0].mm = mm;
+	mm->asi[0].pgd = (pgd_t *)__get_free_page(GFP_PGTABLE_USER);
+	if (!mm->asi[0].pgd)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void asi_free_mm_state(struct mm_struct *mm)
+{
+	if (!boot_cpu_has(X86_FEATURE_ASI) || !mm->asi_enabled)
+		return;
+
+	asi_free_pgd_range(&mm->asi[0], pgd_index(ASI_LOCAL_MAP),
+			   pgd_index(ASI_LOCAL_MAP +
+				     PFN_PHYS(max_possible_pfn)) + 1);
+
+	free_page((ulong)mm->asi[0].pgd);
 }
 
 static bool is_page_within_range(size_t addr, size_t page_size,
@@ -599,3 +637,37 @@ void *asi_va(unsigned long pa)
 			      ? ASI_LOCAL_MAP : PAGE_OFFSET));
 }
 EXPORT_SYMBOL(asi_va);
+
+static bool is_addr_in_local_nonsensitive_range(size_t addr)
+{
+	return addr >= ASI_LOCAL_MAP &&
+	       addr < VMALLOC_GLOBAL_NONSENSITIVE_START;
+}
+
+void asi_do_lazy_map(struct asi *asi, size_t addr)
+{
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
+		return;
+
+	if ((asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) &&
+	    is_addr_in_local_nonsensitive_range(addr))
+		asi_clone_pgd(asi->pgd, asi->mm->asi[0].pgd, addr);
+}
+
+/*
+ * Should be called after asi_map(ASI_LOCAL_NONSENSITIVE,...) for any mapping
+ * that is required to exist prior to asi_enter() (e.g. thread stacks)
+ */
+void asi_sync_mapping(struct asi *asi, void *start, size_t len)
+{
+	size_t addr = (size_t)start;
+	size_t end = addr + len;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
+		return;
+
+	if ((asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) &&
+	    is_addr_in_local_nonsensitive_range(addr))
+		for (; addr < end; addr = pgd_addr_end(addr, end))
+			asi_clone_pgd(asi->pgd, asi->mm->asi[0].pgd, addr);
+}
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4bfed53e210e..8692eb50f4a5 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1498,6 +1498,12 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 {
 	unsigned long address = read_cr2();
 	irqentry_state_t state;
+	/*
+	 * There is a very small chance that an NMI could cause an asi_exit()
+	 * before this asi_get_current(), but that is ok, we will just do
+	 * the fixup on the next page fault.
+	 */
+	struct asi *asi = asi_get_current();
 
 	prefetchw(&current->mm->mmap_lock);
 
@@ -1539,6 +1545,7 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 
 	instrumentation_begin();
 	handle_page_fault(regs, error_code, address);
+	asi_do_lazy_map(asi, address);
 	instrumentation_end();
 
 	irqentry_exit(regs, state);
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 51c9c4a488e8..a1c8ebff70e8 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -13,6 +13,7 @@
 #define ASI_MAX_NUM			0
 
 #define ASI_GLOBAL_NONSENSITIVE		NULL
+#define ASI_LOCAL_NONSENSITIVE		NULL
 
 #define VMALLOC_GLOBAL_NONSENSITIVE_START	VMALLOC_START
 #define VMALLOC_GLOBAL_NONSENSITIVE_END		VMALLOC_END
@@ -31,7 +32,9 @@ int asi_register_class(const char *name, uint flags,
 
 static inline void asi_unregister_class(int asi_index) { }
 
-static inline void asi_init_mm_state(struct mm_struct *mm) { }
+static inline int asi_init_mm_state(struct mm_struct *mm) { return 0; }
+
+static inline void asi_free_mm_state(struct mm_struct *mm) { }
 
 static inline
 int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
@@ -67,9 +70,16 @@ static inline int asi_map(struct asi *asi, void *addr, size_t len)
 	return 0;
 }
 
+static inline
+void asi_sync_mapping(struct asi *asi, void *addr, size_t len) { }
+
 static inline
 void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb) { }
 
+
+static inline
+void asi_do_lazy_map(struct asi *asi, size_t addr) { }
+
 static inline
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3695a32ee9bd..dd5a86e913ea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -699,6 +699,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_subscriptions_destroy(mm);
+	asi_free_mm_state(mm);
 	check_mm(mm);
 	put_user_ns(mm->user_ns);
 	free_mm(mm);
@@ -1072,17 +1073,20 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 		mm->def_flags = 0;
 	}
 
-	asi_init_mm_state(mm);
-
 	if (mm_alloc_pgd(mm))
 		goto fail_nopgd;
 
 	if (init_new_context(p, mm))
 		goto fail_nocontext;
 
+	if (asi_init_mm_state(mm))
+		goto fail_noasi;
+
 	mm->user_ns = get_user_ns(user_ns);
+
 	return mm;
 
+fail_noasi:
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
-- 
2.35.1.473.g83b2b277ed-goog

