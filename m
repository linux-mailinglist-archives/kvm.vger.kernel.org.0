Return-Path: <kvm+bounces-32227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7C69D44F5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 01:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DCF2B21416
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75C87080D;
	Thu, 21 Nov 2024 00:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z44iOJYq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5307A5695;
	Thu, 21 Nov 2024 00:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732149452; cv=none; b=dB+cVFNAlUO9Zzuzt0FD0mB+MExyjYp4QWe/M6Mvc3XexHKt20Vdq4wWa9ILEVr0MAcNIq7vyyij+6jI9rF6Yv+z+L3bG/IWCr5w2MAwVZ67aFmGQwQEMl6dpmoKXVwxpXqoz0dGV/L2xtVL+AlAsEdAuHS4d+l9ZI6ixjPLoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732149452; c=relaxed/simple;
	bh=C2zlLAlJ+VEIVk1W1QZj6tkfITBwAi6nLVdxcLHmMw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W506rt+01HyiQK0mG53l/sk0mPeaVbthFW6JtgoKNUaePtS2+b8+VKeN3bzOliidNG/MJ0BSD8pUZHHwTmJjyAIgVfeG1D9+5sAJ6pwJh/e9Tw4hGevxbUlXwez5NCIo2zZdh31CuKfU//g67LWcY0A7BOBd2au8B1vv1/Srd9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z44iOJYq; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732149451; x=1763685451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C2zlLAlJ+VEIVk1W1QZj6tkfITBwAi6nLVdxcLHmMw4=;
  b=Z44iOJYqIUIEdirTlliLDJTZeK4EfQwK0c445YGCPxB6D55OnELHC7DG
   pQzZKtXlVmDSuISGX5emJS2Y3CobS1KOMjGXqREvFoOxv6bszTNXMbE6A
   vj8GAaTQvCP5Ig1DxTRmscoskxDmZTWvKRfiquNRR1F9KdjS2TpyqUMHY
   mEt9FjPnMLEEVpE3KXNm8v4xRQFMB6bTV9/oO6vjry16Psx7HriXqRxLL
   0BL92RXwGm1lOXFsPlL8U/g3B/yC1yQC9SBhSUOckbqYbIYg7m5kE9zoy
   8GLcvnt7lGqF1BVT1jQAhF7Hnkd4cKI77KJfgJD1a1fuvo9LQTUgIflpq
   A==;
X-CSE-ConnectionGUID: sXX5Jp6QTqepchg9My8+gw==
X-CSE-MsgGUID: KGehntXdTBaA9SDCK4GBtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32390265"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32390265"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:37:31 -0800
X-CSE-ConnectionGUID: 2zykJIYVSom+eqYFU6vSug==
X-CSE-MsgGUID: sFkCgBEKT3CpOYfIQ5Elqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90070326"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:37:26 -0800
Message-ID: <655f1869-2769-429d-8952-01ad04e74f2e@linux.intel.com>
Date: Thu, 21 Nov 2024 08:37:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 20/58] KVM: x86/pmu: Always set global enable bits
 in passthrough mode
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
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
 <20240801045907.4010984-21-mizhang@google.com> <Zzyw1UyapXDNpc-c@google.com>
 <b08075d5-1190-44f7-bccc-04f3273c13f3@linux.intel.com>
 <Zz4XsR6v2PKb-yvX@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4XsR6v2PKb-yvX@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 1:09 AM, Sean Christopherson wrote:
> On Wed, Nov 20, 2024, Dapeng Mi wrote:
>> On 11/19/2024 11:37 PM, Sean Christopherson wrote:
>>>> ---
>>>>  arch/x86/kvm/pmu.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>>> index 5768ea2935e9..e656f72fdace 100644
>>>> --- a/arch/x86/kvm/pmu.c
>>>> +++ b/arch/x86/kvm/pmu.c
>>>> @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>  	 * in the global controls).  Emulate that behavior when refreshing the
>>>>  	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>>>>  	 */
>>>> -	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
>>>> +	if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)
>>>>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>>> This is wrong and confusing.  From the guest's perspective, and therefore from
>>> host userspace's perspective, PERF_GLOBAL_CTRL does not exist.  Therefore, the
>>> value that is tracked for the guest must be '0'.
>>>
>>> I see that intel_passthrough_pmu_msrs() and amd_passthrough_pmu_msrs() intercept
>>> accesses to PERF_GLOBAL_CTRL if "pmu->version > 1" (which, by the by, needs to be
>>> kvm_pmu_has_perf_global_ctrl()), so there's no weirdness with the guest being able
>>> to access MSRs that shouldn't exist.
>>>
>>> But KVM shouldn't stuff pmu->global_ctrl, and doing so is a symptom of another
>>> flaw.  Unless I'm missing something, KVM stuffs pmu->global_ctrl so that the
>>> correct value is loaded on VM-Enter, but loading and saving PERF_GLOBAL_CTRL on
>>> entry/exit is unnecessary and confusing, as is loading the associated MSRs when
>>> restoring (loading) the guest context.
>>>
>>> For PERF_GLOBAL_CTRL on Intel, KVM needs to ensure all GP counters are enabled in
>>> VMCS.GUEST_IA32_PERF_GLOBAL_CTRL, but that's a "set once and forget" operation,
>>> not something that needs to be done on every entry and exit.  Of course, loading
>>> and saving PERF_GLOBAL_CTRL on every entry/exit is unnecessary for other reasons,
>>> but that's largely orthogonal.
>>>
>>> On AMD, amd_restore_pmu_context()[*] needs to enable a maximal value for
>>> PERF_GLOBAL_CTRL, but I don't think there's any need to load the other MSRs,
>>> and the maximal value should come from the above logic, not pmu->global_ctrl.
>> Sean, just double confirm, you are suggesting to do one-shot initialization
>> for guest PERF_GLOBAL_CTRL (VMCS.GUEST_IA32_PERF_GLOBAL_CTRL for Intel)
>> after vCPU resets, right?
> No, it would need to be written during refresh().  VMCS.GUEST_IA32_PERF_GLOBAL_CTRL
> is only static (because it's unreachable) if the guest does NOT have version > 1.
oh, yeah, refresh() instead of reset() to be exact.
>

