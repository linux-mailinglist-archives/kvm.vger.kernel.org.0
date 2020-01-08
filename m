Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D351338A4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 02:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgAHBuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 20:50:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40293 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgAHBuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 20:50:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id k25so745749pgt.7;
        Tue, 07 Jan 2020 17:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k/xLHVr+E3Mm0ZHWLILeml/rw0rkew9DOHcx6ajd5sk=;
        b=ZM3lGfmDx3evcWkdgiQL85j5d0lPcXoM1Q6+yAhQO2N2Uamr6u/T72rhsBCuOhlokr
         p66L+m6lonmCQDVQA1uQi12ZbBpMWZjgmeW6liYuCqVyuRp5ueCA/EKfUttJVvwIM/El
         6AqAJa3YmhumJ/hkEld5Y6AIjo3q1GhWHamGKkiA85nh0XPTb87txaxYJj03GrapnoAs
         HpR4AHrljcMRB6AElLeBTnOSsAu/DpvuVFMSQy1UQYTpeNKUfBGdii74qNxwYMi5L+oi
         52QUPUnaC/bOOl3ZZ0xeYnxvCd6hkjo9LzUd9gGBc4BMpeItOGH6GrKY2Sl7enbUm33q
         2n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k/xLHVr+E3Mm0ZHWLILeml/rw0rkew9DOHcx6ajd5sk=;
        b=Pt9JXscrESLyNG51SRACjBOsdo0PthP9F7Ci4APGveBuDv9/Ku0sWAUDZaUyHSmZxz
         sxUGdW6maEMEI1ZU8GLMCAM9woWzPEkC6GOP6QKE3qiexMlWSJYE/P/ylmo3dRsfyl7y
         0IsWwnYPrrZ6yizT+MaLR/lO0u1xBQ2uzJG5747kj6o8UUBOITd7eUvjHlC/mcKLJepd
         YtqwSJGsOWRn/j0FjXUbnqC3n/qxIU+y1mSWIo97frF+0lHujNeynImF0Sgt7cpaCA8E
         kZbY6GRt+WhTLFZeQ6jA5SzgMQOr7TluopahDwlQvyRoDdmmCnNJ9IR+tWh7pF6HfV+X
         d5QA==
X-Gm-Message-State: APjAAAXlkGTohXyztmD2D+bdq8bQjhOYNtezIDd9jFD+MUuUs69yX6LA
        Pnk81atwhvHsr11MpyR/JwOKjTVo
X-Google-Smtp-Source: APXvYqzhfG7ey2jgclGz8NpZCi23qZJLxeejPX1VOBywZUKXya5K8TE0j4F9XRbtYzi3xMa22VorQg==
X-Received: by 2002:a62:7883:: with SMTP id t125mr2520413pfc.141.1578448222147;
        Tue, 07 Jan 2020 17:50:22 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w8sm825747pfn.186.2020.01.07.17.50.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Jan 2020 17:50:21 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH RFC] sched/fair: Penalty the cfs task which executes mwait/hlt
Date:   Wed,  8 Jan 2020 09:50:01 +0800
Message-Id: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

To deliver all of the resources of a server to instances in cloud, there are no 
housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools 
etc which can't be offloaded to other hardware like smart nic, these stuff will 
contend with vCPUs even if MWAIT/HLT instructions executed in the guest.

The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
the top command on host still observe 100% cpu utilization since qemu process is 
running even though guest who has the power management capability executes mwait. 
Actually we can observe the physical cpu has already enter deeper cstate by 
powertop on host.

For virtualization, there is a HLT activity state in CPU VMCS field which indicates 
the logical processor is inactive because it executed the HLT instruction, but 
SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical 
processor into an inactive state, however, this VMCS field never reflects this 
state.

This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
instructions executed, because it can worse the message-passing workloads which 
will switch between idle and running frequently in the guest. Lets penalty the 
vCPU which is long idle through tick-based sampling and preemption.

Bind unixbench to one idle pCPU:
Dhrystone 2 using register variables            26445969.1  (base)

Bind unixbench and one vCPU which is idle to one pCPU:

Before patch:

Dhrystone 2 using register variables            21248475.1  (80% of base)

After patch:

Dhrystone 2 using register variables            24839863.6  (94% of base)

[1] https://lists.gnu.org/archive/html/qemu-devel/2018-06/msg06794.html
[2] https://lkml.org/lkml/2018/3/12/359

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: KarimAllah <karahmed@amazon.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/smp.h      |  1 +
 arch/x86/include/asm/topology.h |  7 ++++++
 arch/x86/kernel/smpboot.c       | 53 ++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c             |  1 +
 kernel/sched/fair.c             | 10 +++++++-
 kernel/sched/features.h         |  5 ++++
 kernel/sched/sched.h            |  7 ++++++
 7 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index e15f364..61e5b9b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -28,6 +28,7 @@
 DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
 DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
