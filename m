Return-Path: <kvm+bounces-29032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E98B9A14E2
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51C691C22688
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FBD1D2F61;
	Wed, 16 Oct 2024 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="tBfYQYKc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FB91865E2
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729114623; cv=none; b=lMlR+y+rioC3GvNXo/Ein7QZ2vi7nP0nrniovh60zqSBQpxt5OUzK1iRXnggB2+aZb5vKUOWQa39wnQADg1Cqv2j5X3kJzN5zyXFiTsYZ4LfXKdifxqMudJPgPOUFzJF8dCXkiGAE9y0UR+R4aDN53EcD8RYBTWUaVrZWsikKj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729114623; c=relaxed/simple;
	bh=iN8JH5XHMrDttQd/FuXK13OhyOLPTNT7siHNd0XZ9p4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gPKc7tifadvii7sttEjGt1TWfo30vygIXpDrR9T4CYFkk5Y29Yxxa2fe2Ib0EWupeVvYe9UxUBfGyNC3k0INTkhuJeNuzxwD5cWxyBb4l8roWSCuDGgo2ELEBBKsV2VknABhgNdMKXbs5YHjSewAmL5nuSjvM4ul+2htAcBQR94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=tBfYQYKc; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f4d8ef84so314826e87.0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 14:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729114618; x=1729719418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzevpsck3dJoJhpaLAHlTvmXlx+875anP82T3kvIZwQ=;
        b=tBfYQYKc0KOPatrkQvIsGSGK2ep90UxDN7WgpaRQgJKM4DrHJxk+4g0hhndhMYY3pp
         eZ3HpqcodO8JBAglf2CkPiEKHsdDDTiYW2WINvVaQm1mi0wB9dLNvKWQLO5PacqutxEP
         a/av17RyN9xzTa1XR064zXstzyVeq9gROhNRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729114618; x=1729719418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzevpsck3dJoJhpaLAHlTvmXlx+875anP82T3kvIZwQ=;
        b=HPKFi1cQ1MScGCi++i7PBEjOTCxY4qt5DNMXUcUYe/RNbejTIxlsW4nG2ndqsVsFps
         s7kzFDNtSJVq0ZgqZFXxdHvUkX7BfEhEhbhE6sEQtFiTXyKXEinOXRuTVUg3qKZaQwMZ
         fdxpEH3uikL5393ztUupZTaOOpE084ScQdLekRSR8uxCg9ZCczs9RUaIHiHb/YcT7iJS
         bcfxcUxT4peRH7JxWSzYisXROYS/lpt6hkKGdKmPur1kH5Vhd0Wq8fgPWNTyZioJZzZu
         Ct7HlIOHWlZvmFRfBBuHqwrgEhlK57eX9E61pabFRH4F8eLcPae2taSpkZ51AnPrNCBM
         WxNA==
X-Forwarded-Encrypted: i=1; AJvYcCUFOUbnooOOBkAA+ncd+ASm0C/sfUWeQdYuSFSWEkOFSqBO0hjk7Zf/6RuwRvyL1wmvoi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXqBgDImHtkxSPdNSvpCTBIE3jXWUFBT4b07xdVJxNGyhBh4RT
	sdO6au/XFAwqX064aRegnIEww6wwesAvS9DMV77BdbAvoPN9I4kR/ZuujmH80lDqVy65F7qPFv2
	tgdwWcmKj11/DX/Rg6ltky+tBkD65ywGPZCA8dV/h704FWTY=
X-Google-Smtp-Source: AGHT+IE1H4Vh/DlQoBbaP9HRN6riUp4Ff1MfsEWkMbRb+vmeg9cRWkPijr7gnhfFeB7b6BVoGnjUIALJ+uIMkqdeJoY=
X-Received: by 2002:a05:6512:1044:b0:530:ae4a:58d0 with SMTP id
 2adb3069b0e04-539da3c1d9bmr9797869e87.8.1729114617980; Wed, 16 Oct 2024
 14:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-4-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-4-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Wed, 16 Oct 2024 14:36:46 -0700
