Return-Path: <kvm+bounces-32238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E589D463F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 04:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37CB51F22396
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3E01C7299;
	Thu, 21 Nov 2024 03:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSGGDCrR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBF1C1F3A;
	Thu, 21 Nov 2024 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732159770; cv=none; b=H8IyZRk4CgCMC+SfaorM1FW274+h2/MVNv3K3XRGio6Rj0juMvIg313UvrEoCEsXXYMG8877kaFQbl0hL4U774HMWrJqEBynwblcje+VDtH9pH6kxnJjQz3BPiLLajcxokfDf7PXmPZgOmJwDxaXkwJWXEihQN1s2uiYPUneU/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732159770; c=relaxed/simple;
	bh=RHoVzwWXjt4caPv+g3UeTiU+/R+dvmY/yBmiV0cWZE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZuyX5TTs7ftH9qxFDxmQXGFE5xJbBBFysritwKsGU2BlCC+FTS19SzSi8Z8SN4twZDYyq10uXM+EgqsgpDzjedzYtuxRakn012JoxBfaGo/pOVdt/pJJrTeALOEw5y32J/WLBUXUt+ZExQ1Mw9LWazUVmfUbNHXorlCXAFslucA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSGGDCrR; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732159769; x=1763695769;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RHoVzwWXjt4caPv+g3UeTiU+/R+dvmY/yBmiV0cWZE8=;
  b=TSGGDCrRKOqbnKeAo/badN0sl2Say10q6YRj4hOZnpHJOxw3NzTBJc0+
   gx3VPKFNcpLy2ZoRzJSBzfpa585oRswkzzt6sAalyKNtzjCD4Atw3Q/O4
   G8PqC9UK0rhk/yX/qM5x38aIks9d9G1kSaoe38wmnCNgLJHaHKue19SxO
   h2ZXtbd5vs2T8gqcPSHkzmIng3pxDN1+Y8ch3huK/gOt/1+m23yhJNguP
   cSzaPEscdE7XLfLsB6DUfz3i7VIZ2EB55M7dhptNKc+jhLf+JHAFIoCTj
   REQiJCKI6DD03sVngLIcdrRvQQr2Vif946P0eUYbo1yqA95D1EmqUXzIu
   Q==;
X-CSE-ConnectionGUID: hkDmgSuYTmacLSgULGc8cA==
X-CSE-MsgGUID: w7qdJ+JvTfmEEp9ZNvVRlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="31616603"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="31616603"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:29:27 -0800
X-CSE-ConnectionGUID: hDd+q5yrSAKHs8G2FW7PIw==
X-CSE-MsgGUID: Kcrmj1ABRBWlJGGQ//X+oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90516447"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 19:29:23 -0800
Message-ID: <5eac39c5-4e53-457e-b6b1-4101135595ce@linux.intel.com>
Date: Thu, 21 Nov 2024 11:29:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 56/58] KVM: x86/pmu/svm: Wire up PMU filtering
 functionality for passthrough PMU
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
 <20240801045907.4010984-57-mizhang@google.com> <Zz5XEDX8NqnrHhj3@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz5XEDX8NqnrHhj3@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 5:39 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> From: Manali Shukla <manali.shukla@amd.com>
>>
>> With the Passthrough PMU enabled, the PERF_CTLx MSRs (event selectors) are
>> always intercepted and the event filter checking can be directly done
>> inside amd_pmu_set_msr().
>>
>> Add a check to allow writing to event selector for GP counters if and only
>> if the event is allowed in filter.
> This belongs in the patch that adds AMD support for setting pmc->eventsel_hw.
> E.g. reverting just this patch would leave KVM in a very broken state.  And it's
> unnecessarily difficult to review.

Sure. would merge them into one.


>
>> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/svm/pmu.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index 86818da66bbe..9f3e910ee453 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -166,6 +166,15 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  		if (data != pmc->eventsel) {
>>  			pmc->eventsel = data;
>>  			if (is_passthrough_pmu_enabled(vcpu)) {
>> +				if (!check_pmu_event_filter(pmc)) {
>> +					/*
>> +					 * When guest request an invalid event,
>> +					 * stop the counter by clearing the
>> +					 * event selector MSR.
>> +					 */
>> +					pmc->eventsel_hw = 0;
>> +					return 0;
>> +				}
>>  				data &= ~AMD64_EVENTSEL_HOSTONLY;
>>  				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;
>>  			} else {
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

