Return-Path: <kvm+bounces-48796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF1BAD2E89
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 09:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 344867A7ED4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 07:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8877227AC56;
	Tue, 10 Jun 2025 07:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkwY/J2c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0B31F874F;
	Tue, 10 Jun 2025 07:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749540165; cv=none; b=gJqgwM3SkBsKBKToNpC9BcTTYeADM4t7IhFxulihtmIRnRzSHv+9Di/exBDDMPK5moHDO+qF1yp+0JXdWgmf/MgS8mj7aqgiRKhe/5LQijDtzBIgFGAKuaLdgeIZlFv50KD1daFlZ2GwjeNeyv46264B39aZ3+dc0Fh8Roxk5SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749540165; c=relaxed/simple;
	bh=RNhwcUFQqmkSVPbYtaCqDacVJjQ0PSUeZTxQ8gxIzvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IeD7g3kYY9OvVDHnBTZ2H/yF+63XCjGZiRt/x08dMixyYywmWZQhe1yzP4bYY2ILLoG4OjvLEhjDmY9NzeYrW0qaKpFyYzMJGMuSbQ31ru26EHQAUowmLjLdvgLLyUtayq6UNU5d/cupZYvZOWiVEFYoQRxjBxevAVhEXFXBdG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkwY/J2c; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749540164; x=1781076164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RNhwcUFQqmkSVPbYtaCqDacVJjQ0PSUeZTxQ8gxIzvY=;
  b=DkwY/J2cb8YKp3nXIKJAMMBGhJsIg7M8YPI97GyjVm8dJpJ9qN5prEXj
   Ua7hBPddDlsYrrbbXzqyGCBaWnEh31ukYXqfVJWWKH3ybEEk01o4F4eoQ
   UA6K+bMBpChaxM7Jee5YT+aKC7y8L8J102jeQ78Ahd/LvY9njhRxFc4NI
   zKapC52jT8R5rTjD05n24M5StiLn4qQ22Powd4IlSJmFo4eqDBU1C9ywK
   skOGM/aM7NxQaTd8xnxqrQLq7yNO/2RG5563bQdnBQ/TT+fJADTG+HD0Q
   njDKPhBzMgWhI/rLtySQ7ybWFre/NhdSKTt0DRq3tgYW0ABD7/hKznprn
   w==;
X-CSE-ConnectionGUID: psfzAxF5Tr2MuhLiZIXdFw==
X-CSE-MsgGUID: McMyaCwiT1CrhuqbKsUhgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="62249557"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="62249557"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:22:43 -0700
X-CSE-ConnectionGUID: AmQEKyYSQIWl7oY9hwpvqQ==
X-CSE-MsgGUID: IbFCF7mgQZW1Hj0QR7GqWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="151559407"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:22:41 -0700
Message-ID: <303a9aaa-eb52-47b2-af05-32df320dc52b@linux.intel.com>
Date: Tue, 10 Jun 2025 15:22:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 08/16] x86/pmu: Rename
 gp_counter_mask_length to arch_event_mask_length
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-9-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529221929.3807680-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> Rename gp_counter_mask_length to arch_event_mask_length to reflect what
> the field actually tracks.  The availablity of architectural events has
> nothing to do with the GP counters themselves.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/pmu.c | 4 ++--
>  lib/x86/pmu.h | 2 +-
>  x86/pmu.c     | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index 599168ac..b97e2c4a 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -18,7 +18,7 @@ void pmu_init(void)
>  
>  		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>  		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>  
>  		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
>  		pmu.arch_event_available = ~cpuid_10.b;

Better to change to "pmu.arch_event_available = ~cpuid_10.b &
(BIT(pmu.arch_event_mask_length) - 1)" to follow SDM. Some newly introduced
architectural events like topdown metrics events doesn't exist on older
platforms.


> @@ -50,7 +50,7 @@ void pmu_init(void)
>  			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
>  		}
>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
> -		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> +		pmu.arch_event_mask_length = pmu.nr_gp_counters;
>  		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
>  
>  		if (this_cpu_has_perf_global_status()) {
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index d0ad280a..c7dc68c1 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -63,7 +63,7 @@ struct pmu_caps {
>  	u8 fixed_counter_width;
>  	u8 nr_gp_counters;
>  	u8 gp_counter_width;
> -	u8 gp_counter_mask_length;
> +	u8 arch_event_mask_length;
>  	u32 arch_event_available;
>  	u32 msr_gp_counter_base;
>  	u32 msr_gp_event_select_base;
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 0ce34433..63eae3db 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -992,7 +992,7 @@ int main(int ac, char **av)
>  	printf("PMU version:         %d\n", pmu.version);
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>  	printf("GP counter width:    %d\n", pmu.gp_counter_width);
> -	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
> +	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
>  	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>  	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>  

