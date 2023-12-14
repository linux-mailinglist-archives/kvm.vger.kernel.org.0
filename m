Return-Path: <kvm+bounces-4473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D43A7812FD7
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 790FD1F22730
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775B241774;
	Thu, 14 Dec 2023 12:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ZPgGIYmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4726810F
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:13:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso6794478a12.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702556001; x=1703160801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxoH3e1pqfRG5EpbAAgxwCw1oRjLeMfi1qyzwQu8z4E=;
        b=ZPgGIYmcWPNimFXItEwd7PxKG6mCBrxpr8rzWObBC5fI9MwAH9tvcN6Yrdao1FOCc9
         nYc7iElwrvB07IA2UV1c7TYI3BuSY5mvJrABPAdS5wSA0WbpFdReu5RfQhJrKSiOB238
         9WG/bJ+Fn4OiYfPk/fD0m2OKv2kjMmCLQAuEskYsVa0N6vCn8mfh+xtU1m4SIYTA3PZn
         yogxhp2FCgQWBejmxldXRgLEAhJQTuqP7XNaqUVCyYnCW9n/XF8ncGUjkbrYn6LBQ1me
         7BMdwVnL1uOe0YyhJuTdRtWhmVE90wn50ndrMk7QJGCrNIov0+VvH0C02ol/xwwRbpoO
         GQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702556001; x=1703160801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxoH3e1pqfRG5EpbAAgxwCw1oRjLeMfi1qyzwQu8z4E=;
        b=Hkn/LCquU6TwXO71Awj+AzLO5Po7urTPYATgZqay4rUsw2Ys0WdLHgiGcrgJubfew6
         ao+tkUAwrGXKTMYyqFwfRwr7QFI2HLNVmQxKI7pU3Rdt2F36xmSR4h64YvcISYrb/3wj
         /0uhiQJeC5NsWDqw0nNuWHu8yFYWWGH9aAiBt5EhWcdLGUuBAqO5+gcRXfT/HSz2+ul5
         Qs6ABm2LlN2lxyB3bCEhGb8u9q37DrNwvw+qCyDnSJ+/E0LGls0MoLHr7crVQlQODY3E
         tmyaO/Eu/MyOJTJ1oESEvYLiOsNddsTJpf6aEWhfe56CFt+Ea7M7ziJDDbqH/Yf5Pb5z
         3E8g==
X-Gm-Message-State: AOJu0YzzGZT7EAZiY4SNRIlkti1XjLrrwX5IAbn1d2rgF4FlXzkJa/PT
	MVscAitdC9u7QzcPjnxy/eqIVlhNrLJEKgaZlcze32NNHq9PKR4hyKk=
X-Google-Smtp-Source: AGHT+IEooiD5rkngFLDpel3wTKhmmCpJGezIc1l7FQ/uXS5019jlAjf7Ozjts7D2t9f+t/Nftwhsc5T2VEWM2r0TPEI=
X-Received: by 2002:a17:90a:ae0d:b0:286:9b69:a0f6 with SMTP id
 t13-20020a17090aae0d00b002869b69a0f6mr7104084pjq.39.1702556000638; Thu, 14
 Dec 2023 04:13:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-2-atishp@rivosinc.com>
In-Reply-To: <20231205024310.1593100-2-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 17:43:09 +0530
Message-ID: <CAAhSdy0j=BKfoNFr2+P+z0YK29LkudpHQ5XQUZhY_F1mfWQAug@mail.gmail.com>
Subject: Re: [RFC 1/9] RISC-V: Fix the typo in Scountovf CSR name
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 8:13=E2=80=AFAM Atish Patra <atishp@rivosinc.com> wr=
ote:
>
> The counter overflow CSR name is "scountovf" not "sscountovf".
>
> Fix the csr name.
>
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/csr.h         | 2 +-
>  arch/riscv/include/asm/errata_list.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 306a19a5509c..88cdc8a3e654 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -281,7 +281,7 @@
>  #define CSR_HPMCOUNTER30H      0xc9e
>  #define CSR_HPMCOUNTER31H      0xc9f
>
> -#define CSR_SSCOUNTOVF         0xda0
> +#define CSR_SCOUNTOVF          0xda0
>
>  #define CSR_SSTATUS            0x100
>  #define CSR_SIE                        0x104
> diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/as=
m/errata_list.h
> index 83ed25e43553..7026fba12eeb 100644
> --- a/arch/riscv/include/asm/errata_list.h
> +++ b/arch/riscv/include/asm/errata_list.h
> @@ -152,7 +152,7 @@ asm volatile(ALTERNATIVE_2(                          =
               \
>
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)                                    \
>  asm volatile(ALTERNATIVE(                                              \
> -       "csrr %0, " __stringify(CSR_SSCOUNTOVF),                        \
> +       "csrr %0, " __stringify(CSR_SCOUNTOVF),                         \
>         "csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),             \
>                 THEAD_VENDOR_ID, ERRATA_THEAD_PMU,                      \
>                 CONFIG_ERRATA_THEAD_PMU)                                \
> --
> 2.34.1
>

