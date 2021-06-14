Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503273A7293
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 01:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhFNXm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 19:42:26 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41560 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhFNXmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 19:42:25 -0400
Received: by mail-pg1-f176.google.com with SMTP id l184so9948945pgd.8
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 16:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qx09jvjZXoLNFHjvHw0pNVdOQT3WD4BGxXmIJw0AsjI=;
        b=FDU07yC7c9GFyM9BlKFfzhxty4Q4CNdjJ1hNYS7J+qgHO81M+z4MBHSSaDuZXCgcjH
         yoz+Iy/1EOi3SwGtYGnX35O6gE3j8pVCbeP+ne2BM5gT6RmT8v8RL0fftBZt98nwT8Nw
         YD1zfZNbd6tB+9HGGEwhGjaB3Ou/rDAdUbrAwsRzZeKMuElcooTcm+O9wAHW4hhzvAPl
         fCcZUM2hGtdlSDmUltdpBM4XtJaov7nt59eakqIL1VQiajzaYQadOcNn8PLMlSf+jlk6
         iKlTXGj9x/MlVyyBRFet2ee1bzBY41kx+OcyhswXEocKEN18TIjikeGlJ3JBPtTrx4Gw
         gCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qx09jvjZXoLNFHjvHw0pNVdOQT3WD4BGxXmIJw0AsjI=;
        b=IW+opkgms3uA4Q+WNGBHmBRZDbSiP9wvmViy7gEXROqL69SDkWST2E3JewKNNqLIfS
         CcMi5s1JyQHF/FF+1gUoro0m/KDz/mGbTGo715KZP0eqJJSj4PGMp8RhMGfvbRaPeZa6
         oxdOEVDgVh6XwmxCE1SrgTduwS6ygSSYmArXDgy1ogZ1OdhOfMN5K9aRNMyjffsFsXdA
         5VyJLdIjYuxu9nzNDQEG90re4BqhaTsH+TamZNTp2IBMLPM0Pm9jbOloNrbcP7D/wMV3
         PO+WbeGNNQuALGOmh2z1wn1B5bD2UG1KvTtWELQZYfzg7aY9i8nTw58/wi71l3TDkxp5
         0ecg==
X-Gm-Message-State: AOAM532r9BFl8SMDOKLhlRuNWEDKEUH0WHY/I23cr6jeDdwDSWaFrz3Y
        EIo6rvR3HNi+bAznIT0zlNWH/w==
X-Google-Smtp-Source: ABdhPJw2o3zCH5BiXczpOLOXK7bEohwR5EVCHVjpKPYXeZZKOVpWFtTOo4oY9QyH8P3HCzfG5WfscA==
X-Received: by 2002:aa7:9ab3:0:b029:2f7:e053:f727 with SMTP id x19-20020aa79ab30000b02902f7e053f727mr1402848pfi.74.1623713962030;
        Mon, 14 Jun 2021 16:39:22 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id w206sm13361523pff.1.2021.06.14.16.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 16:39:21 -0700 (PDT)
Date:   Mon, 14 Jun 2021 23:39:17 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
Message-ID: <YMfopaDSRKvlsH0Y@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-6-dmatlack@google.com>
 <YMffQriMoxWw2V1f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMffQriMoxWw2V1f@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 10:59:14PM +0000, Sean Christopherson wrote:
> On Fri, Jun 11, 2021, David Matlack wrote:
> > In order to use walk_shadow_page_lockless() in fast_page_fault() we need
> > to also record the spteps.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 1 +
> >  arch/x86/kvm/mmu/mmu_internal.h | 3 +++
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 1 +
> >  3 files changed, 5 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8140c262f4d3..765f5b01768d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3538,6 +3538,7 @@ static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> >  		spte = mmu_spte_get_lockless(it.sptep);
> >  		walk->last_level = it.level;
> >  		walk->sptes[it.level] = spte;
> > +		walk->spteps[it.level] = it.sptep;
> >  
> >  		if (!is_shadow_present_pte(spte))
> >  			break;
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 26da6ca30fbf..0fefbd5d6c95 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -178,6 +178,9 @@ struct shadow_page_walk {
> >  
> >  	/* The spte value at each level. */
> >  	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> > +
> > +	/* The spte pointers at each level. */
> > +	u64 *spteps[PT64_ROOT_MAX_LEVEL + 1];
> 
> Hrm.  I'm not sure how I feel about this patch, or about shadow_page_walk in
> general.  On the one hand, I like having a common API.  On the other hand, I
> really don't like mixing two different protection schemes, e.g. this really
> should be
> 
>         tdp_ptep_t spteps;
> 
> in order to gain the RCU annotations for TDP, but those RCU annotations are
> problematic because the legacy MMU doesn't use RCU to protect its page tables.
> 
> I also don't like forcing the caller to hold the "lock" for longer than is
> necessary, e.g. get_mmio_spte() doesn't require access to the page tables after
> the initial walk, but the common spteps[] kinda sorta forces its hand.

Yeah this felt gross implementing. I like your idea to create separate
APIs instead.

> 
> The two use cases (and the only common use cases I can see) have fairly different
> requirements.  The MMIO check wants the SPTEs at _all_ levels, whereas the fast
> page fault handler wants the SPTE _and_ its pointer at a single level.  So I
> wonder if by providing a super generic API we'd actually increase complexity.
> 
> I.e. rather than provide a completely generic API, maybe it would be better to
> have two distinct API.  That wouldn't fix the tdp_ptep_t issue, but it would at
> least bound it to some degree and make the code more obvious.

Does the tdp_ptep_t issue go away if kvm_tdp_mmu_get_spte_lockless
returns an rcu_dereference'd version of the pointer? See below.

> I suspect it would
> also reduce the code churn, though that's not necessarily a goal in and of itself.

Makes sense. So keep walk_shadow_page_lockless_{begin,end}() as a
generic API but provide separate helper functions for get_mmio_spte and
fast_page_fault to get each exactly what each needs.

> 
> E.g. for fast_page_fault():
> 
>         walk_shadow_page_lockless_begin(vcpu);
> 
>         do {
>                 sptep = get_spte_lockless(..., &spte);
>                 if (!is_shadow_present_pte(spte))
>                         break;
> 
>                 sp = sptep_to_sp(sptep);
>                 if (!is_last_spte(spte, sp->role.level))
>                         break;
> 
>                 ...
>         } while(true);
> 
>         walk_shadow_page_lockless_end(vcpu);
> 
> 
> and for get_mmio_spte():
>         walk_shadow_page_lockless_begin(vcpu);
>         leaf = get_sptes_lockless(vcpu, addr, sptes, &root);
>         if (unlikely(leaf < 0)) {
>                 *sptep = 0ull;
>                 return reserved;
>         }
> 
>         walk_shadow_page_lockless_end(vcpu);
> 
> 
> And if we look at the TDP MMU implementations, they aren't sharing _that_ much
> code, and the code that is shared isn't all that interesting, e.g. if we really
> wanted to we could macro-magic away the boilerplate, but I think even I would
> balk at the result :-)

Agreed.

> 
> int kvm_tdp_mmu_get_sptes_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> 				   int *root_level)
> {
> 	struct tdp_iter iter;
> 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> 	gfn_t gfn = addr >> PAGE_SHIFT;
> 	int leaf = -1;
> 
> 	*root_level = vcpu->arch.mmu->shadow_root_level;
> 
> 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> 		leaf = iter.level;
> 		sptes[leaf] = iter.old_spte;
> 	}
> 
> 	return leaf;
> }
> 
> u64 *kvm_tdp_mmu_get_spte_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *spte)
> {
> 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> 	gfn_t gfn = addr >> PAGE_SHIFT;
> 	struct tdp_iter iter;
> 	u64 *sptep = NULL;
> 
> 	*spte = 0ull;
> 
> 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> 		/*
> 		 * Here be a comment about the unfortunate differences between
> 		 * the TDP MMU and the legacy MMU.
> 		 */
> 		sptep = (u64 * __force)iter.sptep;

Instead, should this be:

		sptep = rcu_dereference(iter.sptep);

?

> 		*spte = iter.old_spte;
> 	}
> 	return sptep;
> }
> 
