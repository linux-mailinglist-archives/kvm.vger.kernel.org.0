Return-Path: <kvm+bounces-46611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F92AB7A81
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 495BA1BA5F2C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E513D994;
	Thu, 15 May 2025 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cGpN0wsC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9BB1863E
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747268398; cv=none; b=ZfJaefMg0E4zFEf1oVnyG5JVL4p6xoL+g7jPnr8nISqDV+rHgzg1su161jmcLrAUMZPCcDzkU6pkAiYfed92nBKpIt30zeI5P8LvhW3T34iiwfrbnSD3e61ieEu4dVGp4xM7St7boskg7eJplKd/QkdJZ7qfMJYLzVYR2af+HwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747268398; c=relaxed/simple;
	bh=LjpMuPJLWL/kSD36VWNs6Nv8CF2pnWpxWtkNafcX8qI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hf/86/GxT3CssirNcJgzD+8GAF4PQcOsARUxbhL2W6ZVtCil07OxwXJ5Geu/9sGCkhQWMq/pXLorKiRHezXofttKK3AGAeKf15TNY/TTBF1TzjBvwMsshBq5l0LYkQ4z/OMcJXvW7sAYAKUXyrcz2zrL4c5NphlN71aW44HouBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cGpN0wsC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30cbf82bd11so308153a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 17:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747268396; x=1747873196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NillZDQHMGkN8gsEINGl9IIKhPwgteKU+AMr08jxx80=;
        b=cGpN0wsCVFBG33lcBz1uHs+nfwzzkqv1AUTvfuyePYLl6tcU2yuHeZrzftncdn8jT4
         BZ+3ZwPjobA6iOUU1hg4ImgJyS5gruDKuu1hc7OwR48XAH4OYB/4W9xz0frZXmVQBuDH
         sgeqxSTGRh/7p+pzLbPa+D7Vb3cgia/uBpq3qfCccR7oYlvktKdtad/qdtB64E7g1X49
         J1Q3K/oIFcoax6ehIu0OzrVyPEOJ2SkkLEoqvfxrgtkYqGQ/wfzDnZWqGqNUhjzRE8J7
         B6Zd0cE40p7TJYsV+WYsCaW2dMdsX+4bU3N+QK44raVLYHT8g0fmuYvjuXZcqjgOpFh8
         HOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747268396; x=1747873196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NillZDQHMGkN8gsEINGl9IIKhPwgteKU+AMr08jxx80=;
        b=ieBZhJV/JyuPGjD64dck0SiF0sn80X/o5PqeW1+/L5redJCyPDugq8hr60IY9QvrDS
         Y6TIQgzQ3HFE3DFRK8pjIcR0K5I9RXaL86NTMVNroLkiSUbhXGfxSHfpu+B0SuiIdEMm
         2qHjjwG4zkpFuyP58v90E7M//w/Hi502poFAfUST8HAUTkJWkpjvXRkXRfHSt/l5qRms
         TYYLCyeKohGHaTTOvVewmcBR4Q2tIinsVij399fvqmjtHwgY2zYBPaAw6QLVCX1P5BHl
         yLjs6DMdvwFHHgqstjRVG+GFo1TOL/E6rE2CaVpkpJ+C0yaQLVgzOYm6j61U4BGxZ0OA
         T8EA==
X-Forwarded-Encrypted: i=1; AJvYcCX4vfCYru8/gYavt7mv2NPTxbS4WGeo13kD+aEYJkR2xI0nJWC+E7x1V9UcL4+N31zWO/M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc5ppztvni2bzpwgY7BrkMARFBOkO3YpasdpZj7hgsAN+Rj5Iw
	DBx0sK6oYwz75ESNUTm2H1W7/KaSHWI6nobLwIK2DM7MnoRsB91IWI6t6M9I+TANTdYyOFufdo0
	LFQ==
