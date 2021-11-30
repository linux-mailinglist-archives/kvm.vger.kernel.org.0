Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5848246295B
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 01:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhK3BAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 20:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhK3BAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 20:00:33 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D80AC061714
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:57:15 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y68so47529087ybe.1
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=esRLWzH6dw+Ce7phJ2ONogztplO8dpDdVUer7uLYFyE=;
        b=U5aJzHs/FlOo0fNLHNpFTCG7aV5AVGzHjOwJv+ZRQZ2UYblO/Xoq68Mh+LgMAMEAwG
         gwa4zJ90Q4Vp3p//JZbIjVpEVxN22f3h+4+7sxeGO3sWwSmqmkrdz9jnHCSb8YiN2upS
         D5/Ndr10UjtHbiuh4FI5cWeoCkqsB0aTL44awIBISsM9N3zTXpwRLBVNjjFjIWCBIAR2
         CqaFqQtCrMACvIkUHE15giu+ir9UH3UZ8bOr0YqtuXy0pXWMKyxt97pf5dNW50HQAd3P
         Xq4aMkwtelVEamSaY/KLEzVzDqoYGw++6mQuJua5WoTXkJxRUXI/ALyHcOXeHdQOkQOB
         T1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=esRLWzH6dw+Ce7phJ2ONogztplO8dpDdVUer7uLYFyE=;
        b=YNEjsXave+N1U18VM+KsJGZ1eliU8ICq+Karvls+0xqj4L/U19RHkCqBko0HNSozpy
         F/NgbvTgDh53nMxxJlCMZqcOrgmsyuauwLvqX3nXDg/sL+csxasRGlDprna5T9obob2r
         HtWkiCJ9zI4jBVh3e2PwPqeAXaAto3cdGPdWs1rt806p+ylHVSluiaRlDJrw15GZ1Bwo
         n+bohdWI2cWbnLCzS83XTkTUVkecijROJBtkikBoHpvEJpd8nWbGQj2lmAxzXcUhyOCj
         9GkTzoeyTd1R3XfnBWWDEOo+vyd9fy3HeMPienmjwdD6axTJmdJ6Q/RzKMo7DoOehZcv
         wIrg==
X-Gm-Message-State: AOAM530XhSMkGM/8YriiRVJKc29qia8MvZcDk5OPtpc169DdkjEsbbU8
        IGLIAzMk4Te9EmtMrEiUKfJlfS5qRBD3v91545kLGg==
X-Google-Smtp-Source: ABdhPJxBtrnBwZDK0SfMN9ZP26BpdgE0OykhJRvFEkCn6qO1fburjBb59wkMhZpu1UbE5WIus+YADqwKUV0GYHNYlNY=
X-Received: by 2002:a25:d003:: with SMTP id h3mr33831953ybg.184.1638233834133;
 Mon, 29 Nov 2021 16:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com> <20211113012234.1443009-2-rananta@google.com>
 <20211127131628.iihianybqbeyjdbg@gator.home>
In-Reply-To: <20211127131628.iihianybqbeyjdbg@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 29 Nov 2021 16:57:03 -0800
Message-ID: <CAJHc60yfmkPxchCgLT7FMabcmodYLhcJJDiJA3EDiS2nMSHQgg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/11] KVM: arm64: Factor out firmware register
 handling from psci.c
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 5:16 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sat, Nov 13, 2021 at 01:22:24AM +0000, Raghavendra Rao Ananta wrote:
> > Common hypercall firmware register handing is currently employed
> > by psci.c. Since the upcoming patches add more of these registers,
> > it's better to move the generic handling to hypercall.c for a
> > cleaner presentation.
> >
> > While we are at it, collect all the firmware registers under
> > fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> > kvm_arm_copy_fw_reg_indices() in a generic way.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/guest.c       |   2 +-
> >  arch/arm64/kvm/hypercalls.c  | 170 +++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/psci.c        | 166 ----------------------------------
> >  include/kvm/arm_hypercalls.h |   7 ++
> >  include/kvm/arm_psci.h       |   7 --
> >  5 files changed, 178 insertions(+), 174 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 5ce26bedf23c..625f97f7b304 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -18,7 +18,7 @@
> >  #include <linux/string.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/fs.h>
> > -#include <kvm/arm_psci.h>
> > +#include <kvm/arm_hypercalls.h>
> >  #include <asm/cputype.h>
> >  #include <linux/uaccess.h>
> >  #include <asm/fpsimd.h>
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 30da78f72b3b..9e136d91b470 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -146,3 +146,173 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >       smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> >       return 1;
> >  }
> > +
> > +static const u64 fw_reg_ids[] = {
> > +     KVM_REG_ARM_PSCI_VERSION,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > +};
> > +
> > +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     return ARRAY_SIZE(fw_reg_ids);
> > +}
> > +
> > +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > +             if (put_user(fw_reg_ids[i], uindices))
>
> This is missing the ++ on uindices, so it just writes the same offset
> three times.
>
Thanks for catching this! I believe I realized this later and
corrected it in patch-04/11 of the series and missed it here.
I'll fix it here as well.

> > +                     return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}
>
> I assume the rest of the patch is just a cut+paste move of code.
>
That's right.

Regards,
Raghavendra

> Thanks,
> drew
>
