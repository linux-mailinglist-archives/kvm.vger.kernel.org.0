Return-Path: <kvm+bounces-34349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B40439FB846
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 02:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16B071884C28
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 01:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E867C4437A;
	Tue, 24 Dec 2024 01:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="DneAf1Ar"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3508F5B
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735003723; cv=none; b=AcE5NQj8o0ZeJN0ODhMWBYeGdhRe2XwAAbI6xSqLO/pWy7cDfw05s0dUO4qEg9n4kml5exyw/kNNN34oSAgzc+dLgBKNze7Ez8X/2kJw8+OUkCAhy2ZKeI7oAg/F//bSmQtwoBkUVmKd+3fdrtSIdjDOwCXLEOn5kUZq73pZF1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735003723; c=relaxed/simple;
	bh=cPwyCMbVi81FZyNSs5/NF+gXXBgBJeWA2QEyV7FfZ/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LVTnyoFLxR2QvcvL5OLkJmygeQ82YuJgX3sUhi4t63kpNQoPrZ15n2z/+ZaqFWa4k78KUbLQ/0edZTbi46xSOZ7bL33azcMqg9WaO/ktYRbFnI8EPPs+13XpD4D7aW1pAIO9H7y9/k9K72STJvILKbv/0XIQU+/tNZoIuI4xF9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=DneAf1Ar; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21669fd5c7cso45903145ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 17:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1735003719; x=1735608519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2r+hHGrSfGWRzOt3YPjDLu8rBH3ivYL9UjShvm3+Rt0=;
        b=DneAf1ArfJ4dx9XjmjPqskmwSkRhu0wDoMwWZuJkaoSgJtfGAmlvzIcNohEfuHv5GV
         lAZZJ2jjfrvU5dOkKInVdAdNenmbMUMJFi2bHoiO0aiAV9sV68PHGO8g5flvUStDeTIW
         94E+zHxyfOsqpHZXncwZTmvitkKnwMVudq6g64sJiRWQgn4B1e6P6K6xT/aQRdKmijMd
         iszIXO/imcVz1nlmvHvF1pd7yoYZbcSgMX5w9iAl1gWMpufzism93tlvWO8uAQ89D1fD
         bZGh0A8qUJmCMd83WOPFoUmmzUhZeQa9JzTjFuYgMiyvbdafwGhviijWXV13UMtiZpk+
         BhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735003719; x=1735608519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2r+hHGrSfGWRzOt3YPjDLu8rBH3ivYL9UjShvm3+Rt0=;
        b=gh5t1oi9KjkgX12/AusNArAJ64eaf+FyeNKJH9ubQOHv5veCrJZsltQGmc1IdKrMWm
         vHjbEdgXW5O4Ao4JJ7zlD+PL7ZWDOBfg3Vo6XcPe4oeTMHsUcpc4J40LNq3T6oZ4pone
         WqvNvq5OOrOn1yjdXy0nbPhv46d8S+d6IdIiqvUbQc4ry6NhklKDq9U9mnixsOQ07Ryk
         9zShMFOpjmZJ3hrntHTFHhvQQbB6qnKNS4wWCEYXHt4o8B/4HXLTwHyc11KVd0ztIu9P
         Zw2zSyynh+3Moy0uvfaqxTegPI4NuXXdidPfHATP+RmjMZxuMW2JxIgSAoCuVz1mM3cU
         u3XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgXu30RHSkZK2+7a/KdOR7ujuPLpwAxEZMnmpByeId+ncJhoer2ZQMwBOGvthZc1GRauo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2zxLHR5/+SVhORUImUGI7GT9Vr5Z5kY9ZZGOvij5ox7zPJ0XG
	q5ZU7Cw0rqbHX3GDJ1qAXBnBOSVXDH9UfJP/eHTWZYivs205DkcombnqxsAXI4HpvZ4N7F8gQDT
	o0joxnI8GqK6/C8q0kVNqbc6087lt65gCczt5/Q==
X-Gm-Gg: ASbGncuqJN8wjoJIdJiMsOZhJ2SEZc+RWQPwiZcf824cqTlqSe/WrTQsxroBYPH+3rt
	rH5gpQT+JkvvaQvvA7uOY3kcJ7U9RTzNOghPB
