Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648EF4C0C04
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiBWF1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiBWF0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA66CA63
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so26693792ybg.8
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xuSOdR8cu+3sckZI73No+K9Gsgd7KYxoVcTvOLd9SRE=;
        b=L1vzi2HE8mlZkGyGTJ2UNkXNrCVKkhnCd6edxiG2679p05lL9RiITgedK2mHCr1gL1
         r2NbbiBimY0XMB+ilTAP/tinO8mfPjfgIiKo0Vo4CIbvxKkOOdhmUUJYzmRPnVEAIELz
         CaVtVNSnDCTPdbHIF9MBinzjbvZUfNhf/kWzWIx9iGyWw1+hTpjVB6Q9fAmZ4GqOYOQ9
         UfdgAMaldxCH3MN9zplE0ZKYVWhDkyZhstobQhDLPnFPNehmwZEzxYqfvR65uiELnTbL
         w+77nDxtgfJrLubYlcykpyqTJJAw4YhWcHGLjL5ZvkLqkeKvUc2iiWBXMc2g3lSez3xL
         mBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xuSOdR8cu+3sckZI73No+K9Gsgd7KYxoVcTvOLd9SRE=;
        b=ZNr59EM1mPumgJzSFyZl/8Ys2Rdpd4lG/1risRpjVi2eFJ0b47n6MiVkM+sfywk2OV
         MuW9mVMAEq+CGj9pgNwntZZ490Tt21fSWq3EFRDpEqEx6bp+Po0eqTlG+n2/xJLQ0J/g
         Ww69o1vud0yMb5mYjlKqFsLjCMyORhWVcfsvNf8HO41qzZVxPgmD2gDNkpPkYKhajMe9
         NsaIQndoTFSRHUl75uRvEHMFm6EpBORyIsPiUiHP35xy0dIQdGAmHzpkt4TmI9dZgukN
         VHwfXC/FYyRXDDOR0xhwIy8DBYKmCRhnwPziE04CIyjkpVcvSzwTzKLt9qmwzmtg83Cx
         l1+w==
X-Gm-Message-State: AOAM531/3RO9BjsXvMVmBcqSVYOJLt91eY50y7RohTfAXOXgvHffSpaI
        zDJeIQi42waSw5XDvrjkc38sPUM/85zw
X-Google-Smtp-Source: ABdhPJxz+92U+hDuWLEHSSBb08IRQ0vjXntk0j4pQJ0mXKWbSMLKP0n+iJJ9k2gkkoSoqaVm7kKAazHDcEee
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:aa2c:0:b0:624:64ce:8550 with SMTP id
 s41-20020a25aa2c000000b0062464ce8550mr16649367ybi.105.1645593890279; Tue, 22
 Feb 2022 21:24:50 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:05 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-30-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 29/47] mm: asi: Reduce TLB flushes when freeing pages asynchronously
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

When we are freeing pages asynchronously (because the original free
was issued with IRQs disabled), issue only one TLB flush per execution
of the async work function. If there is only one page to free, we do a
targeted flush for that page only. Otherwise, we just do a full flush.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/tlbflush.h |  8 +++++
 arch/x86/mm/tlb.c               | 52 ++++++++++++++++++++-------------
 include/linux/mm_types.h        | 30 +++++++++++++------
 mm/page_alloc.c                 | 40 ++++++++++++++++++++-----
 4 files changed, 93 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 85315d1d2d70..7d04aa2a5f86 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -296,6 +296,14 @@ unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush);
 u16 kern_pcid(u16 asid);
 u16 asi_pcid(struct asi *asi, u16 asid);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+void __asi_prepare_tlb_flush(struct asi *asi, u64 *new_tlb_gen);
+void __asi_flush_tlb_range(u64 mm_context_id, u16 pcid_index, u64 new_tlb_gen,
+			   size_t start, size_t end, const cpumask_t *cpu_mask);
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 #endif /* !MODULE */
 
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 2a442335501f..fcd2c8e92f83 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1302,21 +1302,10 @@ static bool is_asi_active_on_cpu(int cpu, void *info)
 	return per_cpu(asi_cpu_state.curr_asi, cpu);
 }
 
