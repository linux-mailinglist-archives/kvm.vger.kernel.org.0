Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D60B44B9D0
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 01:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhKJA7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 19:59:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:29430 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhKJA7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 19:59:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="232417678"
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="232417678"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 16:56:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="491894028"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.71]) ([10.238.2.71])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 16:56:44 -0800
Message-ID: <0b1ac54e-5706-4864-a4a9-1d1a2cff354a@intel.com>
Date:   Wed, 10 Nov 2021 08:56:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-4-chenyi.qiang@intel.com> <YYliC1kdT9ssX/f7@google.com>
 <85414ca6-e135-2371-cbce-0f595a7b7a26@intel.com>
 <YYqT/cOm3Psf1gj1@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YYqT/cOm3Psf1gj1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/9/2021 11:30 PM, Sean Christopherson wrote:
> On Tue, Nov 09, 2021, Chenyi Qiang wrote:
>>
>> On 11/9/2021 1:44 AM, Sean Christopherson wrote:
>>> Hrm.  Ideally this would be open coded in vmx_set_msr().  Long term, the RESET/INIT
>>> paths should really treat MSR updates as "normal" host_initiated writes instead of
>>> having to manually handle every MSR.
>>>
>>> That would be a bit gross to handle in vmx_vcpu_reset() since it would have to
>>> create a struct msr_data (because __kvm_set_msr() isn't exposed to vendor code),
>>> but since vcpu->arch.pkrs is relevant to the MMU I think it makes sense to
>>> initiate the write from common x86.
>>>
>>> E.g. this way there's not out-of-band special code, vmx_vcpu_reset() is kept clean,
>>> and if/when SVM gains support for PKRS this particular path Just Works.  And it would
>>> be an easy conversion for my pipe dream plan of handling MSRs at RESET/INIT via a
>>> list of MSRs+values.
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index ac83d873d65b..55881d13620f 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -11147,6 +11147,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>           kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>>>           kvm_rip_write(vcpu, 0xfff0);
>>>
>>> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
>>> +               __kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
>>> +
>>
>> Got it. In addition, is it necessary to add on-INIT check? like:
>>
>> if (kvm_cpu_cap_has(X86_FEATURE_PKS) && !init_event)
>> 	__kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
>>
>> PKRS should be preserved on INIT, not cleared. The SDM doesn't make this
>> clear either.
> 
> Hmm, but your cover letter says:
> 
>    To help patches review, one missing info in SDM is that PKSR will be
>    cleared on Powerup/INIT/RESET, which should be listed in Table 9.1
>    "IA-32 and Intel 64 Processor States Following Power-up, Reset, or INIT"
> 
> Which honestly makes me a little happy because I thought I was making stuff up
> for a minute :-)
> 
> So which is it?

Sorry about the confusion. PKRS is preserved on INIT. I tried to correct 
my statement in previous ping mail but seems not so obvious.

> 
