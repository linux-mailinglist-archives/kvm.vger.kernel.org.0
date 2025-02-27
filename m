Return-Path: <kvm+bounces-39496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609D8A47241
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78E51169422
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764771DCB09;
	Thu, 27 Feb 2025 02:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZeXZceS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDFC1D63CC
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622759; cv=none; b=q7HFxVe7zYpoK7JA46jQ/Vr56MJvkFvyKUxjWVBkBnHofBtSTZnmcGChJLLOev8JcInVDQOau6pOtq4t0fEX0EfSLUlJ8CuIkeDpfaFtAYG8b0i4aE2j58M8p6dSszt9vm7KrRpvNB8XYcaVTlU0foDNYzoBqMpj7YanFfQXASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622759; c=relaxed/simple;
	bh=EP6PsRCf87GzV1IBCG1heWk9cTGrnzInffXbkT0E3+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T7Xzi4mj2vZV/spPqWZX6Y/fgrwNlIqJn4m2vICpCCKnIGP89QuIzYsbWx0Ge0y14EKSphM+JHUurFZA10ZMRm41Wd7gGM8c+gHQcYE/ceFttRmxvNqw/wz7lvZ2hDsvmLBxtlY/N3buGk8n0Da3UvmneNAnu9D8uhAdeqsWDtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZeXZceS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc5a9f18afso1085380a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622757; x=1741227557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xfyweVUhHjn5qLEM1jkmIOD/E67k0zFXQwB6BCCQHG8=;
        b=NZeXZceScV3GIGfgYEDo9NfJem4onudXg3iRAnNcFKD6lFQeaVgGALJK/BjOiWbPIh
         9yS9s+jrMy7qBnGhkxMP5XpQHsNc0oIgW28xsqn6bNFU3Ih8QXaaBJkuJQ2vL/Korifg
         z87H+KjeqQxEq/BIffnglVcqEWlFL6V0ldXECM+HArU+yq8pWGvKk1yV26aOAr99bvsG
         BvR2IxqtY5p+4SIHDFogK5W3r9H6kVzFKXJv4sZ1LBiaL6BlGma0thlqXTAM7mFe5sAx
         WIVtTmTj0rde4eO3+9oCdaaLP4EqxSwJL7m1fV7vJUlFK2GvaSluBeXi0KNBvZGJa0Fz
         3bkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622757; x=1741227557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xfyweVUhHjn5qLEM1jkmIOD/E67k0zFXQwB6BCCQHG8=;
        b=VCo2Cv7eB6f4DOEgQHImg71MT6GyuRQgRa6HpZC1fqTa2ynG5WpVgcuOM+etH4oNqS
         SXeRQW+dbcOyRbe87TX9lRYNnstKT1K2uDucqK0g1+q/zrDmbAtyyghNl8jmjksIBIUW
         m0VTokvepjSTC5Zg82xWVs5bJWjbpZ05A/iig7MihjL8MGDUsPj4LZq6wmZwOoG1LGOZ
         ug1AHUL9D9AN2NTEhZ2CCpDcIhb7XHt9RKfkhhhjbtWYzvrP7Dlb0CtYqvTZDoQFT+mG
         S5nYq3eE1+dcW/ThRZDl7CaQ+5EM6gckHMJ1FjTnLIiXfJut2x0hDs+Xt7tn8zF2KkiA
         KNUw==
X-Forwarded-Encrypted: i=1; AJvYcCVCkVh4xkXAD2Bvy4F122lIQz0LyQ00oA8jCKyVXfHVFxi4LorKD3/veb8T/hKYNzSLre0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyasOGj0AJX5M5MYt0l+DRUkN6WSIpPWZarQAbdU/YZf1iruf4g
	9+8Zv74h8yynQ5UNFOMx5CrBxDDdZmjNvrN1pq8a+hA/5Qwweof9Yy4osPrXNltkSBW9BN59FMa
	CPg==
