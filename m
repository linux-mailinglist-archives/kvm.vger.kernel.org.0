Return-Path: <kvm+bounces-20852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F109242AB
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 17:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0318A1F22D83
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 15:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD3F1BC085;
	Tue,  2 Jul 2024 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQfD7lCK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039BB15D5B3;
	Tue,  2 Jul 2024 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719935050; cv=none; b=Lw/X923WtQbHBfxYxOz+2pAwhwDZRk6pIJWGYxCAOmHnHxHL4HPXUtJ5eOO0kV8uDiHzDeq0VROvVBaB9nrwMqa3ew57WAIr8z0Fx6HrSIuICcHi37PPU2vjcDb7BxrVOQcf8hu6wCFezK1D2H3Mw8IZM0GRLwI9m9sef212r3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719935050; c=relaxed/simple;
	bh=F1Gn4x440MlS82wMJXJvrA12SkX28/R3FqLKNs4QeRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wkh5fA6pmDLHxdyBuAnWvID6wLkrsmk/z2YZBaOqybnqwHybWx+aJfVEUMA5vvXIJicam6UNFHtavyjgxY354WMkucoxIoDSP4ydLUO8d/V1rN78W5acm1Tj9//ggjLne+zNN4lP7ZuZuuEvuOSliFWq3IKUFIL3vlzLWLjjrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQfD7lCK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D95CC116B1;
	Tue,  2 Jul 2024 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719935049;
	bh=F1Gn4x440MlS82wMJXJvrA12SkX28/R3FqLKNs4QeRw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oQfD7lCK5swft2kWiLZUfkAmRAXW5GXb3uqDpf5TZ4mroht6zWwAJgTIkfspujSeK
	 gQDO4bYn78NN2g0na4QBFzTOYjxHEdGQ3mNgudbXJ1cs7Rp8IaSjkt23MT6K4zvoG1
	 ircraRx1qPiG3CZ5bZuwdyg+QJVOuHyqxPlIiw7EMFN8uUPokzL9G60rlknkj0JImR
	 zyjatCEaMp4/Ern4rIXHzVo9LgDSbIFtfxGuWm7FMGywuOzFP2pRpyLvnZM2iNs4b2
	 HgBWCKQ8fKLpwab27tvv2rkWdGJYAyT0Y8ZlJnXyjerCBXNGTa9DRx3AbXvxVJLGa/
	 nMS4hoCRmES6g==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7241b2fe79so478872366b.1;
        Tue, 02 Jul 2024 08:44:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKmy1kCS/mqz1ISkgmSWWSOVVz6n6jF19oOfj83vwacy1Bj3GeGrwjT+TCqsk1xWVNcX8+yJ+Cqoqu1M/YC7y7OzmpUYKu4NrY58QwANkehO4jrB4kwfq9GnvQ7GWlE9Ex
X-Gm-Message-State: AOJu0YyOFaPEOaeHcNUMONy+5l76uuWMv9i0KHruBrLAhYTcbfSCPBJ3
	cdA6FuuSfeV5X47JKgznnjQC3lwCvAbQlzfoOmiaT6e/Sr9RmEFHwru+T1tGdlZ8WtKv0rB+5+7
	4BSmTsPxPUuaEGp5yGGaqMNvTEEY=
X-Google-Smtp-Source: AGHT+IHsqGuN75hpZxSSor20jov3ICFkDx0SAMuDGTm6nZCPOVLLBmUXxeBrIv3R26hYXZVXMTP9PsUFy6oZ4kEwWeI=
X-Received: by 2002:a17:907:7d89:b0:a72:5a8c:87c6 with SMTP id
 a640c23a62f3a-a751443c5acmr789946866b.10.1719935048159; Tue, 02 Jul 2024
 08:44:08 -0700 (PDT)
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
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
In-Reply-To: <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Jul 2024 23:43:56 +0800
X-Gmail-Original-Message-ID: <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
Message-ID: <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 4:42=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/7/2 =E4=B8=8B=E5=8D=883:28, Huacai Chen wrote:
> > On Tue, Jul 2, 2024 at 12:13=E2=80=AFPM maobibo <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2024/7/2 =E4=B8=8A=E5=8D=8810:34, Huacai Chen wrote:
> >>> On Tue, Jul 2, 2024 at 10:25=E2=80=AFAM maobibo <maobibo@loongson.cn>=
 wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/7/2 =E4=B8=8A=E5=8D=889:59, Huacai Chen wrote:
