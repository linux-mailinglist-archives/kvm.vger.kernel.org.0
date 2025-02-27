Return-Path: <kvm+bounces-39489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D18BA47224
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547BF3AF653
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D2D1B041A;
	Thu, 27 Feb 2025 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U5Y3X53A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1951A8F63
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622748; cv=none; b=EYT9o0RT+H+pYgmsJJ4kZUkWJCNZ63qy9VC2NHHev2z9neVIiL3b/O72hvgIO3Q4Xzv4qWCYYZxInR7VilDrS8a8jbJ23gG4o7i9Wy84O6IJe5bz6Spqi+bhHPFb9IKuwrpeKzuRODMCE+Gc0uqtxX7knD0JravNR1k2awMkmDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622748; c=relaxed/simple;
	bh=vr3NG+3TNhQXw/Ld9LNbvZ/lm9g+GH2tsC78kbtC4nE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V4U/R5Gn/XUO1EHBLlt6I1NOjV6UkLZKCJGYoviaMIyBRiiTUMeWLvuvXg4RAI4MNtH/2SkGQn2FdpPKcMor2whaGe5RFEj00lEjymyGCcwpJn1b6Dje48xveMvzBYr4bVPCrkHe/gylwJNJ1+A89AKUUUR3fzpHYami+veZxtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U5Y3X53A; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso1555124a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622744; x=1741227544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KtBuHiug8RyBl7zdSfnpeCyQMsoAneIAJhrbW8v3FfQ=;
        b=U5Y3X53A2y1lQU6JZcZNk9HkzPtTid97/l/KmSjY0h0cAxtjcytG5ZjjcAEBtiFqLp
         PTsXBc5zeIj1yGbW2ecjlI+YpTlsIpD9ni9pvgISHOMJobsGUQqwbj9SSHbWUdzvYaUe
         ip36RXqRd5LhVlMNZfN8NzqjKVTXbEIVhe5RsPgKiWKIdWK+WonvNpxzm7eQ47tk9VY/
         vCblbFtDKjSgTNT6UxtylyQx7LK/zpJTFogyTSNETtn4VbMKUJ9oLiYOIH9Z/VYm47Rj
         i2Ltiqj5MDHf3vgoMlPE+b6I7i27GjQrnnA6+4vfkej0hr27mnyA4RWheC9p8FvjsdTc
         NPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622744; x=1741227544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtBuHiug8RyBl7zdSfnpeCyQMsoAneIAJhrbW8v3FfQ=;
        b=WCeDef4UbN89/S6F8J3/1vV1AOOAGrh5NtGXGypuJO7ItxneM51zsz7KATWUTkIfaP
         QmUGHeipB3fG1cypDbzSIOCqJrQWYAvvKkjpzOY0wqVtXWipESoafHucpZF4BJQWlNt/
         6vDWVddjDTu3joYBuInsXzFKGOb61LHTGnYTaofl23E8HOlBF62AiM2XlcBOKIKjoPth
         wbJPyuMH4fcotmd6oSmaAspGX8Zu/9FDEd1n9pRTzLOQ0cAZCYySvaKY+r6JI8MEMyB3
         2fZ0pWfKkt4VJY9kvZDo+0gutNctSMsE3ri1suLS6x84+IRAEeXthfCJbUAa+DFJobaj
         90cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRtrhy6qVZICHF6Fr5K8cIGdqYsoqNoZGdQyuERR9xrChvqPUp9+IWdQwdehVM97JEnVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgGfS9DO3WYyXWQ5FE98EDYA5aVzwmfOHQPpuygu33Ak05nw4z
	CgQwYEfbyXPC900t+JDaN0MkF50mzf/GXmHM0g+8Bb29f/BbqF/FaqSXLSVS4b7EOf0B1CptvMY
	hsQ==
X-Google-Smtp-Source: AGHT+IEZuLrSoCpVWZXJcy9TmAp9qIs68IJxs5ZGUPBqjbzVn9jX2mg4vMG9kljqKgFFkZhvGqcDyGJTu1M=
X-Received: from pjbsn14.prod.google.com ([2002:a17:90b:2e8e:b0:2fc:15bf:92f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:2ee:b8ac:73b0
 with SMTP id 98e67ed59e1d1-2fe68acd43fmr15933009a91.2.1740622744544; Wed, 26
 Feb 2025 18:19:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:17 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-2-seanjc@google.com>
Subject: [PATCH v2 01/38] x86/tsc: Add a standalone helpers for getting TSC
 info from CPUID.0x15
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

Extract retrieval of TSC frequency information from CPUID into standalone
helpers so that TDX guest support and kvmlock can reuse the logic.  Provide
a version that includes the multiplier math as TDX in particular does NOT
want to use native_calibrate_tsc()'s fallback logic that derives the TSC
frequency based on CPUID.0x16 when the core crystal frequency isn't known.

Opportunsitically drop native_calibrate_tsc()'s "== 0" and "!= 0" check
in favor of the kernel's preferred style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tsc.h |  9 +++++
 arch/x86/kernel/tsc.c      | 67 +++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94408a784c8e..a4d84f721775 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -28,6 +28,15 @@ static inline cycles_t get_cycles(void)
 }
 #define get_cycles get_cycles
 
+struct cpuid_tsc_info {
+	unsigned int denominator;
+	unsigned int numerator;
+	unsigned int crystal_khz;
+	unsigned int tsc_khz;
+};
+extern int cpuid_get_tsc_info(struct cpuid_tsc_info *info);
+extern int cpuid_get_tsc_freq(struct cpuid_tsc_info *info);
+
 extern void tsc_early_init(void);
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 34dec0b72ea8..93713eb81f52 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,46 +655,67 @@ static unsigned long quick_pit_calibrate(void)
 	return delta;
 }
 
