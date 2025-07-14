Return-Path: <kvm+bounces-52272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D781B0389C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B69CF179F6D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1B823956E;
	Mon, 14 Jul 2025 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tL3yj00f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BD41F0994
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752480253; cv=none; b=nAI4wz1gKMg5sHNKhGXlGgQ/8m4HCH6zjSoPQdVRbmz51vRK6dp+zepc7hWqKD4LV48OX/oiCHMAS+8E3RXBISmbvLkGggbVn9/XAsHgXFw1haPB4r2ldQxfBmD4WjPzSwCIoYRVsbVV9+C7yqoY+HiaghiazTqY4KdrvwKAvCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752480253; c=relaxed/simple;
	bh=f+o9WVDsyRj3e9aXVc3KN67EOFIQrJYY2xIcE0eTzEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEq7fdti8TuSo55bFV6GEyAgfkZSHRvSzbUO7pju8fTjlxkYAd5OyKW+Dc0nz3p70LvXyahgpaUj4htB+ESuDvoG7Pfe5mpyr2EJtfx69BNM2vRyea5BwDDjxXoLsVQahSYUtMpkA1sW6bOu4AAB/w/88wGTW8RxM2wwXDM7KVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tL3yj00f; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3df2d8cb8d2so14577795ab.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 01:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752480251; x=1753085051; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZgIQGeH6iTe1iCoPtim6lSFnAFbmo2QUEBDo1A3JBQ=;
        b=tL3yj00fNL/H6AzWzxrsDV+69GuYO5036L104qSA1sZJ4oBiXtvJbLiygI6YkPtswg
         l4MJCXCegnoTrBEaYin6YCFVnEhMVEuLUZ3bd0/7LfjdBTTgciZ5Tu+AcgtgAbaV8U1J
         ZAxLf+RB+g5DK1+UYedfK8/yixClNC5whozruCCu8S0TZhYqUTJfYslvrrrm3hahfju3
         f2giv9mU8Q0Ivo9AqHbsdgvVQ+dqh9SV1zHnj5IeHrRQ/jGpIl+foybYCo7ow7S2/whs
         Xtzzx1B+TpAmLnUaIR6AjtnWqm7E0q0luSIhAFBMDaFI7NKkoOrsgRiyMTfwuCT1cm3n
         it6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752480251; x=1753085051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZgIQGeH6iTe1iCoPtim6lSFnAFbmo2QUEBDo1A3JBQ=;
        b=nBvu4ratM0ZyCIme9nokYClZvFDryGxng6SA7A5IglUNHyNvO+GifQT7MpVzI+0ZFI
         a7M1/Ivw1tbwRClQmIA857UgCGM8Hy+tqpO0p0oNE/4R1WMHqkF5IKPXy78tdfiJW8Eb
         6A1vgjfnVjSmbuvcnTnzN+RkryCWsoow729f0f2UJpdcTiplOvNkAlxnGdnG3ZDWaQNA
         KjrFt7KAB1K7ieDIrZYee3T8IIXGesIhYoOl7tJsZviaF84KqfJa1eNHvqOQ1h5ZUnu8
         hy1sIFyRZT2yFJ7dwbSDcmmuSLPHgl7B5HlJ2R9mY6B2PPn6QQNg7/yyVDt43vLxiRgP
         2LXA==
X-Forwarded-Encrypted: i=1; AJvYcCWDbSXhfxIfxyFIZhHIDJLcpAADN3RzUYVLFKEF9QEDdqOI5EITFGcRXBEvjGkfM1YTUxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM1KKmXHg7RQfuam2shTRQyg+YriKskfY1rZAHb0+eVXJm+7DW
	LvkCJPS2s47dd2foZXL4qhdmHpqU3FB5LoZD3q7pIYfwZM6+u6aOewBe8JALScEkho4sy8OklAr
	nIZATMqbYjleKGCgvRZfqKc4YnE62XRKiMcxjHruVRA==
X-Gm-Gg: ASbGncsb3u4FXBw9ViYsWA+EIPRB8UBctcAiUDYiv2JRrBBw77rNBbhV5vfxtzUfIAu
	42zvh/uTmCqP1Btrop2mQ96wUUN9WJnuSplOgUTzcTwKmYZMHS9ssKt/XYCgXbR5clEPvwevgp6
	z+IJPMhcIqM1caYkSnGAqXMuCugMT2qWeJwxd9RxLvQLoLfYQtn71960BFUFyJvT3eL2KZlPPj4
	LKB/w9qJoTX4Moafks=
X-Google-Smtp-Source: AGHT+IFRHVQzoAt1qKkfWgKOuTxoczx2KhtXwBF+kniHBzyY3kBO8gLSgMJy+LXX+IM1zlPXQQUK731W+/4cNca4pWM=
X-Received: by 2002:a05:6e02:304a:b0:3df:4046:93a9 with SMTP id
 e9e14a558f8ab-3e25325550bmr122893985ab.5.1752480250607; Mon, 14 Jul 2025
 01:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711101537.16308-1-luxu.kernel@bytedance.com>
In-Reply-To: <20250711101537.16308-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 14 Jul 2025 13:33:59 +0530
X-Gm-Features: Ac12FXxof_i54yoTN6sBpKdXuMFJfg4CBnTxqLczo_oXcUYHd6dY56mBe6MespY
Message-ID: <CAAhSdy0OumSXbJEEafE6q-LPu2PTdN9Tzx_aoapy=RJD214uBw@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: Delegate illegal instruction fault to VS mode
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: rkrcmar@ventanamicro.com, cleger@rivosinc.com, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 3:45=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> Delegate illegal instruction fault to VS mode in default to avoid such

s/in default/by default/

> exceptions being trapped to HS and redirected back to VS.
>
> The delegation of illegal instruction fault is particularly important
> to guest applications that use vector instructions frequently. In such
> cases, an illegal instruction fault will be raised when guest user thread
> uses vector instruction the first time and then guest kernel will enable
> user thread to execute following vector instructions.
>
> The fw pmu event counter remains undeleted so that guest can still query
> illegal instruction events via sbi call. Guest will only see zero count
> on illegal instruction faults and know 'firmware' has delegated it.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>  arch/riscv/include/asm/kvm_host.h | 1 +
>  arch/riscv/kvm/vcpu_exit.c        | 5 -----
>  2 files changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 85cfebc32e4cf..3f6b9270f366a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -44,6 +44,7 @@
>  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
>
>  #define KVM_HEDELEG_DEFAULT            (BIT(EXC_INST_MISALIGNED) | \
> +                                        BIT(EXC_INST_ILLEGAL)     | \
>                                          BIT(EXC_BREAKPOINT)      | \
>                                          BIT(EXC_SYSCALL)         | \
>                                          BIT(EXC_INST_PAGE_FAULT) | \
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 6e0c184127956..cd8fa68f3642c 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -193,11 +193,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struc=
t kvm_run *run,
>         ret =3D -EFAULT;
>         run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
> -       case EXC_INST_ILLEGAL:
> -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN)=
;
> -               vcpu->stat.instr_illegal_exits++;
> -               ret =3D vcpu_redirect(vcpu, trap);
> -               break;

Lets keep the illegal instruction trap handling so that if SBI implementati=
on
forwards VS-mode illegal instruction trap to HS-mode ignoring hedeleg
due to unknown reasons then we still forward this trap to Guest otherwise
such an illegal instruction trap will cause exit to user-space and eventual=
ly
kill the Guest.

>         case EXC_LOAD_MISALIGNED:
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LO=
AD);
>                 vcpu->stat.load_misaligned_exits++;
> --
> 2.20.1
>

Regards,
Anup

