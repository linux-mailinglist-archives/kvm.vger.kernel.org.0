Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F724305BE
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbhJQAp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 20:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbhJQAp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Oct 2021 20:45:26 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3A6C061765
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 17:43:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so12002857pjb.1
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 17:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IiOWGy8tMQRLpDn+eCyybilmmSR1ckxWs2pDq5ZT9Ik=;
        b=J5xRJ0dTlgDAo6yty9GlaenUpAjwcXiT5oAi/nRczSdBoQ1YfioXV8pJzIE1inx+R1
         bnAdW7YP3yQYbSpaM7oITWrY8xWWOZXlo2JDfOIxmNm82FYWUga28yAjcyqsPbD9nuGA
         zoguHRuJCrjfiz2INl3V0sOonzQoOg5LBF3nGQNraadXGRufsogZvhLfKKHsh1860x4M
         ukAvDjoqL/ygxmozeQkX67z8BAlu3aiKQrgUF+YvX/wQ/nQDV59tKkBKtolmcO2d4Ex5
         4ZtILO5dr+NF/7f3wt/ML06pi4Qhg/NyNN6kgixBQPpG1AUHu0GJcCvSVQCA6LdsgxiC
         +/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IiOWGy8tMQRLpDn+eCyybilmmSR1ckxWs2pDq5ZT9Ik=;
        b=LlA8kq9Bg0oY3lsCdQW/3B8DzI/iVNwGFvTKnDEHh8xFXLXwVlo3m0vezLhFS1bk9R
         IBYXld05Odnxiw7e/gtbZ1tiAP+NLSlaJ7W/7hkru5M0VBUujMmWr6SckC2rMhz0XwWb
         Vg/C+AmjSVlTUt67FigfvYC4OazJRhZIGZ8lleckdhgE7O57hsLCZQRTf4xFyBQAJyKp
         cSJoedw0icMii1MCcYPS0Lfu3btUxOiUN0FFTKDJeiI5C7zW4mfKTn8tfyagLZlYgAwn
         V0P0g1sy+epJmJx0fjQIRv7jmwFYm1OPCFZzAxMkJBD4zKQ9KOBUwBipHiqI01cV0e7p
         mx6Q==
X-Gm-Message-State: AOAM530Ybow+QDZw8DAzkcjfXItFU5dUXS0y2LCZfZXUNThBI+WsC8l0
        asGZR3u7/v3YZh64utzVqosOicb2dzqmcu5hGLG5qw==
X-Google-Smtp-Source: ABdhPJy3v+acwe/IavlDvDOFJQAd8YtLrwYt9/b1dEsWw7zjJKe6J06bBCxOm0YQ7+Br5VTgSCTFV1eWn36o+7szWcc=
X-Received: by 2002:a17:902:c402:b0:13f:1c07:5a25 with SMTP id
 k2-20020a170902c40200b0013f1c075a25mr18688367plk.38.1634431395551; Sat, 16
 Oct 2021 17:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com> <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator>
In-Reply-To: <20211015130918.ezlygga73doepbw6@gator>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 16 Oct 2021 17:42:59 -0700
Message-ID: <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 6:09 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 11, 2021 at 09:35:12PM -0700, Reiji Watanabe wrote:
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
> >  2 files changed, 28 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 9b5e7a3b6011..0cd351099adf 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
> >       u64 disr_el1;           /* Deferred [SError] Status Register */
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
>
> crm is 4 bits, so this should be 0 <= crm < 16 and...
>
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
>
> ...this should be 128. Or am I missing something?

Registers with (3, 0, 0, 0<=crm<8, op2) are defined/allocated including
reserved (RAZ) ones (please see Table D12-2 in ARM DDI 0487G.b),
and the code supports those only for now.

I understand that registers with crm >= 8 could be defined in the future
(I'm not so sure if they will be really ID registers though),
but then we can include them later as needed.

> > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > +
> >  enum vcpu_sysreg {
> >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > @@ -209,6 +217,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> >       /* Memory Tagging Extension registers */
> >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> >       GCR_EL1,        /* Tag Control Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1d46e185f31e..72ca518e7944 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
> >       u32 sr = reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >               struct sys_reg_desc const *r, bool raz)
> >  {
> >       u32 id = reg_to_encoding(r);
> > -     u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> > +     u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>
> Since not all ID registers will use this, then maybe name it
> reset_sanitised_id_reg?

Thank you for the suggestion.

I named it 'reset_id_reg' according to the naming conventions of
set_id_reg, get_id_reg, and access_id_reg which are used for the same
set of ID registers (ID_SANITISED ones) as reset_id_reg.
I would think it's better to use consistent names for all of them.
So, I am a bit reluctant to change only the name of reset_id_reg.

What do you think about the names of those other three functions ?


> > +{
> > +     u32 id = reg_to_encoding(rd);
> > +
> > +     if (vcpu_has_reset_once(vcpu))
> > +             return;
>
> Ah, I see my kvm_vcpu_initialized() won't work since vcpu->arch.target is
> set before the first reset. While vcpu->arch.target is only being used
> like a "is_initialized" boolean at this time, I guess we better keep it
> in case we ever want to implement CPU models (which this series gets us a
> step closer to).

Thank you for sharing your thoughts and I agree with you.


> > +
> > +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> > +}
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              const struct kvm_one_reg *reg, void __user *uaddr)
> > @@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > - * For now, these registers are immutable for userspace, so no values
> > - * are stored, and for set_id_reg() we don't allow the effective value
> > - * to be changed.
> > + * We don't allow the effective value to be changed.
> >   */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > @@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> >  #define ID_SANITISED(name) {                 \
> >       SYS_DESC(SYS_##name),                   \
> >       .access = access_id_reg,                \
> > +     .reset  = reset_id_reg,                 \
> >       .get_user = get_id_reg,                 \
> >       .set_user = set_id_reg,                 \
> >       .visibility = id_visibility,            \
> > @@ -1830,8 +1838,10 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr = __vcpu_sys_reg(vcpu,
> > +                                      IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
> > +             u64 pfr = __vcpu_sys_reg(vcpu,
> > +                                      IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
>
> Please avoid these ugly line breaks when we're well under Linux's max
> length, which is 100.

Yes, I will fix them (as well as all other similar line breaks
for other patches in my series).

Thanks,
Reiji
