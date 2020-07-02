Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC829212C91
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgGBSyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 14:54:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:33859 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgGBSyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 14:54:03 -0400
IronPort-SDR: S9ILGZcGBBcjMcL0lYqjP9z3mJWEqF6tNU7eVKyQikHXNJddRwGCWqzZQ+r1y9L8LCaK5Aplah
 zEEO4Xodtzaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="212034227"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="212034227"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:54:03 -0700
IronPort-SDR: CC/vtgNsaWOz//xrtb6pWysiLk9porL5m+VulPA8Ik9jNfAKqYSRTILgihgSFwQbuTT8sMN++q
 BRAUNlUi0hxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="455622731"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 02 Jul 2020 11:54:03 -0700
Date:   Thu, 2 Jul 2020 11:54:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] KVM: X86: Go on updating other CPUID leaves when
 leaf 1 is absent
Message-ID: <20200702185403.GH3575@linux.intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623115816.24132-3-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 07:58:11PM +0800, Xiaoyao Li wrote:
> As handling of bits other leaf 1 added over time, kvm_update_cpuid()
> should not return directly if leaf 1 is absent, but should go on
> updateing other CPUID leaves.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

This should probably be marked for stable.

> ---
>  arch/x86/kvm/cpuid.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1d13bad42bf9..0164dac95ef5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -60,22 +60,21 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
> -	if (!best)
> -		return 0;

Rather than wrap the existing code, what about throwing it in a separate
helper?  That generates an easier to read diff and also has the nice
property of getting 'apic' out of the common code.

> -
> -	/* Update OSXSAVE bit */
> -	if (boot_cpu_has(X86_FEATURE_XSAVE) && best->function == 0x1)
> -		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> +	if (best) {
> +		/* Update OSXSAVE bit */
> +		if (boot_cpu_has(X86_FEATURE_XSAVE))
> +			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
>  				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
>  
> -	cpuid_entry_change(best, X86_FEATURE_APIC,
> +		cpuid_entry_change(best, X86_FEATURE_APIC,
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>  
> -	if (apic) {
> -		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> -			apic->lapic_timer.timer_mode_mask = 3 << 17;
> -		else
> -			apic->lapic_timer.timer_mode_mask = 1 << 17;
> +		if (apic) {
> +			if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> +				apic->lapic_timer.timer_mode_mask = 3 << 17;
> +			else
> +				apic->lapic_timer.timer_mode_mask = 1 << 17;
> +		}
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> -- 
> 2.18.2
> 
