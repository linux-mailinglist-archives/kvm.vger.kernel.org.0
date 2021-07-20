Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7713CFBDB
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 16:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbhGTNfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 09:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239759AbhGTNeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 09:34:50 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68487C06178C
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 07:03:50 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u15so24624652oiw.3
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 07:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3pAi2IUwv7EdpJAk0boQH8aQmdEiZAI8a1a0cHarpI4=;
        b=tOwo8JvOI333zTSShr7G1VQA9f36JvMMNfNy1R4+AFu6wyd+zUTDRc3727tpBO3PTO
         CollJtLxZ1ie8UmiMdFJ2EwmFnHL7LVTZ1MwOUnb0/9VJ40wFwvdA4u4VoYw3xKLcRq+
         j3BiNhWmklGXaozYmLVL87ARe8dSQ+G0O6BuuPS+1jkZHknx87nIzCb0U5wh5fb1Pj9k
         z6Rj9DPISr0X2Wc9vqLTM4EmCRb4uz0xKXGaqCwwLg5xN811WE56OjyoHuKePwn7UC+F
         9sCfaWQsLxa5QsFKDhwvoDHoKWtadr3X89+6EWT/j+Lj1Dmv0luQacJyQiqYXxY2Nf23
         FpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3pAi2IUwv7EdpJAk0boQH8aQmdEiZAI8a1a0cHarpI4=;
        b=GYA7iTxCeYlzgTJK3FBY+Pay5VKX2CAwXJ9q3DdY0uGAUXQYawuVcrk3GyDWTOALyU
         oBdCziNOzVY1hByJmEalVdCtenVmqxwZJPv+KzOVdsDAnucXjxT+ZEzgs9yBJZtoD7rv
         bVJZ8YZzQ4UHq6QsYPRY2uc6+tL6vg52GA5NgyWV0uXEncB4QfZ14gxxum4qOngLPjsq
         T88ArUrKxF23QX7hfypu42JOlmI1rHczVl1HCTQI20yI+dIWxGa3WSs7f2+6y5TIORL7
         /z37eU6QNzUgxo9m2sEgY7FIgiWc4YfQNuXzL+8G4HBp8BAf/Tzn97gaYf2rn2uUi+Bt
         I+gg==
X-Gm-Message-State: AOAM533HyRjADqKznsJA/UzXi1p8MqZpH2jj17q0X2Ffpmkig/llo0Nc
        AoItYQrsLrPcQrISYi29bnVC7Ut9Q8h/6JjTWyf1ng==
X-Google-Smtp-Source: ABdhPJy67+4yt2CQ9gqDe2NPUt44b6Ljx8YHSPr8w0AM4pzGQ7GWeDm6CdAiYnsIJo8vfqE2nz3OKjDc0mNnw3K+NQk=
X-Received: by 2002:a05:6808:5a:: with SMTP id v26mr12146167oic.90.1626789829100;
 Tue, 20 Jul 2021 07:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-6-tabba@google.com>
 <20210720133810.7q4k2yde57okgvmm@gator>
In-Reply-To: <20210720133810.7q4k2yde57okgvmm@gator>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 20 Jul 2021 15:03:12 +0100
Message-ID: <CA+EHjTzW=GnG_zE=eregR7+WTLD-ASzajrMkinUMX=+Lfq3RcA@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Jul 20, 2021 at 2:38 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> > Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> > common code. It will be used in nVHE in a later patch.
> >
> > Note that the refactored code uses __inline_bsearch for find_reg
> > instead of bsearch to avoid copying the bsearch code for nVHE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  3 +++
> >  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
> >  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
> >  3 files changed, 35 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 7b9c3acba684..326f49e7bd42 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1153,6 +1153,9 @@
> >  #define ICH_VTR_A3V_SHIFT    21
> >  #define ICH_VTR_A3V_MASK     (1 << ICH_VTR_A3V_SHIFT)
> >
> > +/* Extract the feature specified from the feature id register. */
> > +#define FEATURE(x)   (GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
>
> I think the comment would be better as
>
>  Create a mask for the feature bits of the specified feature.

I agree. I'll use this instead.

> And, I think a more specific name than FEATURE would be better. Maybe
> FEATURE_MASK or even ARM64_FEATURE_MASK ?

I think so too. ARM64_FEATURE_MASK is more descriptive than just FEATURE.

Thanks,
/fuad

> > +
> >  #ifdef __ASSEMBLY__
> >
> >       .irp    num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 80a6e41cadad..1a939c464858 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -44,10 +44,6 @@
> >   * 64bit interface.
> >   */
> >
> > -#define reg_to_encoding(x)                                           \
> > -     sys_reg((u32)(x)->Op0, (u32)(x)->Op1,                           \
> > -             (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> > -
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> >                                struct sys_reg_params *params,
> >                                const struct sys_reg_desc *r)
> > @@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -#define FEATURE(x)   (GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> > -
> >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >               struct sys_reg_desc const *r, bool raz)
> > @@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
> >       return 0;
> >  }
> >
> > -static int match_sys_reg(const void *key, const void *elt)
> > -{
> > -     const unsigned long pval = (unsigned long)key;
> > -     const struct sys_reg_desc *r = elt;
> > -
> > -     return pval - reg_to_encoding(r);
> > -}
> > -
> > -static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
> > -                                      const struct sys_reg_desc table[],
> > -                                      unsigned int num)
> > -{
> > -     unsigned long pval = reg_to_encoding(params);
> > -
> > -     return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> > -}
> > -
> >  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
> >  {
> >       kvm_inject_undefined(vcpu);
> > @@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
> >
> >       trace_kvm_handle_sys_reg(esr);
> >
> > -     params.Op0 = (esr >> 20) & 3;
> > -     params.Op1 = (esr >> 14) & 0x7;
> > -     params.CRn = (esr >> 10) & 0xf;
> > -     params.CRm = (esr >> 1) & 0xf;
> > -     params.Op2 = (esr >> 17) & 0x7;
> > +     params = esr_sys64_to_params(esr);
> >       params.regval = vcpu_get_reg(vcpu, Rt);
> > -     params.is_write = !(esr & 1);
> >
> >       ret = emulate_sys_reg(vcpu, &params);
> >
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 9d0621417c2a..cc0cc95a0280 100644
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
> > +                               .is_write = !((esr) & 1) })
> > +
> >  struct sys_reg_desc {
> >       /* Sysreg string for debug */
> >       const char *name;
> > @@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
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
> > +     return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> > +}
> > +
> >  const struct sys_reg_desc *find_reg_by_id(u64 id,
> >                                         struct sys_reg_params *params,
> >                                         const struct sys_reg_desc table[],
> > --
> > 2.32.0.402.g57bb445576-goog
> >
>
> Otherwise
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
