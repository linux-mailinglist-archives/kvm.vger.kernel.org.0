Return-Path: <kvm+bounces-20730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 564BE91CFD8
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 04:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F86228238D
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 02:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456525CAC;
	Sun, 30 Jun 2024 02:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnQXold+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E74A1B;
	Sun, 30 Jun 2024 02:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719713287; cv=none; b=LhVin5QSBQbwXMsT0ZOHVfF2HaC4WcJhgKsV/rpTy1wv5mUYHf2itXOUFkzN2G8EzuM1m7FNCNocKamdhpkKpDhQE7y4jMFYNaHJuJXpAAVDRgIPrhVnF/wdQoU5wxjMBQWbPmFvWKRYUHR266xi9GoUpkUSMEL013ztrY5MYko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719713287; c=relaxed/simple;
	bh=iFjFttgRTQ2SwqDY9upSpaZfvy03BxFKJH5G8viK1w4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fVe5i0qmaUX7YPdnqtoZ1BQzf5ICQ+FHauPqwOZLPXZZXL/ih5okdp6T7TIA64cIjPG34Wg9Tt9xgS+R1KO1Lltg05ySmHRNthSXUQOTEKFwPn9s2Y4vJtvmHCGvXW6zNtKnUiKua4idNGgnaPn5JeMoUozD0uC1TkOIkDadOz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnQXold+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F6C4AF07;
	Sun, 30 Jun 2024 02:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719713286;
	bh=iFjFttgRTQ2SwqDY9upSpaZfvy03BxFKJH5G8viK1w4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tnQXold+7BItQOkaXYn4wUJFHdYVUlxe8M+8OrJYMGiJbByB1RLsWhpMsWXj+fZ7v
	 MOnofG/Fi/y+Ht2O8P5xr7B1xIb7++Kv4tDpCuwOYWi7A/tlXijIPKz8DmSmKqGgAg
	 eHNcLbYK4Cg7VtEPoMOj2+VyIhWp9RUSZJweJ0Hf6IVDrc7cdwgg6VLb0pct4qN00c
	 ZolYZ8JRUSqcihWfpA+JN/MaICV1BD6YGZIcGOkDKaAQfkU8zFUjK4jEWcBaceXw8V
	 ovVbDMcDhmyJBzs62fA1EQNk8jflJT9vLYzVGFNv0CVd++XaEobbwF+zCszPG/2Dj5
	 eDx29V833xHsg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7245453319so294811566b.1;
        Sat, 29 Jun 2024 19:08:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHZ/laENhGGVNuSjCd7jRAEpMst7kPIvjhaYjcYTuQBX6QuNLrHcNaj64l64gpIYqHP/XX+QvMvccUJ1OxSHTzq3kw/lntV0rRxwUNYAQzfzEjc1XVguYe3j5Mw0zKYs1f
X-Gm-Message-State: AOJu0YzVkVGPFYdOThYf9k9Wwh4mcYVUMNtcBJsNVazI5T0IXMsdInUT
	o6E4qwKeMD7qncIqwahl2dVTKgMK586TJhUNHchtLCAaAvU83vl71ZjxckZOQUeDbgs+qu5EgCj
	yfIp84FP1Y+5h6DHBQ7Ygnw1d9Bo=
X-Google-Smtp-Source: AGHT+IGNg1x9Zl6jHYZFTfFnRABUyl8yaxcqHbNrEka6utzRXqO6gsECXwj5mbYm4/cTFHrICnHNTtrtk7224OC3yXA=
X-Received: by 2002:a17:907:3f29:b0:a6f:6df5:a264 with SMTP id
 a640c23a62f3a-a751386ec5fmr201080466b.1.1719713285494; Sat, 29 Jun 2024
 19:08:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626063239.3722175-1-maobibo@loongson.cn> <20240626063239.3722175-3-maobibo@loongson.cn>
In-Reply-To: <20240626063239.3722175-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 30 Jun 2024 10:07:53 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
Message-ID: <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Two kinds of LBT feature detection are added here, one is VCPU
> feature, the other is VM feature. VCPU feature dection can only
> work with VCPU thread itself, and requires VCPU thread is created
> already. So LBT feature detection for VM is added also, it can
> be done even if VM is not created, and also can be done by any
> thread besides VCPU threads.
>
> Loongson Binary Translation (LBT) feature is defined in register
> cpucfg2. Here LBT capability detection for VCPU is added.
>
> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
> three sub-features relative with LBT are added as following:
>  KVM_LOONGARCH_VM_FEAT_X86BT
>  KVM_LOONGARCH_VM_FEAT_ARMBT
>  KVM_LOONGARCH_VM_FEAT_MIPSBT
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>  arch/loongarch/kvm/vcpu.c             |  6 ++++
>  arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>  3 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index ddc5cab0ffd0..c40f7d9ffe13 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -82,6 +82,12 @@ struct kvm_fpu {
>  #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CSR, REG)
>  #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CPUCFG, REG)
>
> +/* Device Control API on vm fd */
> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> +
>  /* Device Control API on vcpu fd */
>  #define KVM_LOONGARCH_VCPU_CPUCFG      0
>  #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
If you insist that LBT should be a vm feature, then I suggest the
above two also be vm features. Though this is an UAPI change, but
CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
have a chance to change it now.

Huacai

> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 233d28d0e928..9734b4d8db05 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>                         *v |=3D CPUCFG2_LSX;
>                 if (cpu_has_lasx)
>                         *v |=3D CPUCFG2_LASX;
> +               if (cpu_has_lbt_x86)
> +                       *v |=3D CPUCFG2_X86BT;
> +               if (cpu_has_lbt_arm)
> +                       *v |=3D CPUCFG2_ARMBT;
> +               if (cpu_has_lbt_mips)
> +                       *v |=3D CPUCFG2_MIPSBT;
>
>                 return 0;
>         case LOONGARCH_CPUCFG3:
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index 6b2e4f66ad26..09e05108c68b 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long=
 ext)
>         return r;
>  }
>
> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_at=
tr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> +               if (cpu_has_lbt_x86)
> +                       return 0;
> +               return -ENXIO;
> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> +               if (cpu_has_lbt_arm)
> +                       return 0;
> +               return -ENXIO;
> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> +               if (cpu_has_lbt_mips)
> +                       return 0;
> +               return -ENXIO;
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr=
)
> +{
> +       switch (attr->group) {
> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> +               return kvm_vm_feature_has_attr(kvm, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
>  int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned lo=
ng arg)
>  {
> -       return -ENOIOCTLCMD;
> +       struct kvm *kvm =3D filp->private_data;
> +       void __user *argp =3D (void __user *)arg;
> +       struct kvm_device_attr attr;
> +
> +       switch (ioctl) {
> +       case KVM_HAS_DEVICE_ATTR:
> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> +                       return -EFAULT;
> +
> +               return kvm_vm_has_attr(kvm, &attr);
> +       default:
> +               return -EINVAL;
> +       }
>  }
> --
> 2.39.3
>

