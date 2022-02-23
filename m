Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA34C0C17
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbiBWF1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbiBWF1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:17 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFFC6CA68
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d6baed6aafso144152337b3.3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fjoegs+Ro+S0LiOfkKDHuccTriIwowqx+uIdOr3iex0=;
        b=EbHx41T8pBJ5A2BSG8qjfuD65qMmT14wI+rGz7MtVYSyZZTtXAQ9SSi490wWxvTCX3
         lF1yqHJ25Ogc1hfXuKo9v+hg5YjvOasU7cMgAwTxB6T3rHmXhsMhhA64NTfNq1j1V9t4
         TXGaFy+GztCl/Zph97U1y4UYZaT827j5iNNm3e+F0mQoJhUP0sknSp9qrgRx9gx8cRMf
         Kb0JwVGCNa+GNMz65PcJow71XH07p87xccnzELq309vUDOD82kYnpx/YluPwYOrivr7t
         AT7gGVWsZa9CQMSKMpbyZuKYicDY2/ciGXtsoA+y078oLzomCpgRmU1bPsX32QTmpazD
         udew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fjoegs+Ro+S0LiOfkKDHuccTriIwowqx+uIdOr3iex0=;
        b=vXCQPo6FS6lhhqQYMAbyGGxAteDcJltk8f+r5WvP0cq7Jenixt1EiHWMtb7Gjno93J
         Tl8W8onOMaFOVKEuD+x6jeTf8motbJqYYmkjpAfoxKG/WaiuCclA8HZ2sFKxwuygEo/J
         R3x7XdZs9SFe6R/BGC/cZfF/OdCFSMZZhbT3T25WpK6NvsuNH+VMFRTT3y7bK1lgfRwb
         Q2ezU/TRplj4plMUYl/7tLniIjP0qJpOdyP8YZn7pwnzEN2LEJ0Do0p32+6k/Rmf/00m
         7i0jWZl5SDzXSKmSQqj/NOeK/sexmInwTAV6c9IGn4wt8WeUwW62nkZv2QAeU1pvICXu
         WVMg==
X-Gm-Message-State: AOAM532eBg93CGDfCbwRuH1fcoGmxZQbOTfyUYDBY+BH2WJqaP0wPpBC
        iYXerg9zu8eg0IS/doCSHzxNYvhS0bez
X-Google-Smtp-Source: ABdhPJyEpvnRe67yGfdP/oVogGTIG0cZjG1Fj1fU4LBOman77N8SUGlY7TMto2pQXc1VwXiknsbYEeXFLlaJ
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a5b:cc8:0:b0:622:e87:2087 with SMTP id
 e8-20020a5b0cc8000000b006220e872087mr26256339ybr.106.1645593916871; Tue, 22
 Feb 2022 21:25:16 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:17 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-42-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 41/47] mm: asi: Annotation of static variables to be nonsensitive
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
data access. This commit marks certain static variables as not
sensitive.

Some static variables are accessed frequently and therefore would cause
many ASI exits. The frequency of these accesses is monitored by tracing
asi_exits and analyzing the accessed addresses. Many of these variables
don't contain sensitive information and can therefore be mapped into the
global ASI region. This commit applies the __asi_not_sensitive*
attributes to these frequenmtly-accessed yet not sensitive variables.
The end result is a very significant reduction in ASI exits on real
benchmarks.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/events/core.c            |  4 ++--
 arch/x86/events/intel/core.c      |  2 +-
 arch/x86/events/msr.c             |  2 +-
 arch/x86/events/perf_event.h      |  2 +-
 arch/x86/include/asm/kvm_host.h   |  4 ++--
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/bugs.c        |  2 +-
 arch/x86/kernel/setup.c           |  4 ++--
 arch/x86/kernel/smp.c             |  2 +-
 arch/x86/kernel/tsc.c             |  8 +++----
 arch/x86/kvm/lapic.c              |  2 +-
 arch/x86/kvm/mmu/spte.c           |  2 +-
 arch/x86/kvm/mmu/spte.h           |  2 +-
 arch/x86/kvm/mtrr.c               |  2 +-
 arch/x86/kvm/vmx/capabilities.h   | 14 ++++++------
 arch/x86/kvm/vmx/vmx.c            | 37 ++++++++++++++++---------------
 arch/x86/kvm/x86.c                | 35 +++++++++++++++--------------
 arch/x86/mm/asi.c                 |  4 ++--
 include/linux/debug_locks.h       |  4 ++--
 include/linux/jiffies.h           |  4 ++--
 include/linux/notifier.h          |  2 +-
 include/linux/profile.h           |  2 +-
 include/linux/rcupdate.h          |  4 +++-
 include/linux/rcutree.h           |  2 +-
 include/linux/sched/sysctl.h      |  1 +
 init/main.c                       |  2 +-
 kernel/cgroup/cgroup.c            |  5 +++--
 kernel/cpu.c                      | 14 ++++++------
 kernel/events/core.c              |  4 ++--
 kernel/freezer.c                  |  2 +-
 kernel/locking/lockdep.c          | 14 ++++++------
 kernel/panic.c                    |  2 +-
 kernel/printk/printk.c            |  4 ++--
 kernel/profile.c                  |  4 ++--
 kernel/rcu/tree.c                 | 10 ++++-----
 kernel/rcu/update.c               |  4 ++--
 kernel/sched/clock.c              |  2 +-
 kernel/sched/core.c               |  6 ++---
 kernel/sched/cpuacct.c            |  2 +-
 kernel/sched/cputime.c            |  2 +-
 kernel/sched/fair.c               |  4 ++--
 kernel/sched/loadavg.c            |  2 +-
 kernel/sched/rt.c                 |  2 +-
 kernel/sched/sched.h              |  4 ++--
 kernel/smp.c                      |  2 +-
 kernel/softirq.c                  |  3 ++-
 kernel/time/hrtimer.c             |  2 +-
 kernel/time/jiffies.c             |  8 ++++++-
 kernel/time/ntp.c                 | 30 ++++++++++++-------------
 kernel/time/tick-common.c         |  4 ++--
 kernel/time/tick-internal.h       |  2 +-
 kernel/time/tick-sched.c          |  2 +-
 kernel/time/timekeeping.c         | 10 ++++-----
 kernel/time/timekeeping.h         |  2 +-
 kernel/time/timer.c               |  2 +-
 kernel/trace/trace.c              |  2 +-
 kernel/trace/trace_sched_switch.c |  4 ++--
 lib/debug_locks.c                 |  5 +++--
 mm/memory.c                       |  2 +-
 mm/page_alloc.c                   |  2 +-
 mm/sparse.c                       |  4 ++--
 virt/kvm/kvm_main.c               |  2 +-
 62 files changed, 170 insertions(+), 156 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 38b2c779146f..db825bf053fd 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -44,7 +44,7 @@
 
 #include "perf_event.h"
 
