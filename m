Return-Path: <kvm+bounces-46393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16069AB5DD8
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 893AE19E5C98
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F64E2C2ABB;
	Tue, 13 May 2025 20:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlAJxtkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDBB2C1098;
	Tue, 13 May 2025 20:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168684; cv=none; b=XtEpsoj9okjJcSdkvXcgPG8maUHu/ViXqKjK8xTRvl/oYV1NI2mYYeA1BJagJR4xTfryO5Vgqj0b3TrIFs3PYMncJkQHNn0mpMRHtUnxCU+lCF3XkytWV/AQo9po/tvjVUxGBKmaqUPd9TbcGQx1zwgLa3YeVgJFWaKXYgQAZEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168684; c=relaxed/simple;
	bh=tuP0z5QJYB3K4sZ/QOSUtwEDpmxwT+ADMb45rtxF958=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hekL7lqBPhv7wWDY6YBq//31r7dl2gRTJUsd6VzJRbRXS3lu6mL5hde+hT2MjTIW4WK5SG7jmFG+ybqJb9nDF4IYQhoBkh0AvdZox/IrPLyiQ5EOqmvFNW37uGgQZORMtjO9u0UX/lscJRh6cwosa5IjP6RROInS0zJUFtYOG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlAJxtkQ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168683; x=1778704683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tuP0z5QJYB3K4sZ/QOSUtwEDpmxwT+ADMb45rtxF958=;
  b=QlAJxtkQ2rZeu64K69LsFOV4ZSV6waPTZMecXokLN/+PaQT7G9vx1/MI
   fTpqWM66Hk+vVISZTvggnFTGCdvZX+cLl24Wa4Vz7LoTYEn2mUfkW6X6V
   mwMfqlYn77+D2Zvcl3Q8tDckIijoDJJTqIWj/sf4TQgKXptpxiOTpbXIZ
   pA4E0/YGoYpBuYcWhKIxTEOlgjNkxMFPwizRpN/jReHXEoDq+oOiJBYlZ
   jgtxaVNbiDb33d0I32Q9OtXB6sb/f4A0u37Z8WnU6zrGllBetg5cGC5oy
   178EbnfURpzpq4I2HhSIgE/9SarXkO55ne4yqIa1KVZf4orP48yf/QhlB
   w==;
X-CSE-ConnectionGUID: YZLLzq3mTjOjqhTkHQ8J5w==
X-CSE-MsgGUID: HVx6UgARTS64GM6nkYlYgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160474"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160474"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:38:00 -0700
X-CSE-ConnectionGUID: LnsfcjOvSLCJQFVQ6UcCKg==
X-CSE-MsgGUID: c3Uf+7qEQGarDivPmKTZrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241733"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:59 -0700
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
Subject: [PATCH v6 7/9] x86/nmi: Enable NMI-source for IPIs delivered as NMIs
Date: Tue, 13 May 2025 13:38:01 -0700
Message-ID: <20250513203803.2636561-8-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250513203803.2636561-1-sohil.mehta@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
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
v6: Include asm/nmi.h to avoid compile errors. (LKP)

v5: Encode APIC_DM_NMI directly with the NMI-source vector.
---
 arch/x86/include/asm/apic.h      | 8 ++++++++
 arch/x86/kernel/apic/hw_nmi.c    | 2 +-
 arch/x86/kernel/cpu/mce/inject.c | 2 +-
 arch/x86/kernel/kgdb.c           | 2 +-
 arch/x86/kernel/nmi_selftest.c   | 2 +-
 arch/x86/kernel/smp.c            | 2 +-
 6 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9c3d5932d591..99033bfb26ea 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -14,6 +14,7 @@
 #include <asm/msr.h>
 #include <asm/hardirq.h>
 #include <asm/io.h>
+#include <asm/nmi.h>
 #include <asm/posted_intr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
@@ -23,6 +24,13 @@
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


