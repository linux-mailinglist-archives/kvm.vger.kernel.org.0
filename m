Return-Path: <kvm+bounces-39491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB801A4722C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23FB13B2979
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A45C1B4227;
	Thu, 27 Feb 2025 02:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y4kztwTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A571AF0C5
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622750; cv=none; b=WdENPH2s2+NUxS++e6y1j4aPLSKQ4QsPp6HPIiD2wOkGMoJPBNvsuaoM6QLI5w6XtUhASivwRJ8W5q1J90Ga0oBPazGH0Wu0/DOSKRFFIBKlAsrqCe4m53bXxCMpdQLZRBqgrM+AW2rVAKT7jYJ1udarfd+pkcRlmHWik9fSuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622750; c=relaxed/simple;
	bh=CRD6OYeqn6lfXavNqHsH0zbcrohxH95CePzgJTbqoqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X3ARApN2fnKtw0Ch0q1Tvks800VowGsQgdhUvt59D9pQU8O8tnryi222OpFgFHPZqK6o6KT7O4rMcG1G7+CC2CUr6AeMAIrtIeacYWu16sNfUZl+kvGIf5LvvbZ559Ej4+PXZn7MBZ/t8qDlNAPZ/bGp+VW5pJdUftZy1c+JCmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y4kztwTW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f816a85facso1036085a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622748; x=1741227548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VvDX2+gOZciJHv0b670CNF4YevTYL2569oCfzMxNGMY=;
        b=y4kztwTWlstfeCIGCjXiC1tJ8K5F8ZDfCth+sTY4INMoviIwl6zHL1cJr/+F5tSTyi
         ci6jusT5E7cWUg2VQpv4lsCUnTZtMy/vhapuQ7o+vsoD/9/AmszcuhWYRXBATZPG+feZ
         SVZsVrzYHCVJ2GlHbKaSdrUhcFGjlyhVViYopwDV0V/6bhKXzUlZSq3xsm5kCKVsSA31
         JU1Ul/80M4tFKXqx859DKFQnh8tUaj3DkNSEGp2WSty+3IB3WJEch1aO2YjCxYur0BXv
         3eVLEtAuom23Sn6p92pDeGL6oYd9s1kzDw3bovq4F6aBKnhW/WN86NJZfz2NwFvTg7C7
         Uq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622748; x=1741227548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VvDX2+gOZciJHv0b670CNF4YevTYL2569oCfzMxNGMY=;
        b=lUm4S85f5AxXtML9V/FMQKs8M32O0Ari3q+ObrzWg70R+orxRgv92zRf5YjRC3TlYU
         w4DGXXuKxYsHugrzrOPjcKHh951EwkJTnsC5vkRpoGYtAQ6sCqZrm0dwQUbMh1p/gSOQ
         tB+2W01droGhgBw3hfwwdkUSTZf8auzNn0NKMxYQUX5R7jslV9azD3g5prVExH2d7OZv
         sLWXDAtZLM5fblFfAAMV3vuAq9J+5p82zzZVOUw2916bLD8xnXLAyjlLak/5reverzSZ
         qXhw/YcSO4+x1FasZQJbht2dQDscf10MhnMrxvU2zGCRjCDie8lZdFrYpR0Y/TGG1cOF
         8bcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJFMOFNyiP6kvVVVNNxL9N+Q94xRZ1C2JBYbh4p/G7wVDjlHsxeFWD2ZKJoZytxnCajsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLo+lehXlp2AIWwBDG8nky39e6Dy+R+NMdmQ19+L01j/3f27c
	H65gKQSgYF5xiUyXMgpvFN2GHf8KCXUqlz7aOwsvdb2TAeKaihO2tlPv0jXz98D18nZFI8FOUkS
	CLQ==
X-Google-Smtp-Source: AGHT+IFmK8jVkmb1xHfpVWU6EZoqjhev83fKG44NRMRJnNlywOI5c93DmBzKNvUnwRZS9xQkuc4Cdr3SCGs=
X-Received: from pjbsz5.prod.google.com ([2002:a17:90b:2d45:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5148:b0:2ee:c9b6:4c42
 with SMTP id 98e67ed59e1d1-2fce86cf0ebmr41779532a91.16.1740622748050; Wed, 26
 Feb 2025 18:19:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:19 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-4-seanjc@google.com>
Subject: [PATCH v2 03/38] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
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

Add a helper to register non-native, i.e. PV and CoCo, CPU and TSC
frequency calibration routines.  This will allow consolidating handling
of common TSC properties that are forced by hypervisor (PV routines),
and will also allow adding sanity checks to guard against overriding a
TSC calibration routine with a routine that is less robust/trusted.

Make the CPU calibration routine optional, as Xen (very sanely) doesn't
assume the CPU runs as the same frequency as the TSC.

Wrap the helper in an #ifdef to document that the kernel overrides
the native routines when running as a VM, and to guard against unwanted
usage.  Add a TODO to call out that AMD_MEM_ENCRYPT is a mess and doesn't
depend on HYPERVISOR_GUEST because it gates both guest and host code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/sev/core.c       |  4 ++--
 arch/x86/include/asm/tsc.h     |  4 ++++
 arch/x86/kernel/cpu/acrn.c     |  4 ++--
 arch/x86/kernel/cpu/mshyperv.c |  3 +--
 arch/x86/kernel/cpu/vmware.c   |  4 ++--
 arch/x86/kernel/jailhouse.c    |  4 ++--
 arch/x86/kernel/kvmclock.c     |  4 ++--
 arch/x86/kernel/tsc.c          | 17 +++++++++++++++++
 arch/x86/xen/time.c            |  2 +-
 9 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 82492efc5d94..684cef70edc1 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3291,6 +3291,6 @@ void __init snp_secure_tsc_init(void)
 	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
 	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
 
-	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
-	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+	tsc_register_calibration_routines(securetsc_get_tsc_khz,
+					  securetsc_get_tsc_khz);
 }
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index c3a14df46327..9318c74e8d13 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -40,6 +40,10 @@ extern int cpuid_get_cpu_freq(unsigned int *cpu_khz);
 
 extern void tsc_early_init(void);
 extern void tsc_init(void);
+#if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
+extern void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
+					      unsigned long (*calibrate_cpu)(void));
+#endif
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index 2c5b51aad91a..c1506cb87d8c 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -29,8 +29,8 @@ static void __init acrn_init_platform(void)
 	/* Install system interrupt handler for ACRN hypervisor callback */
 	sysvec_install(HYPERVISOR_CALLBACK_VECTOR, sysvec_acrn_hv_callback);
 
