Return-Path: <kvm+bounces-21544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7EE92FEEA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 497A1281DE2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14870179970;
	Fri, 12 Jul 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzhvd/bo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C38179202
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803672; cv=none; b=PlcVbFfHeLenFyEN51YT+E0c1y//8qOG4PRbknyXveZ/i9hG7Dpz1m2n/mDr161AQHMvaoKd2CqGPfe/K8B5uyNxCVFQEiKuNCaIwCfL5UA6aHXTuaRhw6fu6bRqme99pk9HqJVjJ3NMCrwco2rCf18yLO+MEjfD+ms2PCjlNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803672; c=relaxed/simple;
	bh=kjjyiN2vmyqipSL6Mp7ZmPAujjs/LXDiL0u5FOb6NbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MiR+h0a3mf0aSJ09CeHtowyXzlQX6CTMXzQw8AxIZg/gG6/GwnSUF7lkSx+ayBY4eZ18whadsB3uMK0WHttjYoQxPkilrh6ccx7wmahz/G9ypgD1pIfg9z6QA7zglFNtcrMF/wm54R78iqA8x2Aw4dPMra1/5SuzNO7gpk7DM0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzhvd/bo; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-36789def10eso1371741f8f.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803669; x=1721408469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qrAVAbVK+nVNUznV+52/ScTYsIGKlGAcY8a4rOPWm6Y=;
        b=xzhvd/boGPuWiwVPlHlbaMKaJM+AcoIUt/dJhSpg3n4Qal2SSHlINSuEGDAw6oE0a0
         HJNPTC9Dzg8EIjOHq3rLhxHEh0r9ok1V6c0qhQnpMHCyE5G+9kQ0r1ilEn+JNOwb5f7v
         F1ksCBXWr+ALD47Kp2iOSOgHN6dewscbt9ucgMENxj6J6nhllqhxgb79rJJLSCbB/7Vc
         Z4qWV0ltrx068R9jUxszCttnaKiKSIMBxp9fZaKMx+mbyXtbrFjlyJ20n6uii8xQoMi6
         2cbxbLHEddGDqE2IZmD2uybIc5E3DR7FCwJ8uWoTyoLvZv/YQZr5zlntgRkHcDgNZgyg
         mhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803669; x=1721408469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qrAVAbVK+nVNUznV+52/ScTYsIGKlGAcY8a4rOPWm6Y=;
        b=PLMbGOuUuXTfEYz9cfHTKtv/akQJo7dzn6qLnivlJjidYJFsc8j/zz7/qPgI0Ro4yt
         K1YdSMhiYLVDIvvj8Lgzq0BWdzJsfxw6rMNKnzka4vKHaCKPSDVjRjt2O64LA6olMdc6
         lotd5YyUygQUql6idUn23XjtbzRi/EfgE5LNO7bLwV6OatTvnrtcsdSKANduieZU+WXr
         fmsehTAeFCevsOhuY2rGPXpT4nPpwZOMLGUl691hgYrB7RN18J7aESl9v77NdCXZT3rr
         IqIVGSdvoPgOLKXX4V4BdbAvKtjjVz9SXM/Bqtk82vHxsFWkRDsegU3INRX8eYozAMr5
         A1yg==
X-Forwarded-Encrypted: i=1; AJvYcCXi2o3YjnNzl6vhvjrxO6jUQ3mXPVSKD9X5eeL8Qs1ZJyVn9WRQNChWomwxEkcxv6PQSm1RA33bBuAHbVjhw7RLmGD7
X-Gm-Message-State: AOJu0YwcNP5TV+EhrZpCPCedZojI+ipHX0P6ZSj2sxr4NZs4SHaeYVPy
	POXO8uqLIilcyZ3AYuC2pM1M+BJk0QwJbwls8fZdcGUrmmoEdbU0vKRIZ/q32EYU35eSJbOPCe+
	Er/6K4jmuOg==
X-Google-Smtp-Source: AGHT+IF3kvDD67OIZ2BMm13dMbd7zSJf6yY9zVib7vZL6oHM8iz/nEJhVOpklDYifHh85TWN8ozTDRdKs7e20g==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6000:187:b0:367:60dc:9ec4 with SMTP
 id ffacd0b85a97d-367cea68085mr18401f8f.6.1720803668718; Fri, 12 Jul 2024
 10:01:08 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:24 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-6-144b319a40d8@google.com>
