Return-Path: <kvm+bounces-17082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D8D8C09F3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 04:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E2191F22CEB
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18FF13C3DF;
	Thu,  9 May 2024 02:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWzberVg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A189F85950;
	Thu,  9 May 2024 02:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715223513; cv=none; b=BnTilldn/fKA7E4tMjxvnGNroLbBYkGb0fKVHQeP94UVwhpXPUlVyLpKshsN+Z/bPviznpeZebV38vvbcvGuFNUpFJCmMHfzWtgc4fqlzNwHjEHd3f9FMw3TXU8g/v9g57Pg+we0PSl2FzPO7r8KB6HA9TP9tp+Z2DZoZMKJ8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715223513; c=relaxed/simple;
	bh=scJgC0HkzGpJkHpFhkXum0CUoi2ERVSMaLYTkKCUkEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUNOJlDqUWgzEdTwjOwq9jiOozmMqdFT73wpV+SDgiQbYuFNW/c1bf0QoGDF9szD3Rl7662MdCEEolcNMiTpq+KUcWHKcTBsfvm82JYQJhrTgCeHePYcTLD6vFuEDbPAchT5CCE66HNhuqogQ3qvcavam/n5S/EKzqf1C9Ahtbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWzberVg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715223512; x=1746759512;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=scJgC0HkzGpJkHpFhkXum0CUoi2ERVSMaLYTkKCUkEU=;
  b=PWzberVgzeMvVojLgIZe9FjUF+McXWBqBI7Elf6KL6bYUb7+0dqBDMmG
   nmjxCNLZYbWcmi/M6p4UnffD3F+fDvCqPy8frUixhi/3kCCcDLmdBVaoc
   2XZdQSVt6pZFouWYB8AfAQx0bpOEyltyTDLmMuOo5Gym0UE10LHnN4LI2
   mrn4N5IhfdjFg47bD6hbMrcUjUPq6uRmGGWpbLrI47hx4rcqTtbE6Kwyv
   GQS82F3EikS1rL3bf3OmhnI1EkPNhZigtN1EBhyJOwtVFuiQ1kS1Z7e8B
   KSh1tGeUaaBgnwHqcYe6GAf23J+xuo5XvUB1i5gRRgtky5tnwcDsMGmqU
   g==;
X-CSE-ConnectionGUID: uk2Ne+w1SYWuc+bMDyDo8Q==
X-CSE-MsgGUID: wt61SB3OQMeKZ/Ulx+NNpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="14934209"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="14934209"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 19:58:32 -0700
X-CSE-ConnectionGUID: Bk+F0MIdQv68pDRA2TT90A==
X-CSE-MsgGUID: Dtf65lEfRLOHOBebC1NsbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="33626671"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 19:58:25 -0700
Message-ID: <5e14e5bd-0125-4d56-953f-8ecdbe31668d@linux.intel.com>
Date: Thu, 9 May 2024 10:58:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when
 accessing global_ctrl in passthrough vPMU
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
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
 <20240506053020.3911940-27-mizhang@google.com>
 <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
 <9b93c6bb-0182-4729-a935-2c05f1160a73@linux.intel.com>
 <e7bc3989-154b-42cb-9a6b-83b395f5d0ee@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <e7bc3989-154b-42cb-9a6b-83b395f5d0ee@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/9/2024 9:29 AM, Chen, Zide wrote:
>
> On 5/8/2024 5:43 PM, Mi, Dapeng wrote:
>> On 5/9/2024 5:48 AM, Chen, Zide wrote:
>>> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
>>>> Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
>>>> when passthrough vPMU is enabled. Note that even when passthrough vPMU is
>>>> enabled, global_ctrl may still be intercepted if guest VM only sees a
>>>> subset of the counters.
>>>>
>>>> Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>>> ---
>>>>  arch/x86/kvm/pmu.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>>> index bd94f2d67f5c..e9047051489e 100644
>>>> --- a/arch/x86/kvm/pmu.c
>>>> +++ b/arch/x86/kvm/pmu.c
>>>> @@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>>  		if (pmu->global_ctrl != data) {
>>>>  			diff = pmu->global_ctrl ^ data;
>>>>  			pmu->global_ctrl = data;
>>>> -			reprogram_counters(pmu, diff);
>>>> +			if (!is_passthrough_pmu_enabled(vcpu))
>>>> +				reprogram_counters(pmu, diff);
>>> Since in [PATCH 44/54], reprogram_counters() is effectively skipped in
>>> the passthrough case, is this patch still needed?
>> Zide, reprogram_counters() and reprogram_counter() are two different
>> helpers. Both they need to be skipped in passthrough mode.
> Yes, but this is talking about reprogram_counters() only.  passthrough
> mode is being checked inside and outside the function call, which is
> redundant.
Oh, yes. I don't need this patch then.

