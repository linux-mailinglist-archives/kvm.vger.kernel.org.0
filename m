Return-Path: <kvm+bounces-32235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CBD9D4625
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 04:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C4A71F21FA2
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4F11AA1D4;
	Thu, 21 Nov 2024 03:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g81Dibme"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A331A3A8F;
	Thu, 21 Nov 2024 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732158908; cv=none; b=E9WGDP0uX/J30x8hM7u5/mX4p56m8cwG/msMX19d4ROWQZlnlBd8WwcKei71NpGt3lfJh6UV4BldCNF/+poI8ZMkXcMXnwup7DvBKkE8+wLYJs7asdlssvVzlhwpGdr+OolfWck78T2b1Ry2jRV4UhAekn112Jt02QyIOv2hcyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732158908; c=relaxed/simple;
	bh=pbZjwKMieNeqaZGkYUAgo1AvnfYaOhmk3UFuJdyhwr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCzAM76rUBFhGH2WxVuOzRPnDwb4Kzy1+BEH1J7EqH2ixhuFcVpRm70D39nW8rl/A7reUi1XNXoHnm6j1NDqxTVcg/qjAv8icajYbpbECGzURhBo/r3LRMuyg8TowgwGF9yD9Il2M42cYgtGk/ygO0qVqRlkwcLWszseK4PGdgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g81Dibme; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732158907; x=1763694907;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pbZjwKMieNeqaZGkYUAgo1AvnfYaOhmk3UFuJdyhwr0=;
  b=g81DibmewrJcVgRrbfMcB+6SiwrZsz3af8C/pwbUFeUCx8ecT9PLgxZ7
   dxA8sfP0H6ZpIyDWHbtDN4OXukRg5mKXj5Sjytu6AbWuRcfhtcIOWpJm9
   JWKItn1+S6rbFMQFTNVIooCx3T2duPpaA5Jz85CTBCFWQbSto9j6pFXDK
   NQRQDxOSULkqBjzmWv2r0UPnHV3v9Uknx8MmS+9OWJAuGanWRcVdMDL7V
   e9LJhCfsxvA3ZZqgmRp87Uk+ikCnTrgQFS55hjbw/d+pQVKhvBHrtE7C9
   OMVZr7B+es4aW68t6heBiPNr8p1AI8n2BuE5aY40qf8mrO6AVl8eKyGRp
   g==;
