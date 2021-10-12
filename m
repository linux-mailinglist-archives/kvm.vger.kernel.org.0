Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7415842AF47
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 23:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhJLVui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 17:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhJLVuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 17:50:37 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D9AC061745
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 14:48:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e7so373726pgk.2
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 14:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oA9FzDgVqTGdx1czSwXl6ZrYbBDAr0EIMvOhvwuaTdk=;
        b=CqXvJIe1amTWYFrjVyrniAq7PVrDTlXlO26WSeLMWq3KizYEx/D9ZiWiZyoiyxTFPF
         h1TIXxH8RiIwsOLn973g0lSt+QPUmJT8wRSn33ndyjy7Z08dshauEfN9CdUNtq84b8Z9
         TZsxHsXxZvBrON/kvKX9wHpV7hygzzVGzVMsGIM9qvaOoD5X9NHWN+2a6MG+7jKVLq3A
         EmmeVK7+f+8rxwjcZVkNNs1+/L/dIGHZfJVyP4FVX0fOjMUUCPhOAru4KjMj1wv6mdRv
         2+8t19Mnpt3sPjbqhyc1y0WnQXGRFJFIn0m0q4b0UmxO7zQ7AJ/13kcXM0VLKU8xqim6
         dkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oA9FzDgVqTGdx1czSwXl6ZrYbBDAr0EIMvOhvwuaTdk=;
        b=OlHCJH9LIX9FjAsxj5qMdsXRRx8TlOg0MPLqbG17IVd9wnmIeGGyTJzXhDd2VRwCU4
         GnY6D85/ej9QYtafmwXBlx+SiQjzgCwkUrVLdmFxKaqa18Ejau02WHgS8rMniaZ2+7s0
         XuP0ROwWH7lDgVtcQ3ibPlDgU9+x7BqiDZ14roc97b/yG7A0ol11ltpGGJxYWcNSVjGs
         YhcAZqsNqkq7wJo6oOEQH7lqyHSft0Ub1rR3Pwn0mrzkfkRfMNjxBLbLX0cxmL7VflZr
         KbDFYhR54+D24Do7mdukNqdCLWXcL9Y0wqbsFKKi8xws94FiJvSrBfz6ialiwWg3q879
         bxFQ==
X-Gm-Message-State: AOAM533YOIn3DzrrJvwnhdd36dLdPZNiimOp0D0EPtUu9fbZpKSsNt6n
        uE7VqVB+hMTx50YTnhUI77JoJg==
X-Google-Smtp-Source: ABdhPJzd5yePVpqBRc8WNbyxjJrkNRvPG8x67xR2B5rO/fbOYFQteZXzaITE7pxN672MCRHF03Ynig==
X-Received: by 2002:a62:7506:0:b0:44c:efe8:4167 with SMTP id q6-20020a627506000000b0044cefe84167mr22378776pfc.59.1634075314208;
        Tue, 12 Oct 2021 14:48:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o6sm12062004pfp.79.2021.10.12.14.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:48:33 -0700 (PDT)
