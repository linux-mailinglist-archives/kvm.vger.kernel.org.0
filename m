Return-Path: <kvm+bounces-15895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFC48B1CF0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 10:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5885A1F233DB
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 08:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9D07FBA8;
	Thu, 25 Apr 2024 08:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lG5R9E/l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918647E59F
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 08:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714034418; cv=none; b=a5K4HU9fE5SXJwa1qtoLB8R0zK46qvoOpZXOZsj9WskjOBmtrDIIonIBogXwFRBSEtj2HAcmvvSgpOn/W0aAVt9DXtQ8c4rztSCHS1sQC+ZBAvd6mgXW815ZbPaofnI53tsYOzxcoFMxCgp57MIGM7Q1Zw7PokLi8DLdz5jMRmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714034418; c=relaxed/simple;
	bh=K/Cg5XtNto2C/13YZaMoG170H77iS2HAQOjxL3QuFD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ky/mJjTvar/YuCBQoir/JYETkr1PX2bWosxbnTQ5aVQ3WDBnuuwMfWnlUKkRXIoIDd07BjKrVXvjq6hb/VBk7tnYMY8w/4SWUi039AUp0RqkO4+uKDxPOhot7qCBNMrELvKnARBxy6z5oUChcYYjXWV8M2yvtSdKyN1zcf5jrXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lG5R9E/l; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714034417; x=1745570417;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K/Cg5XtNto2C/13YZaMoG170H77iS2HAQOjxL3QuFD8=;
  b=lG5R9E/lKd7syn6uSZ/v9xIo2Txp/KhHSkdZXFS4yRJy86K8pTsvdqlM
   VIBxJE6vV7y5XUItjMNl7M6kLUlbi9F0PI32fdNBGYPHnPNBvP4KOl7Ut
   RtxhAWm40XslbGjBAWkfzdrgHtOYvImJT6T/P8MaAjtmNW5yOPkOVv0x+
   3vNoQ1IQg6fi9QJuDaw5rypwOfcCXwv8sBsdooq5Kx7joLY+Kf2s0RUUI
   2wfiphPyY6fq7H9hFo9K6G94z7E+b9RMNQYISG8pa/mOADojzcv0GJqzb
   gyt7SgbKSgQf7LjWXJ9odbJGDKiGsAiVxjFmHgvqeI7bwLCeT/QXcJNZp
   A==;
X-CSE-ConnectionGUID: w0GTRqZ4QZK1P2zPsXiZYw==
X-CSE-MsgGUID: MxM/utbWTOuJqB4JJrx8Fw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9570767"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="9570767"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 01:40:16 -0700
X-CSE-ConnectionGUID: BY6rdOebSoCkhZNBuGSy/g==
X-CSE-MsgGUID: BavTUoOpSpK1M8a6krZjOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="29630606"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 01:40:12 -0700
Message-ID: <eb5cfa25-6490-4b8d-8552-4be2662d15d2@intel.com>
Date: Thu, 25 Apr 2024 16:40:10 +0800
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZioDhpYUOEdGbWgE@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/2024 3:17 PM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
> On Wed, Apr 24, 2024 at 11:57:11PM +0800, Xiaoyao Li wrote:
>> Date: Wed, 24 Apr 2024 23:57:11 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
>>   feature name
>>
>> On 3/29/2024 6:19 PM, Zhao Liu wrote:
>>> From: Zhao Liu <zhao1.liu@intel.com>
>>>
>>> Hi list,
>>>
>>> This series is based on Paolo's guest_phys_bits patchset [1].
>>>
>>> Currently, the old and new kvmclocks have the same feature name
>>> "kvmclock" in FeatureWordInfo[FEAT_KVM].
>>>
>>> When I tried to dig into the history of this unusual naming and fix it,
>>> I realized that Tim was already trying to rename it, so I picked up his
>>> renaming patch [2] (with a new commit message and other minor changes).
>>>
>>> 13 years age, the same name was introduced in [3], and its main purpose
>>> is to make it easy for users to enable/disable 2 kvmclocks. Then, in
>>> 2012, Don tried to rename the new kvmclock, but the follow-up did not
>>> address Igor and Eduardo's comments about compatibility.
>>>
>>> Tim [2], not long ago, and I just now, were both puzzled by the naming
>>> one after the other.
>>
>> The commit message of [3] said the reason clearly:
>>
>>    When we tweak flags involving this value - specially when we use "-",
>>    we have to act on both.
>>
>> So you are trying to change it to "when people want to disable kvmclock,
>> they need to use '-kvmclock,-kvmclock2' instead of '-kvmclock'"
>>
>> IMHO, I prefer existing code and I don't see much value of differentiating
>> them. If the current code puzzles you, then we can add comment to explain.
> 
> It's enough to just enable kvmclock2 for Guest; kvmclock (old) is
> redundant in the presence of kvmclock2.
> 
> So operating both feature bits at the same time is not a reasonable
> choice, we should only keep kvmclock2 for Guest. It's possible because
> the oldest linux (v4.5) which QEMU i386 supports has kvmclock2.

who said the oldest Linux QEMU supports is from 4.5? what about 2.x kernel?

Besides, not only the Linux guest, whatever guest OS is, it will be 
broken if the guest is using kvmclock and QEMU starts to drop support of 
kvmclock.

So, again, hard NAK to drop the support of kvmclock. It breaks existing 
guests that use kvmclock. You cannot force people to upgrade their 
existing VMs to use kvmclock2 instead of kvmclock.

> Pls see:
> https://elixir.bootlin.com/linux/v4.5/source/arch/x86/include/uapi/asm/kvm_para.h#L22
> 
> With this in mind, I'm trying to implement a silky smooth transition to
> "only kcmclock2 support".
> 
> This series is now separating kvmclock and kvmclock2, and then I plan to
> go to the KVM side and deprecate kvmclock2, and then finally remove
> kvmclock (old) in QEMU. Separating the two features makes the process
> clearer.
> 
> Continuing to use the same name equally would have silently caused the
> CPUID to change on the Guest side, which would have hurt compatibility
> as well.
> 
>>> So, this series is to push for renaming the new kvmclock feature to
>>> "kvmclock2" and adding compatibility support for older machines (PC 9.0
>>> and older).
>>>
>>> Finally, let's put an end to decades of doubt about this name.
>>>
>>>
>>> Next Step
>>> =========
>>>
>>> This series just separates the two kvmclocks from the naming, and in
>>> subsequent patches I plan to stop setting kvmclock(old kcmclock) by
>>> default as long as KVM supports kvmclock2 (new kvmclock).
>>
>> No. It will break existing guests that use KVM_FEATURE_CLOCKSOURCE.
> 
> Please refer to my elaboration on v4.5 above, where kvmclock2 is
> available, it should be used in priority.
> 
>>> Also, try to deprecate the old kvmclock in KVM side.
>>>
>>> [1]: https://lore.kernel.org/qemu-devel/20240325141422.1380087-1-pbonzini@redhat.com/
>>> [2]: https://lore.kernel.org/qemu-devel/20230908124534.25027-4-twiederh@redhat.com/
>>> [3]: https://lore.kernel.org/qemu-devel/1300401727-5235-3-git-send-email-glommer@redhat.com/
>>> [4]: https://lore.kernel.org/qemu-devel/1348171412-23669-3-git-send-email-Don@CloudSwitch.com/
> 
> Thanks,
> Zhao
> 
> 


