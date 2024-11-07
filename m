Return-Path: <kvm+bounces-31170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E269C0F43
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B01284EFD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1798B217F4A;
	Thu,  7 Nov 2024 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnZ3TZ90"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EFA194C92;
	Thu,  7 Nov 2024 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731008793; cv=none; b=pyILzju+nnf+rOUZwRMFB6X52x0D7mzGkKm3KCqTcWEmqOwX2IS+b5qCy+vyeccBOo3RlLKqHKROMl5yxH1l+OafumU9VwIyknBe0OgpvmWvXZg+9RbvMptbgzhgNIAkxd96pAPN+kPp+R1Lp1iTyz75Yb7ShUz83Jw1Sx2mtzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731008793; c=relaxed/simple;
	bh=nU6wUyehaIMnSMsUf0IiJjEAD3owJ/kov/ScS7TWAgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MBNkiy5kA6lBmzcE58pJVsBLfjQt635h5+z7Ql6JzvYZaN+HWyWVvP0+5OSZpbOVrMbT44PrM0YVeynJ99MBpQGwIhJKpQZXIx8KszBWWKSsIiJ0XXk6+ArQavDfKM7LtYuNc7J8/vf+qNOe7a7k1n7kGHUk5b6anL2cBw1vmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnZ3TZ90; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731008791; x=1762544791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nU6wUyehaIMnSMsUf0IiJjEAD3owJ/kov/ScS7TWAgg=;
  b=OnZ3TZ90xdTg3iDQYtaM+YopUtG2ia8j4cxQ3BUXaqHDg6m7V7f1DLjQ
   SCjTrfGCNDqBqEhaULT2p3kXFUWwtkIGlJk3vqC5fzUG1Ra2U8zcC5VCE
   v15EW4AgVMr7XrNkyLs1aveVhF2eIzfRqv71+NY6F4trN//ac8LRhnkwX
   bt/lghbnnSoYOh9b8UMSRjt5+lZIN4EzrlVE2qzxfPAddOb/yENqqSxSZ
   hzxH0/FNrBByHCZuW2hb97BeKM1l6WKkdkdtJQmdiSyFMg85OXJnk6zbz
   BZeHR5TbIljJw+tW6tdA3cH+QOf7gqCSVrCDc5Qot7jkGJhNnyhYkLMB3
   w==;
X-CSE-ConnectionGUID: 2CTib1heQP+5WQpkpVxWqw==
X-CSE-MsgGUID: wpvqBEp1SGy2ZP0MRgNkew==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="56272330"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="56272330"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:46:30 -0800
X-CSE-ConnectionGUID: BfFncz9rRIGYCasq2Q9UMA==
X-CSE-MsgGUID: B3tQBkvxRlmhhDfctrP1yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="84729818"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:46:29 -0800
Received: from [10.212.68.83] (kliang2-mobl1.ccr.corp.intel.com [10.212.68.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 34C2720B5703;
	Thu,  7 Nov 2024 11:46:25 -0800 (PST)
Message-ID: <655de93b-26cf-4588-aec5-9d0eba997c4e@linux.intel.com>
Date: Thu, 7 Nov 2024 14:46:24 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] perf: Correct perf sampling with guest VMs
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20241107190336.2963882-1-coltonlewis@google.com>
 <20241107190336.2963882-6-coltonlewis@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241107190336.2963882-6-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-11-07 2:03 p.m., Colton Lewis wrote:
> Previously any PMU overflow interrupt that fired while a VCPU was
> loaded was recorded as a guest event whether it truly was or not. This
> resulted in nonsense perf recordings that did not honor
> perf_event_attr.exclude_guest and recorded guest IPs where it should
> have recorded host IPs.
> 
> Rework the sampling logic to only record guest samples for events with
> exclude_guest = 0. This way any host-only events with exclude_guest
> set will never see unexpected guest samples. The behaviour of events
> with exclude_guest = 0 is unchanged.
> 
> Note that events configured to sample both host and guest may still
> misattribute a PMI that arrived in the host as a guest event depending
> on KVM arch and vendor behavior.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Acked-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan
>  arch/arm64/include/asm/perf_event.h |  4 ----
>  arch/arm64/kernel/perf_callchain.c  | 28 ----------------------------
>  arch/x86/events/core.c              | 16 ++++------------
>  include/linux/perf_event.h          | 21 +++++++++++++++++++--
>  kernel/events/core.c                | 21 +++++++++++++++++----
>  5 files changed, 40 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> index 31a5584ed423..ee45b4e77347 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -10,10 +10,6 @@
>  #include <asm/ptrace.h>
>  
>  #ifdef CONFIG_PERF_EVENTS
> -struct pt_regs;
> -extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
> -extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
> -#define perf_arch_misc_flags(regs)	perf_misc_flags(regs)
>  #define perf_arch_bpf_user_pt_regs(regs) &regs->user_regs
>  #endif
>  
> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
> index 01a9d08fc009..9b7f26b128b5 100644
> --- a/arch/arm64/kernel/perf_callchain.c
> +++ b/arch/arm64/kernel/perf_callchain.c
> @@ -38,31 +38,3 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>  
>  	arch_stack_walk(callchain_trace, entry, current, regs);
>  }
> -
> -unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
> -{
> -	if (perf_guest_state())
> -		return perf_guest_get_ip();
> -
> -	return instruction_pointer(regs);
> -}
> -
> -unsigned long perf_arch_misc_flags(struct pt_regs *regs)
> -{
> -	unsigned int guest_state = perf_guest_state();
> -	int misc = 0;
> -
> -	if (guest_state) {
> -		if (guest_state & PERF_GUEST_USER)
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> -	} else {
> -		if (user_mode(regs))
> -			misc |= PERF_RECORD_MISC_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_KERNEL;
> -	}
> -
> -	return misc;
> -}
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 9fdc5fa22c66..d85e12ca4263 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -3005,9 +3005,6 @@ static unsigned long code_segment_base(struct pt_regs *regs)
>  
>  unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
>  {
> -	if (perf_guest_state())
> -		return perf_guest_get_ip();
> -
>  	return regs->ip + code_segment_base(regs);
>  }
>  
> @@ -3035,17 +3032,12 @@ unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
>  
>  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  {
> -	unsigned int guest_state = perf_guest_state();
>  	unsigned long misc = common_misc_flags(regs);
>  
> -	if (guest_state) {
> -		misc |= perf_arch_guest_misc_flags(regs);
> -	} else {
> -		if (user_mode(regs))
> -			misc |= PERF_RECORD_MISC_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_KERNEL;
> -	}
> +	if (user_mode(regs))
> +		misc |= PERF_RECORD_MISC_USER;
> +	else
> +		misc |= PERF_RECORD_MISC_KERNEL;
>  
>  	return misc;
>  }
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 772ad352856b..368ea0e9577c 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1655,8 +1655,9 @@ extern void perf_tp_event(u16 event_type, u64 count, void *record,
>  			  struct task_struct *task);
>  extern void perf_bp_event(struct perf_event *event, void *data);
>  
> -extern unsigned long perf_misc_flags(struct pt_regs *regs);
> -extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
> +extern unsigned long perf_misc_flags(struct perf_event *event, struct pt_regs *regs);
> +extern unsigned long perf_instruction_pointer(struct perf_event *event,
> +					      struct pt_regs *regs);
>  
>  #ifndef perf_arch_misc_flags
>  # define perf_arch_misc_flags(regs) \
> @@ -1667,6 +1668,22 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>  # define perf_arch_bpf_user_pt_regs(regs) regs
>  #endif
>  
> +#ifndef perf_arch_guest_misc_flags
> +static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> +{
> +	unsigned long guest_state = perf_guest_state();
> +
> +	if (!(guest_state & PERF_GUEST_ACTIVE))
> +		return 0;
> +
> +	if (guest_state & PERF_GUEST_USER)
> +		return PERF_RECORD_MISC_GUEST_USER;
> +	else
> +		return PERF_RECORD_MISC_GUEST_KERNEL;
> +}
> +# define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
> +#endif
> +
>  static inline bool has_branch_stack(struct perf_event *event)
>  {
>  	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 2c44ffd6f4d8..c62164a2ff23 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7022,13 +7022,26 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
>  #endif
>  
> -unsigned long perf_misc_flags(struct pt_regs *regs)
> +static bool should_sample_guest(struct perf_event *event)
>  {
> +	return !event->attr.exclude_guest && perf_guest_state();
> +}
> +
> +unsigned long perf_misc_flags(struct perf_event *event,
> +			      struct pt_regs *regs)
> +{
> +	if (should_sample_guest(event))
> +		return perf_arch_guest_misc_flags(regs);
> +
>  	return perf_arch_misc_flags(regs);
>  }
>  
> -unsigned long perf_instruction_pointer(struct pt_regs *regs)
> +unsigned long perf_instruction_pointer(struct perf_event *event,
> +				       struct pt_regs *regs)
>  {
> +	if (should_sample_guest(event))
> +		return perf_guest_get_ip();
> +
>  	return perf_arch_instruction_pointer(regs);
>  }
>  
> @@ -7849,7 +7862,7 @@ void perf_prepare_sample(struct perf_sample_data *data,
>  	__perf_event_header__init_id(data, event, filtered_sample_type);
>  
>  	if (filtered_sample_type & PERF_SAMPLE_IP) {
> -		data->ip = perf_instruction_pointer(regs);
> +		data->ip = perf_instruction_pointer(event, regs);
>  		data->sample_flags |= PERF_SAMPLE_IP;
>  	}
>  
> @@ -8013,7 +8026,7 @@ void perf_prepare_header(struct perf_event_header *header,
>  {
>  	header->type = PERF_RECORD_SAMPLE;
>  	header->size = perf_sample_data_size(data, event);
> -	header->misc = perf_misc_flags(regs);
> +	header->misc = perf_misc_flags(event, regs);
>  
>  	/*
>  	 * If you're adding more sample types here, you likely need to do


