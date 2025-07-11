Return-Path: <kvm+bounces-52109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 589DAB01706
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0070F161C2A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3738621CFF6;
	Fri, 11 Jul 2025 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lA/K/0ao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DB4205E3B
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752224271; cv=none; b=YdhpG8ahgA3CquHOpuyDsX6ly5gFDrRa6SNbPO24eEKv4hlbUeF4ngclvWLH5RkV6iZ/sQHe04U+Ik9RYYNP4/Rs8ei8sdIqlBEzY2eqSJhd+oM81K+5rRSzFUKupYIOdHxiVwAfrYkrvxvoArgb4GKlh2sPG7UeTHoZ1eJZT+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752224271; c=relaxed/simple;
	bh=pRHMkDqV97U26JmQEq+woAi2LAZVGtP7svkWnKfjPQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TMrNJg3qExEuan/4ho9G79a/EkkPgyvcJZ+HE7d65BGQs4hwtI0JOVYSgyQqr1sibqBt2+kSZcoiODMeUwKKKwGfAihU2bVZt3Wc+Zw/AI3Yby0qDbjTxdW1xcYugEusXX6CMc0Mqu8z/6ojwMUSWXABkcVC/m7iRmbaQnsaWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lA/K/0ao; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235e1d710d8so24793035ad.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752224268; x=1752829068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jPE3mL5y1udMtv31ER89R9IyYO4SZ2b6SdsXTbZEV0=;
        b=lA/K/0aoG7C0eC79A5ai8HjjGyfIskeVXRtIfJQuzMX/Za8fUzYRxLwbiKkeX8ddmy
         eS6r1gvXbLftMYT7DbI4kmD7kobSHB0nLrjyyEGGvLqQ1d1Rv3tGNrrgHd+qMTRZpY1/
         s+e5q1KWrLm4kgNS0nfLmhNasnodxWACExZn4oCcsKv1ohQiGIEL2ON6v1gG4lkDrd42
         8fBye2bSsHb4YEIQn42V+du3yTnyxqkv3mVPNncvmLKd2ohuhvAxxsiYFFiBP7ICU137
         hzQdM8sdT7mUXvBNz4BWtmzJE6gD4bfptiALvBOeOuCxjCKy6L//oM+gHniUV1PGxg8D
         SYcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752224268; x=1752829068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jPE3mL5y1udMtv31ER89R9IyYO4SZ2b6SdsXTbZEV0=;
        b=DQiOSqLSjqarcnULWURxcsCd+2Lf2TSejbNEhXrz6+eQhSQReSSlPFdPTBbso+8l22
         W0GFKteBGjyKnEt8kRaKPbDPcIgdy8GDJ5DFo7jZuzozLGHmOulTYyyGXET5l4eYpOr7
         KK/NhKzRFdAXLT/g4u6AJZ8WcDIZVdxQgzGl6l8mW0T9XQ4xDmatZeUJIvrR8RAX1Uk6
         iGlWr9Xvezo7+suxL3nJ2MbptcClSY7tNiNR9qy378HuY1Phg2ScqBiqbG1Cu+iqohMi
         i9vNJ7z0+Kre8GJotkwiS4bXR5tZFCoWdsLrCtWfrEUmTE9XCOsAZAwckSI3PiUp2k7d
         kHAA==
X-Forwarded-Encrypted: i=1; AJvYcCWM/ejVaYu2OdvjgfAYYc5b40FNRYBixvzuPBgggm0Lb/NWO+XCoLU3Q36GpDc9ggMdmNw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4YNqLw201H9KT14zAOWx+d7gEpNqJQplhkjvZEK9wHscbMnDU
	fqlSviEgsNvPQn1oweCFZ5bJC/iRerkDHH1bIZZEMmGXZJ/jfXRCSBuu1rhVMghLM8mcyAWeT84
	0n4O/JS64dgLE1Hng1qkH7X1hLEk/stIeD3urEaOaQw==
X-Gm-Gg: ASbGncs85CCBtAmTdvCFWjbMZn79OVgflYSmJI2henOGHqhL0NXawqZAqJDSBErF8XB
	eUqNT5fC40cM636Lae05na76MR8xYepXd0cC4lHmjhM6lXwIlN2a5jzSD1Oli0nvo8tKgQw3Qwe
	wSSHz80nXW7teDElehclZwaNfUKcdvrstgQEO2QF8mcUMrUTBbC1lMGrtsYltrt9DSQEgDs05W+
	SYycfvcjdBZIYBuSCGX
X-Google-Smtp-Source: AGHT+IGK/U+DIO6wfNWGGall2Awzk7CE4ogxDlD3/mORB2QJIQwmSRHRTeEmJGi1pr+O0MdSB9VbBzHvyfMIotCxim0=
X-Received: by 2002:a17:90b:384c:b0:312:51a9:5d44 with SMTP id
 98e67ed59e1d1-31c4ca64de6mr3517873a91.5.1752224267719; Fri, 11 Jul 2025
 01:57:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710133030.88940-1-luxu.kernel@bytedance.com> <CAK9=C2W60a2otfJKucJc_d4=X9YBTep1zSp+wa8E7-kL7tJR0Q@mail.gmail.com>