Subject: [PATCH 06/26] mm: asi: ASI support in interrupts/exceptions
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Add support for potentially switching address spaces from within
interrupts/exceptions/NMIs etc. An interrupt does not automatically
switch to the unrestricted address space. It can switch if needed to
access some memory not available in the restricted address space, using
the normal asi_exit call.

On return from the outermost interrupt, if the target address space was
the restricted address space (e.g. we were in the critical code path
between ASI Enter and VM Enter), the restricted address space will be
automatically restored. Otherwise, execution will continue in the
unrestricted address space until the next explicit ASI Enter.

In order to keep track of when to restore the restricted address space,
an interrupt/exception nesting depth counter is maintained per-task.
An alternative implementation without needing this counter is also
possible, but the counter unlocks an additional nice-to-have benefit by
allowing detection of whether or not we are currently executing inside
an exception context, which would be useful in a later patch.

Note that for KVM on SVM, this is not actually necessary as NMIs are in
fact maskable via CLGI. It's not clear to me if VMX has something
equivalent but we will need this infrastructure in place for userspace
support anyway.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h       | 68 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/idtentry.h  | 50 ++++++++++++++++++++++++-----
 arch/x86/include/asm/processor.h |  5 +++
 arch/x86/kernel/process.c        |  2 ++
 arch/x86/kernel/traps.c          | 22 +++++++++++++
 arch/x86/mm/asi.c                |  5 ++-
 include/asm-generic/asi.h        | 10 ++++++
 7 files changed, 151 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 04ba2ec7fd28..df34a8c0560b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -127,6 +127,11 @@ void asi_relax(void);
 /* Immediately exit the restricted address space if in it */
 void asi_exit(void);
 
+static inline void asi_init_thread_state(struct thread_struct *thread)
+{
+	thread->asi_state.intr_nest_depth = 0;
+}
+
 /* The target is the domain we'll enter when returning to process context. */
 static __always_inline struct asi *asi_get_target(struct task_struct *p)
 {
@@ -167,9 +172,10 @@ static __always_inline bool asi_is_relaxed(void)
 /*
  * Is the current task in the critical section?
  *
- * This is just the inverse of !asi_is_relaxed(). We have both functions in order to
- * help write intuitive client code. In particular, asi_is_tense returns false
- * when ASI is disabled, which is judged to make user code more obvious.
+ * This is just the inverse of !asi_is_relaxed(). We have both functions in
+ * order to help write intuitive client code. In particular, asi_is_tense
+ * returns false when ASI is disabled, which is judged to make user code more
+ * obvious.
  */
 static __always_inline bool asi_is_tense(void)
 {
@@ -181,6 +187,62 @@ static __always_inline pgd_t *asi_pgd(struct asi *asi)
 	return asi ? asi->pgd : NULL;
 }
 
+static __always_inline void asi_intr_enter(void)
+{
+	if (static_asi_enabled() && asi_is_tense()) {
+		current->thread.asi_state.intr_nest_depth++;
+		barrier();
+	}
+}
+
+void __asi_enter(void);
+
+static __always_inline void asi_intr_exit(void)
+{
+	if (static_asi_enabled() && asi_is_tense()) {
+		/*
+		 * If an access to sensitive memory got reordered after the
+		 * decrement, the #PF handler for that access would see a value
+		 * of 0 for the counter and re-__asi_enter before returning to
+		 * the faulting access, triggering an infinite PF loop.
+		 */
+		barrier();
+
+		if (--current->thread.asi_state.intr_nest_depth == 0) {
+			/*
+			 * If the decrement got reordered after __asi_enter, an
+			 * interrupt that came between __asi_enter and the
+			 * decrement would always see a nonzero value for the
+			 * counter so it wouldn't call __asi_enter again and we
+			 * would return to process context in the wrong address
+			 * space.
+			 */
+			barrier();
+			__asi_enter();
+		}
+	}
+}
+
+/*
+ * Returns the nesting depth of interrupts/exceptions that have interrupted the
+ * ongoing critical section. If the current task is not in a critical section
+ * this is 0.
+ */
+static __always_inline int asi_intr_nest_depth(void)
+{
+	return current->thread.asi_state.intr_nest_depth;
+}
+
+/*
+ * Remember that interrupts/exception don't count as the critical section. If
+ * you want to know if the current task is in the critical section use
+ * asi_is_tense().
+ */
+static __always_inline bool asi_in_critical_section(void)
+{
+	return asi_is_tense() && !asi_intr_nest_depth();
+}
+
 #define INIT_MM_ASI(init_mm) \
 	.asi_init_lock = __MUTEX_INITIALIZER(init_mm.asi_init_lock),
 
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 749c7411d2f1..446aed5ebe18 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -12,6 +12,7 @@
 #include <linux/hardirq.h>
 
 #include <asm/irq_stack.h>
+#include <asm/asi.h>
 
 typedef void (*idtentry_t)(struct pt_regs *regs);
 
@@ -55,12 +56,15 @@ static __always_inline void __##func(struct pt_regs *regs);		\
 									\
 __visible noinstr void func(struct pt_regs *regs)			\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
+	irqentry_state_t state;						\
 									\
+	asi_intr_enter();						\
+	state = irqentry_enter(regs);					\
 	instrumentation_begin();					\
 	__##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
+	asi_intr_exit();						\
 }									\
 									\
 static __always_inline void __##func(struct pt_regs *regs)
