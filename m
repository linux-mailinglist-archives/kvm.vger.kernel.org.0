Return-Path: <kvm+bounces-32114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A18159D322F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 03:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 302FE1F23BB3
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 02:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD5C42AAB;
	Wed, 20 Nov 2024 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jK+/Dd3E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CBD3D69;
	Wed, 20 Nov 2024 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732069922; cv=none; b=flMuj14yazYgLJnF9u7YPaNWFrZAiurQgPAVq4awUs6hqxwYyYrlnxGU9G0KIt+l3lP0ACFYTqizRYxH1V4FQhf+oEN/SzKgsgSrWW7GVkYC7OrpcEGImb+zGdpxLcqTVMhf7O4BcUOnwhjkiTtBk3EAw/qdRYF09JYIi8XJeeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732069922; c=relaxed/simple;
	bh=5uJRZ/VYjfqfRcplK62lTG3IErPJAqFIAMRB7D94jaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSKwMhfS34byqKgWro1S5TuiEVCwuDOBOFQ8Kpk/bAeiKdjTuOY7xq6vaH7BweeK7G88cRWgla0GcGDZyE/ZzZjY/hKlgsXe0ji2tL4OdBARh9a5PidZXCHif7m9Onv4tNAmfEkDYwANVQ225eZs3CPI30RdE0+n5dv36GQEKfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jK+/Dd3E; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732069921; x=1763605921;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5uJRZ/VYjfqfRcplK62lTG3IErPJAqFIAMRB7D94jaU=;
  b=jK+/Dd3EIuJPrv5++CeUMISiR/iJETZZTZ5ew3gFNvnbD/XrPSxeMz9G
   MiFdgEtZ8bEtnU5mkuHctW0ywJVmt+2w8RsJ48sPCyQnQ667cXvpRVVYf
   kXASQgOBE+yh3YudEzThVqhK7kKqE+8XkprM6GWZ2ATVGG60JnMHVJGju
   4OyeD78gu2cTKvr0D/MQk5VgrReQ+1ckIb5j86AL9vm0NzeZDk77xmopY
   xRjNtY0hXuOg6qcXVPHdC/v1wGa/HSuo1riS8EoyFYwMsaOhOD1OhsmQa
   uV3TZfDcNS6t1X1pIOTipeO2bPqY8UxZxpEWPAy+13leQYReziSS0Bhwx
   w==;
X-CSE-ConnectionGUID: h/GwBSzrTpqgKFnx/Gc9qw==
X-CSE-MsgGUID: AItRHCwfRPuKymKy/zTngA==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32257063"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32257063"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 18:32:00 -0800
X-CSE-ConnectionGUID: VVmGCb3KQTG4woZRtMSrkQ==
X-CSE-MsgGUID: JLjx93f7QAmEhHzHuecRWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="113045351"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 18:31:56 -0800
Message-ID: <60ddd7aa-adcf-4afd-b651-afd8035847ba@linux.intel.com>
Date: Wed, 20 Nov 2024 10:31:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
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
 <ZzyZ7U9C3EZyudz7@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzyZ7U9C3EZyudz7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/19/2024 10:00 PM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> This series contains perf interface improvements to address Peter's
>> comments. In addition, fix several bugs for v2. This version is based on
>> 6.10-rc4. The main changes are:
>>
>>  - Use atomics to replace refcounts to track the nr_mediated_pmu_vms.
>>  - Use the generic ctx_sched_{in,out}() to switch PMU resources when a
>>    guest is entering and exiting.
>>  - Add a new EVENT_GUEST flag to indicate the context switch case of
>>    entering and exiting a guest. Updates the generic ctx_sched_{in,out}
>>    to specifically handle this case, especially for time management.
>>  - Switch PMI vector in perf_guest_{enter,exit}() as well. Add a new
>>    driver-specific interface to facilitate the switch.
>>  - Remove the PMU_FL_PASSTHROUGH flag and uses the PASSTHROUGH pmu
>>    capability instead.
>>  - Adjust commit sequence in PERF and KVM PMI interrupt functions.
>>  - Use pmc_is_globally_enabled() check in emulated counter increment [1]
>>  - Fix PMU context switch [2] by using rdpmc() instead of rdmsr().
>>
>> AMD fixes:
>>  - Add support for legacy PMU MSRs in MSR interception.
>>  - Make MSR usage consistent if PerfMonV2 is available.
>>  - Avoid enabling passthrough vPMU when local APIC is not in kernel.
>>  - increment counters in emulation mode.
>>
>> This series is organized in the following order:
>>
>> Patches 1-3:
>>  - Immediate bug fixes that can be applied to Linux tip.
>>  - Note: will put immediate fixes ahead in the future. These patches
>>    might be duplicated with existing posts.
>>  - Note: patches 1-2 are needed for AMD when host kernel enables
>>    preemption. Otherwise, guest will suffer from softlockup.
>>
>> Patches 4-17:
>>  - Perf side changes, infra changes in core pmu with API for KVM.
>>
>> Patches 18-48:
>>  - KVM mediated passthrough vPMU framework + Intel CPU implementation.
>>
>> Patches 49-58:
>>  - AMD CPU implementation for vPMU.
> Please rename everything in KVM to drop "passthrough" and simply use "mediated"
> for the overall concept.  This is not a passthrough setup by any stretch of the
> word.  I realize it's a ton of renaming, but calling this "passthrough" is very
> misleading and actively harmful for unsuspecting readers.

Sure.


>
> For helpers and/or comments that deal with intercepting (or not) MSRs, use
> "intercept" and appropriate variations.  E.g. intel_pmu_update_msr_intercepts().

Sure.


>
> And for RDPMC, maybe kvm_rdpmc_in_guest() to follow kvm_{hlt,mwait,pause,cstate_in_guest()?
> I don't love the terminology, but there's a lot of value in being consistent
> throughout KVM.

Sure.


>
> I am not willing to budge on this, at all.
>
> I'm ok with the perf side of things using "passthrough" if "mediated" feels weird
> in that context and we can't come up with a better option, but for the KVM side,
> "passthrough" is simply wrong.

Kan, what's you idea on perf side's naming? I prefer unified naming in the
whole patchset.



