Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B326748B86
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjGESSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjGESSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:18:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C21BDF
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 11:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688581027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/ucjOAEaHS5XCwJ7CRYxNKU/jQaRurVwoCVOxjEFxI=;
        b=doHzIz5vR47Xf9CIejudGcE01BiZCnGhpNJNAR/2YeImA+FDuyrUkME6Y4V6VtoOWCKfev
        T1mVqRUtCVQ41+t5KEGKwu0wr5punMiJXA/DStBf5Uy9To7idBVlyLUWztzlCxZJKg1hur
        ixgD4y7qA6OujgA7b0p1BibXKbfrVd8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-LTvzUOljPxOE1cOXn7g4IA-1; Wed, 05 Jul 2023 14:17:05 -0400
X-MC-Unique: LTvzUOljPxOE1cOXn7g4IA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5994C881B28;
        Wed,  5 Jul 2023 18:17:03 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.42.28.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26F1E18EB4;
        Wed,  5 Jul 2023 18:16:58 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org
Cc:     Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: [RFC PATCH 11/14] context-tracking: Introduce work deferral infrastructure
Date:   Wed,  5 Jul 2023 19:12:53 +0100
Message-Id: <20230705181256.3539027-12-vschneid@redhat.com>
In-Reply-To: <20230705181256.3539027-1-vschneid@redhat.com>
References: <20230705181256.3539027-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

smp_call_function() & friends have the unfortunate habit of sending IPIs to
isolated, NOHZ_FULL, in-userspace CPUs, as they blindly target all online
CPUs.

Some callsites can be bent into doing the right, such as done by commit:

  cc9e303c91f5 ("x86/cpu: Disable frequency requests via aperfmperf IPI for nohz_full CPUs")

Unfortunately, not all SMP callbacks can be omitted in this
fashion. However, some of them only affect execution in kernelspace, which
means they don't have to be executed *immediately* if the target CPU is in
userspace: stashing the callback and executing it upon the next kernel entry
would suffice. x86 kernel instruction patching or kernel TLB invalidation
are prime examples of it.

Add a field in struct context_tracking used as a bitmask to track deferred
callbacks to execute upon kernel entry. The LSB of that field is used as a
flag to prevent queueing deferred work when the CPU leaves userspace.

Later commits introduce the bit:callback mappings.

Note: A previous approach by PeterZ [1] used an extra bit in
context_tracking.state to flag the presence of deferred callbacks to
execute, and the actual callbacks were stored in a separate atomic
variable.

This meant that the atomic read of context_tracking.state was sufficient to
determine whether there are any deferred callbacks to execute.
Unfortunately, it presents a race window. Consider the work setting
function as:

  preempt_disable();
  seq = atomic_read(&ct->seq);
  if (__context_tracking_seq_in_user(seq)) {
	  /* ctrl-dep */
	  atomic_or(work, &ct->work);
	  ret = atomic_try_cmpxchg(&ct->seq, &seq, seq|CT_SEQ_WORK);
  }
  preempt_enable();

  return ret;

Then the following can happen:

  CPUx                                             CPUy
						     CT_SEQ_WORK \in context_tracking.state
    atomic_or(WORK_N, &ct->work);
						      ct_kernel_enter()
							ct_state_inc();
    atomic_try_cmpxchg(&ct->seq, &seq, seq|CT_SEQ_WORK);

The cmpxchg() would fail, ultimately causing an IPI for WORK_N to be
sent. Unfortunately, the work bit would remain set, and it can't be sanely
cleared in case another CPU set it concurrently - this would ultimately
lead to a double execution of the callback, one as a deferred callback and
one in the IPI. As not all IPI callbacks are idempotent, this is
undesirable.

Link: https://lore.kernel.org/all/20210929151723.162004989@infradead.org/
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/Kconfig                                 |  9 +++
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/context_tracking_work.h | 14 +++++
 include/linux/context_tracking.h             |  1 +
 include/linux/context_tracking_state.h       |  1 +
 include/linux/context_tracking_work.h        | 28 +++++++++
 kernel/context_tracking.c                    | 63 ++++++++++++++++++++
 kernel/time/Kconfig                          |  5 ++
 8 files changed, 122 insertions(+)
 create mode 100644 arch/x86/include/asm/context_tracking_work.h
 create mode 100644 include/linux/context_tracking_work.h

