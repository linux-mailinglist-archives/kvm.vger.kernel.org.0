Return-Path: <kvm+bounces-54891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E44DB2AB74
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C73A1BC61CB
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 14:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F09A93D;
	Mon, 18 Aug 2025 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nTwJBQDM"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B772E228D;
	Mon, 18 Aug 2025 14:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755527539; cv=none; b=noxV84yZJiRyrp0Zu/SxrPv8cLI/NGBnFqX4i2DQWs3FC0MG11Sw//Poobudg6nzt+Igz6LB9VASv5H4DM6JRItauvLsVZmyPyNdrIc6mmHx38dbGLLqZBQ7VY4a8hPPYyvYUs6CyvTkQ03kn8HTvll44fMbRen6cyxEnYjUz9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755527539; c=relaxed/simple;
	bh=rJq1PLFg1Jl8mhEVCyIXsTV8k6n43w+l6BpugcpqbW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anIK/enQGvTM2OMt66aHl8sAsLiYonzJ2oV7SnK1ocCV+s2qGiNRMCUqwzEF1nsJZjDEtpchoKf2x5Re313dkDH7cB4qjtmAH3Qxu7i66NQTG3+NQnCiIWPjq2MhgjpUJCk0eqeJNJb8bwHQD/egBt9GF3pb3k4+ZVf0FDhAFDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nTwJBQDM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6/EIRFg9PLgH5wwlMqWFKmPwTY6Y/F+Dlmaynssm+2Y=; b=nTwJBQDMyEiWOl9UKDS8McJeti
	nj2X7/q6CCyGsURq8PcmJKXeUUPIGn1OIHoJm93+vT3hwGJB/j6uSWZyqTNkmObWD5hUoZFcLuuqv
	FDy6H/gOMAsxcb0nNNyzDeOEjs3qBBIvRCTnxZNQG4RgiZgY4h3Tl+whMPf7vRLFHfsGBo0dtF63J
	b9a4itPxIPqRAa3/rFEEiJCCB1HWg+ppbiRYrSeF6BxqBVPvItmbtmMAUuckFZZXb1iaPxtZV3irs
	UTjM7zKpuSyaFmkEsXTgejffm/Nqdx4etJkPDN0uMWcooNWwfQqSfINnPGbas/DAJX/d6G8BuDVHY
	Gbz6qISA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uo0u5-00000007DeO-2MJS;
	Mon, 18 Aug 2025 14:32:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EC54630029B; Mon, 18 Aug 2025 16:32:04 +0200 (CEST)
Date: Mon, 18 Aug 2025 16:32:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	Kan Liang <kan.liang@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
Message-ID: <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com>
 <aJ9YbZTJAg66IiVh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9YbZTJAg66IiVh@google.com>

On Fri, Aug 15, 2025 at 08:55:25AM -0700, Sean Christopherson wrote:
> On Fri, Aug 15, 2025, Sean Christopherson wrote:
> > On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > index e1df3c3bfc0d..ad22b182762e 100644
> > > > --- a/kernel/events/core.c
> > > > +++ b/kernel/events/core.c
> > > > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> > > >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> > > >  	}
> > > >  
> > > > +	arch_perf_load_guest_context(data);
> > > 
> > > So I still don't understand why this ever needs to reach the generic
> > > code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> > > no?
> > 
> > It's definitely possible to handle this entirely within x86, I just don't love
> > switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
> > It's not a sticking point for me if you strongly prefer something like this: 
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 0e5048ae86fa..86b81c217b97 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
> >  
> >         lockdep_assert_irqs_disabled();
> >  
> > -       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> > +       perf_load_guest_context();
> > +
> > +       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> 
> Hmm, an argument for providing a dedicated perf_load_guest_lvtpc() APIs is that
> it would allow KVM to handle LVTPC writes in KVM's VM-Exit fastpath, i.e. without
> having to do a full put+reload of the guest context.
> 
> So if we're confident that switching the host LVTPC outside of
> perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.

Let me see. So the hardware sets Masked when it raises the interrupt.

The interrupt handler clears it from software -- depending on uarch in 3
different places:
 1) right at the start of the PMI
 2) in the middle, right before enabling the PMU (writing global control)
 3) at the end of the PMI

the various changelogs adding that code mention spurious PMIs and
malformed PEBS records.

So the fun all happens when the guest is doing PMI and gets a VM-exit
while still Masked.

At that point, we can come in and completely rewrite the PMU state,
reroute the PMI and enable things again. Then later, we 'restore' the
PMU state, re-set LVTPC masked to the guest interrupt and 'resume'.

What could possibly go wrong :/ Kan, I'm assuming, but not knowing, that
writing all the PMU MSRs is somehow serializing state sufficient to not
cause the above mentioned fails? Specifically, clearing PEBS_ENABLE
should inhibit those malformed PEBS records or something? What if the
host also has PEBS and we don't actually clear the bit?

The current order ensures we rewrite LVTPC when global control is unset;
I think we want to keep that.

While staring at this, I note that perf_load_guest_context() will clear
global ctrl, clear all the counter programming, and re-enable an empty
pmu. Now, an empty PMU should result in global control being zero --
there is nothing run after all.

But then kvm_mediated_pmu_load() writes an explicit 0 again. Perhaps
replace this with asserting it is 0 instead?

Anyway, this means that moving the LVTPC writing into
kvm_mediated_pmu_load() as you suggest is identical.
perf_load_guest_context() results in global control being 0, we then
assert it is 0, and write LVTPC while it is still 0.
kvm_pmu_load_guest_pmcs() will then frob the MSRs.

OK, so *IF* doing the VM-exit during PMI is sound, this is something
that needs a comment somewhere. Then going back again, is the easy part,
since on the host side, we can never transition into KVM during a PMI.

