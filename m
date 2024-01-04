Return-Path: <kvm+bounces-5606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9897F823A08
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 273C91F2535A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 01:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA006107B3;
	Thu,  4 Jan 2024 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeTLQOVs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E833A46B3;
	Thu,  4 Jan 2024 01:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C01C43397;
	Thu,  4 Jan 2024 01:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704330035;
	bh=TZtkZ8yGWLLSrM6jGHuMOmBUVL08ioVOnU7v7YXHcq8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=VeTLQOVscVMLDsJLoSPPYQmIy6TBKV1AoZNyo5qVh/PYbV+0InVUBrTet02rOCqrJ
	 f/tTuduEFy/ufen6zoUxWDWBYCJzHmvybBM5lDfxDdqg82aHvcPxWR1dZE4GlJvWiP
	 U003B6Yxv18C4kCEQLigljnvjqTdGk6zxkJ849M5lSgprMP2Ii1Pi3/XpKUJPicyqg
	 kOL65lppLUak4TigB6D6l53l189JDeaaRYQ9mLErBrDRpB+KK2QxcZcqtLIPZaKn2O
	 t6iHS7sWpEtL97PdnrA0FUfJMcRPGbSXtAr6TzFXXQIQ25XycRvhmmrCxwx32JtpbR
	 i3qOvP0qQpHPg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 052DFCE08F4; Wed,  3 Jan 2024 17:00:35 -0800 (PST)
Date: Wed, 3 Jan 2024 17:00:34 -0800
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
Message-ID: <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZX6pkHnZP777DVi@google.com>

On Wed, Jan 03, 2024 at 04:24:06PM -0800, Sean Christopherson wrote:
> On Wed, Jan 03, 2024, Paul E. McKenney wrote:
> > On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> > > Hello!
> > > 
> > > Since some time between v5.19 and v6.4, long-running rcutorture tests
> > > would (rarely but intolerably often) have all guests on a given host die
> > > simultaneously with something like an instruction fault or a segmentation
> > > violation.
> > > 
> > > Each bisection step required 20 hosts running 10 hours each, and
> > > this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> > > IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
> > > is certainly messing with things that could possibly cause all manner
> > > of mischief, I don't immediately see a smoking gun.  Except that the
> > > commit prior to this one is rock solid.
> > > Just to make things a bit more exciting, bisection in mainline proved
> > > to be problematic due to bugs of various kinds that hid this one.  I was
> > > therefore forced to bisect among the commits backported to the internal
> > > v5.19-based kernel, which fingered the backported version of the patch
> > > called out above.
> > 
> > Ah, and so why do I believe that this is a problem in mainline rather
> > than just (say) a backporting mistake?
> > 
> > Because this issue was first located in v6.4, which already has this
> > commit included.
> > 
> > 							Thanx, Paul
> > 
> > > Please note that this is not (yet) an emergency.  I will just continue
> > > to run rcutorture on v5.19-based hypervisors in the meantime.
> > > 
> > > Any suggestions for debugging or fixing?
> 
> This looks suspect:
> 
> +       u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> +       int global_ctrl, pebs_enable;
>  
> -       arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
> -       arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> -       arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> -       arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
> -       *nr = 1;
> +       *nr = 0;
> +       global_ctrl = (*nr)++;
> +       arr[global_ctrl] = (struct perf_guest_switch_msr){
> +               .msr = MSR_CORE_PERF_GLOBAL_CTRL,
> +               .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> +       };
> 
> 
> IIUC (always a big if with this code), the intent is that the guest's version of
> PERF_GLOBAL_CTRL gets bits that are (a) not exclusive to the host and (b) not
> being used for PEBS.  (b) is necessary because PEBS generates records in memory
> using virtual addresses, i.e. the CPU will write to memory using a virtual address
> that is valid for the host but not the guest.  And so PMU counters that are
> configured to generate PEBS records need to be disabled while running the guest.
> 
> Before that commit, the logic was:
> 
>   guest[PERF_GLOBAL_CTRL] = ctrl & ~host;
>   guest[PERF_GLOBAL_CTRL] &= ~pebs;
> 
> But after, it's now:
> 
>   guest[PERF_GLOBAL_CTRL] = ctrl & (~host | ~pebs);
> 
> I.e. the kernel is enabled counters in the guest that are not host-only OR not
> PEBS.  E.g. if only counter 0 is in use, it's using PEBS, but it's not exclusive
> to the host, then the new code will yield (truncated to a single byte for sanity)
> 
>   1 = 1 & (0xf | 0xe)
> 
> and thus keep counter 0 enabled, whereas the old code would yield
> 
>   1 = 1 & 0xf
>   0 = 1 & 0xe
> 
> A bit of a shot in the dark and completed untested, but I think this is the correct
> fix?

I am firing off some tests, and either way, thank you very much!!!

							Thanx, Paul

> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index a08f794a0e79..92d5a3464cb2 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -4056,7 +4056,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>         arr[global_ctrl] = (struct perf_guest_switch_msr){
>                 .msr = MSR_CORE_PERF_GLOBAL_CTRL,
>                 .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> -               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> +               .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),
>         };
>  
>         if (!x86_pmu.pebs)
> 

