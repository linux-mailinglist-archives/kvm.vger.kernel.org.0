Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A44C0C08
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiBWF1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbiBWF0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:20 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB366E4EE
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:01 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d6180e0ab4so162341737b3.2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ht+B2vhllT9TUcS9YCbehkBKQfQF+JUOyLFYYS9ZTII=;
        b=X4LjelXhHrsgUAmOKDupgWtkMo3qDIfheiClzbfmM97+mtJS0Ry/l7ad7kEFvNmAMO
         ru8xaZ7F2Wij3ltuM/YwpEuAwo9u28wNABujo/9gA7WhQcealUnUhGS4exGNNI00mM/h
         QXyufTreNJLTmpGLik/8e62TY2RamcG4YVt1a9kq7jRUpJ5gpqeZZz9Udb++OBULoX7j
         8m+I6tqS0xRBkRNDUPy1xvHpGNE8YXXtkcOVcVJNJbGCsF4uJmSxV3FYbdH5JUcqjBWM
         ug6RC3+13tjcavk58yKUhJSjRMK2SZqloPpTOfJuLf4aHFrFV1j6/rXU3Dwv5NYwIvsx
         Wd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ht+B2vhllT9TUcS9YCbehkBKQfQF+JUOyLFYYS9ZTII=;
        b=sdENzewPF/kZRKBNhE/vij5tpUY55MRyEcfXv2TL69xQh/sBzsLDKYi0xWQawWryhy
         OrjwMBlS2xQmYY+3ZMitSsLD0VmUCXtoSDqoM8eELajHe2rULP83SZ3W7D8mEzDVWOIH
         xiRcXH1OmWpB67xQRk3BBSu2rDFvYxu9kkvdGxF7qjl/etCaxpKUOlvNJTRlSVAt0HEC
         MpcPAy8QNY9iBqUuEKnDt8vie5boiMYvmpBBak0pyw3hOuwZAoBQTtN1AukH+ter87jF
         jqzY29IwKGYZvGx9nZuJRd0OVr6tw+G82xBWlMkGN8QyFubjm/fk+GNnV7Y/mF1fbuh9
         A0RA==
X-Gm-Message-State: AOAM531r9WhJPg5EMqQ+eVveUSjGglU2uZmkr0rpvLIruLbbA8lPJ9Xc
        Py3hmgbT38opVcgUgJtBakrLjWN/25sN
X-Google-Smtp-Source: ABdhPJzjFJlAylJJF1esEWWn/fBYg6FPQgSZQ8x6J/wS+NLWdoHP+2b1OSKZqRs0ZEPrSWXIKV7/9dmH6JQ/
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:6b4d:0:b0:624:7295:42ee with SMTP id
 o13-20020a256b4d000000b00624729542eemr15381999ybm.290.1645593888119; Tue, 22
 Feb 2022 21:24:48 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:04 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-29-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 28/47] mm: asi: Avoid TLB flush IPIs to CPUs not in ASI context
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

Most CPUs will not be running in a restricted ASI address space at any
given time. So when we need to do an ASI TLB flush, we can skip those
CPUs and let them do a flush at the time of the next ASI Enter.

Furthermore, for flushes related to local non-sensitive memory, we can
restrict the CPU set even further to those CPUs that have that specific
mm_struct loaded.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h      |   9 +-
 arch/x86/include/asm/tlbflush.h |  47 +++----
 arch/x86/mm/asi.c               |  73 +++++++++--
 arch/x86/mm/tlb.c               | 209 ++++++++++++++++++++++++++++++--
 4 files changed, 282 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 1a77917c79c7..35421356584b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -41,6 +41,8 @@ struct asi {
 	struct asi_class *class;
 	struct mm_struct *mm;
 	u16 pcid_index;
+	atomic64_t *tlb_gen;
+	atomic64_t __tlb_gen;
 	int64_t asi_ref_count;
 };
 
@@ -138,11 +140,16 @@ static inline int asi_intr_nest_depth(void)
 	return current->thread.intr_nest_depth;
 }
 
+void asi_get_latest_tlb_gens(struct asi *asi, u64 *latest_local_tlb_gen,
+			     u64 *latest_global_tlb_gen);
+
 #define INIT_MM_ASI(init_mm)						\
 	.asi = {							\
 		[0] = {							\
 			.pgd = asi_global_nonsensitive_pgd,		\
-			.mm = &init_mm					\
+			.mm = &init_mm,					\
+			.__tlb_gen = ATOMIC64_INIT(1),			\
+			.tlb_gen = &init_mm.asi[0].__tlb_gen		\
 		}							\
 	},
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 295bebdb4395..85315d1d2d70 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -63,7 +63,8 @@ static inline void cr4_clear_bits(unsigned long mask)
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 
 struct asi_tlb_context {
-	bool flush_pending;
+	u64 local_tlb_gen;
+	u64 global_tlb_gen;
 };
 
 #endif
