Return-Path: <kvm+bounces-66901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C67CEBBA9
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 10:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5924130274E1
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 09:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05075319617;
	Wed, 31 Dec 2025 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWg0A+fw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E21C84D0
	for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767175047; cv=none; b=nwAeP724abdMAhG5l4+GfsHib3dS4eMcMWYGdgprzErdTFwDCbCX9ycH7kVe+3eJtbtYWkhLU69K/jM0Q50Tls0mmkx7v+wHYgdau9BkyUXMpRP0bGsa3Ri5wQ3GE2TFRLMpcgTFPyGRa1/7wTMvgG2zPRl5Jq0ga6lll9uY3sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767175047; c=relaxed/simple;
	bh=XvxoJbk1n4B1oJqYc+bpz+GSlIINHD8bl2ATrnimr0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JiFq3DaJhhnQxm2J7E4Li7gRD/nMrJqY2nZpwCQFITU+R8qkE9btcDL4sHqOmK7/VTc6alg6vaslWWXjV8Ga4+lnqYzkexQoIFtcqle5AYc5g/M1erRD7kKKJK4H68k624jM78ik+uBUbZZQ/xMWaoRGbyyA4qPWCVTd9v/r0CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWg0A+fw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10388C113D0
	for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767175047;
	bh=XvxoJbk1n4B1oJqYc+bpz+GSlIINHD8bl2ATrnimr0E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cWg0A+fwAqLDO9LJjaGk+JnCdLCrEexDqxYbWVjda8mSn8pOXTm9CcfBe9TGWoWNz
	 c74ehg/Lir+uG2icmcjNP+g03Zit8Jo7sH/MEiT8nTXBwHW3qpfl2smpbWrqo3zr/p
	 BQIiOReRG1Xp8Dxpx7cldY0nZFut33ODWaeHZX36NDP2ZN0Ilcg/ORJvQPm3E5h4+0
	 pJ8VxhUuetO9f2hWBdDBv77Ffh8tQj51VFhEvB7XQYzN9j/fLZnvV+EW77Zwk95xDn
	 5MWhj8ua7BjqbMB0c9tJhlhlj0pj2uA64mJpIKIYI0t/mqInOARqoy7a9lxtWLIl+8
	 dNXaODEBySaEw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64e48264e56so5378600a12.1
        for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 01:57:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW1jeGJuG/pHG9HAD8/4eh9s+GXl6R3mfp9DEL7f/sslf82+bj5E52TjX6b8M2Yiy8eEUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzscZx+CsbwDWiifx2TAIEx4BxcprW5noBVSuhfsIOCDhFFJnBo
	pbs1cVm0whPFx8LagDOBSlNUdXfMGL2fKpORdWLs37Wb8BQOYLjq8zuBxte4ZSc1MWWkUGwr0hq
	so//CbJFcOwoJ/Tors/DyA5A0sK4aoZU=
X-Google-Smtp-Source: AGHT+IGFvAfQAolQJ2K+0/uCxaIU8otYl6h/fq5oX7O3pcXzWhQopfnVb02NugdZPQ/WGQxCpOFaXUbUOr6KUygbnYg=
X-Received: by 2002:a17:907:868e:b0:b76:4c8f:2cd8 with SMTP id
 a640c23a62f3a-b8037233e75mr3604962566b.55.1767175044185; Wed, 31 Dec 2025
 01:57:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231020227.1526779-1-maobibo@loongson.cn>
In-Reply-To: <20251231020227.1526779-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 31 Dec 2025 17:57:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4CU1Ct8ZcxpZcMEZy7uL-wPmkxVhJwEWQdy0rpBAo8fg@mail.gmail.com>
X-Gm-Features: AQt7F2pVX4avY4bk2RV3KDOYexQPEQMo7NMugvWE4Gz5dX2R9QHc-obzRmQeIYQ
Message-ID: <CAAhV-H4CU1Ct8ZcxpZcMEZy7uL-wPmkxVhJwEWQdy0rpBAo8fg@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Add more CPUCFG mask bit
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Dec 31, 2025 at 10:02=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With LA664 CPU there are more features supported which are indicated
> in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. These features do
> not depend on KVM and there is no KVM exception when it is used in
> VM mode.
>
> Here add more CPUCFG mask support with LA664 if VM is configured with
> host CPU model.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/loongarch.h |  7 +++++++
>  arch/loongarch/kvm/vcpu.c              | 11 +++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index e6b8ff61c8cc..553c4dc7a156 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -94,6 +94,12 @@
>  #define  CPUCFG2_LSPW                  BIT(21)
>  #define  CPUCFG2_LAM                   BIT(22)
>  #define  CPUCFG2_PTW                   BIT(24)
> +#define  CPUCFG2_FRECIPE               BIT(25)
> +#define  CPUCFG2_DIV32                 BIT(26)
> +#define  CPUCFG2_LAM_BH                        BIT(27)
> +#define  CPUCFG2_LAMCAS                        BIT(28)
> +#define  CPUCFG2_LLACQ_SCREL           BIT(29)
> +#define  CPUCFG2_SCQ                   BIT(30)
>
>  #define LOONGARCH_CPUCFG3              0x3
>  #define  CPUCFG3_CCDMA                 BIT(0)
> @@ -108,6 +114,7 @@
>  #define  CPUCFG3_SPW_HG_HF             BIT(11)
>  #define  CPUCFG3_RVA                   BIT(12)
>  #define  CPUCFG3_RVAMAX                        GENMASK(16, 13)
> +#define  CPUCFG3_DBAR_HINTS            BIT(17)
>  #define  CPUCFG3_ALDORDER_CAP          BIT(18) /* All address load order=
ed, capability */
>  #define  CPUCFG3_ASTORDER_CAP          BIT(19) /* All address store orde=
red, capability */
>  #define  CPUCFG3_ALDORDER_STA          BIT(20) /* All address load order=
ed, status */
I applied the first part because it both needed by KVM and George's patch:
https://lore.kernel.org/loongarch/20251231034523.47014-1-dongtai.guo@linux.=
dev/T/#u

Huacai

> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 656b954c1134..9d186004670c 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigne=
d int id, u64 val)
>
>  static int _kvm_get_cpucfg_mask(int id, u64 *v)
>  {
> +       unsigned int config;
> +
>         if (id < 0 || id >=3D KVM_MAX_CPUCFG_REGS)
>                 return -EINVAL;
>
> @@ -684,9 +686,18 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>                 if (cpu_has_ptw)
>                         *v |=3D CPUCFG2_PTW;
>
> +               /*
> +                * Some features depends on host and they are irrelative =
with
> +                * KVM hypervisor
> +                */
> +               config =3D read_cpucfg(LOONGARCH_CPUCFG2);
> +               *v |=3D config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCF=
G2_LAM_BH);
> +               *v |=3D config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | =
CPUCFG2_SCQ);
>                 return 0;
>         case LOONGARCH_CPUCFG3:
>                 *v =3D GENMASK(16, 0);
> +               config =3D read_cpucfg(LOONGARCH_CPUCFG3);
> +               *v |=3D config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDER_S=
TA);
>                 return 0;
>         case LOONGARCH_CPUCFG4:
>         case LOONGARCH_CPUCFG5:
>
> base-commit: dbf8fe85a16a33d6b6bd01f2bc606fc017771465
> --
> 2.39.3
>
>

