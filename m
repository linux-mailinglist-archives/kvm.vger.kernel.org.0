Return-Path: <kvm+bounces-34420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F39E9FEE06
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 09:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EFD01882D53
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 08:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D201925BC;
	Tue, 31 Dec 2024 08:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrBZXTHc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38D918C03A;
	Tue, 31 Dec 2024 08:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735634504; cv=none; b=hQYOG3GigpV4oRdzlvIf8VtMLLaA/pPjgLPIkinMWcs6JBssms9aque5PJvSI+Ny+wQlMP9iAPeComdyHAxsP4j82hdG1yPLioPcQW0uDSOlKCn5y7ouWvGPtTqDDqqgcYfQWTH2KKReRXTPKwvNywUQ2kWIoNGhllGbyETEedg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735634504; c=relaxed/simple;
	bh=S0pZB/8+bUrTH2ZqE0EYDyre8eepmgbbfxKsDiu+VrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TQ+BcUAI8IxQHACjIxMAcXUTOxfIeuL4+hVpK1vaZHgfYFKuO2uXApwLrFBRfiP1SLaLXvK/grbM868dDxKY/iZYPbc99F+p2DfmHeOsGDjjeraf4CDKdl/USpLN8A903+TOxZ3Dx4qlgWlo5YgKmTDQihRqhq3B4olfm62HsEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrBZXTHc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58953C4CEDD;
	Tue, 31 Dec 2024 08:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735634504;
	bh=S0pZB/8+bUrTH2ZqE0EYDyre8eepmgbbfxKsDiu+VrA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LrBZXTHc6Bi/SZHFlMIrtxkc13Bg/2piNGm+9dwHE8/pPdEiZv40pAyZf1kbchdZD
	 7p5OoGmIBWu78KnotqqIY+Yx4OR7z4P1LtLqlJ8l9iTbWUVknsMMt2cI44+kUk0eXo
	 bRvU2z74nAgumFEBCFWj1goBB7S/zG/bQfs43sgeNzxRk1lbB5V3iAqB2h0B4xIFEU
	 w+x0heRyV+lNtabUvYbhXzJn/UuQcxidQWFHwvr2uq8JyQzoRAjntibvW5BECllmZr
	 E+whnF9oXqXANXVHmD+G8d5aVHMq4xda5085pANhv/k7NU12EI1plahQ3HNq0e8P0S
	 a8G8uF4B4mUbA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aabfb33aff8so1714768866b.0;
        Tue, 31 Dec 2024 00:41:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVF99mk+9mvGTAeXD8/wWnBIJgP6slaputd9OYIxX17vdzzx8V0POkqK7OmYvr0IFAD/og=@vger.kernel.org, AJvYcCWJW/9hIgWT5GbdeoOLTmRo919FB5ZQQN7/dKX+GBBk3/ahoiCwo/MpNzqociW4XUvZUGdTQibEHAc/6B2T@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2ziQ0TF3Fe1YCXh1l8pJo3zKo2Y321g0BS4bQr7B5nSx6PtOC
	lKspvLY+c6BhrCALbnchxiqTcAF2bzGsaM1Io8OsBm+1UzGu8suwz51InVujpjTUsnZY6qzFDCz
	+FmPlOwB/r5baBsvZEI19t3HGtig=
X-Google-Smtp-Source: AGHT+IGn6DKTkVSNuM8NChZ2lX6kl/NYz5C7Zxt/IShJNy1LmXTWOSXX3+bu6j82mB9yxcCox69lem/for4w9uA5QNc=
X-Received: by 2002:a17:907:7fa1:b0:aab:8311:951f with SMTP id
 a640c23a62f3a-aac3349a9aamr3389940266b.6.1735634502780; Tue, 31 Dec 2024
 00:41:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223084212.34822-1-maobibo@loongson.cn> <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
 <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn> <CAAhV-H42D4Rybzkc9YVsjo+GEQwiq4LTdjtmWyOzaqmuW6x8CQ@mail.gmail.com>
 <521ca7c6-64a2-53fa-5cff-b366ae73f600@loongson.cn>
