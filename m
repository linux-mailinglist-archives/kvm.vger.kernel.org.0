Return-Path: <kvm+bounces-11351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2CF875D8B
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 06:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8EC51C21A72
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 05:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980A82EAE6;
	Fri,  8 Mar 2024 05:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="afijcFjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB4623775
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709875680; cv=none; b=fcOUA/LLpp/QHTa7OBS+xdfN+HU2Jqe8lOYUeMgvoR9mw3IpYG+jyRxW/XK17dBdX4maGzyjd6ciqUSyS70RnD2vWPMDiAodMPsOk8M7Fw5TIpmHR2nGkMn3jvkVBe1kNhs5sBE04lH25iHezyYhwyGHHBLI18z+7slz+mSAEm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709875680; c=relaxed/simple;
	bh=sDlDQsVRzpULpD5wsVn3hNDqx9hytYMB4sNYX/CLr0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKaw1hFPtNW1T2hswERMV74SxXsqOWx5Tdf5AL4Xp74UmS1t4NI03i5Y3r+m/eTz+QWVSITY8eFkppE3sEjm4zac9hjuc6esBTyp6KSwaIOxfPlZhAD9txplPrr6+HHh+bCPWsnMHkiaAM5EaPWHsegfhvdCO1QsCuZ//QgHe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=afijcFjH; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-364f791a428so7260845ab.3
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 21:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709875678; x=1710480478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pl9NNpV23e7PPSXFKavXyx5MR9eH3+53L7KC39+t3tA=;
        b=afijcFjHYbRCp57fhbNFPfTLqpSddACYWXbh2Ug0NTIYtFyNCojsB2KDk2iiTJJcwi
         21Y7rMy359g9c8uzGmoOUcEIYnCbHqRMkyCUlyxqHSjXzwOnVx1nuOl+GkH6d7fbB0rb
         CizR9nWTS6gQMBAhFsqOgzwy9iRwOqp6dQanPRRkCjjqYOB3GGe/tZeuMknERLMs6L+C
         9GsLiuAOOhZsXNsEd6Pk0bi0+9sxbbf3gqL6WjH254BEpr2MlyKOdcpeYKghClTdOtck
         rzY9WVH9I8pimRVFxnIQS9i3vCBJxGlMCzf6Wm+2A2qQ24dxnwOu7TxLT3MnaEcqbOZz
         NMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709875678; x=1710480478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pl9NNpV23e7PPSXFKavXyx5MR9eH3+53L7KC39+t3tA=;
        b=dXGhgpvWwnMNS0IrEHJi88/KmEr5CZe1XrAzwk3uGjVo2c86eKipj+HAllvzOytG/0
         VzEQuS1rYsXad1HdGHco2dAo0daWqRDx984GMtOFl6zXTI2D/IT0Jm/9YILHcEuSWdMF
         beAwRA8vJgObIjaVfNRTX2suXpn7+r4WVshaBh10RYe74EjzZefYMrMsI/HnJqzF4i+q
         MwafTxzKx7Uzoj9nSzTbSj+1fPECyHFo5jG8o/Zmpwz93wYtm4dENpyeHdCoRjRuJMUV
         639fuHOh7H+frKZy9nl3feWzy7c4ZXNHs6G90hRDsMYjiW+6/gHDAhN4frq63mK4AGiR
         H6mA==
X-Forwarded-Encrypted: i=1; AJvYcCXidigV0FY2HUTzdtQM+ypzIEbMZ3LvsYLQIM9d0Vzhu0pQ0FxoUncoH17r8dkj2rs4thwW0R4jQ371kciMpiXiu4Yi
X-Gm-Message-State: AOJu0YzIQFMyKpVE35VzfTWNSWLGEZsbWC77enEZ/uD1UlZWKdUHqI3q
	bLFJyS01+9dSYnVG4IH2oYzkKpgCeOVJcfiAIzR+4XInBcV7xuAAYbzI8CS66sGbM02JhZ0MX7H
	wh84noQ+Rq10GHVl1WaAqNfj6Xd3wfWprTX0ipg==
X-Google-Smtp-Source: AGHT+IHtDu8/USI0tggQbcaqnOFGrFTBALs/MuZlRMxGOGB7tpDm6kBEgQgsE3U2CSZZd4h2xUbIrcWyL5HEAAHhCts=
X-Received: by 2002:a92:cd8b:0:b0:363:c2d4:a365 with SMTP id
 r11-20020a92cd8b000000b00363c2d4a365mr24881857ilb.26.1709875678243; Thu, 07
 Mar 2024 21:27:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com>
