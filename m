Return-Path: <kvm+bounces-35603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33775A12DD1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 22:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34323A594A
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 21:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607FC1DB37C;
	Wed, 15 Jan 2025 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JiJltTVI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC44156F57
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736977049; cv=none; b=HdMCNad6wiL9Z0N65LQuMwHO4IGeXaSBWoH4WO7rMLCB5PJmkTJ5RrlGMwLcDk1pVF3Nb06pSXv+s2vFw9Ju55cRyxLheWbRSdAV5HwOCG7WmxXs0VrPhJgdFl9ClSIMtiXkCXwWQrCDMkLebPADFK9Ad6mAxbAbHKY13v5zIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736977049; c=relaxed/simple;
	bh=SO4KDfuX2Azpjvm/vQCO8Mmo4hgwQHwVrIYLO67qnU0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kVRRjTLdoshEFTYKYjda5he3BOLvetAxh4fJ5CFGtXDfyTyie2+1J4Mt/vDc4jASHfoJ0M7IhXipV9RbnF25LuZPv5UpwjklfjgSW16VLSxXBiVkZ2XLSotuy1tsz36yMKXdW+PzLNZeZao9+9cVX+N3R7Bzcwq81a29D3gMT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JiJltTVI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso529373a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 13:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736977047; x=1737581847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DE03VH0L0OHrfXKwkdUHEFj5nyzfBv/0w1PnGQr0ZNI=;
        b=JiJltTVIpgTo7VeZqrhizqCZ8bVFDAivEu31NnBhkWqWsOlN2IVPhrZO7yFTry4+tg
         AsABMCRJj3h9PhJ5q3hGOW5z1WlOpjPtJ6jfAySUtMhaHc7UNjK+kOshx2fOAqAvWIrh
         8BKYDSoncPfyAYJqJbs+j/3tYOpOXox11UJoAu6oGgld5GspgHGMw4/S4lzVRyaDXojJ
         aefJajJw/r+wWATJb1ztB1g4/QlYNvdec6mKPr17LCpmR5Xo6A8Pwa+ZqF2NfrIs/nYc
         BMQH4UgQJdccMQegrPJaF/8Qq1wsNv6CTOLHf4V8ub4HiN/OO1+cX0wCD4k4f6aahv4F
         gHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736977047; x=1737581847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DE03VH0L0OHrfXKwkdUHEFj5nyzfBv/0w1PnGQr0ZNI=;
        b=ByaSSUeLpZ0AQU5ZV/e2cRfv/fT9zF3fgL4BcuqGepmjNRxleFkiVCLH2slMccs0N6
         madeOMzX4YdgMFfTzNVMrQw1m9dWgo9fmKYOcLlRhRJe1vPbRCMQUGQNm0nq3mdDeFnS
         g1HAsvOLG7zZqfyYBNmKol5oP+ZUW4guIYWKSyf7C31jaMnQ6qP1h6yjW/njx/GvQzRu
         WLkCQ1YPOLaiTe78B7OrXLUsZgcdWDQmlLY5DrzYSr4S75FIMRUfZM3AkCOy12bMeHL4
         d8zOa/+wxhfvoMOBWA3dnJ8mvTx0ePv3iXll9barklSWdYiPALW9DZa7NIHQR/FfWZQ1
         AYAA==
X-Forwarded-Encrypted: i=1; AJvYcCWWQ5AN/S1p/Y9qnHYBjR6TN9GbUDwcX2J4nHYdWS3g4lwOPTVy0U/ptUfEp/7qK61nIEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUxxnIWHFo/Mjf7nkKatUgXFzdRSX1avYOyBtj60SlDA9CGduh
	s7QxL/YuHfJkitem/lra6HGpwYbWaoI9y+XBYh4GobleCWQVmHkp6/8eT2rIOJAHVc/2VthPBNR
	kzA==
