Return-Path: <kvm+bounces-68161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA0AD22E85
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 08:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA12E30975B5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 07:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1395E32ABC7;
	Thu, 15 Jan 2026 07:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JPoabBQC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32480329C7E
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 07:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768463041; cv=none; b=fl+F6KfFhFA31oAfnTCNwsJPVglFH2NJAcPaNFOeeveoaAApvmmp44qKmZ7NJkdgjcJUSGDkxZK0XVZS9eDYjYSoPaoWpeMwuvV2KmW8/GaV6U6nJCoX+ANvXTgAshRCVp5E+q3r/ooZp5JWh6hDQMl9R9yoPcfw6iGbixh1OjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768463041; c=relaxed/simple;
	bh=4FGPv/2RxBM3h5py+1EMqhDtPUHe2D+7RO2VfCfYdZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRpJcAXahvM0r0fc0dvOmaTLjvwQDD63ZCrZieN3GEzkcQrMkiag3VAbO7cZ5+HP32Oq5p4Hii5oux3RM9h/WUG1+iz9fbyGM/+xi9qQzkPopvnlpsdBitD0VJWQs5xkr42DLsJz9WpUZSGFVozt3dmkmVzcggOcIrwLkFiSDLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JPoabBQC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42F7C4AF09
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 07:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768463040;
	bh=4FGPv/2RxBM3h5py+1EMqhDtPUHe2D+7RO2VfCfYdZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JPoabBQClH8LVoT1CRQ3qky/rMkHsRyVl7+QY2ZIPFUbOQg0xyf6ASkVvCJwKmbgX
	 5UHinV5rku73xgr8lUOZHaHJzU05116Ds4TzuhKilGa25ccUGD8y1+kPTIulFfQZ7C
	 ooAdVwg4bYGDlRFHptMg4ZEwf5JVa1v+YrebE1+ikYSR3YZtADt1Y2RJ6ijetJD+BM
	 cR2FftV3MGt9MMRlrWwuO/0hKf6KEGkLTKoe001EPGTWO6MfcMa2vCV7PnmJKdNvvx
	 4ClB/mY6p2FWyAEYJHt9XPvZnnZo+UDd69txsxOPo+q8M2b+Q7INv4f4h9nJLPqqO/
	 G3iO84SuoOhpA==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-652fec696c9so1024585a12.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 23:44:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVXI0OaykgNIRE3GdwsexuhqlwQcsEfxxDOrk9qN1J8CnpJWbP/Jn0joH/YVDxbeFtb6Zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRRJ43ulPgtoJEiv7xAqJ3M4eDfhbdIyr0NqNlqr+maDigq71c
	5V5fwUKlxKcXDR00/x7V1pKKUjH4urEj/IZStLRnZfmdbvX/NHDy6Qc47gDcsCAvQb720ayy3sP
	jO5BBoYzz5MRoSGl/JFVDbIXo2jrwtjs=
X-Received: by 2002:a17:907:7f91:b0:b79:d24b:474d with SMTP id
 a640c23a62f3a-b87676a0da7mr359416066b.16.1768463039462; Wed, 14 Jan 2026
 23:43:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251225091224.2893389-1-gaosong@loongson.cn> <20251225091224.2893389-2-gaosong@loongson.cn>
In-Reply-To: <20251225091224.2893389-2-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 15 Jan 2026 15:43:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5h2LioH6SZD8RUNewb4De3LWM9g2PJFUnTTkX+GG4cdw@mail.gmail.com>
X-Gm-Features: AZwV_QiaUyKFTIxEaKv_MY3PKwCihURSdn_6U07VTAlpWKWayuoeaNBCR3B_XX8
Message-ID: <CAAhV-H5h2LioH6SZD8RUNewb4De3LWM9g2PJFUnTTkX+GG4cdw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] LongArch: KVM: Add DMSINTC device support
To: Song Gao <gaosong@loongson.cn>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Song,

On Thu, Dec 25, 2025 at 5:37=E2=80=AFPM Song Gao <gaosong@loongson.cn> wrot=
e:
>
> Add device model for DMSINTC interrupt controller, implement basic
> create/destroy/set_attr interfaces, and register device model to kvm
> device table.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
>  arch/loongarch/include/asm/kvm_host.h    |   3 +
>  arch/loongarch/include/uapi/asm/kvm.h    |   4 +
>  arch/loongarch/kvm/Makefile              |   1 +
>  arch/loongarch/kvm/intc/dmsintc.c        | 110 +++++++++++++++++++++++
>  arch/loongarch/kvm/main.c                |   6 ++
>  include/uapi/linux/kvm.h                 |   2 +
>  7 files changed, 147 insertions(+)
>  create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
>  create mode 100644 arch/loongarch/kvm/intc/dmsintc.c
>
> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/in=
clude/asm/kvm_dmsintc.h
> new file mode 100644
> index 000000000000..1d4f66996f3c
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DMSINTC_H
> +#define __ASM_KVM_DMSINTC_H
> +
> +
> +struct loongarch_dmsintc  {
> +       struct kvm *kvm;
> +       uint64_t msg_addr_base;
> +       uint64_t msg_addr_size;
> +};
> +
> +struct dmsintc_state {
> +       atomic64_t  vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index e4fe5b8e8149..5e9e2af7312f 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>  #include <asm/kvm_ipi.h>
>  #include <asm/kvm_eiointc.h>
>  #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dmsintc.h>
>  #include <asm/loongarch.h>
>
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -134,6 +135,7 @@ struct kvm_arch {
>         struct loongarch_ipi *ipi;
>         struct loongarch_eiointc *eiointc;
>         struct loongarch_pch_pic *pch_pic;
> +       struct loongarch_dmsintc *dmsintc;
>  };
>
>  #define CSR_MAX_NUMS           0x800
> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>         struct kvm_mp_state mp_state;
>         /* ipi state */
>         struct ipi_state ipi_state;
> +       struct dmsintc_state dmsintc_state;
>         /* cpucfg */
>         u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index de6c3f18e40a..0a370d018b08 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>  #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL             0x40000006
>  #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT            0
>
> +#define KVM_DEV_LOONGARCH_DMSINTC_CTRL                 0x40000007
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE                0x0
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE                0x1
> +
>  #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..6e184e24443c 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y +=3D vm.o
>  kvm-y +=3D intc/ipi.o
>  kvm-y +=3D intc/eiointc.o
>  kvm-y +=3D intc/pch_pic.o
> +kvm-y +=3D intc/dmsintc.o
>  kvm-y +=3D irqfd.o
>
>  CFLAGS_exit.o  +=3D $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/=
dmsintc.c
> new file mode 100644
> index 000000000000..3fdea81a08c8
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dmsintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
> +                               struct kvm_device_attr *attr,
> +                               bool is_write)
> +{
> +       int addr =3D attr->attr;
> +       void __user *data;
> +       struct loongarch_dmsintc *s =3D dev->kvm->arch.dmsintc;
> +       u64 tmp;
> +
> +       data =3D (void __user *)attr->addr;
> +       switch (addr) {
> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
> +               if (is_write) {
> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr=
_base)))
> +                               return -EFAULT;
> +                       if (s->msg_addr_base) {
> +                               /* Duplicate setting are not allowed. */
> +                               return -EFAULT;
> +                       }
> +                       if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) =3D=3D 0)
> +                               s->msg_addr_base =3D tmp;
> +                       else
> +                               return  -EFAULT;
> +               }
> +               break;
> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> +               if (is_write) {
> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr=
_size)))
> +                               return -EFAULT;
> +                       if (s->msg_addr_size) {
> +                               /*Duplicate setting are not allowed. */
> +                               return -EFAULT;
> +                       }
> +                       s->msg_addr_size =3D tmp;
> +               }
> +               break;
> +       default:
> +               kvm_err("%s: unknown dmsintc register, addr =3D %d\n", __=
func__, addr);
> +               return -ENXIO;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_dmsintc_set_attr(struct kvm_device *dev,
> +                       struct kvm_device_attr *attr)
> +{
> +       switch (attr->group) {
> +       case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
> +               return kvm_dmsintc_ctrl_access(dev, attr, true);
> +       default:
> +               kvm_err("%s: unknown group (%d)\n", __func__, attr->group=
);
> +               return -EINVAL;
> +       }
> +}
> +
> +static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
> +{
> +       struct kvm *kvm;
> +       struct loongarch_dmsintc *s;
> +
> +       if (!dev) {
> +               kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       kvm =3D dev->kvm;
> +       if (kvm->arch.dmsintc) {
> +               kvm_err("%s: LoongArch DMSINTC has already been created!\=
n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       s =3D kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
> +       if (!s)
> +               return -ENOMEM;
> +
> +       s->kvm =3D kvm;
> +       kvm->arch.dmsintc =3D s;
> +       return 0;
> +}
> +
> +static void kvm_dmsintc_destroy(struct kvm_device *dev)
> +{
> +
> +       if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
> +               return;
> +
> +       kfree(dev->kvm->arch.dmsintc);
No need to call kvm_io_bus_unregister_dev()? And it seems you need to
kfree(dev) if this series is correct:

https://lore.kernel.org/loongarch/99826cf9-356d-235b-9c7c-9d51d36e53c3@loon=
gson.cn/T/#t

Huacai

> +}
> +
> +static struct kvm_device_ops kvm_dmsintc_dev_ops =3D {
> +       .name =3D "kvm-loongarch-dmsintc",
> +       .create =3D kvm_dmsintc_create,
> +       .destroy =3D kvm_dmsintc_destroy,
> +       .set_attr =3D kvm_dmsintc_set_attr,
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void)
> +{
> +       return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE=
_LOONGARCH_DMSINTC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..f363a3b24903 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,12 @@ static int kvm_loongarch_env_init(void)
>
>         /* Register LoongArch PCH-PIC interrupt controller interface. */
>         ret =3D kvm_loongarch_register_pch_pic_device();
> +       if (ret)
> +               return ret;
> +
> +       /* Register LoongArch DMSINTC interrupt contrroller interface */
> +       if (cpu_has_msgint)
> +               ret =3D kvm_loongarch_register_dmsintc_device();
>
>         return ret;
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..7c56e7e36265 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_LOONGARCH_EIOINTC KVM_DEV_TYPE_LOONGARCH_EIOINTC
>         KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>  #define KVM_DEV_TYPE_LOONGARCH_PCHPIC  KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +       KVM_DEV_TYPE_LOONGARCH_DMSINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
>
>         KVM_DEV_TYPE_MAX,
>
> --
> 2.39.3
>
>

