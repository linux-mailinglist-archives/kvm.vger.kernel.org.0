Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9D5206CE
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiEIVpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiEIVpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:45:18 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6BB5DA6B
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:41:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w19so26089221lfu.11
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O+5gvsFijOHeW3i755kklmCaNCPDrPNduHFLHJgoMI8=;
        b=bhNOFb/ujRVSbL/+KIKaKwcxZJXu5sdlVTvgox92xqawxOdyXcuhwJ/ZfiLwgx0zkB
         rWp2VUnHPTmRizZI0H5Zx//ET/GzJK7XbUChcnwYBowjffWiC66TqPhPeOAjx7U/8lEU
         6NjYacJEaLjLPNkd2nVuOzLxWGGzY0sfDNKLmTJFa/dkyzQ0VdeW/v6NwV2HTyXKeD2Z
         zoCOYbSPtT35iepPAdvX6k70g92evKNYXsqMRfnqzEfDBZrs1VoWHAabc+4tUzoGJJYG
         lem7Rxz5VSNBh0lcN1vobTMCOFZEi6iPdhDFYXf6567DJdjmYKSqGjoQL6J0+3OiPKFj
         sNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O+5gvsFijOHeW3i755kklmCaNCPDrPNduHFLHJgoMI8=;
        b=5V5IIRzitVy8uDBpgJZu90rMWyQZdo98i+v4WNQxQUw4ol7y1J4qw9pJ1/vH6JYkAa
         S8t3dmszJJF5DQHcQwlxK+CuE4SUtcV6M+Sao6dhAL9U/d5jIKzDbubIoJk1S/D6hrUI
         pQEw1hcvM/Sk8jZHoMw+mRsL6lpPbTHGqXSyRR1LRad4nWNiQAw1QDhukkvQocUke1Iq
         D/8aiPEiQuS+iQztQGxH1p2+BYmxZwd+uDU4ZUDmOf4lG22c77on+kbGwGLmZUg08UFR
         EwrSAji/RGv4iz8PfYUNjLV5W3BAx/4eUabhRv4bRmaOEueYT+P6OFO6X+G4uGLQOp3E
         uvig==
X-Gm-Message-State: AOAM530SO5pfIvVuWOyZwy30EM90aQdE6IaUpuQRLdXMYQ6NREq2wtuc
        leldiAEADjg8CwbWA29fajo75a7evtVQwTU91fMQlg==
X-Google-Smtp-Source: ABdhPJynfBI2TATP0BS9cf2tDgm1Odlr/6us6YsCv+zgfrkGbMVsGuj1TtNZCdoktolPs7BHsN/YjWoS8WV1kehKsww=
X-Received: by 2002:a05:6512:398d:b0:473:a597:540a with SMTP id
 j13-20020a056512398d00b00473a597540amr14456367lfu.64.1652132481002; Mon, 09
 May 2022 14:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-21-dmatlack@google.com>
 <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