Date:   Tue, 12 Oct 2021 21:48:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Message-ID: <YWYCrQX4ZzwUVZCe@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-38-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-38-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 991b8c996fc1..6d9483ec91ab 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -31,6 +31,7 @@
>  #include "svm_ops.h"
>  #include "cpuid.h"
>  #include "trace.h"
> +#include "mmu.h"
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> @@ -2905,6 +2906,181 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
>  	svm->vmcb->control.ghcb_gpa = value;
>  }
>  
> +static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +
> +	return psmash(pfn);
> +}
> +
> +static int snp_make_page_shared(struct kvm *kvm, gpa_t gpa, kvm_pfn_t pfn, int level)
> +{
> +	int rc, rmp_level;
> +
> +	rc = snp_lookup_rmpentry(pfn, &rmp_level);
> +	if (rc < 0)
> +		return -EINVAL;
> +
> +	/* If page is not assigned then do nothing */
> +	if (!rc)
> +		return 0;
> +
> +	/*
> +	 * Is the page part of an existing 2MB RMP entry ? Split the 2MB into
> +	 * multiple of 4K-page before making the memory shared.
> +	 */
> +	if (level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M) {
> +		rc = snp_rmptable_psmash(kvm, pfn);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return rmp_make_shared(pfn, level);
> +}
> +
> +static int snp_check_and_build_npt(struct kvm_vcpu *vcpu, gpa_t gpa, int level)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int rc, npt_level;
> +	kvm_pfn_t pfn;
> +
> +	/*
> +	 * Get the pfn and level for the gpa from the nested page table.
> +	 *
> +	 * If the tdp walk fails, then its safe to say that there is no
> +	 * valid mapping for this gpa. Create a fault to build the map.
> +	 */
> +	write_lock(&kvm->mmu_lock);

SEV (or any vendor code for that matter) should not be taking mmu_lock.  All of
KVM has somewhat fungible borders between the various components, but IMO this
crosses firmly into "this belongs in the MMU" territory.

For example, I highly doubt this actually need to take mmu_lock for write.  More
below.

> +	rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> +	write_unlock(&kvm->mmu_lock);

What's the point of this walk?  As soon as mmu_lock is dropped, all bets are off.
At best this is a strong hint.  It doesn't hurt anything per se, it's just a waste
of cycles.

> +	if (!rc) {
> +		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);

Same here.

> +		if (is_error_noslot_pfn(pfn))
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int snp_gpa_to_hva(struct kvm *kvm, gpa_t gpa, hva_t *hva)
> +{
> +	struct kvm_memory_slot *slot;
> +	gfn_t gfn = gpa_to_gfn(gpa);
> +	int idx;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Note, using the __gfn_to_hva_memslot() is not solely for performance,
> +	 * it's also necessary to avoid the "writable" check in __gfn_to_hva_many(),
> +	 * which will always fail on read-only memslots due to gfn_to_hva() assuming
> +	 * writes.
> +	 */
> +	*hva = __gfn_to_hva_memslot(slot, gfn);
> +	srcu_read_unlock(&kvm->srcu, idx);

*hva is effectively invalidated the instance kvm->srcu is unlocked, e.g. a pending
memslot update can complete immediately after and delete/move the backing memslot.

> +
> +	return 0;
> +}
> +
> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
> +					  int level)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> +	struct kvm *kvm = vcpu->kvm;
> +	int rc, npt_level;
> +	kvm_pfn_t pfn;
> +	gpa_t gpa_end;
> +
> +	gpa_end = gpa + page_level_size(level);
> +
> +	while (gpa < gpa_end) {
> +		/*
> +		 * If the gpa is not present in the NPT then build the NPT.
> +		 */
> +		rc = snp_check_and_build_npt(vcpu, gpa, level);
> +		if (rc)
> +			return -EINVAL;
> +
> +		if (op == SNP_PAGE_STATE_PRIVATE) {
> +			hva_t hva;
> +
> +			if (snp_gpa_to_hva(kvm, gpa, &hva))
> +				return -EINVAL;
> +
> +			/*
> +			 * Verify that the hva range is registered. This enforcement is
> +			 * required to avoid the cases where a page is marked private
> +			 * in the RMP table but never gets cleanup during the VM
> +			 * termination path.
> +			 */
> +			mutex_lock(&kvm->lock);
> +			rc = is_hva_registered(kvm, hva, page_level_size(level));

This will get a false negative if a hva+size spans two contiguous regions.

Also, storing a boolean return in a variable that is an int _and_ was already used
for the kernel's standard 

> +			mutex_unlock(&kvm->lock);

This is also subject to races, e.g. userspace unregisters the hva immediately
after this check, before KVM makes whatever conversion it makes below.

A linear walk through a list to find a range is also a bad idea, e.g. pathological
worst case scenario is that userspace has created tens of thousands of individual
regions.  There is no restriction on the number of regions, just the number of
pages that can be pinned.

I dislike the svm_(un)register_enc_region() scheme in general, but at least for
SEV and SEV-ES the code is isolated, e.g. KVM is little more than a dump pipe to
let userspace pin pages.  I would like to go the opposite direction and work towards
eliminating regions_list (or at least making it optional), not build more stuff
on top.

The more I look at this, the more strongly I feel that private <=> shared conversions
belong in the MMU, and that KVM's SPTEs should be the single source of truth for
shared vs. private.  E.g. add a SPTE_TDP_PRIVATE_MASK in the software available bits.
I believe the only hiccup is the snafu where not zapping _all_ SPTEs on memslot
deletion breaks QEMU+VFIO+GPU, i.e. KVM would lose its canonical info on unrelated
memslot deletion.

But that is a solvable problem.  Ideally the bug, wherever it is, would be root
caused and fixed.  I believe Peter (and Marc?) is going to work on reproducing
the bug.

If we are unable to root cause and fix the bug, I think a viable workaround would
be to clear the hardware present bit in unrelated SPTEs, but keep the SPTEs
themselves.  The idea mostly the same as the ZAPPED_PRIVATE concept from the initial
TDX RFC.  MMU notifier invalidations, memslot removal, RMP restoration, etc... would
all continue to work since the SPTEs is still there, and KVM's page fault handler
could audit any "blocked" SPTE when it's refaulted (I'm pretty sure it'd be
impossible for the PFN to change, since any PFN change would require a memslot
update or mmu_notifier invalidation).

The downside to that approach is that it would require walking all SPTEs to do a
memslot deletion, i.e. we'd lose the "fast zap" behavior.  If that's a performance
issue, the behavior could be opt-in (but not for SNP/TDX).

> +			if (!rc)
> +				return -EINVAL;
> +
> +			/*
> +			 * Mark the userspace range unmerable before adding the pages
> +			 * in the RMP table.
> +			 */
> +			mmap_write_lock(kvm->mm);
> +			rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
> +			mmap_write_unlock(kvm->mm);

As mentioned in an earlier patch, this simply cannot work.

> +			if (rc)
> +				return -EINVAL;
> +		}
> +
> +		write_lock(&kvm->mmu_lock);
> +
> +		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);

