Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F572722DC8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjFERm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjFERm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:42:57 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE03A7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:42:56 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-970056276acso760798366b.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685986974; x=1688578974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1y5t9l7fgNxCwxhJF5oRJyBHW++Rnvru6BGlC3ty3Q=;
        b=JJ2yARfO1j6yctytY7RGFu0N1Ba800EMMeCBuIZlkBQiK8ZPENXew9+W9k1Ln6ixa1
         f5xHogwfGWTkjM0vLDEjQDvPVex34Knt3zl4oI2HhKJkF5nvFCTSr5rAr5H3azXHzFH0
         ZG7umyJv6hMgxgj7dJPrfh/m92oX8PF2Rivuky1jx5LAKQrzv2wr3ZFcl9un79EtV3v7
         8IEmPD4sMP6do2dUecwoo2qCjvTymLWbm1BBUeM7bg417aY/H6KTfPkCVkNMsZzxc6qX
         Ti98DZTq/YM4vn83dqYvBFB/oPOpY/OnvX5wMSQnznEC2UzLt4yQh3OIvHkbP8/gYh9m
         XadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685986974; x=1688578974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1y5t9l7fgNxCwxhJF5oRJyBHW++Rnvru6BGlC3ty3Q=;
        b=NuV8GiCKlsCDP0lRipGt2MsF+ctpophGHVm+bSwNWhfdlQj2g04jqPJ1Uw4B7zHjDg
         5GZejYGoARohJlx7zISyY929HYPzCnx0Mp8QHb3rA2zo2mJWU4u896AVL1ahkC/z7rsG
         g1VDPhTAO+PCatLDc4lpxI4i8ahM4s2KNo78TkeAb2SpRrp7ZrBUUxqxGTQg/ZsXqbUm
         lNgkhdg8fU7Ft0qdo7rGXansH7E9+kjoM+P33E0Z8mYRSTM5tbsfYf94B317J92eT6oH
         2wmDjvy2Yi+0VOYFC7wBURpiGgWL8Ffgx5d5TpGaVTqizGD4GmIOD6g1XE5MP0/WKiJy
         Au9Q==
X-Gm-Message-State: AC+VfDw5DwjRBmCGJOYRztXn01OgM1zIMFLCckI/ypdzjFjgg+gRb83w
        OSRKh1LlaHXPO5ikMCg4fyTO0Aq7DQbmax0Yfn2XeQ==
X-Google-Smtp-Source: ACHHUZ5rd4wnlUPX3vnRn8UOpfyeh0jb4JFLgcyiQf2uwLDSz3fu9nRd5EsNEz+1nStKKC3LUh3M9sS1XTOwTmirexI=
X-Received: by 2002:a17:906:58cf:b0:96a:1c2a:5a38 with SMTP id
 e15-20020a17090658cf00b0096a1c2a5a38mr6459925ejs.11.1685986974517; Mon, 05
 Jun 2023 10:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
In-Reply-To: <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 5 Jun 2023 10:42:18 -0700
Message-ID: <CAL715WJowYL=W40SWmtPoz1F9WVBFDG7TQwbsV2Bwf9-cS77=Q@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 9:55=E2=80=AFAM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.com>=
 wrote:
> >
> > Remove KVM MMU write lock when accessing indirect_shadow_pages counter =
when
> > page role is direct because this counter value is used as a coarse-grai=
ned
> > heuristics to check if there is nested guest active. Racing with this
> > heuristics without mmu lock will be harmless because the corresponding
> > indirect shadow sptes for the GPA will either be zapped by this thread =
or
> > some other thread who has previously zapped all indirect shadow pages a=
nd
> > makes the value to 0.
> >
> > Because of that, remove the KVM MMU write lock pair to potentially redu=
ce
> > the lock contension and improve the performance of nested VM. In additi=
on
> > opportunistically change the comment of 'direct mmu' to make the
> > description consistent with other places.
> >
> > Reported-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5ad55ef71433..97cfa5a00ff2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_vcp=
u *vcpu, gpa_t cr2_or_gpa,
> >
> >         kvm_release_pfn_clean(pfn);
> >
> > -       /* The instructions are well-emulated on direct mmu. */
> > +       /* The instructions are well-emulated on Direct MMUs. */
> >         if (vcpu->arch.mmu->root_role.direct) {
> > -               unsigned int indirect_shadow_pages;
> > -
> > -               write_lock(&vcpu->kvm->mmu_lock);
> > -               indirect_shadow_pages =3D vcpu->kvm->arch.indirect_shad=
ow_pages;
> > -               write_unlock(&vcpu->kvm->mmu_lock);
> > -
> > -               if (indirect_shadow_pages)
> > +               if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
>
> I don't understand the need for READ_ONCE() here. That implies that
> there is something tricky going on, and I don't think that's the case.

READ_ONCE() is just telling the compiler not to remove the read. Since
this is reading a global variable,  the compiler might just read a
previous copy if the value has already been read into a local
variable. But that is not the case here...

Note I see there is another READ_ONCE for
kvm->arch.indirect_shadow_pages, so I am reusing the same thing.

I did check the reordering issue but it should be fine because when
'we' see indirect_shadow_pages as 0, the shadow pages must have
already been zapped. Not only because of the locking, but also the
program order in __kvm_mmu_prepare_zap_page() shows that it will zap
shadow pages first before updating the stats.
