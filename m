Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD574667EA9
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbjALTGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbjALTFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:05:33 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001105F8D
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:47:24 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id f3so13401635pgc.2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FvDS6hSylsd6ESRqV5AwmYjERDlCAeBCt2posT5P68o=;
        b=G+p8OOgksB0HPT1AraUCRCOVKgM1HWs+6AFhho29DRw3eoIBNZKvlmP0+yE4k9gML+
         Losi9Shd5JJtpc3JSk6CXdZ//hFVnLKAhi7fk4KLELNN4IYvXELGDwR95A5sa1Q7QWrc
         rAs66N7LqrLRStSlepBo25uIcKW+/KNc9KeVgj6fSjNbfKqvxN2wmcdtCi2G7OhOBeKM
         N2GuKgypAwxakzDx21j0KP0ryTje6l53v1j/5iIkxxH//wI13qhG9WDyDoqAQlKD/O4K
         hEWWltRqGQv9DsiS6LDUDv4U+8GhXEyrl+o0QIldvg/ETfWrRjyJBfURSOjtEgJ+QqBw
         JU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FvDS6hSylsd6ESRqV5AwmYjERDlCAeBCt2posT5P68o=;
        b=zyWYZPh6RfHABBATsPN7SGaJmm8sl1EV9A2neb55zPo7/0FIbHFKlFhS98iTOe04T1
         ++J+tdLdxWeiPQFAx6fte9gwGHBnQxicdT18p3t+cJY3jPbJs4HhikYd2ZWw43A+OBwB
         8RB0QNvdIOLNanGmyoBQE6h0v3LFPZOmCkbbbql2hpmaF7Nj7jgnaropoDVjX+I52rW+
         gLZ5pnzazE6POtWTnn7dXTLI6wT5YiTgo8B4+eFK3OVXFWOUD33cTk7T0D5wfMd1pKqy
         LmEsFX6G2bfask073Vg4YLvaOmKrddkbxzHBhp5SyDRWbznnPMyP/vFB/J+aDzRzAdy8
         yygg==
X-Gm-Message-State: AFqh2kqNQ3c/kYgOheOs2oM/WzSEbaxycquhb1qOM35iWBvXObFYqNv8
        F+Y2JKfrxzY5sdWu1jSOccz+ee0Mm96rwzZQb5KQ3Q==
X-Google-Smtp-Source: AMrXdXs90D2Pih4HSpfMuCdFmhDKcip5iUGj/pcgzGOEnId42Oh0jYlXBLk5cps8xFsvo/RsWGCkabP70PPHkR+0Sy8=
X-Received: by 2002:a63:104f:0:b0:4ac:d14e:2d01 with SMTP id
 15-20020a63104f000000b004acd14e2d01mr1383509pgq.595.1673549244339; Thu, 12
 Jan 2023 10:47:24 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-5-atishp@rivosinc.com>
 <20230112110444.jjbmgslr6dspxwbh@orel>
