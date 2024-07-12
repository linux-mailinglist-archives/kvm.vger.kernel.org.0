Return-Path: <kvm+bounces-21541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C40EB92FEE5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDD0285EA6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B84178395;
	Fri, 12 Jul 2024 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YIqDaR1J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D65A178364
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803664; cv=none; b=V+Wex2kmMuC5rTv7Ko3rzJc/Uvsb6TLgvRk1niBxXSa4Yg6bT/OmdweNwQWrOQmrL7y6ss2VpNt+PQlL53VA7yO1VV8J6sCO0nULeyY6dsdNDyJVl/0LwWSNdcYWg0DUGr1EFWsbrrvc9K8GLhNISTmJSEb1z/0PxPztW29Tyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803664; c=relaxed/simple;
	bh=7hFccffoH6+2s6A+xgGH3BAwy9+MyU9gEGjy8kzQy10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdNAbcFKgjIfFXScgpi6zH3xIVdzk6dxVMm1IFzTMp2acF9JQfm2ll+mm/r89pDReRnmq5/7p1PUUIVfpqryK8/9iNlJmgSS71P1qSYAGPtn8zm6ItIPoF20rESIy99Kpq3MG/DOVvnrEjXEsXC1oNR+EuqMYi23xJ5KMtsxeC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YIqDaR1J; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42725d3ae3eso15358285e9.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803660; x=1721408460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PMdbHr8f+bHJyqhYwYG2FeYYV8yyAj+rEymiJJJZ+c4=;
        b=YIqDaR1JDjsKswpltImZIoVteGIZ1DuELoFXymxz3GwQsTWq8t/aGvOAY+oqk649v5
         JuIklSH3a89w4WMt+ssYOkcNpy0yVHPAwMnunkQlDRiOkEyI4g+UErcQPEM8if3nMn9k
         TmGGqtkQxJWeWTNR19PJwazHQc7tNY6MzsIgSbxUHNmsiPR+HTx1HPHUcZ+uV3J0iHyk
         rqztansgulYBMHm9SKr68rzgNl201QUVr9Q94MlwBq5HKlsBL1v4uvnSqABdTK4dTafo
         /JachCrFTb6Z+igR2s352y1dBdnwZ7XjnHn0hheGNPYClDc/+c7DO2IFbMMA6R1UE/Ir
         rvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803660; x=1721408460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PMdbHr8f+bHJyqhYwYG2FeYYV8yyAj+rEymiJJJZ+c4=;
        b=Cx4hUplLLmegLAnT2jEeh1jQ+Hf0rlY4anfSZNzL8V7eW6dJwB4zYQ/AUQWH4AbjCh
         09hs6b+iuY/s0iwm85uBAIHMcEnVBD0XUlv7Em7mIW8m01yR6kXqLgZUNiKB3PGu+lDb
         e8htIKXwjuCE6JsZ04ZCc1EhCU3TahY7+rGJK87kKmt8j3gDmtqOvs5suWXZ26vxADzR
         dYqp7uzcUkHfbNkVLRTmm61OPGLTwUaHQUaK6dLaLxWOWjNvz6FCTWRmTHF8XaAwCn5I
         J84PGkEuU9OHJJPisQQs11x06vHUDzPl6q1JjeRb9MXdjHfUqk32nDUs9s2k277zpp3g
         imEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUupvb4ZuM72naKdYyiY1xviHURsmXzjmQtug8QNCa5ogwAGD3kb940l8Xj18inPbo+Hu2MLNIxVnIu/8CeiTyf/Cbj
X-Gm-Message-State: AOJu0YxP8TPmOdmMeNkdLDN1WjZ/4xdXCP9Rbh9NCdnTRVX5RW78LEwD
	ErKTdhPvo/1ZKrbRkHQkasF20HF8ffZgiCm3EqXP2Rez1cN0RV9ipwShbx4+ycv9ztz5LS+k9Rs
	dCoegbNESpw==