In-Reply-To: <Zen8qGzVpaOB_vKa@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 8 Mar 2024 10:57:46 +0530
Message-ID: <CAAhSdy2Mu08RsBM+7FMjkcV49p9gOj3UKEoZnPAVk92e_3q=sw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 7, 2024 at 11:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Mar 07, 2024, Anup Patel wrote:
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.9
> >
> > - Exception and interrupt handling for selftests
> > - Sstc (aka arch_timer) selftest
> > - Forward seed CSR access to KVM userspace
> > - Ztso extension support for Guest/VM
> > - Zacas extension support for Guest/VM
> >
> > ----------------------------------------------------------------
> > Anup Patel (5):
> >       RISC-V: KVM: Forward SEED CSR access to user space
> >       RISC-V: KVM: Allow Ztso extension for Guest/VM
> >       KVM: riscv: selftests: Add Ztso extension to get-reg-list test
> >       RISC-V: KVM: Allow Zacas extension for Guest/VM
> >       KVM: riscv: selftests: Add Zacas extension to get-reg-list test
> >
> > Haibo Xu (11):
> >       KVM: arm64: selftests: Data type cleanup for arch_timer test
> >       KVM: arm64: selftests: Enable tuning of error margin in arch_time=
r test
> >       KVM: arm64: selftests: Split arch_timer test code
> >       KVM: selftests: Add CONFIG_64BIT definition for the build
> >       tools: riscv: Add header file csr.h
> >       tools: riscv: Add header file vdso/processor.h
> >       KVM: riscv: selftests: Switch to use macro from csr.h
> >       KVM: riscv: selftests: Add exception handling support
> >       KVM: riscv: selftests: Add guest helper to get vcpu id
>
> Uh, what's going on with this series?  Many of these were committed *yest=
erday*,
> but you sent a mail on February 12th[1] saying these were queued.  That's=
 quite
> the lag.
>
> I don't intend to police the RISC-V tree, but this commit caused a confli=
ct with
> kvm-x86/selftests[2].  It's a non-issue in this case because it's such a =
trivial
> conflict, and we're all quite lax with selftests, but sending a pull requ=
est ~12
> hours after pushing commits that clearly aren't fixes is a bit ridiciulou=
s.  E.g.
> if this were to happen with a less trivial conflict, the other sub-mainta=
iner would
> be left doing a late scramble to figure things out just before sending th=
eir own
> pull requests.
>
>   tag kvm-riscv-6.9-1
>   Tagger:     Anup Patel <anup@brainfault.org>
>   TaggerDate: Thu Mar 7 11:54:34 2024 +0530
>
> ...
>
>   commit d8c0831348e78fdaf67aa95070bae2ef8e819b05
>   Author:     Anup Patel <apatel@ventanamicro.com>
>   AuthorDate: Tue Feb 13 13:39:17 2024 +0530
>   Commit:     Anup Patel <anup@brainfault.org>
>   CommitDate: Wed Mar 6 20:53:44 2024 +0530
>
> The other reason this caught my eye is that the conflict happened in comm=
on code,
> but the added helper is RISC-V specific and used only from RISC-V code.  =
ARM does
> have an identical helper, but AFAICT ARM's helper is only used from ARM c=
ode.
>
> But the prototype of guest_get_vcpuid() is in common code.  Which isn't a=
 huge
> deal, but it's rather undesirable because there's no indication that its
> implementation is arch-specific, and trying to use it in code built for s=
390 or
> x86 (or MIPS or PPC, which are on the horizon), would fail.  I'm all for =
making
> code common where possible, but going halfway and leaving a trap for othe=
r
> architectures makes for a poor experience for developers.
>
> And again, this showing up _so_ late means it's unnecessarily difficult t=
o clean
> things up.  Which is kinda the whole point of getting thing into linux-ne=
xt, so
> that folks that weren't involved in the original patch/series can react i=
f there
> is a hiccup/problem/oddity.

Sorry for the last minute conflict.

In all release cycles, the riscv_kvm_queue freezes by rc6 and riscv_kvm_nex=
t
is updated at least a week before sending PR.

In this case there was a crucial last minute bug found in RISC-V arch_timer
selftest patches due to which the get-reg-list selftest was broken so I
updated the offending commits in the queue itself before sending out PR.

I will definitely try my best to avoid such last minute conflict.

Regards,
Anup

>
> [1] https://lore.kernel.org/all/CAAhSdy2wFzk0h5MiM5y9Fij0HyWake=3D7vNuV1M=
ExUxkEtMWShw@mail.gmail.com
> [2] https://lore.kernel.org/all/20240307145946.7e014225@canb.auug.org.au
>
> >       KVM: riscv: selftests: Change vcpu_has_ext to a common function
> >       KVM: riscv: selftests: Add sstc timer test

