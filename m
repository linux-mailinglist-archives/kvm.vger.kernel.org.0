Return-Path: <kvm+bounces-25644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B76967DC1
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 04:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6765C1C21C22
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 02:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC582C182;
	Mon,  2 Sep 2024 02:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s35LAdWY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156D31F949;
	Mon,  2 Sep 2024 02:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725243633; cv=none; b=JF3mN3R41+eiRlMKouV+4ZtJCFIGTclNDpJ3a5gGDyn2e1AR/20gYdUbUQty5bcW1pBkH1Md3ZezZPpnUsnPqejcuf7hWGV6Qe3vUj/B0QYpINc1RBijB3+UBWUXz2pjUscMA1w2XVHMl6Ovr/+HKW+4iWMIvtS9LFZQX3oyXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725243633; c=relaxed/simple;
	bh=xRn+BfSsB6XdgAbV/5Mc0+2fUQ8JjXNosZfKtUrjQl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jj3Kt/7RpE3gR41GpAxW4jEiMJZZ1gmrIHyz8z66NTo4hvWOQbSqxxaHtZjpvDSW6y7ehIHyzqQquFaVxhLi710QP2BK2qZTNLs3S+Xi7+2PGlab1oxePbKA5yVywkrRtP2qP2e3OyZNguY9ZvHllSKcz1KFh42Y6YFBdvP9OFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s35LAdWY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BEFC4CEC9;
	Mon,  2 Sep 2024 02:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725243632;
	bh=xRn+BfSsB6XdgAbV/5Mc0+2fUQ8JjXNosZfKtUrjQl0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s35LAdWYT1pqV2N0XqnvWgasqtWIoxKPXfwCB3xKHS/fzJGep12N7FWkV0tWRgqFT
	 ZgVFHIjCcv9n9ZVc7jGDo5UpxU44ESUkKmMVQlJhpGo94KXOHLLG+KgU771iEg3VSy
	 9PYNkWYZDDec0oU9a6Wv/qba9strxbQILNnPOZqH4Exp1f/fHARIJsXrxKoEwkYJKz
	 2cEb9T2gN5IhW+cAXx/Q+o03gIIWDZDJ3qZA9HitVNHRpacZkuw2cCqI3oDEsd5GcY
	 6vfjVLKFwbGj4wsR1988lbjEjtkw6LbUF+NnZlU0XKKb4hYLhSeMKBh0Wp9N84Q1hl
	 cez2KQTaf3a6A==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c0aa376e15so1966512a12.1;
        Sun, 01 Sep 2024 19:20:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWguiyMdlul9meuLnQgic9kiG7bjvd0t2bCxUXBVj8EuIhLvPEyGm0uTshnLtj6z1LwsbI=@vger.kernel.org, AJvYcCXS7rMmCHxrKc39PfpiM1EAJJiRgV1vH1K5HcXirmzWhTTn0NUr9SBjWytAzGbcvQZI+Nno3SHZjEDk+Thz@vger.kernel.org
X-Gm-Message-State: AOJu0YzWiYuDRlHGJO7pZrtUuowQcyyKTS+oVSXAwat2q25ibCZ2OyMM
	biKfxrnDMg4C8Y3tZbELpofoH6TEWVc6asRFbXqEGmnaNs8YRxyDehN4e1myF4pCcBU6Rue0Cbb
	5hxCImVkAHEyeKe72p4SiufkERUE=
X-Google-Smtp-Source: AGHT+IHSf839mMpS/X4ZbkEOlVHqU2Pl6NsRBtWR5rY0e9LQZZXqVueSBYYCozI87+g/3MEgOFGfMn+F42QE0uNXJLk=
X-Received: by 2002:a05:6402:354d:b0:5be:dab8:1bb3 with SMTP id
 4fb4d7f45d1cf-5c21ed3e9efmr10513009a12.13.1725243631227; Sun, 01 Sep 2024
 19:20:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730075744.1215856-1-maobibo@loongson.cn> <20240730075744.1215856-4-maobibo@loongson.cn>
 <CAAhV-H7D80huYzF6ewZqcgx8MTzWZNFXJHOahoJ33zJYX1kyAw@mail.gmail.com> <13276416-c62b-b33d-1824-7764122ef863@loongson.cn>