diff --git a/arch/Kconfig b/arch/Kconfig
index 205fd23e0cada..e453e9fb864be 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -851,6 +851,15 @@ config HAVE_CONTEXT_TRACKING_USER_OFFSTACK
 	  - No use of instrumentation, unless instrumentation_begin() got
 	    called.
 
+config HAVE_CONTEXT_TRACKING_WORK
+	bool
+	help
+	  Architecture supports deferring work while not in kernel context.
+	  This is especially useful on setups with isolated CPUs that might
+	  want to avoid being interrupted to perform housekeeping tasks (for
+	  ex. TLB invalidation or icache invalidation). The housekeeping
+	  operations are performed upon re-entering the kernel.
+
 config HAVE_TIF_NOHZ
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 53bab123a8ee4..490c773105c0c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -197,6 +197,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING_USER		if X86_64
 	select HAVE_CONTEXT_TRACKING_USER_OFFSTACK	if HAVE_CONTEXT_TRACKING_USER
+	select HAVE_CONTEXT_TRACKING_WORK		if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_OBJTOOL_MCOUNT		if HAVE_OBJTOOL
 	select HAVE_OBJTOOL_NOP_MCOUNT		if HAVE_OBJTOOL_MCOUNT
diff --git a/arch/x86/include/asm/context_tracking_work.h b/arch/x86/include/asm/context_tracking_work.h
new file mode 100644
index 0000000000000..5bc29e6b2ed38
--- /dev/null
+++ b/arch/x86/include/asm/context_tracking_work.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_CONTEXT_TRACKING_WORK_H
+#define _ASM_X86_CONTEXT_TRACKING_WORK_H
+
+static __always_inline void arch_context_tracking_work(int work)
+{
+	switch (work) {
+	case CONTEXT_WORK_n:
+		// Do work...
+		break;
+	}
+}
+
+#endif
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index d3cbb6c16babf..80d571ddfc3a4 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/vtime.h>
 #include <linux/context_tracking_state.h>
+#include <linux/context_tracking_work.h>
 #include <linux/instrumentation.h>
 
 #include <asm/ptrace.h>
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index fdd537ea513ff..5af06ed26f858 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -36,6 +36,7 @@ struct context_tracking {
 	int recursion;
 #endif
 #ifdef CONFIG_CONTEXT_TRACKING
+	atomic_t work;
 	atomic_t state;
 #endif
 #ifdef CONFIG_CONTEXT_TRACKING_IDLE
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
new file mode 100644
index 0000000000000..0b06c3dab58c7
--- /dev/null
+++ b/include/linux/context_tracking_work.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CONTEXT_TRACKING_WORK_H
+#define _LINUX_CONTEXT_TRACKING_WORK_H
+
+#include <linux/bitops.h>
+
+enum {
+	CONTEXT_WORK_DISABLED_OFFSET,
+	CONTEXT_WORK_n_OFFSET,
+	CONTEXT_WORK_MAX_OFFSET
+};
+
+enum ct_work {
+	CONTEXT_WORK_DISABLED = BIT(CONTEXT_WORK_DISABLED_OFFSET),
+	CONTEXT_WORK_n        = BIT(CONTEXT_WORK_n_OFFSET),
+	CONTEXT_WORK_MAX      = BIT(CONTEXT_WORK_MAX_OFFSET)
+};
+
+#include <asm/context_tracking_work.h>
+
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+extern bool ct_set_cpu_work(unsigned int cpu, unsigned int work);
+#else
+static inline bool
+ct_set_cpu_work(unsigned int cpu, unsigned int work) { return false; }
+#endif
+
+#endif
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 4e6cb14272fcb..b6aee3d0c0528 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -32,6 +32,9 @@ DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 	.dynticks_nmi_nesting = DYNTICK_IRQ_NONIDLE,
 #endif
 	.state = ATOMIC_INIT(RCU_DYNTICKS_IDX),
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+	.work = ATOMIC_INIT(CONTEXT_WORK_DISABLED),
+#endif
 };
 EXPORT_SYMBOL_GPL(context_tracking);
 
