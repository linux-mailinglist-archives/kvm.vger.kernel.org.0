Return-Path: <kvm+bounces-70860-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8POpF4uhjGkkrwAAu9opvQ
	(envelope-from <kvm+bounces-70860-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:34:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B35E4125B6E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7FAD1301991C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2178130149E;
	Wed, 11 Feb 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="msU/eyCj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A41B207A32
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824066; cv=none; b=kXe+SmcSjgx559+SMyvfvJaXGOkSR3tYF0eNA239ZFTz6gAHMQn8DiZ3HRywrqYZmKcxdCjTtBeBKFS/25Z8C9maOP0csbiWPWUXBNahxbOvZOI5t8X1i54vbmd9t02GAfmGp1cgZ9nwOaeBpRZ3AisyQsGWTZUYFxzIsJFxj4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824066; c=relaxed/simple;
	bh=Y4BBXD4TqbsbTCp/hhnEWPoBXyVZSj4HcFNm9BuH0io=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7Ffb0ygKctiB6jrBQW1m+fH45GaDUFVGTkw4YGBvjF866hM6Zwvheb8NcFJRMIFW5xJJCSn2V82/q3yIZXy8uWy0tKhAyYliWMbo50ELM/GKAnLI3uMu02mx518mbqnikmEY+RwfEdYtRxvQzgj5VFIj+uh+Kpi+pOx6yPa848=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=msU/eyCj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c67e92aad79so1330817a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770824063; x=1771428863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4KEeCZROYJyn1dyhO5+lkxTzIro646ilaaeEHlML6XE=;
        b=msU/eyCjbyxfNGSdIJwjxC2jzyi6cvsI/KDY3HX0nR1sCqg7kb4mYZ/Keqta+J8yV2
         qKGZXViMU3X+JiLswSSzi4KvjIg6Wx2D1RY/kyFbLybn+zC5CBATl8x8HmrJ1w1+mxB5
         1rzHr+QspoJSPcHPyFy1SkY1O0T7HGWDJRWy9wTiIDcd5RXXOLz3Z946WeXziwaTbsHB
         JTEiVtKKJpy4a/jHxHhxKh0rQUPvdM7a/llpbBvVQPhlmKycRAXBFdYfiAs4QZ6XYwJR
         WJsR3Gcr1sY3Ne0MJW3wGkcOAXzSzVA1wWz/weInQyJg6oFIGnGuU9gGT1Kc7dZxMwmn
         mMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824063; x=1771428863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KEeCZROYJyn1dyhO5+lkxTzIro646ilaaeEHlML6XE=;
        b=HNVGto9VmBHBGyD3K2arcNqvylbClaU797YpV0PL3vs/OIWLwJZRDlvj0Bxfh2KNo7
         sr/RVvFct7y3dgV6hRBupEPI2vxH9xItMg1omdnEOTY623cVZJY+0wqIoVxDLdIYVQwK
         r6SdaXdGE4KTAwmGIy7PwM98Np/xbkLSP/tPFcOmWHcAj0Yx9N3RKLcEIpsu5pn43JJ1
         yEpAdiMb2PUz0kMWpUA+iR9IOB71oYOdSmtTF94FJ3eUFkgbpdk17j8llzt1dvEiXlW3
         8T6MIU7amVx1I7qMdgr3KrqqY8WgSOR8o+IjZxOeg2Y+mt+/Vot8s1X9up5BcKr0ZerR
         IIXg==
X-Forwarded-Encrypted: i=1; AJvYcCX+7QE19nXPOYbMC5UH6q4btkCH1C4lgzCa83HNs8KrPZRfa+p8cXKFrtLiFTxt94Gnl/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWqpj7YjywjwOi48ggOG3DW1WuHGhB8rFZ/UOW52nFGLeG4k8R
	arORUB6CPc6f+U0LYWc/8itkYY0OzjPXJGMYXP/W+GVb7M3OqwsMyVEsUWkEqTAg1UVds/smBFL
	0xDaLTA==
X-Received: from pjyd14.prod.google.com ([2002:a17:90a:dfce:b0:34c:e69b:d74f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d12f:b0:393:74ed:7de9
 with SMTP id adf61e73a8af0-393acf885dbmr16306207637.3.1770824063511; Wed, 11
 Feb 2026 07:34:23 -0800 (PST)
Date: Wed, 11 Feb 2026 07:34:22 -0800
In-Reply-To: <20260211120944.-eZhmdo7@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209161527.31978-1-shaikhkamal2012@gmail.com> <20260211120944.-eZhmdo7@linutronix.de>
Message-ID: <aYyhfvC_2s000P7H@google.com>
Subject: Re: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping
 for non-blocking invalidations
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "shaikh.kamal" <shaikhkamal2012@gmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70860-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lists.linux.dev];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B35E4125B6E
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Sebastian Andrzej Siewior wrote:
> On 2026-02-09 21:45:27 [+0530], shaikh.kamal wrote:
> > mmu_notifier_invalidate_range_start() may be invoked via
> > mmu_notifier_invalidate_range_start_nonblock(), e.g. from oom_reaper(),
> > where sleeping is explicitly forbidden.
> > 
> > KVM's mmu_notifier invalidate_range_start currently takes
> > mn_invalidate_lock using spin_lock(). On PREEMPT_RT, spin_lock() maps
> > to rt_mutex and may sleep, triggering:
> > 
> >   BUG: sleeping function called from invalid context
> > 
> > This violates the MMU notifier contract regardless of PREEMPT_RT;

I highly doubt that.  kvm.mmu_lock is also a spinlock, and KVM has been taking
that in invalidate_range_start() since

  e930bffe95e1 ("KVM: Synchronize guest physical memory map to host virtual memory map")

which was a full decade before mmu_notifiers even added the blockable concept in

  93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers")

and even predate the current concept of a "raw" spinlock introduced by

  c2f21ce2e312 ("locking: Implement new raw_spinlock")

> > RT kernels merely make the issue deterministic.

No, RT kernels change the rules, because suddenly a non-sleeping locking becomes
sleepable.

> > Fix by converting mn_invalidate_lock to a raw spinlock so that
> > invalidate_range_start() remains non-sleeping while preserving the
> > existing serialization between invalidate_range_start() and
> > invalidate_range_end().

This is insufficient.  To actually "fix" this in KVM mmu_lock would need to be
turned into a raw lock on all KVM architectures.  I suspect the only reason there
haven't been bug reports is because no one trips an OOM kill on VM while running
with CONFIG_DEBUG_ATOMIC_SLEEP=y.

That combination is required because since commit

  8931a454aea0 ("KVM: Take mmu_lock when handling MMU notifier iff the hva hits a memslot")

KVM only acquires mmu_lock if the to-be-invalidated range overlaps a memslot,
i.e. affects memory that may be mapped into the guest.

E.g. this hack to simulate a non-blockable invalidation

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7015edce5bd8..7a35a83420ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -739,7 +739,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
                .handler        = kvm_mmu_unmap_gfn_range,
                .on_lock        = kvm_mmu_invalidate_begin,
                .flush_on_ret   = true,
-               .may_block      = mmu_notifier_range_blockable(range),
+               .may_block      = false,//mmu_notifier_range_blockable(range),
        };
 
        trace_kvm_unmap_hva_range(range->start, range->end);
@@ -768,6 +768,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
         */
        gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
 
+       non_block_start();
        /*
         * If one or more memslots were found and thus zapped, notify arch code
         * that guest memory has been reclaimed.  This needs to be done *after*
@@ -775,6 +776,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
         */
        if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
                kvm_arch_guest_memory_reclaimed(kvm);
+       non_block_end();
 
        return 0;
 }

immediately triggers

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:241
  in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 4992, name: qemu
  preempt_count: 0, expected: 0
  RCU nest depth: 0, expected: 0
  CPU: 6 UID: 1000 PID: 4992 Comm: qemu Not tainted 6.19.0-rc6-4d0917ffc392-x86_enter_mmio_stack_uaf_no_null-rt #1 PREEMPT_RT 
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x51/0x60
   __might_resched+0x10e/0x160
   rt_write_lock+0x49/0x310
   kvm_mmu_notifier_invalidate_range_start+0x10b/0x390 [kvm]
   __mmu_notifier_invalidate_range_start+0x9b/0x230
   do_wp_page+0xce1/0xf30
   __handle_mm_fault+0x380/0x3a0
   handle_mm_fault+0xde/0x290
   __get_user_pages+0x20d/0xbe0
   get_user_pages_unlocked+0xf6/0x340
   hva_to_pfn+0x295/0x420 [kvm]
   __kvm_faultin_pfn+0x5d/0x90 [kvm]
   kvm_mmu_faultin_pfn+0x31b/0x6e0 [kvm]
   kvm_tdp_page_fault+0xb6/0x160 [kvm]
   kvm_mmu_do_page_fault+0xee/0x1f0 [kvm]
   kvm_mmu_page_fault+0x8d/0x600 [kvm]
   vmx_handle_exit+0x18c/0x5a0 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xc70/0x1c90 [kvm]
   kvm_vcpu_ioctl+0x2d7/0x9a0 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0x5e/0x11b0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>
  kvm: emulating exchange as write


