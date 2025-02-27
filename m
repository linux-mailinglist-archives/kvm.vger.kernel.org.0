Return-Path: <kvm+bounces-39519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E46A472D4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89E56188A79B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E07022FDE0;
	Thu, 27 Feb 2025 02:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vimbu3KW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E0190470
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622799; cv=none; b=MndOGa83TESvqfBgn4H8H5+LHtCZ/XD4ul5gBpMXvwc9oWqE8X6wYjXegC4w48Z5SI0c4oCKFdOOdgCtqkHruCaDUJxdxefb6mpWcfVmkzKzALp6eHwhSiVUrohMq55Xzp1oGbLv2GOo68YwjwkDF7qkGPaPnf1HT0WCRWIspm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622799; c=relaxed/simple;
	bh=FqtvTL/qyi7OYXRbCV2e1dPSPCUMJ7/F3eHsImFUkdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lOyLmI4rc0xo63hpR6hHZWMSDrwPK/k9Wy442FIPurc6XlD5ihySeRr9JtS0Q2GZWlEvGN2IrOVhfRLXjPvKheuxGKYXfqAcXntyseaK8oYfZ5cCXaXO9pNh2LiFmvPYvdYI8hSLbNWKld0Tp4PLcpg6IvRjZyestB9cSYuPxj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vimbu3KW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso1557046a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622797; x=1741227597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0SoCRyyhI3eHKNBGNMMOnftZcsartKHSJO+ab+uvDMM=;
        b=vimbu3KWwirkfvG2z+F2RLzAMf3fleQVYftgs+b88GbRCqO0+ZJb5NFWIwoFHVRkeC
         XijiXmcioM5Qv5ZUanGznotAh1C8WnFWmMXVexEQxqqncbxDAodaukOCkf+sBAslObHB
         w1EOaJZfeEL14P4v0W8lOaHrDO3a3gr7GPd7J4ng4PAUfdl9xaNSLHyAFbuvZ76CRReN
         UeWGFCwVHBzRDvJuGzxyHvCaR7RcwyWA6T5jAGu5Z1zFlXanx8wavvPI7cnpXesjrzhy
         arZDhouFi575no1HyTHRC5ehVFyltEKH2d+DSxJVMI4nyBCS1B+1ttUfewWzQapcrLjv
         XNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622797; x=1741227597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0SoCRyyhI3eHKNBGNMMOnftZcsartKHSJO+ab+uvDMM=;
        b=Y4TsqQJBGTtmGsm/9USRqNzn+oTMLOUiMYsqLaOlqagGfWVk+9kEPdofsFHvDZJ0TG
         sXpaPumYecdBh86DWR6QAPuFerCfNASQe+JpJ/Xr3N02ZCbsD1RxApDTiuCpkn6/2l/M
         98uZ3/Iqzeitfm42Njk8qIlx0/b3GoTHZ1mB1M9vFCtbOizqGqb1rPKaIBwdYW2ozLpb
         hP6PK/MMJPf7ua7b+NMlz2ZAszZby7owU9qaDJu8uilbjyF8/+z/f7ubSlcqgcCHZyLs
         o680pPohEc60lQHYCDUphQ9dBJ0pQ2CEG8ZbdqVQdh9RhyCvgwTLbM8NUnwYRjJJ+NUw
         mGVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGwQoqjV/umYI4xWJgphiEvE2pqsltUAElruqFm1g2exRafX2Bwvtig5QF6R6PTEgoIoo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6dQ53JdtJLZ8MN51Tns6eFUhtkL8u7Bls9lEPs5dRF2RAk9st
	l+mmQfnHgZtLN0cvi96MWKB6FTXHYk5NxFgFvYmpO45xMHusmCHondluUo/NVOoQrhlWh4797N5
	2BA==
X-Google-Smtp-Source: AGHT+IGBOkpo7XivcprIZNXQBr8QlNDoqFx2IFaBrMW4afTfcx1rvnIfDlcWOduAP6/zUs4HYAwvxKFyq/w=
X-Received: from pjboi12.prod.google.com ([2002:a17:90b:3a0c:b0:2fa:a101:755])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ec6:b0:2ea:696d:732f
 with SMTP id 98e67ed59e1d1-2fe692c6ba8mr15211686a91.29.1740622796750; Wed, 26
 Feb 2025 18:19:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:47 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-32-seanjc@google.com>