In-Reply-To: <521ca7c6-64a2-53fa-5cff-b366ae73f600@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 31 Dec 2024 16:41:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5TVwX2T=ccT4o0btJEbL+gwBESBD6Y_Z2BEqNuhom3iw@mail.gmail.com>
Message-ID: <CAAhV-H5TVwX2T=ccT4o0btJEbL+gwBESBD6Y_Z2BEqNuhom3iw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: bibo mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2024 at 10:13=E2=80=AFAM bibo mao <maobibo@loongson.cn> wro=
te:
>
> Hi Huacai,
>
> On 2024/12/23 =E4=B8=8B=E5=8D=885:05, Huacai Chen wrote:
> > I also tried to port an untested version, but I think your version is
> > a tested one.
> > https://github.com/chenhuacai/linux/commit/e6596b0e45c80756794aba74ac08=
6c5c0e0306eb
> >
> > And I have some questions:
> > 1, "user service" is not only for syscall, so you rename it?
> > 2, Why 4.19 doesn't need something like "vcpu->run->hypercall.args[0]
> > =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A0);"
> > 3, I think my version about "vcpu->run->exit_reason =3D
> > KVM_EXIT_HYPERCALL;" and "update_pc()" is a little better than yours,
> > so you can improve them.
> After a second thought, update_pc() before return to user may be not
> strictly right, since user VMM can dump registers including pc which is
> advanced already.
Agree, and we can see how others do.

>
> How about adding function kvm_complete_hypercall() like
> kvm_complete_mmio_read(), such as:
 kvm_complete_user_service() maybe better? Since the "classic
hypercall" doesn't come here.

And we may also need to set vcpu->run->exit_reason for all cases,
which is done in my version.

Huacai

> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> +int kvm_complete_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +       update_pc(&vcpu->arch);
> +       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
> +}
> +
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1736,8 +1736,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                  if (!run->iocsr_io.is_write)
>                          kvm_complete_iocsr_read(vcpu, run);
>          } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> -               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret)=
;
> -               update_pc(&vcpu->arch);
> +               kvm_complete_hypercall(vcpu, run);
> +               run->exit_reason =3D KVM_EXIT_UNKNOWN;
>          }
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Mon, Dec 23, 2024 at 4:54=E2=80=AFPM bibo mao <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2024/12/23 =E4=B8=8B=E5=8D=884:50, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> Is this patch trying to do the same thing as "LoongArch: add hypcall
> >>> to emulate syscall in kvm" in 4.19?
> >> yes, it is to do so -:)
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>> On Mon, Dec 23, 2024 at 4:42=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Some VMMs provides special hypercall service in usermode, KVM need
> >>>> not handle the usermode hypercall service and pass it to VMM and
> >>>> let VMM handle it.
> >>>>
> >>>> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
> >>>> service, KVM loads all six registers to VMM.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_host.h      |  1 +
> >>>>    arch/loongarch/include/asm/kvm_para.h      |  2 ++
> >>>>    arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
> >>>>    arch/loongarch/kvm/exit.c                  | 22 +++++++++++++++++=
+++++
> >>>>    arch/loongarch/kvm/vcpu.c                  |  3 +++
> >>>>    5 files changed, 29 insertions(+)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/=
include/asm/kvm_host.h
> >>>> index 7b8367c39da8..590982cd986e 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>> @@ -162,6 +162,7 @@ enum emulation_result {
> >>>>    #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
> >>>>    #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |   =
      \
> >>>>                                            BIT(KVM_FEATURE_STEAL_TIM=
E) |  \
> >>>> +                                        BIT(KVM_FEATURE_USER_HCALL)=
 |  \
> >>>>                                            BIT(KVM_FEATURE_VIRT_EXTI=
OI))
> >>>>
> >>>>    struct kvm_vcpu_arch {
> >>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/=
include/asm/kvm_para.h
> >>>> index c4e84227280d..d3c00de484f6 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>>> @@ -13,12 +13,14 @@
> >>>>
> >>>>    #define KVM_HCALL_CODE_SERVICE         0
> >>>>    #define KVM_HCALL_CODE_SWDBG           1
> >>>> +#define KVM_HCALL_CODE_USER            2
> >>>>
> >>>>    #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISO=
R_KVM, KVM_HCALL_CODE_SERVICE)
> >>>>    #define  KVM_HCALL_FUNC_IPI            1
> >>>>    #define  KVM_HCALL_FUNC_NOTIFY         2
> >>>>
> >>>>    #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(H=
YPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
> >>>> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISOR_=
KVM, KVM_HCALL_CODE_USER)
> >>>>
> >>>>    /*
> >>>>     * LoongArch hypercall return code
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loong=
arch/include/uapi/asm/kvm_para.h
> >>>> index b0604aa9b4bb..76d802ef01ce 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>> @@ -17,5 +17,6 @@
> >>>>    #define  KVM_FEATURE_STEAL_TIME                2
> >>>>    /* BIT 24 - 31 are features configurable by user space vmm */
> >>>>    #define  KVM_FEATURE_VIRT_EXTIOI       24
> >>>> +#define  KVM_FEATURE_USER_HCALL                25
> >>>>
> >>>>    #endif /* _UAPI_ASM_KVM_PARA_H */
> >>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >>>> index a7893bd01e73..1a85cd4fb6a5 100644
> >>>> --- a/arch/loongarch/kvm/exit.c
> >>>> +++ b/arch/loongarch/kvm/exit.c
> >>>> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu=
 *vcpu)
