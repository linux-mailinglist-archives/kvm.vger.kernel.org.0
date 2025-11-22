Return-Path: <kvm+bounces-64277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE7BC7C4EA
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 04:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52EAD3A621C
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 03:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69657264612;
	Sat, 22 Nov 2025 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UghMCwob"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2441A2545
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 03:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763782695; cv=none; b=TjTL6/EgT/kKZUHhYV7A8mOk6v80TycMSNjS0z/U8ELyjiujfWkJJRiOd+WysCow1V/16rwtTV4qbIl5rXeX7qehw5WTsgCYMGXg+j7TQEtodIk3NuvEoMUn3xIYDeKpvuFqDs/+5vAqFYsg8UORP8goqN1lbPVQMevvMsBm0GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763782695; c=relaxed/simple;
	bh=GW5SYpmr97d7GMMG7slEee14IKBRbnl3nv7C64YFOEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxmaQTNnmcJs5CqjUN9S9bsMELvmbMy8AYbGNo7Tx45a220nhzrN+IYtqx+4mMGjnebYAKyiFKAV4CKb2ua8xJtDWTun0BQhxaRc55z4TrRrKI6xErVjbnbF3vqgbJWgruuHAAR+TUy0RijxhOoYrUb/J0fTUaJznbdXF709qV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UghMCwob; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA0EC4AF09
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763782695;
	bh=GW5SYpmr97d7GMMG7slEee14IKBRbnl3nv7C64YFOEA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UghMCwobwetq5dlc4fHkNqsoJ27iXUeSAnlwt1Sb7Bkdu3ITNW2cF5yGcOhg65qL0
	 i6NPeFxEjcl7gkzk6aXxL61xMNIHI3uM3m+uqm5itDvGmtjiqA29f18F2m7ZbJfmBt
	 wJXk3ZpSmrz8wDdDwwGFGV6PKqrwUfbuYFBQL8db3i9mP/yLLCKqtwmu19mZESHmdJ
	 HzIjstpOgBfbWWJx6Bk5GhpcU7bYH/chk1xsx/puajpelu9IdIZZcLSsKHsWRMT8Jh
	 26pxaOZx3IxoeHgi3b2cJJZBuHsyJQLJSzDul83RTJhNJYqDsmI+Ptv2GtzkgUwiOo
	 nwVUve5sXRHpg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b736cd741c1so464629966b.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:38:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVz7ztBKWLSgkVGs+0ZhowpR2KBIFSrgC4b9SBr/1S5tA25zl2JXB8u0J8Z8s/Y9nMhpA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB5udNw6Jugskq56m4TuUOZ9HDvIawjWSdQJNrLyUdG9DJVCRJ
	D5r86yRMIhoi+zBfyJ66IqVzU6jYAov6lSZrk23hbxRf21XBkg48GQIsKRjhvqiTp52FevCnTQs
	sayqXyEg+OKHQBilCfOfyFBsmsEDZiao=
X-Google-Smtp-Source: AGHT+IHUJPBJh5ptvQmK5d+6PIPITPkae8XWbCUIBnOE9Ut+IXL20Ba6UgzDiIX5kiSQlqefse9z3zv3kkjf2wdLsw0=
X-Received: by 2002:a17:907:2d11:b0:b76:3bfd:8afe with SMTP id
 a640c23a62f3a-b767150b8a1mr504131566b.5.1763782693495; Fri, 21 Nov 2025
 19:38:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014100359.1159754-1-maobibo@loongson.cn>
In-Reply-To: <20251014100359.1159754-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 22 Nov 2025 11:38:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Si0j0YHw11vn74hoX4bvwpZ_1xxNerhOa9Do1mgeR4w@mail.gmail.com>
X-Gm-Features: AWmQ_blLn9FEZpIS91UMscXMnoq1pX0_sUDuxxeYiPvJU8rTKQCd2RzAW6v0Wrs
Message-ID: <CAAhV-H5Si0j0YHw11vn74hoX4bvwpZ_1xxNerhOa9Do1mgeR4w@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Use 64-bit register definition with eiointc
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied with further simplification, if it is not correct please let me kno=
w.
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/commit/?h=3Dloongarch-next&id=3Da49c93149100a51e9d343a592399853601a57325

