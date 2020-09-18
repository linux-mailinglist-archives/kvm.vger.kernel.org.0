Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D324026F038
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgIRClv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 22:41:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:23951 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbgIRClX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 22:41:23 -0400
IronPort-SDR: ldM/cxTwKRhr+dhuox3U90S0Jj4OC2J6v04wLv0WMNvGlrEbOaL4JWL7gUFMc3fj/GEWZtosj4
 Ii1jgrQdaqgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147587885"
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="147587885"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 19:41:20 -0700
IronPort-SDR: g6C/AqcPT9vj3VXVQIh26xiFUtoD4S2mqdwPZJZRvTvdYIXpUVQL3TL0n3XVhVX3rxIKz2Z1YG
 2V5X/wxxsNIw==
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="452577463"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 19:41:20 -0700
Date:   Thu, 17 Sep 2020 19:41:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] KVM: x86: allocate vcpu->arch.cpuid_entries
 dynamically
Message-ID: <20200918024117.GC14678@sjchrist-ice>
References: <20200915154306.724953-1-vkuznets@redhat.com>
 <20200915154306.724953-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915154306.724953-2-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 05:43:05PM +0200, Vitaly Kuznetsov wrote:
> The current limit for guest CPUID leaves (KVM_MAX_CPUID_ENTRIES, 80)
> is reported to be insufficient but before we bump it let's switch to
> allocating vcpu->arch.cpuid_entries dynamically. Currenly,

                                                   Currently,

> 'struct kvm_cpuid_entry2' is 40 bytes so vcpu->arch.cpuid_entries is
> 3200 bytes which accounts for 1/4 of the whole 'struct kvm_vcpu_arch'
> but having it pre-allocated (for all vCPUs which we also pre-allocate)
> gives us no benefits.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> @@ -241,18 +253,31 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  			      struct kvm_cpuid2 *cpuid,
>  			      struct kvm_cpuid_entry2 __user *entries)
>  {
> +	struct kvm_cpuid_entry2 *cpuid_entries2 = NULL;
>  	int r;
>  
>  	r = -E2BIG;
>  	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
>  		goto out;
>  	r = -EFAULT;
> -	if (copy_from_user(&vcpu->arch.cpuid_entries, entries,
> -			   cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
> -		goto out;
> +
> +	if (cpuid->nent) {
> +		cpuid_entries2 = vmemdup_user(entries,
> +					      array_size(sizeof(cpuid_entries2[0]),
> +							 cpuid->nent));

Any objection to using something super short like "e2" instead of cpuid_entries2
so that this can squeeze on a single line, or at least be a little more sane?

> +		if (IS_ERR(cpuid_entries2)) {
> +			r = PTR_ERR(cpuid_entries2);
> +			goto out;

Don't suppose you'd want to opportunistically kill off these gotos?

> +		}
> +	}
> +	kvfree(vcpu->arch.cpuid_entries);

This is a bit odd.  The previous vcpu->arch.cpuid_entries is preserved on
allocation failure, but not on kvm_check_cpuid() failure.  Being destructive
on the "check" failure was always a bit odd, but it really stands out now.

Given that kvm_check_cpuid() now only does an actual check and not a big
pile of updates, what if we refactored the guts of kvm_find_cpuid_entry()
into yet another helper so that kvm_check_cpuid() could check the input
before crushing vcpu->arch.cpuid_entries?

	if (cpuid->nent) {
		e2 = vmemdup_user(entries, array_size(sizeof(e2[0]), cpuid->nent));
		if (IS_ERR(e2))
			return PTR_ERR(e2);

		r = kvm_check_cpuid(e2, cpuid->nent);
		if (r)
			return r;
	}

	vcpu->arch.cpuid_entries = e2;
	vcpu->arch.cpuid_nent = cpuid->nent;
	return 0;

> +	vcpu->arch.cpuid_entries = cpuid_entries2;
>  	vcpu->arch.cpuid_nent = cpuid->nent;
> +
>  	r = kvm_check_cpuid(vcpu);
>  	if (r) {
> +		kvfree(vcpu->arch.cpuid_entries);
> +		vcpu->arch.cpuid_entries = NULL;
>  		vcpu->arch.cpuid_nent = 0;
>  		goto out;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1994602a0851..42259a6ec1d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9610,6 +9610,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kvm_mmu_destroy(vcpu);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	free_page((unsigned long)vcpu->arch.pio_data);
> +	kvfree(vcpu->arch.cpuid_entries);
>  	if (!lapic_in_kernel(vcpu))
>  		static_key_slow_dec(&kvm_no_apic_vcpu);
>  }
> -- 
> 2.25.4
> 
