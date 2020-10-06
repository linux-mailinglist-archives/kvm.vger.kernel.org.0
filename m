Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566622854A6
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgJFWde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 18:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgJFWde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 18:33:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BBDC061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 15:33:33 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id o18so465518ill.2
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 15:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9p1MY3hl0VjKwvxCjtFJ+LTRHD7p4AUYAZD5YNgkGmI=;
        b=euybA1L6HHdATfaMRKmXvnT08W0W/Y3u6itIt67ptVlnqL2mShdqTKHusJ/QLsCDAF
         LKKsEUVKMmgPhXMv6ZjlgWRJ9ghfcFMGzS0sZOQyvsmKxwgKuwLiATdVIPACHtAn3Sh+
         3LbBsGAv3ArmaFq54UF2LNSBno4jH3Ulr5mm/M5CbN6WP5ne103V2CgbwYPQsZiW41oX
         p8xkerimFhRULM4Enu4LLUy4N+aAHELgFEGDZP5lrbB79JZkfVQR5cuOJ8E6l2o5vGRF
         QYG9qwBY++Vg2PnHhWhmlR8NqfJQ/c9uSZq2ThtkKSv0RPOYmUGIUpbDd1hwqfhhbWa7
         vmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9p1MY3hl0VjKwvxCjtFJ+LTRHD7p4AUYAZD5YNgkGmI=;
        b=WBJlhHz5DWIAREuddT0JM7xZb5kq6+02Hen6Cca7tKdFS970KETFe6HK7oR3Sy5Ror
         F8li0Wg1G4ELaJ8tfTonEUgzG+28FYfszQb6QT+jMTcaSYVXUvNgf1oEIb9WzWKEA2ce
         NLgdlco1dD2MINjt63XzCFyJZN2BKvtLaTq53aRnc7mjNeW5NzBdbExSQdZvu1NNRGm8
         ekhcLpmndPRBFY9W/9Gfc0TqwwglxqNiWmQp/GK5dopwSTmTbZUKFZKAnvJZdumRxbYO
         x4xc8Cti0xf167fBc19slKB3XE9OJB3ucWqgbkAWR/3obqdAEj81Hk5hyrpcTSAFDdJ8
         zYKg==
X-Gm-Message-State: AOAM531Sm4bH+OkxvHcK79b5nF/+JSmjQFcZgDKrphjST00A/6Gc5w+v
        EK5bkha35Et7QrDVVhRAm8gD0TQw92iWbghrPhs7OQ==
X-Google-Smtp-Source: ABdhPJxLptLZ665u9RwWgNSkkfL5igCl9zjiYdKHBpsJGqRXwJCSk4Be37v2VD8UTG0hY2mwdkj3/eBSZYhGMJCj3Gk=
X-Received: by 2002:a92:5b02:: with SMTP id p2mr306759ilb.283.1602023612887;
 Tue, 06 Oct 2020 15:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-11-bgardon@google.com>
 <20200930163740.GD32672@linux.intel.com>
In-Reply-To: <20200930163740.GD32672@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 6 Oct 2020 15:33:21 -0700
Message-ID: <CANgfPd_A6Bbv+ehRvMVi_NK2C_Jb=bBmXJR89fj=JSFSga0avg@mail.gmail.com>
Subject: Re: [PATCH 10/22] kvm: mmu: Add TDP MMU PF handler
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 9:37 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 02:22:50PM -0700, Ben Gardon wrote:
> > @@ -4113,8 +4088,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >       if (page_fault_handle_page_track(vcpu, error_code, gfn))
> >               return RET_PF_EMULATE;
> >
> > -     if (fast_page_fault(vcpu, gpa, error_code))
> > -             return RET_PF_RETRY;
> > +     if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> > +             if (fast_page_fault(vcpu, gpa, error_code))
> > +                     return RET_PF_RETRY;
>
> It'll probably be easier to handle is_tdp_mmu() in fast_page_fault().

I'd prefer to keep this check here because then in the fast page fault
path, we can just handle the case where we do have a tdp mmu root with
the tdp mmu fast pf handler and it'll mirror the split below with
__direct_map and the TDP MMU PF handler.

