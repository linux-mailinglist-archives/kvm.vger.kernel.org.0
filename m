Return-Path: <kvm+bounces-30870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 426339BE100
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7A4A1F228E2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7851D514B;
	Wed,  6 Nov 2024 08:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwUURdBV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3210F2;
	Wed,  6 Nov 2024 08:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881966; cv=none; b=P8zMeKqLj34uHS1CxnV7Sl7N/mdzbjiim5pVnSGZkEyBvgWOQ2lrcTQvZMy+VPlsg7zCuqqeCflB2Rl0k9OuMs8XTzcIGe3JRJJ/0S2+Y8JzEfhYB13z1HJam3edUdI4//x3k4HhYJbpwdb2xHVZWjVwDwi+Hu7NP0mlAPCsmnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881966; c=relaxed/simple;
	bh=Cs/WodRVZmIX/VI2JdODdxjoBOobCQ65AmVv2eKfwAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHs8RXx6kWwQn/OTkJhw8eMkizTZDGPX3DUiPdXOHTyTjHYsFioH75hNTz/+zh3Vb3nEPZZqD2qThpEb3dNiEpBtuIArKyyLOhBjSsAdXp5nzpEdsrXLt38nu830zO4QPQp9ulVa2g36XSIkfK6aVU6y1Ogqroog+laQ23WwZX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwUURdBV; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730881965; x=1762417965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cs/WodRVZmIX/VI2JdODdxjoBOobCQ65AmVv2eKfwAA=;
  b=dwUURdBVCI2+Yv36CF6vstRUZ4y1EPfnHnds4PyHCA0S6jLA11wN1R6z
   EfgT18zXjeKpzjhwtdiciwle0Ec7l7IU8lTDQKTWIoNp9h/pWnYvZHK3Q
   6ncyln1rLSI16W7wHixJ5sUcbVc9sSGiU0kWtfVwyzbn5/p0Q0ySyt+pO
   8BBeniMDlH3xsWmX+Qb2QbATdYNG3PEXTfcfqxAK3iIAhRLH2MRv4ksS1
   oHPEvAUgD5G/veYpoK6KeIaUBrLkxDBA76Dps+16jt8Fw0i3eGN9CC2NH
   iBEpSlsp31WfTcqj0Ip8xzf78KCQdh80FydmhTYGLWPHNbSSxRU99ZSvF
   A==;
X-CSE-ConnectionGUID: 5vCY+9/+RXGS4ohTbTI7tw==
X-CSE-MsgGUID: XQefZObvS8moZXdTKUDXKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42048792"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42048792"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:32:38 -0800
X-CSE-ConnectionGUID: yTyKz2cfSNO2ywyt9X/EFQ==
X-CSE-MsgGUID: 6eGHPVTWRD6hoA44792b1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="121917951"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:32:35 -0800
Message-ID: <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
Date: Wed, 6 Nov 2024 16:32:33 +0800
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
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
 <ZymDgtd3VquVwsn_@google.com>
 <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 11/5/2024 5:20 PM, Huang, Kai wrote:
>> I think I prefer Binbin's version, as it forces the caller to provide cui(), i.e.
>> makes it harder KVM to fail to handle the backend of the hypercall.
> Fine to me.
>
> [...]
>
>> The one thing I don't love about providing a separate cui() is that it means
>> duplicating the guts of the completion helper.  Ha!  But we can avoid that by
>> adding another macro (untested).
>>
>> More macros/helpers is a bit ugly too, but I like the symmetry, and it will
>> definitely be easier to maintain.  E.g. if the completion phase needs to pivot
>> on the exact hypercall, then we can update common code and don't need to remember
>> to go update TDX too.
>>
>> If no one objects and/or has a better idea, I'll splice together Binbin's patch
>> with this blob, and post a series tomorrow.
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8e8ca6dab2b2..0b0fa9174000 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -2179,6 +2179,16 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>>          kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>>   }
>>   
>> +#define kvm_complete_hypercall_exit(vcpu, ret_reg)                             \
>> +do {                                                                           \
>> +       u64 ret = (vcpu)->run->hypercall.ret;                                   \
>> +                                                                               \
>> +       if (!is_64_bit_mode(vcpu))                                              \
>> +               ret = (u32)ret;                                                 \
>> +       kvm_##ret_reg##_write(vcpu, ret);                                       \
>> +       ++(vcpu)->stat.hypercalls;                                              \
>> +} while (0)
>> +
>>   int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>                                unsigned long a0, unsigned long a1,
>>                                unsigned long a2, unsigned long a3,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 425a301911a6..aec79e132d3b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9989,12 +9989,8 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>>   
>>   static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>>   {
>> -       u64 ret = vcpu->run->hypercall.ret;
>> +       kvm_complete_hypercall_exit(vcpu, rax);
>>   
>> -       if (!is_64_bit_mode(vcpu))
>> -               ret = (u32)ret;
>> -       kvm_rax_write(vcpu, ret);
>> -       ++vcpu->stat.hypercalls;
>>          return kvm_skip_emulated_instruction(vcpu);
>>   }
>>   
> I think there's one issue here:
>
> I assume macro kvm_complete_hypercall_exit(vcpu, ret_reg) will also be used by
> TDX.  The issue is it calls !is_64_bit_mode(vcpu), which has below WARN():
>
>          WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>
> So IIUC TDX will hit this.
>
> Btw, we have below (kinda) duplicated code in ____kvm_emulate_hypercall() too:
>
> 	++vcpu->stat.hypercalls;
>                                                                                                                                                                 
>          if (!op_64_bit)
>                  ret = (u32)ret;
>                                                                                                                                                                 
>          kvm_register_write_raw(vcpu, ret_reg, ret);
>
> If we add a helper to do above, e.g.,
>
> static void kvm_complete_hypercall_exit(struct kvm_vcpu *vcpu, int ret_reg,
> 				        unsigned long ret, bool op_64_bit)
> {
> 	if (!op_64_bit)
> 		ret = (u32)ret;
> 	kvm_register_write_raw(vcpu, ret_reg, ret);
> 	++vcpu->stat.hypercalls;
> }
If this is going to be the final version, it would be better to make it
public, and export the symbol, so that TDX code can reuse it.


>
> Then we can have
>
> static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
> {
> 	kvm_complete_hypercall_exit(vcpu, VCPU_REGS_RAX,
> 		vcpu->run->hypercall.ret, is_64_bit_mode(vcpu));
>
> 	return kvm_skip_emulated_instruction(vcpu);
> }
>
> TDX version can use:
>
> 	kvm_complete_hypercall_exit(vcpu, VCPU_REGS_R10,
> 		vcpu->run->hypercall.ret, true);
>
> And ____kvm_emulate_hypercall() can be:
>
> static int ____kvm_emulate_hypercall(vcpu, ...)
> {
> 	...
> out:
> 	kvm_complete_hypercall_exit(vcpu, ret_reg, ret, op_64_bit);
> 	return 1;
> }
>


