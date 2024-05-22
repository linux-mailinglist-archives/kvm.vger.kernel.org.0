Return-Path: <kvm+bounces-17985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CDE8CC7F3
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C36391F20CC8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62241465AD;
	Wed, 22 May 2024 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZMsAi/rB";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jLnOj0g4"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6D182DB;
	Wed, 22 May 2024 21:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412034; cv=none; b=NPLknpZhC8w3MoSz5CsFELX6HgYzUHAO2suT15ldQqBCWUEykws6diK+6q+CcRgHGI0hfQX38qELmZv5xU1AuxabogadDtSLw+7eevYNl/TBCCjx6fjrcIPIsnOvcCvrJYCzsVPjhqC6mjJN26N+7xL2xELDrsaOrw3/hrtk/a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412034; c=relaxed/simple;
	bh=IXX192pD0raczuPL13k5ksQg23Qrdji8/ReRatFWZOY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f1y+Dd9xL2Hce1pidZWyrsPEn8n4JJmE+V/x8tIx4mRig/nqnBtclRI/mNdl8IXE030rRITTCzq0qHaTMPG5BSeCQ04OYc7z1dJ9Q3DK5llAwL8MvSHfAt2DPT0+tRzyTFXD2TB0G7206hYxjTua9NYWdqC11gVDmAb1MKPVnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZMsAi/rB; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jLnOj0g4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1716412030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jLVxSCQfoVeR8U2ERh+IiooD/MtttiK7XavkulJ8Sz8=;
	b=ZMsAi/rBw+STsdRVRyLD14gUdNDkd+kZfJcbn1yBmydUm4lwQV8f0h2lG+hlKfER2WUzqi
	CGN8pdvwlTCC7srgMxwuL3Cn6yW9SyPBYq2MUox0pBYBmkLaLAYrDTUz+xhzexmQ/HgQBP
	UOPsmgdENY8SpivY6JVeDwHOl0cOGcAYAvVmUMMweb8N0J17zKkXYK6SZlVgqA+asshM2j
	QUYj9AB/0Nx7Y0cF+X8p56Rqjzrp1zrNepGKU/fq+59/8yiefjH0ys87MbEJD1Moxm2f3v
	VIbom4CjiP1ozjmTONJTZSeET0ipafyLQ+4MeSFMCoBt1wiC0K39KJhwPVfMTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1716412030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jLVxSCQfoVeR8U2ERh+IiooD/MtttiK7XavkulJ8Sz8=;
	b=jLnOj0g48+pWO/rtZVTMq1YU81uGsKgOYmL0kb6c0mTC927Zqax2FcBY6lOfP0+tCpETOV
	gE0bEdFJPfICm7BA==
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC
 deadline timers
In-Reply-To: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
Date: Wed, 22 May 2024 23:07:10 +0200
Message-ID: <875xv5h7y9.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Dec 21 2023 at 18:51, Maxim Levitsky wrote:
> The test usually fails because L2 observes TSC after the 
> preemption timer deadline, before the VM exit happens.

That's an arguably silly failure condition.

Timer interrupt delivery can be late even on bare metal, so observing
TSC ahead of the expected timer event is not really wrong.

Btw, the kernel also handles it nicely when the timer event arrives
_before_ the expected time. It simply reprograms the timer and is done
with it. That's actually required because clocksource (which determines
time) and clockevent (which expires timers) can be on different clocks
which might drift against each other.

>     In particular, NTP performing a forward correction will result in
>     a timer expiring sooner than expected from a guest point of view.
>     Not a big deal, we kick the vcpu anyway.
>
>     But on wake-up, the vcpu thread is going to perform a check to
>     find out whether or not it should block. And at that point, the
>     timer check is going to say "timer has not expired yet, go back
>     to sleep". This results in the timer event being lost forever.

That's obviously a real problem.

>     There are multiple ways to handle this. One would be record that
>     the timer has expired and let kvm_cpu_has_pending_timer return
>     true in that case, but that would be fairly invasive. Another is
>     to check for the "short sleep" condition in the hrtimer callback,
>     and restart the timer for the remaining time when the condition
>     is detected.

:)

> So to solve this issue there are two options:

There is a third option:

   3. Unconditionally inject the timer interrupt into the guest when the
      underlying hrtimer has expired

      That's fine because timer interrupts can be early (see above) and
      any sane OS has to be able to handle it.

> 1. Have another go at implementing support for CLOCK_MONOTONIC_RAW timers. 
>    I don't know if that is feasible and I would be very happy to hear
>    a feedback from you.

That's a non-trivial exercise.

The charm of having all clocks related to CLOCK_MONOTONIC is that there
is zero requirement to take NTP frequency adjustments into account,
which makes the implementation reasonably simple and robust.

Changing everything over in that area (hrtimers, clockevents, NOHZ) to
be raw hardware frequency based would be an Herculean task and just a
huge pile of horrors.

So the only realistic way to do that is to correlate a
CLOCK_MONOTONIC_RAW timer to CLOCK_MONOTONIC, which obviously has the
same problem you are trying to solve :)

But we could be smart about it. Let's look at the math:

    mraw  = base_mraw + (tsc - base_r) * factor_r;
    mono  = base_mono + (tsc - base_m) * factor_m;

So converting a MONOTONIC_RAW time into MONOTONIC would be:

   tsc = (mraw - base_mraw)/factor_r + base_r

   mono = base_mono + ((mraw - base_mraw)/factor_r + base_r - base_m) * factor_m;

It's guaranteed that base_r == base_m, so:

   mono = base_mono + (mraw - base_mraw) * factor_m / factor_r;

The conversion factors are actually implemented with scaled math:

   mono = base_mono + (((delta_raw * mult_m) >> sft_m) << sft_r) / mult_r;

As sft_m and sft_r are guaranteed to be identical:

   mono = base_mono + (delta_raw * mult_m) / mult_r;

That obviously only works correctly when mult_m is constant between the
time the timer is enqueued and the time the timer is expired as you
figured out.

But even if mult_m changes this will be correct if we take NOHZ out of
the picture for a moment. Why?

In a NOHZ=n scenario the next expiring timer is at least reevaluated
once every tick. As mult_m is stable between ticks any MONOTONIC_RAW
timer which expires before the next tick will be pretty accurately
mapped back onto MONOTONIC and therefore expire at the expected time.

Now NOHZ comes into play and ruins everything under the following
condition:

   1) CPU takes an idle nap for a longer period of time
   
   2) Time synchronization (NTP/PTP/PPS) is adjusting mult_m during that
      #1 period

That's the only condition where the conversion fails. If NTP slows down
the conversion then the timer is going to be late. If it speeds it up
then the hrtimer core will take care of it and guarantee that the timer
callback is never invoked early.

But that's going to be a rare problem because it requires:

    1) the CPU to be in idle for a longer period

    2) the MONOTONIC_RAW timer to be the effective first timer to fire
       after that idle period

    3) Time synchronization adjusting right during that idle period

Sure that can happen, but the question is whether it's really a
problem. As I said before timer events coming late is to be expected
even on bare metal (think SMI, NMI, long interrupt disabled regions).

So the main benefit of such a change would be to spare the various
architecture specific implementations the stupid exercise of
implementing half baked workarounds which will suffer from
the very same problems.

If done right then the extra overhead of the division will be not really
noticable and only take effect when there is a MONOTONIC_RAW timer
queued. IOW, it's a penalty on virtualization hosts, but not for
everyone. The facility will introduce some extra cycles due to
conditionals vs. MONOTONIC_RAW in a few places, but that's probably
something which can't even be measured.

Thanks,

        tglx

