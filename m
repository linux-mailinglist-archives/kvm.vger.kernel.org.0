Return-Path: <kvm+bounces-20900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1979264F7
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5818FB212FD
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C39181B9D;
	Wed,  3 Jul 2024 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K60MVa0k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25662181311;
	Wed,  3 Jul 2024 15:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720020974; cv=none; b=n56+J0TbCZFTWs8BMBoJGEpv8IlEnNtPPWSITvJ2hqSRadV3c4XCXeGpnJoyTJiH0UsxnoxYJUw4DG0cxVlPknT8v4GqsgA3rJTpKWiaB61u+vxNYwIIt+xiAu5lU6LhSQFbsZxhtLeGzoxoK32wfsrU7TouwkzsGPVhjYkVxeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720020974; c=relaxed/simple;
	bh=6Gtk2qmlvnHp9KMxnwj1XVHDyicmeOgvQjFp0LL0ejA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RzqyCve+dyzqVp/ClSM2SGzsXUDjeb7nY0nCoziteIQ4BiGj4M/fjx+z7KRPYqCPmwRyakiV+MilPuCF9P3sXqmnssmJrTeHie5aU2N3EGtbGHfU353h0E34LnIE1suiCjIySJ/0PXM+pl7x+SfODHXKWIymiYqoP9bRFmFpLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K60MVa0k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DDFC2BD10;
	Wed,  3 Jul 2024 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720020973;
	bh=6Gtk2qmlvnHp9KMxnwj1XVHDyicmeOgvQjFp0LL0ejA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K60MVa0kZY00XMlIuG10BVsw1fvAbTLA1wI+dQs+QzjsGEhrRe4c7rQL/dAzH7q1d
	 hikH/o3k80UY5h3G3DebaqbFk7V9IUDiiqbnlJYGn7VZCkqX1v70Z1PsO4iRBjs9IR
	 ZybZXoueEOXfmXUxBT0VJKng7htFcwnRn9gNTOvOi4kDzjCIDJ0Ak0CeBqkY0g1S0A
	 GHSTLCmVtrHwDv6YNGkesSSzD6cN1GnAYaxgqdcx4XmcS1PifuXYs273mm2jlFTo3q
	 HBO8gLjbPqjjw2HieZYfYnVTiLVdAVDMqxIuX/mpaFFqjArXaOA3PxQaWPWmApy+7c
	 M2NJYXDS7o+dg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a724b4f1218so620999966b.2;
        Wed, 03 Jul 2024 08:36:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVbPNJ6b/VTDSt5Vrk4VaJPlBlJAk+S6LCuO2XzCU2YsGkPYe7bROtPQsw9zHURdJqkEyAofzahVZOiY3j/gkZ1+VuCEF9Hfc3by8417f8/yMtk8T62UeH26t3bzCFgHYM1
X-Gm-Message-State: AOJu0YxHx8BXWksRhb7K6aKsHae8/fTzRvfGeX9Q4G7Yhh43JILGmCPZ
	w9gC4hxysFP77ku+n5zj5HzGwHYxB43JL1r1xpIzTNDWGJSYrmn/JDZnmTMgsnDemEoIkDcbG02
	KiQvob4jn/H2IbSnw92EPtrQDVaE=
X-Google-Smtp-Source: AGHT+IGBP9VnY+dtMQOjnre/0HuapAdJpD8X6TeD7LjqJIsTbgs1N59f9yhR7WGs8+ALojmcrIYwMU3rz0R6m+PlUXE=
X-Received: by 2002:a17:906:a416:b0:a72:b4d6:ec6c with SMTP id
 a640c23a62f3a-a7514422b00mr608793366b.33.1720020972129; Wed, 03 Jul 2024
 08:36:12 -0700 (PDT)
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
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn> <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn> <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
In-Reply-To: <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 3 Jul 2024 23:35:59 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
Message-ID: <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 11:15=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/7/2 =E4=B8=8B=E5=8D=8811:43, Huacai Chen wrote:
> > On Tue, Jul 2, 2024 at 4:42=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >>
> >> On 2024/7/2 =E4=B8=8B=E5=8D=883:28, Huacai Chen wrote:
> >>> On Tue, Jul 2, 2024 at 12:13=E2=80=AFPM maobibo <maobibo@loongson.cn>=
 wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/7/2 =E4=B8=8A=E5=8D=8810:34, Huacai Chen wrote:
> >>>>> On Tue, Jul 2, 2024 at 10:25=E2=80=AFAM maobibo <maobibo@loongson.c=
n> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2024/7/2 =E4=B8=8A=E5=8D=889:59, Huacai Chen wrote:
> >>>>>>> On Tue, Jul 2, 2024 at 9:51=E2=80=AFAM maobibo <maobibo@loongson.=
cn> wrote:
> >>>>>>>>
> >>>>>>>> Huacai,
> >>>>>>>>
> >>>>>>>> On 2024/7/1 =E4=B8=8B=E5=8D=886:26, Huacai Chen wrote:
> >>>>>>>>> On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loongso=
n.cn> wrote:
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> Huacai,
> >>>>>>>>>>
> >>>>>>>>>> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> >>>>>>>>>>> Hi, Bibo,
> >>>>>>>>>>>
> >>>>>>>>>>> On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loo=
ngson.cn> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>> Two kinds of LBT feature detection are added here, one is VC=
PU
> >>>>>>>>>>>> feature, the other is VM feature. VCPU feature dection can o=
nly
> >>>>>>>>>>>> work with VCPU thread itself, and requires VCPU thread is cr=
eated
> >>>>>>>>>>>> already. So LBT feature detection for VM is added also, it c=
an
> >>>>>>>>>>>> be done even if VM is not created, and also can be done by a=
ny
> >>>>>>>>>>>> thread besides VCPU threads.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Loongson Binary Translation (LBT) feature is defined in regi=
ster
> >>>>>>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and =
macro
> >>>>>>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported featu=
re. And
> >>>>>>>>>>>> three sub-features relative with LBT are added as following:
> >>>>>>>>>>>>        KVM_LOONGARCH_VM_FEAT_X86BT
> >>>>>>>>>>>>        KVM_LOONGARCH_VM_FEAT_ARMBT
> >>>>>>>>>>>>        KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>>>>>>>>>>>
> >>>>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>>>>>> ---
> >>>>>>>>>>>>        arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>>>>>>>>>>>        arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>>>>>>>>>>>        arch/loongarch/kvm/vm.c               | 44 ++++++++++=
++++++++++++++++-
> >>>>>>>>>>>>        3 files changed, 55 insertions(+), 1 deletion(-)
> >>>>>>>>>>>>
> >>>>>>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/lo=
ongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >>>>>>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>>>>>>>>>>>        #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_=
64(KVM_REG_LOONGARCH_CSR, REG)
> >>>>>>>>>>>>        #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_=
64(KVM_REG_LOONGARCH_CPUCFG, REG)
> >>>>>>>>>>>>
> >>>>>>>>>>>> +/* Device Control API on vm fd */
> >>>>>>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >>>>>>>>>>>> +
> >>>>>>>>>>>>        /* Device Control API on vcpu fd */
> >>>>>>>>>>>>        #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>>>>>>>>>>        #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>>>>>>>>>> If you insist that LBT should be a vm feature, then I suggest=
 the
> >>>>>>>>>>> above two also be vm features. Though this is an UAPI change,=
 but
> >>>>>>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been rel=
eased. We
> >>>>>>>>>>> have a chance to change it now.
> >>>>>>>>>>
> >>>>>>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every=
 vcpu
