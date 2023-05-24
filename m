Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BAA70FB97
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjEXQXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 12:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjEXQWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 12:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EE010B
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684945328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yPwyuS1OongKitLVaU9z5x5rdysTI14nc2mLRrtatWw=;
        b=QljhobqysXYCe3EG9X6fU+Xp8tww2tTqTEq3hzAtbH3VmeYUAJHrdKX58pOAMfpe/qjLfQ
        /7cJslFqAB3FTRNwWl3wkfngRJbkwFibu/eW/2NYz/Kks4zejsnl3jMbLa+bKuNznDL7QS
        Zp1ACPLdWc4hGJ644twmhM9vPy64Q3M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-H-T6jSOSMd2uHNEQWuyKyA-1; Wed, 24 May 2023 12:22:06 -0400
X-MC-Unique: H-T6jSOSMd2uHNEQWuyKyA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6257fdf4bc6so1985806d6.0
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 09:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684945326; x=1687537326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yPwyuS1OongKitLVaU9z5x5rdysTI14nc2mLRrtatWw=;
        b=PP0d2cs/SMdLcQpOp39NQNBBOZh/+JW1UGX2J4n16axXR5QtokyNmFumeXdsHu2Qw/
         ERzmo4hsepvuQWSOy26EK9cNPGbcZUveWro6JAmqqtPdPaX+r1jRYGLGVH7pz75Q9lFq
         z0ESglJ7mvYLx6GPYBOaWZ2alMiYbU5wuHktPmHFPL1SlpntlkFOw2RxpLv+21c4RDmL
         0SEumHvWKfs/kG2xyMksuTfq7CweaKFKnvpEHnRMJUl7p7m8eQosW0Yi2Ue7XgfstM5M
         a1CvnffQiGAH5fdveMFR5bWoWhrllgzQN1BfpKitt7rZC5hUZFUSoj004b8LSAGn12m5
         Pg2w==
X-Gm-Message-State: AC+VfDz2N1rwbLPUPfJarAYBsddVygOO2P+uti3TzUz9TeyTr8GeRIzM
        RemyctpTY8WTQxIwl3wWGiv7vmiBkzLkgndUe4rULkpPEwWa7oj9TeVT1yIAwO4M1xgOF6xce3E
        gPL0Y6LAvLeSW
X-Received: by 2002:a05:6214:4118:b0:622:265e:3473 with SMTP id kc24-20020a056214411800b00622265e3473mr26910196qvb.1.1684945326054;
        Wed, 24 May 2023 09:22:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ44gSuxNK5fKTIYGrmxrxLmxwCMv6vwRSeYWoCsOBEZjRDG+1NMNWBC7tmoLEdae6sAzBVCjg==
X-Received: by 2002:a05:6214:4118:b0:622:265e:3473 with SMTP id kc24-20020a056214411800b00622265e3473mr26910168qvb.1.1684945325673;
        Wed, 24 May 2023 09:22:05 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id bz16-20020ad44c10000000b00621253d19f9sm3649443qvb.98.2023.05.24.09.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 09:22:04 -0700 (PDT)
Date:   Wed, 24 May 2023 12:22:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 1/4] KVM: mmu: introduce new gfn_to_pfn_noref functions
Message-ID: <ZG45q0xJSnA6NKQN@x1n>
References: <20230330085802.2414466-1-stevensd@google.com>
 <20230330085802.2414466-2-stevensd@google.com>
 <ZGvUsf7lMkrNDHuE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZGvUsf7lMkrNDHuE@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 01:46:41PM -0700, Sean Christopherson wrote:
