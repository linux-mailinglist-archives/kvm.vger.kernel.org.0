Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ADB4C0C02
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbiBWF1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbiBWF0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6126E2BF
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:55 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d726bd83a2so91086467b3.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uZNDncAP+HAcrLlxbbBV0jFwf5VHCLxBgZuEl9jtIsw=;
        b=r7+qr6EGJVpdhQWG8PE8sNYbh0H6kTLpdH6ctOr0wPyBw/Z56OW3u31LYarb4QOnRX
         rF4lg3l0IVEqPlgJWaO9d3dWxAEdyJe1HcTUm1KWff1m3xuyDOy9VVB9sTaWZhhffwst
         nktPdcdn5pMY1JLUsndyvZTdi+apZc+M8CANZ+FleFcjiBh1KMmN3V5cV4UkdqGp6dj7
         eto63Nt1iYZsRhYWTV9r7EgsApuw+VuQRiPkO/uEZytDeujtWN47qFOJnrbnHuYu8/o4
         722Zq0PbXoAaWsxp0efHDuBM6HhxyWCGqP/XygpW0eZmFRIaDvse+6/DxrUVYKJYRCUo
         G3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uZNDncAP+HAcrLlxbbBV0jFwf5VHCLxBgZuEl9jtIsw=;
        b=l8NJ0z4VlL3CK0dneZUscdZq9IZ1RkpFijDSoZwfaEAFJ96EvsIkoC1eRBY7772RUf
         BlwvNSA+74Uj1PU5vUFvzTrDn2U2RrWl/oEWZYeeS30bnUpDloSAzY3xmPTUUqv1leW+
         LknvRrHBv/QTnMUsjnMPHA4+UqcuUh7s2zqIoQTiH0nNIZLZMIHOuIYE+iYJcve5R0YN
         oKF3LzWaJ5nLTI0+dZphxQ/8GwFo+mlO3O4I6EnGqVq2aPwa6+DW2qfFLVjXdlsCN+YY
         0eI0ystS7ZV7ot97mXMTfMmUMemXGDfpTHnz2iq1o3UQ7AljFR1kKFNehLtbXRxnCjxz
         nLHw==
X-Gm-Message-State: AOAM532vewLKUnrP/ySXFnMRoQuq0ILriyBNe9S+JYh5DHGvVqystMSG
        LUiw1g7Bb7BpO2AoJbfq8inKo5rqAevr
X-Google-Smtp-Source: ABdhPJyGbSHeEEC3fevrTXJ9nvduL9Idz1OuetENZ+6YGEpuvdg8wlXwAyrhsHfA5UVeantdGlz2RTX/R7Xv
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:6993:0:b0:624:55af:336c with SMTP id
 e141-20020a256993000000b0062455af336cmr19351145ybc.412.1645593885940; Tue, 22
 Feb 2022 21:24:45 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:03 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-28-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 27/47] mm: asi: Avoid TLB flushes during ASI CR3 switches
 when possible
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

The TLB flush functions are modified to flush the ASI PCIDs in addition
to the unrestricted kernel PCID and the KPTI PCID. Some tracking is
also added to figure out when the TLB state for ASI PCIDs is out-of-date
(e.g. due to lack of INVPCID support), and ASI Enter/Exit use this
information to skip a TLB flush during the CR3 switch when the TLB is
already up-to-date.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h      |  11 ++-
 arch/x86/include/asm/tlbflush.h |  47 ++++++++++
 arch/x86/mm/asi.c               |  38 +++++++-
 arch/x86/mm/tlb.c               | 152 ++++++++++++++++++++++++++++++--
 4 files changed, 234 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index aaa0d0bdbf59..1a77917c79c7 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -126,11 +126,18 @@ static inline void asi_intr_exit(void)
 	if (static_cpu_has(X86_FEATURE_ASI)) {
 		barrier();
 
-		if (--current->thread.intr_nest_depth == 0)
+		if (--current->thread.intr_nest_depth == 0) {
+			barrier();
 			__asi_enter();
+		}
 	}
 }
 
