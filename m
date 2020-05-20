Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8378A1DA9C5
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 07:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgETFSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 01:18:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:31204 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgETFSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 01:18:21 -0400
IronPort-SDR: CWxmLo0KjVeChSzZoIJVfr23xyT283Eq05Ae1pSNgvysnvo+In099WIymUnnqdx3JGsF2qgiEV
 jHmidRfngMpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 22:18:21 -0700
IronPort-SDR: CkTefz0UaEQsehSmtFPRAmHr+Rb9O3PeLamnbTw/CO1N+elDvv0MngIfdDGSWfb0grkvZ/43jM
 I1762b+WVs1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,412,1583222400"; 
   d="scan'208";a="268148079"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 19 May 2020 22:18:21 -0700
Date:   Tue, 19 May 2020 22:18:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 10/10] KVM: x86: Enable CET virtualization and
 advertise CET to userspace
Message-ID: <20200520051820.GA16252@linux.intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
 <20200506082110.25441-11-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506082110.25441-11-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 04:21:09PM +0800, Yang Weijiang wrote:
> Set the feature bits so that CET capabilities can be seen in guest via
> CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
> master control bit(CR4.CET).
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/cpuid.c            | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f68c825e94ad..21f3c89d8c70 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -95,7 +95,8 @@
>  			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_CET))
>  
>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 984ab2b395b3..333a9e0d7cdf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -344,7 +344,8 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> -		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
> +		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> +		F(SHSTK)
>  	);
>  	/* Set LA57 based on hardware capability. */
>  	if (cpuid_ecx(7) & F(LA57))
> @@ -353,7 +354,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) | F(IBT)

SHSTK and IBT need to be disabled in vmx_set_cpu_caps() if unrestricted guest
is disabled.  CET won't play nice with emulating arbitrary instructions, e.g.
KVM doesn't enforce ENDBR and doesn't keep SSP up-to-date (and no one is
advocating fully emulating CET).

Paolo also floated the idea of providing a reduced opcode set, e.g. only I/O,
MOV, and ALU instructions, but I don't think that needs to be done in the
initial CET enabling as it's more of a defense-in-depth than a functional
requirement.

No need to respin a new series just for this, it can wait until I've looked
through this version.

Original thread: https://lkml.kernel.org/r/20200515161919.29249-1-pbonzini@redhat.com

>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> -- 
> 2.17.2
> 
