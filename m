Return-Path: <kvm+bounces-32146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3DF9D3A4A
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 13:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A552B23AA5
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 11:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA0B1A3AB1;
	Wed, 20 Nov 2024 11:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gc7ZYG2E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A9419E98A;
	Wed, 20 Nov 2024 11:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732103435; cv=none; b=Dh05uW+LcvE91FZ0Y2TUyhS9KYowI0Dfw/E0grmtp2L//hEZ/KsMlvibDzAxrtYrBGCdL7Yqdp+t+FMTwZnALrUaoIQm8PRO9wIeYZE2gHFIwf7YNctxRqmQHD0BUz3t01i09jQqlZjKTn2vjUNMRtHqV2YIWViawVcTK2HiS6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732103435; c=relaxed/simple;
	bh=vgR2QGy5ActK3tloN3jTKvROuGWWUI4mrqV1CfwRMRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=unwIC0LBjDtiPQuntKxWnG36Jy6PGpNUmYo+f1yWmOX47TaIqAMn6xky3z8+Nhbp3acorwVSLKnKt16aaIgLE+mozGCmyZlvtUDr9M1+uwZBTQIkvMd747uJ16JReXPETEy4M+shrXqk0OzZrfLlOtXy3nzuGlvaj5F4YWP1zdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gc7ZYG2E; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732103435; x=1763639435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vgR2QGy5ActK3tloN3jTKvROuGWWUI4mrqV1CfwRMRk=;
  b=Gc7ZYG2EzHDZ21WYJiGKTJdSzzAvyo5iScqnqmiVx3Mt6CWJUZlCSrRe
   DEUFfF9lKsrosBjIcL91SWq6cZCnjMM8ku9g7OwRhecZpTUvxAfhjtITw
   VHG+K8o52srfbyGUZts9+vf/bdqSpXe2wkWEPzYh61tX5U7w0BuGXErjB
   PCW2suLGIq7nVHhB0W6S6TmWT+2yUM9YCL4ZSs4L7nAczpzcfMZCbkeyk
   IZWUM4uR2PYlzEwDqJJFOKfOWWqsNV2K3PMnV8ULNLLHWYjtnftnZSCsi
   LrpjR0diYIGlrlEiT0/Ka0SxJrDzrFzgE1wng5DllTCj0B6m5JzPgwGkS
   Q==;
X-CSE-ConnectionGUID: 10FbWJHmT4KbGLATuSHEUw==
X-CSE-MsgGUID: 1EmOA1pKRCa5tmZofZFIhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="43223115"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="43223115"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 03:50:34 -0800
X-CSE-ConnectionGUID: DIcRQmEKRiSQ3PQnwFBmow==
X-CSE-MsgGUID: avTOmYJ4RiGMC+IxA/abiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="90297146"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 03:50:29 -0800
Message-ID: <01b6dc80-8cb6-4b13-9d0f-db3a07672532@linux.intel.com>
Date: Wed, 20 Nov 2024 19:50:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 31/58] KVM: x86/pmu: Add counter MSR and selector
 MSR index into struct kvm_pmc
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
 <20240801045907.4010984-32-mizhang@google.com> <ZzzfwXefHP7SG-Vy@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzfwXefHP7SG-Vy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 2:58 AM, Sean Christopherson wrote:
> Please squash this with the patch that does the actual save/load.  Hmm, maybe it
> should be put/load, now that I think about it more?  That's more consitent with
> existing KVM terminology.

Sure. I ever noticed that this in-consistence, but "put" seem not so
intuitionistic as "save", so didn't change it.


>
> Anyways, please squash them together, it's very difficult to review them separately.
>
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Add the MSR indices for both selector and counter in each kvm_pmc. Giving
>> convenience to mediated passthrough vPMU in scenarios of querying MSR from
>> a given pmc. Note that legacy vPMU does not need this because it never
>> directly accesses PMU MSRs, instead each kvm_pmc is bound to a perf_event.
>>
>> For actual Zen 4 and later hardware, it will never be the case that the
>> PerfMonV2 CPUID bit is set but the PerfCtrCore bit is not. However, a
>> guest can be booted with PerfMonV2 enabled and PerfCtrCore disabled.
>> KVM does not clear the PerfMonV2 bit from guest CPUID as long as the
>> host has the PerfCtrCore capability.
>>
>> In this case, passthrough mode will use the K7 legacy MSRs to program
>> events but with the incorrect assumption that there are 6 such counters
>> instead of 4 as advertised by CPUID leaf 0x80000022 EBX. The host kernel
>> will also report unchecked MSR accesses for the absent counters while
>> saving or restoring guest PMU contexts.
>>
>> Ensure that K7 legacy MSRs are not used as long as the guest CPUID has
>> either PerfCtrCore or PerfMonV2 set.
>>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/kvm/svm/pmu.c          | 13 +++++++++++++
>>  arch/x86/kvm/vmx/pmu_intel.c    | 13 +++++++++++++
>>  3 files changed, 28 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 4b3ce6194bdb..603727312f9c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -522,6 +522,8 @@ struct kvm_pmc {
>>  	 */
>>  	u64 emulated_counter;
>>  	u64 eventsel;
>> +	u64 msr_counter;
>> +	u64 msr_eventsel;
> There's no need to track these per PMC, the tracking can be per PMU, e.g.
>
> 	u64 gp_eventsel_base;
> 	u64 gp_counter_base;
> 	u64 gp_shift;
> 	u64 fixed_base;
>
> Actually, there's no need for a per-PMU fixed base, as that can be shoved into
> kvm_pmu_ops.  LOL, and the upcoming patch hardcodes INTEL_PMC_FIXED_RDPMC_BASE.
> Naughty, naughty ;-)
>
> It's not pretty, but 16 bytes per PMC isn't trivial. 
>
> Hmm, actually, scratch all that.  A better alternative would be to provide a
> helper to put/load counter/selector MSRs, and call that from vendor code.  Ooh,
> I think there's a bug here.  On AMD, the guest event selector MSRs need to be
> loaded _before_ PERF_GLOBAL_CTRL, no?  I.e. enable the guest's counters only
> after all selectors have been switched AMD64_EVENTSEL_GUESTONLY.  Otherwise there
> would be a brief window where KVM could incorrectly enable counters in the host.
> And the reverse that for put().
>
> But Intel has the opposite ordering, because MSR_CORE_PERF_GLOBAL_CTRL needs to
> be cleared before changing event selectors.

Not quite sure about AMD platforms, but it seems both Intel and AMD
platforms follow below sequence to manipulated PMU MSRs.

disable PERF_GLOBAL_CTRL MSR

manipulate counter-level PMU MSR

enable PERF_GLOBAL_CTRL MSR

It seems there is no issues?


>
> And so trying to handle this entirely in common code, while noble, is at best
> fragile and at worst buggy.
>
> The common helper can take the bases and shift, and if we want to have it handle
> fixed counters, the base for that too.

Sure. Would add a callback and vendor specific code would fill the base and
shift fields by leveraging the callback.


>

