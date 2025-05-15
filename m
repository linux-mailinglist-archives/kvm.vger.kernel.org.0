Return-Path: <kvm+bounces-46616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770B9AB7AB1
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3C134C745E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E648572617;
	Thu, 15 May 2025 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WtR2M5CK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB2770838
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747269804; cv=none; b=ZrwgJr5WzHerG+4WZgaiPQhLMWyr70nsKAoT4Qsp9Djh3cxTJb5+azwhl2e5royUB2iyDKrP8OIjjpOIX+E+7uBJf7I0lFx01s3qVQ2K8npUpabUsAQmoQJZxj2gFWlhX32Zo81CeOLIrdTPEqA806ZyGt/I9b5Zrd+nB/KHsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747269804; c=relaxed/simple;
	bh=sh3HU8ZTmV1xK08ux3gq1GamRBC3N2HLZmWvZ+uSV+c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DGknJT/cB7VmbGHFF4jKCt4NCUzEWoa84TzWv1n1ed6j2peDoNTjljk8gx/u4JZ9eXFU2kS7m2HrtuL5/7rNAwowQCUBAEd1q+vJt+Fi9ttb9vgd+QH9hqkBlJc27e67bHBrYESUxIbdLKSXSif3TpnlXiSz8WFzLQw5EHDOS2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WtR2M5CK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e2bd11716so404718a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 17:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747269802; x=1747874602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qi9rXvGS+iuUqtWdNSRUfqShbIMa2mNBIlT2w7H0VXw=;
        b=WtR2M5CKMjkgGJ4SKGK+yCNMe0Wchq/D2uZw4ojjOmLAmbmXBi/Nn53Q0WNbg1OvRW
         +ZbwAVx0fl4W8uTvhAt+xW3Zsc54gEheCN9rzsrc4iFeteIGHuqJEu7a5cpOvL1jRRkY
         N22ISRp7gZQoUNfNPUFiTtYLVqCqK8LUHHMgVVuXkFHwX8aWvQ+4gYfTaGbqgZws70EI
         +4BVMUpfBW7vtrn+DSC/aVEJ4NmgqMfRTZBuxV9ccYS0Pivd3oCK3YRnKLCRFOJnbKUc
         tH+DifyV/7yUfZ+3+1kLYI8Dfnd52TBcA67lkve1NO9/rO8SGHvjqtDIhzjUpkn4+QkH
         TS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747269802; x=1747874602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qi9rXvGS+iuUqtWdNSRUfqShbIMa2mNBIlT2w7H0VXw=;
        b=M40/6gNYJrLt6R0c41hZcU7TAy6cLb2AoerPnxMNR6KuFU8t8Li1EByI+yElI/sGJm
         E3JPA5DnMvzIrOHZXQjE1O4slbqGB6fO2VjyxmNXgvU7XcklI5PtT11fBHidvWTPnbjg
         Cf6wiGZz2AA/pddwEEW5vV45vGm9X9Bd1vLzXv6xNFwP3QDOX4oXkaLVmTkRa3eTKRgz
         HRY+S1BslSSv/z3t+qVyBttpeA1wtXo4ADYAOVIBddGmOuK7WqKqHYTFdMdKldBWwHAF
         uOfBJ8QroXGRYbANAyriBtV4201A66K6xc1G3YqZGVPKVmMqpfvEbVvN86L1VeKoQSvG
         wB7g==
X-Forwarded-Encrypted: i=1; AJvYcCWmv4dquzvQHvSCzOXBiGBamReGTIXjNrXSBQfQwI0Nt2IT+vtO1lzoVvfxIWBzFytdykw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmbAmTrdbDBjWw1tBqI+sNTWx0F/cQvTxUXGZbATcQ4NcHh3BT
	r0iARzPHpPRgWveM8UC1gT8Nh4/6fBGWmQbFXtiu7bREZPeJcYs7FB3j1aq2PNqcpiLYcBqP9Ae
	e9g==
X-Google-Smtp-Source: AGHT+IFzn6XtXG9DycxGfH/GbFRwVV8EVW6xOATWhl7aoIWCLbu6lw861vOtGGbJ05KZULEzBclxkjJPHDY=
X-Received: from pjbsr12.prod.google.com ([2002:a17:90b:4e8c:b0:30a:2020:e2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d84:b0:2ee:e518:c1cb
 with SMTP id 98e67ed59e1d1-30e5156edcbmr1131216a91.7.1747269801886; Wed, 14
 May 2025 17:43:21 -0700 (PDT)
Date: Wed, 14 May 2025 17:43:20 -0700
In-Reply-To: <20250324173121.1275209-28-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-28-mizhang@google.com>
Message-ID: <aCU4qAjgUCUa5Mgz@google.com>
Subject: Re: [PATCH v4 27/38] KVM: x86/pmu: Handle PMU MSRs interception and
 event filtering
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

Again, be more precise.

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> Mediated vPMU needs to intercept EVENTSELx and FIXED_CNTR_CTRL MSRs to
> filter out guest malicious perf events. Either writing these MSRs or
> updating event filters would call reprogram_counter() eventually. Thus
> check if the guest event should be filtered out in reprogram_counter().
> If so, clear corresponding EVENTSELx MSR or FIXED_CNTR_CTRL field to
> ensure the guest event won't be really enabled at vm-entry.
> 
> Besides, mediated vPMU intercepts the MSRs of these guest not owned
> counters and it just needs simply to read/write from/to pmc->counter.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Co-developed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/pmu.c | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/pmu.h |  3 +++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 63143eeb5c44..e9100dc49fdc 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -305,6 +305,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
>  
>  void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
>  {
> +	if (kvm_mediated_pmu_enabled(pmc->vcpu)) {
> +		pmc->counter = val & pmc_bitmask(pmc);
> +		return;
> +	}
> +
>  	/*
>  	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
>  	 * read-modify-write.  Adjust the counter value so that its value is
> @@ -455,6 +460,28 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>  	bool emulate_overflow;
>  	u8 fixed_ctr_ctrl;
>  
> +	if (kvm_mediated_pmu_enabled(pmu_to_vcpu(pmu))) {
> +		bool allowed = check_pmu_event_filter(pmc);
> +
> +		if (pmc_is_gp(pmc)) {
> +			if (allowed)
> +				pmc->eventsel_hw |= pmc->eventsel &
> +						    ARCH_PERFMON_EVENTSEL_ENABLE;
> +			else
> +				pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
> +		} else {
> +			int idx = pmc->idx - KVM_FIXED_PMC_BASE_IDX;
> +
> +			if (allowed)
> +				pmu->fixed_ctr_ctrl_hw = pmu->fixed_ctr_ctrl;
> +			else
> +				pmu->fixed_ctr_ctrl_hw &=
> +					~intel_fixed_bits_by_idx(idx, 0xf);
> +		}
> +
> +		return 0;

I think it's worth adding a helper for this, as it makes things a bit more
self-documenting in terms of when KVM needs to "reprogram" mediated PMU PMCs.

