Return-Path: <kvm+bounces-21094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD989929F90
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48B581F21747
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183F07345B;
	Mon,  8 Jul 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uc/sem5X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E56077F0B;
	Mon,  8 Jul 2024 09:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720432304; cv=none; b=Z4h43qYqOrunsz49W259ltmwRWTQ57LZmulADfwYR1iSX6U2VBvkk9kXf3NiWxeYWCDrmaszenEdheA2Gc8vxOQCEmwHQFvS1GokPusTITFbRX3HrlzM6jFN74TdFDperFUCsu9mAPue1faX32+2BnR2yuaHV5RSjA2Dmk6XJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720432304; c=relaxed/simple;
	bh=aF5h1IXbYlhT2JKmsHLe4KKrp9Hsu7Hlo7FByZ+0aRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ISJq+gvq2sDSl37rm7q/Cn+rcf9mqm7oHX5W7DWOuCX0WTO+fMLCHjUXFzGzMvmGjDsM0bOoBNz+YcYKn/kOYlLx1QlUipU9182zsAmgK+HIGVGzYu6B+aHUsEGTVpKYqlB7snxytxC2ivB3+KrLdN2RaVnCMNEnBrYZXQhj0NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uc/sem5X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8731C4AF0B;
	Mon,  8 Jul 2024 09:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720432304;
	bh=aF5h1IXbYlhT2JKmsHLe4KKrp9Hsu7Hlo7FByZ+0aRw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Uc/sem5X09ApcG6DKSXpofr6WUuQl5F2oIUxBW6kCWku6UPBsPzxQyge+WDXPoIv+
	 heumxOnxA1FLSHFtKnUvshcaPs89IN7v2TzvgLHlhsiGnXUIiCEzykIgEdxmvG2baX
	 VuRLRsI28ipYEqApxB2jsksMroQ8LtCvxUc/GOfhayWqpMpcK1jiA4N6LepZK/oEo1
	 x4v/XW++OyEGYB+FgF7ASnME9eHWF/y2eSAJ1tP4ywVyTuAUMlbUgpzC19y6fgg5WH
	 oJoAtuL2D7zCe4IJZqKFCFazFBokS5a2TF6oBSiSBmJwWbEBkw//tn7SbwhYWkSMbA
	 4FQh8lZr1Erbg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a77e2f51496so200896366b.0;
        Mon, 08 Jul 2024 02:51:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXI/jkUWiSfqfwuzNSJpSG1FpNGIlavfna58NyWaZJkMWG+QTR/WhBHAmHwO93EWts5Fq4k032G5jdLZvnCNHFwg4dpLac6mn6M+Aktzxvjr18VM1esIJ1uHLQW0KDOEs6m
X-Gm-Message-State: AOJu0Yw0BHz7Hpwf/mg6BqMnWR4J19hS4T+762r6YcvrNolhthHMx86L
	2RMT/vzuByMH5eOlRrXmD+heoBV5fZmd2YIDFsSg0M0yBvMzq3lmdN8smQm8S8qNZPrd5/AUgh1
	uATFsGCqR8GkzULswYl5dqIFhQi0=
X-Google-Smtp-Source: AGHT+IEfTHH6m1cAOk+7KHobDNGbFu5dAC9Na0+gfKk757fy9VEX/2qBfWHZAG7HegQ0snBiNfCd5YxRKzIGOGtZ0ko=
X-Received: by 2002:a17:906:3652:b0:a77:c6c4:2bb7 with SMTP id
 a640c23a62f3a-a77c6c42d80mr561150166b.1.1720432302388; Mon, 08 Jul 2024
 02:51:42 -0700 (PDT)
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
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn> <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
 <aac97476-0a3a-657d-9340-c129bc710791@loongson.cn>
