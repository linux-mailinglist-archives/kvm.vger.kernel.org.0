Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6D74A87F
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 03:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjGGBfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 21:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjGGBfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 21:35:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855961FD9
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 18:35:15 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4fb761efa7aso2023696e87.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 18:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688693713; x=1691285713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHzMQLp6cC/kLBC/6EOoqJ2QCFHXCMXxzGNBM9QacjY=;
        b=hJRjPgcTCc7q6itd2xbffCg48LKO/Qm/YiojcslhQVKO2e+xGuKwenYHZjO6sm/Nd4
         j+Q+arjaIozLu+vV0ToUrNaQE3iqbHFkEbzw62omnPFzlS5rZwkuqhAb6kqwNak5ba03
         v7eBCW1S9UdFdykuZWhw1cVpSMPjbwNVEnVDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688693713; x=1691285713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHzMQLp6cC/kLBC/6EOoqJ2QCFHXCMXxzGNBM9QacjY=;
        b=WPFmnrSEhDTfxbmqBIbnL27u/UGIxOKOFigHeJdgpU9egv0kMgLLpVhZ9FLLpcFlGg
         aiz2E6qekwGnFHf8P8v8qteuGfZvmfcCFSev1NCiVLbhuuVERrTXIlz9nnjcvFV86pII
         lYdcgPbDHDtZeJbreJWeVs5ApaKCSPz+DlFxLj3+b8x9bdGEKy+p+E4W1jRL8HPhkVOk
         tTBjRuR4yfPDZ2ZGJivHjTLusLiRiqfjnat5WzCdqZivGfD7cx9+ZGFQwCJ0F1/GuCsi
         7WU42juXRVQGwRAnqoLtNa16m5BOcABBr50m5kDrpTdkpwE/7X65QO5uYKn5nC8n0u2C
         rglQ==
X-Gm-Message-State: ABy/qLZnCC3Y7D+nLsc5jGL1lO7ph+LXA2m3zRLMdGvxn2xPUcPJLX7N
        7HO1Eq9a/UVdvvqgDAdpeAciowkQAD0NpUrGdzOpig==
X-Google-Smtp-Source: APBJJlE5Z1LKZjv+Su0EOT2WrS/jSlDd30OmLqLSEJNttXtFFbijFLtL5Sn7PdB1lMgsRBKF7D8wQuyk1Ic2XROTdJ4=
X-Received: by 2002:a05:6512:3e0c:b0:4fb:bc46:7c09 with SMTP id
 i12-20020a0565123e0c00b004fbbc467c09mr3594815lfv.6.1688693713232; Thu, 06 Jul
 2023 18:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706155805.GD3894444@ls.amr.corp.intel.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Fri, 7 Jul 2023 10:35:02 +0900
Message-ID: <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 7, 2023 at 12:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Thu, Jul 06, 2023 at 01:52:08PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > On Wed, Jul 5, 2023 at 7:17=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel=
.com> wrote:
> > >
> > > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > > From: David Stevens <stevensd@chromium.org>
> > > >
> > > > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to =
map
> > > > memory into the guest that is backed by un-refcounted struct pages =
- for
> > > > example, higher order non-compound pages allocated by the amdgpu dr=
iver
> > > > via ttm_pool_alloc_page.
> > >
> > > I guess you mean the tail pages of the higher order non-compound page=
s?
> > > And as to the head page, it is said to be set to one coincidentally[*=
],
> > > and shall not be considered as refcounted.  IIUC, refcount of this he=
ad
> > > page will be increased and decreased soon in hva_to_pfn_remapped(), s=
o
> > > this may not be a problem(?). But treating this head page differently=
,
> > > as a refcounted one(e.g., to set the A/D flags), is weired.
> > >
> > > Or maybe I missed some context, e.g., can the head page be allocted t=
o
> > > guest at all?
> >
> > Yes, this is to allow mapping the tail pages of higher order
> > non-compound pages - I should have been more precise in my wording.
> > The head pages can already be mapped into the guest.
> >
> > Treating the head and tail pages would require changing how KVM
> > behaves in a situation it supports today (rather than just adding
> > support for an unsupported situation). Currently, without this series,
> > KVM can map VM_PFNMAP|VM_IO memory backed by refcounted pages into the
> > guest. When that happens, KVM sets the A/D flags. I'm not sure whether
> > that's actually valid behavior, nor do I know whether anyone actually
> > cares about it. But it's what KVM does today, and I would shy away
> > from modifying that behavior without good reason.
> >
> > > >
> > > > The bulk of this change is tracking the is_refcounted_page flag so =
that
> > > > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. =
This is
> > > > done by storing the flag in an unused bit in the sptes.
> > >
> > > Also, maybe we should mention this only works on x86-64.
> > >
> > > >
> > > > Signed-off-by: David Stevens <stevensd@chromium.org>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++--------=
----
> > > >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> > > >  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
> > > >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> > > >  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
> > > >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
> > > >  6 files changed, 62 insertions(+), 30 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e44ab512c3a1..b1607e314497 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > >
> > > ...
> > >
> > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu=
, struct kvm_memory_slot *slot,
> > > >       bool host_writable =3D !fault || fault->map_writable;
> > > >       bool prefetch =3D !fault || fault->prefetch;
> > > >       bool write_fault =3D fault && fault->write;
> > > > +     bool is_refcounted =3D !fault || fault->is_refcounted_page;
> > >
> > > Just wonder, what if a non-refcounted page is prefetched?  Or is it p=
ossible in
> > > practice?
> >
> > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > FOLL_GET. That's fixable, but it's not something this series currently
> > does.
>
> So if we prefetch a page, REFCOUNTED bit is cleared unconditionally with =
this
> hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for pre=
fetched
> spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should repre=
sent
> whether the corresponding page is ref-countable or not, right?
>
> Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(prefet=
ch_pte)
> is shadow paging, we need to test it with legacy KVM MMU or shadow paging=
 to hit
> the issue, though.
>

direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
fault parameter, so is_refcounted will evaluate to true. So the spte's
refcounted bit will get set in that case.

-David
