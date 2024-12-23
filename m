Return-Path: <kvm+bounces-34345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FAB09FAF61
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 15:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ACD216601A
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 14:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5F2190664;
	Mon, 23 Dec 2024 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KnqakzSg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764531401B
	for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 14:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734963576; cv=none; b=KX3vaKzEidL0iC5Nz6zmOigFLuwLm6M9+iF/mJdQ43frHC4xoywqiJ2ffTb81OSJyDQY4aEmLItz+dddqTvzs7q/0hJ9gljqv2TeTNi291divZ8hvTA66gyVf8pmRd0gHPmM750BQf2HZns6qlKU9yYJTgXIuLYLZZeM4hQIOUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734963576; c=relaxed/simple;
	bh=K8N6qBCFIPEGButK9dyl3JjJ5gO0M6G6yXLWv2w9dYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCkGs6eiFZCk8RoftT1/hpU9k9yMW7plt+1gNzDQs7DXugKl9gH+GpVpzcYbnmAQNBKbgd1ktRFgSUnSe4v8RKMcTJ7SzR8TrNseam26TA/lxHAo6VkvKwBueK2oNjR0JVJFQoDyWorFFkwAqVab7xhCFepbRHF8HfjJBHlpee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=KnqakzSg; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ad272538e8so19587025ab.1
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 06:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734963573; x=1735568373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlKsDcG265GLTRuHGNMMDIoHE87S0dQc7oUcHfSD0xo=;
        b=KnqakzSgxTxatxbVXVIhsRW5ZxVEnM90TMIkKjZCtWOsp4Pi/Y1W/+YPMFMRW6r8pr
         srIV1QurUw8bxFEddcOSm7bILs9U8Oz1Lfz3S24rTLZaIQshJxSiDG2RLof6TmvmmrX9
         86pDB18k2yFqvbkKOpxfwiK7Qed2ogvrCnWNsitjzQAFBs25P7tbfbLSd67bCAhUfXA5
         A6Myl/n7cXN2Rrikg2YoQ/qKvbZP8JI2aVXumw9EjovOvD48yDjpU3Qnq+il/wDb6HyC
         yN9sosAnIS3jGSPqmsDg/tMnd8yXwqOo/QIXYVE7OSUQdAD1xthHIgf4uNtGkR4FZ5kg
         dyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734963573; x=1735568373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlKsDcG265GLTRuHGNMMDIoHE87S0dQc7oUcHfSD0xo=;
        b=XgCVet7Rw5fCbAsyfP5osFGIHo5zVWxKrfSsCTWZDkLibd/kEGivN7FunToTXNKUhc
         hvg0CaLMujyy0C3kW4o8UzT+Qdzf2wgTr5p+tIK2btj7OX1A3fMtYzT6HY3KrvmB2ig+
         EV+rWEfkkZVimccTF3Oz/g9L+qBeweOgo+HlAZkkhX1NpcpBu273T4dpzoWPg8C6GhCr
         JkhHskY0nVi6FBkpbjqaj2s4s0b+qRumRlfumaJhJ44YSPlozPw0CDSZDbQBOB4gsb8w
         EMywZr/Nb8RaGt4IkzaMjji9YL6etGrqziBuUoqNw4Q0xHoocRsjvvD+CbWWrPBH+dvY
         hkog==
X-Forwarded-Encrypted: i=1; AJvYcCU0bx0S/Feg3Wt9DDYf8ncLcP6zjwTc8DjJDKFcWJR3qPA9Rq0sHc/8i6DV90sMK+i65K4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo2ZCOe0+9Uz/mSzO2f0j6OweRL+VXXGUqTq7B4X1+Xi647YXJ
	Vod1ac/mKgUamWq2JtkO5FFeSUnquimIyfy+wtKGHD6nvaNFf+SiqQ8nxh2vNLzSEyLXNRLb6BA
	2zXcerntVFEb1sF3o5bHLqFM41RwWyLlevyrdOw==