@@ -223,6 +224,20 @@ struct flush_tlb_info {
 	unsigned int		initiating_cpu;
 	u8			stride_shift;
 	u8			freed_tables;
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/*
+	 * We can't use the mm pointer above, as there can be some cases where
+	 * the mm is already freed. Of course, a flush wouldn't be necessary
+	 * in that case, and we would know that when we compare the context ID.
+	 *
+	 * If U64_MAX, then a global flush would be done.
+	 */
+	u64			mm_context_id;
+
+	/* If non-zero, flush only the ASI instance with this PCID index. */
+	u16			asi_pcid_index;
+#endif
 };
 
 void flush_tlb_local(void);
@@ -281,36 +296,6 @@ unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush);
 u16 kern_pcid(u16 asid);
 u16 asi_pcid(struct asi *asi, u16 asid);
 
-#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
-
-static inline bool *__asi_tlb_flush_pending(struct asi *asi)
-{
-	struct tlb_state *tlb_state;
-	struct tlb_context *tlb_context;
-
-	tlb_state = this_cpu_ptr(&cpu_tlbstate);
-	tlb_context = &tlb_state->ctxs[tlb_state->loaded_mm_asid];
-	return &tlb_context->asi_context[asi->pcid_index].flush_pending;
-}
-
-static inline bool asi_get_and_clear_tlb_flush_pending(struct asi *asi)
-{
-	bool *tlb_flush_pending_ptr = __asi_tlb_flush_pending(asi);
-	bool tlb_flush_pending = READ_ONCE(*tlb_flush_pending_ptr);
-
-	if (tlb_flush_pending)
-		WRITE_ONCE(*tlb_flush_pending_ptr, false);
-
-	return tlb_flush_pending;
-}
-
-static inline void asi_clear_pending_tlb_flush(struct asi *asi)
-{
-	WRITE_ONCE(*__asi_tlb_flush_pending(asi), false);
-}
-
-#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
-
 #endif /* !MODULE */
 
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 17b8e6e60312..29c74b6d4262 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -355,6 +355,11 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 		for (i = pgd_index(VMALLOC_GLOBAL_NONSENSITIVE_START);
 		     i < PTRS_PER_PGD; i++)
 			set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
+
+		asi->tlb_gen = &mm->asi[0].__tlb_gen;
+	} else {
+		asi->tlb_gen = &asi->__tlb_gen;
+		atomic64_set(asi->tlb_gen, 1);
 	}
 
 exit_unlock:
@@ -384,11 +389,26 @@ void asi_destroy(struct asi *asi)
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
 
+void asi_get_latest_tlb_gens(struct asi *asi, u64 *latest_local_tlb_gen,
+			     u64 *latest_global_tlb_gen)
+{
+	if (likely(asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE))
+		*latest_global_tlb_gen =
+			atomic64_read(ASI_GLOBAL_NONSENSITIVE->tlb_gen);
+	else
+		*latest_global_tlb_gen = 0;
+
+	*latest_local_tlb_gen = atomic64_read(asi->tlb_gen);
+}
+
 void __asi_enter(void)
 {
 	u64 asi_cr3;
 	u16 pcid;
 	bool need_flush = false;
+	u64 latest_local_tlb_gen, latest_global_tlb_gen;
+	struct tlb_state *tlb_state;
+	struct asi_tlb_context *tlb_context;
 	struct asi *target = this_cpu_read(asi_cpu_state.target_asi);
 
 	VM_BUG_ON(preemptible());
@@ -397,17 +417,35 @@ void __asi_enter(void)
 	if (!target || target == this_cpu_read(asi_cpu_state.curr_asi))
 		return;
 
-	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
-		  LOADED_MM_SWITCHING);
+	tlb_state = this_cpu_ptr(&cpu_tlbstate);
+	VM_BUG_ON(tlb_state->loaded_mm == LOADED_MM_SWITCHING);
 
 	this_cpu_write(asi_cpu_state.curr_asi, target);
 
