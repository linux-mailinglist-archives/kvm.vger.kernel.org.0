Return-Path: <kvm+bounces-64935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D811C92029
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 13:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2074234C73E
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 12:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BE3329E57;
	Fri, 28 Nov 2025 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u95lUah+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2104E3081DE
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764333709; cv=none; b=OlwVXz1inZV6LVT7l2uMVAUOYuhb0p9eKHmY9IDl+CyuBOQfl/RtXcSNHH6f95GVu5uLOa0QOJUsZEecNI4qF88yrc5ahk9UEtN07DQ9/mYT+wkgyB+isGNHQsQxxD2I369RunUJ4gv8y+7Lprc4eEsKCSv2OyXGVSIPqDOjYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764333709; c=relaxed/simple;
	bh=lFitHy2vbyIeuIYUR8qQkOQux0hkDnlcTykD7bUkQVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iaSD8uSKn/afl4s643Ky0P+Hs4xNJEXufrGKNI7aLLuvwm/4cPIvLLIcfzWG9qUDq7vX5QjJdY3kBuZoM3b0qm11UQz04IYoIijsuc7V1g3Qokq6FDRIdyTC3QjvowwmnP/pIZTTr6BdnJCnmnNKis2Y+ZvZRI8cH0sCKjR9oek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u95lUah+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEC9C4AF09
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764333708;
	bh=lFitHy2vbyIeuIYUR8qQkOQux0hkDnlcTykD7bUkQVc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u95lUah+XvZrHg1XPD4HYRycjb8dp5klQJSYefYD5SqQItsl3uIL14cpd+Ig1xHuj
	 YbciU+zMPtdaeNbdTlIEJgyaj5REciElcs+hExL8yj/p4aercmHFoPVUunB1/iQuYS
	 FlGqgA+IxV55fNCsTo3uDe7lVoJRjYwnKQiUlJ2f+wF6jotI011prTlENtpeMS7Nix
	 3EaBKrJjg1puPWA9OcL8yFLTWrC3O6VEdG8uX8W5lyhmjbk4iDx2d0kX5R0dIJy83Z
	 ZHhwTo255vptaC9cflVQzpBKzGFeuCcFvJMlX5Km9erweJ/xDivDEin9Iu/Gz1cb3s
	 NgsojMuCtvcaQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b735b7326e5so487666766b.0
        for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 04:41:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX8WD9nhB/HryIA8YqVi9oCKfu8pbYhV3EH20jvqkK3hACV4ve7qGMJFDcO7hYLFSY1dZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRbdjSuhSjpTym9XxNzT1A7gyVANbJwnCA2PgDMQzJGxKslmuy
	sFDnJnAZqL0IFqdGK5whlxfPYQHMy9HHYMsOp5XBvQ13EWxKIOu94V5a7tThA1F5RXHxi9ctvco
	MQUXnr2Z7WGlUoDEJMoMLKUdAH3riruc=
X-Google-Smtp-Source: AGHT+IF9x9pQKsUh+6q9nmWDe4cxMC+vwVYJTaa+RKsM6Ya63McSfkFYB5bIrlVQaQp46vMBJNbLS4acOtlQVpHcRas=
X-Received: by 2002:a17:907:d19:b0:b07:87f1:fc42 with SMTP id
 a640c23a62f3a-b766ef1d094mr3720212466b.16.1764333707416; Fri, 28 Nov 2025
 04:41:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128091125.2720148-1-gaosong@loongson.cn> <20251128091125.2720148-2-gaosong@loongson.cn>
In-Reply-To: <20251128091125.2720148-2-gaosong@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 28 Nov 2025 20:41:53 +0800
X-Gmail-Original-Message-ID: <CAAhV-H499e4LBKS-pvKOy_oudzcCNb7mhnq_3YEBaae0Ncj4HA@mail.gmail.com>
X-Gm-Features: AWmQ_blxDx8UDkeOSgRsk31XZH0cJO63XwaL4PSWc0ihBVWPC6ebfBitIrz7Vq8
Message-ID: <CAAhV-H499e4LBKS-pvKOy_oudzcCNb7mhnq_3YEBaae0Ncj4HA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] LongArch: KVM: Add some maccros for AVEC
To: Song Gao <gaosong@loongson.cn>, Thomas Gleixner <tglx@linutronix.de>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Thomas,

On Fri, Nov 28, 2025 at 5:35=E2=80=AFPM Song Gao <gaosong@loongson.cn> wrot=
e:
>
> Add some maccros for AVEC interrupt controller, so the dintc can use
> those maccros.
>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
Would you mind if I apply this simple patch to the loongarch tree?
Later patches depend on this one, but if it is taken into the irqchip
tree, this series is not very convenient for kvm.


Huacai

> ---
>  arch/loongarch/include/asm/irq.h     | 8 ++++++++
>  drivers/irqchip/irq-loongarch-avec.c | 5 +++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/as=
m/irq.h
> index 12bd15578c33..aaa022fcb9e3 100644
> --- a/arch/loongarch/include/asm/irq.h
> +++ b/arch/loongarch/include/asm/irq.h
> @@ -50,6 +50,14 @@ void spurious_interrupt(void);
>  #define NR_LEGACY_VECTORS      16
>  #define IRQ_MATRIX_BITS                NR_VECTORS
>
> +#define AVEC_VIRQ_SHIFT                4
> +#define AVEC_VIRQ_BIT          8
> +#define AVEC_VIRQ_MASK         GENMASK(AVEC_VIRQ_BIT - 1, 0)
> +#define AVEC_CPU_SHIFT         12
> +#define AVEC_CPU_BIT           16
> +#define AVEC_CPU_MASK          GENMASK(AVEC_CPU_BIT - 1, 0)
> +
> +
>  #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
>  void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int excl=
ude_cpu);
>
> diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-l=
oongarch-avec.c
> index bf52dc8345f5..f0118cfd4363 100644
> --- a/drivers/irqchip/irq-loongarch-avec.c
> +++ b/drivers/irqchip/irq-loongarch-avec.c
> @@ -209,8 +209,9 @@ static void avecintc_compose_msi_msg(struct irq_data =
*d, struct msi_msg *msg)
>         struct avecintc_data *adata =3D irq_data_get_irq_chip_data(d);
>
>         msg->address_hi =3D 0x0;
> -       msg->address_lo =3D (loongarch_avec.msi_base_addr | (adata->vec &=
 0xff) << 4)
> -                         | ((cpu_logical_map(adata->cpu & 0xffff)) << 12=
);
> +       msg->address_lo =3D (loongarch_avec.msi_base_addr |
> +                       (adata->vec & AVEC_VIRQ_MASK) << AVEC_VIRQ_SHIFT)=
 |
> +                       ((cpu_logical_map(adata->cpu & AVEC_CPU_MASK)) <<=
 AVEC_CPU_SHIFT);
>         msg->data =3D 0x0;
>  }
>
> --
> 2.39.3
>

