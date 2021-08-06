Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562BA3E23A5
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243496AbhHFHBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:01:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:13959 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243487AbhHFHBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 03:01:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299909292"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="299909292"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:01:14 -0700
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="481378284"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:01:09 -0700
Subject: Re: [PATCH v3 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-3-guang.zeng@intel.com> <YQxnGIT7XLQvPkrz@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <86b1a46b-10b7-a495-8793-26374ebc9b90@intel.com>
Date:   Fri, 6 Aug 2021 15:01:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQxnGIT7XLQvPkrz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/6/2021 6:32 AM, Sean Christopherson wrote:
> On Thu, Aug 05, 2021, Zeng Guang wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> The Tertiary VM-Exec Control, different from previous control fields, is 64
>> bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
>> support both 32 bit and 64 bit fields' auxiliary functions building.
>> Also, define the auxiliary functions for Tertiary control field here, using
>> the new BUILD_CONTROLS_SHADOW().
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.h | 23 ++++++++++++-----------
>>   1 file changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 3979a947933a..945c6639ce24 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -413,31 +413,32 @@ static inline u8 vmx_get_rvi(void)
>>   	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>>   }
>>   
>> -#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
>> -static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
>> +#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			    \
>> +static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val) \
> Align the trailing backslashes (with tabs when possible).  It's a lot of unfortunate
> churn, but it really does make the code easier to read.  An alternative is to split
> "static inline" to a separate line.
>
>>   {									    \
>>   	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
>> -		vmcs_write32(uname, val);				    \
>> +		vmcs_write##bits(uname, val);				    \
>>   		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
>>   	}								    \
>>   }									    \
>> -static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
>> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	    \
>>   {									    \
>>   	return vmx->loaded_vmcs->controls_shadow.lname;			    \
>>   }									    \
>> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
>> +static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)   \
>>   {									    \
>>   	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
>>   }									    \
>> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
>> +static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val) \
>>   {									    \
>>   	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
>>   }
>> -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
>> -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
>> -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
>> -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
>> -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
>> +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
>> +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
>> +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
>> +BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
> This fails to compile because all the TERTIARY collateral is in a later patch.


Alternative to derive relative TERTIARY collateral and prepare them in 
this patch. Ok for that ?

>
> I think I'd also prefer hiding the 32/64 param via more macros, e.g.
>
> #define __BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
> static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {			\
> 		vmcs_write##bits(uname, val);					\
> 		vmx->loaded_vmcs->controls_shadow.lname = val;			\
> 	}									\
> }										\
> static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
> {										\
> 	return vmx->loaded_vmcs->controls_shadow.lname;				\
> }										\
> static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
> }										\
> static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> {										\
> 	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
> }
> #define BUILD_CONTROLS_SHADOW(lname, uname)   __BUILD_CONTROLS_SHADOW(lname, uname, 32)
> #define BUILD_CONTROLS_SHADOW64(lname, uname) __BUILD_CONTROLS_SHADOW(lname, uname, 64)
