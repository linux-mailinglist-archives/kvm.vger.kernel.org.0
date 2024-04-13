Return-Path: <kvm+bounces-14589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D458A3A90
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 05:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A05DD2849F1
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E8818AED;
	Sat, 13 Apr 2024 03:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNzkiFql"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DAC746E;
	Sat, 13 Apr 2024 03:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712977433; cv=none; b=hYs+KI7brimClfSTkhjCPnlnG0BoIcxqXd/EBjT6FfR35Btwkta3IlnbEJo0jkjaCQXggE3A5IO9cLoPyKiavAgknFyVn4ecXvewpJhFqH55hCJ/IjG5EHsvGGR4QGQjJbveyrchmDNZsXSYWOIMEpFJ3DK7e3zDoCOtGWxjUNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712977433; c=relaxed/simple;
	bh=d8Wds4LD+CAanA9YbrNPMmtQW7eczQtHmQs8plsr3H8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RB0lwjiu/lAYDYfgAUzdiHKsoqj/yRnRZJQnBFVzl/9MNZp3S3YLnKhG9Pmce5Z+fjNz1EOgte79s4zMb4/7/oZxNscp9XJFw7N1ZdJnwmiOCG+lEVwdOW11Iyx4EX30gc2EbY8Vc8/DZKQEBDGahVqlKwxf6IpSqvwct4QW1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNzkiFql; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712977431; x=1744513431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d8Wds4LD+CAanA9YbrNPMmtQW7eczQtHmQs8plsr3H8=;
  b=SNzkiFql+UTqmt8oeLWNQtnV2zBh09/bpyZcx2FZRyiKDLrPzUpWCK/T
   sAyrKcmpDOzgwSdALBTUeFutF8AMocjBew3acwCMoLehC0sn/7gDjd5fe
   oI8r1Bmkhpw9c/W2VYTCsIF9d5PMiOS5+G5ukYtY96KQxa0ewy67/jmjW
   NNNkBRgdmnn4k97hBLJLrNNBqul6yGTkn3fd7rJ4JET30W9O58pVVibqP
   hlmiwjglH5CaQ9hFc260ojnQ6jPuPhLfsAaseAnapt9uuQNBiwnJRBnHb
   adtFnW+fTcguC/oGLJfNBsHRuLXaMDaopS4DxRKPEhkY7mvxiqbjQRZMQ
   w==;
X-CSE-ConnectionGUID: fzD9IBGQQjq7eLGvzvuLZg==
X-CSE-MsgGUID: 4QAYbViPQGe8xHDbDb3Z4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8303366"
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="8303366"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:03:51 -0700
X-CSE-ConnectionGUID: N+Ty/tYrRTypkp7E+ya9MQ==
X-CSE-MsgGUID: bwiCov8+QuSgdtJYjwSPRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="25961559"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:03:47 -0700
Message-ID: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
Date: Sat, 13 Apr 2024 11:03:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZhhZush_VOEnimuw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/12/2024 5:44 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>
>> Implement the save/restore of PMU state for pasthrough PMU in Intel. In
>> passthrough mode, KVM owns exclusively the PMU HW when control flow goes to
>> the scope of passthrough PMU. Thus, KVM needs to save the host PMU state
>> and gains the full HW PMU ownership. On the contrary, host regains the
>> ownership of PMU HW from KVM when control flow leaves the scope of
>> passthrough PMU.
>>
>> Implement PMU context switches for Intel CPUs and opptunistically use
>> rdpmcl() instead of rdmsrl() when reading counters since the former has
>> lower latency in Intel CPUs.
>>
>> Co-developed-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 73 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 73 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 0d58fe7d243e..f79bebe7093d 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -823,10 +823,83 @@ void intel_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>>   
>>   static void intel_save_pmu_context(struct kvm_vcpu *vcpu)
> I would prefer there be a "guest" in there somewhere, e.g. intel_save_guest_pmu_context().
Yeah. It looks clearer.
>
>>   {
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct kvm_pmc *pmc;
>> +	u32 i;
>> +
>> +	if (pmu->version != 2) {
>> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
>> +		return;
>> +	}
>> +
>> +	/* Global ctrl register is already saved at VM-exit. */
>> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
>> +	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
>> +	if (pmu->global_status)
>> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, pmu->global_status);
>> +
>> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>> +		pmc = &pmu->gp_counters[i];
>> +		rdpmcl(i, pmc->counter);
>> +		rdmsrl(i + MSR_ARCH_PERFMON_EVENTSEL0, pmc->eventsel);
>> +		/*
>> +		 * Clear hardware PERFMON_EVENTSELx and its counter to avoid
>> +		 * leakage and also avoid this guest GP counter get accidentally
>> +		 * enabled during host running when host enable global ctrl.
>> +		 */
>> +		if (pmc->eventsel)
>> +			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
>> +		if (pmc->counter)
>> +			wrmsrl(MSR_IA32_PMC0 + i, 0);
> This doesn't make much sense.  The kernel already has full access to the guest,
> I don't see what is gained by zeroing out the MSRs just to hide them from perf.