X-Google-Smtp-Source: AGHT+IGK7T2uVtHCkzgg9idpaqI5CgjOHQ8lJUTz55dy8O8u0q+xXKgUvujnuayeBIrgMdHIgLk5Hrx+hJs=
X-Received: from pjbta8.prod.google.com ([2002:a17:90b:4ec8:b0:2fa:1771:e276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d48:b0:2ee:d7d3:3019
 with SMTP id 98e67ed59e1d1-2fe7e31f7c1mr10280973a91.12.1740622757149; Wed, 26
 Feb 2025 18:19:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:24 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-9-seanjc@google.com>
Subject: [PATCH v2 08/38] clocksource: hyper-v: Register sched_clock
 save/restore iff it's necessary
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

Register the Hyper-V timer callbacks or saving/restoring its PV sched_clock
if and only if the timer is actually being used for sched_clock.
Currently, Hyper-V overrides the save/restore hooks if the reference TSC
available, whereas the Hyper-V timer code only overrides sched_clock if
the reference TSC is available *and* it's not invariant.  The flaw is
effectively papered over by invoking the "old" save/restore callbacks as
part of save/restore, but that's unnecessary and fragile.

To avoid introducing more complexity, and to allow for additional cleanups
of the PV sched_clock code, move the save/restore hooks and logic into
hyperv_timer.c and simply wire up the hooks when overriding sched_clock
itself.

Note, while the Hyper-V timer code is intended to be architecture neutral,
CONFIG_PARAVIRT is firmly x86-only, i.e. adding a small amount of x86
specific code (which will be reduced in future cleanups) doesn't
meaningfully pollute generic code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/mshyperv.c     | 58 ------------------------------
 drivers/clocksource/hyperv_timer.c | 50 ++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index aa60491bf738..174f6a71c899 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -223,63 +223,6 @@ static void hv_machine_crash_shutdown(struct pt_regs *regs)
 	hyperv_cleanup();
 }
 #endif /* CONFIG_CRASH_DUMP */
-
-static u64 hv_ref_counter_at_suspend;
-static void (*old_save_sched_clock_state)(void);
-static void (*old_restore_sched_clock_state)(void);
-
-/*
- * Hyper-V clock counter resets during hibernation. Save and restore clock
- * offset during suspend/resume, while also considering the time passed
- * before suspend. This is to make sure that sched_clock using hv tsc page
- * based clocksource, proceeds from where it left off during suspend and
- * it shows correct time for the timestamps of kernel messages after resume.
- */
-static void save_hv_clock_tsc_state(void)
-{
-	hv_ref_counter_at_suspend = hv_read_reference_counter();
-}
-
-static void restore_hv_clock_tsc_state(void)
-{
-	/*
-	 * Adjust the offsets used by hv tsc clocksource to
-	 * account for the time spent before hibernation.
-	 * adjusted value = reference counter (time) at suspend
-	 *                - reference counter (time) now.
-	 */
-	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend - hv_read_reference_counter());
-}
-
-/*
- * Functions to override save_sched_clock_state and restore_sched_clock_state
- * functions of x86_platform. The Hyper-V clock counter is reset during
- * suspend-resume and the offset used to measure time needs to be
- * corrected, post resume.
- */
-static void hv_save_sched_clock_state(void)
-{
-	old_save_sched_clock_state();
-	save_hv_clock_tsc_state();
-}
-
-static void hv_restore_sched_clock_state(void)
-{
-	restore_hv_clock_tsc_state();
-	old_restore_sched_clock_state();
-}
-
-static void __init x86_setup_ops_for_tsc_pg_clock(void)
-{
-	if (!(ms_hyperv.features & HV_MSR_REFERENCE_TSC_AVAILABLE))
-		return;
-
-	old_save_sched_clock_state = x86_platform.save_sched_clock_state;
-	x86_platform.save_sched_clock_state = hv_save_sched_clock_state;
-
-	old_restore_sched_clock_state = x86_platform.restore_sched_clock_state;
-	x86_platform.restore_sched_clock_state = hv_restore_sched_clock_state;
-}
 #endif /* CONFIG_HYPERV */
 
 static uint32_t  __init ms_hyperv_platform(void)
@@ -635,7 +578,6 @@ static void __init ms_hyperv_init_platform(void)
 
 	/* Register Hyper-V specific clocksource */
 	hv_init_clocksource();
-	x86_setup_ops_for_tsc_pg_clock();
 	hv_vtl_init_platform();
 #endif
 	/*
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index f00019b078a7..86a55167bf5d 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -534,10 +534,60 @@ static __always_inline void hv_setup_sched_clock(void *sched_clock)
 	sched_clock_register(sched_clock, 64, NSEC_PER_SEC);
 }
 #elif defined CONFIG_PARAVIRT
+static u64 hv_ref_counter_at_suspend;
+static void (*old_save_sched_clock_state)(void);
+static void (*old_restore_sched_clock_state)(void);
+
+/*
+ * Hyper-V clock counter resets during hibernation. Save and restore clock
+ * offset during suspend/resume, while also considering the time passed
+ * before suspend. This is to make sure that sched_clock using hv tsc page
+ * based clocksource, proceeds from where it left off during suspend and
+ * it shows correct time for the timestamps of kernel messages after resume.
+ */
+static void save_hv_clock_tsc_state(void)
+{
+	hv_ref_counter_at_suspend = hv_read_reference_counter();
+}
+
+static void restore_hv_clock_tsc_state(void)
+{
+	/*
+	 * Adjust the offsets used by hv tsc clocksource to
+	 * account for the time spent before hibernation.
+	 * adjusted value = reference counter (time) at suspend
+	 *                - reference counter (time) now.
+	 */
+	hv_adj_sched_clock_offset(hv_ref_counter_at_suspend - hv_read_reference_counter());
+}
+/*
+ * Functions to override save_sched_clock_state and restore_sched_clock_state
+ * functions of x86_platform. The Hyper-V clock counter is reset during
+ * suspend-resume and the offset used to measure time needs to be
+ * corrected, post resume.
+ */
+static void hv_save_sched_clock_state(void)
+{
+	old_save_sched_clock_state();
+	save_hv_clock_tsc_state();
+}
+
+static void hv_restore_sched_clock_state(void)
+{
+	restore_hv_clock_tsc_state();
+	old_restore_sched_clock_state();
+}
+
 static __always_inline void hv_setup_sched_clock(void *sched_clock)
 {
 	/* We're on x86/x64 *and* using PV ops */
 	paravirt_set_sched_clock(sched_clock);
+
+	old_save_sched_clock_state = x86_platform.save_sched_clock_state;
+	x86_platform.save_sched_clock_state = hv_save_sched_clock_state;
+
+	old_restore_sched_clock_state = x86_platform.restore_sched_clock_state;
+	x86_platform.restore_sched_clock_state = hv_restore_sched_clock_state;
 }
 #else /* !CONFIG_GENERIC_SCHED_CLOCK && !CONFIG_PARAVIRT */
 static __always_inline void hv_setup_sched_clock(void *sched_clock) {}
-- 
2.48.1.711.g2feabab25a-goog


