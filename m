Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5C8456542
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 23:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhKRWDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 17:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhKRWDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 17:03:20 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDBBC061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:00:20 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n85so7384528pfd.10
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EpdJi3HYgLc5zwKM/z1Fkk+LrQE+K6mTNDKahwPRN+Q=;
        b=akQ9hotq/NIJFU7aF5TgnIKJNyCnEcDMpW5ZtN6EzU8z9873Ze+lsfJAepUwTdRkPm
         QVtg3sfjkzqWMCtitRktzbgzCpnEzTHNWAluqme/o+QYJpgcK+5UCQVcOHX77mEX8ZFA
         hrzCME8n3ul8ykXPDoTLJjnbWfsjxVjwQizOYDNhN4p9acchsHk4xxntouONdNg1NBhR
         ExQT2cAlzF6RaGaGyKrG1XYK1RjDU+PKeF4DYCc4nHiaqT4ngsdBHTPrLfAyJZjA8Bbb
         pT5UpJ7bUSEShC6Yn0o/YosxpFZ1kGhV2jKyzlp7er1mWeXXFFmiZxBkPQeQyEim3K17
         /uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EpdJi3HYgLc5zwKM/z1Fkk+LrQE+K6mTNDKahwPRN+Q=;
        b=36k2OBiCLoYWBCa91RvCMmwjmvL1aH6NHKC2Lm7XCdnJ7ZoawqkXLSz/TuUw2nWohQ
         iWaKLe9lbUKgTUfbZBDj/edBHA+GQ1OEgnkjtuYtl+devy16I9KtpMpZxgfMDmIe1fez
         TbEC9y8xKL41FZ2DjdoCs69T03pdFX+yziQOqT+8FdMaVkME2XUe1vEatvX5b5U4hivQ
         UK7D/MCj5gHn4c9irZn7+xvclF0GtUAkywhxLqOWdJ1iHnT6KVpco+t1Dks9/8PA0SoJ
         QYDZYbC1uJ+b14MZ/PTodtB4DhY9WIDws+dVA4eWYoDNSjPibkVObOOP1/wxEuh0SEbM
         9GJQ==
X-Gm-Message-State: AOAM531BleHMA8/x9zN9QzSEcONzdfRhWGiyy6ilAEYFlBOFfgZCJIOD
        GUFlB/NnbsSDBe3Ma+bZFKWszdNbYB3DXI4yc8D5EYFBwAAiwQ==
X-Google-Smtp-Source: ABdhPJzL2sawh7KxRB9k5qoNwKnO6wsjrcsjdgXf7XIV8VeKfPMFfbCAThDnxgeJ16+XkOhTt+8FzOqG77GQGJZPL3c=
X-Received: by 2002:a63:c158:: with SMTP id p24mr13526679pgi.53.1637272819548;
 Thu, 18 Nov 2021 14:00:19 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-3-reijiw@google.com>
 <dad16d0f-a0fa-cd8e-fdd0-0bbdf38af791@redhat.com>
In-Reply-To: <dad16d0f-a0fa-cd8e-fdd0-0bbdf38af791@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 18 Nov 2021 14:00:03 -0800
Message-ID: <CAAeT=FyUjwJDLw=6u_ocgQ_974+vD4w0n2=WCYXLsH4cf+dxOw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Nov 18, 2021 at 12:37 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> >  2 files changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index edbe2cb21947..72db73c79403 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
> >       u64 disr_el1;           /* Deferred [SError] Status Register */
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > +
> >  enum vcpu_sysreg {
> >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> >       /* Memory Tagging Extension registers */
> >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> >       GCR_EL1,        /* Tag Control Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e3ec1a44f94d..5608d3410660 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -33,6 +33,8 @@
> >
> >  #include "trace.h"
> >
> > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> > +
> >  /*
> >   * All of this file is extremely similar to the ARM coproc.c, but the
> >   * types are different. My gut feeling is that it should be pretty
> > @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >       u32 sr = reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > -             struct sys_reg_desc const *r, bool raz)
> > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> > -     u32 id = reg_to_encoding(r);
> > -     u64 val;
> > -
> > -     if (raz)
> > -             return 0;
> > -
> > -     val = read_sanitised_ftr_reg(id);
> > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >       return val;
> >  }
> >
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > +                    struct sys_reg_desc const *r, bool raz)
> > +{
> > +     u32 id = reg_to_encoding(r);
> > +
> > +     return raz ? 0 : __read_id_reg(vcpu, id);
> > +}
> > +
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >                                 const struct sys_reg_desc *r)
> >  {
> > @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> > +{
> > +     u32 id = reg_to_encoding(rd);
> > +
> > +     if (vcpu_has_reset_once(vcpu))
> > +             return;
> > +
> > +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> > +}
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              const struct kvm_one_reg *reg, void __user *uaddr)
> > @@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > - * For now, these registers are immutable for userspace, so no values
> > - * are stored, and for set_id_reg() we don't allow the effective value
> > - * to be changed.
> > + * We don't allow the effective value to be changed.
> This change may be moved to a subsequent patch as this patch does not
> change the behavior yet.

Thank you for the review.

There are three main parts in the original comments.

 (A) these registers are immutable for userspace
 (B) no values are stored
 (C) we don't allow the effective value to be changed

This patch stores ID register values in sys_regs[].
So, I don't think (B) should be there, and I removed (B).
Since (A) is essentially the same as (C), I removed (A)
(and left (C)).

Do you think it is better to leave (A) in this patch, too ?

Thanks,
Reiji


> >   */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > @@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> >  #define ID_SANITISED(name) {                 \
> >       SYS_DESC(SYS_##name),                   \
> >       .access = access_id_reg,                \
> > +     .reset  = reset_id_reg,                 \
> >       .get_user = get_id_reg,                 \
> >       .set_user = set_id_reg,                 \
> >       .visibility = id_visibility,            \
> > @@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > +             u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> >               u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
> >
> >               p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> >
> Thanks
>
> Eric
>
