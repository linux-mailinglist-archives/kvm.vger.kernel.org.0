Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E868533146
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiEXTFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbiEXTFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:05:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F25C79
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:05:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so16638583plg.5
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DR/nuBiqLcgC+/SROQD5L8bNkKy9EZfRFgC18F9S9ww=;
        b=sZXxLJ0UADizmGO6xHWwTN4W8yDnhIUEVOKmwfvEej2spaXGF0EESBdPHVYFLJb3At
         PcJis8qhhnKhvwY1SunQHLM7GW9R+bwc4wMyWQqs3pFdouPKAnqOtmYj0ZKaXMgUdYk9
         HQ7hi3zLb+VAP7Cp6l9ONfdkXcdWIBdDOXoe9MzhVy9EvHT3aIXZiTzCzBP8/ipyT0XJ
         U1Wejs2zcDBBafpDoNI8BjSSea7Kjcrk2zsgxXh02J3pTTQKnftwPzQ0P0T8molWLqJc
         uUNkj8bWnYjXqRwyh4RJsDQSuEtKVwNNNbC0CwoLMnlxezVJO8RdtF5m0cfiKxFgOlgE
         gwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DR/nuBiqLcgC+/SROQD5L8bNkKy9EZfRFgC18F9S9ww=;
        b=NkuJmz3usTsf/v9hloTo0cvRg6IvfpUSN1y5/0xCnKXaJQn9F0Zv1FG16RQWyKOaJW
         XU+w3lAynGvtKI103AO3Bsw5Ed5bjOocg13cAS8MIu5DzUI6i1YCqqY5r4wDpMcD0MS5
         KYojECjeyiFJYpszr8aeIK/gjYBexlKb8+CursD3A2q7hbFonCMHDv7F4bIoy+VeqyX7
         UFzssq7V5+8Vg/is9j8qshsLBjYVJjr7lSlch9ijKJW+v6wLUfHH+iFMQDQTVgTvBEnA
         VGB+M7xt9GcA4TVnvoMEugiDwofYozpIO4H39f814sMSSSH8rRcm+fzFuVmlGpUhw2WE
         cXlg==
X-Gm-Message-State: AOAM531hmkLaCnpcKekKyVc5yd+InoGFIgdV5dC98cDKtuTLpXmqiBF0
        fIB1loaDvpFR4uT5pnr4dgqajA==
X-Google-Smtp-Source: ABdhPJwHf6o+0CcP4PfAdFYs//8NqCdMHB0WWfQ1h14HywkB4J88huVTlf2N8auNU5yShHfJuW3zCg==
X-Received: by 2002:a17:902:bf0a:b0:162:201e:1f49 with SMTP id bi10-20020a170902bf0a00b00162201e1f49mr11895798plb.39.1653419142453;
        Tue, 24 May 2022 12:05:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z9-20020a056a001d8900b0051812f8faa3sm9312525pfw.184.2022.05.24.12.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 12:05:41 -0700 (PDT)
Date:   Tue, 24 May 2022 19:05:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/kvm: Alloc dummy async #PF token outside of raw
 spinlock
Message-ID: <Yo0sgZZw6wyjnxQA@google.com>
References: <YozWhplb1iXiQDlI@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YozWhplb1iXiQDlI@kili>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022, Dan Carpenter wrote:
> Hello Sean Christopherson,
> 
> The patch ddd7ed842627: "x86/kvm: Alloc dummy async #PF token outside
> of raw spinlock" from May 19, 2022, leads to the following Smatch
> static checker warning:
> 
> 	arch/x86/kernel/kvm.c:212 kvm_async_pf_task_wake()
> 	warn: sleeping in atomic context
> 
> arch/x86/kernel/kvm.c
>     202         raw_spin_lock(&b->lock);
>     203         n = _find_apf_task(b, token);
>     204         if (!n) {
>     205                 /*
>     206                  * Async #PF not yet handled, add a dummy entry for the token.
>     207                  * Allocating the token must be down outside of the raw lock
>     208                  * as the allocator is preemptible on PREEMPT_RT kernels.
>     209                  */
>     210                 if (!dummy) {
>     211                         raw_spin_unlock(&b->lock);
> --> 212                         dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
>                                                                 ^^^^^^^^^^
> Smatch thinks the caller has preempt disabled.  The `smdb.py preempt
> kvm_async_pf_task_wake` output call tree is:
> 
> sysvec_kvm_asyncpf_interrupt() <- disables preempt
> -> __sysvec_kvm_asyncpf_interrupt()
>    -> kvm_async_pf_task_wake()

Duh, it's in IRQ context.  Ah, I see Paolo already fixed this up.

Staring at this code more... Ignoring KVM as L1 for the moment, isn't this dead code
now that the "page present" event is delivered via IRQ?  The IRQ is always delivered
to the CPU that encountered the "fault", and the injected #PF from the host has
higher priority than the IRQ.  So even if the host is preempted and the target page
is faulted in prior to running the vCPU, the injected #PF will be delivered before
the IRQ.

Sadly, KVM as L1 is annoying and waits until after enabling IRQs (and a bunch of
other stuff) to handle the #PF VM-Exit from L2.  Changing that is a bit messy as
KVM shouldn't enabling IRQs and schedule away until after guest_timing_exit_irqoff().
But it's very doable and IMO would clean up the KVM code a bit by not relying on the
apf.host_apf_flags cookie.

And there's also a theoretical memory leak.  If an early wakeup occurs, and then a
"wake all" also occurs before the async #PF is injected, the "wake all" will delete
the dummy entry without freeing the data.

Something like this (spread out over multiple patches).  Am I missing something that
would prevent this from working?

---
 arch/x86/include/asm/kvm_host.h |   8 ++-
 arch/x86/include/asm/kvm_para.h |  14 +++-
 arch/x86/kernel/kvm.c           | 121 ++++++++++++--------------------
 arch/x86/kvm/mmu/mmu.c          |  23 ++----
 arch/x86/kvm/svm/nested.c       |   9 ++-
 arch/x86/kvm/svm/svm.c          |  17 +++--
 arch/x86/kvm/svm/svm.h          |   2 +-
 arch/x86/kvm/vmx/nested.c       |   8 ++-
 arch/x86/kvm/vmx/nested.h       |   2 +-
 arch/x86/kvm/vmx/vmx.c          |  31 ++++----
 arch/x86/kvm/x86.c              |  20 +++++-
 11 files changed, 126 insertions(+), 129 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad28b0d1d5ea..5fc44dbec0f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1352,6 +1352,11 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }

+struct kvm_host_apf {
+	u32 flags;
+	u32 token;
+};
+
 struct kvm_x86_ops {
 	const char *name;

@@ -1479,7 +1484,8 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage,
 			       struct x86_exception *exception);
-	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
+				   struct kvm_host_apf *apf);

 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 56935ebb1dfe..329b7cc29472 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -5,6 +5,7 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <linux/interrupt.h>
+#include <linux/swait.h>
 #include <uapi/asm/kvm_para.h>

 #ifdef CONFIG_KVM_GUEST
@@ -95,13 +96,22 @@ static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
 	return ret;
 }

+struct kvm_task_sleep_node {
+	struct hlist_node link;
+	struct swait_queue_head wq;
+	u32 token;
+	int cpu;
+};
+
 #ifdef CONFIG_KVM_GUEST
 void kvmclock_init(void);
 void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
-void kvm_async_pf_task_wait_schedule(u32 token);
+void kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n);
+void kvm_async_pf_task_wait_irqs_on(struct kvm_task_sleep_node *n);
+void kvm_async_pf_queue_task_and_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_apf_flags(void);
 bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
@@ -125,7 +135,7 @@ static inline void kvm_spinlock_init(void)
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */

 #else /* CONFIG_KVM_GUEST */
-#define kvm_async_pf_task_wait_schedule(T) do {} while(0)
+#define kvm_async_pf_queue_task_and_wait(T) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)

 static inline bool kvm_para_available(void)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1a3658f7e6d9..d6ab777ead07 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
-#include <linux/swait.h>
 #include <linux/syscore_ops.h>
 #include <linux/cc_platform.h>
 #include <linux/efi.h>
@@ -80,13 +79,6 @@ static void kvm_io_delay(void)
 #define KVM_TASK_SLEEP_HASHBITS 8
 #define KVM_TASK_SLEEP_HASHSIZE (1<<KVM_TASK_SLEEP_HASHBITS)