> >>>>>>>>>> has is own different gpa address.
> >>>>>>>>> Then leave this as a vm feature.
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We ca=
nnot break
> >>>>>>>>>> the API even if it is 6.10-rc1, VMM has already used this. Els=
e there is
> >>>>>>>>>> uapi breaking now, still will be in future if we cannot contro=
l this.
> >>>>>>>>> UAPI changing before the first release is allowed, which means,=
 we can
> >>>>>>>>> change this before the 6.10-final, but cannot change it after
> >>>>>>>>> 6.10-final.
> >>>>>>>> Now QEMU has already synced uapi to its own directory, also I ne=
ver hear
> >>>>>>>> about this, with my experience with uapi change, there is only n=
ewly
> >>>>>>>> added or removed deprecated years ago.
> >>>>>>>>
> >>>>>>>> Is there any documentation about UAPI change rules?
> >>>>>>> No document, but learn from my more than 10 years upstream experi=
ence.
> >>>>>> Can you show me an example about with your rich upstream experienc=
e?
> >>>>> A simple example,
> >>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c revert
> >>>>> 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
> >>>>> 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
> >>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior before
> >>>>> 6.9-final, but not after that.
> >>>>>
> >>>>> Before the first release, the code status is treated as "unstable",=
 so
> >>>>> revert, modify is allowed. But after the first release, even if an
> >>>>> "error" should also be treated as a "bad feature".
> >>>> Huacai,
> >>>>
> >>>> Thanks for showing the example.
> >>>>
> >>>> For this issue, Can we adding new uapi and mark the old as deprecate=
d?
> >>>> so that it can be removed after years.
> >>> Unnecessary, just remove the old one. Deprecation is for the usage
> >>> after the first release.
> >>>
> >>>>
> >>>> For me, it is too frequent to revert the old uapi, it is not bug and
> >>>> only that we have better method now. Also QEMU has synchronized the =
uapi
> >>>> to its directory already.
> >>> QEMU also hasn't been released after synchronizing the uapi, so it is
> >>> OK to remove the old api now.
> >> No, I will not do such thing. It is just a joke to revert the uapi.
> >>
> >> So just create new world and old world on Loongarch system again?
> > Again, code status before the first release is *unstable*, that status
> > is not enough to be a "world".
> >
> > It's your responsibility to make a good design at the beginning, but
> > you fail to do that. Fortunately we are before the first release;
> > unfortunately you don't want to do that.
> Yes, this is flaw at the beginning, however it can works and new abi can
> be added.
>
> If there is no serious bug and it is synced to QEMU already, I am not
> willing to revert uabi. Different projects have its own schedule plan,
> that is one reason. The most important reason may be that different
> peoples have different ways handling these issues.
In another thread I found that Jiaxun said he has a solution to make
LBT be a vcpu feature and still works well. However, that may take
some time and is too late for 6.11.

But we have another choice now: just remove the UAPI and vm.c parts in
this series, let the LBT main parts be upstream in 6.11, and then
solve other problems after 6.11. Even if Jiaxun's solution isn't
usable, we can still use this old vm feature solution then.


