Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56067FED4
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjA2MQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjA2MQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:16:48 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A821ADDE
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:16:42 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n6so5879544edo.9
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jVVJmYjV4WbauYiI6oOanAdhcw6dcBjZj3Q2soKxHyA=;
        b=SK0OtpP5qtVA5a35VOuXFGVOkialxjRN77UtsswV8Iay9z9tCGxtxKC6tMzRYOVDNk
         Z5VFH83jM7d/DbKH0622VNpLnU82dGt4FGG2jeZECBVoYUMcA9nd97YhJNjicXtEOBsN
         e+XtNqevi6ufeRw9v6NcCs6VV2cOtQ8oR/FkJA236Y/S1DCU9pYNj9SPnIli4f9gf28s
         5fiRJPuQfWsv2JuCzzhFgC2xCvqrGA9b4oTx1pSEFuwfytHsZBaGLgxqEcT/xL0f+vuk
         SqNKGAN6Y4oVfpPSXdggy9A/r85aZO/tA8I5azwn4lnyAWOQkZoCKtlEfeoSAY/5x5xp
         2Cdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jVVJmYjV4WbauYiI6oOanAdhcw6dcBjZj3Q2soKxHyA=;
        b=QKlZ2CQnwkDd22L3uPZa1AWvQuy6DQXVHcIF3uPmKMkE8SQhklAqPJW+fHLVDUZYHX
         u+4D6Q55y4OZIC7glNmQmS7LAuNfUkbBApmENrIS44O6IHmNcfUMvyQ9PLKU37OnG0oo
         nemBOf7ocRPhvoWyD2UNvbMP0qjMtNX3QV62Di3O3/g2zred/9Wr+RBNcoVoH2zW2nwE
         lBCA4CJ04ACFogtuIXRWGNGF5ESkF+NAVDXe7BtKT5p4WPBa8k+b6TjY7WNY3mkn8wPg
         iahpvydK5hhI7tqrdXcYf6FfjfBAtgTqJi0mL64TUnynHSo9K4oEZ2HEW/Qx/k93K9i/
         Zozg==
X-Gm-Message-State: AFqh2kq/iCVxFiQS74Xzqp6vU90EC2pbIGLHBe1PrvrNoLL2KFtwcNFC
        de4XcQk00uJRGji1jY7M84H/IVUW+Nc/Md3qdA10DA==
X-Google-Smtp-Source: AMrXdXt/BSTLA8xCz/vQc0zP7q2wsYk9fw/Z2XCQ+GWcIGFOBmWoaUyGuq812PrAepVxnYr4phBXi8P3BSnIE9pmJ3s=
X-Received: by 2002:a05:6402:4494:b0:49e:89e:c7b4 with SMTP id
 er20-20020a056402449400b0049e089ec7b4mr7535678edb.1.1674994600772; Sun, 29
 Jan 2023 04:16:40 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-7-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-7-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 17:46:29 +0530
