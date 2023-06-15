Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F88730EB1
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 07:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbjFOFdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 01:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbjFOFdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 01:33:52 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFA410A
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 22:33:49 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-558cf3e9963so1206495eaf.1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 22:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1686807229; x=1689399229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVuZclG4Cda/5LV9eJvrnxHKu3TmQ8yWbJn35s3zZlg=;
        b=REtIKuqqlqV5xd+LNvJdGcf2lXY8JrBdZFxLSMkawJOCKtY6BMj5boJjQ52h2Y6eTj
         eVdMIoLc0s51O/2UPHCypxJyMIInmlyPUbnqUlNL3Rg1O/0dqLWspZthqyjpJBiJp06L
         z4TlwZ8Spl4lP0nx5kB/2tpuWsrTow973XxAx4aoKOvKqny4o33aopP+oLv4LqT5jitZ
         4Eq8S1NT/Mk5qsD9iDS99yhq6n30rfJKc/nozT4iCjBkEXPvWav71X8Xq7S8OzQkdoN3
         V3tBDBwZ1A1+XcJkkQ2rl91veOqe9+d2/R00e2E3ra0BRgDUVc1JRIRpFh2zEuYORWVD
         r7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686807229; x=1689399229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVuZclG4Cda/5LV9eJvrnxHKu3TmQ8yWbJn35s3zZlg=;
        b=MwhSbLtWG0UcGl+JlZq2K3tS8xMikCyUPu6j/eRqgvS7lxtBlw9t6Zom6qEdZylqHy
         parTETthWlpXBJD6PJ35BJkBsO53FPrDyRo89+z1A28syXMqzuqQ56KB5Y9nrv33CuV2
         jg3PNLS1Jt6oRCiQqtkRh901QQNkVYfYiYCjGugDlBR2z0M0XhdksLEdEeDsoAsxQYEy
         BwcCEtYUFdHN7dmBmaJR1H0b1sG5M2XcVqvRp5PW1PWKSP9tj1IUvfbc80dKuMQaVdq0
         BOdgvrTnS880lsEGzFilIMxWKLeCWkcfIazW90b5g4pw6n/NMXQY43u7BU+yXCEoxUxY
         tV+g==
X-Gm-Message-State: AC+VfDzQ4ofIJUarQGW12thJyd2+3umpvnv15fbrBwbfmcl8U5xaq3Gr
        3qEUaRKiWsVoKWeoQdwvmbuHVjQltNlFputDmoxgpQ==
X-Google-Smtp-Source: ACHHUZ5yxeONWCOFmuxuJCvcq1tsZ8tg8wKv1hr2m+jVZLw4EQUQmytFPAdKU3oswTUe/qJenIaUEjSHSFetnKwQsFk=
X-Received: by 2002:a05:6820:508:b0:55b:2d40:5f13 with SMTP id
 m8-20020a056820050800b0055b2d405f13mr13766465ooj.0.1686807228594; Wed, 14 Jun
 2023 22:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230612053932.58604-1-apatel@ventanamicro.com> <20230612053932.58604-7-apatel@ventanamicro.com>
In-Reply-To: <20230612053932.58604-7-apatel@ventanamicro.com>
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date:   Thu, 15 Jun 2023 13:33:38 +0800
Message-ID: <CAMWQL2gRgATzQJxiUZ610R-hfmrW+3mFu-kf7cVeUB1X6isKBw@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] RISC-V: KVM: Implement device interface for AIA irqchip
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Vincent Chen <vincent.chen@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anup,

