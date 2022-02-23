Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13874C0C20
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiBWF2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiBWF1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7986D4EA
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so2533763ybp.19
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OyDHTZ7Ac6r1LQol+lgAiZ5efN30RaXmeX7z0hPyuqA=;
        b=DdkDTnIiPn6TLdbXCmFvIo19iJFubFIhdETlSTTLRRjgZ4Sbw2XRK1yw+KEVLoro4T
         wP84t15CnH7WoNP9nOE1xCfFjeXiFihRdrvEeEaqbhIrww6MkpxMl0Beadw+zBAHg4Wm
         Y49K0SbIs0XAjHP26SPAuOOPd/FRd4AzW+548DKIXzxHOTL9Gnv2I7DesA74Y2aSN1w7
         bukmgHnjTzQ3TsZeAD6EjoZj4bz08/67lWCDyTLOclgldihhQFgdX/f7KijewY11x+pe
         ztyxmT3V40T+w3mwFuSkO23/qUqxo0xoLiD6fHheWqBlYJ4PhhilLPTmelIkwEUqdEVv
         YRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OyDHTZ7Ac6r1LQol+lgAiZ5efN30RaXmeX7z0hPyuqA=;
        b=Q/OeopjTqdqlThJK85rRc1a1W7ua51QstB6p+iS22B1MpQy/GXaKS5rix979CGDomg
         rRnuCTP4dy2kGiHVgfXHwFmyIVzO7s/QUP2xeT+plHBVyvY6U4nrMb9dT1tfmaUBE/D7
         3bWjatswTsm8g28Ft+yvyVigRXRXSjnLQvGNUzBI2qHTW3eaXpRTg2+qSkFnjqbu9vDt
         lH0zkX26+S0q/2pkR41zbjmaRFn1ayV4q7phIPwggqHTKcZlhu1mJ+IHdW1X3TKuUOyt
         CsA5cJ43KE9yshHfNQJ8bQbRy8f0ZALxVEIMRGPHZQNnCivvTw1/hQeT4Yr0gAV3M6lF
         OXRA==
X-Gm-Message-State: AOAM5339bUPTve32ERqhlQ4Xqo1vJ/8rtFmPBxYe2vfwTIQUiVr94hLq
        ioAFeMs3iWoyFlfvkUuOiKjrI/EUj18e
X-Google-Smtp-Source: ABdhPJzJ67z80Uc/VNlFr/C8BlwDxiZI69VgqPgglpNrTFnLyw6IzyUmF2cWMgeuQwRsundlA5eSPH6P2ztJ
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:e45:0:b0:2d6:bc2e:3f66 with SMTP id
 66-20020a810e45000000b002d6bc2e3f66mr22941292ywo.54.1645593919291; Tue, 22
 Feb 2022 21:25:19 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:18 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-43-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 42/47] mm: asi: Annotation of PERCPU variables to be nonsensitive
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

The heart of ASI is to diffrentiate between sensitive and non-sensitive
data access. This commit marks certain static PERCPU variables as not
sensitive.

