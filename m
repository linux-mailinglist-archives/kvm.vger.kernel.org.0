Return-Path: <kvm+bounces-31031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A68189BF7AA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D80E71C20B9B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EC620B1F7;
	Wed,  6 Nov 2024 19:55:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEE13A26F;
	Wed,  6 Nov 2024 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730922954; cv=none; b=ONo6FVBVI/rGJ3HVFn/3iSpm/OKaJGrXtnoDCc2Suggnk5ra7HdkJuFSoA2qO5C+iuKxTFFUuNxyrxV0Jgn78sHRe5Nlpm8A6BTwYrPr3RDY0KyQBo3ZjOhO6iyBbKUn8aE3dToAgd76ZyVtqp6MsPBHVVHkp4JT/QWZwWLTqak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730922954; c=relaxed/simple;
	bh=XPs6E4peSoALY20kBmu4SRgS9pGyv22f5TO51cGafaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yzo7GMDx+F/2M+3S9K9qsvMwl8TdOn/gzmvI96Ijhf9inZRsEu2TclhfdeeBFPCFdmtezVAZFTyAGhZNXc3HY4zg56Qvj6z+OH62jDNB1yAlpo5lKi8l8pOTz/fOjusjb8QdaEcgaFyMCNgZqpXH3NFsAmYWsZSd4wkOHhMs9pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B876EC4CED5;
	Wed,  6 Nov 2024 19:55:48 +0000 (UTC)
Date: Wed, 6 Nov 2024 19:55:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
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
	"bp@alien8.de" <bp@alien8.de>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Message-ID: <ZyvJwjfKgnqMpM9P@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
 <20241105183041.1531976-2-harisokn@amazon.com>
 <ZytOH2oigoC-qVLK@arm.com>
 <b62d938111c6ce52b91d0f2e3922857c5d4ef253.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b62d938111c6ce52b91d0f2e3922857c5d4ef253.camel@amazon.com>

On Wed, Nov 06, 2024 at 06:13:35PM +0000, Okanovic, Haris wrote:
> On Wed, 2024-11-06 at 11:08 +0000, Catalin Marinas wrote:
> > On Tue, Nov 05, 2024 at 12:30:37PM -0600, Haris Okanovic wrote:
> > > diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
> > > index d4f581c1e21d..112027eabbfc 100644
> > > --- a/include/asm-generic/barrier.h
> > > +++ b/include/asm-generic/barrier.h
> > > @@ -256,6 +256,31 @@ do {                                                                     \
> > >  })
> > >  #endif
> > > 
> > > +/**
> > > + * smp_vcond_load_relaxed() - (Spin) wait until an expected value at address
> > > + * with no ordering guarantees. Spins until `(*addr & mask) == val` or
> > > + * `nsecs` elapse, and returns the last observed `*addr` value.
> > > + *
> > > + * @nsecs: timeout in nanoseconds
> > 
> > FWIW, I don't mind the relative timeout, it makes the API easier to use.
> > Yes, it may take longer in absolute time if the thread is scheduled out
> > before local_clock_noinstr() is read but the same can happen in the
> > caller anyway. It's similar to udelay(), it can take longer if the
> > thread is scheduled out.
> > 
> > > + * @addr: pointer to an integer
> > > + * @mask: a bit mask applied to read values
> > > + * @val: Expected value with mask
> > > + */
> > > +#ifndef smp_vcond_load_relaxed
> > > +#define smp_vcond_load_relaxed(nsecs, addr, mask, val) ({    \
> > > +     const u64 __start = local_clock_noinstr();              \
> > > +     u64 __nsecs = (nsecs);                                  \
> > > +     typeof(addr) __addr = (addr);                           \
> > > +     typeof(*__addr) __mask = (mask);                        \
> > > +     typeof(*__addr) __val = (val);                          \
> > > +     typeof(*__addr) __cur;                                  \
> > > +     smp_cond_load_relaxed(__addr, (                         \
> > > +             (VAL & __mask) == __val ||                      \
> > > +             local_clock_noinstr() - __start > __nsecs       \
> > > +     ));                                                     \
> > > +})
> > 
> > The generic implementation has the same problem as Ankur's current
> > series. smp_cond_load_relaxed() can't wait on anything other than the
> > variable at __addr. If it goes into a WFE, there's nothing executed to
> > read the timer and check for progress. Any generic implementation of
> > such function would have to use cpu_relax() and polling.
> 
> How would the caller enter wfe()? Can you give a specific scenario that
> you're concerned about?

Let's take the arm64 example with the event stream disabled. Without the
subsequent patches implementing smp_vcond_load_relaxed(), just expand
the arm64 smp_cond_load_relaxed() implementation in the above macro. If
the timer check doesn't trigger an exit from the loop,
__cmpwait_relaxed() only waits on the variable to change its value,
nothing to do with the timer.

> This code already reduces to a relaxed poll, something like this:
> 
> ```
> start = clock();
> while((READ_ONCE(*addr) & mask) != val && (clock() - start) < nsecs) {
>   cpu_relax();
> }
> ```

Well, that's if you also use the generic implementation of
smp_cond_load_relaxed() but have you checked all the other architectures
that don't do something similar to the arm64 wfe (riscv comes close)?
Even if all other architectures just use a cpu_relax(), that's still
abusing the smp_cond_load_relaxed() semantics. And what if one places
another loop in their __cmpwait()? That's allowed because you are
supposed to wait on a single variable to change not on multiple states.

-- 
Catalin

