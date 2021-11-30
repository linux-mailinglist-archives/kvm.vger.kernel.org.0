Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24735464342
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345725AbhK3Xcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345754AbhK3XcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:32:11 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91765C06139C
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:28:20 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id k2so44352418lji.4
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TqIP0RXx7E3f6+yzuzVTrpTvIuuc+Wk2dUewCgI7AI=;
        b=Mtl+X9nK5Mr1pQLFoszaUYiFwt0iXxJ4Wdd37GMdffqbB/8vxqQKOpf55MLYmiaWbb
         7MToWIk5Y5ln5hQ4Ing/dle/k8gyfQUw1GCW0gxHy86BSG3Z7nRD5RCbFOoRHfTC0xnj
         9P7JjFix7mYGC42AA5lbKEfXOnKNLLw64clqcgEH1fJls9XY3PvC8kjMURsBkjxlkJ11
         oTWQZamaHZbn9xtZJjcskvmaKIWvANSN5nRugWj8Vo7F+a1mdR+cIx+wmProt7EuqCwW
         +xJmpftAadRwLGtVIyYzjSLIP+4gZQuiUheAIB12r8IuYeBxILqPxfWJMHhf5EM+B5Ps
         58cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TqIP0RXx7E3f6+yzuzVTrpTvIuuc+Wk2dUewCgI7AI=;
        b=NPD+oqNhSv+QTVvlqoperr1h+/VIncN2zgZn9b/ShwiUEGInuIBIzDlPHRVuBwvlZT
         g5oZxOT61rh8e85etwPCJnt3qYLSKyg18S1dGOL0JoF/JwPXEcAkmeyTE+8CdA2Qh+oc
         VzGFBce0JF+75KVgmFMeOtchH0hLoG0Cc8aNro9hAGlUWEN+g/OM9vEU1uPq6W++w9OT
         wVEYBhO1FPGSSjMTI/Jf4SYVAGgCtNWrsVDMMj8zUVZASzyBfdN+Mcx+lK5hY343Ln0p
         +iljulWHXTRdjV4EdRuEFVtn+BHMg32gsJipt3TKzxKVDE6Y8R0Tgf7BbrO6ASOtOGbq
         hdKw==
X-Gm-Message-State: AOAM530EO7aHvYznp6A8P+DbMSIVEPpkNcEHkKHJG6Ysk9YXEaYQMLSR
        MielnmjPyqTBC140nwyOLrhzltlMxvusZkjnn5GDhg==
X-Google-Smtp-Source: ABdhPJxzmaRzuiFFsyFBhzhmDWP7in/SFLl83UNnpo7BgDidjXxfOvuOqF2ij9Q1iZgDm2QBDp52jTfjGJyfYlCqXp0=
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr1956213ljj.49.1638314898705;
 Tue, 30 Nov 2021 15:28:18 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-5-dmatlack@google.com>
 <CANgfPd_DyTgb2z-1YQB-Rf+aYpGvHWogqUfv=8jH5+s7Vk-tvA@mail.gmail.com>
In-Reply-To: <CANgfPd_DyTgb2z-1YQB-Rf+aYpGvHWogqUfv=8jH5+s7Vk-tvA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:27:52 -0800
Message-ID: <CALzav=e8k6WWs6Z=rVoPZMEjW7gna9oq8QbSb-1oNgeibtGQSg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 10:53 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Factor out the logic to atomically replace an SPTE with an SPTE that
> > points to a new page table. This will be used in a follow-up commit to
> > split a large page SPTE into one level lower.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++------------
> >  1 file changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index cc9fe33c9b36..9ee3f4f7fdf5 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -945,6 +945,39 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >         return ret;
> >  }
> >
> > +/*
> > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > + * spte pointing to the provided page table.
> > + *
> > + * @kvm: kvm instance
> > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > + * @sp: The new TDP page table to install.
> > + * @account_nx: True if this page table is being installed to split a
> > + *              non-executable huge page.
> > + *
> > + * Returns: True if the new page table was installed. False if spte being
> > + *          replaced changed, causing the atomic compare-exchange to fail.
> > + *          If this function returns false the sp will be freed before
> > + *          returning.
> > + */
> > +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
> > +                                     struct tdp_iter *iter,
> > +                                     struct kvm_mmu_page *sp,
> > +                                     bool account_nx)
> > +{
> > +       u64 spte;
> > +
> > +       spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> > +
> > +       if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
> > +               tdp_mmu_link_page(kvm, sp, account_nx);
> > +               return true;
> > +       } else {
> > +               tdp_mmu_free_sp(sp);
> > +               return false;
> > +       }
> > +}
> > +
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -954,8 +987,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >         struct kvm_mmu *mmu = vcpu->arch.mmu;
> >         struct tdp_iter iter;
> >         struct kvm_mmu_page *sp;
> > -       u64 *child_pt;
> > -       u64 new_spte;
> >         int ret;
> >
> >         kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -983,6 +1014,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                 }
> >
> >                 if (!is_shadow_present_pte(iter.old_spte)) {
> > +                       bool account_nx = fault->huge_page_disallowed &&
> > +                                         fault->req_level >= iter.level;
> > +
> >                         /*
> >                          * If SPTE has been frozen by another thread, just
> >                          * give up and retry, avoiding unnecessary page table
> > @@ -992,21 +1026,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                                 break;
> >
> >                         sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> > -                       child_pt = sp->spt;
> > -
> > -                       new_spte = make_nonleaf_spte(child_pt,
> > -                                                    !shadow_accessed_mask);
> > -
> > -                       if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> > -                               tdp_mmu_link_page(vcpu->kvm, sp,
> > -                                                 fault->huge_page_disallowed &&
> > -                                                 fault->req_level >= iter.level);
> > -
> > -                               trace_kvm_mmu_get_page(sp, true);
>
> This refactoring drops this trace point. Is that intentional?

Yes it was intentional, but I forgot to describe it in the commit
message. Good catch.

This tracepoint is redundant with the one in alloc_tdp_mmu_page().

I'll update the commit message for v1.

>
>
> > -                       } else {
> > -                               tdp_mmu_free_sp(sp);
> > +                       if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
> >                                 break;
> > -                       }
> >                 }
> >         }
> >
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >
