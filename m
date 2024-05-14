Return-Path: <kvm+bounces-17367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04EF58C4D1E
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 09:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D931B227C1
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AD81400A;
	Tue, 14 May 2024 07:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SU+YqhG4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5183D1171D;
	Tue, 14 May 2024 07:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715672096; cv=none; b=t6hHmrMHSj6TKZWXb8PpBA9FkGfaFv8AK8v2M8KxxTZuArRBmHBBN3zHqz68yKT+i/F3NdAD4iGAUdKp1IAkBoKVWSBRIpgNn2lXCN7q8mvTeM3kXYFFB536ZCR8fts1tKSgBlfLbI6AUUdqic2PjisVS1T1+EBWOKK36W1/KwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715672096; c=relaxed/simple;
	bh=TULusMh7T/SdxAZq8HnaEdWoBbssb9f1gBrF4iydUIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AHP2HMg9gXqGi9RtM89xCoGr3kehqNz4+NBaAkAUpHMKaGtypq7D9dMLCbbWdsaRB62m+I5xuNoep9mrNblvnxlhk0mirhxwfro7q24O2NTm00DCJ2t5aXhY9WxdTEoHNi3+vLKOAUIa7gGPZ7D28niyH2btpXU5yVbj0jAJTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SU+YqhG4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715672096; x=1747208096;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TULusMh7T/SdxAZq8HnaEdWoBbssb9f1gBrF4iydUIY=;
  b=SU+YqhG4fJq4ZUbwrWBeXjYYJ4bsC5W1UINIE8j7eYnCRz8rtitofDsB
   aHNneQLu9aG7UFufPs06MSZWYyxYd/b3J6+LqO9So6p6TORz6GuXmXAuL
   xvSesINds2J7RxH4xkdensLW9opixY7qQhlpyVFK0KqCFZ7O7N7ZNhFa+
   PrUjQj7kVK9hkYWbbU8d8AetpfQMvJym20wLFdjjyaPWRZkZnhx/7ytJh
   clGZOCZVLBtmJqHEdHOp7TjbCwgI5w08W6K6MAJvLnX6m277siINTDoNn
   ZDj3ns2aOPCXl8cf7dT04/rwb9+a9G7oeFusH1K1+OJqDsuVLVxUlD3xu
   A==;
X-CSE-ConnectionGUID: +r+bNhgoRHuc78cI8AEzsg==
X-CSE-MsgGUID: I0oM94WpSvOAylbp8+cDtA==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22310152"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="22310152"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 00:34:54 -0700
X-CSE-ConnectionGUID: EVHuThG7S4aiReU+5Lqd2A==
X-CSE-MsgGUID: l6mWBjcDS7ah0BG/vcvIqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30735478"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 00:33:08 -0700
Message-ID: <f1d32929-c189-4c70-ba05-33224bdd5602@linux.intel.com>
Date: Tue, 14 May 2024 15:33:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/54] KVM: x86/pmu: Exclude PMU MSRs in
 vmx_get_passthrough_msr_slot()
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-28-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240506053020.3911940-28-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
> Reject PMU MSRs interception explicitly in
> vmx_get_passthrough_msr_slot() since interception of PMU MSRs are
> specially handled in intel_passthrough_pmu_msrs().
>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9de7d2623b8..62b5913abdd6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -164,7 +164,7 @@ module_param(enable_passthrough_pmu, bool, 0444);
>  
>  /*
>   * List of MSRs that can be directly passed to the guest.
> - * In addition to these x2apic, PT and LBR MSRs are handled specially.
> + * In addition to these x2apic, PMU, PT and LBR MSRs are handled specially.
>   */
>  static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
>  	MSR_IA32_SPEC_CTRL,
> @@ -694,6 +694,13 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> +	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
> +	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
> +	case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + 2:

We'd better use helpers to get the maximum supported GP and fixed counter
instead of magic numbers here. There are more GP and fixed counters in the
future's Intel CPUs.


> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		/* PMU MSRs. These are handled in intel_passthrough_pmu_msrs() */
>  		return -ENOENT;
>  	}
>  