Same comment about the bool into int. Though in this case I'd say have
kvm_mmu_get_tdp_walk() return 0/-errno, not a bool.  Boolean returns for helpers
without "is_", "test_", etc... are generally confusing.

> +		if (!rc) {
> +			/*
> +			 * This may happen if another vCPU unmapped the page
> +			 * before we acquire the lock. Retry the PSC.
> +			 */
> +			write_unlock(&kvm->mmu_lock);
> +			return 0;

How will the caller (guest?) know to retry the PSC if KVM returns "success"?

> +		}
> +
> +		/*
> +		 * Adjust the level so that we don't go higher than the backing
> +		 * page level.
> +		 */
> +		level = min_t(size_t, level, npt_level);
> +
> +		trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
> +
> +		switch (op) {
> +		case SNP_PAGE_STATE_SHARED:
> +			rc = snp_make_page_shared(kvm, gpa, pfn, level);
> +			break;
> +		case SNP_PAGE_STATE_PRIVATE:
> +			rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
> +			break;
> +		default:
> +			rc = -EINVAL;

Not that it really matters, because I don't think the MADV_* approach is viable,
but this neglects to undo snp_mark_unmergable() on failure.

> +			break;
> +		}
> +
> +		write_unlock(&kvm->mmu_lock);
> +
> +		if (rc) {
> +			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
> +					   op, gpa, pfn, level, rc);
> +			return rc;
> +		}
> +
> +		gpa = gpa + page_level_size(level);
> +	}
> +
> +	return 0;
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
