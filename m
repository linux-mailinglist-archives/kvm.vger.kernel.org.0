Return-Path: <kvm+bounces-33041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C58B19E3F9F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:27:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 021CEB3B00B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DEA20C02E;
	Wed,  4 Dec 2024 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDg5xCTH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF53187561;
	Wed,  4 Dec 2024 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733326409; cv=none; b=VRYdY5uuVkN8cNavJRxyDCbyrsBFqhhpiacSvbxh0onS/yYveh53Ig/TWjd1cztuVaXG5TwnqySmDIh8pqZ+pE3c81TEysqYmQMHfyyImFT2q7rMzT4V0MTrM1sqHo7BUOaJ4WT6YSSg9W0+foflUXjux/W/DVcsY5d3+DV5v6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733326409; c=relaxed/simple;
	bh=sP2tlIplVJ2QVwFXPlzFGcliFejTYrT+QehRMwauIDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n7K9O769izCfo9h9bAXfAhpOihhCWJJQlcqJdTIdszqzJPPhq/UeeETc7Xad8bsC5egD6yfRJggehaYpuJSnRo16j+ZlGcBYpXuMQG8cEAjCa12cXWqOviOpTSD1PASgx/GNsNqV27vRh1a93taCwfazWjYMGZQO6AsTaGdAnX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDg5xCTH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733326408; x=1764862408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sP2tlIplVJ2QVwFXPlzFGcliFejTYrT+QehRMwauIDw=;
  b=DDg5xCTHrmXvkKWuViQyfqlGgCIfJ1Zi30kSNP+uabKFt/TTznljFhWF
   /+z5J0jIGJ2NiZoJa5PHb7D8Fa5isiy6jZSEdsBG6wzrjlSogzD0sAikr
   ULlzh85rJAa4CVVXilUXKhZRE9/uHjaKC/Yv0dBQmb/cfkhZ5cdfwf3fz
   8zRCK1VaRDOYic+AHYvVhRlLk6XhUj/MV98BMF+LAKUMmiewbyiRuz9oi
   DF0FZGzdeGxOMpMoX3QkW1Z/uxTcLt2Lhlwv0mkORJFoY5cXHudwf1ANx
   hrDfEW2VRuSKq45QCdeE2Sps9zpQW+u5iTmiH1sPBFfuFkTwJEauq39pQ
   Q==;
X-CSE-ConnectionGUID: h1tf6xtPSB+U4viaVaTuKw==
X-CSE-MsgGUID: DGXqXhbWSdq2zeg+QO7vrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33846356"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="33846356"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 07:33:27 -0800
X-CSE-ConnectionGUID: yD4DljVcRza+lA1wwx98FQ==
X-CSE-MsgGUID: BKnKBe7VQ9aym5aG7iV7Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93479977"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 07:33:23 -0800
Message-ID: <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
Date: Wed, 4 Dec 2024 23:33:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: Adrian Hunter <adrian.hunter@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Huang, Kai"
 <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yang, Weijiang" <weijiang.yang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com> <Z0+vdVRptHNX5LPo@intel.com>
 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com> <Z0/4wsR2WCwWfZyV@intel.com>
 <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com> <Z1A5QWaTswaQyE3k@intel.com>
 <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/2024 7:55 PM, Adrian Hunter wrote:
> On 4/12/24 13:13, Chao Gao wrote:
>> On Wed, Dec 04, 2024 at 08:57:23AM +0200, Adrian Hunter wrote:
>>> On 4/12/24 08:37, Chao Gao wrote:
>>>> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>>>>> On 4/12/24 03:25, Chao Gao wrote:
>>>>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>>>>> +
>>>>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>>>> +	       (entry->ebx & TDX_FEATURE_TSX);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>>>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	if (has_tsx(entry))
>>>>>>> +		clear_tsx(entry);
>>>>>>> +
>>>>>>> +	if (has_waitpkg(entry))
>>>>>>> +		clear_waitpkg(entry);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>>>>> +{
>>>>>>> +	return has_tsx(entry) || has_waitpkg(entry);
>>>>>>> +}
>>>>>>
>>>>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>>>>> ensures that unconfigurable bits are not set by userspace.
>>>>>
>>>>> Aren't they configurable?
>>>>
>>>> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
>>>> so they are not configurable from a userspace perspective. Did I miss anything?
>>>> KVM should check user inputs against its adjusted configurable bitmap, right?
>>>
>>> Maybe I misunderstand but we rely on the TDX module to reject
>>> invalid configuration.  We don't check exactly what is configurable
>>> for the TDX Module.
>>
>> Ok, this is what I missed. I thought KVM validated user input and masked
>> out all unsupported features. sorry for this.
>>
>>>
>>> TSX and WAITPKG are not invalid for the TDX Module, but KVM
>>> must either support them by restoring their MSRs, or disallow
>>> them.  This patch disallows them for now.
>>
>> Yes. I agree. what if a new feature (supported by a future TDX module) also
>> needs KVM to restore some MSRs? current KVM will allow it to be exposed (since
>> only TSX/WAITPKG are checked); then some MSRs may get corrupted. I may think
>> this is not a good design. Current KVM should work with future TDX modules.
> 
> With respect to CPUID, I gather this kind of thing has been
> discussed, such as here:
> 
> 	https://lore.kernel.org/all/ZhVsHVqaff7AKagu@google.com/
> 
> and Rick and Xiaoyao are working on something.
> 
> In general, I would expect a new TDX Module would advertise support for
> new features, but KVM would have to opt in to use them.
> 

There were discussion[1] on whether KVM to gatekeep the 
configurable/supported CPUIDs for TDX. I stand by Sean that KVM needs to 
do so.

Regarding KVM opt in the new feature, KVM gatekeeps the CPUID bit that 
can be set by userspace is exactly the behavior of opt-in. i.e., for a 
given KVM, it only allows a CPUID set {S} to be configured by userspace, 
if new TDX module supports new feature X, it needs KVM to opt-in X by 
adding X to {S} so that X is allowed to be configured by userspace.

Besides, I find current interface between KVM and userspace lacks the 
ability to tell userspace what bits are not supported by KVM. 
KVM_TDX_CAPABILITIES.cpuid doesn't work because it represents the 
configurable CPUIDs, not supported CPUIDs (I think we might rename it to 
configurable_cpuid to better reflect its meaning). So userspace has to 
hardcode that TSX and WAITPKG is not support itself.

[1] https://lore.kernel.org/all/ZuM12EFbOXmpHHVQ@google.com/


