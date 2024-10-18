Return-Path: <kvm+bounces-29168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 891169A3CD5
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 13:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FC911F25C0D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 11:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9398520493C;
	Fri, 18 Oct 2024 11:05:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F66204923;
	Fri, 18 Oct 2024 11:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729249546; cv=none; b=inwGFS55QMoIjvP4zfbA34JlHghsJd6v2IENOBf4JkgdmSPOLTbh0dVctd1lG5Qs83UoIMIYQVENDHTu3AqkPakoUHT3Igc8Y9ZVl3fLam+YwmvWWUtuaHTKyBscmDkFZcAMirDt3kX6sVBf0LQKBB8ofH8pZ1GZl7fChLXAbvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729249546; c=relaxed/simple;
	bh=9hDVWgN9eP3gLsc0lzjrta/0kQpsyqMF5QbErKfyG2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQ1acgqPttoW9idM1vXNoSaYQP3P342u1w5wbaV5L2o6GqalhIzfHTomg8JlOolhyarRdF937xh++H5oliCo5jjUdL/JEAy2fpg17kJY/22RstycxRYmMdDk4XBPFpEaed9wuxIJ/SUuzdo3oZ1VSfARwbP5sI4WFQMvWudMZas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BF1C4CEC3;
	Fri, 18 Oct 2024 11:05:40 +0000 (UTC)
Date: Fri, 18 Oct 2024 12:05:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "Okanovic, Haris" <harisokn@amazon.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>,
	"cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
	"daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <ZxJBAubok8pc5ek7@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
 <ZxEYy9baciwdLnqh@arm.com>
 <87h69amjng.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h69amjng.fsf@oracle.com>

On Thu, Oct 17, 2024 at 03:47:31PM -0700, Ankur Arora wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Oct 16, 2024 at 03:13:33PM +0000, Okanovic, Haris wrote:
> >> On Tue, 2024-10-15 at 13:04 +0100, Catalin Marinas wrote:
> >> > On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
> >> > > +                     smp_cond_load_relaxed(&current_thread_info()->flags,
> >> > > +                                           VAL & _TIF_NEED_RESCHED ||
> >> > > +                                           loop_count++ >= POLL_IDLE_RELAX_COUNT);
> >> >
> >> > The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
> >> > never set. With the event stream enabled on arm64, the WFE will
> >> > eventually be woken up, loop_count incremented and the condition would
> >> > become true. However, the smp_cond_load_relaxed() semantics require that
> >> > a different agent updates the variable being waited on, not the waiting
> >> > CPU updating it itself. Also note that the event stream can be disabled
> >> > on arm64 on the kernel command line.
> >>
> >> Alternately could we condition arch_haltpoll_want() on
> >> arch_timer_evtstrm_available(), like v7?
> >
> > No. The problem is about the smp_cond_load_relaxed() semantics - it
> > can't wait on a variable that's only updated in its exit condition. We
> > need a new API for this, especially since we are changing generic code
> > here (even it was arm64 code only, I'd still object to such
> > smp_cond_load_*() constructs).
> 
> Right. The problem is that smp_cond_load_relaxed() used in this context
> depends on the event-stream side effect when the interface does not
> encode those semantics anywhere.
> 
> So, a smp_cond_load_timeout() like in [1] that continues to depend on
> the event-stream is better because it explicitly accounts for the side
> effect from the timeout.
> 
> This would cover both the WFxT and the event-stream case.

Indeed.

> The part I'm a little less sure about is the case where WFxT and the
> event-stream are absent.
> 
> As you said earlier, for that case on arm64, we use either short
> __delay() calls or spin in cpu_relax(), both of which are essentially
> the same thing.

Something derived from __delay(), not exactly this function. We can't
use it directly as we also want it to wake up if an event is generated
as a result of a memory write (like the current smp_cond_load().

> Now on x86 cpu_relax() is quite optimal. The spec explicitly recommends
> it and from my measurement a loop doing "while (!cond) cpu_relax()" gets
> an IPC of something like 0.1 or similar.
> 
> On my arm64 systems however the same loop gets an IPC of 2.  Now this
> likely varies greatly but seems like it would run pretty hot some of
> the time.

For the cpu_relax() fall-back, it wouldn't be any worse than the current
poll_idle() code, though I guess in this instance we'd not enable idle
polling.

I expect the event stream to be on in all production deployments. The
reason we have a way to disable it is for testing. We've had hardware
errata in the past where the event on spin_unlock doesn't cross the
cluster boundary. We'd not notice because of the event stream.

> So maybe the right thing to do would be to keep smp_cond_load_timeout()
> but only allow polling if WFxT or event-stream is enabled. And enhance
> cpuidle_poll_state_init() to fail if the above condition is not met.

We could do this as well. Maybe hide this behind another function like
arch_has_efficient_smp_cond_load_timeout() (well, some shorter name),
checked somewhere in or on the path to cpuidle_poll_state_init(). Well,
it might be simpler to do this in haltpoll_want(), backed by an
arch_haltpoll_want() function.

I assume we want poll_idle() to wake up as soon as a task becomes
available. Otherwise we could have just used udelay() for some fraction
of cpuidle_poll_time() instead of cpu_relax().

-- 
Catalin

