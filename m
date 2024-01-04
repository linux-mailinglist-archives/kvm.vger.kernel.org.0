Return-Path: <kvm+bounces-5657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C4D8245C8
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A48BC1F22DCF
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C290924B25;
	Thu,  4 Jan 2024 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMxGHge/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED55A249F2;
	Thu,  4 Jan 2024 16:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B8BC433C9;
	Thu,  4 Jan 2024 16:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704384415;
	bh=JnV7QowiSuoiLFDQGI0FPGZ+bh9s4g0HF1y3doYPSSU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=IMxGHge/+PtWAmaXmRXqw7V/VlI9zH3YIupyilsnUtVRwtPBHsIf7fR5PSO8+iCW1
	 FclmcuASM5epMs+qdMM2P+GryyzCxsDz9whIA49Pn8dyglcEQKjctatYFGHd7046Cp
	 GpQ4vwVu5uXhx82f2SgrHdFhSu1Yu4cdN+YtAwwbopViSP+2R//7oBro/tr/gIrr2G
	 sU+6CyLik6z6DO9ui56HGqRQ5McMknXKg2awyRjvTSRmp5SEIzoUw57f8lkngXGSJ7
	 myr7bI+AhTKRJbBX2C/9vGTIrvibp1Bhv057BnTPHYMsbxequL2M8XLXxD5Z2Yiqg2
	 M6Q+rAXDTAwbg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 05981CE130C; Thu,  4 Jan 2024 08:06:55 -0800 (PST)
Date: Thu, 4 Jan 2024 08:06:54 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Luwei Kang <luwei.kang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
Message-ID: <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
 <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
 <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>

On Thu, Jan 04, 2024 at 03:59:52PM +0100, Paolo Bonzini wrote:
> On Thu, Jan 4, 2024 at 3:58 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Wed, Jan 03, 2024 at 05:00:35PM -0800, Paul E. McKenney wrote:
> > > On Wed, Jan 03, 2024 at 04:24:06PM -0800, Sean Christopherson wrote:
> > > > On Wed, Jan 03, 2024, Paul E. McKenney wrote:
> > > > > On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> > > > > > Hello!
> > > > > >
> > > > > > Since some time between v5.19 and v6.4, long-running rcutorture tests
> > > > > > would (rarely but intolerably often) have all guests on a given host die
> > > > > > simultaneously with something like an instruction fault or a segmentation
> > > > > > violation.
> > > > > >
> > > > > > Each bisection step required 20 hosts running 10 hours each, and
> > > > > > this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> > > > > > IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
> > > > > > is certainly messing with things that could possibly cause all manner
> > > > > > of mischief, I don't immediately see a smoking gun.  Except that the
> > > > > > commit prior to this one is rock solid.
> > > > > > Just to make things a bit more exciting, bisection in mainline proved
> > > > > > to be problematic due to bugs of various kinds that hid this one.  I was
> > > > > > therefore forced to bisect among the commits backported to the internal
> > > > > > v5.19-based kernel, which fingered the backported version of the patch
> > > > > > called out above.
> > > > >
> > > > > Ah, and so why do I believe that this is a problem in mainline rather
> > > > > than just (say) a backporting mistake?
> > > > >
> > > > > Because this issue was first located in v6.4, which already has this
> > > > > commit included.
> > > > >
> > > > >                                                   Thanx, Paul
> > > > >
> > > > > > Please note that this is not (yet) an emergency.  I will just continue
> > > > > > to run rcutorture on v5.19-based hypervisors in the meantime.
> > > > > >
> > > > > > Any suggestions for debugging or fixing?
> > > >
> > > > This looks suspect:
> > > >
> > > > +       u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> > > > +       int global_ctrl, pebs_enable;
> > > >
> > > > -       arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
> > > > -       arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> > > > -       arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> > > > -       arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
> > > > -       *nr = 1;
> > > > +       *nr = 0;
> > > > +       global_ctrl = (*nr)++;
> > > > +       arr[global_ctrl] = (struct perf_guest_switch_msr){
> > > > +               .msr = MSR_CORE_PERF_GLOBAL_CTRL,
> > > > +               .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > > > +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> > > > +       };
> > > >
> > > >
> > > > IIUC (always a big if with this code), the intent is that the guest's version of
> > > > PERF_GLOBAL_CTRL gets bits that are (a) not exclusive to the host and (b) not
> > > > being used for PEBS.  (b) is necessary because PEBS generates records in memory
> > > > using virtual addresses, i.e. the CPU will write to memory using a virtual address
> > > > that is valid for the host but not the guest.  And so PMU counters that are
> > > > configured to generate PEBS records need to be disabled while running the guest.
> > > >
> > > > Before that commit, the logic was:
> > > >
> > > >   guest[PERF_GLOBAL_CTRL] = ctrl & ~host;
> > > >   guest[PERF_GLOBAL_CTRL] &= ~pebs;
> > > >
> > > > But after, it's now:
> > > >
> > > >   guest[PERF_GLOBAL_CTRL] = ctrl & (~host | ~pebs);
> > > >
> > > > I.e. the kernel is enabled counters in the guest that are not host-only OR not
> > > > PEBS.  E.g. if only counter 0 is in use, it's using PEBS, but it's not exclusive
> > > > to the host, then the new code will yield (truncated to a single byte for sanity)
> > > >
> > > >   1 = 1 & (0xf | 0xe)
> > > >
> > > > and thus keep counter 0 enabled, whereas the old code would yield
> > > >
> > > >   1 = 1 & 0xf
> > > >   0 = 1 & 0xe
> > > >
> > > > A bit of a shot in the dark and completed untested, but I think this is the correct
> > > > fix?
> > >
> > > I am firing off some tests, and either way, thank you very much!!!
> >
> > Woo-hoo!!!  ;-)
> >
> > Tested-by: Paul E. McKenney <paulmck@kernel.org>
> >
> > Will you be sending a proper patch, or would you prefer that I do so?
> > In the latter case, I would need your Signed-off-by.
> 
> I will fast track this one to Linus.

