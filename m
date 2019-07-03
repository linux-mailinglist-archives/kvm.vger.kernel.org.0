Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CD65D8D8
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGCAaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:30:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:11554 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbfGCA36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 17:29:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,445,1557212400"; 
   d="scan'208";a="315413534"
Received: from unknown (HELO [10.239.196.136]) ([10.239.196.136])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2019 17:29:55 -0700
Subject: Re: [PATCH v5 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>, rkrcmar@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jingqi.liu@intel.com
References: <20190620084620.17974-1-tao3.xu@intel.com>
 <20190620084620.17974-3-tao3.xu@intel.com>
 <b2cfa1d015315c74af6cee1c00185e5c68cfa397.camel@linux.intel.com>
 <22533924-f7e8-4b50-d5fe-7cbcc9295b53@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <05d4c029-79f4-e513-1778-a7c245a48ad7@intel.com>
Date:   Wed, 3 Jul 2019 08:29:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <22533924-f7e8-4b50-d5fe-7cbcc9295b53@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/3/2019 12:37 AM, Paolo Bonzini wrote:
> On 20/06/19 11:46, Xiaoyao Li wrote:
>> You cannot put the atomic switch here. What if umwait_control_cached is changed
>> at runtime? Host kernel patch exposed a sysfs interface to let it happen.
> 
> Thanks for the review, Xiaoyao.  I agree with both of your remarks.
> 
> Paolo
> 
Hi paolo,

The issues have been solved in v6 patches, could you help to review v6 
patches?

Thanks

Tao

>>> +		break;
>>>   	case MSR_IA32_SPEC_CTRL:
>>>   		if (!msr_info->host_initiated &&
>>>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>>> @@ -4126,6 +4148,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool
>>> init_event)
>>>   	vmx->rmode.vm86_active = 0;
>>>   	vmx->spec_ctrl = 0;
>>>   
>>> +	vmx->msr_ia32_umwait_control = 0;
>>> +
>>>   	vcpu->arch.microcode_version = 0x100000000ULL;
>>>   	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>>>   	kvm_set_cr8(vcpu, 0);
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index 61128b48c503..8485bec7c38a 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -14,6 +14,8 @@
>>>   extern const u32 vmx_msr_index[];
>>>   extern u64 host_efer;
>>>   
>>> +extern u32 umwait_control_cached;
>>> +
>>>   #define MSR_TYPE_R	1
>>>   #define MSR_TYPE_W	2
>>>   #define MSR_TYPE_RW	3
>>> @@ -194,6 +196,7 @@ struct vcpu_vmx {
>>>   #endif
>>>   
>>>   	u64		      spec_ctrl;
>>> +	u64		      msr_ia32_umwait_control;
>>>   
>>>   	u32 vm_entry_controls_shadow;
>>>   	u32 vm_exit_controls_shadow;
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 83aefd759846..4480de459bf4 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1138,6 +1138,7 @@ static u32 msrs_to_save[] = {
>>>   	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
>>>   	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
>>>   	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>>> +	MSR_IA32_UMWAIT_CONTROL,
>>>   };
>>>   
>>>   static unsigned num_msrs_to_save;
>>
> 