@@ -102,12 +106,15 @@ static __always_inline void __##func(struct pt_regs *regs,		\
 __visible noinstr void func(struct pt_regs *regs,			\
 			    unsigned long error_code)			\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
+	irqentry_state_t state;						\
 									\
+	asi_intr_enter();						\
+	state = irqentry_enter(regs);					\
 	instrumentation_begin();					\
 	__##func (regs, error_code);					\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
+	asi_intr_exit();						\
 }									\
 									\
 static __always_inline void __##func(struct pt_regs *regs,		\
@@ -139,7 +146,16 @@ static __always_inline void __##func(struct pt_regs *regs,		\
  * is required before the enter/exit() helpers are invoked.
  */
 #define DEFINE_IDTENTRY_RAW(func)					\
-__visible noinstr void func(struct pt_regs *regs)
+static __always_inline void __##func(struct pt_regs *regs);		\
+									\
+__visible noinstr void func(struct pt_regs *regs)			\
+{									\
+	asi_intr_enter();						\
+	__##func (regs);						\
+	asi_intr_exit();						\
+}									\
+									\
+static __always_inline void __##func(struct pt_regs *regs)
 
 /**
  * DEFINE_FREDENTRY_RAW - Emit code for raw FRED entry points
@@ -178,7 +194,18 @@ noinstr void fred_##func(struct pt_regs *regs)
  * is required before the enter/exit() helpers are invoked.
  */
 #define DEFINE_IDTENTRY_RAW_ERRORCODE(func)				\
-__visible noinstr void func(struct pt_regs *regs, unsigned long error_code)
+static __always_inline void __##func(struct pt_regs *regs,		\
+				     unsigned long error_code);		\
+									\
+__visible noinstr void func(struct pt_regs *regs, unsigned long error_code)\
+{									\
+	asi_intr_enter();						\
+	__##func (regs, error_code);					\
+	asi_intr_exit();						\
+}									\
+									\
+static __always_inline void __##func(struct pt_regs *regs,		\
+				     unsigned long error_code)
 
 /**
  * DECLARE_IDTENTRY_IRQ - Declare functions for device interrupt IDT entry
@@ -209,14 +236,17 @@ static void __##func(struct pt_regs *regs, u32 vector);			\
 __visible noinstr void func(struct pt_regs *regs,			\
 			    unsigned long error_code)			\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
+	irqentry_state_t state;						\
 	u32 vector = (u32)(u8)error_code;				\
 									\
+	asi_intr_enter();						\
+	state = irqentry_enter(regs);					\
 	instrumentation_begin();					\
 	kvm_set_cpu_l1tf_flush_l1d();					\
 	run_irq_on_irqstack_cond(__##func, regs, vector);		\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
+	asi_intr_exit();						\
 }									\
 									\
 static noinline void __##func(struct pt_regs *regs, u32 vector)
@@ -256,12 +286,15 @@ static __always_inline void instr_##func(struct pt_regs *regs)		\
 									\
 __visible noinstr void func(struct pt_regs *regs)			\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
+	irqentry_state_t state;						\
 									\
+	asi_intr_enter();						\
+	state = irqentry_enter(regs);					\
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
+	asi_intr_exit();						\
 }									\
 									\
 void fred_##func(struct pt_regs *regs)					\
@@ -295,12 +328,15 @@ static __always_inline void instr_##func(struct pt_regs *regs)		\
 									\
 __visible noinstr void func(struct pt_regs *regs)			\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
+	irqentry_state_t state;						\
 									\
+	asi_intr_enter();						\
+	state = irqentry_enter(regs);					\
 	instrumentation_begin();					\
 	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
+	asi_intr_exit();						\
 }									\
 									\
 void fred_##func(struct pt_regs *regs)					\
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a42f03ff3edc..5b10b3c09b6a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -494,6 +494,11 @@ struct thread_struct {
 	struct {
 		/* Domain to enter when returning to process context. */
 		struct asi	*target;
