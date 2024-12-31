Return-Path: <kvm+bounces-34422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2002E9FEE63
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 10:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C83161BFD
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 09:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF82192D83;
	Tue, 31 Dec 2024 09:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SE2ic69m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87846189903;
	Tue, 31 Dec 2024 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735637842; cv=none; b=DNNSD26IEJ5TiH6gyhENcAJC0oosonPCmwSPuFzurvXccU9XgPVbLFudvB8kNCDMFC2zKVKuItveeRwtAfjhFCoOunHQwcPGqwZCfxlWbIhwklaC+XzmcH49DWEwX3X2DzwERidHGC7hD5h6xy9MSLg6xVIvun39Sv5oD1dZlsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735637842; c=relaxed/simple;
	bh=a1SyA27xhAQfSi/dI5hJ0oGNNPE6XukEm3NoyuqEsSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VL9xaVw+cWCCOwlJYueOsF9yIEUi7DtoYZqRK8P3B1qanAayCX/wsBLgtOz/27gBjOA2VZRDXCajdxfs5V5d34ll1bgOvQtiIy9EdJ8cBuMQuotndk3Zy/ZreILe74ysEO+O2ZTDoeozc0RDZVHbsspQrEzIbHmAIIDfrEg3a00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SE2ic69m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22355C4CEDC;
	Tue, 31 Dec 2024 09:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735637842;
	bh=a1SyA27xhAQfSi/dI5hJ0oGNNPE6XukEm3NoyuqEsSg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SE2ic69mgxL2OwJHtL0A7zld3KNy4u/zpq4B7dZyt1+crOrUAdvbon7psdAqbIlSs
	 pMQJ3ngQdAOsfQwcbLGEiYS+VBETPiR3K0bcfbR6p/hBv5mmpXKz0/BMUCODe9EgMm
	 4kf/Y4tWf327GzqAwiXzNqZP41edeIeR1K+kZzzC2QYMG2p4mExxl3UC1RbFAbPxqx
	 4+6640TkideE1DsGaOleaaBDZBtY2JXg4JvB3PchemvH3mnTMExlyYouy+rilxCQh2
	 vj+jfINHKFoiDLFTMUGzkP5JiKhzTiTLHBweODYrWX382TbAhK6Vyqqg8EgVS0gso9
	 1xwJcBQgHmPqw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa67ac42819so1383484666b.0;
        Tue, 31 Dec 2024 01:37:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUkdcCMWYxwnaIY7w5YLOYGZzkoCSSdEnK3xOrQ9nZYs00geidKkXUPLdEoM/v73NhKzH0=@vger.kernel.org, AJvYcCWy/okqUWO6ZbZHS4MwLmrBxbUtVQ10GC6XU0XR6LzZBroFjGlGdUcjea8lj+2IyWNfzvP8t/3El4vo4qEW@vger.kernel.org
X-Gm-Message-State: AOJu0YzDtK8xhQNxCHc92B/e+coWdY21Sr1k9JZw28L44oaIkph3/qwU
	oVB75ACb0hd+yiM6wpMm/b4Tej4IaCLSuLkrTcFrlC7763gkvTphx9KRXPO7eeyTYZbQjHQ0oyF
	cpBX8h6HCD/GssLb9T3HUnzqSNX0=
X-Google-Smtp-Source: AGHT+IF9tMIl5QLw+RSv4dBYExrDOeGNOB8hUTyHSsLBhqDmVHrKvqwGQlEF7aMH0AuqhessL0+vWvXfJIQ73hdDdB0=
X-Received: by 2002:a17:907:3f10:b0:aa6:9624:78f7 with SMTP id
 a640c23a62f3a-aac2ada1f5fmr3101487466b.17.1735637840552; Tue, 31 Dec 2024
 01:37:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223084212.34822-1-maobibo@loongson.cn> <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
 <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn> <CAAhV-H42D4Rybzkc9YVsjo+GEQwiq4LTdjtmWyOzaqmuW6x8CQ@mail.gmail.com>
 <521ca7c6-64a2-53fa-5cff-b366ae73f600@loongson.cn> <CAAhV-H5TVwX2T=ccT4o0btJEbL+gwBESBD6Y_Z2BEqNuhom3iw@mail.gmail.com>
 <8814cf39-0842-ec48-c578-e5e6eeda2295@loongson.cn>
In-Reply-To: <8814cf39-0842-ec48-c578-e5e6eeda2295@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 31 Dec 2024 17:37:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5UufM7RdsoOxqdzGt=KrRyLM_FV7vwL3u4BC0ugwt+TA@mail.gmail.com>
Message-ID: <CAAhV-H5UufM7RdsoOxqdzGt=KrRyLM_FV7vwL3u4BC0ugwt+TA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: bibo mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 31, 2024 at 5:27=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/12/31 =E4=B8=8B=E5=8D=884:41, Huacai Chen wrote:
> > On Mon, Dec 30, 2024 at 10:13=E2=80=AFAM bibo mao <maobibo@loongson.cn>=
 wrote:
