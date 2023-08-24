Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6D78695F
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjHXIFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbjHXIEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:04:50 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D53B1982
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:04:04 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bcb89b4767so64992191fa.3
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864240; x=1693469040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Td1ijM0dx2iNRqr2N3eBQRfbFRu8kCUmxHSvTRGEgsw=;
        b=lhgftW+kUpJYgyukPTeMGEg46DSs1BtK5z/SjUu/e9VMVm5eN2eC2u/+blwQ54vuJI
         QzMbNLtSEMMFERz0K+7AT6ffq4Qi3z/IjFDT6xFIyWWXpCQzGPh8rnE/SorU6ZtJitOd
         jas03pjzHirqsUsRf4RDToow05j9J/8XlXbKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864240; x=1693469040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Td1ijM0dx2iNRqr2N3eBQRfbFRu8kCUmxHSvTRGEgsw=;
        b=TNyBVwQ0l6KLGg69NGRblrSkhKUkDI3CWFoMfXvqxsKEi4iwHhCrG0fnvPZUjtiu//
         lb3THqBuVRO+NTDBgySA4TMGWe7ln1/k+cHxj6KFSA95LqvSDze0PHdYV1d/n9UowNdU
         yNShUwD54S0hMgEFwYhA64AL5gHpyKbGFJGBvVj8Ztqrn7Mf836QAnPdZVyknDVfD2ep
         53p39Is14q1q88jlJdlOb7QyYAf6XvQyUwSUZAFZUDBBFKCxQohK+QLn09kjerQ/uB2c
         VuJZYC2+mSdKiPxQ3L62k765mt7Z3cGDHNbCT9SVNL9k8UUSS5xgUzbHnQgElf/pcCJ5
         7rCA==
X-Gm-Message-State: AOJu0Yz2A2dWewrOovR0TiyhSbwLPdsma1UOW0ZM6ptu7gyPZDHGrJeS
        BakDElq6eMRfhLDF16kq/X5JTRJLcqJ3HI11PIwjgQ==
X-Google-Smtp-Source: AGHT+IHrh+7nk/e5kV9L3xlBi65IU/eMAhbsiTEPcc+GmOb5gP2KdijZWmZMUBZJY5xZHioTccxZZzWEqXrR9lrjuwM=
X-Received: by 2002:a2e:9ed1:0:b0:2b9:4b2e:5420 with SMTP id
 h17-20020a2e9ed1000000b002b94b2e5420mr10117680ljk.52.1692864239959; Thu, 24
 Aug 2023 01:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705102547.hr2zxkdkecdxp5tf@linux.intel.com>
In-Reply-To: <20230705102547.hr2zxkdkecdxp5tf@linux.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Thu, 24 Aug 2023 17:03:48 +0900
Message-ID: <CAD=HUj7F6CUNt_9txEu0upB=PBwJzkL5dBhNs_BVHX1cicqBgw@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 7:25=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to map
> > memory into the guest that is backed by un-refcounted struct pages - fo=
r
> > example, higher order non-compound pages allocated by the amdgpu driver
> > via ttm_pool_alloc_page.
> >
> > The bulk of this change is tracking the is_refcounted_page flag so that
> > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. This=
 is
