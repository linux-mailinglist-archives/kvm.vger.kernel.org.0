Return-Path: <kvm+bounces-63047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E42C5A057
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 601BE4E99C4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 20:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED586324B3C;
	Thu, 13 Nov 2025 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wmp9mP/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63650324706
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763067085; cv=none; b=dw+/q1rO9XwhLWl/IwSsduD0Aw1n5MP3+QYby1dJOcs+S+IMGs6LUU8iRho/b5AK9MAD9AnsNFn6hupL6s6PQ4Ij4DH9VMMpjRtjAdL15DvJ+WubQCk6O6b+MjCRH8dAoCoNGETby5N7ARXqhdcl+Xc7rFOo7h5P+7Jd8CvzJU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763067085; c=relaxed/simple;
	bh=2qD33DHcfAR1IPtZENaezS1oJEG+r+B9YVEUiZ/LQdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hRBKJrq4vnEGEAvsUQ5QK6eFLZtBhmnq0mgdQM8Ae69lzoDXlt58zXx5HrBmjLAzrrJG9TFpEQSy3wzbFbo6MJY4cfBn279M08cfQSMCdmkpUfB2XexjGVp8Wq8JZVFu6wRk1k31iRg7U9JdGkQP6K8Omlf9RXUfUwllFa9bYSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wmp9mP/Z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295fbc7d4abso11814145ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763067083; x=1763671883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iZirwTH1N2dLuDj6J5piWIcXE5UcZVGJnlCfUAfpwcE=;
        b=wmp9mP/Z2gEla0NL1VSCOODTnn9X+mxt/al5DOT8w2A0YCPnKKy38HGeoXrS0Ihdw6
         5vbw5j/gOQhUZ9diK7VRw5Tl5p1YaSi1jlxYg7v1VBFSQuTG0yw5YluGrDAcvOsLAUdk
         imnJNaoOhkNbOeww8U2qyvCFwHq27lqqi56w/Gv9iiZThFkXNSCPrsJ+hIfSl2qN7kBh
         +wtdF7n9uRT/34B26/ZqqJFZuWKYA30GNzI7gLGagplohf6e9K/aBz5iCkPvUiR+xNds
         3GMuHiVTpjyY90UVl26R2zFA2rG2gKBvxaiviMZBOZ7yekdfCB8jdlF9Jp7WxcoTBxM6
         62gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763067083; x=1763671883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZirwTH1N2dLuDj6J5piWIcXE5UcZVGJnlCfUAfpwcE=;
        b=SDI+mviMtMc2IF1yujm+5JgXRXJetZcLj1doT/ewiZoSE1AM8NIqp+pClRnT0QxOtD
         2KAwOMdf+UtIEiaCk2wedYLqoQshkQ7rrEVaVe/gPZQZtFXc1baJlAdtm2Hoo/2/ZBNu
         C5Olt6g9u8I2t7UEuygO6xg5bx0uJWM9KJMVSLFFkPWaLQZLLXElpf8bBOaIyUKk8bui
         ZZoJrhfqRJ8Zgh5u0F2SMOZt29pr+2kJgmYvbEXPEAQL0TRh9jQ4A0l9OEpO7Bxk7SF7
         9/ujJZ4HM2THzd7pZ4IXWfNfyeovduUTDyuBfsGc2qc+TXpw5vzMw+ffbsP3ZvDOCoqe
         MhBA==
X-Gm-Message-State: AOJu0Yw63D+H5Bm/6HGHfoQniJQaeRmGGvZ4pf+NsdoHfYiglkxek9mD
	sx9JD2ybkOsT5VH/ukX/A8GO8+8UWy7Z5kiThXZw+x252CI/Q2vKa9K8n29uqdmG/rsGgVI9Kdy
	+qR4GCg==
