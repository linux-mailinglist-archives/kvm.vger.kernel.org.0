Return-Path: <kvm+bounces-20405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4633B914F7D
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 16:02:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F10172836A4
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AC014264F;
	Mon, 24 Jun 2024 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ES4maETQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B81422C3;
	Mon, 24 Jun 2024 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719237767; cv=none; b=HeCqvka8TjJw/AXPx9KMxXnKMdVFOeA8P7bz5nwjZJBo6/xoe0A0TSNZmh2kItOW7khf2GYAlhNCQiivUGnUZUABMPuAsEGM5ck8gJREk7N63oj5rxp3F+RYsGOBgRKimvOTG0MWZffKuiZS1x7mn09I/f/tUxyZPe8K3FNXhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719237767; c=relaxed/simple;
	bh=U5OrXuHKL3Op9dlOgeULGy1aVemr//kxPqPW521saJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bt0orAE4XSABYSW0EPwD8QtAP3TInrHjIrZwgzKo32KGEcSmEbjPBuIKkIuDUSezXu0knA+yKoSO+p5gyBuYwGT7Yq3DbjW6K03rAA3Vfk+MEZSxB79qNfN9a1VEUz7go9TSoq+ag5trpLV18UvZio8tNqoiKekOgwKz6NwZN74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ES4maETQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04578C32782;
	Mon, 24 Jun 2024 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719237766;
	bh=U5OrXuHKL3Op9dlOgeULGy1aVemr//kxPqPW521saJ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ES4maETQv3RXMfGSR+NAmPAsKP+SKilMvC5LeHVM7vnBtKXvVjK8bg2EaSY/5GyV9
	 16R0HKgRRt0G1wWOfv74PHG0XRFXw0cIve8aCA5xP4ea2DJun2pgYSO4ExQjp6C0lT
	 q++FZJ2T+Zvt7sirYuCXhqN0UNk4+vj8/yNlCydW877P8nwy8CCm99xGj4tXshReVK
	 nprUZddmjJvYXCmwMTb0Q1eptP3OP6bbf18LvCrwDT/50GMhcahFscR+J/wnmbwNb5
	 vIuDvBBDUqyHmw0kgTMgLlcyMpbtypSHuayeaZRjjxNq+krWLREl/Ds867IkFJifTt
	 pPj5I5UllZayw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a724598cfe3so197504266b.1;
        Mon, 24 Jun 2024 07:02:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxQzYISSUJslcMzDnAOBeYufxC3Z+NU78UNWO0j4QgiVCVI9dgqgxsw//G+2rvfbDaVzgWfCAFNOa+DXoJCQV9gDkZZI4HR66SUpRUvNHWJV+sNGN5k7xO9ssuiWdQfmO8
X-Gm-Message-State: AOJu0YzYotEpPkOSgCv/7XS/5vU4aWxGBSXRCQ6uNrMGuvb6hjtC/N4Z
	vIh8wQzbU7AN7knYmSgb68AIG/eGjxIPX5bw1bfI/uwbNew3+jfy/Iu+mxr+VUuX4/5QotCeWOY
	whyVHmVvY7iPRNQFZniHmav+fy0I=
X-Google-Smtp-Source: AGHT+IGOEridawHGSJTjSWtqPLGetC6GUIgnA8PS6QhQ97MbknLy9omzesEDMTuNAwt0plESwGjJ0mtJbXbi1+G76tM=
X-Received: by 2002:a17:906:2a89:b0:a6f:5f:8b7 with SMTP id
 a640c23a62f3a-a7245ba39bbmr355509366b.21.1719237764579; Mon, 24 Jun 2024
 07:02:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240527074644.836699-1-maobibo@loongson.cn> <20240527074644.836699-5-maobibo@loongson.cn>
 <CAAhV-H7wdMH=fdGhtxcJ9zY+H-PKT2q0rgrsEPm+LhBgCqNsjQ@mail.gmail.com> <1e56fc1a-351e-9d66-3954-9fe1642139a3@loongson.cn>
In-Reply-To: <1e56fc1a-351e-9d66-3954-9fe1642139a3@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Jun 2024 22:02:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4xVy7wnj3N=RxA8e_Ah-mVc2SQH3Axz+F_DNo9sM8KHA@mail.gmail.com>
Message-ID: <CAAhV-H4xVy7wnj3N=RxA8e_Ah-mVc2SQH3Axz+F_DNo9sM8KHA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] LoongArch: KVM: Add VM LBT feature detection support
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 10:00=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/6/23 =E4=B8=8B=E5=8D=886:14, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Mon, May 27, 2024 at 3:46=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Before virt machine or vcpu is created, vmm need check supported
> >> features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
> >> for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
> >> supported feature.
> >>
> >> Three sub-features relative with LBT are added, in later any new
> >> feature can be added if it is used for vmm. The sub-features is
> >>   KVM_LOONGARCH_VM_FEAT_X86BT
> >>   KVM_LOONGARCH_VM_FEAT_ARMBT
> >>   KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>   arch/loongarch/kvm/vm.c               | 44 +++++++++++++++++++++++++=
+-
> >>   2 files changed, 49 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/in=
clude/uapi/asm/kvm.h
> >> index 656aa6a723a6..ed12e509815c 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >> @@ -91,6 +91,12 @@ struct kvm_fpu {
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
> > I think LBT should be vcpu features rather than vm features, which is
> > the same like CPUCFG and FP/SIMD.
> yes, LBT is part of vcpu feature. Only when VMM check validity about
> LBT, it is too late if it is vcpu feature. It is only checkable after
> vcpu is created also, that is too late for qemu VMM.
But why do we need so early to detect LBT? Why can the CPUCFG attr be
implemented in vcpu.c?

Huacai

>
> However if it is VM feature, this feature can be checked even if VM or
> VCPU is not created.
>
> So here is LBt is treated as VM capability also, You can check function
> kvm_vm_ioctl_check_extension() on other architectures,
> KVM_CAP_GUEST_DEBUG_HW_BPS/KVM_CAP_ARM_PMU_V3 are also VM features.
>
> >
> > Moreover, this patch can be merged to the 2nd one.
> Sure, I will merge it with 2nd patch.
>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >> +
> >>   /* Device Control API on vcpu fd */
> >>   #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
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

