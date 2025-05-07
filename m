Return-Path: <kvm+bounces-45684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38595AAD2BD
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4324D985CB2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9461D63EF;
	Wed,  7 May 2025 01:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIuQwTC6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAC3198E8C;
	Wed,  7 May 2025 01:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580891; cv=none; b=WXoJD3Xa3MYD9dHpWWF/6zIxr+uOaGbJroFgNdynNjyfQVagnFsNS+zLQzLF738om6rjLTdeEYWqWDG7jPSK82CsA4BfCc2FvUjfjQbjB5Q9/JsW38/2XAXX5ISK4Nw5OKL3vuMSNidspvu0mVC/J5+XNFAkYo2B770rGLtNxUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580891; c=relaxed/simple;
	bh=HNUxDNxmsA35a4yq3ONufJvC11cN0f1ZFby/QdJGW4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzQRYszhUNNAapDvzThXfPxNYVbVNPKqwZjilXG3J0JLi+NNupfoUQsRi2o03pgRIrnLnSkgu2NDAkrU0PvcUOfOl7IFyFoLEGyIYq8iZrauqpm6ZM2SHLuoRr+XjG9VRIiRRwLfpeyP769llTtDyeg71haiEmt8OmiZcM9fyrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIuQwTC6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580889; x=1778116889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HNUxDNxmsA35a4yq3ONufJvC11cN0f1ZFby/QdJGW4I=;
  b=YIuQwTC69qsKEL2if1pHhkB5uyCGEULjMTE9IWyAKMtyfll5VH+7jyBc
   IGruUaqQmhfluXd90htpdU6cAmy5l6oDXYp3E8pgFSJtdmBrAydgXx5pK
   dL6XIPcuIVgXH88dpw8uTfOINO9nOUQ4IslUDRSR4uF1YfJtwDNbeqx/t
   AVu01c5Ufj5LmYo/wG16BqOb4kVsiW2PR3RNCRY+9xiMPebXq2Apuf3W1
   D8+UsDTgBEufN1LYTSP/qOTsee+SrVUXK0vRUIM996AZBXL1zN4BgrgQc
   UTVtxT4qW4W3gawhU2Ig+me29ns/37PssealF8Io67r0rkBN+OmnQf5lx
   Q==;
X-CSE-ConnectionGUID: aQYwmjmyTr6PtolaVNMP0g==
X-CSE-MsgGUID: EZTCZw31S4KIuTli0BeEfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47384004"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47384004"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:27 -0700
X-CSE-ConnectionGUID: 5GUH4ti5TgiOcIHmQG8y+g==
X-CSE-MsgGUID: 8OXM08jjRIiFFSaVP10Vyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808757"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:26 -0700
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
Subject: [PATCH v5 7/9] x86/nmi: Enable NMI-source for IPIs delivered as NMIs
Date: Tue,  6 May 2025 18:21:43 -0700
Message-ID: <20250507012145.2998143-8-sohil.mehta@intel.com>
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

With the IPI handling APIs ready to support the new NMI encoding, encode
the NMI delivery mode directly with the NMI-source vectors to trigger
NMIs.

Move most of the existing NMI-based IPIs to use the new NMI-source
vectors, except for the microcode rendezvous NMI and the crash reboot
NMI. NMI handling for them is special-cased in exc_nmi() and does not
need NMI-source reporting.

However, in the future, it might be useful to assign a source vector to
all NMI sources to improve isolation and debuggability.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Encode APIC_DM_NMI directly with the NMI-source vector.
---
 arch/x86/include/asm/apic.h      | 7 +++++++
 arch/x86/kernel/apic/hw_nmi.c    | 2 +-
 arch/x86/kernel/cpu/mce/inject.c | 2 +-
 arch/x86/kernel/kgdb.c           | 2 +-
 arch/x86/kernel/nmi_selftest.c   | 2 +-
 arch/x86/kernel/smp.c            | 2 +-
 6 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 11a3f88518fa..9bade39b5feb 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -23,6 +23,13 @@
 #define APIC_EXTNMI_ALL		1
 #define APIC_EXTNMI_NONE	2
 
+/* Trigger NMIs with source information */
+#define TEST_NMI		(APIC_DM_NMI | NMIS_VECTOR_TEST)
+#define SMP_STOP_NMI		(APIC_DM_NMI | NMIS_VECTOR_SMP_STOP)
+#define BT_NMI			(APIC_DM_NMI | NMIS_VECTOR_BT)
+#define KGDB_NMI		(APIC_DM_NMI | NMIS_VECTOR_KGDB)
+#define MCE_NMI			(APIC_DM_NMI | NMIS_VECTOR_MCE)
+
 /*
  * Debugging macros
  */
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 4e04f13d2de9..586f4b25feae 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -33,7 +33,7 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
 #ifdef arch_trigger_cpumask_backtrace
 static void nmi_raise_cpu_backtrace(cpumask_t *mask)
 {
-	__apic_send_IPI_mask(mask, NMI_VECTOR);
+	__apic_send_IPI_mask(mask, BT_NMI);
 }
 
 void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu)
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index a3c753dfce91..6328a607ffc4 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -269,7 +269,7 @@ static void __maybe_unused raise_mce(struct mce *m)
 					mce_irq_ipi, NULL, 0);
 				preempt_enable();
 			} else if (m->inject_flags & MCJ_NMI_BROADCAST)
-				__apic_send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
+				__apic_send_IPI_mask(mce_inject_cpumask, MCE_NMI);
 		}
 		start = jiffies;
 		while (!cpumask_empty(mce_inject_cpumask)) {
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 9ca4b141da0c..3dedc5f57541 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -416,7 +416,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
  */
 void kgdb_roundup_cpus(void)
 {
-	apic_send_IPI_allbutself(NMI_VECTOR);
+	apic_send_IPI_allbutself(KGDB_NMI);
 }
 #endif
 
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 5196023b31dc..c5c91f520c69 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -71,7 +71,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 	/* sync above data before sending NMI */
 	wmb();
 
-	__apic_send_IPI_mask(mask, NMI_VECTOR);
+	__apic_send_IPI_mask(mask, TEST_NMI);
 
 	/* Don't wait longer than a second */
 	timeout = USEC_PER_SEC;
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 5be1c0bdf901..614acec5655f 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -217,7 +217,7 @@ static void native_stop_other_cpus(int wait)
 			pr_emerg("Shutting down cpus with NMI\n");
 
 			for_each_cpu(cpu, &cpus_stop_mask)
-				__apic_send_IPI(cpu, NMI_VECTOR);
+				__apic_send_IPI(cpu, SMP_STOP_NMI);
 		}
 		/*
 		 * Don't wait longer than 10 ms if the caller didn't
-- 
2.43.0


