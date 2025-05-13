Return-Path: <kvm+bounces-46389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B18AB5DC8
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59B9919E4705
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC992C1082;
	Tue, 13 May 2025 20:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JE01mFch"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89C1F3FD0;
	Tue, 13 May 2025 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168681; cv=none; b=m9fsoiOxyKX1Ze3aorC/tiNjnO67PlUdBBmJLglz8M3OCG06EeIKqQWQzlhfZvbogSNlHpcqnPnL/OgBiSyAYqrZ/7ZDCf6hWQNy51s/JuwjRy12vM7KN6rMx9K4n5SgrNFzO3tQL+d8iqZPGSeTHaqNVl+yHe0ftTVV/w1X7II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168681; c=relaxed/simple;
	bh=bf4f0FtErss0et6pnp0FJf7srNyY2MRbqPiZKdJRnTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxjFI57nxk3U/WS1LksxPjx0IlSeNYytd41L9eTOx0Zmi7mnM+8tU/q2DbABSS1mP78QMeevdsOptYdSnT5M3hrHdAuCK1Rq9N34islWhf3geGblibOtbZogLh2b7n0ih6wKve3gKQSKUA5NI6UG+1wpxhgnUshuhzgfgcGgQRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JE01mFch; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168679; x=1778704679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bf4f0FtErss0et6pnp0FJf7srNyY2MRbqPiZKdJRnTI=;
  b=JE01mFchDDsEb7Jgd72qw/mV2l08ZVhR2Qk78St/57AMXx+1AoyLbbSq
   EGLT/7jFY2Yx8CUViwOUCmiTR5lRNrr+qQXDYz58UtZNN2C7x/vjxNhLE
   ZzalUeRDP+miZmbFDmm4v8sg8uC/w0GRKYtmcccnL9K+h1Ttg43s+Tvvf
   /4smuXYW8Tuivm2jg8jG4zwbJFi5YxWckEtGPDwnWDiCgZuWqgt5+yeMH
   iflt7c8vZHfM9Jl23Y9UW1Pp357q35G2KAzwYXl9gIEB/TUaLGQUuYt7D
   zvZe0iStyhEJ3pjCBFhLCf6xBhua4GsooByLk6NHCrADZUPoGVjtE49e+
   w==;
X-CSE-ConnectionGUID: 7uRMoZjGRL6bBA9ZgS3bVQ==
X-CSE-MsgGUID: Os+mriFyQbqJAnPAfqclug==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160423"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160423"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:37:57 -0700
X-CSE-ConnectionGUID: Ttt9udV+ROufOEwJY9P0VA==
X-CSE-MsgGUID: gc+tCI4lRJuPJsW+uHIbkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241721"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:57 -0700
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
Subject: [PATCH v6 3/9] x86/nmi: Extend the registration interface to include the NMI-source vector
Date: Tue, 13 May 2025 13:37:57 -0700
Message-ID: <20250513203803.2636561-4-sohil.mehta@intel.com>
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

To prepare for NMI-source reporting, add a source vector argument to the
NMI handler registration interface. Later, this will be used to
register NMI handlers with a unique source vector that can be used to
identify the originator of the NMI.

For now, just extend the interface and pass zero as the source vector
for all handlers. No functional change intended.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v6: No change.

v5: Split the patch into two parts. This one only extends the interface.
---
 arch/x86/events/amd/ibs.c         | 2 +-
 arch/x86/events/core.c            | 2 +-
 arch/x86/include/asm/nmi.h        | 5 ++++-
 arch/x86/kernel/apic/hw_nmi.c     | 3 +--
 arch/x86/kernel/cpu/mce/inject.c  | 2 +-
 arch/x86/kernel/cpu/mshyperv.c    | 3 +--
 arch/x86/kernel/kgdb.c            | 6 ++----
 arch/x86/kernel/nmi_selftest.c    | 7 +++----
 arch/x86/kernel/smp.c             | 4 ++--
 arch/x86/platform/uv/uv_nmi.c     | 4 ++--
 drivers/acpi/apei/ghes.c          | 2 +-
 drivers/char/ipmi/ipmi_watchdog.c | 3 +--
 drivers/edac/igen6_edac.c         | 3 +--
 drivers/watchdog/hpwdt.c          | 6 +++---
 14 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 0252b7ea8bca..45dece8bee84 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1486,7 +1486,7 @@ static __init int perf_event_ibs_init(void)
 	if (ret)
 		goto err_op;
 
-	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs");
+	ret = register_nmi_handler(NMI_LOCAL, perf_ibs_nmi_handler, 0, "perf_ibs", 0);
 	if (ret)
 		goto err_nmi;
 
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 6866cc5acb0b..b84b8be1f075 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2115,7 +2115,7 @@ static int __init init_hw_perf_events(void)
 		x86_pmu.config_mask = X86_RAW_EVENT_MASK;
 
 	perf_events_lapic_init();
-	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI");
+	register_nmi_handler(NMI_LOCAL, perf_event_nmi_handler, 0, "PMI", 0);
 
 	unconstrained = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, x86_pmu.cntr_mask64,
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 79d88d12c8fb..f0a577bf7bba 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,6 +54,7 @@ struct nmiaction {
 	u64			max_duration;
 	unsigned long		flags;
 	const char		*name;
+	u8			source_vector;
 };
 
 /**
@@ -62,6 +63,7 @@ struct nmiaction {
  * @fn:   The NMI handler
  * @fg:   Flags associated with the NMI handler
  * @n:    Name of the NMI handler
+ * @src:  NMI-source based vector for the NMI handler
  * @init: Optional __init* attributes for struct nmiaction
  *
  * Adds the provided handler to the list of handlers for the specified
@@ -75,13 +77,14 @@ struct nmiaction {
  *
  * Return: 0 on success, or an error code on failure.
  */
