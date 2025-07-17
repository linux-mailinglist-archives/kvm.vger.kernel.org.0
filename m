Return-Path: <kvm+bounces-52748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D43B9B0906D
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A99E585B18
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FA82F7D18;
	Thu, 17 Jul 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="l1bZu5xd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617032D661D
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765554; cv=none; b=PXV0VfSWpwQxNU5Hl11ZsWoHfuvQbGz0S2y9cKHoRxZUk0oA9LRpZo8Slh937OlOSpFfYZsbJSQt+9/POA5FlP9PhcQrsXxeBGUAgDdclU8e3MrPUFOwDAkNu2fi6F1yncxBJkKGZqKt28kgpsCTqw2cmDBDhtLMbcQoRmGf86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765554; c=relaxed/simple;
	bh=sEH8huyYpvNQfqn9VnitIqOJAs+4IuQO9XkijYeBhU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sby1WD5P38oX/CntOvFjT/P9IdLZvXiJUz1PUB7oorr6Xj7gP7f+lO7AzVti/izAUo0+5fhVg/Dmxy5k477TUBjHRInPQp/GvwREOGkJmkKtjSXYMzFm2G83jc9D/TwJHAXa3E3Lpg3LJDpvMJ5qOcQncu+BMUTtN9TWyxOzeOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=l1bZu5xd; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7d95b08634fso63005785a.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752765552; x=1753370352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5xUBrBCpzFPT/Ceifws++OIUGJp175GJMu2Bn4O4tU=;
        b=l1bZu5xdE6uWJs44259xRXhy10gnZRtWRoUxfxENA3CQ552uq/scQJyqpj9ccblpWy
         VgQKUgKIl2nrZlxCN36Ax6sirnNolTz4rkKjktVUJpumCDuJydj0YAxIdpY4kKGJiFOg
         U1arDbrsTrH8AGUSUfy0ZZwXCe+X333PEIzP7ojFAiyvuhHnoJ4LXHp7oXMmMh/OUvcJ
         OmE+kd1uh0IyAMiwOnmP0aju1y8u0agFvyfqp0E0AGmv/jtxQW0f2hhm+z0duxLHXXbK
         paDpCCiVOit2mLMZu/7DiPxm7ugojlEzWXyCuz0MaczLfTgOnkQRI1KOf6WzfDZC1wVN
         plZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765552; x=1753370352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5xUBrBCpzFPT/Ceifws++OIUGJp175GJMu2Bn4O4tU=;
        b=XFYLVfQfoAovXaKxISTGigAlpfXmkefW6LQ7YleSgaxW1KIA228+HjMuu7dWLps37L
         Z8EuaFHG0pTGO99nY9RWtOY8HELFWF7pQo48jYJ3iVyJQwQqrMsyz5clfdhLP2D7Hj3a
         nFodFLRo1rKl451A2Kbs3TyQBQVOkq0AboERaV5240sv1+ym1RHkK56NHUqbwU/Cx1ET
         1GlnNzyVE39LNcKUbO9s29x8ZdvL5yrWeQmf43zyx1ck6XxMJAh+gSrcb4H6lwdUVnNV
         vJFq7fqIcrF4bnlp85xeCdLqhYkELx+4ALxSTvJzN3hQVFbd6AbzcXJ2+7nQZPUlEXKM
         voXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwG6AjZf8rmmbBo8IE7GZN6mcP2J0rgtKcnuTCKY1ILzG5dq7qppe8hk5pkjgife++GCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWQEKlY2FhArUSqsIepngYFspo3CHCEvrt6Iat2T4YsAX5Nr7A
	X6pIHfoetA7nwt5YBSDy28mgw1cosVnqksBOiYYjwg3xEg91odo7E9rzsil0n2Xnl6Fxxh/KsJJ
	h2qrHzKHU5mrhNE6oltVm6ZZlvBpe4myGqwbIIIVxnQ==
X-Gm-Gg: ASbGncuEdFaRhs4USDiWj7PuLZi6Vh/lJJjphRBuScRQd0HTYlFtg+fMMhrdcDcwjji
	GuEWmGj6yeCUlK3kwAj56kXFCjP1dm2bkE/loRSOMVbJDIrsOCwOt2GrJTapFkJaKe4+LNBbvb9
	tJFLBI7BJgVtvMIeEVtSQeAOtKBXIOaMDag7EaZV6lnRE+Hhwg79FmoASQkcnkwyjCevoW2IBxo
	Z8qP/h1
X-Google-Smtp-Source: AGHT+IE3X2vck2pgSl2t6KFn5NgHq0p0Hh8fU3rZDbhsrXFgiaKsssOSMAr59vMNLRAJb0iXVxOVbhMl8sP6UXRX7pU=
X-Received: by 2002:a05:620a:1794:b0:7e3:320b:437 with SMTP id
 af79cd13be357-7e343351613mr1118889785a.1.1752765551906; Thu, 17 Jul 2025
 08:19:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-3-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-3-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 20:48:58 +0530
X-Gm-Features: Ac12FXyPbawu-s2Ss3H3yKP5ugd9T6IetcEyIWyv14Bbl9oa3EI2UsBfWrZcDw8
Message-ID: <CAAhSdy304FBYo-3TZyNhKqtDsUSnW+B=U3ktR5JHLr9+LLqXEg@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] RISC-V: KVM: Add support for Raw event v2
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 12:33=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> SBI v3.0 introuced a new raw event type v2 for wider mhpmeventX

s/introuced/introduced/

> programming. Add the support in kvm for that.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 78ac3216a54d..15d71a7b75ba 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -60,6 +60,7 @@ static u32 kvm_pmu_get_perf_event_type(unsigned long ei=
dx)
>                 type =3D PERF_TYPE_HW_CACHE;
>                 break;
>         case SBI_PMU_EVENT_TYPE_RAW:
> +       case SBI_PMU_EVENT_TYPE_RAW_V2:
>         case SBI_PMU_EVENT_TYPE_FW:
>                 type =3D PERF_TYPE_RAW;
>                 break;
> @@ -128,6 +129,9 @@ static u64 kvm_pmu_get_perf_event_config(unsigned lon=
g eidx, uint64_t evt_data)
>         case SBI_PMU_EVENT_TYPE_RAW:
>                 config =3D evt_data & RISCV_PMU_RAW_EVENT_MASK;
>                 break;
> +       case SBI_PMU_EVENT_TYPE_RAW_V2:
> +               config =3D evt_data & RISCV_PMU_RAW_EVENT_V2_MASK;
> +               break;
>         case SBI_PMU_EVENT_TYPE_FW:
>                 if (ecode < SBI_PMU_FW_MAX)
>                         config =3D (1ULL << 63) | ecode;
>
> --
> 2.43.0
>

Otherwise, it looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

