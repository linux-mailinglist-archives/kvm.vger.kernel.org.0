Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C22687437
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 05:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjBBECD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 23:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBBEB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 23:01:59 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1038A74A52
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 20:01:57 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qw12so2517012ejc.2
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 20:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cu11cHvOyKKctTH7jR1mjeC4mbPUy4+2mNgeAegFj4Y=;
        b=Q9gmZTWbJF7aGf+XlNAifBIGd4nT4lu5TrKuxhosbivMXiz4AXo/IwsF7kOKJwkLOv
         J5RRBYomTTHqwbqEEEnUq0r3yPO2CCj3F/22zLQlS1TDj4ergqOeFLtTHxC3NCtmEVmx
         rFgI+ZjKYmHvZ1CAArBiFBt0WGPRMYb1FoKOowE+RdV65rK/kaNiGmQxDjPc+fiT97Uc
         M4u8/DonSa+G8AOaz4gQSuIBJLulT3zm2MQZ0QuIjmEE2AKUa5CBaqr0iCvzH3/UDs7I
         5qWcPOp7vBa3JicHamt07hlVDTiUGysVl4QSToflhGUzk7kLlAt56wtgFU9HNCYj6yTs
         PZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cu11cHvOyKKctTH7jR1mjeC4mbPUy4+2mNgeAegFj4Y=;
        b=RYqOSu8HxpFEI8VmrDDxcXufASOkP5BRNIsMLS4tVRW5rmaVZ7Gv3m45s/R3HAs1Tf
         c86Y6cuIQPABYw7CBRY0NuplfuOKUyIGRf1o7TZy+DnAczeVFQFDkA6San/9SnKHoz2L
         8Jz1JCMY5zpH/I1YmXE3tq5bRZvD3X6QjvBk0ApR/C+/C/bpf6zU0ym5apEeyq4IANeI
         8i/T8vXwFC4oyvwg6cB8WWD9Snuorzroj+11it88t9d6qGQONfIPHH5Izpd/IW+BV9dh
         zCDptfjKg/HUZWOLrSGm5bfojO6+sUoFg8+ggc94Tqp2UAn7FDZYag77+IpQ2oLInpzf
         peLA==
X-Gm-Message-State: AO0yUKUiTec56HEK9/hDWrOUXOTi90RJjHfwZBY3W6xkadnrt10AbbMK
        +FByVWHJY3QcR1D2LBBVSx4g+NOn+HqGNHN04/Qwlg==
X-Google-Smtp-Source: AK7set9wINjwBvhrANBB5qRjNpemuX5M5sG9bbi9qLiM+I8AUv7aVwZTZF2JIDgYTakciriDYReLixJHqKsgNS4vowo=
X-Received: by 2002:a17:906:5945:b0:884:8380:20db with SMTP id
 g5-20020a170906594500b00884838020dbmr1234534ejr.301.1675310515316; Wed, 01
 Feb 2023 20:01:55 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-7-atishp@rivosinc.com>
In-Reply-To: <20230201231250.3806412-7-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 2 Feb 2023 09:31:44 +0530
Message-ID: <CAAhSdy1y7Ou8V4NRWhbbjKv_BL9veFsmn16wk7aOtnSQf7vMEw@mail.gmail.com>
Subject: Re: [PATCH v4 06/14] RISC-V: KVM: Modify SBI extension handler to
 return SBI error code
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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