> >>>>                   vcpu->stat.hypercall_exits++;
> >>>>                   kvm_handle_service(vcpu);
> >>>>                   break;
> >>>> +       case KVM_HCALL_USER_SERVICE:
> >>>> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER=
_HCALL)) {
> >>>> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HC=
ALL_INVALID_CODE);
> >>>> +                       break;
> >>>> +               }
> >>>> +
> >>>> +               vcpu->run->exit_reason =3D KVM_EXIT_HYPERCALL;
> >>>> +               vcpu->run->hypercall.nr =3D KVM_HCALL_USER_SERVICE;
> >>>> +               vcpu->run->hypercall.args[0] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A0);
> >>>> +               vcpu->run->hypercall.args[1] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A1);
> >>>> +               vcpu->run->hypercall.args[2] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A2);
> >>>> +               vcpu->run->hypercall.args[3] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A3);
> >>>> +               vcpu->run->hypercall.args[4] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A4);
> >>>> +               vcpu->run->hypercall.args[5] =3D kvm_read_reg(vcpu, =
LOONGARCH_GPR_A5);
> >>>> +               vcpu->run->hypercall.flags =3D 0;
> >>>> +               /*
> >>>> +                * Set invalid return value by default
> >>>> +                * Need user-mode VMM modify it
> >>>> +                */
> >>>> +               vcpu->run->hypercall.ret =3D KVM_HCALL_INVALID_CODE;
> >>>> +               ret =3D RESUME_HOST;
> >>>> +               break;
> >>>>           case KVM_HCALL_SWDBG:
> >>>>                   /* KVM_HCALL_SWDBG only in effective when SW_BP is=
 enabled */
> >>>>                   if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index d18a4a270415..8c46ad1872ee 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *v=
cpu)
> >>>>           if (run->exit_reason =3D=3D KVM_EXIT_LOONGARCH_IOCSR) {
> >>>>                   if (!run->iocsr_io.is_write)
> >>>>                           kvm_complete_iocsr_read(vcpu, run);
> >>>> +       } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> >>>> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall=
.ret);
> >>>> +               update_pc(&vcpu->arch);
> >>>>           }
> >>>>
> >>>>           if (!vcpu->wants_to_run)
> >>>>
> >>>> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
> >>
>

