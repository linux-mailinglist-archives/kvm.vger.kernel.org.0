Return-Path: <kvm+bounces-62665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7DFC49E8C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 01:48:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B2E694EF1FC
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6092472A6;
	Tue, 11 Nov 2025 00:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqElORJV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14BD282EB
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 00:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822004; cv=none; b=XNKnkFF8in+PTAEAZkFrmeWK0ahzYoqTAcMLacccUqqQTWI7Faw9i79WWZzzmsz90bBUCOFMwBfSp3VBd4zVX9mYdIL6kchmgNMBID0PJ+oNQGxw8kvdo4HtIN+fLOUQMaKjxHDV/LIIgcCbT3wG9kZWxvC2ykSZ+/cmgUsuYcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822004; c=relaxed/simple;
	bh=/kOuNrBIK7LxQSnl0LtISpi6FERK4LvLScheOr3MFsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=csYGy4R1fjNrfth0FJB3ZrLSgXNdlkwceys577yq5DCPxkHmHzrXaXOxAmatsN5ia3WBfEwSDT9S6xoEKlmwhkGuSzSVOB3uxBp6QgPKGqUBe6DybcTI6rFccaafzh1A59QuqHLUwP6fIOlkfGyJGYNzId97rwHOlMxNUJfCJPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fqElORJV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3437863d0easo2234885a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 16:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762822002; x=1763426802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h4vJAtM1hvkS6u/nhIsyPK7Ri59l7kOtBGD7RmJImMA=;
        b=fqElORJVkrUnV0jPV0EZF1zMJ7XnqLy0w6rncpchnaInFCwoFG2s0IO8ww9k/EmfCw
         jFrs9LVY1lvhrKpkSQYBmd/6kqCNAJnOhxXxGlCw0TvFWKw4NMXo0+qmp/2ariXykpcb
         HysvBu3t3bnEQ4Yep4gy6VQtq/GVWydO1s7Y3uJORF1MzNpKD1CWgTE8H++h5C/OJ0wz
         D7YC/eyK69SLLKBdZbaMzqxP+9RYOcrPBrwc7lWdna3dn+a4DawemGLAwiiPDNus4FdY
         spFxrlQl/hlUq+nDv81xGmXkcry82fJK9/tNIOoYnnBrtWMH1xXK8v5f4ljwSJcRRD89
         D3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762822002; x=1763426802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4vJAtM1hvkS6u/nhIsyPK7Ri59l7kOtBGD7RmJImMA=;
        b=fMFwY/vZxZZNKzj4xaThOeSmToJC1ViDhinimOIwt3YCdLH3NqLxbikePKJaWXrUUY
         JDXUHvoBBovVZWl5C0H0QVKb8yKibtBVz2m0L+ayROx+RgLlSdclWicKq+ZLlZfc0anz
         HLEVEnaMejQ9s0Lnh+DoFlc/TsNa2jY7bJmX6qj4ynUOd5mYZsJBFHahyfln1jvB/oBb
         iDeMm0tbq6n+F7+cjfKzcQjS891CQTdq6Qv41lZQDipWLVCLYIojgM++X83xIaXDwbzI
         41A3gvaTbMtlfwPNLzbm4oTBlMjygQhP7JN7i6ZrgmpfRYxcoYDgPGLofpnzQB8scsMG
         GbcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEzwLn6+waLDi34S6zHJNy01Aam4jwasRlGglShJuS+9AGOBlop5gi9snlzOhkGCmYlZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeYAoTs5c2VkO04fDmtoGwdEoL09T9wqyWbYILyonQ3EGd7J6R
	qQlok2gjre/29d8p91io2qJN0CD6XmfxwYRQdjGgLm/V/KDZRzdKjlZRZTFGy33dbpkiZnIKwHk
	1PDDMGA==
X-Google-Smtp-Source: AGHT+IHcaJ4X3ikYmgLrfgdBZzRpo1g4lATJ/hYMlR312OeSq9NeNoarN32vs8Cum9bFa9VBfwMgpV/EJi4=
X-Received: from pjve4.prod.google.com ([2002:a17:90a:da04:b0:339:ee20:f620])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e710:b0:341:8bdd:5cf3
 with SMTP id 98e67ed59e1d1-3436cb739d3mr12728884a91.7.1762822002110; Mon, 10
 Nov 2025 16:46:42 -0800 (PST)
Date: Mon, 10 Nov 2025 16:46:40 -0800
In-Reply-To: <20251107034802.39763-2-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107034802.39763-1-fuqiang.wng@gmail.com> <20251107034802.39763-2-fuqiang.wng@gmail.com>
Message-ID: <aRKHcPLEEHTE5hpJ@google.com>
Subject: Re: [PATCH v5 1/1] KVM: x86: Fix VM hard lockup after prolonged
 suspend with periodic HV timer
