Return-Path: <kvm+bounces-30585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C479BC252
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01865282FE0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583F51C68F;
	Tue,  5 Nov 2024 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9ZnANM/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A518622;
	Tue,  5 Nov 2024 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768841; cv=none; b=WPEhzX71pPUSZlS1XZ6OdZxCc7+rAxBtqTyTwm/dpgHVfd6SMxWmc4eS7ORUVCoajaqYOpKyJXbaVTe31FUJ8GAJOqu6ki62eg8OvdVFr9ToGrBHvgN1g1gerPwDRW2PIpn30u52t+divZCHI/Ke5olxi39S5dM+IF3XMvx2f7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768841; c=relaxed/simple;
	bh=l8DfQn5o9vFOLgOjvh00A/2LWCZJcea+IHrefb+e5XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hjiQSAae9LFPwb+cVxXDDFCPNAXhJTHY6NPvbKi6wqNNUtEVthaJJCTC2bHJg+afAEb9c9d7zPC6kT1V2380nNbGR5UPuanZ0JHgauw1djfflJTjuY733rBBx8uTY8paxvq1kgVSB318rbcvp8at2iioYUe21jy2ie89oKMyhE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9ZnANM/; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730768840; x=1762304840;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l8DfQn5o9vFOLgOjvh00A/2LWCZJcea+IHrefb+e5XA=;
  b=Q9ZnANM/uaZ+t9+fGdUw5LBdVmh2TYtr8WA7h+dRR/fBb9TXfT2qwszN
   u5DJqTHOeS9gZU09vUdhS4NHeX//CwWU57Nk8rAXDaP5viUfUvfVbe4le
   zcfpNvE6pEn3JoiXgfXzyWBuqg4QxqsR4XRjjV8wd8Tfn/o8dWwEbUJiO
   roY+g/PTFt95vtG+RKd1Tf+3WyEF77kAqfcpaXOcTrA5N1i09KGZCKA5H
   UFeS/M/4Ce0mJi93iFs7YTCvHMkJqp/LLDWOajG6QdKNCgTiI09n86ICw
   X4e9NZMVr65JYTA+/6T/U3Rj61p2FHKJsfkJkXDPdpPKAFTOBXDWZBrcR
   w==;
X-CSE-ConnectionGUID: SzMGS2cPTqWfSIiPOw1H9Q==
X-CSE-MsgGUID: MjnbYTbdRAWM8Y8hoNSHpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30372804"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30372804"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:07:19 -0800
X-CSE-ConnectionGUID: XeKeeuNkQ3S/7Y42Ho9weQ==
X-CSE-MsgGUID: HypnBqjyQPeOOyIFyRNpIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="83765655"
Received: from unknown (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:07:17 -0800
Message-ID: <ea6bdf59-312e-45ea-9ed7-19272ec1beb9@linux.intel.com>
Date: Tue, 5 Nov 2024 09:07:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/4/2024 5:55 PM, Huang, Kai wrote:
[...]
>>>    int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>    {
>>> -	unsigned long nr, a0, a1, a2, a3, ret;
>>> -	int op_64_bit;
>>> -	int cpl;
>>> +	int r;
>>>    
>>>    	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>>>    		return kvm_xen_hypercall(vcpu);
>>> @@ -10102,23 +10105,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>    	if (kvm_hv_hypercall_enabled(vcpu))
>>>    		return kvm_hv_hypercall(vcpu);
>>>    
>>> -	nr = kvm_rax_read(vcpu);
>>> -	a0 = kvm_rbx_read(vcpu);
>>> -	a1 = kvm_rcx_read(vcpu);
>>> -	a2 = kvm_rdx_read(vcpu);
>>> -	a3 = kvm_rsi_read(vcpu);
>>> -	op_64_bit = is_64_bit_hypercall(vcpu);
>>> -	cpl = kvm_x86_call(get_cpl)(vcpu);
>>> -
>>> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>> -		/* MAP_GPA tosses the request to the user space. */
>>> +	r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
>>> +				    is_64_bit_hypercall(vcpu),
>>> +				    kvm_x86_call(get_cpl)(vcpu), RAX);
>> Now, the register for return code of the hypercall can be specified.
>> But in  ____kvm_emulate_hypercall(), the complete_userspace_io callback
>> is hardcoded to complete_hypercall_exit(), which always set return code
>> to RAX.
>>
>> We can allow the caller to pass in the cui callback, or assign different
>> version according to the input 'ret_reg'.  So that different callers can use
>> different cui callbacks.  E.g., TDX needs to set return code to R10 in cui
>> callback.
>>
>> How about:
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index dba78f22ab27..0fba98685f42 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -2226,13 +2226,15 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>>    int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>                                 unsigned long a0, unsigned long a1,
>>                                 unsigned long a2, unsigned long a3,
>> -                             int op_64_bit, int cpl, int ret_reg);
>> +                             int op_64_bit, int cpl, int ret_reg,
>> +                             int (*cui)(struct kvm_vcpu *vcpu));
>>
> Does below (incremental diff based on Sean's) work?

Yes, it can work.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 734dac079453..5131af97968d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10075,7 +10075,6 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu,
> unsigned long nr,
>                          vcpu->run->hypercall.flags |=
> KVM_EXIT_HYPERCALL_LONG_MODE;
>   
>                  WARN_ON_ONCE(vcpu->run->hypercall.flags &
> KVM_EXIT_HYPERCALL_MBZ);
> -               vcpu->arch.complete_userspace_io = complete_hypercall_exit;
>                  /* stat is incremented on completion. */
>                  return 0;
>          }
> @@ -10108,8 +10107,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>          r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
>                                      is_64_bit_hypercall(vcpu),
>                                      kvm_x86_call(get_cpl)(vcpu), RAX);
> -       if (r <= 0)
> +       if (r <= 0) {
> +               if (!r)
> +                       vcpu->arch.complete_userspace_io =
> complete_hypercall_exit;
>                  return 0;
> +       }
>   
>          return kvm_skip_emulated_instruction(vcpu);
>   }
>