>
> >
> >       r = mmu_topup_memory_caches(vcpu, false);
> >       if (r)
> > @@ -4139,8 +4115,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >       r = make_mmu_pages_available(vcpu);
> >       if (r)
> >               goto out_unlock;
> > -     r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> > -                      prefault, is_tdp && lpage_disallowed);
> > +
> > +     if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
> > +             r = kvm_tdp_mmu_page_fault(vcpu, write, map_writable, max_level,
> > +                                        gpa, pfn, prefault,
> > +                                        is_tdp && lpage_disallowed);
> > +     else
> > +             r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
> > +                              prefault, is_tdp && lpage_disallowed);
> >
> >  out_unlock:
> >       spin_unlock(&vcpu->kvm->mmu_lock);
>
> ...
>
> > +/*
> > + * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> > + * page tables and SPTEs to translate the faulting guest physical address.
> > + */
> > +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> > +                        int max_level, gpa_t gpa, kvm_pfn_t pfn,
> > +                        bool prefault, bool account_disallowed_nx_lpage)
> > +{
> > +     struct tdp_iter iter;
> > +     struct kvm_mmu_memory_cache *pf_pt_cache =
> > +                     &vcpu->arch.mmu_shadow_page_cache;
> > +     u64 *child_pt;
> > +     u64 new_spte;
> > +     int ret;
> > +     int as_id = kvm_arch_vcpu_memslots_id(vcpu);
> > +     gfn_t gfn = gpa >> PAGE_SHIFT;
> > +     int level;
> > +
> > +     if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> > +             return RET_PF_RETRY;
>
> I feel like we should kill off these silly WARNs in the existing code instead
> of adding more.  If they actually fired, I'm pretty sure that they would
> continue firing and spamming the kernel log until the VM is killed as I don't
> see how restarting the guest will magically fix anything.
>
> > +
> > +     if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
> > +             return RET_PF_RETRY;
>
> This seems especially gratuitous, this has exactly one caller that explicitly
> checks is_tdp_mmu_root().  Again, if this fires it will spam the kernel log
> into submission.
>
> > +
> > +     level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn);
> > +
> > +     for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
> > +             disallowed_hugepage_adjust(iter.old_spte, gfn, iter.level,
> > +                                        &pfn, &level);
> > +
> > +             if (iter.level == level)
> > +                     break;
> > +
> > +             /*
> > +              * If there is an SPTE mapping a large page at a higher level
> > +              * than the target, that SPTE must be cleared and replaced
> > +              * with a non-leaf SPTE.
> > +              */
> > +             if (is_shadow_present_pte(iter.old_spte) &&
> > +                 is_large_pte(iter.old_spte)) {
> > +                     *iter.sptep = 0;
> > +                     handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
> > +                                         iter.old_spte, 0, iter.level);
> > +                     kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
> > +                                     KVM_PAGES_PER_HPAGE(iter.level));
> > +
> > +                     /*
> > +                      * The iter must explicitly re-read the spte here
> > +                      * because the new is needed before the next iteration
> > +                      * of the loop.
> > +                      */
>
> I think it'd be better to explicitly, and simply, call out that iter.old_spte
> is consumed below.  It's subtle enough to warrant a comment, but the comment
> didn't actually help me.  Maybe something like:
>
>                         /*
>                          * Refresh iter.old_spte, it will trigger the !present
>                          * path below.
>                          */
>

That's a good point and calling out the relation to the present check
below is much clearer.


> > +                     iter.old_spte = READ_ONCE(*iter.sptep);
> > +             }
> > +
> > +             if (!is_shadow_present_pte(iter.old_spte)) {
> > +                     child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
> > +                     clear_page(child_pt);
> > +                     new_spte = make_nonleaf_spte(child_pt,
> > +                                                  !shadow_accessed_mask);
> > +
> > +                     *iter.sptep = new_spte;
> > +                     handle_changed_spte(vcpu->kvm, as_id, iter.gfn,
> > +                                         iter.old_spte, new_spte,
> > +                                         iter.level);
> > +             }
> > +     }
> > +
> > +     if (WARN_ON(iter.level != level))
> > +             return RET_PF_RETRY;
>
> This also seems unnecessary.  Or maybe these are all good candiates for
> KVM_BUG_ON...
>

I've replaced all these warnings with KVM_BUG_ONs.

> > +
> > +     ret = page_fault_handle_target_level(vcpu, write, map_writable,
> > +                                          as_id, &iter, pfn, prefault);
> > +
> > +     /* If emulating, flush this vcpu's TLB. */
>
> Why?  It's obvious _what_ the code is doing, the comment should explain _why_.
>
> > +     if (ret == RET_PF_EMULATE)
> > +             kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > +
> > +     return ret;
> > +}
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index cb86f9fe69017..abf23dc0ab7ad 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -14,4 +14,8 @@ void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> >
> >  bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
> >  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> > +
> > +int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> > +                        int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
> > +                        bool lpage_disallowed);
> >  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >
