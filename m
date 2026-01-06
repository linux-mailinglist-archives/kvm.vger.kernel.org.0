Return-Path: <kvm+bounces-67155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B99CFB271
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 22:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6EB8E308B345
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 21:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E7B34B195;
	Tue,  6 Jan 2026 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ub9QFSf4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3434AB1E
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719963; cv=none; b=F0g8QNlOViZ9oKsdkJ6Me5dBMouxySmt3N2EJ8+b4T4uEPzuTT88TGQO1M0d3WyMOgD7pWOQNiJrWyI0B0yJNQ82F/ubQlhyfEMhLDVByksbMU0Wg9kLgmyTP23HKLvxi/nv7r1xFnp7h/md7eMvi6ctlcihW6Nng8/f4ZExD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719963; c=relaxed/simple;
	bh=KyAVrWzv3AID7JMa80Wqw08D32rx5181M5Uz4WEsr4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bWam4hqwa+Pr9TVvfzAXjwXFj4g3wfQm5HXeqGcvZ1ezBpa5oFDOzA05YKwUXOxAeGnBO6JQYm6FmiiPyNrljnx8OWOLeoyWs/IqWrC8pnuoT8HVI/lF6J6Nqh6lcu4hVNpXihkHEPrIFCuSFYri4CAbExeOSER2epijKmNXKT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ub9QFSf4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a07fa318fdso17880495ad.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 09:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767719961; x=1768324761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HniCsd4ODup/fdDva7XbnCYJAp8ItqdAhsexUFQc9RM=;
        b=Ub9QFSf4V8lChLq3bV9NV+C8/bR3XwDANetCPy+J+dT6PyrqhyyfULM3fpisWwQBk9
         Y9OhIiUvdRoN8jnFf6ALOvNFnYnVKDfYQYZVwzqSbt7a7H3psApVZYfbC0u8aBUdzBqu
         x9hejFaLr8zen51tw9KkI2qqlIVX8Yno/+ou5dmiGIbycikKpfGuaVw1t9wMoXqyay2r
         kbxSMMUWEsBiwpbTH+l2cLiBL8IXgblT9f/Ub3ZvQhx/CwYQKNfSEWHhd1EGSLyovtS4
         5ctt5lmoHNKCyp1KCJIEQHYWCMj1VCGShqDt4LpcGzs05V6v61qR+cXhte7b5WoaBzaf
         WGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767719961; x=1768324761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HniCsd4ODup/fdDva7XbnCYJAp8ItqdAhsexUFQc9RM=;
        b=m1V/w+wuNQGPEMZIDAd59vvD252+sJWmk953V7fYRGQAaDoRXIAMC/nQhnvCVPMcvM
         j+54qR9TVIrmgFWHcfObzkcEljyGUoabVvar54eJgd/4x936up9bBzyojWtI5fumo8cR
         nc7bMzWkdfY2TTTeQGSIAz06yEPZ/TJj0aPLzPmUSM9WrJHDx8Zm5kXIjnWaK6EKCe4e
         urCs2Z0SIpfR1Ei6AEWpAGu4Q8KPsVjjkDij2HGteCrcfQU3z45u9jI2GGXFYtLya+gx
         StRNK5a9UKeGWkOnuDQnvHkujiPM4ialwwX1yYtFbrSvmZZd3PvDPZFJ5R7uOn4TXoOf
         bbDw==
X-Forwarded-Encrypted: i=1; AJvYcCWlsi2D8vhByRBlyV5PMz+xPtQoEQL4GS9RryFJYFmBTV/fBLvw8yGLaZFZjKUIg1hDoxE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmz/TubeShgErFG8H0Eor0yQ5eMX9KUW7M51hhCkIRFXNKRy4h
	p/4YY9n1lX4K5hxK5+4fgAvqDi7kJvU6wgbPuIOEhTID8rDqeCoVriI5DXAgBZbmbx3ARPIf+/Y
	I+tyMjQ==
