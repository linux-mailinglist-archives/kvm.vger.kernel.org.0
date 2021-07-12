Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C073C656B
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhGLV1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 17:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhGLV1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 17:27:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E5FC0613E8
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:24:41 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a127so17619754pfa.10
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UM06NyY+rKEvc9YJCUSsr2EWsc/2rGHoghtQBhoCWaI=;
        b=ihxyPRY/Z2eD5HTwV50Zgx2UzTW1WRUhkLV+GOJL7J/6Y06vLWwp4QNCqaRnShQLom
         QlN1bUl+4NLDN2P3l1DByBLUCxxnpq72aOmSHw+ONwpr24VAm5FXcz5EgJY3NNtmi5Mw
         8RvYb784P34hVHajYWbNBMHM+CeQdka0sctmjFfnmSK+ArJEZMZJNoPqgLotoD9Ycz0z
         ILjD+p2WSq5NhpAdbfUUPtl6GZ/8ELa9xhl9CF272afALN/u6D5uHTH1pWvirA0pU8h3
         ozPgiOYovkXdZpatImoj8j4TZO9Hfalp+qTwn2RWQjYCvsx9KLVp4z9P5QrkEaWxy2lH
         C3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UM06NyY+rKEvc9YJCUSsr2EWsc/2rGHoghtQBhoCWaI=;
        b=bkMnp+zb82eybiiSlzLUMcsFSlvzLKEF95J7pHttBaM6qYnrQCpL1TEw38ptyV9//i
         wbkRR+fcKiT2+6hlg2yuehki5sX9zY8xzW259QdPs1Q9WHmCZyTo6cWr6Z2fjRIfrx+b
         nw7KJjSTj+gfx0XIYselipKOLVIGzbYWi34ZQHzIpwI/FG42eaARtkltn/4sFHWHGg7k
         dxApl/ZIiVxdfRKU1t4h6EP/REACfUfn73df+HbPoxt6MUggLPKzjdYOkPLdkFYKt3zZ
         nMMPNGtmi20x4+lt6QnhL4JgNJoFksvX1x58+fZvos3nU6FwV3+dIC3A+eSCOoO2u8c+
         e0vg==
X-Gm-Message-State: AOAM532WLyvtQnJHZr21xo+fA+AK7/UR2dPOmee4pE+ZC+pRKIEXdjGG
        Rv7xRLIJ9nPa7J4WTJNIxLRPoA==
X-Google-Smtp-Source: ABdhPJwkpR03pPoU3X08yYZ1rYuGAkXWnoWhp0JfWCk9lHHjfUZWihIXfsNQr2ltp/23l+484RqRqQ==
X-Received: by 2002:a62:37c2:0:b029:2ff:f7dd:1620 with SMTP id e185-20020a6237c20000b02902fff7dd1620mr1185196pfa.33.1626125081290;
        Mon, 12 Jul 2021 14:24:41 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 123sm17153793pfw.33.2021.07.12.14.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 14:24:40 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:24:36 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP
 MMU
Message-ID: <YOyzFOUp6KTeKRFh@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-5-dmatlack@google.com>
 <CANgfPd_Ew2AcwegRxcwr+M_myVjyjq2UVz=pHqVuy-UnPWY_ew@mail.gmail.com>
 <YOyuD7UJXHpNnXA2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOyuD7UJXHpNnXA2@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 09:03:11PM +0000, Sean Christopherson wrote:
> On Mon, Jul 12, 2021, Ben Gardon wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index c6fa8d00bf9f..2c9e0ed71fa0 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
> > >         if (is_removed_spte(iter->old_spte))
> > >                 return false;
> > >
> > > +       /*
> > > +        * TDP MMU sptes can also be concurrently cmpxchg'd in
> > > +        * fast_pf_fix_direct_spte as part of fast_page_fault.
> > > +        */
> 
> The cmpxchg64 part isn't what's interesting, it's just the means to the end.
> Maybe reword slightly to focus on modifying SPTEs without holding mmu_lock, e.g.
> 
> 	/*
> 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs outside
> 	 * of mmu_lock.
> 	 */