X-Google-Smtp-Source: AGHT+IEe15DAZ7eb/4a7+um2+f6w3QllKB0v/qQaTVLKeY1Vwnntxf3xKoWKAGt1rLFo53oGnaFjnWDYtlk=
X-Received: from pjwx14.prod.google.com ([2002:a17:90a:c2ce:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2642:b0:2ea:aa56:499
 with SMTP id 98e67ed59e1d1-2f548e9aed3mr40147444a91.1.1736977047223; Wed, 15
 Jan 2025 13:37:27 -0800 (PST)
Date: Wed, 15 Jan 2025 13:37:25 -0800
In-Reply-To: <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250106124633.1418972-13-nikunj@amd.com> <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com> <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com> <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com> <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com> <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
Message-ID: <Z4gqlbumOFPF_rxd@google.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com, 
	francescolavra.fl@gmail.com, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Nikunj A. Dadhania wrote:
> On 1/8/2025 10:32 PM, Sean Christopherson wrote:
> > On Wed, Jan 08, 2025, Borislav Petkov wrote:
> >> On Wed, Jan 08, 2025 at 06:00:59AM -0800, Sean Christopherson wrote:
> 
> > For TDX guests, the TSC is _always_ "secure".  So similar to singling out kvmclock,
> > handling SNP's STSC but not the TDX case again leaves the kernel in an inconsistent
> > state.  Which is why I originally suggested[*] fixing the sched_clock mess in a
> > generically; 
> > doing so would avoid the need to special case SNP or TDX in code> that doesn't/shouldn't care about SNP or TDX.
> 
> That is what I have attempted in this patch[1] where irrespective of SNP/TDX, whenever
> TSC is picked up as a clock source, sched-clock will start using TSC instead of any
> PV sched clock. This does not have any special case for STSC/SNP/TDX. 

*sigh*

This is a complete and utter trainwreck.

Paolo had an idea to handle this without a deferred callback by having kvmclock
detect if kvmclock is selected as the clocksource, OR if the TSC is unreliable,
i.e. if the kernel may switch to kvmclock due to the TSC being marked unreliable.

Unfortunately, that idea doesn't work because the ordering is all wrong.  The
*early* TSC initialization in setup_arch() happens after kvmclock_init() (via
init_hypervisor_platform())

	init_hypervisor_platform();

	tsc_early_init();

and even if we mucked with that, __clocksource_select() very deliberately doesn't
change the clocksource until the kernel is "finished" booting, in order to avoid
thrashing the clocksource.

  static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
  {
	struct clocksource *cs;

	if (!finished_booting || list_empty(&clocksource_list)) <===
		return NULL;

	...
  }


  /*
   * clocksource_done_booting - Called near the end of core bootup
   *
   * Hack to avoid lots of clocksource churn at boot time.
   * We use fs_initcall because we want this to start before
   * device_initcall but after subsys_initcall.
   */
  static int __init clocksource_done_booting(void)
  {
	mutex_lock(&clocksource_mutex);
	curr_clocksource = clocksource_default_clock();
	finished_booting = 1;
	/*
	 * Run the watchdog first to eliminate unstable clock sources
	 */
	__clocksource_watchdog_kthread();
	clocksource_select();
	mutex_unlock(&clocksource_mutex);
	return 0;
  }
  fs_initcall(clocksource_done_booting);

I fiddled with a variety of ideas to try and let kvmclock tell sched_clock that
it prefers the TSC, e.g. if TSC_RELIABLE is set, but after seeing this comment
in native_sched_clock():

	/*
	 * Fall back to jiffies if there's no TSC available:
	 * ( But note that we still use it if the TSC is marked
	 *   unstable. We do this because unlike Time Of Day,
	 *   the scheduler clock tolerates small errors and it's
	 *   very important for it to be as fast as the platform
	 *   can achieve it. )
	 */

My strong vote is prefer TSC over kvmclock for sched_clock if the TSC is constant,
nonstop, and not marked stable via command line.  I.e. use the same criteria as
tweaking the clocksource rating.  As above, sched_clock is more tolerant of slop
than clocksource, so it's a bit ridiculous to care whether the TSC or kvmclock
(or something else entirely) is used for the clocksource.

If we wanted to go with a more conservative approach, e.g. to minimize the risk
of breaking existing setups, we could also condition the change on the TSC being
reliable and having a known frequency.  I.e. require SNP's Secure TSC, or require
the hypervisor to enumerate the TSC frequency via CPUID.  I don't see a ton of
value in that approach though, and long-term it would lead to some truly weird
code due to holding sched_clock to a higher standard than clocksource.

But wait, there's more!  Because TDX doesn't override .calibrate_tsc() or
.calibrate_cpu(), even though TDX provides a trusted TSC *and* enumerates the
frequency of the TSC, unless I'm missing something, tsc_early_init() will compute
the TSC frequency using the information provided by KVM, i.e. the untrusted host.

The "obvious" solution is to leave the calibration functions as-is if the TSC has
a known, reliable frequency, but even _that_ is riddled with problems, because
as-is, the kernel sets TSC_KNOWN_FREQ and TSC_RELIABLE in tsc_early_init(), which
runs *after* init_hypervisor_platform().  SNP Secure TSC fudges around this by
overiding the calibration routines, but that's a bit gross and easy to fix if we
also fix TDX.  And fixing TDX by running native_calibrate_tsc() would give the
same love to setups where the hypervisor provides CPUID 0x15 and/or 0x16.

All in all, I'm thinking something like this (across multiple patches):

---
 arch/x86/include/asm/tsc.h |  1 +
 arch/x86/kernel/kvmclock.c | 55 ++++++++++++++++++++++++++------------
 arch/x86/kernel/setup.c    |  7 +++++
 arch/x86/kernel/tsc.c      | 32 +++++++++++++++++-----
 4 files changed, 72 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94408a784c8e..e13d6c3f2298 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -28,6 +28,7 @@ static inline cycles_t get_cycles(void)
 }
 #define get_cycles get_cycles
 
+extern void tsc_early_detect(void);
 extern void tsc_early_init(void);
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..fa6bf71cc511 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -317,33 +317,54 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+	/*
+	 * If the TSC counts at a constant frequency across P/T states, counts
+	 * in deep C-states, and the TSC hasn't been marked unstable, prefer
+	 * the TSC over kvmclock for sched_clock and drop kvmclock's rating so
+	 * that TSC is chosen as the clocksource.  Note, the TSC unstable check
+	 * exists purely to honor the TSC being marked unstable via command
+	 * line, any runtime detection of an unstable will happen after this.
+	 */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    !check_tsc_unstable()) {
+		kvm_clock.rating = 299;
+		pr_warn("kvm-clock: Using native sched_clock\n");
+	} else {
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+	}
+
+	/*
+	 * If the TSC frequency is already known, e.g. via CPUID, rely on that
+	 * information.  For "normal" VMs, the hypervisor controls kvmclock and
+	 * CPUID, i.e. the frequency is coming from the same place.  For CoCo
+	 * VMs, the TSC frequency may be provided by trusted firmware, in which
+	 * case it's highly desirable to use that information, not kvmclock's.
+	 * Note, TSC_KNOWN_FREQ must be read before presetting loops-per-jiffy,
+	 * (see kvm_get_tsc_khz()).
+	 */
+	if (!boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ) ||
+	    !boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
+		pr_warn("kvm-clock: Using native calibration\n");
+		x86_platform.calibrate_tsc = kvm_get_tsc_khz;
+		x86_platform.calibrate_cpu = kvm_get_tsc_khz;
+	}
 