> >>
> >> Hi Huacai,
> >>
> >> On 2024/12/23 =E4=B8=8B=E5=8D=885:05, Huacai Chen wrote:
> >>> I also tried to port an untested version, but I think your version is
> >>> a tested one.
> >>> https://github.com/chenhuacai/linux/commit/e6596b0e45c80756794aba74ac=
086c5c0e0306eb
> >>>
> >>> And I have some questions:
> >>> 1, "user service" is not only for syscall, so you rename it?
> >>> 2, Why 4.19 doesn't need something like "vcpu->run->hypercall.args[0]
> >>> =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A0);"
> >>> 3, I think my version about "vcpu->run->exit_reason =3D
> >>> KVM_EXIT_HYPERCALL;" and "update_pc()" is a little better than yours,
> >>> so you can improve them.
> >> After a second thought, update_pc() before return to user may be not
> >> strictly right, since user VMM can dump registers including pc which i=
s
> >> advanced already.
> > Agree, and we can see how others do.
> >
> >>
> >> How about adding function kvm_complete_hypercall() like
> >> kvm_complete_mmio_read(), such as:
> >   kvm_complete_user_service() maybe better? Since the "classic
> > hypercall" doesn't come here.
> sure, will do rename it with kvm_complete_user_service.
>
> >
> > And we may also need to set vcpu->run->exit_reason for all cases,
> > which is done in my version.
> By my understanding, exit_reason need be set only for RESUME_HOST.
> it is unnecessary for RESUME_GUEST.
Unset means KVM_EXIT_UNKNOWN. Though we only check exit_reason for
RESUME_HOST now, let a classic hypercall with KVM_EXIT_UNKNOWN may be
error-prone.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> +int kvm_complete_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run=
)
> >> +{
> >> +       update_pc(&vcpu->arch);
> >> +       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
> >> +}
> >> +
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -1736,8 +1736,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u)
> >>                   if (!run->iocsr_io.is_write)
> >>                           kvm_complete_iocsr_read(vcpu, run);
> >>           } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> >> -               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.r=
et);
> >> -               update_pc(&vcpu->arch);
> >> +               kvm_complete_hypercall(vcpu, run);
> >> +               run->exit_reason =3D KVM_EXIT_UNKNOWN;
> >>           }
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>> On Mon, Dec 23, 2024 at 4:54=E2=80=AFPM bibo mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/12/23 =E4=B8=8B=E5=8D=884:50, Huacai Chen wrote:
> >>>>> Hi, Bibo,
> >>>>>
> >>>>> Is this patch trying to do the same thing as "LoongArch: add hypcal=
l
> >>>>> to emulate syscall in kvm" in 4.19?
> >>>> yes, it is to do so -:)
> >>>>
> >>>> Regards
> >>>> Bibo Mao
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>> On Mon, Dec 23, 2024 at 4:42=E2=80=AFPM Bibo Mao <maobibo@loongson.=
cn> wrote:
> >>>>>>
> >>>>>> Some VMMs provides special hypercall service in usermode, KVM need
> >>>>>> not handle the usermode hypercall service and pass it to VMM and
> >>>>>> let VMM handle it.
> >>>>>>
> >>>>>> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
> >>>>>> service, KVM loads all six registers to VMM.
> >>>>>>
> >>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>> ---
> >>>>>>     arch/loongarch/include/asm/kvm_host.h      |  1 +
> >>>>>>     arch/loongarch/include/asm/kvm_para.h      |  2 ++
> >>>>>>     arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
> >>>>>>     arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++=
++++++++
> >>>>>>     arch/loongarch/kvm/vcpu.c                  |  3 +++
> >>>>>>     5 files changed, 29 insertions(+)
> >>>>>>
> >>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarc=
h/include/asm/kvm_host.h
> >>>>>> index 7b8367c39da8..590982cd986e 100644
> >>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>>>> @@ -162,6 +162,7 @@ enum emulation_result {
> >>>>>>     #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
> >>>>>>     #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |=
         \
> >>>>>>                                             BIT(KVM_FEATURE_STEAL_=
TIME) |  \
> >>>>>> +                                        BIT(KVM_FEATURE_USER_HCAL=
L) |  \
> >>>>>>                                             BIT(KVM_FEATURE_VIRT_E=
XTIOI))
> >>>>>>
> >>>>>>     struct kvm_vcpu_arch {
> >>>>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarc=
h/include/asm/kvm_para.h
> >>>>>> index c4e84227280d..d3c00de484f6 100644
> >>>>>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>>>>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>>>>> @@ -13,12 +13,14 @@
> >>>>>>
> >>>>>>     #define KVM_HCALL_CODE_SERVICE         0
> >>>>>>     #define KVM_HCALL_CODE_SWDBG           1
> >>>>>> +#define KVM_HCALL_CODE_USER            2
> >>>>>>
> >>>>>>     #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERV=
ISOR_KVM, KVM_HCALL_CODE_SERVICE)
> >>>>>>     #define  KVM_HCALL_FUNC_IPI            1
> >>>>>>     #define  KVM_HCALL_FUNC_NOTIFY         2
> >>>>>>
> >>>>>>     #define KVM_HCALL_SWDBG                        HYPERCALL_ENCOD=
E(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
> >>>>>> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISO=
R_KVM, KVM_HCALL_CODE_USER)
> >>>>>>
> >>>>>>     /*
> >>>>>>      * LoongArch hypercall return code
> >>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loo=
ngarch/include/uapi/asm/kvm_para.h
> >>>>>> index b0604aa9b4bb..76d802ef01ce 100644
> >>>>>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> >>>>>> @@ -17,5 +17,6 @@
> >>>>>>     #define  KVM_FEATURE_STEAL_TIME                2
> >>>>>>     /* BIT 24 - 31 are features configurable by user space vmm */
> >>>>>>     #define  KVM_FEATURE_VIRT_EXTIOI       24
> >>>>>> +#define  KVM_FEATURE_USER_HCALL                25
> >>>>>>
> >>>>>>     #endif /* _UAPI_ASM_KVM_PARA_H */
> >>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >>>>>> index a7893bd01e73..1a85cd4fb6a5 100644
> >>>>>> --- a/arch/loongarch/kvm/exit.c
> >>>>>> +++ b/arch/loongarch/kvm/exit.c
> >>>>>> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vc=
pu *vcpu)
> >>>>>>                    vcpu->stat.hypercall_exits++;
> >>>>>>                    kvm_handle_service(vcpu);
> >>>>>>                    break;
> >>>>>> +       case KVM_HCALL_USER_SERVICE:
> >>>>>> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_US=
ER_HCALL)) {
> >>>>>> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_=
HCALL_INVALID_CODE);
> >>>>>> +                       break;
> >>>>>> +               }
> >>>>>> +
> >>>>>> +               vcpu->run->exit_reason =3D KVM_EXIT_HYPERCALL;
> >>>>>> +               vcpu->run->hypercall.nr =3D KVM_HCALL_USER_SERVICE=
;
> >>>>>> +               vcpu->run->hypercall.args[0] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A0);
> >>>>>> +               vcpu->run->hypercall.args[1] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A1);
> >>>>>> +               vcpu->run->hypercall.args[2] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A2);
> >>>>>> +               vcpu->run->hypercall.args[3] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A3);
> >>>>>> +               vcpu->run->hypercall.args[4] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A4);
> >>>>>> +               vcpu->run->hypercall.args[5] =3D kvm_read_reg(vcpu=
, LOONGARCH_GPR_A5);
> >>>>>> +               vcpu->run->hypercall.flags =3D 0;
> >>>>>> +               /*
> >>>>>> +                * Set invalid return value by default
> >>>>>> +                * Need user-mode VMM modify it
> >>>>>> +                */
> >>>>>> +               vcpu->run->hypercall.ret =3D KVM_HCALL_INVALID_COD=
E;
> >>>>>> +               ret =3D RESUME_HOST;
> >>>>>> +               break;
> >>>>>>            case KVM_HCALL_SWDBG:
> >>>>>>                    /* KVM_HCALL_SWDBG only in effective when SW_BP=
 is enabled */
> >>>>>>                    if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK=
) {
> >>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>>>> index d18a4a270415..8c46ad1872ee 100644
> >>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu =
*vcpu)
> >>>>>>            if (run->exit_reason =3D=3D KVM_EXIT_LOONGARCH_IOCSR) {
> >>>>>>                    if (!run->iocsr_io.is_write)
> >>>>>>                            kvm_complete_iocsr_read(vcpu, run);
> >>>>>> +       } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> >>>>>> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hyperca=
ll.ret);
> >>>>>> +               update_pc(&vcpu->arch);
> >>>>>>            }
> >>>>>>
> >>>>>>            if (!vcpu->wants_to_run)
> >>>>>>
> >>>>>> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
> >>>>>> --
> >>>>>> 2.39.3
> >>>>>>
> >>>>
> >>>>
> >>
>
>