X-Google-Smtp-Source: AGHT+IE/Lrm2iniBx+LCo4pKWDmy4JykLLOGfcbXkvXZxVT09h8YR6ozlvGSkmm8taUBniNnCdHlY+cinsc=
X-Received: from plqu16.prod.google.com ([2002:a17:902:a610:b0:290:28e2:ce59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c04:b0:295:b7a3:30e6
 with SMTP id d9443c01a7336-2986a6d55c0mr3834675ad.18.1763067082645; Thu, 13
 Nov 2025 12:51:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 12:51:13 -0800
In-Reply-To: <20251113205114.1647493-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113205114.1647493-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113205114.1647493-4-seanjc@google.com>
Subject: [PATCH v6 3/4] KVM: x86: Fix VM hard lockup after prolonged
 inactivity with periodic HV timer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: fuqiang wang <fuqiang.wng@gmail.com>

When advancing the target expiration for the guest's APIC timer in periodic
mode, set the expiration to "now" if the target expiration is in the past
(similar to what is done in update_target_expiration()).  Blindly adding
the period to the previous target expiration can result in KVM generating
a practically unbounded number of hrtimer IRQs due to programming an
expired timer over and over.  In extreme scenarios, e.g. if userspace
pauses/suspends a VM for an extended duration, this can even cause hard
lockups in the host.

Currently, the bug only affects Intel CPUs when using the hypervisor timer
(HV timer), a.k.a. the VMX preemption timer.  Unlike the software timer,
a.k.a. hrtimer, which KVM keeps running even on exits to userspace, the
HV timer only runs while the guest is active.  As a result, if the vCPU
does not run for an extended duration, there will be a huge gap between
the target expiration and the current time the vCPU resumes running.
Because the target expiration is incremented by only one period on each
timer expiration, this leads to a series of timer expirations occurring
rapidly after the vCPU/VM resumes.

More critically, when the vCPU first triggers a periodic HV timer
expiration after resuming, advancing the expiration by only one period
will result in a target expiration in the past.  As a result, the delta
may be calculated as a negative value.  When the delta is converted into
an absolute value (tscdeadline is an unsigned u64), the resulting value
can overflow what the HV timer is capable of programming.  I.e. the large
value will exceed the VMX Preemption Timer's maximum bit width of
cpu_preemption_timer_multi + 32, and thus cause KVM to switch from the
HV timer to the software timer (hrtimers).

After switching to the software timer, periodic timer expiration callbacks
may be executed consecutively within a single clock interrupt handler,
because hrtimers honors KVM's request for an expiration in the past and
immediately re-invokes KVM's callback after reprogramming.  And because
the interrupt handler runs with IRQs disabled, restarting KVM's hrtimer
over and over until the target expiration is advanced to "now" can result
in a hard lockup.

E.g. the following hard lockup was triggered in the host when running a
Windows VM (only relevant because it used the APIC timer in periodic mode)
after resuming the VM from a long suspend (in the host).

  NMI watchdog: Watchdog detected hard LOCKUP on cpu 45
  ...
  RIP: 0010:advance_periodic_target_expiration+0x4d/0x80 [kvm]
  ...
  RSP: 0018:ff4f88f5d98d8ef0 EFLAGS: 00000046
  RAX: fff0103f91be678e RBX: fff0103f91be678e RCX: 00843a7d9e127bcc
  RDX: 0000000000000002 RSI: 0052ca4003697505 RDI: ff440d5bfbdbd500
  RBP: ff440d5956f99200 R08: ff2ff2a42deb6a84 R09: 000000000002a6c0
  R10: 0122d794016332b3 R11: 0000000000000000 R12: ff440db1af39cfc0
  R13: ff440db1af39cfc0 R14: ffffffffc0d4a560 R15: ff440db1af39d0f8
  FS:  00007f04a6ffd700(0000) GS:ff440db1af380000(0000) knlGS:000000e38a3b8000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000d5651feff8 CR3: 000000684e038002 CR4: 0000000000773ee0
  PKRU: 55555554
  Call Trace:
   <IRQ>
   apic_timer_fn+0x31/0x50 [kvm]
   __hrtimer_run_queues+0x100/0x280
   hrtimer_interrupt+0x100/0x210
   ? ttwu_do_wakeup+0x19/0x160
   smp_apic_timer_interrupt+0x6a/0x130
   apic_timer_interrupt+0xf/0x20
   </IRQ>

Moreover, if the suspend duration of the virtual machine is not long enough
to trigger a hard lockup in this scenario, since commit 98c25ead5eda
("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86"), KVM
will continue using the software timer until the guest reprograms the APIC
timer in some way.  Since the periodic timer does not require frequent APIC
timer register programming, the guest may continue to use the software
timer in perpetuity.

Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
Cc: stable@vger.kernel.org
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
[sean: massage comments and changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a5c927e7bae6..8b6ec3304100 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2131,15 +2131,33 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
 	ktime_t delta;
 
 	/*
-	 * Synchronize both deadlines to the same time source or
-	 * differences in the periods (caused by differences in the
-	 * underlying clocks or numerical approximation errors) will
-	 * cause the two to drift apart over time as the errors
-	 * accumulate.
+	 * Use kernel time as the time source for both the hrtimer deadline and
+	 * TSC-based deadline so that they stay synchronized.  Computing each
+	 * deadline independently will cause the two deadlines to drift apart
+	 * over time as differences in the periods accumulate, e.g. due to
+	 * differences in the underlying clocks or numerical approximation errors.
 	 */
 	apic->lapic_timer.target_expiration =
 		ktime_add_ns(apic->lapic_timer.target_expiration,
 				apic->lapic_timer.period);
+
+	/*
+	 * If the new expiration is in the past, e.g. because userspace stopped
+	 * running the VM for an extended duration, then force the expiration
+	 * to "now" and don't try to play catch-up with the missed events.  KVM
+	 * will only deliver a single interrupt regardless of how many events
+	 * are pending, i.e. restarting the timer with an expiration in the
+	 * past will do nothing more than waste host cycles, and can even lead
+	 * to a hard lockup in extreme cases.
+	 */
+	if (ktime_before(apic->lapic_timer.target_expiration, now))
+		apic->lapic_timer.target_expiration = now;
+
+	/*
+	 * Note, ensuring the expiration isn't in the past also prevents delta
+	 * from going negative, which could cause the TSC deadline to become
+	 * excessively large due to it an unsigned value.
+	 */
 	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
 	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
 		nsec_to_cycles(apic->vcpu, delta);
-- 
2.52.0.rc1.455.g30608eb744-goog