Message-ID: <CAOnJCUKMf4a0KQaiK5g8nAngqCKFtbnc38kQVu_nMb9ujwif1g@mail.gmail.com>
Subject: Re: [PATCH 03/13] RISC-V: KVM: Save/restore SCOUNTEREN in C source
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
> The SCOUNTEREN CSR need not be saved/restored in the low-level
> __kvm_riscv_switch_to() function hence move the SCOUNTEREN CSR
> save/restore to the kvm_riscv_vcpu_swap_in_guest_state() and
> kvm_riscv_vcpu_swap_in_host_state() functions in C sources.
>
> Also, re-arrange the CSR save/restore and related GPR usage in
> the low-level __kvm_riscv_switch_to() low-level function.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c        |  2 ++
>  arch/riscv/kvm/vcpu_switch.S | 52 +++++++++++++++---------------------
>  2 files changed, 23 insertions(+), 31 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 93b1ce043482..957e1a5e081b 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -691,6 +691,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_gu=
est_state(struct kvm_vcpu *
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>         struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
>
> +       vcpu->arch.host_scounteren =3D csr_swap(CSR_SCOUNTEREN, csr->scou=
nteren);
>         vcpu->arch.host_senvcfg =3D csr_swap(CSR_SENVCFG, csr->senvcfg);
>         if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN) &&
>             (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
> @@ -704,6 +705,7 @@ static __always_inline void kvm_riscv_vcpu_swap_in_ho=
st_state(struct kvm_vcpu *v
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>         struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
>
> +       csr->scounteren =3D csr_swap(CSR_SCOUNTEREN, vcpu->arch.host_scou=
nteren);
>         csr->senvcfg =3D csr_swap(CSR_SENVCFG, vcpu->arch.host_senvcfg);
>         if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN) &&
>             (cfg->hstateen0 & SMSTATEEN0_SSTATEEN0))
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index f83643c4fdb9..3f8cbc21a644 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -43,30 +43,25 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>
>         /* Load Guest CSR values */
>         REG_L   t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
> -       REG_L   t1, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -       la      t3, .Lkvm_switch_return
> -       REG_L   t4, (KVM_ARCH_GUEST_SEPC)(a0)
> +       la      t1, .Lkvm_switch_return
> +       REG_L   t2, (KVM_ARCH_GUEST_SEPC)(a0)
>
>         /* Save Host and Restore Guest SSTATUS */
>         csrrw   t0, CSR_SSTATUS, t0
>
> -       /* Save Host and Restore Guest SCOUNTEREN */
> -       csrrw   t1, CSR_SCOUNTEREN, t1
> -
>         /* Save Host STVEC and change it to return path */
> -       csrrw   t3, CSR_STVEC, t3
> -
> -       /* Save Host SSCRATCH and change it to struct kvm_vcpu_arch point=
er */
> -       csrrw   t2, CSR_SSCRATCH, a0
> +       csrrw   t1, CSR_STVEC, t1
>
>         /* Restore Guest SEPC */
> -       csrw    CSR_SEPC, t4
> +       csrw    CSR_SEPC, t2
> +
> +       /* Save Host SSCRATCH and change it to struct kvm_vcpu_arch point=
er */
> +       csrrw   t3, CSR_SSCRATCH, a0
>
>         /* Store Host CSR values */
>         REG_S   t0, (KVM_ARCH_HOST_SSTATUS)(a0)
> -       REG_S   t1, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> -       REG_S   t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> -       REG_S   t3, (KVM_ARCH_HOST_STVEC)(a0)
> +       REG_S   t1, (KVM_ARCH_HOST_STVEC)(a0)
> +       REG_S   t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
>
>         /* Restore Guest GPRs (except A0) */
>         REG_L   ra, (KVM_ARCH_GUEST_RA)(a0)
> @@ -145,31 +140,26 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_S   t6, (KVM_ARCH_GUEST_T6)(a0)
>
>         /* Load Host CSR values */
> -       REG_L   t1, (KVM_ARCH_HOST_STVEC)(a0)
> -       REG_L   t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> -       REG_L   t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> -       REG_L   t4, (KVM_ARCH_HOST_SSTATUS)(a0)
> -
> -       /* Save Guest SEPC */
> -       csrr    t0, CSR_SEPC
> +       REG_L   t0, (KVM_ARCH_HOST_STVEC)(a0)
> +       REG_L   t1, (KVM_ARCH_HOST_SSCRATCH)(a0)
> +       REG_L   t2, (KVM_ARCH_HOST_SSTATUS)(a0)
>
>         /* Save Guest A0 and Restore Host SSCRATCH */
> -       csrrw   t2, CSR_SSCRATCH, t2
> +       csrrw   t1, CSR_SSCRATCH, t1
>
> -       /* Restore Host STVEC */
> -       csrw    CSR_STVEC, t1
> +       /* Save Guest SEPC */
> +       csrr    t3, CSR_SEPC
>
> -       /* Save Guest and Restore Host SCOUNTEREN */
> -       csrrw   t3, CSR_SCOUNTEREN, t3
> +       /* Restore Host STVEC */
> +       csrw    CSR_STVEC, t0
>
>         /* Save Guest and Restore Host SSTATUS */
> -       csrrw   t4, CSR_SSTATUS, t4
> +       csrrw   t2, CSR_SSTATUS, t2
>
>         /* Store Guest CSR values */
> -       REG_S   t0, (KVM_ARCH_GUEST_SEPC)(a0)
> -       REG_S   t2, (KVM_ARCH_GUEST_A0)(a0)
> -       REG_S   t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -       REG_S   t4, (KVM_ARCH_GUEST_SSTATUS)(a0)
> +       REG_S   t1, (KVM_ARCH_GUEST_A0)(a0)
> +       REG_S   t2, (KVM_ARCH_GUEST_SSTATUS)(a0)
> +       REG_S   t3, (KVM_ARCH_GUEST_SEPC)(a0)
>
>         /* Restore Host GPRs (except A0 and T0-T6) */
>         REG_L   ra, (KVM_ARCH_HOST_RA)(a0)
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish

