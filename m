Return-Path: <kvm+bounces-32125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A54609D3381
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E3B1F23F68
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 06:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B311581F8;
	Wed, 20 Nov 2024 06:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l8YtV42A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18843F9C5;
	Wed, 20 Nov 2024 06:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732083742; cv=none; b=juWzqfsxqDnL/P0xTgiQCsHOlfcvrIIYZ7o8l0Q8F8+uUJOOXkfHmEK5PHJ4ao2L9oPQ3VLILDF8yDkglYX7W/mGoAZpJTSOtjdwNykgU4X2J6wDec8JrwqfyT82Dsn6K1onQkj13y+hMIwIwfo7ciGeEms0A8PmK+WcCKXWaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732083742; c=relaxed/simple;
	bh=//4SfKNXSxLm1a+oNDhWQoBEcyXsWOeoSXmHbuH9XwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VxeobQHbpCMBSvEW6B3fPCgDMkBlAGoiAg972eTVuHskLXuhspYomCTZs0YonDBVIxda0LWmj87GjX9VWOXtL/7hioxuDaz7VhRsb4ihcmTtN/Z5a7JUuXDUY4xV9r/hIG1FxTrEZXSg2zaauGVKwUxdeMKXMDxi1TEQTZ0hwz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l8YtV42A; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732083740; x=1763619740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=//4SfKNXSxLm1a+oNDhWQoBEcyXsWOeoSXmHbuH9XwE=;
  b=l8YtV42AVKeAOtqkiNbKSlAbU/0kNezfPm5soCxJhZDV2lMjAjUFh2fC
   ejILqIvf3FbUxYdtorslD20QuZ3VPdKh1q9YPa0A/X/xEWSEUs83KuSes
   UfOM+eXxk1KOvlQvkYcnkJn6Q9bOGdJ6nNIjup1xZd9bWIOY8sCGQxiOD
   kqBnGOCwTb4mtOfSlKDp1TkO9MUlqDpBWApSMVV1yoQnAML1U2pwBXHya
   4NczjT5ABQCQSYAjXdOhV0qXKtxclCugH5OZ9GddlvdU84L2nC11Ah0JQ
   LHwLtANY5Y96va2VmIw28ZGN3vQMhi8K5lX10d7cUBnobM8N4wpyGpoOr
   A==;
X-CSE-ConnectionGUID: cBy3BpSPQSe5eKWE08X2PA==
X-CSE-MsgGUID: R3gTtLKCROySaJV/ODB1iA==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32372802"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32372802"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 22:22:20 -0800
X-CSE-ConnectionGUID: SoJElIlvRFWWojTn4u3oSA==
X-CSE-MsgGUID: N/1VDQK6RBqV2JwHp2w1kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89614254"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 22:22:15 -0800
Message-ID: <183c290f-d22f-43e4-a1ba-f854774b1b74@linux.intel.com>
Date: Wed, 20 Nov 2024 14:22:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 25/58] KVM: x86/pmu: Introduce PMU operator to
 check if rdpmc passthrough allowed
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
 <20240801045907.4010984-26-mizhang@google.com> <ZzzLsLE-BmzVAXF0@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzLsLE-BmzVAXF0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 1:32 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Introduce a vendor specific API to check if rdpmc passthrough allowed.
>> RDPMC passthrough requires guest VM have the full ownership of all
>> counters. These include general purpose counters and fixed counters and
>> some vendor specific MSRs such as PERF_METRICS. Since PERF_METRICS MSR is
>> Intel specific, putting the check into vendor specific code.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> ---
>>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
>>  arch/x86/kvm/pmu.c                     |  1 +
>>  arch/x86/kvm/pmu.h                     |  1 +
>>  arch/x86/kvm/svm/pmu.c                 |  6 ++++++
>>  arch/x86/kvm/vmx/pmu_intel.c           | 16 ++++++++++++++++
>>  5 files changed, 25 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> index f852b13aeefe..fd986d5146e4 100644
>> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> @@ -20,6 +20,7 @@ KVM_X86_PMU_OP(get_msr)
>>  KVM_X86_PMU_OP(set_msr)
>>  KVM_X86_PMU_OP(refresh)
>>  KVM_X86_PMU_OP(init)
>> +KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
>>  KVM_X86_PMU_OP_OPTIONAL(reset)
>>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 19104e16a986..3afefe4cf6e2 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -102,6 +102,7 @@ bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu)
>>  
>>  	if (is_passthrough_pmu_enabled(vcpu) &&
>>  	    !enable_vmware_backdoor &&
>> +	    static_call(kvm_x86_pmu_is_rdpmc_passthru_allowed)(vcpu) &&
> If the polarity is inverted, the callback can be OPTIONAL_RET0 on AMD.  E.g.
>
> 	if (kvm_pmu_call(rdpmc_needs_intercept(vcpu)))
> 		return false;
>
>> +static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * Per Intel SDM vol. 2 for RDPMC, 
>
> Please don't reference specific sections in the comments.  For changelogs it's
> ok, because changelogs are a snapshot in time.  But comments are living things
> and will become stale in almost every case.  And I don't see any reason to reference
> the SDM, just state the behavior; it's implied that that's the architectural
> behavior, otherwise KVM is buggy.
>
>> MSR_PERF_METRICS is accessible by
> This is technically wrong, the SDM states that the RDPMC behavior is implementation
> specific.  That matters to some extent, because if it was _just_ one MSR and was
> guaranteed to always be that one MSR, it might be worth creating a virtualization
> hole.
>
> 	/*
> 	 * Intercept RDPMC if the host supports PERF_METRICS, but the guest
> 	 * does not, as RDPMC with type 0x2000 accesses implementation specific
> 	 * metrics.
> 	 */
>
>
> All that said, isn't this redundant with the number of fixed counters?  I'm having
> a hell of a time finding anything concrete in the SDM, but IIUC fixed counter 3
> is tightly coupled to perf metrics.  E.g. rather than add a vendor hook just for
> this, rely on the fixed counters and refuse to enable the mediated PMU if the
> underlying CPU model is nonsensical, i.e. perf metrics exists without ctr3.
>
> And I kinda think we have to go that route, because enabling RDPMC interception
> based on future features is doomed from the start.  E.g. if this code had been
> written prior to PERF_METRICS, older KVMs would have zero clue that RDPMC needs
> to be intercepted on newer hardware.

Yeah, this sounds make sense. Fixed counter 3 and PERF_METRICS are always
coupled as a whole, and the previous code has already checked the fixed
counter bitmap. I think we can drop this patch and just add a comment to
explain the reason.



