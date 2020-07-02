Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57077212CB4
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 21:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgGBTAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 15:00:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:34347 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgGBTAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 15:00:22 -0400
IronPort-SDR: 8hf33vtWaHk+NCbu1bYQYwAjK/vmrqlvNvWCFZox8cpwcjHaZLVVOeFN8/xHzkSOxfo42CQfrN
 BIXD+N2Gez+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="212034856"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="212034856"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 12:00:10 -0700
IronPort-SDR: rqLQjWA58hjTkjuJMBEnTweEPcjLNq5OVXnCC/UdhdWcmNjstQ0OlIyq999z+668H2OVHJwvTI
 Ku1wjv5p0FaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="295988111"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 02 Jul 2020 12:00:09 -0700
Date:   Thu, 2 Jul 2020 12:00:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] KVM: X86: Move kvm_apic_set_version() to
 kvm_update_vcpu_model()
Message-ID: <20200702190009.GJ3575@linux.intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-8-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623115816.24132-8-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 07:58:16PM +0800, Xiaoyao Li wrote:
> Obviously, kvm_apic_set_version() fits well in kvm_update_vcpu_model().

Same as the last patch, it would be nice to explicitly document that there
are no dependencies between kvm_apic_set_version() and kvm_update_cpuid().

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5decc2dd5448..3428f4d84b42 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -129,6 +129,8 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
>  			apic->lapic_timer.timer_mode_mask = 3 << 17;
>  		else
>  			apic->lapic_timer.timer_mode_mask = 1 << 17;
> +
> +		kvm_apic_set_version(vcpu);
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
> @@ -226,7 +228,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  	}
>  
>  	cpuid_fix_nx_cap(vcpu);
> -	kvm_apic_set_version(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  
> @@ -255,7 +256,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  		goto out;
>  	}
>  
> -	kvm_apic_set_version(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  out:
> -- 
> 2.18.2
> 
