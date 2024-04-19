Return-Path: <kvm+bounces-15182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9808AA69A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ED571C21B75
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 01:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E8B3C28;
	Fri, 19 Apr 2024 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="expQ49LH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38F1362;
	Fri, 19 Apr 2024 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713490977; cv=none; b=kjN7OMC6pnG6/WaKrltBxeNJLsP+lfgPRhcSr9CtD4h4BDVT8K6ehrujN72kBoIeexI1WccJWQujBzjLQ92iZnCtDWdR5pALM4TC22GKJp+Dq9QXeqwM0dUxd4y78AyG9wfzFBGCMrXbcJWP6bIHq/Pg7EbTeIa5ZbGCQL3NmaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713490977; c=relaxed/simple;
	bh=cSZkElQuxZTV1/D8NzqIO8txy29Fe8ChfyA1kCtXJjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9zz8RMue4jzCZAvLyo8wKmwISWshIM8POHkOvuriK2sb76HD//m1xlLsB26j4cbfa8aQ/YY/d9v/o5Amq1l9LS0w91ZGNlhPu1TsQQEx6E9cnoel7pSo/0RylqOesmmF/njz7qENCVJKt5cRbirVohG7B0MQgFAPcSzFjY8ZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=expQ49LH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713490976; x=1745026976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cSZkElQuxZTV1/D8NzqIO8txy29Fe8ChfyA1kCtXJjc=;
  b=expQ49LHOkuMzeynhwff9X397oAp+6/VTsZZDO/K0KfwmsDp9Pv43Qii
   o77Gv3d9d4CEey9Yus/TE0ypfzoRHDw+VRdfiMvTxeRSU4chiUhGrzntp
   WDOY8NOmX/B2JI9X1FjvG06deUvBJQH84/7cPofHAcQGq7IWC82guaK7j
   89NXLhHP27+WZgB1uVmKsNXz67wWJIMOLUzis9eNz23JqKQ4P/HQSFHgL
   nHmcwJdpSHoghOy8wvFzlR+N3eBIW2NeNfUH3jFdwrrcllIMAsP+ucome
   f1sKVWN17B0dOydvRwS9RX6yRInVfAzSivHgZNcl+beAVsUXl0Fzmne+2
   w==;
X-CSE-ConnectionGUID: 7AEnpK7iScGwU1yme1Cg4g==
X-CSE-MsgGUID: 87iGdm0DQeGtqRV9R4HCxg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9202175"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9202175"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:42:55 -0700
X-CSE-ConnectionGUID: 1iL09b7CTDqgzgzUMFAIlw==
X-CSE-MsgGUID: dw35IcYrRCet56oNwtTe1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23250130"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 18:42:51 -0700
Message-ID: <f83f6923-7aa2-4a10-8e83-3fa77400c446@linux.intel.com>
Date: Fri, 19 Apr 2024 09:42:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
 <dac4aa8c-94d1-475e-ae97-20229bd9ade2@linux.intel.com>
 <20240418212214.GB3596705@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240418212214.GB3596705@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/19/2024 5:22 AM, Isaku Yamahata wrote:
> On Thu, Apr 18, 2024 at 07:04:11PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 4/18/2024 5:29 PM, Binbin Wu wrote:
>>>> +
>>>> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct kvm_memory_slot *slot;
>>>> +    int size, write, r;
>>>> +    unsigned long val;
>>>> +    gpa_t gpa;
>>>> +
>>>> +    KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
>>>> +
>>>> +    size = tdvmcall_a0_read(vcpu);
>>>> +    write = tdvmcall_a1_read(vcpu);
>>>> +    gpa = tdvmcall_a2_read(vcpu);
>>>> +    val = write ? tdvmcall_a3_read(vcpu) : 0;
>>>> +
>>>> +    if (size != 1 && size != 2 && size != 4 && size != 8)
>>>> +        goto error;
>>>> +    if (write != 0 && write != 1)
>>>> +        goto error;
>>>> +
>>>> +    /* Strip the shared bit, allow MMIO with and without it set. */
>>> Based on the discussion
>>> https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
>>> Do we still allow the MMIO without shared bit?
> That's independent.  The part is how to work around guest accesses the
> MMIO region with private GPA.  This part is,  the guest issues
> TDG.VP.VMCALL<MMMIO> and KVM masks out the shared bit to make it friendly
> to the user space VMM.
It's similar.
The tdvmcall from the guest for mmio can also be private GPA, which is 
not reasonable, right?
According to the comment, kvm doens't care about if the TD guest issue 
the tdvmcall with private GPA or shared GPA.