+DECLARE_PER_CPU(bool, cpu_is_idle);
 
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4b14d23..13e2ffc 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -193,4 +193,11 @@ static inline void sched_clear_itmt_support(void)
 }
 #endif /* CONFIG_SCHED_MC_PRIO */
 
+#ifdef CONFIG_SMP
+#include <asm/cpufeature.h>
+
+#define arch_scale_freq_tick arch_scale_freq_tick
+extern void arch_scale_freq_tick(void);
+#endif
+
 #endif /* _ASM_X86_TOPOLOGY_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 69881b2..390534e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -99,6 +99,9 @@
 DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+DEFINE_PER_CPU(bool, cpu_is_idle);
+EXPORT_PER_CPU_SYMBOL(cpu_is_idle);
+
 /* Logical package management. We might want to allocate that dynamically */
 unsigned int __max_logical_packages __read_mostly;
 EXPORT_SYMBOL(__max_logical_packages);
@@ -147,6 +150,8 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	*((volatile u32 *)phys_to_virt(TRAMPOLINE_PHYS_LOW)) = 0;
 }
 
+static void set_cpu_sample(void);
+
 /*
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.
@@ -183,6 +188,8 @@ static void smp_callin(void)
 	 */
 	set_cpu_sibling_map(raw_smp_processor_id());
 
+	set_cpu_sample();
+
 	/*
 	 * Get our bogomips.
 	 * Update loops_per_jiffy in cpu_data. Previous call to
@@ -1337,7 +1344,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	set_sched_topology(x86_topology);
 
 	set_cpu_sibling_map(0);
-
+	set_cpu_sample();
 	smp_sanity_check();
 
 	switch (apic_intr_mode) {
@@ -1764,3 +1771,47 @@ void native_play_dead(void)
 }
 
 #endif
+
+static DEFINE_PER_CPU(u64, arch_prev_tsc);
+static DEFINE_PER_CPU(u64, arch_prev_mperf);
+
+#include <asm/cpu_device_id.h>
+#include <asm/intel-family.h>
+
+#define ICPU(model) \
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_APERFMPERF, 0}
+
+static void set_cpu_sample(void)
+{
+	u64 mperf;
+
+	if (!boot_cpu_has(X86_FEATURE_APERFMPERF))
+		return;
+
+	rdmsrl(MSR_IA32_MPERF, mperf);
+
+	this_cpu_write(arch_prev_tsc, rdtsc());
+	this_cpu_write(arch_prev_mperf, mperf);
+	this_cpu_write(cpu_is_idle, true);
+}
+
+void arch_scale_freq_tick(void)
+{
+	u64 mperf;
+	u64 mcnt, tsc;
+	int result;
+
+	if (!static_cpu_has(X86_FEATURE_APERFMPERF))
+		return;
+
+	rdmsrl(MSR_IA32_MPERF, mperf);
+
+	mcnt = mperf - this_cpu_read(arch_prev_mperf);
+	tsc = rdtsc() - this_cpu_read(arch_prev_tsc);
+	if (!mcnt)
+		return;
+
+	this_cpu_write(arch_prev_tsc, rdtsc());
+	this_cpu_write(arch_prev_mperf, mperf);
+	this_cpu_write(cpu_is_idle, (mcnt * 100 / tsc) == 0);
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dd05a37..e41ad01 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3593,6 +3593,7 @@ void scheduler_tick(void)
 	struct task_struct *curr = rq->curr;
 	struct rq_flags rf;
 
+	arch_scale_freq_tick();
 	sched_clock_tick();
 
 	rq_lock(rq, &rf);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 83ab35e..5ff7431 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4118,10 +4118,18 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	unsigned long ideal_runtime, delta_exec;
 	struct sched_entity *se;
 	s64 delta;
+	bool resched = false;
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime) {
+
+	if (sched_feat(IDLE_PENALTY) && this_cpu_read(cpu_is_idle) &&
+		(ideal_runtime > delta_exec)) {
+		curr->vruntime += calc_delta_fair(ideal_runtime - delta_exec, curr);
+		update_min_vruntime(cfs_rq);
+		resched = true;
+	}
+	if (delta_exec > ideal_runtime || resched) {
 		resched_curr(rq_of(cfs_rq));
 		/*
 		 * The current task ran long enough, ensure it doesn't get
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 2410db5..bacf59d 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -13,6 +13,11 @@
 SCHED_FEAT(START_DEBIT, true)
 
 /*
+ * Penalty the cfs task which executes mwait/hlt
+ */
+SCHED_FEAT(IDLE_PENALTY, true)
+
+/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0db2c1b..0fe4f2d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1953,6 +1953,13 @@ static inline int hrtick_enabled(struct rq *rq)
 
 #endif /* CONFIG_SCHED_HRTICK */
 
+#ifndef arch_scale_freq_tick
+static __always_inline
+void arch_scale_freq_tick(void)
+{
+}
+#endif
+
 #ifndef arch_scale_freq_capacity
 static __always_inline
 unsigned long arch_scale_freq_capacity(int cpu)
-- 
1.8.3.1