In-Reply-To: <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:40:54 -0700
Message-ID: <CALzav=dTmLLO1tLDuZyx6EPF3RbRi=BtpKiT0piU6xjW6f_LSw@mail.gmail.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 7, 2022 at 12:51 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
>
> On 2022/4/23 05:05, David Matlack wrote:
> > Add support for Eager Page Splitting pages that are mapped by nested
> > MMUs. Walk through the rmap first splitting all 1GiB pages to 2MiB
> > pages, and then splitting all 2MiB pages to 4KiB pages.
> >
> > Note, Eager Page Splitting is limited to nested MMUs as a policy rather
> > than due to any technical reason (the sp->role.guest_mode check could
> > just be deleted and Eager Page Splitting would work correctly for all
> > shadow MMU pages). There is really no reason to support Eager Page
> > Splitting for tdp_mmu=N, since such support will eventually be phased
> > out, and there is no current use case supporting Eager Page Splitting on
> > hosts where TDP is either disabled or unavailable in hardware.
> > Furthermore, future improvements to nested MMU scalability may diverge
> > the code from the legacy shadow paging implementation. These
> > improvements will be simpler to make if Eager Page Splitting does not
> > have to worry about legacy shadow paging.
> >
> > Splitting huge pages mapped by nested MMUs requires dealing with some
> > extra complexity beyond that of the TDP MMU:
> >
> > (1) The shadow MMU has a limit on the number of shadow pages that are
> >      allowed to be allocated. So, as a policy, Eager Page Splitting
> >      refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
> >      pages available.
> >
> > (2) Splitting a huge page may end up re-using an existing lower level
> >      shadow page tables. This is unlike the TDP MMU which always allocates
> >      new shadow page tables when splitting.
> >
> > (3) When installing the lower level SPTEs, they must be added to the
> >      rmap which may require allocating additional pte_list_desc structs.
> >
> > Case (2) is especially interesting since it may require a TLB flush,
> > unlike the TDP MMU which can fully split huge pages without any TLB
> > flushes. Specifically, an existing lower level page table may point to
> > even lower level page tables that are not fully populated, effectively
> > unmapping a portion of the huge page, which requires a flush.
> >
> > This commit performs such flushes after dropping the huge page and
> > before installing the lower level page table. This TLB flush could
> > instead be delayed until the MMU lock is about to be dropped, which
> > would batch flushes for multiple splits.  However these flushes should
> > be rare in practice (a huge page must be aliased in multiple SPTEs and
> > have been split for NX Huge Pages in only some of them). Flushing
> > immediately is simpler to plumb and also reduces the chances of tripping
> > over a CPU bug (e.g. see iTLB multihit).
> >
> > Suggested-by: Peter Feiner <pfeiner@google.com>
> > [ This commit is based off of the original implementation of Eager Page
> >    Splitting from Peter in Google's kernel from 2016. ]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   .../admin-guide/kernel-parameters.txt         |   3 +-
> >   arch/x86/include/asm/kvm_host.h               |  20 ++
> >   arch/x86/kvm/mmu/mmu.c                        | 276 +++++++++++++++++-
> >   arch/x86/kvm/x86.c                            |   6 +
> >   4 files changed, 296 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 3f1cc5e317ed..bc3ad3d4df0b 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2387,8 +2387,7 @@
> >                       the KVM_CLEAR_DIRTY ioctl, and only for the pages being
> >                       cleared.
> >
> > -                     Eager page splitting currently only supports splitting
> > -                     huge pages mapped by the TDP MMU.
> > +                     Eager page splitting is only supported when kvm.tdp_mmu=Y.
> >
> >                       Default is Y (on).
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 15131aa05701..5df4dff385a1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1240,6 +1240,24 @@ struct kvm_arch {
> >       hpa_t   hv_root_tdp;
> >       spinlock_t hv_root_tdp_lock;
> >   #endif
> > +
> > +     /*
> > +      * Memory caches used to allocate shadow pages when performing eager
> > +      * page splitting. No need for a shadowed_info_cache since eager page
> > +      * splitting only allocates direct shadow pages.
> > +      */
> > +     struct kvm_mmu_memory_cache split_shadow_page_cache;
> > +     struct kvm_mmu_memory_cache split_page_header_cache;
> > +
> > +     /*
> > +      * Memory cache used to allocate pte_list_desc structs while splitting
> > +      * huge pages. In the worst case, to split one huge page, 512
> > +      * pte_list_desc structs are needed to add each lower level leaf sptep
> > +      * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> > +      * page table.
> > +      */
> > +#define SPLIT_DESC_CACHE_CAPACITY 513
> > +     struct kvm_mmu_memory_cache split_desc_cache;
> >   };
> >
> >
>
>
> I think it needs to document that the topup operations for these caches are
>
> protected by kvm->slots_lock.

Will do. Thanks!
>
