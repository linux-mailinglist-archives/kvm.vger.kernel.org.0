Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB70A7490F3
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 00:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjGEWYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 18:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGEWYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 18:24:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA023A9;
        Wed,  5 Jul 2023 15:24:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8794C61789;
        Wed,  5 Jul 2023 22:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BF7C433C7;
        Wed,  5 Jul 2023 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688595841;
        bh=7HeBDOa/LX+W3drzDFVFH2u+XTBdq1prz5VSNxFOvwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O7zynVxe6Eac6BpYL1V1McKGBDINZNGEmPRkwUM8Qdqe6S3t0I81z9Rh4Dt+xQiWr
         8eDkRvOMprfm9HJ7kyDg8trIwwbKj2aWoTc0+1N9ccYUKnIXXmyxZ9z1u/M7X5b6ut
         ymMliGEPk4zNTszi/vhyCc5xbb0M55FGrm+qpB9d0Z7C545SoRza5W2SDx9IPy/47B
         jSgo2X+UHyiShANFhNBdP7fla1hIC5OIZS4tUySBZo67nqB1QXB6Zs1t6svEmeeaqI
         s/nfTdp2IcR30cXGYF6Xzc6fL5FlBeN62KkB3RTIbEozMEFI2u/yLc4yLsRoSWqycT
         K4Z14r9HNnGnA==
Date:   Thu, 6 Jul 2023 00:23:57 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
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
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 11/14] context-tracking: Introduce work deferral
 infrastructure
Message-ID: <ZKXtfWZiM66dK5xC@localhost.localdomain>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230705181256.3539027-12-vschneid@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le Wed, Jul 05, 2023 at 07:12:53PM +0100, Valentin Schneider a écrit :
> +bool ct_set_cpu_work(unsigned int cpu, unsigned int work)
> +{
> +	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);
> +	unsigned int old_work;
> +	bool ret = false;
> +
> +	preempt_disable();
> +
> +	old_work = atomic_read(&ct->work);
> +	/*
> +	 * Try setting the work until either
> +	 * - the target CPU no longer accepts any more deferred work
> +	 * - the work has been set
> +	 */
> +	while (!(old_work & CONTEXT_WORK_DISABLED) && !ret)

Isn't there a race here where you may have missed a CPU that just entered in
user and you eventually disturb it?

> +		ret = atomic_try_cmpxchg(&ct->work, &old_work, old_work | work);
> +
> +	preempt_enable();
> +	return ret;
> +}
[...]
> @@ -100,14 +158,19 @@ static noinstr void ct_kernel_exit_state(int offset)
>   */
>  static noinstr void ct_kernel_enter_state(int offset)
>  {
> +	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
>  	int seq;
> +	unsigned int work;
>  
> +	work = ct_work_fetch(ct);

So this adds another fully ordered operation on user <-> kernel transition.
How many such IPIs can we expect?

If this is just about a dozen, can we stuff them in the state like in the
following? We can potentially add more of them especially on 64 bits we could
afford 30 different works, this is just shrinking the RCU extended quiescent
state counter space. Worst case that can happen is that RCU misses 65535
idle/user <-> kernel transitions and delays a grace period...

diff --git a/arch/Kconfig b/arch/Kconfig
index 205fd23e0cad..e453e9fb864b 100644
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
index 53bab123a8ee..490c773105c0 100644
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
index 000000000000..5bc29e6b2ed3
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
index d3cbb6c16bab..333b26d7cbe5 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/vtime.h>
 #include <linux/context_tracking_state.h>
+#include <linux/context_tracking_work.h>
 #include <linux/instrumentation.h>
 
 #include <asm/ptrace.h>
@@ -75,7 +76,7 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 static __always_inline bool context_tracking_guest_enter(void)
 {
 	if (context_tracking_enabled())
-		__ct_user_enter(CONTEXT_GUEST);
+		__ct_user_enter(CONTEXT_USER);
 
 	return context_tracking_enabled_this_cpu();
 }
@@ -83,7 +84,7 @@ static __always_inline bool context_tracking_guest_enter(void)
 static __always_inline void context_tracking_guest_exit(void)
 {
 	if (context_tracking_enabled())
-		__ct_user_exit(CONTEXT_GUEST);
+		__ct_user_exit(CONTEXT_USER);
 }
 
 #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
@@ -122,6 +123,26 @@ static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
 	return !(arch_atomic_read(this_cpu_ptr(&context_tracking.state)) & RCU_DYNTICKS_IDX);
 }
 
