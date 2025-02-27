Return-Path: <kvm+bounces-39521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5F3A472E4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 915EC7A88F9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4FF23E22A;
	Thu, 27 Feb 2025 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p/38eAlX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECAF23AE7B
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622803; cv=none; b=YJKJKLHohXzgg5SFU9dxyqX0PPYGtt763NmzfYUj/X86wjzdmqNgR7q7UbNGi3q5piHN02e4P7Gp2jlFUm9Oq/q1QFWp+YMTeWU2Sl3MLFebnGZ7VvBZmo3z+1JH0TFJjKBxGvl+cbHX4O7NZ6/OpTfB7B3mEsA7Lc/JFg4zwD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622803; c=relaxed/simple;
	bh=QPB0hO3DgGDIpWXharYozGSl0kpmrn7uptJliWGGUbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q4AJTMHB1K5oZJMIxLV36+jpUFoYBeY0i3S62layMWWv73RW3rk1otJj4uajFdtNc2xSQ2jo4j1syEO2C0pouK2CvxZCE3E0vkPjV0YC8V4cM6IxGWQXNfcuJ7Q+qskrupzC+EvvRj2q4TdvuQXO7KVX5iDwdQyDffffxALIDgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p/38eAlX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc45101191so1080492a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622800; x=1741227600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SUWURP6DS00BmWQuQkka/ewYMygd0uN/XlEQWE3xarE=;
        b=p/38eAlXVBlnzxMy4cgsnY0hH2hHTEIwimsxxtF21T0WkCtdNUw3WUnpEiNfrZFn9Z
         wFtDE33Y8Q6RhXb+kvOuUE80VfYmhRdlnLd49oet2ZCZyx55S9HQ+lsJiB6EGohCoCXs
         yLL8vgRDcZ6wUk8rxJ88gzM/Qb2l6l0lMsYQcfZKT5gQp9sEyP4GkQva5+PNY50SUmip
         XmHnWKq3pm6Btq73RCSWaagC3bIfp68w0vXxHzgNxh7z5yAuk4tVWLZCO1DIjZ2rfERI
         hq35r+/20Ic+WIA1yx9X+UhO8hvPB/Z6w5BYag0kiSpcpCLLBJ7aVZGWxDl1q8NxjtSx
         6SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622800; x=1741227600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUWURP6DS00BmWQuQkka/ewYMygd0uN/XlEQWE3xarE=;
        b=wMZn3FRtMhdHFixsGHj4Iqfxp/bDYbkyvAo5ToPP6zybxwNAhjb4Yl3KaV7cEKfiYg
         KdYA5EWm4t1Kar+mkLHOWQ7SlxXWq9FzSiTZmXsYvLaPVt1AngVL076D50E03g8TY49K
         zi4GivG+i7eHmGsLdmtGR4BuPo+yOBqeQu+HaPsnfC6btsQCru3ZsGmnnV6nemPeg5Hv
         JJ5Tf84GFRbyj/lghDAt/H+1b3X1ZCfTF/8CFpYsL74Y6JgQQ2lAxVMZKsCNK5DEfO51
         QhvpZCB7nBmm2m2q2RElHZpsJepL9dJ48Vw1nm5ZtW/6vW5F82iPvqD8ePxkzDnzWHCh
         UBgw==
X-Forwarded-Encrypted: i=1; AJvYcCWWQqGbdUOUlyz5WfYBd/4eV4A3xSYaWTVj2VLRY6ieiZptFLuejghzYcgpLm7lMBj8lx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbSXwXd5rMxp+NS3TT439HkTAa8J9cxgbrootfN227cSwSW7Ky
	gUYXhErm6acgMhLbvt/Qj8x8y+dCM5JoL+vMqtA0T/f3c/uxyhJiOtQ5IQNMegAiLxQiaj8vUwV
	kaw==
X-Google-Smtp-Source: AGHT+IEaJegSwuz7gp17gUBIq0YV/a5p90hmpWu2RxMMtE/LMlRmTHKg61dycPOdBb/l8JsfSEdKtOPrkAY=
X-Received: from pjboh8.prod.google.com ([2002:a17:90b:3a48:b0:2fc:2b96:2d4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcf:b0:2f8:34df:5652
 with SMTP id 98e67ed59e1d1-2fce78beb41mr33366155a91.21.1740622800327; Wed, 26
 Feb 2025 18:20:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:49 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-34-seanjc@google.com>
Subject: [PATCH v2 33/38] x86/kvmclock: Mark TSC as reliable when it's
 constant and nonstop
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
 arch/x86/kernel/kvmclock.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ce676e735ced..b924b19e8f0f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -362,6 +362,7 @@ static void __init kvm_sched_clock_init(bool stable)
 
 void __init kvmclock_init(void)
 {
+	enum tsc_properties tsc_properties = TSC_FREQUENCY_KNOWN;
 	bool stable = false;
 
 	if (!kvm_para_available() || !kvmclock)
@@ -400,18 +401,6 @@ void __init kvmclock_init(void)
 			 PVCLOCK_TSC_STABLE_BIT;
 	}
 
-	kvm_sched_clock_init(stable);
-
-	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
-					  TSC_FREQUENCY_KNOWN);
-
-	x86_platform.get_wallclock = kvm_get_wallclock;
-	x86_platform.set_wallclock = kvm_set_wallclock;
-#ifdef CONFIG_SMP
-	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
-#endif
-	kvm_get_preset_lpj();
-
 	/*
 	 * X86_FEATURE_NONSTOP_TSC is TSC runs at constant rate
 	 * with P/T states and does not stop in deep C-states.
@@ -422,8 +411,22 @@ void __init kvmclock_init(void)
 	 */
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
-	    !check_tsc_unstable())
+	    !check_tsc_unstable()) {
 		kvm_clock.rating = 299;
+		tsc_properties = TSC_FREQ_KNOWN_AND_RELIABLE;
+	}
+
+	kvm_sched_clock_init(stable);
+
+	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_tsc_khz,
+					  tsc_properties);
+
+	x86_platform.get_wallclock = kvm_get_wallclock;
+	x86_platform.set_wallclock = kvm_set_wallclock;
+#ifdef CONFIG_SMP
+	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
+#endif
+	kvm_get_preset_lpj();
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";
-- 
2.48.1.711.g2feabab25a-goog


