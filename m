Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84993722E9E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 20:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjFESXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 14:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjFESXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 14:23:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F441CD
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 11:23:40 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9741a0fd134so857374066b.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 11:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685989418; x=1688581418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HL7LtRo38rSnr6Yt2ZUnSYtZjcJWAoASEOUKNC+FfI=;
        b=gdl9BZYroG0qaIxk7YA86KFT4AKV6+dIVkcfngm6sciZt1q02QM+UFdcxOBMvMVtBu
         0ujgc+j5vdX5xc6F3hhhSb3/si+cvyzXE+mc5xs6CuMFQLPgVk9AtMrcaNWUhsLsVuTg
         UknBQPkH31ZwZyB2sWpB3BjeA9org01sZ7UEXtNiHRb3l9ZIhDT6JG7vQvIVlOGg2xZD
         mAH1ek8US+H1u7SG//mVfUnrVJqnZfH9LgiAjqq9so7KBiqCE7peCMgZQnq3Dp/zrfeo
         o6U2iX9Ftyd3D+loqzK+7YB40kq33LkXPd0TsavtSgDVM+etK2CgMOlOB3uVD6NN1c9H
         hBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685989418; x=1688581418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HL7LtRo38rSnr6Yt2ZUnSYtZjcJWAoASEOUKNC+FfI=;
        b=DrsHVtI4UKQVAS3PFwlwZI+HmqTbQdYoFczY+LusN1mlOUapBuf0o2Sx9ss9O/iuEp
         kf/+qHD/rZQXrjUzQ3ucOut86GyR4+DA/beALoIdt3oH12hYw31YITZJgFhuTzq8dkiB
         xmwNMHHAZu7Q09BfD///RhaLa7Hvap/Ti9B1y6bmm3KDeWx4Sm012/2KjO9a7XKFxBVw
         L9qBKZzjCmlb73Zn7eyMkePCzssrSa/RTuuFV9qN8L7ITjP2uGt3F7wmmI6qS2LrZvn+
         5GSal/Xbw/VXwhS5CU4oy7QUUgy8BE32PCP8Kr0vngDmD9kY2iL3XBjJ+DbopJQ0Go9y
         Q8ow==
X-Gm-Message-State: AC+VfDwhUp7ps1JZR8L5t19R875hLaflHl47sPspJLaeY4u/ZHEOzmtg
        zbNcV3CIcRIh1x2VlP7ulnG/DEZ99Miu1u3cPJ8Hi3YzXydMVT//Ztc=
X-Google-Smtp-Source: ACHHUZ5uwKaEuBe9wYIGI0HuH4IIcIaMLwpiOJsGMJYBm9sUz4ar/aO2G6+XEhq/cl765C1WmCtjdhJmbcR+yeBbBlk=
X-Received: by 2002:a17:907:745:b0:974:7713:293f with SMTP id
 xc5-20020a170907074500b009747713293fmr6788752ejb.41.1685989418510; Mon, 05
 Jun 2023 11:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com> <CALMp9eRRzQKoFVHvgY8VfpS-8=RY6HYOanBuGYLRbRQ+9V8zng@mail.gmail.com>
In-Reply-To: <CALMp9eRRzQKoFVHvgY8VfpS-8=RY6HYOanBuGYLRbRQ+9V8zng@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 5 Jun 2023 11:23:02 -0700
Message-ID: <CAL715WKVZKESoSyG-uv1v1+K1vgy=wEwCVdOVsT-JzA2zhWigA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 11:12=E2=80=AFAM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Mon, Jun 5, 2023 at 10:42=E2=80=AFAM Mingwei Zhang <mizhang@google.com=
> wrote:
> >
> > On Mon, Jun 5, 2023 at 9:55=E2=80=AFAM Jim Mattson <jmattson@google.com=
> wrote:
> > >
> > > On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.=
com> wrote:
> > > >
> > > > Remove KVM MMU write lock when accessing indirect_shadow_pages coun=
ter when
> > > > page role is direct because this counter value is used as a coarse-=
grained
> > > > heuristics to check if there is nested guest active. Racing with th=
is
> > > > heuristics without mmu lock will be harmless because the correspond=
ing
> > > > indirect shadow sptes for the GPA will either be zapped by this thr=
ead or
> > > > some other thread who has previously zapped all indirect shadow pag=
es and
> > > > makes the value to 0.
> > > >
> > > > Because of that, remove the KVM MMU write lock pair to potentially =
reduce
> > > > the lock contension and improve the performance of nested VM. In ad=
dition
> > > > opportunistically change the comment of 'direct mmu' to make the
> > > > description consistent with other places.
> > > >
> > > > Reported-by: Jim Mattson <jmattson@google.com>
> > > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > > ---
> > > >  arch/x86/kvm/x86.c | 10 ++--------
> > > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 5ad55ef71433..97cfa5a00ff2 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm=
_vcpu *vcpu, gpa_t cr2_or_gpa,
> > > >
> > > >         kvm_release_pfn_clean(pfn);
> > > >
> > > > -       /* The instructions are well-emulated on direct mmu. */
> > > > +       /* The instructions are well-emulated on Direct MMUs. */
> > > >         if (vcpu->arch.mmu->root_role.direct) {
> > > > -               unsigned int indirect_shadow_pages;
> > > > -
> > > > -               write_lock(&vcpu->kvm->mmu_lock);
> > > > -               indirect_shadow_pages =3D vcpu->kvm->arch.indirect_=
shadow_pages;
> > > > -               write_unlock(&vcpu->kvm->mmu_lock);
> > > > -
> > > > -               if (indirect_shadow_pages)
> > > > +               if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages=
))
> > >
> > > I don't understand the need for READ_ONCE() here. That implies that
> > > there is something tricky going on, and I don't think that's the case=
.
> >
> > READ_ONCE() is just telling the compiler not to remove the read. Since
> > this is reading a global variable,  the compiler might just read a
> > previous copy if the value has already been read into a local
> > variable. But that is not the case here...
>
> Not a global variable, actually, but that's not relevant. What would
> be wrong with using a previously read copy?

Nothing will be wrong I think since this is already just a heuristic.

>
> We don't always wrap reads in READ_ONCE(). It's actually pretty rare.
> So, there should be an explicit and meaningful reason.
>
> > Note I see there is another READ_ONCE for
> > kvm->arch.indirect_shadow_pages, so I am reusing the same thing.
>
> That's not a good reason. "If all of your friends jumped off a cliff,
> would you?"

:)

>
> > I did check the reordering issue but it should be fine because when
> > 'we' see indirect_shadow_pages as 0, the shadow pages must have
> > already been zapped. Not only because of the locking, but also the
> > program order in __kvm_mmu_prepare_zap_page() shows that it will zap
> > shadow pages first before updating the stats.

yeah, I forgot to mention that removing READ_ONCE() is ok for me.
