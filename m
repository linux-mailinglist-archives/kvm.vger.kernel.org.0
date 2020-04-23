Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4E1B615A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgDWQ4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:56:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:57896 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729685AbgDWQ4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:56:32 -0400
IronPort-SDR: 3BlYyVNj/vAYLoaK/7jtjRLpLXNwp1ogQRf3gtenegxcOKmNoTAhGPwT5FjVfR6cz+I+Q4hozC
 DH0xfarPWb5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:56:31 -0700
IronPort-SDR: pQYcwN/zIhJlMVvB52YVl4Ttgkv0Zub6V7g3IRK2tHK9OAWwX6uOkH8xSsyvzdH2fIZxkqKrs4
 QMlZheB3U/lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430390420"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 09:56:31 -0700
Date:   Thu, 23 Apr 2020 09:56:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 9/9] KVM: X86: Set CET feature bits for CPUID
 enumeration
Message-ID: <20200423165631.GB25564@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-10-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-10-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 04:18:46PM +0800, Yang Weijiang wrote:
> Set the feature bits so that CET capabilities can be seen
> in guest via CPUID enumeration. Add CR4.CET bit support
> in order to allow guest set CET master control bit(CR4.CET).
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/cpuid.c            | 4 ++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c944ad99692..5109c43c6981 100644
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
> index 25e9a11291b3..26ab959df92f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -366,6 +366,10 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	if (boot_cpu_has(X86_FEATURE_IBT))
> +		kvm_cpu_cap_set(X86_FEATURE_IBT);
> +	if (boot_cpu_has(X86_FEATURE_SHSTK))
> +		kvm_cpu_cap_set(X86_FEATURE_SHSTK);

This is the wrong way to advertise bits, the correct method is to declare
the flag in the appriorate kvm_cpu_cap_mask() call.  The manually handling
is only needed when the feature bit diverges from kernel support, either
because KVM allow a feature based purely on hardware support, e.g. LA57, or
when emulating a feature based on a different similar feature, e.g. the
STIBP/SSBD flags above.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6828be99b908..6262438f9527 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -329,7 +329,8 @@ void kvm_set_cpu_caps(void)
                F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
                F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
                F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-               F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+               F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+               F(SHSTK)
        );
        /* Set LA57 based on hardware capability. */
        if (cpuid_ecx(7) & F(LA57))
@@ -338,7 +339,7 @@ void kvm_set_cpu_caps(void)
        kvm_cpu_cap_mask(CPUID_7_EDX,
                F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
                F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-               F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
+               F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) | F(IBT)
        );

>  
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX512_BF16)
> -- 
> 2.17.2
> 
