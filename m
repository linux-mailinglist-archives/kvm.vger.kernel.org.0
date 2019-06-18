Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A124AE35
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfFRWvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:2939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730934AbfFRWvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009368"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:11 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split lock
Date:   Tue, 18 Jun 2019 15:41:11 -0700
Message-Id: <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There may be different considerations on how to handle #AC for split lock,
e.g. how to handle system hang caused by split lock issue in firmware,
how to emulate faulting instruction, etc. We use a simple method to
handle user and kernel split lock and may extend the method in the future.

When #AC exception for split lock is triggered from user process, the
process is killed by SIGBUS. To execute the process properly, a user
application developer needs to fix the split lock issue.

When #AC exception for split lock is triggered from a kernel instruction,
disable split lock detection on local CPU and warn the split lock issue.
After the exception, the faulting instruction will be executed and kernel
execution continues. Split lock detection is only disabled on the local
CPU, not globally. It will be re-enabled if the CPU is offline and then
online or through debugfs interface.

A kernel/driver developer should check the warning, which contains helpful
faulting address, context, and callstack info, and fix the split lock
issues. Then further split lock issues may be captured and fixed.

After bit 29 in MSR_TEST_CTL is set to 1 in kernel, firmware inherits
the setting when firmware is executed in S4, S5, run time services, SMI,
etc. If there is a split lock operation in firmware, it will triggers
#AC and may hang the system depending on how firmware handles the #AC.
It's up to a firmware developer to fix split lock issues in firmware.

MSR TEST_CTL value is cached in per CPU msr_test_ctl_cached which will be
used in virtualization to avoid costly MSR read.

Ingo suggests to use global split_lock_debug flag to allow only one CPU to
print split lock warning in the #AC handler because WARN_ONCE() and
underlying BUGFLAG_ONCE mechanism are not atomic. This also solves
the race if the split-lock #AC fault is re-triggered by NMI of perf
context interrupting one split-lock warning execution while the original
WARN_ON() is executing.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h  |  3 +++
 arch/x86/kernel/cpu/intel.c | 38 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c     | 42 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4e03f53fc079..81710f2a3eea 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -42,7 +42,10 @@ unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
+DECLARE_PER_CPU(u64, msr_test_ctl_cached);
+void split_lock_disable(void);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
+static inline void split_lock_disable(void) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7ae6cc22657d..16cf1631b7f9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,6 +31,9 @@
 #include <asm/apic.h>
 #endif
 
+DEFINE_PER_CPU(u64, msr_test_ctl_cached);
+EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cached);
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -624,6 +627,17 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+static void split_lock_init(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		u64 test_ctl_val;
+
+		/* Cache MSR TEST_CTL */
+		rdmsrl(MSR_TEST_CTL, test_ctl_val);
+		this_cpu_write(msr_test_ctl_cached, test_ctl_val);
+	}
+}
+
 static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
@@ -734,6 +748,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 		detect_tme(c);
 
 	init_intel_misc_features(c);
+
+	split_lock_init(c);
 }
 
 #ifdef CONFIG_X86_32
@@ -1027,3 +1043,25 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	if (ia32_core_cap & MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT)
 		split_lock_setup();
 }
+
+static atomic_t split_lock_debug;
+
+void split_lock_disable(void)
+{
+	/* Disable split lock detection on this CPU */
+	this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
+	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
+
+	/*
+	 * Use the atomic variable split_lock_debug to ensure only the
+	 * first CPU hitting split lock issue prints one single complete
+	 * warning. This also solves the race if the split-lock #AC fault
+	 * is re-triggered by NMI of perf context interrupting one
+	 * split-lock warning execution while the original WARN_ONCE() is
+	 * executing.
+	 */
+	if (atomic_cmpxchg(&split_lock_debug, 0, 1) == 0) {
+		WARN_ONCE(1, "split lock operation detected\n");
+		atomic_set(&split_lock_debug, 0);
+	}
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8b6d03e55d2f..38143c028f5a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -293,9 +294,48 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,           0, NULL, "coprocessor segment overru
 DO_ERROR(X86_TRAP_TS,     SIGSEGV,          0, NULL, "invalid TSS",         invalid_TSS)
 DO_ERROR(X86_TRAP_NP,     SIGBUS,           0, NULL, "segment not present", segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,           0, NULL, "stack segment",       stack_segment)
-DO_ERROR(X86_TRAP_AC,     SIGBUS,  BUS_ADRALN, NULL, "alignment check",     alignment_check)
 #undef IP
 
+dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
+{
+	unsigned int trapnr = X86_TRAP_AC;
+	char str[] = "alignment check";
+	int signr = SIGBUS;
+
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) == NOTIFY_STOP)
+		return;
+
+	cond_local_irq_enable(regs);
+	if (!user_mode(regs) && static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		/*
+		 * Only split locks can generate #AC from kernel mode.
+		 *
+		 * The split-lock detection feature is a one-shot
+		 * debugging facility, so we disable it immediately and
+		 * print a warning.
+		 *
+		 * This also solves the instruction restart problem: we
+		 * return the faulting instruction right after this it
+		 * will be executed without generating another #AC fault
+		 * and getting into an infinite loop, instead it will
+		 * continue without side effects to the interrupted
+		 * execution context.
+		 *
+		 * Split-lock detection will remain disabled after this,
+		 * until the next reboot.
+		 */
+		split_lock_disable();
+
+		return;
+	}
+
+	/* Handle #AC generated in any other cases. */
+	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
+		error_code, BUS_ADRALN, NULL);
+}
+
 #ifdef CONFIG_VMAP_STACK
 __visible void __noreturn handle_stack_overflow(const char *message,
 						struct pt_regs *regs,
-- 
2.19.1

