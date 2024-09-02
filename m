Return-Path: <kvm+bounces-25648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6A3967E5B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 06:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36A171C218F6
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 04:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3EB14AD20;
	Mon,  2 Sep 2024 04:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERDXbGa2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAFA3BBD8;
	Mon,  2 Sep 2024 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725249911; cv=none; b=UMxs1CECFytczCaBPqxXbTdUiLOtNzjkUJFhutBYmpMwKjpYjdBVyiV/4VHGRXO3EojpyElf2bjOFxSG7BlSFUw+lQfI6c6/Y8qEoQqehKn108CcCdWmusqGvhSfEMx7vG35JeUreuuAc6LcFRkL/mWsalQw15igeWK86xK794c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725249911; c=relaxed/simple;
	bh=TDmM6WNmDBtpDvKtVrOVPvLKn39Sv0jF9rd6+2w+b5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7fS25xzztBbzXtMW+RUol83DgF2wBjYhIwL7A96ADvlVyxMZZF1c24oOOVDXLaUO01j0vqRwcVaKvrz58DehJQDVDpLXAku1bJE0ri8Bjsr58yvJUEb88hnmOxWQGfY72oNcSA2+MkEa/4Z7PgHvVF0zpI674x7DzNPshE7Ma4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERDXbGa2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB26C4CEC2;
	Mon,  2 Sep 2024 04:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725249911;
	bh=TDmM6WNmDBtpDvKtVrOVPvLKn39Sv0jF9rd6+2w+b5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ERDXbGa2t/+hCVW1EQ3o72zi0D6UnQfJH3CH+Jl6QB7yTcVGgE0UJfv+X7WfuG9pS
	 mxX9woC6VONMQLQdVligJ/YtbeIaFQueS6bq5r6xssTEaknfc4zczin6rEEHaGpogj
	 FbJ9gM3Gz8+9AI9fLquLoHgi/dTXikfbm66Ofa/RQNZB5BDWdBP1eeXvNaClGgfJEV
	 Jw/mqpXJYdSbPV7VcD0HkBeQQvs6qp0K/sKvpZXFiwED+ru+ulhsnJ2PBYEgKjbreU
	 y3i90SqK95r5ww8TRBQm4X9RLkaAT15A1b5psssIMCWBq1Tn5rvxTehYsRvUbPBJAA
	 8BwB8vf0AG8zg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a86b64ebd8aso230043766b.1;
        Sun, 01 Sep 2024 21:05:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmSVBTnGNP1z66JC30kQMtJP4uitiONZWfIqG3bTgCudlBVbpPOER6jMUEC79E/K/UkItm5GwsaffRSWF5@vger.kernel.org, AJvYcCX4iqNPdKjY4Ot1EjzmHFwpG6K2DrQMdPfAhm9qHnFdp8OCv/ENPhzyuZkd9+D1IG2K+kA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK7kIvNQGiVIom+y9ngRopbtP4wCeh1329Ov4exxFidoTMEDvj
	aPj+HW1YIR2b0yfAdmhKnq/jPR4QCFOlgyc7tIRPTsPp787/WU/PDkCu+GQPzMSk8v2+10BhtpM
	8z6l36vW5WGwR9ii4xUwLjN9DuqY=
X-Google-Smtp-Source: AGHT+IERQL7oHGyQdHW0wSVBvO8S9n8cLsjN5Ak1PIyaVrxS4RDKNqMwAABecy5IXqZdzwsx6C/94NOfAjICX8I45zg=
X-Received: by 2002:a50:cc0b:0:b0:5c0:8eb1:2800 with SMTP id
 4fb4d7f45d1cf-5c21ed3f549mr10998764a12.11.1725249909929; Sun, 01 Sep 2024
 21:05:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730075744.1215856-1-maobibo@loongson.cn> <20240730075744.1215856-4-maobibo@loongson.cn>
 <CAAhV-H7D80huYzF6ewZqcgx8MTzWZNFXJHOahoJ33zJYX1kyAw@mail.gmail.com>
 <13276416-c62b-b33d-1824-7764122ef863@loongson.cn> <CAAhV-H4RhhYB0LHeOs+Cjr6LZj6np_S4-neEtYnLUU_K=upV_w@mail.gmail.com>
 <1daacc02-2bdc-928b-6291-7604c841d219@loongson.cn>
In-Reply-To: <1daacc02-2bdc-928b-6291-7604c841d219@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 2 Sep 2024 12:04:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5mwdCp9pX53Pu2GKA48+9k0HMAR0cEBB3BPTBjySPwKA@mail.gmail.com>
Message-ID: <CAAhV-H5mwdCp9pX53Pu2GKA48+9k0HMAR0cEBB3BPTBjySPwKA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] LoongArch: KVM: Add vm migration support for LBT registers
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 10:45=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/9/2 =E4=B8=8A=E5=8D=8810:20, Huacai Chen wrote:
> > On Mon, Sep 2, 2024 at 9:56=E2=80=AFAM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >> Hi Huacai,
> >>
> >> On 2024/8/31 =E4=B8=8B=E5=8D=8810:49, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Tue, Jul 30, 2024 at 3:57=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Every vcpu has separate LBT registers. And there are four scr regist=
ers,
> >>>> one flags and ftop register for LBT extension. When VM migrates, VMM
> >>>> needs to get LBT registers for every vcpu.
> >>>>
> >>>> Here macro KVM_REG_LOONGARCH_LBT is added for new vcpu lbt register =
type,
> >>>> the following macro is added to get/put LBT registers.
> >>>>     KVM_REG_LOONGARCH_LBT_SCR0
> >>>>     KVM_REG_LOONGARCH_LBT_SCR1
> >>>>     KVM_REG_LOONGARCH_LBT_SCR2
> >>>>     KVM_REG_LOONGARCH_LBT_SCR3
> >>>>     KVM_REG_LOONGARCH_LBT_EFLAGS
> >>>>     KVM_REG_LOONGARCH_LBT_FTOP
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/uapi/asm/kvm.h |  9 +++++
> >>>>    arch/loongarch/kvm/vcpu.c             | 56 ++++++++++++++++++++++=
+++++
> >>>>    2 files changed, 65 insertions(+)
> >>>>
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/=
include/uapi/asm/kvm.h
> >>>> index 49bafac8b22d..003fb766c93f 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>> @@ -64,6 +64,7 @@ struct kvm_fpu {
> >>>>    #define KVM_REG_LOONGARCH_KVM          (KVM_REG_LOONGARCH | 0x200=
00ULL)
> >>>>    #define KVM_REG_LOONGARCH_FPSIMD       (KVM_REG_LOONGARCH | 0x300=
00ULL)
> >>>>    #define KVM_REG_LOONGARCH_CPUCFG       (KVM_REG_LOONGARCH | 0x400=
00ULL)
> >>>> +#define KVM_REG_LOONGARCH_LBT          (KVM_REG_LOONGARCH | 0x50000=
ULL)
> >>>>    #define KVM_REG_LOONGARCH_MASK         (KVM_REG_LOONGARCH | 0x700=
00ULL)
> >>> I think KVM_REG_LOONGARCH_MASK should contain all above register
> >>> classes, so should it be  (KVM_REG_LOONGARCH | 0x370000ULL)?
> >> Sorry, maybe I miss something. What is the meaning of 0x370000ULL? How
> >> does the value come from?
> > It seems I misunderstood the mask, please ignore.
> >
> >>
> >>>
> >>>>    #define KVM_CSR_IDX_MASK               0x7fff
> >>>>    #define KVM_CPUCFG_IDX_MASK            0x7fff
> >>>> @@ -77,6 +78,14 @@ struct kvm_fpu {
> >>>>    /* Debugging: Special instruction for software breakpoint */
> >>>>    #define KVM_REG_LOONGARCH_DEBUG_INST   (KVM_REG_LOONGARCH_KVM | K=
VM_REG_SIZE_U64 | 3)
> >>>>
> >>>> +/* LBT registers */
> >>>> +#define KVM_REG_LOONGARCH_LBT_SCR0     (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 1)
> >>>> +#define KVM_REG_LOONGARCH_LBT_SCR1     (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 2)
> >>>> +#define KVM_REG_LOONGARCH_LBT_SCR2     (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 3)
> >>>> +#define KVM_REG_LOONGARCH_LBT_SCR3     (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 4)
> >>>> +#define KVM_REG_LOONGARCH_LBT_EFLAGS   (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 5)
> >>>> +#define KVM_REG_LOONGARCH_LBT_FTOP     (KVM_REG_LOONGARCH_LBT | KVM=
_REG_SIZE_U64 | 6)
> >>> FTOP is a 32bit register in other place of the kernel, is it correct
> >>> to use U64 here?
> >> It is deliberate and there is no 32bit compat requirement for kvm. ALL
> >> regiester interfaces are defined as 64-bit.
> >> On kernel and qemu side, ftop can be defined as 32bit still, however t=
he
> >> interface is 64-bit. So there is forced type conversion between u32 an=
d
> >> u64. There is no problem here.
> > If you are sure, then no problem. But there is indeed KVM_REG_SIZE_U32
> > in include/uapi/linux/kvm.h, and if we append more fields after ftop,
> > define it as U64 may break memcpy().
> yes, there is KVM_REG_SIZE_U32 definition, however LoongArch KVM does
> not use it, else the safer checking is a little complicated. Now
> parameter with KVM_REG_SIZE_U32 is simply treated as illegal.
I think just add a "case KVM_REG_SIZE_U32" in kvm_set_reg/kvm_get_reg
is OK, kvm_set_one_reg/kvm_get_one_reg don't need any modifications.
No?

