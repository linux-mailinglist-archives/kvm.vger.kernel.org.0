Return-Path: <kvm+bounces-49328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA2AAD7DDB
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 721A73A1B23
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E6C2E62B3;
	Thu, 12 Jun 2025 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/+SALHr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29E52E2EF7;
	Thu, 12 Jun 2025 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765034; cv=none; b=tTlrTy5vIgfR6v4QHcDDJmaCwhbmF8WuS6HlPLhHKkM7xa+3gJqbev1X3j8FahRaHJ0knT0fA5GbReVec/K90ATbEphm67bjOClVl34h1wvH4jHh+V2NAZr6MPNh1g/dUcVK+P1o/klJxxVyC4HdYlzofZJZDc5jiMgI0cCWk3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765034; c=relaxed/simple;
	bh=X5AazRLPkD4qnl4y51OKxsRAvMNIQ2UGhe8CaDOK3k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR/Jl09CGjCylqGmMpYHoq85YQNoPg+eXLXmEMmyWFRoJF6EZIH/vIwHYDUhv42Hr0Qb/f/1baytnID2dwC+l+ODaZQ5KbUW3MD3v2W+goOFv//PnnC0JT8tffHX5gXw9dfpWm4yC9akXci3CX1Ynt0bdGF95sI/gJ2FK64Qyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/+SALHr; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765033; x=1781301033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X5AazRLPkD4qnl4y51OKxsRAvMNIQ2UGhe8CaDOK3k0=;
  b=U/+SALHr8S0F/3TC/RaiyQ/ILxn7nIm/IWES4ImDLCkpIiVsJDVw3rjK
   1TK9TYzQlft89EPAG0d0sqSWMsUWMPVMrh0ZCborji7VRld0LfN/v/WBS
   swR0ByX0RntPpgHDddStiiSnD8hmKRAyK+EndgO4ZKjknZHkc6wojrsAA
   FXiAZofLOjJG9kV6kU62lf6hfl3bt0uxyY8sT39nwwwQKCN6YFvoMfYgI
   C1fS40Jytnh4+TlwdcPDsnNL5mR/y+eWAGv+zMQuki7FLVJ9qmO7jgRLi
   vmc6yiEHjU+6OwbIO86O7+DAX8ftChb+R4ev2rDKeRdAXUj8auE1IPxxT
   A==;
X-CSE-ConnectionGUID: ToIOmlPoSB6sg6KlBxfpxA==
X-CSE-MsgGUID: UqmTrZXASPmHzut3obxeMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065345"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065345"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:30 -0700
X-CSE-ConnectionGUID: fnbw2o0IQO6h44e7RuE5Kw==
X-CSE-MsgGUID: 4sGjZK+ORt+IJPLUF4H1vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881966"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:30 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
Date: Thu, 12 Jun 2025 14:48:44 -0700
Message-ID: <20250612214849.3950094-6-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prior to NMI-source support, the vector information was ignored by the
hardware while delivering NMIs. With NMI-source reporting, the initial
architecture supports a 16-bit source bitmap to identify the source of
the NMI. Upon receiving an NMI, this bitmap is delivered to the kernel
as part of the FRED event delivery mechanism.

Assign a vector space of 1-15 that is specific to NMI-source and
independent of the IDT vector space. Though unlikely, the hardware may
extend the NMI-source bitmap in the future. Add a code comment to
clarify how the kernel support can be easily extended.

Being a bitmap, the NMI-source vectors do not have any inherent priority
associated with them. The order of executing the NMI handlers is up to
the kernel. Existing NMI handling already has a priority mechanism for
the NMI handlers, with CPU-specific (NMI_LOCAL) handlers executed first,
followed by platform NMI handlers and unknown NMI (NMI_UNKNOWN) handlers
being last. Within each of these NMI types, the handlers registered with
NMI_FLAG_FIRST are given priority.

NMI-source follows the same priority scheme to avoid unnecessary
complexity. Therefore, the NMI-source vectors are assigned arbitrarily,
except for vector 2.

Vector 2 is reserved for external NMIs corresponding to the Local APIC -
LINT1 pin. Some third-party chipsets may send NMI messages with a fixed
vector value of 2. Using vector 2 for something else would lead to
confusion about the exact source. Do not assign it to any handler.

NMI-source vectors are only assigned for NMI_LOCAL type handlers.
Platform NMI handlers have a single handler registered per type. They
don't need additional source information to differentiate among them.

Use the assigned vectors to register the respective NMI handlers. Warn
if the vector values are unexpected.

A couple of NMI handlers, such as the microcode rendezvous and the crash
reboot, do not use the typical NMI registration interface. Leave them
as-is for now.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
---
v7: Use an enum to define the NMI-source vectors. (DaveH)
    Add a BUILD_BUG_ON to validate the allocated vector count. (DaveH)
    Add review tag from Xin.

v6: Store source vector unconditionally. (PeterZ)
    Add a warning for unexpected source vector values. (PeterZ)

v5: Move the vector defines to nmi.h.
    Combine vector allocation and registration into one patch.
    Simplify NMI vector names.
    Describe usage of vector 2 for external NMIs.
    Get rid of vector priorities.