-#define register_nmi_handler(t, fn, fg, n, init...)	\
+#define register_nmi_handler(t, fn, fg, n, src, init...)	\
 ({							\
 	static struct nmiaction init fn##_na = {	\
 		.list = LIST_HEAD_INIT(fn##_na.list),	\
 		.handler = (fn),			\
 		.name = (n),				\
 		.flags = (fg),				\
+		.source_vector = (src),			\
 	};						\
 	__register_nmi_handler((t), &fn##_na);		\
 })
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 45af535c44a0..612b77660d05 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,8 +53,7 @@ NOKPROBE_SYMBOL(nmi_cpu_backtrace_handler);
 
 static int __init register_nmi_cpu_backtrace_handler(void)
 {
-	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler,
-				0, "arch_bt");
+	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_bt", 0);
 	return 0;
 }
 early_initcall(register_nmi_cpu_backtrace_handler);
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 06e3cf7229ce..17804ba0b02f 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -774,7 +774,7 @@ static int __init inject_init(void)
 
 	debugfs_init();
 
-	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify");
+	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify", 0);
 	mce_register_injector_chain(&inject_nb);
 
 	setup_inj_struct(&i_mce);
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 3e2533954675..d643d6fb3cfa 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -548,8 +548,7 @@ static void __init ms_hyperv_init_platform(void)
 			lapic_timer_period);
 	}
 
-	register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST,
-			     "hv_nmi_unknown");
+	register_nmi_handler(NMI_UNKNOWN, hv_nmi_unknown, NMI_FLAG_FIRST, "hv_nmi_unknown", 0);
 #endif
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 9c9faa1634fb..ab2d1b79b79e 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -602,13 +602,11 @@ int kgdb_arch_init(void)
 	if (retval)
 		goto out;
 
-	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_LOCAL, kgdb_nmi_handler, 0, "kgdb", 0);
 	if (retval)
 		goto out1;
 
-	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler,
-					0, "kgdb");
+	retval = register_nmi_handler(NMI_UNKNOWN, kgdb_nmi_handler, 0, "kgdb", 0);
 
 	if (retval)
 		goto out2;
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index a010e9d062bf..b203e4371816 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -40,8 +40,7 @@ static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 static void __init init_nmi_testsuite(void)
 {
 	/* trap all the unknown NMIs we may generate */
-	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
-			__initdata);
+	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk", 0, __initdata);
 }
 
 static void __init cleanup_nmi_testsuite(void)
@@ -63,8 +62,8 @@ static void __init test_nmi_ipi(struct cpumask *mask)
 {
 	unsigned long timeout;
 
-	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
-				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
+	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback, NMI_FLAG_FIRST,
+				 "nmi_selftest", 0, __initdata)) {
 		nmi_fail = FAILURE;
 		return;
 	}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18266cc3d98c..b80812aa06c3 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -142,8 +142,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 
 static int register_stop_handler(void)
 {
-	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-				    NMI_FLAG_FIRST, "smp_stop");
+	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback, NMI_FLAG_FIRST, "smp_stop",
+				    0);
 }
 
 static void native_stop_other_cpus(int wait)
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 5c50e550ab63..473c34eb264c 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -1029,10 +1029,10 @@ static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 
 static void uv_register_nmi_notifier(void)
 {
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv", 0))
 		pr_warn("UV: NMI handler failed to register\n");
 
-	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping", 0))
 		pr_warn("UV: PING NMI handler failed to register\n");
 }
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b72772494655..95bd3a64608f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1318,7 +1318,7 @@ static void ghes_nmi_add(struct ghes *ghes)
 {
 	mutex_lock(&ghes_list_mutex);
 	if (list_empty(&ghes_nmi))
-		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes", 0);
 	list_add_rcu(&ghes->list, &ghes_nmi);
 	mutex_unlock(&ghes_list_mutex);
 }
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f1875b2bebbc..5db402c4b9e7 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1267,8 +1267,7 @@ static void check_parms(void)
 		}
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0,
-						"ipmi");
+		rv = register_nmi_handler(NMI_UNKNOWN, ipmi_nmi, 0, "ipmi", 0);
 		if (rv) {
 			pr_warn("Can't register nmi handler\n");
 			return;
diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 5807517ee32d..3a6e7334e94c 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1363,8 +1363,7 @@ static int register_err_handler(void)
 		return 0;
 	}
 
-	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler,
-				  0, IGEN6_NMI_NAME);
+	rc = register_nmi_handler(NMI_SERR, ecclog_nmi_handler, 0, IGEN6_NMI_NAME, 0);
 	if (rc) {
 		igen6_printk(KERN_ERR, "Failed to register NMI handler\n");
 		return rc;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ae30e394d176..5246706afcf6 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -242,13 +242,13 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	/*
 	 * Only one function can register for NMI_UNKNOWN
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error;
-	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error1;
-	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
+	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt", 0);
 	if (retval)
 		goto error2;
 
-- 
2.43.0