Huacai
>
> Regards
> Bibo, Mao
> >
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo, Mao
> >>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo, Mao
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> How about adding new extra features capability for VM such as?
> >>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> >>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
> >>>>>>>>> They should be similar as LBT, if LBT is vcpu feature, they sho=
uld
> >>>>>>>>> also be vcpu features; if LBT is vm feature, they should also b=
e vm
> >>>>>>>>> features.
> >>>>>>>> On other architectures, with function kvm_vm_ioctl_check_extensi=
on()
> >>>>>>>>         KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
> >>>>>>>>         KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
> >>>>>>>> These features are all cpu features, at the same time they are V=
M features.
> >>>>>>>>
> >>>>>>>> If they are cpu features, how does VMM detect validity of these =
features
> >>>>>>>> passing from command line? After all VCPUs are created and send =
bootup
> >>>>>>>> command to these VCPUs? That is too late, VMM main thread is eas=
y to
> >>>>>>>> detect feature validity if they are VM features also.
> >>>>>>>>
> >>>>>>>> To be honest, I am not familiar with KVM still, only get further
> >>>>>>>> understanding after actual problems solving. Welcome to give com=
ments,
> >>>>>>>> however please read more backgroud if you insist on, else there =
will be
> >>>>>>>> endless argument again.
> >>>>>>> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
> >>>>>>> haven't insisted on whether they should be vcpu features or vm
> >>>>>>> features.
> >>>>>> It is reasonable if LSX/LASX/LBT should be in the same class, sinc=
e
> >>>>>> there is feature options such as lsx=3Don/off,lasx=3Don/off,lbt=3D=
on/off.
> >>>>>>
> >>>>>> What is the usage about CPUCFG capability used for VM feature? It =
is not
> >>>>>> a detailed feature, it is only feature-set indicator like cpuid.
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo Mao
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>>
> >>>>>>>> Regards
> >>>>>>>> Bibo, Mao
> >>>>>>>>>
> >>>>>>>>> Huacai
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> Regards
> >>>>>>>>>> Bibo Mao
> >>>>>>>>>>>
> >>>>>>>>>>> Huacai
> >>>>>>>>>>>
> >>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/=
vcpu.c
> >>>>>>>>>>>> index 233d28d0e928..9734b4d8db05 100644
> >>>>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id,=
 u64 *v)
> >>>>>>>>>>>>                               *v |=3D CPUCFG2_LSX;
> >>>>>>>>>>>>                       if (cpu_has_lasx)
> >>>>>>>>>>>>                               *v |=3D CPUCFG2_LASX;
> >>>>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>>>> +                       *v |=3D CPUCFG2_X86BT;
> >>>>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>>>> +                       *v |=3D CPUCFG2_ARMBT;
> >>>>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>>>> +                       *v |=3D CPUCFG2_MIPSBT;
> >>>>>>>>>>>>
> >>>>>>>>>>>>                       return 0;
> >>>>>>>>>>>>               case LOONGARCH_CPUCFG3:
> >>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm=
.c
> >>>>>>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
> >>>>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct k=
vm *kvm, long ext)
> >>>>>>>>>>>>               return r;
> >>>>>>>>>>>>        }
> >>>>>>>>>>>>
> >>>>>>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct =
kvm_device_attr *attr)
> >>>>>>>>>>>> +{
> >>>>>>>>>>>> +       switch (attr->attr) {
> >>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >>>>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >>>>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >>>>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>> +       default:
> >>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>> +       }
> >>>>>>>>>>>> +}
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_devi=
ce_attr *attr)
> >>>>>>>>>>>> +{
> >>>>>>>>>>>> +       switch (attr->group) {
> >>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >>>>>>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
> >>>>>>>>>>>> +       default:
> >>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>> +       }
> >>>>>>>>>>>> +}
> >>>>>>>>>>>> +
> >>>>>>>>>>>>        int kvm_arch_vm_ioctl(struct file *filp, unsigned int=
 ioctl, unsigned long arg)
> >>>>>>>>>>>>        {
> >>>>>>>>>>>> -       return -ENOIOCTLCMD;
> >>>>>>>>>>>> +       struct kvm *kvm =3D filp->private_data;
> >>>>>>>>>>>> +       void __user *argp =3D (void __user *)arg;
> >>>>>>>>>>>> +       struct kvm_device_attr attr;
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +       switch (ioctl) {
> >>>>>>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
> >>>>>>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)=
))
> >>>>>>>>>>>> +                       return -EFAULT;
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
> >>>>>>>>>>>> +       default:
> >>>>>>>>>>>> +               return -EINVAL;
> >>>>>>>>>>>> +       }
> >>>>>>>>>>>>        }
> >>>>>>>>>>>> --
> >>>>>>>>>>>> 2.39.3
> >>>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>
>

