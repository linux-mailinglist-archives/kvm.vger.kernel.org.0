Return-Path: <kvm+bounces-34350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C1F9FB8D1
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 04:05:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F62A16549C
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 03:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C9A433A0;
	Tue, 24 Dec 2024 03:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LRz9+u4g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F959C2C8
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 03:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735009509; cv=none; b=NZRotTWWwRJK0YrwxQuNg+yNkBydN0zx60OpokBd2mV7jD7gdH0DyL6t4c+60a1SxEeN21ZW76Ag0IN7UPYz1jzJuuP5OZFZEIFqRKf54husv9yTCGgRSow/jwksCRs3b+hyq5NTHR4y97asMScEkNn7s7dSr8ywVzUKfcEKumo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735009509; c=relaxed/simple;
	bh=Nqf0fUa4C1KnyWxg6h3152NiqINFnunHzcYgljTpZRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4xTZ6Z1ANIb88ktV5D3RgD3j6G8R4cJOOus/unN8qNbDAgxqrV7NE0C+3+j1DRahllenBKXdCv6OpbJRwLebxoAP/AK1QLH3KKKasoIjmHC1cFq3H3ubCLMnd/vwTRmDg4T8edLNQXiNbv30c9L3qeVqhvPpUFXxuL4StOoI4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LRz9+u4g; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3003943288bso52749391fa.0
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 19:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1735009505; x=1735614305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zV2swasXPvMAVlP5f3jr8oXory5QX9BeYa7Q0nFqvZs=;
        b=LRz9+u4gjz5hM//EGa6VkbF3I78LGgoK9yq9MX+caO07A7PQWSxLSzDV7pXb6NDZaU
         PC/LcPgagYS+ZC5Eiv6qpfxlEBSXAhcTXnMlgC6Fl3EcC74dC2hWqt3BdVhYyIJVtuSW
         JclCWm544c42eglf6RGJMWfZRdoo9MuL6VIKaiIE6ysk/ildGEFaW8lnEqd2pCIFyb5i
         yrW3vusr5CNk7luc7Ju95V4QLW/D6HBJXtCyV5fL1A6EOgfJ9/4VB6WCptylcG9Xms49
         L1T61kjFwUz04PDOFRuh2ZBnJOkZM2GSkUUUAfFivh5E/WYpsifkoT6sGaB37ln8/ZCH
         2szg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735009505; x=1735614305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zV2swasXPvMAVlP5f3jr8oXory5QX9BeYa7Q0nFqvZs=;
        b=d93lnyoBjq7XLXEQuSn9DcnkMUmF/ScthvqfsFog4cKOv6yyKKvvTxuA6HUX68DuPW
         4fKDaMWgq8Hy38X+uFKm1z3Ir50CV5uVVKLgtyJkH6tUTgObGCE7GoBOZKzweFzdSVmg
         YfDSanVJBZTqABfTo8PSROarx400xKouZKv/Yi2H0FWpBY3gANbl7ZnqY3YmTj2tedYx
         wUL7juxIVw/cam2wcrqorJ82H0KikmJUTAYxvNNaTYGklu6FZtb8M5h/UDt/c5hBowMV
         1ObX0lv5bl4tIKeVquCw7Wo91HSKhpPmLwBRWuHn+PO5cmgsyeECp6m77bEvkGZ7hXQA
         cvsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuW0FYQKy4xWREpQ9EbGiqdjJdmMaHCuh96/zx4Gdt9SlwgfYmCP5J4eJJU6rlH6KGZDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSQViJHjLq6DQprdTSFTla5USohcXWzNkmf+5QcyWeTCMUg4gB
	0rFvVTYwYFwA8SEK/EEzkvA1KD9xFdS1v5mgX/TCvKo3rQL/uSdnLF4n7TR+PjX/zQEyWCIhYLV
	Aob+f6BMr8SIYxFavmRxXlxVaENMdZC/T3BrVbg==
X-Gm-Gg: ASbGncuIFVJNR/TgXvYQ/cxZLC8NBpkAGUiMEeFhnhMA+SwUU9Jis0Zoi1TrrmgRZ/y
	Uz9KWfW0N2N9rLssXpNlZWB8fpe2kFLCQZ1XbnSMT
X-Google-Smtp-Source: AGHT+IHETOY6VFgnZtw5FYGpJ+VNB/mTZqQvaj9A7za3YSjBjYMJMn+409HJt1Vwowo3742LZINWLlVQDCSZtPlp0us=
X-Received: by 2002:a05:6512:6d3:b0:542:1137:611a with SMTP id
 2adb3069b0e04-54229533db1mr5786359e87.17.1735009505466; Mon, 23 Dec 2024
 19:05:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com>
 <20241212-kvm_guest_stat-v1-3-d1a6d0c862d5@rivosinc.com> <CAAhSdy24K3pkOR25Rbcvw6pRWXrKXdy0CH9CLeG77EqQRZTDnQ@mail.gmail.com>
 <CAHBxVyH3eX0o66398+L09RKriudDC90M_7wzsRrQZ+42f4JOVQ@mail.gmail.com>
