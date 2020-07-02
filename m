Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0407212CB2
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 21:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGBS7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 14:59:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:34250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgGBS7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 14:59:13 -0400
IronPort-SDR: TDfCyntwCHs/CwtxGutyY37rHGD6SsdRhnnDmMMlyyedVF5eumzxL2kM+bJFlu8oYmysXsME/m
 dpUeKTfAp8VA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="212034711"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="212034711"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:59:13 -0700
IronPort-SDR: YzTLt/T+mK9N9RTGwbAy/S5tmgEKsO7bJREBpaOjScr8Lf/fBZF6lvAWWk9T+KKDLC2G6r81MO
 d8g2cqceqIsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="278207421"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 02 Jul 2020 11:59:13 -0700
Date:   Thu, 2 Jul 2020 11:59:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: X86: Move kvm_x86_ops.update_vcpu_model()
 into kvm_update_vcpu_model()
Message-ID: <20200702185913.GI3575@linux.intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
 <20200623115816.24132-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623115816.24132-7-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 07:58:15PM +0800, Xiaoyao Li wrote:
> kvm_x86_ops.update_vcpu_model() is used to update vmx/svm vcpu settings
> based on updated CPUID settings. So it's supposed to be called after
> CPUIDs are fully updated, i.e., kvm_update_cpuid().
> 
> Move it in kvm_update_vcpu_model().

The changelog needs to provide an in-depth analysis of VMX and SVM to prove
that there are no existing dependencies in the ordering.  I've done the
analysis a few times over the past few years for a similar chage I carried
in my SGX code, but dropped that code a while back and haven't done the
analysis since.  Anyways, it should be documented.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> ---
>  arch/x86/kvm/cpuid.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d2f93823f9fd..5decc2dd5448 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -121,6 +121,8 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
>  
> +	kvm_x86_ops.update_vcpu_model(vcpu);
> +
>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	if (best && apic) {
>  		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> @@ -136,6 +138,7 @@ void kvm_update_vcpu_model(struct kvm_vcpu *vcpu)
>  		vcpu->arch.guest_supported_xcr0 =
>  			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
>  
> +

Spurious whitespace.

>  	/* Note, maxphyaddr must be updated before tdp_level. */
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
> @@ -224,7 +227,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  
>  	cpuid_fix_nx_cap(vcpu);
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.update_vcpu_model(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  
> @@ -254,7 +256,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  	}
>  
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops.update_vcpu_model(vcpu);
>  	kvm_update_cpuid(vcpu);
>  	kvm_update_vcpu_model(vcpu);
>  out:
> -- 
> 2.18.2
> 
