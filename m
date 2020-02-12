Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB715AD3B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgBLQWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:22:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:17698 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgBLQWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:22:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 08:22:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="380807826"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 12 Feb 2020 08:22:20 -0800
Date:   Wed, 12 Feb 2020 08:22:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
Message-ID: <20200212162220.GA15617@linux.intel.com>
References: <20200206221434.23790-1-sean.j.christopherson@intel.com>
 <878sleg2z7.fsf@vitty.brq.redhat.com>
 <20200207155539.GC2401@linux.intel.com>
 <408bfd4c-7407-48cd-95fb-db44a7c1c2bf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408bfd4c-7407-48cd-95fb-db44a7c1c2bf@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 12:55:09PM +0100, Paolo Bonzini wrote:
> On 07/02/20 16:55, Sean Christopherson wrote:
> > It becomes a matter of weighing the maintenance cost and robustness against
> > the performance benefits.  For the TDP case, amost no one (that cares about
> > performance) uses shadow paging, the change is very explicit, tiny and
> > isolated, and TDP page fault are a hot path, e.g. when booting the VM.
> > I.e. low maintenance overhead, still robust, and IMO worth the shenanigans.
> 
> The "NULL" trick does not seem needed though.  Any objections to this?

Nope, no objections.

> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 9277ee8a54a5..a647601c9e1c 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -109,7 +109,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					u32 err, bool prefault)
>  {
>  #ifdef CONFIG_RETPOLINE
> -	if (likely(!vcpu->arch.mmu->page_fault))
> +	if (likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
>  		return kvm_tdp_page_fault(vcpu, cr2_or_gpa, err, prefault);
>  #endif
>  	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5267f1440677..87e9ba27ada1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4925,12 +4925,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	context->mmu_role.as_u64 = new_role.as_u64;
> -#ifdef CONFIG_RETPOLINE
> -	/* Nullify ->page_fault() to use direct kvm_tdp_page_fault() call. */
> -	context->page_fault = NULL;
> -#else
>  	context->page_fault = kvm_tdp_page_fault;
> -#endif
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = nonpaging_invlpg;
>  	context->update_pte = nonpaging_update_pte;
> 
> Paolo
> 
