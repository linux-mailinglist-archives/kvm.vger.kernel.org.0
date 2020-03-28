Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264CE1968A2
	for <lists+kvm@lfdr.de>; Sat, 28 Mar 2020 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgC1Slu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Mar 2020 14:41:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:22605 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgC1Slt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Mar 2020 14:41:49 -0400
IronPort-SDR: RlnRSN+pyFK1kJegySdbJRIBypfNEwgGSlc6LdmKhwyzxjn4gGfIDxYmuU3QwMWuv6LAsAgQjm
 8SkshtvpcDKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2020 11:41:49 -0700
IronPort-SDR: sdpObI+vzRvcuRArPN5Pm5hmAeAQrvPL3U7SKzrdF68D/YCGs2cDX1gUBFBJWLb3bsQ/A4O34P
 pXiU6CCLVbTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,317,1580803200"; 
   d="scan'208";a="236953833"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 28 Mar 2020 11:41:49 -0700
Date:   Sat, 28 Mar 2020 11:41:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: cleanup kvm_inject_emulated_page_fault
Message-ID: <20200328184149.GS8104@linux.intel.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326093516.24215-3-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 05:35:15AM -0400, Paolo Bonzini wrote:
> To reconstruct the kvm_mmu to be used for page fault injection, we
> can simply use fault->nested_page_fault.  This matches how
> fault->nested_page_fault is assigned in the first place by
> FNAME(walk_addr_generic).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 6 ------
>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>  arch/x86/kvm/x86.c             | 7 +++----
>  3 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e26c9a583e75..6250e31ac617 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4353,12 +4353,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr3(vcpu);
>  }
>  
> -static void inject_page_fault(struct kvm_vcpu *vcpu,
> -			      struct x86_exception *fault)
> -{
> -	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
> -}
> -
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access, int *nr_present)
>  {
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 1ddbfff64ccc..ae646acf6703 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -812,7 +812,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	if (!r) {
>  		pgprintk("%s: guest page fault\n", __func__);
>  		if (!prefault)
> -			inject_page_fault(vcpu, &walker.fault);
> +			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
>  
>  		return RET_PF_RETRY;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 64ed6e6e2b56..522905523bf0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -614,12 +614,11 @@ EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
>  bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>  				    struct x86_exception *fault)
>  {
> +	struct kvm_mmu *fault_mmu;
>  	WARN_ON_ONCE(fault->vector != PF_VECTOR);
>  
> -	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
> -		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
> -	else
> -		vcpu->arch.mmu->inject_page_fault(vcpu, fault);
> +	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu : vcpu->arch.walk_mmu;

Apparently I'm in a nitpicky mood.  IMO, a newline after the colon is
easier to parse

	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu :
					       vcpu->arch.walk_mmu;

FWIW, I really like that "inject into the nested_mmu if it's not a nested
page fault" logic goes away.  That trips me up every time I look at it.

> +	fault_mmu->inject_page_fault(vcpu, fault);
>  
>  	return fault->nested_page_fault;
>  }
> -- 
> 2.18.2
> 
> 
