Return-Path: <kvm+bounces-54895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C4EB2ACBB
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 17:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D500A3B76F9
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 15:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C07257AC6;
	Mon, 18 Aug 2025 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHRY4JEW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0F2571BC
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755530739; cv=none; b=ZVacNkgMYLLDpyEIJXHrU7Kk8Wr/a7VCy2ctUHtydLE0gl0AifCE3RVAW6Qgk7S0H8YU+VxQv4konon7xEhE44ibgOKD7tETIg54PT4H/N8GlSU/OEmlw6DH6C6v8v+8MTzCxYG4KrPWrV+XDVyJvNjTcij9Evjj417yjIPKF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755530739; c=relaxed/simple;
	bh=cQQ74RqI0oi17iisfFPsBnqCiIujEhsD/7CJ215Qn5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tdk5ZBZiKoNkshCLHPo8wn6+XZjmhrbBNsmO1L1lf+41UnWg0ecI8QANN+bq6APqggW8TBd/seyYDyoiWJjZfgmIH2zcQsu/Zk05+wofK5j+KvHTm6q/NV6q5TC140ydO2AWFaVvcNsMws5x8kWvsggaU6rIdaatRz65swJ8KHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHRY4JEW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323267c0292so3942061a91.1
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 08:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755530736; x=1756135536; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoYx/ZJm+dL7FRV6jyG7YgqbQ7bK3pBhdAAvFLAFxA=;
        b=XHRY4JEWwtrsZamal5vzPJOMq1fmfGGwLP0AaRnWKph6b+KnplwEtY12h/+7ofcuWv
         apfyofwWzXv7EeK7HanthaIXwT1r2MMs5g6uzhro5K5e62mZIzrfFPO+Df8qDXIgEr+z
         3AYXuhEEm8rvm78a/BKkg5rnYtiDJgBNln/6pL5m7Rueg6D1ZkBuyvWVHmLY4NC7SZ5Q
         oXbHB3mQTEtFZu9tQTeSnGhGfQYyV4qVNI7eypIo6Xr149K9aTs4Ntfv376Y3+Q325l3
         9LlsljHh3An1fOmjphXZlREs4JAWh7aFlgBTF4I1MOG4vP0Mqow1SMjVDWUI5tvHHg+G
         Pi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755530736; x=1756135536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoYx/ZJm+dL7FRV6jyG7YgqbQ7bK3pBhdAAvFLAFxA=;
        b=Ev+TXuhLhfADR8+ESMvKK4/EvEHzBflH0BLScabXASEP/i6BvUrQSYCB9zFgQKdvEE
         atNh811QyIQVVdRrbtl9+iCfnk1x5E8OdvTeo3oynXYwGF3KjrkrtFgyBJ1UOOznb+xP
         UfF6YkJ/SvZHuzXoBw5Fip5+CdkZXzFUtUFa3T2z2RfXQLvf/BOM5oWDFoODV+i0JUKG
         wohrUJprb2QBdMtoUR++jqArNZHPJ+X238RClDhPtKzskKB2Q9SAd0zBqT1ckvxPSLUc
         HxUMKMcKnlqdIhnEDWnHmDyjmUxMw8CAXHykuDsxcDLC5brJZpikrALLFKKwTs48admm
         991w==
X-Forwarded-Encrypted: i=1; AJvYcCX/dukOjws5xEtqkTrlrr8LZ590dhyq6/w65GD2ULNT9yjnX7YTZSWj8sT9jeKgZuF1q0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbPrOKkE2DWnX57sKZv9HF6Sgv9S5MGNM4Tx9q+X3b8meBEQJI
	bwoJ3axIednm6bwkVp0UB5v0FChWLHLduHJ6HYnUmLrSQrvVwMa+TkOn8LaInICqtj+2k9iGCu5
	fnsLsew==
