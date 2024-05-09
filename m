Return-Path: <kvm+bounces-17098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCB18C0BF5
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34919282C50
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D2D1494D2;
	Thu,  9 May 2024 07:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kT6CXIK4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741922CA9;
	Thu,  9 May 2024 07:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715239836; cv=none; b=rmzPOTja/g5qtmDgsMd/9ojQ3iUeEq4BpPv0RGJRfgOQGcNjfximKMXjDkYo4eB3vxgqTtQ0WX/zxGORN01zeXmkEW2ASkwBbg66IH2bqCG6lFbH3EjPGG5M5hNsmAOKsLv/92ZCzFq7CGfjc2d3mb6zeVcI0SbV/Kcyn64lmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715239836; c=relaxed/simple;
	bh=dvywxWombUI9APoz+VK+Sl0o4Zdu/VmMMBc/g1btFx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mS/6iXMOPPC66izAMsbqQOnqOtVi1MfYVL/ffBof5YvswEDoXzOiWaxfkaE41Ln558VsUvowEa9ywNmWCz2PuQ52LTe7C0DugsM7PMyozZmg1bGKkAhPM1U/O7Fk3RdMOA464oWBP/D076AoXL8+MnfEjRw7E8a2KBdWe2UyFEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kT6CXIK4; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715239834; x=1746775834;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dvywxWombUI9APoz+VK+Sl0o4Zdu/VmMMBc/g1btFx0=;
  b=kT6CXIK4GirFruSaKlcs60J7IpIYOSWWXO8VLA6rLSQaM4EuMfa+cfVl
   dB/bCTFa3ryIhMbHWAWrNOU57IMRvW0MaM5Wg9Z0sGvmHso0Zb4TjyXyn
   36IB5E+OnqyylkSFlp/HD9xJBTSmBjURKYXCjGInI7+bHLF6Zm7CCHb0u
   PclUzJFKpe2nVkcgq4Fisd6AD7jhgUBZsjneDq4XZJ3Bx+JzY+NO3WOsR
   mj9+reHpSriE+qLd8QvxUa0IpSxXFIfehGfoRpxlsOIL4m1oXSVN0dKHD
   jYjHkxs4q7WekvfbqCCPfqgH5T/f57+/SCyKmx4X4uBsQgqFIw026wWVx
   w==;
X-CSE-ConnectionGUID: Z4zeweKOT+S5jl1NjM+lWA==
X-CSE-MsgGUID: zrH1ywuDTfKeA2dUDtYKoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="28655487"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="28655487"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:30:33 -0700
X-CSE-ConnectionGUID: j+SrG3lKRfq87nCVLp0dDQ==
X-CSE-MsgGUID: b5kEwL0BRsiNCfn2BtNbkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="60021404"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:30:28 -0700
Message-ID: <33425c96-96a9-4a5b-8a1b-9b1ebcba448c@linux.intel.com>
Date: Thu, 9 May 2024 15:30:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
 <20240507092241.GV40213@noisy.programming.kicks-ass.net>
 <34245468-00fc-49aa-951e-d7d786084d08@linux.intel.com>
 <20240508083707.GH30852@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240508083707.GH30852@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/2024 4:37 PM, Peter Zijlstra wrote:
> On Wed, May 08, 2024 at 02:58:30PM +0800, Zhang, Xiong Y wrote:
>> On 5/7/2024 5:22 PM, Peter Zijlstra wrote:
>>> On Mon, May 06, 2024 at 05:29:37AM +0000, Mingwei Zhang wrote:
>>>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
>>>> +void x86_perf_guest_enter(u32 guest_lvtpc)
>>>> +{
>>>> +	lockdep_assert_irqs_disabled();
>>>> +
>>>> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>>>> +			       (guest_lvtpc & APIC_LVT_MASKED));
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(x86_perf_guest_enter);
>>>> +
>>>> +void x86_perf_guest_exit(void)
>>>> +{
>>>> +	lockdep_assert_irqs_disabled();
>>>> +
>>>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
>>>
>>> Urgghh... because it makes sense for this bare APIC write to be exported
>>> ?!?
>> Usually KVM doesn't access HW except vmx directly and requests other
>> components to access HW to avoid confliction, APIC_LVTPC is managed by x86
>> perf driver, so I added two functions here and exported them.
> 
> Yes, I understand how you got here. But as with everything you export,
> you should ask yourself, should I export this. The above
> x86_perf_guest_enter() function allows any module to write random LVTPC
> entries. That's not a good thing to export.
Totally agree with your concern. Here KVM need to switch PMI vector at PMU
context switch, export isn't good, could you kindly give guideline to
design or improve such interface?
I thought the following two method, but they are worse than this commit.
1. Perf register notification to KVM, but this makes perf depends on KVM.
2. KVM write APIC_LVTPC directly, but this needs x86 export apic_write().

thanks
> 
> I utterly detest how KVM is a module and ends up exporting a ton of
> stuff that *really* should not be exported.

