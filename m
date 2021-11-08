Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1AD44791D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 05:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhKHEKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Nov 2021 23:10:37 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:30927 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbhKHEKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Nov 2021 23:10:34 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HncsH69xWzcb8q;
        Mon,  8 Nov 2021 12:02:59 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 12:07:41 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 12:07:40 +0800
Subject: Re: [PATCH V10 05/18] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-6-lingshan.zhu@intel.com> <6187A6F9.5030401@huawei.com>
 <5aa115ab-d22c-098d-0591-36c7ab15f8b6@gmail.com>
CC:     <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kan.liang@linux.intel.com>, <ak@linux.intel.com>,
        <wei.w.wang@intel.com>, <eranian@google.com>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <boris.ostrvsky@oracle.com>,
        Yao Yuan <yuan.yao@intel.com>,
        "Venkatesh Srinivas" <venkateshs@chromium.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <6188A28B.2020302@huawei.com>
Date:   Mon, 8 Nov 2021 12:07:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <5aa115ab-d22c-098d-0591-36c7ab15f8b6@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/8 11:06, Like Xu wrote:
> On 7/11/2021 6:14 pm, Liuxiangdong wrote:
>> Hi, like and lingshan.
>>
>> As said,  IA32_MISC_ENABLE[7] bit depends on the PMU is enabled for 
>> the guest, so a software
>> write openration to this bit will be ignored.
>>
>> But, in this patch, all the openration that writes 
>> msr_ia32_misc_enable in guest could make this bit become 0.
>>
>> Suppose:
>> When we start vm with "enable_pmu", vcpu->arch.ia32_misc_enable_msr 
>> may be 0x80 first.
>> And next, guest writes msr_ia32_misc_enable value 0x1.
>> What we want could be 0x81, but unfortunately, it will be 0x1 because of
>> "data &= ~MSR_IA32_MISC_ENABLE_EMON;"
>> And even if guest writes msr_ia32_misc_enable value 0x81, it will be 
>> 0x1 also.
>>
>
> Yes and thank you. The fix has been committed on my private tree for a 
> long time.
>
>>
>> What we want is write operation will not change this bit. So, how 
>> about this?
>>
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>           }
>>           break;
>>       case MSR_IA32_MISC_ENABLE:
>> +        data &= ~MSR_IA32_MISC_ENABLE_EMON;
>> +        data |= (vcpu->arch.ia32_misc_enable_msr & 
>> MSR_IA32_MISC_ENABLE_EMON);
>>           if (!kvm_check_has_quirk(vcpu->kvm, 
>> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>>               ((vcpu->arch.ia32_misc_enable_msr ^ data) & 
>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>               if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>
>>
>
> How about this for the final state considering PEBS enabling:
>
>     case MSR_IA32_MISC_ENABLE: {
>         u64 old_val = vcpu->arch.ia32_misc_enable_msr;
>         u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
>             MSR_IA32_MISC_ENABLE_EMON;
>
         u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
             MSR_IA32_MISC_ENABLE_EMON;

Repetitive "MSR_IA32_MISC_ENABLE_EMON" ?

>         /* RO bits */
>         if (!msr_info->host_initiated &&
>             ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
>             return 1;
>
>         /*
>          * For a dummy user space, the order of setting vPMU 
> capabilities and
>          * initialising MSR_IA32_MISC_ENABLE is not strictly 
> guaranteed, so to
>          * avoid inconsistent functionality we keep the vPMU bits 
> unchanged here.
>          */
Yes. It's a little clearer with comments.
>         data &= ~pmu_mask;
>         data |= old_val & pmu_mask;
>         if (!kvm_check_has_quirk(vcpu->kvm, 
> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>             ((old_val ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>             if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>                 return 1;
>             vcpu->arch.ia32_misc_enable_msr = data;
>             kvm_update_cpuid_runtime(vcpu);
>         } else {
>             vcpu->arch.ia32_misc_enable_msr = data;
>         }
>         break;
>     }
>
>> Or is there anything in your design intention I don't understand?
>>
>> Thanks!
>>
>> Xiangdong Liu
>>
>>
>> On 2021/8/6 21:37, Zhu Lingshan wrote:
>>> From: Like Xu <like.xu@linux.intel.com>
>>>
>>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
>>> detect whether the processor supports performance monitoring facility.
>>>
>>> It depends on the PMU is enabled for the guest, and a software write
>>> operation to this available bit will be ignored. The proposal to ignore
>>> the toggle in KVM is the way to go and that behavior matches bare 
>>> metal.
>>>
>>> Cc: Yao Yuan <yuan.yao@intel.com>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> ---
>>>   arch/x86/kvm/vmx/pmu_intel.c | 1 +
>>>   arch/x86/kvm/x86.c           | 1 +
>>>   2 files changed, 2 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c 
>>> b/arch/x86/kvm/vmx/pmu_intel.c
>>> index 9efc1a6b8693..d9dbebe03cae 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu 
>>> *vcpu)
>>>       if (!pmu->version)
>>>           return;
>>> +    vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
>>>       perf_get_x86_pmu_capability(&x86_pmu);
>>>       pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index efd11702465c..f6b6984e26ef 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3321,6 +3321,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
>>> struct msr_data *msr_info)
>>>           }
>>>           break;
>>>       case MSR_IA32_MISC_ENABLE:
>>> +        data &= ~MSR_IA32_MISC_ENABLE_EMON;
>>>           if (!kvm_check_has_quirk(vcpu->kvm, 
>>> KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>>>               ((vcpu->arch.ia32_misc_enable_msr ^ data) & 
>>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>>               if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>

