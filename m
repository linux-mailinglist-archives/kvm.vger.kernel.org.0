Return-Path: <kvm+bounces-51166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9F8AEF317
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 11:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53051188BCB7
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E322826C38E;
	Tue,  1 Jul 2025 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAsT/MPj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126EF269B01;
	Tue,  1 Jul 2025 09:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751361631; cv=none; b=gVV2TpG/2Ndtw0JMKD8J1zhPOVe0trcc1hBm0hmrJ1AQkJofWUXBHRMXqpbxuqC7uf3fccjL8dpkVz+0ibLozCePdh1aFz498qio2O+iwAkTEFNsCoE4AKv+jHKwFDcMyBB5zOJpiNQhY/A6KUyo39Yb+sJ7pnVOUK5lzGcvoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751361631; c=relaxed/simple;
	bh=YR1Mo0lU1rxR/+syUdZNzkPffefGUf+scFGq7Mf+1uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Br7iw03dCyhtuOoL+Gj5xiBOQSmg6XbiH+YiBQ9H1eF42HQETauWIurhdoq/eK+3Qm4/nSvGIojRPLkmHh9gEdwH7+9NU90vDKIKCAe8hYt0vy76ZP6RlW+sGYRlwWOFZVONtitPamXOq9f8F0/7S9/GpAJrdqOrb1sRRny8I0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAsT/MPj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D4C4CEF1;
	Tue,  1 Jul 2025 09:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751361630;
	bh=YR1Mo0lU1rxR/+syUdZNzkPffefGUf+scFGq7Mf+1uc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uAsT/MPjtGHsZBuY79JLbmspdiGCZcfK3asQXDMopSuU1jXRSRvICaeubRIJjIrcL
	 JmpIBqSulZHF/uGJn6BKKEMKG/mKDsMru28dJ8tVuIeZqyZp5E3hqTe6lSerKFXmXI
	 u5VmCzU2sBscM3Boy5v5e9eKORnu273JyBqh9Hd+mApYVAir6CmaGE/J7GLCg2jYBH
	 XCrSQIKQ78KdviflYamyspRPfiDyKvA9pPX26Z9JIlyeHyVy3uXdJ8S3VXCsB4UPoc
	 5MQHuP4Mfzd0taHd1Yr1zND9Gk4FoW2wgUk6S6JevtQyIyDkz72nwPSWiSgJ7roWGM
	 OLreQA3Mjy7RQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so10900580a12.3;
        Tue, 01 Jul 2025 02:20:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU9J3ULvtPYmsZKn6RcEJRfMb+0ZyLbCONqKZR9Yvh0/byu6wLLE+oqh9zu2qnKOe/x+EYQq5Y/PAGl4jfA@vger.kernel.org, AJvYcCV3cbI+8Z52zWsWdhBny2Y1YN0QvdzFk6p8oLthZsYCaugSjelcBCwrirJN29/vjJWA0uU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBt1UPjJ3CbNW+S1N+ThsI5JtdqNJcRJMVbRgbs6Od9Fe9QYdv
	6nIGGMZsJQU15wNLIE0mfsTtXq/6TnxiykBo4DtscbPABMsgFA2DfI3sd5aI2ZwyCT/7pDkps2V
	CUMMNzDQzr20NBzZbx6TWeoV4gvT85aE=
X-Google-Smtp-Source: AGHT+IFTaALBKe0BGAY7PpBeqvRGaILY1Js74zrJWRWAb4vRnQt+8dyODJRs1wEKxDI/3NSwpGgVJN+CnJ4Ho6Gm9bQ=
X-Received: by 2002:a05:6402:3511:b0:604:a19a:d84b with SMTP id
 4fb4d7f45d1cf-60c88b3e36emr15064170a12.5.1751361628990; Tue, 01 Jul 2025
 02:20:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619071449.1714869-1-maobibo@loongson.cn> <CAAhV-H42wPsxNCSp-4wy1+f-2yAJ1fuWbsC57bvQkHL0E3n=-g@mail.gmail.com>
 <31541826-2802-32e0-f8f0-f717e1c02d74@loongson.cn>
