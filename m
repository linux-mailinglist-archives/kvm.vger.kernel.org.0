Return-Path: <kvm+bounces-33008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EE99E3950
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B194C285037
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F76D1B414E;
	Wed,  4 Dec 2024 11:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LhHOq0/P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5A11ABEDC;
	Wed,  4 Dec 2024 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733313346; cv=none; b=Rfiatvw26EicdzAjWjhHH3HxuvXLpxXX/lt0/gRuXL8Q34hKoYbdT0gu+qSpRv5IbWhMNt/OvywY9MX8O9EK4P0CnbMZ7frkOEhKF5GCSHCopaJxOYDeamzXiELUidx5+GPKGI+EaatYUTM6HEh92HcJJPb4O9fFb90oNx4m4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733313346; c=relaxed/simple;
	bh=oscURUXw+fmOxFAxom/IqF5tJkXEvSnHpzBCBlzL+iA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sreYimPpNOoBzw5BttvR/GZMNRTxBUsE3mDyxD1SoAWxPcEtsZMVk6GzwfryGStnyXoz4S/Z8dbn+PSZPmghZ7dvOnbVFitSxUq0InOj1hp6qP6kn4EPbK26dgF/33RjS/IdjM1KECQoBL2OOC5N+ZY2NOygVzTvNorftv1GYNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LhHOq0/P; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733313344; x=1764849344;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oscURUXw+fmOxFAxom/IqF5tJkXEvSnHpzBCBlzL+iA=;
  b=LhHOq0/P6vaNAKV+/C76FZFD6AbO7J3TtEYJsljjwOLewiKZehQmVLHr
   Slx2+JZ6J5M1LQJ2GVmyb4dXXiDwKg6UaayUDhjugq9PiH5wLDlA3VMVa
   Fh6kyqZVf1mk34CYP5S+lePUnq5uYHe53UceoF+5GfuzCSAIsFKZza7Hy
   r1qJF5mNPMYEAJTygbrmMpbI8KFwfv/hQMxsmnzK6z3voFIioq+zerAf2
   Z6bwD20SkR21DT20DIR7vYAznZoOHerV+AS5S3sMbCOVxacblZ9M6ca7h
   ULZ4RhDmY2VL1l+97KIagOxtjO1gqT1/AztL9m/s0aR5pa7oHQnNgFuh+
   A==;
X-CSE-ConnectionGUID: 1KE7cLBjSseRGPKSbJ79cQ==
X-CSE-MsgGUID: rmX3sCUBRHCMOPjEvRoEzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="44237660"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="44237660"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 03:55:43 -0800
X-CSE-ConnectionGUID: yH2OLVC8QDq+3rAeVnsS5w==
X-CSE-MsgGUID: Yl2Uhi9tSDGdTBOhrOfOgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="131196830"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 03:55:38 -0800
Message-ID: <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
Date: Wed, 4 Dec 2024 13:55:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
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
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z1A5QWaTswaQyE3k@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 13:13, Chao Gao wrote:
> On Wed, Dec 04, 2024 at 08:57:23AM +0200, Adrian Hunter wrote:
>> On 4/12/24 08:37, Chao Gao wrote:
>>> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>>>> On 4/12/24 03:25, Chao Gao wrote:
>>>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>>>> +
>>>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>>> +	       (entry->ebx & TDX_FEATURE_TSX);
>>>>>> +}
>>>>>> +
>>>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>>>>>> +}
>>>>>> +
>>>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>>>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>>>> +}
>>>>>> +
>>>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>>>> +}
>>>>>> +
>>>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	if (has_tsx(entry))
>>>>>> +		clear_tsx(entry);
>>>>>> +
>>>>>> +	if (has_waitpkg(entry))
>>>>>> +		clear_waitpkg(entry);
>>>>>> +}
>>>>>> +
>>>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>>>> +{
>>>>>> +	return has_tsx(entry) || has_waitpkg(entry);
>>>>>> +}
>>>>>
>>>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>>>> ensures that unconfigurable bits are not set by userspace.
>>>>
>>>> Aren't they configurable?
>>>
>>> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
>>> so they are not configurable from a userspace perspective. Did I miss anything?
>>> KVM should check user inputs against its adjusted configurable bitmap, right?
>>
>> Maybe I misunderstand but we rely on the TDX module to reject
>> invalid configuration.  We don't check exactly what is configurable
>> for the TDX Module.
> 
> Ok, this is what I missed. I thought KVM validated user input and masked
> out all unsupported features. sorry for this.
> 
>>
>> TSX and WAITPKG are not invalid for the TDX Module, but KVM
>> must either support them by restoring their MSRs, or disallow
>> them.  This patch disallows them for now.
> 
> Yes. I agree. what if a new feature (supported by a future TDX module) also
> needs KVM to restore some MSRs? current KVM will allow it to be exposed (since
> only TSX/WAITPKG are checked); then some MSRs may get corrupted. I may think
> this is not a good design. Current KVM should work with future TDX modules.

With respect to CPUID, I gather this kind of thing has been
discussed, such as here:

	https://lore.kernel.org/all/ZhVsHVqaff7AKagu@google.com/

and Rick and Xiaoyao are working on something.

In general, I would expect a new TDX Module would advertise support for
new features, but KVM would have to opt in to use them.


