Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E68268209
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 03:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfGOBWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 21:22:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:17201 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfGOBWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 21:22:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2019 18:22:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,492,1557212400"; 
   d="scan'208";a="160946445"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.203]) ([10.239.196.203])
  by orsmga008.jf.intel.com with ESMTP; 14 Jul 2019 18:22:15 -0700
Subject: Re: [PATCH v7 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-3-tao3.xu@intel.com>
 <20190712155202.GC29659@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <8ed3cec5-8ba9-b2ed-f0e4-eefb0a988bc8@intel.com>
Date:   Mon, 15 Jul 2019 09:22:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190712155202.GC29659@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/2019 11:52 PM, Sean Christopherson wrote:
> On Fri, Jul 12, 2019 at 04:29:06PM +0800, Tao Xu wrote:
>> diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
>> index 6a204e7336c1..631152a67c6e 100644
>> --- a/arch/x86/kernel/cpu/umwait.c
>> +++ b/arch/x86/kernel/cpu/umwait.c
>> @@ -15,7 +15,8 @@
>>    * Cache IA32_UMWAIT_CONTROL MSR. This is a systemwide control. By default,
>>    * umwait max time is 100000 in TSC-quanta and C0.2 is enabled
>>    */
>> -static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
>> +u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
>> +EXPORT_SYMBOL_GPL(umwait_control_cached);
> 
> It'd probably be better to add an accessor to expose umwait_control_cached
> given that umwait.c is using {READ,WRITE}_ONCE() and there shouldn't be a
> need to write it outside of umwait.c.
> 

OKay

>>   /*
>>    * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL MSR in
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f411c9ae5589..0787f140d155 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1676,6 +1676,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   #endif
>>   	case MSR_EFER:
>>   		return kvm_get_msr_common(vcpu, msr_info);
>> +	case MSR_IA32_UMWAIT_CONTROL:
>> +		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>> +			return 1;
>> +
>> +		msr_info->data = vmx->msr_ia32_umwait_control;
>> +		break;
>>   	case MSR_IA32_SPEC_CTRL:
>>   		if (!msr_info->host_initiated &&
>>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>> @@ -1838,6 +1844,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			return 1;
>>   		vmcs_write64(GUEST_BNDCFGS, data);
>>   		break;
>> +	case MSR_IA32_UMWAIT_CONTROL:
>> +		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
>> +			return 1;
>> +
>> +		/* The reserved bit IA32_UMWAIT_CONTROL[1] should be zero */
>> +		if (data & BIT_ULL(1))
>> +			return 1;
>> +
>> +		vmx->msr_ia32_umwait_control = data;
> 
> The SDM only defines bits 31:0, and the kernel uses a u32 to cache its
> value.  I assume bits 63:32 are reserved?  I'm guessing we also need an
> SDM update...
> 

The SDM define IA32_UMWAIT_CONTROL is a 32bit MSR. So need me to set 
63:32 reserved?

>> +		break;
>>   	case MSR_IA32_SPEC_CTRL:
>>   		if (!msr_info->host_initiated &&
>>   		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>> @@ -4139,6 +4155,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   	vmx->rmode.vm86_active = 0;
>>   	vmx->spec_ctrl = 0;
>>   
>> +	vmx->msr_ia32_umwait_control = 0;
>> +
>>   	vcpu->arch.microcode_version = 0x100000000ULL;
>>   	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>>   	kvm_set_cr8(vcpu, 0);
>> @@ -6352,6 +6370,19 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>   					msrs[i].host, false);
>>   }
>>   

