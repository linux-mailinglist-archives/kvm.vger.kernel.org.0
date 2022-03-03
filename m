Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652304CC698
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiCCTyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiCCTyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:54:01 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F66181E63
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:53:15 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id j15so10334099lfe.11
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 11:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XoEAYDx446fXkmQuWKwwNKiNKBljBToUr9mPvWD2olQ=;
        b=E3cRT6Y5KHhW/Cza9qMruREtgdGi+aygUVIr/vS3H8uR6KlKAmfd/GicCkvDrm111M
         /82YJoTtE7ZwblLXpd+9bymcMnfbulRgTJn1rbHa5pXPIGgxh+Y4PVJsRCasrsNU0y0i
         jVNQQKl7Ed8GG99DgFj7FjxM7CNR7R3bPmDv8kXaENb2gyPnop3U+jpT5xAz2HLvbs4k
         yxPPq4jayMdACosJNvoRbHe5VCWX7qyPovArzaTjU9Jw/ON10GzcvBohOvE8PhRknZuI
         pOFO7EqZ1lYxrO/woNF1hbhN8U/Gn51kSCYfTLjCQwXwr9Z5DkN9/Y1TAH/fHXu/mGpp
         6hbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XoEAYDx446fXkmQuWKwwNKiNKBljBToUr9mPvWD2olQ=;
        b=4IhU2i6p27tI2Sr7QQjGnGJodLyR38aCG5AsrATo+XBjZxljouGGJzCeFeEvLtIVO4
         pAaoq+eomEcL49+aaVljLJ4dyKYVPJpxsI4GW0pd8vo4dCcilo6N9ILkiimmRzGWnJmq
         FxWHu534iwrEdHMEKHuFGN1UCTXdcL2hbl1RXA+ky1FArkr8i0UY4SOS/Y1AcHMSdvIZ
         0Orq6qFq8P0wPvqmaoWOnKINnb+d/J5cyVXXhIC5g51095hk5Hk22OZWJMGc186s7Hmn
         0/RcFzzJlEy8CPuEXlXA7mx0hiPmKawNJnGs6aLspIB3ZW1ef9db7KMOaeueM+aCpyLU
         4L1Q==
X-Gm-Message-State: AOAM5327+xS1TDLajiwNCinkqRBmwC7pAHs9jIH/zj74jsj8V7z6ZFCj
        T2444f0NdqhEAk1WIbPEfq2TE3DT2+P4DvCyjGBJ8g==
X-Google-Smtp-Source: ABdhPJwbKab4uPBxWjkPewLzFfGD27do6suW8zprL0EkIZ2+N+uIOuPVKnP13+hvvRIEZuh/Ghvb1SZiXBuoZfOeOSg=
X-Received: by 2002:a19:7503:0:b0:443:3d52:fde6 with SMTP id
 y3-20020a197503000000b004433d52fde6mr22360133lfe.250.1646337193350; Thu, 03
 Mar 2022 11:53:13 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-18-dmatlack@google.com>
 <CANgfPd90UA2_RRRWzwE6D_FtKiExSkbqktKiPpcYV0MmJxagWQ@mail.gmail.com>
In-Reply-To: <CANgfPd90UA2_RRRWzwE6D_FtKiExSkbqktKiPpcYV0MmJxagWQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 3 Mar 2022 11:52:46 -0800
Message-ID: <CALzav=fuLgXJ3Krr8JYXA0Bd1KdPeh+thJnLyvMMZtqsNeSu3w@mail.gmail.com>
Subject: Re: [PATCH 17/23] KVM: x86/mmu: Pass bool flush parameter to drop_large_spte()
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 12:47 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
> >
> > drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
> > Its helper function, __drop_large_spte(), does the drop without the
> > flush. This difference is not obvious from the name.
> >
> > To make the code more readable, pass an explicit flush parameter. Also
> > replace the vCPU pointer with a KVM pointer so we can get rid of the
> > double-underscore helper function.
> >
> > This is also in preparation for a future commit that will conditionally
> > flush after dropping a large SPTE.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c         | 25 +++++++++++--------------
> >  arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
> >  2 files changed, 13 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 99ad7cc8683f..2d47a54e62a5 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1162,23 +1162,20 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
> >  }
> >
> >
> > -static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
> > +static void drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
>
> Since there are no callers of __drop_large_spte, I'd be inclined to
> hold off on adding the flush parameter in this commit and just add it
> when it's needed,

The same argument about waiting until there's a user could be said
about "KVM: x86/mmu: Pass access information to
make_huge_page_split_spte()". I agree with this advice when the future
user is entirely theoretical or some future series. But when the
future user is literally the next commit in the series, I think it's
ok to do things this way since it distributes the net diff more evenly
among patches, which eases reviewing.

But, you've got me thinking and I think I want to change this commit
slightly: I'll keep __drop_larg_spte() but push all the implementation
into it and add a bool flush parameter there. That way we don't have
to change all the call sites of drop_large_spte() in this commit. The
implementation of drop_large_spte() will just be
__drop_large_spte(..., true). And the next commit can call
__drop_large_spte(..., false) with a comment.

> or better yet after you add the new user with the
> conditional flush so that there's a commit explaining why it's safe to
> not always flush in that case.
>
> >  {
> > -       if (is_large_pte(*sptep)) {
> > -               WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
> > -               drop_spte(kvm, sptep);
> > -               return true;
> > -       }
> > +       struct kvm_mmu_page *sp;
> >
> > -       return false;
> > -}
> > +       if (!is_large_pte(*sptep))
> > +               return;
> >
> > -static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
> > -{
> > -       if (__drop_large_spte(vcpu->kvm, sptep)) {
> > -               struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> > +       sp = sptep_to_sp(sptep);
> > +       WARN_ON(sp->role.level == PG_LEVEL_4K);
> > +
> > +       drop_spte(kvm, sptep);
> >
> > -               kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> > +       if (flush) {
> > +               kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> >                         KVM_PAGES_PER_HPAGE(sp->role.level));
> >         }
> >  }
> > @@ -3051,7 +3048,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                 if (it.level == fault->goal_level)
> >                         break;
> >
> > -               drop_large_spte(vcpu, it.sptep);
> > +               drop_large_spte(vcpu->kvm, it.sptep, true);
> >                 if (is_shadow_present_pte(*it.sptep))
> >                         continue;
> >
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 703dfb062bf0..ba61de29f2e5 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -677,7 +677,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >                 gfn_t table_gfn;
> >
> >                 clear_sp_write_flooding_count(it.sptep);
> > -               drop_large_spte(vcpu, it.sptep);
> > +               drop_large_spte(vcpu->kvm, it.sptep, true);
> >
> >                 sp = NULL;
> >                 if (!is_shadow_present_pte(*it.sptep)) {
> > @@ -739,7 +739,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >
> >                 validate_direct_spte(vcpu, it.sptep, direct_access);
> >
> > -               drop_large_spte(vcpu, it.sptep);
> > +               drop_large_spte(vcpu->kvm, it.sptep, true);
> >
> >                 if (!is_shadow_present_pte(*it.sptep)) {
> >                         sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
> > --
> > 2.35.0.rc2.247.g8bbb082509-goog
> >