-	x86_platform.calibrate_tsc = acrn_get_tsc_khz;
-	x86_platform.calibrate_cpu = acrn_get_tsc_khz;
+	tsc_register_calibration_routines(acrn_get_tsc_khz,
+					  acrn_get_tsc_khz);
 }
 
 static bool acrn_x2apic_available(void)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index f285757618fc..aa60491bf738 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -478,8 +478,7 @@ static void __init ms_hyperv_init_platform(void)
 
 	if (ms_hyperv.features & HV_ACCESS_FREQUENCY_MSRS &&
 	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {
-		x86_platform.calibrate_tsc = hv_get_tsc_khz;
-		x86_platform.calibrate_cpu = hv_get_tsc_khz;
+		tsc_register_calibration_routines(hv_get_tsc_khz, hv_get_tsc_khz);
 		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	}
 
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 00189cdeb775..d6f079a75f05 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -416,8 +416,8 @@ static void __init vmware_platform_setup(void)
 		}
 
 		vmware_tsc_khz = tsc_khz;
-		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
-		x86_platform.calibrate_cpu = vmware_get_tsc_khz;
+		tsc_register_calibration_routines(vmware_get_tsc_khz,
+						  vmware_get_tsc_khz);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 		/* Skip lapic calibration since we know the bus frequency. */
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index cd8ed1edbf9e..b0a053692161 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -209,8 +209,6 @@ static void __init jailhouse_init_platform(void)
 	x86_init.mpparse.parse_smp_cfg		= jailhouse_parse_smp_config;
 	x86_init.pci.arch_init			= jailhouse_pci_arch_init;
 
-	x86_platform.calibrate_cpu		= jailhouse_get_tsc;
-	x86_platform.calibrate_tsc		= jailhouse_get_tsc;
 	x86_platform.get_wallclock		= jailhouse_get_wallclock;
 	x86_platform.legacy.rtc			= 0;
 	x86_platform.legacy.warm_reset		= 0;
@@ -220,6 +218,8 @@ static void __init jailhouse_init_platform(void)
 
 	machine_ops.emergency_restart		= jailhouse_no_restart;
 
+	tsc_register_calibration_routines(jailhouse_get_tsc, jailhouse_get_tsc);
+
 	while (pa_data) {
 		mapping = early_memremap(pa_data, sizeof(header));
 		memcpy(&header, mapping, sizeof(header));
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..b898b95a7d50 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -320,8 +320,8 @@ void __init kvmclock_init(void)
 	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
 	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
 
-	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
-	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
+	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz);
+
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index bb4619148161..d65e85929d3e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1294,6 +1294,23 @@ static void __init check_system_tsc_reliable(void)
 		tsc_disable_clocksource_watchdog();
 }
 
+/*
+ * TODO: Disentangle AMD_MEM_ENCRYPT and make SEV guest support depend on
+ *	 HYPERVISOR_GUEST.
+ */
+#if defined(CONFIG_HYPERVISOR_GUEST) || defined(CONFIG_AMD_MEM_ENCRYPT)
+void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
+				       unsigned long (*calibrate_cpu)(void))
+{
+	if (WARN_ON_ONCE(!calibrate_tsc))
+		return;
+
+	x86_platform.calibrate_tsc = calibrate_tsc;
+	if (calibrate_cpu)
+		x86_platform.calibrate_cpu = calibrate_cpu;
+}
+#endif
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 96521b1874ac..9e2e900dc0c7 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -566,7 +566,7 @@ static void __init xen_init_time_common(void)
 	static_call_update(pv_steal_clock, xen_steal_clock);
 	paravirt_set_sched_clock(xen_sched_clock);
 
-	x86_platform.calibrate_tsc = xen_tsc_khz;
+	tsc_register_calibration_routines(xen_tsc_khz, NULL);
 	x86_platform.get_wallclock = xen_get_wallclock;
 }
 
-- 
2.48.1.711.g2feabab25a-goog