In-Reply-To: <aac97476-0a3a-657d-9340-c129bc710791@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 8 Jul 2024 17:51:29 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Pqf6_MLwhe8eC0XvspMnUvxB=HdLvPsAT6U=m5SozCg@mail.gmail.com>
Message-ID: <CAAhV-H7Pqf6_MLwhe8eC0XvspMnUvxB=HdLvPsAT6U=m5SozCg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 9:24=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/7/3 =E4=B8=8B=E5=8D=8811:35, Huacai Chen wrote:
> > On Wed, Jul 3, 2024 at 11:15=E2=80=AFAM maobibo <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2024/7/2 =E4=B8=8B=E5=8D=8811:43, Huacai Chen wrote:
> >>> On Tue, Jul 2, 2024 at 4:42=E2=80=AFPM maobibo <maobibo@loongson.cn> =
wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/7/2 =E4=B8=8B=E5=8D=883:28, Huacai Chen wrote:
> >>>>> On Tue, Jul 2, 2024 at 12:13=E2=80=AFPM maobibo <maobibo@loongson.c=
n> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2024/7/2 =E4=B8=8A=E5=8D=8810:34, Huacai Chen wrote:
> >>>>>>> On Tue, Jul 2, 2024 at 10:25=E2=80=AFAM maobibo <maobibo@loongson=
.cn> wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 2024/7/2 =E4=B8=8A=E5=8D=889:59, Huacai Chen wrote:
> >>>>>>>>> On Tue, Jul 2, 2024 at 9:51=E2=80=AFAM maobibo <maobibo@loongso=
n.cn> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Huacai,
> >>>>>>>>>>
> >>>>>>>>>> On 2024/7/1 =E4=B8=8B=E5=8D=886:26, Huacai Chen wrote:
> >>>>>>>>>>> On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loong=
son.cn> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> Huacai,
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> >>>>>>>>>>>>> Hi, Bibo,
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@l=
oongson.cn> wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Two kinds of LBT feature detection are added here, one is =
VCPU
> >>>>>>>>>>>>>> feature, the other is VM feature. VCPU feature dection can=
 only
> >>>>>>>>>>>>>> work with VCPU thread itself, and requires VCPU thread is =
created
> >>>>>>>>>>>>>> already. So LBT feature detection for VM is added also, it=
 can
> >>>>>>>>>>>>>> be done even if VM is not created, and also can be done by=
 any
> >>>>>>>>>>>>>> thread besides VCPU threads.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Loongson Binary Translation (LBT) feature is defined in re=
gister
> >>>>>>>>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, an=
d macro
> >>>>>>>>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported fea=
ture. And
> >>>>>>>>>>>>>> three sub-features relative with LBT are added as followin=
g:
> >>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_X86BT
> >>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_ARMBT
> >>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>>>>>>>> ---
> >>>>>>>>>>>>>>         arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>>>>>>>>>>>>>         arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>>>>>>>>>>>>>         arch/loongarch/kvm/vm.c               | 44 +++++++=
+++++++++++++++++++-
> >>>>>>>>>>>>>>         3 files changed, 55 insertions(+), 1 deletion(-)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/=
loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >>>>>>>>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>>>>>>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>>>>>>>>>>>>>         #define KVM_IOC_CSRID(REG)             LOONGARCH_R=
EG_64(KVM_REG_LOONGARCH_CSR, REG)
> >>>>>>>>>>>>>>         #define KVM_IOC_CPUCFG(REG)            LOONGARCH_R=
EG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> +/* Device Control API on vm fd */
> >>>>>>>>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>         /* Device Control API on vcpu fd */
> >>>>>>>>>>>>>>         #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>>>>>>>>>>>>         #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>>>>>>>>>>>> If you insist that LBT should be a vm feature, then I sugge=
st the
> >>>>>>>>>>>>> above two also be vm features. Though this is an UAPI chang=
e, but
> >>>>>>>>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been r=
eleased. We
> >>>>>>>>>>>>> have a chance to change it now.
> >>>>>>>>>>>>
> >>>>>>>>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since eve=
ry vcpu
> >>>>>>>>>>>> has is own different gpa address.
> >>>>>>>>>>> Then leave this as a vm feature.
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We =
cannot break
> >>>>>>>>>>>> the API even if it is 6.10-rc1, VMM has already used this. E=
lse there is
> >>>>>>>>>>>> uapi breaking now, still will be in future if we cannot cont=
rol this.
> >>>>>>>>>>> UAPI changing before the first release is allowed, which mean=
s, we can
> >>>>>>>>>>> change this before the 6.10-final, but cannot change it after
> >>>>>>>>>>> 6.10-final.
> >>>>>>>>>> Now QEMU has already synced uapi to its own directory, also I =
never hear
> >>>>>>>>>> about this, with my experience with uapi change, there is only=
 newly
