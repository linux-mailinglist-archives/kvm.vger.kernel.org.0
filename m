Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA556310679
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhBEIRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:17:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:45779 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhBEIRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:17:44 -0500
IronPort-SDR: ja+Hd8T03IL/KSij1j90C44fcpa9tftpPh5ussA+ZcDqzu2OfJG03szfSvEaKcOEdUU+QcBZuK
 OevFsBnS164A==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="266230891"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="266230891"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:17:00 -0800
IronPort-SDR: CchZAmIblgIWP22MZmvVbIL4x1przYjfvTwcnt6qRUXZmU6Pgu9C0riDl6EcUDAa75qkN8ImdH
 bugGpGDON5/w==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393757160"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:16:57 -0800
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
 <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
 <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
Date:   Fri, 5 Feb 2021 16:16:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I am wondering if it is acceptable for you to
review the minor Architecture LBR patch set without XSAVES for v5.12 ?

As far as I know, the guest Arch LBR  can still work without XSAVES support.

---
thx,likexu

On 2021/2/4 8:59, Xu, Like wrote:
> On 2021/2/3 22:37, Paolo Bonzini wrote:
>> On 03/02/21 14:57, Like Xu wrote:
>>> If CPUID.(EAX=07H, ECX=0):EDX[19] is exposed to 1, the KVM supports Arch
>>> LBRs and CPUID leaf 01CH indicates details of the Arch LBRs capabilities.
>>> As the first step, KVM only exposes the current LBR depth on the host for
>>> guest, which is likely to be the maximum supported value on the host.
>>>
>>> If KVM supports XSAVES, the CPUID.(EAX=0DH, ECX=1):EDX:ECX[bit 15]
>>> is also exposed to 1, which means the availability of support for Arch
>>> LBR configuration state save and restore. When available, guest software
>>> operating at CPL=0 can use XSAVES/XRSTORS manage supervisor state
>>> component Arch LBR for own purposes once IA32_XSS [bit 15] is set.
>>> XSAVE support for Arch LBRs is enumerated in CPUID.(EAX=0DH, ECX=0FH).
>>>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c   | 23 +++++++++++++++++++++++
>>>   arch/x86/kvm/vmx/vmx.c |  2 ++
>>>   arch/x86/kvm/x86.c     | 10 +++++++++-
>>>   3 files changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 944f518ca91b..900149eec42d 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -778,6 +778,29 @@ static inline int __do_cpuid_func(struct 
>>> kvm_cpuid_array *array, u32 function)
>>>               entry->edx = 0;
>>>           }
>>>           break;
>>> +    /* Architectural LBR */
>>> +    case 0x1c:
>>> +    {
>>> +        u64 lbr_depth_mask = 0;
>>> +
>>> +        if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
>>> +            entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>> +            break;
>>> +        }
>>> +
>>> +        /*
>>> +         * KVM only exposes the maximum supported depth,
>>> +         * which is also the fixed value used on the host.
>>> +         *
>>> +         * KVM doesn't allow VMM user sapce to adjust depth
>>> +         * per guest, because the guest LBR emulation depends
>>> +         * on the implementation of the host LBR driver.
>>> +         */
>>> +        lbr_depth_mask = 1UL << fls(entry->eax & 0xff);
>>> +        entry->eax &= ~0xff;
>>> +        entry->eax |= lbr_depth_mask;
>>> +        break;
>>> +    }
>>>       /* Intel PT */
>>>       case 0x14:
>>>           if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 9ddf0a14d75c..c22175d9564e 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -7498,6 +7498,8 @@ static __init void vmx_set_cpu_caps(void)
>>>           kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
>>>       if (vmx_pt_mode_is_host_guest())
>>>           kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
>>> +    if (cpu_has_vmx_arch_lbr())
>>> +        kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
>>>         if (vmx_umip_emulated())
>>>           kvm_cpu_cap_set(X86_FEATURE_UMIP);
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 667d0042d0b7..107f2e72f526 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -10385,8 +10385,16 @@ int kvm_arch_hardware_setup(void *opaque)
>>>         if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>>>           supported_xss = 0;
>>> -    else
>>> +    else {
>>>           supported_xss &= host_xss;
>>> +        /*
>>> +         * The host doesn't always set ARCH_LBR bit to hoss_xss since 
>>> this
>>> +         * Arch_LBR component is used on demand in the Arch LBR driver.
>>> +         * Check e649b3f0188f "Support dynamic supervisor feature for 
>>> LBR".
>>> +         */
>>> +        if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>>> +            supported_xss |= XFEATURE_MASK_LBR;
>>> +    }
>>>         /* Update CET features now that supported_xss is finalized. */
>>>       if (!kvm_cet_supported()) {
>>>
>>
>> This requires some of the XSS patches that Weijang posted for CET, right?
>
> Yes, at least we need three of them for Arch LBR:
>
> 3009dfd6d61f KVM: x86: Load guest fpu state when accessing MSRs managed 
> by XSAVES
> d39b0a16ad1f KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
> e98bf65e51c9 KVM: x86: Report XSS as an MSR to be saved if there are 
> supported features
>
>>
>> Also, who takes care of saving/restoring the MSRs, if the host has not 
>> added XFEATURE_MASK_LBR to MSR_IA32_XSS?
>
> I may not understand your concern on this. Let me try to explain:
>
> The guest Arch LBR driver will save the origin host_xss and
> mark the LBR bit only in the XSS and then save/restore MSRs
> in the extra specified guest memory, and restore the origin host_xss.
>
> On the host side, the same thing happens to vcpu thread
> due to the help of guest LBR event created by the vPMU
> and the hardware LBR MSRs are saved/restored in a exclusive way.
>
>>
>> Thanks,
>>
>> Paolo
>>
>

