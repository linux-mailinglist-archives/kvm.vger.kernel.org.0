Return-Path: <kvm+bounces-32987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 933239E33BF
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 07:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9C9E284FEA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 06:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA4118A92C;
	Wed,  4 Dec 2024 06:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PdcTnbkt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060C94A33;
	Wed,  4 Dec 2024 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733295456; cv=none; b=b09+BucWUCc217SgYd7HIQlsSPAtoa8D5fQqPG3EyAMnh6DPPYjsz+zfieymQ2pwZrFAvsv7WA7f3aCFQK62saQt89sW39ukFSvJLwiTXhX3TEhunYp1BCCkP7UaMAQHVNLHt4Rd1zQ2vYJ+MG9REka1XVJkGfjQj66isG5+T1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733295456; c=relaxed/simple;
	bh=unW9c3b8w97RuIQaYDhvSoZuXkNfKWuuuAg0Qb1R2ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAfTvOOQvQIrlrr/kLYrIC0fIoylUaukpypM8Fxi0KBajBjNSN13vChiARRZT2bDDjcOs94gdHPrzFJhP877EouBzuyTtPRaf7b3V4KECuJqXA8wWW/iAsIQPyH+M4a6etLxfBISP36gMCwJ7f1CoRW2yo5U1nA+ruJ+zGEXAE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PdcTnbkt; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733295455; x=1764831455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=unW9c3b8w97RuIQaYDhvSoZuXkNfKWuuuAg0Qb1R2ek=;
  b=PdcTnbkt+bNp3kjesJ3z914Iu4jnRBAaxXGL9+l7nJPWoa/cbgs8gECm
   MinC14dQ789vGEvAkFfc9y174XE5oIAsHpsF7kt5T7vbf+htPBOLmmu1L
   7FKIpEoe9aIZpWx30bfsdQgw53Zi7l9FHiVQw/IPlmgphbYoNUez/q5y5
   VtOEvAAVImTcb6j7a4bRU7RAcimNU9qc29KhV6+D8S4DznMh3ozf5OJfp
   gfOiumIwncIqrPnrS91WJi6Hd6QiDvW6mTOC3W6FRU+e9VgzcB7O6fsne
   RxQAXz0aCosNlkyZx2XDHi5MoeehcS95DVojrV+hqXC8HIKOfMM/tMQT4
   w==;
X-CSE-ConnectionGUID: TGOiiXt/Rtys4iUviAHwhA==
X-CSE-MsgGUID: ir+kIgGlRGeI8+1bI+MRWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="32886469"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="32886469"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 22:57:33 -0800
X-CSE-ConnectionGUID: 2TQO+xD8SqS/8izJg33gOQ==
X-CSE-MsgGUID: vBGKPLjoT+m6BImqRVlR3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="124604473"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 22:57:28 -0800
Message-ID: <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com>
Date: Wed, 4 Dec 2024 08:57:23 +0200
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
References: <Zz/6NBmZIcRUFvLQ@intel.com> <Z0cmEd5ehnYT8uc-@google.com>
 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com> <Z0+vdVRptHNX5LPo@intel.com>
 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com> <Z0/4wsR2WCwWfZyV@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0/4wsR2WCwWfZyV@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 08:37, Chao Gao wrote:
> On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>> On 4/12/24 03:25, Chao Gao wrote:
>>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>>> +
>>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>> +	       (entry->ebx & TDX_FEATURE_TSX);
>>>> +}
>>>> +
>>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>>>> +}
>>>> +
>>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	return entry->function == 7 && entry->index == 0 &&
>>>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>>> +}
>>>> +
>>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>>> +}
>>>> +
>>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	if (has_tsx(entry))
>>>> +		clear_tsx(entry);
>>>> +
>>>> +	if (has_waitpkg(entry))
>>>> +		clear_waitpkg(entry);
>>>> +}
>>>> +
>>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>>> +{
>>>> +	return has_tsx(entry) || has_waitpkg(entry);
>>>> +}
>>>
>>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>>> ensures that unconfigurable bits are not set by userspace.
>>
>> Aren't they configurable?
> 
> They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
> so they are not configurable from a userspace perspective. Did I miss anything?
> KVM should check user inputs against its adjusted configurable bitmap, right?

Maybe I misunderstand but we rely on the TDX module to reject
invalid configuration.  We don't check exactly what is configurable
for the TDX Module.

TSX and WAITPKG are not invalid for the TDX Module, but KVM
must either support them by restoring their MSRs, or disallow
them.  This patch disallows them for now.

> 
>>
>>>
>>>> +
>>>> #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>>>>
>>>> static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
>>>> @@ -124,6 +162,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
>>>> 	/* Work around missing support on old TDX modules */
>>>> 	if (entry->function == 0x80000008)
>>>> 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
>>>> +
>>>> +	tdx_clear_unsupported_cpuid(entry);
>>>> }
>>>>
>>>> static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>>>> @@ -1235,6 +1275,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>>>> 		if (!entry)
>>>> 			continue;
>>>>
>>>> +		if (tdx_unsupported_cpuid(entry))
>>>> +			return -EINVAL;
>>>> +
>>>> 		copy_cnt++;
>>>>
>>>> 		value = &td_params->cpuid_values[i];
>>>> -- 
>>>> 2.43.0
>>>>
>>


