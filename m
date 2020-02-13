Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871D415C047
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgBMO0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:26:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:20110 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgBMO0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 09:26:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 06:26:43 -0800
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227245933"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.123]) ([10.255.30.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Feb 2020 06:26:41 -0800
Subject: Re: [PATCH 22/61] KVM: x86: Make kvm_mpx_supported() an inline
 function
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-23-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <05355867-58c6-06de-704c-286c8f57c838@intel.com>
Date:   Thu, 13 Feb 2020 22:26:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-23-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2020 2:51 AM, Sean Christopherson wrote:
> Expose kvm_mpx_supported() as a static inline so that it can be inlined
> in kvm_intel.ko.
> 
> No functional change intended.
> 

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 6 ------
>   arch/x86/kvm/cpuid.h | 1 -
>   arch/x86/kvm/x86.h   | 5 +++++
>   3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 84006cc4007c..d3c93b94abc3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -45,12 +45,6 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   	return ret;
>   }
>   
> -bool kvm_mpx_supported(void)
> -{
> -	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> -}
> -EXPORT_SYMBOL_GPL(kvm_mpx_supported);
> -
>   #define F feature_bit
>   
>   int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7366c618aa04..c1ac0995843d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -7,7 +7,6 @@
>   #include <asm/processor.h>
>   
>   int kvm_update_cpuid(struct kvm_vcpu *vcpu);
> -bool kvm_mpx_supported(void);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>   					      u32 function, u32 index);
>   int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 02b49ee49e24..bfac4a80956c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -283,6 +283,11 @@ enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vc
>   extern u64 host_xcr0;
>   extern u64 supported_xcr0;
>   
> +static inline bool kvm_mpx_supported(void)
> +{
> +	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +}
> +
>   extern unsigned int min_timer_period_us;
>   
>   extern bool enable_vmware_backdoor;
> 

