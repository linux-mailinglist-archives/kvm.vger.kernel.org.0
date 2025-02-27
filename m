Return-Path: <kvm+bounces-39517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C278A472CA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669C716B328
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901AA2356B3;
	Thu, 27 Feb 2025 02:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C2bEH7N8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28EF2343AE
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622795; cv=none; b=PchyynYswsuTqEz/zxbJQazDLLkSJdbn89gl1FhFR7KQsLQdurp17XAakjUgpLnlvWPWOmYOy7HNZI5VYF/TLLMLMlBDFWu2NA30E1csyAThCpMRS8iW/YVW4HL6fuwLQ3+gxV6E9NE4aqszbsNPN4lCeH875f6QunhMRYXlGr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622795; c=relaxed/simple;
	bh=rD+knfVmlT64JQ1lkKWQu4cILK/xQrLi9CqFuuTpl9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QcBPOQxrqT5Xl8WUyPt0KZOvrtYVjC2vNfXOkivnKggsnBg/cyfCesG4Vq6e1kxeS5Tt2jW7rGxEqQTyoHzbVMOWaF+lF38oGPY9VUj1QLn1L9YxQZg2tMFDDaDq+13rx73GU42JWgkzvI5IHNpgo2LB3QiLN1VHIFax+4rebBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C2bEH7N8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso1546807a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622793; x=1741227593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P4tBmLUacP8DGxGQBI6X9mo8c2uhJ9G5VZle1I388Hk=;
        b=C2bEH7N8G98JK652NmlnCXoxwcXUVY16K/HXdHIWahTSHby9n9P6AOXN9dLq2mXCIr
         LX8pzyFqqseW3prLeqE0/H2ZA1wZLhXAirkzOaKV7ww3zKQFbqYkVxhE+/LSKkHBvfim
         ZQAG/zZAxu7sDeTN8F7M/NEXCk9QHRwiEJyDNuZ9LM2SK0VpXxcRIK7jBg/EC6lnf1+v
         JMpjTOp946M0745lysOM/GsjejPjE5Qg6vYqQ6A6ROrNCxegYKZjlwmTJgGoc399fUlw
         18dv12Na02OedvCuMN9A5WM33WSUvbbnvWmXIR8AgExa1mSdRhO2fQgcKScXDzuj/Yzv
         QUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622793; x=1741227593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P4tBmLUacP8DGxGQBI6X9mo8c2uhJ9G5VZle1I388Hk=;
        b=T2yMWTCYdr65JOsrJIsXQXzNHTarb5T0064suNzmOaYExS8g/GzCLf+Ol8PhtoPvuB
         YxltJW1EvW8tTDbRQWlXb7skz/MoB6AP/JSC7P2mTgFGjTFqwz80nVp5W8uPM6Lsxcdz
         hF1ZiJ2cVUdARygUoSohtE2o91KwTVF/I7/NKlQgWDuE2dqXaza0n1CDb1skUgRlHgbf
         Ee0CHUTDogzHXla/PtryOSC24mdH9yeSPkiIQ4qtBWErETB0XpADCS8qL5/mYMa1pKsQ
         PxncjyvBUx0pRzQ1jGE1uXrP1BOhOeXTsPdRQCC5wiYzelEzeq5WyDpOvORJqZvQoTPI
         DzoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMuQ5ZYkZMCeZEL7XDtoPLUaMtF0ygCMVGK5uFcZwnFWon7iTkhAZ46T1GBLyy8yaN1Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx73cF2TwQROD6WoswOYSM++Fr0Kly/QHVQADFTAuQdl60NpiYj
	YbuRWfvPHv8H124QNiE0poQ06hYh9zc/C22nZ1COlawvm/wVmIFg0V4VeSQXYnPWerPNjuwYuFN
	ISw==
X-Google-Smtp-Source: AGHT+IGdVjOlq0BY70ioN6i4xVGmLOeDmFSQNBlkaPaHsOsARCADALqyiFXLpG70t8VDnA7M1OSlhaskPoo=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2fa:15aa:4d2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54cd:b0:2f2:8bdd:cd8b
 with SMTP id 98e67ed59e1d1-2fe7e3b1756mr8832651a91.29.1740622793310; Wed, 26
 Feb 2025 18:19:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:45 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-30-seanjc@google.com>
Subject: [PATCH v2 29/38] x86/paravirt: Plumb a return code into __paravirt_set_sched_clock()
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

Add a return code to __paravirt_set_sched_clock() so that the kernel can
reject attempts to use a PV sched_clock without breaking the caller.  E.g.
when running as a CoCo VM with a secure TSC, using a PV clock is generally
undesirable.

Note, kvmclock is the only PV clock that does anything "extra" beyond
simply registering itself as sched_clock, i.e. is the only caller that
needs to check the new return value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/paravirt.h | 6 +++---
 arch/x86/kernel/kvmclock.c      | 7 +++++--
 arch/x86/kernel/paravirt.c      | 5 +++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index e6d5e77753c4..5de31b22aa5f 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -28,14 +28,14 @@ u64 dummy_sched_clock(void);
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
 DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
 
-void __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
-				       void (*save)(void), void (*restore)(void));
+int __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
+				      void (*save)(void), void (*restore)(void));
 
 static __always_inline void paravirt_set_sched_clock(u64 (*func)(void),
 						     void (*save)(void),
 						     void (*restore)(void))
 {
-	__paravirt_set_sched_clock(func, true, save, restore);
+	(void)__paravirt_set_sched_clock(func, true, save, restore);
 }
 
 static __always_inline u64 paravirt_sched_clock(void)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 76884dfc77f4..1dbe12ecb26e 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -337,9 +337,12 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 
 static void __init kvm_sched_clock_init(bool stable)
 {
+	if (__paravirt_set_sched_clock(kvm_sched_clock_read, stable,
+				       kvm_save_sched_clock_state,
+				       kvm_restore_sched_clock_state))
+		return;
+
 	kvm_sched_clock_offset = kvm_clock_read();
-	__paravirt_set_sched_clock(kvm_sched_clock_read, stable,
-				   kvm_save_sched_clock_state, kvm_restore_sched_clock_state);
 	kvmclock_is_sched_clock = true;
 
 	/*
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 92bf831a63b1..a3a1359cfc26 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -86,8 +86,8 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
 
-void __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
-				       void (*save)(void), void (*restore)(void))
+int __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
+				      void (*save)(void), void (*restore)(void))
 {
 	if (!stable)
 		clear_sched_clock_stable();
@@ -95,6 +95,7 @@ void __init __paravirt_set_sched_clock(u64 (*func)(void), bool stable,
 	static_call_update(pv_sched_clock, func);
 	x86_platform.save_sched_clock_state = save;
 	x86_platform.restore_sched_clock_state = restore;
+	return 0;
 }
 
 /* These are in entry.S */
-- 
2.48.1.711.g2feabab25a-goog


