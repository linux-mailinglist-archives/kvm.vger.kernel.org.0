Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7363D4681DA
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 02:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384030AbhLDBsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 20:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhLDBsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 20:48:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED5DC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 17:45:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h24so3628532pjq.2
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 17:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXTzVRcw9Wcwwdztj7ycV2R24Ap1tLHxOwWtA8nBtu4=;
        b=N8rFgPSo1jS+9dpaBkCHo9OU/mVjpmC/mkf5e9KAfbkfbq5Z0GTwb+3JM5uvhKYXNn
         +xnyHgYhWPhaQjbPfn2Y5/vR+66rw+67ctziQAAUcIjDHecBWZFesDdzyZH+BqiYOCNE
         lgVy1ZWNwNimWDN2QGT1W0zDB+xJJbiVPfEWmsOMiX5Z1x0rLH3e0UxMt/VLJtrjlJVq
         omj2bRFF5uHeoaVw5LUek1giCIHm6Wt0KZ56+hSOwwegTEz8uVwg8PwMj8q9RfswYkWM
         b7gVe3pikIzXfbcPA/P+L5/dWamr3NTiV8zNqTGfkA2dllKnskyagjHquocyuMseg7Lz
         hFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXTzVRcw9Wcwwdztj7ycV2R24Ap1tLHxOwWtA8nBtu4=;
        b=So0ZIZ+0V+su4Pm7uBMnmaADfQHI7yRrW4wzLUlH6Nl5NYnEoWRV1bpOXCynThAcze
         hlaOxShmKh5hUtv9HCssSVKIhiCRzXL3Sn3Ag9nD3CQq59+vGsNFVUNXaLnvkmDZLpGY
         Q7v989AgBugQUOWmy0djkivoNfoYOzHggtv1sByOzB5n2BcmIbAyW8KzGZgrYku/H5At
         UACnw34a8r+aWMVx6iyA5ltu3y/YNjRW3VvWDX3bo8PH6fGghmg14KXj1nQXXXv7jDmD
         Q0PtAgLaCJoOn4QHV4sCg94Z6WLH1brE1fdav6hSYWG4zxOonTWtHEfVNgAT3Abiusqc
         fYyw==
X-Gm-Message-State: AOAM5334/O0KOdvO0ZZMnxbtcaJQiMZMsaDDBG79rdIzfPNdP9+Ne3Zj
        Edz2X67Xsr0m5iJz4BjZSPsvgdpIfEc8yjgqj6aFe2iLIPI2Lg==
X-Google-Smtp-Source: ABdhPJz2IUDlxxiRRkbEoPCrybD1Jv6gpGOY8yPLvsLq5k7V+X1aQy6qCI+dDsC/JKM597UuEd0MEuYgfHKaMXQnW3s=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr18758356pjb.110.1638582318230;
 Fri, 03 Dec 2021 17:45:18 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-3-reijiw@google.com>
 <9f6e8b7e-c2b3-5883-f934-5b537c4ce19b@redhat.com>
In-Reply-To: <9f6e8b7e-c2b3-5883-f934-5b537c4ce19b@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 3 Dec 2021 17:45:02 -0800
Message-ID: <CAAeT=Fw+zW+CDnye+XzokmQtQYBfzrEEfLr=78UfFQZsQb_wuA@mail.gmail.com>
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

On Thu, Dec 2, 2021 at 2:58 AM Eric Auger <eauger@redhat.com> wrote:
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
> The KVM API allows to call VCPU_INIT several times (with same
> target/feature). With above check on the second call the ID_REGS won't
> be reset. Somehow this is aligned with target/feature behavior. However
> if this is what we want, I think we would need to document it in the KVM
> API doc.

Thank you for the comment.

That is what we want.  Since ID registers are read only registers,
their values must not change across the reset.

'4.82 KVM_ARM_VCPU_INIT' in api.rst says:

  System registers: Reset to their architecturally defined
  values as for a warm reset to EL1 (resp. SVC)

Since this reset behavior for the ID registers follows what is
described above, I'm not sure if we need to document the reset
behavior of the ID registers specifically.
If KVM changes the values across the resets, I would think it
rather needs to be documented though.

Thanks,
Reiji
