Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977606A11C0
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 22:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBWVMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 16:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBWVMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 16:12:48 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F4360131
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 13:12:26 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id p5-20020a056a0026c500b005cbeecd5c0dso5016874pfw.3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 13:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jZqpqHNnDrkVf5YnH4C4p2Du+MWFI+rsSboHjRikfo0=;
        b=cstTUl3cDjETi7Uy5k8lUK4jDXVH5n84ULJ8Qdzf8KUig6GFtpHB7w0eoI8Plhg2NM
         6FWa3l7sXNc+M6YDtvaFjXzlpRtWBMe5SojZXE91tPmgJMlFF/CW1ZZv81jiCr0fXexK
         lScdHryZlveE1J+z0J2TIi81MbXXQWHYdNInuM44+8VugSDN/fGG/tYGrW4Jcvq/Dl9n
         Ek7HnOVQiTB+e4FM6RTzQyIV1EEstxc2pOWecp5NaX9GOemJJxxrazzswOceIxFVcfln
         /s7eha+SalTSQycIbbCTH+sAFv5dgkYSrn8AD1goiYFHWVwKHCsyUeb7nev3pGjb/y5j
         CUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jZqpqHNnDrkVf5YnH4C4p2Du+MWFI+rsSboHjRikfo0=;
        b=5f4p+RpTE7c4TJmqnDXOU+6QsoyM+fs7kCNpoJTLqZROyEtTLtyhxUg3ckhOvs2aKR
         IxD3kev7x/7PgUcHd4KeFPrCpIQyp8Fa+V3TAmBylzrEWQyDmNpSqcYSoquZTM0PPTNl
         MMYgjGXeDP0YU/DS3BJshcCeJksQ2Xslg/c70FwAsbOaFCzfCRsPlU5Nv2+EyKQdeso5
         9Qn/W8GbMc9lH5woaH7bQbWd6VUewssWYFcZLiwHQXWyKOY/OH+fSmVXXRaWlOTje9x1
         W8OuMNBuKosxBBBbYNUQjxAnn/07XfwqZZVW0R+xxaFcMLLPhyRf5qJY2vPDVSQ04n52
         Fkfg==
X-Gm-Message-State: AO0yUKV4u8LZlHK4HnEIXrM2kXGkmQJnM0/WK72ZsxFGJegD+PMQM7GB
        GupbzxV81xttqlJ4cYsmfK5NfxP7zCc=
X-Google-Smtp-Source: AK7set8UOj7NygywK+cGr/Rmvj7I4XEunDNhPQJfW5dsIVprbIkkXYFIqYFcViXFQ9A3GP588Pa1F52horE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa4b:b0:237:2106:a861 with SMTP id
 dt11-20020a17090afa4b00b002372106a861mr826705pjb.0.1677186745595; Thu, 23 Feb
 2023 13:12:25 -0800 (PST)
Date:   Thu, 23 Feb 2023 13:12:24 -0800
In-Reply-To: <CAOUHufZ0Ep4_Edo4OoeUVpVK4uFJF6_yVL=xSrQM8an_Vw4VKw@mail.gmail.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-2-yuzhao@google.com>
 <Y/ee1s3XPGa62SFV@google.com> <CAOUHufZ0Ep4_Edo4OoeUVpVK4uFJF6_yVL=xSrQM8an_Vw4VKw@mail.gmail.com>
Message-ID: <Y/fWuGL5RN8fUIr5@google.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm/kvm: add mmu_notifier_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 10:14=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 16, 2023, Yu Zhao wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 9c60384b5ae0..1b465df4a93d 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -875,6 +875,63 @@ static int kvm_mmu_notifier_clear_young(struct m=
mu_notifier *mn,
> > >       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gf=
n);
> > >  }
> > >
> > > +static bool kvm_test_clear_young(struct kvm *kvm, unsigned long star=
t,
> > > +                              unsigned long end, unsigned long *bitm=
ap)
> > > +{
> > > +     int i;
> > > +     int key;
> > > +     bool success =3D true;
> > > +
> > > +     trace_kvm_age_hva(start, end);
> > > +
> > > +     key =3D srcu_read_lock(&kvm->srcu);
> > > +
> > > +     for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > > +             struct interval_tree_node *node;
> > > +             struct kvm_memslots *slots =3D __kvm_memslots(kvm, i);
> > > +
> > > +             kvm_for_each_memslot_in_hva_range(node, slots, start, e=
nd - 1) {
> > > +                     gfn_t lsb_gfn;
> > > +                     unsigned long hva_start, hva_end;
> > > +                     struct kvm_gfn_range range =3D {
> > > +                             .slot =3D container_of(node, struct kvm=
_memory_slot,
> > > +                                                  hva_node[slots->no=
de_idx]),
> > > +                     };
> > > +
> > > +                     hva_start =3D max(start, range.slot->userspace_=
addr);
> > > +                     hva_end =3D min(end - 1, range.slot->userspace_=
addr +
> > > +                                            range.slot->npages * PAG=
E_SIZE - 1);
> > > +
> > > +                     range.start =3D hva_to_gfn_memslot(hva_start, r=
ange.slot);
> > > +                     range.end =3D hva_to_gfn_memslot(hva_end, range=
.slot) + 1;
> > > +
> > > +                     if (WARN_ON_ONCE(range.end <=3D range.start))
> > > +                             continue;
> >
> > Extend __kvm_handle_hva_range() instead of copy-pasting.  At a very qui=
ck glance,
> > I believe all that is needed is (minus sanity checks):
>=20
> Yes, will do.
>=20
> I do need to add one more parameter to kvm_gfn_range, because that's
> what the current kvm_arch_test_clear_young() needs, assuming that
> function is acceptable.
>=20
> Also, just a side note, from MM's POV, the following in
> __kvm_handle_hva_range() seems to forget to handle end =3D=3D 0, if that'=
s
> possible?

It's handled by the WARN_ON_ONCE() at the very top:

static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
						  const struct kvm_hva_range *range)
{
	if (WARN_ON_ONCE(range->end <=3D range->start))
		return 0;


>=20
>   hva_end =3D min(range->end, slot->userspace_addr + (slot->npages <<
> PAGE_SHIFT));
