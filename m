Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66903179E69
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 04:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCEDs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 22:48:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:54742 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgCEDs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 22:48:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 19:48:26 -0800
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234271358"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.168.47]) ([10.249.168.47])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 04 Mar 2020 19:48:23 -0800
Subject: Re: [PATCH v2 2/7] KVM: x86: Add helpers to perform CPUID-based guest
 vendor check
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-3-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b752a4d4-b469-1a1f-c064-bf98a0467d49@intel.com>
Date:   Thu, 5 Mar 2020 11:48:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305013437.8578-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/5/2020 9:34 AM, Sean Christopherson wrote:
> Add helpers to provide CPUID-based guest vendor checks, i.e. to do the
> ugly register comparisons.  Use the new helpers to check for an AMD
> guest vendor in guest_cpuid_is_amd() as well as in the existing emulator
> flows.
> 
> Using the new helpers fixes a _very_ theoretical bug where
> guest_cpuid_is_amd() would get a false positive on a non-AMD virtual CPU
> with a vendor string beginning with "Auth" due to the previous logic
> only checking EBX.  It also fixes a marginally less theoretically bug
> where guest_cpuid_is_amd() would incorrectly return false for a guest
> CPU with "AMDisbetter!" as its vendor string.
> 
> Fixes: a0c0feb57992c ("KVM: x86: reserve bit 8 of non-leaf PDPEs and PML4Es in 64-bit mode on AMD")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/include/asm/kvm_emulate.h | 24 ++++++++++++++++++++
>   arch/x86/kvm/cpuid.h               |  2 +-
>   arch/x86/kvm/emulate.c             | 36 +++++++-----------------------
>   3 files changed, 33 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index bf5f5e476f65..2754972c36e6 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -393,6 +393,30 @@ struct x86_emulate_ctxt {
>   #define X86EMUL_CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
>   #define X86EMUL_CPUID_VENDOR_GenuineIntel_edx 0x49656e69
>   
> +static inline bool is_guest_vendor_intel(u32 ebx, u32 ecx, u32 edx)
> +{
> +	return ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
> +	       ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
> +	       edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx;
> +}
> +
> +static inline bool is_guest_vendor_amd(u32 ebx, u32 ecx, u32 edx)
> +{
> +	return (ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&
> +		ecx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
> +		edx == X86EMUL_CPUID_VENDOR_AuthenticAMD_edx) ||
> +	       (ebx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx &&
> +		ecx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx &&
> +		edx == X86EMUL_CPUID_VENDOR_AMDisbetterI_edx);
> +}
> +
> +static inline bool is_guest_vendor_hygon(u32 ebx, u32 ecx, u32 edx)
> +{
> +	return ebx == X86EMUL_CPUID_VENDOR_HygonGenuine_ebx &&
> +	       ecx == X86EMUL_CPUID_VENDOR_HygonGenuine_ecx &&
> +	       edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx;
> +}
> +

Why not define those in cpuid.h ?
And also move X86EMUL_CPUID_VENDOR_* to cpuid.h and remove the "EMUL" 
prefix.

>   enum x86_intercept_stage {
>   	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
>   	X86_ICPT_PRE_EXCEPT,
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7366c618aa04..13eb3e92c6a9 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -145,7 +145,7 @@ static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
>   	struct kvm_cpuid_entry2 *best;
>   
>   	best = kvm_find_cpuid_entry(vcpu, 0, 0);
> -	return best && best->ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx;
> +	return best && is_guest_vendor_amd(best->ebx, best->ecx, best->edx);
>   }
>   
>   static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index dd19fb3539e0..9cf303984fe5 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2712,9 +2712,7 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
>   
>   	eax = ecx = 0;
>   	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
> -	return ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx
> -		&& ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx
> -		&& edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx;
> +	return is_guest_vendor_intel(ebx, ecx, edx);
>   }
>   
>   static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
> @@ -2733,34 +2731,16 @@ static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
>   	ecx = 0x00000000;
>   	ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
>   	/*
> -	 * Intel ("GenuineIntel")
> -	 * remark: Intel CPUs only support "syscall" in 64bit
> -	 * longmode. Also an 64bit guest with a
> -	 * 32bit compat-app running will #UD !! While this
> -	 * behaviour can be fixed (by emulating) into AMD
> -	 * response - CPUs of AMD can't behave like Intel.
> +	 * remark: Intel CPUs only support "syscall" in 64bit longmode. Also a
> +	 * 64bit guest with a 32bit compat-app running will #UD !! While this
> +	 * behaviour can be fixed (by emulating) into AMD response - CPUs of
> +	 * AMD can't behave like Intel.
>   	 */
> -	if (ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
> -	    ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
> -	    edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx)
> +	if (is_guest_vendor_intel(ebx, ecx, edx))
>   		return false;
>   
> -	/* AMD ("AuthenticAMD") */
> -	if (ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&
> -	    ecx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
> -	    edx == X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
> -		return true;
> -
> -	/* AMD ("AMDisbetter!") */
> -	if (ebx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx &&
> -	    ecx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx &&
> -	    edx == X86EMUL_CPUID_VENDOR_AMDisbetterI_edx)
> -		return true;
> -
> -	/* Hygon ("HygonGenuine") */
> -	if (ebx == X86EMUL_CPUID_VENDOR_HygonGenuine_ebx &&
> -	    ecx == X86EMUL_CPUID_VENDOR_HygonGenuine_ecx &&
> -	    edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx)
> +	if (is_guest_vendor_amd(ebx, ecx, edx) ||
> +	    is_guest_vendor_hygon(ebx, ecx, edx))
>   		return true;
>   
>   	/*
> 