+		/*
+		 * The depth of interrupt/exceptions interrupting an ASI
+		 * critical section
+		 */
+		int		intr_nest_depth;
 	} asi_state;
 #endif
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b8441147eb5e..ca2391079e59 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -96,6 +96,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
+	asi_init_thread_state(&dst->thread);
+
 	/* Drop the copied pointer to current's fpstate */
 	dst->thread.fpu.fpstate = NULL;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4fa0b17e5043..ca0d0b9fe955 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -64,6 +64,7 @@
 #include <asm/umip.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/asi.h>
 #include <asm/vdso.h>
 #include <asm/tdx.h>
 #include <asm/cfi.h>
@@ -414,6 +415,27 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	}
 #endif
 
+	/*
+	 * Do an asi_exit() only here because a #DF usually indicates
+	 * the system is in a really bad state, and we don't want to
+	 * cause any additional issue that would prevent us from
+	 * printing a correct stack trace.
+	 *
+	 * The additional issues are not related to a possible triple
+	 * fault, which can only occurs if a fault is encountered while
+	 * invoking this handler, but here we are already executing it.
+	 * Instead, an ASI-induced #PF here could potentially end up
+	 * getting another #DF. For example, if there was some issue in
+	 * invoking the #PF handler. The handler for the second #DF
+	 * could then again cause an ASI-induced #PF leading back to the
+	 * same recursion.
+	 *
+	 * This is not needed in the espfix64 case above, since that
+	 * code is about turning a #DF into a #GP which is okay to
+	 * handle in the restricted domain. That's also why we don't
+	 * asi_exit() in the #GP handler.
+	 */
+	asi_exit();
 	irqentry_nmi_enter(regs);
 	instrumentation_begin();
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 21207a3e8b17..2cd8e93a4415 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -171,7 +171,7 @@ void asi_destroy(struct asi *asi)
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
 
-static noinstr void __asi_enter(void)
+noinstr void __asi_enter(void)
 {
 	u64 asi_cr3;
 	struct asi *target = asi_get_target(current);
@@ -186,6 +186,7 @@ static noinstr void __asi_enter(void)
 	 * disabling preemption should be fine.
 	 */
 	VM_BUG_ON(preemptible());
+	VM_BUG_ON(current->thread.asi_state.intr_nest_depth != 0);
 
 	if (!target || target == this_cpu_read(curr_asi))
 		return;
@@ -246,6 +247,8 @@ noinstr void asi_exit(void)
 
 	asi = this_cpu_read(curr_asi);
 	if (asi) {
+		WARN_ON_ONCE(asi_in_critical_section());
+
 		if (asi->class->ops.pre_asi_exit)
 			asi->class->ops.pre_asi_exit();
 
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index d0a451f9d0b7..fa0bbf899a09 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -38,6 +38,8 @@ static inline bool asi_is_relaxed(void) { return true; }
 
 static inline bool asi_is_tense(void) { return false; }
 
+static inline bool asi_in_critical_section(void) { return false; }
+
 static inline void asi_exit(void) { }
 
 static inline bool asi_is_restricted(void) { return false; }
@@ -48,6 +50,14 @@ static inline struct asi *asi_get_target(struct task_struct *p) { return NULL; }
 
 static inline pgd_t *asi_pgd(struct asi *asi) { return NULL; }
 
+static inline void asi_init_thread_state(struct thread_struct *thread) { }
+
+static inline void asi_intr_enter(void) { }
+
+static inline int asi_intr_nest_depth(void) { return 0; }
+
+static inline void asi_intr_exit(void) { }
+
 #define static_asi_enabled() false
 
 static inline void asi_check_boottime_disable(void) { }

-- 
2.45.2.993.g49e7a77208-goog


