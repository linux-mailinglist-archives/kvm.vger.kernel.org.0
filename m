Return-Path: <kvm+bounces-24698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF679596BC
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 10:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49ED1F24215
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 08:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB141A2840;
	Wed, 21 Aug 2024 08:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6Ol8LeZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29331531F3;
	Wed, 21 Aug 2024 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724228030; cv=none; b=nbvwF+73wTlPBiIFNHP64KGhiOl+oGqAcetmn4SVqS+NGPS6q1z1XXIQwcYNk27fqqHF5/w/8oOR8xSpNiEnAlyX7cgm4GLW3fpEvSl8R1nGftRScps/WPmwWE0m2QNo2D7YMoz1uVpwYqxtwpOkTm6nMhGl9IlR/h9r6Sje6aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724228030; c=relaxed/simple;
	bh=6jeGrf5F6QPj3TH3LoMD9xCUzC1e59dy6y0usUFYI3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8DYKJeam+tuKqLbClhewmSnJyR0T46k0Hro7P/qGl6A9jq9QaIkBng1QcnGr2cV+fl4y3yeAVVe3zRyW8g0+x273bD8zMH5N5iwhp3BdMNy5IGA5YsDqhvlfIbRfDy42+71CB8mXqrP/aIOvukXzmtdzDiveQgKVIzx5HOgBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6Ol8LeZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273CBC4AF09;
	Wed, 21 Aug 2024 08:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724228030;
	bh=6jeGrf5F6QPj3TH3LoMD9xCUzC1e59dy6y0usUFYI3A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f6Ol8LeZTAC3PQ9C8OKE2RNBE+BzoBXhT3pgrHed827P8sEXdRdHBO/V1kuy/kXZz
	 DTjI0qmHYNgEN43h2vovKTofYespdDl+tMcUp0nnMgkcMqKuoAVjlLQB9mrYKw9ht8
	 LQv+zDCi2J+k9iKHCbr1XA76NYy4ezHHwvgUEUVL2PG7655AgXyISqrmv305wzW+Ug
	 gRIa3wkPKjuqGWkKt+AeFtTr664Zc+1TA8u/m88efHYdpRRRm4PHmp45KPrqcLkZ6u
	 uQ6iJ0bdN/kmjZsOeGA63LcPSYik9KCjpIDaeT3I298TluSEWqkTWcUFwj/HSA3JAn
	 HjiZFqAJoAJUA==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f3e2f5163dso28984561fa.2;
        Wed, 21 Aug 2024 01:13:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVHQMcq81dptEfcrVtCpS9CyAeGOK6P1aL/7Ka6AOXMyZYHT0eX4YylYMuGa2jw5187vuKjC0/D4PKlfFzo@vger.kernel.org, AJvYcCVPW99y54S8xbIG3ewmiYHJXgdFSSCxISXlto/tRH8IfEQIIXNdw6vqZBD5FHXa3I+yR/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhcSx5nF08ItpLkGR99mm5d5DyZjp0xjIkrCIYA1ElYXRp66hX
	tdTvBioQIONE26b0VBsLTxDdc31h2fQ95wjT3eA8W7uKLFTD19AK4yOQKVRCgaSt/oiORgJqH+G
	3BvQwZdMhP7xRqnOhp3+jWPVjp6U=
X-Google-Smtp-Source: AGHT+IGPdq9KSUOAc69WAHGBH+vBHwiJfXrs7FHjPOTXVUawx28hFyiE2vJwAhASpX6qVL5J2SOAZIlVK6LjtB2WXIU=
X-Received: by 2002:a05:651c:b21:b0:2ef:1b64:5319 with SMTP id
 38308e7fff4ca-2f3f881cffamr10365221fa.11.1724228028334; Wed, 21 Aug 2024
 01:13:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812030210.500240-1-maobibo@loongson.cn> <20240812030210.500240-2-maobibo@loongson.cn>
 <CAAhV-H4aqu=ZOOb3UAcQt4DQNMcpUd7O=ted+Zka3pV1fjyoMQ@mail.gmail.com> <522c84a8-f919-612c-3502-9d05db97fe91@loongson.cn>
