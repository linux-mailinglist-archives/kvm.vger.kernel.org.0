Return-Path: <kvm+bounces-20821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E7191F01E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 287261C236AF
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 07:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A283146D73;
	Tue,  2 Jul 2024 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kf+iHY46"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450F413D614;
	Tue,  2 Jul 2024 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905319; cv=none; b=QJG+KWaCjECHaUvLLMPXd9ylbdnGo+4TrK4AEcmmiPzmei67f0Cgt4LVXV9VO88u/zeDrPTzIgNwAlJTRhgk3TFWK0vQ/xlgLRMlvRsQrmsRMUHmWYIwYnlpczYeTI2hp3fSxb6oG8s6UtnRbnK0nroQkI+oybGwLNVyhpWM2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905319; c=relaxed/simple;
	bh=QsXpFanEidtyChqWTF3TSayQuvqt+pbFx8sFDzBDCOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BqXqr2yUJkIzl9rdNVl6Ebo4//hapDWGxYCKQn7vd6URGRQkFUcumrTOcazPUFqL0I9i/c46l79k4v7b42bG2CKV5or4FOGW3vP9ncdVQ7EKdtZOCJI5RkfBniRsRgwg+GLrN2b3lIcyKiBiJ7bs+qWWdPj/bBPOkU1AcldWOk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kf+iHY46; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE14EC4AF0D;
	Tue,  2 Jul 2024 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905319;
	bh=QsXpFanEidtyChqWTF3TSayQuvqt+pbFx8sFDzBDCOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Kf+iHY46AOgAM76ZjmtodzuNIG7qeq+ldxXywCXzu6CtyRiwWvm8+P05e8/KyE0nh
	 O6WpQryeztDewcsK1orGgVCwgGUx4uRaXjYQu6k05uDObiqmjSp0U0aOMrh1uQeisP
	 TltR1igRj8zU3loRUjOWB+Yw6c/VquIHnUmoxTg0zwsw6zW88DjIYWIF5rh1aN0KfA
	 +NvjK4voVg2iS07hUR7GCuLe5RVnC9zdiD785+DCZbskVxknKErruNt+4pqKypvJQC
	 1cIf35CCJihD4er0OSY1bwEkp2xyIbrkykY7fcG1wvo0j5Va/PMN/rVkiXVGCuWRdU
	 fY7rkD6mcuNXA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7541fad560so35715266b.0;
        Tue, 02 Jul 2024 00:28:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVJRNOLFvzeuOiQfIJ09Y2edVzKFLb9OLlTFEfsAgMOMDm0CNQOhwdoJhG4lycGE0eTCMHzEv8bryQ5UDWtjotJo3aCr9npVW/uqCSYCQVn/GZFhFsmS9uMIQRySEMi8H4D
X-Gm-Message-State: AOJu0YwMt6qXJoQGR3VAYubvH8lAL6QoDrnqR7zubK7+kkWhFxNCYk8g
	bj+Eu6Bn9u2U/mAXH1e83w4Eo70fCsNASwrUYQ+l6OxeR87lUGics087jFriDlzvnsk68Ny+kLo
	tBYyaGMAhxlL0ygpCd3qUNH4Log0=
X-Google-Smtp-Source: AGHT+IHpXNW+NcSOTpCPixx7VGPveQQpczThA5UJu4syitG4UnP3wgNBc1rDIUfomZlDFrh+EjoEmA38qVScL+SLQkk=
X-Received: by 2002:a17:906:6a15:b0:a72:5bb9:b13c with SMTP id
 a640c23a62f3a-a75144bae99mr696751166b.75.1719905317489; Tue, 02 Jul 2024
 00:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626063239.3722175-1-maobibo@loongson.cn> <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn> <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn> <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
 <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn> <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