In-Reply-To: <13276416-c62b-b33d-1824-7764122ef863@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 2 Sep 2024 10:20:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4RhhYB0LHeOs+Cjr6LZj6np_S4-neEtYnLUU_K=upV_w@mail.gmail.com>
Message-ID: <CAAhV-H4RhhYB0LHeOs+Cjr6LZj6np_S4-neEtYnLUU_K=upV_w@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] LoongArch: KVM: Add vm migration support for LBT registers
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 9:56=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
>
> Hi Huacai,
>
> On 2024/8/31 =E4=B8=8B=E5=8D=8810:49, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Tue, Jul 30, 2024 at 3:57=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> Every vcpu has separate LBT registers. And there are four scr register=
s,
> >> one flags and ftop register for LBT extension. When VM migrates, VMM
> >> needs to get LBT registers for every vcpu.
> >>
> >> Here macro KVM_REG_LOONGARCH_LBT is added for new vcpu lbt register ty=
pe,
> >> the following macro is added to get/put LBT registers.
> >>    KVM_REG_LOONGARCH_LBT_SCR0
> >>    KVM_REG_LOONGARCH_LBT_SCR1
> >>    KVM_REG_LOONGARCH_LBT_SCR2
> >>    KVM_REG_LOONGARCH_LBT_SCR3
> >>    KVM_REG_LOONGARCH_LBT_EFLAGS
> >>    KVM_REG_LOONGARCH_LBT_FTOP
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/uapi/asm/kvm.h |  9 +++++
> >>   arch/loongarch/kvm/vcpu.c             | 56 +++++++++++++++++++++++++=
++
> >>   2 files changed, 65 insertions(+)
> >>
> >> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/in=
clude/uapi/asm/kvm.h
> >> index 49bafac8b22d..003fb766c93f 100644
> >> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >> @@ -64,6 +64,7 @@ struct kvm_fpu {
> >>   #define KVM_REG_LOONGARCH_KVM          (KVM_REG_LOONGARCH | 0x20000U=
LL)
> >>   #define KVM_REG_LOONGARCH_FPSIMD       (KVM_REG_LOONGARCH | 0x30000U=
LL)
> >>   #define KVM_REG_LOONGARCH_CPUCFG       (KVM_REG_LOONGARCH | 0x40000U=
LL)
> >> +#define KVM_REG_LOONGARCH_LBT          (KVM_REG_LOONGARCH | 0x50000UL=
L)
> >>   #define KVM_REG_LOONGARCH_MASK         (KVM_REG_LOONGARCH | 0x70000U=
LL)
> > I think KVM_REG_LOONGARCH_MASK should contain all above register
> > classes, so should it be  (KVM_REG_LOONGARCH | 0x370000ULL)?
> Sorry, maybe I miss something. What is the meaning of 0x370000ULL? How
> does the value come from?
It seems I misunderstood the mask, please ignore.

>
> >
> >>   #define KVM_CSR_IDX_MASK               0x7fff
> >>   #define KVM_CPUCFG_IDX_MASK            0x7fff
> >> @@ -77,6 +78,14 @@ struct kvm_fpu {
> >>   /* Debugging: Special instruction for software breakpoint */
> >>   #define KVM_REG_LOONGARCH_DEBUG_INST   (KVM_REG_LOONGARCH_KVM | KVM_=
REG_SIZE_U64 | 3)
> >>
> >> +/* LBT registers */
> >> +#define KVM_REG_LOONGARCH_LBT_SCR0     (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 1)
> >> +#define KVM_REG_LOONGARCH_LBT_SCR1     (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 2)
> >> +#define KVM_REG_LOONGARCH_LBT_SCR2     (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 3)
> >> +#define KVM_REG_LOONGARCH_LBT_SCR3     (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 4)
> >> +#define KVM_REG_LOONGARCH_LBT_EFLAGS   (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 5)
> >> +#define KVM_REG_LOONGARCH_LBT_FTOP     (KVM_REG_LOONGARCH_LBT | KVM_R=
EG_SIZE_U64 | 6)
> > FTOP is a 32bit register in other place of the kernel, is it correct
> > to use U64 here?
> It is deliberate and there is no 32bit compat requirement for kvm. ALL
> regiester interfaces are defined as 64-bit.
> On kernel and qemu side, ftop can be defined as 32bit still, however the
> interface is 64-bit. So there is forced type conversion between u32 and
> u64. There is no problem here.
If you are sure, then no problem. But there is indeed KVM_REG_SIZE_U32
in include/uapi/linux/kvm.h, and if we append more fields after ftop,
define it as U64 may break memcpy().