Subject: [PATCH v2 31/38] x86/tsc: Pass KNOWN_FREQ and RELIABLE as params to registration
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add a "tsc_properties" set of flags and use it to annotate whether the
TSC operates at a known and/or reliable frequency when registering a
paravirtual TSC calibration routine.  Currently, each PV flow manually
sets the associated feature flags, but often in haphazard fashion that
makes it difficult for unfamiliar readers to see the properties of the
TSC when running under a particular hypervisor.

The other, bigger issue with manually setting the feature flags is that
it decouples the flags from the calibration routine.  E.g. in theory, PV
code could mark the TSC as having a known frequency, but then have its
PV calibration discarded in favor of a method that doesn't use that known
frequency.  Passing the TSC properties along with the calibration routine
will allow adding sanity checks to guard against replacing a "better"
calibration routine with a "worse" routine.

As a bonus, the flags also give developers working on new PV code a heads
up that they should at least mark the TSC as having a known frequency.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/sev/core.c       |  6 ++----
 arch/x86/coco/tdx/tdx.c        |  7 ++-----
 arch/x86/include/asm/tsc.h     |  8 +++++++-
 arch/x86/kernel/cpu/acrn.c     |  4 ++--
 arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
 arch/x86/kernel/cpu/vmware.c   |  7 ++++---
 arch/x86/kernel/jailhouse.c    |  4 ++--
 arch/x86/kernel/kvmclock.c     |  4 ++--
 arch/x86/kernel/tsc.c          |  8 +++++++-
 arch/x86/xen/time.c            |  4 ++--
 10 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index dab386f782ce..29dd50552715 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3284,12 +3284,10 @@ void __init snp_secure_tsc_init(void)
 {
 	unsigned long long tsc_freq_mhz;
 
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
-	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-
 	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
 	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
 
 	tsc_register_calibration_routines(securetsc_get_tsc_khz,
-					  securetsc_get_tsc_khz);
+					  securetsc_get_tsc_khz,
+					  TSC_FREQ_KNOWN_AND_RELIABLE);
 }
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 42cdaa98dc5e..ca31560d0dd3 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -1135,14 +1135,11 @@ static unsigned long tdx_get_tsc_khz(void)
 
 void __init tdx_tsc_init(void)
 {
-	/* TSC is the only reliable clock in TDX guest */
-	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
-
 	/*
 	 * Override the PV calibration routines (if set) with more trustworthy
 	 * CPUID-based calibration.  The TDX module emulates CPUID, whereas any
 	 * PV information is provided by the hypervisor.
 	 */
-	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL);
+	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL,
+					  TSC_FREQ_KNOWN_AND_RELIABLE);
 }
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9318c74e8d13..360f47610258 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -41,8 +41,14 @@ extern int cpuid_get_cpu_freq(unsigned int *cpu_khz);
 extern void tsc_early_init(void);
 extern void tsc_init(void);
 #if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
+enum tsc_properties {
+	TSC_FREQUENCY_KNOWN	= BIT(0),
+	TSC_RELIABLE		= BIT(1),
+	TSC_FREQ_KNOWN_AND_RELIABLE = TSC_FREQUENCY_KNOWN | TSC_RELIABLE,
+};
 extern void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
-					      unsigned long (*calibrate_cpu)(void));
+					      unsigned long (*calibrate_cpu)(void),
+					      enum tsc_properties properties);
 #endif
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index 2da3de4d470e..4f2f4f7ec334 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -29,9 +29,9 @@ static void __init acrn_init_platform(void)
 	/* Install system interrupt handler for ACRN hypervisor callback */
 	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
 
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	tsc_register_calibration_routines(acrn_get_tsc_khz,
-					  acrn_get_tsc_khz);
+					  acrn_get_tsc_khz,
+					  TSC_FREQUENCY_KNOWN);
 }
 
 static bool acrn_x2apic_available(void)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 174f6a71c899..445ac3adfebc 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -421,8 +421,13 @@ static void __init ms_hyperv_init_platform(void)
 
 	if (ms_hyperv.features & HV_ACCESS_FREQUENCY_MSRS &&
 	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
-		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz);
-		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+		enum tsc_properties tsc_properties = TSC_FREQUENCY_KNOWN;
+
+		if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT)
+			tsc_properties = TSC_FREQ_KNOWN_AND_RELIABLE;
+
+		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz,
+						  tsc_properties);
 	}
 
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
@@ -525,7 +530,6 @@ static void __init ms_hyperv_init_platform(void)
 		 * is called.
 		 */
 		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, HV_EXPOSE_INVARIANT_TSC);
