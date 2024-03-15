Return-Path: <kvm+bounces-11884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E69787C89E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 06:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC2DB282E87
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 05:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC3E12E74;
	Fri, 15 Mar 2024 05:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkqJJJwX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4B12B6C;
	Fri, 15 Mar 2024 05:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710481848; cv=none; b=hX3XG8fuJKnizSSehWgRjPnKDTUi4b2a3+bEepWW0kE1UO7+fKkw44u5JgPGxC8FDnLoujbfAqN2/WEsKR8qjmDrgxidcZErxuRhFA5XL2uGjOU09mR0T+MSxG7owmomJPKSw75sZLnX6iFARHE3rLkj4zfr7SGFsk0SLXHdmHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710481848; c=relaxed/simple;
	bh=S0iZ55C9l1m73RLehXEmJUqcuecM8ZpLpZ+1VMipxEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLAY6zAVtm/TIB2UxQpY+FrqFR34MHw7sfClmjbN3pkn4qAnlio9oCF5rlIU/PnxaO222o0R8cFF2oZuI+aY2EJs+8EKFLJOQSsdTg1T7GN0EJv7AGC8tehihVSXqpcau5cfYAsExqgJ2VHuBOxznUHHIlf9Lzh8MpOqUqozDgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fkqJJJwX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710481847; x=1742017847;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S0iZ55C9l1m73RLehXEmJUqcuecM8ZpLpZ+1VMipxEQ=;
  b=fkqJJJwXvlaVl0FT8YL7aiQ5q3jF1xKTUpEJItAvwm9WuygOw4t5caw7
   SfKhgF/gb0f2xpGpk+ue/IATpPBk3kexrMnEmQ4gC0BvHAbXJMEubdBMQ
   zn1H3Pw8uPd9BSnvCRNDw8v0BSimvqJzrwo44EFJH04ESJYpoWeFYueI1
   zhnFxfRBTDMnmNehZnqZqXEZ7STSOMmD41CV8Q6pjUQ2rTHGv1MFjxAyi
   vB8mMwYPA8r6hl8c0t1r7JAuNkoRRaKfOpbKjzW+x7pAw4oCcoDZLhsjN
   +3mSRm/wpFwk5iZtEANBXfQxg2v8gJ1nPMZsJ+JAWbObZzHnbOZBJWf+2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="9118242"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="9118242"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 22:50:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="17284036"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 22:50:42 -0700
Message-ID: <0f20ffa7-63ac-4af2-8293-447dcae45eb7@intel.com>
Date: Fri, 15 Mar 2024 13:50:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Content-Language: en-US
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
 "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
 <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
 <aa1ed4c118177e3e341eebccecac3b07bf75a47d.camel@intel.com>
 <10c41a88-d692-4ff5-a0c3-ae13a06a055c@intel.com>
 <078ed2b1c3681c6c0ada9106d481d2f7d964815a.camel@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <078ed2b1c3681c6c0ada9106d481d2f7d964815a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/15/2024 1:39 PM, Huang, Kai wrote:
> On Fri, 2024-03-15 at 13:11 +0800, Li, Xiaoyao wrote:
>>> Here is what Isaku can do using the current API:
>>>
>>>   	u64 num_cpuid_config;
>>   >
>>>
>>>   	...
>>>
>>>   	tdx_sys_metadata_field_read(NUM_CPUID_CONFIG, &num_cpuid_config);
>>>
>>>   	tdx_info = kzalloc(calculate_tdx_info_size(num_cpuid_config), ...);
>>>
>>>   	tdx_info->num_cpuid_config = num_cpuid_config;
>>
>> Dosen't num_cpuid_config serve as temporary variable in some sense?
> 
> You need it, regardless whether it is u64 or u16.
> 
>>
>> For this case, it needs to be used for calculating the size of tdx_info.
>> So we have to have it. But it's not the common case.
>>
>> E.g., if we have another non-u64 field (e.g., field_x) in tdx_info, we
>> cannot to read it via
>>
>> 	tdx_sys_metadata_field_read(FIELD_X_ID, &tdx_info->field_x);
>>
>> we have to use a temporary u64 variable.
> 
> Let me repeat below in my _previous_ reply:
> 
> "
> One example that the current tdx_sys_metadata_field_read() doesn't quite fit is
> you have something like this:
> 
> 	struct {
> 		u16 whatever;
> 		...
> 	} st;
> 
> 	tdx_sys_metadata_field_read(FIELD_ID_WHATEVER, &st.whatever);
> 
> But for this use case you are not supposed to use tdx_sys_metadata_field_read(),
> but use tdx_sys_metadata_read() which has a mapping provided anyway.
> "

tdx_sys_metadata_read() is too complicated for just reading one field.

Caller needs to prepare a one-item size array of "struct 
tdx_metadata_field_mapping" and pass the correct offset.

> So sorry I am not seeing a real example from you.
> 


