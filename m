Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7253F2662E2
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgIKQFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:05:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:51191 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIKQFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 12:05:21 -0400
IronPort-SDR: kys1aNcFhmZQPIqPTrk5KaDVrHUYPSrSXKkYEtlyYKFzAq8h38KpklnrtuP71OKO184uPDrl3H
 /7s7Baih+6Gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="158071546"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="158071546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 09:05:01 -0700
IronPort-SDR: J+uNvfXjsVKPaULLRObScXcXxC0aGVPmjVazhcEikrkeaQMnXn5rWg+TG/LI7fzWiTyQbwEHmM
 2PCEvdVhi3qg==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="300969658"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 09:04:58 -0700
Date:   Fri, 11 Sep 2020 09:04:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN
Message-ID: <20200911160455.GB4344@sjchrist-ice>
References: <20200911093147.484565-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911093147.484565-1-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 11:31:47AM +0200, Vitaly Kuznetsov wrote:
> Even without in-kernel LAPIC we should allow writing '0' to
> MSR_KVM_ASYNC_PF_EN as we're not enabling the mechanism. In
> particular, QEMU with 'kernel-irqchip=off' fails to start
> a guest with
> 
> qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
> 
> Fixes: 9d3c447c72fb2 ("KVM: X86: Fix async pf caused null-ptr-deref")
> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d39d6cf1d473..44a86f7f2397 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2730,9 +2730,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  	if (data & 0x30)
>  		return 1;
>  
> -	if (!lapic_in_kernel(vcpu))
> -		return 1;
> -
>  	vcpu->arch.apf.msr_en_val = data;
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu)) {
> @@ -2741,6 +2738,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  		return 0;
>  	}
>  
> +	if (!lapic_in_kernel(vcpu))

This doesn't actually verify that @data == 0.  kvm_pv_async_pf_enabled()
returns true iff KVM_ASYNC_PF_ENABLED and KVM_ASYNC_PF_DELIVERY_AS_INT are
set, e.g. this would allow setting one and not the other.  This also allows
userspace to set vcpu->arch.apf.msr_en_val to an unsupported value, i.e.
@data has already been propagated to the vcpu and isn't unwound.

Why not just pivot on @data when lapic_in_kernel() is false?  vcpu->arch.apic
is immutable so there's no need to update apf.msr_en_val in either direction.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 539ea1cd6020..36969d5ec291 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2735,7 +2735,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
                return 1;

        if (!lapic_in_kernel(vcpu))
-               return 1;
+               return data ? 1 : 0;

        vcpu->arch.apf.msr_en_val = data;


> +		return 1;
> +
>  	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
>  					sizeof(u64)))
>  		return 1;
> -- 
> 2.25.4
> 
