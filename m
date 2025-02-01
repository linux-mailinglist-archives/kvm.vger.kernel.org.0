Return-Path: <kvm+bounces-37049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7229A24691
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B6571637D8
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10B6145B1B;
	Sat,  1 Feb 2025 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MuvGHiMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191EC84D0F
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376254; cv=none; b=uu5ENt3pQlSnQobCDWGPmaQLW8yOQoZXTJ82wwsbpnhNomKMRekakMlOa6ImVfy9pa7QP6+mkqf9khHnnJkZ3/a1iMNdEKYAd9UiJscssDEta3WKqx2p6kXXubvuOewP4lIcGcow41btdgi7y4+URAGxWtb2Hk0snJW2yHiGSz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376254; c=relaxed/simple;
	bh=jYmI/eXpvsg2cQw9fM1WNGkxu+qGdy0jshAF8Oe8hpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZgZ1Y9Kuj9ZcHIpa0m/RJeFQEQkzFAtEtgGpSHuLbt3MkCVquymaz57pUv6rV0utMqRWhNM05SyL3hKhAIu6c5sQS1PnWtsdIxSqH2GPcbJsAMZXdZ8Jm764ZOFI5UOcyv+wxTZXEpwEb448FdjvM37UDSSfaYqUTnVnka7la0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MuvGHiMl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so7118129a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376252; x=1738981052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jT3QYFJ8LBBvWgIRRoR6lTexg7BmHolHr3L1o5rQg1s=;
        b=MuvGHiMluEw4cTn+5fuVHv799QGTYc1ZAF60q8gekw5CCCrbsI/VYuY+I7AXurCVMy
         v+QsMPAi/B75dMxtfYhWMURQXJUzeehiFoCJMAkdvVapTu4jqu7wWBdsyjzuAJrGL8Cq
         aluwRRVHrlgcFvHPuD0Vpx84Khyu8OiFgKew6kVmoGE6Xs+kemM89kr6z7jCgeR30SCO
         wsgOxbig9rX1Y2DlcM7s3i6ho+NfAKW1XjZXT5CGw47jMtmM0lWGNI7/CEMt6BFXUqUf
         r5EjQQBHBr6jTwvfdilXF8gEs3OzD9QQsfb4MMtLsH0od1EAdOYR9yJYPPNgbRPOmFtz
         qm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376252; x=1738981052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jT3QYFJ8LBBvWgIRRoR6lTexg7BmHolHr3L1o5rQg1s=;
        b=IKFezbI62poytchpYe1IPeMO6lAAjAPEz0PaTzE9+Z4b5As1TUd8jzuMKR736OPcxg
         Q3O1HXJj7N7BwAYrQdZDUxrUiqR3g71shEgK2rECPmuUGcDOR9MtVB0Jbnv3C5cbZre0
         NBFTpImRToIoHJXS+2W+x4v0COe6HsfrLrYrw/v/ci8lC9lkGVkwGuzB3NgPl1ZiZZTS
         g4vuYR/Vtd4DEFN/4mYRABONMJwOMTMPj7r5+845MHJNcmAHs8qXN2shRd4kAJKmkzWR
         /bJJAWNOlZMj2np9MxX7CuXPwHjl/rKnir/7/Nh+a2ZaDmvVsA8dacUYzv+yKphv64HL
         Q2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWuwRRZSFjghNrgJsxvq83+Ab71/gLrYura9pGQnJ9HI2MW+j8X2XIVTpi9TYluUGTzq3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBHn1RvBPXcyWinv/sOwTCXbODxmx0BhWK2vpCaVY73DrNGg4L
	Mv1DfbcwVneR3stoj7alI1T24zbFC4m7tSLYozB14xsRgtG7hHjjaMvJXIUyFebS87SljM5ayc0
	0gA==
X-Google-Smtp-Source: AGHT+IENOAlD/a9C1yscB8pt52goTvVVex1rnSy0sEVpxDmpsSGOR0udgFhGxI9toBaldalY7yVRQJOWBrI=
X-Received: from pjbqj6.prod.google.com ([2002:a17:90b:28c6:b0:2ef:6fb0:55fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c887:b0:2ee:a744:a4fe
 with SMTP id 98e67ed59e1d1-2f83ac5cbf4mr18887576a91.25.1738376252521; Fri, 31
 Jan 2025 18:17:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:05 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-4-seanjc@google.com>
Subject: [PATCH 03/16] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org, 
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, Sean Christopherson <seanjc@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
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
index 540e2a31c87d..82a6cc27cafb 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -87,6 +87,10 @@ static inline int cpuid_get_cpu_freq(unsigned int *cpu_khz)
 
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
index 4fc633ac5873..5a16271b7a5c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1245,6 +1245,23 @@ static void __init check_system_tsc_reliable(void)
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
2.48.1.362.g079036d154-goog


