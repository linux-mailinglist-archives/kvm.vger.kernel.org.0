Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE83A7248
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 01:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFNXCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 19:02:39 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:34389 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhFNXCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 19:02:37 -0400
Received: by mail-pj1-f43.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso724851pjx.1
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 16:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=54aOuN+rEm6lDr1qC/18pauTInucZ7Tfek12D6lXz4A=;
        b=XSteeasx5SZUTn9urhQb35zEPY5RULb0rf4iaVB49mebpZrEZKkK6W/TZ5ZOYlSJiA
         hrILmze/ciNbvgbgy1kl85T+TEF94DZNMJYpWJ0E+2g/s/VI9SBADliZval3xv1Rbu/B
         fB7/Z910nHnucV/1f5BJG89rjzNDauLXfSgcSWedmPe64qEJzLZMMy5qrCfcSJ9wlIVc
         oh4H0BQzr3Iyd/u4TlP11LYcAdZj721YASi5UY+DuilEgcLgccR8YDIUDnrLx95sjoXz
         RGQJzbtbt4FF8nVHInhUXJ9DL4i1DZIPcnHS3gb7m3OxtJOkd5pYTWtzAPOHLeGrcXC/
         PYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=54aOuN+rEm6lDr1qC/18pauTInucZ7Tfek12D6lXz4A=;
        b=MFIzdbpngX6FR53Df+78oEypQvCrGw+acECtHC13zyCzhVVyRRoXpBg3382xuCUrio
         7XYpuMSk/dC0R5nPiHdyaTh/jQ8SO7jyd/mdpiwN90FY/sESkWXoRlJKmMffCuRbD6EH
         0YVWbIT9fIQiN4iERZMtB/c3qVlk3L/IBg2w1BO8TbOvk+H7xRgccKibpBIXU6pUhpmD
         YZJo4TKmX8VE5qm3+0Dt1lqbT3JNwN5c0nU1QlXrIgj/SCB6ry2JiRTm2zlgYkMPZUK4
         tSOSj47J/lQo5ISliJ5ud2FJOuYsQYbfLmzOMgVRGLY5zdVIluAwBfz/LZV4c8EiLmjt
         PPJA==
X-Gm-Message-State: AOAM533KyGWAU4clRgofaDDeQFv/5OfbL6pR1zqkt6vDMEuykUL2yfhy
        pgmmo9Ui0NnWQt3xoO0+0O9JcA==
X-Google-Smtp-Source: ABdhPJxgcLxUqUIS4vqirW/YQVNxQ8xzP1Y6Ihm70ZH9F6Vy6KuqPJ9yyILZgwyqj6RkGxd1gRS1hw==
X-Received: by 2002:a17:902:a70f:b029:ea:d4a8:6a84 with SMTP id w15-20020a170902a70fb02900ead4a86a84mr1505186plq.42.1623711558919;
        Mon, 14 Jun 2021 15:59:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l12sm4142722pff.105.2021.06.14.15.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:59:18 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:59:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
Message-ID: <YMffQriMoxWw2V1f@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611235701.3941724-6-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021, David Matlack wrote:
> In order to use walk_shadow_page_lockless() in fast_page_fault() we need
> to also record the spteps.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8140c262f4d3..765f5b01768d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3538,6 +3538,7 @@ static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
>  		spte = mmu_spte_get_lockless(it.sptep);
>  		walk->last_level = it.level;
>  		walk->sptes[it.level] = spte;
> +		walk->spteps[it.level] = it.sptep;
>  
>  		if (!is_shadow_present_pte(spte))
>  			break;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 26da6ca30fbf..0fefbd5d6c95 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -178,6 +178,9 @@ struct shadow_page_walk {
>  
>  	/* The spte value at each level. */
>  	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> +
> +	/* The spte pointers at each level. */
> +	u64 *spteps[PT64_ROOT_MAX_LEVEL + 1];

Hrm.  I'm not sure how I feel about this patch, or about shadow_page_walk in
general.  On the one hand, I like having a common API.  On the other hand, I
really don't like mixing two different protection schemes, e.g. this really
should be

        tdp_ptep_t spteps;

in order to gain the RCU annotations for TDP, but those RCU annotations are
problematic because the legacy MMU doesn't use RCU to protect its page tables.

I also don't like forcing the caller to hold the "lock" for longer than is
necessary, e.g. get_mmio_spte() doesn't require access to the page tables after
the initial walk, but the common spteps[] kinda sorta forces its hand.

The two use cases (and the only common use cases I can see) have fairly different
requirements.  The MMIO check wants the SPTEs at _all_ levels, whereas the fast
page fault handler wants the SPTE _and_ its pointer at a single level.  So I
wonder if by providing a super generic API we'd actually increase complexity.

I.e. rather than provide a completely generic API, maybe it would be better to
have two distinct API.  That wouldn't fix the tdp_ptep_t issue, but it would at
least bound it to some degree and make the code more obvious.  I suspect it would
also reduce the code churn, though that's not necessarily a goal in and of itself.

E.g. for fast_page_fault():

        walk_shadow_page_lockless_begin(vcpu);

        do {
                sptep = get_spte_lockless(..., &spte);
                if (!is_shadow_present_pte(spte))
                        break;

                sp = sptep_to_sp(sptep);
                if (!is_last_spte(spte, sp->role.level))
                        break;

                ...
        } while(true);

        walk_shadow_page_lockless_end(vcpu);


and for get_mmio_spte():
        walk_shadow_page_lockless_begin(vcpu);
        leaf = get_sptes_lockless(vcpu, addr, sptes, &root);
        if (unlikely(leaf < 0)) {
                *sptep = 0ull;
                return reserved;
        }

        walk_shadow_page_lockless_end(vcpu);


And if we look at the TDP MMU implementations, they aren't sharing _that_ much
code, and the code that is shared isn't all that interesting, e.g. if we really
wanted to we could macro-magic away the boilerplate, but I think even I would
balk at the result :-)

int kvm_tdp_mmu_get_sptes_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
				   int *root_level)
{
	struct tdp_iter iter;
	struct kvm_mmu *mmu = vcpu->arch.mmu;
	gfn_t gfn = addr >> PAGE_SHIFT;
	int leaf = -1;

	*root_level = vcpu->arch.mmu->shadow_root_level;

	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
		leaf = iter.level;
		sptes[leaf] = iter.old_spte;
	}

	return leaf;
}

u64 *kvm_tdp_mmu_get_spte_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *spte)
{
	struct kvm_mmu *mmu = vcpu->arch.mmu;
	gfn_t gfn = addr >> PAGE_SHIFT;
	struct tdp_iter iter;
	u64 *sptep = NULL;

	*spte = 0ull;

	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
		/*
		 * Here be a comment about the unfortunate differences between
		 * the TDP MMU and the legacy MMU.
		 */
		sptep = (u64 * __force)iter.sptep;
		*spte = iter.old_spte;
	}
	return sptep;
}

