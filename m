Return-Path: <kvm+bounces-37052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80028A2469D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A070E1889622
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C352F155C8A;
	Sat,  1 Feb 2025 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c2W9PjL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D76514AD38
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376260; cv=none; b=pHhzgDXn5PDL/g0HGSkW+y8E7o0iNlU5Bj+IN28s3bQMHUZoN9D2woDlNssRT0B/11l+Q3oi0rgjsHryOfkWHzucfiWs5ZWYvvVLCn2rsO8PKp1xPjEzzzr+OuZu+H/izb1DXEmChXL7ql22pmTHIfDNRzsw4Ll7kt9xOmWaXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376260; c=relaxed/simple;
	bh=28sb199ir3z+fqMIFiQCff2Q1bkmQ/ZCLy7LVrgv3wA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLPVFruwlYC4TkTcS9rHD6TQMGBlMombYrDO0hWtm51VAdDOJkN4dCw5qfsOF6emV7X3KCpv3jeraoBqCetyOuWJl6yKHixO1OBDHQgz61bYT0oMC0pmJv0N6Wl4p7ngYqA/PF1EII3L2aX7L54BeWQVIOvF/a7fJzs70YXuFZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c2W9PjL6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so7282866a91.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376258; x=1738981058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZIVWnX4ZIR8qTULzG2lFgPLNUNOiBx5bmZBm2lc3bA=;
        b=c2W9PjL6Mj/K7LoRXwArZm/ri4tzHjPHZq2+N8nrF59kXkOhZPSSKA1g13HGrsI3M5
         OQ2rsiUViTmgfFS6383FVxIMd7a6LdAOw5JzhdaYkSdQT3n6QOx+NuRrOLxSGS6Fzmig
         sHmUM4r+/TiWk9VPAhxlDsp7WgYvEQ/WHzgtlsHpQx7eAq2vK+XDFQDFR6qy6jWybPb6
         5M5pXtf9SJyP/13Z1pOsxhMq+H9m6M/J5aQMYFzLy/SN8uRbq5uElae1mt+xdooV/Zh/
         0l5i3zZijDp2HrjvE13ap5eEJmp1h4Aq26QR0a1ngcMP3Rc9KlfnnXREu8r6dVw0DsR0
         ZTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376258; x=1738981058;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OZIVWnX4ZIR8qTULzG2lFgPLNUNOiBx5bmZBm2lc3bA=;
        b=HsKf9bdLGtHs8Te6HzRQP+N+jbI6AJvyOHQU3QbrZQDpJbDflVJX6glXV0Mjgw+7CJ
         iSsESxtjojnsaO4w3LsxLB+9HxD6NVABvCFh8fuEgq859NHeH30f9xN3huMbEdZZY5y6
         yUki8OLWtlUdVwDyJPAdp0VY4S387ZbjXr4Zme+8fSmmn+K1EOcbhoKj5PPM/NDrNDtG
         qDD7drz3iWvJHzFUwr+9oudUWOdn/6c7YIIP+aQsikwaGdqml2sXoiggLwhCwopgI/D4
         Ft1FFFuc97p44YpQfe7qMP0Zc+LLgg30vtI9z0/1NLUIx7xQ/ny/CxU+rvzKHJRgxh9W
         mKag==
X-Forwarded-Encrypted: i=1; AJvYcCXefPYioIWpEiY/dKpAg00eZP22IWWkHUqxsynD1O4zx8cMhEFthQ4xLJmq3B/pLtWFTaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5qNmaRMZ1i1LFL5rAPaTjuhj2P4rm1Ggjas9pt/KX7gvSTHwF
	5tsvVzyfInRc9+JiprpyDSF+6jCq8EzS11VHhAHEbOq/GTLI0JO3NnOmrDyheRnm0QlEK5eub96
	VFg==