Some static variables are accessed frequently and therefore would cause
many ASI exits. The frequency of these accesses is monitored by tracing
asi_exits and analyzing the accessed addresses. Many of these variables
don't contain sensitive information and can therefore be mapped into the
global ASI region. This commit modified
DEFINE_PER_CPU --> DEFINE_PER_CPU_ASI_NOT_SENSITIVE to variables which
are frequenmtly-accessed yet not sensitive variables.
The end result is a very significant reduction in ASI exits on real
benchmarks.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/events/core.c                |  2 +-
 arch/x86/events/intel/bts.c           |  2 +-
 arch/x86/events/perf_event.h          |  2 +-
 arch/x86/include/asm/asi.h            |  2 +-
 arch/x86/include/asm/current.h        |  2 +-
 arch/x86/include/asm/debugreg.h       |  2 +-
 arch/x86/include/asm/desc.h           |  2 +-
 arch/x86/include/asm/fpu/api.h        |  2 +-
 arch/x86/include/asm/hardirq.h        |  2 +-
 arch/x86/include/asm/hw_irq.h         |  2 +-
 arch/x86/include/asm/percpu.h         |  2 +-
 arch/x86/include/asm/preempt.h        |  2 +-
 arch/x86/include/asm/processor.h      | 12 ++++++------
 arch/x86/include/asm/smp.h            |  2 +-
 arch/x86/include/asm/tlbflush.h       |  4 ++--
 arch/x86/include/asm/topology.h       |  2 +-
 arch/x86/kernel/apic/apic.c           |  2 +-
 arch/x86/kernel/apic/x2apic_cluster.c |  6 +++---
 arch/x86/kernel/cpu/common.c          | 12 ++++++------
 arch/x86/kernel/fpu/core.c            |  2 +-
 arch/x86/kernel/hw_breakpoint.c       |  2 +-
 arch/x86/kernel/irq.c                 |  2 +-
 arch/x86/kernel/irqinit.c             |  2 +-
 arch/x86/kernel/nmi.c                 |  6 +++---
 arch/x86/kernel/process.c             |  4 ++--
 arch/x86/kernel/setup_percpu.c        |  4 ++--
 arch/x86/kernel/smpboot.c             |  3 ++-
 arch/x86/kernel/tsc.c                 |  2 +-
 arch/x86/kvm/x86.c                    |  2 +-
 arch/x86/kvm/x86.h                    |  2 +-
 arch/x86/mm/asi.c                     |  2 +-
 arch/x86/mm/init.c                    |  2 +-
 arch/x86/mm/tlb.c                     |  2 +-
 include/asm-generic/irq_regs.h        |  2 +-
 include/linux/arch_topology.h         |  2 +-
 include/linux/hrtimer.h               |  2 +-
 include/linux/interrupt.h             |  2 +-
 include/linux/kernel_stat.h           |  4 ++--
 include/linux/prandom.h               |  2 +-
 kernel/events/core.c                  |  6 +++---
 kernel/irq_work.c                     |  6 +++---
 kernel/rcu/tree.c                     |  2 +-
 kernel/sched/core.c                   |  6 +++---
 kernel/sched/cpufreq.c                |  3 ++-
 kernel/sched/cputime.c                |  2 +-
 kernel/sched/sched.h                  | 21 +++++++++++----------
 kernel/sched/topology.c               | 14 +++++++-------
 kernel/smp.c                          |  7 ++++---
 kernel/softirq.c                      |  2 +-
 kernel/time/hrtimer.c                 |  2 +-
 kernel/time/tick-common.c             |  2 +-
 kernel/time/tick-internal.h           |  4 ++--
 kernel/time/tick-sched.c              |  2 +-
 kernel/time/timer.c                   |  2 +-
 kernel/trace/trace.c                  |  2 +-
 kernel/trace/trace_preemptirq.c       |  2 +-
 kernel/watchdog.c                     | 12 ++++++------
 lib/irq_regs.c                        |  2 +-
 lib/random32.c                        |  3 ++-
 virt/kvm/kvm_main.c                   |  2 +-
 60 files changed, 112 insertions(+), 107 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index db825bf053fd..2d9829d774d7 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -47,7 +47,7 @@
 struct x86_pmu x86_pmu __asi_not_sensitive_readmostly;
 static struct pmu pmu;
 
-DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 	.pmu = &pmu,
 };
diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 974e917e65b2..06d9de514b0d 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -36,7 +36,7 @@ enum {
 	BTS_STATE_ACTIVE,
 };
 
-static DEFINE_PER_CPU(struct bts_ctx, bts_ctx);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct bts_ctx, bts_ctx);
 
 #define BTS_RECORD_SIZE		24
 #define BTS_SAFETY_MARGIN	4080
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 27cca7fd6f17..9a4855e6ffa6 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1036,7 +1036,7 @@ static inline bool x86_pmu_has_lbr_callstack(void)
 		x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
 }
 
-DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct cpu_hw_events, cpu_hw_events);
 
 int x86_perf_event_set_period(struct perf_event *event);
 
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index d43f6aadffee..6148e65fb0c2 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -52,7 +52,7 @@ struct asi_pgtbl_pool {
 	uint count;
 };
 
-DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
+DECLARE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(struct asi_state, asi_cpu_state);
 
 extern pgd_t asi_global_nonsensitive_pgd[];
 
diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index 3e204e6140b5..a4bcf1f305bf 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -8,7 +8,7 @@
 #ifndef __ASSEMBLY__
 struct task_struct;
 
-DECLARE_PER_CPU(struct task_struct *, current_task);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, current_task);
 
 static __always_inline struct task_struct *get_current(void)
 {
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index cfdf307ddc01..fa67db27b098 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -6,7 +6,7 @@
 #include <linux/bug.h>
 #include <uapi/asm/debugreg.h>
 
-DECLARE_PER_CPU(unsigned long, cpu_dr7);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, cpu_dr7);
 
 #ifndef CONFIG_PARAVIRT_XXL
 /*
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index ab97b22ac04a..7d9fff8c9543 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -298,7 +298,7 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-DECLARE_PER_CPU(bool, __tss_limit_invalid);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(bool, __tss_limit_invalid);
 
 static inline void force_reload_TR(void)
 {
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 6f5ca3c2ef4a..15abb1b05fbc 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -121,7 +121,7 @@ static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 
 /* State tracking */
-DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct fpu *, fpu_fpregs_owner_ctx);
 
 /* Process cleanup */
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 275e7fd20310..2f70deca4a20 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -46,7 +46,7 @@ typedef struct {
 #endif
 } ____cacheline_aligned irq_cpustat_t;
 
-DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
+DECLARE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(irq_cpustat_t, irq_stat);
 
 #define __ARCH_IRQ_STAT
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index d465ece58151..e561abfce735 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -128,7 +128,7 @@ extern char spurious_entries_start[];
 #define VECTOR_RETRIGGERED	((void *)-2L)
 
 typedef struct irq_desc* vector_irq_t[NR_VECTORS];
-DECLARE_PER_CPU(vector_irq_t, vector_irq);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(vector_irq_t, vector_irq);
 
 #endif /* !ASSEMBLY_ */
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index a3c33b79fb86..f9486bbe8a76 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -390,7 +390,7 @@ static inline bool x86_this_cpu_variable_test_bit(int nr,
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index fe5efbcba824..204a8532b870 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -7,7 +7,7 @@
 #include <linux/thread_info.h>
 #include <linux/static_call_types.h>
 
-DECLARE_PER_CPU(int, __preempt_count);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(int, __preempt_count);
 
 /* We use the MSB mostly because its available */
 #define PREEMPT_NEED_RESCHED	0x80000000
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 20116efd2756..63831f9a503b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -417,14 +417,14 @@ struct tss_struct {
 	struct x86_io_bitmap	io_bitmap;
 } __aligned(PAGE_SIZE);
 
-DECLARE_PER_CPU_PAGE_ALIGNED(struct tss_struct, cpu_tss_rw);
+DECLARE_PER_CPU_PAGE_ALIGNED_ASI_NOT_SENSITIVE(struct tss_struct, cpu_tss_rw);
 
 /* Per CPU interrupt stacks */
 struct irq_stack {
 	char		stack[IRQ_STACK_SIZE];
 } __aligned(IRQ_STACK_SIZE);
 
-DECLARE_PER_CPU(unsigned long, cpu_current_top_of_stack);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, cpu_current_top_of_stack);
 
 #ifdef CONFIG_X86_64
 struct fixed_percpu_data {
@@ -448,8 +448,8 @@ static inline unsigned long cpu_kernelmode_gs_base(int cpu)
 	return (unsigned long)per_cpu(fixed_percpu_data.gs_base, cpu);
 }
 
-DECLARE_PER_CPU(void *, hardirq_stack_ptr);
-DECLARE_PER_CPU(bool, hardirq_stack_inuse);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(void *, hardirq_stack_ptr);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(bool, hardirq_stack_inuse);
 extern asmlinkage void ignore_sysret(void);
 
 /* Save actual FS/GS selectors and bases to current->thread */
@@ -458,8 +458,8 @@ void current_save_fsgs(void);
 #ifdef CONFIG_STACKPROTECTOR
 DECLARE_PER_CPU(unsigned long, __stack_chk_guard);
 #endif
-DECLARE_PER_CPU(struct irq_stack *, hardirq_stack_ptr);
-DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct irq_stack *, hardirq_stack_ptr);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct irq_stack *, softirq_stack_ptr);
 #endif	/* !X86_64 */
 
 struct perf_event;
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 81a0211a372d..8d85a918532e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -19,7 +19,7 @@ DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_l2c_shared_map);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_l2c_id);
-DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(int, cpu_number);
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 7d04aa2a5f86..adcdeb58d817 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -151,7 +151,7 @@ struct tlb_state {
 	 */
 	struct tlb_context ctxs[TLB_NR_DYN_ASIDS];
 };
-DECLARE_PER_CPU_ALIGNED(struct tlb_state, cpu_tlbstate);
+DECLARE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct tlb_state, cpu_tlbstate);
 
 struct tlb_state_shared {
 	/*
@@ -171,7 +171,7 @@ struct tlb_state_shared {
 	 */
 	bool is_lazy;
 };
-DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
+DECLARE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct tlb_state_shared, cpu_tlbstate_shared);
 
 bool nmi_uaccess_okay(void);
 #define nmi_uaccess_okay nmi_uaccess_okay
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index cc164777e661..bff1a9123469 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -203,7 +203,7 @@ DECLARE_STATIC_KEY_FALSE(arch_scale_freq_key);
 
 #define arch_scale_freq_invariant() static_branch_likely(&arch_scale_freq_key)
 
-DECLARE_PER_CPU(unsigned long, arch_freq_scale);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, arch_freq_scale);
 
 static inline long arch_scale_freq_capacity(int cpu)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..5fa0ce0ecfb3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -548,7 +548,7 @@ static struct clock_event_device lapic_clockevent = {
 	.rating				= 100,
 	.irq				= -1,
 };
-static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct clock_event_device, lapic_events);
 
 static const struct x86_cpu_id deadline_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL_STEPPINGS(HASWELL_X, X86_STEPPINGS(0x2, 0x2), 0x3a), /* EP */
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e696e22d0531..655fe820a240 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -20,10 +20,10 @@ struct cluster_mask {
  * x86_cpu_to_logical_apicid for all online cpus in a sequential way.
  * Using per cpu variable would cost one cache line per cpu.
  */
-static u32 *x86_cpu_to_logical_apicid __read_mostly;
+static u32 *x86_cpu_to_logical_apicid __asi_not_sensitive_readmostly;
 
-static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
-static DEFINE_PER_CPU_READ_MOSTLY(struct cluster_mask *, cluster_masks);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(cpumask_var_t, ipi_mask);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct cluster_mask *, cluster_masks);
 static struct cluster_mask *cluster_hotplug_mask;
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0083464de5e3..471b3a42db64 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1775,17 +1775,17 @@ EXPORT_PER_CPU_SYMBOL_GPL(fixed_percpu_data);
  * The following percpu variables are hot.  Align current_task to
  * cacheline size such that they fall in the same cacheline.
  */
-DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, current_task) ____cacheline_aligned =
 	&init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(void *, hardirq_stack_ptr);
-DEFINE_PER_CPU(bool, hardirq_stack_inuse);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(void *, hardirq_stack_ptr);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(bool, hardirq_stack_inuse);
 
-DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, __preempt_count) = INIT_PREEMPT_COUNT;
 EXPORT_PER_CPU_SYMBOL(__preempt_count);
 
-DEFINE_PER_CPU(unsigned long, cpu_current_top_of_stack) = TOP_OF_INIT_STACK;
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, cpu_current_top_of_stack) = TOP_OF_INIT_STACK;
 
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
@@ -1826,7 +1826,7 @@ void syscall_init(void)
 
 #else	/* CONFIG_X86_64 */
 
-DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
 EXPORT_PER_CPU_SYMBOL(__preempt_count);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index d7859573973d..b59317c5721f 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -57,7 +57,7 @@ static DEFINE_PER_CPU(bool, in_kernel_fpu);
 /*
  * Track which context is using the FPU on the CPU:
  */
-DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct fpu *, fpu_fpregs_owner_ctx);
 
 struct kmem_cache *fpstate_cachep;
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 668a4a6533d9..c2ceea8f6801 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -36,7 +36,7 @@
 #include <asm/tlbflush.h>
 
 /* Per cpu debug control register value */
-DEFINE_PER_CPU(unsigned long, cpu_dr7);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, cpu_dr7);
 EXPORT_PER_CPU_SYMBOL(cpu_dr7);
 
 /* Per cpu debug address registers values */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 766ffe3ba313..5c5aa75050a5 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -26,7 +26,7 @@
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
 
-DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
+DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
 atomic_t irq_err_count;
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index beb1bada1b0a..d7893e040695 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -46,7 +46,7 @@
  * (these are usually mapped into the 0x30-0xff vector range)
  */
 
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(vector_irq_t, vector_irq) = {
 	[0 ... NR_VECTORS - 1] = VECTOR_UNUSED,
 };
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 4bce802d25fb..ef95071228ca 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -469,9 +469,9 @@ enum nmi_states {
 	NMI_EXECUTING,
 	NMI_LATCHED,
 };
-static DEFINE_PER_CPU(enum nmi_states, nmi_state);
-static DEFINE_PER_CPU(unsigned long, nmi_cr2);
-static DEFINE_PER_CPU(unsigned long, nmi_dr7);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(enum nmi_states, nmi_state);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, nmi_cr2);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, nmi_dr7);
 
 DEFINE_IDTENTRY_RAW(exc_nmi)
 {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f9bd1c3415d4..e4a32490dda0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -56,7 +56,7 @@
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
-__visible DEFINE_PER_CPU_PAGE_ALIGNED(struct tss_struct, cpu_tss_rw) = {
+__visible DEFINE_PER_CPU_PAGE_ALIGNED_ASI_NOT_SENSITIVE(struct tss_struct, cpu_tss_rw) = {
 	.x86_tss = {
 		/*
 		 * .sp0 is only used when entering ring 0 from a lower
@@ -77,7 +77,7 @@ __visible DEFINE_PER_CPU_PAGE_ALIGNED(struct tss_struct, cpu_tss_rw) = {
 };
 EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
 
-DEFINE_PER_CPU(bool, __tss_limit_invalid);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(bool, __tss_limit_invalid);
 EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
 
 void __init arch_task_cache_init(void)
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7b65275544b2..13c94a512b7e 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -23,7 +23,7 @@
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
 
-DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
 #ifdef CONFIG_X86_64
@@ -32,7 +32,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 #define BOOT_PERCPU_OFFSET 0
 #endif
 
-DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 unsigned long __per_cpu_offset[NR_CPUS] __ro_after_init = {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 617012f4619f..0cfc4fdc2476 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2224,7 +2224,8 @@ static void disable_freq_invariance_workfn(struct work_struct *work)
 static DECLARE_WORK(disable_freq_invariance_work,
 		    disable_freq_invariance_workfn);
 
-DEFINE_PER_CPU(unsigned long, arch_freq_scale) = SCHED_CAPACITY_SCALE;
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, arch_freq_scale) =
+                                                        SCHED_CAPACITY_SCALE;
 
 void arch_scale_freq_tick(void)
 {
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d7169da99b01..39c441409dec 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -59,7 +59,7 @@ struct cyc2ns {
 
 }; /* fits one cacheline */
 
-static DEFINE_PER_CPU_ALIGNED(struct cyc2ns, cyc2ns);
+static DEFINE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(struct cyc2ns, cyc2ns);
 
 static int __init tsc_early_khz_setup(char *buf)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0df88eadab60..451872d178e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8523,7 +8523,7 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct kvm_vcpu *, current_vcpu);
 EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
 
 int kvm_is_in_guest(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..3d5da4daaf53 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -392,7 +392,7 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
-DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct kvm_vcpu *, current_vcpu);
 
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index fdc117929fc7..04628949e89d 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -20,7 +20,7 @@
 static struct asi_class asi_class[ASI_MAX_NUM] __asi_not_sensitive;
 static DEFINE_SPINLOCK(asi_class_lock __asi_not_sensitive);
 
-DEFINE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
+DEFINE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(struct asi_state, asi_cpu_state);
 EXPORT_PER_CPU_SYMBOL_GPL(asi_cpu_state);
 
 __aligned(PAGE_SIZE) pgd_t asi_global_nonsensitive_pgd[PTRS_PER_PGD];
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index dfff17363365..012631d03c4f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1025,7 +1025,7 @@ void __init zone_sizes_init(void)
 	free_area_init(max_zone_pfns);
 }
 
-__visible DEFINE_PER_CPU_ALIGNED(struct tlb_state, cpu_tlbstate) = {
+__visible DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct tlb_state, cpu_tlbstate) = {
 	.loaded_mm = &init_mm,
 	.next_asid = 1,
 	.cr4 = ~0UL,	/* fail hard if we screw up cr4 shadow initialization */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index fcd2c8e92f83..36d41356ed04 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -972,7 +972,7 @@ static bool tlb_is_not_lazy(int cpu)
 
 static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
+DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct tlb_state_shared, cpu_tlbstate_shared);
 EXPORT_PER_CPU_SYMBOL(cpu_tlbstate_shared);
 
 STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
diff --git a/include/asm-generic/irq_regs.h b/include/asm-generic/irq_regs.h
index 2e7c6e89d42e..3225bdb2aefa 100644
--- a/include/asm-generic/irq_regs.h
+++ b/include/asm-generic/irq_regs.h
@@ -14,7 +14,7 @@
  * Per-cpu current frame pointer - the location of the last exception frame on
  * the stack
  */
-DECLARE_PER_CPU(struct pt_regs *, __irq_regs);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct pt_regs *, __irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
 {
diff --git a/include/linux/arch_topology.h b/include/linux/arch_topology.h
index b97cea83b25e..35fdf256777a 100644
--- a/include/linux/arch_topology.h
+++ b/include/linux/arch_topology.h
@@ -23,7 +23,7 @@ static inline unsigned long topology_get_cpu_scale(int cpu)
 
 void topology_set_cpu_scale(unsigned int cpu, unsigned long capacity);
 
-DECLARE_PER_CPU(unsigned long, arch_freq_scale);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, arch_freq_scale);
 
 static inline unsigned long topology_get_freq_scale(int cpu)
 {
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0ee140176f10..68b2f10aaa46 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -355,7 +355,7 @@ static inline void timerfd_clock_was_set(void) { }
 static inline void timerfd_resume(void) { }
 #endif
 
-DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct tick_device, tick_cpu_device);
 
 #ifdef CONFIG_PREEMPT_RT
 void hrtimer_cancel_wait_running(const struct hrtimer *timer);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 1f22a30c0963..6ae485d2ebb3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -554,7 +554,7 @@ extern void __raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 
-DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, ksoftirqd);
 
 static inline struct task_struct *this_cpu_ksoftirqd(void)
 {
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 69ae6b278464..89609dc5d30f 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -40,8 +40,8 @@ struct kernel_stat {
 	unsigned int softirqs[NR_SOFTIRQS];
 };
 
-DECLARE_PER_CPU(struct kernel_stat, kstat);
-DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct kernel_stat, kstat);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct kernel_cpustat, kernel_cpustat);
 
 /* Must have preemption disabled for this to be meaningful. */
 #define kstat_this_cpu this_cpu_ptr(&kstat)
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index 056d31317e49..f02392ca6dc2 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -16,7 +16,7 @@ void prandom_bytes(void *buf, size_t nbytes);
 void prandom_seed(u32 seed);
 void prandom_reseed_late(void);
 
-DECLARE_PER_CPU(unsigned long, net_rand_noise);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, net_rand_noise);
 
 #define PRANDOM_ADD_NOISE(a, b, c, d) \
 	prandom_u32_add_noise((unsigned long)(a), (unsigned long)(b), \
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6ea559b6e0f4..1914cc538cab 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1207,7 +1207,7 @@ void perf_pmu_enable(struct pmu *pmu)
 		pmu->pmu_enable(pmu);
 }
 
-static DEFINE_PER_CPU(struct list_head, active_ctx_list);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct list_head, active_ctx_list);
 
 /*
  * perf_event_ctx_activate(), perf_event_ctx_deactivate(), and
@@ -4007,8 +4007,8 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
-static DEFINE_PER_CPU(int, perf_throttled_count);
-static DEFINE_PER_CPU(u64, perf_throttled_seq);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, perf_throttled_count);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(u64, perf_throttled_seq);
 
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bool disable)
 {
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f7df715ec28e..10df3577c733 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -22,9 +22,9 @@
 #include <asm/processor.h>
 #include <linux/kasan.h>
 
-static DEFINE_PER_CPU(struct llist_head, raised_list);
-static DEFINE_PER_CPU(struct llist_head, lazy_list);
-static DEFINE_PER_CPU(struct task_struct *, irq_workd);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct llist_head, raised_list);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct llist_head, lazy_list);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, irq_workd);
 
 static void wake_irq_workd(void)
 {
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 284d2722cf0c..aee2b6994bc2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -74,7 +74,7 @@
 
 /* Data structures. */
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
+static DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct rcu_data, rcu_data) = {
 	.dynticks_nesting = 1,
 	.dynticks_nmi_nesting = DYNTICK_IRQ_NONIDLE,
 	.dynticks = ATOMIC_INIT(1),
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e1c08ff4130e..7c96f0001c7f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -43,7 +43,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(sched_util_est_cfs_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_util_est_se_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct rq, runqueues);
 
 #ifdef CONFIG_SCHED_DEBUG
 /*
@@ -5104,8 +5104,8 @@ void sched_exec(void)
 
 #endif
 
-DEFINE_PER_CPU(struct kernel_stat, kstat);
-DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct kernel_stat, kstat);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct kernel_cpustat, kernel_cpustat);
 
 EXPORT_PER_CPU_SYMBOL(kstat);
 EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
index 7c2fe50fd76d..c55a47f8e963 100644
--- a/kernel/sched/cpufreq.c
+++ b/kernel/sched/cpufreq.c
@@ -9,7 +9,8 @@
 
 #include "sched.h"
 
-DEFINE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct update_util_data __rcu *,
+                                 cpufreq_update_util_data);
 
 /**
  * cpufreq_add_update_util_hook - Populate the CPU's update_util_data pointer.
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 623b5feb142a..d3ad13308889 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -17,7 +17,7 @@
  * task when irq is in progress while we read rq->clock. That is a worthy
  * compromise in place of having locks on each irq in account_system_time.
  */
-DEFINE_PER_CPU(struct irqtime, cpu_irqtime);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct irqtime, cpu_irqtime);
 
 static int __asi_not_sensitive sched_clock_irqtime;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 517c70a29a57..4188c1a570db 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1360,7 +1360,7 @@ static inline void update_idle_core(struct rq *rq)
 static inline void update_idle_core(struct rq *rq) { }
 #endif
 
-DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+DECLARE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		this_cpu_ptr(&runqueues)
@@ -1760,13 +1760,13 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 	return sd;
 }
 
-DECLARE_PER_CPU(struct sched_domain __rcu *, sd_llc);
-DECLARE_PER_CPU(int, sd_llc_size);
-DECLARE_PER_CPU(int, sd_llc_id);
-DECLARE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
-DECLARE_PER_CPU(struct sched_domain __rcu *, sd_numa);
-DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
-DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_llc);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(int, sd_llc_size);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(int, sd_llc_id);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain_shared __rcu *, sd_llc_shared);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_numa);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_asym_packing);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_asym_cpucapacity);
 extern struct static_key_false sched_asym_cpucapacity;
 
 struct sched_group_capacity {
@@ -2753,7 +2753,7 @@ struct irqtime {
 	struct u64_stats_sync	sync;
 };
 
-DECLARE_PER_CPU(struct irqtime, cpu_irqtime);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct irqtime, cpu_irqtime);
 
 /*
  * Returns the irqtime minus the softirq time computed by ksoftirqd.
@@ -2776,7 +2776,8 @@ static inline u64 irq_time_read(int cpu)
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 #ifdef CONFIG_CPU_FREQ
-DECLARE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct update_util_data __rcu *,
+                                  cpufreq_update_util_data);
 
 /**
  * cpufreq_update_util - Take a note about CPU utilization changes.
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index d201a7052a29..1dcea6a6133e 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -641,13 +641,13 @@ static void destroy_sched_domains(struct sched_domain *sd)
  * the cpumask of the domain), this allows us to quickly tell if
  * two CPUs are in the same cache domain, see cpus_share_cache().
  */
-DEFINE_PER_CPU(struct sched_domain __rcu *, sd_llc);
-DEFINE_PER_CPU(int, sd_llc_size);
-DEFINE_PER_CPU(int, sd_llc_id);
-DEFINE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
-DEFINE_PER_CPU(struct sched_domain __rcu *, sd_numa);
-DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
-DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_llc);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, sd_llc_size);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, sd_llc_id);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain_shared __rcu *, sd_llc_shared);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_numa);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_asym_packing);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct sched_domain __rcu *, sd_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_asym_cpucapacity);
 
 static void update_top_cache_domain(int cpu)
diff --git a/kernel/smp.c b/kernel/smp.c
index c51fd981a4a9..3c1b328f0a09 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -92,9 +92,10 @@ struct call_function_data {
 	cpumask_var_t		cpumask_ipi;
 };
 
-static DEFINE_PER_CPU_ALIGNED(struct call_function_data, cfd_data);
+static DEFINE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(struct call_function_data, cfd_data);
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
+static DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(struct llist_head,
+                                                       call_single_queue);
 
 static void flush_smp_call_function_queue(bool warn_cpu_offline);
 
@@ -464,7 +465,7 @@ static __always_inline void csd_unlock(struct __call_single_data *csd)
 	smp_store_release(&csd->node.u_flags, 0);
 }
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(call_single_data_t, csd_data);
+static DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(call_single_data_t, csd_data);
 
 void __smp_call_single_queue(int cpu, struct llist_node *node)
 {
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c462b7fab4d3..d2660a59feab 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -59,7 +59,7 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 static struct softirq_action softirq_vec[NR_SOFTIRQS]
 __asi_not_sensitive ____cacheline_aligned;
 
-DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct task_struct *, ksoftirqd);
 
 const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "IRQ_POLL",
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 8b176f5c01f2..74cfc89a17c4 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -65,7 +65,7 @@
  * to reach a base using a clockid, hrtimer_clockid_to_base()
  * is used to convert from clockid to the proper hrtimer_base_type.
  */
-DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index cbe75661ca74..67180cb44394 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -25,7 +25,7 @@
 /*
  * Tick devices
  */
-DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct tick_device, tick_cpu_device);
 /*
  * Tick next event: keeps track of the tick time. It's updated by the
  * CPU which handles the tick and protected by jiffies_lock. There is
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index ed7e2a18060a..6961318d41b7 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -13,7 +13,7 @@
 # define TICK_DO_TIMER_NONE	-1
 # define TICK_DO_TIMER_BOOT	-2
 
-DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct tick_device, tick_cpu_device);
 extern ktime_t tick_next_period;
 extern int tick_do_timer_cpu;
 
@@ -161,7 +161,7 @@ static inline void timers_update_nohz(void) { }
 #define tick_nohz_active (0)
 #endif
 
-DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
+DECLARE_PER_CPU_ASI_NOT_SENSITIVE(struct hrtimer_cpu_base, hrtimer_bases);
 
 extern u64 get_next_timer_interrupt(unsigned long basej, u64 basem);
 void timer_clear_idle(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c23fecbb68c2..afd393b85577 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -36,7 +36,7 @@
 /*
  * Per-CPU nohz control structure
  */
-static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct tick_sched, tick_cpu_sched);
 
 struct tick_sched *tick_get_tick_sched(int cpu)
 {
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 0b09c99b568c..9567df187420 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -212,7 +212,7 @@ struct timer_base {
 	struct hlist_head	vectors[WHEEL_SIZE];
 } ____cacheline_aligned;
 
-static DEFINE_PER_CPU(struct timer_base, timer_bases[NR_BASES]);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct timer_base, timer_bases[NR_BASES]);
 
 #ifdef CONFIG_NO_HZ_COMMON
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eaec3814c5a4..b82f478caf4e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -106,7 +106,7 @@ dummy_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
  * tracing is active, only save the comm when a trace event
  * occurred.
  */
-static DEFINE_PER_CPU(bool, trace_taskinfo_save);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(bool, trace_taskinfo_save);
 
 /*
  * Kill all tracing for good (never come back).
diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f4938040c228..177de3501677 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 /* Per-cpu variable to prevent redundant calls when IRQs already off */
-static DEFINE_PER_CPU(int, tracing_irq_cpu);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(int, tracing_irq_cpu);
 
 /*
  * Like trace_hardirqs_on() but without the lockdep invocation. This is
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index ad912511a0c0..c2bf55024202 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -174,13 +174,13 @@ static bool softlockup_initialized __read_mostly;
 static u64 __read_mostly sample_period;
 
 /* Timestamp taken after the last successful reschedule. */
-static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, watchdog_touch_ts);
 /* Timestamp of the last softlockup report. */
-static DEFINE_PER_CPU(unsigned long, watchdog_report_ts);
-static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
-static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
-static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, watchdog_report_ts);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(bool, softlockup_touch_sync);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, hrtimer_interrupts);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
 
 static int __init nowatchdog_setup(char *str)
diff --git a/lib/irq_regs.c b/lib/irq_regs.c
index 0d545a93070e..8b3c6be06a7a 100644
--- a/lib/irq_regs.c
+++ b/lib/irq_regs.c
@@ -9,6 +9,6 @@
 #include <asm/irq_regs.h>
 
 #ifndef ARCH_HAS_OWN_IRQ_REGS
-DEFINE_PER_CPU(struct pt_regs *, __irq_regs);
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct pt_regs *, __irq_regs);
 EXPORT_PER_CPU_SYMBOL(__irq_regs);
 #endif
diff --git a/lib/random32.c b/lib/random32.c
index a57a0e18819d..e4c1cb1a70b4 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -339,7 +339,8 @@ struct siprand_state {
 };
 
 static DEFINE_PER_CPU(struct siprand_state, net_rand_state) __latent_entropy;
-DEFINE_PER_CPU(unsigned long, net_rand_noise);
+/* TODO(oweisse): Is this entropy sensitive?? */
+DEFINE_PER_CPU_ASI_NOT_SENSITIVE(unsigned long, net_rand_noise);
 EXPORT_PER_CPU_SYMBOL(net_rand_noise);
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0af973b950c2..8d2d76de5bd0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -110,7 +110,7 @@ static atomic_t hardware_enable_failed;
 static struct kmem_cache *kvm_vcpu_cache;
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
-static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct kvm_vcpu *, kvm_running_vcpu);
 
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
-- 
2.35.1.473.g83b2b277ed-goog