It's necessary to clear the EVENTSELx MSRs for both GP and fixed 
counters. Considering this case, Guest uses GP counter 2, but Host 
doesn't use it. So if the EVENTSEL2 MSR is not cleared here, the GP 
counter 2 would be enabled unexpectedly on host later since Host perf 
always enable all validate bits in PERF_GLOBAL_CTRL MSR. That would 
cause issues.

Yeah,  the clearing for PMCx MSR should be unnecessary .


>
> Similarly, if perf enables a counter if PERF_GLOBAL_CTRL without first restoring
> the event selector, we gots problems.
>
> Same thing for the fixed counters below.  Can't this just be?
>
> 	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
> 		rdpmcl(i, pmu->gp_counters[i].counter);
>
> 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> 		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i,
> 		       pmu->fixed_counters[i].counter);
>
>> +	}
>> +
>> +	rdmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>> +	/*
>> +	 * Clear hardware FIXED_CTR_CTRL MSR to avoid information leakage and
>> +	 * also avoid these guest fixed counters get accidentially enabled
>> +	 * during host running when host enable global ctrl.
>> +	 */
>> +	if (pmu->fixed_ctr_ctrl)
>> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +		pmc = &pmu->fixed_counters[i];
>> +		rdpmcl(INTEL_PMC_FIXED_RDPMC_BASE | i, pmc->counter);
>> +		if (pmc->counter)
>> +			wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>> +	}
>>   }
>>   
>>   static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>>   {
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct kvm_pmc *pmc;
>> +	u64 global_status;
>> +	int i;
>> +
>> +	if (pmu->version != 2) {
>> +		pr_warn("only PerfMon v2 is supported for passthrough PMU");
>> +		return;
>> +	}
>> +
>> +	/* Clear host global_ctrl and global_status MSR if non-zero. */
>> +	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now?

As previous comments say, host perf always enable all counters in 
PERF_GLOBAL_CTRL by default. The reason to clear PERF_GLOBAL_CTRL here 
is to ensure all counters in disabled state and the later counter 
manipulation (writing MSR) won't cause any race condition or unexpected 
behavior on HW.


>
>> +	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
>> +	if (global_status)
>> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
> This seems especially silly, isn't the full MSR being written below?  Or am I
> misunderstanding how these things work?

I think Jim's comment has already explain why we need to do this.

>
>> +	wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
>> +
>> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>> +		pmc = &pmu->gp_counters[i];
>> +		wrmsrl(MSR_IA32_PMC0 + i, pmc->counter);
>> +		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
>> +	}
>> +
>> +	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
>> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +		pmc = &pmu->fixed_counters[i];
>> +		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
>> +	}
>>   }
>>   
>>   struct kvm_pmu_ops intel_pmu_ops __initdata = {
>> -- 
>> 2.34.1
>>

