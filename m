Return-Path: <kvm+bounces-45681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 565C7AAD2B0
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDDCF7B6F01
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DDE1A8F84;
	Wed,  7 May 2025 01:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="il9tdp5s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5B15382E;
	Wed,  7 May 2025 01:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580888; cv=none; b=MF6fV+tNFf9s5IB4fUO/LT+tF55rJT3hZYIFKQ3Yli9NnU53T+BojX8AY30dtYSQRVl/0B+JMVd30amtqojBkFSgvxtN7UbAFqQzdErHpYn6mmHzQ5wBlf2NiYfTk7VdDWu1PMDZfTRr6FF4WLSqiCMAHCuRooVhnzxmtOihZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580888; c=relaxed/simple;
	bh=daPGJ5R44PQLscMXj4Gprs5BHzZ9Y/l0zAfru9/D5Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzH88kzpAn+wuIq6KipGulvbg0v4zBARzvFTfBJndaCcXm1b20jSdUWWJBGR6R5QSTVV7io2uUIq3025fHzQIN68hkS5r6SE8SydbOGceKVaJ6e/p42VTzVm8H6OEA/+lRPM2+iZ8bZ8BzhbNeLsmik/nB3R2xq9mShR3dRwRMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=il9tdp5s; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580887; x=1778116887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=daPGJ5R44PQLscMXj4Gprs5BHzZ9Y/l0zAfru9/D5Cg=;
  b=il9tdp5sL5VP0X0jcJhhJ0Np9eNAKqIbiNVtP+82m+cyxcsC8kAzRIsV
   sH+o4Qcmt++0Yobo+LDd/j4UAwQniVDSEf0biMUbzMvzeOzcpTFyaehFU
   vn/77aYtUZ9HJzm1Ge3ag1q85LdYv1WXU/fwmSQJUCEdRTk3NHh2xLd0Q
   ir4/DgKyeymemdJpvUrCohGt7OhzXUtqEWqJcCLqB48swPYgQyrmaf6l5
   mfw0v9WNCepmR8iP3vSfk1nc/V4F2IUop2HHT0CUeTVnfa+lcFhpYYaJO
   U0bZJQbpgsqQ7XBIniaZ1GJZ3ck0u6F+ltLeKH0YZae1B1uSkRVVk0qEY
   Q==;
X-CSE-ConnectionGUID: ziQiP1BsSFm6/6wVuzp3Qg==
X-CSE-MsgGUID: R7JdWcGTSuuVhmX9ZE0Ieg==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383955"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383955"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:24 -0700
X-CSE-ConnectionGUID: cF8R8+Y1R++6iI23nJSppg==
X-CSE-MsgGUID: H5D8vTx8Qh2s1kOPfhFk0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808748"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:23 -0700
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
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 4/9] x86/nmi: Assign and register NMI-source vectors
Date: Tue,  6 May 2025 18:21:40 -0700
Message-ID: <20250507012145.2998143-5-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250507012145.2998143-1-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prior to NMI-source support, the vector information was ignored by the
hardware while delivering NMIs. With NMI-source, the architecture
currently supports a 16-bit source bitmap to identify the source of the
NMI. Upon receiving an NMI, this bitmap is delivered as part of the FRED
event delivery mechanism to the kernel.

Assign a vector space of 0-15 that is specific to NMI-source and
independent of the IDT vector space of 0-255. Being a bitmap, the
NMI-source vectors do not have any inherent priority associated with
them. The order of executing the NMI handlers is up to the kernel.

Existing NMI handling already has a priority mechanism for the NMI
handlers, with CPU-specific (NMI_LOCAL) handlers executed first,
followed by platform NMI handlers and unknown NMI (NMI_UNKNOWN) handlers
being last. Within each of these NMI types, the handlers registered with
NMI_FLAG_FIRST are given priority.

NMI-source follows the same priority scheme to avoid unnecessary
complexity. Therefore, the NMI-source vectors are assigned arbitrarily,
except for vectors 0 and 2.

Vector 0 is set by the hardware whenever a source vector was not used
while generating an NMI or the originator could not be reliably
identified. Do not assign it to any handler.

Vector 2 is reserved for external NMIs corresponding to Local APIC -
LINT1. Some third-party chipsets may send NMI messages with a hardcoded
vector of 2, which would result in vector 2 being set in the NMI-source
bitmap. To avoid confusion, do not assign vector 2 to any handler.

NMI-source vectors are only assigned for NMI_LOCAL type handlers.
Platform NMI handlers have a single handler registered per type. They
don't need additional source information to differentiate among them.