X-Gm-Gg: ASbGnctgjWcQDVH8VOEbFf1XhNsqXus2iOZqLMBAQdmgEsM+81+z77phuBZNFJkI7UU
	twkkXEaaJ4YOYlJceqw4knvAy/ftPDKjKol0FRUg=
X-Google-Smtp-Source: AGHT+IHT7JeacGaKf7+yPhFAeXWIA2+H/KV/q4bKowl5LHB+O1SpHIOeP9ZRh+8nxiuSwiyJGyjte+YTgeP6fBPIcQk=
X-Received: by 2002:a92:d703:0:b0:3ab:502c:b523 with SMTP id
 e9e14a558f8ab-3c02ceb2239mr110342355ab.4.1734963573524; Mon, 23 Dec 2024
 06:19:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com> <20241212-kvm_guest_stat-v1-3-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-3-d1a6d0c862d5@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 23 Dec 2024 19:49:22 +0530
X-Gm-Features: AbW1kvYLaTndzKv1CpNodLd28lS6Xhq_vsaRN7L1uynktu-VhkkNsDjLYzKvJF0
Message-ID: <CAAhSdy24K3pkOR25Rbcvw6pRWXrKXdy0CH9CLeG77EqQRZTDnQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] RISC-V: KVM: Add new exit statstics for redirected traps
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 2:27=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> Currently, kvm doesn't delegate the few traps such as misaligned
> load/store, illegal instruction and load/store access faults because it
> is not expected to occur in the guest very frequent. Thus, kvm gets a
> chance to act upon it or collect statstics about it before redirecting
> the traps to the guest.
>
> We can collect both guest and host visible statistics during the traps.
> Enable them so that both guest and host can collect the stats about
> them if required.

s/We can collect .../Collect .../

>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Otherwise, it looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h | 5 +++++
>  arch/riscv/kvm/vcpu.c             | 7 ++++++-
>  arch/riscv/kvm/vcpu_exit.c        | 5 +++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 35eab6e0f4ae..cc33e35cd628 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -87,6 +87,11 @@ struct kvm_vcpu_stat {
>         u64 csr_exit_kernel;
>         u64 signal_exits;
>         u64 exits;
> +       u64 instr_illegal_exits;
> +       u64 load_misaligned_exits;
> +       u64 store_misaligned_exits;
> +       u64 load_access_exits;
> +       u64 store_access_exits;
>  };
>
>  struct kvm_arch_memory_slot {
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e048dcc6e65e..60d684c76c58 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -34,7 +34,12 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D=
 {
>         STATS_DESC_COUNTER(VCPU, csr_exit_user),
>         STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
>         STATS_DESC_COUNTER(VCPU, signal_exits),
> -       STATS_DESC_COUNTER(VCPU, exits)
> +       STATS_DESC_COUNTER(VCPU, exits),
> +       STATS_DESC_COUNTER(VCPU, instr_illegal_exits),
> +       STATS_DESC_COUNTER(VCPU, load_misaligned_exits),
> +       STATS_DESC_COUNTER(VCPU, store_misaligned_exits),
> +       STATS_DESC_COUNTER(VCPU, load_access_exits),
> +       STATS_DESC_COUNTER(VCPU, store_access_exits),
>  };
>
>  const struct kvm_stats_header kvm_vcpu_stats_header =3D {
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index acdcd619797e..6e0c18412795 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -195,22 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run,
>         switch (trap->scause) {
>         case EXC_INST_ILLEGAL:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN)=
;
> +               vcpu->stat.instr_illegal_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_LOAD_MISALIGNED:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LO=
AD);
> +               vcpu->stat.load_misaligned_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_STORE_MISALIGNED:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_ST=
ORE);
> +               vcpu->stat.store_misaligned_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_LOAD_ACCESS:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
> +               vcpu->stat.load_access_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_STORE_ACCESS:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE)=
;
> +               vcpu->stat.store_access_exits++;
>                 ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_INST_ACCESS:
>
> --
> 2.34.1
>