In-Reply-To: <20230112110444.jjbmgslr6dspxwbh@orel>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 12 Jan 2023 10:47:13 -0800
Message-ID: <CAHBxVyEyMdk+vQ5wTgOF56UJs-zLtkVixDxXquTjoLyV6Vj21Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] RISC-V: KVM: Modify SBI extension handler to
 return SBI error code
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 3:04 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Dec 15, 2022 at 09:00:39AM -0800, Atish Patra wrote:
> > Currently, the SBI extension handle is expected to return Linux error code.
>
> handler
>
> > The top SBI layer converts the Linux error code to SBI specific error code
> > that can be returned to guest invoking the SBI calls. This model works
> > as long as SBI error codes have 1-to-1 mappings between them.
>
> as long as SBI and Linux error codes have 1-to-1...
>
> > However, that may not be true always. This patch attempts to disassociate
> > both these error codes by allowing the SBI extension implementation to
> > return SBI specific error codes as well.
> >
> > The extension will continue to return the Linux error specific code which
> > will indicate any problem *with* the extension emulation while the
> > SBI specific error will indicate the problem *of* the emulation.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 10 ++++--
> >  arch/riscv/kvm/vcpu_sbi.c             | 45 ++++++++-------------------
> >  arch/riscv/kvm/vcpu_sbi_base.c        | 38 +++++++++++-----------
> >  arch/riscv/kvm/vcpu_sbi_hsm.c         | 22 +++++++------
> >  arch/riscv/kvm/vcpu_sbi_replace.c     | 44 +++++++++++++-------------
> >  5 files changed, 74 insertions(+), 85 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > index 61dac1b..fee9253 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > @@ -18,6 +18,12 @@ struct kvm_vcpu_sbi_context {
> >       int return_handled;
> >  };
> >
> > +struct kvm_vcpu_sbi_ext_data {
> > +     unsigned long out_val;
> > +     unsigned long err_val;
> > +     bool uexit;
> > +};
> > +
> >  struct kvm_vcpu_sbi_extension {
> >       unsigned long extid_start;
> >       unsigned long extid_end;
> > @@ -27,8 +33,8 @@ struct kvm_vcpu_sbi_extension {
> >        * specific error codes.
> >        */
> >       int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                    unsigned long *out_val, struct kvm_cpu_trap *utrap,
> > -                    bool *exit);
> > +                    struct kvm_vcpu_sbi_ext_data *edata,
> > +                    struct kvm_cpu_trap *utrap);
> >
> >       /* Extension specific probe function */
> >       unsigned long (*probe)(struct kvm_vcpu *vcpu, unsigned long extid);
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index f96991d..50c5472 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -12,26 +12,6 @@
> >  #include <asm/sbi.h>
> >  #include <asm/kvm_vcpu_sbi.h>
> >
> > -static int kvm_linux_err_map_sbi(int err)
> > -{
> > -     switch (err) {
> > -     case 0:
> > -             return SBI_SUCCESS;
> > -     case -EPERM:
> > -             return SBI_ERR_DENIED;
> > -     case -EINVAL:
> > -             return SBI_ERR_INVALID_PARAM;
> > -     case -EFAULT:
> > -             return SBI_ERR_INVALID_ADDRESS;
> > -     case -EOPNOTSUPP:
> > -             return SBI_ERR_NOT_SUPPORTED;
> > -     case -EALREADY:
> > -             return SBI_ERR_ALREADY_AVAILABLE;
> > -     default:
> > -             return SBI_ERR_FAILURE;
> > -     };
> > -}
> > -
> >  #ifndef CONFIG_RISCV_SBI_V01
> >  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> >       .extid_start = -1UL,
> > @@ -125,11 +105,10 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >       int ret = 1;
> >       bool next_sepc = true;
> > -     bool userspace_exit = false;
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >       const struct kvm_vcpu_sbi_extension *sbi_ext;
> >       struct kvm_cpu_trap utrap = { 0 };
> > -     unsigned long out_val = 0;
> > +     struct kvm_vcpu_sbi_ext_data edata_out = { 0 };
> >       bool ext_is_v01 = false;
> >
> >       sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> > @@ -139,7 +118,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >                   cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
> >                       ext_is_v01 = true;
> >  #endif
> > -             ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> > +             ret = sbi_ext->handler(vcpu, run, &edata_out, &utrap);
> >       } else {
> >               /* Return error for unsupported SBI calls */
> >               cp->a0 = SBI_ERR_NOT_SUPPORTED;
> > @@ -156,25 +135,27 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >               goto ecall_done;
> >       }
> >
> > +     /* The SBI extension returns Linux error code. Exits the ioctl loop
>
> Need opening /* wing
>
> And for wording, maybe
>
>  When the SBI extension returns a Linux error code, it exist the ioctl
>  loop and forwards the error to userspace.
>

Sure.

> > +      * and forwards the error to the userspace.
> > +      */
> > +     if (ret < 0) {
> > +             next_sepc = false;
> > +             goto ecall_done;
> > +     }
>
> Shouldn't this ret < 0 check go above the "Handle special error cases..."
> block?
>

