Return-Path: <kvm+bounces-45607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 942AAAACA38
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 17:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B52411C27007
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 15:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9603B283FF9;
	Tue,  6 May 2025 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E9Vab5f0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0D4233739
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746547059; cv=none; b=JzBfVwimROSF3kk497hSSTYbTk+aW/kEXqWlCu7kL4cXeDgWlhpeSDZI7G3Zflkiz7iVqpbVQ3Hccv8n0f14EBsYCv82ZUy7xdwnVXGXbxkWclWnaZvVvCRnXaODbIWywKOTRy0JtmCWsYTgxKBojupV9zX09nqZPcP6U/oDW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746547059; c=relaxed/simple;
	bh=H6t/LyVC2tH9tYFL7kkla4lrUFrql+BZCxnd6PfxDCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J5E0qxzfZnXTInRlgaCzEResOw7+zd757jGEGPSbAcUO2lrP1XvWIJalDbH9cNpgAIh5OLBFdf9FHPBOJobZFieG4G/vXvyu1kFZ2nGuSxlQEFpg7taCaAmfJ8xR/S2O8UlSRbATR3F4MuxJ2u5EicmvHOPb+UVGlhX492mznBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E9Vab5f0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3011bee1751so4683019a91.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 08:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746547057; x=1747151857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=82szPLcDXXwvSQ58Vad6wi1SQt/unX3NlA9/tZXFxs4=;
        b=E9Vab5f0FwUPadAxTTsGtOJpRWVeETQ3tnUpRhMlesOKrKTN0ri7KBGDD5HwbR8R6p
         AJiPqrYCcmDmR2CXWx8PjRH+rKGvYfO5C61sHqAArSSnspZVz2DK8TjAVU3sTcV6lqqj
         QKKYlLElX1VPC1UIAZEjccnHfhvtgmp5wG9Ow6T/EF9mkxdxh4f59KuGEZT8JjjR7Pzq
         z4ROMetl0z69+C2muYN9+dOKsEEzUT8AMB/XA3zyyBdFTtLXLgIGVPNhodoaI9cmkSaJ
         hVh16p/L/ohtFCwEcYFREcTXwxGdVg0TVfDFvPMVvJDZU2ZXEJAWfpppSboxivcyC4NO
         fn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746547057; x=1747151857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82szPLcDXXwvSQ58Vad6wi1SQt/unX3NlA9/tZXFxs4=;
        b=gv3BCKObUgmJxLGlFwK1JKq5lMJ6umIWbQv2l5MM51BjS9v/8KS1lo7rjU9QKzVKcr
         Q8usGHiqf0S3qtxuWbwpuNhKXYodMhtkd1Ywr5ZY2k1i7dTWDUS+QyrGYtpf/cnhaFt7
         1gkit9axrYWkYgddHQI1Ssq9uRTApcD/i+LmHCVmfkx3nkiBhJVdzQDNQfn9AfUtfvvv
         B7Dzu6AGp8WpCnd8f8dWyRNhEHuSChGJHEB0lvz1dNyjWxwLwD8vTqJnJx0DIc3S9/LY
         jlyhXk9XoMEXhJF7Jn9GzcuLIZBQGK7d2YvI5uMdoMJX0dLPt7Wi88BJllXkzTiVIQkB
         SMLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOglKuO+W8/eOPk0HJSYt5KLlxoMTUvQDDPQP/uBylVvTSSH648spZ/uDa+jwaz191ivQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFnJQtRSCnXTHITs2W3G/TXbG3TtsnIuPue2RDioKg/mEsE6uP
	xl4ve65OLfJiIc+Fsph9N9LOGkTndtKTHO1sOEV9911t2KL0n37oHkdTwOoBPf4SPmU9cR9jaeQ
	hiw==
X-Google-Smtp-Source: AGHT+IG2VFH1wSD18xRDddv0hgK00HGNoXLRAE7B72u0/t9CQiIyb6Bq2SPEZzRGzlMmuQ/W/U0QS1Iq0fw=
X-Received: from pjbpm5.prod.google.com ([2002:a17:90b:3c45:b0:2ff:5516:6add])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5245:b0:2ff:58a4:9db3
 with SMTP id 98e67ed59e1d1-30a7c0e41c1mr5310957a91.35.1746547057607; Tue, 06
 May 2025 08:57:37 -0700 (PDT)
Date: Tue, 6 May 2025 08:57:36 -0700
In-Reply-To: <aBoc0MhlvO4hR03u@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250505180300.973137-1-seanjc@google.com> <aBnbBL8Db0rHXxFX@google.com>
 <aBoZpr2HNPysavjd@google.com> <aBoc0MhlvO4hR03u@google.com>
Message-ID: <aBoxcOPWRWyFIgVE@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Larabel <Michael@michaellarabel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 06, 2025, Yosry Ahmed wrote:
> On Tue, May 06, 2025 at 07:16:06AM -0700, Sean Christopherson wrote:
> > On Tue, May 06, 2025, Yosry Ahmed wrote:
> > > On Mon, May 05, 2025 at 11:03:00AM -0700, Sean Christopherson wrote:
> > > > +static void svm_srso_vm_destroy(void)
> > > > +{
> > > > +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> > > > +		return;
> > > > +
> > > > +	if (atomic_dec_return(&srso_nr_vms))
> > > > +		return;
> > > > +
> > > > +	guard(spinlock)(&srso_lock);
> > > > +
> > > > +	/*
> > > > +	 * Verify a new VM didn't come along, acquire the lock, and increment
> > > > +	 * the count before this task acquired the lock.
> > > > +	 */
> > > > +	if (atomic_read(&srso_nr_vms))
> > > > +		return;
> > > > +
> > > > +	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);
> > > 
> > > Just a passing-by comment. I get worried about sending IPIs while
> > > holding a spinlock because if someone ever tries to hold that spinlock
> > > with IRQs disabled, it may cause a deadlock.
> > > 
> > > This is not the case for this lock, but it's not obvious (at least to
> > > me) that holding it in a different code path that doesn't send IPIs with
> > > IRQs disabled could cause a problem.
> > > 
> > > You could add a comment, convert it to a mutex to make this scenario
> > > impossible,
> > 
> > Using a mutex doesn't make deadlock impossible, it's still perfectly legal to
> > disable IRQs while holding a mutex.
> 
> Right, but it's illegal to hold a mutex while disabling IRQs.

Nit on the wording: it's illegal to take a mutex while IRQs are disabled.  Disabling
IRQs while already holding a mutex is fine.

And it's also illegal to take a spinlock while IRQs are disabled, becauase spinlocks
become sleepable mutexes with PREEMPT_RT=y.  While PREEMPT_RT=y isn't super common,
people do run KVM with PREEMPT_RT=y, and I'm guessing bots/CI would trip any such
violation quite quickly.

E.g. with IRQs disabled around the guard(spinlock)(&srso_lock):

 BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
 in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 2799, name: qemu
 preempt_count: 0, expected: 0
 RCU nest depth: 0, expected: 0
 1 lock held by qemu/2799:
  #0: ffffffff8263f898 (srso_lock){....}-{3:3}, at: svm_vm_destroy+0x47/0xa0
 irq event stamp: 9090
 hardirqs last  enabled at (9089): [<ffffffff81414087>] vprintk_store+0x467/0x4d0
 hardirqs last disabled at (9090): [<ffffffff812fd1ce>] svm_vm_destroy+0x5e/0xa0
 softirqs last  enabled at (0): [<ffffffff8137585c>] copy_process+0xa1c/0x29f0
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 Call Trace:
  <TASK>
  dump_stack_lvl+0x57/0x80
  __might_resched.cold+0xcc/0xde
  rt_spin_lock+0x5b/0x170
  svm_vm_destroy+0x47/0xa0
  kvm_destroy_vm+0x180/0x310
  kvm_vm_release+0x1d/0x30
  __fput+0x10d/0x2f0
  task_work_run+0x58/0x90
  do_exit+0x325/0xa80
  do_group_exit+0x32/0xa0
  get_signal+0xb5b/0xbb0
  arch_do_signal_or_restart+0x29/0x230
  syscall_exit_to_user_mode+0xea/0x180
  do_syscall_64+0x7a/0x220
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7fb50ae7fc4e
  </TASK>

> In this case, if the other CPU is already holding the lock then there's no
> risk of deadlock, right?

Not on srso_lock, but there's still deadlock potential on the locks used to protect
the call_function_data structure.

> > Similarly, I don't want to add a comment, because there is absolutely nothing
> > special/unique about this situation/lock.  E.g. KVM has tens of calls to
> > smp_call_function_many_cond() while holding a spinlock equivalent, in the form
> > of kvm_make_all_cpus_request() while holding mmu_lock.
> 
> Agreed that it's not a unique situation at all. Ideally we'd have some
> debugging (lockdep?) magic that identifies that an IPI is being sent
> while a lock is held, and that this specific lock is never spinned on
> with IRQs disabled.

Sleepable spinlocks aside, the lockdep_assert_irqs_enabled() in
smp_call_function_many_cond() already provides sufficient of coverage for that
case.  And if code is using some other form of IPI communication *and* taking raw
spinlocks, then I think it goes without saying that developers would need to be
very, very careful.

> > smp_call_function_many_cond() already asserts that IRQs are disabled, so I have
> > zero concerns about this flow breaking in the future.
> 
> That doesn't really help tho, the problem is if another CPU spins on the
> lock with IRQs disabled, regardless of whether or not it. Basically if
> CPU 1 acquires the lock and sends an IPI while CPU 2 disables IRQs and
> spins on the lock.

Given that svm_srso_vm_destroy() is guaranteed to call on_each_cpu() with the
lock held at some point, I'm completely comfortable relying on its lockdep
assertion.

> > > or dismiss my comment as being too paranoid/ridiculous :)
> > 
> > I wouldn't say your thought process is too paranoid; when writing the code, I had
> > to pause and think to remember whether or not using on_each_cpu() while holding a
> > spinlock is allowed.  But I do think the conclusion is wrong :-)
> 
> That's fair. I think protection against this should be done more generically
> as I mentioned earlier, but it felt like it would be easy-ish to side-step it
> in this case.

Eh, modifying this code in such a way that it could deadlock without lockdep
noticing would likely send up a comincal number of red flags during code review.

