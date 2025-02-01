Return-Path: <kvm+bounces-37058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F4DA246BB
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5F741889888
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEFD1BD9D8;
	Sat,  1 Feb 2025 02:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r+aBF04b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AF1B392E
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376270; cv=none; b=Lm1673WmE4vmOeaYdqdbG1aJzScD/+Hil5F7F7zGYHTsAbd2g743FVuSbeE9fOCMFW46/w0cELa4gPvtJfXfHhuCGpjob1/5zfuopMCwjWMj7FleTwe8/nQ9Z0h7xivZFngfz0gmqfmBfrnX3zGlvdTrFOuwpz0yygLQNmZCY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376270; c=relaxed/simple;
	bh=xkVUUxGUDTn4R+vL3GICv7gTh6ZLEkeNiGFIyJAu9Bg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAwGTTqXHjFqWM4TkhQCUN+qSFn6lwjalTV/NDFT8nqyCYGMbKnnxK7aQKo16p5sZE7I2ZCAKi31kbDJbj2gr6NpKQL2kCyAxOF8n8sUPpgmEYcR+zpECwYcUJftyr5WLp11Mu04AGdu7ND/ZROeGhARfmp3E1MqHSGye4ahL/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r+aBF04b; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efc3292021so7281472a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376268; x=1738981068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IrGW5KyAKjJvdPU9ageDhgEv89aW3VoCTAEai48xeak=;
        b=r+aBF04bMXteYNEUdpZ/KADsthpRfht39q2wEsPQeBT+khZhBofTSYdnvQvsxEOJ1i
         NchDdLKDgLbHiwN6DRHxmlg9KPbE4YzBHFed4CzWRAErW4DkLFP71gOQnF3f8SiwiM+S
         +wDyW0gVkO7DFExXLUWwEhGRZnGK5ondcEQ7uOYnFpqfn9rnxi/3yIuEIHRlOa5zFWER
         hA6EFvctVRaUvbUz+X0PfZmnyrjEXXGmqR68UssIQ9zhrtQ5qGefLxl6kIDWHuZeD1ZO
         4Jznl/ksONtVfVYvLV4RcpLRIzEE9J0Ubl45xbYFHyLyQUPE/Kf/qq19sTEotMffu89H
         mFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376268; x=1738981068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrGW5KyAKjJvdPU9ageDhgEv89aW3VoCTAEai48xeak=;
        b=ioo3/1HdgCG1bUC7FotYk+h6OXhg2x2D7cGpdpOkBPBoTA/DKv2TTD5y9ja3bpcm5s
         11pH+S1zWvrD08jYamMNYDb89JyKp+cwErNV08rqUZfjRFRnboaZBynNVJfg+P77pa3V
         iBQADSUX/nnOeB1U7meubbS8iikFiPhAe5oSc3Kb6gYg5tB8digUpsBGS0ZvQ3i4aYtp
         2muLfnn70LmlQyB98lZVFc4kocsulQeaEXrrYhW+qwkdBmCcuviIXCjB2N13S4jA9yAN
         L/c2IUP5wVv79fKfRHgtfBvzSbz4hrNRLzU7m/NqUMKb1WJD4krhiCL32uUf+GYQmoWn
         46dg==
X-Forwarded-Encrypted: i=1; AJvYcCXa3yk/dyadsXPOGQ4E5WP2zVnCce379dOyIQSy+XBYoISmxMCLN+RA8Rm6uI89KMalQb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkQo6K+xEn38TbA9KyTtWCmShYFOnhc1WD0LlFS8R/z1Kj9gJl
	vma5H6ALx7IoU7+v5gMeAYlcPMHvZSGJ5fli4WWOh8NDkd/7q5VxTHauBIldHIOvWdLVMre9pRO
	ZnA==
X-Google-Smtp-Source: AGHT+IFnviFY5P8yLFi8Q8khLJ9/h4GGB0jx1XaxjiOcD/F0E8KD3icYKrUfW55PtjtMBfI0KqMQJtaVac0=
X-Received: from pgbci10.prod.google.com ([2002:a05:6a02:200a:b0:a97:3102:ea5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9102:b0:1e1:faa:d8cf
 with SMTP id adf61e73a8af0-1ed7a6e1efcmr25085282637.40.1738376268141; Fri, 31
 Jan 2025 18:17:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:14 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-13-seanjc@google.com>
Subject: [PATCH 12/16] x86/kvmclock: Mark TSC as reliable when it's constant
 and nonstop
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

Mark the TSC as reliable if the hypervisor (KVM) has enumerated the TSC
as constant and nonstop, and the admin hasn't explicitly marked the TSC
as unstable.  Like most (all?) virtualization setups, any secondary
clocksource that's used as a watchdog is guaranteed to be less reliable
than a constant, nonstop TSC, as all clocksources the kernel uses as a
watchdog are all but guaranteed to be emulated when running as a KVM
guest.  I.e. any observed discrepancies between the TSC and watchdog will
be due to jitter in the watchdog.

This is especially true for KVM, as the watchdog clocksource is usually
emulated in host userspace, i.e. reading the clock incurs a roundtrip
cost of thousands of cycles.

Marking the TSC reliable addresses a flaw where the TSC will occasionally
be marked unstable if the host is under moderate/heavy load.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 890535ddc059..a7c4ae7f92e2 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -283,6 +283,7 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 
 void __init kvmclock_init(void)
 {
+	enum tsc_properties tsc_properties = TSC_FREQUENCY_KNOWN;
 	u8 flags;
 
 	if (!kvm_para_available() || !kvmclock)
@@ -313,11 +314,26 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
+	/*
+	 * X86_FEATURE_NONSTOP_TSC is TSC runs at constant rate
+	 * with P/T states and does not stop in deep C-states.
+	 *
+	 * Invariant TSC exposed by host means kvmclock is not necessary:
+	 * can use TSC as clocksource.
+	 *
+	 */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    !check_tsc_unstable()) {
+		kvm_clock.rating = 299;
+		tsc_properties = TSC_FREQ_KNOWN_AND_RELIABLE;
+	}
+
 	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
 	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
 
 	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
-					  TSC_FREQUENCY_KNOWN);
+					  tsc_properties);
 
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
@@ -328,19 +344,6 @@ void __init kvmclock_init(void)
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
-- 
2.48.1.362.g079036d154-goog


