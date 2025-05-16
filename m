Return-Path: <kvm+bounces-46807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 670A7AB9DA5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D81F23A83D6
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EA172607;
	Fri, 16 May 2025 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="htm8yxHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188B72A1AA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402593; cv=none; b=SeohcNwqMOTkapubbVLHlsA/4INPaNsLwMTbXlSVyc5FKyIM9imPlllT63O3Hf4duNdg6cnsozkuh3ZLsaaZWw+SSF3EC7rKkuLAHrG50ju6yXQezrmVR5X02Zn5+xDejhCe6tOpvcXmHQFZ/4ivO8q5Fu3f1qO6mFri58NDTqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402593; c=relaxed/simple;
	bh=gzBy5TTcFJ3Ju+lkxl17/Cv2ww6IlyXb3lMPvTTW0+Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U8gMiiUl8Zb6YHHVqgXYBAqjSyEGOutK4yw26lBjppRWTG9XgWZEuQiXB1/QBW5G1ksQbpej+oUraF6hDvk4vETsYK+hVipK1r0tQGQSh2SuhBiOr9X8QIjsyMjd/z+4twQL4Gga/Z6ZZvmEsf+VcKzdQwiXMHHAkHPqKeMWS28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=htm8yxHC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7375e2642b4so1592426b3a.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 06:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402591; x=1748007391; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sr0VF1D9f4EdiXRgig2Y19NqlMlaKz9LNUFtzyrU4Tw=;
        b=htm8yxHCwbnujK5LXLcVoxYrpuPDdapk/TVsm2G1KX0VWhKO9UZWCDKcK+fBD/H4d1
         BIyv5yfojAxEp1QqGfgnvZmaMRaH5MgnZJgqHTpyb2VdM8811I3B4x5ndZO41cixfs1n
         vJIMFKrlVXU1ZYuDVBtycpiP/lu+Q4AGT1L0rbN3K7RVu/+wM/DtdVK6JTwchoQ0mu8+
         YLuODh+kkPP1Vm0/a9fkdy1w+Agh7UiGK5xDe/r8u/6O2KiajcecSZ2Mu/G9d9vGRO2U
         YzhcD2pT4X8v/4XGnVeHrwzB0DhJl9lJ5czRbesFlKRfFdj3Pt8GbHQfRV6WVocKjbVh
         j5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402591; x=1748007391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sr0VF1D9f4EdiXRgig2Y19NqlMlaKz9LNUFtzyrU4Tw=;
        b=v9BL9130PI/aKk/PiXEv8vmfr8IeF4akQoGtNL/A7aeNw22CJo34hHghyfZlBc8DE1
         9SUXW+a/kRPfT7ssvHqIdfYeDRL5A7QLxFpNgQoZb3uBwdmBXe7MEB0AaM9q29DZmi7v
         KCauG8IncbfMNsQ60T/pHfP49pkK95r9PX9xdHgwgGyes3OA8AseEeIjIspcX9m4DVPq
         AJc239Qyi0dIkJ2IgXG6A5hcN5F3gLJHYIf8+SKQMvtTKcQWsSfbTw+NPliArFdElwtG
         0atHqdFvBm/MWO4LGZGJ/lIT1r9jxNUcJ7alyTMyXytETRvaSeeK/D50nPToridXkM8g
         ms/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVH4pjRxFd4gtJemcS7ounfm70EcRkyWYWQEM5jOWwetO2vbdmtJfzE2AcfVpyZ5d5ykqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY5itbSZO2gdIIyXfnxbXyKL0zD6uoa88W5EQw/+b2zCj7CnJL
	QWLTFQY1ZjVyo3gpyzcC0QcoSeI8SnTbss5K4xfXo0hh+QYBJxiY1812Y+IfWEHtNTJtksgbxr1
	kOfK3vA==
X-Google-Smtp-Source: AGHT+IEhdLfsUKZfqxAmSSK/NZ6cCAotywEPb/wMxpYTMH4NdwOB83MvM0a738g3iK2/V7i3Nl+pBDtNm2c=
X-Received: from pfbkm42.prod.google.com ([2002:a05:6a00:3c6a:b0:736:3e92:66d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d1f:b0:1f3:3690:bf32
 with SMTP id adf61e73a8af0-216218c644dmr4974759637.18.1747402591371; Fri, 16
 May 2025 06:36:31 -0700 (PDT)
Date: Fri, 16 May 2025 06:36:30 -0700
In-Reply-To: <20250324173121.1275209-26-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-26-mizhang@google.com>
Message-ID: <aCc_Xh4hSCL4eVV8@google.com>
Subject: Re: [PATCH v4 25/38] KVM: x86/pmu: Add AMD PMU registers to direct
 access list
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
> From: Sandipan Das <sandipan.das@amd.com>
> 
> Add all PMU-related MSRs (including legacy K7 MSRs) to the list of
> possible direct access MSRs.  Most of them will not be intercepted when
> using passthrough PMU.
> 
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 24 ++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h |  2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a713c803a3a3..bff351992468 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -143,6 +143,30 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_K7_EVNTSEL0,			.always = false },

These are always intercepted, i.e. don't belong in this list.

> +	{ .index = MSR_K7_PERFCTR0,			.always = false },
> +	{ .index = MSR_K7_EVNTSEL1,			.always = false },
> +	{ .index = MSR_K7_PERFCTR1,			.always = false },
> +	{ .index = MSR_K7_EVNTSEL2,			.always = false },
> +	{ .index = MSR_K7_PERFCTR2,			.always = false },
> +	{ .index = MSR_K7_EVNTSEL3,			.always = false },
> +	{ .index = MSR_K7_PERFCTR3,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL0,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR0,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL1,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR1,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL2,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR2,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL3,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR3,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL4,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR4,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTL5,			.always = false },
> +	{ .index = MSR_F15H_PERF_CTR5,			.always = false },
> +	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,	.always = false },
> +	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,	.always = false },
> +	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,	.always = false },
> +	{ .index = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,	.always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };

As with the Intel patch, this absolutely belongs in the patch that supports
disabling intercepts.

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..ae71bf5f12d0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	48
> +#define MAX_DIRECT_ACCESS_MSRS	72
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> -- 
> 2.49.0.395.g12beb8f557-goog
> 

