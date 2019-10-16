Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91656D8578
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 03:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbfJPB3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 21:29:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:49626 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfJPB3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 21:29:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 18:29:42 -0700
X-IronPort-AV: E=Sophos;i="5.67,302,1566889200"; 
   d="scan'208";a="186004002"
Received: from unknown (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 15 Oct 2019 18:29:40 -0700
Subject: Re: [PATCH 2/4] KVM: VMX: Setup MSR bitmap only when has msr_bitmap
 capability
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
 <20191015164033.87276-3-xiaoyao.li@intel.com>
 <05ff009e-5f60-54ff-a371-111763a1cb7f@oracle.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <00aaf6d2-e47c-c972-55b6-c7eedd87a075@intel.com>
Date:   Wed, 16 Oct 2019 09:29:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <05ff009e-5f60-54ff-a371-111763a1cb7f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/2019 8:40 AM, Krish Sadhukhan wrote:
> 
> 
> On 10/15/2019 09:40 AM, Xiaoyao Li wrote:
>> Move the MSR bitmap setup codes to vmx_vmcs_setup() and only setup them
>> when hardware has msr_bitmap capability.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 39 ++++++++++++++++++++-------------------
>>   1 file changed, 20 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 58b77a882426..7051511c27c2 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4164,12 +4164,30 @@ static void ept_set_mmio_spte_mask(void)
>>   static void vmx_vmcs_setup(struct vcpu_vmx *vmx)
>>   {
>>       int i;
>> +    unsigned long *msr_bitmap;
>>       if (nested)
>>           nested_vmx_vmcs_setup();
>> -    if (cpu_has_vmx_msr_bitmap())
>> -        vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
>> +    if (cpu_has_vmx_msr_bitmap()) {
>> +        msr_bitmap = vmx->vmcs01.msr_bitmap;
>> +        vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, 
>> MSR_TYPE_R);
> 
> vmx_disable_intercept_for_msr() also calls cpu_has_vmx_msr_bitmap(), 
> which means we are repeating the check. A cleaner approach is to remove 
> the call to cpu_has_vmx_msr_bitmap()  from 
> vmx_disable_intercept_for_msr()  and let its callers do the check just 
> like you are doing here.
> 

Right.
I'll improve it. Thanks!

>> +        vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, 
>> MSR_TYPE_RW);
>> +        vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, 
>> MSR_TYPE_RW);
>> +        vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, 
>> MSR_TYPE_RW);
>> +        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
>> +        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
>> +        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
>> +        if (kvm_cstate_in_guest(vmx->vcpu.kvm)) {
>> +            vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C1_RES, MSR_TYPE_R);
>> +            vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
>> +            vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
>> +            vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>> +        }
>> +
>> +        vmcs_write64(MSR_BITMAP, __pa(msr_bitmap));
>> +    }
>> +    vmx->msr_bitmap_mode = 0;
>>       vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
>> @@ -6697,7 +6715,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct 
>> kvm *kvm, unsigned int id)
>>   {
>>       int err;
>>       struct vcpu_vmx *vmx;
>> -    unsigned long *msr_bitmap;
>>       int cpu;
>>       BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
>> @@ -6754,22 +6771,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct 
>> kvm *kvm, unsigned int id)
>>       if (err < 0)
>>           goto free_msrs;
>> -    msr_bitmap = vmx->vmcs01.msr_bitmap;
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, 
>> MSR_TYPE_RW);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, 
>> MSR_TYPE_RW);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, 
>> MSR_TYPE_RW);
>> -    vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, 
>> MSR_TYPE_RW);
>> -    if (kvm_cstate_in_guest(kvm)) {
>> -        vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, 
>> MSR_TYPE_R);
>> -        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
>> -        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
>> -        vmx_disable_intercept_for_msr(msr_bitmap, 
>> MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>> -    }
>> -    vmx->msr_bitmap_mode = 0;
>> -
>>       vmx->loaded_vmcs = &vmx->vmcs01;
>>       cpu = get_cpu();
>>       vmx_vcpu_load(&vmx->vcpu, cpu);
> 