+static inline int asi_intr_nest_depth(void)
+{
+	return current->thread.intr_nest_depth;
+}
+
 #define INIT_MM_ASI(init_mm)						\
 	.asi = {							\
 		[0] = {							\
@@ -150,6 +157,8 @@ static inline void asi_intr_enter(void) { }
 
 static inline void asi_intr_exit(void) { }
 
+static inline int asi_intr_nest_depth(void) { return 0; }
+
 static inline void asi_init_thread_state(struct thread_struct *thread) { }
 
 static inline pgd_t *asi_pgd(struct asi *asi) { return NULL; }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index f9ec5e67e361..295bebdb4395 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -12,6 +12,7 @@
 #include <asm/invpcid.h>
 #include <asm/pti.h>
 #include <asm/processor-flags.h>
+#include <asm/asi.h>
 
 void __flush_tlb_all(void);
 
@@ -59,9 +60,20 @@ static inline void cr4_clear_bits(unsigned long mask)
  */
 #define TLB_NR_DYN_ASIDS	6
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+struct asi_tlb_context {
+	bool flush_pending;
+};
+
+#endif
+
 struct tlb_context {
 	u64 ctx_id;
 	u64 tlb_gen;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	struct asi_tlb_context asi_context[ASI_MAX_NUM];
+#endif
 };
 
 struct tlb_state {
@@ -100,6 +112,10 @@ struct tlb_state {
 	 */
 	bool invalidate_other;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* If set, ASI Exit needs to do a TLB flush during the CR3 switch */
+	bool kern_pcid_needs_flush;
+#endif
 	/*
 	 * Mask that contains TLB_NR_DYN_ASIDS+1 bits to indicate
 	 * the corresponding user PCID needs a flush next time we
@@ -262,8 +278,39 @@ extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 unsigned long build_cr3(pgd_t *pgd, u16 asid);
 unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush);
 
+u16 kern_pcid(u16 asid);
 u16 asi_pcid(struct asi *asi, u16 asid);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static inline bool *__asi_tlb_flush_pending(struct asi *asi)
+{
+	struct tlb_state *tlb_state;
+	struct tlb_context *tlb_context;
+
+	tlb_state = this_cpu_ptr(&cpu_tlbstate);
+	tlb_context = &tlb_state->ctxs[tlb_state->loaded_mm_asid];
+	return &tlb_context->asi_context[asi->pcid_index].flush_pending;
+}
+
+static inline bool asi_get_and_clear_tlb_flush_pending(struct asi *asi)
+{
+	bool *tlb_flush_pending_ptr = __asi_tlb_flush_pending(asi);
+	bool tlb_flush_pending = READ_ONCE(*tlb_flush_pending_ptr);
+
+	if (tlb_flush_pending)
+		WRITE_ONCE(*tlb_flush_pending_ptr, false);
+
+	return tlb_flush_pending;
+}
+
+static inline void asi_clear_pending_tlb_flush(struct asi *asi)
+{
+	WRITE_ONCE(*__asi_tlb_flush_pending(asi), false);
+}
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 #endif /* !MODULE */
 
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index dbfea3dc4bb1..17b8e6e60312 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -388,6 +388,7 @@ void __asi_enter(void)
 {
 	u64 asi_cr3;
 	u16 pcid;
+	bool need_flush = false;
 	struct asi *target = this_cpu_read(asi_cpu_state.target_asi);
 
 	VM_BUG_ON(preemptible());
@@ -401,8 +402,18 @@ void __asi_enter(void)
 
 	this_cpu_write(asi_cpu_state.curr_asi, target);
 
+	if (static_cpu_has(X86_FEATURE_PCID))
+		need_flush = asi_get_and_clear_tlb_flush_pending(target);
+
+	/*
+	 * It is possible that we may get a TLB flush IPI after
+	 * already reading need_flush, in which case we won't do the
+	 * flush below. However, in that case the interrupt epilog
+	 * will also call __asi_enter(), which will do the flush.
+	 */
+
 	pcid = asi_pcid(target, this_cpu_read(cpu_tlbstate.loaded_mm_asid));
-	asi_cr3 = build_cr3_pcid(target->pgd, pcid, false);
+	asi_cr3 = build_cr3_pcid(target->pgd, pcid, !need_flush);
 	write_cr3(asi_cr3);
 
 	if (target->class->ops.post_asi_enter)
@@ -437,12 +448,31 @@ void asi_exit(void)
 	asi = this_cpu_read(asi_cpu_state.curr_asi);
 
 	if (asi) {
+		bool need_flush = false;
+
 		if (asi->class->ops.pre_asi_exit)
 			asi->class->ops.pre_asi_exit();
 
-		unrestricted_cr3 =
-			build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
-				  this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+		if (static_cpu_has(X86_FEATURE_PCID) &&
+		    !static_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+			need_flush = this_cpu_read(
+					cpu_tlbstate.kern_pcid_needs_flush);
+			this_cpu_write(cpu_tlbstate.kern_pcid_needs_flush,
+				       false);
+		}
+
+		/*
+		 * It is possible that we may get a TLB flush IPI after
+		 * already reading need_flush. However, in that case the IPI
+		 * will not set flush_pending for the unrestricted address
+		 * space, as that is done by flush_tlb_one_user() only if
+		 * asi_intr_nest_depth() is 0.
+		 */
+
+		unrestricted_cr3 = build_cr3_pcid(
+			this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
+			kern_pcid(this_cpu_read(cpu_tlbstate.loaded_mm_asid)),
+			!need_flush);
 
 		write_cr3(unrestricted_cr3);
 		this_cpu_write(asi_cpu_state.curr_asi, NULL);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 312b9c185a55..5c9681df3a16 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -114,7 +114,7 @@ static_assert(TLB_NR_DYN_ASIDS < BIT(CR3_AVAIL_PCID_BITS));
 /*
  * Given @asid, compute kPCID
  */
-static inline u16 kern_pcid(u16 asid)
+inline u16 kern_pcid(u16 asid)
 {
 	VM_WARN_ON_ONCE(asid > MAX_ASID_AVAILABLE);
 
@@ -166,6 +166,60 @@ u16 asi_pcid(struct asi *asi, u16 asid)
 	return kern_pcid(asid) | (asi->pcid_index << ASI_PCID_BITS_SHIFT);
 }
 
+static void invalidate_kern_pcid(void)
+{
+	this_cpu_write(cpu_tlbstate.kern_pcid_needs_flush, true);
+}
+
+static void invalidate_asi_pcid(struct asi *asi, u16 asid)
+{
+	uint i;
+	struct asi_tlb_context *asi_tlb_context;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) ||
+	    !static_cpu_has(X86_FEATURE_PCID))
+		return;
+
+	asi_tlb_context = this_cpu_ptr(cpu_tlbstate.ctxs[asid].asi_context);
+
+	if (asi)
+		asi_tlb_context[asi->pcid_index].flush_pending = true;
+	else
+		for (i = 1; i < ASI_MAX_NUM; i++)
+			asi_tlb_context[i].flush_pending = true;
+}
+
+static void flush_asi_pcid(struct asi *asi)
+{
+	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+	/*
+	 * The flag should be cleared before the INVPCID, to avoid clearing it
+	 * in case an interrupt/exception sets it again after the INVPCID.
+	 */
+	asi_clear_pending_tlb_flush(asi);
+	invpcid_flush_single_context(asi_pcid(asi, asid));
+}
+
+static void __flush_tlb_one_asi(struct asi *asi, u16 asid, size_t addr)
+{
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return;
+
+	if (!static_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+		invalidate_asi_pcid(asi, asid);
+	} else if (asi) {
+		invpcid_flush_one(asi_pcid(asi, asid), addr);
+	} else {
+		uint i;
+		struct mm_struct *mm = this_cpu_read(cpu_tlbstate.loaded_mm);
+
+		for (i = 1; i < ASI_MAX_NUM; i++)
+			if (mm->asi[i].pgd)
+				invpcid_flush_one(asi_pcid(&mm->asi[i], asid),
+						  addr);
+	}
+}
+
 #else /* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 u16 asi_pcid(struct asi *asi, u16 asid)
@@ -173,6 +227,11 @@ u16 asi_pcid(struct asi *asi, u16 asid)
 	return kern_pcid(asid);
 }
 
+static inline void invalidate_kern_pcid(void) { }
+static inline void invalidate_asi_pcid(struct asi *asi, u16 asid) { }
+static inline void flush_asi_pcid(struct asi *asi) { }
+static inline void __flush_tlb_one_asi(struct asi *asi, u16 asid, size_t addr) { }
+
 #endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush)
@@ -223,7 +282,8 @@ static void clear_asid_other(void)
 	 * This is only expected to be set if we have disabled
 	 * kernel _PAGE_GLOBAL pages.
 	 */
-	if (!static_cpu_has(X86_FEATURE_PTI)) {
+	if (!static_cpu_has(X86_FEATURE_PTI) &&
+	    !cpu_feature_enabled(X86_FEATURE_ASI)) {
 		WARN_ON_ONCE(1);
 		return;
 	}
@@ -313,6 +373,7 @@ static void load_new_mm_cr3(pgd_t *pgdir, u16 new_asid, bool need_flush)
 
 	if (need_flush) {
 		invalidate_user_asid(new_asid);
+		invalidate_asi_pcid(NULL, new_asid);
 		new_mm_cr3 = build_cr3(pgdir, new_asid);
 	} else {
 		new_mm_cr3 = build_cr3_noflush(pgdir, new_asid);
@@ -741,11 +802,17 @@ void initialize_tlbstate_and_flush(void)
 	this_cpu_write(cpu_tlbstate.next_asid, 1);
 	this_cpu_write(cpu_tlbstate.ctxs[0].ctx_id, mm->context.ctx_id);
 	this_cpu_write(cpu_tlbstate.ctxs[0].tlb_gen, tlb_gen);
+	invalidate_asi_pcid(NULL, 0);
 
 	for (i = 1; i < TLB_NR_DYN_ASIDS; i++)
 		this_cpu_write(cpu_tlbstate.ctxs[i].ctx_id, 0);
 }
 
+static inline void invlpg(unsigned long addr)
+{
+	asm volatile("invlpg (%0)" ::"r"(addr) : "memory");
+}
+
 /*
  * flush_tlb_func()'s memory ordering requirement is that any
  * TLB fills that happen after we flush the TLB are ordered after we
@@ -967,7 +1034,8 @@ void flush_tlb_multi(const struct cpumask *cpumask,
  * least 95%) of allocations, and is small enough that we are
  * confident it will not cause too much overhead.  Each single
  * flush is about 100 ns, so this caps the maximum overhead at
- * _about_ 3,000 ns.
+ * _about_ 3,000 ns (plus upto an additional ~3000 ns for each
+ * ASI instance, or for KPTI).
  *
  * This is in units of pages.
  */
@@ -1157,7 +1225,8 @@ void flush_tlb_one_kernel(unsigned long addr)
 	 */
 	flush_tlb_one_user(addr);
 
-	if (!static_cpu_has(X86_FEATURE_PTI))
+	if (!static_cpu_has(X86_FEATURE_PTI) &&
+	    !cpu_feature_enabled(X86_FEATURE_ASI))
 		return;
 
 	/*
@@ -1174,9 +1243,45 @@ void flush_tlb_one_kernel(unsigned long addr)
  */
 STATIC_NOPV void native_flush_tlb_one_user(unsigned long addr)
 {
-	u32 loaded_mm_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+	u16 loaded_mm_asid;
 
-	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+	if (!static_cpu_has(X86_FEATURE_PCID)) {
+		invlpg(addr);
+		return;
+	}
+
+	loaded_mm_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+
+	/*
+	 * If we don't have INVPCID support, then we do an ASI Exit so that
+	 * the invlpg happens in the unrestricted address space, and we
+	 * invalidate the ASI PCID so that it is flushed at the next ASI Enter.
+	 *
+	 * But if a valid target ASI is set, then an ASI Exit can be ephemeral
+	 * due to interrupts/exceptions/NMIs (except if we are already inside
+	 * one), so we just invalidate both the ASI and the unrestricted kernel
+	 * PCIDs and let the invlpg flush whichever happens to be the current
+	 * address space. This is a bit more wasteful, but this scenario is not
+	 * actually expected to occur with the current usage of ASI, and is
+	 * handled here just for completeness. (If we wanted to optimize this,
+	 * we could manipulate the intr_nest_depth to guarantee that an ASI
+	 * Exit is not ephemeral).
+	 */
+	if (!static_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+		if (unlikely(!asi_is_target_unrestricted()) &&
+		    asi_intr_nest_depth() == 0)
+			invalidate_kern_pcid();
+		else
+			asi_exit();
+	}
+
+	/* Flush the unrestricted kernel address space */
+	if (!is_asi_active())
+		invlpg(addr);
+	else
+		invpcid_flush_one(kern_pcid(loaded_mm_asid), addr);
+
+	__flush_tlb_one_asi(NULL, loaded_mm_asid, addr);
 
 	if (!static_cpu_has(X86_FEATURE_PTI))
 		return;
@@ -1235,6 +1340,9 @@ STATIC_NOPV void native_flush_tlb_global(void)
  */
 STATIC_NOPV void native_flush_tlb_local(void)
 {
+	struct asi *asi;
+	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+
 	/*
 	 * Preemption or interrupts must be disabled to protect the access
 	 * to the per CPU variable and to prevent being preempted between
@@ -1242,10 +1350,36 @@ STATIC_NOPV void native_flush_tlb_local(void)
 	 */
 	WARN_ON_ONCE(preemptible());
 
-	invalidate_user_asid(this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	/*
+	 * If we don't have INVPCID support, then we have to use
+	 * write_cr3(read_cr3()). However, that is not safe when ASI is active,
+	 * as an interrupt/exception/NMI could cause an ASI Exit in the middle
+	 * and change CR3. So we trigger an ASI Exit beforehand. But if a valid
+	 * target ASI is set, then an ASI Exit can also be ephemeral due to
+	 * interrupts (except if we are already inside one), and thus we have to
+	 * fallback to a global TLB flush.
+	 */
+	if (!static_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
+		if (unlikely(!asi_is_target_unrestricted()) &&
+		    asi_intr_nest_depth() == 0) {
+			native_flush_tlb_global();
+			return;
+		}
+		asi_exit();
+	}
 
-	/* If current->mm == NULL then the read_cr3() "borrows" an mm */
-	native_write_cr3(__native_read_cr3());
+	invalidate_user_asid(asid);
+	invalidate_asi_pcid(NULL, asid);
+
+	asi = asi_get_current();
+
+	if (!asi) {
+		/* If current->mm == NULL then the read_cr3() "borrows" an mm */
+		native_write_cr3(__native_read_cr3());
+	} else {
+		invpcid_flush_single_context(kern_pcid(asid));
+		flush_asi_pcid(asi);
+	}
 }
 
 void flush_tlb_local(void)
-- 
2.35.1.473.g83b2b277ed-goog