Huacai

On Tue, Oct 14, 2025 at 6:04=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> With in-kernel emulated eiointc driver, hardware register can be
> accessed by different size, there is reg_u8/reg_u16/reg_u32/reg_u64
> union type with eiointc register.
>
> Here use 64-bit type with register definition and remove union type
> since most registers are accessed with 64-bit method. And it makes
> eiointc emulated driver simpler.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_eiointc.h | 55 +++------------
>  arch/loongarch/kvm/intc/eiointc.c        | 89 +++++++++++++-----------
>  2 files changed, 57 insertions(+), 87 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/in=
clude/asm/kvm_eiointc.h
> index a3a40aba8acf..8b7a2fa3f7f8 100644
> --- a/arch/loongarch/include/asm/kvm_eiointc.h
> +++ b/arch/loongarch/include/asm/kvm_eiointc.h
> @@ -10,10 +10,7 @@
>
>  #define EIOINTC_IRQS                   256
>  #define EIOINTC_ROUTE_MAX_VCPUS                256
> -#define EIOINTC_IRQS_U8_NUMS           (EIOINTC_IRQS / 8)
> -#define EIOINTC_IRQS_U16_NUMS          (EIOINTC_IRQS_U8_NUMS / 2)
> -#define EIOINTC_IRQS_U32_NUMS          (EIOINTC_IRQS_U8_NUMS / 4)
> -#define EIOINTC_IRQS_U64_NUMS          (EIOINTC_IRQS_U8_NUMS / 8)
> +#define EIOINTC_IRQS_U64_NUMS          (EIOINTC_IRQS / 64)
>  /* map to ipnum per 32 irqs */
>  #define EIOINTC_IRQS_NODETYPE_COUNT    16
>
> @@ -64,54 +61,18 @@ struct loongarch_eiointc {
>         uint32_t status;
>
>         /* hardware state */
> -       union nodetype {
> -               u64 reg_u64[EIOINTC_IRQS_NODETYPE_COUNT / 4];
> -               u32 reg_u32[EIOINTC_IRQS_NODETYPE_COUNT / 2];
> -               u16 reg_u16[EIOINTC_IRQS_NODETYPE_COUNT];
> -               u8 reg_u8[EIOINTC_IRQS_NODETYPE_COUNT * 2];
> -       } nodetype;
> +       u64 nodetype[EIOINTC_IRQS_NODETYPE_COUNT / 4];
>
>         /* one bit shows the state of one irq */
> -       union bounce {
> -               u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
> -               u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
> -               u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
> -               u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
> -       } bounce;
> -
> -       union isr {
> -               u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
> -               u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
> -               u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
> -               u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
> -       } isr;
> -       union coreisr {
> -               u64 reg_u64[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U64_NUM=
S];
> -               u32 reg_u32[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U32_NUM=
S];
> -               u16 reg_u16[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U16_NUM=
S];
> -               u8 reg_u8[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U8_NUMS];
> -       } coreisr;
> -       union enable {
> -               u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
> -               u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
> -               u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
> -               u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
> -       } enable;
> +       u64 bounce[EIOINTC_IRQS_U64_NUMS];
> +       u64 isr[EIOINTC_IRQS_U64_NUMS];
> +       u64 coreisr[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U64_NUMS];
> +       u64 enable[EIOINTC_IRQS_U64_NUMS];
>
>         /* use one byte to config ipmap for 32 irqs at once */
> -       union ipmap {
> -               u64 reg_u64;
> -               u32 reg_u32[EIOINTC_IRQS_U32_NUMS / 4];
> -               u16 reg_u16[EIOINTC_IRQS_U16_NUMS / 4];
> -               u8 reg_u8[EIOINTC_IRQS_U8_NUMS / 4];
> -       } ipmap;
> +       u64 ipmap;
>         /* use one byte to config coremap for one irq */
> -       union coremap {
> -               u64 reg_u64[EIOINTC_IRQS / 8];
> -               u32 reg_u32[EIOINTC_IRQS / 4];
> -               u16 reg_u16[EIOINTC_IRQS / 2];
> -               u8 reg_u8[EIOINTC_IRQS];
> -       } coremap;
> +       u64 coremap[EIOINTC_IRQS / 8];
>
>         DECLARE_BITMAP(sw_coreisr[EIOINTC_ROUTE_MAX_VCPUS][LOONGSON_IP_NU=
M], EIOINTC_IRQS);
>         uint8_t  sw_coremap[EIOINTC_IRQS];
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index c32333695381..eecdc8f4a565 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -11,21 +11,23 @@ static void eiointc_set_sw_coreisr(struct loongarch_e=
iointc *s)
>  {
>         int ipnum, cpu, cpuid, irq;
>         struct kvm_vcpu *vcpu;
> +       u8 *coremap;
>
> +       coremap =3D (u8 *)s->coremap;
>         for (irq =3D 0; irq < EIOINTC_IRQS; irq++) {
> -               ipnum =3D s->ipmap.reg_u8[irq / 32];
> +               ipnum =3D (s->ipmap >> (irq / 32 * 8)) & 0xFF;
>                 if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
>                         ipnum =3D count_trailing_zeros(ipnum);
>                         ipnum =3D (ipnum >=3D 0 && ipnum < 4) ? ipnum : 0=
;
>                 }
>
> -               cpuid =3D s->coremap.reg_u8[irq];
> +               cpuid =3D coremap[irq];
>                 vcpu =3D kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
>                 if (!vcpu)
>                         continue;
>
>                 cpu =3D vcpu->vcpu_id;
> -               if (test_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu=
]))
> +               if (test_bit(irq, (unsigned long *)s->coreisr[cpu]))
>                         __set_bit(irq, s->sw_coreisr[cpu][ipnum]);
>                 else
>                         __clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
> @@ -38,7 +40,7 @@ static void eiointc_update_irq(struct loongarch_eiointc=
 *s, int irq, int level)
