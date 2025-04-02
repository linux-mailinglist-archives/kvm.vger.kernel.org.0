Return-Path: <kvm+bounces-42469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C01DA78F95
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFDC47A2DD1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 13:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5E323A986;
	Wed,  2 Apr 2025 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQHr9KMs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF455BAF0;
	Wed,  2 Apr 2025 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743599810; cv=none; b=V7cnLnKIs3M+BD/+9C6AuL61XbtumP5B/bzlsYhJdT0Oe0dnjCmyV2+YU17Ue+QJB3k7DQfmmtkkFrs3GOGlKUDFjReCltQ6Lukq8hoF9PxYgHR5AyIxcTXYusBG9bzPN60SwpH/s5oVrtLhTxofD7h18/4AurYH5BtbFF1KO9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743599810; c=relaxed/simple;
	bh=d6hmBXGp60mn5wwqyak2KqVoDBzb+Wvc5pH1eYeHxRk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=q85MQDJBCV9adRiBVxysD3YpLpOW3WwZz2oHhC0puGS0tifxibBIyFp69rFlg6rQHjV6uwwfdLMGVvMRLbl+HWOGoYfLT5TEbPviHK0wNvBdeIxjanJgbRlS+Q/y05XGdSd98p9hFF/BTEGJuHPMB8j35R1IfUEiADXyXIRA2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQHr9KMs; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743599809; x=1775135809;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=d6hmBXGp60mn5wwqyak2KqVoDBzb+Wvc5pH1eYeHxRk=;
  b=SQHr9KMsAKzLxzuOLRI8htdJGT9RiiM14CU2sCDGdRqf0Qf9OTPGMzEu
   OfiTaKd6m9Vf8d98pCrn25HYc7ytSgmidikDn6NT6XzduzqOx2l0Teqet
   c0PuXD05XR/E+kWhLTuutc/SQ1VzCf+Er3mvna1MLL++ISkDK+DLOqCqu
   TEZBu3/DUhRLV/90GILu3/wyX0nJHhCDD1v5b980LkKF1lrGB6yMWk8HC
   Bf8wdXGejLc8wiCCYpaNnV9oRZJiJUL5bgiG1Cas0RTwlSm9TBO7z8wXq
   mqUj4gf1B20GjhyUM+ftpqgN0iLIibpwfR6iCAa9kY9+tThpA8kTjMYKZ
   A==;
X-CSE-ConnectionGUID: c5w/VMHOTt2PPFi4tWr+qQ==
X-CSE-MsgGUID: Z4Csxq5PSLaQWVvjP5Nyrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="48754119"
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="48754119"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 06:16:48 -0700
X-CSE-ConnectionGUID: 5ffR5GaDTPGXMcp6iElOvw==
X-CSE-MsgGUID: OO1lkGRYRt6fn6XYmVXsKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="131825882"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.208]) ([10.124.242.208])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 06:16:44 -0700
Message-ID: <c96f2ed1-1c7f-4b61-85ff-902e08c61fbc@linux.intel.com>
Date: Wed, 2 Apr 2025 21:16:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
From: Binbin Wu <binbin.wu@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Content-Language: en-US
In-Reply-To: <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/2/2025 8:53 PM, Binbin Wu wrote:
[...]
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index b952bc673271..535200446c21 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -1463,6 +1463,39 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
>>>       return 1;
>>>   }
>>>   +static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
>>> +{
>>> +    tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
>>> +    return 1;
>>> +}
>>> +
>>> +static int tdx_get_quote(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +
>>> +    u64 gpa = tdx->vp_enter_args.r12;
>>> +    u64 size = tdx->vp_enter_args.r13;
>>> +
>>> +    /* The buffer must be shared memory. */
>>> +    if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
>>> +        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>>> +        return 1;
>>> +    }
>> It is a little bit confusing about the shared buffer check here.  There are two
>> perspectives here:
>>
>> 1) the buffer has already been converted to shared, i.e., the attributes are
>> stored in the Xarray.
>> 2) the GPA passed in the GetQuote must have the shared bit set.
>>
>> The key is we need 1) here.  From the spec, we need the 2) as well because it
>> *seems* that the spec requires GetQuote to provide the GPA with shared bit set,
>> as it says "Shared GPA as input".
>>
>> The above check only does 2).  I think we need to check 1) as well, because once
>> you forward this GetQuote to userspace, userspace is able to access it freely.
>
> Right.
>
> Another discussion is whether KVM should skip the sanity checks for GetQuote
> and let the userspace take the job.
> Considering checking the buffer is shared memory or not, KVM seems to be a
> better place.
A second thought. If the userspace could do the shared memory check, the
whole sanity checks can be done in userspace to keep KVM as small as possible.

>
>>
>> As a result, the comment
>>
>>    /* The buffer must be shared memory. */
>>
>> should also be updated to something like:
>>
>>    /*
>>     * The buffer must be shared. GetQuote requires the GPA to have
>>     * shared bit set.
>>     */
>
>