Thank you, Paolo!

One additional request, if I may be so bold...

Although I am happy to have been able to locate the commit (and even
happier that Sean spotted the problem and that you quickly pushed the
fix to mainline!), chasing this consumed a lot of time and systems over
an embarrassingly large number of months.  As in I first spotted this
bug in late July.  Despite a number of increasingly complex attempts,
bisection became feasible only after the buggy commit was backported to
our internal v5.19 code base.  :-(

My (completely random) guess is that there is some rare combination
of events that causes this code to fail.  If so, is it feasible to
construct a test that makes this rare combination of events less rare,
so that similar future bugs are caught more quickly?

And please understand that I am not casting shade on those who wrote,
reviewed, and committed that buggy commit.  As in I freely confess that
I had to stare at Sean's fix for a few minutes before I figured out what
was going on.  Instead, the point I am trying to make is that carefully
constructed tests can serve as tireless and accurate code reviewers.
This won't ever replace actual code review, but my experience indicates
that it will help find more bugs more quickly and more easily.

							Thanx, Paul

> Paolo
> 
> > And again, thank you very much!!!
> >
> >                                                         Thanx, Paul
> >
> > > > diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> > > > index a08f794a0e79..92d5a3464cb2 100644
> > > > --- a/arch/x86/events/intel/core.c
> > > > +++ b/arch/x86/events/intel/core.c
> > > > @@ -4056,7 +4056,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
> > > >         arr[global_ctrl] = (struct perf_guest_switch_msr){
> > > >                 .msr = MSR_CORE_PERF_GLOBAL_CTRL,
> > > >                 .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> > > > -               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> > > > +               .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),
> > > >         };
> > > >
> > > >         if (!x86_pmu.pebs)
> > > >
> >
> 