-struct kvm_task_sleep_node {
-	struct hlist_node link;
-	struct swait_queue_head wq;
-	u32 token;
-	int cpu;
-};
-
 static struct kvm_task_sleep_head {
 	raw_spinlock_t lock;
 	struct hlist_head list;
@@ -107,59 +99,71 @@ static struct kvm_task_sleep_node *_find_apf_task(struct kvm_task_sleep_head *b,
 	return NULL;
 }

-static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
+/*
+ * Add an async #PF victim to the queue of waiters.  This must be called before
+ * IRQs are _ever_ enabled after a #PF or #PF VM-Exit to ensure the wake IRQ
+ * cannot arrive before the waiter is queued.
+ */
+void kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *e;
+
+	lockdep_assert_irqs_disabled();

 	raw_spin_lock(&b->lock);
-	e = _find_apf_task(b, token);
-	if (e) {
-		/* dummy entry exist -> wake up was delivered ahead of PF */
-		hlist_del(&e->link);
-		raw_spin_unlock(&b->lock);
-		kfree(e);
-		return false;
-	}
-
 	n->token = token;
 	n->cpu = smp_processor_id();
 	init_swait_queue_head(&n->wq);
 	hlist_add_head(&n->link, &b->list);
 	raw_spin_unlock(&b->lock);
-	return true;
 }
+EXPORT_SYMBOL_GPL(kvm_async_pf_queue_task);

 /*
- * kvm_async_pf_task_wait_schedule - Wait for pagefault to be handled
- * @token:	Token to identify the sleep node entry
- *
- * Invoked from the async pagefault handling code or from the VM exit page
- * fault handler. In both cases RCU is watching.
+ * Wait for a page fault to be resolved by the host. Invoked from the async #PF
+ * handler or from KVM (running as L1) after a page fault VM-Exit. In both
+ * cases RCU is watching.
  */
-void kvm_async_pf_task_wait_schedule(u32 token)
+static void __kvm_async_pf_task_wait_schedule(struct kvm_task_sleep_node *n,
+					      bool irqs_on)
 {
-	struct kvm_task_sleep_node n;
 	DECLARE_SWAITQUEUE(wait);

-	lockdep_assert_irqs_disabled();
-
-	if (!kvm_async_pf_queue_task(token, &n))
-		return;
-
 	for (;;) {
-		prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
-		if (hlist_unhashed(&n.link))
+		prepare_to_swait_exclusive(&n->wq, &wait, TASK_UNINTERRUPTIBLE);
+		if (hlist_unhashed(&n->link))
 			break;

-		local_irq_enable();
+		if (!irqs_on)
+			local_irq_enable();
+
 		schedule();
-		local_irq_disable();
+
+		if (!irqs_on)
+			local_irq_disable();
 	}
-	finish_swait(&n.wq, &wait);
+	finish_swait(&n->wq, &wait);
+}
+
+void kvm_async_pf_task_wait_irqs_on(struct kvm_task_sleep_node *n)
+{
+	lockdep_assert_irqs_enabled();
+
+	__kvm_async_pf_task_wait_schedule(n, true);
+}
+EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_irqs_on);
+
+void kvm_async_pf_queue_task_and_wait(u32 token)
+{
+	struct kvm_task_sleep_node n;
+
+	lockdep_assert_irqs_disabled();
+
+	kvm_async_pf_queue_task(token, &n);
+
+	__kvm_async_pf_task_wait_schedule(&n, false);
 }
-EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_schedule);

 static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 {
@@ -191,53 +195,18 @@ void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *n, *dummy = NULL;
+	struct kvm_task_sleep_node *n;

 	if (token == ~0) {
 		apf_task_wake_all();
 		return;
 	}

-again:
 	raw_spin_lock(&b->lock);
 	n = _find_apf_task(b, token);
-	if (!n) {
-		/*
-		 * Async #PF not yet handled, add a dummy entry for the token.
-		 * Allocating the token must be down outside of the raw lock
-		 * as the allocator is preemptible on PREEMPT_RT kernels.
-		 */
-		if (!dummy) {
-			raw_spin_unlock(&b->lock);
-			dummy = kzalloc(sizeof(*dummy), GFP_ATOMIC);
-
-			/*
-			 * Continue looping on allocation failure, eventually
-			 * the async #PF will be handled and allocating a new
-			 * node will be unnecessary.
-			 */
-			if (!dummy)
-				cpu_relax();
-
-			/*
-			 * Recheck for async #PF completion before enqueueing
-			 * the dummy token to avoid duplicate list entries.
-			 */
-			goto again;
-		}
-		dummy->token = token;
-		dummy->cpu = smp_processor_id();
-		init_swait_queue_head(&dummy->wq);
-		hlist_add_head(&dummy->link, &b->list);
-		dummy = NULL;
-	} else {
+	if (!WARN_ON_ONCE(!n))
 		apf_task_wake_one(n);
-	}
 	raw_spin_unlock(&b->lock);
-
-	/* A dummy token might be allocated and ultimately not used.  */
-	if (dummy)
-		kfree(dummy);
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);