On Thu, Feb 2, 2023 at 4:42 AM Atish Patra <atishp@rivosinc.com> wrote:
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
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 10 ++++-
>  arch/riscv/kvm/vcpu_sbi.c             | 61 +++++++++++----------------
>  arch/riscv/kvm/vcpu_sbi_base.c        | 36 +++++++---------
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 28 ++++++------
>  arch/riscv/kvm/vcpu_sbi_replace.c     | 43 +++++++++----------
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 18 ++++----
>  6 files changed, 90 insertions(+), 106 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 45ba341..8425556 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -18,6 +18,13 @@ struct kvm_vcpu_sbi_context {
>         int return_handled;
>  };
>
> +struct kvm_vcpu_sbi_return {
> +       unsigned long out_val;
> +       unsigned long err_val;
> +       struct kvm_cpu_trap *utrap;

This should not be a pointer.

> +       bool uexit;
> +};
> +
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
>         unsigned long extid_end;
> @@ -27,8 +34,7 @@ struct kvm_vcpu_sbi_extension {
>          * specific error codes.
>          */
>         int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                      unsigned long *out_val, struct kvm_cpu_trap *utrap,
> -                      bool *exit);
> +                      struct kvm_vcpu_sbi_return *retdata);
>
>         /* Extension specific probe function */
>         unsigned long (*probe)(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index f96991d..fe2897e 100644
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
> @@ -125,11 +105,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>         int ret = 1;
>         bool next_sepc = true;
> -       bool userspace_exit = false;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         const struct kvm_vcpu_sbi_extension *sbi_ext;
> -       struct kvm_cpu_trap utrap = { 0 };
> -       unsigned long out_val = 0;
> +       struct kvm_cpu_trap utrap = {0};
> +       struct kvm_vcpu_sbi_return sbi_ret = {
> +               .out_val = 0,
> +               .err_val = 0,
> +               .utrap = &utrap,
> +       };
>         bool ext_is_v01 = false;
>
>         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> @@ -139,42 +122,46 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>                     cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
>                         ext_is_v01 = true;
>  #endif
> -               ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> +               ret = sbi_ext->handler(vcpu, run, &sbi_ret);
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
> -       if (utrap.scause) {
> +       if (sbi_ret.utrap->scause) {
>                 /* No need to increment sepc or exit ioctl loop */
>                 ret = 1;
> -               utrap.sepc = cp->sepc;
> -               kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> +               sbi_ret.utrap->sepc = cp->sepc;
> +               kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
>                 next_sepc = false;
>                 goto ecall_done;
>         }
>
>         /* Exit ioctl loop or Propagate the error code the guest */
> -       if (userspace_exit) {
> +       if (sbi_ret.uexit) {
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
> +               cp->a0 = sbi_ret.err_val;
>                 ret = 1;
>         }
>  ecall_done:
>         if (next_sepc)
>                 cp->sepc += 4;
> -       if (!ext_is_v01)
> -               cp->a1 = out_val;
> +       /* a1 should only be updated when we continue the ioctl loop */
> +       if (!ext_is_v01 && ret == 1)
> +               cp->a1 = sbi_ret.out_val;
>
>         return ret;
>  }
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 846d518..69f4202 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -14,24 +14,22 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *trap, bool *exit)
> +                                   struct kvm_vcpu_sbi_return *retdata)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         const struct kvm_vcpu_sbi_extension *sbi_ext;
>
>         switch (cp->a6) {
>         case SBI_EXT_BASE_GET_SPEC_VERSION:
> -               *out_val = (KVM_SBI_VERSION_MAJOR <<
> +               retdata->out_val = (KVM_SBI_VERSION_MAJOR <<
>                             SBI_SPEC_VERSION_MAJOR_SHIFT) |
>                             KVM_SBI_VERSION_MINOR;
>                 break;
>         case SBI_EXT_BASE_GET_IMP_ID:
> -               *out_val = KVM_SBI_IMPID;
> +               retdata->out_val = KVM_SBI_IMPID;
>                 break;
>         case SBI_EXT_BASE_GET_IMP_VERSION:
> -               *out_val = LINUX_VERSION_CODE;
> +               retdata->out_val = LINUX_VERSION_CODE;
>                 break;
>         case SBI_EXT_BASE_PROBE_EXT:
>                 if ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
> @@ -43,33 +41,33 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                          * forward it to the userspace
>                          */
>                         kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -                       *exit = true;
> +                       retdata->uexit = true;
>                 } else {
>                         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
>                         if (sbi_ext) {
>                                 if (sbi_ext->probe)
> -                                       *out_val = sbi_ext->probe(vcpu);
> +                                       retdata->out_val = sbi_ext->probe(vcpu);
>                                 else
> -                                       *out_val = 1;
> +                                       retdata->out_val = 1;
>                         } else
> -                               *out_val = 0;
> +                               retdata->out_val = 0;
>                 }
>                 break;
>         case SBI_EXT_BASE_GET_MVENDORID:
> -               *out_val = vcpu->arch.mvendorid;
> +               retdata->out_val = vcpu->arch.mvendorid;
>                 break;
>         case SBI_EXT_BASE_GET_MARCHID:
> -               *out_val = vcpu->arch.marchid;
> +               retdata->out_val = vcpu->arch.marchid;
>                 break;
>         case SBI_EXT_BASE_GET_MIMPID:
> -               *out_val = vcpu->arch.mimpid;
> +               retdata->out_val = vcpu->arch.mimpid;
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 break;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> @@ -79,17 +77,15 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
>  };
>
>  static int kvm_sbi_ext_forward_handler(struct kvm_vcpu *vcpu,
> -                                       struct kvm_run *run,
> -                                       unsigned long *out_val,
> -                                       struct kvm_cpu_trap *utrap,
> -                                       bool *exit)
> +                                      struct kvm_run *run,
> +                                      struct kvm_vcpu_sbi_return *retdata)
>  {
>         /*
>          * Both SBI experimental and vendor extensions are
>          * unconditionally forwarded to userspace.
>          */
>         kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -       *exit = true;
> +       retdata->uexit = true;
>         return 0;
>  }
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 619ac0f..7dca0e9 100644
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
> @@ -67,9 +67,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>  }
>
>  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                  unsigned long *out_val,
> -                                  struct kvm_cpu_trap *utrap,
> -                                  bool *exit)
> +                                  struct kvm_vcpu_sbi_return *retdata)
>  {
>         int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> @@ -88,27 +86,29 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         case SBI_EXT_HSM_HART_STATUS:
>                 ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
>                 if (ret >= 0) {
> -                       *out_val = ret;
> -                       ret = 0;
> +                       retdata->out_val = ret;
> +                       retdata->err_val = 0;
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
> +       retdata->err_val = ret;
> +
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index 03a0198..38fa4c0 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -14,15 +14,15 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *utrap, bool *exit)
> +                                   struct kvm_vcpu_sbi_return *retdata)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         u64 next_cycle;
>
> -       if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
> -               return -EINVAL;
> +       if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
> +               retdata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
>
>  #if __riscv_xlen == 32
>         next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> @@ -31,7 +31,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  #endif
>         kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
> @@ -41,8 +41,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
>  };
>
>  static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                  unsigned long *out_val,
> -                                  struct kvm_cpu_trap *utrap, bool *exit)
> +                                  struct kvm_vcpu_sbi_return *retdata)
>  {
>         int ret = 0;
>         unsigned long i;
> @@ -51,8 +50,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         unsigned long hmask = cp->a0;
>         unsigned long hbase = cp->a1;
>
> -       if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
> -               return -EINVAL;
> +       if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
> +               retdata->err_val = SBI_ERR_INVALID_PARAM;
> +               return 0;
> +       }
>
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>                 if (hbase != -1UL) {
> @@ -76,10 +77,8 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
>  };
>
>  static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap, bool *exit)
> +                                     struct kvm_vcpu_sbi_return *retdata)
>  {
> -       int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         unsigned long hmask = cp->a0;
>         unsigned long hbase = cp->a1;
> @@ -116,10 +115,10 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>                  */
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> @@ -130,14 +129,12 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
>
>  static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>                                     struct kvm_run *run,
> -                                   unsigned long *out_val,
> -                                   struct kvm_cpu_trap *utrap, bool *exit)
> +                                   struct kvm_vcpu_sbi_return *retdata)
>  {
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>         unsigned long funcid = cp->a6;
>         u32 reason = cp->a1;
>         u32 type = cp->a0;
> -       int ret = 0;
>
>         switch (funcid) {
>         case SBI_EXT_SRST_RESET:
> @@ -146,24 +143,24 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>                         kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_SHUTDOWN,
>                                                 reason);
> -                       *exit = true;
> +                       retdata->uexit = true;
>                         break;
>                 case SBI_SRST_RESET_TYPE_COLD_REBOOT:
>                 case SBI_SRST_RESET_TYPE_WARM_REBOOT:
>                         kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_RESET,
>                                                 reason);
> -                       *exit = true;
> +                       retdata->uexit = true;
>                         break;
>                 default:
> -                       ret = -EOPNOTSUPP;
> +                       retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 }
>                 break;
>         default:
> -               ret = -EOPNOTSUPP;
> +               retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>         }
>
> -       return ret;
> +       return 0;
>  }
>
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 489f225..0269e08 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -14,9 +14,7 @@
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap,
> -                                     bool *exit)
> +                                  struct kvm_vcpu_sbi_return *retdata)
>  {
>         ulong hmask;
>         int i, ret = 0;
> @@ -33,7 +31,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                  * handled in kernel so we forward these to user-space
>                  */
>                 kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -               *exit = true;
> +               retdata->uexit = true;
>                 break;
>         case SBI_EXT_0_1_SET_TIMER:
>  #if __riscv_xlen == 32
> @@ -49,10 +47,10 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         case SBI_EXT_0_1_SEND_IPI:
>                 if (cp->a0)
>                         hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> +                                                          retdata->utrap);
>                 else
>                         hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> +               if (retdata->utrap->scause)
>                         break;
>
>                 for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> @@ -65,17 +63,17 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         case SBI_EXT_0_1_SHUTDOWN:
>                 kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>                                                 KVM_SYSTEM_EVENT_SHUTDOWN, 0);
> -               *exit = true;
> +               retdata->uexit = true;
>                 break;
>         case SBI_EXT_0_1_REMOTE_FENCE_I:
>         case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
>         case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
>                 if (cp->a0)
>                         hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> +                                                          retdata->utrap);
>                 else
>                         hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> +               if (retdata->utrap->scause)
>                         break;
>
>                 if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> @@ -103,7 +101,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 }
>                 break;
>         default:
> -               ret = -EINVAL;
> +               retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>                 break;
>         }
>
> --
> 2.25.1
>

Regards,
Anup
