Return-Path: <kvm+bounces-15907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3468B2158
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 143621F22496
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FD612D770;
	Thu, 25 Apr 2024 12:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsVJMp11"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E06012B156
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 12:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714046694; cv=none; b=KKwvpStckQnQRrzNMwSuSWnc0ERBKlEj53D9LQBqot+MAl1vOAijzB/DDm8Sn8EE1OM6eH49ZXVD6cLr1JM0w0nGJbgzVRkRIE5FEuH34vSZcWFRNiPJWcLAD5SopEcQp9CnSMRVFZCQYDhiIcnDatdEdwM7dWKuNeElXDPASCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714046694; c=relaxed/simple;
	bh=Jr6R/la1rSAowbUSEQZJA/82lMaRwKYgXs88oenMdZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tiY25qTrH6BMRGTkm209plwFNll2s+sykcIY7yyPFZ6SOYEl6ZFnywRPNsZpnN3ePN2u+fNS37yl/6iIf4Cd/BzOrOpZJlmT57rrWag8hw5dFRaMMIrFQN3jwg1a9NPYmMU59gNEZ/1F3AhkFgrtcnWXO7hpX0VJmP01+7gZqAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsVJMp11; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714046692; x=1745582692;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jr6R/la1rSAowbUSEQZJA/82lMaRwKYgXs88oenMdZM=;
  b=DsVJMp11B8CQhD+CGnqq6+xQlfMXuvDHfFVuoftPQfZndshqbyLTSip3
   Jk9HritI4P54FL+wDEhKwKWNd/1NxMpOh2ImTrk/mqIE2yOgi2xJi6Sqo
   i1gsLaoGsdnWpYQ6KU6jS4n7TIPBxGWAlfdwy/oyLye1Zk+ms92VW1dyi
   zQbRP5AkWrtFd8c4xzgv8GoQFpEJoBTJ9uGoj3nEBbLWSjHBUHe9bEHf3
   XmykhJJaxBEZu815XLQx26ezj/AByjBCECheMcKqg1uM6lF2m9IlnqEZM
   aaKDHtUIFeALsN2BwR2vBY4VaBymjOHcPOrO++O/I57fwCV3blgjtOzwt
   w==;
X-CSE-ConnectionGUID: dEJWkcWYS/i+Ao1lrOTi+g==
X-CSE-MsgGUID: OnoigWkvQ/2SXLUrQ394Sw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9848215"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9848215"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:04:51 -0700
X-CSE-ConnectionGUID: E/3EMOI/R+Sgsk9UxL7SMA==
X-CSE-MsgGUID: cP5IbvouRoCNFyo77NRAtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="24996896"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 05:04:49 -0700
Message-ID: <6ee5cb90-d299-4977-8a2f-529f78dc3913@intel.com>
Date: Thu, 25 Apr 2024 20:04:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock feature
 name
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Tim Wiederhake <twiederh@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
 <fb252e78-2e71-4422-9499-9eac69102eec@intel.com> <ZioDhpYUOEdGbWgE@intel.com>
 <eb5cfa25-6490-4b8d-8552-4be2662d15d2@intel.com> <ZiowbFCZ75LOgBMC@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZiowbFCZ75LOgBMC@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/2024 6:29 PM, Zhao Liu wrote:
> On Thu, Apr 25, 2024 at 04:40:10PM +0800, Xiaoyao Li wrote:
>> Date: Thu, 25 Apr 2024 16:40:10 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
>>   feature name
>>
>> On 4/25/2024 3:17 PM, Zhao Liu wrote:
>>> Hi Xiaoyao,
>>>
>>> On Wed, Apr 24, 2024 at 11:57:11PM +0800, Xiaoyao Li wrote:
>>>> Date: Wed, 24 Apr 2024 23:57:11 +0800
>>>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
>>>>    feature name
>>>>
>>>> On 3/29/2024 6:19 PM, Zhao Liu wrote:
>>>>> From: Zhao Liu <zhao1.liu@intel.com>
>>>>>
>>>>> Hi list,
>>>>>
>>>>> This series is based on Paolo's guest_phys_bits patchset [1].
>>>>>
>>>>> Currently, the old and new kvmclocks have the same feature name
>>>>> "kvmclock" in FeatureWordInfo[FEAT_KVM].
>>>>>
>>>>> When I tried to dig into the history of this unusual naming and fix it,
>>>>> I realized that Tim was already trying to rename it, so I picked up his
>>>>> renaming patch [2] (with a new commit message and other minor changes).
>>>>>
>>>>> 13 years age, the same name was introduced in [3], and its main purpose
>>>>> is to make it easy for users to enable/disable 2 kvmclocks. Then, in
>>>>> 2012, Don tried to rename the new kvmclock, but the follow-up did not
>>>>> address Igor and Eduardo's comments about compatibility.
>>>>>
>>>>> Tim [2], not long ago, and I just now, were both puzzled by the naming
>>>>> one after the other.
>>>>
>>>> The commit message of [3] said the reason clearly:
>>>>
>>>>     When we tweak flags involving this value - specially when we use "-",
>>>>     we have to act on both.
>>>>
>>>> So you are trying to change it to "when people want to disable kvmclock,
>>>> they need to use '-kvmclock,-kvmclock2' instead of '-kvmclock'"
>>>>
>>>> IMHO, I prefer existing code and I don't see much value of differentiating
>>>> them. If the current code puzzles you, then we can add comment to explain.
>>>
>>> It's enough to just enable kvmclock2 for Guest; kvmclock (old) is
>>> redundant in the presence of kvmclock2.
>>>
>>> So operating both feature bits at the same time is not a reasonable
>>> choice, we should only keep kvmclock2 for Guest. It's possible because
>>> the oldest linux (v4.5) which QEMU i386 supports has kvmclock2.
>>
>> who said the oldest Linux QEMU supports is from 4.5? what about 2.x kernel?
> 
> For Host (docs/system/target-i386.rst).
> 
>> Besides, not only the Linux guest, whatever guest OS is, it will be broken
>> if the guest is using kvmclock and QEMU starts to drop support of kvmclock.
> 
> I'm not aware of any minimum version requirements for Guest supported
> by KVM, but there are no commitment.

the common commitment is at least keeping backwards compatibility.

>> So, again, hard NAK to drop the support of kvmclock. It breaks existing
>> guests that use kvmclock. You cannot force people to upgrade their existing
>> VMs to use kvmclock2 instead of kvmclock.
> 
> I agree, legacy kvmclock can be left out, if the old kernel does not
> support kvmclock2 and strongly requires kvmclock, it can be enabled
> using 9.1 and earlier machines or legacy-kvmclock, as long as Host still
> supports it.
> 
> What's the gap in handling it this way? especially considering that
> kvmclock2 was introduced in v2.6.35, and earlier kernels are no longer
> maintained. The availability of the PV feature requires compatibility
> for both Host and Guest.
> 
> Anyway, the above discussion here is about future plans, and this series
> does not prevent any Guest from ignoring kvmclock2 in favor of kvmclock.
> 
> What this series is doing, i.e. separating the current two kvmclock and
> ensuring CPUID compatibility via legacy-kvmclock, could balance the
> compatibility requirements of the ancient (unmaintained kernel) with
> the need for future feature changes.

You introduce a user-visible change that people need to use 
"-kvmclock,-kvmclock2" to totally disable kvmclock.

The only difference between kvmclock and kvmclock2 is the MSR index. And 
from users' perspective, they don't care this difference. The existing 
usage is simple. When I want kvmclock, use "+kvmclock". When I don't 
want it, use "-kvmclock".

You are complicating things and I don't see a strong reason that we have 
to do it.

> Thanks,
> Zhao
> 


