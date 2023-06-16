Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119817328F6
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244763AbjFPHeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjFPHeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:34:12 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95642DF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:34:09 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b43a99c887so4016471fa.2
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 00:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686900848; x=1689492848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AhYRYHpfaZ+p6+Cii/7BzV//5AE9PyljanZxUPSkRM=;
        b=dfuO3kz+1dS0kIkh7kNGM1AgDOyVzCimQu1MYQDEjd5S2PXS1a54C8c3WngkQ1wKV0
         4yPAfvAgUXu97lHVywyLs+e3JlW3bEOQrIS3C4+gAkYY1m1BL/ZI/0Bsj3euIurYOrhV
         dI7pWEDKs0PARp2HCG1SIRLUjDHov/cVzioS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686900848; x=1689492848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AhYRYHpfaZ+p6+Cii/7BzV//5AE9PyljanZxUPSkRM=;
        b=UYJBGdD2HDEB4bfZiOho7RP3QONWMNUsfgpKWWi7//LjwjmT6Jnf5ltKg6fiY4M9DF
         M2l3sND8zdqokcUV1Rv59mf2T7KYoxNjaAnidGJZO+4g3CqMPZqYSMIbB9o7FPwGPqgG
         FKcNQPm7vYBP87S4ti1cVx5bpH8lo2lHmdjmubbU69/t95S3+OazcwPe7dgusrXrOhub
         Rsr2x3br5bsbxfXySqn0RqI9BfL2xzey71fJKLP4qWkXqHHsKus6L8rgkrrh/nGb3Xq0
         66ZocPT9i7jYoNOLGrUi9Vm0+r7BdChskA3BnsaiIqRBgK9rUzhgOJwXwg6nyl07gvis
         r90w==
X-Gm-Message-State: AC+VfDxFjZaVPk33t7M7O0nPTiSI/DaOQRpaYmSUC8r9jb+6+oOq9JZq
        PzIyk+ulpF2P7bcZiLCIcXGf8C88JOmya7j/uzVz
X-Google-Smtp-Source: ACHHUZ5zvxCjJd+6So3lVwpINWZTTjPkrXt9cHwR6q9nTUoww0jaEq4/dz06m93MwLBq92AQXsrF5lni/u1LF32YJrg=
X-Received: by 2002:a2e:b0ef:0:b0:2af:1dba:d44 with SMTP id
 h15-20020a2eb0ef000000b002af1dba0d44mr1060750ljl.34.1686900847502; Fri, 16
 Jun 2023 00:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230615073353.85435-1-apatel@ventanamicro.com> <20230615073353.85435-8-apatel@ventanamicro.com>
