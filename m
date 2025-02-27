Return-Path: <kvm+bounces-39498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC25A47250
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:23:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A891668AA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C87018C907;
	Thu, 27 Feb 2025 02:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jpZ24PzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C25F1BEF8C
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622762; cv=none; b=Hg4H/Hp2ad5ZSAZzkrBcZTvbhPmHENyFFl4r2Akruu6EvMErsMpVKvV1abhwmOI5KGkHEs7Q+C1JQdGC63L5NB+Vtu3MkAicvgIMByTQbJdh6eDvXSpmwohSo/hZGlRJGCvTO8N+VtZhfvb4/UYBl2/9Vue8DXvHmAkFrv0udKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622762; c=relaxed/simple;
	bh=6BODDAoV1hIIhUhwPZ9d59Xbs0XOkFee+lu9N6Pq9I4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s7KMQJcJbH+53gEoBDsVXpGRr9nj+4k3/ZYeOi/Cr6ZIB2DpY3M0LW35oL+PLs59e1jKDoeu+f5/PVjIEostJ6eV3U2NT0+fzvMlQ3orBJwu7Q86qs5AxwbRWRB7I//8vp6NyMNUeWrKOcMuiONrmIOQZkH+AYcNy1zvsKK74Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jpZ24PzQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01e2bso1040524a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622760; x=1741227560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yCluOSGlRhOy+WE1mTtSxuryf3jXdB/g/GtrHZOBhNw=;
        b=jpZ24PzQQs2wAgA+5FKc2U5L/UPpup1absHMLvmLlaMWDK5mcd0PUDvPqag7ZNil4Z
         Hk3epljU/B++4funWP4LGil39k0gkIaAtENVkATBszC/xwezk+e56SWxP3IPEue1V7dU
         w1JdLLb6rVk+kC1nKztfhGIM/hMykf7H0+oyTSiLC+8/3dSspd5rfPnzy77BoIgHBBo0
         BowuYaKWSRpAR2oIcqLT475HBspQSNjgH8r3mSYkxCjY2NvyHLTdVRAAH5SRJRMyV24M
         eRR27I9S7EBMo0RNix1KTsjKkghixtpwm+6d7FH041nYfDhXWgfpLXXpqCAuU8v6arkv
         VxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622760; x=1741227560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yCluOSGlRhOy+WE1mTtSxuryf3jXdB/g/GtrHZOBhNw=;
        b=IJcghvxvahmMMjKJU64jntboajAdwpzbl5cF8lUnEI0VnSV39+DYWOJzPm+rpmW75n
         4kxhBenWETeb1coM6CwQf+VgCZ8HuRIsKKDQfC1dCP659N00YA2qojiTEt6XrQtCmATR
         VPU/59IzC5V+M2B8798PpfPzBlxNHLM2wB00tvJA61urLtNj/6bBt5P0hn993qDB6e1/
         Oz4EBN24SEp3heQYZLvoHkOgFx0z8r2i3fWi6a2MZB1MYn9QgFdPgEPGlSGJ35MzBWcK
         6hfpO1OVkBeGZw52oH0NDpkdwe3q+UC6r0c/6gZOGry1FAuzelsPReDz94vdXxSNlKfO
         IyrA==
X-Forwarded-Encrypted: i=1; AJvYcCUPMZQRNoYVQTrS4DTTOmHnniXfdVQEuPfJMWcfMb864vI65BjuoHLoHJYdwbWIiPYoyxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YygI8sPMqm1aO4kmXfzk/DK/PBGWncY6BgrsA+Y0nG9kFHJODrE
	5oj9Gp+fB4ZoMwbdeUKqz6lCmLgvt4WA6ZOJMMcsIuP4x7XhQtpcrm4D+lDXjDkScjaPmABl/c7
	y4g==
X-Google-Smtp-Source: AGHT+IEg2qVczQMppIuK2WVUrcQpfIoWQRuX4zIj2kwQnn94y9fLsBQqATNYRMsqTAxp9OZvbzuNSvbgNPw=
X-Received: from pgte20.prod.google.com ([2002:a65:6894:0:b0:ae1:49ef:10d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8004:b0:1f0:e368:4a48
 with SMTP id adf61e73a8af0-1f0e3684a6fmr22807696637.8.1740622760519; Wed, 26
 Feb 2025 18:19:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:26 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-11-seanjc@google.com>
Subject: [PATCH v2 10/38] clocksource: hyper-v: Don't save/restore TSC offset
 when using HV sched_clock
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

Now that Hyper-V overrides the sched_clock save/restore hooks if and only
sched_clock itself is set to the Hyper-V timer, drop the invocation of the
"old" save/restore callbacks.  When the registration of the PV sched_clock
was done separate from overriding the save/restore hooks, it was possible
for Hyper-V to clobber the TSC save/restore callbacks without actually
switching to the Hyper-V timer.

Enabling a PV sched_clock is a one-way street, i.e. the kernel will never
revert to using TSC for sched_clock, and so there is no need to invoke the
TSC save/restore hooks (and if there was, it belongs in common PV code).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/clocksource/hyperv_timer.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 5a52d0acf31f..4a21874e91b9 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -524,9 +524,6 @@ static __always_inline void hv_setup_sched_clock(void *sched_clock)
 }
 #elif defined CONFIG_PARAVIRT
 static u64 hv_ref_counter_at_suspend;
-static void (*old_save_sched_clock_state)(void);
-static void (*old_restore_sched_clock_state)(void);
-
 /*
  * Hyper-V clock counter resets during hibernation. Save and restore clock
  * offset during suspend/resume, while also considering the time passed
@@ -536,8 +533,6 @@ static void (*old_restore_sched_clock_state)(void);
  */
 static void hv_save_sched_clock_state(void)
 {
-	old_save_sched_clock_state();
-
 	hv_ref_counter_at_suspend = hv_read_reference_counter();
 }
 
@@ -550,8 +545,6 @@ static void hv_restore_sched_clock_state(void)
 	 *                - reference counter (time) now.
 	 */
 	hv_sched_clock_offset -= (hv_ref_counter_at_suspend - hv_read_reference_counter());
-
-	old_restore_sched_clock_state();
 }
 
 static __always_inline void hv_setup_sched_clock(void *sched_clock)
@@ -559,10 +552,7 @@ static __always_inline void hv_setup_sched_clock(void *sched_clock)
 	/* We're on x86/x64 *and* using PV ops */
 	paravirt_set_sched_clock(sched_clock);
 
-	old_save_sched_clock_state = x86_platform.save_sched_clock_state;
 	x86_platform.save_sched_clock_state = hv_save_sched_clock_state;
-
-	old_restore_sched_clock_state = x86_platform.restore_sched_clock_state;
 	x86_platform.restore_sched_clock_state = hv_restore_sched_clock_state;
 }
 #else /* !CONFIG_GENERIC_SCHED_CLOCK && !CONFIG_PARAVIRT */
-- 
2.48.1.711.g2feabab25a-goog


