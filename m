Return-Path: <kvm+bounces-34337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB6B9FABD6
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 10:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38EBB188568D
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1373719259D;
	Mon, 23 Dec 2024 09:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJKI4Ygr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327F11917ED;
	Mon, 23 Dec 2024 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734944716; cv=none; b=Jf3i+5XSHgE9dcUOFBfU0ibCvTMaSAxGptPkcyoyf/F7xdPXLlORw3r29Tckt6h6ausd6tEvg1MpLpoRf3Yvnbs43AOiZ8qc7vf/fVgxyYg3Xh3szzE/lnXz2Wm9rSMIrDmQ7dN1ptRLQd8STfUmr/H6+eC+I5CgXWBBGyULpkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734944716; c=relaxed/simple;
	bh=ma3lYyKuMua4Kurr88Xi8bzk0eJdAu34sG5lQUOf0e0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGwntZbCzLPXb1S7bVSR0X7W/NASsOeiQjYKxC9EeeSLmi7ArNPTrC618MEZijERayEPD/HgoHxHehLu9NlhtH+5XwmFW14RGcIVyiavwvUoUiysr3B/AUXVnilH4FNhTis9vIIRzGvitpWrrE2/oOOPe0FP8WNi8PCMWwRJdxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJKI4Ygr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3ACC4CED3;
	Mon, 23 Dec 2024 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734944715;
	bh=ma3lYyKuMua4Kurr88Xi8bzk0eJdAu34sG5lQUOf0e0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aJKI4YgrBcGUyvoiYb94eEaVxazV72ci3OCr3xEQYbAlIUznmwkTtSlEUJYkZKYLg
	 qIzf8w3ggZZWBXlWa1WJ0cG4w2G1o4MMuPJwztTUzyuckOh1ukxXX8OdAyTABv3FTl
	 mAd8miuI6REXCAnDQ/5vbsJkRnyWKrcqYozCstNE+QNV27py8w575atPWcxttEhHQr
	 4DnjOA9BJ1+IY/EeljW0oExKynSUvj4Jdw3Z8V09sbn4Q109jEIogXhyI4ghlRJrua
	 VUyh7VxejkHNX24qPJHzTMxExzb522h9LfGSB8qIAaXMytducjWm2Ui6h93/2w7jCd
	 balUJbfHQ4ZBw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaec61d0f65so233740766b.1;
        Mon, 23 Dec 2024 01:05:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVsz2i1BZUUEEbJANG+k/2n/QTXzKNMalvcasdG0/9pD9R4014JC4pGuHqM8fxnM+ytUi0=@vger.kernel.org, AJvYcCXZRPHJu879dS+5Do6/+7uSu2UmPC8XaQVrV8LosQn2YTjBl1zrqm2ylcK3epYqiuXCFDib5o7OiN1wW0jO@vger.kernel.org
X-Gm-Message-State: AOJu0YxRMmJeQrHDjr1HgXAyyMobYvBJ6bTOTzEFRDTCEFIH9VC7BQjD
	INwCeFZasxVNoOwtPfhTGwnNidH6Xa6KujrdxZTrz7LNTMKFmrjpwQllExuQgGPYkGVavGDOmLX
	ruuMSGZ2Qg8lvG/su6iNB5YSuVoc=
X-Google-Smtp-Source: AGHT+IHAP0Er4Nn/izdHZf2U+ZAiB+I0kZ0fPyw8Ttvm1TjC47P6Nhrmi2FSU9VJHqw1k/DTQzSMwiLNXncBoIG4U1c=
X-Received: by 2002:a17:907:1c10:b0:aab:eefd:4ceb with SMTP id
 a640c23a62f3a-aac27025de5mr1096728966b.10.1734944714269; Mon, 23 Dec 2024
 01:05:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241223084212.34822-1-maobibo@loongson.cn> <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
 <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn>
In-Reply-To: <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 23 Dec 2024 17:05:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H42D4Rybzkc9YVsjo+GEQwiq4LTdjtmWyOzaqmuW6x8CQ@mail.gmail.com>
Message-ID: <CAAhV-H42D4Rybzkc9YVsjo+GEQwiq4LTdjtmWyOzaqmuW6x8CQ@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: bibo mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also tried to port an untested version, but I think your version is
a tested one.
https://github.com/chenhuacai/linux/commit/e6596b0e45c80756794aba74ac086c5c=
0e0306eb

And I have some questions:
1, "user service" is not only for syscall, so you rename it?
2, Why 4.19 doesn't need something like "vcpu->run->hypercall.args[0]
=3D kvm_read_reg(vcpu, LOONGARCH_GPR_A0);"
3, I think my version about "vcpu->run->exit_reason =3D
KVM_EXIT_HYPERCALL;" and "update_pc()" is a little better than yours,
so you can improve them.

Huacai

