Return-Path: <kvm+bounces-44266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD57FA9C185
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DFB79A5E0E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F54241689;
	Fri, 25 Apr 2025 08:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DkDA8ycj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713B21B6D11;
	Fri, 25 Apr 2025 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570142; cv=none; b=kPkimr4acoyUI4aFZuc5Ep0NMlQKAUw1o6EThZApnL3y0d5OgYstnJAGHkOPxZ6tQtwnNIz/wYLhmoa3gedL+kEX2yEU132HGhV//bP/VMvDzfKAOCJVjrmNxyHQYGF8tTuv1g551g4woLbImuyG1Mep7U9MemblYE9bCkIXPz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570142; c=relaxed/simple;
	bh=revNcdhZHbnMJG0fNqbbU9l/IB0mYOTwCTjBO65BMac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFQjfez8MzMV5R8q/NwrLjc5+vygRiLwDEiDm6YyUYjCTLEEcFZGGRrGbk6TN7cX7AApV7RzJukIzi3Lh9AIuuafmOH4qw9+YBA/3BVqa0HohgiHfWtn/XoDl/GJ0PPZM9SpWrz9xZ06dMVDBKCGDYCkG86s9Dkl5e1Yk7PwD/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DkDA8ycj; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5P2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:34:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5P2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570091;
	bh=647AnGgLXs34NjSWqun8T/TryywSzrBvCGHXdii61Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkDA8ycjphciWWaVFq4Ul+HxFYAk++kpSrDb0GUR0+2NW9udjWpkcu+di893xjMRD
	 9uim80f09InfvNePjMl1wKwRMq7GsEmfWJiHXG/PjgSZEQeu9o/vRLtpHeEZv3FEWt
	 xF+PGcJtnbJxrEbQVi6Kusy8GslmLYh0muh4hbUuAzkQPt9ob2zYoL8//RuufchGLu
	 JmIaj+7Rnf9eTe9UJcaAJ0xbt8AqC53B67DeK1VUibNOh+7mw/oehutgxmPU4wObgA
	 RaOo4zVtWws27D9rCnoPAljeM3d1TsZHQsDnnC9SL8BFlfaW0cAz8RQN4Bsq85pDKc
	 /0jy4nOMAQJgA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
Subject: [PATCH v3 01/14] x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
Date: Fri, 25 Apr 2025 01:34:24 -0700
Message-ID: <20250425083442.2390017-2-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425083442.2390017-1-xin@zytor.com>
References: <20250425083442.2390017-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For some reason, there are some TSC-related functions in the MSR
header even though there is a tsc.h header.

Relocate rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h>, and
subsequently remove the inclusion of <asm/msr.h> in <asm/tsc.h>.
Consequently, <asm/msr.h> must be included in several source files
that previously did not require it.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---

Change in v3:
* Add a problem statement to the changelog (Dave Hansen).
---
 arch/x86/events/msr.c                         |  3 +
 arch/x86/events/perf_event.h                  |  1 +
 arch/x86/events/probe.c                       |  2 +
 arch/x86/hyperv/ivm.c                         |  1 +
 arch/x86/include/asm/fred.h                   |  1 +
 arch/x86/include/asm/microcode.h              |  2 +
 arch/x86/include/asm/mshyperv.h               |  1 +
 arch/x86/include/asm/msr.h                    | 55 +-------------
 arch/x86/include/asm/suspend_32.h             |  1 +
 arch/x86/include/asm/suspend_64.h             |  1 +
 arch/x86/include/asm/switch_to.h              |  2 +
 arch/x86/include/asm/tsc.h                    | 76 ++++++++++++++++++-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  1 +
 arch/x86/kernel/fpu/xstate.h                  |  1 +
 arch/x86/kernel/hpet.c                        |  1 +
 arch/x86/kernel/process_64.c                  |  1 +
 arch/x86/kernel/trace_clock.c                 |  2 +-
 arch/x86/kernel/tsc_sync.c                    |  1 +
 arch/x86/lib/kaslr.c                          |  2 +-
 arch/x86/mm/mem_encrypt_identity.c            |  1 +
 arch/x86/realmode/init.c                      |  1 +
 drivers/acpi/processor_perflib.c              |  1 +
 drivers/acpi/processor_throttling.c           |  3 +-
 drivers/cpufreq/amd-pstate-ut.c               |  2 +
 drivers/hwmon/hwmon-vid.c                     |  4 +
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +
 drivers/platform/x86/intel/pmc/cnp.c          |  1 +
 .../intel/speed_select_if/isst_if_common.c    |  1 +
 drivers/platform/x86/intel/turbo_max_3.c      |  1 +
 29 files changed, 116 insertions(+), 58 deletions(-)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 8970ecef87c5..c39e49cecace 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -3,6 +3,9 @@
 #include <linux/sysfs.h>
 #include <linux/nospec.h>
 #include <asm/cpu_device_id.h>