X-Google-Smtp-Source: AGHT+IFcMeXA8VIBFL831iVKjhY+AV/GUGMaW5llrGZfmojSdj8zqHZ4SMmI2Ir2VJD2NBPugN1JemRWHpg=
X-Received: from pjtu6.prod.google.com ([2002:a17:90a:c886:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:3dc1:b0:2f9:9ddd:689c
 with SMTP id 98e67ed59e1d1-2f99ddd6bcfmr3721003a91.25.1738376257808; Fri, 31
 Jan 2025 18:17:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:08 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-7-seanjc@google.com>
Subject: [PATCH 06/16] x86/tdx: Override PV calibration routines with
 CPUID-based calibration
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
Content-Transfer-Encoding: quoted-printable

When running as a TDX guest, explicitly override the TSC frequency
calibration routine with CPUID-based calibration instead of potentially
relying on a hypervisor-controlled PV routine.  For TDX guests, CPUID.0x15
is always emulated by the TDX-Module, i.e. the information from CPUID is
more trustworthy than the information provided by the hypervisor.

To maintain backwards compatibility with TDX guest kernels that use native
calibration, and because it's the least awful option, retain
native_calibrate_tsc()'s stuffing of the local APIC bus period using the
core crystal frequency.  While it's entirely possible for the hypervisor
to emulate the APIC timer at a different frequency than the core crystal
frequency, the commonly accepted interpretation of Intel's SDM is that APIC
timer runs at the core crystal frequency when that latter is enumerated via
CPUID:

  The APIC timer frequency will be the processor=E2=80=99s bus clock or cor=
e
  crystal clock frequency (when TSC/core crystal clock ratio is enumerated
  in CPUID leaf 0x15).

If the hypervisor is malicious and deliberately runs the APIC timer at the
wrong frequency, nothing would stop the hypervisor from modifying the
frequency at any time, i.e. attempting to manually calibrate the frequency
out of paranoia would be futile.

Deliberately leave the CPU frequency calibration routine as is, since the
TDX-Module doesn't provide any guarantees with respect to CPUID.0x16.

Opportunistically add a comment explaining that CoCo TSC initialization
needs to come after hypervisor specific initialization.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/tdx/tdx.c    | 30 +++++++++++++++++++++++++++---
 arch/x86/include/asm/tdx.h |  2 ++
 arch/x86/kernel/tsc.c      |  8 ++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 32809a06dab4..9d95dc713331 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -8,6 +8,7 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/kexec.h>
+#include <asm/apic.h>
 #include <asm/coco.h>
 #include <asm/tdx.h>
 #include <asm/vmx.h>
@@ -1063,9 +1064,6 @@ void __init tdx_early_init(void)
=20
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
=20
-	/* TSC is the only reliable clock in TDX guest */
-	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
-
 	cc_vendor =3D CC_VENDOR_INTEL;
=20
 	/* Configure the TD */
@@ -1122,3 +1120,29 @@ void __init tdx_early_init(void)
=20
 	tdx_announce();
 }
+
+static unsigned long tdx_get_tsc_khz(void)
+{
+	unsigned int __tsc_khz, crystal_khz;
+
+	if (WARN_ON_ONCE(cpuid_get_tsc_freq(&__tsc_khz, &crystal_khz)))
+		return 0;
+
+	lapic_timer_period =3D crystal_khz * 1000 / HZ;
+
+	return __tsc_khz;
+}
+
+void __init tdx_tsc_init(void)
+{
+	/* TSC is the only reliable clock in TDX guest */
+	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+
+	/*
+	 * Override the PV calibration routines (if set) with more trustworthy
+	 * CPUID-based calibration.  The TDX module emulates CPUID, whereas any
+	 * PV information is provided by the hypervisor.
+	 */
+	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL);
+}
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b4b16dafd55e..621fbdd101e2 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -53,6 +53,7 @@ struct ve_info {
 #ifdef CONFIG_INTEL_TDX_GUEST
=20
 void __init tdx_early_init(void);
+void __init tdx_tsc_init(void);
=20
 void tdx_get_ve_info(struct ve_info *ve);
=20
@@ -72,6 +73,7 @@ void __init tdx_dump_td_ctls(u64 td_ctls);
 #else
=20
 static inline void tdx_early_init(void) { };
+static inline void tdx_tsc_init(void) { }
 static inline void tdx_safe_halt(void) { };
=20
 static inline bool tdx_early_handle_ve(struct pt_regs *regs) { return fals=
e; }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 09ca0cbd4f31..922003059101 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -32,6 +32,7 @@
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
 #include <asm/sev.h>
+#include <asm/tdx.h>
=20
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1514,8 +1515,15 @@ void __init tsc_early_init(void)
 	if (is_early_uv_system())
 		return;
=20
+	/*
+	 * Do CoCo specific "secure" TSC initialization *after* hypervisor
+	 * platform initialization so that the secure variant can override the
+	 * hypervisor's PV calibration routine with a more trusted method.
+	 */
 	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
 		snp_secure_tsc_init();
+	else if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
+		tdx_tsc_init();
=20
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
--=20
2.48.1.362.g079036d154-goog


