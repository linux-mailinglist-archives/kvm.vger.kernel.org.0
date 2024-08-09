Return-Path: <kvm+bounces-23690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E593694D140
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F0DE1F2226C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351D4194089;
	Fri,  9 Aug 2024 13:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Lvvi60HV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA0194A6F
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 13:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210179; cv=none; b=B3nFRaWQJxW6i26DxCw4y9g1UvNjtIjRGREDzXP+YjnE4HrRRucBoFaKIFh4RO5f1MhXHcXkimtiQtDueN5Sebg4cQzWpmnGSV6sKBE6al2LXH9KaoTiL4ylq9ok66+Y3ja3YRTFBEHQm+3czjsxJnw2U5SO3DmoLcA+QeBUmSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210179; c=relaxed/simple;
	bh=zhs2jESJZf2/FLZN+Mxj6UUZq2vu1qhPaieXnvvKigM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T6cxi3HeY7ObceYaAydq8I2jol0BSkOK6UvQJmsKdZchwvK7RCD85TrN3M3EC7Cw0Lk+gH/2RsLT/zlsjwZ4JdPVJcXdhtCm1Rpbq1wTt41Ll/lg1LkcahIA4Iq2wV+Qm1WIgj/bwWyOw2TGy8WhDQYoGveXjB0Z81YXWouzeKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Lvvi60HV; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ef2fccca2cso21915141fa.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 06:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723210175; x=1723814975; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuzwnBVQwfnD4VRTU1K9TpVmgTpZ9T24iNeNAWvAywI=;
        b=Lvvi60HVal2GVphb2Rbpd//fAkNzBxjVEJI11GSmsTNJfOb6LMiVhO1tAOsSUq7yP9
         kbZDrhRTUPwEx3QAVmgePgmVyrvtmB2A3GVclBj7MeuHSHlHJtN09jfM/Ts6w0P3J8C5
         j/DTTTg259yJebooTba20WZugJHs3s/2C6AgyR+Yi3fLnPYTEOtAAOzaDI7b1owh2kVv
         7E66k15YMVZ5JY62h47ACJl3NpkKJgm9+i2sWsi8LQAdbCxfVYxI5k1c1YlSbzO+UVU0
         S8Hrqr3HmahwfzvDTdglWuxKRi835M7ERG35Q81NJ/UaDkHQIEFvbkV0iQ28d3QsEu5f
         xB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723210175; x=1723814975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuzwnBVQwfnD4VRTU1K9TpVmgTpZ9T24iNeNAWvAywI=;
        b=gBKx9PifDl2Yd/4EUihqSr6MeCrcBg/N+oBzP1C5Y5eT7LO1m/e0yeQJtRjUbcK+JX
         5HVXSB5Ite4EOrdfdg4Y7tClMpjT/5Tdb8wp3+8b92hlsijfP8Cum0hX1+JbRs1DPuY9
         qHpWxESZvAJXyCPjZu+qKIv0YwJ+j5Cv+QV1+uGX1/q5TOrH3jhU0bznUU4BhsTY7yRX
         zFY973Ht6GybM758PYMB97YIPmiF1QDPeZVHU2Wc9YBO4vW1eXyr41pihVh/MqA7eQ7U
         HPXG5M/JbQHlcedpaoolG9PPe/pxmivvXVp5mVNaNFNHytY60RXfO2Dz2+/ZsIkLa8sY
         dIGw==
X-Gm-Message-State: AOJu0Yzj1x95Jgd3bb9x0ssO9DxO8p+k4P/7AU3ogkaw68O/NdEn6qwY
	2XZlmN0bfgeMH5/I653LWJYttMymtmNwKOx6hlBHzWySE3i+cNTj09tsO9W5KOGqYqViBmvypiY
	/zKJ0UwO1ZNqyS76KSQUIhH36bsqKbDZrQwc9cw==
X-Google-Smtp-Source: AGHT+IGclZY00rkf851HYZJyFJ2+DYuLetQhuut/JN+KciMvpwBJfqStH8Gc3aNdvraTu436hwns7qMiWhWECweOpAw=
X-Received: by 2002:a05:6512:b03:b0:52c:8a39:83d7 with SMTP id
 2adb3069b0e04-530ee9f549dmr1187453e87.52.1723210174761; Fri, 09 Aug 2024
 06:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807154943.150540-2-ajones@ventanamicro.com>
In-Reply-To: <20240807154943.150540-2-ajones@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 9 Aug 2024 18:59:23 +0530
Message-ID: <CAK9=C2Wxk8gDq-2jct47OOO4eK634nDUUGE8NdDrd88_s8_W4g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix sbiret init before forwarding to userspace
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, anup@brainfault.org, atishp@atishpatra.org, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 9:19=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> When forwarding SBI calls to userspace ensure sbiret.error is
> initialized to SBI_ERR_NOT_SUPPORTED first, in case userspace
> neglects to set it to anything. If userspace neglects it then we
> can't be sure it did anything else either, so we just report it
> didn't do or try anything. Just init sbiret.value to zero, which is
> the preferred value to return when nothing special is specified.
>
> KVM was already initializing both sbiret.error and sbiret.value, but
> the values used appear to come from a copy+paste of the __sbi_ecall()
> implementation, i.e. a0 and a1, which don't apply prior to the call
> being executed, nor at all when forwarding to userspace.
>
> Fixes: dea8ee31a039 ("RISC-V: KVM: Add SBI v0.1 support")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Queued this patch for Linux-6.11 fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 62f409d4176e..7de128be8db9 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -127,8 +127,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
>         run->riscv_sbi.args[3] =3D cp->a3;
>         run->riscv_sbi.args[4] =3D cp->a4;
>         run->riscv_sbi.args[5] =3D cp->a5;
> -       run->riscv_sbi.ret[0] =3D cp->a0;
> -       run->riscv_sbi.ret[1] =3D cp->a1;
> +       run->riscv_sbi.ret[0] =3D SBI_ERR_NOT_SUPPORTED;
> +       run->riscv_sbi.ret[1] =3D 0;
>  }
>
>  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
> --
> 2.45.2
>
>

