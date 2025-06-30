Return-Path: <kvm+bounces-51077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B383EAED69B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA0B1161B8B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 08:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408A8239E82;
	Mon, 30 Jun 2025 08:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjFyH3wW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D1E21FF55;
	Mon, 30 Jun 2025 08:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270668; cv=none; b=bGERMZLZvH7fO2naprwK023+QBKajFggELjkZlG26SnbMzK05CmEpGJcp3aIyqj9a40A+JYERIBdRhhJTKBq5C9Un6RcvdsOBCQLR0IaZJ5+OHwwOX4RDH13cjWT/Lai8y0W7xqSTcE4MDSe9tH9UvHKC2tPPE43NdtxwnHzm8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270668; c=relaxed/simple;
	bh=bwchRmcLVbZYLZGHfdDl6K19HLcH2bDZCDHH2eaUt34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8KtZiwtwmDGbBc84iugIX6fe5uliEJeU0wCYh9A2AeLkYS9CAuObMPuaZcHkAiLWL1i7CTp6kFw4XmCxXU7ZCTTJXK5k+Ddj+04sCyN8BMZW4u0slm4xyrwQXGxGw9wlNDI648mHIDIdpRH3MQYsBkj7KCLZQZoXb6nlcGX2Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjFyH3wW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB41C4CEEB;
	Mon, 30 Jun 2025 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751270667;
	bh=bwchRmcLVbZYLZGHfdDl6K19HLcH2bDZCDHH2eaUt34=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AjFyH3wWyGhc00UmXWf/Baghr444XwrDHmaZNwUt2B5oJAD9XJ9p6rWTP9Uf+mXUy
	 XT6HYoLBjhuDCMyf5JQkvkzyIZzRMdEn33rpS8bVI/3XQjZ/gujtmDsuImDsku1gtk
	 8M9KBZH/xeBFtbaSPoCvVI8+QsiLNIen9FuflgdrgYMMRXsgITLgO7Zzg3ulEUg62M
	 6zAkkvbNFNxQP8M90e/Sk7/XqChjbT0sAfUl2bbfDBD3GrBnq4eUA4d8uG8b4tmTRQ
	 in9EX2JtthhCdNUxGdTST6chzGxTX3LmCjkrgxSd4ZdcGtb4rBMs3/o3gROTNxDJJd
	 P7tfxJM7tTlTA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so8779568a12.1;
        Mon, 30 Jun 2025 01:04:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVLOhmXhbSujYsZeZaiDg8PgX4gXHvEuVt/rZDuSgiG7N8cOiEDQyZ6Uxyi40sZGgVy5J8=@vger.kernel.org, AJvYcCWr6YqPSevI4aNzuc4dcYKZVaUAziIfsk1ipmE8+FI/ikPEW47nnroMNmJesu7fYDGWF+lR2/OVwCiSgtHv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0AKtjnvvEi1BK7ksHmNlvEpsm+8XSIJSr1/d/Do55cYN2w+vh
	eArVWh3DSzLwW1vJztkkSuLrYenYVOkemub7cr/SfI8kk8ZzcjbKMlh7i2bOrjcGrwA50+Ry1zY
	gwfLR/wMk7sansNH2O8ZnzPZa1SWHwmI=
X-Google-Smtp-Source: AGHT+IHvs0BPl27zV28ojmMXtogxYdBLQpI0Nb2lzudY4Dal6psVvwXmOrDtSymaTj8NC9aMyua2eiATokD9CrBpBhw=
X-Received: by 2002:a05:6402:34cd:b0:60c:6a8d:8511 with SMTP id
 4fb4d7f45d1cf-60c6a8d89c8mr13781147a12.12.1751270666189; Mon, 30 Jun 2025
 01:04:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619071449.1714869-1-maobibo@loongson.cn>