> >>>>>>>>>> added or removed deprecated years ago.
> >>>>>>>>>>
> >>>>>>>>>> Is there any documentation about UAPI change rules?
> >>>>>>>>> No document, but learn from my more than 10 years upstream expe=
rience.
> >>>>>>>> Can you show me an example about with your rich upstream experie=
nce?
> >>>>>>> A simple example,
> >>>>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c revert
> >>>>>>> 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
> >>>>>>> 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
> >>>>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior befor=
e
> >>>>>>> 6.9-final, but not after that.
> >>>>>>>
> >>>>>>> Before the first release, the code status is treated as "unstable=
", so
> >>>>>>> revert, modify is allowed. But after the first release, even if a=
n
> >>>>>>> "error" should also be treated as a "bad feature".
> >>>>>> Huacai,
> >>>>>>
> >>>>>> Thanks for showing the example.
> >>>>>>
> >>>>>> For this issue, Can we adding new uapi and mark the old as depreca=
ted?
> >>>>>> so that it can be removed after years.
> >>>>> Unnecessary, just remove the old one. Deprecation is for the usage
> >>>>> after the first release.
> >>>>>
> >>>>>>
> >>>>>> For me, it is too frequent to revert the old uapi, it is not bug a=
nd
> >>>>>> only that we have better method now. Also QEMU has synchronized th=
e uapi
> >>>>>> to its directory already.
> >>>>> QEMU also hasn't been released after synchronizing the uapi, so it =
is
> >>>>> OK to remove the old api now.
> >>>> No, I will not do such thing. It is just a joke to revert the uapi.
> >>>>
> >>>> So just create new world and old world on Loongarch system again?
> >>> Again, code status before the first release is *unstable*, that statu=
s
> >>> is not enough to be a "world".
> >>>
> >>> It's your responsibility to make a good design at the beginning, but
> >>> you fail to do that. Fortunately we are before the first release;
> >>> unfortunately you don't want to do that.
> >> Yes, this is flaw at the beginning, however it can works and new abi c=
an
> >> be added.
> >>
> >> If there is no serious bug and it is synced to QEMU already, I am not
> >> willing to revert uabi. Different projects have its own schedule plan,
> >> that is one reason. The most important reason may be that different
> >> peoples have different ways handling these issues.
> > In another thread I found that Jiaxun said he has a solution to make
> > LBT be a vcpu feature and still works well. However, that may take
> > some time and is too late for 6.11.
>
> It is welcome if Jiaxun provide patch for host machine type, I have no
> time give any feedback with suggestion of Jianxun now.
>
> >
> > But we have another choice now: just remove the UAPI and vm.c parts in
> > this series, let the LBT main parts be upstream in 6.11, and then
> > solve other problems after 6.11. Even if Jiaxun's solution isn't
> > usable, we can still use this old vm feature solution then.
>
> There is not useul if only LBT main part goes upstream. VMM cannot use
> LBT if control part is not merged.
There is no control part UAPI for LSX/LASX, but it works.
If you insist that all should be merged together, there is probably
not enough time for the 6.11 merge window.

Huacai

>
>  From another side, what do you like to do? Reviewing patch of others
> and give comments whatever grammar spelling or useful suggestions, or
> Writing patch which needs much efforts rather than somethings like
> feature configuration, BSP drivers.
>
> Regards
> Bibo Mao
>
> >
> >
> > Huacai
> >>
> >> Regards
> >> Bibo, Mao
> >>>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Regards
> >>>> Bibo, Mao
> >>>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo, Mao
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> How about adding new extra features capability for VM such a=
s?
> >>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> >>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
> >>>>>>>>>>> They should be similar as LBT, if LBT is vcpu feature, they s=
hould
> >>>>>>>>>>> also be vcpu features; if LBT is vm feature, they should also=
 be vm
> >>>>>>>>>>> features.
> >>>>>>>>>> On other architectures, with function kvm_vm_ioctl_check_exten=
sion()
> >>>>>>>>>>          KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
> >>>>>>>>>>          KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
> >>>>>>>>>> These features are all cpu features, at the same time they are=
 VM features.
