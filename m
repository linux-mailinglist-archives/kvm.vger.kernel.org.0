Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2524A00D5
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 20:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbiA1T1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 14:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiA1T1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 14:27:35 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE5FC061714
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 11:27:35 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j23so11807175edp.5
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 11:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGi3kvUTWLMlTMsLo7Uiwt0VLKLoGeVNXRBhLXdxbYg=;
        b=BAoRGYHWM81Tqy6/WtRLJ3S5YhFVToMahxbexRpQVvAPy5/dCikD2CLI8dv5yTq++X
         Xh8B8zeMXAVtSz3qSb3/pGtVoHlr3A4Cu1iE+pkSif7kzmRQgG6xaMuAOowwhqcPT0aS
         1ltQQOfNhQ0TUZA6D+5JylaeODzyKbHjoacKbq/uycdasxcsvf1xyvPYFHAf9YZvWkaU
         iFPmhOLuoVTMXejz4bvjiFOaz78K7mr212QySlMcTzNHNj9c16P1iPFRLtHY1UyVzb5c
         GvQ3mYQ8nZHtd2XYUpZXEAANSNvuVroWdMzNan90UAOSy/2NDEiYUZXbReiWZH4Jo0qW
         Cokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGi3kvUTWLMlTMsLo7Uiwt0VLKLoGeVNXRBhLXdxbYg=;
        b=idHLPmEOkivw85g+Lzz+SnKA7BN/Ny6Fn+jN83h2hog6Qsdd93SQ9W+wyFaDwf9ZHx
         Z1GLrqDL0TXavZc9693ip4k871ZOahldxVBOPmsKdRiIoiPl1xarNwDEoLCNshwelCxL
         3mibwqPTxrzc66FiH2iUAp+tQads58NSrcHyI583wv7gmpVbS6G9h1m7C0xd4Lz2XnI/
         IFG/DyiHoplLXjFMpMQTVMhGbzy1qTi2mhqN4TqwktTTEQoBX2B8wG7aSt4SCVj2YZ1t
         /hj8UrYtTuuTTjo9KObpUwgLFO4NYliEe98tNUxy4qYhBkd1WDon600szJq1MQgy+9xv
         ytIg==
X-Gm-Message-State: AOAM530YmvJnbhSejCyaV8U5w5sJAituWIwIrazSMGz1XwQRhNi+IqZn
        Flc2tmN28+HWjUpse+X4cdvMUYCHNB3L4GuXaE8KRw==
X-Google-Smtp-Source: ABdhPJwfca8B8rOhxbI8lwoElPyVVie0Abri7eCEDHDUIBYUY2U55XJiRS0ZLuT8wvnSUDk5afJL5gn1VvdwooEJ2uk=
X-Received: by 2002:aa7:cd08:: with SMTP id b8mr9312715edw.265.1643398053850;
 Fri, 28 Jan 2022 11:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com> <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