> >>>>> On Tue, Jul 2, 2024 at 9:51=E2=80=AFAM maobibo <maobibo@loongson.cn=
> wrote:
> >>>>>>
> >>>>>> Huacai,
> >>>>>>
> >>>>>> On 2024/7/1 =E4=B8=8B=E5=8D=886:26, Huacai Chen wrote:
> >>>>>>> On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loongson.=
cn> wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> Huacai,
> >>>>>>>>
> >>>>>>>> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> >>>>>>>>> Hi, Bibo,
> >>>>>>>>>
> >>>>>>>>> On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loong=
son.cn> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Two kinds of LBT feature detection are added here, one is VCPU
> >>>>>>>>>> feature, the other is VM feature. VCPU feature dection can onl=
y
> >>>>>>>>>> work with VCPU thread itself, and requires VCPU thread is crea=
ted
> >>>>>>>>>> already. So LBT feature detection for VM is added also, it can
> >>>>>>>>>> be done even if VM is not created, and also can be done by any
> >>>>>>>>>> thread besides VCPU threads.
> >>>>>>>>>>
> >>>>>>>>>> Loongson Binary Translation (LBT) feature is defined in regist=
er
> >>>>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
> >>>>>>>>>>
> >>>>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and ma=
cro
> >>>>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature=
. And
> >>>>>>>>>> three sub-features relative with LBT are added as following:
> >>>>>>>>>>       KVM_LOONGARCH_VM_FEAT_X86BT
> >>>>>>>>>>       KVM_LOONGARCH_VM_FEAT_ARMBT
> >>>>>>>>>>       KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>>>>>>>>>
> >>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>>>> ---
> >>>>>>>>>>       arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>>>>>>>>>       arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>>>>>>>>>       arch/loongarch/kvm/vm.c               | 44 +++++++++++++=
+++++++++++++-
> >>>>>>>>>>       3 files changed, 55 insertions(+), 1 deletion(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loon=
garch/include/uapi/asm/kvm.h
> >>>>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >>>>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>>>>>>>>>       #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(=
KVM_REG_LOONGARCH_CSR, REG)
> >>>>>>>>>>       #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(=
KVM_REG_LOONGARCH_CPUCFG, REG)
> >>>>>>>>>>
> >>>>>>>>>> +/* Device Control API on vm fd */
> >>>>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >>>>>>>>>> +
> >>>>>>>>>>       /* Device Control API on vcpu fd */
> >>>>>>>>>>       #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>>>>>>>>       #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>>>>>>>> If you insist that LBT should be a vm feature, then I suggest t=
he
> >>>>>>>>> above two also be vm features. Though this is an UAPI change, b=
ut
> >>>>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been relea=
sed. We
> >>>>>>>>> have a chance to change it now.
> >>>>>>>>
> >>>>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every v=
cpu
> >>>>>>>> has is own different gpa address.
> >>>>>>> Then leave this as a vm feature.
> >>>>>>>
> >>>>>>>>
> >>>>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cann=
ot break
> >>>>>>>> the API even if it is 6.10-rc1, VMM has already used this. Else =
there is
> >>>>>>>> uapi breaking now, still will be in future if we cannot control =
this.
> >>>>>>> UAPI changing before the first release is allowed, which means, w=
e can
> >>>>>>> change this before the 6.10-final, but cannot change it after
> >>>>>>> 6.10-final.
> >>>>>> Now QEMU has already synced uapi to its own directory, also I neve=
r hear
> >>>>>> about this, with my experience with uapi change, there is only new=
ly
> >>>>>> added or removed deprecated years ago.
> >>>>>>
> >>>>>> Is there any documentation about UAPI change rules?
> >>>>> No document, but learn from my more than 10 years upstream experien=
ce.
> >>>> Can you show me an example about with your rich upstream experience?
> >>> A simple example,
> >>> e877d705704d7c8fe17b6b5ebdfdb14b84c revert
> >>> 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
> >>> 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
> >>> e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior before
> >>> 6.9-final, but not after that.
> >>>
> >>> Before the first release, the code status is treated as "unstable", s=
o
> >>> revert, modify is allowed. But after the first release, even if an
> >>> "error" should also be treated as a "bad feature".
> >> Huacai,
> >>
> >> Thanks for showing the example.
> >>
> >> For this issue, Can we adding new uapi and mark the old as deprecated?
> >> so that it can be removed after years.
> > Unnecessary, just remove the old one. Deprecation is for the usage
> > after the first release.
> >
> >>
> >> For me, it is too frequent to revert the old uapi, it is not bug and
> >> only that we have better method now. Also QEMU has synchronized the ua=
pi
> >> to its directory already.
> > QEMU also hasn't been released after synchronizing the uapi, so it is
> > OK to remove the old api now.
> No, I will not do such thing. It is just a joke to revert the uapi.
>
> So just create new world and old world on Loongarch system again?
Again, code status before the first release is *unstable*, that status
is not enough to be a "world".