>         struct kvm_vcpu *vcpu;
>         struct kvm_interrupt vcpu_irq;
>
> -       ipnum =3D s->ipmap.reg_u8[irq / 32];
> +       ipnum =3D (s->ipmap >> (irq / 32 * 8)) & 0xFF;
>         if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
>                 ipnum =3D count_trailing_zeros(ipnum);
>                 ipnum =3D (ipnum >=3D 0 && ipnum < 4) ? ipnum : 0;
> @@ -53,13 +55,13 @@ static void eiointc_update_irq(struct loongarch_eioin=
tc *s, int irq, int level)
>
>         if (level) {
>                 /* if not enable return false */
> -               if (!test_bit(irq, (unsigned long *)s->enable.reg_u32))
> +               if (!test_bit(irq, (unsigned long *)s->enable))
>                         return;
> -               __set_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
> +               __set_bit(irq, (unsigned long *)s->coreisr[cpu]);
>                 found =3D find_first_bit(s->sw_coreisr[cpu][ipnum], EIOIN=
TC_IRQS);
>                 __set_bit(irq, s->sw_coreisr[cpu][ipnum]);
>         } else {
> -               __clear_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]=
);
> +               __clear_bit(irq, (unsigned long *)s->coreisr[cpu]);
>                 __clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
>                 found =3D find_first_bit(s->sw_coreisr[cpu][ipnum], EIOIN=
TC_IRQS);
>         }
> @@ -94,7 +96,7 @@ static inline void eiointc_update_sw_coremap(struct loo=
ngarch_eiointc *s,
>                 if (s->sw_coremap[irq + i] =3D=3D cpu)
>                         continue;
>
> -               if (notify && test_bit(irq + i, (unsigned long *)s->isr.r=
eg_u8)) {
> +               if (notify && test_bit(irq + i, (unsigned long *)s->isr))=
 {
>                         /* lower irq at old cpu and raise irq at new cpu =
*/
>                         eiointc_update_irq(s, irq + i, 0);
>                         s->sw_coremap[irq + i] =3D cpu;
> @@ -108,7 +110,7 @@ static inline void eiointc_update_sw_coremap(struct l=
oongarch_eiointc *s,
>  void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
>  {
>         unsigned long flags;
> -       unsigned long *isr =3D (unsigned long *)s->isr.reg_u8;
> +       unsigned long *isr =3D (unsigned long *)s->isr;
>
>         spin_lock_irqsave(&s->lock, flags);
>         level ? __set_bit(irq, isr) : __clear_bit(irq, isr);
> @@ -127,27 +129,27 @@ static int loongarch_eiointc_read(struct kvm_vcpu *=
vcpu, struct loongarch_eioint
>         switch (offset) {
>         case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
>                 index =3D (offset - EIOINTC_NODETYPE_START) >> 3;
> -               data =3D s->nodetype.reg_u64[index];
> +               data =3D s->nodetype[index];
>                 break;
>         case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
>                 index =3D (offset - EIOINTC_IPMAP_START) >> 3;
> -               data =3D s->ipmap.reg_u64;
> +               data =3D s->ipmap;
>                 break;
>         case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
>                 index =3D (offset - EIOINTC_ENABLE_START) >> 3;
> -               data =3D s->enable.reg_u64[index];
> +               data =3D s->enable[index];
>                 break;
>         case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
>                 index =3D (offset - EIOINTC_BOUNCE_START) >> 3;
> -               data =3D s->bounce.reg_u64[index];
> +               data =3D s->bounce[index];
>                 break;
>         case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
>                 index =3D (offset - EIOINTC_COREISR_START) >> 3;
> -               data =3D s->coreisr.reg_u64[vcpu->vcpu_id][index];
> +               data =3D s->coreisr[vcpu->vcpu_id][index];
>                 break;
>         case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>                 index =3D (offset - EIOINTC_COREMAP_START) >> 3;
> -               data =3D s->coremap.reg_u64[index];
> +               data =3D s->coremap[index];
>                 break;
>         default:
>                 ret =3D -EINVAL;
> @@ -223,26 +225,26 @@ static int loongarch_eiointc_write(struct kvm_vcpu =
*vcpu,
>         switch (offset) {
>         case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
>                 index =3D (offset - EIOINTC_NODETYPE_START) >> 3;
> -               old =3D s->nodetype.reg_u64[index];
> -               s->nodetype.reg_u64[index] =3D (old & ~mask) | data;
> +               old =3D s->nodetype[index];
> +               s->nodetype[index] =3D (old & ~mask) | data;
>                 break;
>         case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
>                 /*
>                  * ipmap cannot be set at runtime, can be set only at the=
 beginning
>                  * of irqchip driver, need not update upper irq level
>                  */
> -               old =3D s->ipmap.reg_u64;
> -               s->ipmap.reg_u64 =3D (old & ~mask) | data;
> +               old =3D s->ipmap;
> +               s->ipmap =3D (old & ~mask) | data;
>                 break;
>         case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
>                 index =3D (offset - EIOINTC_ENABLE_START) >> 3;
> -               old =3D s->enable.reg_u64[index];
> -               s->enable.reg_u64[index] =3D (old & ~mask) | data;
> +               old =3D s->enable[index];
> +               s->enable[index] =3D (old & ~mask) | data;
>                 /*
>                  * 1: enable irq.
>                  * update irq when isr is set.
>                  */
> -               data =3D s->enable.reg_u64[index] & ~old & s->isr.reg_u64=
[index];
> +               data =3D s->enable[index] & ~old & s->isr[index];
>                 while (data) {
>                         irq =3D __ffs(data);
>                         eiointc_update_irq(s, irq + index * 64, 1);
> @@ -252,7 +254,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *v=
cpu,
>                  * 0: disable irq.
>                  * update irq when isr is set.
>                  */
> -               data =3D ~s->enable.reg_u64[index] & old & s->isr.reg_u64=
[index];
> +               data =3D ~s->enable[index] & old & s->isr[index];
>                 while (data) {
>                         irq =3D __ffs(data);
>                         eiointc_update_irq(s, irq + index * 64, 0);
> @@ -262,16 +264,16 @@ static int loongarch_eiointc_write(struct kvm_vcpu =
*vcpu,
>         case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
>                 /* do not emulate hw bounced irq routing */
>                 index =3D (offset - EIOINTC_BOUNCE_START) >> 3;
> -               old =3D s->bounce.reg_u64[index];
> -               s->bounce.reg_u64[index] =3D (old & ~mask) | data;
> +               old =3D s->bounce[index];
> +               s->bounce[index] =3D (old & ~mask) | data;
>                 break;
>         case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
>                 index =3D (offset - EIOINTC_COREISR_START) >> 3;
>                 /* use attrs to get current cpu index */
>                 cpu =3D vcpu->vcpu_id;
> -               old =3D s->coreisr.reg_u64[cpu][index];
> +               old =3D s->coreisr[cpu][index];
>                 /* write 1 to clear interrupt */
> -               s->coreisr.reg_u64[cpu][index] =3D old & ~data;
> +               s->coreisr[cpu][index] =3D old & ~data;
>                 data &=3D old;
>                 while (data) {
>                         irq =3D __ffs(data);
> @@ -281,9 +283,9 @@ static int loongarch_eiointc_write(struct kvm_vcpu *v=
cpu,
>                 break;
>         case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>                 index =3D (offset - EIOINTC_COREMAP_START) >> 3;
> -               old =3D s->coremap.reg_u64[index];
> -               s->coremap.reg_u64[index] =3D (old & ~mask) | data;
> -               data =3D s->coremap.reg_u64[index];
> +               old =3D s->coremap[index];
> +               s->coremap[index] =3D (old & ~mask) | data;
> +               data =3D s->coremap[index];
>                 eiointc_update_sw_coremap(s, index * 8, data, sizeof(data=
), true);
>                 break;
>         default:
> @@ -451,10 +453,10 @@ static int kvm_eiointc_ctrl_access(struct kvm_devic=
e *dev,
>                 break;
>         case KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED:
>                 eiointc_set_sw_coreisr(s);
> -               for (i =3D 0; i < (EIOINTC_IRQS / 4); i++) {
> -                       start_irq =3D i * 4;
> +               for (i =3D 0; i < (EIOINTC_IRQS / 8); i++) {
> +                       start_irq =3D i * 8;
>                         eiointc_update_sw_coremap(s, start_irq,
> -                                       s->coremap.reg_u32[i], sizeof(u32=
), false);
> +                                       s->coremap[i], sizeof(u64), false=
);
>                 }
>                 break;
>         default:
> @@ -481,34 +483,41 @@ static int kvm_eiointc_regs_access(struct kvm_devic=
e *dev,
>         switch (addr) {
>         case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
>                 offset =3D (addr - EIOINTC_NODETYPE_START) / 4;
> -               p =3D &s->nodetype.reg_u32[offset];
> +               p =3D s->nodetype;
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
>                 offset =3D (addr - EIOINTC_IPMAP_START) / 4;
> -               p =3D &s->ipmap.reg_u32[offset];
> +               p =3D &s->ipmap;
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
>                 offset =3D (addr - EIOINTC_ENABLE_START) / 4;
> -               p =3D &s->enable.reg_u32[offset];
> +               p =3D s->enable;
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
>                 offset =3D (addr - EIOINTC_BOUNCE_START) / 4;
> -               p =3D &s->bounce.reg_u32[offset];
> +               p =3D s->bounce;
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_ISR_START ... EIOINTC_ISR_END:
>                 offset =3D (addr - EIOINTC_ISR_START) / 4;
> -               p =3D &s->isr.reg_u32[offset];
> +               p =3D s->isr;
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
>                 if (cpu >=3D s->num_cpu)
>                         return -EINVAL;
>
>                 offset =3D (addr - EIOINTC_COREISR_START) / 4;
> -               p =3D &s->coreisr.reg_u32[cpu][offset];
> +               p =3D s->coreisr[cpu];
> +               p +=3D offset * 4;
>                 break;
>         case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>                 offset =3D (addr - EIOINTC_COREMAP_START) / 4;
> -               p =3D &s->coremap.reg_u32[offset];
> +               p =3D s->coremap;
> +               p +=3D offset * 4;
>                 break;
>         default:
>                 kvm_err("%s: unknown eiointc register, addr =3D %d\n", __=
func__, addr);
>
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> --
> 2.39.3
>
>