-	if (static_cpu_has(X86_FEATURE_PCID))
-		need_flush = asi_get_and_clear_tlb_flush_pending(target);
+	if (static_cpu_has(X86_FEATURE_PCID)) {
+		/*
+		 * curr_asi write has to happen before the asi->tlb_gen reads
+		 * below.
+		 *
+		 * See comments in asi_flush_tlb_range().
+		 */
+		smp_mb();
+
+		asi_get_latest_tlb_gens(target, &latest_local_tlb_gen,
+					&latest_global_tlb_gen);
+
+		tlb_context = &tlb_state->ctxs[tlb_state->loaded_mm_asid]
+					.asi_context[target->pcid_index];
+
+		if (READ_ONCE(tlb_context->local_tlb_gen) < latest_local_tlb_gen
+		    || READ_ONCE(tlb_context->global_tlb_gen) <
+		       latest_global_tlb_gen)
+			need_flush = true;
+	}
 
 	/*
 	 * It is possible that we may get a TLB flush IPI after
-	 * already reading need_flush, in which case we won't do the
+	 * already calculating need_flush, in which case we won't do the
 	 * flush below. However, in that case the interrupt epilog
 	 * will also call __asi_enter(), which will do the flush.
 	 */
@@ -416,6 +454,23 @@ void __asi_enter(void)
 	asi_cr3 = build_cr3_pcid(target->pgd, pcid, !need_flush);
 	write_cr3(asi_cr3);
 
+	if (static_cpu_has(X86_FEATURE_PCID)) {
+		/*
+		 * There is a small possibility that an interrupt happened
+		 * after the read of the latest_*_tlb_gen above and when
+		 * that interrupt did an asi_enter() upon return, it read
+		 * an even higher latest_*_tlb_gen and already updated the
+		 * tlb_context->*tlb_gen accordingly. In that case, the
+		 * following will move back the tlb_context->*tlb_gen. That
+		 * isn't ideal, but it should not cause any correctness issues.
+		 * We may just end up doing an unnecessary TLB flush on the next
+		 * asi_enter(). If we really needed to avoid that, we could
+		 * just do a cmpxchg, but it is likely not necessary.
+		 */
+		WRITE_ONCE(tlb_context->local_tlb_gen, latest_local_tlb_gen);
+		WRITE_ONCE(tlb_context->global_tlb_gen, latest_global_tlb_gen);
+	}
+
 	if (target->class->ops.post_asi_enter)
 		target->class->ops.post_asi_enter();
 }
@@ -504,6 +559,8 @@ int asi_init_mm_state(struct mm_struct *mm)
 	if (!mm->asi_enabled)
 		return 0;
 
+	mm->asi[0].tlb_gen = &mm->asi[0].__tlb_gen;
+	atomic64_set(mm->asi[0].tlb_gen, 1);
 	mm->asi[0].mm = mm;
 	mm->asi[0].pgd = (pgd_t *)__get_free_page(GFP_PGTABLE_USER);
 	if (!mm->asi[0].pgd)
@@ -718,12 +775,6 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb)
 		asi_flush_tlb_range(asi, addr, len);
 }
 
-void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
-{
-	/* Later patches will do a more optimized flush. */
-	flush_tlb_kernel_range((ulong)addr, (ulong)addr + len);
-}
-
 void *asi_va(unsigned long pa)
 {
 	struct page *page = pfn_to_page(PHYS_PFN(pa));
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5c9681df3a16..2a442335501f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -31,6 +31,8 @@
 # define __flush_tlb_multi(msk, info)	native_flush_tlb_multi(msk, info)
 #endif
 
+STATIC_NOPV void native_flush_tlb_global(void);
+
 /*
  *	TLB flushing, formerly SMP-only
  *		c/o Linus Torvalds.
@@ -173,7 +175,6 @@ static void invalidate_kern_pcid(void)
 
 static void invalidate_asi_pcid(struct asi *asi, u16 asid)
 {
-	uint i;
 	struct asi_tlb_context *asi_tlb_context;
 
 	if (!static_cpu_has(X86_FEATURE_ASI) ||
@@ -183,21 +184,30 @@ static void invalidate_asi_pcid(struct asi *asi, u16 asid)
 	asi_tlb_context = this_cpu_ptr(cpu_tlbstate.ctxs[asid].asi_context);
 
 	if (asi)
-		asi_tlb_context[asi->pcid_index].flush_pending = true;
+		asi_tlb_context[asi->pcid_index] =
+					(struct asi_tlb_context) { 0 };
 	else
-		for (i = 1; i < ASI_MAX_NUM; i++)
-			asi_tlb_context[i].flush_pending = true;
+		memset(asi_tlb_context, 0,
+		       sizeof(struct asi_tlb_context) * ASI_MAX_NUM);
 }
 
 static void flush_asi_pcid(struct asi *asi)
 {
 	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
-	/*
-	 * The flag should be cleared before the INVPCID, to avoid clearing it
-	 * in case an interrupt/exception sets it again after the INVPCID.
-	 */
-	asi_clear_pending_tlb_flush(asi);
+	struct asi_tlb_context *tlb_context = this_cpu_ptr(
+		&cpu_tlbstate.ctxs[asid].asi_context[asi->pcid_index]);
+	u64 latest_local_tlb_gen = atomic64_read(asi->tlb_gen);
+	u64 latest_global_tlb_gen = atomic64_read(
+					ASI_GLOBAL_NONSENSITIVE->tlb_gen);
+
 	invpcid_flush_single_context(asi_pcid(asi, asid));
+
+	/*
+	 * This could sometimes move the *_tlb_gen backwards. See comments
+	 * in __asi_enter().
+	 */
+	WRITE_ONCE(tlb_context->local_tlb_gen, latest_local_tlb_gen);
+	WRITE_ONCE(tlb_context->global_tlb_gen, latest_global_tlb_gen);
 }
 
 static void __flush_tlb_one_asi(struct asi *asi, u16 asid, size_t addr)
