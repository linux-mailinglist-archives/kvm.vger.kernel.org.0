Return-Path: <kvm+bounces-29918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 401189B40BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A569BB21A45
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6C61FCF49;
	Tue, 29 Oct 2024 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5VlXwzk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B8B149C4F;
	Tue, 29 Oct 2024 03:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730170973; cv=none; b=Yp4oT06r3hpBnfguctUXYxOZ1um6DohYf8mnAzFNfY5u0I+/mnFdnSNtJ4aPIpV0v7SeYJ4cL9i/Ol/adstsZMWQNAiCnnZJrOYUT1OXuWdUjl1Y4mHckuW5gW+nZN6q8GkvvDjL2i/hZwm7AIo4vNW1aH2eeNj4XouFffqzagk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730170973; c=relaxed/simple;
	bh=YJirQKrSE6yxS55nJowHms/VDNWK13GiMmuZEuD9SnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YwoB6oGv437csV4wNi+NXgaVYeQoYDFDnDcW/syy0u3j3D+iDY4Euzuw0tXs9VeYQeB7S7xOl0f31veJCOUTJXsi4L0xGoHHnIj4dStC7mkm+FpVBpWbgDZZb6rjVR4OiTcCA+8jiay1sfcDvKH/Gu2qPI6dAN9TFOa8jm3gv4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l5VlXwzk; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730170971; x=1761706971;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YJirQKrSE6yxS55nJowHms/VDNWK13GiMmuZEuD9SnQ=;
  b=l5VlXwzkBhRatUzpiJnnKg+c0Y/H21PZxvwcFDYMW4IK69Bx9vmrV+nN
   OXTTpFfncgIuVrVdBBKcZ/e6pc1mHou+Bmyytn0Hyp4Kzc7SlVIR+vj1X
   YFj010ZQA4ytUSbivBfRxfgrZ9bZePQc3c9WYpXgaegnC5rOTZHVCPkdY
   JuAz5cIGbhDu7azRsyiglInTfaIuk7YVIcCnVCgGa+BkvoygHn6luDeKC
   qp1r7VrE/WzN/OwaMnYHIVv9KMerfgavRFXlE/mDAOJL3nHLbONqdSkj+
   6PYIuCoCYO8UmkbeXQRflIUjn46KHd+NrObQKgGKhu44v8EhiuzyrTK0z
   w==;
X-CSE-ConnectionGUID: 5JxL2fBtRFmAJtoRJwK8Rw==
X-CSE-MsgGUID: wUpqbguxSMm5pOmgWOVwiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47255576"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47255576"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 20:02:50 -0700
X-CSE-ConnectionGUID: wW+3HsnpRHeswz3V7zRU2w==
X-CSE-MsgGUID: zcvFjNC5Tj+aNRVtubgFPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="81906246"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 20:02:46 -0700
Message-ID: <b015fb9c-4595-49a9-afde-ef01a45e15d1@intel.com>
Date: Tue, 29 Oct 2024 11:02:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-10-nikunj@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241028053431.3439593-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
> Calibrating the TSC frequency using the kvmclock is not correct for
> SecureTSC enabled guests. Use the platform provided TSC frequency via the
> GUEST_TSC_FREQ MSR (C001_0134h).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/include/asm/sev.h |  2 ++
>   arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>   arch/x86/kernel/tsc.c      |  5 +++++
>   3 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index d27c4e0f9f57..9ee63ddd0d90 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>   }
>   
>   void __init snp_secure_tsc_prepare(void);
> +void __init snp_secure_tsc_init(void);
>   
>   #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>   
> @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>   				       u32 resp_sz) { return -ENODEV; }
>   
>   static inline void __init snp_secure_tsc_prepare(void) { }
> +static inline void __init snp_secure_tsc_init(void) { }
>   
>   #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>   
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 140759fafe0c..0be9496b8dea 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3064,3 +3064,19 @@ void __init snp_secure_tsc_prepare(void)
>   
>   	pr_debug("SecureTSC enabled");
>   }
> +
> +static unsigned long securetsc_get_tsc_khz(void)
> +{
> +	unsigned long long tsc_freq_mhz;
> +
> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
> +
> +	return (unsigned long)(tsc_freq_mhz * 1000);
> +}
> +
> +void __init snp_secure_tsc_init(void)
> +{
> +	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
> +	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
> +}
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index dfe6847fd99e..730cbbd4554e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -30,6 +30,7 @@
>   #include <asm/i8259.h>
>   #include <asm/topology.h>
>   #include <asm/uv/uv.h>
> +#include <asm/sev.h>
>   
>   unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>   EXPORT_SYMBOL(cpu_khz);
> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>   	/* Don't change UV TSC multi-chassis synchronization */
>   	if (is_early_uv_system())
>   		return;
> +
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		snp_secure_tsc_init();

IMHO, it isn't the good place to call snp_secure_tsc_init() to update 
the callbacks here.

It's better to be called in some snp init functions.

>   	if (!determine_cpu_tsc_frequencies(true))
>   		return;
>   	tsc_enable_sched_clock();


