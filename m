Return-Path: <kvm+bounces-63753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79E41C71266
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 22:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F25E94E1A08
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 21:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A478288C30;
	Wed, 19 Nov 2025 21:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dwY5SH/K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC682652A2
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763587889; cv=none; b=siuE8RrKvzYSdAS9DpSQ+d12/X3AA42TJDWm5oec8kcsUP4wq+4KTQQMCQ8jJq2PqWpxhEtD2VpYSoGsN7IQ4FOZbdc4DMMLKZ6owM4brtiiTSxiXTjMNg2qT4zkXZf4h8QMWDiHmOZIIaU58l+QZHITfdLMB06U/LL7USm0YzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763587889; c=relaxed/simple;
	bh=xnVWHoRf7o0NcxPQfVQjG9xcAOWFFNXm2zL7SdEXGTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rSKNGWgkEtQ6bXCAVqLG2GzEbTJWZH4dUvIimxntd3yK1m96z3gWSfx2qBxC1K9FJdxGWrQujV2QWfEoipcjNyQGa8p4xaZCqxH8BgbpZDSTP7q4HCX+N4hUWuv9eUUGd1pGUAkzppZ1jq3mW6B1aiTfDZPF9Fsk/+lmHrbHJXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dwY5SH/K; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-298389232c4so4228335ad.2
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 13:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763587887; x=1764192687; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlBn8hNsoLzEGGI6zV1NxPFQ/eFHCg8PaMSNSKYawI=;
        b=dwY5SH/K3B1spsCJkHaaYy5Yes1+n5M/uUUXpP6+AiKQ1vPFlfifPIezxVF9DpMOlT
         5t2mMbaMfU8DKLv0ZtLiegnpd/BTVj7Y4UnwnRttNhIk5YEFY1dXgOUU0nNCF7tOngYl
         vYCwMUt/BOluXDxwHobpmWQw6bH7eZPlEk6Pk3fwmT/KlOPq4L4CZxmlk0ufc7husBQw
         5B4Wo9c9Bl9aDsR6ckIHSf8n+L8OveGt3RFVQHcrfOapjNXqU3pjT21TbEZzKikfZV4x
         gOIEFau6vKPXmaiyoutWZWQ9aqe9cwsvlAfRymaN+zCvFFH9uUKkwt6+3MnhDvzDoZkI
         qISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763587887; x=1764192687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlBn8hNsoLzEGGI6zV1NxPFQ/eFHCg8PaMSNSKYawI=;
        b=LD18pY015opZ0l9vWYlD3CvBQNmo04QWn8IrOGF+qOzqPvJU8wtWjErSyAyiHTGfTo
         loz9fH5fFSShdC/tCLrnF81j07HWr1fkZ22RF+PqFtyJQru7Z1j0POHuSB41qSarGC96
         Vv/PK+eNKB2U7OUsriCf3mheakFuqdYBluFY81lNGPmgyJ/63UdFcKiD6VReC/BR7WCv
         cxCG5tLa+bqaTmHRkaSMw5zR3badBr8KniWqJkl/p9em+s0FtA0us3lQ6zJXQ5sCqoHQ
         r+a30hUnMdqwXPa/unm74R0Np2YnIUeoXX0N270rnvStoOMIpqeyXWJ3RiLHSAy5QKLS
         zqhw==
X-Forwarded-Encrypted: i=1; AJvYcCWCbUOPwr328p3P3kZxAn+Bu841gd1sevuTucBdIgk/6evRHQlMZ4LXlRvCRZwfoSvIorY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWHJ7+0+rBnc5OuhoDypefCBly4QSVQpwj+3wcxpOok2rqRMzx
	Mt4Au7iWpMAuGfQo6dScMbkHdGTifDDTNDaqpesrUk4XN/Ehl5wgH+HthIC1lFxBgoO0QOZPrCr
	/yJPENA==