Huacai
>
> And no memcpy() is used for ftop/cpucfg, there is assignment for every
> single register like this:
>
> For cpucfg read/write:
>    vcpu->arch.cpucfg[id] =3D (u32)v;
>    *v =3D vcpu->arch.cpucfg[id];
> For ftop read/write:
>    vcpu->arch.fpu.ftop =3D v;
>    *v =3D vcpu->arch.fpu.ftop;
>
> Regards
> Bibo Mao
> >
> >>
> >>>
> >>>> +
> >>>>    #define LOONGARCH_REG_SHIFT            3
> >>>>    #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 |=
 (REG << LOONGARCH_REG_SHIFT))
> >>>>    #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_L=
OONGARCH_CSR, REG)
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index b5324885a81a..b2500d4fa729 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -597,6 +597,34 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcp=
u,
> >>>>                           break;
> >>>>                   }
> >>>>                   break;
> >>>> +       case KVM_REG_LOONGARCH_LBT:
> >>> What about adding FPU/LSX/LASX registers (if needed for migration) in
> >>> kvm_{get, set}_one_reg() here?
> >> If there is 512bit SIMD or other requirement, it will be added in
> >> kvm_{get, set}_one_reg(). For FPU/LSX/LASX registers, there is common
> >> API KVM_GET_FPU/KVM_SET_FPU here. The impmentation of QEMU only gets
> >> FPU, the upper LSX/LASX is lost, we will submit a patch in qemu side,
> >> the kvm kernel side is ok.
> > OK, no problem.
> >
> > Huacai
> >>
> >> /*
> >>    * for KVM_GET_FPU and KVM_SET_FPU
> >>    */
> >> struct kvm_fpu {
> >>           __u32 fcsr;
> >>           __u64 fcc;    /* 8x8 */
> >>           struct kvm_fpureg {
> >>                   __u64 val64[4];
> >>           } fpr[32];
> >> };
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>> +               if (!kvm_guest_has_lbt(&vcpu->arch))
> >>>> +                       return -ENXIO;
> >>>> +
> >>>> +               switch (reg->id) {
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR0:
> >>>> +                       *v =3D vcpu->arch.lbt.scr0;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR1:
> >>>> +                       *v =3D vcpu->arch.lbt.scr1;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR2:
> >>>> +                       *v =3D vcpu->arch.lbt.scr2;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR3:
> >>>> +                       *v =3D vcpu->arch.lbt.scr3;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
> >>>> +                       *v =3D vcpu->arch.lbt.eflags;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_FTOP:
> >>>> +                       *v =3D vcpu->arch.fpu.ftop;
> >>>> +                       break;
> >>>> +               default:
> >>>> +                       ret =3D -EINVAL;
> >>>> +                       break;
> >>>> +               }
> >>>> +               break;
> >>>>           default:
> >>>>                   ret =3D -EINVAL;
> >>>>                   break;
> >>>> @@ -663,6 +691,34 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcp=
u,
> >>>>                           break;
> >>>>                   }
> >>>>                   break;
> >>>> +       case KVM_REG_LOONGARCH_LBT:
> >>>> +               if (!kvm_guest_has_lbt(&vcpu->arch))
> >>>> +                       return -ENXIO;
> >>>> +
> >>>> +               switch (reg->id) {
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR0:
> >>>> +                       vcpu->arch.lbt.scr0 =3D v;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR1:
> >>>> +                       vcpu->arch.lbt.scr1 =3D v;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR2:
> >>>> +                       vcpu->arch.lbt.scr2 =3D v;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_SCR3:
> >>>> +                       vcpu->arch.lbt.scr3 =3D v;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
> >>>> +                       vcpu->arch.lbt.eflags =3D v;
> >>>> +                       break;
> >>>> +               case KVM_REG_LOONGARCH_LBT_FTOP:
> >>>> +                       vcpu->arch.fpu.ftop =3D v;
> >>>> +                       break;
> >>>> +               default:
> >>>> +                       ret =3D -EINVAL;
> >>>> +                       break;
> >>>> +               }
> >>>> +               break;
> >>>>           default:
> >>>>                   ret =3D -EINVAL;
> >>>>                   break;
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
> >>
>
>

