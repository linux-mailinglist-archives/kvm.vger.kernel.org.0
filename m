Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562643B92CB
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 16:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhGAOHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 10:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhGAOHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 10:07:33 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC6BC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 07:05:02 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t3so7407100oic.5
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 07:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B7IUnh0oWyjBb2xRncqIUXvQS59ay97jYCOfPEteAjc=;
        b=lIs2zjPlxTetwv2YHF0hWz6sbsM3W7g5WxyfvhsBCUbb6bDyxfthudpXaz9sn6UBkr
         Lvlrq5FhKeg9/3Uc5Wjqe5FoAvl2X9E7+yPn6LW8oDULu98kMUx/eba6pOvqiJ3GTIsv
         Sh7ikCMS2cTDm573VNQ8q8z3ABMq3o6/8MRwsGKL+FFpz1+ePXfqfxcCaP6/vjCgPLgn
         6eeQ1j9MQ0MTHVXMoIMhIt+N/sS760pVRr2+nchlN1YXtCuYBgv8dkSBDHgDzY7ZTYYz
         LsLoRPOkYCU7y00dNWwTmdT3lVVF4hGwtw9YcdqXZPrV95RZotSN3dMzEu2IbVhcRcJz
         qHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B7IUnh0oWyjBb2xRncqIUXvQS59ay97jYCOfPEteAjc=;
        b=C/1P4hf4s6gsSPt+ONeyWkh3ToynXZrdrPexJ7RdqnN2gzR2PFuAZ1qm+9+e1FDGqL
         OkpA+yyTWAHenO0GKZtryJWu5JlT74MXK48Jchxwvly56fa3FFdkyZ9AdRia+m6I+TNk
         VJIJDkuJ336sVohXzIYN1oqhgFADCbcSTPcgAW+i/WVpChbl3dWKtkQbE3buMkg1SAhX
         FN+BhoDLA8zx36/G8EfJe91lBBGDmzn67saY/7ik/6gynN78K32tsDdLwxbGFTy12pkJ
         1yJqvehkykrUjynkwR5mb87PcoGFaZaD4LKZicpJxPMzzGJrQS87Zvf8133yU3HR/LDg
         nxOQ==
X-Gm-Message-State: AOAM530eLAnelNGTIebbPGhZogQ0jq12fZvCo/iaa4N7b8VDC4f6ruu9
        c3BacqXl5GaK4KTJwg6EfsfZDV5SrEYTcOVov5C9wg==
X-Google-Smtp-Source: ABdhPJxh97XTaujhPyDDSWa0CFYxsqv8rXYuxB3HmSkbRQ+/EPSoQuBQ8hjPuKO7p8D6Vm4dD7Kzh7JgjeGzDP6OVFM=
X-Received: by 2002:a05:6808:158b:: with SMTP id t11mr1057180oiw.8.1625148301795;
 Thu, 01 Jul 2021 07:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-5-tabba@google.com>
 <20210701130917.GD9757@willie-the-truck>
In-Reply-To: <20210701130917.GD9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 15:04:25 +0100
Message-ID: <CA+EHjTyi8++9r1i4oY7HjjPQMSTz5G5H5CQ_dDtsG7X5LuZr1Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jul 1, 2021 at 2:09 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:41PM +0100, Fuad Tabba wrote:
> > Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> > common code. It will be used in nVHE in a later patch.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 30 +-----------------------------
> >  arch/arm64/kvm/sys_regs.h | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 36 insertions(+), 29 deletions(-)
>
> [...]
>
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 9d0621417c2a..b8e2a4dd830f 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -11,6 +11,12 @@
> >  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
> >  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
> >
> > +#include <linux/bsearch.h>
> > +
> > +#define reg_to_encoding(x)                                           \
> > +     sys_reg((u32)(x)->Op0, (u32)(x)->Op1,                           \
> > +             (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> > +
> >  struct sys_reg_params {
> >       u8      Op0;
> >       u8      Op1;
> > @@ -21,6 +27,14 @@ struct sys_reg_params {
> >       bool    is_write;
> >  };
> >
> > +#define esr_sys64_to_params(esr)                                               \
> > +     ((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
> > +                               .Op1 = ((esr) >> 14) & 0x7,                  \
> > +                               .CRn = ((esr) >> 10) & 0xf,                  \
> > +                               .CRm = ((esr) >> 1) & 0xf,                   \
> > +                               .Op2 = ((esr) >> 17) & 0x7,                  \
> > +                               .is_write = !((esr)&1) })
>
> Formatting has gone funny here (need spaces around the '&' in that last
> entry).

Will fix this.

> > +
> >  struct sys_reg_desc {
> >       /* Sysreg string for debug */
> >       const char *name;
> > @@ -152,6 +166,24 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
> >       return i1->Op2 - i2->Op2;
> >  }
> >
> > +static inline int match_sys_reg(const void *key, const void *elt)
> > +{
> > +     const unsigned long pval = (unsigned long)key;
> > +     const struct sys_reg_desc *r = elt;
> > +
> > +     return pval - reg_to_encoding(r);
> > +}
> > +
> > +static inline const struct sys_reg_desc *
> > +find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
> > +      unsigned int num)
> > +{
> > +     unsigned long pval = reg_to_encoding(params);
> > +
> > +     return __inline_bsearch((void *)pval, table, num, sizeof(table[0]),
> > +                             match_sys_reg);
>
> You don't mention why you change bsearch() to __inline_bsearch().

It's because of linking with nvhe. Rather than copy the bsearch code
for nvhe, I thought I'd use the inline version of bsearch. I'll update
the comment to explain that.

Thanks,
/fuad

> Will