In-Reply-To: <522c84a8-f919-612c-3502-9d05db97fe91@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 21 Aug 2024 16:13:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6OjnJf_+Ukj=BnVMTFsJpnr5e4cAiP9bZSAbMdEap9yg@mail.gmail.com>
Message-ID: <CAAhV-H6OjnJf_+Ukj=BnVMTFsJpnr5e4cAiP9bZSAbMdEap9yg@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] LoongArch: KVM: Enable paravirt feature control
 from VMM
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Thomas Gleixner <tglx@linutronix.de>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org, 
	Song Gao <gaosong@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:21=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
> Huacai,
>
> Thanks for reviewing my patch.
> I reply inline.
>
> On 2024/8/19 =E4=B8=8B=E5=8D=889:32, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Mon, Aug 12, 2024 at 11:02=E2=80=AFAM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>
> >> Export kernel paravirt features to user space, so that VMM can control
> >> the single paravirt feature. By default paravirt features will be the =
same
> >> with kvm supported features if VMM does not set it.
> >>
> >> Also a new feature KVM_FEATURE_VIRT_EXTIOI is added which can be set f=
rom
> >> user space. This feature indicates that the virt EXTIOI can route
> >> interrupts to 256 vCPUs, rather than 4 vCPUs like with real HW.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h      |  7 ++++
> >>   arch/loongarch/include/asm/kvm_para.h      |  1 +
> >>   arch/loongarch/include/asm/kvm_vcpu.h      |  4 ++
> >>   arch/loongarch/include/asm/loongarch.h     | 13 ------
> >>   arch/loongarch/include/uapi/asm/Kbuild     |  2 -
> >>   arch/loongarch/include/uapi/asm/kvm.h      |  5 +++
> >>   arch/loongarch/include/uapi/asm/kvm_para.h | 24 +++++++++++
> >>   arch/loongarch/kernel/paravirt.c           |  8 ++--
> >>   arch/loongarch/kvm/exit.c                  | 19 ++++-----
> >>   arch/loongarch/kvm/vcpu.c                  | 47 ++++++++++++++++++--=
--
> >>   arch/loongarch/kvm/vm.c                    | 43 +++++++++++++++++++-
> >>   11 files changed, 137 insertions(+), 36 deletions(-)
> >>   create mode 100644 arch/loongarch/include/uapi/asm/kvm_para.h
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index 5f0677e03817..b73f6678e38a 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -107,6 +107,8 @@ struct kvm_arch {
> >>          unsigned int  root_level;
> >>          spinlock_t    phyid_map_lock;
> >>          struct kvm_phyid_map  *phyid_map;
> >> +       /* Enabled PV features */
> >> +       unsigned long pv_features;
> >>
> >>          s64 time_offset;
> >>          struct kvm_context __percpu *vmcs;
> >> @@ -136,6 +138,11 @@ enum emulation_result {
> >>   #define KVM_LARCH_SWCSR_LATEST (0x1 << 3)
> >>   #define KVM_LARCH_HWCSR_USABLE (0x1 << 4)
> >>
> >> +#define LOONGARCH_PV_FEAT_UPDATED              BIT_ULL(63)
> >> +#define LOONGARCH_PV_FEAT_MASK                                       =
  \
> >> +               (BIT(KVM_FEATURE_IPI) | BIT(KVM_FEATURE_STEAL_TIME) | =
  \
> >> +                BIT(KVM_FEATURE_VIRT_EXTIOI))
> >> +
> >>   struct kvm_vcpu_arch {
> >>          /*
> >>           * Switch pointer-to-function type to unsigned long
> >> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/in=
clude/asm/kvm_para.h
> >> index 43ec61589e6c..39d7483ab8fd 100644
> >> --- a/arch/loongarch/include/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/asm/kvm_para.h
> >> @@ -2,6 +2,7 @@
> >>   #ifndef _ASM_LOONGARCH_KVM_PARA_H
> >>   #define _ASM_LOONGARCH_KVM_PARA_H
> >>
> >> +#include <uapi/asm/kvm_para.h>
> >>   /*
> >>    * Hypercall code field
> >>    */
> >> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/in=
clude/asm/kvm_vcpu.h
> >> index c416cb7125c0..a1fc24a48fd1 100644
> >> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >> @@ -125,4 +125,8 @@ static inline bool kvm_pvtime_supported(void)
> >>          return !!sched_info_on();
> >>   }
> >>
> >> +static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu, unsig=
ned int feature)
> >> +{
> >> +       return vcpu->kvm->arch.pv_features & BIT(feature);
> >> +}
> > We have similar functions
> > kvm_guest_has_fpu/kvm_guest_has_lsx/kvm_guest_has_lasx, so maybe it is
> > better to rename it as kvm_guest_has_pv_feature().
> Sure, will do. kvm_guest_has_pv_feature() is better than guest_pv_has().
>
> >
> >>   #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
> >> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/i=
nclude/asm/loongarch.h
> >> index 04a78010fc72..eb82230f52c3 100644
> >> --- a/arch/loongarch/include/asm/loongarch.h
> >> +++ b/arch/loongarch/include/asm/loongarch.h
> >> @@ -158,19 +158,6 @@
> >>   #define  CPUCFG48_VFPU_CG              BIT(2)
> >>   #define  CPUCFG48_RAM_CG               BIT(3)
> >>
> >> -/*
> >> - * CPUCFG index area: 0x40000000 -- 0x400000ff
> >> - * SW emulation for KVM hypervirsor
> >> - */
> >> -#define CPUCFG_KVM_BASE                        0x40000000
> >> -#define CPUCFG_KVM_SIZE                        0x100
> >> -
> >> -#define CPUCFG_KVM_SIG                 (CPUCFG_KVM_BASE + 0)
> >> -#define  KVM_SIGNATURE                 "KVM\0"
> >> -#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >> -#define  KVM_FEATURE_IPI               BIT(1)
> >> -#define  KVM_FEATURE_STEAL_TIME                BIT(2)
> > It is a little better to keep these definitions here (at least
> > convenient for grep).
> These macro definitions are moved and exported in uapi file
> uapi/asm/kvm_para.h, so that user mode VMM can use it and disable or
> enable specific PV feature. So we need move it to uapi file.
We can also copy the definitions to a qemu header file rather than
UAPI. But of course the best solution is to do as other architectures
do.

And if the best solution is defining in UAPI, please keep a comment here:

/*
 * CPUCFG index area: 0x40000000 -- 0x400000ff
 * SW emulation for KVM hypervirsor, see
arch/loongarch/include/uapi/asm/kvm_para.h
 */


Huacai

>
> Regards
> Bibo Mao
> >
> >
> >
> > Huacai
> >
> >> -
> >>   #ifndef __ASSEMBLY__
> >>
> >>   /* CSR */
> >> diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/i=
nclude/uapi/asm/Kbuild
> >> index c6d141d7b7d7..517761419999 100644
> >> --- a/arch/loongarch/include/uapi/asm/Kbuild
> >> +++ b/arch/loongarch/include/uapi/asm/Kbuild
> >> @@ -1,4 +1,2 @@
> >>   # SPDX-License-Identifier: GPL-2.0
> >>   syscall-y +=3D unistd_64.h
> >> -
> >> -generic-y +=3D kvm_para.h
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/in=
clude/uapi/asm/kvm.h
> >> index ddc5cab0ffd0..719490e64e1c 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >> @@ -82,6 +82,11 @@ struct kvm_fpu {
> >>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOON=
GARCH_CSR, REG)
> >>   #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOON=
GARCH_CPUCFG, REG)
> >>
> >> +/* Device Control API on vm fd */
> >> +#define KVM_LOONGARCH_VM_FEAT_CTRL             0
> >> +#define  KVM_LOONGARCH_VM_FEAT_PV_IPI          5
> >> +#define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    6
> >> +
> >>   /* Device Control API on vcpu fd */
> >>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongar=
ch/include/uapi/asm/kvm_para.h
> >> new file mode 100644
> >> index 000000000000..5dfe675709ab
> >> --- /dev/null
> >> +++ b/arch/loongarch/include/
> >> @@ -0,0 +1,24 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >> +#ifndef _UAPI_ASM_KVM_PARA_H
> >> +#define _UAPI_ASM_KVM_PARA_H
> >> +
> >> +#include <linux/types.h>
> >> +
> >> +/*
> >> + * CPUCFG index area: 0x40000000 -- 0x400000ff
> >> + * SW emulation for KVM hypervirsor
> >> + */
> >> +#define CPUCFG_KVM_BASE                        0x40000000
> >> +#define CPUCFG_KVM_SIZE                        0x100
> >> +#define CPUCFG_KVM_SIG                 (CPUCFG_KVM_BASE + 0)
> >> +#define  KVM_SIGNATURE                 "KVM\0"
> >> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >> +#define  KVM_FEATURE_IPI               1
> >> +#define  KVM_FEATURE_STEAL_TIME                2
> >> +/*
> >> + * BIT 24 - 31 is features configurable by user space vmm
> >> + * With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs
> >> + */
> >> +#define  KVM_FEATURE_VIRT_EXTIOI       24
> >> +
> >> +#endif /* _UAPI_ASM_KVM_PARA_H */
> >> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/=
paravirt.c
> >> index 9c9b75b76f62..cc6bf096cb88 100644
> >> --- a/arch/loongarch/kernel/paravirt.c
> >> +++ b/arch/loongarch/kernel/paravirt.c
> >> @@ -175,7 +175,7 @@ int __init pv_ipi_init(void)
> >>                  return 0;
> >>
> >>          feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> >> -       if (!(feature & KVM_FEATURE_IPI))
> >> +       if (!(feature & BIT(KVM_FEATURE_IPI)))
> >>                  return 0;
> >>
> >>   #ifdef CONFIG_SMP
> >> @@ -206,7 +206,7 @@ static int pv_enable_steal_time(void)
> >>          }
> >>
> >>          addr |=3D KVM_STEAL_PHYS_VALID;
> >> -       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, =
addr);
> >> +       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_STEAL_TI=
ME), addr);
> >>
> >>          return 0;
> >>   }
> >> @@ -214,7 +214,7 @@ static int pv_enable_steal_time(void)
> >>   static void pv_disable_steal_time(void)
> >>   {
> >>          if (has_steal_clock)
> >> -               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEA=
L_TIME, 0);
> >> +               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, BIT(KVM_FEATURE_=
STEAL_TIME), 0);
> >>   }
> >>
> >>   #ifdef CONFIG_SMP
> >> @@ -266,7 +266,7 @@ int __init pv_time_init(void)
> >>                  return 0;
> >>
> >>          feature =3D read_cpucfg(CPUCFG_KVM_FEATURE);
> >> -       if (!(feature & KVM_FEATURE_STEAL_TIME))
> >> +       if (!(feature & BIT(KVM_FEATURE_STEAL_TIME)))
> >>                  return 0;
> >>
> >>          has_steal_clock =3D 1;
> >> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >> index ea73f9dc2cc6..54f78864a617 100644
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> @@ -50,9 +50,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, lar=
ch_inst inst)
> >>                  vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNATUR=
E;
> >>                  break;
> >>          case CPUCFG_KVM_FEATURE:
> >> -               ret =3D KVM_FEATURE_IPI;
> >> -               if (kvm_pvtime_supported())
> >> -                       ret |=3D KVM_FEATURE_STEAL_TIME;
> >> +               ret =3D vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEA=
T_MASK;
> >>                  vcpu->arch.gprs[rd] =3D ret;
> >>                  break;
> >>          default:
> >> @@ -697,8 +695,8 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
> >>          id   =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
> >>          data =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
> >>          switch (id) {
> >> -       case KVM_FEATURE_STEAL_TIME:
> >> -               if (!kvm_pvtime_supported())
> >> +       case BIT(KVM_FEATURE_STEAL_TIME):
> >> +               if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
> >>                          return KVM_HCALL_INVALID_CODE;
> >>
> >>                  if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VAL=
ID))
> >> @@ -712,10 +710,10 @@ static long kvm_save_notify(struct kvm_vcpu *vcp=
u)
> >>                  kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> >>                  break;
> >>          default:
> >> -               break;
> >> +               return KVM_HCALL_INVALID_CODE;
> >>          };
> >>
> >> -       return 0;
> >> +       return KVM_HCALL_INVALID_CODE;
> >>   };
> >>
> >>   /*
> >> @@ -786,8 +784,11 @@ static void kvm_handle_service(struct kvm_vcpu *v=
cpu)
> >>
> >>          switch (func) {
> >>          case KVM_HCALL_FUNC_IPI:
> >> -               kvm_send_pv_ipi(vcpu);
> >> -               ret =3D KVM_HCALL_SUCCESS;
> >> +               if (guest_pv_has(vcpu, KVM_FEATURE_IPI)) {
> >> +                       kvm_send_pv_ipi(vcpu);
> >> +                       ret =3D KVM_HCALL_SUCCESS;
> >> +               } else
> >> +                       ret =3D KVM_HCALL_INVALID_CODE;
> >>                  break;
> >>          case KVM_HCALL_FUNC_NOTIFY:
> >>                  ret =3D kvm_save_notify(vcpu);
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 16756ffb55e8..2a7d7f91facd 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -730,6 +730,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kv=
m_vcpu *vcpu,
> >>          switch (attr->attr) {
> >>          case 2:
> >>                  return 0;
> >> +       case CPUCFG_KVM_FEATURE:
> >> +               return 0;
> >>          default:
> >>                  return -ENXIO;
> >>          }
> >> @@ -740,7 +742,7 @@ static int kvm_loongarch_cpucfg_has_attr(struct kv=
m_vcpu *vcpu,
> >>   static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
> >>                                           struct kvm_device_attr *attr=
)
> >>   {
> >> -       if (!kvm_pvtime_supported() ||
> >> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
> >>                          attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA=
)
> >>                  return -ENXIO;
> >>
> >> @@ -773,9 +775,18 @@ static int kvm_loongarch_cpucfg_get_attr(struct k=
vm_vcpu *vcpu,
> >>          uint64_t val;
> >>          uint64_t __user *uaddr =3D (uint64_t __user *)attr->addr;
> >>
> >> -       ret =3D _kvm_get_cpucfg_mask(attr->attr, &val);
> >> -       if (ret)
> >> -               return ret;
> >> +       switch (attr->attr) {
> >> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
> >> +               ret =3D _kvm_get_cpucfg_mask(attr->attr, &val);
> >> +               if (ret)
> >> +                       return ret;
> >> +               break;
> >> +       case CPUCFG_KVM_FEATURE:
> >> +               val =3D vcpu->kvm->arch.pv_features & LOONGARCH_PV_FEA=
T_MASK;
> >> +               break;
> >> +       default:
> >> +               return -ENXIO;
> >> +       }
> >>
> >>          put_user(val, uaddr);
> >>
> >> @@ -788,7 +799,7 @@ static int kvm_loongarch_pvtime_get_attr(struct kv=
m_vcpu *vcpu,
> >>          u64 gpa;
> >>          u64 __user *user =3D (u64 __user *)attr->addr;
> >>
> >> -       if (!kvm_pvtime_supported() ||
> >> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
> >>                          attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA=
)
> >>                  return -ENXIO;
> >>
> >> @@ -821,7 +832,29 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm=
_vcpu *vcpu,
> >>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
> >>                                           struct kvm_device_attr *attr=
)
> >>   {
> >> -       return -ENXIO;
> >> +       u64 __user *user =3D (u64 __user *)attr->addr;
> >> +       u64 val, valid;
> >> +       struct kvm *kvm =3D vcpu->kvm;
> >> +
> >> +       switch (attr->attr) {
> >> +       case CPUCFG_KVM_FEATURE:
> >> +               if (get_user(val, user))
> >> +                       return -EFAULT;
> >> +
> >> +               valid =3D LOONGARCH_PV_FEAT_MASK;
> >> +               if (val & ~valid)
> >> +                       return -EINVAL;
> >> +
> >> +               /* All vCPUs need set the same pv features */
> >> +               if ((kvm->arch.pv_features & LOONGARCH_PV_FEAT_UPDATED=
) &&
> >> +                               ((kvm->arch.pv_features & valid) !=3D =
val))
> >> +                       return -EINVAL;
> >> +               kvm->arch.pv_features =3D val | LOONGARCH_PV_FEAT_UPDA=
TED;
> >> +               return 0;
> >> +
> >> +       default:
> >> +               return -ENXIO;
> >> +       }
> >>   }
> >>
> >>   static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
> >> @@ -831,7 +864,7 @@ static int kvm_loongarch_pvtime_set_attr(struct kv=
m_vcpu *vcpu,
> >>          u64 gpa, __user *user =3D (u64 __user *)attr->addr;
> >>          struct kvm *kvm =3D vcpu->kvm;
> >>
> >> -       if (!kvm_pvtime_supported() ||
> >> +       if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME) ||
> >>                          attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA=
)
> >>                  return -ENXIO;
> >>
> >> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >> index 6b2e4f66ad26..3234f3e85dc0 100644
> >> --- a/arch/loongarch/kvm/vm.c
> >> +++ b/arch/loongarch/kvm/vm.c
> >> @@ -5,6 +5,7 @@
> >>
> >>   #include <linux/kvm_host.h>
> >>   #include <asm/kvm_mmu.h>
> >> +#include <asm/kvm_vcpu.h>
> >>
> >>   const struct _kvm_stats_desc kvm_vm_stats_desc[] =3D {
> >>          KVM_GENERIC_VM_STATS(),
> >> @@ -39,6 +40,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >>          spin_lock_init(&kvm->arch.phyid_map_lock);
> >>
> >>          kvm_init_vmcs(kvm);
> >> +       /* Enable all pv features by default */
> >> +       kvm->arch.pv_features =3D BIT(KVM_FEATURE_IPI);
> >> +       if (kvm_pvtime_supported())
> >> +               kvm->arch.pv_features |=3D BIT(KVM_FEATURE_STEAL_TIME)=
;
> >>          kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
> >>          kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - 1;
> >>          kvm->arch.invalid_ptes[0] =3D 0;
> >> @@ -99,7 +104,43 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
> >>          return r;
> >>   }
> >>
> >> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device=
_attr *attr)
> >> +{
> >> +       switch (attr->attr) {
> >> +       case KVM_LOONGARCH_VM_FEAT_PV_IPI:
> >> +               return 0;
> >> +       case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
> >> +               if (kvm_pvtime_supported())
> >> +                       return 0;
> >> +               return -ENXIO;
> >> +       default:
> >> +               return -ENXIO;
> >> +       }
> >> +}
> >> +
> >> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *a=
ttr)
> >> +{
> >> +       switch (attr->group) {
> >> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >> +               return kvm_vm_feature_has_attr(kvm, attr);
> >> +       default:
> >> +               return -ENXIO;
> >> +       }
> >> +}
> >> +
> >>   int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigne=
d long arg)
> >>   {
> >> -       return -ENOIOCTLCMD;
> >> +       struct kvm *kvm =3D filp->private_data;
> >> +       void __user *argp =3D (void __user *)arg;
> >> +       struct kvm_device_attr attr;
> >> +
> >> +       switch (ioctl) {
> >> +       case KVM_HAS_DEVICE_ATTR:
> >> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> >> +                       return -EFAULT;
> >> +
> >> +               return kvm_vm_has_attr(kvm, &attr);
> >> +       default:
> >> +               return -EINVAL;
> >> +       }
> >>   }
> >> --
> >> 2.39.3
> >>
> >>
>
>