In-Reply-To: <31541826-2802-32e0-f8f0-f717e1c02d74@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 1 Jul 2025 17:20:16 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6Pzw0uuoK3DfyNz=GMzk+9od-hm2NGqGa44C+=E-cufA@mail.gmail.com>
X-Gm-Features: Ac12FXxO7IM7_gzKdKUT3B_Q3FosFvdYIYxjsxiCf5LIhsVmWTs_CR1GoJBbg-E
Message-ID: <CAAhV-H6Pzw0uuoK3DfyNz=GMzk+9od-hm2NGqGa44C+=E-cufA@mail.gmail.com>
Subject: Re: [PATCH v2] LoongArch: KVM: INTC: Add IOCSR MISC register emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 4:44=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/6/30 =E4=B8=8B=E5=8D=884:04, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Thu, Jun 19, 2025 at 3:15=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> IOCSR MISC register 0x420 controlls some features of eiointc, such as
> >> BIT 48 enables eiointc and BIT 49 set interrupt encoding mode.
> >>
> >> When kernel irqchip is set, IOCSR MISC register should be emulated in
> >> kernel also. Here add IOCSR MISC register emulation in kernel side.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >> v1 ... v2:
> >>    1. Add separate file arch/loongarch/kvm/intc/misc.c for IOCSR MISC
> >>       register 0x420 emulation, since it controls feature about AVEC
> >>       irqchip also.
> > I found we can decouple the misc register and EIOINTC in addition:
> > 1, Move misc.c out of intc directory;
> > 2, Call kvm_loongarch_create_misc() in kvm_arch_init_vm();
> > 3, Call kvm_loongarch_destroy_misc() in kvm_arch_destroy_vm();
> > 4, Then maybe misc_created can be removed.
> Now irqchip in kernel is optional, the same with misc register. Misc
> register will be emulated in user VMM if kernel-irqchip option is off.
>
> There is no way to detect kernel-irqchip option when function
> kvm_arch_init_vm() is called, and kvm_loongarch_create_misc() needs be
> dynamically called from ioctl command.
Can we use  kvm_arch_irqchip_in_kernel() to detect?


Huacai

