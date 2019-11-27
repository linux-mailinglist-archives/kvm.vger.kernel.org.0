Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE85C10B55A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfK0SPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:15:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:13404 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfK0SPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:15:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:15:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="383579517"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 27 Nov 2019 10:15:40 -0800
Date:   Wed, 27 Nov 2019 10:15:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 01/28] kvm: mmu: Separate generating and setting mmio
 ptes
Message-ID: <20191127181540.GA22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-2-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:17:57PM -0700, Ben Gardon wrote:
> Separate the functions for generating MMIO page table entries from the
> function that inserts them into the paging structure. This refactoring
> will allow changes to the MMU sychronization model to use atomic
> compare / exchanges (which are not guaranteed to succeed) instead of a
> monolithic MMU lock.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5269aa057dfa6..781c2ca7455e3 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -390,8 +390,7 @@ static u64 get_mmio_spte_generation(u64 spte)
>  	return gen;
>  }
>  
> -static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> -			   unsigned access)
> +static u64 generate_mmio_pte(struct kvm_vcpu *vcpu, u64 gfn, unsigned access)

Maybe get_mmio_spte_value()?  I see "generate" and all I can think of is
the generation number and nothing else.

>  {
>  	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
>  	u64 mask = generation_mmio_spte_mask(gen);
> @@ -403,6 +402,17 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
>  	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< shadow_nonpresent_or_rsvd_mask_len;
>  
> +	return mask;
> +}
> +
> +static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> +			   unsigned access)
> +{
> +	u64 mask = generate_mmio_pte(vcpu, gfn, access);
> +	unsigned int gen = get_mmio_spte_generation(mask);
> +
> +	access = mask & ACC_ALL;
> +
>  	trace_mark_mmio_spte(sptep, gfn, access, gen);
>  	mmu_spte_set(sptep, mask);
>  }
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
