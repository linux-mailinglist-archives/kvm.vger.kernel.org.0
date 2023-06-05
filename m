Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E411F722E63
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 20:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbjFESMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjFESMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 14:12:05 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057B9D3
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 11:12:04 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-33dea7d5424so17945ab.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685988723; x=1688580723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1v9H+aU/5MHg3n8/buk5HlYHhoHgA0ZUnQMJqGpMQJA=;
        b=gw03rkY2VpY+Vru936UGtYoAX16IZyS5hd3OHHog78K7Dvpq4TBluKU7gtif/3w5rp
         ye0RfevEZZ6jTOGi5G7VLdTevL4ZMODtlV8xlZGLD9DJz+i37yh6rv/JH5y5X6agRpXe
         fV8TWvMcjLK3PNCeAQrS93sWoYofkauour4Aazx5Z0IxnN1XUt8Eeq1eBDJmUXtGpZjG
         kDu9knKK33Ge2wQag5BQycHWxOa3SvPfV5AZ/UEbzSRQVa1QOSQlGefOlY4T2eGbLv5E
         QWDOaDjXT5rvKzZOFKi4fgTveJ7ov5u2N4YabOK16pcVDAc96eejtpjhCCZ++4+mIJVz
         Pjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685988723; x=1688580723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v9H+aU/5MHg3n8/buk5HlYHhoHgA0ZUnQMJqGpMQJA=;
        b=aP1NTWjMstOn6RS9r7cQsQB6ALSoNWNM77h2hsiY9etCKW09hInNzDxdBWbBINB1yC
         uSiIjHh/tCGvOwQm8ZuGxbT9Bzla+d/DmdyJF0RmOCF83pTe+Mv2kqlUiyaveYSAWTgM
         gQ2J/hWvkuwwKV2gzaItBTo27hcDhdXo9nl3ogu5Kz2KoM2XVZPZuwUj2HF05ZSlVcvC
         J9XsejPxaD1R1/ZhHuvWm4R55TN24a4PewkiZA56SgXd7PfyybShzXuiW6RRnsxOsHUx
         2rbCDsz3/m1AkVCjBH5di0JI6HQw42+FtajpB9m2Cb85LhGEL+inzsoPV+irv23LHPhK
         HiMw==
X-Gm-Message-State: AC+VfDxsaxdYh3dpJDyp02IIJv2bBvEivDr0aC7fCGvXXvi3tJS6kz9p
        FSN9cofAxieXEWh1ZnLtSU72I8HYkgJok/229PqnLw==
X-Google-Smtp-Source: ACHHUZ672rcdLzlt2TMtoZbpzHauyvyUWezDXI8ZRdcdXNwd9xa7Gpvfgbo3dXGDPFoIev1sMhSHkIoArtW1/9/Ol1s=
X-Received: by 2002:a92:c24b:0:b0:33d:b6ed:8bf3 with SMTP id
 k11-20020a92c24b000000b0033db6ed8bf3mr17037ilo.27.1685988723232; Mon, 05 Jun
 2023 11:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
In-Reply-To: <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Jun 2023 11:11:51 -0700
Message-ID: <CALMp9eRRzQKoFVHvgY8VfpS-8=RY6HYOanBuGYLRbRQ+9V8zng@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Mingwei Zhang <mizhang@google.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 10:42=E2=80=AFAM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> On Mon, Jun 5, 2023 at 9:55=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.co=
m> wrote:
> > >
> > > Remove KVM MMU write lock when accessing indirect_shadow_pages counte=
r when
> > > page role is direct because this counter value is used as a coarse-gr=
ained
> > > heuristics to check if there is nested guest active. Racing with this
> > > heuristics without mmu lock will be harmless because the correspondin=
g
> > > indirect shadow sptes for the GPA will either be zapped by this threa=
d or
> > > some other thread who has previously zapped all indirect shadow pages=
 and
> > > makes the value to 0.
> > >
> > > Because of that, remove the KVM MMU write lock pair to potentially re=
duce
> > > the lock contension and improve the performance of nested VM. In addi=
tion
> > > opportunistically change the comment of 'direct mmu' to make the
> > > description consistent with other places.
> > >
> > > Reported-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5ad55ef71433..97cfa5a00ff2 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_v=
cpu *vcpu, gpa_t cr2_or_gpa,
> > >
> > >         kvm_release_pfn_clean(pfn);
> > >
> > > -       /* The instructions are well-emulated on direct mmu. */
> > > +       /* The instructions are well-emulated on Direct MMUs. */
> > >         if (vcpu->arch.mmu->root_role.direct) {
> > > -               unsigned int indirect_shadow_pages;
> > > -
> > > -               write_lock(&vcpu->kvm->mmu_lock);
> > > -               indirect_shadow_pages =3D vcpu->kvm->arch.indirect_sh=
adow_pages;
> > > -               write_unlock(&vcpu->kvm->mmu_lock);
> > > -
> > > -               if (indirect_shadow_pages)
> > > +               if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> >
> > I don't understand the need for READ_ONCE() here. That implies that
> > there is something tricky going on, and I don't think that's the case.
>
> READ_ONCE() is just telling the compiler not to remove the read. Since
> this is reading a global variable,  the compiler might just read a
> previous copy if the value has already been read into a local
> variable. But that is not the case here...

Not a global variable, actually, but that's not relevant. What would
be wrong with using a previously read copy?

We don't always wrap reads in READ_ONCE(). It's actually pretty rare.
So, there should be an explicit and meaningful reason.

> Note I see there is another READ_ONCE for
> kvm->arch.indirect_shadow_pages, so I am reusing the same thing.

That's not a good reason. "If all of your friends jumped off a cliff,
would you?"

> I did check the reordering issue but it should be fine because when
> 'we' see indirect_shadow_pages as 0, the shadow pages must have
> already been zapped. Not only because of the locking, but also the
> program order in __kvm_mmu_prepare_zap_page() shows that it will zap
> shadow pages first before updating the stats.
