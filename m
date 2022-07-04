Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EEE565000
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGDIr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 04:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiGDIrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 04:47:55 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B1BB87F
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 01:47:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o19-20020a05600c4fd300b003a0489f414cso5188489wmq.4
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 01:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8sO1gaN9uIp00cJhoCccLGVFJcE2R7vIHa/A/JURso8=;
        b=eI3mJ80/oG46lW+7HYoMlHkjAOUCsPj/QYkgOENM2Pe0OxjTbzBzHklS/ppL2Ix282
         soz3GxHDJUNd2/9aMB17Y/OJ0Jk9Pv+YL39DDEBVqk5v2MiPkaJmFO3yo6Eyu70K7y9y
         fSTMR6n0SXwg9Tn3uHt6uyAJsNGZNKl7ksGo9hwkQ75aPGtP1/YTmg4y4l0bqAxjIKdw
         NQOdU23EEwa2s+0geBLFQo9NKNxz82Cx9JduMhPDOhqwnrQiKz+r7yJ+KIyKFg9YGVoD
         Cu2Soy7EtAyBr7rrZSg5ufTGkjiX7860QAdXI5Hp4FXyaFgaGHl+L2u4AxZkWvjscKYg
         pFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8sO1gaN9uIp00cJhoCccLGVFJcE2R7vIHa/A/JURso8=;
        b=FSzgf2ROyXvUiyrzWQzK4jhmcioDw4mHHk2p3u8/SN82E9x27sCjgSvmR1RPysvhq4
         XFW+HUde9rBvZMi5uvy54yWSaVyjMvTMHSrITx18OqW2E1WGGS1AAkgCMz5PJjavJ/Rt
         NijqMZX8/euIjjuEasJZxinqZ3WZHrrz8siFVb3g3ESncoTUXZdCjchfRJKB5d1YSlBy
         +TrmwYUUwPAVfiUUlcMrWPiK6EQakCGypLJkjxeXmc2RDEl+q5HfruHj/JMRFtw2zWLu
         7rqJ3GdhTXfDXAPQqpGGa90blryciGid7CVzftqIZG9zMrKDJEgQYdTipOjuy2NMeiFx
         JeLA==
X-Gm-Message-State: AJIora/opMnENpG68jLhZOzGPC62KZvyUtI7RnOb6Gog7tQy/sOmCKno
        aQJEo3NwqrDPc4oGR7mnZjGcYUk8vR0q5M5YUDW4rg==
X-Google-Smtp-Source: AGRyM1uUK8bOVlD/3qAsjbCQSKru53fXWntpuQQ/dSZAy23WNU1hxZ1U+QXKV6WnAZRQShDnzZN2YJSPThYrLPYyAos=
X-Received: by 2002:a05:600c:1d0b:b0:3a0:3ab8:924 with SMTP id
 l11-20020a05600c1d0b00b003a03ab80924mr29521753wms.137.1656924470662; Mon, 04
 Jul 2022 01:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220620234254.2610040-1-atishp@rivosinc.com>
In-Reply-To: <20220620234254.2610040-1-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Jul 2022 14:17:38 +0530
Message-ID: <CAAhSdy2ziUJV2vozZw+vDiA+-Xa5pNiC=Dy_gapCApoR4bnxWg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Improve ISA extension by using a bitmap
To:     Atish Patra <atishp@rivosinc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 5:13 AM Atish Patra <atishp@rivosinc.com> wrote:
>
> Currently, the every vcpu only stores the ISA extensions in a unsigned long
> which is not scalable as number of extensions will continue to grow.
> Using a bitmap allows the ISA extension to support any number of
> extensions. The CONFIG one reg interface implementation is modified to
> support the bitmap as well. But it is meant only for base extensions.
> Thus, the first element of the bitmap array is sufficient for that
> interface.
>
> In the future, all the new multi-letter extensions must use the
> ISA_EXT one reg interface that allows enabling/disabling any extension
> now.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h    |  3 +-
>  arch/riscv/include/asm/kvm_vcpu_fp.h |  8 +--
>  arch/riscv/kvm/vcpu.c                | 81 ++++++++++++++--------------
>  arch/riscv/kvm/vcpu_fp.c             | 27 +++++-----
>  4 files changed, 59 insertions(+), 60 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 319c8aeb42af..c749cdacbd63 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -14,6 +14,7 @@
>  #include <linux/kvm_types.h>
>  #include <linux/spinlock.h>
>  #include <asm/csr.h>
> +#include <asm/hwcap.h>
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_timer.h>
>
> @@ -170,7 +171,7 @@ struct kvm_vcpu_arch {
>         int last_exit_cpu;
>
>         /* ISA feature bits (similar to MISA) */
> -       unsigned long isa;
> +       DECLARE_BITMAP(isa, RISCV_ISA_EXT_MAX);
>
>         /* SSCRATCH, STVEC, and SCOUNTEREN of Host */
>         unsigned long host_sscratch;
> diff --git a/arch/riscv/include/asm/kvm_vcpu_fp.h b/arch/riscv/include/asm/kvm_vcpu_fp.h
> index 4da9b8e0f050..e86bb67f2a8a 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_fp.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_fp.h
> @@ -22,9 +22,9 @@ void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
>
>  void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> -                                 unsigned long isa);
> +                                 unsigned long *isa);

