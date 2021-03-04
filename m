Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E110532CB22
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 04:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhCDDpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 22:45:11 -0500
Received: from mga17.intel.com ([192.55.52.151]:11266 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233032AbhCDDor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 22:44:47 -0500
IronPort-SDR: pzfjg/hFb2M+itgWDyKc3+dUO/5QqxuVmlZG2v7J9nwLfEjHWsXEiKUirZ1n3zRLmkYbSpBszZ
 xDbu4dAhwCNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="167232054"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="167232054"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 19:43:15 -0800
IronPort-SDR: GWymfTxRVoqXNB056u0rdKA7QLkuLPbBV+Ukh/yzGWb4LHrTzzbSexekVNR8QcoUJlhajFcjAV
 CMAb4/MC6yUA==
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="400389470"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 19:43:12 -0800
Subject: Re: [PATCH v3 9/9] KVM: x86: Add XSAVE Support for Architectural LBRs
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-10-like.xu@linux.intel.com>
 <YD/PYp0DtZaw2HYh@google.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <b6b3476b-3278-9a40-33a9-0014fed9bbfb@linux.intel.com>
Date:   Thu, 4 Mar 2021 11:43:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YD/PYp0DtZaw2HYh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/4 2:03, Sean Christopherson wrote:
> On Wed, Mar 03, 2021, Like Xu wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 034708a3df20..ec4593e0ee6d 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7268,6 +7268,8 @@ static __init void vmx_set_cpu_caps(void)
>>   	supported_xss = 0;
>>   	if (!cpu_has_vmx_xsaves())
>>   		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>> +	else if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> +		supported_xss |= XFEATURE_MASK_LBR;
>>   
>>   	/* CPUID 0x80000001 */
>>   	if (!cpu_has_vmx_rdtscp())
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d773836ceb7a..bca2e318ff24 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10433,6 +10433,8 @@ int kvm_arch_hardware_setup(void *opaque)
>>   
>>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>   		supported_xss = 0;
>> +	else
>> +		supported_xss &= host_xss;
> 
> Not your fault by any means, but I would prefer to have matching logic for XSS
> and XCR0.  The existing clearing of supported_xss here is pointless.  E.g. I'd
> prefer something like the following, though Paolo may have a different opinion.

I have no preference for where to do rdmsrl() in kvm_arch_init()
or kvm_arch_hardware_setup().

It's true the assignment of supported_xss in the kvm/intel
tree is redundant and introducing KVM_SUPPORTED_XSS is also fine to me.


> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d7e760fdfa0..c781034463e5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7244,12 +7244,15 @@ static __init void vmx_set_cpu_caps(void)
>                  kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
>          if (vmx_pt_mode_is_host_guest())
>                  kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
> +       if (!cpu_has_vmx_arch_lbr()) {
> +               kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
> +               supported_xss &= ~XFEATURE_MASK_LBR;
> +       }
> 

I will move the above part to the LBR patch
and leave the left part as a pre-patch for Paolo's review.

>          if (vmx_umip_emulated())
>                  kvm_cpu_cap_set(X86_FEATURE_UMIP);
> 
>          /* CPUID 0xD.1 */
> -       supported_xss = 0;
>          if (!cpu_has_vmx_xsaves())
>                  kvm_cpu_cap_clear(X86_FEATURE_XSAVES);

if (!cpu_has_vmx_xsaves())
	supported_xss = 0;
	kvm_cpu_cap_clear(X86_FEATURE_XSAVES);

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7b0adebec1ef..5f9eb1f5b840 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -205,6 +205,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>                                  | XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>                                  | XFEATURE_MASK_PKRU)
> 
> +#define KVM_SUPPORTED_XSS      XFEATURE_MASK_LBR
> +
>   u64 __read_mostly host_efer;
>   EXPORT_SYMBOL_GPL(host_efer);
> 
> @@ -8037,6 +8039,11 @@ int kvm_arch_init(void *opaque)
>                  supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
>          }
> 
> +       if (boot_cpu_has(X86_FEATURE_XSAVES))

{

> +               rdmsrl(MSR_IA32_XSS, host_xss);
> +               supported_xss = host_xss & KVM_SUPPORTED_XSS;
> +       }
> +
>          if (pi_inject_timer == -1)
>                  pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
>   #ifdef CONFIG_X86_64
> @@ -10412,9 +10419,6 @@ int kvm_arch_hardware_setup(void *opaque)
> 
>          rdmsrl_safe(MSR_EFER, &host_efer);
> 
> -       if (boot_cpu_has(X86_FEATURE_XSAVES))
> -               rdmsrl(MSR_IA32_XSS, host_xss);
> -
>          r = ops->hardware_setup();
>          if (r != 0)
>                  return r;
> @@ -10422,9 +10426,6 @@ int kvm_arch_hardware_setup(void *opaque)
>          memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>          kvm_ops_static_call_update();
> 
> -       if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> -               supported_xss = 0;
> -
>   #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>          cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>   #undef __kvm_cpu_cap_has
> 