From: Sean Christopherson <seanjc@google.com>
To: fuqiang wang <fuqiang.wng@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Marcelo Tosatti <mtosatti@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yu chen <33988979@163.com>, dongxu zhang <xu910121@sina.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 07, 2025, fuqiang wang wrote:
> When a VM is suspended while using the periodic HV timer, the KVM timer
> also ceases to advance. After the VM resumes from a prolonged suspend,

Maybe it's because I've been dealing with a variety of different suspend+resume
issue, but I find it confusing to talk about suspend+resume, partly because it's
not immediately clear if you're talking about _host_ suspend+resume versus guest
suspend+resume.  And suspend+resume isn't the only way this issue could be hit,
e.g. userspace could simply stop running a VM for whatever reason and get the
same result.

I even think we should downplay the HV timer / VMX Preemption Timer angle to
some extent, because restarting the hrtimer if it expires while the vCPU is in
userspace is wasteful and unnecessary.  And if we ever "fix" that, e.g. maybe by
not restarting the hrtimer if vcpu->wants_to_run is false, then the hard lockup
could be hittable even without the HV timer.

> there will be a huge gap between target_expiration and the current time.
> Because target_expiration is incremented by only one period on each KVM
> timer expiration, this leads to a series of KVM timer expirations occurring
> rapidly after the VM resumes.
> 
> More critically, when the VM first triggers a periodic HV timer expiration
> after resuming, executing advance_periodic_target_expiration() advance
> target_expiration by one period, but it will still be earlier than the
> current time (now).  As a result, delta may be calculated as a negative
> value. Subsequently, nsec_to_cycles() convert this delta into an absolute
> value larger than guest_l1_tsc, resulting in a negative tscdeadline. Since
> the hv timer supports a maximum bit width of cpu_preemption_timer_multi +
> 32, this causes the hv timer setup to fail and switch to the sw timer.
> 
> After switching to the software timer, periodic timer expiration callbacks
> may be executed consecutively within a single clock interrupt handler, with
> interrupts disabled until target_expiration is advanced to now. If this
> situation persists for an extended period, it could result in a hard
> lockup.
> 
> Here is a stack trace from a Windows VM that encountered a hard lockup
> after resuming from a long suspend.
> 
>   NMI watchdog: Watchdog detected hard LOCKUP on cpu 45
>   ...
>   RIP: 0010:advance_periodic_target_expiration+0x4d/0x80 [kvm]
>   ...
>   RSP: 0018:ff4f88f5d98d8ef0 EFLAGS: 00000046
>   RAX: fff0103f91be678e RBX: fff0103f91be678e RCX: 00843a7d9e127bcc
>   RDX: 0000000000000002 RSI: 0052ca4003697505 RDI: ff440d5bfbdbd500
>   RBP: ff440d5956f99200 R08: ff2ff2a42deb6a84 R09: 000000000002a6c0
>   R10: 0122d794016332b3 R11: 0000000000000000 R12: ff440db1af39cfc0
>   R13: ff440db1af39cfc0 R14: ffffffffc0d4a560 R15: ff440db1af39d0f8
>   FS:  00007f04a6ffd700(0000) GS:ff440db1af380000(0000) knlGS:000000e38a3b8000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 000000d5651feff8 CR3: 000000684e038002 CR4: 0000000000773ee0
>   PKRU: 55555554
>   Call Trace:
>    <IRQ>
>    apic_timer_fn+0x31/0x50 [kvm]
>    __hrtimer_run_queues+0x100/0x280
>    hrtimer_interrupt+0x100/0x210
>    ? ttwu_do_wakeup+0x19/0x160
>    smp_apic_timer_interrupt+0x6a/0x130
>    apic_timer_interrupt+0xf/0x20
>    </IRQ>
> 
> Moreover, if the suspend duration of the virtual machine is not long enough
> to trigger a hard lockup in this scenario, due to the commit 98c25ead5eda
> ("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86"), if the
> guest is using the sw timer before blocking, it will continue to use the sw
> timer after being woken up, and will not switch back to the hv timer until
> the relevant APIC timer register is reprogrammed.  Since the periodic timer
> does not require frequent APIC timer register programming, the guest may
> continue to use the software timer for an extended period.
> 
> This patch makes the following modification: When handling KVM periodic
> timer expiration, if we find that the advanced target_expiration is still
> less than now, we set target_expiration directly to now (just like how
> update_target_expiration handles the remaining).

Please don't use "this patch" (it's superfluous since this is obvioulsy a patch),
or pronouns like "we" and "us" as pronouns are often ambiguous in the world of
KVM.  E.g. "we" might me "we the cloud provider", "we the VMM", "we as KVM", "we
as the host kernel", etc.

> Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
> Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
> ---
>  arch/x86/kvm/lapic.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0ae7f913d782..bc082271c81c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2131,18 +2131,34 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>  	ktime_t delta;
>  
>  	/*
> -	 * Synchronize both deadlines to the same time source or
> -	 * differences in the periods (caused by differences in the
> -	 * underlying clocks or numerical approximation errors) will
> -	 * cause the two to drift apart over time as the errors
> -	 * accumulate.
> +	 * Use kernel time as the time source for both deadlines so that they
> +	 * stay synchronized.  Computing each deadline independently will cause
> +	 * the two deadlines to drift apart over time as differences in the
> +	 * periods accumulate, e.g. due to differences in the underlying clocks
> +	 * or numerical approximation errors.
>  	 */
>  	apic->lapic_timer.target_expiration =
>  		ktime_add_ns(apic->lapic_timer.target_expiration,
>  				apic->lapic_timer.period);
> +
> +	/*
> +	 * When the vm is suspend, the hv timer also stops advancing. After it
> +	 * is resumed, this may result in a large delta. If the

This definitely shouldn't talk about suspend+resume, because that's fully a VMM
concept and isn't the _only_ way to end up with a huge delta.

> +	 * target_expiration only advances by one period each time, it will
> +	 * cause KVM to frequently handle timer expirations.

It's also worth calling out that KVM will only deliver a single IRQ to the guest,
i.e. restarting the timer over and over (and over and over) is completey usless.
*Except* if KVM is posting IRQs across CPUs, e.g. running hrtimers on housekeeping
CPUs, in which case KVM really will deliver an interrupt storm to the guest.

But I don't want to try and special case that mode, because there's no guarantee
KVM can post a timer, and I don't want to have arbitrarily different guest-visible
behavior based on a fairly obscure module param (and other settings).  So unless
I too am missing something, setting the target expiration to "now" seems like the
way to go.

> +	 */
> +	if (apic->lapic_timer.period > 0 &&

apic->lapic_timer.period is guaranteed to be zero here.  kvm_lapic_expired_hv_timer()
and start_sw_period() check it explicitly, and apic_timer_fn() should be unreachable
with period==0 (KVM is supposed to cancel the hrtimer before changing the period).

I do think it's worth hardening apic_timer_fn() though, but in a separate prep
patch.

> +	    ktime_before(apic->lapic_timer.target_expiration, now))
> +		apic->lapic_timer.target_expiration = now;
> +
>  	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
> -	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
> -		nsec_to_cycles(apic->vcpu, delta);
> +	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
> +	/*
> +	 * Note: delta must not be negative. Otherwise, blindly adding a
> +	 * negative delta could cause the deadline to become excessively large
> +	 * due to the tscdeadline being an unsigned value.
> +	 */

Rather than say "delta must not be negative", instead call out that the delta
_can't_ be negative thanks to the above calculation (which is also why moving
the "period > 0" check to the caller is important).  And I think it's worth
putting this comment above the calculation of "delta" to preserve the existing
code that does "tscdead = l1_tsc + delta" (and it yields a smaller diff).

> +	apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
>  }
>  
>  static void start_sw_period(struct kvm_lapic *apic)
> @@ -2972,7 +2988,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
>  
>  	if (lapic_is_periodic(apic)) {
>  		advance_periodic_target_expiration(apic);
> -		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
> +		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);

This can also go in a separate prep patch.  Logically it stands on its own (use
the computed expiration instead of doing yet another calculation), and in case
something goes sideways, it'll give us another bisection point.

Lastly, adding a cleanup patch on top to capture apic->lapic_timer in a local
variable would make this code easier to read (I don't want to say "easy" to
read, but at least easier :-D).

All in all, I ended up with the below.  I'll post a v6 tomorrow (I've got the
tweaks made locally) after testing.  Thanks much!

static void advance_periodic_target_expiration(struct kvm_lapic *apic)
{
	struct kvm_timer *ktimer = &apic->lapic_timer;
	ktime_t now = ktime_get();
	u64 tscl = rdtsc();
	ktime_t delta;

	/*
	 * Use kernel time as the time source for both the hrtimer deadline and
	 * TSC-based deadline so that they stay synchronized.  Computing each
	 * deadline independently will cause the two deadlines to drift apart
	 * over time as differences in the periods accumulate, e.g. due to
	 * differences in the underlying clocks or numerical approximation errors.
	 */
	ktimer->target_expiration = ktime_add_ns(ktimer->target_expiration,
						 ktimer->period);

	/*
	 * If the new expiration is in the past, e.g. because userspace stopped
	 * running the VM for an extended duration, then force the expiration
	 * to "now" and don't try to play catch-up with the missed events.  KVM
	 * will only deliver a single interrupt regardless of how many events
	 * are pending, i.e. restarting the timer with an expiration in the
	 * past will do nothing more than waste host cycles, and can even lead
	 * to a hard lockup in extreme cases.
	 */
	if (ktime_before(ktimer->target_expiration, now))
		ktimer->target_expiration = now;

	/*
	 * Note, ensuring the expiration isn't in the past also prevents delta
	 * from going negative, which could cause the TSC deadline to become
	 * excessively large due to it an unsigned value.
	 */
	delta = ktime_sub(ktimer->target_expiration, now);
	ktimer->target_expiration = kvm_read_l1_tsc(apic->vcpu, tscl) +
				    nsec_to_cycles(apic->vcpu, delta);
}

