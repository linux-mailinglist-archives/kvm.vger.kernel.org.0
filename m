Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D775209C3
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiEJADf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiEJADc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:03:32 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290D32BAE7E
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 16:59:37 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 16so18910060lju.13
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 16:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sv3pTpJTnWXaUyOjFBwaWrS/CLWAom11yfRsP9pioX8=;
        b=VF6L1TPfm2H2grwGvQxjXB/rArUophBvKMYmM/4AEEpeIZrYdUdTkfOBkEk4BEbWI2
         /BgJZ8DPOFsMFZ5/prlhmlOCXI7dMWlqrjCriPK4EOPMoBMidR/ccweduFs1gDKmRT2a
         jSe0+YixmYg86Fdp+ChmxZ0pmebT4hiwVv3DgQ+7zzAAdiclAHaSsZx+fOvRaoxK4gQl
         ntcTyXAntp2EDiFAzJWUKf/TOAG3zn5txtEp+PpXundea+M6c7weB3Tkwug4AMtjQHXw
         PJuQq1IbklNK0Aix9p1bGOaT0nnOf65MjY4stPTNcj1Kn4OveQSBaQvqSlsF5pHRI33D
         4PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sv3pTpJTnWXaUyOjFBwaWrS/CLWAom11yfRsP9pioX8=;
        b=xM+NkFSB+Hb6/Ggb44n0txFEHHPRcrvF0EdLHZeS1oM47aEyC+dKNrf7bmYGRq8ft3
         XPmeYFACLFKkt4KNb5juwINPcFw0gFqyC7TCWX6fhbetxpdt9bl9/2RgoOf5bEF6nCbh
         FC37xswgxQ4acaOLpVOzMlVTi5+TgmJFS9BI8Haafbka7Ywae2+6nfBHBbxfKY1hlccD
         AoMDQX+80X+Kla40fSOU9Csn0JdejpOpatCmZ5MkmMgWWsB+wC4kK6qK0oOaMOR2AuQF
         F0oOc7lbVH4FB2H+C57xPKBvVQ63xU7gX0qzSfx+2583D1kJonK2IQ+VJPtcqy3sSYNu
         kO/A==
X-Gm-Message-State: AOAM531tPpBeIpisENyxPAhwY4+VnwbPKMLoHNK9zlWSpNbWm+iva7EW
        6bKlU7rr7t2hJ8yHa1N9egLS8t0DIOMz3GVtmPc45A==
X-Google-Smtp-Source: ABdhPJzzfhA9KvrCN94ITvdKe/AlJljESk7ftI2Q4cbLmACU7hg6vyw4MuMeMX20juJBAyGaRDpk8iTGMDcKRMFMUho=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr1219325ljk.16.1652140775207; Mon, 09
 May 2022 16:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-12-dmatlack@google.com>
 <YnRerE5+FpwkUdQE@google.com> <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
 <YnmcOdZILo2LqhAW@google.com>
In-Reply-To: <YnmcOdZILo2LqhAW@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 16:59:08 -0700
Message-ID: <CALzav=cPS82CyXD-90_K+pTaxBVDQicJ0er+LFdns5TqxA6ubA@mail.gmail.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in __kvm_mmu_get_shadow_page()
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

On Mon, May 9, 2022 at 3:57 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 09, 2022, David Matlack wrote:
> > On Thu, May 5, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Apr 22, 2022, David Matlack wrote:
> > > > Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> > > > it to vcpu_or_null to prevent future commits from accidentally taking
> > > > dependency on it without first considering the NULL case.
> > > >
> > > > The vcpu pointer is only used for syncing indirect shadow pages in
> > > > kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> > > > correctness since unsync pages can simply be zapped. But this should
> > > > never occur in practice, since the only use-case for passing a NULL vCPU
> > > > pointer is eager page splitting which will only request direct shadow
> > > > pages (which can never be unsync).
> > > >
> > > > Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> > > > vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> > > > called to get an indirect shadow page with a NULL vCPU pointer, since
> > > > zapping unsync SPs is a performance overhead that should be considered.
> > > >
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
> > > >  1 file changed, 32 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 04029c01aebd..21407bd4435a 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> > > >         &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
> > > >               if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> > > >
> > > > -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > > > -                      struct list_head *invalid_list)
> > > > +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> > > > +                        struct kvm_mmu_page *sp,
> > > > +                        struct list_head *invalid_list)
> > > >  {
> > > > -     int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> > > > +     int ret = -1;
> > > > +
> > > > +     if (vcpu_or_null)
> > >
> > > This should never happen.  I like the idea of warning early, but I really don't
> > > like that the WARN is far removed from the code that actually depends on @vcpu
> > > being non-NULL. Case in point, KVM should have bailed on the WARN and never
> > > reached this point.  And the inner __kvm_sync_page() is completely unnecessary.
> >
> > Yeah that's fair.
> >
> > >
> > > I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
> > > really help because understand why/when it's NULL.
> >
> > Eh, I don't think it needs to encode why or when. It just needs to
> > flag to the reader (and future code authors) that this vcpu pointer
> > (unlike all other vcpu pointers in KVM) is NULL in certain cases.
>
> My objection is that without the why/when, developers that aren't familiar with
> this code won't know the rules for using vcpu_or_null.  E.g. I don't want to end
> up with
>
>         if (vcpu_or_null)
>                 do x;
>         else
>                 do y;
>
> because inevitably it'll become unclear whether or not that code is actually _correct_.
> It might not #GP on a NULL pointer, but it doesn't mean it's correct.

Ah, right. And that's actually why I put the big comment and WARN in
__kvm_mmu_get_shadow_page(). Readers could easily jump to where
vcpu_or_null is passed in and see the rules around it. But if we move
the WARN to the kvm_sync_page() call, I agree it will be harder for
readers to know the rules and "vcpu_or_null" starts to become a risky
variable.

>
> > > I played around with casting, e.g. to/from an unsigned long or void *, to prevent
> > > usage, but that doesn't work very well because 'unsigned long' ends up being
> > > awkward/confusing, and 'void *' is easily lost on a function call.  And both
> > > lose type safety :-(
> >
> > Yet another shortcoming of C :(
>
> And lack of closures, which would work very well here.
>
> > (The other being our other discussion about the RET_PF* return codes
> > getting easily misinterpreted as KVM's magic return-to-user /
> > continue-running-guest return codes.)
> >
> > Makes me miss Rust!
> >
> > >
> > > All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
> > > kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
> > > no real loss in robustness, e.g. we'd really have to screw up code review and
> > > testing to introduce a null vCPU pointer dereference in this code.
> >
> > Agreed about moving the check here and dropping __kvm_sync_page(). But
> > I would prefer to retain the vcpu_or_null name (or at least something
> > other than "vcpu" to indicate there's something non-standard about
> > this pointer).
>
> The least awful idea I've come up with is wrapping the vCPU in a struct, e.g.
>
>         struct sync_page_info {
>                 void *vcpu;
>         }
>
> That provides the contextual information I want, and also provides the hint that
> something is odd about the vcpu, which you want.  It's like a very poor man's closure :-)
>
> The struct could even be passed by value to avoid the miniscule overhead, and to
> make readers look extra hard because it's that much more wierd.

Interesting idea. I'll give it a shot.

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d102522804a..068be77a4fff 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2003,8 +2003,13 @@ static void clear_sp_write_flooding_count(u64 *spte)
>         __clear_sp_write_flooding_count(sptep_to_sp(spte));
>  }
>
> +/* Wrapper to make it difficult to dereference a potentially NULL @vcpu. */
> +struct sync_page_info {
> +       void *vcpu;
> +};
> +
>  static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
> -                                                    struct kvm_vcpu *vcpu,
> +                                                    struct sync_page_info spi,
>                                                      gfn_t gfn,
>                                                      struct hlist_head *sp_list,
>                                                      union kvm_mmu_page_role role)
> @@ -2041,6 +2046,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                         goto out;
>
>                 if (sp->unsync) {
> +                       /*
> +                        * Getting indirect shadow pages without a valid @spi
> +                        * is not supported, i.e. this should never happen.
> +                        */
> +                       if (KVM_BUG_ON(!spi.vcpu, kvm))
> +                               break;
> +
>                         /*
>                          * The page is good, but is stale.  kvm_sync_page does
>                          * get the latest guest state, but (unlike mmu_unsync_children)
> @@ -2053,7 +2065,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                          * If the sync fails, the page is zapped.  If so, break
>                          * in order to rebuild it.
>                          */
> -                       ret = kvm_sync_page(vcpu, sp, &invalid_list);
> +                       ret = kvm_sync_page(spi.vcpu, sp, &invalid_list);
>                         if (ret < 0)
>                                 break;
>
> @@ -2120,7 +2132,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  }
>
>  static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
> -                                                     struct kvm_vcpu *vcpu,
> +                                                     struct sync_page_info spi,
>                                                       struct shadow_page_caches *caches,
>                                                       gfn_t gfn,
>                                                       union kvm_mmu_page_role role)
> @@ -2131,7 +2143,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
>
>         sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>
> -       sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
> +       sp = kvm_mmu_find_shadow_page(kvm, spi, gfn, sp_list, role);
>         if (!sp) {
>                 created = true;
>                 sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
> @@ -2151,7 +2163,11 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>                 .gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
>         };
>
> -       return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> +       struct sync_page_info spi = {
> +               .vcpu = vcpu,
> +       };
> +
> +       return __kvm_mmu_get_shadow_page(vcpu->kvm, spi, &caches, gfn, role);
>  }
>
>  static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
>