On Mon, Jun 12, 2023 at 1:41=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> We implement KVM device interface for in-kernel AIA irqchip so that
> user-space can use KVM device ioctls to create, configure, and destroy
> in-kernel AIA irqchip.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  | 132 +++++--
>  arch/riscv/include/uapi/asm/kvm.h |  45 +++
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              |  11 +
>  arch/riscv/kvm/aia_device.c       | 622 ++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |   2 +
>  6 files changed, 771 insertions(+), 42 deletions(-)
>  create mode 100644 arch/riscv/kvm/aia_device.c
>
> diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kv=
m_aia.h
> index 3bc0a0e47a15..a1281ebc9b92 100644
> --- a/arch/riscv/include/asm/kvm_aia.h
> +++ b/arch/riscv/include/asm/kvm_aia.h
> @@ -20,6 +20,33 @@ struct kvm_aia {
>
>         /* In-kernel irqchip initialized */
>         bool            initialized;
> +
> +       /* Virtualization mode (Emulation, HW Accelerated, or Auto) */
> +       u32             mode;
> +
> +       /* Number of MSIs */
> +       u32             nr_ids;
> +
> +       /* Number of wired IRQs */
> +       u32             nr_sources;
> +
> +       /* Number of group bits in IMSIC address */
> +       u32             nr_group_bits;
> +
> +       /* Position of group bits in IMSIC address */
> +       u32             nr_group_shift;
> +
> +       /* Number of hart bits in IMSIC address */
> +       u32             nr_hart_bits;
> +
> +       /* Number of guest bits in IMSIC address */
> +       u32             nr_guest_bits;
> +
> +       /* Guest physical address of APLIC */
> +       gpa_t           aplic_addr;
> +
> +       /* Internal state of APLIC */
> +       void            *aplic_state;
>  };
>
>  struct kvm_vcpu_aia_csr {
> @@ -38,8 +65,19 @@ struct kvm_vcpu_aia {
>
>         /* CPU AIA CSR context upon Guest VCPU reset */
>         struct kvm_vcpu_aia_csr guest_reset_csr;
> +
> +       /* Guest physical address of IMSIC for this VCPU */
> +       gpa_t           imsic_addr;
> +
> +       /* HART index of IMSIC extacted from guest physical address */
> +       u32             hart_index;
> +
> +       /* Internal state of IMSIC for this VCPU */
> +       void            *imsic_state;
>  };
>
> +#define KVM_RISCV_AIA_UNDEF_ADDR       (-1)
> +
>  #define kvm_riscv_aia_initialized(k)   ((k)->arch.aia.initialized)
>
>  #define irqchip_in_kernel(k)           ((k)->arch.aia.in_kernel)
> @@ -50,10 +88,17 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
>  #define kvm_riscv_aia_available() \
>         static_branch_unlikely(&kvm_riscv_aia_available)
>
> +extern struct kvm_device_ops kvm_riscv_aia_device_ops;
> +
>  static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcp=
u)
>  {
>  }
>
> +static inline int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
> +{
> +       return 1;
> +}
> +
>  #define KVM_RISCV_AIA_IMSIC_TOPEI      (ISELECT_MASK + 1)
>  static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
>                                                unsigned long isel,
> @@ -64,6 +109,41 @@ static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct=
 kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static inline void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> +                                                 u32 guest_index, u32 of=
fset,
> +                                                 u32 iid)
> +{
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
> +{
> +       return 0;
> +}
> +
> +static inline void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcp=
u)
> +{
> +}
> +
> +static inline int kvm_riscv_aia_aplic_inject(struct kvm *kvm,
> +                                            u32 source, bool level)
> +{
> +       return 0;
> +}
> +
> +static inline int kvm_riscv_aia_aplic_init(struct kvm *kvm)
> +{
> +       return 0;
> +}
> +
> +static inline void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
> +{
> +}
> +
>  #ifdef CONFIG_32BIT
>  void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu);
> @@ -99,50 +179,18 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcp=
u, unsigned int csr_num,
>  { .base =3D CSR_SIREG,      .count =3D 1, .func =3D kvm_riscv_vcpu_aia_r=
mw_ireg }, \
>  { .base =3D CSR_STOPEI,     .count =3D 1, .func =3D kvm_riscv_vcpu_aia_r=
mw_topei },
>
> -static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
> -{
> -       return 1;
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
> -{
> -       return 0;
> -}
> -
> -static inline void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
> -{
> -}
> -
> -static inline int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm,
> -                                                u32 hart_index,
> -                                                u32 guest_index, u32 iid=
)
> -{
> -       return 0;
> -}
> -
> -static inline int kvm_riscv_aia_inject_msi(struct kvm *kvm,
> -                                          struct kvm_msi *msi)
> -{
> -       return 0;
> -}
> +int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
>
> -static inline int kvm_riscv_aia_inject_irq(struct kvm *kvm,
> -                                          unsigned int irq, bool level)
> -{
> -       return 0;
> -}
> +int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
> +                                  u32 guest_index, u32 iid);
> +int kvm_riscv_aia_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
> +int kvm_riscv_aia_inject_irq(struct kvm *kvm, unsigned int irq, bool lev=
el);
>
> -static inline void kvm_riscv_aia_init_vm(struct kvm *kvm)
> -{
> -}
> -
> -static inline void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
> -{
> -}
> +void kvm_riscv_aia_init_vm(struct kvm *kvm);
> +void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
>
>  int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
>                              void __iomem **hgei_va, phys_addr_t *hgei_pa=
);
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 332d4a274891..047c8fc5bd71 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -204,6 +204,51 @@ enum KVM_RISCV_SBI_EXT_ID {
>  #define KVM_REG_RISCV_SBI_MULTI_REG_LAST       \
>                 KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
>
> +/* Device Control API: RISC-V AIA */
> +#define KVM_DEV_RISCV_APLIC_ALIGN              0x1000
> +#define KVM_DEV_RISCV_APLIC_SIZE               0x4000
> +#define KVM_DEV_RISCV_APLIC_MAX_HARTS          0x4000
> +#define KVM_DEV_RISCV_IMSIC_ALIGN              0x1000
> +#define KVM_DEV_RISCV_IMSIC_SIZE               0x1000
> +
> +#define KVM_DEV_RISCV_AIA_GRP_CONFIG           0
> +#define KVM_DEV_RISCV_AIA_CONFIG_MODE          0
> +#define KVM_DEV_RISCV_AIA_CONFIG_IDS           1
> +#define KVM_DEV_RISCV_AIA_CONFIG_SRCS          2
> +#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS    3
> +#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT   4
> +#define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS     5
> +#define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS    6
> +
> +/*
> + * Modes of RISC-V AIA device:
> + * 1) EMUL (aka Emulation): Trap-n-emulate IMSIC
> + * 2) HWACCEL (aka HW Acceleration): Virtualize IMSIC using IMSIC guest =
files
> + * 3) AUTO (aka Automatic): Virtualize IMSIC using IMSIC guest files whe=
never
> + *    available otherwise fallback to trap-n-emulation
> + */
> +#define KVM_DEV_RISCV_AIA_MODE_EMUL            0
> +#define KVM_DEV_RISCV_AIA_MODE_HWACCEL         1
> +#define KVM_DEV_RISCV_AIA_MODE_AUTO            2
> +
> +#define KVM_DEV_RISCV_AIA_IDS_MIN              63
> +#define KVM_DEV_RISCV_AIA_IDS_MAX              2048
> +#define KVM_DEV_RISCV_AIA_SRCS_MAX             1024
> +#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX       8
> +#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN      24
> +#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX      56
> +#define KVM_DEV_RISCV_AIA_HART_BITS_MAX                16
> +#define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX       8
> +
> +#define KVM_DEV_RISCV_AIA_GRP_ADDR             1
> +#define KVM_DEV_RISCV_AIA_ADDR_APLIC           0
> +#define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)   (1 + (__vcpu))
> +#define KVM_DEV_RISCV_AIA_ADDR_MAX             \
> +               (1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
> +
> +#define KVM_DEV_RISCV_AIA_GRP_CTRL             2
> +#define KVM_DEV_RISCV_AIA_CTRL_INIT            0
> +
>  /* One single KVM irqchip, ie. the AIA */
>  #define KVM_NR_IRQCHIPS                        1
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 8031b8912a0d..dd69ebe098bd 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -27,3 +27,4 @@ kvm-y +=3D vcpu_sbi_hsm.o
>  kvm-y +=3D vcpu_timer.o
>  kvm-$(CONFIG_RISCV_PMU_SBI) +=3D vcpu_pmu.o vcpu_sbi_pmu.o
>  kvm-y +=3D aia.o
> +kvm-y +=3D aia_device.o
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 18c442c15ff2..585a3b42c52c 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -631,6 +631,14 @@ int kvm_riscv_aia_init(void)
>         if (rc)
>                 return rc;
>
> +       /* Register device operations */
> +       rc =3D kvm_register_device_ops(&kvm_riscv_aia_device_ops,
> +                                    KVM_DEV_TYPE_RISCV_AIA);
> +       if (rc) {
> +               aia_hgei_exit();
> +               return rc;
> +       }
> +
>         /* Enable KVM AIA support */
>         static_branch_enable(&kvm_riscv_aia_available);
>
> @@ -642,6 +650,9 @@ void kvm_riscv_aia_exit(void)
>         if (!kvm_riscv_aia_available())
>                 return;
>
> +       /* Unregister device operations */
> +       kvm_unregister_device_ops(KVM_DEV_TYPE_RISCV_AIA);
> +
>         /* Cleanup the HGEI state */
>         aia_hgei_exit();
>  }
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> new file mode 100644
> index 000000000000..a151fb357887
> --- /dev/null
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -0,0 +1,622 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + *
> + * Authors:
> + *     Anup Patel <apatel@ventanamicro.com>
> + */
> +
> +#include <linux/bits.h>
> +#include <linux/kvm_host.h>
> +#include <linux/uaccess.h>
> +#include <asm/kvm_aia_imsic.h>
> +
> +static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> +{
> +       struct kvm_vcpu *tmp_vcpu;
> +
> +       for (; vcpu_lock_idx >=3D 0; vcpu_lock_idx--) {
> +               tmp_vcpu =3D kvm_get_vcpu(kvm, vcpu_lock_idx);
> +               mutex_unlock(&tmp_vcpu->mutex);
> +       }
> +}
> +
> +static void unlock_all_vcpus(struct kvm *kvm)
> +{
> +       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> +}
> +
> +static bool lock_all_vcpus(struct kvm *kvm)
> +{
> +       struct kvm_vcpu *tmp_vcpu;
> +       unsigned long c;
> +
> +       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> +               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> +                       unlock_vcpus(kvm, c - 1);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
> +}
> +
> +static int aia_create(struct kvm_device *dev, u32 type)
> +{
> +       int ret;
> +       unsigned long i;
> +       struct kvm *kvm =3D dev->kvm;
> +       struct kvm_vcpu *vcpu;
> +
> +       if (irqchip_in_kernel(kvm))
> +               return -EEXIST;
> +
> +       ret =3D -EBUSY;
> +       if (!lock_all_vcpus(kvm))
> +               return ret;
> +
> +       kvm_for_each_vcpu(i, vcpu, kvm) {
> +               if (vcpu->arch.ran_atleast_once)
> +                       goto out_unlock;
> +       }
> +       ret =3D 0;
> +
> +       kvm->arch.aia.in_kernel =3D true;
> +
> +out_unlock:
> +       unlock_all_vcpus(kvm);
> +       return ret;
> +}
> +
> +static void aia_destroy(struct kvm_device *dev)
> +{
> +       kfree(dev);
> +}
> +
> +static int aia_config(struct kvm *kvm, unsigned long type,
> +                     u32 *nr, bool write)
> +{
> +       struct kvm_aia *aia =3D &kvm->arch.aia;
> +
> +       /* Writes can only be done before irqchip is initialized */
> +       if (write && kvm_riscv_aia_initialized(kvm))
> +               return -EBUSY;
> +
> +       switch (type) {
> +       case KVM_DEV_RISCV_AIA_CONFIG_MODE:
> +               if (write) {
> +                       switch (*nr) {
> +                       case KVM_DEV_RISCV_AIA_MODE_EMUL:
> +                               break;
> +                       case KVM_DEV_RISCV_AIA_MODE_HWACCEL:
> +                       case KVM_DEV_RISCV_AIA_MODE_AUTO:
> +                               /*
> +                                * HW Acceleration and Auto modes only
> +                                * supported on host with non-zero guest
> +                                * external interrupts (i.e. non-zero
> +                                * VS-level IMSIC pages).
> +                                */
> +                               if (!kvm_riscv_aia_nr_hgei)
> +                                       return -EINVAL;
> +                               break;
> +                       default:
> +                               return -EINVAL;
> +                       };
> +                       aia->mode =3D *nr;
> +               } else
> +                       *nr =3D aia->mode;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_IDS:
> +               if (write) {
> +                       if ((*nr < KVM_DEV_RISCV_AIA_IDS_MIN) ||
> +                           (*nr >=3D KVM_DEV_RISCV_AIA_IDS_MAX) ||
> +                           (*nr & KVM_DEV_RISCV_AIA_IDS_MIN) ||

The msi number is one less than a multiple of 64. This line should be
((*nr & KVM_DEV_RISCV_AIA_IDS_MIN) !=3D KVM_DEV_RISCV_AIA_IDS_MIN)

> +                           (kvm_riscv_aia_max_ids <=3D *nr))
> +                               return -EINVAL;
> +                       aia->nr_ids =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_ids;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_SRCS:
> +               if (write) {
> +                       if ((*nr >=3D KVM_DEV_RISCV_AIA_SRCS_MAX) ||
> +                           (*nr >=3D kvm_riscv_aia_max_ids))
> +                               return -EINVAL;
> +                       aia->nr_sources =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_sources;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS:
> +               if (write) {
> +                       if (*nr >=3D KVM_DEV_RISCV_AIA_GROUP_BITS_MAX)
> +                               return -EINVAL;
> +                       aia->nr_group_bits =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_group_bits;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT:
> +               if (write) {
> +                       if ((*nr < KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN) ||
> +                           (*nr >=3D KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX))
> +                               return -EINVAL;
> +                       aia->nr_group_shift =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_group_shift;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_HART_BITS:
> +               if (write) {
> +                       if (*nr >=3D KVM_DEV_RISCV_AIA_HART_BITS_MAX)
> +                               return -EINVAL;
> +                       aia->nr_hart_bits =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_hart_bits;
> +               break;
> +       case KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS:
> +               if (write) {
> +                       if (*nr >=3D KVM_DEV_RISCV_AIA_GUEST_BITS_MAX)
> +                               return -EINVAL;
> +                       aia->nr_guest_bits =3D *nr;
> +               } else
> +                       *nr =3D aia->nr_guest_bits;
> +               break;
> +       default:
> +               return -ENXIO;
> +       };
> +
> +       return 0;
> +}
> +
> +static int aia_aplic_addr(struct kvm *kvm, u64 *addr, bool write)
> +{
> +       struct kvm_aia *aia =3D &kvm->arch.aia;
> +
> +       if (write) {
> +               /* Writes can only be done before irqchip is initialized =
*/
> +               if (kvm_riscv_aia_initialized(kvm))
> +                       return -EBUSY;
> +
> +               if (*addr & (KVM_DEV_RISCV_APLIC_ALIGN - 1))
> +                       return -EINVAL;
> +
> +               aia->aplic_addr =3D *addr;
> +       } else
> +               *addr =3D aia->aplic_addr;
> +
> +       return 0;
> +}
> +
> +static int aia_imsic_addr(struct kvm *kvm, u64 *addr,
> +                         unsigned long vcpu_idx, bool write)
> +{
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vcpu_aia *vcpu_aia;
> +
> +       vcpu =3D kvm_get_vcpu(kvm, vcpu_idx);
> +       if (!vcpu)
> +               return -EINVAL;
> +       vcpu_aia =3D &vcpu->arch.aia_context;
> +
> +       if (write) {
> +               /* Writes can only be done before irqchip is initialized =
*/
> +               if (kvm_riscv_aia_initialized(kvm))
> +                       return -EBUSY;
> +
> +               if (*addr & (KVM_DEV_RISCV_IMSIC_ALIGN - 1))
> +                       return -EINVAL;
> +       }
> +
> +       mutex_lock(&vcpu->mutex);
> +       if (write)
> +               vcpu_aia->imsic_addr =3D *addr;
> +       else
> +               *addr =3D vcpu_aia->imsic_addr;
> +       mutex_unlock(&vcpu->mutex);
> +
> +       return 0;
> +}
> +
> +static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa_t addr)
> +{
> +       u32 h, l;
> +       gpa_t mask =3D 0;
> +
> +       h =3D aia->nr_hart_bits + aia->nr_guest_bits +
> +           IMSIC_MMIO_PAGE_SHIFT - 1;
> +       mask =3D GENMASK_ULL(h, 0);
> +
> +       if (aia->nr_group_bits) {
> +               h =3D aia->nr_group_bits + aia->nr_group_shift - 1;
> +               l =3D aia->nr_group_shift;
> +               mask |=3D GENMASK_ULL(h, l);
> +       }
> +
> +       return (addr & ~mask) >> IMSIC_MMIO_PAGE_SHIFT;
> +}
> +
> +static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
> +{
> +       u32 hart, group =3D 0;
> +
> +       hart =3D (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
> +               GENMASK_ULL(aia->nr_hart_bits - 1, 0);
> +       if (aia->nr_group_bits)
> +               group =3D (addr >> aia->nr_group_shift) &
> +                       GENMASK_ULL(aia->nr_group_bits - 1, 0);
> +
> +       return (group << aia->nr_hart_bits) | hart;
> +}
> +
> +static int aia_init(struct kvm *kvm)
> +{
> +       int ret, i;
> +       unsigned long idx;
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vcpu_aia *vaia;
> +       struct kvm_aia *aia =3D &kvm->arch.aia;
> +       gpa_t base_ppn =3D KVM_RISCV_AIA_UNDEF_ADDR;
> +
> +       /* Irqchip can be initialized only once */
> +       if (kvm_riscv_aia_initialized(kvm))
> +               return -EBUSY;
> +
> +       /* We might be in the middle of creating a VCPU? */
> +       if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
> +               return -EBUSY;
> +
> +       /* Number of sources should be less than or equals number of IDs =
*/
> +       if (aia->nr_ids < aia->nr_sources)
> +               return -EINVAL;
> +
> +       /* APLIC base is required for non-zero number of sources */
> +       if (aia->nr_sources && aia->aplic_addr =3D=3D KVM_RISCV_AIA_UNDEF=
_ADDR)
> +               return -EINVAL;
> +
> +       /* Initialize APLIC */
> +       ret =3D kvm_riscv_aia_aplic_init(kvm);
> +       if (ret)
> +               return ret;
> +
> +       /* Iterate over each VCPU */
> +       kvm_for_each_vcpu(idx, vcpu, kvm) {
> +               vaia =3D &vcpu->arch.aia_context;
> +
> +               /* IMSIC base is required */
> +               if (vaia->imsic_addr =3D=3D KVM_RISCV_AIA_UNDEF_ADDR) {
> +                       ret =3D -EINVAL;
> +                       goto fail_cleanup_imsics;
> +               }
> +
> +               /* All IMSICs should have matching base PPN */
> +               if (base_ppn =3D=3D KVM_RISCV_AIA_UNDEF_ADDR)
> +                       base_ppn =3D aia_imsic_ppn(aia, vaia->imsic_addr)=
;
> +               if (base_ppn !=3D aia_imsic_ppn(aia, vaia->imsic_addr)) {
> +                       ret =3D -EINVAL;
> +                       goto fail_cleanup_imsics;
> +               }
> +
> +               /* Update HART index of the IMSIC based on IMSIC base */
> +               vaia->hart_index =3D aia_imsic_hart_index(aia,
> +                                                       vaia->imsic_addr)=
;
> +
> +               /* Initialize IMSIC for this VCPU */
> +               ret =3D kvm_riscv_vcpu_aia_imsic_init(vcpu);
> +               if (ret)
> +                       goto fail_cleanup_imsics;
> +       }
> +
> +       /* Set the initialized flag */
> +       kvm->arch.aia.initialized =3D true;
> +
> +       return 0;
> +
> +fail_cleanup_imsics:
> +       for (i =3D idx - 1; i >=3D 0; i--) {
> +               vcpu =3D kvm_get_vcpu(kvm, i);
> +               if (!vcpu)
> +                       continue;
> +               kvm_riscv_vcpu_aia_imsic_cleanup(vcpu);
> +       }
> +       kvm_riscv_aia_aplic_cleanup(kvm);
> +       return ret;
> +}
> +
> +static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *=
attr)
> +{
> +       u32 nr;
> +       u64 addr;
> +       int nr_vcpus, r =3D -ENXIO;
> +       unsigned long type =3D (unsigned long)attr->attr;
> +       void __user *uaddr =3D (void __user *)(long)attr->addr;
> +
> +       switch (attr->group) {
> +       case KVM_DEV_RISCV_AIA_GRP_CONFIG:
> +               if (copy_from_user(&nr, uaddr, sizeof(nr)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D aia_config(dev->kvm, type, &nr, true);
> +               mutex_unlock(&dev->kvm->lock);
> +
> +               break;
> +
> +       case KVM_DEV_RISCV_AIA_GRP_ADDR:
> +               if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +                       return -EFAULT;
> +
> +               nr_vcpus =3D atomic_read(&dev->kvm->online_vcpus);
> +               mutex_lock(&dev->kvm->lock);
> +               if (type =3D=3D KVM_DEV_RISCV_AIA_ADDR_APLIC)
> +                       r =3D aia_aplic_addr(dev->kvm, &addr, true);
> +               else if (type < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcpus))
> +                       r =3D aia_imsic_addr(dev->kvm, &addr,
> +                           type - KVM_DEV_RISCV_AIA_ADDR_IMSIC(0), true)=
;
> +               mutex_unlock(&dev->kvm->lock);
> +
> +               break;
> +
> +       case KVM_DEV_RISCV_AIA_GRP_CTRL:
> +               switch (type) {
> +               case KVM_DEV_RISCV_AIA_CTRL_INIT:
> +                       mutex_lock(&dev->kvm->lock);
> +                       r =3D aia_init(dev->kvm);
> +                       mutex_unlock(&dev->kvm->lock);
> +                       break;
> +               }
> +
> +               break;
> +       }
> +
> +       return r;
> +}
> +
> +static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *=
attr)
> +{
> +       u32 nr;
> +       u64 addr;
> +       int nr_vcpus, r =3D -ENXIO;
> +       void __user *uaddr =3D (void __user *)(long)attr->addr;
> +       unsigned long type =3D (unsigned long)attr->attr;
> +
> +       switch (attr->group) {
> +       case KVM_DEV_RISCV_AIA_GRP_CONFIG:
> +               if (copy_from_user(&nr, uaddr, sizeof(nr)))
> +                       return -EFAULT;
> +
> +               mutex_lock(&dev->kvm->lock);
> +               r =3D aia_config(dev->kvm, type, &nr, false);
> +               mutex_unlock(&dev->kvm->lock);
> +               if (r)
> +                       return r;
> +
> +               if (copy_to_user(uaddr, &nr, sizeof(nr)))
> +                       return -EFAULT;
> +
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_ADDR:
> +               if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +                       return -EFAULT;
> +
> +               nr_vcpus =3D atomic_read(&dev->kvm->online_vcpus);
> +               mutex_lock(&dev->kvm->lock);
> +               if (type =3D=3D KVM_DEV_RISCV_AIA_ADDR_APLIC)
> +                       r =3D aia_aplic_addr(dev->kvm, &addr, false);
> +               else if (type < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcpus))
> +                       r =3D aia_imsic_addr(dev->kvm, &addr,
> +                           type - KVM_DEV_RISCV_AIA_ADDR_IMSIC(0), false=
);
> +               mutex_unlock(&dev->kvm->lock);
> +               if (r)
> +                       return r;
> +
> +               if (copy_to_user(uaddr, &addr, sizeof(addr)))
> +                       return -EFAULT;
> +
> +               break;
> +       }
> +
> +       return r;
> +}
> +
> +static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *=
attr)
> +{
> +       int nr_vcpus;
> +
> +       switch (attr->group) {
> +       case KVM_DEV_RISCV_AIA_GRP_CONFIG:
> +               switch (attr->attr) {
> +               case KVM_DEV_RISCV_AIA_CONFIG_MODE:
> +               case KVM_DEV_RISCV_AIA_CONFIG_IDS:
> +               case KVM_DEV_RISCV_AIA_CONFIG_SRCS:
> +               case KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS:
> +               case KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT:
> +               case KVM_DEV_RISCV_AIA_CONFIG_HART_BITS:
> +               case KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS:
> +                       return 0;
> +               }
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_ADDR:
> +               nr_vcpus =3D atomic_read(&dev->kvm->online_vcpus);
> +               if (attr->attr =3D=3D KVM_DEV_RISCV_AIA_ADDR_APLIC)
> +                       return 0;
> +               else if (attr->attr < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcp=
us))
> +                       return 0;
> +               break;
> +       case KVM_DEV_RISCV_AIA_GRP_CTRL:
> +               switch (attr->attr) {
> +               case KVM_DEV_RISCV_AIA_CTRL_INIT:
> +                       return 0;
> +               }
> +               break;
> +       }
> +
> +       return -ENXIO;
> +}
> +
> +struct kvm_device_ops kvm_riscv_aia_device_ops =3D {
> +       .name =3D "kvm-riscv-aia",
> +       .create =3D aia_create,
> +       .destroy =3D aia_destroy,
> +       .set_attr =3D aia_set_attr,
> +       .get_attr =3D aia_get_attr,
> +       .has_attr =3D aia_has_attr,
> +};
> +
> +int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
> +{
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(vcpu->kvm))
> +               return 1;
> +
> +       /* Update the IMSIC HW state before entering guest mode */
> +       return kvm_riscv_vcpu_aia_imsic_update(vcpu);
> +}
> +
> +void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_aia_csr *csr =3D &vcpu->arch.aia_context.guest_cs=
r;
> +       struct kvm_vcpu_aia_csr *reset_csr =3D
> +                               &vcpu->arch.aia_context.guest_reset_csr;
> +
> +       if (!kvm_riscv_aia_available())
> +               return;
> +       memcpy(csr, reset_csr, sizeof(*csr));
> +
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(vcpu->kvm))
> +               return;
> +
> +       /* Reset the IMSIC context */
> +       kvm_riscv_vcpu_aia_imsic_reset(vcpu);
> +}
> +
> +int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_aia *vaia =3D &vcpu->arch.aia_context;
> +
> +       if (!kvm_riscv_aia_available())
> +               return 0;
> +
> +       /*
> +        * We don't do any memory allocations over here because these
> +        * will be done after AIA device is initialized by the user-space=
.
> +        *
> +        * Refer, aia_init() implementation for more details.
> +        */
> +
> +       /* Initialize default values in AIA vcpu context */
> +       vaia->imsic_addr =3D KVM_RISCV_AIA_UNDEF_ADDR;
> +       vaia->hart_index =3D vcpu->vcpu_idx;
> +
> +       return 0;
> +}
> +
> +void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
> +{
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(vcpu->kvm))
> +               return;
> +
> +       /* Cleanup IMSIC context */
> +       kvm_riscv_vcpu_aia_imsic_cleanup(vcpu);
> +}
> +
> +int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
> +                                  u32 guest_index, u32 iid)
> +{
> +       unsigned long idx;
> +       struct kvm_vcpu *vcpu;
> +
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return -EBUSY;
> +
> +       /* Inject MSI to matching VCPU */
> +       kvm_for_each_vcpu(idx, vcpu, kvm) {
> +               if (vcpu->arch.aia_context.hart_index =3D=3D hart_index)
> +                       return kvm_riscv_vcpu_aia_imsic_inject(vcpu,
> +                                                              guest_inde=
x,
> +                                                              0, iid);
> +       }
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_aia_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> +{
> +       gpa_t tppn, ippn;
> +       unsigned long idx;
> +       struct kvm_vcpu *vcpu;
> +       u32 g, toff, iid =3D msi->data;
> +       struct kvm_aia *aia =3D &kvm->arch.aia;
> +       gpa_t target =3D (((gpa_t)msi->address_hi) << 32) | msi->address_=
lo;
> +
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return -EBUSY;
> +
> +       /* Convert target address to target PPN */
> +       tppn =3D target >> IMSIC_MMIO_PAGE_SHIFT;
> +
> +       /* Extract and clear Guest ID from target PPN */
> +       g =3D tppn & (BIT(aia->nr_guest_bits) - 1);
> +       tppn &=3D ~((gpa_t)(BIT(aia->nr_guest_bits) - 1));
> +
> +       /* Inject MSI to matching VCPU */
> +       kvm_for_each_vcpu(idx, vcpu, kvm) {
> +               ippn =3D vcpu->arch.aia_context.imsic_addr >>
> +                                       IMSIC_MMIO_PAGE_SHIFT;
> +               if (ippn =3D=3D tppn) {
> +                       toff =3D target & (IMSIC_MMIO_PAGE_SZ - 1);
> +                       return kvm_riscv_vcpu_aia_imsic_inject(vcpu, g,
> +                                                              toff, iid)=
;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +int kvm_riscv_aia_inject_irq(struct kvm *kvm, unsigned int irq, bool lev=
el)
> +{
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return -EBUSY;
> +
> +       /* Inject interrupt level change in APLIC */
> +       return kvm_riscv_aia_aplic_inject(kvm, irq, level);
> +}
> +
> +void kvm_riscv_aia_init_vm(struct kvm *kvm)
> +{
> +       struct kvm_aia *aia =3D &kvm->arch.aia;
> +
> +       if (!kvm_riscv_aia_available())
> +               return;
> +
> +       /*
> +        * We don't do any memory allocations over here because these
> +        * will be done after AIA device is initialized by the user-space=
.
> +        *
> +        * Refer, aia_init() implementation for more details.
> +        */
> +
> +       /* Initialize default values in AIA global context */
> +       aia->mode =3D (kvm_riscv_aia_nr_hgei) ?
> +               KVM_DEV_RISCV_AIA_MODE_AUTO : KVM_DEV_RISCV_AIA_MODE_EMUL=
;
> +       aia->nr_ids =3D kvm_riscv_aia_max_ids - 1;
> +       aia->nr_sources =3D 0;
> +       aia->nr_group_bits =3D 0;
> +       aia->nr_group_shift =3D KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN;
> +       aia->nr_hart_bits =3D 0;
> +       aia->nr_guest_bits =3D 0;
> +       aia->aplic_addr =3D KVM_RISCV_AIA_UNDEF_ADDR;
> +}
> +
> +void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
> +{
> +       /* Proceed only if AIA was initialized successfully */
> +       if (!kvm_riscv_aia_initialized(kvm))
> +               return;
> +
> +       /* Cleanup APLIC context */
> +       kvm_riscv_aia_aplic_cleanup(kvm);
> +}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 737318b1c1d9..27ccd07898e1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1442,6 +1442,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_XIVE              KVM_DEV_TYPE_XIVE
>         KVM_DEV_TYPE_ARM_PV_TIME,
>  #define KVM_DEV_TYPE_ARM_PV_TIME       KVM_DEV_TYPE_ARM_PV_TIME
> +       KVM_DEV_TYPE_RISCV_AIA,
> +#define KVM_DEV_TYPE_RISCV_AIA         KVM_DEV_TYPE_RISCV_AIA
>         KVM_DEV_TYPE_MAX,
>  };
>
> --
> 2.34.1
>

Additionally, it might be necessary to consider adding KVM_CAP_IRQCHIP
in the kvm_vm_ioctl_check_extension() function when the KVM AIA chip
is present.

Regards,
Yong-Xuan
