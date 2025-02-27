Return-Path: <kvm+bounces-39513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F825A472B8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:28:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8DD07A7FA9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE09E22FE19;
	Thu, 27 Feb 2025 02:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LGdP3V47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3459822C35C
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622788; cv=none; b=CBybHZzqN5QUurMjOQBP2VZNCbkS2VFneQgXaG8NNMZNha+BFLHrPkw441mShqces+UqSpzPny9VN5HdopGYenlzaGuYa94Lar9mFLqx2cB2nErdi4BAoqT+7iec5PtGHNopKkvMe3Uj7Rwmf28gQLIe4/d5uwG/Fp2z1HALguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622788; c=relaxed/simple;
	bh=zjjnD8AWfMJS2/xbCkWD8FS8YCODvYXqFbARM/Ts+/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PnQB6AdRplWUqMgMjwhQ34oyYDDYrKkZnCEJylOTo5tBOCgsNaMdDkSH0CpwTdthbvh9kMfdxyv4dIOV/3dV8Biw6KqeXXX9Y7m+naDb8Lk1ZSz9acBZmiwV7Bvu8rsIGWj/zHz4AXUq8xEcaByegdjytkr++7I1Qq2qT4mycmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LGdP3V47; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22107b29ac3so7797505ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622786; x=1741227586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3WIlT5dxc8eqreSuMAUxshuXGBEM8C/NLPwcD1zy3Y0=;
        b=LGdP3V47zvBfuYhkNIl11AV1RfpjpLs+4ZoASXY5qRpzH0BbueuSYw41Iptz3ijd3v
         gtic5rc9c0YEZMvGsRCQDIrMPaDUL6uHWG5KOUwXvJmOOM58H//frQlF7FnmwGuft8Or
         xaAz8D6Spnx/Hx5xUKEmQxvRMvI8fliZDw55LCSQoM7Kni64zuQkGKnAziTtiFGFhtn/
         KvjEcTKJbxSuG8OwRnkKPlkFJgyV2pOU5B4vJSVbGRBy2R64Zek5I9LgxpP61GR4lU8C
         gVLzI6H3fBqw/0SYdFT+kjqujcFYkM1DN+IkAhUFv3/B+J2ud4G8Jf48/cEHpguSI2sF
         L1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622786; x=1741227586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3WIlT5dxc8eqreSuMAUxshuXGBEM8C/NLPwcD1zy3Y0=;
        b=bonGZEtjusMbTgAElOlli4+3gUK18eVY1En+xIYHmTDqogiSMrn3EjMRIxtjwYVEbQ
         9NtEOkmbiygZhXN0LFiM5RTrMTmoCOFVA/n5yXrRF8JSkKA3wX8F6w70OyVmezqygYJb
         4cr1oKsqoQI7gWJg+mEkACKgaj/WGMVKD76LAieYJYgxrNNMXHGaLLSRbgkV+Xv9W9iN
         nENGks1z1up4KFlBTfg6MBxsQBBAGRrGyrqY38hyZGVLJSx9HeLlU8iCIPTwW+Uo9LGF
         9bArr/rrrL3Uq5RcordkTlBBBPs1HKOenHojOlL2ZsWOcoP+obxp8NxjalpH3E4rBDj5
         lEyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT7INh7y1KCTY8tWUiaMuC+L6lg8vxkut86aK/0JQs5edT9sjkihwhrcm836z74UIaxdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8HAc44b21XaYzrVR3+lWB6WoeopTdHcd3mZAeAwo9zEz2ALSk
	tFratt3+XK7bWzZL+y1czuvswF5AOW0CkxUQeJ1rIC1UcNrMZnuiY6B8HAsElMD15SysitpLKKs
	yhw==
X-Google-Smtp-Source: AGHT+IEKa+U3XmhHVLGnMc9mY3OxJMjJ1pR3+E2erpOOt4xnyyZwND9G3ZoTVgYNZ7eny0ZZLwJ5fe0HKa8=
X-Received: from pjvf4.prod.google.com ([2002:a17:90a:da84:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e80e:b0:21f:3d0d:2408
 with SMTP id d9443c01a7336-2234a28af91mr27386885ad.10.1740622786458; Wed, 26
 Feb 2025 18:19:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:41 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-26-seanjc@google.com>
Subject: [PATCH v2 25/38] x86/kvmclock: Hook clocksource.suspend/resume when
 kvmclock isn't sched_clock
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

Save/restore kvmclock across suspend/resume via clocksource hooks when
kvmclock isn't being used for sched_clock.  This will allow using kvmclock
as a clocksource (or for wallclock!) without also using it for sched_clock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 0580fe1aefa0..319f8b2d0702 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -130,7 +130,17 @@ static void kvm_setup_secondary_clock(void)
 
 static void kvm_restore_sched_clock_state(void)
 {
-	kvm_register_clock("primary cpu clock, resume");
+	kvm_register_clock("primary cpu, sched_clock resume");
+}
+
+static void kvmclock_suspend(struct clocksource *cs)
+{
+	kvmclock_disable();
+}
+
+static void kvmclock_resume(struct clocksource *cs)
+{
+	kvm_register_clock("primary cpu, clocksource resume");
 }
 
 void kvmclock_cpu_action(enum kvm_guest_cpu_action action)
@@ -201,6 +211,8 @@ static struct clocksource kvm_clock = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 	.id     = CSID_X86_KVM_CLK,
 	.enable	= kvm_cs_enable,
+	.suspend = kvmclock_suspend,
+	.resume = kvmclock_resume,
 };
 
 static void __init kvmclock_init_mem(void)
@@ -295,6 +307,15 @@ static void __init kvm_sched_clock_init(bool stable)
 	__paravirt_set_sched_clock(kvm_sched_clock_read, stable,
 				   kvm_save_sched_clock_state, kvm_restore_sched_clock_state);
 
+	/*
+	 * The BSP's clock is managed via dedicated sched_clock save/restore
+	 * hooks when kvmclock is used as sched_clock, as sched_clock needs to
+	 * be kept alive until the very end of suspend entry, and restored as
+	 * quickly as possible after resume.
+	 */
+	kvm_clock.suspend = NULL;
+	kvm_clock.resume = NULL;
+
 	pr_info("kvm-clock: using sched offset of %llu cycles",
 		kvm_sched_clock_offset);
 
-- 
2.48.1.711.g2feabab25a-goog


