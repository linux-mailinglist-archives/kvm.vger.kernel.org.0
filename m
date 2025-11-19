Return-Path: <kvm+bounces-63726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 656C7C6F4D5
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 15:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 68CCD2E455
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2560B34AAF7;
	Wed, 19 Nov 2025 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0J46IyH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE573101DE
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763562593; cv=none; b=Umy4qmZTXGqEsIDVhjR0ZhBdicMx85eOxb7K3rMOaKDxEu34Wjtu3zDvC3s4PsNhTtvU+32T4bbynOfpdNpQYpwD7rUayRdjGwC3CBu+GGUn3T8M4F8t+FYjBeb/SfUfwopNHNbbKm4KsIpAbnsPh95ZWmhcsY6D3PK4mLY3b8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763562593; c=relaxed/simple;
	bh=QWwxLCo65YI6EUJ9QN5enxExOzudpPi/1Zek2Yl7Ll8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YWUaGGo/QDCbBb4Va0Nvjtf6vzjFHwOyUs8e+4q9jMUYurUpwNi2pnNTuyu+f5qfsOHAVWIjABvEhmhVfvYOddZn23i/SjWwO0t15AmwDXoQb02uwMP9MzY5lhqhrEkM8+e3hyV4/ClvPDOkttc0njDqbiHRQ4VusoVyelYFO+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0J46IyH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5997C2BCB4
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763562592;
	bh=QWwxLCo65YI6EUJ9QN5enxExOzudpPi/1Zek2Yl7Ll8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L0J46IyHhB1W9BqCju+ZfMAU9EC7AcpgXV9tasCW9WB2arzl3QOYOlWZd0mrbRvwP
	 OD0j/b8ebmd4bXJevsTvbwhLTN6ouP2IU4Fbdo7ODSv9ncFZy/8/aMHBUoQC9B1ogs
	 lyZlo7W/KvbC34cmb/COzysXA6sRT7VIeWsDd58TS85uiuqkIxSPMLI+CzGi77jJel
	 0dfUUM7vhK5F8W3KCBkRa0LL1XPAmynluzNdPnSxrCGaFgaC+SA4tKWsrPVOYVulmy
	 V4JOhiuxNOqOaC8Ml8uFJ8XEXKWSSiace9tXjSG3tftdyphor+osEjGlVcWbv/if4W
	 L3Z1lUbr24PIA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7277324204so944437066b.0
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 06:29:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDUcOUXT6s+xPLV1sCoThG91PpgwWtb2j/SsThEKyv23aSzQk9PFuzRCbcWQGFoQDjh/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Uw7Jy7rx2I9eVdDV6ZQwT3RsEiOsNdpPlYSBHSlT9skk6mwu
	OdCuh2DKM2wcGYSHV3R+cMsO4IVZjQygGiQ3BonWX00chV3RwawpGWzBQ46wAr28cGByJVs0O1q
	c7rXTBhFahdi/rku6EDIKOc0rfovUXtU=
X-Google-Smtp-Source: AGHT+IGfTzHUp+TW4sMtzYrxbtCFB5b3MWEE37MvJ5eZTm+bam0bmZi/HVodQz4qkFvFkoK8JJOpk12cPNoSLyxzcgQ=
X-Received: by 2002:a17:907:1c9c:b0:b6d:7b77:ff33 with SMTP id
 a640c23a62f3a-b736782c351mr1826184966b.19.1763562589628; Wed, 19 Nov 2025
 06:29:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251119083946.1864543-1-gaosong@loongson.cn>
In-Reply-To: <20251119083946.1864543-1-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 19 Nov 2025 22:29:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6Q+uxjcr=2LkBRAd=X4zjXeuwKTsJMBvD6bfbMsSHUcA@mail.gmail.com>
X-Gm-Features: AWmQ_bm-zlvJKTuA1HX09Y8lxL95iJ6rRX5X2gJfLv2WVXAdahlvgzSmDr24QEI
Message-ID: <CAAhV-H6Q+uxjcr=2LkBRAd=X4zjXeuwKTsJMBvD6bfbMsSHUcA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add AVEC support irqchip in kernel
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Song,

On Wed, Nov 19, 2025 at 5:04=E2=80=AFPM Song Gao <gaosong@loongson.cn> wrot=
e:
>
> Add a dintc device to set dintc msg base and msg size.
> implement deliver the msi to vcpu and inject irq to dest vcpu.
> add some macros for AVEC.
>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>  arch/loongarch/include/asm/irq.h       |   7 ++
>  arch/loongarch/include/asm/kvm_dintc.h |  22 +++++
>  arch/loongarch/include/asm/kvm_host.h  |   8 ++
>  arch/loongarch/include/uapi/asm/kvm.h  |   4 +
>  arch/loongarch/kvm/Makefile            |   1 +
>  arch/loongarch/kvm/intc/dintc.c        | 115 +++++++++++++++++++++++++
>  arch/loongarch/kvm/interrupt.c         |   1 +
>  arch/loongarch/kvm/irqfd.c             |  35 +++++++-
>  arch/loongarch/kvm/main.c              |   5 ++
>  arch/loongarch/kvm/vcpu.c              |  51 +++++++++++
>  drivers/irqchip/irq-loongarch-avec.c   |   5 +-
>  include/uapi/linux/kvm.h               |   2 +
>  12 files changed, 252 insertions(+), 4 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
>  create mode 100644 arch/loongarch/kvm/intc/dintc.c
>
> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/as=
m/irq.h
> index 12bd15578c33..5ab8b91e9ae8 100644
> --- a/arch/loongarch/include/asm/irq.h
> +++ b/arch/loongarch/include/asm/irq.h
> @@ -50,6 +50,13 @@ void spurious_interrupt(void);
>  #define NR_LEGACY_VECTORS      16
>  #define IRQ_MATRIX_BITS                NR_VECTORS
>
> +#define AVEC_VIRQ_SHIFT                4
> +#define AVEC_VIRQ_BIT          8
> +#define AVEC_VIRQ_MASK         GENMASK(AVEC_VIRQ_BIT - 1, 0)
> +#define AVEC_CPU_SHIFT         12
> +#define AVEC_CPU_BIT           16
> +#define AVEC_CPU_MASK          GENMASK(AVEC_CPU_BIT - 1, 0)
> +
>  #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
>  void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int excl=
ude_cpu);
>
> diff --git a/arch/loongarch/include/asm/kvm_dintc.h b/arch/loongarch/incl=
ude/asm/kvm_dintc.h
> new file mode 100644
> index 000000000000..0ec301fbb638
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dintc.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DINTC_H
> +#define __ASM_KVM_DINTC_H
> +
> +
> +struct loongarch_dintc  {
> +       spinlock_t lock;
> +       struct kvm *kvm;
> +       uint64_t msg_addr_base;
> +       uint64_t msg_addr_size;
> +};
> +
> +struct dintc_state {
> +       atomic64_t vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index 0cecbd038bb3..3806a71658c1 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_ipi.h>
>  #include <asm/kvm_eiointc.h>
>  #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dintc.h>
>  #include <asm/loongarch.h>
>
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -132,6 +133,7 @@ struct kvm_arch {
>         struct loongarch_ipi *ipi;
>         struct loongarch_eiointc *eiointc;
>         struct loongarch_pch_pic *pch_pic;
> +       struct loongarch_dintc *dintc;
>  };
>
>  #define CSR_MAX_NUMS           0x800
> @@ -242,6 +244,7 @@ struct kvm_vcpu_arch {
>         struct kvm_mp_state mp_state;
>         /* ipi state */
>         struct ipi_state ipi_state;
> +       struct dintc_state dintc_state;
>         /* cpucfg */
>         u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>
> @@ -253,6 +256,11 @@ struct kvm_vcpu_arch {
>         } st;
>  };
>
> +void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu);
> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +                                     struct kvm_vcpu *vcpu,
> +                                     u32 vector, int level);
> +
>  static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, in=
t reg)
>  {
>         return csr->csrs[reg];
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index de6c3f18e40a..07da84f7002c 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>  #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL             0x40000006
>  #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT            0
>
> +#define KVM_DEV_LOONGARCH_DINTC_CTRL                   0x40000007
> +#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE          0x0
> +#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE          0x1
> +
>  #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..fe984bf1cbdb 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y +=3D vm.o
>  kvm-y +=3D intc/ipi.o
>  kvm-y +=3D intc/eiointc.o
>  kvm-y +=3D intc/pch_pic.o
> +kvm-y +=3D intc/dintc.o
>  kvm-y +=3D irqfd.o
>
>  CFLAGS_exit.o  +=3D $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dintc.c b/arch/loongarch/kvm/intc/di=
ntc.c
> new file mode 100644
> index 000000000000..376c6e20ec04
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dintc.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dintc_ctrl_access(struct kvm_device *dev,
> +                                struct kvm_device_attr *attr,
> +                                bool is_write)
> +{
> +       int addr =3D attr->attr;
> +       void __user *data;
> +       struct loongarch_dintc *s =3D dev->kvm->arch.dintc;
> +
> +       data =3D (void __user *)attr->addr;
> +       switch (addr) {
> +       case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE:
> +               if (is_write) {
> +                       if (copy_from_user(&(s->msg_addr_base), data, siz=
eof(s->msg_addr_base)))
> +                               return -EFAULT;
> +               }
> +               break;
> +       case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE:
> +               if (is_write) {
> +                       if (copy_from_user(&(s->msg_addr_size), data, siz=
eof(s->msg_addr_size)))
> +                               return -EFAULT;
> +               }
> +               break;
> +       default:
> +               kvm_err("%s: unknown dintc register, addr =3D %d\n", __fu=
nc__, addr);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_dintc_get_attr(struct kvm_device *dev,
> +                       struct kvm_device_attr *attr)
> +{
> +       switch (attr->group) {
> +       case KVM_DEV_LOONGARCH_DINTC_CTRL:
> +               return kvm_dintc_ctrl_access(dev, attr, false);
> +       default:
> +               kvm_err("%s: unknown group (%d)\n", __func__, attr->group=
);
> +               return -EINVAL;
> +       }
> +}
> +
> +static int kvm_dintc_set_attr(struct kvm_device *dev,
> +                             struct kvm_device_attr *attr)
> +{
> +       switch (attr->group) {
> +       case KVM_DEV_LOONGARCH_DINTC_CTRL:
> +               return kvm_dintc_ctrl_access(dev, attr, true);
> +       default:
> +               kvm_err("%s: unknown group (%d)\n", __func__, attr->group=
);
> +               return -EINVAL;
> +       }
> +}
> +
> +static int kvm_dintc_create(struct kvm_device *dev, u32 type)
> +{
> +       struct kvm *kvm;
> +       struct loongarch_dintc *s;
> +
> +       if (!dev) {
> +               kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       kvm =3D dev->kvm;
> +       if (kvm->arch.dintc) {
> +               kvm_err("%s: LoongArch DINTC has already been created!\n"=
, __func__);
> +               return -EINVAL;
> +       }
> +
> +       s =3D kzalloc(sizeof(struct loongarch_dintc), GFP_KERNEL);
> +       if (!s)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&s->lock);
> +       s->kvm =3D kvm;
> +
> +       kvm->arch.dintc =3D s;
> +       return 0;
> +}
> +
> +static void kvm_dintc_destroy(struct kvm_device *dev)
> +{
> +       struct kvm *kvm;
> +       struct loongarch_dintc *dintc;
> +
> +       if (!dev || !dev->kvm || !dev->kvm->arch.dintc)
> +               return;
> +
> +       kvm =3D dev->kvm;
> +       dintc =3D kvm->arch.dintc;
> +       kfree(dintc);
> +}
> +
> +static struct kvm_device_ops kvm_dintc_dev_ops =3D {
> +       .name =3D "kvm-loongarch-dintc",
> +       .create =3D kvm_dintc_create,
> +       .destroy =3D kvm_dintc_destroy,
> +       .set_attr =3D kvm_dintc_set_attr,
> +       .get_attr =3D kvm_dintc_get_attr,
> +};
> +
> +int kvm_loongarch_register_dintc_device(void)
> +{
> +       return kvm_register_device_ops(&kvm_dintc_dev_ops, KVM_DEV_TYPE_L=
OONGARCH_DINTC);
> +}
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrup=
t.c
> index a6d42d399a59..c74e7af3e772 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsig=
ned int priority)
>                 irq =3D priority_to_irq[priority];
>
>         if (cpu_has_msgint && (priority =3D=3D INT_AVEC)) {
> +               loongarch_dintc_inject_irq(vcpu);
>                 set_gcsr_estat(irq);
>                 return 1;
>         }
> diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
> index 9a39627aecf0..a6f9342eaba1 100644
> --- a/arch/loongarch/kvm/irqfd.c
> +++ b/arch/loongarch/kvm/irqfd.c
> @@ -2,7 +2,6 @@
>  /*
>   * Copyright (C) 2024 Loongson Technology Corporation Limited
>   */
> -
>  #include <linux/kvm_host.h>
>  #include <trace/events/kvm.h>
>  #include <asm/kvm_pch_pic.h>
> @@ -16,6 +15,27 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routi=
ng_entry *e,
>         return 0;
>  }
>
> +static int kvm_dintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, in=
t level)
> +{
> +       unsigned int virq, dest, cpu_bit;
> +       struct kvm_vcpu *vcpu;
> +
> +       cpu_bit =3D find_first_bit((unsigned long *)&(kvm->arch.dintc->ms=
g_addr_base), 64)
> +                               - AVEC_CPU_SHIFT;
> +       cpu_bit =3D min(cpu_bit, AVEC_CPU_BIT);
> +
> +       virq =3D (addr >> AVEC_VIRQ_SHIFT)&AVEC_VIRQ_MASK;
> +       dest =3D (addr >> AVEC_CPU_SHIFT)&GENMASK(cpu_bit - 1, 0);
> +       if (dest > KVM_MAX_VCPUS)
> +               return -EINVAL;
> +       vcpu =3D kvm_get_vcpu_by_id(kvm, dest);
> +
> +       if (!vcpu)
> +               return -EINVAL;
> +       return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
> +}
> +
> +
>  /*
>   * kvm_set_msi: inject the MSI corresponding to the
>   * MSI routing entry
> @@ -26,10 +46,21 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_rout=
ing_entry *e,
>  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>                 struct kvm *kvm, int irq_source_id, int level, bool line_=
status)
>  {
> +       u64 msg_addr;
> +
>         if (!level)
>                 return -1;
>
> -       pch_msi_set_irq(kvm, e->msi.data, level);
> +       msg_addr =3D (((u64)e->msi.address_hi) << 32) | e->msi.address_lo=
;
> +       if (cpu_has_msgint &&
> +               msg_addr > kvm->arch.dintc->msg_addr_base &&
> +               msg_addr <=3D (kvm->arch.dintc->msg_addr_base  + kvm->arc=
h.dintc->msg_addr_size)) {
> +               return kvm_dintc_set_msi_irq(kvm, e->msi.address_lo, e->m=
si.data, level);
> +       } else if (e->msi.address_lo  =3D=3D 0) {
> +               pch_msi_set_irq(kvm, e->msi.data, level);
> +       } else {
> +               return 0;
> +       }
>
>         return 0;
>  }
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..d18d9f4d485c 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
>
>         /* Register LoongArch PCH-PIC interrupt controller interface. */
>         ret =3D kvm_loongarch_register_pch_pic_device();
> +       if (ret)
> +               return ret;
> +
> +       /* Register LoongArch DINTC interrupt contrroller interface */
> +       ret =3D kvm_loongarch_register_dintc_device();
>
>         return ret;
>  }
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 1e7590fc1b47..4f13161be107 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -13,6 +13,57 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>
> +void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu)
> +{
> +       struct dintc_state *ds =3D &vcpu->arch.dintc_state;
> +       unsigned int i;
> +       unsigned long temp[4], old;
> +
> +       if (!ds)
> +               return;
> +
> +       for (i =3D 0; i < 4; i++) {
> +               old =3D atomic64_read(&(ds->vector_map[i]));
> +               if (old)
> +                       temp[i] =3D atomic64_xchg(&(ds->vector_map[i]), 0=
);
> +       }
> +
> +       if (temp[0]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
> +       }
> +       if (temp[1]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
> +       }
> +       if (temp[2]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
> +       }
> +       if (temp[3]) {
> +               old =3D kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
> +               kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
> +       }
> +}
> +int  kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +                                       struct kvm_vcpu *vcpu,
> +                                       u32 vector, int level)
> +{
> +       struct kvm_interrupt vcpu_irq;
> +       struct dintc_state *ds;
> +
> +       if (!vcpu || vector >=3D 256)
> +               return -EINVAL;
> +       ds =3D &vcpu->arch.dintc_state;
> +       if (!ds)
> +               return -ENODEV;
> +       set_bit(vector, (unsigned long *)&ds->vector_map);
> +       vcpu_irq.irq =3D level ? INT_AVEC : -INT_AVEC;
> +       kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
> +       kvm_vcpu_kick(vcpu);
> +       return 0;
> +}
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D {
>         KVM_GENERIC_VCPU_STATS(),
>         STATS_DESC_COUNTER(VCPU, int_exits),
> diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-l=
oongarch-avec.c
> index bf52dc8345f5..2f0f704cfebb 100644
> --- a/drivers/irqchip/irq-loongarch-avec.c
> +++ b/drivers/irqchip/irq-loongarch-avec.c
> @@ -209,8 +209,9 @@ static void avecintc_compose_msi_msg(struct irq_data =
*d, struct msi_msg *msg)
>         struct avecintc_data *adata =3D irq_data_get_irq_chip_data(d);
>
>         msg->address_hi =3D 0x0;
> -       msg->address_lo =3D (loongarch_avec.msi_base_addr | (adata->vec &=
 0xff) << 4)
> -                         | ((cpu_logical_map(adata->cpu & 0xffff)) << 12=
);
> +       msg->address_lo =3D (loongarch_avec.msi_base_addr |
> +                         (adata->vec & AVEC_VIRQ_MASK) << AVEC_VIRQ_SHIF=
T) |
> +                         ((cpu_logical_map(adata->cpu & AVEC_CPU_MASK)) =
<< AVEC_CPU_SHIFT);
>         msg->data =3D 0x0;
>  }
As Bibo said, this patch should be splitted. At least this part
(together with the macro definition) should be splitted out as a
preparation patch and sent to the irqchip list.

This small part should be done as soon as possible, because we hope it
will be merged to irqchip tree in the 6.19 cycle.


Huacai

>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab020..738dd8d626a4 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1198,6 +1198,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_LOONGARCH_EIOINTC KVM_DEV_TYPE_LOONGARCH_EIOINTC
>         KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>  #define KVM_DEV_TYPE_LOONGARCH_PCHPIC  KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +       KVM_DEV_TYPE_LOONGARCH_DINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DINTC   KVM_DEV_TYPE_LOONGARCH_DINTC
>
>         KVM_DEV_TYPE_MAX,
>
> --
> 2.39.3
>
>

