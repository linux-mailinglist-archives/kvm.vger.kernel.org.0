Return-Path: <kvm+bounces-49949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CA1AE0050
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 10:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C7683A2AEE
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 08:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEB9265609;
	Thu, 19 Jun 2025 08:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/SqDvUk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9B7239E96;
	Thu, 19 Jun 2025 08:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750322832; cv=none; b=mu+s5nT/SClb1fsFi/oYIVBNKADuq1f9Q77hVjBeAwgnDz2G6rkysGe54a04jR8omNMNugzfSqfAuLew7EFAvNbFOJe/6Ur3faOiVMu7f6+/PZblSLgB2piaZ2FW4yuEwqxez8J50HZzf3SABB+e3dXddBm+wohr2YT4/HMZYdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750322832; c=relaxed/simple;
	bh=lDXCVX4q7vcUWq+/M1DFLYUd7+DFlOjabwmk14VPhaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k5jopq3VY+dsX90JxeTG32KHYl6DArKC7Oy6ApGwLRZpXB2K4egLybBE8RnKCixGRPJBTkAuZxDV1+F/AvH5BtlTRNLecbHiyCiYfJ+i1D0UNe3UZlTzmwdGsOksQgmLHm8AgEV/wpflYJXpXzZg0Rt0MEZbZ/dedqlPLuO2rAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/SqDvUk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22312C4CEED;
	Thu, 19 Jun 2025 08:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750322832;
	bh=lDXCVX4q7vcUWq+/M1DFLYUd7+DFlOjabwmk14VPhaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M/SqDvUk6tS0R3i+tyH6t7SsbtFXIjkhdMA0NHXSPWa4fNN8+fNC2Q5nJveauJNM2
	 D1+pyOPGpKaM09qQwtekkxZH/T3pL+y2CNGBTl5NZOZgBFwvXNWUW7ToZDTX34b3di
	 komBWfXsx3IeIj5SNgxOtsoY66avelbGP7/BL+Im0qFL1jU/CQMXx4wITDZERFv/kD
	 vF26IecNKPjGoegR+TyvEJxW9nh33zeVPfS8hK5JC75tN8APbKpWbkKsafbpP4rzo/
	 RAuaNSq+15qZmLgsttae9I4v3vveic8HMEGNW91ftIOYGikiC0aDkqrnINCpnsKTIL
	 KH1Y9z0/PC+yA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso916270a12.0;
        Thu, 19 Jun 2025 01:47:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUBL1O80BdH4v/CBwXa4GLykXq89AbN0jsoZsoUAhaa8vJRZNAulC78aotaykP15JchsrFz8kPhI/D8bYeg@vger.kernel.org, AJvYcCUDVyvg2I6Ym0o4SSJq85KMW+fvnq6uKDIE1nKbOwaac+npQ2i3ndM+y7rNsay2HSf+vJY=@vger.kernel.org, AJvYcCWCy6pVZyMuWlGmaK9EaLP+yTp1YhQgg7ZshNh3v/EhT9cSFEGs3S6HPQ685Abiefr9MLynA+k3@vger.kernel.org
X-Gm-Message-State: AOJu0YzRI7zwlSoDCtvHXBaLZmSJP9BOPonbUygUpfvYsPY6T+VwWazC
	t6beCmJDEcqXEOi/rSbmTae2g0volWajR4DLjpXvyvVMrw8huYY/cnRahyoowg24OgMn5Ftx0dF
	rx4HB7OYQq/3srnJer+Z6McqfynUzVcQ=
X-Google-Smtp-Source: AGHT+IFeJC3NPskVJUNoI2sRnfcHU0f/t2j7OGS2vtL/y78AJ7isycEhTkscDum+baBAp1XR5gdccY+jQHFyT7q8ihE=
X-Received: by 2002:a05:6402:40c3:b0:602:ef0a:cef8 with SMTP id
 4fb4d7f45d1cf-608d09c0ademr17260179a12.18.1750322830625; Thu, 19 Jun 2025
 01:47:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611014651.3042734-1-maobibo@loongson.cn> <20250611014651.3042734-5-maobibo@loongson.cn>
In-Reply-To: <20250611014651.3042734-5-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 19 Jun 2025 16:46:59 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com>
X-Gm-Features: AX0GCFvQfrZhtZzoYo5oGwCwbWDmxUGOenAQOTjMOkCZzk0DHfrc0j8ZTO4Qivc
Message-ID: <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] LoongArch: KVM: INTC: Check validation of num_cpu
 from user space
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 11, 2025 at 9:47=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
> irqchip eiointc, here add validation about cpu number to avoid array
> pointer overflow.
>
> Cc: stable@vger.kernel.org
> Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and writ=
e functions")
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index b48511f903b5..ed80bf290755 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device =
*dev,
>         int ret =3D 0;
>         unsigned long flags;
>         unsigned long type =3D (unsigned long)attr->attr;
> -       u32 i, start_irq;
> +       u32 i, start_irq, val;
>         void __user *data;
>         struct loongarch_eiointc *s =3D dev->kvm->arch.eiointc;
>
> @@ -806,7 +806,12 @@ static int kvm_eiointc_ctrl_access(struct kvm_device=
 *dev,
>         spin_lock_irqsave(&s->lock, flags);
>         switch (type) {
>         case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
> -               if (copy_from_user(&s->num_cpu, data, 4))
> +               if (copy_from_user(&val, data, 4) =3D=3D 0) {
> +                       if (val < EIOINTC_ROUTE_MAX_VCPUS)
> +                               s->num_cpu =3D val;
> +                       else
> +                               ret =3D -EINVAL;
Maybe it is better to set s->num_cpu to EIOINTC_ROUTE_MAX_VCPUS (or
other value) rather than keep it uninitialized. Because in other
places we need to check s->num_cpu and an uninitialized value may
cause undefined behavior.


Huacai
> +               } else
>                         ret =3D -EFAULT;
>                 break;
>         case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
> @@ -835,7 +840,7 @@ static int kvm_eiointc_regs_access(struct kvm_device =
*dev,
>                                         struct kvm_device_attr *attr,
>                                         bool is_write)
>  {
> -       int addr, cpuid, offset, ret =3D 0;
> +       int addr, cpu, offset, ret =3D 0;
>         unsigned long flags;
>         void *p =3D NULL;
>         void __user *data;
> @@ -843,7 +848,7 @@ static int kvm_eiointc_regs_access(struct kvm_device =
*dev,
>
>         s =3D dev->kvm->arch.eiointc;
>         addr =3D attr->attr;
> -       cpuid =3D addr >> 16;
> +       cpu =3D addr >> 16;
>         addr &=3D 0xffff;
>         data =3D (void __user *)attr->addr;
>         switch (addr) {
> @@ -868,8 +873,11 @@ static int kvm_eiointc_regs_access(struct kvm_device=
 *dev,
>                 p =3D &s->isr.reg_u32[offset];
>                 break;
>         case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
> +               if (cpu >=3D s->num_cpu)
> +                       return -EINVAL;
> +
>                 offset =3D (addr - EIOINTC_COREISR_START) / 4;
> -               p =3D &s->coreisr.reg_u32[cpuid][offset];
> +               p =3D &s->coreisr.reg_u32[cpu][offset];
>                 break;
>         case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>                 offset =3D (addr - EIOINTC_COREMAP_START) / 4;
> --
> 2.39.3
>