In-Reply-To: <20250619071449.1714869-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 30 Jun 2025 16:04:14 +0800
X-Gmail-Original-Message-ID: <CAAhV-H42wPsxNCSp-4wy1+f-2yAJ1fuWbsC57bvQkHL0E3n=-g@mail.gmail.com>
X-Gm-Features: Ac12FXzXFS8OKvbl7bkuwM5E_l_CPBg3TGydOuvuMTVVQgYvoLr_GH3pLufkJ4o
Message-ID: <CAAhV-H42wPsxNCSp-4wy1+f-2yAJ1fuWbsC57bvQkHL0E3n=-g@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: KVM: INTC: Add IOCSR MISC register emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Thu, Jun 19, 2025 at 3:15=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> IOCSR MISC register 0x420 controlls some features of eiointc, such as
> BIT 48 enables eiointc and BIT 49 set interrupt encoding mode.
>
> When kernel irqchip is set, IOCSR MISC register should be emulated in
> kernel also. Here add IOCSR MISC register emulation in kernel side.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
> v1 ... v2:
>   1. Add separate file arch/loongarch/kvm/intc/misc.c for IOCSR MISC
>      register 0x420 emulation, since it controls feature about AVEC
>      irqchip also.
I found we can decouple the misc register and EIOINTC in addition:
1, Move misc.c out of intc directory;
2, Call kvm_loongarch_create_misc() in kvm_arch_init_vm();
3, Call kvm_loongarch_destroy_misc() in kvm_arch_destroy_vm();
4, Then maybe misc_created can be removed.

At last you can make this patch and others from another series to be a
new series.


Huacai