X-Google-Smtp-Source: AGHT+IFCmpj8FbJmK1+JWLBztlT6f28DkrWlTFsNjoSajBRjHfMiKFT/6+vAkpnb7u9ULN6Oz/FIAv/3KBU=
X-Received: from pjee5.prod.google.com ([2002:a17:90b:5785:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c6:b0:31e:f3b7:49c6
 with SMTP id 98e67ed59e1d1-323421b64b7mr17300718a91.15.1755530736134; Mon, 18
 Aug 2025 08:25:36 -0700 (PDT)
Date: Mon, 18 Aug 2025 08:25:34 -0700
In-Reply-To: <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com> <aJ9YbZTJAg66IiVh@google.com> <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
Message-ID: <aKNF7jc4qr9ab-Es@google.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 18, 2025, Peter Zijlstra wrote:
> On Fri, Aug 15, 2025 at 08:55:25AM -0700, Sean Christopherson wrote:
> > On Fri, Aug 15, 2025, Sean Christopherson wrote:
> > > On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > > index e1df3c3bfc0d..ad22b182762e 100644
> > > > > --- a/kernel/events/core.c
> > > > > +++ b/kernel/events/core.c
> > > > > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> > > > >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> > > > >  	}
> > > > >  
> > > > > +	arch_perf_load_guest_context(data);
> > > > 
> > > > So I still don't understand why this ever needs to reach the generic
> > > > code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> > > > no?
> > > 
> > > It's definitely possible to handle this entirely within x86, I just don't love
> > > switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
> > > It's not a sticking point for me if you strongly prefer something like this: 
> > > 
> > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > index 0e5048ae86fa..86b81c217b97 100644
> > > --- a/arch/x86/kvm/pmu.c
> > > +++ b/arch/x86/kvm/pmu.c
> > > @@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
> > >  
> > >         lockdep_assert_irqs_disabled();
> > >  
> > > -       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> > > +       perf_load_guest_context();
> > > +
> > > +       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> > 
> > Hmm, an argument for providing a dedicated perf_load_guest_lvtpc() APIs is that
> > it would allow KVM to handle LVTPC writes in KVM's VM-Exit fastpath, i.e. without
> > having to do a full put+reload of the guest context.
> > 
> > So if we're confident that switching the host LVTPC outside of
> > perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.
> 
> Let me see. So the hardware sets Masked when it raises the interrupt.
> 
> The interrupt handler clears it from software -- depending on uarch in 3
> different places:
>  1) right at the start of the PMI
>  2) in the middle, right before enabling the PMU (writing global control)
>  3) at the end of the PMI
> 
> the various changelogs adding that code mention spurious PMIs and
> malformed PEBS records.
> 
> So the fun all happens when the guest is doing PMI and gets a VM-exit
> while still Masked.
> 
> At that point, we can come in and completely rewrite the PMU state,
> reroute the PMI and enable things again. Then later, we 'restore' the
> PMU state, re-set LVTPC masked to the guest interrupt and 'resume'.
> 
> What could possibly go wrong :/ Kan, I'm assuming, but not knowing, that
> writing all the PMU MSRs is somehow serializing state sufficient to not
> cause the above mentioned fails? Specifically, clearing PEBS_ENABLE
> should inhibit those malformed PEBS records or something? What if the
> host also has PEBS and we don't actually clear the bit?
> 
> The current order ensures we rewrite LVTPC when global control is unset;
> I think we want to keep that.

Yes, for sure.

> While staring at this, I note that perf_load_guest_context() will clear
> global ctrl, clear all the counter programming, and re-enable an empty
> pmu. Now, an empty PMU should result in global control being zero --
> there is nothing run after all.
> 
> But then kvm_mediated_pmu_load() writes an explicit 0 again. Perhaps
> replace this with asserting it is 0 instead?

Yeah, I like that idea, a lot.  This?

	perf_load_guest_context();

	/*
	 * Sanity check that "loading" guest context disabled all counters, as
	 * modifying the LVTPC while host perf is active will cause explosions,
	 * as will loading event selectors and PMCs with guest values.
	 *
	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
	 * configuring all events to be GUEST_ONLY.
	 */
	WARN_ON_ONCE(rdmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL));

	perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));

> Anyway, this means that moving the LVTPC writing into
> kvm_mediated_pmu_load() as you suggest is identical.
> perf_load_guest_context() results in global control being 0, we then
> assert it is 0, and write LVTPC while it is still 0.
> kvm_pmu_load_guest_pmcs() will then frob the MSRs.
> 
> OK, so *IF* doing the VM-exit during PMI is sound, this is something
> that needs a comment somewhere. 

I'm a bit lost here.  Are you essentially asking if it's ok to take a VM-Exit
while the guest is handling a PMI?  If so, that _has_ to work, because there are
myriad things that can/will trigger a VM-Exit at any point while the guest is
active.

> Then going back again, is the easy part, since on the host side, we can never
> transition into KVM during a PMI.

