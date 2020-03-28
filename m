Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1719686E
	for <lists+kvm@lfdr.de>; Sat, 28 Mar 2020 19:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgC1S3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Mar 2020 14:29:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:54936 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgC1S3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Mar 2020 14:29:52 -0400
IronPort-SDR: A0tfWluWzFJAN1qmmXhYRkMAZGq20yiH1WUpT0nFXZtwy0vFxxMH1qXswNBoKoT2WCwRFval1P
 GCQdOW2IiT/g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2020 11:29:51 -0700
IronPort-SDR: dZJ8l2AFLuB2WfezcrgkOfi5968u+3mDyCBouG/Kf/rrItkVep/KyH52pHpKcuUzQJpL497WJm
 g+FS51zzM+MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,317,1580803200"; 
   d="scan'208";a="294209453"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Mar 2020 11:29:51 -0700
Date:   Sat, 28 Mar 2020 11:29:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Sync SPTEs when injecting page/EPT fault
 into L1
Message-ID: <20200328182951.GR8104@linux.intel.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326093516.24215-4-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 05:35:16AM -0400, Paolo Bonzini wrote:
> From: Junaid Shahid <junaids@google.com>
> 
> When injecting a page fault or EPT violation/misconfiguration, KVM is
> not syncing any shadow PTEs associated with the faulting address,
> including those in previous MMUs that are associated with L1's current
> EPTP (in a nested EPT scenario), nor is it flushing any hardware TLB
> entries.  All this is done by kvm_mmu_invalidate_gva.
> 
> Page faults that are either !PRESENT or RSVD are exempt from the flushing,
> as the CPU is not allowed to cache such translations.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Message-Id: <20200320212833.3507-8-sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 12 ++++++------
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  arch/x86/kvm/x86.c        | 11 ++++++++++-
>  3 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 522905523bf0..dbca6c3bd0db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -618,8 +618,17 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>  	WARN_ON_ONCE(fault->vector != PF_VECTOR);
>  
>  	fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu : vcpu->arch.walk_mmu;
> -	fault_mmu->inject_page_fault(vcpu, fault);
>  
> +	/*
> +	 * Invalidate the TLB entry for the faulting address, if it exists,
> +	 * else the access will fault indefinitely (and to emulate hardware).
> +	 */
> +	if ((fault->error_code & PFERR_PRESENT_MASK)
> +	    && !(fault->error_code & PFERR_RSVD_MASK))

What kind of heathen puts && on the new line?  :-D

> +		kvm_mmu_invalidate_gva(vcpu, fault_mmu,
> +				       fault->address, fault_mmu->root_hpa);

Another nit, why have the new line after fault_mmu?  I.e.

		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
				       fault_mmu->root_hpa);


> +
> +	fault_mmu->inject_page_fault(vcpu, fault);
>  	return fault->nested_page_fault;
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
> -- 
> 2.18.2
> 
