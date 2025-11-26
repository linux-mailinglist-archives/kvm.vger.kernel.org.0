Return-Path: <kvm+bounces-64578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 103E0C8794D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EBFE14E12CB
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 00:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFEA1DD877;
	Wed, 26 Nov 2025 00:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XniS5A0m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A65148850;
	Wed, 26 Nov 2025 00:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764116600; cv=none; b=Y3JHcwwyW797L8wA1kqrJ6I4ifw3jP/7sKbiXAtHy4wegVCd96k2aVRcjFdm8KrqmxMrXEprV4AJ4d0rJkFgjs/dItiP3YLLdBDbY5DB8BibEou07IWck+kqfXb88i6AU9IUrU0dgFSRFKqzNXH2Hhs2d4/jdXgYoMP9VKa0tFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764116600; c=relaxed/simple;
	bh=jNSFdQCLhdJyzqyDdBupTSBjX5ORPHs5VM+yw2SDmzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmmA5JxOizc0dceo65XDGbT++U+17zmdFFPoFg2PEK1YqpljpnMFKetgFUoMC9TegfpJ+TuxWpHUNRIH8ALshf8pwgyPe7G6AKwadG+OnTM+qUAnP57M9FEV9ZcsHSkV1G+4OyEFph+PNlPr1UqQjlNXR92GKU6DiqZOyAqei1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XniS5A0m; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764116598; x=1795652598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jNSFdQCLhdJyzqyDdBupTSBjX5ORPHs5VM+yw2SDmzU=;
  b=XniS5A0m35sAoMkpgcRsVzbaWgJstJyq6FA5G0/CwHZnnjlZP2B9ga5G
   LEItvKO6gljXG2QX/k+njdhzg+ANLaFx0vD76ur1QIYXFJopUBmNhYjd8
   TSEYXQc8zD5onNRxgVlwTGH/HPzsKYt2iFEOOW/5mdwZgM984JprLMKO/
   IMkbdthdzWf2IlGaq7u7YWrLrPk+LGtgYCqaBdYlJQ2LqChzaaqQOnkJH
   hAFT4zR/2yZF1qEVg2XiF6/bYYqMJTpgp8MDBZoLv5vBvKCBZymMhzX66
   Gy2zs15YriofLwx0+I98Js8VglDqewmVvh1twG035VwsUTK0ynlOaZaXG
   g==;
X-CSE-ConnectionGUID: ucAPYeJ+Qg+H0kr2PqHh6A==
X-CSE-MsgGUID: LfCaZAxoQKS/qWsfrr7jpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66306976"
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="66306976"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 16:23:18 -0800
X-CSE-ConnectionGUID: W+654JrHR0i0NNZKwcIPrQ==
X-CSE-MsgGUID: g62AlCY3TmyGnusI1wnrTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="197267661"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 16:23:10 -0800
Message-ID: <f7a84eb0-eb64-4cdf-801d-088bbdbce0b4@linux.intel.com>
Date: Wed, 26 Nov 2025 08:23:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via
 entry/exit fields for mediated PMU
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-29-seanjc@google.com> <aSUK8FuWT4lpMP3F@google.com>
 <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
 <aSXigAQznhuxZmy7@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aSXigAQznhuxZmy7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/26/2025 1:08 AM, Sean Christopherson wrote:
> On Tue, Nov 25, 2025, Dapeng Mi wrote:
>> On 11/25/2025 9:48 AM, Sean Christopherson wrote:
>>>> +	if (host_pmu->version < 4 || !(host_perf_cap & PERF_CAP_FW_WRITES))
>>>> +		return false;
>>>> +
>>>> +	/*
>>>> +	 * All CPUs that support a mediated PMU are expected to support loading
>>>> +	 * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
>>>> +	 */
>>>> +	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
>>>> +			 !cpu_has_save_perf_global_ctrl()))
>>>> +		return false;
>>> And so this WARN fires due to cpu_has_save_perf_global_ctrl() being false.  The
>>> bad changelog is mine, but the code isn't entirely my fault.  I did suggest the
>>> WARN in v3[1], probably because I forgot when PMU v4 was introduced and no one
>>> corrected me.
>>>
>>> v4 of the series[2] then made cpu_has_save_perf_global_ctrl() a hard requirement,
>>> based on my miguided feedback.
>>>
>>>    * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
>>>      save/retore list support for GLOBAL_CTRL, thus the support of mediated
>>>      vPMU is constrained to SapphireRapids and later CPUs on Intel side.
>>>
>>> Doubly frustrating is that this was discussed in the original RFC, where Jim
>>> pointed out[3] that requiring VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL would prevent
>>> enabling the mediated PMU on Skylake+, and I completely forgot that conversation
>>> by the time v3 of the series rolled around :-(
>> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL is introduced from SPR and later. I
>> remember the original requirements includes to support Skylake and Icelake,
>> but I ever thought there were some offline sync and the requirement changed...
> Two things:
>
>  1) Upstream's "requirements" are not the same as Google's requirements (or those
>     of any company/individual).  Upstream most definitely is influenced by the
>     needs and desires of end users, but ultimately the decision to do something
>     (or not) is one that needs to be made by the upstream community.
>
>  2) Decisions made off-list need to be summarized and communicated on-list,
>     especially in cases like this where it's a relatively minor detail in a
>     large series/feature, and thus easy to overlook.
>
> I'll follow-up internally to make sure these points are well-understood by Google
> folks as well (at least, those working on KVM).

Understood and would follow.


>
>> My bad,
> Eh, this was a group "effort".  I'm as much to blame as anyone else.
>
>> I should double confirm this at then.
> No need, as above, Google's requirements (assuming the requirements you're referring
> to are coming from Google people) are effectively just one data point.  At this
> point, I want to drive the decision to support Sylake+ (or not) purely through
> discussion of upstream patches.
>
>>> As mentioned in the discussion with Jim, _if_ PMU v4 was introduced with ICX (or
>>> later), then I'd be in favor of making VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard
>>> requirement.  But losing supporting Skylake+ is a bit much.
>>>
>>> There are a few warts with nVMX's use of the auto-store list that need to be
>>> cleaned up, but on the plus side it's also a good excuse to clean up
>>> {add,clear}_atomic_switch_msr(), which have accumulated some cruft and quite a
>>> bit of duplicate code.  And while I still dislike using the auto-store list, the
>>> code isn't as ugly as it was back in v3 because we _can_ make the "load" VMCS
>>> controls mandatory without losing support for any CPUs (they predate PMU v4).
>> Yes, xxx_atomic_switch_msr() helpers need to be cleaned up and optimized. I
>> suppose we can have an independent patch-set to clean up and support
>> global_ctrl with auto-store list for Skylake and Icelake.
> I have the code written (I wanted to see how much complexity it would add before
> re-opening this discussion).  My plan is to put the Skylake+ support at the end
> of the series, not a separate series, so that it can be reviewed in one shot.
> E.g. if we can make a change in the "main" series that would simplify Skylake+
> support, then I'd prefer to find and implement any such change right away.

Sure. Thanks.



