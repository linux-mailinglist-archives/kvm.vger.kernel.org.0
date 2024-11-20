Return-Path: <kvm+bounces-32196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB289D41A9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A0ADB2BD56
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2D91AB523;
	Wed, 20 Nov 2024 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="peEDogQw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834D3487BE
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732123838; cv=none; b=YZb6tBEFpgOQVTwAADPTocPHJ1rXLzIBT9eYl0gXRz5FhyaQqcm1fZiTLVCWM8ZtsoAG4cSthm1B488mxwJJ/cyajPmRDeryu1aYyAyI+TTpRrt4y/GtCauE+4ugN5MGdvGMR8Ty/4E/TBi9oZprXrXDs6FjONeAaB0bLED6iZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732123838; c=relaxed/simple;
	bh=TG0dlCFUSN4cnij7g01n4dBy7QEzuUOjv1gkitQFLnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fk6kbPNvCNwDRdVoo5g7UPMEH4+8Hnam42+bjiJJ5FZYwn3WGNrp47V+VTnGK3fu9JsgnEAzK7wXnuQXk+6uxcqOgVUhybsTwmNx52NRI8TrU57EOvxzUxdWfWcVX8Q95DlZ6sU7r1bVSzLrb+Fbi9aaOEQhEdTlGh5W0exXnnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=peEDogQw; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eec923c760so6495427b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 09:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732123835; x=1732728635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKWW5QzZwmE/Mi4Elyfcq3cgERVzaGEbfYDFGjWzMI8=;
        b=peEDogQwcXUAP+m34K5livHmhFiAA/iKXngd+5cBOmVhQ74QK6xtsgQkY1Ao2MUyax
         pXN+Qp4XJvdSqDvil/rSpja7g8b61RVakhrxwYbi/knVac1qOMHLds5ilAQLLPnU079A
         VcV9L3IPtuFwxKpRL03tcfSP3Vth4jBZsOJyZonFX3teNeyoAEYFW0XwZNSUyQEQ7tcw
         OtKXr5g/TyJ+aPhJXezEtF0v7kHXzn6l4koUvWEQeijXZQI95g3xQlKOlH9fGhLJSfQt
         uSFa9L8MsBSVmPJwF4xuTHXo8y6zXXb+PL0KkgN95IRz+CKswjaHb/6AIwd5LEaKK7yQ
         BY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732123835; x=1732728635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKWW5QzZwmE/Mi4Elyfcq3cgERVzaGEbfYDFGjWzMI8=;
        b=iu5xASzo5sGlxS6fhEsYCkhsadgAmkfA5+KpnHFSZyhPwfQhWEuTECWYPU1EthnWZs
         cnQC2ZZPIHsItPMKrsq+UQBEKTkJHf4zun3pI4bfc9fIlU+CD5LILsryFRNNI1AMyjkk
         0YZY1I75SuTnEmENJtuoed/cUaxk0KWCQKk1m//v8mYWkUDCanpteGiG8HQFehkiQToH
         HyFqK9eVrM3nT75PmQ3GcahzGN2fVzu/uutObI1BHl5RCdSYoz7A6+J+gzwaVo+l5J6Q
         jcEVcIaFl7ytRUIxTVWsEQhhBE/eap7d50vSFZ0AZWp2SftUJvg4HZiNtX0YdzYkyW+a
         lsOQ==
X-Forwarded-Encrypted: i=1; AJvYcCURrDGzRno6tow8xd9w8wAiFIoMgqZWSOPCEkb/VppCvtTVcuDVLEpMz/optSo/JEwLsfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCkjkj9P3PsUzF/AspO99QeheenM0d9/yUXvTrJ+DNIaoOZUDX
	vn/tdfXHNjK3hXQ5Jmpl/+bGGNBZV64IcKBy16TpRnthjpMnA7CkZY4lfXI9czq01iUpoiSsFiE
	gqA==
X-Google-Smtp-Source: AGHT+IFQrscPnIPzw9XKs9NYl+H6VDRxDA+r6yWqcphM0I3a+4bD6VZIBrqslhYOxvzvI3Hd4UFJ1+s3X6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ae8f:0:b0:e30:cee4:1922 with SMTP id
 3f1490d57ef6-e38cb5f8c07mr4899276.7.1732123834965; Wed, 20 Nov 2024 09:30:34
 -0800 (PST)