X-Google-Smtp-Source: AGHT+IEVF7omOk0dAyaMWn9nP5g1PTxgYRWlYkZl2KK6tCcUkjJHKogxau8pwI0HbmROqrqrZGZvZockxDjFbQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:1c13:b0:426:6668:d59 with SMTP
 id 5b1f17b1804b1-426707f91dbmr1903295e9.3.1720803659878; Fri, 12 Jul 2024
 10:00:59 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:21 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-3-144b319a40d8@google.com>
Subject: [PATCH 03/26] mm: asi: Introduce ASI core API
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

From: Junaid Shahid <junaids@google.com>

Introduce core API for Address Space Isolation (ASI).
Kernel address space isolation provides the ability to run some kernel
code with a restricted kernel address space.

There can be multiple classes of such restricted kernel address spaces
(e.g. KPTI, KVM-PTI etc.). Each ASI class is identified by an index.
The ASI class can register some hooks to be called when
entering/exiting the restricted address space.

Currently, there is a fixed maximum number of ASI classes supported.
In addition, each process can have at most one restricted address space
from each ASI class. Neither of these are inherent limitations and
are merely simplifying assumptions for the time being.

(The high-level ASI API was derived from the original ASI RFC by
Alexandre Chartre [0]).

[0]:
https://lore.kernel.org/kvm/1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com

Signed-off-by: Ofir Weisse <oweisse@google.com>
Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h       | 175 +++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h |   8 ++
 arch/x86/include/asm/tlbflush.h  |   2 +
 arch/x86/mm/Makefile             |   1 +
 arch/x86/mm/asi.c                | 234 +++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init.c               |   3 +-
 arch/x86/mm/tlb.c                |   2 +-
 include/asm-generic/asi.h        |  50 +++++++++
 include/linux/mm_types.h         |   7 ++
 kernel/fork.c                    |   3 +
 mm/init-mm.c                     |   4 +
 11 files changed, 487 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
