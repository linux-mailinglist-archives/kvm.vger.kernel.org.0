Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CA6722D73
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbjFERRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbjFERRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:17:42 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B14CD3
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:17:40 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f804665702so13141cf.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685985459; x=1688577459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PW3P1vIM2WDTsRDVeenwIcNSQa/MZz4KHGZSoIx2p84=;
        b=1klBAYVVSmnvd11O+TpDJXrRcQnLLHSmd9MixU4CSWvozFm9aWcwlRRSCgOVtUXY5E
         1i8h/a8gA0km1btECjApb90WEM1GeISM5/eRt/OMBwg+seF+TDmzaZ+MPRj57G8ihvTP
         TYlPgB+ZKcywuhQdwZJnuGcozC6tnAUvHlK0LwPijfDV7wWxeIkfM5CDyKDxFxbFhJ1O
         tgNTxPnl0CIN2mfWySwjXh5azIs4zL8CWDArg1MHlY1djlec5894mdHKhFq/nFFEnl/u
         YQ6xIew+ANpcjREwWueUOLpU2XpMboZNLXeIOSw0ISr6f1ZMh9hImY1IxbedySxbmbPV
         JHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685985459; x=1688577459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PW3P1vIM2WDTsRDVeenwIcNSQa/MZz4KHGZSoIx2p84=;
        b=AmuFFwrI1Gj63xT3uhaMwOjK7HXF4qnGnwCE6kKIqvCv7wt+bUMmXhwu/CioM2poi+
         LIbceTDMELrtDrgpkBtvIal0cpo78lXW9gY8knhbriE5dzxxMxly/MnENk8XMpe39fwc
         cNdim13mv5jWNTWmkGdh0lVKyolzQQbir7NN9hQFxv+vc4Q+l2ZiyNV/xhYPrnylQLJi
         8pgSwG9m9FXX9q4jMOIrMarwx3yle4djz5ZF4B/YJ9QoFRmKNAgQ/r+VColTJeYUgKoy
         s1ObDNwkMqhbjzQqvtv6AeAH0ugd7xgpwvQ0ngjK/1E0vXAldlcv7W1YOqbyXYpGOo6E
         60fA==
X-Gm-Message-State: AC+VfDwzd6bX3kU1Alb7zIdtm2QK4DmKX1nmc//XEPVzryMjMerVWrP1
        WmLg5Scxhn++ggIzXcazWrGtLLJDMr1PdzoWPgF5mg==
X-Google-Smtp-Source: ACHHUZ4WzS+Kzr3p8Yhnpffe3+jO9D1YWqR3ee9JQUrOyisbjpiwcFlcjWQ3tEfzP22YSKPHzXOd7umwDPQR57u6qms=
X-Received: by 2002:ac8:58cf:0:b0:3f8:5b2:aeee with SMTP id
 u15-20020ac858cf000000b003f805b2aeeemr721497qta.22.1685985458926; Mon, 05 Jun
 2023 10:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
In-Reply-To: <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 5 Jun 2023 10:17:27 -0700
Message-ID: <CANgfPd9kKxq1146F3mX_u7KCC0HrWfgYrxZd6c9Dh7s19E4Eog@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Jim Mattson <jmattson@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Nit: Internally within Google, on older kernels, we have the "Direct
MMU" which was the precursor to the TDP MMU we all know and love. This
comment however does not refer to the Direct MMU. Direct here just
refers to the direct role bit being set. Since it's just descriptive,
direct should not be capitalized in this comment, so no reason to
change this line.

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

Agree this doesn't need a READ_ONCE. Just a read is fine.
kvm_mmu_unprotect_page starts by acquiring the MMU lock, so there's
not much room to reorder anything anyway.

Thanks for sending a patch to fix this. The critical section of the
MMU lock here is small, but any lock acquisition in write mode can
mess up performance of otherwise happy read-mode uses.

>
> >                         kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gp=
a));
> >
> >                 return true;
> >
> > base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
> > --
> > 2.41.0.rc0.172.g3f132b7071-goog
> >