Why ? I thought if an extension handler has both utrap updated and
returns an error,
user space redirection should take precedence. Let me know if it is wrong.

Currently, only legacy SBI extension handler uses utrap for unpriv reads.
So I don't feel strongly about it either. Just wanted to understand
your reasonings.

> > +
> >       /* Exit ioctl loop or Propagate the error code the guest */
> > -     if (userspace_exit) {
> > +     if (edata_out.uexit) {
> >               next_sepc = false;
> >               ret = 0;
> >       } else {
> > -             /**
> > -              * SBI extension handler always returns an Linux error code. Convert
> > -              * it to the SBI specific error code that can be propagated the SBI
> > -              * caller.
> > -              */
> > -             ret = kvm_linux_err_map_sbi(ret);
> > -             cp->a0 = ret;
> > +             cp->a0 = edata_out.err_val;
> >               ret = 1;
> >       }
> >  ecall_done:
> >       if (next_sepc)
> >               cp->sepc += 4;
> >       if (!ext_is_v01)
> > -             cp->a1 = out_val;
> > +             cp->a1 = edata_out.out_val;
> >
> >       return ret;
> >  }
> > diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> > index 89e2415..487828d 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_base.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> > @@ -14,24 +14,23 @@
> >  #include <asm/kvm_vcpu_sbi.h>
> >
> >  static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                                 unsigned long *out_val,
> > -                                 struct kvm_cpu_trap *trap, bool *exit)
> > +                                 struct kvm_vcpu_sbi_ext_data *edata,
> > +                                 struct kvm_cpu_trap *trap)
> >  {
> > -     int ret = 0;
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >       const struct kvm_vcpu_sbi_extension *sbi_ext;
> >
> >       switch (cp->a6) {
> >       case SBI_EXT_BASE_GET_SPEC_VERSION:
> > -             *out_val = (KVM_SBI_VERSION_MAJOR <<
> > +             edata->out_val = (KVM_SBI_VERSION_MAJOR <<
> >                           SBI_SPEC_VERSION_MAJOR_SHIFT) |
> >                           KVM_SBI_VERSION_MINOR;
> >               break;
> >       case SBI_EXT_BASE_GET_IMP_ID:
> > -             *out_val = KVM_SBI_IMPID;
> > +             edata->out_val = KVM_SBI_IMPID;
> >               break;
> >       case SBI_EXT_BASE_GET_IMP_VERSION:
> > -             *out_val = LINUX_VERSION_CODE;
> > +             edata->out_val = LINUX_VERSION_CODE;
> >               break;
> >       case SBI_EXT_BASE_PROBE_EXT:
> >               if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
> > @@ -43,33 +42,33 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                        * forward it to the userspace
> >                        */
> >                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > -                     *exit = true;
> > +                     edata->uexit = true;
> >               } else {
> >                       sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> >                       if (sbi_ext) {
> >                               if (sbi_ext->probe)
> > -                                     *out_val = sbi_ext->probe(vcpu, cp->a0);
> > +                                     edata->out_val = sbi_ext->probe(vcpu, cp->a0);
> >                               else
> > -                                     *out_val = 1;
> > +                                     edata->out_val = 1;
> >                       } else
> > -                             *out_val = 0;
> > +                             edata->out_val = 0;
> >               }
> >               break;
> >       case SBI_EXT_BASE_GET_MVENDORID:
> > -             *out_val = vcpu->arch.mvendorid;
> > +             edata->out_val = vcpu->arch.mvendorid;
> >               break;
> >       case SBI_EXT_BASE_GET_MARCHID:
> > -             *out_val = vcpu->arch.marchid;
> > +             edata->out_val = vcpu->arch.marchid;
> >               break;
> >       case SBI_EXT_BASE_GET_MIMPID:
> > -             *out_val = vcpu->arch.mimpid;
> > +             edata->out_val = vcpu->arch.mimpid;
> >               break;
> >       default:
> > -             ret = -EOPNOTSUPP;
> > +             edata->err_val = SBI_ERR_NOT_SUPPORTED;
> >               break;
> >       }
> >
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> > @@ -79,17 +78,16 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> >  };
> >
> >  static int kvm_sbi_ext_forward_handler(struct kvm_vcpu *vcpu,
> > -                                     struct kvm_run *run,
> > -                                     unsigned long *out_val,
> > -                                     struct kvm_cpu_trap *utrap,
> > -                                     bool *exit)
> > +                                    struct kvm_run *run,
> > +                                    struct kvm_vcpu_sbi_ext_data *edata,
> > +                                    struct kvm_cpu_trap *utrap)
> >  {
> >       /*
> >        * Both SBI experimental and vendor extensions are
> >        * unconditionally forwarded to userspace.
> >        */
> >       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> > -     *exit = true;
> > +     edata->uexit = true;
> >       return 0;
> >  }
> >
> > diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> > index 0f8d9fe..4188f21 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> > @@ -21,9 +21,9 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
> >
> >       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
> >       if (!target_vcpu)
> > -             return -EINVAL;
> > +             return SBI_ERR_INVALID_PARAM;
> >       if (!target_vcpu->arch.power_off)
> > -             return -EALREADY;
> > +             return SBI_ERR_ALREADY_AVAILABLE;
> >
> >       reset_cntx = &target_vcpu->arch.guest_reset_context;
> >       /* start address */
> > @@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
> >  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
> >  {
> >       if (vcpu->arch.power_off)
> > -             return -EPERM;
> > +             return SBI_ERR_FAILURE;
>
> -EPERM shouldn't map to SBI_ERR_FAILURE, but this should be addressed in
> the previous patch.
>
> >
> >       kvm_riscv_vcpu_power_off(vcpu);
> >
> > @@ -57,7 +57,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
> >
> >       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
> >       if (!target_vcpu)
> > -             return -EINVAL;
> > +             return SBI_ERR_INVALID_PARAM;
> >       if (!target_vcpu->arch.power_off)
> >               return SBI_HSM_STATE_STARTED;
> >       else if (vcpu->stat.generic.blocking)
> > @@ -66,10 +66,10 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
> >               return SBI_HSM_STATE_STOPPED;
> >  }
> >
> > +
>
> stray new blank line
>