> >>>>>>>>>>
> >>>>>>>>>> If they are cpu features, how does VMM detect validity of thes=
e features
> >>>>>>>>>> passing from command line? After all VCPUs are created and sen=
d bootup
> >>>>>>>>>> command to these VCPUs? That is too late, VMM main thread is e=
asy to
> >>>>>>>>>> detect feature validity if they are VM features also.
> >>>>>>>>>>
> >>>>>>>>>> To be honest, I am not familiar with KVM still, only get furth=
er
> >>>>>>>>>> understanding after actual problems solving. Welcome to give c=
omments,
> >>>>>>>>>> however please read more backgroud if you insist on, else ther=
e will be
> >>>>>>>>>> endless argument again.
> >>>>>>>>> I just say CPUCFG/LSX/LASX and LBT should be in the same class,=
 I
> >>>>>>>>> haven't insisted on whether they should be vcpu features or vm
> >>>>>>>>> features.
> >>>>>>>> It is reasonable if LSX/LASX/LBT should be in the same class, si=
nce
> >>>>>>>> there is feature options such as lsx=3Don/off,lasx=3Don/off,lbt=
=3Don/off.
> >>>>>>>>
> >>>>>>>> What is the usage about CPUCFG capability used for VM feature? I=
t is not
> >>>>>>>> a detailed feature, it is only feature-set indicator like cpuid.
> >>>>>>>>
> >>>>>>>> Regards
> >>>>>>>> Bibo Mao
> >>>>>>>>>
> >>>>>>>>> Huacai
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> Regards
> >>>>>>>>>> Bibo, Mao
> >>>>>>>>>>>
> >>>>>>>>>>> Huacai
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> Regards
> >>>>>>>>>>>> Bibo Mao
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Huacai
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kv=
m/vcpu.c
> >>>>>>>>>>>>>> index 233d28d0e928..9734b4d8db05 100644
> >>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int i=
d, u64 *v)
> >>>>>>>>>>>>>>                                *v |=3D CPUCFG2_LSX;
> >>>>>>>>>>>>>>                        if (cpu_has_lasx)
> >>>>>>>>>>>>>>                                *v |=3D CPUCFG2_LASX;
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>>>>>> +                       *v |=3D CPUCFG2_X86BT;
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>>>>>> +                       *v |=3D CPUCFG2_ARMBT;
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>>>>>> +                       *v |=3D CPUCFG2_MIPSBT;
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>                        return 0;
> >>>>>>>>>>>>>>                case LOONGARCH_CPUCFG3:
> >>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/=
vm.c
> >>>>>>>>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
> >>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct=
 kvm *kvm, long ext)
> >>>>>>>>>>>>>>                return r;
> >>>>>>>>>>>>>>         }
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struc=
t kvm_device_attr *attr)
> >>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>> +       switch (attr->attr) {
> >>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_x86)
> >>>>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_arm)
> >>>>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >>>>>>>>>>>>>> +               if (cpu_has_lbt_mips)
> >>>>>>>>>>>>>> +                       return 0;
> >>>>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>>>> +       default:
> >>>>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_de=
vice_attr *attr)
> >>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>> +       switch (attr->group) {
> >>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >>>>>>>>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
> >>>>>>>>>>>>>> +       default:
> >>>>>>>>>>>>>> +               return -ENXIO;
> >>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>         int kvm_arch_vm_ioctl(struct file *filp, unsigned =
int ioctl, unsigned long arg)
> >>>>>>>>>>>>>>         {
> >>>>>>>>>>>>>> -       return -ENOIOCTLCMD;
> >>>>>>>>>>>>>> +       struct kvm *kvm =3D filp->private_data;
> >>>>>>>>>>>>>> +       void __user *argp =3D (void __user *)arg;
> >>>>>>>>>>>>>> +       struct kvm_device_attr attr;
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       switch (ioctl) {
> >>>>>>>>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
> >>>>>>>>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(att=
r)))
> >>>>>>>>>>>>>> +                       return -EFAULT;
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
> >>>>>>>>>>>>>> +       default:
> >>>>>>>>>>>>>> +               return -EINVAL;
> >>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>>         }
> >>>>>>>>>>>>>> --
> >>>>>>>>>>>>>> 2.39.3
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>
> >>>>>>
> >>>>
> >>
> >>
>
>

