Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0877932FB
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 02:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242390AbjIFApK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 20:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238361AbjIFApJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 20:45:09 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9641A2
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 17:45:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68a4175e8c3so3577893b3a.0
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 17:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693961104; x=1694565904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HUA9usxNgwB6YytBqtV+1OLueYqIkCgXy7MnO3qXqNQ=;
        b=PU1kE3jnmyCVR83uyhyVNCFtJagHNY6ozxolX0h2hfykkyArcTkaKEfC51+yTMgyuN
         OY9RWnA9FO/vsQTLjPjjSdo0CGh+3pAmVySJLLlVZAkhdPd1TNgE+NfovFWFR8YV+6yO
         bygurNg/FUDNwQH4ZJBa/dTuNGFdxYnE8I1jvLxKVvrZARPGqyCaZ0hDSie9VIVh/KJG
         94nYpXKPWQ/t9qCJ1TP7sEv0itAUtt87D9ZDw37keEaUp/IKoJMuAaEmw0J3cZTh4YCe
         pyRow6+EFXfJ5blzzTLAhyUp5MFjD9EvjmvmAeI3izGFbAUyH2aAKYz2hsoI5exua/+K
         aZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693961104; x=1694565904;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HUA9usxNgwB6YytBqtV+1OLueYqIkCgXy7MnO3qXqNQ=;
        b=AnZELjRWCQb/K9nDdyqvs/T7u3PHmBo99PrWp/FenJq1NpPFcUVxnYZtgjhUqELnrn
         BPw/O2t90Kl4kWb6YbJ66OgKxVC3ZjIyniaRLAe9GiFW29CaP5BWYto8oe8YZUF2JRPB
         0/4wxGKPUtCAoxr361X/G9vSFAuB+jSsS2ksiK0mxGq45jwKmNa4/ls3QGy2ZBLmkeW7
         g7vwVuVSyJz5EeEgNSQibr++50HQaOwHUP1T0hKL+/rDZrDP5mxLZ5fLvr9C1UJlmKwx
         DE84BSojyCxx2yQYC9orewhI+aaq36fqAJerk9W0dOtWpH8h1dJk+kPt3JI2az1kls1z
         eydQ==
X-Gm-Message-State: AOJu0Yy1DwrUJZRjq85Ix66m074xtv7t6XNAXGmkW7UtNUtVbwLJ/cmE
        +nYb4noma/wC5uguIsb9H7/l0tUEf78=
X-Google-Smtp-Source: AGHT+IEjMoa55UXF5kyTyYfYfW3WHpsvfUj4SXpf2Xux5fwvpnUOg3He95RZW7oJ1ZZo3y681Y0APv8WxlY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3982:b0:68c:33a9:e564 with SMTP id
 fi2-20020a056a00398200b0068c33a9e564mr5874174pfb.5.1693961103860; Tue, 05 Sep
 2023 17:45:03 -0700 (PDT)
Date:   Tue, 5 Sep 2023 17:45:02 -0700
In-Reply-To: <CAD=HUj6SoKHhA02oNpCt--ofE_n1wjdY1ddBURXDiS5Rwu=Q-g@mail.gmail.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-4-stevensd@google.com>
 <20230705161914.00004070.zhi.wang.linux@gmail.com> <CAD=HUj5cbzjrc0KD7xcibtRMRCzoJRJAzt7jTHSXUSpzyAYbdg@mail.gmail.com>
 <20230711203348.00000fb8.zhi.wang.linux@gmail.com> <ZK3Q34WNLjGVQQw+@google.com>
 <CAD=HUj6SoKHhA02oNpCt--ofE_n1wjdY1ddBURXDiS5Rwu=Q-g@mail.gmail.com>
Message-ID: <ZPfLjnG8b9LJV4p7@google.com>
Subject: Re: [PATCH v7 3/8] KVM: Make __kvm_follow_pfn not imply FOLL_GET
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 05, 2023, David Stevens wrote:
> On Wed, Jul 12, 2023 at 7:00=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Jul 11, 2023, Zhi Wang wrote:
> > > On Thu, 6 Jul 2023 15:49:39 +0900
> > > David Stevens <stevensd@chromium.org> wrote:
> > >
> > > > On Wed, Jul 5, 2023 at 10:19___PM Zhi Wang <zhi.wang.linux@gmail.co=
m> wrote:
> > > > >
> > > > > On Tue,  4 Jul 2023 16:50:48 +0900
> > > > > David Stevens <stevensd@chromium.org> wrote:
> > > > > If yes, do we have to use FOLL_GET to resolve GFN associated with=
 a tail page?
> > > > > It seems gup can tolerate gup_flags without FOLL_GET, but it is m=
ore like a
> > > > > temporary solution. I don't think it is a good idea to play trick=
s with
> > > > > a temporary solution, more like we are abusing the toleration.
> > > >
> > > > I'm not sure I understand what you're getting at. This series never
> > > > calls gup without FOLL_GET.
> > > >
> > > > This series aims to provide kvm_follow_pfn as a unified API on top =
of
> > > > gup+follow_pte. Since one of the major clients of this API uses an =
mmu
> > > > notifier, it makes sense to support returning a pfn without taking =
a
> > > > reference. And we indeed need to do that for certain types of memor=
y.
> > > >
> > >
> > > I am not having prob with taking a pfn without taking a ref. I am
> > > questioning if using !FOLL_GET in struct kvm_follow_pfn to indicate t=
aking
> > > a pfn without a ref is a good idea or not, while there is another fla=
g
> > > actually showing it.
> > >
> > > I can understand that using FOLL_XXX in kvm_follow_pfn saves some
> > > translation between struct kvm_follow_pfn.{write, async, xxxx} and GU=
P
> > > flags. However FOLL_XXX is for GUP. Using FOLL_XXX for reflecting the
> > > requirements of GUP in the code path that going to call GUP is reason=
able.
> > >
> > > But using FOLL_XXX with purposes that are not related to GUP call rea=
lly
> > > feels off.
> >
> > I agree, assuming you're talking specifically about the logic in hva_to=
_pfn_remapped()
> > that handles non-refcounted pages, i.e. this
> >
> >         if (get_page_unless_zero(page)) {
> >                 foll->is_refcounted_page =3D true;
> >                 if (!(foll->flags & FOLL_GET))
> >                         put_page(page);
> >         } else if (foll->flags & FOLL_GET) {
> >                 r =3D -EFAULT;
> >         }
> >
> > should be
> >
> >         if (get_page_unless_zero(page)) {
> >                 foll->is_refcounted_page =3D true;
> >                 if (!(foll->flags & FOLL_GET))
> >                         put_page(page);
> >         else if (!foll->guarded_by_mmu_notifier)
> >                 r =3D -EFAULT;
> >
> > because it's not the desire to grab a reference that makes getting non-=
refcounted
> > pfns "safe", it's whether or not the caller is plugged into the MMU not=
ifiers.
> >
> > Though that highlights that checking guarded_by_mmu_notifier should be =
done for
> > *all* non-refcounted pfns, not just non-refcounted struct page memory.
>=20
> I think things are getting confused here because there are multiple
> things which "safe" refers to. There are three different definitions
> that I think are relevant here:
>=20
> 1) "safe" in the sense that KVM doesn't corrupt page reference counts
> 2) "safe" in the sense that KVM doesn't access pfns after they have been =
freed
> 3) "safe" in the sense that KVM doesn't use stale hva -> pfn translations
>
> For property 1, FOLL_GET is important. If the caller passes FOLL_GET,
> then they expect to be able to pass the returned pfn to
> kvm_release_pfn. This means that when FOLL_GET is set, if
> kvm_pfn_to_refcounted_page returns a page, then hva_to_pfn_remapped
> must take a reference count to avoid eventually corrupting the page
> ref count. I guess replacing the FOLL_GET check with
> !guarded_by_mmu_notifier is logically equivalent because
> __kvm_follow_pfn requires that at least one of guarded_by_mmu_notifier
> and FOLL_GET is set. But since we're concerned about a property of the
> refcount, I think that checking FOLL_GET is clearer.
>=20
> For property 2, FOLL_GET is also important. If guarded_by_mmu_notifier
> is set, then we're all good here. If guarded_by_mmu_notifier is not
> set, then the check in __kvm_follow_pfn guarantees that FOLL_GET is
> set. For struct page memory, we're safe because KVM will hold a
> reference as long as it's still using the page. For non struct page
> memory, we're not safe - this is where the breaking change of
> allow_unsafe_mappings would go. Note that for non-refcounted struct
> page, we can't use the allow_unsafe_mappings escape hatch. Since
> FOLL_GET was requested, if we returned such a page, then the caller
> would eventually corrupt the page refcount via kvm_release_pfn.

