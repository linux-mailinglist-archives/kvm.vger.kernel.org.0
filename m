Return-Path: <kvm+bounces-20787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5419891DC76
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D382D1F2190F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5128514A098;
	Mon,  1 Jul 2024 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AD5cT/W4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7398A145B38;
	Mon,  1 Jul 2024 10:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719829629; cv=none; b=C3/0bLkeQGkP+E6DEVTUpa/WjJIOrKtl6WEf/8IhLYMGjE7WIL4gkfP+4cigptBVrA3hcnaPUWjaltrAek8xOTHUbkS066NtWoitRPKWqYyqZG3x/Se8YHOFak3wFYY3Npe/0aq3Tw2eezOsat55M6ZFscijDHIYi5AibexVeWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719829629; c=relaxed/simple;
	bh=AOtDmRNJfqQY++v4UUgbpsLJiz5duuZ3LpRF+W3BRYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0ueEXFrjNxhG3F60PuonYrwPjBLU23WbtSUnYFCnw8cUZq9mRbKaZYUHhRDrOwEVHQU2Hf/td8JpK6HmfroSbOXFK6Zoidg+gDaa2U2sqva5zH4U3o9A+jAw/AUqwojpof0tTqiFfVnW7BBWw3iVqGdfVBlJgvNzbR1QMKT0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AD5cT/W4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1063CC4AF0D;
	Mon,  1 Jul 2024 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719829629;
	bh=AOtDmRNJfqQY++v4UUgbpsLJiz5duuZ3LpRF+W3BRYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AD5cT/W4h116AQNwUQkblKnYYn3Nnr494DhkhpVdtXYAkmHIwpahbfe5WL+SAK1uU
	 sQLL+zSTuIn4KiKKdXJexLhVkbuL9ImBQNGBKYb29uOxjtmEJMtk5wf1sXyCaGKsBu
	 U7i0ladzzbL/nYAJ0NwEwCwcq7csruoEAFfef8QIYqRsvOL+uUhOSD3CCkdmOMdL74
	 7Cc5qy4lZaDvmn6YknzWYBz9Qq88XT+Gn/Bzsj3s11ezq9J/g/o2tMZjqDVQ70aZSB
	 XO9M/r/pPs8LBS/k2xyU388E4PhybqjM292VcIOkjmsKR1E8fpU1Xwy999M1KDiEFt
	 zqysGTHZtHWPA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57d06101d76so47480a12.3;
        Mon, 01 Jul 2024 03:27:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXjs9NWW/Feus//OVZwOlZJ/PuEvAc2sJdQBN2EbzpmSp1qotPzFFf3Lhvcv+RsZTxPzICKSv7hlGj2K1pRW2NqcCmNg0wgaGHBF6S4fqzLw24Gyu2uyRMSH1040oUphrXp
X-Gm-Message-State: AOJu0YwyL2wltO/PUtOdhdXvAwe6U25BCrIOiWoo1mtXa5w/0g3vvA+7
	9PEcwilcsCsYdUqeooIcjqKB334Xo83kPB0L4s8GPGRR31tIEL2LTVJIY1bIQgHBqg7w0DsX08z
	u2D1/K48G5ZwNeCAZ1CuP6FTGcD4=
X-Google-Smtp-Source: AGHT+IHGZZCbQwYQWDz7MHph9rhLp1XsHpW9ufuafTw/vti9tqr3X02n6kFZJcNGEpVMl2xkauTKpW7VaW5Rzdmikc8=
X-Received: by 2002:a17:906:1246:b0:a72:7f22:5f9e with SMTP id
 a640c23a62f3a-a751447bd08mr264808066b.57.1719829627601; Mon, 01 Jul 2024
 03:27:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626063239.3722175-1-maobibo@loongson.cn> <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com> <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
In-Reply-To: <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 1 Jul 2024 18:26:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
Message-ID: <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
>
> Huacai,
>
> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Two kinds of LBT feature detection are added here, one is VCPU
> >> feature, the other is VM feature. VCPU feature dection can only
> >> work with VCPU thread itself, and requires VCPU thread is created
> >> already. So LBT feature detection for VM is added also, it can
> >> be done even if VM is not created, and also can be done by any
> >> thread besides VCPU threads.
> >>
> >> Loongson Binary Translation (LBT) feature is defined in register
> >> cpucfg2. Here LBT capability detection for VCPU is added.
> >>
> >> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
> >> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
> >> three sub-features relative with LBT are added as following:
> >>   KVM_LOONGARCH_VM_FEAT_X86BT
> >>   KVM_LOONGARCH_VM_FEAT_ARMBT
> >>   KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>   arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>   arch/loongarch/kvm/vm.c               | 44 +++++++++++++++++++++++++=
+-
> >>   3 files changed, 55 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/in=
clude/uapi/asm/kvm.h
> >> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOON=
GARCH_CSR, REG)
> >>   #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOON=
GARCH_CPUCFG, REG)
> >>
> >> +/* Device Control API on vm fd */
> >> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >> +
> >>   /* Device Control API on vcpu fd */
> >>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> > If you insist that LBT should be a vm feature, then I suggest the
> > above two also be vm features. Though this is an UAPI change, but
> > CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
> > have a chance to change it now.
>
> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
> has is own different gpa address.
Then leave this as a vm feature.

>
> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot break
> the API even if it is 6.10-rc1, VMM has already used this. Else there is
> uapi breaking now, still will be in future if we cannot control this.
UAPI changing before the first release is allowed, which means, we can
change this before the 6.10-final, but cannot change it after
6.10-final.

>
> How about adding new extra features capability for VM such as?
> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
They should be similar as LBT, if LBT is vcpu feature, they should
also be vcpu features; if LBT is vm feature, they should also be vm
features.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 233d28d0e928..9734b4d8db05 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
> >>                          *v |=3D CPUCFG2_LSX;
> >>                  if (cpu_has_lasx)
> >>                          *v |=3D CPUCFG2_LASX;
> >> +               if (cpu_has_lbt_x86)
> >> +                       *v |=3D CPUCFG2_X86BT;
> >> +               if (cpu_has_lbt_arm)
> >> +                       *v |=3D CPUCFG2_ARMBT;
> >> +               if (cpu_has_lbt_mips)
> >> +                       *v |=3D CPUCFG2_MIPSBT;
> >>
> >>                  return 0;
> >>          case LOONGARCH_CPUCFG3:
> >> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >> index 6b2e4f66ad26..09e05108c68b 100644
> >> --- a/arch/loongarch/kvm/vm.c
> >> +++ b/arch/loongarch/kvm/vm.c
> >> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >>          return r;
> >>   }
> >>
> >> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device=
_attr *attr)
> >> +{
> >> +       switch (attr->attr) {
> >> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >> +               if (cpu_has_lbt_x86)
> >> +                       return 0;
> >> +               return -ENXIO;
> >> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >> +               if (cpu_has_lbt_arm)
> >> +                       return 0;
> >> +               return -ENXIO;
> >> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >> +               if (cpu_has_lbt_mips)
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
>

