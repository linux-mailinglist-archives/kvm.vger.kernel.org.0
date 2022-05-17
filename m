Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB9529694
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 03:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiEQBOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiEQBOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 21:14:07 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFAC40928;
        Mon, 16 May 2022 18:14:06 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id r1so29963762ybo.7;
        Mon, 16 May 2022 18:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Krh36ViT/EwDdvnp42Kcg/9QiROI+wYenJfQpSBh8DQ=;
        b=dZ0jQ9xFO9MEBQYlRmAuN309bWDTIKOAEWzH10mbYlxK3A92D3O0rHe3NMpGuuQRQ0
         82bXfjvfZbU8U3eVvx/0QD4KI+iKYr756RlYNR6+VTLCwjM+kkGTBPSXnaMWH3stcIhY
         vHxweQPMbfB2eifacLq1uvr8DRxV1oFRo9vlvfHhreO9osahVcApnPBYPyvDlMUbCsV8
         G+F3cLdAzLnhtRB7IAt8X+y9WfkVbQLtMU5rMFylehhZezTHqvuiNzVGAyB86G4/qMCe
         172JNlMOqmXe+aSUG0Ti93KH8Ky0IOH8nJ7VpS0nsgyOJUT6597M2MIhN1IUXsI4fyy3
         f2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Krh36ViT/EwDdvnp42Kcg/9QiROI+wYenJfQpSBh8DQ=;
        b=bo7hlcxO/eO/rssHf5vIysaLWaAFBRy/6KoCbsdLMEFHb7bop2fQdeUEmkHt9qiZOM
         +/WaRRaPXbPeKPTqLcgr4o3slT83dvxn+LtkuttkuRdTnbLDbs3WHk6RhIkTuJ7t+br7
         bmBNbMeBMGFYf8q7o+lav3/bK7Nll/C4wKHi6vCnxsPJakiZpQYn/P6WsSrISTQP5qTT
         4YhGLP8Gw0MvYPhikhbTaFeIF7UoRyAlLKYdTluKZlDKGUlFJi7NENYxvnUeCb3ixgxU
         ixJ7zop8Tcb88rPE2RMngDLuWuCdgjmcu0SXI9khGDc/bVxz3keKc0PyMcJCVz1cuNQz
         RRdQ==
X-Gm-Message-State: AOAM532+ZUXA7fy11IatRMAglrjJxsw2wmhZBfBvwGGmp8zUyomjyz5v
        uuoA/ThIjkSYYNjfqtVuj/LjLv+FXtoT5EV4kkA=
X-Google-Smtp-Source: ABdhPJyFdaX9VMqmdftxmEICDY2lizLH2P+RWV4/NuazfAIT5DH3J4F0SfPEA0zhjUDb0Rx58XTM5r2HrA5UMLS+7TQ=
X-Received: by 2002:a25:7694:0:b0:64d:b38b:40ec with SMTP id
 r142-20020a257694000000b0064db38b40ecmr6827973ybc.526.1652750045900; Mon, 16
 May 2022 18:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-4-jiangshanlai@gmail.com> <YoLlzcejEDh8VpoB@google.com>
In-Reply-To: <YoLlzcejEDh8VpoB@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 17 May 2022 09:13:54 +0800
Message-ID: <CAJhGHyCKdxti0gDjDP27MDd=bK+0BecXqzExo5t-WAOQLO5WwA@mail.gmail.com>
Subject: Re: [PATCH V2 3/7] KVM: X86/MMU: Link PAE root pagetable with its children
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 8:01 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, May 03, 2022 at 11:07:31PM +0800, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > When special shadow pages are activated, link_shadow_page() might link
> > a special shadow pages which is the PAE root for PAE paging with its
> > children.
> >
> > Add make_pae_pdpte() to handle it.
> >
> > The code is not activated since special shadow pages are not activated
> > yet.
> >
> > Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c  | 6 +++++-
> >  arch/x86/kvm/mmu/spte.c | 7 +++++++
> >  arch/x86/kvm/mmu/spte.h | 1 +
> >  3 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 126f0cd07f98..3fe70ad3bda2 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2277,7 +2277,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> >
> >       BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
> >
> > -     spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> > +     if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
> > +                  vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL))
> > +             spte = make_pae_pdpte(sp->spt);
> > +     else
> > +             spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> >
> >       mmu_spte_set(sptep, spte);
> >
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 75c9e87d446a..ccd9267a58ca 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -251,6 +251,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> >       return child_spte;
> >  }
> >
> > +u64 make_pae_pdpte(u64 *child_pt)
> > +{
> > +     /* The only ignore bits in PDPTE are 11:9. */
> > +     BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
> > +     return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
> > +             shadow_me_value;
>
> If I'm reading mmu_alloc_{direct,shadow}_roots() correctly, PAE page
> directories just get: root | PT_PRESENT_MASK | shadow_me_value. Is there
> a reason to add SPTE_MMU_PRESENT_MASK or am I misreading the code?

Because it has a struct kvm_mmu_page associated with it now.

sp->spt[i] requires SPTE_MMU_PRESENT_MASK if it is present.

>
> > +}
> >
> >  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
> >  {
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index fbbab180395e..09a7e4ba017a 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -413,6 +413,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >              u64 old_spte, bool prefetch, bool can_unsync,
> >              bool host_writable, u64 *new_spte);
> >  u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
> > +u64 make_pae_pdpte(u64 *child_pt);
> >  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
> >  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
> >  u64 mark_spte_for_access_track(u64 spte);
> > --
> > 2.19.1.6.gb485710b
> >