Yes we can.  The caller simply needs to be made aware of is_refcounted_page=
.   I
didn't include that in the snippet below because I didn't want to write the=
 entire
patch.  The whole point of adding is_refcounted_page is so that callers can
identify exactly what type of page was at the end of the trail that was fol=
lowed.

> Property 3 would be nice, but we've already concluded that guarding
> all translations with mmu notifiers is infeasible. So maintaining
> property 2 is the best we can hope for.

No, #3 is just a variant of #2.  Unless you're talking about not making gua=
rantees
about guest accesses being ordered with respect to VMA/memslot updates, but=
 I
don't think that's the case.

> > As for the other usage of FOLL_GET in this series (using it to conditio=
nally do
> > put_page()), IMO that's very much related to the GUP call.  Invoking pu=
t_page()
> > is a hack to workaround the fact that GUP doesn't provide a way to get =
the pfn
> > without grabbing a reference to the page.  In an ideal world, KVM would=
 NOT pass
> > FOLL_GET to the various GUP helpers, i.e. FOLL_GET would be passed as-i=
s and KVM
> > wouldn't "need" to kinda sorta overload FOLL_GET to manually drop the r=
eference.
> >
> > I do think it's worth providing a helper to consolidate and document th=
at hacky
> > code, e.g. add a kvm_follow_refcounted_pfn() helper.
> >
> > All in all, I think the below (completely untested) is what we want?
> >
> > David (and others), I am planning on doing a full review of this series=
 "soon",
> > but it will likely be a few weeks until that happens.  I jumped in on t=
his
> > specific thread because this caught my eye and I really don't want to t=
hrow out
> > *all* of the FOLL_GET usage.
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 5b5afd70f239..90d424990e0a 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2481,6 +2481,25 @@ static inline int check_user_page_hwpoison(unsig=
ned long addr)
> >         return rc =3D=3D -EHWPOISON;
> >  }
> >
> > +static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll=
,
> > +                                          struct page *page)
> > +{
> > +       kvm_pfn_t pfn =3D page_to_pfn(page);
> > +
> > +       foll->is_refcounted_page =3D true;
> > +
> > +       /*
> > +        * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the=
 caller
> > +        * doesn't want to grab a reference, but gup() doesn't support =
getting
> > +        * just the pfn, i.e. FOLL_GET is effectively mandatory.  If th=
at ever
> > +        * changes, drop this and simply don't pass FOLL_GET to gup().
> > +        */
> > +       if (!(foll->flags & FOLL_GET))
> > +               put_page(page);
> > +
> > +       return pfn;
> > +}
> > +
> >  /*
> >   * The fast path to get the writable pfn which will be stored in @pfn,
> >   * true indicates success, otherwise false is returned.  It's also the
> > @@ -2500,11 +2519,9 @@ static bool hva_to_pfn_fast(struct kvm_follow_pf=
n *foll, kvm_pfn_t *pfn)
> >                 return false;
> >
> >         if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
> > -               *pfn =3D page_to_pfn(page[0]);
> >                 foll->writable =3D foll->allow_write_mapping;
> > -               foll->is_refcounted_page =3D true;
> > -               if (!(foll->flags & FOLL_GET))
> > -                       put_page(page[0]);
> > +
> > +               *pfn =3D kvm_follow_refcounted_pfn(foll, page[0]);
> >                 return true;
> >         }
> >
> > @@ -2528,7 +2545,6 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn =
*foll, kvm_pfn_t *pfn)
> >                 return npages;
> >
> >         foll->writable =3D (foll->flags & FOLL_WRITE) && foll->allow_wr=
ite_mapping;
> > -       foll->is_refcounted_page =3D true;
> >
> >         /* map read fault as writable if possible */
> >         if (unlikely(!foll->writable) && foll->allow_write_mapping) {
> > @@ -2540,9 +2556,8 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn =
*foll, kvm_pfn_t *pfn)
> >                         page =3D wpage;
> >                 }
> >         }
> > -       *pfn =3D page_to_pfn(page);
> > -       if (!(foll->flags & FOLL_GET))
> > -               put_page(page);
> > +
> > +       *pfn =3D kvm_follow_refcounted_pfn(foll, page);
> >         return npages;
> >  }
> >
> > @@ -2610,17 +2625,16 @@ static int hva_to_pfn_remapped(struct vm_area_s=
truct *vma, struct kvm_follow_pfn
> >         if (!page)
> >                 goto out;
> >
> > -       if (get_page_unless_zero(page)) {
> > -               foll->is_refcounted_page =3D true;
> > -               if (!(foll->flags & FOLL_GET))
> > -                       put_page(page);
> > -       } else if (foll->flags & FOLL_GET) {
> > -               r =3D -EFAULT;
> > -       }
> > -
> > +       if (get_page_unless_zero(page))
> > +               WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) !=3D=
 pfn);
> >  out:
> >         pte_unmap_unlock(ptep, ptl);
> > -       *p_pfn =3D pfn;
> > +
> > +       if (!foll->is_refcounted_page && !foll->guarded_by_mmu_notifier=
 &&
> > +           !allow_unsafe_mappings)
> > +               r =3D -EFAULT;
> > +       else
> > +               *p_pfn =3D pfn;
> >
> >         return r;
> >  }
> >
>=20
> As I pointed out above, this suggestion is broken because a FOLL_GET
> && !guarded_by_mmu_notifier request (e.g. kvm_vcpu_map) for a
> non-refcounted page will result in the refcount eventually being
> corrupted.

I don't think so, unless I'm misunderstanding the concern.  It just wasn't =
a
complete patch, and wasn't intended to be.

> What do you think of this implementation? If it makes sense, I can
> send out an updated patch series.
>
> /*
>  * If FOLL_GET is set, then the caller wants us to take a reference to
>  * keep the pfn alive. If FOLL_GET isn't set, then __kvm_follow_pfn
>  * guarantees that guarded_by_mmu_notifier is set, so there aren't any
>  * use-after-free concerns.
>  */
> page =3D kvm_pfn_to_refcounted_page(pfn);
> if (page) {
>         if (get_page_unless_zero(page)) {
>                 WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) !=3D p=
fn);
>         } else if (foll->flags & FOLL_GET) {
>                 /*
>                  * Certain IO or PFNMAP mappings can be backed with
>                  * valid struct pages but be allocated without
>                  * refcounting e.g., tail pages of non-compound higher
>                  * order allocations. The caller asked for a ref, but
>                  * we can't take one, since releasing such a ref would
>                  * free the page.
>                  */
>                 r =3D -EFAULT;
>         }
> } else if (foll->flags & FOLL_GET) {
>         /*
>          * When there's no struct page to refcount and no MMU notifier,
>          * then KVM can't be guarantee to avoid use-after-free. However,
>          * there are valid reasons to set up such mappings. If userspace
>          * is trusted and willing to forego kernel safety guarantees,
>          * allow this check to be bypassed.
>          */
>         if (foll->guarded_by_mmu_notifier && !allow_unsafe_mappings)

I assume you mean:

	if (!foll->guarded_by_mmu_notifier && !allow_unsafe_mappings)

>                 r =3D -EFAULT;
> }

Please no.  I don't want to overload FOLL_GET or have dependencies between
FOLL_GET and guarded_by_mmu_notifier.  The guest page fault path should be =
able
to omit FOLL_GET, and it obviously should set guarded_by_mmu_notifier.  And
kvm_vcpu_map() should be able to set FOLL_GET, omit guarded_by_mmu_notifier=
, _and_
play nice with "unsafe", non-refcounted memory when allow_unsafe_mappings i=
s true.

The above fits your use case because nothing in KVM needs to do kvm_vcpu_ma=
p()
on the GPU's buffer, but as a general solution the semantics are very odd. =
 E.g.
in long form, they are:

  Get get a reference if a there's a refcounted page, fail with -EFAULT if =
there's
  a struct page but it's not refcounted, and fail with -EFAULT if there's n=
ot struct
  page unless the caller is protected by mmu_notifiers or unsafe mappings a=
re allowed.

That's rather bonkers.  What I instead want is FOLL_GET to be:

  Get a reference if there's a refcounted page.

And then allow_unsafe_mappings is simply:

  Allow mapping non-refcounted memory into the guest even if the mapping is=
n't
  guarded by mmu_notifier events.