X-Google-Smtp-Source: AGHT+IHyS7zlYGcQubwOVWHsPNUuLoDSaTcet4YEYvFTyEy7rjsqt5ZlGKGrsst2abDakkNkgyAv/um8oac=
X-Received: from plek17.prod.google.com ([2002:a17:903:4511:b0:2a0:974c:2e6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2d1:b0:2a0:f0e5:3f5c
 with SMTP id d9443c01a7336-2a3e2cef6d7mr32610505ad.34.1767719961264; Tue, 06
 Jan 2026 09:19:21 -0800 (PST)
Date: Tue, 6 Jan 2026 09:19:19 -0800
In-Reply-To: <20260104093221.494510-1-alessandro@0x65c.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260104093221.494510-1-alessandro@0x65c.net>
Message-ID: <aV1EF5DU5e66NTK0@google.com>
Subject: Re: [PATCH] KVM: x86: Retry guest entry on -EBUSY from kvm_check_nested_events()
From: Sean Christopherson <seanjc@google.com>
To: Alessandro Ratti <alessandro@0x65c.net>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Jan 04, 2026, Alessandro Ratti wrote:
> When a vCPU running in nested guest mode attempts to block (e.g., due
> to HLT), kvm_check_nested_events() may return -EBUSY to indicate that a
> nested event is pending but cannot be injected immediately, such as
> when event delivery is temporarily blocked in the guest.
> 
> Currently, vcpu_block() logs a WARN_ON_ONCE() and then treats -EBUSY
> like any other error, returning 0 to exit to userspace. This can cause
> the vCPU to repeatedly block without making forward progress, delaying
> event injection and potentially leading to guest hangs under rare timing
> conditions.
> 
> Remove the WARN_ON_ONCE() and handle -EBUSY explicitly by returning 1
> to retry guest entry instead of exiting to userspace. This allows the
> nested event to be injected once the temporary blocking condition
> clears, ensuring forward progress.
> 
> This issue was triggered by syzkaller while exercising nested
> virtualization.

Syzkaller always ruins the fun :-(

> Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
> Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a
> Tested-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
> Signed-off-by: Alessandro Ratti <alessandro@0x65c.net>
> ---
>  arch/x86/kvm/x86.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff8812f3a129..d5cf9a7ff8c5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11596,7 +11596,15 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  	if (is_guest_mode(vcpu)) {
>  		int r = kvm_check_nested_events(vcpu);
>  
> -		WARN_ON_ONCE(r == -EBUSY);
> +		/*
> +		 * -EBUSY indicates a nested event is pending but cannot be
> +		 * injected immediately (e.g., event delivery is temporarily
> +		 * blocked). Return to the vCPU run loop to retry guest entry
> +		 * instead of blocking, which would lose the pending event.
> +		 */
> +		if (r == -EBUSY)
> +			return 1;

The code and the comment are both wrong.  Returning immediately will incorrectly
leave vcpu->arch.mp_state in a non-RUNNABLE state, and _that_ will put the vCPU
into an infinite loop.  The for-loop in vcpu_run() will always see the vCPU as
!running and so will call back into vcpu_block().  vcpu_block() will see the vCPU
as _runnable_ (but still not fully running!) because of the pending (and injected)
event, check nested events again, hit -EBUSY again, and repeat until the VMM kills
the VM.

And returning '0' doesn't block the vCPU, it triggers an exit to userspace.  In
most cases, the spurious exit will be KVM_EXIT_UNKNOWN, but it could be something
else entirely if KVM filled vcpu->run->exit_reason but didn't complete the exit
to userspace.

And as above, the pending event isn't lost, it'll still be pending if userspace
invokes KVM_RUN again.  Of course, unless userspace stuff MP_STATE, the infinite
will still occur, just with userspace's KVM_RUN loop being the outermost loop
(assuming userspace doesn't simply kill the VM).

I said above that syzkaller ruins the fun because, as noted by the changelog in
the Fixes commit, this scenario _should_ be impossible.  And AFAICT, within KVM
itself, that still holds true.  I finally found one of syzbot's reproducers that
is straightforward, i.e. doesn't require hitting a timing window with threading.
In that reproducer (see Link below), userspace stuff MP_STATE and an "injected"
event, thus forcing the vCPU into what is effectively an impossible state.

All of the other reproducers get into HALTED naturally by executing HLT in L2,
and then stuff an injected event.  I've never been able to repro those, because
hitting the WARN requires forcing the vCPU to exit to userspace (e.g. with a
signal) just after HLT is executed so that userspace can stuff event state.  But
in principle it's the same scenario: userspace stuffs impossible vCPU state.

For now, I'm pretty sure the least awful "fix" is to drop the WARN and continue
with waking the vCPU.  In all likelhiood, the garbage event stuffed by userspace
will generate a failed VM-Entry, which KVM will reflect to L1.  So L2 might die,
but L1 should live on, which more than good enough when userspace is being stupid,
and is about as good as we can do if KVM itself is buggy, i.e. if there's a
legitimate KVM but that generates impossible state.

I'll post the below as part of a series, as there is at least one cleanup that
can be done on top to consolidate handling of EBUSY, and I'm hopeful that the
spirit of the WARN can be preserved, e.g. by adding/extending WARNs in paths where
KVM (re)injects events.

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 Jan 2026 07:46:38 -0800
Subject: [PATCH] KVM: x86: Ignore -EBUSY when checking nested events from
 vcpu_block()

Ignore -EBUSY when checking nested events after exiting a blocking state
while L2 is active, as exiting to userspace will generate a spurious
userspace exit, usually with KVM_EXIT_UNKNOWN, and likely lead to the VM's
demise.  Continuing with the wakeup isn't perfect either, as *something*
has gone sideways if a vCPU is awakened in L2 with an injected event (or
worse, a nested run pending), but continuing on gives the VM a decent
chance of surviving without any major side effects.

As explained in the Fixes commits, it _should_ be impossible for a vCPU to
be put into a blocking state with an already-injected event (exception,
IRQ, or NMI).  Unfortunately, userspace can stuff MP_STATE and/or injected
events, and thus put the vCPU into what should be an impossible state.

Don't bother trying to preserve the WARN, e.g. with an anti-syzkaller
Kconfig, as WARNs can (hopefully) be added in paths where _KVM_ would be
violating x86 architecture, e.g. by WARNing if KVM attempts to inject an
exception or interrupt while the vCPU isn't running.

Cc: Alessandro Ratti <alessandro@0x65c.net>
Cc: stable@vger.kernel.org
Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")
Link: https://syzkaller.appspot.com/text?tag=ReproC&x=10d4261a580000
Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671bc7a7.050a0220.455e8.022a.GAE@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..4bf9be1e17a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11596,8 +11596,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		int r = kvm_check_nested_events(vcpu);
 
-		WARN_ON_ONCE(r == -EBUSY);
-		if (r < 0)
+		if (r < 0 && r != -EBUSY)
 			return 0;
 	}
 

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
--

