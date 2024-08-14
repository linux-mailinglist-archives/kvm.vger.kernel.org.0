Return-Path: <kvm+bounces-24095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D479513B8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 07:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1040B22A8C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 05:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68F955898;
	Wed, 14 Aug 2024 04:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmYToklE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA99745F4;
	Wed, 14 Aug 2024 04:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611594; cv=none; b=dGPDUiSJA/y5HX5P1q6C8xn32/xa8K9tQynvnoHPh2hPdqHcXDdGCI44EVMeAi7uXU8HbgDYtqnz2ItyrQ6SSF+qy2M/GcSq7pgy7sUOr6f6/sgWDsx4PDqoA4BTChq2mRkw5ul4jhR68QPJgsKRhOO2/8zwFBFnOc/w+twIn+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611594; c=relaxed/simple;
	bh=p091EtRspnbX44KHYi6UcQSSQSNEqSr5Aoj/x8yrcAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j0UNbUujoWyxcRU8FoxRt6YG1AjPvP/ZfhynSE3b6YuWSgl1FyXIQW8BazL6NUxL6eSiVWtn3xGmRNkaEkDOWbcIyGHqv+3gMLWkZpZuH3mC5q6g7gVVidk2gF14+/qUBmvgRx6JBJoM7BdTCy7RpDfqfENdhxHkIQQBHU02Q/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmYToklE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723611592; x=1755147592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p091EtRspnbX44KHYi6UcQSSQSNEqSr5Aoj/x8yrcAo=;
  b=OmYToklEpIIS2+z6ZsW00vd7yC8tIJEJMaKjxLYGpPKcMxbSfaM9/NnC
   TCgnJZAgxqy5WUk/GGGKv4mvSogHDyvoVJQaClagZhIU0i8ecBWOCWS0y
   q/SbuwcFPAnm+paHe6KWFzVhNBrCjNraZGzWxjsL1T+QCBBhYelDB6GOs
   D9cgJxtuIgFAN8QOSmI9CAnukH3nteNZtvTwkoAcNPH8wF5XW5WKGQJd0
   HOpMTodR7ZJqzhA4GIsuZ31QWS5przG8jFCvpooo5PPKc4CSP+3iaptvs
   AxmJhgogGVJacOoc1KZc/KkrrDm6mWGfiScIqpz8p0UwJx7BwsBb5dQui
   g==;
X-CSE-ConnectionGUID: crDl0L9dQQ6bYstNF7miaA==
X-CSE-MsgGUID: sfd9G5RRQre/Ti2TjgiEjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="44325203"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="44325203"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 21:59:51 -0700
X-CSE-ConnectionGUID: GZre7wTGTNeOyv8/C4hXPw==
X-CSE-MsgGUID: rrsLMKpbROKxfb4jOVVUAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63044022"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 21:59:49 -0700
Message-ID: <6b68ee3f-a438-455b-b867-1e8524956f6c@linux.intel.com>
Date: Wed, 14 Aug 2024 12:59:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 rick.p.edgecombe@intel.com, michael.roth@amd.com
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <ZrucyCn8rfTrKeNE@ls.amr.corp.intel.com>
 <b58771a0-352e-4478-b57d-11fa2569f084@intel.com>
 <Zrv/60HrjlPCaXsi@ls.amr.corp.intel.com> <ZrwI-927_7cBxYT1@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZrwI-927_7cBxYT1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/14/2024 9:31 AM, Sean Christopherson wrote:
> On Tue, Aug 13, 2024, Isaku Yamahata wrote:
>> On Wed, Aug 14, 2024 at 11:11:29AM +1200,
>> Kai Huang <kai.huang@intel.com> wrote:
>>
>>>
>>> On 14/08/2024 5:50 am, Isaku Yamahata wrote:
>>>> On Tue, Aug 13, 2024 at 01:12:55PM +0800,
>>>> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>>>>
>>>>> Check whether a KVM hypercall needs to exit to userspace or not based on
>>>>> hypercall_exit_enabled field of struct kvm_arch.
>>>>>
>>>>> Userspace can request a hypercall to exit to userspace for handling by
>>>>> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
>>>>> hypercall_exit_enabled.  Make the check code generic based on it.
>>>>>
>>>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>>> ---
>>>>>    arch/x86/kvm/x86.c | 4 ++--
>>>>>    arch/x86/kvm/x86.h | 7 +++++++
>>>>>    2 files changed, 9 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index af6c8cf6a37a..6e16c9751af7 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>>>    	cpl = kvm_x86_call(get_cpl)(vcpu);
>>>>>    	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>>>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>>>> -		/* MAP_GPA tosses the request to the user space. */
>>>>> +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
>>>>> +		/* The hypercall is requested to exit to userspace. */
>>>>>    		return 0;
>>>>>    	if (!op_64_bit)
>>>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>>>> index 50596f6f8320..0cbec76b42e6 100644
>>>>> --- a/arch/x86/kvm/x86.h
>>>>> +++ b/arch/x86/kvm/x86.h
>>>>> @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>>>>    			 unsigned int port, void *data,  unsigned int count,
>>>>>    			 int in);
>>>>> +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
> I would rather have "hypercall" in the name, "hc" never jumps out to me as being
> "hypercall". Maybe is_hypercall_exit_enabled(), user_exit_on_hypercall(), or just
> exit_on_hypercall()?
>
> I'd probably vote for user_exit_on_hypercall(), as that clarifies it's all about
> exiting to userspace, not from the guest.
user_exit_on_hypercall() looks good to me.
Thanks!


>
>>>>> +{
>>>>> +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
>>>>> +		return false;
>>>> Is this to detect potential bug? Maybe
>>>> BUILD_BUG_ON(__builtin_constant_p(hc_nr) &&
>>>>                !(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK));
>>>> Overkill?
>>> I don't think this is the correct way to use __builtin_constant_p(), i.e. it
>>> doesn't make sense to use __builtin_constant_p() in BUILD_BUG_ON().
> KVM does use __builtin_constant_p() to effectively disable some assertions when
> it's allowed (by KVM's arbitrary rules) to pass in a non-constant value.  E.g.
> see all the vmcs_checkNN() helpers.  If we didn't waive the assertion for values
> that aren't constant at compile-time, all of the segmentation code would need to
> be unwound into switch statements.
>
> But for things like guest_cpuid_has(), the rule is that the input must be a
> compile-time constant.
>
>>> IIUC you need some build time guarantee here, but __builtin_constant_p() can
>>> return false, in which case the above BUILD_BUG_ON() does nothing, which
>>> defeats the purpose.
>> It depends on what we'd like to detect.  BUILT_BUG_ON(__builtin_constant_p())
>> can detect the usage in the patch 2/2,
>> is_kvm_hc_exit_enabled(vcpu->kvm, KVM_HC_MAP_GPA_RANGE).  The potential
>> future use of is_kvm_hc_exit_enabled(, KVM_HC_MAP_future_hypercall).
>>
>> Although this version doesn't help for the one in kvm_emulate_hypercall(),
>> !ret check is done first to avoid WARN_ON_ONCE() to hit here.
>>
>> Maybe we can just drop this WARN_ON_ONCE().
> Yeah, I think it makes sense to drop the WARN, otherwise I suspect we'll end up
> dancing around the helper just to avoid the warning.
>
> I'm 50/50 on the BUILD_BUG_ON().  One one hand, it's kinda overkill.  On the other
> hand, it's zero generated code.
>
Will remove the WARN_ON_ONCE().


