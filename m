Return-Path: <kvm+bounces-32215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB7C9D4336
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8198C284DD0
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DC91BC9F9;
	Wed, 20 Nov 2024 20:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="izbO6wlV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF9C136E3F
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 20:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732135263; cv=none; b=klrl2EaizZp3v5/fhSG7gaC/LiV9vshi/G25rGj36m1hcnHGQMJ1k+OYuxfkfyeWCjV9EGGSBOJlkL6Z7FJAIh9IiC4czUXhSljB8BMd2vEplqFD/x13hpF30Cp9GXPh3cCHd4aZnTUnzf32RmiMT/DDFvSlz5QQdrwV/IcKi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732135263; c=relaxed/simple;
	bh=FekYk366P+ax6p+AWMnai2VmXkm3SJ34xhn7IDQjVg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Di7po3c/+4XXsMdhazusfOK7seiU5NBQS7iaf+mAIU23vqdCUqcJceulY3Zf1tcpyuE5o5le6NRerUNsc+Bfng5aw03HY4Sj1btWyXIrL2nrDLyioOPNXqNamQwzBURMFSXC32voMZowtyHN47eMfgZhiB6EFbJXH+PTsmsJceQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=izbO6wlV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e389bce2713so196401276.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 12:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732135261; x=1732740061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mqgL25CUvMLSEM2lw1UXMqf9Sdbdhpgd87dTtkToLJY=;
        b=izbO6wlVj40OCqR+fFyrdfXI6RWNoJaubE0PCIF/68JtCJIzTN9fy7JZhyLH8B9I6L
         MFDb8DX2HLMIGbT/G5KZrQEthjjeWtdsHjpwwVlDJ/6uu/9+utSyR9wf3Jhk0405NEuU
         rocAxnxigFlSPRQcZqCfqwLyo630sHg2BIx85efSZFhh00Qt4ron4FoScHX+Nix0X+fk
         QBByzHOpkOTkrkPLIOGrgYj4EMg/YdpUB5/KcrhUW60vlSsuSMD5Ps4PIZX5CYpJSbY2
         C5/p+irOySoaV6DJICqUwUKPszDE7D/NKLobTo3Ov2GjNrrdn3a3MAofL2tlmqmbzLXW
         frRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732135261; x=1732740061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqgL25CUvMLSEM2lw1UXMqf9Sdbdhpgd87dTtkToLJY=;
        b=aUia/Wi8jA5ehW3fHRLHzjUfDI1WvBBgkos7+SzSyQASgxB2k1eWrDk+dG/Xo6FL5A
         RK0AsCFaMr0D1c04AuNsaUFxdgBk2dNmxJ9eYGDhoARSBlgJoxC1p0WUMMk/jk5Bb7h1
         m3iwUTZcX2MGD2sv3qr96O0l7kAFrKjxZPPiVCXi74qIPjoZ1QCHBQmtXVGhyyV2cBJn
         kAPHTGIqj/Ok4LgCk20tzxQBz6J8qbtjwwcO+UbXw9P5dvmaaXSwhLkIxKJMMgWEsaYB
         RneCm/+1diMKN9LBSrnRh6j9xAkHyTh3nelFBMXm6rV89W5fSGe38kbQBQzSnRYmD+iK
         Ps9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWudDNRj51/syRufThr1ETgSclbGDpgihbjrkPfnNk8en1ToPC8p5PVXZoVNi6ckC3tsdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ7vQuJctfBdX8AameXee5E6KldINaV586oUxoU0tCaz49gRds
	dpE3pXwawQgCJDrCF9aK0494PC4no7yz9v8VdgtUktqNPqrMVlUYJ4SOdVJxRxb5mXtIdLPz6q8
	YyA==
X-Google-Smtp-Source: AGHT+IH7F4h6lNCm7/g0kpauweOjyktR0gYjOGEqScoxPC7VLdyH4oaNeASBzAs0j7QsC31w5fKpiMsRptg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:2e4b:0:b0:e25:cea9:b0e with SMTP id
 3f1490d57ef6-e38cb73f509mr1532276.9.1732135260780; Wed, 20 Nov 2024 12:41:00
 -0800 (PST)
Date: Wed, 20 Nov 2024 12:40:59 -0800
In-Reply-To: <20240801045907.4010984-47-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-47-mizhang@google.com>
Message-ID: <Zz5JW-LGL4tvB2r8@google.com>
Subject: Re: [RFC PATCH v3 46/58] KVM: x86/pmu: Disconnect counter reprogram
 logic from passthrough PMU
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Disconnect counter reprogram logic because passthrough PMU never use host
> PMU nor does it use perf API to do anything. Instead, when passthrough PMU
> is enabled, touching anywhere around counter reprogram part should be an
> error.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/pmu.c | 3 +++
>  arch/x86/kvm/pmu.h | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3604cf467b34..fcd188cc389a 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -478,6 +478,9 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>  	bool emulate_overflow;
>  	u8 fixed_ctr_ctrl;
>  
> +	if (WARN_ONCE(pmu->passthrough, "Passthrough PMU never reprogram counter\n"))

Eh, a WARN_ON_ONCE() is enough.

That said, this isn't entirely correct.  The mediated PMU needs to "reprogram"
event selectors if the event filter is changed. KVM currently handles this by
setting  all __reprogram_pmi bits and blasting KVM_REQ_PMU.

LOL, and there's even a reprogram_fixed_counters_in_passthrough_pmu(), so the
above message is a lie.

There is also far too much duplicate code in things like reprogram_fixed_counters()
versus reprogram_fixed_counters_in_passthrough_pmu().

Reprogramming on each write is also technically suboptimal, as _very_ theoretically
KVM could emulate multiple WRMSRs without re-entering the guest.

So, I think the mediated PMU should use the reprogramming infrastructure, and
handle the bulk of the different behavior in reprogram_counter(), not in a half
dozen different paths.

> +		return 0;
> +
>  	emulate_overflow = pmc_pause_counter(pmc);
>  
>  	if (!pmc_event_is_allowed(pmc))
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7e006cb61296..10553bc1ae1d 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -256,6 +256,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  
>  static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>  {
> +	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
> +	if (pmc_to_pmu(pmc)->passthrough)
> +		return;
> +
>  	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>  	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  }
> @@ -264,6 +268,10 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>  {
>  	int bit;
>  
> +	/* Passthrough PMU never reprogram counters via KVM_REQ_PMU. */
> +	if (pmu->passthrough)
> +		return;

Make up your mind :-)  Either handle the mediated PMU here, or handle it in the
callers.  Don't do both.

I vote to handle it here, i.e. drop the check in kvm_pmu_set_msr() when handling
MSR_CORE_PERF_GLOBAL_CTRL, and then add a comment that reprogramming GP counters
doesn't need to happen on control updates because KVM enforces the event filters
when emulating writes to event selectors (and because the guest can write
PERF_GLOBAL_CTRL directly).

> +
>  	if (!diff)
>  		return;
>  
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