> +Peter
> 
> On Thu, Mar 30, 2023, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > Introduce new gfn_to_pfn_noref functions that parallel existing
> > gfn_to_pfn functions. These functions can be used when the caller does
> > not need to maintain a reference to the returned pfn (i.e. when usage is
> > guarded by a mmu_notifier). The noref functions take an out parameter
> > that is used to return the struct page if the hva was resolved via gup.
> > The caller needs to drop its reference such a returned page.
> 
> I dislike the "noref" name and the approach itself (of providing an entirely
> separate set of APIs).  Using "noref" is confusing because the callers do actually
> get a reference to the page (if a refcounted page is found).
> 
> As for the approach, I really, really don't want to end up with yet more APIs
> for getting PFNs from GFNs.  We already have far too many.  In the short term,
> I think we'll need to carry multiple sets of APIs, as converting all architectures
> to any new API will be too much for a single series.  But I want to have line of
> sight to convering on a single, as-small-as-possible set of APIs, and I think/hope
> it should be possible to make the old APIs, e.g. gfn_to_pfn(), to be shims around
> the new APIs.
> 
> And since this series is essentially overhauling the gfn_to_pfn APIs, I think it's
> the right series to take on refactoring the APIs to clean up the growing flag
> problem.  There was a bit of discussion back when "interruptible" support was
> added (https://lore.kernel.org/all/YrTbKaRe497n8M0o@xz-m1.loca), but it got punted
> because it wasn't necessary, and because there wasn't immediate agreement on what
> exactly the APIs should look like.
> 
> Overhauling the APIs would also let us clean up things like async #PF, specifically
> replacing the unintuitive "*async = true" logic with something like this:
> 
> 		if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
> 			pfn = KVM_PFN_ERR_FAULT_MINOR;
> 		else
> 			pfn = KVM_PFN_ERR_FAULT;
> 
> Lastly, I think there's also an opportunity here to harden KVM's interaction with
> mmu_notifiers, and to dedup arch code in KVM .  Specifically, even when the proposed
> "allow_unsafe_kmap" is true, KVM should either (a) be "in" an mmu_notifier sequence
> or (b) _want_ to grab a reference.  And when KVM does NOT want a reference, the core
> API can/should immediately drop the reference even before returning.
> 
> My thought is it provide an "entirely" new API, named something like kvm_follow_pfn()
> to somewhat mirror follow_{pfn,pte,phys}().  Ideally something to pair with gup()
> would be nice, but having a dedicated KVM helper to get _only_ struct page memory
> doesn't work well because KVM almost never wants only struct page memory.
> 
> As for the flags vs. bools debate (see link above), I think the best approach is
> a mix of the two.  Specifically, reuse the FOLL_* flags as-is for inputs, and use
> booleans for outputs.  I don't _think_ there are any input bools/flags that don't
> map 1:1 with existing FOLL_* flags.
> 
> As a very, *very* rough sketch, provide APIs that look a bit like this.

Unifying ref vs nonref cases does look a bit cleaner to me too.

> 
>   kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
>   {
> 	kvm_pfn_t pfn;
> 
> 	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))

IMHO we may not want to rely on mmu_seq==0 either for unlucky very initial
mmu_seq being zero, or avoid overflows?

I'd say we can stick with FOLL_GET in this case to identify ref vs nonref
and always assume mmu_seq a pure random number.

> 		return KVM_PFN_ERR_FAULT;
> 
> 	pfn = ???;
> 
> 	if (foll->page && !(foll->flags & FOLL_GET))
> 		put_page(foll->page);
> 
> 	return pfn;
>   }
> 
>   kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
>   {
> 	struct kvm_follow_pfn foll = {
> 		.flags = FOLL_GET | FOLL_WRITE,
> 	};
> 
> 	<more stuff here?>
> 
> 	foll.slot = ???;
> 	if (!foll.slot || foll.slot->flags & KVM_MEMSLOT_INVALID)
> 		return KVM_HVA_ERR_BAD;
> 
> 	if (memslot_is_readonly(foll.slot))
> 		return KVM_HVA_ERR_RO_BAD;
> 
> 	return __kvm_follow_pfn(&foll);
>   }
> 
> and a few partially converted users
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 67e2ac799aa7..5eaf0395ed87 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -550,12 +550,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>  
>         if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
>                 flush = true;
> -               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> +               if (is_refcounted_page_pte(old_spte))

One question is how to impl is_refcounted_page_pte() here to identify
non-refcountable pages.

IIUC those pages are mostly identical to a normal page (so !PG_reserved)
but it has page_ref_count(page)==0 always, am I right?  I got that roughly
from reading f8be156be1 only though, so I could miss a lot of things..

When thinking about that, I'm also wondering whether we can trivially allow
kvm to support such mapping (without overhaul of the kvm pfn API) by
something like this:

===8<===
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 51e4882d0873..467acbac1a96 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -192,7 +192,13 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)

        page = pfn_to_page(pfn);
        if (!PageReserved(page))
-               return page;
+               /*
+                * When page_ref_count(page)==0 it might be speical page
+                * that do not support refcounting.  Treating them the same
+                * as normal reserved (e.g. MMIO) pages by returning NULL,
+                * so they're exempt of refcounting.
+                */
+               return page_ref_count(page) == 0 ? NULL : page;

        /* The ZERO_PAGE(s) is marked PG_reserved, but is refcounted. */
        if (is_zero_pfn(pfn))
===8<===

So that we treat those special pages the same as normal PFNMAP ones by
skipping all refcountings on inc/dec.  This is based on the fact that kvm
should always hold at least 1 ref on a normal page so a normal page should
never hit ref==0 here, but again I could miss something somewhere..

