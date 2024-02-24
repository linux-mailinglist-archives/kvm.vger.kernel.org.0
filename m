Return-Path: <kvm+bounces-9595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 232988623C8
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 10:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85357B230C4
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 09:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A251BDD9;
	Sat, 24 Feb 2024 09:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmvDPRtg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744021B7EF;
	Sat, 24 Feb 2024 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708765994; cv=none; b=scCaDCqBJwdZHJC1fRVmJ+8qRsH+xjew/Pwkbx6QRvGAqBAdnRY8EQChOJEJqvjL0qHM1cBzJqd6ipLQ9sTX1/EofpG6VnR3JcOGn48kJ472sAtO6rMhtihQBW7QO3qJvOe6o05Qn7mHrcgQ0Ux9boxkUngiUyy8Dd4jsQKGoLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708765994; c=relaxed/simple;
	bh=nJXUT7CztplBm99TFZtv+2XklFZbKoBca8C+PsU2/r0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUUTN2dDm5KCEeBp+4lfcgkfG87POhw0/+lJEH77jWsOl8MoslV0oNhjcQg5mDmJLGIrAYUq+XXiDAqXuI8yodH8mEFNztvPHTki4cEurKVNwbNtDUQef1bKODDJzuO2ywm/6itZD8EEQnQtKeiODtn0s2kYFBl/8swNTMCmBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmvDPRtg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AA6C433C7;
	Sat, 24 Feb 2024 09:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708765994;
	bh=nJXUT7CztplBm99TFZtv+2XklFZbKoBca8C+PsU2/r0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hmvDPRtgS+SIPMSGE6XSd5PX3MFU7PqIGJzCJHTKWKc1TZHcaNNPCI2HpPDnOZpF2
	 H8fXbJwyS9dcb25cuj+AiRVjkrGfNoh1szeUZBLKBEJJrP4dSqSPx2c3gF9kUKwKaW
	 of/BOCGa/6+ar/DwUZaziWxgGiOKiuNMLW/7iHvzKZWXlT312cQXMEOEPD4FT3pSpV
	 FAo0Hhyjb8/GJzNzOvdIJ/ljt1iUQW3H5coQMSkDjDzjSO3V49g0RZd0jF9T+cmhDM
	 zAS0ad97we92mofXPMWz3GnywxhSlpnLv1Qjl0yT4RHuZ/KjQc6cYGSl+FcdIv0joK
	 LJ/u8e9r+S51g==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a3f1bf03722so144785266b.1;
        Sat, 24 Feb 2024 01:13:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWwkL/wicseJkNsx1FHtJ5mBCbAswK0dOwx+tJELbFQz4NXGihTfQ65grCP+qlOThN4BHip8d62uyZkNbOoGZ0zkgr5F7SJEyggAueWxaveqgwhm5APMgdBDaI64retc3eN
X-Gm-Message-State: AOJu0YycdYbxeUIMV+SpkPi9Zl++QNjt7oWVPyn1LWzU0QUIozesImQR
	Df7IY9B9OkQgVQyepKNCMW6lZVRUswFZS+TEXk1+XlhWrRk65kiuaj8YPVwvBJVjDSmIiywnV0Z
	Wr4/wXgGZTBZ0fwwZ3MVhUkw21lo=
X-Google-Smtp-Source: AGHT+IGX/WbZrsokOKj9k9xFWHHWwr0v5fyMig71gN3GsFNeF6VJD2d7UKsTYvREyATp98Hhm9qM0h2D7JAp+qd4CgE=
X-Received: by 2002:a17:906:11d6:b0:a42:eaeb:2932 with SMTP id
 o22-20020a17090611d600b00a42eaeb2932mr517426eja.62.1708765992292; Sat, 24 Feb
 2024 01:13:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222032803.2177856-1-maobibo@loongson.cn> <20240222032803.2177856-4-maobibo@loongson.cn>
In-Reply-To: <20240222032803.2177856-4-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 24 Feb 2024 17:13:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
Message-ID: <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Thu, Feb 22, 2024 at 11:28=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> Instruction cpucfg can be used to get processor features. And there
> is trap exception when it is executed in VM mode, and also it is
> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
> for KVM hypervisor to privide PV features, and the area can be extended
> for other hypervisors in future. This area will never be used for
> real HW, it is only used by software.
After reading and thinking, I find that the hypercall method which is
used in our productive kernel is better than this cpucfg method.
Because hypercall is more simple and straightforward, plus we don't
worry about conflicting with the real hardware.

Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/inst.h      |  1 +
>  arch/loongarch/include/asm/loongarch.h | 10 ++++++
>  arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++---------
>  3 files changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/a=
sm/inst.h
> index d8f637f9e400..ad120f924905 100644
> --- a/arch/loongarch/include/asm/inst.h
> +++ b/arch/loongarch/include/asm/inst.h
> @@ -67,6 +67,7 @@ enum reg2_op {
>         revhd_op        =3D 0x11,
>         extwh_op        =3D 0x16,
>         extwb_op        =3D 0x17,
> +       cpucfg_op       =3D 0x1b,
>         iocsrrdb_op     =3D 0x19200,
>         iocsrrdh_op     =3D 0x19201,
>         iocsrrdw_op     =3D 0x19202,
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 46366e783c84..a1d22e8b6f94 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -158,6 +158,16 @@
>  #define  CPUCFG48_VFPU_CG              BIT(2)
>  #define  CPUCFG48_RAM_CG               BIT(3)
>
> +/*
> + * cpucfg index area: 0x40000000 -- 0x400000ff
> + * SW emulation for KVM hypervirsor
> + */
> +#define CPUCFG_KVM_BASE                        0x40000000UL
> +#define CPUCFG_KVM_SIZE                        0x100
> +#define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
> +#define  KVM_SIGNATURE                 "KVM\0"
> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> +
>  #ifndef __ASSEMBLY__
>
>  /* CSR */
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 923bbca9bd22..6a38fd59d86d 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>         return EMULATE_DONE;
>  }
>
> -static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
> +static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>  {
>         int rd, rj;
>         unsigned int index;
> +
> +       rd =3D inst.reg2_format.rd;
> +       rj =3D inst.reg2_format.rj;
> +       ++vcpu->stat.cpucfg_exits;
> +       index =3D vcpu->arch.gprs[rj];
> +
> +       /*
> +        * By LoongArch Reference Manual 2.2.10.5
> +        * Return value is 0 for undefined cpucfg index
> +        */
> +       switch (index) {
> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
> +               vcpu->arch.gprs[rd] =3D vcpu->arch.cpucfg[index];
> +               break;
> +       case CPUCFG_KVM_SIG:
> +               vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNATURE;
> +               break;
> +       default:
> +               vcpu->arch.gprs[rd] =3D 0;
> +               break;
> +       }
> +
> +       return EMULATE_DONE;
> +}
> +
> +static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
> +{
>         unsigned long curr_pc;
>         larch_inst inst;
>         enum emulation_result er =3D EMULATE_DONE;
> @@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcp=
u)
>         er =3D EMULATE_FAIL;
>         switch (((inst.word >> 24) & 0xff)) {
>         case 0x0: /* CPUCFG GSPR */
> -               if (inst.reg2_format.opcode =3D=3D 0x1B) {
> -                       rd =3D inst.reg2_format.rd;
> -                       rj =3D inst.reg2_format.rj;
> -                       ++vcpu->stat.cpucfg_exits;
> -                       index =3D vcpu->arch.gprs[rj];
> -                       er =3D EMULATE_DONE;
> -                       /*
> -                        * By LoongArch Reference Manual 2.2.10.5
> -                        * return value is 0 for undefined cpucfg index
> -                        */
> -                       if (index < KVM_MAX_CPUCFG_REGS)
> -                               vcpu->arch.gprs[rd] =3D vcpu->arch.cpucfg=
[index];
> -                       else
> -                               vcpu->arch.gprs[rd] =3D 0;
> -               }
> +               if (inst.reg2_format.opcode =3D=3D cpucfg_op)
> +                       er =3D kvm_emu_cpucfg(vcpu, inst);
>                 break;
>         case 0x4: /* CSR{RD,WR,XCHG} GSPR */
>                 er =3D kvm_handle_csr(vcpu, inst);
> --
> 2.39.3
>