In-Reply-To: <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Jul 2024 15:28:23 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
Message-ID: <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 12:13=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/7/2 =E4=B8=8A=E5=8D=8810:34, Huacai Chen wrote:
> > On Tue, Jul 2, 2024 at 10:25=E2=80=AFAM maobibo <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2024/7/2 =E4=B8=8A=E5=8D=889:59, Huacai Chen wrote:
> >>> On Tue, Jul 2, 2024 at 9:51=E2=80=AFAM maobibo <maobibo@loongson.cn> =
wrote:
> >>>>
> >>>> Huacai,
> >>>>
> >>>> On 2024/7/1 =E4=B8=8B=E5=8D=886:26, Huacai Chen wrote:
> >>>>> On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loongson.cn=
> wrote:
> >>>>>>
> >>>>>>
> >>>>>> Huacai,
> >>>>>>
> >>>>>> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> >>>>>>> Hi, Bibo,
> >>>>>>>
> >>>>>>> On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loongso=
n.cn> wrote:
> >>>>>>>>
> >>>>>>>> Two kinds of LBT feature detection are added here, one is VCPU
> >>>>>>>> feature, the other is VM feature. VCPU feature dection can only
> >>>>>>>> work with VCPU thread itself, and requires VCPU thread is create=
d
> >>>>>>>> already. So LBT feature detection for VM is added also, it can
> >>>>>>>> be done even if VM is not created, and also can be done by any
> >>>>>>>> thread besides VCPU threads.
> >>>>>>>>
> >>>>>>>> Loongson Binary Translation (LBT) feature is defined in register
> >>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
> >>>>>>>>
> >>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macr=
o
> >>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. =
And
> >>>>>>>> three sub-features relative with LBT are added as following:
> >>>>>>>>      KVM_LOONGARCH_VM_FEAT_X86BT
> >>>>>>>>      KVM_LOONGARCH_VM_FEAT_ARMBT
> >>>>>>>>      KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>>>>>>>
> >>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>> ---
> >>>>>>>>      arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>>>>>>>      arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>>>>>>>      arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++=
++++++++++-
> >>>>>>>>      3 files changed, 55 insertions(+), 1 deletion(-)
> >>>>>>>>
> >>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loonga=
rch/include/uapi/asm/kvm.h
> >>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>>>>>>>      #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM=
_REG_LOONGARCH_CSR, REG)
> >>>>>>>>      #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM=
_REG_LOONGARCH_CPUCFG, REG)
> >>>>>>>>
> >>>>>>>> +/* Device Control API on vm fd */
> >>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >>>>>>>> +
> >>>>>>>>      /* Device Control API on vcpu fd */
> >>>>>>>>      #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>>>>>>      #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>>>>>> If you insist that LBT should be a vm feature, then I suggest the
> >>>>>>> above two also be vm features. Though this is an UAPI change, but
> >>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been release=
d. We
> >>>>>>> have a chance to change it now.
> >>>>>>
> >>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcp=
u
> >>>>>> has is own different gpa address.
> >>>>> Then leave this as a vm feature.
> >>>>>
> >>>>>>
> >>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot=
 break
> >>>>>> the API even if it is 6.10-rc1, VMM has already used this. Else th=
ere is
> >>>>>> uapi breaking now, still will be in future if we cannot control th=
is.
> >>>>> UAPI changing before the first release is allowed, which means, we =
can
> >>>>> change this before the 6.10-final, but cannot change it after
> >>>>> 6.10-final.
> >>>> Now QEMU has already synced uapi to its own directory, also I never =
hear
> >>>> about this, with my experience with uapi change, there is only newly
> >>>> added or removed deprecated years ago.
> >>>>
> >>>> Is there any documentation about UAPI change rules?
> >>> No document, but learn from my more than 10 years upstream experience=
.
> >> Can you show me an example about with your rich upstream experience?
> > A simple example,
> > e877d705704d7c8fe17b6b5ebdfdb14b84c revert
> > 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
> > 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
> > e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior before
> > 6.9-final, but not after that.
> >
> > Before the first release, the code status is treated as "unstable", so
> > revert, modify is allowed. But after the first release, even if an
> > "error" should also be treated as a "bad feature".
> Huacai,
>
> Thanks for showing the example.
>
> For this issue, Can we adding new uapi and mark the old as deprecated?
> so that it can be removed after years.
Unnecessary, just remove the old one. Deprecation is for the usage
after the first release.

