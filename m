Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E545206AE
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiEIVfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiEIVfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:35:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DCD27B34
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:31:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p10so26051214lfa.12
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0kmXUFkEnnqKC9/sQ+0m3ugBE/G5/Z0l/BkNE/gds8=;
        b=BdJ89P7pwKQktoMATyevsOvT5VFT+xw7I8G3ieZ3PohzylwG947+aUTq7rIi7mu6sw
         rbvunQUi7D9Y2dC2O3GpZnq4iGvNjB8+txs9MrAEXhJ6LG6nw26rGuE9O+3Znay9iqMR
         clIMCPrJneX+9F6Rcq1e7rTcCoegMkdpEyo2JvIHyYvsmiTn8nKhFr8FifuTLM9ohfab
         cQSsH45pFWh8io6LMqdtp8aOAFKiiHh5MbHxWq/+lCtMX9s98a8M9/96jCGuO824cm/b
         7hNDNiXIMKyktw43l+RamUBXwYeBu7hSx04Ua7HjNIq+0L2hgW8QE3Wcw8xf0p2ZUAGk
         rP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0kmXUFkEnnqKC9/sQ+0m3ugBE/G5/Z0l/BkNE/gds8=;
        b=OP1H910Of0/pkYuXiiwqfmbofvB0ACOLkr4xV54f2yBywSM0vu9X+CfUeLdlaVr6R/
         hiVw6tg4GY9C8v0/t2JHRH8Mqgv5OAyLqB3yFAQak+6EDmpsMGWvyAzFZQMmbCwcDhb5
         ib285hC06ZPGmvStuGzTBkPopDiMI6D7Mq7FDm5oSTipwBWy7E3CI7tKzIRriU+AXFGk
         Tvm7Re9gl8A69pBuzWRJ1g119gsWsgKQTMC7uKQoqEhaMZSgIpNeekL+h5hLlicP2sxQ
         a1QEnpCKQVlYPFd9v640+d0oDHoKgb4hoSLZzLOmP2YISXQmDEdmucyrWJnH8Qz59Fyf
         mzWA==
X-Gm-Message-State: AOAM5300bH3kR6cEu9CDoKdesSR5RRM2SjSWKeBEzq9HmOnZqA8v3e8A
        fwhDbStan00P46WCuZVRJxUeEQaGE3rfUBYlBD79Iw==
X-Google-Smtp-Source: ABdhPJzAW1GKaJd0gxsaE4D0hl1sp51777eCufAYMr+dFKb74Wcs3khrPmyQWdNS3nCNB5gg32yUvXVVNtOGgs4pisc=
X-Received: by 2002:ac2:5399:0:b0:472:1f95:85df with SMTP id
 g25-20020ac25399000000b004721f9585dfmr13934735lfh.102.1652131899487; Mon, 09
 May 2022 14:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-17-dmatlack@google.com>
 <Ynk/vnHQsXnZkMGT@google.com>
In-Reply-To: <Ynk/vnHQsXnZkMGT@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:31:13 -0700
Message-ID: <CALzav=dZ+FQKGy=ujzV_bOCpX-UGuN-k02YugOSDYJUyax538w@mail.gmail.com>
Subject: Re: [PATCH v4 16/20] KVM: x86/mmu: Extend make_huge_page_split_spte()
 for the shadow MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 9, 2022 at 9:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Currently make_huge_page_split_spte() assumes execute permissions can be
> > granted to any 4K SPTE when splitting huge pages. This is true for the
> > TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> > shadowing a non-executable huge page.
> >
> > To fix this, pass in the child shadow page where the huge page will be
> > split and derive the execution permission from the shadow page's role.
> > This is correct because huge pages are always split with direct shadow
> > page and thus the shadow page role contains the correct access
> > permissions.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/spte.c    | 13 +++++++------
> >  arch/x86/kvm/mmu/spte.h    |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
> >  3 files changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 4739b53c9734..9db98fbeee61 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -215,10 +215,11 @@ static u64 make_spte_executable(u64 spte)
> >   * This is used during huge page splitting to build the SPTEs that make up the
> >   * new page table.
> >   */
> > -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> > +u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>
> Rather than pass in @sp, what about passing in @role?  Then the need for
> exec_allowed and child_level goes away (for whatever reason I reacted to the
> "allowed" part of exec_allowed).

I like it! Will do.

>
> E.g.
>
> ---
>  arch/x86/kvm/mmu/spte.c    | 11 +++++------
>  arch/x86/kvm/mmu/spte.h    |  3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 9db98fbeee61..1b766e381727 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -215,10 +215,9 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
> +u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
> +                             int index)
>  {
> -       bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
> -       int child_level = sp->role.level;
>         u64 child_spte;
>
>         if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
> @@ -234,9 +233,9 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>          * split. So we just have to OR in the offset to the page at the next
>          * lower level for the given index.
>          */
> -       child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
> +       child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;
>
> -       if (child_level == PG_LEVEL_4K) {
> +       if (role.level == PG_LEVEL_4K) {
>                 child_spte &= ~PT_PAGE_SIZE_MASK;
>
>                 /*
> @@ -244,7 +243,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>                  * the page executable as the NX hugepage mitigation no longer
>                  * applies.
>                  */
> -               if (exec_allowed && is_nx_huge_page_enabled())
> +               if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
>                         child_spte = make_spte_executable(child_spte);
>         }
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 921ea77f1b5e..80d36d0d9def 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>                u64 old_spte, bool prefetch, bool can_unsync,
>                bool host_writable, u64 *new_spte);
> -u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
> +u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
> +                             int index);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 110a34ca41c2..c4c4bad69f38 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1469,7 +1469,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>          * not been linked in yet and thus is not reachable from any other CPU.
>          */
>         for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -               sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
> +               sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);
>
>         /*
>          * Replace the huge spte with a pointer to the populated lower level
>
> base-commit: 721828e2397ab854b536de3ea10a9bc7962091a9
> --
