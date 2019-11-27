Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD9F10B5AD
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK0SZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:25:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:13448 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0SZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:25:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 10:25:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="199273387"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 27 Nov 2019 10:25:53 -0800
Date:   Wed, 27 Nov 2019 10:25:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 02/28] kvm: mmu: Separate pte generation from set_spte
Message-ID: <20191127182553.GB22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-3-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:17:58PM -0700, Ben Gardon wrote:
> Separate the functions for generating leaf page table entries from the
> function that inserts them into the paging structure. This refactoring
> will allow changes to the MMU sychronization model to use atomic
> compare / exchanges (which are not guaranteed to succeed) instead of a
> monolithic MMU lock.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c | 93 ++++++++++++++++++++++++++++------------------
>  1 file changed, 57 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 781c2ca7455e3..7e5ab9c6e2b09 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2964,21 +2964,15 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>  #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
>  #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
>  
> -static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> -		    unsigned pte_access, int level,
> -		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> -		    bool can_unsync, bool host_writable)
> +static int generate_pte(struct kvm_vcpu *vcpu, unsigned pte_access, int level,

Similar comment on "generate".  Note, I don't necessarily like the names
get_mmio_spte_value() or get_spte_value() either as they could be
misinterpreted as reading the value from memory.  Maybe
calc_{mmio_}spte_value()?

> +		    gfn_t gfn, kvm_pfn_t pfn, u64 old_pte, bool speculative,
> +		    bool can_unsync, bool host_writable, bool ad_disabled,
> +		    u64 *ptep)
>  {
> -	u64 spte = 0;
> +	u64 pte;

Renames and unrelated refactoring (leaving the variable uninitialized and
setting it directdly to shadow_present_mask) belong in separate patches.
The renames especially make this patch much more difficult to review.  And,
I disagree with the rename, I think it's important to keep the "spte"
nomenclature, even though it's a bit of a misnomer for TDP entries, so that
it is easy to differentiate data that is coming from the host PTEs versus
data that is for KVM's MMU.

>  	int ret = 0;
> -	struct kvm_mmu_page *sp;
> -
> -	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
> -		return 0;
>  
> -	sp = page_header(__pa(sptep));
> -	if (sp_ad_disabled(sp))
> -		spte |= shadow_acc_track_value;
> +	*ptep = 0;
>  
>  	/*
>  	 * For the EPT case, shadow_present_mask is 0 if hardware
> @@ -2986,36 +2980,39 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	 * ACC_USER_MASK and shadow_user_mask are used to represent
>  	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
>  	 */
> -	spte |= shadow_present_mask;
> +	pte = shadow_present_mask;
> +
> +	if (ad_disabled)
> +		pte |= shadow_acc_track_value;
> +
>  	if (!speculative)
> -		spte |= spte_shadow_accessed_mask(spte);
> +		pte |= spte_shadow_accessed_mask(pte);
>  
>  	if (pte_access & ACC_EXEC_MASK)
> -		spte |= shadow_x_mask;
> +		pte |= shadow_x_mask;
>  	else
> -		spte |= shadow_nx_mask;
> +		pte |= shadow_nx_mask;
>  
>  	if (pte_access & ACC_USER_MASK)
> -		spte |= shadow_user_mask;
> +		pte |= shadow_user_mask;
>  
>  	if (level > PT_PAGE_TABLE_LEVEL)
> -		spte |= PT_PAGE_SIZE_MASK;
> +		pte |= PT_PAGE_SIZE_MASK;
>  	if (tdp_enabled)
> -		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
> +		pte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
>  			kvm_is_mmio_pfn(pfn));
>  
>  	if (host_writable)
> -		spte |= SPTE_HOST_WRITEABLE;
> +		pte |= SPTE_HOST_WRITEABLE;
>  	else
>  		pte_access &= ~ACC_WRITE_MASK;
>  
>  	if (!kvm_is_mmio_pfn(pfn))
> -		spte |= shadow_me_mask;
> +		pte |= shadow_me_mask;
>  
> -	spte |= (u64)pfn << PAGE_SHIFT;
> +	pte |= (u64)pfn << PAGE_SHIFT;
>  
>  	if (pte_access & ACC_WRITE_MASK) {
> -
>  		/*
>  		 * Other vcpu creates new sp in the window between
>  		 * mapping_level() and acquiring mmu-lock. We can
> @@ -3024,9 +3021,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		 */
>  		if (level > PT_PAGE_TABLE_LEVEL &&
>  		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
> -			goto done;
> +			return 0;
>  
> -		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
> +		pte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
>  
>  		/*
>  		 * Optimization: for pte sync, if spte was writable the hash
> @@ -3034,30 +3031,54 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		 * is responsibility of mmu_get_page / kvm_sync_page.
>  		 * Same reasoning can be applied to dirty page accounting.
>  		 */
> -		if (!can_unsync && is_writable_pte(*sptep))
> -			goto set_pte;
> +		if (!can_unsync && is_writable_pte(old_pte)) {
> +			*ptep = pte;
> +			return 0;
> +		}
>  
>  		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
>  			pgprintk("%s: found shadow page for %llx, marking ro\n",
>  				 __func__, gfn);
> -			ret |= SET_SPTE_WRITE_PROTECTED_PT;
> +			ret = SET_SPTE_WRITE_PROTECTED_PT;

More unnecessary refactoring.

>  			pte_access &= ~ACC_WRITE_MASK;
> -			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
> +			pte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
>  		}
>  	}
>  
> -	if (pte_access & ACC_WRITE_MASK) {
> -		kvm_vcpu_mark_page_dirty(vcpu, gfn);
> -		spte |= spte_shadow_dirty_mask(spte);
> -	}
> +	if (pte_access & ACC_WRITE_MASK)
> +		pte |= spte_shadow_dirty_mask(pte);
>  
>  	if (speculative)
> -		spte = mark_spte_for_access_track(spte);
> +		pte = mark_spte_for_access_track(pte);
> +
> +	*ptep = pte;
> +	return ret;
> +}
> +
> +static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
> +		    int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> +		    bool can_unsync, bool host_writable)
> +{
> +	u64 spte;
> +	int ret;
> +	struct kvm_mmu_page *sp;
> +
> +	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
> +		return 0;
> +
> +	sp = page_header(__pa(sptep));
> +
> +	ret = generate_pte(vcpu, pte_access, level, gfn, pfn, *sptep,
> +			   speculative, can_unsync, host_writable,
> +			   sp_ad_disabled(sp), &spte);

Yowsers, that's a big prototype.  This is something that came up in an
unrelated internal discussion.  I wonder if it would make sense to define
a struct to hold all of the data needed to insert an spte and pass that
on the stack isntead of having a bajillion parameters.  Just spitballing,
no idea if it's feasible and/or reasonable.

> +	if (!spte)
> +		return 0;
> +
> +	if (spte & PT_WRITABLE_MASK)
> +		kvm_vcpu_mark_page_dirty(vcpu, gfn);
>  
> -set_pte:
>  	if (mmu_spte_update(sptep, spte))
>  		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
> -done:
>  	return ret;
>  }
>  
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