> +                       kvm_set_page_accessed(pfn_to_page(spte_to_pfn));
>         }
>  
>         if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
>                 flush = true;
> -               kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +               if (is_refcounted_page_pte(old_spte))
> +                       kvm_set_page_dirty(pfn_to_page(spte_to_pfn));
>         }
>  
>         return flush;
> @@ -4278,6 +4280,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> +       struct kvm_follow_pfn foll = {
> +               .mmu_seq = fault->mmu_seq,
> +               .gfn = fault->gfn,
> +       };
>         struct kvm_memory_slot *slot = fault->slot;
>         bool async;
>  
> @@ -4309,12 +4315,16 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>                         return RET_PF_EMULATE;
>         }
>  
> -       async = false;
> -       fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, false, &async,
> -                                               fault->write, &fault->map_writable,
> -                                               &fault->hva, &fault->page);
> -       if (!async)
> -               return RET_PF_CONTINUE; /* *pfn has correct page already */
> +       foll.flags = FOLL_NOWAIT;
> +       if (fault->write)
> +               foll.flags |= FOLL_WRITE;
> +
> +       fault->pfn = __kvm_follow_pfn(&foll);
> +       if (!is_error_noslot_pfn(fault->pfn))
> +               goto success;
> +
> +       if (!is_fault_minor_pfn(fault->pfn))
> +               return RET_PF_CONTINUE;
>  
>         if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>                 trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4332,9 +4342,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * to wait for IO.  Note, gup always bails if it is unable to quickly
>          * get a page and a fatal signal, i.e. SIGKILL, is pending.
>          */
> -       fault->pfn = __gfn_to_pfn_noref_memslot(slot, fault->gfn, false, true, NULL,
> -                                               fault->write, &fault->map_writable,
> -                                               &fault->hva, &fault->page);
> +       foll.flags |= FOLL_INTERRUPTIBLE;
> +       foll.flags &= ~FOLL_NOWAIT;
> +
> +       fault->pfn = kvm_follow_pfn(&foll);
> +       if (!is_error_noslot_pfn(fault->pfn))
> +               goto success;
> +
> +       return RET_PF_CONTINUE;
> +success:
> +       fault->hva = foll.hva;
> +       fault->page = foll.page;
> +       fault->map_writable = foll.writable;
>         return RET_PF_CONTINUE;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 360eaa24456f..0bae253c88dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2663,9 +2663,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>                 if (r < 0)
>                         pfn = KVM_PFN_ERR_FAULT;
>         } else {
> -               if (async && vma_is_valid(vma, write_fault))
> -                       *async = true;
> -               pfn = KVM_PFN_ERR_FAULT;
> +               if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
> +                       pfn = KVM_PFN_ERR_FAULT_MINOR;
> +               else
> ...skipping...
> +       fault->pfn = kvm_follow_pfn(&foll);
> +       if (!is_error_noslot_pfn(fault->pfn))
> +               goto success;
> +
> +       return RET_PF_CONTINUE;
> +success:
> +       fault->hva = foll.hva;
> +       fault->page = foll.page;
> +       fault->map_writable = foll.writable;
>         return RET_PF_CONTINUE;
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 360eaa24456f..0bae253c88dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2663,9 +2663,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>                 if (r < 0)
>                         pfn = KVM_PFN_ERR_FAULT;
>         } else {
> -               if (async && vma_is_valid(vma, write_fault))
> -                       *async = true;
> -               pfn = KVM_PFN_ERR_FAULT;
> +               if ((flags & FOLL_NOWAIT) && vma_is_valid(vma, flags & FOLL_WRITE))
> +                       pfn = KVM_PFN_ERR_FAULT_MINOR;
> +               else
> +                       pfn = KVM_PFN_ERR_FAULT;
>         }
>  exit:
>         mmap_read_unlock(current->mm);
> @@ -2732,6 +2733,30 @@ kvm_pfn_t __gfn_to_pfn_noref_memslot(const struct kvm_memory_slot *slot, gfn_t g
>  }
>  EXPORT_SYMBOL_GPL(__gfn_to_pfn_noref_memslot);
>  
> +kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
> +{
> +       kvm_pfn_t pfn;
> +
> +       if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))
> +               return KVM_PFN_ERR_FAULT;
> +
> +       pfn = __gfn_to_pfn_noref_memslot(...);
> +
> +       if (foll->page && !(foll->flags & FOLL_GET))
> +               put_page(foll->page);
> +
> +       return pfn;
> +}
> +
> +kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
> +{
> +       struct kvm_follow_pfn foll = {
> +               .flags = FOLL_GET | FOLL_WRITE,
> +       };
> +
> +       return __kvm_follow_pfn(&foll);
> +}
> +
>  kvm_pfn_t gfn_to_pfn_noref_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>                                 bool *writable, struct page **page)
>  {
> @@ -2910,25 +2935,23 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
>  
>  int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
>  {
> +       struct page *page;
>         kvm_pfn_t pfn;
>         void *hva = NULL;
> -       struct page *page = KVM_UNMAPPED_PAGE;
>  
>         if (!map)
>                 return -EINVAL;
>  
> -       pfn = gfn_to_pfn(vcpu->kvm, gfn);
> +       pfn = kvm_follow_pfn(vcpu->kvm, gfn, &page)
>         if (is_error_noslot_pfn(pfn))
>                 return -EINVAL;
>  
> -       if (pfn_valid(pfn)) {
> -               page = pfn_to_page(pfn);
> +       if (page)
>                 hva = kmap(page);
>  #ifdef CONFIG_HAS_IOMEM
> -       } else {
> +       else if (allow_unsafe_kmap)
>                 hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>  #endif
> -       }
>  
>         if (!hva)
>                 return -EFAULT;
> 

-- 
Peter Xu