Use the assigned vectors to register the respective NMI handlers. A
couple of NMI handlers, such as the microcode rendezvous and the crash
reboot, do not use the typical NMI registration interface. Leave them
as-is for now.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Move the vector defines to nmi.h.
    Combine vector allocation and registration into one patch.
    Simplify NMI vector names.
    Describe usage of vector 2 for external NMIs.
    Get rid of vector priorities.
---
 arch/x86/events/core.c           |  2 +-
 arch/x86/include/asm/nmi.h       | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/hw_nmi.c    |  2 +-
 arch/x86/kernel/cpu/mce/inject.c |  2 +-
 arch/x86/kernel/kgdb.c           |  2 +-
 arch/x86/kernel/nmi.c            |  5 +++++
 arch/x86/kernel/nmi_selftest.c   |  2 +-
 arch/x86/kernel/smp.c            |  2 +-
 8 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index b84b8be1f075..031e908f0d61 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2115,7 +2115,7 @@ static int __init init_hw_perf_events(void)
 		x86_pmu.config_mask = X86_RAW_EVENT_MASK;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", 0);
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", NMIS_VECTOR_PMI);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, x86_pmu.cntr_mask64,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index f0a577bf7bba..b9beb216f2d0 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -57,6 +57,38 @@ struct nmiaction {
 	u8			source_vector;
 };
 
+/**
+ * NMI-source vectors are used to identify the origin of an NMI and to
+ * route the NMI directly to the appropriate handler.
+ *
+ * On CPUs that support NMI-source reporting with FRED, receiving an NMI
+ * with a valid vector sets the corresponding bit in the NMI-source
+ * bitmap. The bitmap is delivered as FRED event data on the stack.
+ * Multiple NMIs are coalesced in the NMI-source bitmap until the next
+ * NMI delivery.
+ *
+ * If an NMI is received without a vector or beyond the defined range,
+ * the CPU sets bit 0 of the NMI-source bitmap.
+ *
+ * Vector 2 is reserved for external NMIs related to the Local APIC -
+ * LINT1. Some third-party chipsets may send NMI messages with a
+ * hardcoded vector of 2, which would result in bit 2 being set in the
+ * NMI-source bitmap.
+ *
+ * The vectors are in no particular priority order. Add new vector
+ * assignments sequentially in the list below.
+ */
+#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sources */
+#define NMIS_VECTOR_TEST	1	/* NMI selftest */
+#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector 2 */
+#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
+#define NMIS_VECTOR_BT		4	/* CPU backtrace */
+#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
+#define NMIS_VECTOR_MCE		6	/* MCE injection */
+#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
+
+#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */
+
 /**
  * register_nmi_handler - Register a handler for a specific NMI type
  * @t:    NMI type (e.g. NMI_LOCAL)
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 612b77660d05..4e04f13d2de9 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,7 +53,7 @@ NOKPROBE_SYMBOL(nmi_cpu_backtrace_handler);
 
 static int __init register_nmi_cpu_backtrace_handler(void)
 {
-	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", 0);
+	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", NMIS_VECTOR_BT);
 	return 0;
 }
 early_initcall(register_nmi_cpu_backtrace_handler);
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 17804ba0b02f..a3c753dfce91 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -774,7 +774,7 @@ static int __init inject_init(void)
 
 	debugfs_init();
 
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", 0);
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", NMIS_VECTOR_MCE);
 	mce_register_injector_chain(&inject_nb);
 
 	setup_inj_struct(&i_mce);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index ab2d1b79b79e..9ca4b141da0c 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -602,7 +602,7 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", 0);
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", NMIS_VECTOR_KGDB);
 	if (retval)
 		goto out1;
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index be93ec7255bf..a1d672dcb6f0 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -184,6 +184,11 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
+	WARN_ON_ONCE(action->source_vector >= NMIS_VECTORS_MAX);
+
+	if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) || type != NMI_LOCAL)
+		action->source_vector = 0;
+
 	/*
 	 * Indicate if there are multiple registrations on the
 	 * internal NMI handler call chains (SERR and IO_CHECK).
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index b203e4371816..5196023b31dc 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -63,7 +63,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 	unsigned long timeout;
 
 	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback, NMI_FLAG_FIRST,
-				 "nmi_selftest", 0, __initdata)) {
+				 "nmi_selftest", NMIS_VECTOR_TEST, __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b80812aa06c3..5be1c0bdf901 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -143,7 +143,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 static int register_stop_handler(void)
 {
 	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback, NMI_FLAG_FIRST, "smp_stop",
-				    0);
+				    NMIS_VECTOR_SMP_STOP);
 }
 
 static void native_stop_other_cpus(int wait)
-- 
2.43.0


