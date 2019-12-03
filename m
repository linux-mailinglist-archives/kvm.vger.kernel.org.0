Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7294510F3D4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 01:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfLCANo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 19:13:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:47579 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfLCANo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 19:13:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 16:13:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="262392464"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Dec 2019 16:13:43 -0800
Date:   Mon, 2 Dec 2019 16:13:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 12/28] kvm: mmu: Set tlbs_dirty atomically
Message-ID: <20191203001343.GJ8120@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-13-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-13-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:08PM -0700, Ben Gardon wrote:
> The tlbs_dirty mechanism for deferring flushes can be expanded beyond
> its current use case. This allows MMU operations which do not
> themselves require TLB flushes to notify other threads that there are
> unflushed modifications to the paging structure. In order to use this
> mechanism concurrently, the updates to the global tlbs_dirty must be
> made atomically.

If there is a hard requirement that tlbs_dirty must be updated atomically
then it needs to be an actual atomic so that the requirement is enforced.
 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/paging_tmpl.h | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 97903c8dcad16..cc3630c8bd3ea 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -986,6 +986,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  	bool host_writable;
>  	gpa_t first_pte_gpa;
>  	int set_spte_ret = 0;
> +	int ret;
> +	int tlbs_dirty = 0;
>  
>  	/* direct kvm_mmu_page can not be unsync. */
>  	BUG_ON(sp->role.direct);
> @@ -1004,17 +1006,13 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
>  
>  		if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
> -					       sizeof(pt_element_t)))
> -			return 0;
> +					       sizeof(pt_element_t))) {
> +			ret = 0;
> +			goto out;
> +		}
>  
>  		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
> -			/*
> -			 * Update spte before increasing tlbs_dirty to make
> -			 * sure no tlb flush is lost after spte is zapped; see
> -			 * the comments in kvm_flush_remote_tlbs().
> -			 */
> -			smp_wmb();
> -			vcpu->kvm->tlbs_dirty++;
> +			tlbs_dirty++;
>  			continue;
>  		}
>  
> @@ -1029,12 +1027,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  
>  		if (gfn != sp->gfns[i]) {
>  			drop_spte(vcpu->kvm, &sp->spt[i]);
> -			/*
> -			 * The same as above where we are doing
> -			 * prefetch_invalid_gpte().
> -			 */
> -			smp_wmb();
> -			vcpu->kvm->tlbs_dirty++;
> +			tlbs_dirty++;
>  			continue;
>  		}
>  
> @@ -1051,7 +1044,11 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
>  		kvm_flush_remote_tlbs(vcpu->kvm);
>  
> -	return nr_present;
> +	ret = nr_present;
> +
> +out:
> +	xadd(&vcpu->kvm->tlbs_dirty, tlbs_dirty);

Collecting and applying vcpu->kvm->tlbs_dirty updates at the end versus
updating on the fly is a functional change beyond updating tlbs_dirty
atomically.  At a glance, I have no idea whether or not it affects anything
and if so, whether it's correct, i.e. there needs to be an explanation of
why it's safe to combine things into a single update.

> +	return ret;
>  }
>  
>  #undef pt_element_t
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
