Return-Path: <kvm+bounces-46490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5312AB693F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DAD83A82B6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2DB2741BD;
	Wed, 14 May 2025 10:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="izzjTcC/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78F46426
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 10:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220128; cv=none; b=nyf539QuSes0BDsoo3i16Zf1P4kB+chtvyf/c8VRHHqMwP/Wf5d43acfo6x8YXeF2KoCAJe0KPp7x9frCLbowsdp0/celwzqGYzx+o8v3jR7KQBQ7UDnuWlyJ5RkGJbCWaqWK5ZAg0PY+h7as+Rm8o1iichb+XGiYkTXIJhmtd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220128; c=relaxed/simple;
	bh=Wz9I9xC4F27JXB+jiXgRktQ8fB8iSJ26dOapb8gTGWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h4hQ8ykipvv1ACs7ivPCps1LZwQL2xFw81bza/JALpuaBh70BOt5pO92QN8MrF0rAH129Z6uVHjiLRyVruxAtF+DgESZ6wvR6uz8cSF1L2nf8A4uXgsHy0nTEQdHf2nk3crEcFTPqNN4uYeOPicpcVM9vG6zV3cqWX72Ad42qLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=izzjTcC/; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d8020ba858so71956695ab.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 03:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747220124; x=1747824924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRXF9DYELCFr5DWcRHF2au4ZCt3rEGvlc0W9vQ4Jvt0=;
        b=izzjTcC/LTj6htqYkDqTLqrJQ7iJ4FRsB5avH+7QVoi7Wr/eg7ydZC9IVwq2JfbCmC
         uRYbORPRdXFL1PeesKTqq7afkpaD2UZGCK7h62aFtcDYW/Hk7XLejB9Wv91lgxR/ZLj5
         mFnt1lMHLEJdGa3bCzMz60llxLqvqX6ndKdhy+erC64Q02U0qQrHczMUEQ9M5Ppg9u2F
         YB6SeYwjuIAhOGf2RIM7zjVH6tTT1Q7Vx3qKWMsJVJ0S5YFfWJQcjlAnbwI6uUoeNuXJ
         rXyuZ/jBdTHIrYhA5yypnWlz/rlsHXIaYjTjRHXazlH2uGT/vNoyAOmOE9hxLg10NZij
         v8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747220124; x=1747824924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRXF9DYELCFr5DWcRHF2au4ZCt3rEGvlc0W9vQ4Jvt0=;
        b=fi2rE3TjEvp/GP9du4Sm0EiyH/15OguPdYxyJzWvNg+Pmny2jvxP25m0p88eYdYDRe
         njcfKfFBkqyDAsG5BKjU47SX40IBCxC6mDm3Ol3GOi7tFxlVlXLDzC0AC39ZfMyhuaGt
         DfGUQMDjYCo287O2088GIDBrUonmT6yAqHNEALRr8/I9v+Mglev9MsbBoiwKQ1Y09m4f
         FPD8hnAKraJ1bkdDDsWX1w1HooMFu4OJ4F96TIKnIB7XosJOtKo7HjTqBzg4rnkZhsUf
         vYDV1kZaPxeAyJ6rxw6a1MEznrih55pXnLB1EEEdNcY1KGgOkWkHRr91PV6tD6iWGjOH
         f0kw==
X-Forwarded-Encrypted: i=1; AJvYcCVMxLuPeBUm7sruK2r97v/HakpHNI1RafGjCD+GYQCC0aQpH4E0o5xGNsOrLAnNE/yr6m0=@vger.kernel.org
X-Gm-Message-State: AOJu0YztkggoIRqNj7H1ghsccPP55xmtjLGvK6GIslV8bZjSadkbyorP
	IHaDOAoEfctJRWsKZMMXitzML5dEc4fz/3Z+W3SLICA7Apsyq4zhX2+FCqMme4AuNh66/uFBB6E
	3xJ38EWOUWrHsJMlYI2dkNhh11GwRTv+3Cgblog==
X-Gm-Gg: ASbGncvmhmEB6NWNMX3KGuhVt3nYIXjZpZ1v2cq8GiyVVMs7Nk8qNWTKJX1SpSi6mxL
	lP7hxLe36+FObMxLAnFips1I/U4j5NuBBn/JxnJ4A3ZeFQSGwq/TvOk9yI8KK/l9EtTNI35c5Xv
	Z18V78RULnjXed7lCpBdDKnGRbQlOpQwu1KJ6SSz6XmnA3
X-Google-Smtp-Source: AGHT+IEsUcIqOtDh4qY84VrR7dhWsUpg7gwW9C2txJWoPP6k/tpHi1CvIf0OsIfE3p0Zr1XdgR25bvUfnZ7cRBd3PFw=
X-Received: by 2002:a05:6e02:198b:b0:3db:75b6:7624 with SMTP id
 e9e14a558f8ab-3db75b6780fmr2850135ab.11.1747220124329; Wed, 14 May 2025
 03:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com>
In-Reply-To: <20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 14 May 2025 16:25:12 +0530
X-Gm-Features: AX0GCFtIxlTWYfHTygNZSZFPokesN2cLhuuKOTpmwdkrTRv-yq2sET779gpzlaA
Message-ID: <CAAhSdy2LbLwRxuFVtMrrcTTD5NCxVCGLy4o=ZUowxT_9DXGqBA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Disable instret/cycle for VU mode by default
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 12:13=E2=80=AFPM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> The KVM virtualizes PMU in RISC-V and disables all counter access except
> TM bit by default vi hstateen CSR. There is no benefit in enabling CY/TM
> bits in scounteren for the guest user space as it can't be run without
> hcounteren anyways.
>
> Allow only TM bit which matches the hcounteren default setting.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 60d684c76c58..873593bfe610 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -146,8 +146,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
>                 return -ENOMEM;
>
> -       /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
> -       reset_csr->scounteren =3D 0x7;
> +       /* By default, only TM should be accessible in VU mode */
> +       reset_csr->scounteren =3D 0x2;

Let's remove this as well because the Linux SBI PMU driver
does initialize scounteren correctly.

Regards,
Anup

