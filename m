Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFBA212BFB
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGBSQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 14:16:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:24084 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgGBSQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 14:16:09 -0400
IronPort-SDR: uibqNT2r1goJGuROwetVvMgX4nUIj2g3kxGFV9vTVYEGNFY/rmuc1XZeJ7bqldmrrQafwQdvqM
 AtFYwn5FkdZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="208511650"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="208511650"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:16:07 -0700
IronPort-SDR: FZCac+/n1T105djQwmNPNfSwk8S0quKaIoqXlTlhP7d4BBLOqggajyznlb2XQcUeKNXgunBET+
 qLuPMah//6Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="321593912"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jul 2020 11:16:06 -0700
Date:   Thu, 2 Jul 2020 11:16:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
Message-ID: <20200702181606.GF3575@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702174455.282252-1-mlevitsk@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 08:44:55PM +0300, Maxim Levitsky wrote:
> There are few cases when this function was creating a bogus #GP condition,
> for example case when and AMD host supports STIBP but doesn't support SSBD.
> 
> Follow the rules for AMD and Intel strictly instead.

Can you elaborate on the conditions that are problematic, e.g. what does
the guest expect to exist that KVM isn't providing?

> AMD #GP rules for IA32_SPEC_CTRL can be found here:
> https://bugzilla.kernel.org/show_bug.cgi?id=199889
> 
> Fixes: 6441fa6178f5 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL")
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 57 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..a6bed4670b7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10670,27 +10670,54 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  
> -u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> +
> +static u64 kvm_spec_ctrl_valid_bits_host(void)
> +{
> +	uint64_t bits = 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> +		bits |= SPEC_CTRL_IBRS;
> +	if (boot_cpu_has(X86_FEATURE_INTEL_STIBP))
> +		bits |= SPEC_CTRL_STIBP;
> +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
> +		bits |= SPEC_CTRL_SSBD;
> +
> +	if (boot_cpu_has(X86_FEATURE_AMD_IBRS) || boot_cpu_has(X86_FEATURE_AMD_STIBP))
> +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
> +
> +	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;
> +
> +	return bits;
> +}

Rather than compute the mask every time, it can be computed once on module
load and stashed in a global.  Note, there's a RFC series[*] to support
reprobing bugs at runtime, but that has bigger issues with existing KVM
functionality to be addressed, i.e. it's not our problem, yet :-).

[*] https://lkml.kernel.org/r/1593703107-8852-1-git-send-email-mihai.carabas@oracle.com

> +
> +static u64 kvm_spec_ctrl_valid_bits_guest(struct kvm_vcpu *vcpu)
>  {
> -	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
> +	uint64_t bits = 0;
>  
> -	/* The STIBP bit doesn't fault even if it's not advertised */
> -	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> -	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
> -		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> -	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
> -	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
> -		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +		bits |= SPEC_CTRL_IBRS;
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_INTEL_STIBP))
> +		bits |= SPEC_CTRL_STIBP;
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD))
> +		bits |= SPEC_CTRL_SSBD;
>  
> -	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
> -	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> -		bits &= ~SPEC_CTRL_SSBD;
> -	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
> -	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -		bits &= ~SPEC_CTRL_SSBD;
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> +			guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP))

Bad indentation.

> +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS;
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> +		bits |= SPEC_CTRL_STIBP | SPEC_CTRL_IBRS | SPEC_CTRL_SSBD;

Would it be feasible to split into two patches?  The first (tagged Fixes:)
to make the functional changes without inverting the logic or splitting, and
then do the cleanup?  It's really hard to review this patch because I can't
easily tease out what's different in terms of functionality.

>  	return bits;
>  }
> +
> +u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_spec_ctrl_valid_bits_host() &
> +	       kvm_spec_ctrl_valid_bits_guest(vcpu);
> +}
> +
> +
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> -- 
> 2.25.4
> 