-void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
+void __asi_prepare_tlb_flush(struct asi *asi, u64 *new_tlb_gen)
 {
-	size_t start = (size_t)addr;
-	size_t end = start + len;
-	struct flush_tlb_info *info;
-	u64 mm_context_id;
-	const cpumask_t *cpu_mask;
-	u64 new_tlb_gen = 0;
-
-	if (!static_cpu_has(X86_FEATURE_ASI))
-		return;
-
 	if (static_cpu_has(X86_FEATURE_PCID)) {
-		new_tlb_gen = atomic64_inc_return(asi->tlb_gen);
-
+		*new_tlb_gen = atomic64_inc_return(asi->tlb_gen);
 		/*
 		 * The increment of tlb_gen must happen before the curr_asi
 		 * reads in is_asi_active_on_cpu(). That ensures that if another
@@ -1326,8 +1315,35 @@ void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
 		 */
 		smp_mb__after_atomic();
 	}
+}
+
+void __asi_flush_tlb_range(u64 mm_context_id, u16 pcid_index, u64 new_tlb_gen,
+			   size_t start, size_t end, const cpumask_t *cpu_mask)
+{
+	struct flush_tlb_info *info;
 
 	preempt_disable();
+	info = get_flush_tlb_info(NULL, start, end, 0, false, new_tlb_gen,
+				  mm_context_id, pcid_index);
+
+	on_each_cpu_cond_mask(is_asi_active_on_cpu, do_asi_tlb_flush, info,
+			      true, cpu_mask);
+	put_flush_tlb_info();
+	preempt_enable();
+}
+
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
+{
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	u64 mm_context_id;
+	u64 new_tlb_gen = 0;
+	const cpumask_t *cpu_mask;
+
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return;
+
+	__asi_prepare_tlb_flush(asi, &new_tlb_gen);
 
 	if (asi == ASI_GLOBAL_NONSENSITIVE) {
 		mm_context_id = U64_MAX;
@@ -1337,14 +1353,8 @@ void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
 		cpu_mask = mm_cpumask(asi->mm);
 	}
 
-	info = get_flush_tlb_info(NULL, start, end, 0, false, new_tlb_gen,
-				  mm_context_id, asi->pcid_index);
-
-	on_each_cpu_cond_mask(is_asi_active_on_cpu, do_asi_tlb_flush, info,
-			      true, cpu_mask);
-
-	put_flush_tlb_info();
-	preempt_enable();
+	__asi_flush_tlb_range(mm_context_id, asi->pcid_index, new_tlb_gen,
+			      start, end, cpu_mask);
 }
 
 #endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 56511adc263e..7d38229ca85c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -193,21 +193,33 @@ struct page {
 		/** @rcu_head: You can use this to free a page by RCU. */
 		struct rcu_head rcu_head;
 
-#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#if defined(CONFIG_ADDRESS_SPACE_ISOLATION) && !defined(BUILD_VDSO32)
 		struct {
 			/* Links the pages_to_free_async list */
 			struct llist_node async_free_node;
 
 			unsigned long _asi_pad_1;
-			unsigned long _asi_pad_2;
+			u64 asi_tlb_gen;
 
-			/*
-			 * Upon allocation of a locally non-sensitive page, set
-			 * to the allocating mm. Must be set to the same mm when
-			 * the page is freed. May potentially be overwritten in
-			 * the meantime, as long as it is restored before free.
-			 */
-			struct mm_struct *asi_mm;
+			union {
+				/*
+				 * Upon allocation of a locally non-sensitive
+				 * page, set to the allocating mm. Must be set
+				 * to the same mm when the page is freed. May
+				 * potentially be overwritten in the meantime,
+				 * as long as it is restored before free.
+				 */
+				struct mm_struct *asi_mm;
+
+				/*
+				 * Set to the above mm's context ID if the page
+				 * is being freed asynchronously. Can't directly
+				 * use the mm_struct, unless we take additional
+				 * steps to avoid it from being freed while the
+				 * async work is pending.
+				 */
+				u64 asi_mm_ctx_id;
+			};
 		};
 #endif
 	};
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 01784bff2a80..998ff6a56732 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5182,20 +5182,41 @@ static void async_free_work_fn(struct work_struct *work)
 {
 	struct page *page, *tmp;
 	struct llist_node *pages_to_free;
-	void *va;
-	size_t len;
+	size_t addr;
 	uint order;
 
 	pages_to_free = llist_del_all(this_cpu_ptr(&pages_to_free_async));
 
-	/* A later patch will do a more optimized TLB flush. */
+	if (!pages_to_free)
+		return;
+
+	/* If we only have one page to free, then do a targeted TLB flush. */
+	if (!llist_next(pages_to_free)) {
+		page = llist_entry(pages_to_free, struct page, async_free_node);
+		addr = (size_t)page_to_virt(page);
+		order = page->private;
+
+		__asi_flush_tlb_range(page->asi_mm_ctx_id, 0, page->asi_tlb_gen,
+				      addr, addr + PAGE_SIZE * (1 << order),
+				      cpu_online_mask);
+		/* Need to clear, since it shares space with page->mapping. */
+		page->asi_tlb_gen = 0;
+
+		__free_the_page(page, order);
+		return;
+	}
+
+	/*
+	 * Otherwise, do a full flush. We could potentially try to optimize it
+	 * via taking a union of what needs to be flushed, but it may not be
+	 * worth the additional complexity.
+	 */
+	asi_flush_tlb_range(ASI_GLOBAL_NONSENSITIVE, 0, TLB_FLUSH_ALL);
 
 	llist_for_each_entry_safe(page, tmp, pages_to_free, async_free_node) {
-		va = page_to_virt(page);
 		order = page->private;
-		len = PAGE_SIZE * (1 << order);
-
-		asi_flush_tlb_range(ASI_GLOBAL_NONSENSITIVE, va, len);
+		/* Need to clear, since it shares space with page->mapping. */
+		page->asi_tlb_gen = 0;
 		__free_the_page(page, order);
 	}
 }
@@ -5291,6 +5312,11 @@ static bool asi_unmap_freed_pages(struct page *page, unsigned int order)
 	if (!async_flush_needed)
 		return true;
 
+	page->asi_mm_ctx_id = PageGlobalNonSensitive(page)
+			      ? U64_MAX : asi->mm->context.ctx_id;
+
+	__asi_prepare_tlb_flush(asi, &page->asi_tlb_gen);
+
 	page->private = order;
 	llist_add(&page->async_free_node, this_cpu_ptr(&pages_to_free_async));
 
-- 
2.35.1.473.g83b2b277ed-goog