+int cpuid_get_tsc_info(struct cpuid_tsc_info *info)
+{
+	unsigned int ecx_hz, edx;
+
+	memset(info, 0, sizeof(*info));
+
+	if (boot_cpu_data.cpuid_level < CPUID_LEAF_TSC)
+		return -ENOENT;
+
+	/* CPUID 15H TSC/Crystal ratio, plus optionally Crystal Hz */
+	cpuid(CPUID_LEAF_TSC, &info->denominator, &info->numerator, &ecx_hz, &edx);
+
+	if (!info->denominator || !info->numerator)
+		return -ENOENT;
+
+	/*
+	 * Note, some CPUs provide the multiplier information, but not the core
+	 * crystal frequency.  The multiplier information is still useful for
+	 * such CPUs, as the crystal frequency can be gleaned from CPUID.0x16.
+	 */
+	info->crystal_khz = ecx_hz / 1000;
+	return 0;
+}
+
+int cpuid_get_tsc_freq(struct cpuid_tsc_info *info)
+{
+	if (cpuid_get_tsc_info(info) || !info->crystal_khz)
+		return -ENOENT;
+
+	info->tsc_khz = info->crystal_khz * info->numerator / info->denominator;
+	return 0;
+}
+
 /**
  * native_calibrate_tsc - determine TSC frequency
  * Determine TSC frequency via CPUID, else return 0.
  */
 unsigned long native_calibrate_tsc(void)
 {
-	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
-	unsigned int crystal_khz;
+	struct cpuid_tsc_info info;
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return 0;
 
-	if (boot_cpu_data.cpuid_level < CPUID_LEAF_TSC)
+	if (cpuid_get_tsc_info(&info))
 		return 0;
 
-	eax_denominator = ebx_numerator = ecx_hz = edx = 0;
-
-	/* CPUID 15H TSC/Crystal ratio, plus optionally Crystal Hz */
-	cpuid(CPUID_LEAF_TSC, &eax_denominator, &ebx_numerator, &ecx_hz, &edx);
-
-	if (ebx_numerator == 0 || eax_denominator == 0)
-		return 0;
-
-	crystal_khz = ecx_hz / 1000;
-
 	/*
 	 * Denverton SoCs don't report crystal clock, and also don't support
 	 * CPUID_LEAF_FREQ for the calculation below, so hardcode the 25MHz
 	 * crystal clock.
 	 */
-	if (crystal_khz == 0 &&
-			boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT_D)
-		crystal_khz = 25000;
+	if (!info.crystal_khz && boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT_D)
+		info.crystal_khz = 25000;
 
 	/*
 	 * TSC frequency reported directly by CPUID is a "hardware reported"
 	 * frequency and is the most accurate one so far we have. This
 	 * is considered a known frequency.
 	 */
-	if (crystal_khz != 0)
+	if (info.crystal_khz)
 		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 
 	/*
@@ -702,15 +723,15 @@ unsigned long native_calibrate_tsc(void)
 	 * clock, but we can easily calculate it to a high degree of accuracy
 	 * by considering the crystal ratio and the CPU speed.
 	 */
-	if (crystal_khz == 0 && boot_cpu_data.cpuid_level >= CPUID_LEAF_FREQ) {
+	if (!info.crystal_khz && boot_cpu_data.cpuid_level >= CPUID_LEAF_FREQ) {
 		unsigned int eax_base_mhz, ebx, ecx, edx;
 
 		cpuid(CPUID_LEAF_FREQ, &eax_base_mhz, &ebx, &ecx, &edx);
-		crystal_khz = eax_base_mhz * 1000 *
-			eax_denominator / ebx_numerator;
+		info.crystal_khz = eax_base_mhz * 1000 *
+			info.denominator / info.numerator;
 	}
 
-	if (crystal_khz == 0)
+	if (!info.crystal_khz)
 		return 0;
 
 	/*
@@ -727,10 +748,10 @@ unsigned long native_calibrate_tsc(void)
 	 * lapic_timer_period here to avoid having to calibrate the APIC
 	 * timer later.
 	 */
-	lapic_timer_period = crystal_khz * 1000 / HZ;
+	lapic_timer_period = info.crystal_khz * 1000 / HZ;
 #endif
 
-	return crystal_khz * ebx_numerator / eax_denominator;
+	return info.crystal_khz * info.numerator / info.denominator;
 }
 
 static unsigned long cpu_khz_from_cpuid(void)
-- 
2.48.1.711.g2feabab25a-goog