+#include <asm/msr.h>
+#include <asm/tsc.h>
+
 #include "probe.h"
 
 enum perf_msr_id {
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index a5166fa9339b..a8d4e82e3589 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -17,6 +17,7 @@
 #include <asm/fpu/xstate.h>
 #include <asm/intel_ds.h>
 #include <asm/cpu.h>
+#include <asm/msr.h>
 
 /* To enable MSR tracing please use the generic trace points. */
 
diff --git a/arch/x86/events/probe.c b/arch/x86/events/probe.c
index fda35cf25528..bb719d0d3f0b 100644
--- a/arch/x86/events/probe.c
+++ b/arch/x86/events/probe.c
@@ -2,6 +2,8 @@
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/bits.h>
+
+#include <asm/msr.h>
 #include "probe.h"
 
 static umode_t
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 1b8a2415183b..8209de792388 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -22,6 +22,7 @@
 #include <asm/realmode.h>
 #include <asm/e820/api.h>
 #include <asm/desc.h>
+#include <asm/msr.h>
 #include <uapi/asm/vmx.h>
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2a29e5216881..12b34d5b2953 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -9,6 +9,7 @@
 #include <linux/const.h>
 
 #include <asm/asm.h>
+#include <asm/msr.h>
 #include <asm/trapnr.h>
 
 /*
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 263ea3dd0001..107a1aaa211b 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_MICROCODE_H
 #define _ASM_X86_MICROCODE_H
 
+#include <asm/msr.h>
+
 struct cpu_signature {
 	unsigned int sig;
 	unsigned int pf;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index bab5ccfc60a7..15d00dace70f 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -8,6 +8,7 @@
 #include <linux/io.h>
 #include <asm/nospec-branch.h>
 #include <asm/paravirt.h>
+#include <asm/msr.h>
 #include <hyperv/hvhdk.h>
 
 /*
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2ccc78ebc3d7..2caa13830e11 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -12,6 +12,7 @@
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
 
+#include <linux/types.h>
 #include <linux/percpu.h>
 
 struct msr_info {
@@ -169,60 +170,6 @@ native_write_msr_safe(u32 msr, u32 low, u32 high)
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
-/**
- * rdtsc() - returns the current TSC without ordering constraints
- *
- * rdtsc() returns the result of RDTSC as a 64-bit integer.  The
- * only ordering constraint it supplies is the ordering implied by
- * "asm volatile": it will put the RDTSC in the place you expect.  The
- * CPU can and will speculatively execute that RDTSC, though, so the
- * results can be non-monotonic if compared on different CPUs.
- */
-static __always_inline u64 rdtsc(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
-
-	return EAX_EDX_VAL(val, low, high);
-}
-
-/**
- * rdtsc_ordered() - read the current TSC in program order
- *
- * rdtsc_ordered() returns the result of RDTSC as a 64-bit integer.
- * It is ordered like a load to a global in-memory counter.  It should
- * be impossible to observe non-monotonic rdtsc_unordered() behavior
- * across multiple CPUs as long as the TSC is synced.
- */
-static __always_inline u64 rdtsc_ordered(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	/*
-	 * The RDTSC instruction is not ordered relative to memory
-	 * access.  The Intel SDM and the AMD APM are both vague on this
-	 * point, but empirically an RDTSC instruction can be
-	 * speculatively executed before prior loads.  An RDTSC
-	 * immediately after an appropriate barrier appears to be
-	 * ordered as a normal load, that is, it provides the same
-	 * ordering guarantees as reading from a global memory location
-	 * that some other imaginary CPU is updating continuously with a
-	 * time stamp.
-	 *
-	 * Thus, use the preferred barrier on the respective CPU, aiming for
-	 * RDTSCP as the default.
-	 */
-	asm volatile(ALTERNATIVE_2("rdtsc",
-				   "lfence; rdtsc", X86_FEATURE_LFENCE_RDTSC,
-				   "rdtscp", X86_FEATURE_RDTSCP)
-			: EAX_EDX_RET(val, low, high)
-			/* RDTSCP clobbers ECX with MSR_TSC_AUX. */
-			:: "ecx");
-
-	return EAX_EDX_VAL(val, low, high);
-}
-
 static inline u64 native_read_pmc(int counter)
 {
 	DECLARE_ARGS(val, low, high);
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index d8416b3bf832..e8e5aab06255 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -9,6 +9,7 @@
 
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/msr.h>
 
 /* image of the saved processor state */
 struct saved_context {
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index 54df06687d83..b512f9665f78 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -9,6 +9,7 @@
 
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/msr.h>
 
 /*
  * Image of the saved processor state, used by the low level ACPI suspend to
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 75248546403d..4f21df7af715 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -52,6 +52,8 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_X86_32
+#include <asm/msr.h>
+
 static inline void refresh_sysenter_cs(struct thread_struct *thread)
 {
 	/* Only happens when SEP is enabled, no need to test "SEP"arately: */
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94408a784c8e..13335a130edf 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -7,7 +7,81 @@
 
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
-#include <asm/msr.h>
+
+/*
+ * both i386 and x86_64 returns 64-bit value in edx:eax, but gcc's "A"
+ * constraint has different meanings. For i386, "A" means exactly
+ * edx:eax, while for x86_64 it doesn't mean rdx:rax or edx:eax. Instead,
+ * it means rax *or* rdx.
+ */
+#ifdef CONFIG_X86_64
+/* Using 64-bit values saves one instruction clearing the high half of low */
+#define DECLARE_ARGS(val, low, high)	unsigned long low, high
+#define EAX_EDX_VAL(val, low, high)	((low) | (high) << 32)
+#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
+#else
+#define DECLARE_ARGS(val, low, high)	u64 val
+#define EAX_EDX_VAL(val, low, high)	(val)
+#define EAX_EDX_RET(val, low, high)	"=A" (val)
+#endif
+
+/**
+ * rdtsc() - returns the current TSC without ordering constraints
+ *
+ * rdtsc() returns the result of RDTSC as a 64-bit integer.  The
+ * only ordering constraint it supplies is the ordering implied by
+ * "asm volatile": it will put the RDTSC in the place you expect.  The
+ * CPU can and will speculatively execute that RDTSC, though, so the
+ * results can be non-monotonic if compared on different CPUs.
+ */
+static __always_inline u64 rdtsc(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+/**
+ * rdtsc_ordered() - read the current TSC in program order
+ *
+ * rdtsc_ordered() returns the result of RDTSC as a 64-bit integer.
+ * It is ordered like a load to a global in-memory counter.  It should
+ * be impossible to observe non-monotonic rdtsc_unordered() behavior
+ * across multiple CPUs as long as the TSC is synced.
+ */
+static __always_inline u64 rdtsc_ordered(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	/*
+	 * The RDTSC instruction is not ordered relative to memory
+	 * access.  The Intel SDM and the AMD APM are both vague on this
+	 * point, but empirically an RDTSC instruction can be
+	 * speculatively executed before prior loads.  An RDTSC
+	 * immediately after an appropriate barrier appears to be
+	 * ordered as a normal load, that is, it provides the same
+	 * ordering guarantees as reading from a global memory location
+	 * that some other imaginary CPU is updating continuously with a
+	 * time stamp.
+	 *
+	 * Thus, use the preferred barrier on the respective CPU, aiming for
+	 * RDTSCP as the default.
+	 */
+	asm volatile(ALTERNATIVE_2("rdtsc",
+				   "lfence; rdtsc", X86_FEATURE_LFENCE_RDTSC,
+				   "rdtscp", X86_FEATURE_RDTSCP)
+			: EAX_EDX_RET(val, low, high)
+			/* RDTSCP clobbers ECX with MSR_TSC_AUX. */
+			:: "ecx");
+
+	return EAX_EDX_VAL(val, low, high);
+}
+
+#undef DECLARE_ARGS
+#undef EAX_EDX_VAL
+#undef EAX_EDX_RET
 
 /*
  * Standard way to access the cycle counter.
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 2a82eb6a0376..26c354bdea07 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -25,6 +25,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/resctrl.h>
 #include <asm/perf_event.h>
+#include <asm/msr.h>
 
 #include "../../events/perf_event.h" /* For X86_CONFIG() */
 #include "internal.h"
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 5e5d35027f13..f705bd355ea2 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -5,6 +5,7 @@
 #include <asm/cpufeature.h>
 #include <asm/fpu/xstate.h>
 #include <asm/fpu/xcr.h>
+#include <asm/msr.h>
 
 #ifdef CONFIG_X86_64
 DECLARE_PER_CPU(u64, xfd_state);
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cc5d12232216..c9982a7c9536 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -12,6 +12,7 @@
 #include <asm/hpet.h>
 #include <asm/time.h>
 #include <asm/mwait.h>
+#include <asm/msr.h>
 
 #undef  pr_fmt
 #define pr_fmt(fmt) "hpet: " fmt
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 24e1ccf22912..cfa9c031de91 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -57,6 +57,7 @@
 #include <asm/unistd.h>
 #include <asm/fsgsbase.h>
 #include <asm/fred.h>
+#include <asm/msr.h>
 #ifdef CONFIG_IA32_EMULATION
 /* Not included via unistd.h */
 #include <asm/unistd_32_ia32.h>
diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.c
index b8e7abe00b06..708d61743d15 100644
--- a/arch/x86/kernel/trace_clock.c
+++ b/arch/x86/kernel/trace_clock.c
@@ -4,7 +4,7 @@
  */
 #include <asm/trace_clock.h>
 #include <asm/barrier.h>
-#include <asm/msr.h>
+#include <asm/tsc.h>
 
 /*
  * trace_clock_x86_tsc(): A clock that is just the cycle counter.
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index f1c7a86dbf49..ec3aa340d351 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <asm/msr.h>
 #include <asm/tsc.h>
 
 struct tsc_adjust {
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index a58f451a7dd3..b5893928d55c 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -8,7 +8,7 @@
  */
 #include <asm/asm.h>
 #include <asm/kaslr.h>
-#include <asm/msr.h>
+#include <asm/tsc.h>
 #include <asm/archrandom.h>
 #include <asm/e820/api.h>
 #include <asm/shared/io.h>
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 5eecdd92da10..afda349db35b 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -44,6 +44,7 @@
 #include <asm/sections.h>
 #include <asm/coco.h>
 #include <asm/sev.h>
+#include <asm/msr.h>
 
 #include "mm_internal.h"
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 263787b4800c..ed5c63c0b4e5 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -9,6 +9,7 @@
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
+#include <asm/msr.h>
 #include <asm/sev.h>
 
 struct real_mode_header *real_mode_header;
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 53996f1a2d80..64b8d1e19594 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -20,6 +20,7 @@
 #include <acpi/processor.h>
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
+#include <asm/msr.h>
 #endif
 
 #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 00d045e5f524..8482e9a8a7aa 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -18,9 +18,10 @@
 #include <linux/sched.h>
 #include <linux/cpufreq.h>
 #include <linux/acpi.h>
+#include <linux/uaccess.h>
 #include <acpi/processor.h>
 #include <asm/io.h>
-#include <linux/uaccess.h>
+#include <asm/asm.h>
 
 /* ignore_tpc:
  *  0 -> acpi processor driver doesn't ignore _TPC values
diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 707fa81c749f..c8d031b297d2 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -31,6 +31,8 @@
 
 #include <acpi/cppc_acpi.h>
 
+#include <asm/msr.h>
+
 #include "amd-pstate.h"
 
 
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index 6d1175a51832..2df4956296ed 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -15,6 +15,10 @@
 #include <linux/kernel.h>
 #include <linux/hwmon-vid.h>
 
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
+
 /*
  * Common code for decoding VID pins.
  *
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3df6aabc7e33..7edd0b5e0e77 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -27,6 +27,10 @@
 #include <linux/module.h>
 #include <net/ip6_checksum.h>
 
+#ifdef CONFIG_X86
+#include <asm/msr.h>
+#endif
+
 #include "vmxnet3_int.h"
 #include "vmxnet3_xdp.h"
 
diff --git a/drivers/platform/x86/intel/pmc/cnp.c b/drivers/platform/x86/intel/pmc/cnp.c
index 547bdf1ab02d..efea4e1ba52b 100644
--- a/drivers/platform/x86/intel/pmc/cnp.c
+++ b/drivers/platform/x86/intel/pmc/cnp.c
@@ -10,6 +10,7 @@
 
 #include <linux/smp.h>
 #include <linux/suspend.h>
+#include <asm/msr.h>
 #include "core.h"
 
 /* Cannon Lake: PGD PFET Enable Ack Status Register(s) bitmap */
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 44dcd165b4c0..8a5713593811 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -21,6 +21,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #include "isst_if_common.h"
 
diff --git a/drivers/platform/x86/intel/turbo_max_3.c b/drivers/platform/x86/intel/turbo_max_3.c
index 7e538bbd5b50..b5af3e91ba04 100644
--- a/drivers/platform/x86/intel/turbo_max_3.c
+++ b/drivers/platform/x86/intel/turbo_max_3.c
@@ -17,6 +17,7 @@
 
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/msr.h>
 
 #define MSR_OC_MAILBOX			0x150
 #define MSR_OC_MAILBOX_CMD_OFFSET	32
-- 
2.49.0


