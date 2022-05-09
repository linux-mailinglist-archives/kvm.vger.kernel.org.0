Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0475206A4
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiEIVbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiEIVbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:31:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E4F50471
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:27:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id m20so29242867ejj.10
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wI8fy4OzwxzyRjLG/BpgMXtWUTan7AaEmeWOc0KmU8=;
        b=XVUylxLfZr4wTBBAf53qguK656kMjGmwReylBuh+E19fjEmWr2h27UTdg1fI38RiGn
         8lwMbYHRGse1sNSQ6eC2rBYY+uitO09qRwa7vrzyBJU6WVbrEJb2FGlXd3yAg8cBRRK6
         Yih9tAUXZm3jXrv1iINzkAA+YWRBSxHUr0VPD0rPS3cMNIQ4fmlXLJtrEwEFOZlYoqMG
         +7tLyUxVNyXxrs6rOioILum49ZMJXe8wXbjni4a769F47yec1LP8gvAugGQhKSEM3WgF
         HVix7u8jQyc3SDDsuoS00kVZ8L482WHScY0XGcWlmorMWik7FT2DHxu1SFOa1mUeWDhm
         7LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wI8fy4OzwxzyRjLG/BpgMXtWUTan7AaEmeWOc0KmU8=;
        b=LqcEwA9SNc7cBXu9Rlv9Ax/pLm6ebBbHtte6z9DNam0JHKUXrFM0XXpyxAi8EQVgq/
         tOYmGJkjxFWbOh86KdazjkigLZY66Tsw8AuvLgGRGcv8JOtSlOBAckqt1Co6K+POfFx2
         o8ffiwf/oJMpi7j2e6BcpCUik1hdDxuOFetAt9N6d96aUx+4MYs0P4J25Hv0ElhJ8EGe
         uaIPGuCzu4ZDSlc8yCNTuJ/cFcIofNWiYuCnUg08+x+oIqFJ7Sfdo4K2c3rJh7f1SJjd
         sNeLo95QDD8xClT1Ub2JW9WhYd4O0z+cgulhY8FFCu0FE7j8J46AyPq6X3Qg2syns86o
         hKnQ==
X-Gm-Message-State: AOAM533O1mzDM0G0dRwePaofrSp1zWaoyaAlfKvcSzeLcDojWrLrf90N
        UbsCWjM2KWUDJ7Q7hrup7lb2bNDHjHd5OPbaZExVM1uTaMefbA==
X-Google-Smtp-Source: ABdhPJz9Vn1bR4LZrfiRLZV8AQMbZAt+0MKjbAL+S1RjonCsNbAqeb4YDyrtSSL4LLabggd1c9aq3rEOr8LOG2UZXuw=
X-Received: by 2002:a05:6512:1502:b0:474:28db:7b37 with SMTP id
 bq2-20020a056512150200b0047428db7b37mr4229039lfb.250.1652131616560; Mon, 09
 May 2022 14:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-12-dmatlack@google.com>
 <YnRerE5+FpwkUdQE@google.com>
In-Reply-To: <YnRerE5+FpwkUdQE@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:26:29 -0700
Message-ID: <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
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

On Thu, May 5, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> > it to vcpu_or_null to prevent future commits from accidentally taking
> > dependency on it without first considering the NULL case.
> >
> > The vcpu pointer is only used for syncing indirect shadow pages in
> > kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> > correctness since unsync pages can simply be zapped. But this should
> > never occur in practice, since the only use-case for passing a NULL vCPU
> > pointer is eager page splitting which will only request direct shadow
> > pages (which can never be unsync).
> >
> > Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> > vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> > called to get an indirect shadow page with a NULL vCPU pointer, since
> > zapping unsync SPs is a performance overhead that should be considered.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
> >  1 file changed, 32 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 04029c01aebd..21407bd4435a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> >         &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
> >               if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> >
> > -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > -                      struct list_head *invalid_list)
> > +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> > +                        struct kvm_mmu_page *sp,
> > +                        struct list_head *invalid_list)
> >  {
> > -     int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> > +     int ret = -1;
> > +
> > +     if (vcpu_or_null)
>
> This should never happen.  I like the idea of warning early, but I really don't
> like that the WARN is far removed from the code that actually depends on @vcpu
> being non-NULL. Case in point, KVM should have bailed on the WARN and never
> reached this point.  And the inner __kvm_sync_page() is completely unnecessary.

Yeah that's fair.

>
> I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
> really help because understand why/when it's NULL.

Eh, I don't think it needs to encode why or when. It just needs to
flag to the reader (and future code authors) that this vcpu pointer
(unlike all other vcpu pointers in KVM) is NULL in certain cases.

>
> I played around with casting, e.g. to/from an unsigned long or void *, to prevent
> usage, but that doesn't work very well because 'unsigned long' ends up being
> awkward/confusing, and 'void *' is easily lost on a function call.  And both
> lose type safety :-(

Yet another shortcoming of C :(

(The other being our other discussion about the RET_PF* return codes
getting easily misinterpreted as KVM's magic return-to-user /
continue-running-guest return codes.)

Makes me miss Rust!

>
> All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
> kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
> no real loss in robustness, e.g. we'd really have to screw up code review and
> testing to introduce a null vCPU pointer dereference in this code.

Agreed about moving the check here and dropping __kvm_sync_page(). But
I would prefer to retain the vcpu_or_null name (or at least something
other than "vcpu" to indicate there's something non-standard about
this pointer).

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d102522804a..5aed9265f592 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2041,6 +2041,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                         goto out;
>
>                 if (sp->unsync) {
> +                       /*
> +                        * Getting indirect shadow pages without a vCPU pointer
> +                        * is not supported, i.e. this should never happen.
> +                        */
> +                       if (KVM_BUG_ON(!vcpu, kvm))
> +                               break;
> +
>                         /*
>                          * The page is good, but is stale.  kvm_sync_page does
>                          * get the latest guest state, but (unlike mmu_unsync_children)
>
