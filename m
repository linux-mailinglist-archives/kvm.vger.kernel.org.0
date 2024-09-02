Return-Path: <kvm+bounces-25655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C29129680F4
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0006B1C21FA6
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C80185B57;
	Mon,  2 Sep 2024 07:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D21SgXdt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0641842A9E;
	Mon,  2 Sep 2024 07:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725263497; cv=none; b=bAJVsG3QiO7iJZcgNhCxkWv7yVwIy7O4ZN9f39lCDq+9QzVV7wbmXLciRqLerCDTDPBOUmB/x6h0jT0ZZArMzme8+gHBNTZeRjNc+QueUdURX5wD23V96URRw+SYwMt1dHw8fleNEH9M2NiIu6UqJWaUw8jCRYMs0Gi+gPJdYlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725263497; c=relaxed/simple;
	bh=9egc8bzS4xp559knJ0MSFXZijI3tK94YnswRk3BODsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSldp5Hkyojw2nyJZznFzFsci2uRyTN33wJ3uxf5ePpWhryW+LPpgQqWzvf/ykuzrMQEmdxxv22sxxT1ag8OayTB5H4QyLr4ufLzGE1SwCseqXlNL5S612NWYNZVdka8k1BAtPFDLScCS/+g1UPfT/9uySBgzdbW2UBUWRdmJeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D21SgXdt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725263496; x=1756799496;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9egc8bzS4xp559knJ0MSFXZijI3tK94YnswRk3BODsA=;
  b=D21SgXdt3NVlHp8LSgyGV4MdadaBVWFCfTTR1f6kMHyrA4x8cVC20K2A
   /R7WsqD8jccCTUm3SR+aNDQGxRQ2O/5JTGoCNxrQoZThu8GciCBQBVVs3
   SHJu1U8T9q2wY6ut+DwbEhlFAFLPC+Buh1Foh6cyFW32Orrh2TfuSdiFm
   KAt2Foj7ifkcbv5Dxn/GIO3fz2AGiIh9O7oHXHHbBQENzYU+N4MOw6h0H
   E7BT3uyI/tQN+VHT1V1NqvyW0HfE3F7eikfvzVpybBeTnWHo8Yuzjguwj
   FyV5KClvqn5CDPn7rIgkkd3wqTl+ly63uk8XRYqMnin0KbQTmv3p7+w4p
   w==;
X-CSE-ConnectionGUID: gTh6WVzQSv+NaNh4qZ2g1A==
X-CSE-MsgGUID: LehYEzh3S/+Wl2z6IPmehQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="35230525"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="35230525"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:51:35 -0700
X-CSE-ConnectionGUID: SKP+GlhvSjep7rlZSp9g/A==
X-CSE-MsgGUID: S5ESiWwRTvK4Zhvb2Zbavw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="95335117"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.125]) ([10.124.233.125])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:51:30 -0700
Message-ID: <3b82df84-d7cd-4804-864a-253b5de5b5d2@linux.intel.com>
Date: Mon, 2 Sep 2024 15:51:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 30/58] KVM: x86/pmu: Exclude PMU MSRs in
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
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-31-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-31-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> Reject PMU MSRs interception explicitly in
> vmx_get_passthrough_msr_slot() since interception of PMU MSRs are
> specially handled in intel_passthrough_pmu_msrs().
>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 34a420fa98c5..41102658ed21 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -166,7 +166,7 @@ module_param(enable_passthrough_pmu, bool, 0444);
>  
>  /*
>   * List of MSRs that can be directly passed to the guest.
> - * In addition to these x2apic, PT and LBR MSRs are handled specially.
> + * In addition to these x2apic, PMU, PT and LBR MSRs are handled specially.
>   */
>  static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
>  	MSR_IA32_SPEC_CTRL,
> @@ -695,6 +695,13 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> +	case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
> +	case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
> +	case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + 2:

We'd better to use the macro
KVM_MAX_NR_GP_COUNTERS/KVM_MAX_NR_FIXED_COUNTERS to replace these magic number.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d9ccac839b4..68d9c5e7f91e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -696,9 +696,9 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
        case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
        case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
                /* LBR MSRs. These are handled in
vmx_update_intercept_for_lbr_msrs() */
-       case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + 7:
-       case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 + 7:
-       case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + 2:
+       case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + KVM_MAX_NR_GP_COUNTERS - 1:
+       case MSR_IA32_PERFCTR0 ... MSR_IA32_PERFCTR0 +
KVM_MAX_NR_GP_COUNTERS - 1:
+       case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 +
KVM_MAX_NR_FIXED_COUNTERS -1:
        case MSR_CORE_PERF_GLOBAL_STATUS:
        case MSR_CORE_PERF_GLOBAL_CTRL:
        case MSR_CORE_PERF_GLOBAL_OVF_CTRL:


> +	case MSR_CORE_PERF_GLOBAL_STATUS:
> +	case MSR_CORE_PERF_GLOBAL_CTRL:
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		/* PMU MSRs. These are handled in intel_passthrough_pmu_msrs() */
>  		return -ENOENT;
>  	}
>  