+/*
+ * Increment the current CPU's context_tracking structure's ->state field
+ * with ordering and clear the work bits.  Return the new value.
+ */
+static __always_inline unsigned long ct_state_inc_clear_work(int incby)
+{
+	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
+	unsigned long new, old, state;
+
+	state = arch_atomic_read(&ct->state);
+	do {
+		old = state;
+		new = old & ~CONTEXT_WORK_MASK;
+		new += incby;
+		state = arch_atomic_cmpxchg(&ct->state, old, new);
+	} while (old != state);
+
+	return state;
+}
+
 /*
  * Increment the current CPU's context_tracking structure's ->state field
  * with ordering.  Return the new value.
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index fdd537ea513f..ec3d172601c5 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -10,14 +10,19 @@
 #define DYNTICK_IRQ_NONIDLE	((LONG_MAX / 2) + 1)
 
 enum ctx_state {
+	/* Following are values */
 	CONTEXT_DISABLED	= -1,	/* returned by ct_state() if unknown */
 	CONTEXT_KERNEL		= 0,
 	CONTEXT_IDLE		= 1,
 	CONTEXT_USER		= 2,
-	CONTEXT_GUEST		= 3,
-	CONTEXT_MAX		= 4,
+	/* Following are bit numbers */
+	CONTEXT_WORK		= 2,
+	CONTEXT_MAX		= 16,
 };
 
+#define CONTEXT_MASK (BIT(CONTEXT_WORK) - 1)
+#define CONTEXT_WORK_MASK ((BIT(CONTEXT_MAX) - 1) & ~(BIT(CONTEXT_WORK) - 1))
+
 /* Even value for idle, else odd. */
 #define RCU_DYNTICKS_IDX CONTEXT_MAX
 
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
new file mode 100644
index 000000000000..fb74db8876dd
--- /dev/null
+++ b/include/linux/context_tracking_work.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CONTEXT_TRACKING_WORK_H
+#define _LINUX_CONTEXT_TRACKING_WORK_H
+
+#include <linux/bitops.h>
+
+enum {
+	CONTEXT_WORK_n_OFFSET,
+	CONTEXT_WORK_MAX_OFFSET
+};
+
+enum ct_work {
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
index a09f1c19336a..732042b9a7b7 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -72,6 +72,58 @@ static __always_inline void rcu_dynticks_task_trace_exit(void)
 #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
 }
 
+#ifdef CONFIG_CONTEXT_TRACKING_WORK
+static noinstr void ct_work_flush(unsigned long seq)
+{
+	unsigned int bit;
+	/*
+	 * arch_context_tracking_work() must be noinstr, non-blocking,
+	 * and NMI safe.
+	 */
+	for_each_set_bit(bit, &seq, CONTEXT_MAX)
+		arch_context_tracking_work(BIT(bit) >> CONTEXT_WORK);
+}
+
+bool ct_set_cpu_work(unsigned int cpu, unsigned int work)
+{
+	struct context_tracking *ct = per_cpu_ptr(&context_tracking, cpu);
+	unsigned int old, new, state;
+	bool ret = false;
+
+	preempt_disable();
+
+	work <<= CONTEXT_WORK;
+	state = atomic_read(&ct->state);
+	/*
+	 * Try setting the work until either
+	 * - the target CPU is on the kernel
+	 * - the work has been set
+	 */
+	for (;;) {
+		/* Only set if running in user/guest */
+		old = state;
+		old &= ~CONTEXT_MASK;
+		old |= CONTEXT_USER;
+
+		new = old | work;
+
+		state = atomic_cmpxchg(&ct->state, old, new);
+		if (state & work) {
+			ret = true;
+			break;
+		}
+
+		if ((state & CONTEXT_MASK) != CONTEXT_USER)
+			break;
+	}
+
+	preempt_enable();
+	return ret;
+}
+#else
+static __always_inline void ct_work_flush(unsigned long seq) { }
+#endif
+
 /*
  * Record entry into an extended quiescent state.  This is only to be
  * called when not already in an extended quiescent state, that is,
@@ -100,14 +152,18 @@ static noinstr void ct_kernel_exit_state(int offset)
  */
 static noinstr void ct_kernel_enter_state(int offset)
 {
-	int seq;
+	struct context_tracking *ct = this_cpu_ptr(&context_tracking);
+	unsigned long seq;
 
 	/*
 	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
 	 * and we also must force ordering with the next RCU read-side
 	 * critical section.
 	 */
-	seq = ct_state_inc(offset);
+	seq = ct_state_inc_clear_work(offset);
+	if (seq & CONTEXT_WORK_MASK)
+		ct_work_flush(seq & CONTEXT_WORK_MASK);
+
 	// RCU is now watching.  Better not be in an extended quiescent state!
 	rcu_dynticks_task_trace_exit();  // After ->dynticks update!
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & RCU_DYNTICKS_IDX));
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index bae8f11070be..fdb266f2d774 100644
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
2.40.1

