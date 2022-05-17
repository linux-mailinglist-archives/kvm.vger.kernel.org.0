Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B073752A855
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346446AbiEQQmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiEQQmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:42:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CE93EF11
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:42:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c22so657007pgu.2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UAaK0aU2k1qQWWA1NGAVdax/L+mO0Yx8sa53VfFr0E0=;
        b=FAg0TouXgjpk19jvVBTpS2yi0HzoIqR5b71b+PMKbwpZMPO1LZuzVCe6EPm3a5bf2v
         fbkXVBiZV3TOhPvfJAuAFYvSLRndrHQfQ5j9leSEEt+ykDBiFbuwbZuYBNdSvm/WCtcV
         4NJAmUPPZEXXatIF9oal5vnGZW+3qSjbzPslrTO2NwswDDhykcQ5dAZg9vq5LUgqdna8
         Ic4mhJj3ws2m0H7Mg85/Nqf/7UzLcn7QcqxrwY6Z8TZ1yC0mCWalS7N/mUyc02Aaf5MN
         EonoD/leoWhq/NP4bLZK5VS360YZhsvG9+qln6ggH/W9TTnTg/Jfbwmzr0ea1XnjG8ez
         /AAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UAaK0aU2k1qQWWA1NGAVdax/L+mO0Yx8sa53VfFr0E0=;
        b=K1cWHu7pmoCxt6ZROkEsjDepkrubMH87irQ9Y2Cbbitv6Tyd77sIm2DCt5ieFl8s6o
         74EIspeR37BNPtIKPXFGvcrz7YNyqO8RdWdtqRgMlIwpQGzPEU4v/Ur/YnnJEFhdmsVY
         G6cKVqMJL+XVt8TNaMfD04xRoOjBqwFwBTG/0ji2x3AVG9aGDeoQJ/KOAx7N04Iay2zO
         zGS2gVrTaOMSy1ojHdjjARMcp7ROvOORTFsohK698CjdKHw1DgEoOzKz/8gl4cRJhNKV
         53aYCy4oiKsXzV653Hi1lHNTlbSQlrbKgwnl9jA7eEXMlUoqDed/wygTXzdeVsQW4D6W
         BGmA==
X-Gm-Message-State: AOAM5319BAkdNahjcM1gMdbFNejqyGv/QXZNFSr5/N1uRJcHqyYnUh3N
        oBt/pRt7yOYhUY2i4KipiKML4A==
X-Google-Smtp-Source: ABdhPJyze21TTVro1wc6Lf6A3iR1HlwFnF4lUSG1rF8LQuPROGGD1VpxYzDbokW9v5V+R2VGUNNr/Q==
X-Received: by 2002:a63:43c2:0:b0:3c1:829a:5602 with SMTP id q185-20020a6343c2000000b003c1829a5602mr20449743pga.252.1652805724330;
        Tue, 17 May 2022 09:42:04 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903024f00b0015eee3ab203sm9562937plh.49.2022.05.17.09.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 09:42:03 -0700 (PDT)
Date:   Tue, 17 May 2022 16:41:59 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
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
Subject: Re: [PATCH V2 3/7] KVM: X86/MMU: Link PAE root pagetable with its
 children
Message-ID: <YoPQV0wDIMBr3HKG@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-4-jiangshanlai@gmail.com>
 <YoLlzcejEDh8VpoB@google.com>
 <CAJhGHyCKdxti0gDjDP27MDd=bK+0BecXqzExo5t-WAOQLO5WwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCKdxti0gDjDP27MDd=bK+0BecXqzExo5t-WAOQLO5WwA@mail.gmail.com>
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

On Tue, May 17, 2022 at 09:13:54AM +0800, Lai Jiangshan wrote:
> On Tue, May 17, 2022 at 8:01 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Tue, May 03, 2022 at 11:07:31PM +0800, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > >
> > > When special shadow pages are activated, link_shadow_page() might link
> > > a special shadow pages which is the PAE root for PAE paging with its
> > > children.
> > >
> > > Add make_pae_pdpte() to handle it.
> > >
> > > The code is not activated since special shadow pages are not activated
> > > yet.
> > >
> > > Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c  | 6 +++++-
> > >  arch/x86/kvm/mmu/spte.c | 7 +++++++
> > >  arch/x86/kvm/mmu/spte.h | 1 +
> > >  3 files changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 126f0cd07f98..3fe70ad3bda2 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2277,7 +2277,11 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
> > >
> > >       BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
> > >
> > > -     spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> > > +     if (unlikely(sp->role.level == PT32_ROOT_LEVEL &&
> > > +                  vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL))
> > > +             spte = make_pae_pdpte(sp->spt);
> > > +     else
> > > +             spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> > >
> > >       mmu_spte_set(sptep, spte);
> > >
> > > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > > index 75c9e87d446a..ccd9267a58ca 100644
> > > --- a/arch/x86/kvm/mmu/spte.c
> > > +++ b/arch/x86/kvm/mmu/spte.c
> > > @@ -251,6 +251,13 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> > >       return child_spte;
> > >  }
> > >
> > > +u64 make_pae_pdpte(u64 *child_pt)
> > > +{
> > > +     /* The only ignore bits in PDPTE are 11:9. */
> > > +     BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
> > > +     return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
> > > +             shadow_me_value;
> >
> > If I'm reading mmu_alloc_{direct,shadow}_roots() correctly, PAE page
> > directories just get: root | PT_PRESENT_MASK | shadow_me_value. Is there
> > a reason to add SPTE_MMU_PRESENT_MASK or am I misreading the code?
> 
> Because it has a struct kvm_mmu_page associated with it now.
> 
> sp->spt[i] requires SPTE_MMU_PRESENT_MASK if it is present.

Ah of course. e.g. FNAME(fetch) will call is_shadow_present_pte() on PAE
PDPTEs.

Could you also update the comment above SPTE_MMU_PRESENT_MASK? Right now it
says: "Use bit 11, as it is ignored by all flavors of SPTEs and checking a low
bit often generates better code than for a high bit, e.g. 56+." I think it
would be helpful to also meniton that SPTE_MMU_PRESENT_MASK is also used in
PDPTEs which only ignore bits 11:9.


> 
> >
> > > +}
> > >
> > >  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
> > >  {
> > > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > > index fbbab180395e..09a7e4ba017a 100644
> > > --- a/arch/x86/kvm/mmu/spte.h
> > > +++ b/arch/x86/kvm/mmu/spte.h
> > > @@ -413,6 +413,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > >              u64 old_spte, bool prefetch, bool can_unsync,
> > >              bool host_writable, u64 *new_spte);
> > >  u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
> > > +u64 make_pae_pdpte(u64 *child_pt);
> > >  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
> > >  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
> > >  u64 mark_spte_for_access_track(u64 spte);
> > > --
> > > 2.19.1.6.gb485710b
> > >
