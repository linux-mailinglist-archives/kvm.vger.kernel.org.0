Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474EA4C0C2E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbiBWF35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiBWF1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3286FA32
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:37 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d6baed6aafso144154937b3.3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TaqdfVv20HSlc0A1c0PRFCOb1G6wQiL20chjexIyKqk=;
        b=rGs+4FxaDjpCpPLEg7H9QRppi6us6PQKtKoDaRWUcIklSnWA7hAYHi0ajBlLinkdGD
         RR60+N9t//ZgngiTNXXIeQGAWtu9hbb85MnwRsz6HZkNODh5q+Hvo26B+KyLDLD0wO72
         Km+o4S/5IA7Nm5fHy35QBZ6gA5Jj2sdkDbtwen0aMy6pdcJNCDB87jD1BH+xf2J+Qqo1
         uywNmgZooXGbPVFc7sIEcTr3h+ZPEiF9YjXU/CTb1IwHcqN0Ljdos6xBZ49r2iJJ80jO
         IU+HktHwWbxx7NyomQ4O+OP+COIay05VRI+prWu+WSkdgnQPlZ0X+27JswkXnsvP2ZOJ
         /p0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TaqdfVv20HSlc0A1c0PRFCOb1G6wQiL20chjexIyKqk=;
        b=bTv0142fVS7mDRXD0lPzTPJCBQkNSXaRIIJMeUW+3MOAszArhgruInqt2Ri76CrPPI
         5O9wMYMX5Yu5Zuy5g35n5hOQt48fOwGg5VJpujOAUXG1wGY7VEMPXdkU0q2ZmvhGMFaK
         rsHOnGLDy9yB1U/G5GKw5qyItrYm6ncyaux8jIED6DyqA//4kLuw9q6Lol+iYhd0zSgA
         14ViBDHIx/wZMyBk5tvIqB8S5UtY+hWen2mYhuSCexBho6nn+suqFbGh+OJLrOJain38
         iuypmQK0Sbqwqoghxha7J0BT/J9bfmGChenXvWBuhKDZziEgyY5MhiPiaPwjBQbhIs0J
         irNg==
X-Gm-Message-State: AOAM532GVFCERK023aHoYlmiGpfbFK5vz5Z62y+fedxF8TJ07iOaAyBz
        nAHtVlkhxb6zi68WivCtsT1hKLgU3Ybn
X-Google-Smtp-Source: ABdhPJwmqi34TRvmt135zAgWCIHRaV4KjaCBBqxLVhnQGHlMtw+LypDzffAe2O8Zb/1XiXdFw/2ftIFsbgRk
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:6fc1:0:b0:624:43a0:c16c with SMTP id
 k184-20020a256fc1000000b0062443a0c16cmr21683087ybc.222.1645593930719; Tue, 22
 Feb 2022 21:25:30 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:23 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-48-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 47/47] mm: asi: Properly un/mapping task stack from ASI +
 tlb flush
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

There are several locations where this is important. Especially since a
task_struct might be reused, potentially with a different mm.

1. Map in vcpu_run() @ arch/x86/kvm/x86.c
1. Unmap in release_task_stack() @ kernel/fork.c
2. Unmap in do_exit() @ kernel/exit.c
3. Unmap in begin_new_exec() @ fs/exec.c

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/include/asm/asi.h |  6 ++++
 arch/x86/kvm/x86.c         |  6 ++++
 arch/x86/mm/asi.c          | 59 ++++++++++++++++++++++++++++++++++++++
 fs/exec.c                  |  7 ++++-
 include/asm-generic/asi.h  | 16 +++++++++--
 include/linux/sched.h      |  5 ++++
 kernel/exit.c              |  2 +-
 kernel/fork.c              | 22 +++++++++++++-
 8 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 6148e65fb0c2..9d8f43981678 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -87,6 +87,12 @@ void asi_unmap_user(struct asi *asi, void *va, size_t len);
 int  asi_fill_pgtbl_pool(struct asi_pgtbl_pool *pool, uint count, gfp_t flags);
 void asi_clear_pgtbl_pool(struct asi_pgtbl_pool *pool);
 
+int asi_map_task_stack(struct task_struct *tsk, struct asi *asi);
+void asi_unmap_task_stack(struct task_struct *tsk);
+void asi_mark_pages_local_nonsensitive(struct page *pages, uint order,
+                                       struct mm_struct *mm);
+void asi_clear_pages_local_nonsensitive(struct page *pages, uint order);
+
 static inline void asi_init_pgtbl_pool(struct asi_pgtbl_pool *pool)
 {
 	pool->pgtbl_list = NULL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 294f73e9e71e..718104eefaed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10122,6 +10122,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 	vcpu->arch.l1tf_flush_l1d = true;
 
+	/* We must have current->stack mapped into asi. This function can be
+	 * safely called many times, as it will only do the actual mapping once. */
+	r = asi_map_task_stack(current, vcpu->kvm->asi);
+	if (r != 0)
+		return r;
+
 	for (;;) {
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 7f2aa1823736..a86ac6644a57 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -1029,6 +1029,45 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb)
 		asi_flush_tlb_range(asi, addr, len);
 }
 
+int asi_map_task_stack(struct task_struct *tsk, struct asi *asi)
+{
+        int ret;
+
+        /* If the stack is already mapped to asi - don't need to map it again. */
+        if (tsk->asi_stack_mapped)
+                return 0;
+
+        if (!tsk->mm)
+                return -EINVAL;
+
+        /* If the stack was allocated via the page allocator, we assume the
+         * stack pages were marked with PageNonSensitive, therefore tsk->stack
+         * address is properly aliased. */
+        ret = asi_map(ASI_LOCAL_NONSENSITIVE, tsk->stack, THREAD_SIZE);
+        if (!ret) {
+		tsk->asi_stack_mapped = asi;
+		asi_sync_mapping(asi, tsk->stack, THREAD_SIZE);
+	}
+
+        return ret;
+}
+
+void asi_unmap_task_stack(struct task_struct *tsk)
+{
+        /* No need to unmap if the stack was not mapped to begin with. */
+        if (!tsk->asi_stack_mapped)
+                return;
+
+        if (!tsk->mm)
+                return;
+
+        asi_unmap(ASI_LOCAL_NONSENSITIVE, tsk->stack, THREAD_SIZE,
+                  /* flush_tlb = */ true);
+
+        tsk->asi_stack_mapped = NULL;
+}
+
+
 void *asi_va(unsigned long pa)
 {
 	struct page *page = pfn_to_page(PHYS_PFN(pa));
@@ -1336,3 +1375,23 @@ void asi_unmap_user(struct asi *asi, void *addr, size_t len)
 	}
 }
 EXPORT_SYMBOL_GPL(asi_unmap_user);
+
+void asi_mark_pages_local_nonsensitive(struct page *pages, uint order,
+                                       struct mm_struct *mm)
+{
+        uint i;
+        for (i = 0; i < (1 << order); i++) {
+                __SetPageLocalNonSensitive(pages + i);
+                pages[i].asi_mm = mm;
+	}
+}
+
+void asi_clear_pages_local_nonsensitive(struct page *pages, uint order)
+{
+        uint i;
+        for (i = 0; i < (1 << order); i++) {
+                __ClearPageLocalNonSensitive(pages + i);
+                pages[i].asi_mm = NULL;
+	}
+}
+
diff --git a/fs/exec.c b/fs/exec.c
index 76f3b433e80d..fb9182cf3f33 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -69,6 +69,7 @@
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include <asm/asi.h>
 
 #include <trace/events/task.h>
 #include "internal.h"
@@ -1238,7 +1239,11 @@ int begin_new_exec(struct linux_binprm * bprm)
 	struct task_struct *me = current;
 	int retval;
 
-        /* TODO: (oweisse) unmap the stack from ASI */
+        /* The old mm is about to be released later on in exec_mmap. We are
+         * reusing the task, including its stack which was mapped to
+         * mm->asi_pgd[0]. We need to asi_unmap the stack, so the destructor of
+         * the mm won't complain on "lingering" asi mappings. */
+        asi_unmap_task_stack(current);
 
 	/* Once we are committed compute the creds */
 	retval = bprm_creds_from_file(bprm);
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 2763cb1a974c..6e9a261a2b9d 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -66,8 +66,13 @@ static inline struct asi *asi_get_target(void) { return NULL; }
 
 static inline struct asi *asi_get_current(void) { return NULL; }
 
-static inline
-int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
+static inline int asi_map_task_stack(struct task_struct *tsk, struct asi *asi)
+{ return 0; }
+
+static inline void asi_unmap_task_stack(struct task_struct *tsk) { }
+
+static inline int asi_map_gfp(struct asi *asi, void *addr, size_t len,
+			      gfp_t gfp_flags)
 {
 	return 0;
 }
@@ -130,6 +135,13 @@ static inline int asi_load_module(struct module* module) {return 0;}
 
 static inline void asi_unload_module(struct module* module) { }
 
+static inline
+void asi_mark_pages_local_nonsensitive(struct page *pages, uint order,
+                                       struct mm_struct *mm) { }
+
+static inline
+void asi_clear_pages_local_nonsensitive(struct page *pages, uint order) { }
+
 #endif  /* !_ASSEMBLY_ */
 
 #endif /* !CONFIG_ADDRESS_SPACE_ISOLATION */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78c351e35fec..87ad45e52b19 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -67,6 +67,7 @@ struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
 struct task_group;
+struct asi;
 
 /*
  * Task state bitmask. NOTE! These bits are also
@@ -1470,6 +1471,10 @@ struct task_struct {
 	int				mce_count;
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        struct asi *asi_stack_mapped;
+#endif
+
 #ifdef CONFIG_KRETPROBES
 	struct llist_head               kretprobe_instances;
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index ab2749cf6887..f21cc21814d1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -768,7 +768,7 @@ void __noreturn do_exit(long code)
 	profile_task_exit(tsk);
 	kcov_task_exit(tsk);
 
-        /* TODO: (oweisse) unmap the stack from ASI */
+	asi_unmap_task_stack(tsk);
 
 	coredump_task_exit(tsk);
 	ptrace_event(PTRACE_EVENT_EXIT, code);
diff --git a/kernel/fork.c b/kernel/fork.c
index cb147a72372d..876fefc477cb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -216,7 +216,6 @@ static int free_vm_stack_cache(unsigned int cpu)
 
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
-  /* TODO: (oweisse) Add annotation to map the stack into ASI */
 #ifdef CONFIG_VMAP_STACK
 	void *stack;
 	int i;
@@ -269,7 +268,16 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
 					     THREAD_SIZE_ORDER);
 
+        /* When marking pages as PageLocalNonSesitive we set the page->mm to be
+         * NULL. We must make sure the flag is cleared from the stack pages
+         * before free_pages is called. Otherwise, page->mm will be accessed
+         * which will reuslt in NULL reference. page_address() below will yield
+         * an aliased address after ASI_LOCAL_MAP, thanks to
+         * PageLocalNonSesitive flag. */
 	if (likely(page)) {
+                asi_mark_pages_local_nonsensitive(page,
+                                                  THREAD_SIZE_ORDER,
+                                                  NULL);
 		tsk->stack = kasan_reset_tag(page_address(page));
 		return tsk->stack;
 	}
@@ -301,6 +309,14 @@ static inline void free_thread_stack(struct task_struct *tsk)
 	}
 #endif
 
+        /* We must clear the PageNonSensitive flag before calling free_pages().
+         * Otherwise page->mm (which is NULL) will be accessed, in order to
+         * unmap the pages from ASI. Specifically for the stack, we assume the
+         * pages were already unmapped from ASI before we got here, via
+         * asi_unmap_task_stack(). */
+        asi_clear_pages_local_nonsensitive(virt_to_page(tsk->stack),
+                                                        THREAD_SIZE_ORDER);
+
 	__free_pages(virt_to_page(tsk->stack), THREAD_SIZE_ORDER);
 }
 # else
@@ -436,6 +452,7 @@ static void release_task_stack(struct task_struct *tsk)
 	if (WARN_ON(READ_ONCE(tsk->__state) != TASK_DEAD))
 		return;  /* Better to leak the stack than to free prematurely */
 
+        asi_unmap_task_stack(tsk);
 	account_kernel_stack(tsk, -1);
 	free_thread_stack(tsk);
 	tsk->stack = NULL;
@@ -916,6 +933,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	 * functions again.
 	 */
 	tsk->stack = stack;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	tsk->asi_stack_mapped = NULL;
+#endif
 #ifdef CONFIG_VMAP_STACK
 	tsk->stack_vm_area = stack_vm_area;
 #endif
-- 
2.35.1.473.g83b2b277ed-goog