In-Reply-To: <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Fri, 28 Jan 2022 11:27:21 -0800
Message-ID: <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 10:24 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Ricardo,
>
> On Tue, Jan 25, 2022 at 9:22 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Wed, Jan 05, 2022 at 08:26:44PM -0800, Reiji Watanabe wrote:
> > > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > > Use the saved ones when ID registers are read by the guest or
> > > userspace (via KVM_GET_ONE_REG).
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 16 ++++++++
> > >  arch/arm64/kvm/arm.c              |  1 +
> > >  arch/arm64/kvm/sys_regs.c         | 62 ++++++++++++++++++++++---------
> > >  3 files changed, 62 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 2a5f7f38006f..c789a0137f58 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -102,6 +102,17 @@ struct kvm_s2_mmu {
> > >  struct kvm_arch_memory_slot {
> > >  };
> > >
> > > +/*
> > > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > > + * where 0<=crm<8, 0<=op2<8.
> >
> > Is this observation based on this table?
> >
> > Table D12-2 System instruction encodings for non-Debug System register accesses
> > in that case, it seems that the ID registers list might grow after
> > crm=7, and as CRm has 4 bits, why not 16*8=128?
>
> This is basically for registers that are already reserved as RAZ in the
> table (sys_reg_descs[] has entries for the reserved ones as well).
> Registers with crm > 7 are not reserved yet, and that will be expanded
> later as needed later.
>
>
> >
> > > + */
> > > +#define KVM_ARM_ID_REG_MAX_NUM       64
> > > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > +#define is_id_reg(id)        \
> > > +     (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&        \
> > > +      sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&        \
> > > +      sys_reg_CRm(id) < 8)
> > > +
> > >  struct kvm_arch {
> > >       struct kvm_s2_mmu mmu;
> > >
> > > @@ -137,6 +148,9 @@ struct kvm_arch {
> > >
> > >       /* Memory Tagging Extension enabled for the guest */
> > >       bool mte_enabled;
> > > +
> > > +     /* ID registers for the guest. */
> > > +     u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > >  };
> > >
> > >  struct kvm_vcpu_fault_info {
> > > @@ -734,6 +748,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> > >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> > >                               struct kvm_arm_copy_mte_tags *copy_tags);
> > >
> > > +void set_default_id_regs(struct kvm *kvm);
> > > +
> > >  /* Guest/host FPSIMD coordination helpers */
> > >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index e4727dc771bf..5f497a0af254 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >       kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> > >
> > >       set_default_spectre(kvm);
> > > +     set_default_id_regs(kvm);
> > >
> > >       return ret;
> > >  out_free_stage2_pgd:
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index e3ec1a44f94d..80dc62f98ef0 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -33,6 +33,8 @@
> > >
> > >  #include "trace.h"
> > >
> > > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> > > +
> > >  /*
> > >   * All of this file is extremely similar to the ARM coproc.c, but the
> > >   * types are different. My gut feeling is that it should be pretty
> > > @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> > >                         struct sys_reg_params *p,
> > >                         const struct sys_reg_desc *r)
> > >  {
> > > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > +     u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> > >       u32 sr = reg_to_encoding(r);
> > >
> > >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > > @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> > >       return true;
> > >  }
> > >
> > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > > -             struct sys_reg_desc const *r, bool raz)
> > > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > >  {
> > > -     u32 id = reg_to_encoding(r);
> > > -     u64 val;
> > > -
> > > -     if (raz)
> > > -             return 0;
> > > -
> > > -     val = read_sanitised_ftr_reg(id);
> > > +     u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
> > >
> > >       switch (id) {
> > >       case SYS_ID_AA64PFR0_EL1:
> > > @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > >       return val;
> > >  }
> > >
> > > +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > > +                    struct sys_reg_desc const *r, bool raz)
> > > +{
> > > +     u32 id = reg_to_encoding(r);
> > > +
> > > +     return raz ? 0 : __read_id_reg(vcpu, id);
> > > +}
> > > +
> > >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > >                                 const struct sys_reg_desc *r)
> > >  {
> > > @@ -1223,9 +1225,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >  /*
> > >   * cpufeature ID register user accessors
> > >   *
> > > - * For now, these registers are immutable for userspace, so no values
> > > - * are stored, and for set_id_reg() we don't allow the effective value
> > > - * to be changed.
> > > + * For now, these registers are immutable for userspace, so for set_id_reg()
> > > + * we don't allow the effective value to be changed.
> > >   */
> > >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> > >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > > @@ -1237,7 +1238,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
> > >       return reg_to_user(uaddr, &val, id);
> > >  }
> > >
> > > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > > +static int __set_id_reg(struct kvm_vcpu *vcpu,
> > >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > >                       bool raz)
> > >  {
> > > @@ -1837,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> > >       if (p->is_write) {
> > >               return ignore_write(vcpu, p);
> > >       } else {
> > > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > > +             u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > > +             u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> > >               u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
> > >
> > >               p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> > > @@ -2850,3 +2851,30 @@ void kvm_sys_reg_table_init(void)
> > >       /* Clear all higher bits. */
> > >       cache_levels &= (1 << (i*3))-1;
> > >  }
> > > +
> > > +/*
> > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > + * with ID_SANITISED() to the host's sanitized value.
> > > + */
> > > +void set_default_id_regs(struct kvm *kvm)
> > > +{
> > > +     int i;
> > > +     u32 id;
> > > +     const struct sys_reg_desc *rd;
> > > +     u64 val;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > +             rd = &sys_reg_descs[i];
> > > +             if (rd->access != access_id_reg)
> > > +                     /* Not ID register, or hidden/reserved ID register */
> > > +                     continue;
> > > +
> > > +             id = reg_to_encoding(rd);
> > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > +                     /* Shouldn't happen */
> > > +                     continue;
> > > +
> > > +             val = read_sanitised_ftr_reg(id);
> >
> > I'm a bit confused. Shouldn't the default+sanitized values already use
> > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
>
> I'm not sure if I understand your question.
> arm64_ftr_bits_kvm is used for feature support checkings when
> userspace tries to modify a value of ID registers.
> With this patch, KVM just saves the sanitized values in the kvm's
> buffer, but userspace is still not allowed to modify values of ID
> registers yet.
> I hope it answers your question.

Based on the previous commit I was assuming that some registers, like
id_aa64dfr0,
would default to the overwritten values as the sanitized values. More
specifically: if
userspace doesn't modify any ID reg, shouldn't the defaults have the
KVM overwritten
values (arm64_ftr_bits_kvm)?

>
> Thanks,
> Reiji
>
> >
> > > +             kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > > +     }
> > > +}
> > > --
> > > 2.34.1.448.ga2b2bfdf31-goog
> > >