@@ -72,6 +75,57 @@ static __always_inline void rcu_dynticks_task_trace_exit(void)
 #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
 
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+static __always_inline unsigned int ct_work_fetch(struct context_tracking *ct)
+{
+	return arch_atomic_fetch_or(CONTEXT_WORK_DISABLED, &ct->work);
+}
+static __always_inline void ct_work_clear(struct context_tracking *ct)
+{
+	arch_atomic_set(&ct->work, 0);
+}
+
+static noinstr void ct_work_flush(unsigned long work)
+{
+	int bit;
+
+	/* DISABLED is never set while there are deferred works */
+	WARN_ON_ONCE(work & CONTEXT_WORK_DISABLED);
+
+	/*
+	 * arch_context_tracking_work() must be noinstr, non-blocking,
+	 * and NMI safe.
+	 */
+	for_each_set_bit(bit, &work, CONTEXT_WORK_MAX)
+		arch_context_tracking_work(BIT(bit));
+}
+
+bool ct_set_cpu_work(unsigned int cpu, unsigned int work)
+{
+	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);
+	unsigned int old_work;
+	bool ret = false;
+
+	preempt_disable();
+
+	old_work = atomic_read(&ct->work);
+	/*
+	 * Try setting the work until either
+	 * - the target CPU no longer accepts any more deferred work
+	 * - the work has been set
+	 */
+	while (!(old_work & CONTEXT_WORK_DISABLED) && !ret)
+		ret = atomic_try_cmpxchg(&ct->work, &old_work, old_work | work);
+
+	preempt_enable();
+	return ret;
+}
+#else
+static __always_inline void ct_work_flush(unsigned long work) { }
+static __always_inline unsigned int ct_work_fetch(struct context_tracking *ct) { return 0; }
+static __always_inline void ct_work_clear(struct context_tracking *ct) { }
+#endif
+
 /*
  * Record entry into an extended quiescent state.  This is only to be
  * called when not already in an extended quiescent state, that is,
@@ -89,6 +143,10 @@ static noinstr void ct_kernel_exit_state(int offset)
 	 */
 	rcu_dynticks_task_trace_enter();  // Before ->dynticks update!
 	seq = ct_state_inc(offset);
+
+	/* Let this CPU allow deferred callbacks again */
+	ct_work_clear(this_cpu_ptr(&context_tracking));
+
 	// RCU is no longer watching.  Better be in extended quiescent state!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && (seq & RCU_DYNTICKS_IDX));
 }
@@ -100,14 +158,19 @@ static noinstr void ct_kernel_exit_state(int offset)
  */
 static noinstr void ct_kernel_enter_state(int offset)
 {
+	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
 	int seq;
+	unsigned int work;
 
+	work = ct_work_fetch(ct);
 	/*
 	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
 	 * and we also must force ordering with the next RCU read-side
 	 * critical section.
 	 */
 	seq = ct_state_inc(offset);
+	if (work)
+		ct_work_flush(work);
 	// RCU is now watching.  Better not be in an extended quiescent state!
 	rcu_dynticks_task_trace_exit();  // After ->dynticks update!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & RCU_DYNTICKS_IDX));
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index bae8f11070bef..fdb266f2d774b 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -181,6 +181,11 @@ config CONTEXT_TRACKING_USER_FORCE
 	  Say N otherwise, this option brings an overhead that you
 	  don't want in production.
 
+config CONTEXT_TRACKING_WORK
+	bool
+	depends on HAVE_CONTEXT_TRACKING_WORK && CONTEXT_TRACKING_USER
+	default y
+
 config NO_HZ
 	bool "Old Idle dynticks config"
 	help
-- 
2.31.1

