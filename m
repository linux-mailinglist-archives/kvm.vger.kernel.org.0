Return-Path: <kvm+bounces-32985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B23BD9E337F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 07:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D557163541
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 06:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E6C188580;
	Wed,  4 Dec 2024 06:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AkmCkdUi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD4136E;
	Wed,  4 Dec 2024 06:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733293128; cv=none; b=W6GNRUgeJqvDfVTXoUc3I/p6fktJVNKs6SnzOYQa2DSKJQIuWQQVKV9QIfGa5PHtZcLJLkRNpV00szS3sCjWORTaNaoprXz20xeVbinwbEDoCOWPbiX33eTrkSpGeJe64hEKEeFOS9y5RZ6h+xiyi3onruFDeZG7IZkjjCbC5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733293128; c=relaxed/simple;
	bh=wkwF94JJrTUykxOMcrQEFnN5xQ3df8+XZWvRqvsXWgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h++29FWHuSdEBwhvpgALTI1/MTlHvuBhPBm4gjxLnNRLFbebZWRhYIl0eNFFI/c/08+9v0ddL2InwzedvKU3RFmsk5tt8pr2NEkhkPN3ZHi/GxXgVTkoH8VgGtTlJl0fGlcKifha+l8JlhhtDNuVB0+0ISieOSPi76JGI9dCvP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AkmCkdUi; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733293126; x=1764829126;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wkwF94JJrTUykxOMcrQEFnN5xQ3df8+XZWvRqvsXWgM=;
  b=AkmCkdUixU/HaxYZbBJXlLlX2kPipPu5IYlPUTcUG3onJb0jSW2sHvo/
   U/00srY+cjExaOPZRHRM6o9FhyUDwVs3xlavq7Yka5Z7hDxQQBiUQpqj8
   c0rOBOtFkaX8WfYLa58h9M45lRWJXGKW6Bb2ls7ol5CdbKUKiwYJSI36v
   /xotRiNTc295xhhfOCIp2P6B8RRqOhnx5kZHaDlSpr8FGt3gvuTDWtNNh
   GjNTWcfsXRPtdAhhNQEWxxCs6Kqdx/P+ASSMRkpvLz5tCBQNIiFhcz/NM
   CxBpnUvD/CkEpvVPJx0hs/573z5XjhYqDGxVrYF8XyWd9/q0jJ3qYQl2q
   A==;
X-CSE-ConnectionGUID: ZjLH7WLeThyvKJxTnPVOzA==
X-CSE-MsgGUID: /CYDAiVQT32zdRpBTxy4Uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33462629"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="33462629"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 22:18:45 -0800
X-CSE-ConnectionGUID: VfUj9FBaRQ6caCnfy36SKQ==
X-CSE-MsgGUID: V/7TsNY7TO25KfOb1u8N/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98684268"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 22:18:39 -0800
Message-ID: <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
Date: Wed, 4 Dec 2024 08:18:32 +0200
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
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com> <Zz/6NBmZIcRUFvLQ@intel.com>
 <Z0cmEd5ehnYT8uc-@google.com>
 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com> <Z0+vdVRptHNX5LPo@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z0+vdVRptHNX5LPo@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 03:25, Chao Gao wrote:
>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>> +
>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>> +{
>> +	return entry->function == 7 && entry->index == 0 &&
>> +	       (entry->ebx & TDX_FEATURE_TSX);
>> +}
>> +
>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>> +{
>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>> +}
>> +
>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>> +{
>> +	return entry->function == 7 && entry->index == 0 &&
>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>> +}
>> +
>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>> +{
>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>> +}
>> +
>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>> +{
>> +	if (has_tsx(entry))
>> +		clear_tsx(entry);
>> +
>> +	if (has_waitpkg(entry))
>> +		clear_waitpkg(entry);
>> +}
>> +
>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>> +{
>> +	return has_tsx(entry) || has_waitpkg(entry);
>> +}
> 
> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
> ensures that unconfigurable bits are not set by userspace.

Aren't they configurable?

> 
>> +
>> #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>>
>> static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
>> @@ -124,6 +162,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
>> 	/* Work around missing support on old TDX modules */
>> 	if (entry->function == 0x80000008)
>> 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
>> +
>> +	tdx_clear_unsupported_cpuid(entry);
>> }
>>
>> static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>> @@ -1235,6 +1275,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>> 		if (!entry)
>> 			continue;
>>
>> +		if (tdx_unsupported_cpuid(entry))
>> +			return -EINVAL;
>> +
>> 		copy_cnt++;
>>
>> 		value = &td_params->cpuid_values[i];
>> -- 
>> 2.43.0
>>