It's not at all clear to me that switching mmu_lock to a raw lock would be a net
positive for PREEMPT_RT.  OOM-killing a KVM guest in a PREEMPT_RT seems like a
comically rare scenario.  Whereas contending mmu_lock in normal operation is
relatively common (assuming there are even use cases for running VMs with a
PREEMPT_RT host kernel).

In fact, the only reason the splat happens is because mmu_notifiers somewhat
artificially forces an atomic context via non_block_start() since commit

  ba170f76b69d ("mm, notifier: Catch sleeping/blocking for !blockable")

Given the massive amount of churn in KVM that would be required to fully eliminate
the splat, and that it's not at all obvious that it would be a good change overall,
at least for now:

NAK

I'm not fundamentally opposed to such a change, but there needs to be a _lot_
more analysis and justification beyond "fix CONFIG_DEBUG_ATOMIC_SLEEP=y".

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 5fcd401a5897..7a9c33f01a37 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -747,9 +747,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
> >  	 *
> >  	 * Pairs with the decrement in range_end().
> >  	 */
> > -	spin_lock(&kvm->mn_invalidate_lock);
> > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> >  	kvm->mn_active_invalidate_count++;
> > -	spin_unlock(&kvm->mn_invalidate_lock);
> > +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> 
> 	atomic_inc(mn_active_invalidate_count)
> >  
> >  	/*
> >  	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
> > @@ -817,11 +817,11 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
> >  	kvm_handle_hva_range(kvm, &hva_range);
> >  
> >  	/* Pairs with the increment in range_start(). */
> > -	spin_lock(&kvm->mn_invalidate_lock);
> > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> >  	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
> >  		--kvm->mn_active_invalidate_count;
> >  	wake = !kvm->mn_active_invalidate_count;
> 
> 	wake = atomic_dec_return_safe(mn_active_invalidate_count);
> 	WARN_ON_ONCE(wake < 0);
> 	wake = !wake;
> 
> > -	spin_unlock(&kvm->mn_invalidate_lock);
> > +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> >  
> >  	/*
> >  	 * There can only be one waiter, since the wait happens under
> > @@ -1129,7 +1129,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > @@ -1635,17 +1635,17 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
> >  	 * progress, otherwise the locking in invalidate_range_start and
> >  	 * invalidate_range_end will be unbalanced.
> >  	 */
> > -	spin_lock(&kvm->mn_invalidate_lock);
> > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> >  	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
> >  	while (kvm->mn_active_invalidate_count) {
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		spin_unlock(&kvm->mn_invalidate_lock);
> > +		raw_spin_unlock(&kvm->mn_invalidate_lock);
> >  		schedule();
> 
> And this I don't understand. The lock protects the rcuwait assignment
> which would be needed if multiple waiters are possible. But this goes
> away after the unlock and schedule() here. So these things could be
> moved outside of the locked section which limits it only to the
> mn_active_invalidate_count value.

The implementation is essentially a deliberately unfair rwswem.  The "write" side
in kvm_swap_active_memslots() subtly protect this code:

  rcu_assign_pointer(kvm->memslots[as_id], slots);

and the "read" side protects the kvm->memslot lookups in kvm_handle_hva_range().

KVM optimizes its mmu_notifier invalidation path to only take action if the
to-be-invalidated range overlaps one or more memslots, i.e. affects memory that
be can be mapped into the guest.  The wrinkle with those optimizations is that
KVM needs to prevent changes to the memslots between invalidation start() and end(),
otherwise the accounting can become imbalanced, e.g. mmu_invalidate_in_progress
will underflow or be left elevated and essentially hang the VM (among other bad
things).

So simply making mn_active_invalidate_count an atomic won't suffice, because KVM
needs to block start() to ensure start()+end() see the exact same set of memslots.