-		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 	}
 
 	/*
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 399cf3286a60..a3a71309214c 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -385,10 +385,10 @@ static void __init vmware_paravirt_ops_setup(void)
  */
 static void __init vmware_set_capabilities(void)
 {
+	/* TSC is non-stop and reliable even if the frequency isn't known. */
 	setup_force_cpu_cap(X86_FEATURE_CONSTANT_TSC);
 	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-	if (vmware_tsc_khz)
-		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+
 	if (vmware_hypercall_mode == CPUID_VMWARE_FEATURES_ECX_VMCALL)
 		setup_force_cpu_cap(X86_FEATURE_VMCALL);
 	else if (vmware_hypercall_mode == CPUID_VMWARE_FEATURES_ECX_VMMCALL)
@@ -417,7 +417,8 @@ static void __init vmware_platform_setup(void)
 
 		vmware_tsc_khz = tsc_khz;
 		tsc_register_calibration_routines(vmware_get_tsc_khz,
-						  vmware_get_tsc_khz);
+						  vmware_get_tsc_khz,
+						  TSC_FREQ_KNOWN_AND_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 		/* Skip lapic calibration since we know the bus frequency. */
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index b0a053692161..d73a4d0fb118 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -218,7 +218,8 @@ static void __init jailhouse_init_platform(void)
 
 	machine_ops.emergency_restart		= jailhouse_no_restart;
 
-	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc);
+	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc,
+					  TSC_FREQUENCY_KNOWN);
 
 	while (pa_data) {
 		mapping = early_memremap(pa_data, sizeof(header));
@@ -256,7 +257,6 @@ static void __init jailhouse_init_platform(void)
 	pr_debug("Jailhouse: PM-Timer IO Port: %#x\n", pmtmr_ioport);
 
 	precalibrated_tsc_khz = setup_data.v1.tsc_khz;
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 
 	pci_probe = 0;
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1dbe12ecb26e..ce676e735ced 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -199,7 +199,6 @@ void kvmclock_cpu_action(enum kvm_guest_cpu_action action)
  */
 static unsigned long kvm_get_tsc_khz(void)
 {
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	return pvclock_tsc_khz(this_cpu_pvti());
 }
 
@@ -403,7 +402,8 @@ void __init kvmclock_init(void)
 
 	kvm_sched_clock_init(stable);
 
-	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz);
+	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
+					  TSC_FREQUENCY_KNOWN);
 
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5501d76243c8..be58df4fef66 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1301,11 +1301,17 @@ static void __init check_system_tsc_reliable(void)
  */
 #if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
 void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
-				       unsigned long (*calibrate_cpu)(void))
+				       unsigned long (*calibrate_cpu)(void),
+				       enum tsc_properties properties)
 {
 	if (WARN_ON_ONCE(!calibrate_tsc))
 		return;
 
+	if (properties & TSC_FREQUENCY_KNOWN)
+		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	if (properties & TSC_RELIABLE)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+
 	x86_platform.calibrate_tsc = calibrate_tsc;
 	if (calibrate_cpu)
 		x86_platform.calibrate_cpu = calibrate_cpu;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 13e5888c4501..4de06ea55397 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -40,7 +40,6 @@ static unsigned long xen_tsc_khz(void)
 	struct pvclock_vcpu_time_info *info =
 		&HYPERVISOR_shared_info->vcpu_info[0].time;
 
-	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	return pvclock_tsc_khz(info);
 }
 
@@ -571,7 +570,8 @@ static void __init xen_init_time_common(void)
 	 */
 	paravirt_set_sched_clock(xen_sched_clock, NULL, NULL);
 
-	tsc_register_calibration_routines(xen_tsc_khz, NULL);
+	tsc_register_calibration_routines(xen_tsc_khz, NULL,
+					  TSC_FREQUENCY_KNOWN);
 	x86_platform.get_wallclock = xen_get_wallclock;
 }
 
-- 
2.48.1.711.g2feabab25a-goog