Better to use "const unsigned long *"

>  void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> -                                    unsigned long isa);
> +                                    unsigned long *isa);

Same as above.

>  void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx);
>  void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx);
>  #else
> @@ -32,12 +32,12 @@ static inline void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
>  {
>  }
>  static inline void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> -                                               unsigned long isa)
> +                                               unsigned long *isa)
>  {
>  }
>  static inline void kvm_riscv_vcpu_guest_fp_restore(
>                                         struct kvm_cpu_context *cntx,
> -                                       unsigned long isa)
> +                                       unsigned long *isa)
>  {
>  }
>  static inline void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7f4ad5e4373a..cb2a65b5d563 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -46,8 +46,19 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>                                                 riscv_isa_extension_mask(i) | \
>                                                 riscv_isa_extension_mask(m))
>
> -#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
> -                              KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
> +#define KVM_RISCV_ISA_MASK GENMASK(25, 0)
> +
> +/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
> +static unsigned long kvm_isa_ext_arr[] = {
> +       RISCV_ISA_EXT_a,
> +       RISCV_ISA_EXT_c,
> +       RISCV_ISA_EXT_d,
> +       RISCV_ISA_EXT_f,
> +       RISCV_ISA_EXT_h,
> +       RISCV_ISA_EXT_i,
> +       RISCV_ISA_EXT_m,
> +       RISCV_ISA_EXT_SSCOFPMF,

The RISCV_ISA_EXT_SSCOFPMF should be added only after we have
SBI PMU support in KVM RISC-V. Please drop it.

> +};
>
>  static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
> @@ -99,13 +110,20 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_cpu_context *cntx;
>         struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
> +       unsigned long host_isa, i;
>
>         /* Mark this VCPU never ran */
>         vcpu->arch.ran_atleast_once = false;
>         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> +       bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
>
>         /* Setup ISA features available to VCPU */
> -       vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
> +       for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
> +               host_isa = kvm_isa_ext_arr[i];
> +               if (__riscv_isa_extension_available(NULL, host_isa) &&
> +                  host_isa != RISCV_ISA_EXT_h)
> +                       set_bit(host_isa, vcpu->arch.isa);
> +       }
>
>         /* Setup VCPU hfence queue */
>         spin_lock_init(&vcpu->arch.hfence_lock);
> @@ -199,7 +217,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>
>         switch (reg_num) {
>         case KVM_REG_RISCV_CONFIG_REG(isa):
> -               reg_val = vcpu->arch.isa;
> +               reg_val = vcpu->arch.isa[0] & KVM_RISCV_ISA_MASK;
>                 break;
>         default:
>                 return -EINVAL;
> @@ -220,6 +238,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>                                             KVM_REG_SIZE_MASK |
>                                             KVM_REG_RISCV_CONFIG);
>         unsigned long reg_val;
> +       unsigned long isa_mask;
>
>         if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
>                 return -EINVAL;
> @@ -227,13 +246,19 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
>
> +       /* This ONE REG interface is only defined for single letter extensions */
> +       if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
> +               return -EINVAL;
> +
>         switch (reg_num) {
>         case KVM_REG_RISCV_CONFIG_REG(isa):
>                 if (!vcpu->arch.ran_atleast_once) {
>                         /* Ignore the disable request for these extensions */
> -                       vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
> -                       vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> -                       vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> +                       isa_mask = (reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED);
> +                       isa_mask &= riscv_isa_extension_base(NULL);
> +                       /* Do not modify anything beyond single letter extensions */
> +                       isa_mask |= (~KVM_RISCV_ISA_MASK);
> +                       bitmap_and(vcpu->arch.isa, vcpu->arch.isa, &isa_mask, RISCV_ISA_EXT_MAX);

A little more readable version of above sequence can be:

            /* Ignore the disable request for these extensions */
            reg_val |= KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
            reg_val &= riscv_isa_extension_base(NULL);
            /* Do not modify anything beyond single letter extensions */
            reg_val = (vcpu->arch.isa[0] & ~KVM_RISCV_ISA_MASK) |
                  (reg_val & KVM_RISCV_ISA_MASK);
            vcpu->arch.isa[0] = reg_val;
            kvm_riscv_vcpu_fp_reset(vcpu);


>                         kvm_riscv_vcpu_fp_reset(vcpu);
>                 } else {
>                         return -EOPNOTSUPP;
> @@ -374,17 +399,6 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> -/* Mapping between KVM ISA Extension ID & Host ISA extension ID */
> -static unsigned long kvm_isa_ext_arr[] = {
> -       RISCV_ISA_EXT_a,
> -       RISCV_ISA_EXT_c,
> -       RISCV_ISA_EXT_d,
> -       RISCV_ISA_EXT_f,
> -       RISCV_ISA_EXT_h,
> -       RISCV_ISA_EXT_i,
> -       RISCV_ISA_EXT_m,
> -};
> -
>  static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
>                                           const struct kvm_one_reg *reg)
>  {
> @@ -403,7 +417,7 @@ static int kvm_riscv_vcpu_get_reg_isa_ext(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         host_isa_ext = kvm_isa_ext_arr[reg_num];
> -       if (__riscv_isa_extension_available(&vcpu->arch.isa, host_isa_ext))
> +       if (__riscv_isa_extension_available(vcpu->arch.isa, host_isa_ext))
>                 reg_val = 1; /* Mark the given extension as available */
>
>         if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> @@ -437,30 +451,17 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
>         if (!__riscv_isa_extension_available(NULL, host_isa_ext))
>                 return  -EOPNOTSUPP;
>
> -       if (host_isa_ext >= RISCV_ISA_EXT_BASE &&
> -           host_isa_ext < RISCV_ISA_EXT_MAX) {
> -               /*
> -                * Multi-letter ISA extension. Currently there is no provision
> -                * to enable/disable the multi-letter ISA extensions for guests.
> -                * Return success if the request is to enable any ISA extension
> -                * that is available in the hardware.
> -                * Return -EOPNOTSUPP otherwise.
> -                */
> -               if (!reg_val)
> -                       return -EOPNOTSUPP;
> -               else
> -                       return 0;
> -       }
> -
> -       /* Single letter base ISA extension */
>         if (!vcpu->arch.ran_atleast_once) {
> +               /* All multi-letter extension and a few single letter extension can be disabled */
>                 host_isa_ext_mask = BIT_MASK(host_isa_ext);
> -               if (!reg_val && (host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED))
> -                       vcpu->arch.isa &= ~host_isa_ext_mask;
> +               if (!reg_val &&
> +                  ((host_isa_ext_mask & KVM_RISCV_ISA_DISABLE_ALLOWED) ||
> +                  ((host_isa_ext >= RISCV_ISA_EXT_BASE) && (host_isa_ext < RISCV_ISA_EXT_MAX))))
> +                       clear_bit(host_isa_ext, vcpu->arch.isa);
> +               else if (reg_val == 1 && (host_isa_ext != RISCV_ISA_EXT_h))
> +                       set_bit(host_isa_ext, vcpu->arch.isa);
>                 else
> -                       vcpu->arch.isa |= host_isa_ext_mask;
> -               vcpu->arch.isa &= riscv_isa_extension_base(NULL);
> -               vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
> +                       return -EINVAL;

A slightly more readable version of above sequence can be:

        /* All multi-letter extension and a few single letter
extension can be disabled */
        if (host_isa_ext >= RISCV_ISA_EXT_MAX)
            return -EINVAL;
        disable_allow_mask = KVM_RISCV_ISA_DISABLE_ALLOWED;
        if (reg_val == 1)
            set_bit(host_isa_ext, vcpu->arch.isa);
        else if (!reg_val && test_bit(host_isa_ext, &disable_allow_mask))
            clear_bit(host_isa_ext, vcpu->arch.isa);
        else
            return -EINVAL;


>                 kvm_riscv_vcpu_fp_reset(vcpu);
>         } else {
>                 return -EOPNOTSUPP;
> diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
> index d4308c512007..748a8f6a9b5d 100644
> --- a/arch/riscv/kvm/vcpu_fp.c
> +++ b/arch/riscv/kvm/vcpu_fp.c
> @@ -16,12 +16,11 @@
>  #ifdef CONFIG_FPU
>  void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
>  {
> -       unsigned long isa = vcpu->arch.isa;
>         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
>
>         cntx->sstatus &= ~SR_FS;
> -       if (riscv_isa_extension_available(&isa, f) ||
> -           riscv_isa_extension_available(&isa, d))
> +       if (riscv_isa_extension_available(vcpu->arch.isa, f) ||
> +           riscv_isa_extension_available(vcpu->arch.isa, d))
>                 cntx->sstatus |= SR_FS_INITIAL;
>         else
>                 cntx->sstatus |= SR_FS_OFF;
> @@ -34,24 +33,24 @@ static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
>  }
>
>  void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
> -                                 unsigned long isa)
> +                                 unsigned long *isa)
>  {
>         if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
> -               if (riscv_isa_extension_available(&isa, d))
> +               if (riscv_isa_extension_available(isa, d))
>                         __kvm_riscv_fp_d_save(cntx);
> -               else if (riscv_isa_extension_available(&isa, f))
> +               else if (riscv_isa_extension_available(isa, f))
>                         __kvm_riscv_fp_f_save(cntx);
>                 kvm_riscv_vcpu_fp_clean(cntx);
>         }
>  }
>
>  void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
> -                                    unsigned long isa)
> +                                    unsigned long *isa)
>  {
>         if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
> -               if (riscv_isa_extension_available(&isa, d))
> +               if (riscv_isa_extension_available(isa, d))
>                         __kvm_riscv_fp_d_restore(cntx);
> -               else if (riscv_isa_extension_available(&isa, f))
> +               else if (riscv_isa_extension_available(isa, f))
>                         __kvm_riscv_fp_f_restore(cntx);
>                 kvm_riscv_vcpu_fp_clean(cntx);
>         }
> @@ -80,7 +79,6 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
>                               unsigned long rtype)
>  {
>         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> -       unsigned long isa = vcpu->arch.isa;
>         unsigned long __user *uaddr =
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> @@ -89,7 +87,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
>         void *reg_val;
>
>         if ((rtype == KVM_REG_RISCV_FP_F) &&
> -           riscv_isa_extension_available(&isa, f)) {
> +           riscv_isa_extension_available(vcpu->arch.isa, f)) {
>                 if (KVM_REG_SIZE(reg->id) != sizeof(u32))
>                         return -EINVAL;
>                 if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
> @@ -100,7 +98,7 @@ int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
>                 else
>                         return -EINVAL;
>         } else if ((rtype == KVM_REG_RISCV_FP_D) &&
> -                  riscv_isa_extension_available(&isa, d)) {
> +                  riscv_isa_extension_available(vcpu->arch.isa, d)) {
>                 if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
>                         if (KVM_REG_SIZE(reg->id) != sizeof(u32))
>                                 return -EINVAL;
> @@ -126,7 +124,6 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
>                               unsigned long rtype)
>  {
>         struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> -       unsigned long isa = vcpu->arch.isa;
>         unsigned long __user *uaddr =
>                         (unsigned long __user *)(unsigned long)reg->addr;
>         unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> @@ -135,7 +132,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
>         void *reg_val;
>
>         if ((rtype == KVM_REG_RISCV_FP_F) &&
> -           riscv_isa_extension_available(&isa, f)) {
> +           riscv_isa_extension_available(vcpu->arch.isa, f)) {
>                 if (KVM_REG_SIZE(reg->id) != sizeof(u32))
>                         return -EINVAL;
>                 if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
> @@ -146,7 +143,7 @@ int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
>                 else
>                         return -EINVAL;
>         } else if ((rtype == KVM_REG_RISCV_FP_D) &&
> -                  riscv_isa_extension_available(&isa, d)) {
> +                  riscv_isa_extension_available(vcpu->arch.isa, d)) {
>                 if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
>                         if (KVM_REG_SIZE(reg->id) != sizeof(u32))
>                                 return -EINVAL;
> --
> 2.25.1
>

Apart from minor comments above, this looks good to me.

I have taken care of the above comments and queued it for 5.20. I
can certainly modify my queue if you want further changes in this patch.

Thanks,
Anup