@@ -277,7 +246,7 @@ noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 		if (unlikely(!(user_mode(regs))))
 			panic("Host injected async #PF in kernel mode\n");
 		/* Page is swapped out by the host. */
-		kvm_async_pf_task_wait_schedule(token);
+		kvm_async_pf_queue_task_and_wait(token);
 	} else {
 		WARN_ONCE(1, "Unexpected async PF flags: %x\n", flags);
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..2eec5e54f474 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4123,9 +4123,6 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len)
 {
-	int r = 1;
-	u32 flags = vcpu->arch.apf.host_apf_flags;
-
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
 	if (WARN_ON_ONCE(fault_address >> 32))
@@ -4133,23 +4130,11 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 #endif

 	vcpu->arch.l1tf_flush_l1d = true;
-	if (!flags) {
-		trace_kvm_page_fault(fault_address, error_code);
+	trace_kvm_page_fault(fault_address, error_code);

-		if (kvm_event_needs_reinjection(vcpu))
-			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
-		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
-				insn_len);
-	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
-		vcpu->arch.apf.host_apf_flags = 0;
-		local_irq_disable();
-		kvm_async_pf_task_wait_schedule(fault_address);
-		local_irq_enable();
-	} else {
-		WARN_ONCE(1, "Unexpected host async PF flags: %x\n", flags);
-	}
-
-	return r;
+	if (kvm_event_needs_reinjection(vcpu))
+		kvm_mmu_unprotect_page_virt(vcpu, fault_address);
+	return kvm_mmu_page_fault(vcpu, fault_address, error_code, insn, insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2cf92c12706a..0d66960ab0e3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1404,10 +1404,13 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	return 0;
 }

-int nested_svm_exit_special(struct vcpu_svm *svm)
+int nested_svm_exit_special(struct vcpu_svm *svm, fastpath_t exit_fastpath)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;

+	if (exit_fastpath != EXIT_FASTPATH_NONE)
+		return NESTED_EXIT_HOST;
+
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
 	case SVM_EXIT_NMI:
@@ -1419,10 +1422,6 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 		if (svm->vmcb01.ptr->control.intercepts[INTERCEPT_EXCEPTION] &
 		    excp_bits)
 			return NESTED_EXIT_HOST;
-		else if (exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-			 svm->vcpu.arch.apf.host_apf_flags)
-			/* Trap async PF even if not shadowing */
-			return NESTED_EXIT_HOST;
 		break;
 	}
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa9d30b6bc14..c132296ac00c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3351,7 +3351,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)

 		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);

-		vmexit = nested_svm_exit_special(svm);
+		vmexit = nested_svm_exit_special(svm, exit_fastpath);

 		if (vmexit == NESTED_EXIT_CONTINUE)
 			vmexit = nested_svm_exit_handled(svm);
@@ -4005,11 +4005,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	vmcb_mark_all_clean(svm->vmcb);

-	/* if exit due to PF check for async PF */
-	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)
-		vcpu->arch.apf.host_apf_flags =
-			kvm_read_and_reset_apf_flags();
-
 	vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;

 	/*
@@ -4343,8 +4338,16 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }

-static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
+				   struct kvm_host_apf *apf)
 {
+	struct vmcb *vmcb = to_svm(vcpu)->vmcb;
+
+	/* if exit due to PF check for async PF */
+	if (vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR) {
+		apf->flags = kvm_read_and_reset_apf_flags();
+		apf->token = apf->flags ? vmcb->control.exit_info_2 : 0;
+	}
 }

 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cd92f4343753..a5314dd2a75f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -592,7 +592,7 @@ int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