>
> Regards
> Bibo Mao
> >
> > At last you can make this patch and others from another series to be a
> > new series.
> >
> >
> > Huacai
> >
> >>
> >>    2. Define macro MISC_BASE as LOONGARCH_IOCSR_MISC_FUNC rather than
> >>       hard coded 0x420
> >> ---
> >>   arch/loongarch/include/asm/kvm_eiointc.h |   2 +
> >>   arch/loongarch/include/asm/kvm_host.h    |   2 +
> >>   arch/loongarch/include/asm/kvm_misc.h    |  17 +++
> >>   arch/loongarch/include/asm/loongarch.h   |   1 +
> >>   arch/loongarch/kvm/Makefile              |   1 +
> >>   arch/loongarch/kvm/intc/eiointc.c        |  61 +++++++++++
> >>   arch/loongarch/kvm/intc/misc.c           | 125 +++++++++++++++++++++=
++
> >>   7 files changed, 209 insertions(+)
> >>   create mode 100644 arch/loongarch/include/asm/kvm_misc.h
> >>   create mode 100644 arch/loongarch/kvm/intc/misc.c
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch=
/include/asm/kvm_eiointc.h
> >> index a3a40aba8acf..2d1c183f2b1b 100644
> >> --- a/arch/loongarch/include/asm/kvm_eiointc.h
> >> +++ b/arch/loongarch/include/asm/kvm_eiointc.h
> >> @@ -119,5 +119,7 @@ struct loongarch_eiointc {
> >>
> >>   int kvm_loongarch_register_eiointc_device(void);
> >>   void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level=
);
> >> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *valu=
e);
> >> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long va=
lue, unsigned long mask);
> >>
> >>   #endif /* __ASM_KVM_EIOINTC_H */
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index a3c4cc46c892..f463ec52d86c 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -132,6 +132,8 @@ struct kvm_arch {
> >>          struct loongarch_ipi *ipi;
> >>          struct loongarch_eiointc *eiointc;
> >>          struct loongarch_pch_pic *pch_pic;
> >> +       struct kvm_io_device misc;
> >> +       bool   misc_created;
> >>   };
> >>
> >>   #define CSR_MAX_NUMS           0x800
> >> diff --git a/arch/loongarch/include/asm/kvm_misc.h b/arch/loongarch/in=
clude/asm/kvm_misc.h
> >> new file mode 100644
> >> index 000000000000..621e4228dea2
> >> --- /dev/null
> >> +++ b/arch/loongarch/include/asm/kvm_misc.h
> >> @@ -0,0 +1,17 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/*
> >> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> >> + */
> >> +
> >> +#ifndef __ASM_KVM_MISC_H
> >> +#define __ASM_KVM_MISC_H
> >> +
> >> +#include <asm/loongarch.h>
> >> +
> >> +#define MISC_BASE              LOONGARCH_IOCSR_MISC_FUNC
> >> +#define MISC_SIZE              0x8
> >> +
> >> +int kvm_loongarch_create_misc(struct kvm *kvm);
> >> +void kvm_loongarch_destroy_misc(struct kvm *kvm);
> >> +
> >> +#endif /* __ASM_KVM_MISC_H */
> >> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/i=
nclude/asm/loongarch.h
> >> index d84dac88a584..e30d330d497e 100644
> >> --- a/arch/loongarch/include/asm/loongarch.h
> >> +++ b/arch/loongarch/include/asm/loongarch.h
> >> @@ -1141,6 +1141,7 @@
> >>   #define  IOCSR_MISC_FUNC_SOFT_INT      BIT_ULL(10)
> >>   #define  IOCSR_MISC_FUNC_TIMER_RESET   BIT_ULL(21)
> >>   #define  IOCSR_MISC_FUNC_EXT_IOI_EN    BIT_ULL(48)
> >> +#define  IOCSR_MISC_FUNC_INT_ENCODE    BIT_ULL(49)
> >>   #define  IOCSR_MISC_FUNC_AVEC_EN       BIT_ULL(51)
> >>
> >>   #define LOONGARCH_IOCSR_CPUTEMP                0x428
> >> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> >> index cb41d9265662..25fa3866613d 100644
> >> --- a/arch/loongarch/kvm/Makefile
> >> +++ b/arch/loongarch/kvm/Makefile
> >> @@ -18,6 +18,7 @@ kvm-y +=3D vcpu.o
> >>   kvm-y +=3D vm.o
> >>   kvm-y +=3D intc/ipi.o
> >>   kvm-y +=3D intc/eiointc.o
> >> +kvm-y +=3D intc/misc.o
> >>   kvm-y +=3D intc/pch_pic.o
> >>   kvm-y +=3D irqfd.o
> >>
> >> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/in=
tc/eiointc.c
> >> index f39929d7bf8a..87d01521e92f 100644
> >> --- a/arch/loongarch/kvm/intc/eiointc.c
> >> +++ b/arch/loongarch/kvm/intc/eiointc.c
> >> @@ -4,6 +4,7 @@
> >>    */
> >>
> >>   #include <asm/kvm_eiointc.h>
> >> +#include <asm/kvm_misc.h>
> >>   #include <asm/kvm_vcpu.h>
> >>   #include <linux/count_zeros.h>
> >>
> >> @@ -708,6 +709,56 @@ static const struct kvm_io_device_ops kvm_eiointc=
_ops =3D {
> >>          .write  =3D kvm_eiointc_write,
> >>   };
> >>
> >> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *valu=
e)
> >> +{
> >> +       unsigned long data, flags;
> >> +       struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
> >> +
> >> +       if (!eiointc) {
> >> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       data =3D 0;
> >> +       spin_lock_irqsave(&eiointc->lock, flags);
> >> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
> >> +               data |=3D IOCSR_MISC_FUNC_EXT_IOI_EN;
> >> +
> >> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
> >> +               data |=3D IOCSR_MISC_FUNC_INT_ENCODE;
> >> +       spin_unlock_irqrestore(&eiointc->lock, flags);
> >> +
> >> +       *value =3D data;
> >> +       return 0;
> >> +}
> >> +
> >> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long va=
lue, unsigned long mask)
> >> +{
> >> +       struct loongarch_eiointc *eiointc =3D vcpu->kvm->arch.eiointc;
> >> +       unsigned long old, flags;
> >> +
> >> +       if (!eiointc) {
> >> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       old =3D 0;
> >> +       spin_lock_irqsave(&eiointc->lock, flags);
> >> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
> >> +               old |=3D IOCSR_MISC_FUNC_EXT_IOI_EN;
> >> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
> >> +               old |=3D IOCSR_MISC_FUNC_INT_ENCODE;
> >> +
> >> +       value |=3D (old & ~mask);
> >> +       eiointc->status &=3D ~(BIT(EIOINTC_ENABLE_INT_ENCODE) | BIT(EI=
OINTC_ENABLE));
> >> +       if (value & IOCSR_MISC_FUNC_INT_ENCODE)
> >> +               eiointc->status |=3D BIT(EIOINTC_ENABLE_INT_ENCODE);
> >> +       if (value & IOCSR_MISC_FUNC_EXT_IOI_EN)
> >> +               eiointc->status |=3D BIT(EIOINTC_ENABLE);
> >> +       spin_unlock_irqrestore(&eiointc->lock, flags);
> >> +       return 0;
> >> +}
> >> +
> >>   static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
> >>                                  struct kvm_io_device *dev,
> >>                                  gpa_t addr, int len, void *val)
> >> @@ -993,6 +1044,15 @@ static int kvm_eiointc_create(struct kvm_device =
*dev, u32 type)
> >>                  kfree(s);
> >>                  return ret;
> >>          }
> >> +
> >> +       ret =3D kvm_loongarch_create_misc(kvm);
> >> +       if (ret < 0) {
> >> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->devi=
ce);
> >> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->devi=
ce_vext);
> >> +               kfree(s);
> >> +               return ret;
> >> +       }
> >> +
> >>          kvm->arch.eiointc =3D s;
> >>
> >>          return 0;
> >> @@ -1010,6 +1070,7 @@ static void kvm_eiointc_destroy(struct kvm_devic=
e *dev)
> >>          eiointc =3D kvm->arch.eiointc;
> >>          kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->devic=
e);
> >>          kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->devic=
e_vext);
> >> +       kvm_loongarch_destroy_misc(kvm);
> >>          kfree(eiointc);
> >>   }
> >>
> >> diff --git a/arch/loongarch/kvm/intc/misc.c b/arch/loongarch/kvm/intc/=
misc.c
> >> new file mode 100644
> >> index 000000000000..edee66afa36e
> >> --- /dev/null
> >> +++ b/arch/loongarch/kvm/intc/misc.c
> >> @@ -0,0 +1,125 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> >> + */
> >> +#include <asm/kvm_vcpu.h>
> >> +#include <asm/kvm_eiointc.h>
> >> +#include <asm/kvm_misc.h>
> >> +
> >> +static int kvm_misc_read(struct kvm_vcpu *vcpu, struct kvm_io_device =
*dev,
> >> +                       gpa_t addr, int len, void *val)
> >> +{
> >> +       unsigned long data;
> >> +       unsigned int ret;
> >> +
> >> +       addr -=3D MISC_BASE;
> >> +       if (addr & (len - 1)) {
> >> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", =
__func__, addr, len);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       ret =3D kvm_eiointc_get_status(vcpu, &data);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       data =3D data >> ((addr & 7) * 8);
> >> +       switch (len) {
> >> +       case 1:
> >> +               *(unsigned char *)val =3D (unsigned char)data;
> >> +               break;
> >> +
> >> +       case 2:
> >> +               *(unsigned short *)val =3D (unsigned short)data;
> >> +               break;
> >> +
> >> +       case 4:
> >> +               *(unsigned int *)val =3D (unsigned int)data;
> >> +               break;
> >> +
> >> +       default:
> >> +               *(unsigned long *)val =3D data;
> >> +               break;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int kvm_misc_write(struct kvm_vcpu *vcpu, struct kvm_io_device=
 *dev,
> >> +               gpa_t addr, int len, const void *val)
> >> +{
> >> +       unsigned long data, mask;
> >> +       unsigned int shift;
> >> +
> >> +       addr -=3D MISC_BASE;
> >> +       if (addr & (len - 1)) {
> >> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", =
__func__, addr, len);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       shift =3D (addr & 7) * 8;
> >> +       switch (len) {
> >> +       case 1:
> >> +               data =3D *(unsigned char *)val;
> >> +               mask =3D 0xFF;
> >> +               mask =3D mask << shift;
> >> +               data =3D data << shift;
> >> +               break;
> >> +
> >> +       case 2:
> >> +               data =3D *(unsigned short *)val;
> >> +               mask =3D 0xFFFF;
> >> +               mask =3D mask << shift;
> >> +               data =3D data << shift;
> >> +               break;
> >> +
> >> +       case 4:
> >> +               data =3D *(unsigned int *)val;
> >> +               mask =3D UINT_MAX;
> >> +               mask =3D mask << shift;
> >> +               data =3D data << shift;
> >> +               break;
> >> +
> >> +       default:
> >> +               data =3D *(unsigned long *)val;
> >> +               mask =3D ULONG_MAX;
> >> +               mask =3D mask << shift;
> >> +               data =3D data << shift;
> >> +               break;
> >> +       }
> >> +
> >> +       return kvm_eiointc_update_status(vcpu, data, mask);
> >> +}
> >> +
> >> +static const struct kvm_io_device_ops kvm_misc_ops =3D {
> >> +       .read   =3D kvm_misc_read,
> >> +       .write  =3D kvm_misc_write,
> >> +};
> >> +
> >> +int kvm_loongarch_create_misc(struct kvm *kvm)
> >> +{
> >> +       struct kvm_io_device *device;
> >> +       int ret;
> >> +
> >> +       if (kvm->arch.misc_created)
> >> +               return 0;
> >> +
> >> +       device =3D &kvm->arch.misc;
> >> +       kvm_iodevice_init(device, &kvm_misc_ops);
> >> +       ret =3D kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, MISC_BASE,=
 MISC_SIZE, device);
> >> +       if (ret < 0)
> >> +               return ret;
> >> +
> >> +       kvm->arch.misc_created =3D true;
> >> +       return 0;
> >> +}
> >> +
> >> +void kvm_loongarch_destroy_misc(struct kvm *kvm)
> >> +{
> >> +       struct kvm_io_device *device;
> >> +
> >> +       if (kvm->arch.misc_created) {
> >> +               device =3D &kvm->arch.misc;
> >> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
> >> +               kvm->arch.misc_created =3D false;
> >> +       }
> >> +}
> >>
> >> base-commit: 52da431bf03b5506203bca27fe14a97895c80faf
> >> --
> >> 2.39.3
> >>
>