On Mon, Dec 23, 2024 at 4:54=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/12/23 =E4=B8=8B=E5=8D=884:50, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > Is this patch trying to do the same thing as "LoongArch: add hypcall
> > to emulate syscall in kvm" in 4.19?
> yes, it is to do so -:)
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Mon, Dec 23, 2024 at 4:42=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Some VMMs provides special hypercall service in usermode, KVM need
> >> not handle the usermode hypercall service and pass it to VMM and
> >> let VMM handle it.
> >>
> >> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
> >> service, KVM loads all six registers to VMM.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h      |  1 +
> >>   arch/loongarch/include/asm/kvm_para.h      |  2 ++
> >>   arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
> >>   arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++++++++=
++
> >>   arch/loongarch/kvm/vcpu.c                  |  3 +++
> >>   5 files changed, 29 insertions(+)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index 7b8367c39da8..590982cd986e 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -162,6 +162,7 @@ enum emulation_result {
> >>   #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
> >>   #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |      =
   \
> >>                                           BIT(KVM_FEATURE_STEAL_TIME) =
|  \
> >> +                                        BIT(KVM_FEATURE_USER_HCALL) |=
  \
> >>                                           BIT(KVM_FEATURE_VIRT_EXTIOI)=
)
> >>
> >>   struct kvm_vcpu_arch {
> >> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/in=
clude/asm/kvm_para.h
> >> index c4e84227280d..d3c00de484f6 100644
> >> --- a/arch/loongarch/include/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/asm/kvm_para.h
> >> @@ -13,12 +13,14 @@
> >>
> >>   #define KVM_HCALL_CODE_SERVICE         0
> >>   #define KVM_HCALL_CODE_SWDBG           1
> >> +#define KVM_HCALL_CODE_USER            2
> >>
> >>   #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_K=
VM, KVM_HCALL_CODE_SERVICE)
> >>   #define  KVM_HCALL_FUNC_IPI            1
> >>   #define  KVM_HCALL_FUNC_NOTIFY         2
> >>
> >>   #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPE=
RVISOR_KVM, KVM_HCALL_CODE_SWDBG)
> >> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISOR_KV=
M, KVM_HCALL_CODE_USER)
> >>
> >>   /*
> >>    * LoongArch hypercall return code
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongar=
ch/include/uapi/asm/kvm_para.h
> >> index b0604aa9b4bb..76d802ef01ce 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
> >> @@ -17,5 +17,6 @@
> >>   #define  KVM_FEATURE_STEAL_TIME                2
> >>   /* BIT 24 - 31 are features configurable by user space vmm */
> >>   #define  KVM_FEATURE_VIRT_EXTIOI       24
> >> +#define  KVM_FEATURE_USER_HCALL                25
> >>
> >>   #endif /* _UAPI_ASM_KVM_PARA_H */
> >> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >> index a7893bd01e73..1a85cd4fb6a5 100644
> >> --- a/arch/loongarch/kvm/exit.c
> >> +++ b/arch/loongarch/kvm/exit.c
> >> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu *=
vcpu)
> >>                  vcpu->stat.hypercall_exits++;
> >>                  kvm_handle_service(vcpu);
> >>                  break;
> >> +       case KVM_HCALL_USER_SERVICE:
> >> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_H=
CALL)) {
> >> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCAL=
L_INVALID_CODE);
> >> +                       break;
> >> +               }
> >> +
> >> +               vcpu->run->exit_reason =3D KVM_EXIT_HYPERCALL;
> >> +               vcpu->run->hypercall.nr =3D KVM_HCALL_USER_SERVICE;
> >> +               vcpu->run->hypercall.args[0] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A0);
> >> +               vcpu->run->hypercall.args[1] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A1);
> >> +               vcpu->run->hypercall.args[2] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A2);
> >> +               vcpu->run->hypercall.args[3] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A3);
> >> +               vcpu->run->hypercall.args[4] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A4);
> >> +               vcpu->run->hypercall.args[5] =3D kvm_read_reg(vcpu, LO=
ONGARCH_GPR_A5);
> >> +               vcpu->run->hypercall.flags =3D 0;
> >> +               /*
> >> +                * Set invalid return value by default
> >> +                * Need user-mode VMM modify it
> >> +                */
> >> +               vcpu->run->hypercall.ret =3D KVM_HCALL_INVALID_CODE;
> >> +               ret =3D RESUME_HOST;
> >> +               break;
> >>          case KVM_HCALL_SWDBG:
> >>                  /* KVM_HCALL_SWDBG only in effective when SW_BP is en=
abled */
> >>                  if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index d18a4a270415..8c46ad1872ee 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u)
> >>          if (run->exit_reason =3D=3D KVM_EXIT_LOONGARCH_IOCSR) {
> >>                  if (!run->iocsr_io.is_write)
> >>                          kvm_complete_iocsr_read(vcpu, run);
> >> +       } else if (run->exit_reason =3D=3D KVM_EXIT_HYPERCALL) {
> >> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.r=
et);
> >> +               update_pc(&vcpu->arch);
> >>          }
> >>
> >>          if (!vcpu->wants_to_run)
> >>
> >> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
> >> --
> >> 2.39.3
> >>
>
>

