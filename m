Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4CA4B288
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 09:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFSHBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 03:01:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:32026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfFSHBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 03:01:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 00:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="162122833"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.224]) ([10.239.196.224])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2019 00:01:38 -0700
Subject: Re: [PATCH v4 1/3] KVM: x86: add support for user wait instructions
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jingqi.liu@intel.com
References: <20190619060945.14104-1-tao3.xu@intel.com>
 <20190619060945.14104-2-tao3.xu@intel.com>
 <7f6bc0fa-abcd-ce0a-19a0-a5767d094181@linux.intel.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <10820bce-69fa-4cee-f95b-5a8de20388d1@intel.com>
Date:   Wed, 19 Jun 2019 15:01:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <7f6bc0fa-abcd-ce0a-19a0-a5767d094181@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/2019 2:23 PM, Xiaoyao Li wrote:
> 
> 
> On 6/19/2019 2:09 PM, Tao Xu wrote:
>> UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
>> This patch adds support for user wait instructions in KVM. Availability
>> of the user wait instructions is indicated by the presence of the CPUID
>> feature flag WAITPKG CPUID.0x07.0x0:ECX[5]. User wait instructions may
>> be executed at any privilege level, and use IA32_UMWAIT_CONTROL MSR to
>> set the maximum time.
>>
>> The behavior of user wait instructions in VMX non-root operation is
>> determined first by the setting of the "enable user wait and pause"
>> secondary processor-based VM-execution control bit 26.
>>     If the VM-execution control is 0, UMONITOR/UMWAIT/TPAUSE cause
>> an invalid-opcode exception (#UD).
>>     If the VM-execution control is 1, treatment is based on the
>> setting of the “RDTSC exiting” VM-execution control. Because KVM never
>> enables RDTSC exiting, if the instruction causes a delay, the amount of
>> time delayed is called here the physical delay. The physical delay is
>> first computed by determining the virtual delay. If
>> IA32_UMWAIT_CONTROL[31:2] is zero, the virtual delay is the value in
>> EDX:EAX minus the value that RDTSC would return; if
>> IA32_UMWAIT_CONTROL[31:2] is not zero, the virtual delay is the minimum
>> of that difference and AND(IA32_UMWAIT_CONTROL,FFFFFFFCH).
>>
>> Because umwait and tpause can put a (psysical) CPU into a power saving
>> state, by default we dont't expose it to kvm and enable it only when
>> guest CPUID has it.
>>
>> Detailed information about user wait instructions can be found in the
>> latest Intel 64 and IA-32 Architectures Software Developer's Manual.
>>
>> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>> ---
>>
>> no changes in v4.
>> ---
>>   arch/x86/include/asm/vmx.h      | 1 +
>>   arch/x86/kvm/cpuid.c            | 2 +-
>>   arch/x86/kvm/vmx/capabilities.h | 6 ++++++
>>   arch/x86/kvm/vmx/vmx.c          | 4 ++++
>>   4 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index a39136b0d509..8f00882664d3 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -69,6 +69,7 @@
>>   #define SECONDARY_EXEC_PT_USE_GPA        0x01000000
>>   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC    0x00400000
>>   #define SECONDARY_EXEC_TSC_SCALING              0x02000000
>> +#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE    0x04000000
>>   #define PIN_BASED_EXT_INTR_MASK                 0x00000001
>>   #define PIN_BASED_NMI_EXITING                   0x00000008
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index e18a9f9f65b5..48bd851a6ae5 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -405,7 +405,7 @@ static inline int __do_cpuid_ent(struct 
>> kvm_cpuid_entry2 *entry, u32 function,
>>           F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
>>           F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>>           F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>> -        F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
>> +        F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
>>       /* cpuid 7.0.edx*/
>>       const u32 kvm_cpuid_7_0_edx_x86_features =
>> diff --git a/arch/x86/kvm/vmx/capabilities.h 
>> b/arch/x86/kvm/vmx/capabilities.h
>> index d6664ee3d127..fd77e17651b4 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -253,6 +253,12 @@ static inline bool cpu_has_vmx_tsc_scaling(void)
>>           SECONDARY_EXEC_TSC_SCALING;
>>   }
>> +static inline bool vmx_waitpkg_supported(void)
>> +{
>> +    return vmcs_config.cpu_based_2nd_exec_ctrl &
>> +        SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> 
> Shouldn't it be
>      return vmx->secondary_exec_control &
>                  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;   ?

vmx->secondary_exec_control is another way to get SECONDARY_EXEC_CONTROL 
but it need to add vmx as input. Use vmcs_config.cpu_based_2nd_exec_ctrl 
  is easy expand to use in other place.