---
 arch/x86/events/core.c           |  2 +-
 arch/x86/include/asm/nmi.h       | 46 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/hw_nmi.c    |  2 +-
 arch/x86/kernel/cpu/mce/inject.c |  2 +-
 arch/x86/kernel/kgdb.c           |  2 +-
 arch/x86/kernel/nmi.c            |  7 +++++
 arch/x86/kernel/nmi_selftest.c   |  2 +-
 arch/x86/kernel/smp.c            |  2 +-
 8 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index ec59837d10d1..dd42fe7bce9c 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2129,7 +2129,7 @@ static int __init init_hw_perf_events(void)
 		x86_pmu.config_mask = X86_RAW_EVENT_MASK;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", NMIS_NO_SOURCE);
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", NMIS_VECTOR_PMI);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, x86_pmu.cntr_mask64,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 42820c4f59b9..a48958a236fd 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -53,12 +53,58 @@ typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
  * origin of an NMI and to route the NMI directly to the appropriate
  * handler.
  *
+ * On CPUs that support NMI-source reporting with FRED, receiving an NMI
+ * with a valid vector sets the corresponding bit in the NMI-source
+ * bitmap. The bitmap is delivered as FRED event data on the stack.
+ *
+ * Multiple NMIs are coalesced in the NMI-source bitmap until the next
+ * NMI delivery. If an NMI is received without a vector or beyond the
+ * defined range, the CPU sets bit 0 of the NMI-source bitmap.
+ *
+ * Third-party chipsets may send NMI messages with a fixed vector of 2.
+ * Using vector 2 for some other purpose would cause confusion between
+ * those external NMI messages and the other purpose. Avoid using it.
+ *
+ * The vectors are in no particular priority order. Add new vector
+ * assignments sequentially in the list below before the COUNT.
+ *
  * @NMIS_NO_SOURCE:        Reserved for undefined or unidentified sources.
+ * @NMIS_VECTOR_TEST:      NMI selftest.
+ * @NMIS_VECTOR_EXTERNAL:  Reserved to match external NMI vector 2.
+ * @NMIS_VECTOR_SMP_STOP:  Panic stop CPU.
+ * @NMIS_VECTOR_BT:        CPU backtrace.
+ * @NMIS_VECTOR_KGDB:      Kernel debugger.
+ * @NMIS_VECTOR_MCE:       MCE injection.
+ * @NMIS_VECTOR_PMI:       PerfMon counters.
+ *
+ * @NMIS_VECTOR_COUNT:     Count of the defined vectors.
  */
 enum nmi_source_vectors {
 	NMIS_NO_SOURCE		= 0,
+	NMIS_VECTOR_TEST,
+	NMIS_VECTOR_EXTERNAL	= 2,
+	NMIS_VECTOR_SMP_STOP,
+	NMIS_VECTOR_BT,
+	NMIS_VECTOR_KGDB,
+	NMIS_VECTOR_MCE,
+	NMIS_VECTOR_PMI,
+
+	NMIS_VECTOR_COUNT
 };
 
+/*
+ * The early (and likely all future) hardware implementations of
+ * NMI-source reporting would only support a 16-bit source bitmap, with
+ * 1-15 being valid source vectors.
+ *
+ * If the hardware ever supports a larger bitmap, the kernel support can
+ * easily be extended to 64 bits by modifying the MAX below. However,
+ * care must be taken to reallocate the latency sensitive NMI sources
+ * within the first 15 vectors. Any source vector beyond the supported
+ * maximum on prior systems would set bit 0 in the NMI-source bitmap.
+ */
+#define NMIS_VECTORS_MAX	16
+
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index d09e771723ed..4e04f13d2de9 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,7 +53,7 @@ NOKPROBE_SYMBOL(nmi_cpu_backtrace_handler);
 
 static int __init register_nmi_cpu_backtrace_handler(void)
 {
-	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_NO_SOURCE);
+	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_VECTOR_BT);
 	return 0;
 }
 early_initcall(register_nmi_cpu_backtrace_handler);
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index ba70ef8a1964..320068e01c22 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -775,7 +775,7 @@ static int __init inject_init(void)
 
 	debugfs_init();
 
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", NMIS_NO_SOURCE);
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", NMIS_VECTOR_MCE);
 	mce_register_injector_chain(&inject_nb);
 
 	setup_inj_struct(&i_mce);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index ae28fdeefc7f..dfde434d2992 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -602,7 +602,7 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", NMIS_NO_SOURCE);
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", NMIS_VECTOR_KGDB);
 	if (retval)
 		goto out1;
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index be93ec7255bf..8071ad32aa11 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -182,6 +182,13 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 	if (WARN_ON_ONCE(!action->handler || !list_empty(&action->list)))
 		return -EINVAL;
 
+	/* NMI-source reporting should only be used for NMI_LOCAL */
+	WARN_ON_ONCE((type != NMI_LOCAL) && (action->source_vector != NMIS_NO_SOURCE));
+
+	/* Check for valid vector values. See comment above NMIS_VECTORS_MAX */
+	BUILD_BUG_ON(NMIS_VECTOR_COUNT > NMIS_VECTORS_MAX);
+	WARN_ON_ONCE(action->source_vector >= NMIS_VECTOR_COUNT);
+
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/*
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index c4fffa868160..f3918888e494 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -64,7 +64,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 	unsigned long timeout;
 
 	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback, NMI_FLAG_FIRST,
-				 "nmi_selftest", NMIS_NO_SOURCE, __initdata)) {
+				 "nmi_selftest", NMIS_VECTOR_TEST, __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index c9435730dfb0..1ed065b78467 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -143,7 +143,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 static int register_stop_handler(void)
 {
 	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback, NMI_FLAG_FIRST,
-				    "smp_stop", NMIS_NO_SOURCE);
+				    "smp_stop", NMIS_VECTOR_SMP_STOP);
 }
 
 static void native_stop_other_cpus(int wait)
-- 
2.43.0