It's your responsibility to make a good design at the beginning, but
you fail to do that. Fortunately we are before the first release;
unfortunately you don't want to do that.


Huacai

>
> Regards
> Bibo, Mao
>
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo, Mao
> >>>
> >>> Huacai
> >>>
> >>>
> >>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>> How about adding new extra features capability for VM such as?
> >>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> >>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
> >>>>>>> They should be similar as LBT, if LBT is vcpu feature, they shoul=
d
> >>>>>>> also be vcpu features; if LBT is vm feature, they should also be =
vm
> >>>>>>> features.
> >>>>>> On other architectures, with function kvm_vm_ioctl_check_extension=
()
> >>>>>>        KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
> >>>>>>        KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
> >>>>>> These features are all cpu features, at the same time they are VM =
features.
> >>>>>>
> >>>>>> If they are cpu features, how does VMM detect validity of these fe=
atures
> >>>>>> passing from command line? After all VCPUs are created and send bo=
otup
> >>>>>> command to these VCPUs? That is too late, VMM main thread is easy =
to
> >>>>>> detect feature validity if they are VM features also.
> >>>>>>
> >>>>>> To be honest, I am not familiar with KVM still, only get further
> >>>>>> understanding after actual problems solving. Welcome to give comme=
nts,
> >>>>>> however please read more backgroud if you insist on, else there wi=
ll be
> >>>>>> endless argument again.
> >>>>> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
> >>>>> haven't insisted on whether they should be vcpu features or vm
> >>>>> features.
> >>>> It is reasonable if LSX/LASX/LBT should be in the same class, since
> >>>> there is feature options such as lsx=3Don/off,lasx=3Don/off,lbt=3Don=
/off.
> >>>>
> >>>> What is the usage about CPUCFG capability used for VM feature? It is=
 not
> >>>> a detailed feature, it is only feature-set indicator like cpuid.
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo, Mao
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>>
> >>>>>>>> Regards
> >>>>>>>> Bibo Mao
> >>>>>>>>>
> >>>>>>>>> Huacai
> >>>>>>>>>
> >>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vc=
pu.c
> >>>>>>>>>> index 233d28d0e928..9734b4d8db05 100644
> >>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u=
64 *v)
> >>>>>>>>>>                              *v |=3D CPUCFG2_LSX;
> >>>>>>>>>>                      if (cpu_has_lasx)
> >>>>>>>>>>                              *v |=3D CPUCFG2_LASX;
> >>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>> +                       *v |=3D CPUCFG2_X86BT;
> >>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>> +                       *v |=3D CPUCFG2_ARMBT;
> >>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>> +                       *v |=3D CPUCFG2_MIPSBT;
> >>>>>>>>>>
> >>>>>>>>>>                      return 0;
> >>>>>>>>>>              case LOONGARCH_CPUCFG3:
> >>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
> >>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm=
 *kvm, long ext)
> >>>>>>>>>>              return r;
> >>>>>>>>>>       }
> >>>>>>>>>>
> >>>>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kv=
m_device_attr *attr)
> >>>>>>>>>> +{
> >>>>>>>>>> +       switch (attr->attr) {
> >>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>> +                       return 0;
> >>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>> +                       return 0;
> >>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>> +                       return 0;
> >>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>> +       default:
> >>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>> +       }
> >>>>>>>>>> +}
> >>>>>>>>>> +
> >>>>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device=
_attr *attr)
> >>>>>>>>>> +{
> >>>>>>>>>> +       switch (attr->group) {
> >>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >>>>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
> >>>>>>>>>> +       default:
> >>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>> +       }
> >>>>>>>>>> +}
> >>>>>>>>>> +
> >>>>>>>>>>       int kvm_arch_vm_ioctl(struct file *filp, unsigned int io=
ctl, unsigned long arg)
> >>>>>>>>>>       {
> >>>>>>>>>> -       return -ENOIOCTLCMD;
> >>>>>>>>>> +       struct kvm *kvm =3D filp->private_data;
> >>>>>>>>>> +       void __user *argp =3D (void __user *)arg;
> >>>>>>>>>> +       struct kvm_device_attr attr;
> >>>>>>>>>> +
> >>>>>>>>>> +       switch (ioctl) {
> >>>>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
> >>>>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> >>>>>>>>>> +                       return -EFAULT;
> >>>>>>>>>> +
> >>>>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
> >>>>>>>>>> +       default:
> >>>>>>>>>> +               return -EINVAL;
> >>>>>>>>>> +       }
> >>>>>>>>>>       }
> >>>>>>>>>> --
> >>>>>>>>>> 2.39.3
> >>>>>>>>>>
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>