-	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
-	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
 	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
 #endif
+	/*
+	 * Save/restore "sched" clock state even if kvmclock isn't being used
+	 * for sched_clock, as kvmclock is still used for wallclock and relies
+	 * on these hooks to re-enable kvmclock after suspend+resume.
+	 */
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
 	kvm_get_preset_lpj();
 
-	/*
-	 * X86_FEATURE_NONSTOP_TSC is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
-	 *
-	 * Invariant TSC exposed by host means kvmclock is not necessary:
-	 * can use TSC as clocksource.
-	 *
-	 */
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
-	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
-	    !check_tsc_unstable())
-		kvm_clock.rating = 299;
-
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f1fea506e20f..2b6800426349 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -907,6 +907,13 @@ void __init setup_arch(char **cmdline_p)
 	reserve_ibft_region();
 	x86_init.resources.dmi_setup();
 
+	/*
+	 * Detect, but do not fully initialize, TSC info before initializing
+	 * the hypervisor platform, so that hypervisor code can make informed
+	 * decisions about using a paravirt clock vs. TSC.
+	 */
+	tsc_early_detect();
+
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_setup(), for the boot CPU.
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0864b314c26a..9baffb425386 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -663,7 +663,12 @@ unsigned long native_calibrate_tsc(void)
 	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
 	unsigned int crystal_khz;
 
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+	/*
+	 * Ignore the vendor when running as a VM, if the hypervisor provides
+	 * garbage CPUID information then the vendor is also suspect.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
+	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return 0;
 
 	if (boot_cpu_data.cpuid_level < 0x15)
@@ -713,10 +718,13 @@ unsigned long native_calibrate_tsc(void)
 		return 0;
 
 	/*
-	 * For Atom SoCs TSC is the only reliable clocksource.
-	 * Mark TSC reliable so no watchdog on it.
+	 * For Atom SoCs TSC is the only reliable clocksource.  Similarly, in a
+	 * VM, any watchdog is going to be less reliable than the TSC as the
+	 * watchdog source will be emulated in software.  In both cases, mark
+	 * the TSC reliable so that no watchdog runs on it.
 	 */
-	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||
+	    boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -1509,6 +1517,20 @@ static void __init tsc_enable_sched_clock(void)
 	static_branch_enable(&__use_tsc);
 }
 
+void __init tsc_early_detect(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_TSC))
+		return;
+
+	snp_secure_tsc_init();
+
+	/*
+	 * Run through native TSC calibration to set TSC_KNOWN_FREQ and/or
+	 * TSC_RELIABLE as appropriate.
+	 */
+	native_calibrate_tsc();
+}
+
 void __init tsc_early_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_TSC))
@@ -1517,8 +1539,6 @@ void __init tsc_early_init(void)
 	if (is_early_uv_system())
 		return;
 
-	snp_secure_tsc_init();
-
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();

base-commit: 0563ee35ae2c9cfb0c6a7b2c0ddf7d9372bb8a98
-- 

