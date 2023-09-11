Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54979AE40
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjIKUr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243851AbjIKSBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:01:33 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49F2E5
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:01:27 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-655de2a5121so13445576d6.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694455287; x=1695060087; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjDfbVG7Z0f4VRf2UrtEhKHET6lYtFmHzIWX+qMQT4w=;
        b=joDU89foLETwducOUmy0Czh5myFh4v87rXJbSXxJOGWGn2LYz6ElQbl8QUdLNd0w9T
         6I0si2CqmLqbPBA1SZvuO4B8wvqEXLuqQ8g9alrobLLFcpRvZX/OGrxPRAd4BNknwWKV
         e6g4j4c1wLwJbvKyUWorDRaog+ztkhb/WoKDkrkjmIh9BQNzcjpbwLNMCE52g6FBBCnh
         McFYB4yAJRpqwmB7TsH8hpGP+k8BcMpgUk9UOITXMVeQ2lr7IT/Pb8ihFHBHjm5kgWvc
         QzznxuPUhrc8DkgVP4mepP5AudBFBJND9CdP/P0S2h10Pmmd0GIzOPfQQh9PPCujSqH0
         lwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694455287; x=1695060087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjDfbVG7Z0f4VRf2UrtEhKHET6lYtFmHzIWX+qMQT4w=;
        b=oWpV3WQQ7m0BBo9cAY5/Fm9zLhTPfIxZHFaArSEs9DwTD3BRa544RpIc8yMwakjB+T
         2kpHZPfsDrMBT/Mw/V/EDiH81DmxgF6afQzdMyixVhs/x13AzSDZv/vlWZVXNlAhq4uA
         utm4wSvHaHyMD10gN0ltM12YtoSjbAQXoVaqh0GXWjnM+lXeTQXRal3x77QC91F636kQ
         tZtZkaYSU/CK92Ajlej3fJePcLLaOCgHz3I/BOkJajDYIsd6AqMeL9WACNhzkSpgUByr
         pfCWqvfBF4A+UQebcSSm3LhqYM2lfR5sF64GG5lThlpk28IL90GwGftTGmQJm+CinpBI
         634g==
X-Gm-Message-State: AOJu0Yyi5F4aHws9i4jzlXCU/1VrYBaLkq+iy+0iaKRhAJ3iIJ5aOx8k
        SII/ChG+orVQT2g82vphWXmCSzYR3rOxjM23BLoLrg==
X-Google-Smtp-Source: AGHT+IFlV+rbxVmLpOVjETaXMQmsUmYNkJcDNdsKKjIGa+QzT0JjiVzwUSu5k2nyYtxJ0IWGyOzO5f20FKr+R7mrBaA=
X-Received: by 2002:a0c:ea4e:0:b0:64f:3699:90cd with SMTP id
 u14-20020a0cea4e000000b0064f369990cdmr9751242qvp.42.1694455286702; Mon, 11
 Sep 2023 11:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230911061147.409152-1-mizhang@google.com> <ZP8r2CDsv3JkGYzX@google.com>
In-Reply-To: <ZP8r2CDsv3JkGYzX@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 11 Sep 2023 11:00:50 -0700
Message-ID: <CAL715WKyS4sTH3yEOX2OyV+fxMLMOAV6tX-A7fvEAKEUGj8uxw@mail.gmail.com>
Subject: Re: [PATCH] KVM: vPMU: Use atomic bit operations for global_status
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 8:01=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> > Use atomic bit operations for pmu->global_status because it may suffer =
from
> > race conditions between emulated overflow in KVM vPMU and PEBS overflow=
 in
> > host PMI handler.
>
> Only if the host PMI occurs on a different pCPU, and if that can happen d=
on't we
> have a much larger problem?

Why on different pCPU?  For vPMU, I think there is always contention
between the vCPU thread and the host PMI handler running on the same
pCPU, no?

So, in that case, anything that __kvm_perf_overflow(..., in_pmi=3Dtrue)
touches on struct kvm_pmu will potentially race with the functions
like reprogram_counter() -> __kvm_perf_overflow(..., in_pmi=3Dfalse).

-Mingwei
>
> > Fixes: f331601c65ad ("KVM: x86/pmu: Don't generate PEBS records for emu=
lated instructions")
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/pmu.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index edb89b51b383..00b48f25afdb 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -117,11 +117,11 @@ static inline void __kvm_perf_overflow(struct kvm=
_pmc *pmc, bool in_pmi)
> >                       skip_pmi =3D true;
> >               } else {
> >                       /* Indicate PEBS overflow PMI to guest. */
> > -                     skip_pmi =3D __test_and_set_bit(GLOBAL_STATUS_BUF=
FER_OVF_BIT,
> > -                                                   (unsigned long *)&p=
mu->global_status);
> > +                     skip_pmi =3D test_and_set_bit(GLOBAL_STATUS_BUFFE=
R_OVF_BIT,
> > +                                                 (unsigned long *)&pmu=
->global_status);
> >               }
> >       } else {
> > -             __set_bit(pmc->idx, (unsigned long *)&pmu->global_status)=
;
> > +             set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> >       }
> >
> >       if (!pmc->intr || skip_pmi)
> >
> > base-commit: e2013f46ee2e721567783557c301e5c91d0b74ff
> > --
> > 2.42.0.283.g2d96d420d3-goog
> >
