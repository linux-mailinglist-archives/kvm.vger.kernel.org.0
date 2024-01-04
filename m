Return-Path: <kvm+bounces-5651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CEC824420
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0B5E1C21FC4
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 14:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1097C23760;
	Thu,  4 Jan 2024 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOadmwT/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15623749;
	Thu,  4 Jan 2024 14:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAA0C433C8;
	Thu,  4 Jan 2024 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704379852;
	bh=3JTuWT5QZksFXhz5QlHD6DJDpXXaLdQf2WuuHegnM8A=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=iOadmwT/HEsQjg0LSG4fy90jJHIrFTXlh+6JLqLrgEm0BT14qS1vxK8nJSiKdEz11
	 WG0kEqPRDLeB9AXm5GHsOqFv/ltEUZk7uVUqn4YO9QUbcjpCDTzrMMzBv6AOxzKt3d
	 EqejQbHVDr3vZa2fa7Ycz6tLADN0hM+6NMo9k3L5568ctdp1NNvzHH9Oejf0CSEBuH
	 2WK+RsMDpbQuiJ01GlC3MIg2nGdRru3QeUZROJjPMYTleknVFPTxIx0aTNkrO6bcWN
	 HW8iZHsXwQL/599bXvx1K4tzIUiUZmAxJoFYJ0qLys1D5b4V6/sY2QnlAFOWMt/Bs2
	 vubs2tI5+akwA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 3C6A5CE130C; Thu,  4 Jan 2024 06:50:52 -0800 (PST)
Date: Thu, 4 Jan 2024 06:50:52 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>

On Wed, Jan 03, 2024 at 05:00:35PM -0800, Paul E. McKenney wrote:
> On Wed, Jan 03, 2024 at 04:24:06PM -0800, Sean Christopherson wrote:
> > On Wed, Jan 03, 2024, Paul E. McKenney wrote:
> > > On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> > > > Hello!
> > > > 
> > > > Since some time between v5.19 and v6.4, long-running rcutorture tests
> > > > would (rarely but intolerably often) have all guests on a given host die
> > > > simultaneously with something like an instruction fault or a segmentation
> > > > violation.
> > > > 
> > > > Each bisection step required 20 hosts running 10 hours each, and
> > > > this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> > > > IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
> > > > is certainly messing with things that could possibly cause all manner
> > > > of mischief, I don't immediately see a smoking gun.  Except that the
> > > > commit prior to this one is rock solid.
> > > > Just to make things a bit more exciting, bisection in mainline proved
> > > > to be problematic due to bugs of various kinds that hid this one.  I was
> > > > therefore forced to bisect among the commits backported to the internal
> > > > v5.19-based kernel, which fingered the backported version of the patch
> > > > called out above.
> > > 
> > > Ah, and so why do I believe that this is a problem in mainline rather
> > > than just (say) a backporting mistake?
> > > 
> > > Because this issue was first located in v6.4, which already has this
> > > commit included.
> > > 
> > > 							Thanx, Paul
> > > 
> > > > Please note that this is not (yet) an emergency.  I will just continue
> > > > to run rcutorture on v5.19-based hypervisors in the meantime.
> > > > 
> > > > Any suggestions for debugging or fixing?
> > 
> > This looks suspect:
> > 
> > +       u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> > +       int global_ctrl, pebs_enable;
> >  
> > -       arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
> > -       arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> > -       arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> > -       arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
> > -       *nr = 1;
> > +       *nr = 0;
> > +       global_ctrl = (*nr)++;
> > +       arr[global_ctrl] = (struct perf_guest_switch_msr){
> > +               .msr = MSR_CORE_PERF_GLOBAL_CTRL,
> > +               .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> > +       };
> > 
> > 
> > IIUC (always a big if with this code), the intent is that the guest's version of
> > PERF_GLOBAL_CTRL gets bits that are (a) not exclusive to the host and (b) not
> > being used for PEBS.  (b) is necessary because PEBS generates records in memory
> > using virtual addresses, i.e. the CPU will write to memory using a virtual address
> > that is valid for the host but not the guest.  And so PMU counters that are
> > configured to generate PEBS records need to be disabled while running the guest.
> > 
> > Before that commit, the logic was:
> > 
> >   guest[PERF_GLOBAL_CTRL] = ctrl & ~host;
> >   guest[PERF_GLOBAL_CTRL] &= ~pebs;
> > 
> > But after, it's now:
> > 
> >   guest[PERF_GLOBAL_CTRL] = ctrl & (~host | ~pebs);
> > 
> > I.e. the kernel is enabled counters in the guest that are not host-only OR not
> > PEBS.  E.g. if only counter 0 is in use, it's using PEBS, but it's not exclusive
> > to the host, then the new code will yield (truncated to a single byte for sanity)
> > 
> >   1 = 1 & (0xf | 0xe)
> > 
> > and thus keep counter 0 enabled, whereas the old code would yield
> > 
> >   1 = 1 & 0xf
> >   0 = 1 & 0xe
> > 
> > A bit of a shot in the dark and completed untested, but I think this is the correct
> > fix?
> 
> I am firing off some tests, and either way, thank you very much!!!

Woo-hoo!!!  ;-)

Tested-by: Paul E. McKenney <paulmck@kernel.org>

Will you be sending a proper patch, or would you prefer that I do so?
In the latter case, I would need your Signed-off-by.

And again, thank you very much!!!

							Thanx, Paul

> > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> > index a08f794a0e79..92d5a3464cb2 100644
> > --- a/arch/x86/events/intel/core.c
> > +++ b/arch/x86/events/intel/core.c
> > @@ -4056,7 +4056,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
> >         arr[global_ctrl] = (struct perf_guest_switch_msr){
> >                 .msr = MSR_CORE_PERF_GLOBAL_CTRL,
> >                 .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > -               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> > +               .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),
> >         };
> >  
> >         if (!x86_pmu.pebs)
> > 

