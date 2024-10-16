Return-Path: <kvm+bounces-29034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B1A9A14EE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2A001F23D5A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18AE11D2F6E;
	Wed, 16 Oct 2024 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="ne1h/poO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E21D2B0E
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729114777; cv=none; b=kE4zyMu5iZYGOgR4iILMZadjY+l01AiveMgXUL7DHT0UFZMVT17ZBP4NxUHL+Bn4xoC6oypB3eosCbPSWh/eQhdk7o49lzWhSzKkfyQHKG/TCEw+/ESd2CHnaxmM7zhqVTYKmF5IhYql0EllzfBJRhwNe1MfqIt4NkTlPOmYhV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729114777; c=relaxed/simple;
	bh=VKoJF2wAux6Ijj2yS1b73ggopyQUstk7miqBG6XFbgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ajzR7R5h1WcxKOT40mXDp14XVl7QGtwwvGMvxHzTniez9cmWQt2TS9BPqdSX1ZO4ndjtU38eUS5xigjqtoNXI0wltj+HcjMuKYBYnPEuQXl45j89g+BCYQXTOEj1H2JpCdv1hBWqUgvOC1enaOEsJC7oo2bYxEGfpkGIKOpnX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=ne1h/poO; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539eb97f26aso309594e87.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 14:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729114774; x=1729719574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6H8Y7/ZzORONU1hyN/i6yVrHJ4H/bODv43/WrBP0n1k=;
        b=ne1h/poO3Cefk71q9TpgGtshVM/2SXVfaPyHAokj9YzKR59V2lhqPVxeTx1FZQTSk+
         k9Kxo0rtzmV+XK7nwIdfnMXTVEWXGZhL4MljsKAnMa3efMFxhYYA3zfBYB09fTQai5Nd
         n7E99w6GPfL7tCkpFj+CgyIr5/htHL/QX9o6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729114774; x=1729719574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6H8Y7/ZzORONU1hyN/i6yVrHJ4H/bODv43/WrBP0n1k=;
        b=vuqujp8RbG5onCiJ0v7natztmjhjwK0xZZeTfiEi0OGW7+mVzvxsfDxWJ2R+O2KGQc
         TXasEPs4VbejUiRVxf4MGEpNMGylb4KHp9ORP31t6JzLPQmrLT+YLjpPcXuiEjkmjVaD
         dQ9pAXXpkcnB+a8RxPZcIQAYnDZtjS3lvlpGFEerBaqc8u37YDAmpfJVFdgMpRwWm8di
         BEOnBVbDMxE1qWHkNIUbj0syPTSUqK/18X5DZ3Vq6Ssm3kwwAPcoOeNPzdSFjBP4h6w8
         aMj62xpGbkdnpk9aO5Mu2ReaKIurw8Ncj6BYQ5yOQDB5udxXNaBMlbGJxTcquCQ7ndhO
         oIfw==
X-Forwarded-Encrypted: i=1; AJvYcCWs4OmBJiVn5/CsGF2NyFpmTFNI1UpQZj3tLKFGo1/uhlpC03CGDCNS7p/wgVW7u6CBKZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwjgnKyLM+HRJEmRc3yLFg4TeCvVk6VLMIzfePN35rqwfS8SaJ
	N9X4wMB7VCZqWU5RbmSdanaPWxxp4WvwCNs2Fg1qffDJzBGd6c8j+59CsoI07Iqpd+fpXImlvQh
	eFbpm/6UrDneuVjnJY30zJfMi9ensB6s9bnjR
X-Google-Smtp-Source: AGHT+IFPP+peTAUAy0oiDSlqRo1dFfekSIv/GJho/24l6zoVqW/NQcaXYqDCBv05acUPzYaLU4twAhJ7d34uSv62lyk=
X-Received: by 2002:a05:6512:ad6:b0:539:ff5a:7ea5 with SMTP id
 2adb3069b0e04-539ff5a8042mr4811318e87.15.1729114773775; Wed, 16 Oct 2024
 14:39:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-6-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-6-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Wed, 16 Oct 2024 14:39:22 -0700
Message-ID: <CAOnJCUKD_LFrzr+KN=F1mZ3=eJqw73XjrkhVDt=7W6=eEo=4Pg@mail.gmail.com>
Subject: Re: [PATCH 05/13] RISC-V: KVM: Replace aia_set_hvictl() with aia_hvictl_value()
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> The aia_set_hvictl() internally writes the HVICTL CSR which makes
> it difficult optimize the CSR write using SBI NACL extension for
> kvm_riscv_vcpu_aia_update_hvip() function so replace aia_set_hvictl()
> with new aia_hvictl_value() which only computes the HVICTL value.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/aia.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 2967d305c442..17ae4a7c0e94 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -51,7 +51,7 @@ static int aia_find_hgei(struct kvm_vcpu *owner)
>         return hgei;
>  }
>
> -static void aia_set_hvictl(bool ext_irq_pending)
> +static inline unsigned long aia_hvictl_value(bool ext_irq_pending)
>  {
>         unsigned long hvictl;
>
> @@ -62,7 +62,7 @@ static void aia_set_hvictl(bool ext_irq_pending)
>
>         hvictl =3D (IRQ_S_EXT << HVICTL_IID_SHIFT) & HVICTL_IID;
>         hvictl |=3D ext_irq_pending;
> -       csr_write(CSR_HVICTL, hvictl);
> +       return hvictl;
>  }
>
>  #ifdef CONFIG_32BIT
> @@ -130,7 +130,7 @@ void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *=
vcpu)
>  #ifdef CONFIG_32BIT
>         csr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
>  #endif
> -       aia_set_hvictl(!!(csr->hvip & BIT(IRQ_VS_EXT)));
> +       csr_write(CSR_HVICTL, aia_hvictl_value(!!(csr->hvip & BIT(IRQ_VS_=
EXT))));
>  }
>
>  void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
> @@ -536,7 +536,7 @@ void kvm_riscv_aia_enable(void)
>         if (!kvm_riscv_aia_available())
>                 return;
>
> -       aia_set_hvictl(false);
> +       csr_write(CSR_HVICTL, aia_hvictl_value(false));
>         csr_write(CSR_HVIPRIO1, 0x0);
>         csr_write(CSR_HVIPRIO2, 0x0);
>  #ifdef CONFIG_32BIT
> @@ -572,7 +572,7 @@ void kvm_riscv_aia_disable(void)
>         csr_clear(CSR_HIE, BIT(IRQ_S_GEXT));
>         disable_percpu_irq(hgei_parent_irq);
>
> -       aia_set_hvictl(false);
> +       csr_write(CSR_HVICTL, aia_hvictl_value(false));
>
>         raw_spin_lock_irqsave(&hgctrl->lock, flags);
>
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish

