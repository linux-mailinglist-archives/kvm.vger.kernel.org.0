Return-Path: <kvm+bounces-45693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07943AAD6C5
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 09:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 385CE1C01EED
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AEF213E74;
	Wed,  7 May 2025 07:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sfvm9Ag1"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3DE23CB
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 07:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746601544; cv=none; b=EwUQrgXrBvkp7aiqBzGNE5zgMPO/jCiPo94oXdspChLHt1SEZqOKFSv3vTjFhZ4wsgvUyLVYuLEIyWErCKJrJtdUUD6QOryYrqFp/CS8Y82aCuEv8zDyrAUI/ajLBnyoqONru3UyGEnIDM1fhZuIhfa7otSTFX+kcCECL+4rHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746601544; c=relaxed/simple;
	bh=8sMgZtsBofGRCONLWZxr2nzcXo6BzCtS54/Y9ejsotw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnGsr1pS9angyGYZKYHP3+LKc+nb51BJm5xSaATa9iQGEM3AWcD40Z2+dn3H+zeJx9CIik8n8yne2uqcisWoOYauw64bfPodF2ZMXARaoDRdqdkS3A+04RXXO5dwzSSNK6c3l3WbmfbS8dGvLpaR+0JYVZAZ3tAraVwsH66CXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sfvm9Ag1; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 07:05:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746601529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwXGCKLUvkR+CK7jeYzmYMDP45CQNCvobFgoMRwBGTY=;
	b=Sfvm9Ag1gvu4eaQispHxszQc1k0aFmgSsKhOuzGRj4+ojyC8VWG78k3LY/Fim5JlSJweSn
	E0zJ4c86cf4FbTOOlxt1Z4RY2pm2cmrihgPCIgNs+g9rLaPdAXTr8r1kC7qVD9p3OpswBG
	ch8BiT6SGDRiTUFbgtUIdYNPXsju/jk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Larabel <Michael@michaellarabel.com>,
	Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1
 VM count transitions
Message-ID: <aBsGNPvG75KspVmp@google.com>
References: <20250505180300.973137-1-seanjc@google.com>
 <aBnbBL8Db0rHXxFX@google.com>
 <aBoZpr2HNPysavjd@google.com>
 <aBoc0MhlvO4hR03u@google.com>
 <aBoxcOPWRWyFIgVE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBoxcOPWRWyFIgVE@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 06, 2025 at 08:57:36AM -0700, Sean Christopherson wrote:
> On Tue, May 06, 2025, Yosry Ahmed wrote:
> > On Tue, May 06, 2025 at 07:16:06AM -0700, Sean Christopherson wrote:
> > > On Tue, May 06, 2025, Yosry Ahmed wrote:
> > > > On Mon, May 05, 2025 at 11:03:00AM -0700, Sean Christopherson wrote:
> > > > > +static void svm_srso_vm_destroy(void)
> > > > > +{
> > > > > +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> > > > > +		return;
> > > > > +
> > > > > +	if (atomic_dec_return(&srso_nr_vms))
> > > > > +		return;
> > > > > +
> > > > > +	guard(spinlock)(&srso_lock);
> > > > > +
> > > > > +	/*
> > > > > +	 * Verify a new VM didn't come along, acquire the lock, and increment
> > > > > +	 * the count before this task acquired the lock.
> > > > > +	 */
> > > > > +	if (atomic_read(&srso_nr_vms))
> > > > > +		return;
> > > > > +
> > > > > +	on_each_cpu(svm_srso_clear_bp_spec_reduce, NULL, 1);
> > > > 
> > > > Just a passing-by comment. I get worried about sending IPIs while
> > > > holding a spinlock because if someone ever tries to hold that spinlock
> > > > with IRQs disabled, it may cause a deadlock.
> > > > 
> > > > This is not the case for this lock, but it's not obvious (at least to
> > > > me) that holding it in a different code path that doesn't send IPIs with
> > > > IRQs disabled could cause a problem.
> > > > 
> > > > You could add a comment, convert it to a mutex to make this scenario
> > > > impossible,
> > > 
> > > Using a mutex doesn't make deadlock impossible, it's still perfectly legal to
> > > disable IRQs while holding a mutex.
> > 
> > Right, but it's illegal to hold a mutex while disabling IRQs.
> 
> Nit on the wording: it's illegal to take a mutex while IRQs are disabled.  Disabling
> IRQs while already holding a mutex is fine.

Yes :)

> 
> And it's also illegal to take a spinlock while IRQs are disabled, becauase spinlocks
> become sleepable mutexes with PREEMPT_RT=y.  While PREEMPT_RT=y isn't super common,
> people do run KVM with PREEMPT_RT=y, and I'm guessing bots/CI would trip any such
> violation quite quickly.

But I think spin_lock_irq() and friends aren't a violation with
PREEMPT_RT=y, so these wouldn't trip bots/CI AFAICT.

> 
> E.g. with IRQs disabled around the guard(spinlock)(&srso_lock):
> 
>  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
>  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 2799, name: qemu
>  preempt_count: 0, expected: 0
>  RCU nest depth: 0, expected: 0
>  1 lock held by qemu/2799:
>   #0: ffffffff8263f898 (srso_lock){....}-{3:3}, at: svm_vm_destroy+0x47/0xa0
>  irq event stamp: 9090
>  hardirqs last  enabled at (9089): [<ffffffff81414087>] vprintk_store+0x467/0x4d0
>  hardirqs last disabled at (9090): [<ffffffff812fd1ce>] svm_vm_destroy+0x5e/0xa0
>  softirqs last  enabled at (0): [<ffffffff8137585c>] copy_process+0xa1c/0x29f0
>  softirqs last disabled at (0): [<0000000000000000>] 0x0
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x57/0x80
>   __might_resched.cold+0xcc/0xde
>   rt_spin_lock+0x5b/0x170
>   svm_vm_destroy+0x47/0xa0
>   kvm_destroy_vm+0x180/0x310
>   kvm_vm_release+0x1d/0x30
>   __fput+0x10d/0x2f0
>   task_work_run+0x58/0x90
>   do_exit+0x325/0xa80
>   do_group_exit+0x32/0xa0
>   get_signal+0xb5b/0xbb0
>   arch_do_signal_or_restart+0x29/0x230
>   syscall_exit_to_user_mode+0xea/0x180
>   do_syscall_64+0x7a/0x220
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  RIP: 0033:0x7fb50ae7fc4e
>   </TASK>
> 
> > In this case, if the other CPU is already holding the lock then there's no
> > risk of deadlock, right?
> 
> Not on srso_lock, but there's still deadlock potential on the locks used to protect
> the call_function_data structure.
> 
> > > Similarly, I don't want to add a comment, because there is absolutely nothing
> > > special/unique about this situation/lock.  E.g. KVM has tens of calls to
> > > smp_call_function_many_cond() while holding a spinlock equivalent, in the form
> > > of kvm_make_all_cpus_request() while holding mmu_lock.
> > 
> > Agreed that it's not a unique situation at all. Ideally we'd have some
> > debugging (lockdep?) magic that identifies that an IPI is being sent
> > while a lock is held, and that this specific lock is never spinned on
> > with IRQs disabled.
> 
> Sleepable spinlocks aside, the lockdep_assert_irqs_enabled() in
> smp_call_function_many_cond() already provides sufficient of coverage for that
> case.  And if code is using some other form of IPI communication *and* taking raw
> spinlocks, then I think it goes without saying that developers would need to be
> very, very careful.

I think we are not talking about the same thing, or I am
misunderstanding you. The lockdep_assert_irqs_enabled() assertion in
smp_call_function_many_cond() does not protect against this case AFAICT.

Basically imagine that a new code path is added that does:

	spin_lock_irq(&srso_lock);
	/* Some trivial logic, no IPI sending */
	spin_unlock_irq(&srso_lock);

I believe spin_lock_irq() will disable IRQs (at least on some setups)
then spin on the lock.

Now imagine svm_srso_vm_destroy() is already holding the lock and sends
the IPI from CPU 1, while CPU 2 is executing the above code with IRQs
already disabled and spinning on the lock.

This is the deadlock scenario I am talking about. The lockdep assertion
in smp_call_function_many_cond() doesn't help because IRQs are enabled
on CPU 1, the problem is that they are disabled on CPU 2.

Lockdep can detect this by keeping track of the fact that some code
paths acquire the lock with IRQs off while some code paths acquire the
lock and send IPIs, I think.

> 
> > > smp_call_function_many_cond() already asserts that IRQs are disabled, so I have
> > > zero concerns about this flow breaking in the future.
> > 
> > That doesn't really help tho, the problem is if another CPU spins on the
> > lock with IRQs disabled, regardless of whether or not it. Basically if
> > CPU 1 acquires the lock and sends an IPI while CPU 2 disables IRQs and
> > spins on the lock.
> 
> Given that svm_srso_vm_destroy() is guaranteed to call on_each_cpu() with the
> lock held at some point, I'm completely comfortable relying on its lockdep
> assertion.
> 
> > > > or dismiss my comment as being too paranoid/ridiculous :)
> > > 
> > > I wouldn't say your thought process is too paranoid; when writing the code, I had
> > > to pause and think to remember whether or not using on_each_cpu() while holding a
> > > spinlock is allowed.  But I do think the conclusion is wrong :-)
> > 
> > That's fair. I think protection against this should be done more generically
> > as I mentioned earlier, but it felt like it would be easy-ish to side-step it
> > in this case.
> 
> Eh, modifying this code in such a way that it could deadlock without lockdep
> noticing would likely send up a comincal number of red flags during code review.

It just takes another code path using spin_lock_irq() or friends to
deadlock AFAICT.

Anyway, this has side tracked and I am probably taking more of your time
that I originally wanted, I was just making an observation more-or-less
:)