In-Reply-To: <20230615073353.85435-8-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 16 Jun 2023 00:33:55 -0700
Message-ID: <CAOnJCUJQFVhUBkHExpEKZhoa_ztVrEjtacy72QCz_-VsYgC1+A@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] RISC-V: KVM: Add in-kernel emulation of AIA APLIC
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 12:34=E2=80=AFAM Anup Patel <apatel@ventanamicro.co=
m> wrote:
>
> There is no virtualization support in AIA APLIC so we add in-kernel
> emulation of AIA APLIC which only supports MSI-mode (i.e. wired
> interrupts forwarded to AIA IMSIC as MSIs).
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h |  17 +-
>  arch/riscv/kvm/Makefile          |   1 +
>  arch/riscv/kvm/aia_aplic.c       | 576 +++++++++++++++++++++++++++++++
>  3 files changed, 580 insertions(+), 14 deletions(-)
>  create mode 100644 arch/riscv/kvm/aia_aplic.c
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index a1281ebc9b92..f6bd8523395f 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -129,20 +129,9 @@ static inline void kvm_riscv_vcpu_aia_imsic_cleanup(=
struct kvm_vcpu *vcpu)
>  {
>  }
>
> -static inline int kvm_riscv_aia_aplic_inject(struct kvm *kvm,
> -                                            u32 source, bool level)
> -{
> -       return 0;
> -}
> -
> -static inline int kvm_riscv_aia_aplic_init(struct kvm *kvm)
> -{
> -       return 0;
> -}
> -
> -static inline void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
> -{
> -}
> +int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level);
> +int kvm_riscv_aia_aplic_init(struct kvm *kvm);
> +void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm);
>
>  #ifdef CONFIG_32BIT
>  void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index dd69ebe098bd..94c43702c765 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -28,3 +28,4 @@ kvm-y +=3D vcpu_timer.o
>  kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu.o vcpu_sbi_pmu.o
>  kvm-y +=3D aia.o
>  kvm-y +=3D aia_device.o
> +kvm-y +=3D aia_aplic.o
> diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
> new file mode 100644
> index 000000000000..eecd8f4abe21
> --- /dev/null
> +++ b/arch/riscv/kvm/aia_aplic.c
> @@ -0,0 +1,576 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + *
> + * Authors:
> + *     Anup Patel <apatel@ventanamicro.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/math.h>
> +#include <linux/spinlock.h>
> +#include <linux/swab.h>
> +#include <kvm/iodev.h>
> +#include <asm/kvm_aia_aplic.h>
> +
> +struct aplic_irq {
> +       raw_spinlock_t lock;
> +       u32 sourcecfg;
> +       u32 state;
> +#define APLIC_IRQ_STATE_PENDING                BIT(0)
> +#define APLIC_IRQ_STATE_ENABLED                BIT(1)
> +#define APLIC_IRQ_STATE_ENPEND         (APLIC_IRQ_STATE_PENDING | \
> +                                        APLIC_IRQ_STATE_ENABLED)
> +#define APLIC_IRQ_STATE_INPUT          BIT(8)
> +       u32 target;
> +};
> +
> +struct aplic {
> +       struct kvm_io_device iodev;
> +
> +       u32 domaincfg;
> +       u32 genmsi;
> +
> +       u32 nr_irqs;
> +       u32 nr_words;
> +       struct aplic_irq *irqs;
> +};
> +
> +static u32 aplic_read_sourcecfg(struct aplic *aplic, u32 irq)
> +{
> +       u32 ret;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return 0;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       ret =3D irqd->sourcecfg;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void aplic_write_sourcecfg(struct aplic *aplic, u32 irq, u32 val)
> +{
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       if (val & APLIC_SOURCECFG_D)
> +               val =3D 0;
> +       else
> +               val &=3D APLIC_SOURCECFG_SM_MASK;
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       irqd->sourcecfg =3D val;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +}
> +
> +static u32 aplic_read_target(struct aplic *aplic, u32 irq)
> +{
> +       u32 ret;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return 0;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       ret =3D irqd->target;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void aplic_write_target(struct aplic *aplic, u32 irq, u32 val)
> +{
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       val &=3D APLIC_TARGET_EIID_MASK |
> +              (APLIC_TARGET_HART_IDX_MASK << APLIC_TARGET_HART_IDX_SHIFT=
) |
> +              (APLIC_TARGET_GUEST_IDX_MASK << APLIC_TARGET_GUEST_IDX_SHI=
FT);
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       irqd->target =3D val;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +}
> +
> +static bool aplic_read_pending(struct aplic *aplic, u32 irq)
> +{
> +       bool ret;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return false;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       ret =3D (irqd->state & APLIC_IRQ_STATE_PENDING) ? true : false;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pendi=
ng)
> +{
> +       unsigned long flags, sm;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +
> +       sm =3D irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK;
> +       if (!pending &&
> +           ((sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_HIGH) ||
> +            (sm =3D=3D APLIC_SOURCECFG_SM_LEVEL_LOW)))
> +               goto skip_write_pending;
> +
> +       if (pending)
> +               irqd->state |=3D APLIC_IRQ_STATE_PENDING;
> +       else
> +               irqd->state &=3D ~APLIC_IRQ_STATE_PENDING;
> +
> +skip_write_pending:
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +}
> +
> +static bool aplic_read_enabled(struct aplic *aplic, u32 irq)
> +{
> +       bool ret;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return false;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       ret =3D (irqd->state & APLIC_IRQ_STATE_ENABLED) ? true : false;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void aplic_write_enabled(struct aplic *aplic, u32 irq, bool enabl=
ed)
> +{
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       if (enabled)
> +               irqd->state |=3D APLIC_IRQ_STATE_ENABLED;
> +       else
> +               irqd->state &=3D ~APLIC_IRQ_STATE_ENABLED;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +}
> +
> +static bool aplic_read_input(struct aplic *aplic, u32 irq)
> +{
> +       bool ret;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +
> +       if (!irq || aplic->nr_irqs <=3D irq)
> +               return false;
> +       irqd =3D &aplic->irqs[irq];
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +       ret =3D (irqd->state & APLIC_IRQ_STATE_INPUT) ? true : false;
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       return ret;
> +}
> +
> +static void aplic_inject_msi(struct kvm *kvm, u32 irq, u32 target)
> +{
> +       u32 hart_idx, guest_idx, eiid;
> +
> +       hart_idx =3D target >> APLIC_TARGET_HART_IDX_SHIFT;
> +       hart_idx &=3D APLIC_TARGET_HART_IDX_MASK;
> +       guest_idx =3D target >> APLIC_TARGET_GUEST_IDX_SHIFT;
> +       guest_idx &=3D APLIC_TARGET_GUEST_IDX_MASK;
> +       eiid =3D target & APLIC_TARGET_EIID_MASK;
> +       kvm_riscv_aia_inject_msi_by_id(kvm, hart_idx, guest_idx, eiid);
> +}
> +
> +static void aplic_update_irq_range(struct kvm *kvm, u32 first, u32 last)
> +{
> +       bool inject;
> +       u32 irq, target;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +       struct aplic *aplic =3D kvm->arch.aia.aplic_state;
> +
> +       if (!(aplic->domaincfg & APLIC_DOMAINCFG_IE))
> +               return;
> +
> +       for (irq =3D first; irq <=3D last; irq++) {
> +               if (!irq || aplic->nr_irqs <=3D irq)
> +                       continue;
> +               irqd =3D &aplic->irqs[irq];
> +
> +               raw_spin_lock_irqsave(&irqd->lock, flags);
> +
> +               inject =3D false;
> +               target =3D irqd->target;
> +               if ((irqd->state & APLIC_IRQ_STATE_ENPEND) =3D=3D
> +                   APLIC_IRQ_STATE_ENPEND) {
> +                       irqd->state &=3D ~APLIC_IRQ_STATE_PENDING;
> +                       inject =3D true;
> +               }
> +
> +               raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +               if (inject)
> +                       aplic_inject_msi(kvm, irq, target);
> +       }
> +}
> +
> +int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level)
> +{
> +       u32 target;
> +       bool inject =3D false, ie;
> +       unsigned long flags;
> +       struct aplic_irq *irqd;
> +       struct aplic *aplic =3D kvm->arch.aia.aplic_state;
> +
> +       if (!aplic || !source || (aplic->nr_irqs <=3D source))
> +               return -ENODEV;
> +       irqd =3D &aplic->irqs[source];
> +       ie =3D (aplic->domaincfg & APLIC_DOMAINCFG_IE) ? true : false;
> +
> +       raw_spin_lock_irqsave(&irqd->lock, flags);
> +
> +       if (irqd->sourcecfg & APLIC_SOURCECFG_D)
> +               goto skip_unlock;
> +
> +       switch (irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK) {
> +       case APLIC_SOURCECFG_SM_EDGE_RISE:
> +               if (level && !(irqd->state & APLIC_IRQ_STATE_INPUT) &&
> +                   !(irqd->state & APLIC_IRQ_STATE_PENDING))
> +                       irqd->state |=3D APLIC_IRQ_STATE_PENDING;
> +               break;
> +       case APLIC_SOURCECFG_SM_EDGE_FALL:
> +               if (!level && (irqd->state & APLIC_IRQ_STATE_INPUT) &&
> +                   !(irqd->state & APLIC_IRQ_STATE_PENDING))
> +                       irqd->state |=3D APLIC_IRQ_STATE_PENDING;
> +               break;
> +       case APLIC_SOURCECFG_SM_LEVEL_HIGH:
> +               if (level && !(irqd->state & APLIC_IRQ_STATE_PENDING))
> +                       irqd->state |=3D APLIC_IRQ_STATE_PENDING;
> +               break;
> +       case APLIC_SOURCECFG_SM_LEVEL_LOW:
> +               if (!level && !(irqd->state & APLIC_IRQ_STATE_PENDING))
> +                       irqd->state |=3D APLIC_IRQ_STATE_PENDING;
> +               break;
> +       }
> +
> +       if (level)
> +               irqd->state |=3D APLIC_IRQ_STATE_INPUT;
> +       else
> +               irqd->state &=3D ~APLIC_IRQ_STATE_INPUT;
> +
> +       target =3D irqd->target;
> +       if (ie && ((irqd->state & APLIC_IRQ_STATE_ENPEND) =3D=3D
> +                  APLIC_IRQ_STATE_ENPEND)) {
> +               irqd->state &=3D ~APLIC_IRQ_STATE_PENDING;
> +               inject =3D true;
> +       }
> +
> +skip_unlock:
> +       raw_spin_unlock_irqrestore(&irqd->lock, flags);
> +
> +       if (inject)
> +               aplic_inject_msi(kvm, source, target);
> +
> +       return 0;
> +}
> +
> +static u32 aplic_read_input_word(struct aplic *aplic, u32 word)
> +{
> +       u32 i, ret =3D 0;
> +
> +       for (i =3D 0; i < 32; i++)
> +               ret |=3D aplic_read_input(aplic, word * 32 + i) ? BIT(i) =
: 0;
> +
> +       return ret;
> +}
> +
> +static u32 aplic_read_pending_word(struct aplic *aplic, u32 word)
> +{
> +       u32 i, ret =3D 0;
> +
> +       for (i =3D 0; i < 32; i++)
> +               ret |=3D aplic_read_pending(aplic, word * 32 + i) ? BIT(i=
) : 0;
> +
> +       return ret;
> +}
> +
> +static void aplic_write_pending_word(struct aplic *aplic, u32 word,
> +                                    u32 val, bool pending)
> +{
> +       u32 i;
> +
> +       for (i =3D 0; i < 32; i++) {
> +               if (val & BIT(i))
> +                       aplic_write_pending(aplic, word * 32 + i, pending=
);
> +       }
> +}
> +
> +static u32 aplic_read_enabled_word(struct aplic *aplic, u32 word)
> +{
> +       u32 i, ret =3D 0;
> +
> +       for (i =3D 0; i < 32; i++)
> +               ret |=3D aplic_read_enabled(aplic, word * 32 + i) ? BIT(i=
) : 0;
> +
> +       return ret;
> +}
> +
> +static void aplic_write_enabled_word(struct aplic *aplic, u32 word,
> +                                    u32 val, bool enabled)
> +{
> +       u32 i;
> +
> +       for (i =3D 0; i < 32; i++) {
> +               if (val & BIT(i))
> +                       aplic_write_enabled(aplic, word * 32 + i, enabled=
);
> +       }
> +}
> +
> +static int aplic_mmio_read_offset(struct kvm *kvm, gpa_t off, u32 *val32=
)
> +{
> +       u32 i;
> +       struct aplic *aplic =3D kvm->arch.aia.aplic_state;
> +
> +       if ((off & 0x3) !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       if (off =3D=3D APLIC_DOMAINCFG) {
> +               *val32 =3D APLIC_DOMAINCFG_RDONLY |
> +                        aplic->domaincfg | APLIC_DOMAINCFG_DM;
> +       } else if ((off >=3D APLIC_SOURCECFG_BASE) &&
> +                (off < (APLIC_SOURCECFG_BASE + (aplic->nr_irqs - 1) * 4)=
)) {
> +               i =3D ((off - APLIC_SOURCECFG_BASE) >> 2) + 1;
> +               *val32 =3D aplic_read_sourcecfg(aplic, i);
> +       } else if ((off >=3D APLIC_SETIP_BASE) &&
> +                  (off < (APLIC_SETIP_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_SETIP_BASE) >> 2;
> +               *val32 =3D aplic_read_pending_word(aplic, i);
> +       } else if (off =3D=3D APLIC_SETIPNUM) {
> +               *val32 =3D 0;
> +       } else if ((off >=3D APLIC_CLRIP_BASE) &&
> +                  (off < (APLIC_CLRIP_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_CLRIP_BASE) >> 2;
> +               *val32 =3D aplic_read_input_word(aplic, i);
> +       } else if (off =3D=3D APLIC_CLRIPNUM) {
> +               *val32 =3D 0;
> +       } else if ((off >=3D APLIC_SETIE_BASE) &&
> +                  (off < (APLIC_SETIE_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_SETIE_BASE) >> 2;
> +               *val32 =3D aplic_read_enabled_word(aplic, i);
> +       } else if (off =3D=3D APLIC_SETIENUM) {
> +               *val32 =3D 0;
> +       } else if ((off >=3D APLIC_CLRIE_BASE) &&
> +                  (off < (APLIC_CLRIE_BASE + aplic->nr_words * 4))) {
> +               *val32 =3D 0;
> +       } else if (off =3D=3D APLIC_CLRIENUM) {
> +               *val32 =3D 0;
> +       } else if (off =3D=3D APLIC_SETIPNUM_LE) {
> +               *val32 =3D 0;
> +       } else if (off =3D=3D APLIC_SETIPNUM_BE) {
> +               *val32 =3D 0;
> +       } else if (off =3D=3D APLIC_GENMSI) {
> +               *val32 =3D aplic->genmsi;
> +       } else if ((off >=3D APLIC_TARGET_BASE) &&
> +                  (off < (APLIC_TARGET_BASE + (aplic->nr_irqs - 1) * 4))=
) {
> +               i =3D ((off - APLIC_TARGET_BASE) >> 2) + 1;
> +               *val32 =3D aplic_read_target(aplic, i);
> +       } else
> +               return -ENODEV;
> +
> +       return 0;
> +}
> +
> +static int aplic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *=
dev,
> +                          gpa_t addr, int len, void *val)
> +{
> +       if (len !=3D 4)
> +               return -EOPNOTSUPP;
> +
> +       return aplic_mmio_read_offset(vcpu->kvm,
> +                                     addr - vcpu->kvm->arch.aia.aplic_ad=
dr,
> +                                     val);
> +}
> +
> +static int aplic_mmio_write_offset(struct kvm *kvm, gpa_t off, u32 val32=
)
> +{
> +       u32 i;
> +       struct aplic *aplic =3D kvm->arch.aia.aplic_state;
> +
> +       if ((off & 0x3) !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       if (off =3D=3D APLIC_DOMAINCFG) {
> +               /* Only IE bit writeable */
> +               aplic->domaincfg =3D val32 & APLIC_DOMAINCFG_IE;
> +       } else if ((off >=3D APLIC_SOURCECFG_BASE) &&
> +                (off < (APLIC_SOURCECFG_BASE + (aplic->nr_irqs - 1) * 4)=
)) {
> +               i =3D ((off - APLIC_SOURCECFG_BASE) >> 2) + 1;
> +               aplic_write_sourcecfg(aplic, i, val32);
> +       } else if ((off >=3D APLIC_SETIP_BASE) &&
> +                  (off < (APLIC_SETIP_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_SETIP_BASE) >> 2;
> +               aplic_write_pending_word(aplic, i, val32, true);
> +       } else if (off =3D=3D APLIC_SETIPNUM) {
> +               aplic_write_pending(aplic, val32, true);
> +       } else if ((off >=3D APLIC_CLRIP_BASE) &&
> +                  (off < (APLIC_CLRIP_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_CLRIP_BASE) >> 2;
> +               aplic_write_pending_word(aplic, i, val32, false);
> +       } else if (off =3D=3D APLIC_CLRIPNUM) {
> +               aplic_write_pending(aplic, val32, false);
> +       } else if ((off >=3D APLIC_SETIE_BASE) &&
> +                  (off < (APLIC_SETIE_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_SETIE_BASE) >> 2;
> +               aplic_write_enabled_word(aplic, i, val32, true);
> +       } else if (off =3D=3D APLIC_SETIENUM) {
> +               aplic_write_enabled(aplic, val32, true);
> +       } else if ((off >=3D APLIC_CLRIE_BASE) &&
> +                  (off < (APLIC_CLRIE_BASE + aplic->nr_words * 4))) {
> +               i =3D (off - APLIC_CLRIE_BASE) >> 2;
> +               aplic_write_enabled_word(aplic, i, val32, false);
> +       } else if (off =3D=3D APLIC_CLRIENUM) {
> +               aplic_write_enabled(aplic, val32, false);
> +       } else if (off =3D=3D APLIC_SETIPNUM_LE) {
> +               aplic_write_pending(aplic, val32, true);
> +       } else if (off =3D=3D APLIC_SETIPNUM_BE) {
> +               aplic_write_pending(aplic, __swab32(val32), true);
> +       } else if (off =3D=3D APLIC_GENMSI) {
> +               aplic->genmsi =3D val32 & ~(APLIC_TARGET_GUEST_IDX_MASK <=
<
> +                                         APLIC_TARGET_GUEST_IDX_SHIFT);
> +               kvm_riscv_aia_inject_msi_by_id(kvm,
> +                               val32 >> APLIC_TARGET_HART_IDX_SHIFT, 0,
> +                               val32 & APLIC_TARGET_EIID_MASK);
> +       } else if ((off >=3D APLIC_TARGET_BASE) &&
> +                  (off < (APLIC_TARGET_BASE + (aplic->nr_irqs - 1) * 4))=
) {
> +               i =3D ((off - APLIC_TARGET_BASE) >> 2) + 1;
> +               aplic_write_target(aplic, i, val32);
> +       } else
> +               return -ENODEV;
> +
> +       aplic_update_irq_range(kvm, 1, aplic->nr_irqs - 1);
> +
> +       return 0;
> +}
> +
> +static int aplic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device =
*dev,
> +                           gpa_t addr, int len, const void *val)
> +{
> +       if (len !=3D 4)
> +               return -EOPNOTSUPP;
> +
> +       return aplic_mmio_write_offset(vcpu->kvm,
> +                                      addr - vcpu->kvm->arch.aia.aplic_a=
ddr,
> +                                      *((const u32 *)val));
> +}
> +
> +static struct kvm_io_device_ops aplic_iodoev_ops =3D {
> +       .read =3D aplic_mmio_read,
> +       .write =3D aplic_mmio_write,
> +};
> +
> +int kvm_riscv_aia_aplic_init(struct kvm *kvm)
> +{
> +       int i, ret =3D 0;
> +       struct aplic *aplic;
> +
> +       /* Do nothing if we have zero sources */
> +       if (!kvm->arch.aia.nr_sources)
> +               return 0;
> +
> +       /* Allocate APLIC global state */
> +       aplic =3D kzalloc(sizeof(*aplic), GFP_KERNEL);
> +       if (!aplic)
> +               return -ENOMEM;
> +       kvm->arch.aia.aplic_state =3D aplic;
> +
> +       /* Setup APLIC IRQs */
> +       aplic->nr_irqs =3D kvm->arch.aia.nr_sources + 1;
> +       aplic->nr_words =3D DIV_ROUND_UP(aplic->nr_irqs, 32);
> +       aplic->irqs =3D kcalloc(aplic->nr_irqs,
> +                             sizeof(*aplic->irqs), GFP_KERNEL);
> +       if (!aplic->irqs) {
> +               ret =3D -ENOMEM;
> +               goto fail_free_aplic;
> +       }
> +       for (i =3D 0; i < aplic->nr_irqs; i++)
> +               raw_spin_lock_init(&aplic->irqs[i].lock);
> +
> +       /* Setup IO device */
> +       kvm_iodevice_init(&aplic->iodev, &aplic_iodoev_ops);
> +       mutex_lock(&kvm->slots_lock);
> +       ret =3D kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
> +                                     kvm->arch.aia.aplic_addr,
> +                                     KVM_DEV_RISCV_APLIC_SIZE,
> +                                     &aplic->iodev);
> +       mutex_unlock(&kvm->slots_lock);
> +       if (ret)
> +               goto fail_free_aplic_irqs;
> +
> +       /* Setup default IRQ routing */
> +       ret =3D kvm_riscv_setup_default_irq_routing(kvm, aplic->nr_irqs);
> +       if (ret)
> +               goto fail_unreg_iodev;
> +
> +       return 0;
> +
> +fail_unreg_iodev:
> +       mutex_lock(&kvm->slots_lock);
> +       kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &aplic->iodev);
> +       mutex_unlock(&kvm->slots_lock);
> +fail_free_aplic_irqs:
> +       kfree(aplic->irqs);
> +fail_free_aplic:
> +       kvm->arch.aia.aplic_state =3D NULL;
> +       kfree(aplic);
> +       return ret;
> +}
> +
> +void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
> +{
> +       struct aplic *aplic =3D kvm->arch.aia.aplic_state;
> +
> +       if (!aplic)
> +               return;
> +
> +       mutex_lock(&kvm->slots_lock);
> +       kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &aplic->iodev);
> +       mutex_unlock(&kvm->slots_lock);
> +
> +       kfree(aplic->irqs);
> +
> +       kvm->arch.aia.aplic_state =3D NULL;
> +       kfree(aplic);
> +}
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
