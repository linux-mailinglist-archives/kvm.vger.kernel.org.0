Return-Path: <kvm+bounces-52845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FA8B09A74
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D38F317E5D3
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D861DE2C2;
	Fri, 18 Jul 2025 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U41mU38G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E879CD;
	Fri, 18 Jul 2025 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752812040; cv=none; b=EDNuNpLOTul92AASW2Lz1GgX4jjuPGEOvgBZdZI/jp7UokKLoH/55x1H3qiAzeEpe+r3eQTInXWtape0ogaWh0GMQE9gj3ASRDmZPYcX9hEdOmdSE8x1qn6mKLjLz/4cdHZi6s7u2Sp3NsNXrXxo7qL3uGZvT12Po1T0T8u/7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752812040; c=relaxed/simple;
	bh=DHnTfajQCSjlkvREjbmaEy/d/ta4Wp+DnSYxZJdnYw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5OqKG6P9IwlWdEjlcGrlxcmB2mb5a2dJ4MhgBgEpyAx4bnuPZSGCbWWhHHlSQN38SIUEQaJOCJKg91700UQjcL9t6lhGTUnsiOEFamjO3NMn8lQwgaD/sLrnqswAplXAcSFLKfgoqkGw3HLQwIbq0TskBMPtXC9RajOxGaTvco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U41mU38G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFACC4CEF0;
	Fri, 18 Jul 2025 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752812039;
	bh=DHnTfajQCSjlkvREjbmaEy/d/ta4Wp+DnSYxZJdnYw0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U41mU38GA+VlBtnajAa35+hqG/tyMnmjIW1Fe7CKJZ9YtVJ4V9MLHgZLerv/Xz8c/
	 ZE0wEqeSVCug0Lt4EMgtWffwOrelHEsY7utriP9bseQAP5YkwDSbN9PVM65PGpzqr8
	 RUKWdQL1o9/Bi6wB+/2pEyhqlmob/WcbqD2lc/5Ad9rb1hgv7c6zgUxf08cOJGggyo
	 NIL2nps5Z22BC28+W3jrwl6lfxmVKWQh8/Hp0EzUeM+uUy0u65amlnCBS7IYlJwXz2
	 8dgbDyecqJwKu3xG0gt6G6SlboSHbtxEw5GsVUlWu6hc1IHCJB5FPJtagp3kupFq/r
	 xxyEzySLUtFcw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60c5b8ee2d9so3378435a12.2;
        Thu, 17 Jul 2025 21:13:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCjvWq/tNSP3sXH+kT6c5p0JXCsb1TccFfCMD/GKjBlf2IjK7HhY8yGFEpymAafhJDTKc=@vger.kernel.org, AJvYcCWnXqT+BSJJEPe2uKTBMNerlUDIoGODZ9wd2qULOdSP1QuKPx6fgV5beB4nrvVFk2D1CAWDV3Rdp6UYLvU8@vger.kernel.org
X-Gm-Message-State: AOJu0YyepPnUoDocJ9TGE/8E2gFaod4HaZ3PJtWC5NlU66tMm/gtdCVU
	Jshlp5jLJ6NEabvgxP520XJ09FkfGcLGRk5azqGMSCqg/BBvWlb2oJg38J9NTkYYLztF9X/GLBp
	9IcwZKAWN6u+CAFi9PLGLjBLT4Q+lGcE=
X-Google-Smtp-Source: AGHT+IEAC/CrykqlVUov+EJ/y6QUARM5tA1ycLqUcm4EWLS9EBEJLRu/mhAQR5yZ9JZRh3AJjQcI43NahP6URex6JzI=
X-Received: by 2002:a17:907:7e81:b0:aec:4aa6:7800 with SMTP id
 a640c23a62f3a-aec4aa6a010mr634285766b.20.1752812038366; Thu, 17 Jul 2025
 21:13:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716165929.22386-1-yury.norov@gmail.com> <20250716165929.22386-3-yury.norov@gmail.com>
In-Reply-To: <20250716165929.22386-3-yury.norov@gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 18 Jul 2025 12:13:46 +0800
X-Gmail-Original-Message-ID: <CAAhV-H729+VA4fAWX1SOhCAptSDSwLDAOp_RwB0hkDtvm0hMLg@mail.gmail.com>
X-Gm-Features: Ac12FXx3hfpaLFwE6RdiI6R7mON-t5449W1RiBy40PMWcdfNUzWxzQG1L7EcO_o
Message-ID: <CAAhV-H729+VA4fAWX1SOhCAptSDSwLDAOp_RwB0hkDtvm0hMLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] LoongArch: KVM:: simplify kvm_deliver_intr()
To: Yury Norov <yury.norov@gmail.com>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Yury,

On Thu, Jul 17, 2025 at 12:59=E2=80=AFAM Yury Norov <yury.norov@gmail.com> =
wrote:
>
> From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
>
> The function opencodes for_each_set_bit() macro, which makes it bulky.
> Using the proper API makes all the housekeeping code going away.
>
> Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> ---
>  arch/loongarch/kvm/interrupt.c | 25 ++++---------------------
>  1 file changed, 4 insertions(+), 21 deletions(-)
>
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrup=
t.c
> index 4c3f22de4b40..8462083f0301 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -83,28 +83,11 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
>         unsigned long *pending =3D &vcpu->arch.irq_pending;
>         unsigned long *pending_clr =3D &vcpu->arch.irq_clear;
>
> -       if (!(*pending) && !(*pending_clr))
> -               return;
Is it necessary to keep these two lines?

Huacai

> -
> -       if (*pending_clr) {
> -               priority =3D __ffs(*pending_clr);
> -               while (priority <=3D INT_IPI) {
> -                       kvm_irq_clear(vcpu, priority);
> -                       priority =3D find_next_bit(pending_clr,
> -                                       BITS_PER_BYTE * sizeof(*pending_c=
lr),
> -                                       priority + 1);
> -               }
> -       }
> +       for_each_set_bit(priority, pending_clr, INT_IPI + 1)
> +               kvm_irq_clear(vcpu, priority);
>
> -       if (*pending) {
> -               priority =3D __ffs(*pending);
> -               while (priority <=3D INT_IPI) {
> -                       kvm_irq_deliver(vcpu, priority);
> -                       priority =3D find_next_bit(pending,
> -                                       BITS_PER_BYTE * sizeof(*pending),
> -                                       priority + 1);
> -               }
> -       }
> +       for_each_set_bit(priority, pending, INT_IPI + 1)
> +               kvm_irq_deliver(vcpu, priority);
>  }
>
>  int kvm_pending_timer(struct kvm_vcpu *vcpu)
> --
> 2.43.0
>
>