X-CSE-ConnectionGUID: gH6bl0hxR8670p4rGh0uMg==
X-CSE-MsgGUID: XBC7hLnfRNa/e/NrhhNjTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="43632941"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="43632941"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:15:06 -0800
X-CSE-ConnectionGUID: b5EYXkSRQc2jOZn8bK6mAw==
X-CSE-MsgGUID: NE8pnypKTPWAYkfxVZkqIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="89700462"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:15:01 -0800
Message-ID: <01c6ac96-e15b-4070-8aa0-921ef11daf30@linux.intel.com>
Date: Thu, 21 Nov 2024 11:14:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 47/58] KVM: nVMX: Add nested virtualization support
 for passthrough PMU
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-48-mizhang@google.com> <Zz5MADrxFt_atPph@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5MADrxFt_atPph@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 4:52 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Add nested virtualization support for passthrough PMU by combining the MSR
>> interception bitmaps of vmcs01 and vmcs12. Readers may argue even without
>> this patch, nested virtualization works for passthrough PMU because L1 will
>> see Perfmon v2 and will have to use legacy vPMU implementation if it is
>> Linux. However, any assumption made on L1 may be invalid, e.g., L1 may not
>> even be Linux.
>>
>> If both L0 and L1 pass through PMU MSRs, the correct behavior is to allow
>> MSR access from L2 directly touch HW MSRs, since both L0 and L1 passthrough
>> the access.
>>
>> However, in current implementation, if without adding anything for nested,
>> KVM always set MSR interception bits in vmcs02. This leads to the fact that
>> L0 will emulate all MSR read/writes for L2, leading to errors, since the
>> current passthrough vPMU never implements set_msr() and get_msr() for any
>> counter access except counter accesses from the VMM side.
>>
>> So fix the issue by setting up the correct MSR interception for PMU MSRs.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 52 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 643935a0f70a..ef385f9e7513 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -612,6 +612,55 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
>>  						   msr_bitmap_l0, msr);
>>  }
>>  
>> +/* Pass PMU MSRs to nested VM if L0 and L1 are set to passthrough. */
>> +static void nested_vmx_set_passthru_pmu_intercept_for_msr(struct kvm_vcpu *vcpu,
>> +							  unsigned long *msr_bitmap_l1,
>> +							  unsigned long *msr_bitmap_l0)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +	int i;
>> +
>> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +						 msr_bitmap_l0,
>> +						 MSR_ARCH_PERFMON_EVENTSEL0 + i,
>> +						 MSR_TYPE_RW);
>> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +						 msr_bitmap_l0,
>> +						 MSR_IA32_PERFCTR0 + i,
>> +						 MSR_TYPE_RW);
>> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +						 msr_bitmap_l0,
>> +						 MSR_IA32_PMC0 + i,
>> +						 MSR_TYPE_RW);
> I think we should add (gross) macros to dedup the bulk of this boilerplate, by
> referencing the local variables in the macros.  Like I said, gross.  But I think
> it'd be less error prone and easier to read than the copy+paste mess we have today.
> E.g. it's easy to miss that only writes are allowed for MSR_IA32_FLUSH_CMD and
> MSR_IA32_PRED_CMD, because there's so much boilerplate.
>
> Something like:
>
> #define nested_vmx_merge_msr_bitmaps(msr, type)	\
> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0, msr, type)
>
> #define nested_vmx_merge_msr_bitmaps_read(msr)	\
> 	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_R);
>
> #define nested_vmx_merge_msr_bitmaps_write(msr)	\
> 	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_W);
>
> #define nested_vmx_merge_msr_bitmaps_rw(msr)	\
> 	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW);
>
>
> 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> 		nested_vmx_merge_msr_bitmaps_rw(MSR_ARCH_PERFMON_EVENTSEL0 + i);
> 		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PERFCTR0+ i);
> 		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PMC0+ i);
> 	}
>
> 	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++)
> 		nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR_CTRL);
>
> 	blah blah blah

Sure. Thanks.

>
>> +	}
>> +
>> +	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++) {
> Curly braces are unnecessary.

Sure.


>
>> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +						 msr_bitmap_l0,
>> +						 MSR_CORE_PERF_FIXED_CTR0 + i,
>> +						 MSR_TYPE_RW);
>> +	}
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +					 msr_bitmap_l0,
>> +					 MSR_CORE_PERF_FIXED_CTR_CTRL,
>> +					 MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +					 msr_bitmap_l0,
>> +					 MSR_CORE_PERF_GLOBAL_STATUS,
>> +					 MSR_TYPE_RW);
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +					 msr_bitmap_l0,
>> +					 MSR_CORE_PERF_GLOBAL_CTRL,
>> +					 MSR_TYPE_RW);
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
>> +					 msr_bitmap_l0,
>> +					 MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> +					 MSR_TYPE_RW);
>> +}
>> +
>>  /*
>>   * Merge L0's and L1's MSR bitmap, return false to indicate that
>>   * we do not use the hardware.
>> @@ -713,6 +762,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>  					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>  
>> +	if (is_passthrough_pmu_enabled(vcpu))
>> +		nested_vmx_set_passthru_pmu_intercept_for_msr(vcpu, msr_bitmap_l1, msr_bitmap_l0);
> Please wrap.  Or better yet:
>
> 	nested_vmx_merge_pmu_msr_bitmaps(vmx, msr_bitmap_1, msr_bitmap_l0);
>
> and handle the enable_mediated_pmu check in the helper.

Sure.


>
>> +
>>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>  
>>  	vmx->nested.force_msr_bitmap_recalc = false;
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

