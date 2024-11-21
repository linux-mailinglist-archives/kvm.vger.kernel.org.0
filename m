Return-Path: <kvm+bounces-32237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DC09D463C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 04:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64CF1281685
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B98A1B5325;
	Thu, 21 Nov 2024 03:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAtoUlWI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23D13C81B;
	Thu, 21 Nov 2024 03:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159589; cv=none; b=R34cXc1U0VYykxrkMh/s5DuuKxqIdTtp0zk5bCQPEYGp0pZ+efOwaD0Xwlu1anxWfUPITPW+B+hUHNfRpZAKPaslxaaM3VAXAnHtZnA3/zuyRpYhYUrWvDQ85aOZeim6SYL7bW8j7H6IM3dxt9sJSV+bwZ46Yhp2alLjHTrDjdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159589; c=relaxed/simple;
	bh=WHPaEuyDttt0Nc221x4V3sdLjlAdVv8Jizfbsnw3LH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U33PeUv6zeFupoHkdRsjD4ZVeQJBoGmWEsmuoUp+dMDVdWOFL4LecNjCIEwKq2id5mZLmYE2dFLzYIFn6KO+A3vjpnG68hHO70DeoHeCd8qBJ4PfpNpA5GYv9KC20eEyWik0R0ywQ3i9n5JsdH5VEII1LKPU3CBMRvMmhSv8OLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fAtoUlWI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732159589; x=1763695589;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WHPaEuyDttt0Nc221x4V3sdLjlAdVv8Jizfbsnw3LH0=;
  b=fAtoUlWIURTxR7YwT0dHvW5Jthw+mmnlEXMg9EkNLTOAzSFr+xRofCwf
   bjtvSc7rJb3RGH6VmC/ypeQFz8taU9gW6LVucvf9CBmHfxaKvmymQxXk/
   qgzVZXxUvUGksglT13gtxjJ8R03G3u/vqbHtONT0h4kvCZtYyMyBvFUMM
   cdIDO1PYbcV5d6zs4as4770moVDqqjJJgcrb8lSFtiNj8UcW9vlTtQZJ2
   e8VVjceUh/aorzuXvFSU9eF3igqEwzOkaphf0/6pesBsFHrC+2n4pUeRs
   KfdModD8ecH02E//JroQ3s5X/wTHvQxoAhuCAVGxEz+Qj/Qs0MAVHWbGh
   w==;
X-CSE-ConnectionGUID: PXltJssXS+63G2UNqjnx7Q==
X-CSE-MsgGUID: XE8DKrQCRDKDOKZPZ2qqmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="42759471"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="42759471"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:26:28 -0800
X-CSE-ConnectionGUID: 7lcOi7P4SzGqHGgURyGiIg==
X-CSE-MsgGUID: PUMzpbVeRbOqk07eQ/OW7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90518147"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:26:23 -0800
Message-ID: <88516542-9362-462c-a28d-bcf100da970a@linux.intel.com>
Date: Thu, 21 Nov 2024 11:26:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 53/58] KVM: x86/pmu/svm: Set GuestOnly bit and
 clear HostOnly bit when guest write to event selectors
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
 <20240801045907.4010984-54-mizhang@google.com> <Zz5WuqMBdDtZfJBq@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5WuqMBdDtZfJBq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 5:38 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> From: Sandipan Das <sandipan.das@amd.com>
>>
>> On AMD platforms, there is no way to restore PerfCntrGlobalCtl at
>> VM-Entry or clear it at VM-Exit. Since the register states will be
>> restored before entering and saved after exiting guest context, the
>> counters can keep ticking and even overflow leading to chaos while
>> still in host context.
>>
>> To avoid this, the PERF_CTLx MSRs (event selectors) are always
>> intercepted. KVM will always set the GuestOnly bit and clear the
>> HostOnly bit so that the counters run only in guest context even if
>> their enable bits are set. Intercepting these MSRs is also necessary
>> for guest event filtering.
>>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/svm/pmu.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index cc03c3e9941f..2b7cc7616162 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -165,7 +165,12 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		data &= ~pmu->reserved_bits;
>>  		if (data != pmc->eventsel) {
>>  			pmc->eventsel = data;
>> -			kvm_pmu_request_counter_reprogram(pmc);
>> +			if (is_passthrough_pmu_enabled(vcpu)) {
>> +				data &= ~AMD64_EVENTSEL_HOSTONLY;
>> +				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;
> Do both in a single statment, i.e.
>
> 				pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
> 						   AMD64_EVENTSEL_GUESTONLY;
>
> Though per my earlier comments, this likely needs to end up in reprogram_counter().

It looks we need to add a PMU callback and call it from reprogram_counter().


>
>> +			} else {
>> +				kvm_pmu_request_counter_reprogram(pmc);
>> +			}
>>  		}
>>  		return 0;
>>  	}
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