Good point about cmpxchg. I'll use your comment in v3.

> 
> > >         if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> > >                       new_spte) != iter->old_spte)
> > >                 return false;
> > 
> > I'm a little nervous about not going through the handle_changed_spte
> > flow for the TDP MMU, but as things are now, I think it's safe.
> 
> Ya, it would be nice to flow through the TDP MMU proper as we could also "restore"
> __rcu.  That said, the fast #PF fix flow is unique and specific enough that I don't
> think it's worth going out of our way to force the issue.
> 
> > > @@ -1546,3 +1550,35 @@ int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> > >
> > >         return leaf;
> > >  }
> > > +
> > > +/*
> > > + * Must be called between kvm_tdp_mmu_walk_shadow_page_lockless_{begin,end}.
> > > + *
> > > + * The returned sptep must not be used after
> > > + * kvm_tdp_mmu_walk_shadow_page_lockless_end.
> > > + */
> > > +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > > +                                        u64 *spte)
> > > +{
> > > +       struct tdp_iter iter;
> > > +       struct kvm_mmu *mmu = vcpu->arch.mmu;
> > > +       gfn_t gfn = addr >> PAGE_SHIFT;
> > > +       tdp_ptep_t sptep = NULL;
> > > +
> > > +       tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > > +               *spte = iter.old_spte;
> > > +               sptep = iter.sptep;
> > > +       }
> > > +
> > > +       if (sptep)
> 
> This check is unnecessary, even when using rcu_dereference.

Ack. Will fix.

> 
> > > +               /*
> > > +                * Perform the rcu dereference here since we are passing the
> > > +                * sptep up to the generic MMU code which does not know the
> > > +                * synchronization details of the TDP MMU. This is safe as long
> > > +                * as the caller obeys the contract that the sptep is not used
> > > +                * after kvm_tdp_mmu_walk_shadow_page_lockless_end.
> > > +                */
> > 
> > There's a little more to this contract:
> > 1. The caller should only modify the SPTE using an atomic cmpxchg with
> > the returned spte value.
> > 2. The caller should not modify the mapped PFN or present <-> not
> > present state of the SPTE.
> > 3. There are other bits the caller can't modify too. (lpage, mt, etc.)
> > 
> > If the comments on this function don't document all the constraints on
> > how the returned sptep can be used, it might be safer to specify that
> > this is only meant to be used as part of the fast page fault handler.
> 
> Or maybe a less specific, but more scary comment?
> 
> > 
> > > +               return rcu_dereference(sptep);
> 
> I still vote to use "(__force u64 *)" instead of rcu_dereference() to make it
> clear we're cheating in order to share code with the legacy MMU.

Some downsides I see of using __force is:

 - The implementation of rcu_dereference() is non-trivial. I'm not sure
   how much of it we have to re-implement here. For example, should we
   us READ_ONCE() in addition to the type cast?

 - rcu_dereference() checks if the rcu read lock is held and also calls
   rcu_check_sparse, which seem like useful debugging checks we'd miss
   out on.

I think a big comment should be sufficient to draw the readers eyes and
explain [the extent to which :)] we are cheating.

> 
> 	/*
> 	 * Squash the __rcu annotation, the legacy MMU doesn't rely on RCU to
> 	 * protect its page tables and so the common MMU code doesn't preserve
> 	 * the annotation.
> 	 *
> 	 * It goes without saying, but the caller must honor all TDP MMU
> 	 * contracts for accessing/modifying SPTEs outside of mmu_lock.
> 	 */
> 	return (__force u64 *)sptep;
> 	
> > > +       return NULL;
> > > +}
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > > index e9dde5f9c0ef..508a23bdf7da 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > > @@ -81,6 +81,8 @@ void kvm_tdp_mmu_walk_lockless_begin(void);
> > >  void kvm_tdp_mmu_walk_lockless_end(void);
> > >  int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> > >                                   int *root_level);
> > > +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > > +                                        u64 *spte);
> > >
> > >  #ifdef CONFIG_X86_64
> > >  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> > > --
> > > 2.32.0.93.g670b81a890-goog
> > >