>
> For me, it is too frequent to revert the old uapi, it is not bug and
> only that we have better method now. Also QEMU has synchronized the uapi
> to its directory already.
QEMU also hasn't been released after synchronizing the uapi, so it is
OK to remove the old api now.

Huacai

>
> Regards
> Bibo, Mao
> >
> > Huacai
> >
> >
> >>>
> >>>>>
> >>>>>>
> >>>>>> How about adding new extra features capability for VM such as?
> >>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> >>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
> >>>>> They should be similar as LBT, if LBT is vcpu feature, they should
> >>>>> also be vcpu features; if LBT is vm feature, they should also be vm
> >>>>> features.
> >>>> On other architectures, with function kvm_vm_ioctl_check_extension()
> >>>>       KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
> >>>>       KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
> >>>> These features are all cpu features, at the same time they are VM fe=
atures.
> >>>>
> >>>> If they are cpu features, how does VMM detect validity of these feat=
ures
> >>>> passing from command line? After all VCPUs are created and send boot=
up
> >>>> command to these VCPUs? That is too late, VMM main thread is easy to
> >>>> detect feature validity if they are VM features also.
> >>>>
> >>>> To be honest, I am not familiar with KVM still, only get further
> >>>> understanding after actual problems solving. Welcome to give comment=
s,
> >>>> however please read more backgroud if you insist on, else there will=
 be
> >>>> endless argument again.
> >>> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
> >>> haven't insisted on whether they should be vcpu features or vm
> >>> features.
> >> It is reasonable if LSX/LASX/LBT should be in the same class, since
> >> there is feature options such as lsx=3Don/off,lasx=3Don/off,lbt=3Don/o=
ff.
> >>
> >> What is the usage about CPUCFG capability used for VM feature? It is n=
ot
> >> a detailed feature, it is only feature-set indicator like cpuid.
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo, Mao
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo Mao
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu=
.c
> >>>>>>>> index 233d28d0e928..9734b4d8db05 100644
> >>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64=
 *v)
> >>>>>>>>                             *v |=3D CPUCFG2_LSX;
> >>>>>>>>                     if (cpu_has_lasx)
> >>>>>>>>                             *v |=3D CPUCFG2_LASX;
> >>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>> +                       *v |=3D CPUCFG2_X86BT;
> >>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>> +                       *v |=3D CPUCFG2_ARMBT;
> >>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>> +                       *v |=3D CPUCFG2_MIPSBT;
> >>>>>>>>
> >>>>>>>>                     return 0;
> >>>>>>>>             case LOONGARCH_CPUCFG3:
> >>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
> >>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *=
kvm, long ext)
> >>>>>>>>             return r;
> >>>>>>>>      }
> >>>>>>>>
> >>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_=
device_attr *attr)
> >>>>>>>> +{
> >>>>>>>> +       switch (attr->attr) {
> >>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>> +                       return 0;
> >>>>>>>> +               return -ENXIO;
> >>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>> +                       return 0;
> >>>>>>>> +               return -ENXIO;
> >>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>> +                       return 0;
> >>>>>>>> +               return -ENXIO;
> >>>>>>>> +       default:
> >>>>>>>> +               return -ENXIO;
> >>>>>>>> +       }
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_a=
ttr *attr)
> >>>>>>>> +{
> >>>>>>>> +       switch (attr->group) {
> >>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
> >>>>>>>> +       default:
> >>>>>>>> +               return -ENXIO;
> >>>>>>>> +       }
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>>      int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl=
, unsigned long arg)
> >>>>>>>>      {
> >>>>>>>> -       return -ENOIOCTLCMD;
> >>>>>>>> +       struct kvm *kvm =3D filp->private_data;
> >>>>>>>> +       void __user *argp =3D (void __user *)arg;
> >>>>>>>> +       struct kvm_device_attr attr;
> >>>>>>>> +
> >>>>>>>> +       switch (ioctl) {
> >>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
> >>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> >>>>>>>> +                       return -EFAULT;
> >>>>>>>> +
> >>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
> >>>>>>>> +       default:
> >>>>>>>> +               return -EINVAL;
> >>>>>>>> +       }
> >>>>>>>>      }
> >>>>>>>> --
> >>>>>>>> 2.39.3
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>

