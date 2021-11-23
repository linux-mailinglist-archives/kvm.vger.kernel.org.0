Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887FF459D5B
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhKWIGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbhKWIGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:06:19 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9EDC061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:03:11 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i8-20020a7bc948000000b0030db7b70b6bso1388581wml.1
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 00:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N19fcMHCD7YED0BbEjZ8bEMnapF/QHm3e5k63d0Zv0s=;
        b=qpfVoycBcVOep6opqG1Pz9jBiMgDHKbl3Ru10lU8NG1g/nKl7hfcG9snrdWSeib2Zz
         kFzbBKCue8QH5sWCzU694A2teeW6ulp87cJzRXcjH1QXCqAsDBgLA1LUcqinQ9hA8CIX
         BQjtRHkDogRslDhE6H0S/nro4x8H5lSagXcQQIX4JTKLGwGSLgtKhX0z9D/FoWa2G0SG
         sEpXGmb2BaKlcVcAXwb9ILR92wb/hvh/9GjHHF6ndYS0W8DRI7HJYVrIYzErxq/jaMQg
         1RP+LUNutK23m3k+Mdj/RNEAp4v5Zf9Fk3gk96CCXw+2e3vUSRcHWCKEm1I4OSRXAxRD
         9QZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N19fcMHCD7YED0BbEjZ8bEMnapF/QHm3e5k63d0Zv0s=;
        b=AhODceSKmw8FvxTTUa2892v7MpZFzYhVj5inJyzS2fXW/djvluZ5OgHbV/YiDMsGep
         nLHCaxtxiuR6OLZe4aZm2AboS8HoC4UdF/AmPS+CF4r+Vj9sLR5FcLXqbawGcCHDcoCP
         9TI8LDf39lnPXCLiykIOXoWxJqU+jjdQeo8z5KMrRPmkI5ArnLBYjbebkOwNBn190+fm
         cBqttyOHrc0s28R+XFBf6p/WgqZSPASWqpTf5Yq+GBJU2lxBkURYufc+TmfFpkuv/m/Z
         guOATd8C3TuW/Q5Iq+/bd8Mc3Qk5b67OdMvmi7VDuq8BJVKBZXcPw3UAsG++l3Th1Igx
         tlyA==
X-Gm-Message-State: AOAM533YsQYlajUZ/61GvC96yfATJfKnqFmcHGDDdMbtLlHCovugU6dX
        2ONmvCTYBOCx+bISfpv0lJdk2+86YulPPDJpwfIBNA==
X-Google-Smtp-Source: ABdhPJxp+iihTfrZ5iaWDNjYsPxWpbbNAtlnGpf34gIeUNcP2TluMg/3LofWuVkEqy8bcvKC/WbySVRWStvyQDc2AOY=
X-Received: by 2002:a05:600c:2149:: with SMTP id v9mr669199wml.59.1637654590224;
 Tue, 23 Nov 2021 00:03:10 -0800 (PST)
MIME-Version: 1.0
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-3-atishp@rivosinc.com>
In-Reply-To: <20211118083912.981995-3-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 23 Nov 2021 13:32:58 +0530
Message-ID: <CAAhSdy3LtyWL01cmeUk2P_yY8dFKZsbXtWuPgs-FeKtbrHWacQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] RISC-V: KVM: Reorganize SBI code by moving SBI
 v0.1 to its own file
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup.patel@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 2:10 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> From: Atish Patra <atish.patra@wdc.com>
>
> With SBI v0.2, there may be more SBI extensions in future. It makes more
> sense to group related extensions in separate files. Guest kernel will
> choose appropriate SBI version dynamically.
>
> Move the existing implementation to a separate file so that it can be
> removed in future without much conflict.
>
> Reviewed-by: Anup Patel <anup.patel@wdc.com>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

