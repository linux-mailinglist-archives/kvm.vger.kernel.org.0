Return-Path: <kvm+bounces-46608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9D1AB7A5F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 02:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD29F86471F
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 00:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFA44A1D;
	Thu, 15 May 2025 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLop0/wl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5B4191
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747267932; cv=none; b=ZXGcyxUIlu114vsZekWf6jjp2FrgO4zI48UgG0VDkYigbEk90dvNuVUvTnGvraF7u2p9bgzJeS4p/OY6EdaIW7cNWKHgJt7MagCxTi5AM25kWQbKrPntM4jKVamiiHwmoDHkNBvaDzyi1Hijm7f3Hh4fzTPZZWeHxnQzIG0RBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747267932; c=relaxed/simple;
	bh=XBHpEOO6Mr1iT9xgbGw2KgXJRnpu8AxHovPzS00EkNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A3GKB9V/xfb8/aXCebpDYffoahKyMCDcArtI63mc932KdOsSUzM6ap8N06MtJmQxezfBegzxiy+ZVwcz2P/i0rtcEXw92J8tOx3J04PiPQiLRtz/aO1KP483omgaYBFjMx5gSs7Fdohfhp481qaOrYRkUKaXTFO7sNXYK+UZRHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLop0/wl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30aab0f21a3so396524a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 17:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747267930; x=1747872730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/2fHF7ECrBSJHvJ0UWFB+mnx2K6tbXAT5+pP8NTWgjM=;
        b=ZLop0/wlt2cB1ECuQVJWkz/p/RdAU6roETy1BqvGERmr7K/tdTbTBzIN0tJxx3inwe
         9RORleRRb1UH9NqUpFJWQcEBQ6v+FzRNGl5zWcrqZq28mg4O1GkDnc9/d/be4ILZakUP
         1dFqEJbi8eanqcD172fuzfiNcUsQcE1NUldz5wdVmXUSt4eZrG4fU9njYtk11rhmv5Ek
         nY2JUa2CMK223+JbL4lohJUCaTeGzmOjZW8Ub8i1l5VOpW2cEykoA/hK+dA1ApZZLL7I
         WKZXnK90UvI6S7HItxzEUXo3DexQmzomPww3pn7caQHaVjDUVBBOCOvgTm6srPrSUI7q
         lf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747267930; x=1747872730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2fHF7ECrBSJHvJ0UWFB+mnx2K6tbXAT5+pP8NTWgjM=;
        b=YJtRVB9oVP91sYeJ8E+MLJ7Uz2EPnPxtKpAits4I+eBQYjqRu4XW4QUg2unzkUTHJr
         KTkWOAs/6NLR3N7xWPNOzMvN/beJPg8dt1i34gYhRzCQO1wP92R/DDvEbBBdn99dI8y2
         Gpx6WcLodY8lX7rwih3XhGS05G6AUJakxCdQkcnjEjlB+L7+ce/I/FfMiO2ByDSJnOII
         Ykn7Une8pOXMOLkOXZ8aF2tV9c6pVdXmOvcskq226CLF51ls0+idW5ojADfwiuaM2xWI
         I70ZFlsiMFUC7gXXGWsdKMdJHKxwu47nv2Aj0tN/9GBufI4hK067sUC+G7cHCArRU6Jt
         OH6A==
X-Forwarded-Encrypted: i=1; AJvYcCVf1hheXmL+lL0ncXxqZlGZzppiEnPzzTunCNp9N9WbJlYekcbV4IseIRLn7c1tYa76lZc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk1xm3H8/uA/EHQalVhNAvZGqc6FbaBuGnm9fLlKzSI0ZfeAgS
	svCELY1aF5DONxx2057yJB4m2ibqRR4aGBfzL1qrJpGG2iRevK6jpCv7vTnHpJkSRcRrYcZo5/Y
	K+A==
X-Google-Smtp-Source: AGHT+IErPnhCnoLtRvVCBC/lM34c051xHEZ3ABcT4upp5xMVguuSk8tvMW4mh4lK9qgPLfU5q2AMSyngOWY=
X-Received: from pjbsw6.prod.google.com ([2002:a17:90b:2c86:b0:2fa:2891:e310])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35d2:b0:2ee:f076:20fb
 with SMTP id 98e67ed59e1d1-30e2e613263mr9505193a91.17.1747267929967; Wed, 14
 May 2025 17:12:09 -0700 (PDT)
Date: Wed, 14 May 2025 17:12:08 -0700
In-Reply-To: <20250324173121.1275209-16-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-16-mizhang@google.com>
Message-ID: <aCUxWDaNKezTzJTV@google.com>
Subject: Re: [PATCH v4 15/38] KVM: x86/pmu: Check PMU cpuid configuration from
 user space
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

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> Check user space's PMU cpuid configuration and filter the invalid
> configuration.
> 
> Either legacy perf-based vPMU or mediated vPMU needs kernel to support
> local APIC, otherwise PMI has no way to be injected into guest. If
> kernel doesn't support local APIC, reject user space to enable PMU
> cpuid.
> 
> User space configured PMU version must be no larger than KVM supported
> maximum pmu version for mediated vPMU, otherwise guest may manipulate
> some unsupported or unallowed PMU MSRs, this is dangerous and harmful.
> 
> If the pmu version is larger than 1 but smaller than 5, CPUID.AH.ECX
> must be 0 as well which is required by SDM.
> 
> Suggested-by: Zide Chen <zide.chen@intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 15 +++++++++++++++
>  arch/x86/kvm/pmu.c   |  7 +++++--
>  arch/x86/kvm/pmu.h   |  1 +
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8eb3a88707f2..f849ced9deba 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -179,6 +179,21 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  			return -EINVAL;
>  	}
>  
> +	best = kvm_find_cpuid_entry(vcpu, 0xa);
> +	if (vcpu->kvm->arch.enable_pmu && best) {
> +		union cpuid10_eax eax;
> +
> +		eax.full = best->eax;
> +		if (enable_mediated_pmu &&
> +		    eax.split.version_id > kvm_pmu_cap.version)
> +			return -EINVAL;
> +		if (eax.split.version_id > 0 && !vcpu_pmu_can_enable(vcpu))
> +			return -EINVAL;
> +		if (eax.split.version_id > 1 && eax.split.version_id < 5 &&
> +		    best->ecx != 0)
> +			return -EINVAL;

NAK, unless there is a really, *really* strong need for this.  I do not want to
get in the business of vetting the vCPU model presented to the guest.  If KVM
needs to constrain things for its own safety, then by all means, but AFAICT these
are nothing more than sanity checks on userspace.

> +	}
> +
>  	/*
>  	 * Exposing dynamic xfeatures to the guest requires additional
>  	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4f455afe4009..92c742ead663 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -743,6 +743,10 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>  	kvm_pmu_call(reset)(vcpu);
>  }
>  
> +inline bool vcpu_pmu_can_enable(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->kvm->arch.enable_pmu && lapic_in_kernel(vcpu);

Again, the APIC check belongs in the VM enablement path, not here.  Hmm, that
may require more thought with respect to enabling the PMU by default.