Message-ID: <CAAhSdy2F_RwgTy8geVmWeJrw7TWu5tjDXRzTP8meD49fD7_nUA@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] RISC-V: KVM: Modify SBI extension handler to
 return SBI error code
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> Currently, the SBI extension handle is expected to return Linux error code.
> The top SBI layer converts the Linux error code to SBI specific error code
> that can be returned to guest invoking the SBI calls. This model works
> as long as SBI error codes have 1-to-1 mappings between them.
> However, that may not be true always. This patch attempts to disassociate
> both these error codes by allowing the SBI extension implementation to
> return SBI specific error codes as well.
>
> The extension will continue to return the Linux error specific code which
> will indicate any problem *with* the extension emulation while the
> SBI specific error will indicate the problem *of* the emulation.
>
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 10 ++++--
>  arch/riscv/kvm/vcpu_sbi.c             | 46 ++++++++------------------
>  arch/riscv/kvm/vcpu_sbi_base.c        | 38 ++++++++++------------
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 29 +++++++++--------
>  arch/riscv/kvm/vcpu_sbi_replace.c     | 47 ++++++++++++++-------------
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 11 +++----
>  6 files changed, 84 insertions(+), 97 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 45ba341..38407b3 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -18,6 +18,12 @@ struct kvm_vcpu_sbi_context {
>         int return_handled;
>  };
>
> +struct kvm_vcpu_sbi_ext_data {

s/kvm_vcpu_sbi_ext_data/kvm_vcpu_sbi_return/

> +       unsigned long out_val;
> +       unsigned long err_val;

Add "struct kvm_cpu_trap utrap" here.

> +       bool uexit;
> +};
> +
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
>         unsigned long extid_end;
> @@ -27,8 +33,8 @@ struct kvm_vcpu_sbi_extension {
>          * specific error codes.
>          */
>         int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                      unsigned long *out_val, struct kvm_cpu_trap *utrap,
> -                      bool *exit);
> +                      struct kvm_vcpu_sbi_ext_data *edata,
> +                      struct kvm_cpu_trap *utrap);
>
>         /* Extension specific probe function */
>         unsigned long (*probe)(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index f96991d..aa42da6 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -12,26 +12,6 @@
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
> -static int kvm_linux_err_map_sbi(int err)
> -{
> -       switch (err) {
> -       case 0:
> -               return SBI_SUCCESS;
> -       case -EPERM:
> -               return SBI_ERR_DENIED;
> -       case -EINVAL:
> -               return SBI_ERR_INVALID_PARAM;
> -       case -EFAULT:
> -               return SBI_ERR_INVALID_ADDRESS;
> -       case -EOPNOTSUPP:
> -               return SBI_ERR_NOT_SUPPORTED;
> -       case -EALREADY:
> -               return SBI_ERR_ALREADY_AVAILABLE;
> -       default:
> -               return SBI_ERR_FAILURE;
> -       };
> -}
> -
>  #ifndef CONFIG_RISCV_SBI_V01
>  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>         .extid_start = -1UL,
> @@ -125,11 +105,10 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>         int ret = 1;
>         bool next_sepc = true;
> -       bool userspace_exit = false;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         const struct kvm_vcpu_sbi_extension *sbi_ext;
>         struct kvm_cpu_trap utrap = { 0 };

Remove "struct kvm_cpu_trap utrap" from here since it can be
part of "struct kvm_vcpu_sbi_return"

> -       unsigned long out_val = 0;
> +       struct kvm_vcpu_sbi_ext_data edata_out = { 0 };
>         bool ext_is_v01 = false;
>
>         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> @@ -139,13 +118,22 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                     cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
>                         ext_is_v01 = true;
>  #endif
> -               ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> +               ret = sbi_ext->handler(vcpu, run, &edata_out, &utrap);
>         } else {
>                 /* Return error for unsupported SBI calls */
>                 cp->a0 = SBI_ERR_NOT_SUPPORTED;
>                 goto ecall_done;
>         }
>
> +       /*
> +        * When the SBI extension returns a Linux error code, it exits the ioctl
> +        * loop and forwards the error to userspace.
> +        */
> +       if (ret < 0) {
> +               next_sepc = false;
> +               goto ecall_done;
> +       }
> +
>         /* Handle special error cases i.e trap, exit or userspace forward */
>         if (utrap.scause) {
>                 /* No need to increment sepc or exit ioctl loop */
> @@ -157,24 +145,18 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>         }
>
>         /* Exit ioctl loop or Propagate the error code the guest */
> -       if (userspace_exit) {
> +       if (edata_out.uexit) {
>                 next_sepc = false;
>                 ret = 0;
>         } else {
> -               /**
> -                * SBI extension handler always returns an Linux error code. Convert
> -                * it to the SBI specific error code that can be propagated the SBI
> -                * caller.
> -                */
> -               ret = kvm_linux_err_map_sbi(ret);
> -               cp->a0 = ret;
> +               cp->a0 = edata_out.err_val;
>                 ret = 1;
>         }
>  ecall_done:
>         if (next_sepc)
>                 cp->sepc += 4;
>         if (!ext_is_v01)
> -               cp->a1 = out_val;
> +               cp->a1 = edata_out.out_val;

Strange! This now updates the "a1" register when ret < 0 which it should not.

Ideally, the "a1" register should be only updated when "ret == 1".

>
>         return ret;
>  }
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 846d518..84885e5 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -14,24 +14,23 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *trap, bool *exit)
> +                                   struct kvm_vcpu_sbi_ext_data *edata,
> +                                   struct kvm_cpu_trap *trap)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         const struct kvm_vcpu_sbi_extension *sbi_ext;
>
>         switch (cp->a6) {
>         case SBI_EXT_BASE_GET_SPEC_VERSION:
> -               *out_val = (KVM_SBI_VERSION_MAJOR <<
> +               edata->out_val = (KVM_SBI_VERSION_MAJOR <<
>                             SBI_SPEC_VERSION_MAJOR_SHIFT) |
>                             KVM_SBI_VERSION_MINOR;
>                 break;
>         case SBI_EXT_BASE_GET_IMP_ID:
> -               *out_val = KVM_SBI_IMPID;
> +               edata->out_val = KVM_SBI_IMPID;
>                 break;
>         case SBI_EXT_BASE_GET_IMP_VERSION:
> -               *out_val = LINUX_VERSION_CODE;
> +               edata->out_val = LINUX_VERSION_CODE;
>                 break;
>         case SBI_EXT_BASE_PROBE_EXT:
>                 if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
> @@ -43,33 +42,33 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                          * forward it to the userspace
>                          */
>                         kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -                       *exit = true;
> +                       edata->uexit = true;
>                 } else {
>                         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
>                         if (sbi_ext) {
>                                 if (sbi_ext->probe)
> -                                       *out_val = sbi_ext->probe(vcpu);
> +                                       edata->out_val = sbi_ext->probe(vcpu);
>                                 else
> -                                       *out_val = 1;
> +                                       edata->out_val = 1;
>                         } else
> -                               *out_val = 0;
> +                               edata->out_val = 0;
>                 }
>                 break;
>         case SBI_EXT_BASE_GET_MVENDORID:
> -               *out_val = vcpu->arch.mvendorid;
> +               edata->out_val = vcpu->arch.mvendorid;
>                 break;
>         case SBI_EXT_BASE_GET_MARCHID:
> -               *out_val = vcpu->arch.marchid;
> +               edata->out_val = vcpu->arch.marchid;
>                 break;
>         case SBI_EXT_BASE_GET_MIMPID:
> -               *out_val = vcpu->arch.mimpid;
> +               edata->out_val = vcpu->arch.mimpid;
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               edata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 break;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> @@ -79,17 +78,16 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
>  };
>
>  static int kvm_sbi_ext_forward_handler(struct kvm_vcpu *vcpu,
> -                                       struct kvm_run *run,
> -                                       unsigned long *out_val,
> -                                       struct kvm_cpu_trap *utrap,
> -                                       bool *exit)
> +                                      struct kvm_run *run,
> +                                      struct kvm_vcpu_sbi_ext_data *edata,
> +                                      struct kvm_cpu_trap *utrap)
>  {
>         /*
>          * Both SBI experimental and vendor extensions are
>          * unconditionally forwarded to userspace.
>          */
>         kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -       *exit = true;
> +       edata->uexit = true;
>         return 0;
>  }
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 619ac0f..5fb526c 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -21,9 +21,9 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>
>         target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>         if (!target_vcpu)
> -               return -EINVAL;
> +               return SBI_ERR_INVALID_PARAM;
>         if (!target_vcpu->arch.power_off)
> -               return -EALREADY;
> +               return SBI_ERR_ALREADY_AVAILABLE;
>
>         reset_cntx = &target_vcpu->arch.guest_reset_context;
>         /* start address */
> @@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
>  {
>         if (vcpu->arch.power_off)
> -               return -EACCES;
> +               return SBI_ERR_FAILURE;
>
>         kvm_riscv_vcpu_power_off(vcpu);
>
> @@ -57,7 +57,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>
>         target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>         if (!target_vcpu)
> -               return -EINVAL;
> +               return SBI_ERR_INVALID_PARAM;
>         if (!target_vcpu->arch.power_off)
>                 return SBI_HSM_STATE_STARTED;
>         else if (vcpu->stat.generic.blocking)
> @@ -67,9 +67,8 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>  }
>
>  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                  unsigned long *out_val,
> -                                  struct kvm_cpu_trap *utrap,
> -                                  bool *exit)
> +                                  struct kvm_vcpu_sbi_ext_data *edata,
> +                                  struct kvm_cpu_trap *utrap)
>  {
>         int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> @@ -88,27 +87,29 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         case SBI_EXT_HSM_HART_STATUS:
>                 ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
>                 if (ret >= 0) {
> -                       *out_val = ret;
> -                       ret = 0;
> +                       edata->out_val = ret;
> +                       edata->err_val = 0;
>                 }
> -               break;
> +               return 0;
>         case SBI_EXT_HSM_HART_SUSPEND:
>                 switch (cp->a0) {
>                 case SBI_HSM_SUSPEND_RET_DEFAULT:
>                         kvm_riscv_vcpu_wfi(vcpu);
>                         break;
>                 case SBI_HSM_SUSPEND_NON_RET_DEFAULT:
> -                       ret = -EOPNOTSUPP;
> +                       ret = SBI_ERR_NOT_SUPPORTED;
>                         break;
>                 default:
> -                       ret = -EINVAL;
> +                       ret = SBI_ERR_INVALID_PARAM;
>                 }
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               ret = SBI_ERR_NOT_SUPPORTED;
>         }
>
> -       return ret;
> +       edata->err_val = ret;
> +
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index 03a0198..abeb55f 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -14,15 +14,16 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *utrap, bool *exit)
> +                                   struct kvm_vcpu_sbi_ext_data *edata,
> +                                   struct kvm_cpu_trap *utrap)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         u64 next_cycle;
>
> -       if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
> -               return -EINVAL;
> +       if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
> +               edata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
>
>  #if __riscv_xlen == 32
>         next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> @@ -31,7 +32,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  #endif
>         kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
> @@ -41,8 +42,8 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
>  };
>
>  static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                  unsigned long *out_val,
> -                                  struct kvm_cpu_trap *utrap, bool *exit)
> +                                  struct kvm_vcpu_sbi_ext_data *edata,
> +                                  struct kvm_cpu_trap *utrap)
>  {
>         int ret = 0;
>         unsigned long i;
> @@ -51,8 +52,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         unsigned long hmask = cp->a0;
>         unsigned long hbase = cp->a1;
>
> -       if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
> -               return -EINVAL;
> +       if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
> +               edata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
>
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>                 if (hbase != -1UL) {
> @@ -76,10 +79,9 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
>  };
>
>  static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap, bool *exit)
> +                                     struct kvm_vcpu_sbi_ext_data *edata,
> +                                     struct kvm_cpu_trap *utrap)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         unsigned long hmask = cp->a0;
>         unsigned long hbase = cp->a1;
> @@ -116,10 +118,10 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>                  */
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               edata->err_val = SBI_ERR_NOT_SUPPORTED;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> @@ -130,14 +132,13 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
>
>  static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>                                     struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *utrap, bool *exit)
> +                                   struct kvm_vcpu_sbi_ext_data *edata,
> +                                   struct kvm_cpu_trap *utrap)
>  {
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         unsigned long funcid = cp->a6;
>         u32 reason = cp->a1;
>         u32 type = cp->a0;
> -       int ret = 0;
>
>         switch (funcid) {
>         case SBI_EXT_SRST_RESET:
> @@ -146,24 +147,24 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>                         kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_SHUTDOWN,
>                                                 reason);
> -                       *exit = true;
> +                       edata->uexit = true;
>                         break;
>                 case SBI_SRST_RESET_TYPE_COLD_REBOOT:
>                 case SBI_SRST_RESET_TYPE_WARM_REBOOT:
>                         kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_RESET,
>                                                 reason);
> -                       *exit = true;
> +                       edata->uexit = true;
>                         break;
>                 default:
> -                       ret = -EOPNOTSUPP;
> +                       edata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 }
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               edata->err_val = SBI_ERR_NOT_SUPPORTED;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 489f225..c0ccc58 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -14,9 +14,8 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap,
> -                                     bool *exit)
> +                                  struct kvm_vcpu_sbi_ext_data *edata,
> +                                  struct kvm_cpu_trap *utrap)
>  {
>         ulong hmask;
>         int i, ret = 0;
> @@ -33,7 +32,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                  * handled in kernel so we forward these to user-space
>                  */
>                 kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -               *exit = true;
> +               edata->uexit = true;
>                 break;
>         case SBI_EXT_0_1_SET_TIMER:
>  #if __riscv_xlen == 32
> @@ -65,7 +64,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         case SBI_EXT_0_1_SHUTDOWN:
>                 kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_SHUTDOWN, 0);
> -               *exit = true;
> +               edata->uexit = true;
>                 break;
>         case SBI_EXT_0_1_REMOTE_FENCE_I:
>         case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> @@ -103,7 +102,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 }
>                 break;
>         default:
> -               ret = -EINVAL;
> +               edata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 break;
>         }
>
> --
> 2.25.1
>

Regards,
Anup