new file mode 100644
index 0000000000000..a052e561b2b70
--- /dev/null
+++ b/arch/x86/include/asm/asi.h
@@ -0,0 +1,175 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ASI_H
+#define _ASM_X86_ASI_H
+
+#include <asm-generic/asi.h>
+
+#include <asm/pgtable_types.h>
+#include <asm/percpu.h>
+#include <asm/processor.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+
+/*
+ * Overview of API usage by ASI clients:
+ *
+ * Setup: First call asi_init() to create a domain. At present only one domain
+ * can be created per mm per class, but it's safe to asi_init() this domain
+ * multiple times. For each asi_init() call you must call asi_destroy() AFTER
+ * you are certain all CPUs have exicted the restricted address space (by
+ * calling asi_exit()).
+ *
+ * Runtime usage:
+ *
+ * 1. Call asi_enter() to switch to the restricted address space. This can't be
+ *    from an interrupt or exception handler and preemption must be disabled.
+ *
+ * 2. Execute untrusted code.
+ *
+ * 3. Call asi_relax() to inform the ASI subsystem that untrusted code execution
+ *    is finished. This doesn't cause any address space change.
+ *
+ * 4. Either:
+ *
+ *    a. Go back to 1.
+ *
+ *    b. Call asi_exit() before returning to userspace. This immediately
+ *       switches to the unrestricted address space.
+ *
+ * The region between 1 and 3 is called the "ASI critical section". During the
+ * critical section, it is a bug to access any sensitive data, and you mustn't
+ * sleep.
+ *
+ * The restriction on sleeping is not really a fundamental property of ASI.
+ * However for performance reasons it's important that the critical section is
+ * absolutely as short as possible. So the ability to do sleepy things like
+ * taking mutexes oughtn't to confer any convenience on API users.
+ *
+ * Similarly to the issue of sleeping, the need to asi_exit in case 4b is not a
+ * fundamental property of the system but a limitation of the current
+ * implementation. With further work it is possible to context switch
+ * from and/or to the restricted address space, and to return to userspace
+ * directly from the restricted address space, or _in_ it.
+ *
+ * Note that the critical section only refers to the direct execution path from
+ * asi_enter to asi_relax: it's fine to access sensitive data from exceptions
+ * and interrupt handlers that occur during that time. ASI will re-enter the
+ * restricted address space before returning from the outermost
+ * exception/interrupt.
+ *
+ * Note: ASI does not modify KPTI behaviour; when ASI and KPTI run together
+ * there are 2+N address spaces per task: the unrestricted kernel address space,
+ * the user address space, and one restricted (kernel) address space for each of
+ * the N ASI classes.
+ */
+
+#define ASI_MAX_NUM_ORDER	2
+#define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
+
+struct asi_hooks {
+	/*
+	 * Both of these functions MUST be idempotent and re-entrant. They will
+	 * be called in no particular order and with no particular symmetry wrt.
+	 * the number of calls. They are part of the ASI critical section, so
+	 * they must not sleep and must not access sensitive data.
+	 */
+	void (*post_asi_enter)(void);
+	void (*pre_asi_exit)(void);
+};
+
+/*
+ * An ASI class is a type of isolation that can be applied to a process. A
+ * process may have a domain for each class.
+ */
+struct asi_class {
+	struct asi_hooks ops;
+	const char *name;
+};
+
+/*
+ * An ASI domain (struct asi) represents a restricted address space. The
+ * unrestricted address space (and user address space under PTI) are not
+ * represented as a domain.
+ */
+struct asi {
+	pgd_t *pgd;
+	struct asi_class *class;
+	struct mm_struct *mm;
+	int64_t ref_count;
+};
+
+DECLARE_PER_CPU_ALIGNED(struct asi *, curr_asi);
+
+void asi_init_mm_state(struct mm_struct *mm);
+
+int  asi_register_class(const char *name, const struct asi_hooks *ops);
+void asi_unregister_class(int index);
+
+int  asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi);
+void asi_destroy(struct asi *asi);
+
+/* Enter an ASI domain (restricted address space) and begin the critical section. */
+void asi_enter(struct asi *asi);
+
+/*
+ * Leave the "tense" state if we are in it, i.e. end the critical section. We
+ * will stay relaxed until the next asi_enter.
+ */
+void asi_relax(void);
+
+/* Immediately exit the restricted address space if in it */
+void asi_exit(void);
+
+/* The target is the domain we'll enter when returning to process context. */
+static __always_inline struct asi *asi_get_target(struct task_struct *p)
+{
+	return p->thread.asi_state.target;
+}
+
+static __always_inline void asi_set_target(struct task_struct *p,
+					   struct asi *target)
+{
+	p->thread.asi_state.target = target;
+}
+
+static __always_inline struct asi *asi_get_current(void)
+{
+	return this_cpu_read(curr_asi);
+}
+
+/* Are we currently in a restricted address space? */
+static __always_inline bool asi_is_restricted(void)
+{
+	return (bool)asi_get_current();
+}
+
+/* If we exit/have exited, can we stay that way until the next asi_enter? */
+static __always_inline bool asi_is_relaxed(void)
+{
+	return !asi_get_target(current);
+}
+
+/*
+ * Is the current task in the critical section?
+ *
+ * This is just the inverse of !asi_is_relaxed(). We have both functions in order to
+ * help write intuitive client code. In particular, asi_is_tense returns false
+ * when ASI is disabled, which is judged to make user code more obvious.
+ */
+static __always_inline bool asi_is_tense(void)
+{
+	return !asi_is_relaxed();
+}
+
+static __always_inline pgd_t *asi_pgd(struct asi *asi)
+{
+	return asi ? asi->pgd : NULL;
+}
+
+#define INIT_MM_ASI(init_mm) \
+	.asi_init_lock = __MUTEX_INITIALIZER(init_mm.asi_init_lock),
+
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
+#endif
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index dc45d622eae4e..a42f03ff3edca 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -5,6 +5,7 @@
 #include <asm/processor-flags.h>
 
 /* Forward declaration, a strange C thing */