> > done by storing the flag in an unused bit in the sptes.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++------------
> >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
> >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> >  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
> >  6 files changed, 62 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e44ab512c3a1..b1607e314497 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -553,12 +553,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_s=
pte)
> >
> >       if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
> >               flush =3D true;
> > -             kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> > +             if (is_refcounted_page_pte(old_spte))
> > +                     kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old=
_spte)));
> >       }
> >
> >       if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
> >               flush =3D true;
> > -             kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> > +             if (is_refcounted_page_pte(old_spte))
> > +                     kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_sp=
te)));
> >       }
> >
> >       return flush;
> > @@ -596,14 +598,18 @@ static u64 mmu_spte_clear_track_bits(struct kvm *=
kvm, u64 *sptep)
> >        * before they are reclaimed.  Sanity check that, if the pfn is b=
acked
> >        * by a refcounted page, the refcount is elevated.
> >        */
> > -     page =3D kvm_pfn_to_refcounted_page(pfn);
> > -     WARN_ON(page && !page_count(page));
> > +     if (is_refcounted_page_pte(old_spte)) {
> > +             page =3D kvm_pfn_to_refcounted_page(pfn);
> > +             WARN_ON(!page || !page_count(page));
> > +     }
> >
> > -     if (is_accessed_spte(old_spte))
> > -             kvm_set_pfn_accessed(pfn);
> > +     if (is_refcounted_page_pte(old_spte)) {
> > +             if (is_accessed_spte(old_spte))
> > +                     kvm_set_page_accessed(pfn_to_page(pfn));
> >
> > -     if (is_dirty_spte(old_spte))
> > -             kvm_set_pfn_dirty(pfn);
> > +             if (is_dirty_spte(old_spte))
> > +                     kvm_set_page_dirty(pfn_to_page(pfn));
> > +     }
> >
> >       return old_spte;
> >  }
> > @@ -639,8 +645,8 @@ static bool mmu_spte_age(u64 *sptep)
> >                * Capture the dirty status of the page, so that it doesn=
't get
> >                * lost when the SPTE is marked for access tracking.
> >                */
> > -             if (is_writable_pte(spte))
> > -                     kvm_set_pfn_dirty(spte_to_pfn(spte));
> > +             if (is_writable_pte(spte) && is_refcounted_page_pte(spte)=
)
> > +                     kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte))=
);
> >
> >               spte =3D mark_spte_for_access_track(spte);
> >               mmu_spte_update_no_track(sptep, spte);
> > @@ -1278,8 +1284,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *spte=
p)
> >  {
> >       bool was_writable =3D test_and_clear_bit(PT_WRITABLE_SHIFT,
> >                                              (unsigned long *)sptep);
> > -     if (was_writable && !spte_ad_enabled(*sptep))
> > -             kvm_set_pfn_dirty(spte_to_pfn(*sptep));
> > +     if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_pag=
e_pte(*sptep))
> > +             kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
> >
> >       return was_writable;
> >  }
> > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, st=
ruct kvm_memory_slot *slot,
> >       bool host_writable =3D !fault || fault->map_writable;
> >       bool prefetch =3D !fault || fault->prefetch;
> >       bool write_fault =3D fault && fault->write;
> > +     bool is_refcounted =3D !fault || fault->is_refcounted_page;
> >
> >       pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
> >                *sptep, write_fault, gfn);
> > @@ -2969,7 +2976,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, st=
ruct kvm_memory_slot *slot,
> >       }
> >
> >       wrprot =3D make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep=
, prefetch,
> > -                        true, host_writable, &spte);
> > +                        true, host_writable, is_refcounted, &spte);
> >
> >       if (*sptep =3D=3D spte) {
> >               ret =3D RET_PF_SPURIOUS;
> > @@ -4299,8 +4306,9 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >       struct kvm_follow_pfn foll =3D {
> >               .slot =3D slot,
> >               .gfn =3D fault->gfn,
> > -             .flags =3D FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> > +             .flags =3D fault->write ? FOLL_WRITE : 0,
> >               .allow_write_mapping =3D true,
> > +             .guarded_by_mmu_notifier =3D true,
> >       };
> >
> >       /*
> > @@ -4317,6 +4325,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >                       fault->slot =3D NULL;
> >                       fault->pfn =3D KVM_PFN_NOSLOT;
> >                       fault->map_writable =3D false;
> > +                     fault->is_refcounted_page =3D false;
> >                       return RET_PF_CONTINUE;
> >               }
> >               /*
> > @@ -4366,6 +4375,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >  success:
> >       fault->hva =3D foll.hva;
> >       fault->map_writable =3D foll.writable;
> > +     fault->is_refcounted_page =3D foll.is_refcounted_page;
> >       return RET_PF_CONTINUE;
> >  }
> >
> > @@ -4451,7 +4461,8 @@ static int direct_page_fault(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fault
> >
> >  out_unlock:
> >       write_unlock(&vcpu->kvm->mmu_lock);
> > -     kvm_release_pfn_clean(fault->pfn);
> > +     if (fault->is_refcounted_page)
> > +             kvm_set_page_accessed(pfn_to_page(fault->pfn));
> >       return r;
> >  }
> >
> > @@ -4529,7 +4540,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu=
 *vcpu,
> >
> >  out_unlock:
> >       read_unlock(&vcpu->kvm->mmu_lock);
> > -     kvm_release_pfn_clean(fault->pfn);
>
> Yet kvm_release_pfn() can still be triggered for the kvm_vcpu_maped gfns.
> What if guest uses a non-referenced page(e.g., as a vmcs12)? Although I
> believe this is not gonna happen in real world...

kvm_vcpu_map still uses gfn_to_pfn, which eventually passes FOLL_GET
to __kvm_follow_pfn. So if a guest tries to use a non-refcounted page
like that, then kvm_vcpu_map will fail and the guest will probably
crash. It won't trigger any bugs in the host, though.

It is unfortunate that the guest will be able to use certain types of
memory for some purposes but not for others. However, while it is
theoretically fixable, it's an unreasonable amount of work for
something that, as you say, nobody really cares about in practice [1].

[1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/

-David