In-Reply-To: <CAK9=C2W60a2otfJKucJc_d4=X9YBTep1zSp+wa8E7-kL7tJR0Q@mail.gmail.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Fri, 11 Jul 2025 16:57:35 +0800
X-Gm-Features: Ac12FXySh83P0GWh89XB-YNqsR5yVEel47k01hOQLXeLmyXAGpkJZ76LaWl1N8k
Message-ID: <CAPYmKFur4asd4bzCBgCwrPpMK9amihWSeK2Vwpk1mGjK_Fy29g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] RISC-V: KVM: Delegate kvm unhandled
 faults to VS mode
To: Anup Patel <apatel@ventanamicro.com>
Cc: rkrcmar@ventanamicro.com, cleger@rivosinc.com, anup@brainfault.org, 
	atish.patra@linux.dev, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 4:28=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> On Thu, Jul 10, 2025 at 7:00=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com>=
 wrote:
> >
> > Delegate faults which are not handled by kvm to VS mode to avoid
> > unnecessary traps to HS mode. These faults include illegal instruction
> > fault, instruction access fault, load access fault and store access
> > fault.
> >
> > The delegation of illegal instruction fault is particularly important
> > to guest applications that use vector instructions frequently. In such
> > cases, an illegal instruction fault will be raised when guest user thre=
ad
> > uses vector instruction the first time and then guest kernel will enabl=
e
> > user thread to execute following vector instructions.
> >
> > The fw pmu event counters remain undeleted so that guest can still get
> > these events via sbi call. Guest will only see zero count on these
> > events and know 'firmware' has delegated these faults.
>
> Currently, we don't delegate illegal instruction faults and various
> access faults to Guest because we allow Guest to count PMU
> firmware events. Refer, [1] and [2] for past discussions.
>
> [1] http://lists.infradead.org/pipermail/linux-riscv/2024-August/059658.h=
tml
> [2] https://lore.kernel.org/all/20241224-kvm_guest_stat-v2-0-08a77ac36b02=
@rivosinc.com/
>
> I do understand that additional redirection hoop can slow down
> lazy enabling of vector state so drop delegating various access
> faults.

Roger that. I will resend the patch and only delegate illegal insn fault.

>
> Regards,
> Anup
>
> >
> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  4 ++++
> >  arch/riscv/kvm/vcpu_exit.c        | 18 ------------------
> >  2 files changed, 4 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index 85cfebc32e4cf..e04851cf0115c 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -44,7 +44,11 @@
> >  #define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(6)
> >
> >  #define KVM_HEDELEG_DEFAULT            (BIT(EXC_INST_MISALIGNED) | \
> > +                                        BIT(EXC_INST_ACCESS)     | \
> > +                                        BIT(EXC_INST_ILLEGAL)    | \
> >                                          BIT(EXC_BREAKPOINT)      | \
> > +                                        BIT(EXC_LOAD_ACCESS)     | \
> > +                                        BIT(EXC_STORE_ACCESS)    | \
> >                                          BIT(EXC_SYSCALL)         | \
> >                                          BIT(EXC_INST_PAGE_FAULT) | \
> >                                          BIT(EXC_LOAD_PAGE_FAULT) | \
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index 6e0c184127956..6e2302c65e193 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -193,11 +193,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, str=
uct kvm_run *run,
> >         ret =3D -EFAULT;
> >         run->exit_reason =3D KVM_EXIT_UNKNOWN;
> >         switch (trap->scause) {
> > -       case EXC_INST_ILLEGAL:
> > -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INS=
N);
> > -               vcpu->stat.instr_illegal_exits++;
> > -               ret =3D vcpu_redirect(vcpu, trap);
> > -               break;
> >         case EXC_LOAD_MISALIGNED:
> >                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_=
LOAD);
> >                 vcpu->stat.load_misaligned_exits++;
> > @@ -208,19 +203,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, str=
uct kvm_run *run,
> >                 vcpu->stat.store_misaligned_exits++;
> >                 ret =3D vcpu_redirect(vcpu, trap);
> >                 break;
> > -       case EXC_LOAD_ACCESS:
> > -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD=
);
> > -               vcpu->stat.load_access_exits++;
> > -               ret =3D vcpu_redirect(vcpu, trap);
> > -               break;
> > -       case EXC_STORE_ACCESS:
> > -               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STOR=
E);
> > -               vcpu->stat.store_access_exits++;
> > -               ret =3D vcpu_redirect(vcpu, trap);
> > -               break;
> > -       case EXC_INST_ACCESS:
> > -               ret =3D vcpu_redirect(vcpu, trap);
> > -               break;
> >         case EXC_VIRTUAL_INST_FAULT:
> >                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> >                         ret =3D kvm_riscv_vcpu_virtual_insn(vcpu, run, =
trap);
> > --
> > 2.20.1
> >
> >