>
> >
> >> +
> >>   #define LOONGARCH_REG_SHIFT            3
> >>   #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 | (R=
EG << LOONGARCH_REG_SHIFT))
> >>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOON=
GARCH_CSR, REG)
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index b5324885a81a..b2500d4fa729 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -597,6 +597,34 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
> >>                          break;
> >>                  }
> >>                  break;
> >> +       case KVM_REG_LOONGARCH_LBT:
> > What about adding FPU/LSX/LASX registers (if needed for migration) in
> > kvm_{get, set}_one_reg() here?
> If there is 512bit SIMD or other requirement, it will be added in
> kvm_{get, set}_one_reg(). For FPU/LSX/LASX registers, there is common
> API KVM_GET_FPU/KVM_SET_FPU here. The impmentation of QEMU only gets
> FPU, the upper LSX/LASX is lost, we will submit a patch in qemu side,
> the kvm kernel side is ok.
OK, no problem.

Huacai
>
> /*
>   * for KVM_GET_FPU and KVM_SET_FPU
>   */
> struct kvm_fpu {
>          __u32 fcsr;
>          __u64 fcc;    /* 8x8 */
>          struct kvm_fpureg {
>                  __u64 val64[4];
>          } fpr[32];
> };
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> +               if (!kvm_guest_has_lbt(&vcpu->arch))
> >> +                       return -ENXIO;
> >> +
> >> +               switch (reg->id) {
> >> +               case KVM_REG_LOONGARCH_LBT_SCR0:
> >> +                       *v =3D vcpu->arch.lbt.scr0;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR1:
> >> +                       *v =3D vcpu->arch.lbt.scr1;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR2:
> >> +                       *v =3D vcpu->arch.lbt.scr2;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR3:
> >> +                       *v =3D vcpu->arch.lbt.scr3;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
> >> +                       *v =3D vcpu->arch.lbt.eflags;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_FTOP:
> >> +                       *v =3D vcpu->arch.fpu.ftop;
> >> +                       break;
> >> +               default:
> >> +                       ret =3D -EINVAL;
> >> +                       break;
> >> +               }
> >> +               break;
> >>          default:
> >>                  ret =3D -EINVAL;
> >>                  break;
> >> @@ -663,6 +691,34 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
> >>                          break;
> >>                  }
> >>                  break;
> >> +       case KVM_REG_LOONGARCH_LBT:
> >> +               if (!kvm_guest_has_lbt(&vcpu->arch))
> >> +                       return -ENXIO;
> >> +
> >> +               switch (reg->id) {
> >> +               case KVM_REG_LOONGARCH_LBT_SCR0:
> >> +                       vcpu->arch.lbt.scr0 =3D v;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR1:
> >> +                       vcpu->arch.lbt.scr1 =3D v;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR2:
> >> +                       vcpu->arch.lbt.scr2 =3D v;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_SCR3:
> >> +                       vcpu->arch.lbt.scr3 =3D v;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
> >> +                       vcpu->arch.lbt.eflags =3D v;
> >> +                       break;
> >> +               case KVM_REG_LOONGARCH_LBT_FTOP:
> >> +                       vcpu->arch.fpu.ftop =3D v;
> >> +                       break;
> >> +               default:
> >> +                       ret =3D -EINVAL;
> >> +                       break;
> >> +               }
> >> +               break;
> >>          default:
> >>                  ret =3D -EINVAL;
> >>                  break;
> >> --
> >> 2.39.3
> >>
>
>

