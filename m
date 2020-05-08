Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FFA1CB8D1
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEHUN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:13:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:7963 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgEHUN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 16:13:56 -0400
IronPort-SDR: m8pdf0NzRfqVhIDIaDg4rXGUdKPxdGllyuTG/G7o5uopK2LA1pkfdFnlWP1gWGVU7D/71cZ8HO
 DhCOa6UnNawA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 13:13:55 -0700
IronPort-SDR: y4g5nsyjWS+5oiCxcwofr7ePTc8VpZ3E/YSVNyyNDQETMLm2mu8rOOzmegxmmgVNxTxok7MUcZ
 7WxS+kd03CAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="249853292"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2020 13:13:55 -0700
Date:   Fri, 8 May 2020 13:13:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jon Cargille <jcargill@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH] kvm: x86 mmu: avoid mmu_page_hash lookup for
 direct_map-only VM
Message-ID: <20200508201355.GS27052@linux.intel.com>
References: <20200508182425.69249-1-jcargill@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508182425.69249-1-jcargill@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 11:24:25AM -0700, Jon Cargille wrote:
> From: Peter Feiner <pfeiner@google.com>
> 
> Optimization for avoiding lookups in mmu_page_hash. When there's a
> single direct root, a shadow page has at most one parent SPTE
> (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> is non-present, it can be linked to a newly allocated SP without
> first checking if the SP already exists.

Some mechanical comments below.  I'll think through the actual logic next
week, my brain needs to be primed anytime the MMU is involved :-)

> This optimization has proven significant in batch large SP shattering
> where the hash lookup accounted for 95% of the overhead.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>
> Signed-off-by: Jon Cargille <jcargill@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> ---
>  arch/x86/include/asm/kvm_host.h | 13 ++++++++
>  arch/x86/kvm/mmu/mmu.c          | 55 +++++++++++++++++++--------------
>  2 files changed, 45 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a239a297be33..9b70d764b626 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -913,6 +913,19 @@ struct kvm_arch {
>  	struct kvm_page_track_notifier_node mmu_sp_tracker;
>  	struct kvm_page_track_notifier_head track_notifier_head;
>  
> +	/*
> +	 * Optimization for avoiding lookups in mmu_page_hash. When there's a
> +	 * single direct root, a shadow page has at most one parent SPTE
> +	 * (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> +	 * is non-present, it can be linked to a newly allocated SP without
> +	 * first checking if the SP already exists.
> +	 *
> +	 * False initially because there are no indirect roots.
> +	 *
> +	 * Guarded by mmu_lock.
> +	 */
> +	bool shadow_page_may_have_multiple_parents;

Why make this a one-way bool?  Wouldn't it be better to let this transition
back to '0' once all nested guests go away?

And maybe a shorter name that reflects what it tracks instead of how its
used, e.g. has_indirect_mmu or indirect_mmu_count.

> +
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
>  	bool iommu_noncoherent;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e618472c572b..d94552b0ed77 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2499,35 +2499,40 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
>  		role.quadrant = quadrant;
>  	}
> -	for_each_valid_sp(vcpu->kvm, sp, gfn) {
> -		if (sp->gfn != gfn) {
> -			collisions++;
> -			continue;
> -		}
>  
> -		if (!need_sync && sp->unsync)
> -			need_sync = true;
> +	if (vcpu->kvm->arch.shadow_page_may_have_multiple_parents ||
> +	    level == vcpu->arch.mmu->root_level) {

Might be worth a goto to preserve the for-loop.

> +		for_each_valid_sp(vcpu->kvm, sp, gfn) {
> +			if (sp->gfn != gfn) {
> +				collisions++;
> +				continue;
> +			}
>  
> -		if (sp->role.word != role.word)
> -			continue;
> +			if (!need_sync && sp->unsync)
> +				need_sync = true;
>  
> -		if (sp->unsync) {
> -			/* The page is good, but __kvm_sync_page might still end
> -			 * up zapping it.  If so, break in order to rebuild it.
> -			 */
> -			if (!__kvm_sync_page(vcpu, sp, &invalid_list))
> -				break;
> +			if (sp->role.word != role.word)
> +				continue;
>  
> -			WARN_ON(!list_empty(&invalid_list));
> -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> -		}
> +			if (sp->unsync) {
> +				/* The page is good, but __kvm_sync_page might
> +				 * still end up zapping it.  If so, break in
> +				 * order to rebuild it.
> +				 */
> +				if (!__kvm_sync_page(vcpu, sp, &invalid_list))
> +					break;
>  
> -		if (sp->unsync_children)
> -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +				WARN_ON(!list_empty(&invalid_list));
> +				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +			}
>  
> -		__clear_sp_write_flooding_count(sp);
> -		trace_kvm_mmu_get_page(sp, false);
> -		goto out;
> +			if (sp->unsync_children)
> +				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +
> +			__clear_sp_write_flooding_count(sp);
> +			trace_kvm_mmu_get_page(sp, false);
> +			goto out;
> +		}
>  	}
>  
>  	++vcpu->kvm->stat.mmu_cache_miss;
> @@ -3735,6 +3740,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	gfn_t root_gfn, root_pgd;
>  	int i;
>  
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	vcpu->kvm->arch.shadow_page_may_have_multiple_parents = true;
> +	spin_unlock(&vcpu->kvm->mmu_lock);

Taking the lock every time is unnecessary, even if this is changed to a
refcount type variable, e.g.

	if (!has_indirect_mmu) {
		lock_and_set
	}

or

	if (atomic_inc_return(&indirect_mmu_count) == 1)
		lock_and_unlock;

	
> +
>  	root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
>  	root_gfn = root_pgd >> PAGE_SHIFT;
>  
> -- 
> 2.26.2.303.gf8c07b1a785-goog
> 
