Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C784160DDD
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 09:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgBQI5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 03:57:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:24856 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgBQI5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 03:57:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 00:57:19 -0800
X-IronPort-AV: E=Sophos;i="5.70,451,1574150400"; 
   d="scan'208";a="228351206"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.218]) ([10.249.168.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Feb 2020 00:57:15 -0800
Subject: Re: [PATCH] KVM: VMX: Add VMX_FEATURE_USR_WAIT_PAUSE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20200216104858.109955-1-xiaoyao.li@intel.com>
 <87r1ytbnor.fsf@vitty.brq.redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <bb0302e1-c946-2695-8468-d08c3b146b76@intel.com>
Date:   Mon, 17 Feb 2020 16:57:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87r1ytbnor.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/2020 4:52 PM, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Commit 159348784ff0 ("x86/vmx: Introduce VMX_FEATURES_*") missed
>> bit 26 (enable user wait and pause) of Secondary Processor-based
>> VM-Execution Controls.
>>
>> Add VMX_FEATURE_USR_WAIT_PAUSE flag and use it to define
>> SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE to make them uniformly.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/include/asm/vmx.h         | 2 +-
>>   arch/x86/include/asm/vmxfeatures.h | 1 +
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index 2a85287b3685..8521af3fef27 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -72,7 +72,7 @@
>>   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
>>   #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
>>   #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
>> -#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	0x04000000
>> +#define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
>>   
>>   #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>>   #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
>> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
>> index a50e4a0de315..1408f526bd90 100644
>> --- a/arch/x86/include/asm/vmxfeatures.h
>> +++ b/arch/x86/include/asm/vmxfeatures.h
>> @@ -81,6 +81,7 @@
>>   #define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
>>   #define VMX_FEATURE_PT_USE_GPA		( 2*32+ 24) /* "" Processor Trace logs GPAs */
>>   #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
>> +#define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* "" Enable TPAUSE, UMONITOR, UMWATI in guest */
> 
> "UMWAIT"

What an uncareful typo. Thanks!

>>   #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>>   
>>   #endif /* _ASM_X86_VMXFEATURES_H */
> 
> With the typo fixed (likely upon commit),
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

