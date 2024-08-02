Return-Path: <kvm+bounces-23086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1E09462BB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48703281546
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A98A15C124;
	Fri,  2 Aug 2024 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jC4vdo5F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E481AE04D;
	Fri,  2 Aug 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722621011; cv=none; b=S/OP2cGx8XNmqIkKj2Vomrx/yDUb5a6WFCs/d050GQ2ACNnEJzDEL1xOoQhxE6UD7ZrNoY1itJ5SStuWQbVH6Hf1LVS2RKdK3tzSZsZIX0qGJs6K+rySPMweOdBCwK2nV71XQ0nJoVOfg4G+WuJnqG/LLvMlH4bneCtp0vsDJMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722621011; c=relaxed/simple;
	bh=pi0WBPEKZORhPGpalxFXoH/Fl7HCDj8HjJmjz2dzl4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tufiREiIzVGixN4NlyuWyPVO5G+r7H2Y3l5rUqp1sYExk7iMjFfHabOMhK9cNVLToaiTMltpsrTuyyyYC9626cRZb5lTfmjBIZJS2l4U456pJ16Rf0SdsKKwEa7sGMX6whflYmmXMBYkGYPM22vZ5tJh4Q/IjQaLOtW09JCB260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jC4vdo5F; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722621010; x=1754157010;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pi0WBPEKZORhPGpalxFXoH/Fl7HCDj8HjJmjz2dzl4Q=;
  b=jC4vdo5F0yj3ccHka5w8rhu10TRn1puFLTUohVTKIQwm6pNPo19iSRsT
   28SVIQANXSvOKk4H0R+dlralvE/PSE6BLIkgIER5AMdVALEMFZUvNVmIp
   /kWB5Z8pbtQfcJ3QLwbytEg1Ey56ougTmeQ1PE9aPSqM0IMj4uHLcJ0b7
   ZEBliWG9fS4pkcZgpzj9cQw/0exXShRKz7v/Nf5/hzBdOTbuYiikiuYST
   4jHUBZj5Sxg8IhonQq7x9/m5byozc+jmmPcZ8vQyPnlxCgEkkVKNMEW6d
   mD278n1TgaYd0bacZehNYJ/rrFSJqh357W7AwY4Blyx5l1ZKkzPGhUksJ
   g==;
X-CSE-ConnectionGUID: P7/kYRe2QDC8U7J0kcU/rg==
X-CSE-MsgGUID: yeeGyY+tSpuTqZx5jqG14g==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="31802696"
X-IronPort-AV: E=Sophos;i="6.09,258,1716274800"; 
   d="scan'208";a="31802696"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 10:50:09 -0700
X-CSE-ConnectionGUID: PgrMqxhaTRK9TXR5dvKYEA==
X-CSE-MsgGUID: 7y7qpY1iTCSQRGYm7ZqZaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,258,1716274800"; 
   d="scan'208";a="55391042"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 10:50:09 -0700
Received: from [10.212.17.69] (kliang2-mobl1.ccr.corp.intel.com [10.212.17.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 435D520B5782;
	Fri,  2 Aug 2024 10:50:06 -0700 (PDT)
Message-ID: <c34c0726-8795-4431-80a7-7251137ec941@linux.intel.com>
Date: Fri, 2 Aug 2024 13:50:05 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 48/58] perf/x86/intel: Support
 PERF_PMU_CAP_PASSTHROUGH_VPMU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-49-mizhang@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240801045907.4010984-49-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-08-01 12:58 a.m., Mingwei Zhang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> Apply the PERF_PMU_CAP_PASSTHROUGH_VPMU for Intel core PMU. It only
> indicates that the perf side of core PMU is ready to support the
> passthrough vPMU.  Besides the capability, the hypervisor should still need
> to check the PMU version and other capabilities to decide whether to enable
> the passthrough vPMU.
> 
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/events/intel/core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 38c1b1f1deaa..d5bb7d4ed062 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -4743,6 +4743,8 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
>  	else
>  		pmu->pmu.capabilities &= ~PERF_PMU_CAP_AUX_OUTPUT;
>  
> +	pmu->pmu.capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
> +

Because of the simplification in patch 14, there is only one PASSTHROUGH
vPMU supported on a machine. The flag has to be moved for the hybrid
PMUs. Otherwise, the hybrid PMUs would not be registered even in the
bare metal.

>  	intel_pmu_check_event_constraints(pmu->event_constraints,
>  					  pmu->num_counters,
>  					  pmu->num_counters_fixed,
> @@ -6235,6 +6237,9 @@ __init int intel_pmu_init(void)
>  			pr_cont(" AnyThread deprecated, ");
>  	}
>  
> +	/* The perf side of core PMU is ready to support the passthrough vPMU. */
> +	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_PASSTHROUGH_VPMU;
> +

It's good enough to only set the flag here.

Thanks,
Kan

>  	/*
>  	 * Install the hw-cache-events table:
>  	 */

