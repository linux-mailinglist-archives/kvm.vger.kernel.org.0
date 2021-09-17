Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313D240FDA5
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhIQQPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:15:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:1339 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhIQQPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 12:15:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="222879894"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="222879894"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:14:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546478238"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.208.219]) ([10.254.208.219])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:14:01 -0700
Subject: Re: [PATCH v4 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
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
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-3-guang.zeng@intel.com> <YTvOE3p7WRGYUg9h@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <9f8585cd-9c99-b8bd-8400-0fa922b0d361@intel.com>
Date:   Sat, 18 Sep 2021 00:13:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTvOE3p7WRGYUg9h@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2021 5:28 AM, Sean Christopherson wrote:
> On Mon, Aug 09, 2021, Zeng Guang wrote:
>> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
>> +{									\
>> +	return vmx->loaded_vmcs->controls_shadow.lname;			\
>> +}									\
> This conflicts with commit 389ab25216c9 ("KVM: nVMX: Pull KVM L0's desired controls
> directly from vmcs01"), I believe the correct resolution is:
>
> ---
>   arch/x86/kvm/vmx/vmx.h | 59 ++++++++++++++++++++++--------------------
>   1 file changed, 31 insertions(+), 28 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4858c5fd95f2..1ae43afe52a7 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -408,35 +408,38 @@ static inline u8 vmx_get_rvi(void)
>   	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>   }
>
> -#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
> -static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
> -{									    \
> -	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
> -		vmcs_write32(uname, val);				    \
> -		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
> -	}								    \
> -}									    \
> -static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
> -{									    \
> -	return vmcs->controls_shadow.lname;				    \
> -}									    \
> -static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
> -{									    \
> -	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
> -}									    \
> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
> -{									    \
> -	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
> -}									    \
> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
> -{									    \
> -	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
> +#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			\
> +static inline								\
> +void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)		\
> +{									\
> +	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		\
> +		vmcs_write##bits(uname, val);				\
> +		vmx->loaded_vmcs->controls_shadow.lname = val;		\
> +	}								\
> +}									\
> +static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)\
> +{									\
> +	return vmcs->controls_shadow.lname;				\
> +}									\
> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
> +{									\
> +	return __##lname##_controls_get(vmx->loaded_vmcs);		\
> +}									\
> +static inline								\
> +void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)		\
> +{									\
> +	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	\
> +}									\
> +static inline								\
> +void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> +{									\
> +	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	\
>   }
> -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
> -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
> -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
>
>   static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
>   {
> --

I will rebase it. Thanks.