X-Google-Smtp-Source: AGHT+IEd+gfd++T3e2i6Z4dBj2glGk6LJnNjNrz24WgF1sqa+HmClxx9J2N7UBfKQW53wCFECS0cLQGpQb0=
X-Received: from plot18.prod.google.com ([2002:a17:902:8c92:b0:298:9ac:cfe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc7:b0:298:49db:a9c5
 with SMTP id d9443c01a7336-29b5b136462mr7336255ad.43.1763587887332; Wed, 19
 Nov 2025 13:31:27 -0800 (PST)
Date: Wed, 19 Nov 2025 13:31:26 -0800
In-Reply-To: <aKNF7jc4qr9ab-Es@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com> <aJ9YbZTJAg66IiVh@google.com>
 <20250818143204.GH3289052@noisy.programming.kicks-ass.net> <aKNF7jc4qr9ab-Es@google.com>
Message-ID: <aR43LoV1ti5-2WRD@google.com>
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

On Mon, Aug 18, 2025, Sean Christopherson wrote:
> On Mon, Aug 18, 2025, Peter Zijlstra wrote:
> > On Fri, Aug 15, 2025 at 08:55:25AM -0700, Sean Christopherson wrote:
> > > On Fri, Aug 15, 2025, Sean Christopherson wrote:
> > > > On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > So if we're confident that switching the host LVTPC outside of
> > > perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.
> > 
> > Let me see. So the hardware sets Masked when it raises the interrupt.
> > 
> > The interrupt handler clears it from software -- depending on uarch in 3
> > different places:
> >  1) right at the start of the PMI
> >  2) in the middle, right before enabling the PMU (writing global control)
> >  3) at the end of the PMI
> > 
> > the various changelogs adding that code mention spurious PMIs and
> > malformed PEBS records.
> > 
> > So the fun all happens when the guest is doing PMI and gets a VM-exit
> > while still Masked.
> > 
> > At that point, we can come in and completely rewrite the PMU state,
> > reroute the PMI and enable things again. Then later, we 'restore' the
> > PMU state, re-set LVTPC masked to the guest interrupt and 'resume'.
> > 
> > What could possibly go wrong :/ Kan, I'm assuming, but not knowing, that
> > writing all the PMU MSRs is somehow serializing state sufficient to not
> > cause the above mentioned fails? Specifically, clearing PEBS_ENABLE
> > should inhibit those malformed PEBS records or something? What if the
> > host also has PEBS and we don't actually clear the bit?
> > 
> > The current order ensures we rewrite LVTPC when global control is unset;
> > I think we want to keep that.
> 
> Yes, for sure.
> 
> > While staring at this, I note that perf_load_guest_context() will clear
> > global ctrl, clear all the counter programming, and re-enable an empty
> > pmu. Now, an empty PMU should result in global control being zero --
> > there is nothing run after all.
> > 
> > But then kvm_mediated_pmu_load() writes an explicit 0 again. Perhaps
> > replace this with asserting it is 0 instead?
> 
> Yeah, I like that idea, a lot.  This?
> 
> 	perf_load_guest_context();
> 
> 	/*
> 	 * Sanity check that "loading" guest context disabled all counters, as
> 	 * modifying the LVTPC while host perf is active will cause explosions,
> 	 * as will loading event selectors and PMCs with guest values.
> 	 *
> 	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
> 	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
> 	 * configuring all events to be GUEST_ONLY.
> 	 */
> 	WARN_ON_ONCE(rdmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL));

This doesn't actually work, because perf_load_guest_context() doesn't guarantee
PERF_GLOBAL_CTRL is '0', it only guarantees all events are disabled.  E.g. if
there are no perf events, perf_load_guest_context() is one big nop (I think).

And while it might seem reasonable to expect PERF_GLOBAL_CTRL to be '0' if
there are no perf events, that doesn't hold true today.  E.g. amd_pmu_reload_virt()
unconditionally sets all supported MSR_AMD64_PERF_CNTR_GLOBAL_CTL bits.

I'm sure we could massage perf to really truly ensure PERF_GLOBAL_CTRL is '0',
but I don't see any value in explicitly doing that in perf_load_guest_context()
(versus simply doing it in KVM), and I would rather not play whack-a-mole in perf
as part of this series.

So unless someone really, really wants to lean on perf to clear PERF_GLOBAL_CTRL,
I'll go with this:

	/*
	 * Explicitly clear PERF_GLOBAL_CTRL, as "loading" the guest's context
	 * disables all individual counters (if any were enabled), but doesn't
	 * globally disable the entire PMU.  Loading event selectors and PMCs
	 * with guest values while PERF_GLOBAL_CTRL is non-zero will generate
	 * unexpected events and PMIs.
	 *
	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
	 * configuring all events to be GUEST_ONLY.  Clear PERF_GLOBAL_CONTROL
	 * even for SVM to minimize the damage if a perf event is left enabled,
	 * and to ensure a consistent starting state.
	 */
	wrmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL, 0);

