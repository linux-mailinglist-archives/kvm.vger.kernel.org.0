Return-Path: <kvm+bounces-33169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D559E5D2A
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA71A16CABB
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DB4221479;
	Thu,  5 Dec 2024 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hgWpNxCa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5F121CA1F;
	Thu,  5 Dec 2024 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419901; cv=none; b=Fm9Ze/cMPV1ZrPv7ij3DUlsCn2NkwKAqtCidXdaBk0fMzLQXZHnkID/7ej2uhPrsvqMyhBFzMykDySDTNwu7NqmfVRIbzbreKghAKRT6BFP+t/ShNh9uw8p/NFRGPDc2VF7p1rEZpGf0t3zuwVLOl95dCYcUN5nIQqrIUkyLwXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419901; c=relaxed/simple;
	bh=Roia4+bGGz4hZSc613oUJkQPb8sWQxayVY6u6/Nenbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YL1ksVr7glSng3RMi+m/al8WSf1eIqQoSKR/HIoIhzbPMnt4QWQjdmbosI5TYRJhh38gQEqT1yVrHMLKchtMI1RdMFqYUdtaQvaO1IGSzU+ScrBfOvIDmNKvaM4OBindA6HkCPeUyeZfgDSN0WZVobYiRrdAuGSNh053ojFeCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hgWpNxCa; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733419900; x=1764955900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Roia4+bGGz4hZSc613oUJkQPb8sWQxayVY6u6/Nenbw=;
  b=hgWpNxCa4rStFUhguvETtmh5SEa4KQy95lazL9Y8hFZbW+GZFqF44L28
   wGURLIDxPBAvZZuFVrfDcLJMg8mLDl/dSOP9VXPO4B4NqDQK0J1FugxJW
   vR/HCJXiXHNpITm0j5g4hzSKdmFpyRhxRc0/tioaP1cLjpmwtkrClWIlN
   g6CPFCScz+WPTWX6OSK4Z15Vwd+8Mh+6tqzfV9BgDm7k6vLYuMNgzDuCM
   OrACvsBIM3E9/ku927/PMu/3hmlDgGH7MN7w2g+4qFYyLYJksCE1q5xOm
   DLmqc7HntUs1G8KFDfWFkhYnDmcSZp94JJ1lcmxytmpJfOSFWy3YGbeVy
   g==;
X-CSE-ConnectionGUID: cNvLP8mHRseJVjTSrTHyZg==
X-CSE-MsgGUID: yFGo+MbgQumOlf9BO5Y9fg==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="33875866"
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="33875866"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 09:31:35 -0800
X-CSE-ConnectionGUID: BIeGtjC2S+KL2WTcbinNHg==
X-CSE-MsgGUID: IHM5saPuTI2L3Jl8d7cH+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="117398990"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 09:31:28 -0800
Message-ID: <84964644-e53f-4aac-b827-5626393f8c25@intel.com>
Date: Thu, 5 Dec 2024 19:31:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>
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
 <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <a005d50c-6ca8-4572-80ba-5207b95323fb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/12/24 17:33, Xiaoyao Li wrote:
> On 12/4/2024 7:55 PM, Adrian Hunter wrote:
>> On 4/12/24 13:13, Chao Gao wrote:
>>> On Wed, Dec 04, 2024 at 08:57:23AM +0200, Adrian Hunter wrote:
>>>> On 4/12/24 08:37, Chao Gao wrote:
>>>>> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>>>>>> On 4/12/24 03:25, Chao Gao wrote:
>>>>>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>>>>>> +
>>>>>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    return entry->function == 7 && entry->index == 0 &&
>>>>>>>> +           (entry->ebx & TDX_FEATURE_TSX);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    entry->ebx &= ~TDX_FEATURE_TSX;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    return entry->function == 7 && entry->index == 0 &&
>>>>>>>> +           (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    if (has_tsx(entry))
>>>>>>>> +        clear_tsx(entry);
>>>>>>>> +
>>>>>>>> +    if (has_waitpkg(entry))
>>>>>>>> +        clear_waitpkg(entry);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>>>>>> +{
>>>>>>>> +    return has_tsx(entry) || has_waitpkg(entry);
>>>>>>>> +}
>>>>>>>
>>>>>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>>>>>> ensures that unconfigurable bits are not set by userspace.
>>>>>>
>>>>>> Aren't they configurable?
>>>>>
>>>>> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
>>>>> so they are not configurable from a userspace perspective. Did I miss anything?
>>>>> KVM should check user inputs against its adjusted configurable bitmap, right?
>>>>
>>>> Maybe I misunderstand but we rely on the TDX module to reject
>>>> invalid configuration.  We don't check exactly what is configurable
>>>> for the TDX Module.
>>>
>>> Ok, this is what I missed. I thought KVM validated user input and masked
>>> out all unsupported features. sorry for this.
>>>
>>>>
>>>> TSX and WAITPKG are not invalid for the TDX Module, but KVM
>>>> must either support them by restoring their MSRs, or disallow
>>>> them.  This patch disallows them for now.
>>>
>>> Yes. I agree. what if a new feature (supported by a future TDX module) also
>>> needs KVM to restore some MSRs? current KVM will allow it to be exposed (since
>>> only TSX/WAITPKG are checked); then some MSRs may get corrupted. I may think
>>> this is not a good design. Current KVM should work with future TDX modules.
>>
>> With respect to CPUID, I gather this kind of thing has been
>> discussed, such as here:
>>
>>     https://lore.kernel.org/all/ZhVsHVqaff7AKagu@google.com/
>>
>> and Rick and Xiaoyao are working on something.
>>
>> In general, I would expect a new TDX Module would advertise support for
>> new features, but KVM would have to opt in to use them.
>>
> 
> There were discussion[1] on whether KVM to gatekeep the configurable/supported CPUIDs for TDX. I stand by Sean that KVM needs to do so.
> 
> Regarding KVM opt in the new feature, KVM gatekeeps the CPUID bit that can be set by userspace is exactly the behavior of opt-in. i.e., for a given KVM, it only allows a CPUID set {S} to be configured by userspace, if new TDX module supports new feature X, it needs KVM to opt-in X by adding X to {S} so that X is allowed to be configured by userspace.
> 
> Besides, I find current interface between KVM and userspace lacks the ability to tell userspace what bits are not supported by KVM. KVM_TDX_CAPABILITIES.cpuid doesn't work because it represents the configurable CPUIDs, not supported CPUIDs (I think we might rename it to configurable_cpuid to better reflect its meaning). So userspace has to hardcode that TSX and WAITPKG is not support itself.

I don't follow why hardcoding would be necessary.

If the leaf is represented in KVM_TDX_CAPABILITIES.cpuid, and
the bits are 0 there, why would userspace try to set them to 1?

> 
> [1] https://lore.kernel.org/all/ZuM12EFbOXmpHHVQ@google.com/
> 


