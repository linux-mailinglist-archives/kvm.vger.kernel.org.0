Return-Path: <kvm+bounces-40110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3036CA4F3DD
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E5B916EAA5
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 01:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076CA76C61;
	Wed,  5 Mar 2025 01:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnJUA7D3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C85713AA2E
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138527; cv=none; b=JGOYLe5wfZV/PX+gA5hbWCOiK8GOAKviFS4nz/4ttE8GkH5vVdNUyzsNNoEPWNWTBggE/0GtQAAt48PtBArdCzgkxUAD5xSW+sCER9mJbSI6RJTZY96nxt6UVWfO8dC5VIrIcGyHEBq+9uxlA/h3/BGwDjMRdCcRrbCY1ZVmdyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138527; c=relaxed/simple;
	bh=QiMh0iRts9104TqNvjrIL2k35D8Y8FztnArkpKW4d2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZY1mO2O13AGqs+cgtdb0ZXdy+Cvh05SRZk8dE1oi2fQfAfXojuxqdyifTWMrTdvRqYgyG0pY9Wj8okXzcufu0Re0sOkdXtErsCsw0A3zEGL31mkb+J4gS2xql0YVhknGXZCYsYjIxiRhMPOmLL1+QiL5+kajZ65aX6XBPvflEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnJUA7D3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741138526; x=1772674526;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QiMh0iRts9104TqNvjrIL2k35D8Y8FztnArkpKW4d2k=;
  b=QnJUA7D3qiyjbpiDGy6jwXhlhFEXYfBiDEGTvR/T1a4eZpuhgwuNVv2x
   GFqTHcBiHbj5Ah7M0AZ9kl5jXjAac1MZOB7wxlvDfFPj/REzWpLuKuy4F
   JXkMsdVhKOiFOyW1ZzqwbPm7qsbkgxoDCedw8bTPcJbAnV530lzL5J2LU
   vp/uWKdoCVS9Ykkr52VK6lN17YJ8pjpyeaDh5QU88yCJIr2nxv00TkQCX
   Wj6tGsqAcXH4A/YvwkN/gflrDyRZ6zaHySEg309pQgch2+SHcCazWBE1T
   YG3b7wnd83LRre4vc4shtChG2izt0Hvh/wxKGxCcigfllW2c8uQtUUZHR
   w==;
X-CSE-ConnectionGUID: lsLcko3KR4aFrkQD4hBA8Q==
X-CSE-MsgGUID: 9OAYFE7qTjSBLd30VauGPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41940130"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="41940130"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 17:35:25 -0800
X-CSE-ConnectionGUID: KjNWeVdOSIm87daBpzdDXA==
X-CSE-MsgGUID: yrfcwCikRGW9vGRnzZvTaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="118264472"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 17:35:20 -0800
Message-ID: <f6fd4fd9-0284-4c7c-b314-c3985306689a@intel.com>
Date: Wed, 5 Mar 2025 09:35:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
To: Sean Christopherson <seanjc@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, pbonzini@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
 likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com,
 joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com>
 <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>
 <Z8enUUXhfRTr7KCf@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z8enUUXhfRTr7KCf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/2025 9:22 AM, Sean Christopherson wrote:
> On Tue, Mar 04, 2025, Xiaoyao Li wrote:
>> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>>> Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
>>> there is no way to fully disable KVM AMD PMU virtualization. Neither
>>> "-cpu host,-pmu" nor "-cpu EPYC" achieves this.
>>
>> This looks like a KVM bug.
> 
> Heh, the patches you sent do fix _a_ KVM bug, but this is something else entirely.

Aha, that fix was just found by code inspection. It was not supposed to 
be related with this.

> In practice, the KVM bug only affects what KVM_GET_SUPPORTED_CPUID returns when
> enable_pmu=false, and in that case, it's only a reporting issue, i.e. KVM will
> still block usage of the PMU.
> 
> As Dongli pointed out, older AMD CPUs don't actually enumerate a PMU in CPUID,
> and so the kernel assumes that not-too-old CPUs have a PMU:
> 
> 	/* Performance-monitoring supported from K7 and later: */
> 	if (boot_cpu_data.x86 < 6)
> 		return -ENODEV;
> 
> The "expected" output:
> 
>     Performance Events: PMU not available due to virtualization, using software events only.
> 
> is a long-standing workaround in the kernel to deal with lack of enumeration.  On
> top of explicit enumeration, init_hw_perf_events() => check_hw_exists() probes
> hardware to see if it actually works.  If an MSR is unexpectedly unavailable, as
> is the case when running as a guest, the kernel prints a message and disables PMU
> usage.  E.g. the above message is specific to running as a guest:
> 
> 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> 		pr_cont("PMU not available due to virtualization, using software events only.\n");
> 
>  From the KVM side, because there's no CPUID enumeration, there's no way for KVM
> to know that userspace wants to completely disable PMU virtualization from CPUID
> alone.  Whereas with Intel CPUs, KVM infers that the PMU should be disabled by
> lack of a non-zero PMU version, e.g. if CPUID.0xA is omitted.

I see now.

Thanks to you and Dongli!

>> Anyway, since QEMU can achieve its goal with KVM_PMU_CAP_DISABLE with
>> current KVM, I'm fine with it.
> 
> Yeah, this is the only way other than disabling KVM's PMU virtualization via
> module param (enable_pmu).