X-Google-Smtp-Source: AGHT+IHLJmmH3jU1z3Dd3seWuqBfKE6BX7c1oHTHNFkQnpmnsGeKrQO4Ilp3RElE8malUlH4CKZqcLevVysoRCQfJCc=
X-Received: by 2002:a05:6a00:849:b0:725:c8ea:b30b with SMTP id
 d2e1a72fcca58-72abddbe6c8mr15634452b3a.11.1735003718866; Mon, 23 Dec 2024
 17:28:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
 <20241212-kvm_guest_stat-v1-3-d1a6d0c862d5@rivosinc.com> <CAAhSdy24K3pkOR25Rbcvw6pRWXrKXdy0CH9CLeG77EqQRZTDnQ@mail.gmail.com>
In-Reply-To: <CAAhSdy24K3pkOR25Rbcvw6pRWXrKXdy0CH9CLeG77EqQRZTDnQ@mail.gmail.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 23 Dec 2024 17:28:28 -0800
Message-ID: <CAHBxVyH3eX0o66398+L09RKriudDC90M_7wzsRrQZ+42f4JOVQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] RISC-V: KVM: Add new exit statstics for redirected traps
To: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 6:19=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Fri, Dec 13, 2024 at 2:27=E2=80=AFAM Atish Patra <atishp@rivosinc.com>=
 wrote:
> >
> > Currently, kvm doesn't delegate the few traps such as misaligned
> > load/store, illegal instruction and load/store access faults because it
> > is not expected to occur in the guest very frequent. Thus, kvm gets a
> > chance to act upon it or collect statstics about it before redirecting
> > the traps to the guest.
> >
> > We can collect both guest and host visible statistics during the traps.
> > Enable them so that both guest and host can collect the stats about
> > them if required.
>
> s/We can collect .../Collect .../
>

Let me know if I should send a v2. I noticed a couple of other typos
in the commit text as well.

> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
>
> Otherwise, it looks good to me.
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
>
> Regards,
> Anup
>
> > ---
> >  arch/riscv/include/asm/kvm_host.h | 5 +++++
> >  arch/riscv/kvm/vcpu.c             | 7 ++++++-
> >  arch/riscv/kvm/vcpu_exit.c        | 5 +++++
> >  3 files changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 35eab6e0f4ae..cc33e35cd628 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -87,6 +87,11 @@ struct kvm_vcpu_stat {
> >         u64 csr_exit_kernel;
> >         u64 signal_exits;
> >         u64 exits;
> > +       u64 instr_illegal_exits;
> > +       u64 load_misaligned_exits;
> > +       u64 store_misaligned_exits;
> > +       u64 load_access_exits;
> > +       u64 store_access_exits;
> >  };
> >
> >  struct kvm_arch_memory_slot {
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index e048dcc6e65e..60d684c76c58 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -34,7 +34,12 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =
=3D {
> >         STATS_DESC_COUNTER(VCPU, csr_exit_user),
> >         STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
> >         STATS_DESC_COUNTER(VCPU, signal_exits),
> > -       STATS_DESC_COUNTER(VCPU, exits)
> > +       STATS_DESC_COUNTER(VCPU, exits),
> > +       STATS_DESC_COUNTER(VCPU, instr_illegal_exits),
> > +       STATS_DESC_COUNTER(VCPU, load_misaligned_exits),
> > +       STATS_DESC_COUNTER(VCPU, store_misaligned_exits),
> > +       STATS_DESC_COUNTER(VCPU, load_access_exits),
> > +       STATS_DESC_COUNTER(VCPU, store_access_exits),
> >  };
> >
> >  const struct kvm_stats_header kvm_vcpu_stats_header =3D {
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index acdcd619797e..6e0c18412795 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -195,22 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run,
> >         switch (trap->scause) {
> >         case EXC_INST_ILLEGAL:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INS=
N);
> > +               vcpu->stat.instr_illegal_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> >         case EXC_LOAD_MISALIGNED:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_=
LOAD);
> > +               vcpu->stat.load_misaligned_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> >         case EXC_STORE_MISALIGNED:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_=
STORE);
> > +               vcpu->stat.store_misaligned_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> >         case EXC_LOAD_ACCESS:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD=
);
> > +               vcpu->stat.load_access_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> >         case EXC_STORE_ACCESS:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STOR=
E);
> > +               vcpu->stat.store_access_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> >         case EXC_INST_ACCESS:
> >
> > --
> > 2.34.1
> >