-struct x86_pmu x86_pmu __read_mostly;
+struct x86_pmu x86_pmu __asi_not_sensitive_readmostly;
 static struct pmu pmu;
 
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
@@ -2685,7 +2685,7 @@ static int x86_pmu_filter_match(struct perf_event *event)
 	return 1;
 }
 
-static struct pmu pmu = {
+static struct pmu pmu __asi_not_sensitive = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ec6444f2c9dc..5b2b7473b2f2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -189,7 +189,7 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
 	EVENT_CONSTRAINT_END
 };
 
-static struct event_constraint intel_skl_event_constraints[] = {
+static struct event_constraint intel_skl_event_constraints[] __asi_not_sensitive = {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0),	/* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1),	/* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2),	/* CPU_CLK_UNHALTED.REF */
diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 96c775abe31f..db7bca37c726 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -280,7 +280,7 @@ static int msr_event_add(struct perf_event *event, int flags)
 	return 0;
 }
 
-static struct pmu pmu_msr = {
+static struct pmu pmu_msr  __asi_not_sensitive = {
 	.task_ctx_nr	= perf_sw_context,
 	.attr_groups	= attr_groups,
 	.event_init	= msr_event_init,
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 5480db242083..27cca7fd6f17 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1020,7 +1020,7 @@ static struct perf_pmu_format_hybrid_attr format_attr_hybrid_##_name = {\
 }
 
 struct pmu *x86_get_pmu(unsigned int cpu);
-extern struct x86_pmu x86_pmu __read_mostly;
+extern struct x86_pmu x86_pmu __asi_not_sensitive_readmostly;
 
 static __always_inline struct x86_perf_task_context_opt *task_context_opt(void *ctx)
 {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8ba88bbcf895..b7292c4fece7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1542,8 +1542,8 @@ struct kvm_arch_async_pf {
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
-extern bool __read_mostly allow_smaller_maxphyaddr;
-extern bool __read_mostly enable_apicv;
+extern bool __asi_not_sensitive_readmostly allow_smaller_maxphyaddr;
+extern bool __asi_not_sensitive_readmostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 23fb4d51a5da..9836ebe953ed 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -31,7 +31,7 @@
 #include <asm/paravirt.h>
 #include <asm/asm-prototypes.h>
 
-int __read_mostly alternatives_patched;
+int __asi_not_sensitive alternatives_patched;
 
 EXPORT_SYMBOL_GPL(alternatives_patched);
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1c1f218a701d..6b5e6574e391 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -46,7 +46,7 @@ static void __init srbds_select_mitigation(void);
 static void __init l1d_flush_select_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR that always has to be preserved. */
-u64 x86_spec_ctrl_base;
+u64 x86_spec_ctrl_base __asi_not_sensitive;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e04f5e6eb33f..d8461ac88b36 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -116,7 +116,7 @@ static struct resource bss_resource = {
 struct cpuinfo_x86 new_cpu_data;
 
 /* Common CPU data for all CPUs */
-struct cpuinfo_x86 boot_cpu_data __read_mostly;
+struct cpuinfo_x86 boot_cpu_data __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(boot_cpu_data);
 
 unsigned int def_to_bigsmp;
@@ -133,7 +133,7 @@ struct ist_info ist_info;
 #endif
 
 #else
-struct cpuinfo_x86 boot_cpu_data __read_mostly;
+struct cpuinfo_x86 boot_cpu_data __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(boot_cpu_data);
 #endif
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 06db901fabe8..e9e10ffc2ec2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -257,7 +257,7 @@ static int __init nonmi_ipi_setup(char *str)
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
 
-struct smp_ops smp_ops = {
+struct smp_ops smp_ops __asi_not_sensitive = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
 	.smp_cpus_done		= native_smp_cpus_done,
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a698196377be..d7169da99b01 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -30,10 +30,10 @@
 #include <asm/i8259.h>
 #include <asm/uv/uv.h>
 
-unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
+unsigned int __asi_not_sensitive_readmostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
 
-unsigned int __read_mostly tsc_khz;
+unsigned int __asi_not_sensitive_readmostly tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
 #define KHZ	1000
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(tsc_khz);
 /*
  * TSC can be unstable due to cpufreq or due to unsynced TSCs
  */
-static int __read_mostly tsc_unstable;
+static int __asi_not_sensitive_readmostly tsc_unstable;
 static unsigned int __initdata tsc_early_khz;
 
 static DEFINE_STATIC_KEY_FALSE(__use_tsc);
@@ -1146,7 +1146,7 @@ static struct clocksource clocksource_tsc_early = {
  * this one will immediately take over. We will only register if TSC has
  * been found good.
  */
-static struct clocksource clocksource_tsc = {
+static struct clocksource clocksource_tsc __asi_not_sensitive = {
 	.name			= "tsc",
 	.rating			= 300,
 	.read			= read_tsc,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc35deff..213bbdfab49e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -60,7 +60,7 @@
 #define MAX_APIC_VECTOR			256
 #define APIC_VECTORS_PER_REG		32
 
-static bool lapic_timer_advance_dynamic __read_mostly;
+static bool lapic_timer_advance_dynamic __asi_not_sensitive_readmostly;
 #define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
 #define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
 #define LAPIC_TIMER_ADVANCE_NS_INIT	1000
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0c76c45fdb68..13038fae5088 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -33,7 +33,7 @@ u64 __read_mostly shadow_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_mask;
-u64 __read_mostly shadow_acc_track_mask;
+u64 __asi_not_sensitive_readmostly shadow_acc_track_mask;
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cc432f9a966b..d1af03f63009 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -151,7 +151,7 @@ extern u64 __read_mostly shadow_me_mask;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
  * pages.
  */
-extern u64 __read_mostly shadow_acc_track_mask;
+extern u64 __asi_not_sensitive_readmostly shadow_acc_track_mask;
 
 /*
  * This mask must be set on all non-zero Non-Present or Reserved SPTEs in order
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index a8502e02f479..66228abfa9fa 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -138,7 +138,7 @@ struct fixed_mtrr_segment {
 	int range_start;
 };
 
-static struct fixed_mtrr_segment fixed_seg_table[] = {
+static struct fixed_mtrr_segment fixed_seg_table[] __asi_not_sensitive = {
 	/* MSR_MTRRfix64K_00000, 1 unit. 64K fixed mtrr. */
 	{
 		.start = 0x0,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4705ad55abb5..0ab03ec7d6d0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -6,13 +6,13 @@
 
 #include "lapic.h"
 
-extern bool __read_mostly enable_vpid;
-extern bool __read_mostly flexpriority_enabled;
-extern bool __read_mostly enable_ept;
-extern bool __read_mostly enable_unrestricted_guest;
-extern bool __read_mostly enable_ept_ad_bits;
-extern bool __read_mostly enable_pml;
-extern int __read_mostly pt_mode;
+extern bool __asi_not_sensitive_readmostly enable_vpid;
+extern bool __asi_not_sensitive_readmostly flexpriority_enabled;
+extern bool __asi_not_sensitive_readmostly enable_ept;
+extern bool __asi_not_sensitive_readmostly enable_unrestricted_guest;
+extern bool __asi_not_sensitive_readmostly enable_ept_ad_bits;
+extern bool __asi_not_sensitive_readmostly enable_pml;
+extern int __asi_not_sensitive_readmostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
 #define PT_MODE_HOST_GUEST	1
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6549fef39f2b..e1ad82c25a78 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -78,29 +78,29 @@ static const struct x86_cpu_id vmx_cpu_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, vmx_cpu_id);
 #endif
 
-bool __read_mostly enable_vpid = 1;
+bool __asi_not_sensitive_readmostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
-static bool __read_mostly enable_vnmi = 1;
+static bool __asi_not_sensitive_readmostly enable_vnmi = 1;
 module_param_named(vnmi, enable_vnmi, bool, S_IRUGO);
 
-bool __read_mostly flexpriority_enabled = 1;
+bool __asi_not_sensitive_readmostly flexpriority_enabled = 1;
 module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 
-bool __read_mostly enable_ept = 1;
+bool __asi_not_sensitive_readmostly enable_ept = 1;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
 
-bool __read_mostly enable_unrestricted_guest = 1;
+bool __asi_not_sensitive_readmostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
 
-bool __read_mostly enable_ept_ad_bits = 1;
+bool __asi_not_sensitive_readmostly enable_ept_ad_bits = 1;
 module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
 
-static bool __read_mostly emulate_invalid_guest_state = true;
+static bool __asi_not_sensitive_readmostly emulate_invalid_guest_state = true;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
-static bool __read_mostly fasteoi = 1;
+static bool __asi_not_sensitive_readmostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
 module_param(enable_apicv, bool, S_IRUGO);
@@ -110,13 +110,13 @@ module_param(enable_apicv, bool, S_IRUGO);
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
  * use VMX instructions.
  */
-static bool __read_mostly nested = 1;
+static bool __asi_not_sensitive_readmostly nested = 1;
 module_param(nested, bool, S_IRUGO);
 
-bool __read_mostly enable_pml = 1;
+bool __asi_not_sensitive_readmostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
-static bool __read_mostly dump_invalid_vmcs = 0;
+static bool __asi_not_sensitive_readmostly dump_invalid_vmcs = 0;
 module_param(dump_invalid_vmcs, bool, 0644);
 
 #define MSR_BITMAP_MODE_X2APIC		1
@@ -125,13 +125,13 @@ module_param(dump_invalid_vmcs, bool, 0644);
 #define KVM_VMX_TSC_MULTIPLIER_MAX     0xffffffffffffffffULL
 
 /* Guest_tsc -> host_tsc conversion requires 64-bit division.  */
-static int __read_mostly cpu_preemption_timer_multi;
-static bool __read_mostly enable_preemption_timer = 1;
+static int __asi_not_sensitive_readmostly cpu_preemption_timer_multi;
+static bool __asi_not_sensitive_readmostly enable_preemption_timer = 1;
 #ifdef CONFIG_X86_64
 module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #endif
 
-extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __asi_not_sensitive_readmostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
@@ -202,7 +202,7 @@ static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 module_param(ple_window_max, uint, 0444);
 
 /* Default is SYSTEM mode, 1 for host-guest mode */
-int __read_mostly pt_mode = PT_MODE_SYSTEM;
+int __asi_not_sensitive_readmostly pt_mode = PT_MODE_SYSTEM;
 module_param(pt_mode, int, S_IRUGO);
 
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
@@ -421,7 +421,7 @@ static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-struct vmcs_config vmcs_config;
+struct vmcs_config vmcs_config __asi_not_sensitive;
 struct vmx_capability vmx_capability;
 
 #define VMX_SEGMENT_FIELD(seg)					\
@@ -453,7 +453,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
-static unsigned long host_idt_base;
+static unsigned long host_idt_base __asi_not_sensitive;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
@@ -5549,7 +5549,8 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
  * to be done to userspace and return 0.
  */
-static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
+static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) __asi_not_sensitive
+= {
 	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception_nmi,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
 	[EXIT_REASON_TRIPLE_FAULT]            = handle_triple_fault,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0df14deae80..0df88eadab60 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -123,7 +123,7 @@ static int sync_regs(struct kvm_vcpu *vcpu);
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
-struct kvm_x86_ops kvm_x86_ops __read_mostly;
+struct kvm_x86_ops kvm_x86_ops __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
 #define KVM_X86_OP(func)					     \
@@ -148,17 +148,17 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
 static bool __read_mostly kvmclock_periodic_sync = true;
 module_param(kvmclock_periodic_sync, bool, S_IRUGO);
 
-bool __read_mostly kvm_has_tsc_control;
+bool __asi_not_sensitive_readmostly kvm_has_tsc_control;
 EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
-u32  __read_mostly kvm_max_guest_tsc_khz;
+u32  __asi_not_sensitive_readmostly kvm_max_guest_tsc_khz;
 EXPORT_SYMBOL_GPL(kvm_max_guest_tsc_khz);
-u8   __read_mostly kvm_tsc_scaling_ratio_frac_bits;
+u8   __asi_not_sensitive_readmostly kvm_tsc_scaling_ratio_frac_bits;
 EXPORT_SYMBOL_GPL(kvm_tsc_scaling_ratio_frac_bits);
-u64  __read_mostly kvm_max_tsc_scaling_ratio;
+u64  __asi_not_sensitive_readmostly kvm_max_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_max_tsc_scaling_ratio);
-u64 __read_mostly kvm_default_tsc_scaling_ratio;
+u64 __asi_not_sensitive_readmostly kvm_default_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
-bool __read_mostly kvm_has_bus_lock_exit;
+bool __asi_not_sensitive_readmostly kvm_has_bus_lock_exit;
 EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
 
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
@@ -171,20 +171,20 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * advancement entirely.  Any other value is used as-is and disables adaptive
  * tuning, i.e. allows privileged userspace to set an exact advancement time.
  */
-static int __read_mostly lapic_timer_advance_ns = -1;
+static int __asi_not_sensitive_readmostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
-static bool __read_mostly vector_hashing = true;
+static bool __asi_not_sensitive_readmostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
 
-bool __read_mostly enable_vmware_backdoor = false;
+bool __asi_not_sensitive_readmostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 
-static bool __read_mostly force_emulation_prefix = false;
+static bool __asi_not_sensitive_readmostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
-int __read_mostly pi_inject_timer = -1;
+int __asi_not_sensitive_readmostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
 /*
@@ -216,13 +216,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
-bool __read_mostly allow_smaller_maxphyaddr = 0;
+bool __asi_not_sensitive_readmostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
-bool __read_mostly enable_apicv = true;
+bool __asi_not_sensitive_readmostly enable_apicv = true;
 EXPORT_SYMBOL_GPL(enable_apicv);
 
-u64 __read_mostly host_xss;
+/* TODO(oweisse): how dangerous is this variable, from a security standpoint? */
+u64 __asi_not_sensitive_readmostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
 EXPORT_SYMBOL_GPL(supported_xss);
@@ -292,7 +293,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-u64 __read_mostly host_xcr0;
+u64 __asi_not_sensitive_readmostly host_xcr0;
 u64 __read_mostly supported_xcr0;
 EXPORT_SYMBOL_GPL(supported_xcr0);
 
@@ -2077,7 +2078,7 @@ struct pvclock_gtod_data {
 	u64		wall_time_sec;
 };
 
-static struct pvclock_gtod_data pvclock_gtod_data;
+static struct pvclock_gtod_data pvclock_gtod_data __asi_not_sensitive;
 
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index ba373b461855..fdc117929fc7 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -17,8 +17,8 @@
 #undef pr_fmt
 #define pr_fmt(fmt)     "ASI: " fmt
 
-static struct asi_class asi_class[ASI_MAX_NUM];
-static DEFINE_SPINLOCK(asi_class_lock);
+static struct asi_class asi_class[ASI_MAX_NUM] __asi_not_sensitive;
+static DEFINE_SPINLOCK(asi_class_lock __asi_not_sensitive);
 
 DEFINE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
 EXPORT_PER_CPU_SYMBOL_GPL(asi_cpu_state);
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index dbb409d77d4f..7bd0c3dd6d47 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -7,8 +7,8 @@
 
 struct task_struct;
 
-extern int debug_locks __read_mostly;
-extern int debug_locks_silent __read_mostly;
+extern int debug_locks;
+extern int debug_locks_silent;
 
 
 static __always_inline int __debug_locks_off(void)
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 5e13f801c902..deccab0dcb4a 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -76,8 +76,8 @@ extern int register_refined_jiffies(long clock_tick_rate);
  * without sampling the sequence number in jiffies_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
-extern u64 __cacheline_aligned_in_smp jiffies_64;
-extern unsigned long volatile __cacheline_aligned_in_smp __jiffy_arch_data jiffies;
+extern u64 jiffies_64;
+extern unsigned long volatile __jiffy_arch_data jiffies;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void);
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 87069b8459af..a27b193b8e60 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -117,7 +117,7 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
 	struct blocking_notifier_head name =			\
 		BLOCKING_NOTIFIER_INIT(name)
 #define RAW_NOTIFIER_HEAD(name)					\
-	struct raw_notifier_head name =				\
+	struct raw_notifier_head name __asi_not_sensitive =	\
 		RAW_NOTIFIER_INIT(name)
 
 #ifdef CONFIG_TREE_SRCU
diff --git a/include/linux/profile.h b/include/linux/profile.h
index fd18ca96f557..4988b6d05d4c 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -38,7 +38,7 @@ enum profile_type {
 
 #ifdef CONFIG_PROFILING
 
-extern int prof_on __read_mostly;
+extern int prof_on;
 
 /* init basic kernel profiler */
 int profile_init(void);
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5e0beb5c5659..34f5073c88a2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -84,7 +84,7 @@ static inline int rcu_preempt_depth(void)
 
 /* Internal to kernel */
 void rcu_init(void);
-extern int rcu_scheduler_active __read_mostly;
+extern int rcu_scheduler_active;
 void rcu_sched_clock_irq(int user);
 void rcu_report_dead(unsigned int cpu);
 void rcutree_migrate_callbacks(int cpu);
@@ -308,6 +308,8 @@ static inline int rcu_read_lock_any_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+/* TODO: ASI - (oweisse) we might want to switch ".data.unlikely" to some other
+ * section that will be mapped to ASI. */
 /**
  * RCU_LOCKDEP_WARN - emit lockdep splat if specified condition is met
  * @c: condition to check
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 53209d669400..76665db179fa 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -62,7 +62,7 @@ static inline void rcu_irq_exit_check_preempt(void) { }
 void exit_rcu(void);
 
 void rcu_scheduler_starting(void);
-extern int rcu_scheduler_active __read_mostly;
+extern int rcu_scheduler_active;
 void rcu_end_inkernel_boot(void);
 bool rcu_inkernel_boot_has_ended(void);
 bool rcu_is_watching(void);
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 304f431178fd..1529e3835939 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -3,6 +3,7 @@
 #define _LINUX_SCHED_SYSCTL_H
 
 #include <linux/types.h>
+#include <asm/asi.h>
 
 struct ctl_table;
 
diff --git a/init/main.c b/init/main.c
index bb984ed79de0..ce87fac83aed 100644
--- a/init/main.c
+++ b/init/main.c
@@ -123,7 +123,7 @@ extern void radix_tree_init(void);
  * operations which are not allowed with IRQ disabled are allowed while the
  * flag is set.
  */
-bool early_boot_irqs_disabled __read_mostly;
+bool early_boot_irqs_disabled __asi_not_sensitive;
 
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cafb8c114a21..729495e17363 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -162,7 +162,8 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
 static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);
 
 /* the default hierarchy */
-struct cgroup_root cgrp_dfl_root = { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
+struct cgroup_root cgrp_dfl_root __asi_not_sensitive =
+        { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
 EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 
 /*
@@ -755,7 +756,7 @@ EXPORT_SYMBOL_GPL(of_css);
  * reference-counted, to improve performance when child cgroups
  * haven't been created.
  */
-struct css_set init_css_set = {
+struct css_set init_css_set __asi_not_sensitive  = {
 	.refcount		= REFCOUNT_INIT(1),
 	.dom_cset		= &init_css_set,
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 407a2568f35e..59530bd5da39 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2581,26 +2581,26 @@ const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
 EXPORT_SYMBOL(cpu_all_bits);
 
 #ifdef CONFIG_INIT_ALL_POSSIBLE
-struct cpumask __cpu_possible_mask __read_mostly
+struct cpumask __cpu_possible_mask __asi_not_sensitive_readmostly
 	= {CPU_BITS_ALL};
 #else
-struct cpumask __cpu_possible_mask __read_mostly;
+struct cpumask __cpu_possible_mask __asi_not_sensitive_readmostly;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
 
-struct cpumask __cpu_online_mask __read_mostly;
+struct cpumask __cpu_online_mask __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(__cpu_online_mask);
 
-struct cpumask __cpu_present_mask __read_mostly;
+struct cpumask __cpu_present_mask __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(__cpu_present_mask);
 
-struct cpumask __cpu_active_mask __read_mostly;
+struct cpumask __cpu_active_mask __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(__cpu_active_mask);
 
-struct cpumask __cpu_dying_mask __read_mostly;
+struct cpumask __cpu_dying_mask __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(__cpu_dying_mask);
 
-atomic_t __num_online_cpus __read_mostly;
+atomic_t __num_online_cpus __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL(__num_online_cpus);
 
 void init_cpu_present(const struct cpumask *src)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 30d94f68c5bd..6ea559b6e0f4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9651,7 +9651,7 @@ static int perf_swevent_init(struct perf_event *event)
 	return 0;
 }
 
-static struct pmu perf_swevent = {
+static struct pmu perf_swevent __asi_not_sensitive = {
 	.task_ctx_nr	= perf_sw_context,
 
 	.capabilities	= PERF_PMU_CAP_NO_NMI,
@@ -9800,7 +9800,7 @@ static int perf_tp_event_init(struct perf_event *event)
 	return 0;
 }
 
-static struct pmu perf_tracepoint = {
+static struct pmu perf_tracepoint __asi_not_sensitive = {
 	.task_ctx_nr	= perf_sw_context,
 
 	.event_init	= perf_tp_event_init,
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 45ab36ffd0e7..6ca163e4880b 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -13,7 +13,7 @@
 #include <linux/kthread.h>
 
 /* total number of freezing conditions in effect */
-atomic_t system_freezing_cnt = ATOMIC_INIT(0);
+atomic_t __asi_not_sensitive system_freezing_cnt = ATOMIC_INIT(0);
 EXPORT_SYMBOL(system_freezing_cnt);
 
 /* indicate whether PM freezing is in effect, protected by
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2270ec68f10a..1b8f51a37883 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -64,7 +64,7 @@
 #include <trace/events/lock.h>
 
 #ifdef CONFIG_PROVE_LOCKING
-int prove_locking = 1;
+int prove_locking __asi_not_sensitive = 1;
 module_param(prove_locking, int, 0644);
 #else
 #define prove_locking 0
@@ -186,8 +186,8 @@ unsigned long nr_zapped_classes;
 #ifndef CONFIG_DEBUG_LOCKDEP
 static
 #endif
-struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
-static DECLARE_BITMAP(lock_classes_in_use, MAX_LOCKDEP_KEYS);
+struct lock_class lock_classes[MAX_LOCKDEP_KEYS] __asi_not_sensitive;
+static DECLARE_BITMAP(lock_classes_in_use, MAX_LOCKDEP_KEYS) __asi_not_sensitive;
 
 static inline struct lock_class *hlock_class(struct held_lock *hlock)
 {
@@ -389,7 +389,7 @@ static struct hlist_head classhash_table[CLASSHASH_SIZE];
 #define __chainhashfn(chain)	hash_long(chain, CHAINHASH_BITS)
 #define chainhashentry(chain)	(chainhash_table + __chainhashfn((chain)))
 
-static struct hlist_head chainhash_table[CHAINHASH_SIZE];
+static struct hlist_head chainhash_table[CHAINHASH_SIZE] __asi_not_sensitive;
 
 /*
  * the id of held_lock
@@ -599,7 +599,7 @@ u64 lockdep_stack_hash_count(void)
 unsigned int nr_hardirq_chains;
 unsigned int nr_softirq_chains;
 unsigned int nr_process_chains;
-unsigned int max_lockdep_depth;
+unsigned int max_lockdep_depth __asi_not_sensitive;
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
@@ -3225,8 +3225,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 	return 0;
 }
 
-struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
-static DECLARE_BITMAP(lock_chains_in_use, MAX_LOCKDEP_CHAINS);
+struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS] __asi_not_sensitive;
+static DECLARE_BITMAP(lock_chains_in_use, MAX_LOCKDEP_CHAINS) __asi_not_sensitive;
 static u16 chain_hlocks[MAX_LOCKDEP_CHAIN_HLOCKS];
 unsigned long nr_zapped_lock_chains;
 unsigned int nr_free_chain_hlocks;	/* Free chain_hlocks in buckets */
diff --git a/kernel/panic.c b/kernel/panic.c
index cefd7d82366f..6d0ee3ddd58b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -56,7 +56,7 @@ int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
 
-int panic_timeout = CONFIG_PANIC_TIMEOUT;
+int panic_timeout __asi_not_sensitive = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
 #define PANIC_PRINT_TASK_INFO		0x00000001
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 57b132b658e1..3425fb1554d3 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -75,7 +75,7 @@ EXPORT_SYMBOL(ignore_console_lock_warning);
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
  */
-int oops_in_progress;
+int oops_in_progress __asi_not_sensitive;
 EXPORT_SYMBOL(oops_in_progress);
 
 /*
@@ -2001,7 +2001,7 @@ static u8 *__printk_recursion_counter(void)
 		local_irq_restore(flags);		\
 	} while (0)
 
-int printk_delay_msec __read_mostly;
+int printk_delay_msec __asi_not_sensitive_readmostly;
 
 static inline void printk_delay(void)
 {
diff --git a/kernel/profile.c b/kernel/profile.c
index eb9c7f0f5ac5..c5beb9b0b0a8 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -44,10 +44,10 @@ static atomic_t *prof_buffer;
 static unsigned long prof_len;
 static unsigned short int prof_shift;
 
-int prof_on __read_mostly;
+int prof_on __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL_GPL(prof_on);
 
-static cpumask_var_t prof_cpu_mask;
+static cpumask_var_t prof_cpu_mask __asi_not_sensitive;
 #if defined(CONFIG_SMP) && defined(CONFIG_PROC_FS)
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
 static DEFINE_PER_CPU(int, cpu_profile_flip);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ef8d36f580fc..284d2722cf0c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -82,7 +82,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
 	.cblist.flags = SEGCBLIST_SOFTIRQ_ONLY,
 #endif
 };
-static struct rcu_state rcu_state = {
+static struct rcu_state rcu_state __asi_not_sensitive = {
 	.level = { &rcu_state.node[0] },
 	.gp_state = RCU_GP_IDLE,
 	.gp_seq = (0UL - 300UL) << RCU_SEQ_CTR_SHIFT,
@@ -98,7 +98,7 @@ static struct rcu_state rcu_state = {
 static bool dump_tree;
 module_param(dump_tree, bool, 0444);
 /* By default, use RCU_SOFTIRQ instead of rcuc kthreads. */
-static bool use_softirq = !IS_ENABLED(CONFIG_PREEMPT_RT);
+static __asi_not_sensitive bool use_softirq = !IS_ENABLED(CONFIG_PREEMPT_RT);
 #ifndef CONFIG_PREEMPT_RT
 module_param(use_softirq, bool, 0444);
 #endif
@@ -125,7 +125,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
  * transitions from RCU_SCHEDULER_INIT to RCU_SCHEDULER_RUNNING after RCU
  * is fully initialized, including all of its kthreads having been spawned.
  */
-int rcu_scheduler_active __read_mostly;
+int rcu_scheduler_active __asi_not_sensitive;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 /*
@@ -140,7 +140,7 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  * early boot to take responsibility for these callbacks, but one step at
  * a time.
  */
-static int rcu_scheduler_fully_active __read_mostly;
+static int rcu_scheduler_fully_active __asi_not_sensitive;
 
 static void rcu_report_qs_rnp(unsigned long mask, struct rcu_node *rnp,
 			      unsigned long gps, unsigned long flags);
@@ -470,7 +470,7 @@ module_param(qovld, long, 0444);
 
 static ulong jiffies_till_first_fqs = IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) ? 0 : ULONG_MAX;
 static ulong jiffies_till_next_fqs = ULONG_MAX;
-static bool rcu_kick_kthreads;
+static bool rcu_kick_kthreads __asi_not_sensitive;
 static int rcu_divisor = 7;
 module_param(rcu_divisor, int, 0644);
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 156892c22bb5..b61a3854e62d 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -243,7 +243,7 @@ core_initcall(rcu_set_runtime_mode);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
-struct lockdep_map rcu_lock_map = {
+struct lockdep_map rcu_lock_map __asi_not_sensitive = {
 	.name = "rcu_read_lock",
 	.key = &rcu_lock_key,
 	.wait_type_outer = LD_WAIT_FREE,
@@ -494,7 +494,7 @@ EXPORT_SYMBOL_GPL(rcutorture_sched_setaffinity);
 #ifdef CONFIG_RCU_STALL_COMMON
 int rcu_cpu_stall_ftrace_dump __read_mostly;
 module_param(rcu_cpu_stall_ftrace_dump, int, 0644);
-int rcu_cpu_stall_suppress __read_mostly; // !0 = suppress stall warnings.
+int rcu_cpu_stall_suppress __asi_not_sensitive_readmostly; // !0 = suppress stall warnings.
 EXPORT_SYMBOL_GPL(rcu_cpu_stall_suppress);
 module_param(rcu_cpu_stall_suppress, int, 0644);
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c2b2859ddd82..6c3585053f05 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -84,7 +84,7 @@ static int __sched_clock_stable_early = 1;
 /*
  * We want: ktime_get_ns() + __gtod_offset == sched_clock() + __sched_clock_offset
  */
-__read_mostly u64 __sched_clock_offset;
+__asi_not_sensitive u64 __sched_clock_offset;
 static __read_mostly u64 __gtod_offset;
 
 struct sched_clock_data {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 44ea197c16ea..e1c08ff4130e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -76,9 +76,9 @@ __read_mostly int sysctl_resched_latency_warn_once = 1;
  * Limited because this is done with IRQs disabled.
  */
 #ifdef CONFIG_PREEMPT_RT
-const_debug unsigned int sysctl_sched_nr_migrate = 8;
+unsigned int sysctl_sched_nr_migrate __asi_not_sensitive_readmostly = 8;
 #else
-const_debug unsigned int sysctl_sched_nr_migrate = 32;
+unsigned int sysctl_sched_nr_migrate __asi_not_sensitive_readmostly = 32;
 #endif
 
 /*
@@ -9254,7 +9254,7 @@ int in_sched_functions(unsigned long addr)
  * Default task group.
  * Every task in system belongs to this group at bootup.
  */
-struct task_group root_task_group;
+struct task_group root_task_group __asi_not_sensitive;
 LIST_HEAD(task_groups);
 
 /* Cacheline aligned slab cache for task_group */
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 893eece65bfd..6e3da149125c 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -50,7 +50,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 }
 
 static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
-static struct cpuacct root_cpuacct = {
+static struct cpuacct root_cpuacct __asi_not_sensitive = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
 };
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9392aea1804e..623b5feb142a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -19,7 +19,7 @@
  */
 DEFINE_PER_CPU(struct irqtime, cpu_irqtime);
 
-static int sched_clock_irqtime;
+static int __asi_not_sensitive sched_clock_irqtime;
 
 void enable_sched_clock_irqtime(void)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6e476f6d9435..dc9b6133b059 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -35,7 +35,7 @@
  *
  * (default: 6ms * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_latency			= 6000000ULL;
+__asi_not_sensitive unsigned int sysctl_sched_latency	= 6000000ULL;
 static unsigned int normalized_sysctl_sched_latency	= 6000000ULL;
 
 /*
@@ -90,7 +90,7 @@ unsigned int sysctl_sched_child_runs_first __read_mostly;
 unsigned int sysctl_sched_wakeup_granularity			= 1000000UL;
 static unsigned int normalized_sysctl_sched_wakeup_granularity	= 1000000UL;
 
-const_debug unsigned int sysctl_sched_migration_cost	= 500000UL;
+unsigned int sysctl_sched_migration_cost __asi_not_sensitive_readmostly	= 500000UL;
 
 int sched_thermal_decay_shift;
 static int __init setup_sched_thermal_decay_shift(char *str)
diff --git a/kernel/sched/loadavg.c b/kernel/sched/loadavg.c
index 954b229868d9..af71cde93e98 100644
--- a/kernel/sched/loadavg.c
+++ b/kernel/sched/loadavg.c
@@ -57,7 +57,7 @@
 
 /* Variables and functions for calc_load */
 atomic_long_t calc_load_tasks;
-unsigned long calc_load_update;
+unsigned long calc_load_update __asi_not_sensitive;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun); /* should be removed */
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b48baaba2fc2..9d5fbe66d355 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -14,7 +14,7 @@ static const u64 max_rt_runtime = MAX_BW;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
-struct rt_bandwidth def_rt_bandwidth;
+struct rt_bandwidth def_rt_bandwidth __asi_not_sensitive;
 
 static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0e66749486e7..517c70a29a57 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2379,8 +2379,8 @@ extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
 
 extern void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
-extern const_debug unsigned int sysctl_sched_nr_migrate;
-extern const_debug unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_migration_cost;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
diff --git a/kernel/smp.c b/kernel/smp.c
index 01a7c1706a58..c51fd981a4a9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1070,7 +1070,7 @@ static int __init maxcpus(char *str)
 early_param("maxcpus", maxcpus);
 
 /* Setup number of possible processor ids */
-unsigned int nr_cpu_ids __read_mostly = NR_CPUS;
+unsigned int nr_cpu_ids __asi_not_sensitive = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 41f470929e99..c462b7fab4d3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -56,7 +56,8 @@ DEFINE_PER_CPU_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 #endif
 
-static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
+static struct softirq_action softirq_vec[NR_SOFTIRQS]
+__asi_not_sensitive ____cacheline_aligned;
 
 DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0ea8702eb516..8b176f5c01f2 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -706,7 +706,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
  * High resolution timer enabled ?
  */
 static bool hrtimer_hres_enabled __read_mostly  = true;
-unsigned int hrtimer_resolution __read_mostly = LOW_RES_NSEC;
+unsigned int hrtimer_resolution __asi_not_sensitive = LOW_RES_NSEC;
 EXPORT_SYMBOL_GPL(hrtimer_resolution);
 
 /*
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index bc4db9e5ab70..c60f8da1cfb5 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -40,7 +40,13 @@ static struct clocksource clocksource_jiffies = {
 	.max_cycles		= 10,
 };
 
-__cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(jiffies_lock);
+/* TODO(oweisse): __cacheline_aligned_in_smp is expanded to
+  __section__(".data..cacheline_aligned"))) which is at odds with
+ __asi_not_sensitive. We should consider instead using
+ __attribute__ ((__aligned__(XXX))) where XXX is a def for cacheline or
+ something*/
+/* __cacheline_aligned_in_smp */
+__asi_not_sensitive DEFINE_RAW_SPINLOCK(jiffies_lock);
 __cacheline_aligned_in_smp seqcount_raw_spinlock_t jiffies_seq =
 	SEQCNT_RAW_SPINLOCK_ZERO(jiffies_seq, &jiffies_lock);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 406dccb79c2b..23711fb94323 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -31,13 +31,13 @@
 
 
 /* USER_HZ period (usecs): */
-unsigned long			tick_usec = USER_TICK_USEC;
+unsigned long			tick_usec __asi_not_sensitive = USER_TICK_USEC;
 
 /* SHIFTED_HZ period (nsecs): */
-unsigned long			tick_nsec;
+unsigned long			tick_nsec __asi_not_sensitive;
 
-static u64			tick_length;
-static u64			tick_length_base;
+static u64			tick_length __asi_not_sensitive;
+static u64			tick_length_base __asi_not_sensitive;
 
 #define SECS_PER_DAY		86400
 #define MAX_TICKADJ		500LL		/* usecs */
@@ -54,36 +54,36 @@ static u64			tick_length_base;
  *
  * (TIME_ERROR prevents overwriting the CMOS clock)
  */
-static int			time_state = TIME_OK;
+static int			time_state __asi_not_sensitive = TIME_OK;
 
 /* clock status bits:							*/
-static int			time_status = STA_UNSYNC;
+static int			time_status __asi_not_sensitive = STA_UNSYNC;
 
 /* time adjustment (nsecs):						*/
-static s64			time_offset;
+static s64			time_offset __asi_not_sensitive;
 
 /* pll time constant:							*/
-static long			time_constant = 2;
+static long			time_constant __asi_not_sensitive = 2;
 
 /* maximum error (usecs):						*/
-static long			time_maxerror = NTP_PHASE_LIMIT;
+static long			time_maxerror __asi_not_sensitive = NTP_PHASE_LIMIT;
 
 /* estimated error (usecs):						*/
-static long			time_esterror = NTP_PHASE_LIMIT;
+static long			time_esterror __asi_not_sensitive = NTP_PHASE_LIMIT;
 
 /* frequency offset (scaled nsecs/secs):				*/
-static s64			time_freq;
+static s64			time_freq __asi_not_sensitive;
 
 /* time at last adjustment (secs):					*/
-static time64_t		time_reftime;
+static time64_t		time_reftime __asi_not_sensitive;
 
-static long			time_adjust;
+static long			time_adjust __asi_not_sensitive;
 
 /* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
-static s64			ntp_tick_adj;
+static s64			ntp_tick_adj __asi_not_sensitive;
 
 /* second value of the next pending leapsecond, or TIME64_MAX if no leap */
-static time64_t			ntp_next_leap_sec = TIME64_MAX;
+static time64_t			ntp_next_leap_sec __asi_not_sensitive = TIME64_MAX;
 
 #ifdef CONFIG_NTP_PPS
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 46789356f856..cbe75661ca74 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -31,7 +31,7 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  * CPU which handles the tick and protected by jiffies_lock. There is
  * no requirement to write hold the jiffies seqcount for it.
  */
-ktime_t tick_next_period;
+ktime_t tick_next_period __asi_not_sensitive;
 
 /*
  * tick_do_timer_cpu is a timer core internal variable which holds the CPU NR
@@ -47,7 +47,7 @@ ktime_t tick_next_period;
  *    at it will take over and keep the time keeping alive.  The handover
  *    procedure also covers cpu hotplug.
  */
-int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
+int tick_do_timer_cpu __asi_not_sensitive_readmostly = TICK_DO_TIMER_BOOT;
 #ifdef CONFIG_NO_HZ_FULL
 /*
  * tick_do_timer_boot_cpu indicates the boot CPU temporarily owns
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 649f2b48e8f0..ed7e2a18060a 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -15,7 +15,7 @@
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern ktime_t tick_next_period;
-extern int tick_do_timer_cpu __read_mostly;
+extern int tick_do_timer_cpu;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 17a283ce2b20..c23fecbb68c2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -49,7 +49,7 @@ struct tick_sched *tick_get_tick_sched(int cpu)
  * jiffies_lock and jiffies_seq. tick_nohz_next_event() needs to get a
  * consistent view of jiffies and last_jiffies_update.
  */
-static ktime_t last_jiffies_update;
+static ktime_t last_jiffies_update __asi_not_sensitive;
 
 /*
  * Must be called with interrupts disabled !
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dcdcb85121e4..120395965e45 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -39,7 +39,7 @@ enum timekeeping_adv_mode {
 	TK_ADV_FREQ
 };
 
-DEFINE_RAW_SPINLOCK(timekeeper_lock);
+__asi_not_sensitive DEFINE_RAW_SPINLOCK(timekeeper_lock);
 
 /*
  * The most important data for readout fits into a single 64 byte
@@ -48,14 +48,14 @@ DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static struct {
 	seqcount_raw_spinlock_t	seq;
 	struct timekeeper	timekeeper;
-} tk_core ____cacheline_aligned = {
+} tk_core ____cacheline_aligned  __asi_not_sensitive = {
 	.seq = SEQCNT_RAW_SPINLOCK_ZERO(tk_core.seq, &timekeeper_lock),
 };
 
-static struct timekeeper shadow_timekeeper;
+static struct timekeeper shadow_timekeeper __asi_not_sensitive;
 
 /* flag for if timekeeping is suspended */
-int __read_mostly timekeeping_suspended;
+int __asi_not_sensitive_readmostly timekeeping_suspended;
 
 /**
  * struct tk_fast - NMI safe timekeeper
@@ -72,7 +72,7 @@ struct tk_fast {
 };
 
 /* Suspend-time cycles value for halted fast timekeeper. */
-static u64 cycles_at_suspend;
+static u64 cycles_at_suspend __asi_not_sensitive;
 
 static u64 dummy_clock_read(struct clocksource *cs)
 {
diff --git a/kernel/time/timekeeping.h b/kernel/time/timekeeping.h
index 543beba096c7..b32ee75808fe 100644
--- a/kernel/time/timekeeping.h
+++ b/kernel/time/timekeeping.h
@@ -26,7 +26,7 @@ extern void update_process_times(int user);
 extern void do_timer(unsigned long ticks);
 extern void update_wall_time(void);
 
-extern raw_spinlock_t jiffies_lock;
+extern __asi_not_sensitive raw_spinlock_t jiffies_lock;
 extern seqcount_raw_spinlock_t jiffies_seq;
 
 #define CS_NAME_LEN	32
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 85f1021ad459..0b09c99b568c 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -56,7 +56,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/timer.h>
 
-__visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
+u64 jiffies_64 __asi_not_sensitive ____cacheline_aligned = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 78ea542ce3bc..eaec3814c5a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -432,7 +432,7 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_export);
  * The global_trace is the descriptor that holds the top-level tracing
  * buffers for the live tracing.
  */
-static struct trace_array global_trace = {
+static struct trace_array global_trace __asi_not_sensitive = {
 	.trace_flags = TRACE_DEFAULT_FLAGS,
 };
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index e304196d7c28..d49db8e2430a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -16,8 +16,8 @@
 #define RECORD_CMDLINE	1
 #define RECORD_TGID	2
 
-static int		sched_cmdline_ref;
-static int		sched_tgid_ref;
+static int		sched_cmdline_ref __asi_not_sensitive;
+static int		sched_tgid_ref __asi_not_sensitive;
 static DEFINE_MUTEX(sched_register_mutex);
 
 static void
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index a75ee30b77cb..f2d217859be6 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/debug_locks.h>
+#include <asm/asi.h>
 
 /*
  * We want to turn all lock-debugging facilities on/off at once,
@@ -22,7 +23,7 @@
  * that would just muddy the log. So we report the first one and
  * shut up after that.
  */
-int debug_locks __read_mostly = 1;
+int debug_locks __asi_not_sensitive_readmostly = 1;
 EXPORT_SYMBOL_GPL(debug_locks);
 
 /*
@@ -30,7 +31,7 @@ EXPORT_SYMBOL_GPL(debug_locks);
  * 'silent failure': nothing is printed to the console when
  * a locking bug is detected.
  */
-int debug_locks_silent __read_mostly;
+int debug_locks_silent __asi_not_sensitive_readmostly;
 EXPORT_SYMBOL_GPL(debug_locks_silent);
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 667ece86e051..5aa39d0aba2b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -152,7 +152,7 @@ static int __init disable_randmaps(char *s)
 }
 __setup("norandmaps", disable_randmaps);
 
-unsigned long zero_pfn __read_mostly;
+unsigned long zero_pfn __asi_not_sensitive;
 EXPORT_SYMBOL(zero_pfn);
 
 unsigned long highest_memmap_pfn __read_mostly;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 998ff6a56732..9c850b8bd1fc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -183,7 +183,7 @@ unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
 int percpu_pagelist_high_fraction;
-gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
+gfp_t gfp_allowed_mask __asi_not_sensitive_readmostly = GFP_BOOT_MASK;
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
 
diff --git a/mm/sparse.c b/mm/sparse.c
index e5c84b0cf0c9..64dcf7fceaed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -24,10 +24,10 @@
  * 1) mem_section	- memory sections, mem_map's for valid memory
  */
 #ifdef CONFIG_SPARSEMEM_EXTREME
-struct mem_section **mem_section;
+struct mem_section **mem_section __asi_not_sensitive;
 #else
 struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
-	____cacheline_internodealigned_in_smp;
+	____cacheline_internodealigned_in_smp __asi_not_sensitive;
 #endif
 EXPORT_SYMBOL(mem_section);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e8e9c8588908..0af973b950c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3497,7 +3497,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static struct file_operations kvm_vcpu_fops = {
+static struct file_operations kvm_vcpu_fops __asi_not_sensitive = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.mmap           = kvm_vcpu_mmap,
-- 
2.35.1.473.g83b2b277ed-goog