In-Reply-To: <CAHBxVyH3eX0o66398+L09RKriudDC90M_7wzsRrQZ+42f4JOVQ@mail.gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 24 Dec 2024 08:34:53 +0530
Message-ID: <CAK9=C2WwD+RMUmO8SR-bBMfEJLGfd4pMswQx19URLng20Mui-g@mail.gmail.com>
Subject: Re: [PATCH 3/3] RISC-V: KVM: Add new exit statstics for redirected traps
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 24, 2024 at 6:58=E2=80=AFAM Atish Kumar Patra <atishp@rivosinc.=
com> wrote:
>
> On Mon, Dec 23, 2024 at 6:19=E2=80=AFAM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Fri, Dec 13, 2024 at 2:27=E2=80=AFAM Atish Patra <atishp@rivosinc.co=
m> wrote:
> > >
> > > Currently, kvm doesn't delegate the few traps such as misaligned
> > > load/store, illegal instruction and load/store access faults because =
it
> > > is not expected to occur in the guest very frequent. Thus, kvm gets a
> > > chance to act upon it or collect statstics about it before redirectin=
g
> > > the traps to the guest.
> > >
> > > We can collect both guest and host visible statistics during the trap=
s.
> > > Enable them so that both guest and host can collect the stats about
> > > them if required.
> >
> > s/We can collect .../Collect .../
> >
>
> Let me know if I should send a v2. I noticed a couple of other typos
> in the commit text as well.

Yes, please send v2.

Regards,
Anup

>
> > >
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> >
> > Otherwise, it looks good to me.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> >
> > Regards,
> > Anup
> >
> > > ---
> > >  arch/riscv/include/asm/kvm_host.h | 5 +++++
> > >  arch/riscv/kvm/vcpu.c             | 7 ++++++-
> > >  arch/riscv/kvm/vcpu_exit.c        | 5 +++++
> > >  3 files changed, 16 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/a=
sm/kvm_host.h
> > > index 35eab6e0f4ae..cc33e35cd628 100644
> > > --- a/arch/riscv/include/asm/kvm_host.h
> > > +++ b/arch/riscv/include/asm/kvm_host.h
> > > @@ -87,6 +87,11 @@ struct kvm_vcpu_stat {
> > >         u64 csr_exit_kernel;
> > >         u64 signal_exits;
> > >         u64 exits;
> > > +       u64 instr_illegal_exits;
> > > +       u64 load_misaligned_exits;
> > > +       u64 store_misaligned_exits;
> > > +       u64 load_access_exits;
> > > +       u64 store_access_exits;
> > >  };
> > >
> > >  struct kvm_arch_memory_slot {
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index e048dcc6e65e..60d684c76c58 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -34,7 +34,12 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[]=
 =3D {
> > >         STATS_DESC_COUNTER(VCPU, csr_exit_user),
> > >         STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
> > >         STATS_DESC_COUNTER(VCPU, signal_exits),
> > > -       STATS_DESC_COUNTER(VCPU, exits)
> > > +       STATS_DESC_COUNTER(VCPU, exits),
> > > +       STATS_DESC_COUNTER(VCPU, instr_illegal_exits),
> > > +       STATS_DESC_COUNTER(VCPU, load_misaligned_exits),
> > > +       STATS_DESC_COUNTER(VCPU, store_misaligned_exits),
> > > +       STATS_DESC_COUNTER(VCPU, load_access_exits),
> > > +       STATS_DESC_COUNTER(VCPU, store_access_exits),
> > >  };
> > >
> > >  const struct kvm_stats_header kvm_vcpu_stats_header =3D {
> > > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > > index acdcd619797e..6e0c18412795 100644
> > > --- a/arch/riscv/kvm/vcpu_exit.c
> > > +++ b/arch/riscv/kvm/vcpu_exit.c
> > > @@ -195,22 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, =
struct kvm_run *run,
> > >         switch (trap->scause) {
> > >         case EXC_INST_ILLEGAL:
> > >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_I=
NSN);
> > > +               vcpu->stat.instr_illegal_exits++;
> > >                 ret =3D vcpu_redirect(vcpu, trap);
> > >                 break;
> > >         case EXC_LOAD_MISALIGNED:
> > >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNE=
D_LOAD);
> > > +               vcpu->stat.load_misaligned_exits++;
> > >                 ret =3D vcpu_redirect(vcpu, trap);
> > >                 break;
> > >         case EXC_STORE_MISALIGNED:
> > >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNE=
D_STORE);
> > > +               vcpu->stat.store_misaligned_exits++;
> > >                 ret =3D vcpu_redirect(vcpu, trap);
> > >                 break;
> > >         case EXC_LOAD_ACCESS:
> > >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LO=
AD);
> > > +               vcpu->stat.load_access_exits++;
> > >                 ret =3D vcpu_redirect(vcpu, trap);
> > >                 break;
> > >         case EXC_STORE_ACCESS:
> > >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_ST=
ORE);
> > > +               vcpu->stat.store_access_exits++;
> > >                 ret =3D vcpu_redirect(vcpu, trap);
> > >                 break;
> > >         case EXC_INST_ACCESS:
> > >
> > > --
> > > 2.34.1
> > >
>