I have queued this for 5.17

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu_sbi.c             | 148 +++-----------------------
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 126 ++++++++++++++++++++++
>  4 files changed, 146 insertions(+), 131 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_v01.c
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 1a4cb0db2d0b..704151969ceb 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -25,5 +25,7 @@ struct kvm_vcpu_sbi_extension {
>                        bool *exit);
>  };
>
> +void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> +
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 30cdd1df0098..d3d5ff3a6019 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -23,4 +23,5 @@ kvm-y += vcpu_exit.o
>  kvm-y += vcpu_fp.o
>  kvm-y += vcpu_switch.o
>  kvm-y += vcpu_sbi.o
> +kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_timer.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 32376906ff20..a8e0191cd9fc 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -9,9 +9,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
> -#include <asm/csr.h>
>  #include <asm/sbi.h>
> -#include <asm/kvm_vcpu_timer.h>
>  #include <asm/kvm_vcpu_sbi.h>
>
>  static int kvm_linux_err_map_sbi(int err)
> @@ -32,8 +30,21 @@ static int kvm_linux_err_map_sbi(int err)
>         };
>  }
>
> -static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
> -                                      struct kvm_run *run)
> +#ifdef CONFIG_RISCV_SBI_V01
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> +#else
> +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> +       .extid_start = -1UL,
> +       .extid_end = -1UL,
> +       .handler = NULL,
> +};
> +#endif
> +
> +static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> +       &vcpu_sbi_ext_v01,
> +};
> +
> +void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>
> @@ -71,123 +82,6 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>         return 0;
>  }
>
> -#ifdef CONFIG_RISCV_SBI_V01
> -
> -static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> -                                   struct kvm_run *run, u32 type)
> -{
> -       int i;
> -       struct kvm_vcpu *tmp;
> -
> -       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> -       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> -
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -}
> -
> -static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -                                     unsigned long *out_val,
> -                                     struct kvm_cpu_trap *utrap,
> -                                     bool *exit)
> -{
> -       ulong hmask;
> -       int i, ret = 0;
> -       u64 next_cycle;
> -       struct kvm_vcpu *rvcpu;
> -       struct cpumask cm, hm;
> -       struct kvm *kvm = vcpu->kvm;
> -       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> -
> -       switch (cp->a7) {
> -       case SBI_EXT_0_1_CONSOLE_GETCHAR:
> -       case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> -               /*
> -                * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
> -                * handled in kernel so we forward these to user-space
> -                */
> -               kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -               *exit = true;
> -               break;
> -       case SBI_EXT_0_1_SET_TIMER:
> -#if __riscv_xlen == 32
> -               next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> -#else
> -               next_cycle = (u64)cp->a0;
> -#endif
> -               ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> -               break;
> -       case SBI_EXT_0_1_CLEAR_IPI:
> -               ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> -               break;
> -       case SBI_EXT_0_1_SEND_IPI:
> -               if (cp->a0)
> -                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> -               else
> -                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> -                       break;
> -
> -               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> -                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -                       ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> -                       if (ret < 0)
> -                               break;
> -               }
> -               break;
> -       case SBI_EXT_0_1_SHUTDOWN:
> -               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> -               *exit = true;
> -               break;
> -       case SBI_EXT_0_1_REMOTE_FENCE_I:
> -       case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> -       case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> -               if (cp->a0)
> -                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -                                                          utrap);
> -               else
> -                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> -               if (utrap->scause)
> -                       break;
> -
> -               cpumask_clear(&cm);
> -               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> -                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> -                       if (rvcpu->cpu < 0)
> -                               continue;
> -                       cpumask_set_cpu(rvcpu->cpu, &cm);
> -               }
> -               riscv_cpuid_to_hartid_mask(&cm, &hm);
> -               if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> -                       ret = sbi_remote_fence_i(cpumask_bits(&hm));
> -               else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> -                       ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
> -                                               cp->a1, cp->a2);
> -               else
> -                       ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> -                                               cp->a1, cp->a2, cp->a3);
> -               break;
> -       default:
> -               ret = -EINVAL;
> -               break;
> -       }
> -
> -       return ret;
> -}
> -
> -const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> -       .extid_start = SBI_EXT_0_1_SET_TIMER,
> -       .extid_end = SBI_EXT_0_1_SHUTDOWN,
> -       .handler = kvm_sbi_ext_v01_handler,
> -};
> -
> -static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> -       &vcpu_sbi_ext_v01,
> -};
> -
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
>  {
>         int i = 0;
> @@ -214,9 +108,11 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>
>         sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
>         if (sbi_ext && sbi_ext->handler) {
> +#ifdef CONFIG_RISCV_SBI_V01
>                 if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
>                     cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
>                         ext_is_v01 = true;
> +#endif
>                 ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
>         } else {
>                 /* Return error for unsupported SBI calls */
> @@ -256,13 +152,3 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>
>         return ret;
>  }
> -
> -#else
> -
> -int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> -{
> -       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -       return 0;
> -}
> -
> -#endif
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> new file mode 100644
> index 000000000000..08097d1c13c1
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Atish Patra <atish.patra@wdc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> +                                   struct kvm_run *run, u32 type)
> +{
> +       int i;
> +       struct kvm_vcpu *tmp;
> +
> +       kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> +               tmp->arch.power_off = true;
> +       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> +
> +       memset(&run->system_event, 0, sizeof(run->system_event));
> +       run->system_event.type = type;
> +       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
> +static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                     unsigned long *out_val,
> +                                     struct kvm_cpu_trap *utrap,
> +                                     bool *exit)
> +{
> +       ulong hmask;
> +       int i, ret = 0;
> +       u64 next_cycle;
> +       struct kvm_vcpu *rvcpu;
> +       struct cpumask cm, hm;
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +
> +       switch (cp->a7) {
> +       case SBI_EXT_0_1_CONSOLE_GETCHAR:
> +       case SBI_EXT_0_1_CONSOLE_PUTCHAR:
> +               /*
> +                * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
> +                * handled in kernel so we forward these to user-space
> +                */
> +               kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +               *exit = true;
> +               break;
> +       case SBI_EXT_0_1_SET_TIMER:
> +#if __riscv_xlen == 32
> +               next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> +#else
> +               next_cycle = (u64)cp->a0;
> +#endif
> +               ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> +               break;
> +       case SBI_EXT_0_1_CLEAR_IPI:
> +               ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> +               break;
> +       case SBI_EXT_0_1_SEND_IPI:
> +               if (cp->a0)
> +                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> +                                                          utrap);
> +               else
> +                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> +               if (utrap->scause)
> +                       break;
> +
> +               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> +                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> +                       ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> +                       if (ret < 0)
> +                               break;
> +               }
> +               break;
> +       case SBI_EXT_0_1_SHUTDOWN:
> +               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> +               *exit = true;
> +               break;
> +       case SBI_EXT_0_1_REMOTE_FENCE_I:
> +       case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> +       case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> +               if (cp->a0)
> +                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> +                                                          utrap);
> +               else
> +                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> +               if (utrap->scause)
> +                       break;
> +
> +               cpumask_clear(&cm);
> +               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> +                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> +                       if (rvcpu->cpu < 0)
> +                               continue;
> +                       cpumask_set_cpu(rvcpu->cpu, &cm);
> +               }
> +               riscv_cpuid_to_hartid_mask(&cm, &hm);
> +               if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> +                       ret = sbi_remote_fence_i(cpumask_bits(&hm));
> +               else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> +                       ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
> +                                               cp->a1, cp->a2);
> +               else
> +                       ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> +                                               cp->a1, cp->a2, cp->a3);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       };
> +
> +       return ret;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> +       .extid_start = SBI_EXT_0_1_SET_TIMER,
> +       .extid_end = SBI_EXT_0_1_SHUTDOWN,
> +       .handler = kvm_sbi_ext_v01_handler,
> +};
> --
> 2.33.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