X-Google-Smtp-Source: AGHT+IFQjq1PCKOnQWifSwkYyIBpWTwDXTf5nA7iDlW/f85riVF6j0D/YJzRcqSnGliIoEN7myQuTor4ttY=
X-Received: from pjn12.prod.google.com ([2002:a17:90b:570c:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c4:b0:30a:4700:ca91
 with SMTP id 98e67ed59e1d1-30e5156e9e0mr777959a91.1.1747268395729; Wed, 14
 May 2025 17:19:55 -0700 (PDT)
Date: Wed, 14 May 2025 17:19:54 -0700
In-Reply-To: <20250324173121.1275209-21-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-21-mizhang@google.com>
Message-ID: <aCUzKp1uhMsn-g_u@google.com>
Subject: Re: [PATCH v4 20/38] KVM: x86/pmu: Check if mediated vPMU can
 intercept rdpmc
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

The shortlog is wildly inaccurate.  KVM is not simply checking, KVM is actively
disabling RDPMC interception.  *That* needs to be the focus of the shortlog and
changelog.

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 92c742ead663..6ad71752be4b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -604,6 +604,40 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	return 0;
>  }
>  
> +inline bool kvm_rdpmc_in_guest(struct kvm_vcpu *vcpu)

Strongly prefer kvm_need_rdpmc_intercept(), e.g. to follow vmx_need_pf_intercept(),
and because it makes the users more obviously correct.  The "in_guest" terminology
from kvm_{hlt,mwait,pause,cstate}_in_guest() isn't great, but at least in those
flows it's not awful because they are very direct reflections of knobs that control
interception, whereas this helper is making a variety of runtime checks.

> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (!kvm_mediated_pmu_enabled(vcpu))
> +		return false;
> +
> +	/*
> +	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
> +	 * in Ring3 when CR4.PCE=0.
> +	 */
> +	if (enable_vmware_backdoor)
> +		return false;
> +
> +	/*
> +	 * FIXME: In theory, perf metrics is always combined with fixed
> +	 *	  counter 3. it's fair enough to compare the guest and host
> +	 *	  fixed counter number and don't need to check perf metrics
> +	 *	  explicitly. However kvm_pmu_cap.num_counters_fixed is limited
> +	 *	  KVM_MAX_NR_FIXED_COUNTERS (3) as fixed counter 3 is not
> +	 *	  supported now. perf metrics is still needed to be checked
> +	 *	  explicitly here. Once fixed counter 3 is supported, the perf
> +	 *	  metrics checking can be removed.
> +	 */

And then what happens when hardware supported fixed counter #4?  KVM has the same
problem, and we can't check for features that KVM doesn't know about.

The entire problem is that this code is checking for *KVM* support, but what the
guest can see and access needs to be checked against *hardware* support.  Handling
that is simple, just take a snapshot of the host PMU capabilities before KVM
generates kvm_pmu_cap, and use the unadulterated snapshot here (and everywhere
else with similar checks).

> +	return pmu->nr_arch_gp_counters == kvm_pmu_cap.num_counters_gp &&
> +	       pmu->nr_arch_fixed_counters == kvm_pmu_cap.num_counters_fixed &&
> +	       vcpu_has_perf_metrics(vcpu) == kvm_host_has_perf_metrics() &&
> +	       pmu->counter_bitmask[KVM_PMC_GP] ==
> +				(BIT_ULL(kvm_pmu_cap.bit_width_gp) - 1) &&
> +	       pmu->counter_bitmask[KVM_PMC_FIXED] ==
> +				(BIT_ULL(kvm_pmu_cap.bit_width_fixed) - 1);
> +}
> @@ -212,6 +212,18 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
>  }
>  
> +static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	__amd_pmu_refresh(vcpu);

To better communicate the roles of the two paths to refresh():

	amd_pmu_refresh_capabilities(vcpu);

	amd_pmu_refresh_controls(vcpu);

Ditto for Intel.