@@ -1050,7 +1060,7 @@ static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
 static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 			unsigned long start, unsigned long end,
 			unsigned int stride_shift, bool freed_tables,
-			u64 new_tlb_gen)
+			u64 new_tlb_gen, u64 mm_ctx_id, u16 asi_pcid_index)
 {
 	struct flush_tlb_info *info = this_cpu_ptr(&flush_tlb_info);
 
@@ -1071,6 +1081,11 @@ static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 	info->new_tlb_gen	= new_tlb_gen;
 	info->initiating_cpu	= smp_processor_id();
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	info->mm_context_id	= mm_ctx_id;
+	info->asi_pcid_index	= asi_pcid_index;
+#endif
+
 	return info;
 }
 
@@ -1104,7 +1119,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	new_tlb_gen = inc_mm_tlb_gen(mm);
 
 	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
-				  new_tlb_gen);
+				  new_tlb_gen, 0, 0);
 
 	/*
 	 * flush_tlb_multi() is not optimized for the common case in which only
@@ -1157,7 +1172,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 		struct flush_tlb_info *info;
 
 		preempt_disable();
-		info = get_flush_tlb_info(NULL, start, end, 0, false, 0);
+		info = get_flush_tlb_info(NULL, start, end, 0, false, 0, 0, 0);
 
 		on_each_cpu(do_kernel_range_flush, info, 1);
 
@@ -1166,6 +1181,174 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	}
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static inline void invlpg_range(size_t start, size_t end, size_t stride)
+{
+	size_t addr;
+
+	for (addr = start; addr < end; addr += stride)
+		invlpg(addr);
+}
+
+static bool asi_needs_tlb_flush(struct asi *asi, struct flush_tlb_info *info)
+{
+	if (!asi ||
+	    (info->mm_context_id != U64_MAX &&
+	     info->mm_context_id != asi->mm->context.ctx_id) ||
+	    (info->asi_pcid_index && info->asi_pcid_index != asi->pcid_index))
+		return false;
+
+	if (unlikely(!(asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE)) &&
+	    (info->mm_context_id == U64_MAX || !info->asi_pcid_index))
+		return false;
+
+	return true;
+}
+
+static void __flush_asi_tlb_all(struct asi *asi)
+{
+	if (static_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+		flush_asi_pcid(asi);
+		return;
+	}
+
+	/* See comments in native_flush_tlb_local() */
+	if (unlikely(!asi_is_target_unrestricted()) &&
+	    asi_intr_nest_depth() == 0) {
+		native_flush_tlb_global();
+		return;
+	}
+
+	/* Let the next ASI Enter do the flush */
+	asi_exit();
+}
+
+static void do_asi_tlb_flush(void *data)
+{
+	struct flush_tlb_info *info = data;
+	struct tlb_state *tlb_state = this_cpu_ptr(&cpu_tlbstate);
+	struct asi_tlb_context *tlb_context;
+	struct asi *asi = asi_get_current();
+	u64 latest_local_tlb_gen, latest_global_tlb_gen;
+	u64 curr_local_tlb_gen, curr_global_tlb_gen;
+	u64 new_local_tlb_gen, new_global_tlb_gen;
+	bool do_flush_all;
+
+	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+
+	if (!asi_needs_tlb_flush(asi, info))
+		return;
+
+	do_flush_all = info->end - info->start >
+		       (tlb_single_page_flush_ceiling << PAGE_SHIFT);
+
+	if (!static_cpu_has(X86_FEATURE_PCID)) {
+		if (do_flush_all)
+			__flush_asi_tlb_all(asi);
+		else
+			invlpg_range(info->start, info->end, PAGE_SIZE);
+		return;
+	}
+
+	tlb_context = &tlb_state->ctxs[tlb_state->loaded_mm_asid]
+				.asi_context[asi->pcid_index];
+
+	asi_get_latest_tlb_gens(asi, &latest_local_tlb_gen,
+				&latest_global_tlb_gen);
+
+	curr_local_tlb_gen = READ_ONCE(tlb_context->local_tlb_gen);
+	curr_global_tlb_gen = READ_ONCE(tlb_context->global_tlb_gen);
+
+	if (info->mm_context_id == U64_MAX) {
+		new_global_tlb_gen = info->new_tlb_gen;
+		new_local_tlb_gen = curr_local_tlb_gen;
+	} else {
+		new_local_tlb_gen = info->new_tlb_gen;
+		new_global_tlb_gen = curr_global_tlb_gen;
+	}
+
+	/* Somebody already did a full flush */
+	if (new_local_tlb_gen <= curr_local_tlb_gen &&
+	    new_global_tlb_gen <= curr_global_tlb_gen)
+		return;
+
+	/*
+	 * If we can't bring the TLB up-to-date with a range flush, then do a
+	 * full flush anyway.
+	 */
+	if (do_flush_all || !(new_local_tlb_gen == latest_local_tlb_gen &&
+			      new_global_tlb_gen == latest_global_tlb_gen &&
+			      new_local_tlb_gen <= curr_local_tlb_gen + 1 &&
+			      new_global_tlb_gen <= curr_global_tlb_gen + 1)) {
+		__flush_asi_tlb_all(asi);
+		return;
+	}
+
+	invlpg_range(info->start, info->end, PAGE_SIZE);
+
+	/*
+	 * If we are still in ASI context, then all the INVLPGs flushed the
+	 * ASI PCID and so we can update the tlb_gens.
+	 */
+	if (asi_get_current() == asi) {
+		WRITE_ONCE(tlb_context->local_tlb_gen, new_local_tlb_gen);
+		WRITE_ONCE(tlb_context->global_tlb_gen, new_global_tlb_gen);
+	}
+}
+
+static bool is_asi_active_on_cpu(int cpu, void *info)
+{
+	return per_cpu(asi_cpu_state.curr_asi, cpu);
+}
+
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
+{
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	struct flush_tlb_info *info;
+	u64 mm_context_id;
+	const cpumask_t *cpu_mask;
+	u64 new_tlb_gen = 0;
+
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return;
+
+	if (static_cpu_has(X86_FEATURE_PCID)) {
+		new_tlb_gen = atomic64_inc_return(asi->tlb_gen);
+
+		/*
+		 * The increment of tlb_gen must happen before the curr_asi
+		 * reads in is_asi_active_on_cpu(). That ensures that if another
+		 * CPU is in asi_enter() and happens to write to curr_asi after
+		 * is_asi_active_on_cpu() read it, it will see the updated
+		 * tlb_gen and perform a flush during the TLB switch.
+		 */
+		smp_mb__after_atomic();
+	}
+
+	preempt_disable();
+
+	if (asi == ASI_GLOBAL_NONSENSITIVE) {
+		mm_context_id = U64_MAX;
+		cpu_mask = cpu_online_mask;
+	} else {
+		mm_context_id = asi->mm->context.ctx_id;
+		cpu_mask = mm_cpumask(asi->mm);
+	}
+
+	info = get_flush_tlb_info(NULL, start, end, 0, false, new_tlb_gen,
+				  mm_context_id, asi->pcid_index);
+
+	on_each_cpu_cond_mask(is_asi_active_on_cpu, do_asi_tlb_flush, info,
+			      true, cpu_mask);
+
+	put_flush_tlb_info();
+	preempt_enable();
+}
+
+#endif
+
 /*
  * This can be used from process context to figure out what the value of
  * CR3 is without needing to do a (slow) __read_cr3().
@@ -1415,7 +1598,7 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 
 	int cpu = get_cpu();
 
-	info = get_flush_tlb_info(NULL, 0, TLB_FLUSH_ALL, 0, false, 0);
+	info = get_flush_tlb_info(NULL, 0, TLB_FLUSH_ALL, 0, false, 0, 0, 0);
 	/*
 	 * flush_tlb_multi() is not optimized for the common case in which only
 	 * a local TLB flush is needed. Optimize this use-case by calling
-- 
2.35.1.473.g83b2b277ed-goog