+struct asi;
 struct task_struct;
 struct mm_struct;
 struct io_bitmap;
@@ -489,6 +490,13 @@ struct thread_struct {
 	struct thread_shstk	shstk;
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	struct {
+		/* Domain to enter when returning to process context. */
+		struct asi	*target;
+	} asi_state;
+#endif
+
 	/* Floating point and extended processor state */
 	struct fpu		fpu;
 	/*
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 25726893c6f4d..ed847567b25de 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -391,6 +391,8 @@ static inline bool huge_pmd_needs_flush(pmd_t oldpmd, pmd_t newpmd)
 }
 #define huge_pmd_needs_flush huge_pmd_needs_flush
 
+unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam);
+
 #ifdef CONFIG_ADDRESS_MASKING
 static inline  u64 tlbstate_lam_cr3_mask(void)
 {
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 428048e73bd2e..499233f001dc2 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)	+= pti.o
+obj-$(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION)		+= asi.o
 
 obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
new file mode 100644
index 0000000000000..c5979d78fdbbd
--- /dev/null
+++ b/arch/x86/mm/asi.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/compiler_types.h>
+#include <linux/export.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+
+#include <asm/asi.h>
+#include <asm/pgalloc.h>
+#include <asm/mmu_context.h>
+
+static struct asi_class asi_class[ASI_MAX_NUM];
+static DEFINE_SPINLOCK(asi_class_lock);
+
+DEFINE_PER_CPU_ALIGNED(struct asi *, curr_asi);
+EXPORT_SYMBOL(curr_asi);
+
+static inline bool asi_class_registered(int index)
+{
+	return asi_class[index].name != NULL;
+}
+
+static inline bool asi_index_valid(int index)
+{
+	return index >= 0 && index < ARRAY_SIZE(asi_class);
+}
+
+int asi_register_class(const char *name, const struct asi_hooks *ops)
+{
+	int i;
+
+	VM_BUG_ON(name == NULL);
+
+	spin_lock(&asi_class_lock);
+
+	for (i = 0; i < ARRAY_SIZE(asi_class); i++) {
+		if (!asi_class_registered(i)) {
+			asi_class[i].name = name;
+			if (ops != NULL)
+				asi_class[i].ops = *ops;
+			break;
+		}
+	}
+
+	spin_unlock(&asi_class_lock);
+
+	if (i == ARRAY_SIZE(asi_class))
+		i = -ENOSPC;
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(asi_register_class);
+
+void asi_unregister_class(int index)
+{
+	BUG_ON(!asi_index_valid(index));
+
+	spin_lock(&asi_class_lock);
+
+	WARN_ON(asi_class[index].name == NULL);
+	memset(&asi_class[index], 0, sizeof(struct asi_class));
+
+	spin_unlock(&asi_class_lock);
+}
+EXPORT_SYMBOL_GPL(asi_unregister_class);
+
+
+static void __asi_destroy(struct asi *asi)
+{
+	lockdep_assert_held(&asi->mm->asi_init_lock);
+
+}
+
+int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
+{
+	struct asi *asi;
+	int err = 0;
+
+	*out_asi = NULL;
+
+	BUG_ON(!asi_index_valid(asi_index));
+
+	asi = &mm->asi[asi_index];
+
+	BUG_ON(!asi_class_registered(asi_index));
+
+	mutex_lock(&mm->asi_init_lock);
+
+	if (asi->ref_count++ > 0)
+		goto exit_unlock; /* err is 0 */
+
+	BUG_ON(asi->pgd != NULL);
+
+	/*
+	 * For now, we allocate 2 pages to avoid any potential problems with
+	 * KPTI code. This won't be needed once KPTI is folded into the ASI
+	 * framework.
+	 */
+	asi->pgd = (pgd_t *)__get_free_pages(
+		GFP_KERNEL_ACCOUNT | __GFP_ZERO, PGD_ALLOCATION_ORDER);
+	if (!asi->pgd) {
+		err = -ENOMEM;
+		goto exit_unlock;
+	}
+
+	asi->class = &asi_class[asi_index];
+	asi->mm = mm;
+
+exit_unlock:
+	if (err)
+		__asi_destroy(asi);
+	else
+		*out_asi = asi;
+
+	mutex_unlock(&mm->asi_init_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(asi_init);
+
+void asi_destroy(struct asi *asi)
+{
+	struct mm_struct *mm;
+
+	if (!asi)
+		return;
+
+	mm = asi->mm;
+	/*
+	 * We would need this mutex even if the refcount was atomic as we need
+	 * to block concurrent asi_init calls.
+	 */
+	mutex_lock(&mm->asi_init_lock);
+	WARN_ON_ONCE(asi->ref_count <= 0);
+	if (--(asi->ref_count) == 0) {
+		free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
+		memset(asi, 0, sizeof(struct asi));
+	}
+	mutex_unlock(&mm->asi_init_lock);
+}
+EXPORT_SYMBOL_GPL(asi_destroy);
+
+static noinstr void __asi_enter(void)
+{
+	u64 asi_cr3;
+	struct asi *target = asi_get_target(current);
+
+	/*
+	 * This is actually false restriction, it should be fine to be
+	 * preemptible during the critical section. But we haven't tested it. We
+	 * will also need to disable preemption during this function itself and
+	 * perhaps elsewhere. This false restriction shouldn't create any
+	 * additional burden for ASI clients anyway: the critical section has
+	 * to be as short as possible to avoid unnecessary ASI transitions so
+	 * disabling preemption should be fine.
+	 */
+	VM_BUG_ON(preemptible());
+
+	if (!target || target == this_cpu_read(curr_asi))
+		return;
+
+	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
+		  LOADED_MM_SWITCHING);
+
+	/*
+	 * Must update curr_asi before writing CR3 to ensure an interrupting
+	 * asi_exit sees that it may need to switch address spaces.
+	 */
+	this_cpu_write(curr_asi, target);
+
+	asi_cr3 = build_cr3(target->pgd,
+			    this_cpu_read(cpu_tlbstate.loaded_mm_asid),
+			    tlbstate_lam_cr3_mask());
+	write_cr3(asi_cr3);
+
+	if (target->class->ops.post_asi_enter)
+		target->class->ops.post_asi_enter();
+}
+
+noinstr void asi_enter(struct asi *asi)
+{
+	VM_WARN_ON_ONCE(!asi);
+
+	asi_set_target(current, asi);
+	barrier();
+
+	__asi_enter();
+}
+EXPORT_SYMBOL_GPL(asi_enter);
+
+inline_or_noinstr void asi_relax(void)
+{
+	barrier();
+	asi_set_target(current, NULL);
+}
+EXPORT_SYMBOL_GPL(asi_relax);
+
+noinstr void asi_exit(void)
+{
+	u64 unrestricted_cr3;
+	struct asi *asi;
+
+	preempt_disable_notrace();
+
+	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
+		  LOADED_MM_SWITCHING);
+
+	asi = this_cpu_read(curr_asi);
+	if (asi) {
+		if (asi->class->ops.pre_asi_exit)
+			asi->class->ops.pre_asi_exit();
+
+		unrestricted_cr3 =
+			build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
+				  this_cpu_read(cpu_tlbstate.loaded_mm_asid),
+				  tlbstate_lam_cr3_mask());
+
+		write_cr3(unrestricted_cr3);
+		/*
+		 * Must not update curr_asi until after CR3 write, otherwise a
+		 * re-entrant call might not enter this branch. (This means we
+		 * might do unnecessary CR3 writes).
+		 */
+		this_cpu_write(curr_asi, NULL);
+	}
+
+	preempt_enable_notrace();
+}
+EXPORT_SYMBOL_GPL(asi_exit);
+
+void asi_init_mm_state(struct mm_struct *mm)
+{
+	memset(mm->asi, 0, sizeof(mm->asi));
+	mutex_init(&mm->asi_init_lock);
+}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 679893ea5e687..5b06d30dee672 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -249,7 +249,8 @@ static void __init probe_page_size_mask(void)
 	/* By the default is everything supported: */
 	__default_kernel_pte_mask = __supported_pte_mask;
 	/* Except when with PTI where the kernel is mostly non-Global: */
-	if (cpu_feature_enabled(X86_FEATURE_PTI))
+	if (cpu_feature_enabled(X86_FEATURE_PTI) ||
+	    IS_ENABLED(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION))
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6ca18ac9058b6..9a5afeac96547 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -155,7 +155,7 @@ static inline u16 user_pcid(u16 asid)
 	return ret;
 }
 
-static inline_or_noinstr unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
+inline_or_noinstr unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
 {
 	unsigned long cr3 = __sme_pa_nodebug(pgd) | lam;
 
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index c4d9a5ff860a9..3660fc1defe87 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -2,4 +2,54 @@
 #ifndef __ASM_GENERIC_ASI_H
 #define __ASM_GENERIC_ASI_H
 
+#ifndef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+
+#define ASI_MAX_NUM_ORDER		0
+#define ASI_MAX_NUM			0
+
+#ifndef _ASSEMBLY_
+
+struct asi_hooks {};
+struct asi {};
+
+static inline
+int asi_register_class(const char *name, const struct asi_hooks *ops)
+{
+	return 0;
+}
+
+static inline void asi_unregister_class(int asi_index) { }
+
+static inline void asi_init_mm_state(struct mm_struct *mm) { }
+
+static inline int asi_init(struct mm_struct *mm, int asi_index,
+			   struct asi **asi_out)
+{
+	return 0;
+}
+
+static inline void asi_destroy(struct asi *asi) { }
+
+static inline void asi_enter(struct asi *asi) { }
+
+static inline void asi_relax(void) { }
+
+static inline bool asi_is_relaxed(void) { return true; }
+
+static inline bool asi_is_tense(void) { return false; }
+
+static inline void asi_exit(void) { }
+
+static inline bool asi_is_restricted(void) { return false; }
+
+static inline struct asi *asi_get_current(void) { return NULL; }
+
+static inline struct asi *asi_get_target(struct task_struct *p) { return NULL; }
+
+static inline pgd_t *asi_pgd(struct asi *asi) { return NULL; }
+
+#endif  /* !_ASSEMBLY_ */
+
+#endif /* !CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
 #endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5240bd7bca338..226a586ebbdca 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -19,8 +19,10 @@
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
 #include <linux/percpu_counter.h>
+#include <linux/mutex.h>
 
 #include <asm/mmu.h>
+#include <asm/asi.h>
 
 #ifndef AT_VECTOR_SIZE_ARCH
 #define AT_VECTOR_SIZE_ARCH 0
@@ -802,6 +804,11 @@ struct mm_struct {
 		atomic_t membarrier_state;
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+		struct asi asi[ASI_MAX_NUM];
+		struct mutex asi_init_lock;
+#endif
+
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/kernel/fork.c b/kernel/fork.c
index aebb3e6c96dc6..a6251d11106a6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -109,6 +109,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/asi.h>
 
 #include <trace/events/sched.h>
 
@@ -1292,6 +1293,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 		mm->def_flags = 0;
 	}
 
+	asi_init_mm_state(mm);
+
 	if (mm_alloc_pgd(mm))
 		goto fail_nopgd;
 
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 24c8093792745..e820e1c6edd48 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -12,6 +12,7 @@
 #include <linux/user_namespace.h>
 #include <linux/iommu.h>
 #include <asm/mmu.h>
+#include <asm/asi.h>
 
 #ifndef INIT_MM_CONTEXT
 #define INIT_MM_CONTEXT(name)
@@ -44,6 +45,9 @@ struct mm_struct init_mm = {
 #endif
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	INIT_MM_ASI(init_mm)
+#endif
 	INIT_MM_CONTEXT(init_mm)
 };
 

-- 
2.45.2.993.g49e7a77208-goog


