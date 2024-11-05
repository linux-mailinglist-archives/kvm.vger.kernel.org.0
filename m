Return-Path: <kvm+bounces-30736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4366C9BCDF0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 14:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE9481F22AA6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 13:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992621D7992;
	Tue,  5 Nov 2024 13:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMc2n8pv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97E1D63EE;
	Tue,  5 Nov 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730813681; cv=none; b=aPziDcIo9jyk6MQ+XaxyBOJTQZO/ITgxlz95ySNW6YSeWEvt1RXd/mMaStKhOOfUD2vDI7u/nHhAeb+YdQezxG7L5NdRWYN1S+CJd2NqmF0DuQ+ujyeiFZTvOXsc7+S0rnR+48pUQ5bf9Z/4qZX8RI3SWbgDiXkm32+1fpQJncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730813681; c=relaxed/simple;
	bh=t7fHs7K7jwW1ucoMjVvg2nG51xxS8WuOmcmhyFFZGNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0EhZIGIybQF0If0qZTdXuOa1pTDcGgx9GRVIliY0NRN5RLGIF/fnGHai+0mThFd///sgWdU8WMqsM7xw8Rhh9XMKnNGerwZMOVPB+E2okhf/4oLOxt84Ek1vI2U7K22M14+OpOaMtngX4LhD0L1jbsX3kAnFoVSAES4FVQyqgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMc2n8pv; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730813680; x=1762349680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t7fHs7K7jwW1ucoMjVvg2nG51xxS8WuOmcmhyFFZGNE=;
  b=PMc2n8pvtO4PpBOzHDc5XEMYJ4YVD/ABSnu3VXE6O6EpHHJ4Tvfy2njD
   bRla931nRrFn0X3uzxT858B51JwO9nTLl+jlY6396AULw6fKQuR0V3uHo
   GUfM12meOuL11hVdjXtGloBjOMw6Q5nocsTPuuUVAD1ZbkfxIn3F74hrC
   le3PQMrYiC41JTbAQkpi6f9gHNyk1sEHrAiyMT+wFdLQNiMZWrK5iYErn
   jaYWJZ20nUBEePZ2rdbEAvGFH43AmAoaW+X2dcM9k0b4xgrPboP3trzn4
   2nbVJOjdyR/7XtY1FN1dCbQTHHPm0UAzrnR8sSimIpPYi78PjgN6+IT+O
   g==;
X-CSE-ConnectionGUID: ZMUmd85vSeuMgaO2+uIiGg==
X-CSE-MsgGUID: mjMK8IllR12wepsC99owwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="29977002"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="29977002"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 05:34:24 -0800
X-CSE-ConnectionGUID: u+4Jd/6PR6OoeHm62EmHyQ==
X-CSE-MsgGUID: BHQ6aUCWR2CgdM2Lb/eJ+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="88823048"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 05:34:22 -0800
Message-ID: <bb0a1948-d418-4720-97bf-4aceb30ea787@intel.com>
Date: Tue, 5 Nov 2024 21:34:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: VMX: Bury Intel PT virtualization (guest/host
 mode) behind CONFIG_BROKEN
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
References: <20241101185031.1799556-1-seanjc@google.com>
 <20241101185031.1799556-2-seanjc@google.com>
 <c7b8f395-579b-40d9-b3eb-29a347f73ec9@intel.com>
 <ZylO2lHCydixvYCL@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZylO2lHCydixvYCL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/2024 6:46 AM, Sean Christopherson wrote:
> On Mon, Nov 04, 2024, Xiaoyao Li wrote:
>> On 11/2/2024 2:50 AM, Sean Christopherson wrote:
>>> Hide KVM's pt_mode module param behind CONFIG_BROKEN, i.e. disable support
>>> for virtualizing Intel PT via guest/host mode unless BROKEN=y.  There are
>>> myriad bugs in the implementation, some of which are fatal to the guest,
>>> and others which put the stability and health of the host at risk.
>>>
>>> For guest fatalities, the most glaring issue is that KVM fails to ensure
>>> tracing is disabled, and *stays* disabled prior to VM-Enter, which is
>>> necessary as hardware disallows loading (the guest's) RTIT_CTL if tracing
>>> is enabled (enforced via a VMX consistency check).  Per the SDM:
>>>
>>>     If the logical processor is operating with Intel PT enabled (if
>>>     IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>>>     IA32_RTIT_CTL" VM-entry control must be 0.
>>>
>>> On the host side, KVM doesn't validate the guest CPUID configuration
>>> provided by userspace, and even worse, uses the guest configuration to
>>> decide what MSRs to save/load at VM-Enter and VM-Exit.  E.g. configuring
>>> guest CPUID to enumerate more address ranges than are supported in hardware
>>> will result in KVM trying to passthrough, save, and load non-existent MSRs,
>>> which generates a variety of WARNs, ToPA ERRORs in the host, a potential
>>> deadlock, etc.
>>>
>>> Fixes: f99e3daf94ff ("KVM: x86: Add Intel PT virtualization work mode")
>>> Cc: stable@vger.kernel.org
>>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/vmx/vmx.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 6ed801ffe33f..087504fb1589 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -217,9 +217,11 @@ module_param(ple_window_shrink, uint, 0444);
>>>    static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
>>>    module_param(ple_window_max, uint, 0444);
>>> -/* Default is SYSTEM mode, 1 for host-guest mode */
>>> +/* Default is SYSTEM mode, 1 for host-guest mode (which is BROKEN) */
>>>    int __read_mostly pt_mode = PT_MODE_SYSTEM;
>>> +#ifdef CONFIG_BROKEN
>>>    module_param(pt_mode, int, S_IRUGO);
>>> +#endif
>>
>> I like the patch, but I didn't find any other usercase of CONFIG_BROKEN in
>> current Linux.
> 
> Ya, BROKEN is typically used directly in Kconfigs, e.g. "depends on BROKEN".  But
> I can't think of any reason using it in this way would be problematic.

I see. Thanks for the information!

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