Fixed.

> >  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                                unsigned long *out_val,
> > -                                struct kvm_cpu_trap *utrap,
> > -                                bool *exit)
> > +                                struct kvm_vcpu_sbi_ext_data *edata,
> > +                                struct kvm_cpu_trap *utrap)
> >  {
> >       int ret = 0;
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > @@ -88,8 +88,8 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >       case SBI_EXT_HSM_HART_STATUS:
> >               ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
> >               if (ret >= 0) {
> > -                     *out_val = ret;
> > -                     ret = 0;
> > +                     edata->out_val = ret;
> > +                     edata->err_val = 0;
>
> We want a 'return 0;' here. Otherwise below we write ret to err_val.
>

Ahh yes. Thanks for catching that. Will fix it.

> >               }
> >               break;
> >       case SBI_EXT_HSM_HART_SUSPEND:
> > @@ -108,7 +108,9 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >               ret = -EOPNOTSUPP;
>
> This ret = -EOPNOTSUPP in the context and two others above it need to be
> converted to SBI errors.
>

Will do. Thanks.

> >       }
> >
> > -     return ret;
> > +     edata->err_val = ret;
> > +
> > +     return 0;
> >  }
> >
> >  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
> > diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> > index 03a0198..d029136 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> > @@ -14,15 +14,17 @@
> >  #include <asm/kvm_vcpu_sbi.h>
> >
> >  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                                 unsigned long *out_val,
> > -                                 struct kvm_cpu_trap *utrap, bool *exit)
> > +                                 struct kvm_vcpu_sbi_ext_data *edata,
> > +                                 struct kvm_cpu_trap *utrap)
> >  {
> >       int ret = 0;
>
> ret is only used at the bottom to return 0. We can drop the variable and
> change it to an explicit zero.
>

Sure.

> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >       u64 next_cycle;
> >
> > -     if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
> > -             return -EINVAL;
> > +     if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
> > +             edata->err_val = SBI_ERR_INVALID_PARAM;
> > +             return 0;
> > +     }
> >
> >  #if __riscv_xlen == 32
> >       next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> > @@ -41,8 +43,8 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
> >  };
> >
> >  static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                                unsigned long *out_val,
> > -                                struct kvm_cpu_trap *utrap, bool *exit)
> > +                                struct kvm_vcpu_sbi_ext_data *edata,
> > +                                struct kvm_cpu_trap *utrap)
> >  {
> >       int ret = 0;
> >       unsigned long i;
> > @@ -51,8 +53,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >       unsigned long hmask = cp->a0;
> >       unsigned long hbase = cp->a1;
> >
> > -     if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
> > -             return -EINVAL;
> > +     if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
> > +             edata->err_val = SBI_ERR_INVALID_PARAM;
> > +             return 0;
> > +     }
> >
> >       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> >               if (hbase != -1UL) {
> > @@ -76,10 +80,9 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
> >  };
> >
> >  static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > -                                   unsigned long *out_val,
> > -                                   struct kvm_cpu_trap *utrap, bool *exit)
> > +                                   struct kvm_vcpu_sbi_ext_data *edata,
> > +                                   struct kvm_cpu_trap *utrap)
> >  {
> > -     int ret = 0;
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >       unsigned long hmask = cp->a0;
> >       unsigned long hbase = cp->a1;
> > @@ -116,10 +119,10 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
> >                */
> >               break;
> >       default:
> > -             ret = -EOPNOTSUPP;
> > +             edata->err_val = SBI_ERR_NOT_SUPPORTED;
> >       }
> >
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> > @@ -130,14 +133,13 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> >
> >  static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
> >                                   struct kvm_run *run,
> > -                                 unsigned long *out_val,
> > -                                 struct kvm_cpu_trap *utrap, bool *exit)
> > +                                 struct kvm_vcpu_sbi_ext_data *edata,
> > +                                 struct kvm_cpu_trap *utrap)
> >  {
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >       unsigned long funcid = cp->a6;
> >       u32 reason = cp->a1;
> >       u32 type = cp->a0;
> > -     int ret = 0;
> >
> >       switch (funcid) {
> >       case SBI_EXT_SRST_RESET:
> > @@ -146,24 +148,24 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
> >                       kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
> >                                               KVM_SYSTEM_EVENT_SHUTDOWN,
> >                                               reason);
> > -                     *exit = true;
> > +                     edata->uexit = true;
> >                       break;
> >               case SBI_SRST_RESET_TYPE_COLD_REBOOT:
> >               case SBI_SRST_RESET_TYPE_WARM_REBOOT:
> >                       kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
> >                                               KVM_SYSTEM_EVENT_RESET,
> >                                               reason);
> > -                     *exit = true;
> > +                     edata->uexit = true;
> >                       break;
> >               default:
> > -                     ret = -EOPNOTSUPP;
> > +                     edata->err_val = SBI_ERR_NOT_SUPPORTED;
> >               }
> >               break;
> >       default:
> > -             ret = -EOPNOTSUPP;
> > +             edata->err_val = SBI_ERR_NOT_SUPPORTED;
> >       }
> >
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
> > --
> > 2.25.1
> >
>
> Thanks,
> drew