Date: Wed, 20 Nov 2024 09:30:33 -0800
In-Reply-To: <01b6dc80-8cb6-4b13-9d0f-db3a07672532@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-32-mizhang@google.com>
 <ZzzfwXefHP7SG-Vy@google.com> <01b6dc80-8cb6-4b13-9d0f-db3a07672532@linux.intel.com>
Message-ID: <Zz4cuXfFtXzRAWvC@google.com>
Subject: Re: [RFC PATCH v3 31/58] KVM: x86/pmu: Add counter MSR and selector
 MSR index into struct kvm_pmc
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 20, 2024, Dapeng Mi wrote:
> 
> On 11/20/2024 2:58 AM, Sean Christopherson wrote:
> > Please squash this with the patch that does the actual save/load.  Hmm, maybe it
> > should be put/load, now that I think about it more?  That's more consitent with
> > existing KVM terminology.
> 
> Sure. I ever noticed that this in-consistence, but "put" seem not so
> intuitionistic as "save", so didn't change it.

Yeah, "put" isn't perfect, but neither is "save", because the save/put path also
purges hardware state.

> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 4b3ce6194bdb..603727312f9c 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -522,6 +522,8 @@ struct kvm_pmc {
> >>  	 */
> >>  	u64 emulated_counter;
> >>  	u64 eventsel;
> >> +	u64 msr_counter;
> >> +	u64 msr_eventsel;
> > There's no need to track these per PMC, the tracking can be per PMU, e.g.
> >
> > 	u64 gp_eventsel_base;
> > 	u64 gp_counter_base;
> > 	u64 gp_shift;
> > 	u64 fixed_base;
> >
> > Actually, there's no need for a per-PMU fixed base, as that can be shoved into
> > kvm_pmu_ops.  LOL, and the upcoming patch hardcodes INTEL_PMC_FIXED_RDPMC_BASE.
> > Naughty, naughty ;-)
> >
> > It's not pretty, but 16 bytes per PMC isn't trivial. 
> >
> > Hmm, actually, scratch all that.  A better alternative would be to provide a
> > helper to put/load counter/selector MSRs, and call that from vendor code.  Ooh,
> > I think there's a bug here.  On AMD, the guest event selector MSRs need to be
> > loaded _before_ PERF_GLOBAL_CTRL, no?  I.e. enable the guest's counters only
> > after all selectors have been switched AMD64_EVENTSEL_GUESTONLY.  Otherwise there
> > would be a brief window where KVM could incorrectly enable counters in the host.
> > And the reverse that for put().
> >
> > But Intel has the opposite ordering, because MSR_CORE_PERF_GLOBAL_CTRL needs to
> > be cleared before changing event selectors.
> 
> Not quite sure about AMD platforms, but it seems both Intel and AMD
> platforms follow below sequence to manipulated PMU MSRs.
> 
> disable PERF_GLOBAL_CTRL MSR
> 
> manipulate counter-level PMU MSR
> 
> enable PERF_GLOBAL_CTRL MSR

Nope.  kvm_pmu_restore_pmu_context() does:

	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);


	/*
	 * No need to zero out unexposed GP/fixed counters/selectors since RDPMC
	 * in this case will be intercepted. Accessing to these counters and
	 * selectors will cause #GP in the guest.
	 */
	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
		pmc = &pmu->gp_counters[i];
		wrmsrl(pmc->msr_counter, pmc->counter);
		wrmsrl(pmc->msr_eventsel, pmu->gp_counters[i].eventsel_hw);
	}

	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
		pmc = &pmu->fixed_counters[i];
		wrmsrl(pmc->msr_counter, pmc->counter);
	}

And amd_restore_pmu_context() does:

	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
	rdmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, global_status);

	/* Clear host global_status MSR if non-zero. */
	if (global_status)
		wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, global_status);

	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, pmu->global_status);

	wrmsrl(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, pmu->global_ctrl);

So the sequence on AMD is currently:

  disable PERF_GLOBAL_CTRL

  save host PERF_GLOBAL_STATUS 

  load guest PERF_GLOBAL_STATUS (clear+set)

  load guest PERF_GLOBAL_CTRL

  load guest per-counter MSRs