-int nested_svm_exit_special(struct vcpu_svm *svm);
+int nested_svm_exit_special(struct vcpu_svm *svm, fastpath_t exit_fastpath);
 void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
 void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e4062134ddf4..c2648dc121c7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5937,8 +5937,7 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 		if (is_nmi(intr_info))
 			return true;
 		else if (is_page_fault(intr_info))
-			return vcpu->arch.apf.host_apf_flags ||
-			       vmx_need_pf_intercept(vcpu);
+			return vmx_need_pf_intercept(vcpu);
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
@@ -6121,7 +6120,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
  * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
  * reflected into L1.
  */
-bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	union vmx_exit_reason exit_reason = vmx->exit_reason;
@@ -6145,6 +6144,9 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)

 	trace_kvm_nested_vmexit(vcpu, KVM_ISA_VMX);

+	if (exit_fastpath != EXIT_FASTPATH_NONE)
+		return false;
+
 	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
 	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
 		return false;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..73560d12603b 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -24,7 +24,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
-bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu);
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6927f6e8ec31..eb93f67b54fa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5022,7 +5022,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)

 	if (is_page_fault(intr_info)) {
 		cr2 = vmx_get_exit_qual(vcpu);
-		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
+		if (enable_ept) {
 			/*
 			 * EPT will cause page fault only if we need to
 			 * detect illegal GPAs.
@@ -6219,7 +6219,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 		}

-		if (nested_vmx_reflect_vmexit(vcpu))
+		if (nested_vmx_reflect_vmexit(vcpu, exit_fastpath))
 			return 1;
 	}

@@ -6664,23 +6664,27 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }

-static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx,
+					struct kvm_host_apf *apf)
 {
 	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	u32 intr_info = vmx_get_intr_info(vcpu);

 	/* if exit due to PF check for async PF */
-	if (is_page_fault(intr_info))
-		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	if (is_page_fault(intr_info)) {
+		apf->flags = kvm_read_and_reset_apf_flags();
+		apf->token = apf->flags ? vmx_get_exit_qual(vcpu) : 0;
 	/* if exit due to NM, handle before interrupts are enabled */
-	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(&vmx->vcpu);
+	} else if (is_nm_fault(intr_info)) {
+		handle_nm_fault_irqoff(vcpu);
 	/* Handle machine checks before interrupts are enabled */
-	else if (is_machine_check(intr_info))
+	} else if (is_machine_check(intr_info)) {
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
+	} else if (is_nmi(intr_info)) {
+		handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
+	}
 }

 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
@@ -6696,7 +6700,8 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
 }

-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
+				   struct kvm_host_apf *apf)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);

@@ -6706,7 +6711,7 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vmx);
+		handle_exception_nmi_irqoff(vmx, apf);
 }

 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a291236b4695..0b9c4041e794 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10037,6 +10037,8 @@ EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
  */
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
+	struct kvm_task_sleep_node async_pf_node;
+	struct kvm_host_apf host_apf = {};
 	int r;
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
@@ -10344,11 +10346,22 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.xfd_no_write_intercept)
 		fpu_sync_guest_vmexit_xfd_state();

-	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
+	static_call(kvm_x86_handle_exit_irqoff)(vcpu, &host_apf);

 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, 0);

+#ifdef CONFIG_KVM_GUEST
+	if (host_apf.flags) {
+		exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
+
+		if (WARN_ON_ONCE(!(host_apf.flags & KVM_PV_REASON_PAGE_NOT_PRESENT)))
+			host_apf.flags = 0;
+		else
+			kvm_async_pf_queue_task(host_apf.token, &async_pf_node);
+	}
+#endif
+
 	/*
 	 * Consume any pending interrupts, including the possible source of
 	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
@@ -10374,6 +10387,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	preempt_enable();

+#ifdef CONFIG_KVM_GUEST
+	if (host_apf.flags)
+		kvm_async_pf_task_wait_irqs_on(&async_pf_node);
+#endif
+
 	kvm_vcpu_srcu_read_lock(vcpu);

 	/*

base-commit: 0356ff9b10936308892f43a0e9f32b61e4203bee
--

