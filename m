Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35A15293B0
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349695AbiEPWie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiEPWic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:38:32 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700A33E0F5
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:38:30 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id f4so15464461lfu.12
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TdiD7dsVgR3FBrAXSNMPHodeyhLmfprzqOe6s/swopQ=;
        b=fL0lHMFnX/AAhhPQHOIy8IRUdEWFWSgKutye5AzrWvOUyqVkulwARMTZhRqvFu2vdO
         kVZJLC0kt7Y+uihrER8vRQA7064F8cSc+o+Lq6BU1d+j6+ywa2wBOWMRzI1VudYMnTX6
         dy1khjzaQw+qQIjc+aX1zpMoReWBEeC0qTi37Bf+cHNFyj7+pEEWoXYPBevvivSVPl5o
         ftLnuBXRY+oO1Yv5VYkzh0X8LTBUN6FoHAJx8J40yyMLEcbd6ihiaOp3T2r4Pkhtqwzk
         LkiubU7ATRGUPrUy8uPSvUDF1KF0TAiBKO7IjIZuNS8paf+mgh5OckrwgFYynK0IHzKy
         W9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TdiD7dsVgR3FBrAXSNMPHodeyhLmfprzqOe6s/swopQ=;
        b=hvOwP0S1nYi16bvkDk4dNNBOiyCS3QT8wV1JZNbftXd0cLwrNHd8ARihZzQO209yjN
         4wbwvPIen8pVgzhMbhTiQzxzgverDPbcT8+jLXSS9mPpVYXBaYl8biuA005mVMk+Qyi3
         05CETQXlmPoM3UTBRGIelZBTrrnrSX6bCo19PHJKuxRovOYO1sRCva/K27x4tmxs5+lS
         I40glBaO5ztJrzAhYSdpgOODH+pTcSfAbC/oE4TlMOqDlbLJODjMflJ2lixL3myiT6fr
         TuFPwfZFvN7YXjQU58mgtIxzKhclTaOrJwYDmNq4Oo/PTkp5QIpA3kaoflz3yaYYeX3I
         3H1A==
X-Gm-Message-State: AOAM531/qpSEB3XXTTHM9J26/pIR+rjTYPr65tDbWpwmw/7+XN9OylbM
        V669/J5di4BkQYWW5zee5TQkVNyohW1+yVhdbwFgtw==
X-Google-Smtp-Source: ABdhPJz2v+QP/ZNwOlcdcC6F1d3GubjpjpeEcZRMO/XWKMGCLSNgcqoQayWwNuqeQcnSUSQ2MYUUMBuJ67nvb+P5UVw=
X-Received: by 2002:a05:6512:398d:b0:473:a597:540a with SMTP id
 j13-20020a056512398d00b00473a597540amr14924018lfu.64.1652740708621; Mon, 16
 May 2022 15:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com> <20220429183935.1094599-2-dmatlack@google.com>
 <Yn65yvxPIJwgiuxj@xz-m1.local>
In-Reply-To: <Yn65yvxPIJwgiuxj@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 May 2022 15:38:02 -0700
Message-ID: <CALzav=eo5Du2kitLm_2q2ns9GRN455P086qQnQnPX2vsua5R0Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: selftests: Replace x86_page_size with raw levels
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 1:04 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Apr 29, 2022 at 06:39:27PM +0000, David Matlack wrote:
> > x86_page_size is an enum used to communicate the desired page size with
> > which to map a range of memory. Under the hood they just encode the
> > desired level at which to map the page. This ends up being clunky in a
> > few ways:
> >
> >  - The name suggests it encodes the size of the page rather than the
> >    level.
> >  - In other places in x86_64/processor.c we just use a raw int to encode
> >    the level.
> >
> > Simplify this by just admitting that x86_page_size is just the level and
> > using an int and some more obviously named macros (e.g. PG_LEVEL_1G).
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../selftests/kvm/include/x86_64/processor.h  | 14 +++++-----
> >  .../selftests/kvm/lib/x86_64/processor.c      | 27 +++++++++----------
> >  .../selftests/kvm/max_guest_memory_test.c     |  2 +-
> >  .../selftests/kvm/x86_64/mmu_role_test.c      |  2 +-
> >  4 files changed, 22 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 37db341d4cc5..b512f9f508ae 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -465,13 +465,13 @@ void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
> >  struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
> >  void vm_xsave_req_perm(int bit);
> >
> > -enum x86_page_size {
> > -     X86_PAGE_SIZE_4K = 0,
> > -     X86_PAGE_SIZE_2M,
> > -     X86_PAGE_SIZE_1G,
> > -};
> > -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> > -                enum x86_page_size page_size);
> > +#define PG_LEVEL_4K 0
> > +#define PG_LEVEL_2M 1
> > +#define PG_LEVEL_1G 2
>
> A nitpick is: we could have named those as PG_LEVEL_[PTE|PMD|PUD|PGD..]
> rather than 4K|2M|..., then...

I went with these names to match the KVM code (although the level
numbers themselves are off by 1).

>
> > +
> > +#define PG_LEVEL_SIZE(_level) (1ull << (((_level) * 9) + 12))
> > +
> > +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
> >
> >  /*
> >   * Basic CPU control in CR0
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 9f000dfb5594..1a7de69e2495 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -199,15 +199,15 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
> >                                                   uint64_t pt_pfn,
> >                                                   uint64_t vaddr,
> >                                                   uint64_t paddr,
> > -                                                 int level,
> > -                                                 enum x86_page_size page_size)
> > +                                                 int current_level,
> > +                                                 int target_level)
> >  {
> > -     struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
> > +     struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
> >
> >       if (!pte->present) {
> >               pte->writable = true;
> >               pte->present = true;
> > -             pte->page_size = (level == page_size);
> > +             pte->page_size = (current_level == target_level);
> >               if (pte->page_size)
> >                       pte->pfn = paddr >> vm->page_shift;
> >               else
> > @@ -218,20 +218,19 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
> >                * a hugepage at this level, and that there isn't a hugepage at
> >                * this level.
> >                */
> > -             TEST_ASSERT(level != page_size,
> > +             TEST_ASSERT(current_level != target_level,
> >                           "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
> > -                         page_size, vaddr);
> > +                         current_level, vaddr);
> >               TEST_ASSERT(!pte->page_size,
> >                           "Cannot create page table at level: %u, vaddr: 0x%lx\n",
> > -                         level, vaddr);
> > +                         current_level, vaddr);
> >       }
> >       return pte;
> >  }
> >
> > -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> > -                enum x86_page_size page_size)
> > +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
> >  {
> > -     const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
> > +     const uint64_t pg_size = PG_LEVEL_SIZE(level);
> >       struct pageUpperEntry *pml4e, *pdpe, *pde;
> >       struct pageTableEntry *pte;
> >
> > @@ -256,15 +255,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> >        * early if a hugepage was created.
> >        */
> >       pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
> > -                                   vaddr, paddr, 3, page_size);
> > +                                   vaddr, paddr, 3, level);
> >       if (pml4e->page_size)
> >               return;
> >
> > -     pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
> > +     pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, level);
> >       if (pdpe->page_size)
> >               return;
> >
> > -     pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
> > +     pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, level);
>
> ... here we could also potentially replace the 3/2/1s with the new macro
> (or with existing naming number 3 will be missing a macro)?

Good point. Will do.

>
> >       if (pde->page_size)
> >               return;
>
> --
> Peter Xu
>