>
>   2. Define macro MISC_BASE as LOONGARCH_IOCSR_MISC_FUNC rather than
>      hard coded 0x420
> ---
>  arch/loongarch/include/asm/kvm_eiointc.h |   2 +
>  arch/loongarch/include/asm/kvm_host.h    |   2 +
>  arch/loongarch/include/asm/kvm_misc.h    |  17 +++
>  arch/loongarch/include/asm/loongarch.h   |   1 +
>  arch/loongarch/kvm/Makefile              |   1 +
>  arch/loongarch/kvm/intc/eiointc.c        |  61 +++++++++++
>  arch/loongarch/kvm/intc/misc.c           | 125 +++++++++++++++++++++++
>  7 files changed, 209 insertions(+)
>  create mode 100644 arch/loongarch/include/asm/kvm_misc.h
>  create mode 100644 arch/loongarch/kvm/intc/misc.c
>
> diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/in=
clude/asm/kvm_eiointc.h
> index a3a40aba8acf..2d1c183f2b1b 100644
> --- a/arch/loongarch/include/asm/kvm_eiointc.h
> +++ b/arch/loongarch/include/asm/kvm_eiointc.h
> @@ -119,5 +119,7 @@ struct loongarch_eiointc {
>
>  int kvm_loongarch_register_eiointc_device(void);
>  void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value);
> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value=
, unsigned long mask);
>
>  #endif /* __ASM_KVM_EIOINTC_H */
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index a3c4cc46c892..f463ec52d86c 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -132,6 +132,8 @@ struct kvm_arch {
>         struct loongarch_ipi *ipi;
>         struct loongarch_eiointc *eiointc;
>         struct loongarch_pch_pic *pch_pic;
> +       struct kvm_io_device misc;
> +       bool   misc_created;
>  };
>
>  #define CSR_MAX_NUMS           0x800
> diff --git a/arch/loongarch/include/asm/kvm_misc.h b/arch/loongarch/inclu=
de/asm/kvm_misc.h
> new file mode 100644
> index 000000000000..621e4228dea2
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_misc.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_MISC_H
> +#define __ASM_KVM_MISC_H
> +
> +#include <asm/loongarch.h>
> +
> +#define MISC_BASE              LOONGARCH_IOCSR_MISC_FUNC
> +#define MISC_SIZE              0x8
> +
> +int kvm_loongarch_create_misc(struct kvm *kvm);
> +void kvm_loongarch_destroy_misc(struct kvm *kvm);
> +
> +#endif /* __ASM_KVM_MISC_H */
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index d84dac88a584..e30d330d497e 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -1141,6 +1141,7 @@
>  #define  IOCSR_MISC_FUNC_SOFT_INT      BIT_ULL(10)
>  #define  IOCSR_MISC_FUNC_TIMER_RESET   BIT_ULL(21)
>  #define  IOCSR_MISC_FUNC_EXT_IOI_EN    BIT_ULL(48)
> +#define  IOCSR_MISC_FUNC_INT_ENCODE    BIT_ULL(49)
>  #define  IOCSR_MISC_FUNC_AVEC_EN       BIT_ULL(51)
>
>  #define LOONGARCH_IOCSR_CPUTEMP                0x428
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..25fa3866613d 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -18,6 +18,7 @@ kvm-y +=3D vcpu.o
>  kvm-y +=3D vm.o
>  kvm-y +=3D intc/ipi.o
>  kvm-y +=3D intc/eiointc.o
> +kvm-y +=3D intc/misc.o
>  kvm-y +=3D intc/pch_pic.o
>  kvm-y +=3D irqfd.o
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index f39929d7bf8a..87d01521e92f 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -4,6 +4,7 @@
>   */
>
>  #include <asm/kvm_eiointc.h>
> +#include <asm/kvm_misc.h>
>  #include <asm/kvm_vcpu.h>
>  #include <linux/count_zeros.h>
>
> @@ -708,6 +709,56 @@ static const struct kvm_io_device_ops kvm_eiointc_op=
s =3D {
>         .write  =3D kvm_eiointc_write,
>  };
>
> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value)
> +{
> +       unsigned long data, flags;
> +       struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
> +
> +       if (!eiointc) {
> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       data =3D 0;
> +       spin_lock_irqsave(&eiointc->lock, flags);
> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
> +               data |=3D IOCSR_MISC_FUNC_EXT_IOI_EN;
> +
> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
> +               data |=3D IOCSR_MISC_FUNC_INT_ENCODE;
> +       spin_unlock_irqrestore(&eiointc->lock, flags);
> +
> +       *value =3D data;
> +       return 0;
> +}
> +
> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value=
, unsigned long mask)
> +{
> +       struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
> +       unsigned long old, flags;
> +
> +       if (!eiointc) {
> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       old =3D 0;
> +       spin_lock_irqsave(&eiointc->lock, flags);
> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
> +               old |=3D IOCSR_MISC_FUNC_EXT_IOI_EN;
> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
> +               old |=3D IOCSR_MISC_FUNC_INT_ENCODE;
> +
> +       value |=3D (old & ~mask);
> +       eiointc->status &=3D ~(BIT(EIOINTC_ENABLE_INT_ENCODE) | BIT(EIOIN=
TC_ENABLE));
> +       if (value & IOCSR_MISC_FUNC_INT_ENCODE)
> +               eiointc->status |=3D BIT(EIOINTC_ENABLE_INT_ENCODE);
> +       if (value & IOCSR_MISC_FUNC_EXT_IOI_EN)
> +               eiointc->status |=3D BIT(EIOINTC_ENABLE);
> +       spin_unlock_irqrestore(&eiointc->lock, flags);
> +       return 0;
> +}
> +
>  static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
>                                 struct kvm_io_device *dev,
>                                 gpa_t addr, int len, void *val)
> @@ -993,6 +1044,15 @@ static int kvm_eiointc_create(struct kvm_device *de=
v, u32 type)
>                 kfree(s);
>                 return ret;
>         }
> +
> +       ret =3D kvm_loongarch_create_misc(kvm);
> +       if (ret < 0) {
> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device)=
;
> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device_=
vext);
> +               kfree(s);
> +               return ret;
> +       }
> +
>         kvm->arch.eiointc =3D s;
>
>         return 0;
> @@ -1010,6 +1070,7 @@ static void kvm_eiointc_destroy(struct kvm_device *=
dev)
>         eiointc =3D kvm->arch.eiointc;
>         kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
>         kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_ve=
xt);
> +       kvm_loongarch_destroy_misc(kvm);
>         kfree(eiointc);
>  }
>
> diff --git a/arch/loongarch/kvm/intc/misc.c b/arch/loongarch/kvm/intc/mis=
c.c
> new file mode 100644
> index 000000000000..edee66afa36e
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/misc.c
> @@ -0,0 +1,125 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +#include <asm/kvm_vcpu.h>
> +#include <asm/kvm_eiointc.h>
> +#include <asm/kvm_misc.h>
> +
> +static int kvm_misc_read(struct kvm_vcpu *vcpu, struct kvm_io_device *de=
v,
> +                       gpa_t addr, int len, void *val)
> +{
> +       unsigned long data;
> +       unsigned int ret;
> +
> +       addr -=3D MISC_BASE;
> +       if (addr & (len - 1)) {
> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> +               return -EINVAL;
> +       }
> +
> +       ret =3D kvm_eiointc_get_status(vcpu, &data);
> +       if (ret)
> +               return ret;
> +
> +       data =3D data >> ((addr & 7) * 8);
> +       switch (len) {
> +       case 1:
> +               *(unsigned char *)val =3D (unsigned char)data;
> +               break;
> +
> +       case 2:
> +               *(unsigned short *)val =3D (unsigned short)data;
> +               break;
> +
> +       case 4:
> +               *(unsigned int *)val =3D (unsigned int)data;
> +               break;
> +
> +       default:
> +               *(unsigned long *)val =3D data;
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_misc_write(struct kvm_vcpu *vcpu, struct kvm_io_device *d=
ev,
> +               gpa_t addr, int len, const void *val)
> +{
> +       unsigned long data, mask;
> +       unsigned int shift;
> +
> +       addr -=3D MISC_BASE;
> +       if (addr & (len - 1)) {
> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> +               return -EINVAL;
> +       }
> +
> +       shift =3D (addr & 7) * 8;
> +       switch (len) {
> +       case 1:
> +               data =3D *(unsigned char *)val;
> +               mask =3D 0xFF;
> +               mask =3D mask << shift;
> +               data =3D data << shift;
> +               break;
> +
> +       case 2:
> +               data =3D *(unsigned short *)val;
> +               mask =3D 0xFFFF;
> +               mask =3D mask << shift;
> +               data =3D data << shift;
> +               break;
> +
> +       case 4:
> +               data =3D *(unsigned int *)val;
> +               mask =3D UINT_MAX;
> +               mask =3D mask << shift;
> +               data =3D data << shift;
> +               break;
> +
> +       default:
> +               data =3D *(unsigned long *)val;
> +               mask =3D ULONG_MAX;
> +               mask =3D mask << shift;
> +               data =3D data << shift;
> +               break;
> +       }
> +
> +       return kvm_eiointc_update_status(vcpu, data, mask);
> +}
> +
> +static const struct kvm_io_device_ops kvm_misc_ops =3D {
> +       .read   =3D kvm_misc_read,
> +       .write  =3D kvm_misc_write,
> +};
> +
> +int kvm_loongarch_create_misc(struct kvm *kvm)
> +{
> +       struct kvm_io_device *device;
> +       int ret;
> +
> +       if (kvm->arch.misc_created)
> +               return 0;
> +
> +       device =3D &kvm->arch.misc;
> +       kvm_iodevice_init(device, &kvm_misc_ops);
> +       ret =3D kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, MISC_BASE, MI=
SC_SIZE, device);
> +       if (ret < 0)
> +               return ret;
> +
> +       kvm->arch.misc_created =3D true;
> +       return 0;
> +}
> +
> +void kvm_loongarch_destroy_misc(struct kvm *kvm)
> +{
> +       struct kvm_io_device *device;
> +
> +       if (kvm->arch.misc_created) {
> +               device =3D &kvm->arch.misc;
> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
> +               kvm->arch.misc_created =3D false;
> +       }
> +}
>
> base-commit: 52da431bf03b5506203bca27fe14a97895c80faf
> --
> 2.39.3
>

