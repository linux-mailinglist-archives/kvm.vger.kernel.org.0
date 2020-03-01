Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDCE174EB7
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgCARbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 12:31:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:56667 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgCARbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 12:31:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2020 09:31:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,504,1574150400"; 
   d="scan'208";a="242903643"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 01 Mar 2020 09:31:34 -0800
Date:   Sun, 1 Mar 2020 09:31:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Fix MMU role calculation to not drop level
Message-ID: <20200301173134.GA20843@linux.intel.com>
References: <20200229231122.2076-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229231122.2076-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 29, 2020 at 03:11:22PM -0800, Sean Christopherson wrote:
> Use the calculated role as-is when propagating it to kvm_mmu.mmu_role,
> i.e. stop masking off meaningful fields.  The concept of masking off
> fields came from kvm_mmu_pte_write(), which (correctly) ignores certain
> fields when comparing kvm_mmu_page.role against kvm_mmu.mmu_role, e.g.
> the current mmu's access and level have no relation to a shadow page's
> access and level.
> 
> This fixes a bug where KVM will fail to reset shadow_root_level and
> root_level when L1 switches from running L2 with 5-level to running L2
> with 4-level.
> 
> Opportunistically rework the mask for kvm_mmu_pte_write() to define the
> fields that should be ignored as opposed to the fields that should be
> checked, i.e. make it opt-out instead of opt-in so that new fields are
> automatically picked up.  While doing so, stop ignoring "direct".  The
> field is effectively ignored anyways because kvm_mmu_pte_write() is only
> reached with an indirect mmu and the loop only walks indirect shadow
> pages, but double checking "direct" literally costs nothing.
> 
> Fixes: 9fa72119b24d ("kvm: x86: Introduce kvm_mmu_calc_root_page_role()")
> Cc: stable@vger.kernel.org

After more digging, I'm pretty sure this only affects 5-level nested EPT,
which isn't supported in upstream yet.  I.e. Fixes and Cc: stable aren't
needed.

The Fixes: is also incorrect, conditional reinitialization of the MMU was
introduced in commit 7dcd57552008 ("x86/kvm/mmu: check if tdp/shadow MMU
reconfiguration is needed").  The weird masking was introduced in commit
9fa72119b24d ("kvm: x86: Introduce kvm_mmu_calc_root_page_role()"), but it
didn't technically cause problems, just confusion.  E.g. the extended role
flag cr4_la57 shouldn't be necessary since the LA57 is reflected in
role.level, but AFAICT it was introduced in commit 7dcd57552008 because
role.level was masked off.

I'll spin a new version "KVM: nVMX: Allow L1 to use 5-level page walks for
nested EPT" to incorporate this patch and tack on a follow-up to remove
kvm_mmu_extended_role.cr4_la57.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c4e0b97f82ac..80b21b7cf092 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -215,17 +215,6 @@ struct kvm_shadow_walk_iterator {
>  	unsigned index;
>  };
>  
> -static const union kvm_mmu_page_role mmu_base_role_mask = {
> -	.cr0_wp = 1,
> -	.gpte_is_8_bytes = 1,
> -	.nxe = 1,
> -	.smep_andnot_wp = 1,
> -	.smap_andnot_wp = 1,
> -	.smm = 1,
> -	.guest_mode = 1,
> -	.ad_disabled = 1,
> -};
> -
>  #define for_each_shadow_entry_using_root(_vcpu, _root, _addr, _walker)     \
>  	for (shadow_walk_init_using_root(&(_walker), (_vcpu),              \
>  					 (_root), (_addr));                \
> @@ -4919,7 +4908,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	union kvm_mmu_role new_role =
>  		kvm_calc_tdp_mmu_root_page_role(vcpu, false);
>  
> -	new_role.base.word &= mmu_base_role_mask.word;
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> @@ -4991,7 +4979,6 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
>  	union kvm_mmu_role new_role =
>  		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
>  
> -	new_role.base.word &= mmu_base_role_mask.word;
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> @@ -5048,7 +5035,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  
>  	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false);
>  
> -	new_role.base.word &= mmu_base_role_mask.word;
>  	if (new_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> @@ -5089,7 +5075,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
>  	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>  
> -	new_role.base.word &= mmu_base_role_mask.word;
>  	if (new_role.as_u64 == g_context->mmu_role.as_u64)
>  		return;
>  
> @@ -5328,6 +5313,22 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
>  	return spte;
>  }
>  
> +/*
> + * Ignore various flags when determining if a SPTE can be immediately
> + * overwritten for the current MMU.
> + *  - level: explicitly checked in mmu_pte_write_new_pte(), and will never
> + *    match the current MMU role, as MMU's level tracks the root level.
> + *  - access: updated based on the new guest PTE
> + *  - quadrant: handled by get_written_sptes()
> + *  - invalid: always false (loop only walks valid shadow pages)
> + */
> +static const union kvm_mmu_page_role role_ign = {
> +	.level = 0xf,
> +	.access = 0x7,
> +	.quadrant = 0x3,
> +	.invalid = 0x1,
> +};
> +
>  static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			      const u8 *new, int bytes,
>  			      struct kvm_page_track_notifier_node *node)
> @@ -5383,8 +5384,8 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			entry = *spte;
>  			mmu_page_zap_pte(vcpu->kvm, sp, spte);
>  			if (gentry &&
> -			      !((sp->role.word ^ base_role)
> -			      & mmu_base_role_mask.word) && rmap_can_add(vcpu))
> +			    !((sp->role.word ^ base_role) & ~role_ign.word) &&
> +			    rmap_can_add(vcpu))
>  				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
>  			if (need_remote_flush(entry, *spte))
>  				remote_flush = true;
> -- 
> 2.24.1
> 
