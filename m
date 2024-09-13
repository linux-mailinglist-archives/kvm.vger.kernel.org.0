Return-Path: <kvm+bounces-26782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE8B9777FA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 06:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D14492864B6
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 04:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7C11C6893;
	Fri, 13 Sep 2024 04:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="qno/KKHG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1281514CE
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 04:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726201962; cv=none; b=iT+UiPOlcO+1lJREGrgrMiyZrEzsaiMUEVicPdXJyopnIhjEGwVNl485QbCh3CXCHfyUdseb9MKQw3S0+OE3MX5cJ9h7k5B8FnHfhJ1uaXnLN9fzosR2gCN6INP8AA5ahehBE2mdRiM4LasSOVN6w9wCFnh+amRSzoGQ6F+nBXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726201962; c=relaxed/simple;
	bh=7/sXqifHGzfl2SRL3Mw1Pln76S7FBnwdNmeHZ7WAGME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoEfuLUZzqlP4nUpv67Y5u6edO7l0noX9Zkgm50+VkzrbqCiow7mPM94Teh6wr6eIL8OIV0kCMcEU8tq+FzN1yEgeq2uUZCQ92jNYmVaqTOTgs14Zh4rkEUE2EW18brG6+oU5FaiFD2k9KQn11Ml09qGKBHYxJ3N4eeEDwNhjQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=qno/KKHG; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-82a626d73efso65097839f.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 21:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1726201959; x=1726806759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w54pp7KLxKfAIPY5581fcuCi0omX1JlS2WnZJ/hN1G4=;
        b=qno/KKHG/cdhGE7KRcU9DH/rSJnZ0qJLaruKCVrItKzYUKphrwoLWN5WTgdHrlPFSi
         be6qCoLmZ7PCWuOLf8YRBMAwJetYqaTTSmG3Ab7AQ7PoTNEX2u2osPY38nhM0xW2eQ4F
         k/cpAF8qjTvNXdQCD/FxZnoageNlYQ3+1azbPh2NB3CZVxhj+Jw36FZ0H7AYGpuw7W0a
         /tlI5rk+QWdGrxYZCbmIz2dYJbEybjPs5F9btB6Nbv2p7ddOYCMVgzO1qNukWkFytYAu
         bjRPz8jJnb6qxQnR+aAnB1Tve6zsHo1PcRVlFdATPsgd6B0SWJs514aGrKc1GxOyhBH2
         A6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726201959; x=1726806759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w54pp7KLxKfAIPY5581fcuCi0omX1JlS2WnZJ/hN1G4=;
        b=p6vVWOQvtMSrB9O7EJwyggxiRt+SW5hf6+kwk2dFGLxFGYItFCUwwC6HbG2WM/94Mn
         C2j1D2p70vkT5xLgBNEAbsI1psbHWciC+y616Vmsmm60Dff2G3c54aWPG0Uk8lmfwwxm
         sYxXQqYiSxwXZvNplJXqvjNrc1YMe+yN2TA04+cab35VMwCAtjVrjINihkeRd8W1Wn56
         wU8VOdfwY3AsDmaDdQNiuNVRF+FnO6ddPNjkZNWzF/r6ukPXdnQgWC4CO6S8/Wuw+zIx
         gdQWKxdf7vg7zvj4B5R/nB1Bl/cuFXPibTfSqkPFj8hy0XUb1KhJ5mPUedK+e00I2rjc
         pNrA==
X-Forwarded-Encrypted: i=1; AJvYcCUEtHs0H+u+awaOGSesPDu8w2yDQL6zkuJ5+uxzMKsqcROw9wVH/ewUs64+9lao46GjvSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYmuoJtY6cPW/KPrMJPgJ2CT2pWKw8SF+9pU4KXTDMDnhcIuZZ
	32knW3NxycUnij0uBaYna5H67zdx0VxPMZCLzxgE1VZ7lltFbiOEJptRCVsRY2Gn0S5opsoFTkT
	RuSn10S1e0X5wa+toVDo8h15rk8IfuCrBRrkVaA==
X-Google-Smtp-Source: AGHT+IE+2QF6HwF17VErmVADwVFkI6DzAjV6r3QI8XJIUdFcDK2edj5QNTbv9dEzH2k7P2s7H77k2KRWduAraPSF2Sg=
X-Received: by 2002:a05:6e02:154f:b0:3a0:4250:165f with SMTP id
 e9e14a558f8ab-3a0847d0c17mr55015385ab.0.1726201959580; Thu, 12 Sep 2024
 21:32:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <83c2234d582b7e823ce9ac9b73a6bbcf63971a29.1724911120.git.zhouquan@iscas.ac.cn>
 <b5128162-278a-4284-8271-b2b91dc446e1@iscas.ac.cn> <380f4da9-50e9-4632-bdc8-b1723eb19ca5@sifive.com>
In-Reply-To: <380f4da9-50e9-4632-bdc8-b1723eb19ca5@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 13 Sep 2024 10:02:28 +0530
Message-ID: <CAAhSdy1zSTWuTW1KohUDXr9UXUx-QL1A30AUkTGoL7W2L7JWLQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Redirect instruction access fault trap to guest
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Quan Zhou <zhouquan@iscas.ac.cn>, ajones@ventanamicro.com, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 6:09=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> On 2024-09-12 4:03 AM, Quan Zhou wrote:
> >
> > On 2024/8/29 14:20, zhouquan@iscas.ac.cn wrote:
> >> From: Quan Zhou <zhouquan@iscas.ac.cn>
> >>
> >> The M-mode redirects an unhandled instruction access
> >> fault trap back to S-mode when not delegating it to
> >> VS-mode(hedeleg). However, KVM running in HS-mode
> >> terminates the VS-mode software when back from M-mode.
> >>
> >> The KVM should redirect the trap back to VS-mode, and
> >> let VS-mode trap handler decide the next step.
> >>
> >> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> >> ---
> >>   arch/riscv/kvm/vcpu_exit.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> >> index fa98e5c024b2..696b62850d0b 100644
> >> --- a/arch/riscv/kvm/vcpu_exit.c
> >> +++ b/arch/riscv/kvm/vcpu_exit.c
> >> @@ -182,6 +182,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, str=
uct
> >> kvm_run *run,
> >>       ret =3D -EFAULT;
> >>       run->exit_reason =3D KVM_EXIT_UNKNOWN;
> >>       switch (trap->scause) {
> >> +    case EXC_INST_ACCESS:
> >
> > A gentle ping, the instruction access fault should be redirected to
> > VS-mode for handling, is my understanding correct?
>
> Yes, this looks correct. However, I believe it would be equivalent (and m=
ore
> efficient) to add EXC_INST_ACCESS to KVM_HEDELEG_DEFAULT in asm/kvm_host.=
h.
>
> I don't understand why some exceptions are delegated with hedeleg and oth=
ers are
> caught and redirected here with no further processing. Maybe someone thou=
ght
> that it wasn't valid to set a bit in hedeleg if the corresponding bit was
> cleared in medeleg? But this doesn't make sense, as S-mode cannot know wh=
ich
> bits are set in medeleg (maybe none are!).
>
> So the hypervisor must either:
>  1) assume M-mode firmware checks hedeleg and redirects exceptions to VS-=
mode
>     regardless of medeleg, in which case all four of these exceptions can=
 be
>     moved to KVM_HEDELEG_DEFAULT and removed from this switch statement, =
or
>
>  2) assume M-mode might not check hedeleg and redirect exceptions to VS-m=
ode,
>     and since no bits are guaranteed to be set in medeleg, any bit set in
>     hedeleg must _also_ be handled in the switch case here.
>
> Anup, Atish, thoughts?

Any exception delegated to VS-mode via hedeleg means it is directly deliver=
ed
to VS-mode without any intervention of HS-mode. This aligns with the RISC-V
priv specification and there is no alternate semantics assumed by KVM RISC-=
V.

At the moment, for KVM RISC-V we are converging towards the following
approach:

1) Only delegate "supervisor expected" traps to VS-mode via hedeleg
which supervisor software is generally expected to directly handle such
as breakpoint, user syscall, inst page fault, load page fault, and store
page fault.

2) Other "supervisor unexpected" traps are redirected to VS-mode via
software in HS-mode because these are not typically expected by supervisor
software and KVM RISC-V should at least gather some stats for such traps.
Previously, we were redirecting such unexpect traps to KVM user space
where the KVM user space tool will simply dump the VCPU state and kill
the Guest/VM.

The inst misaligned trap was historically always set in hedeleg but we
should update it based on the above approach.

>
> Regards,
> Samuel
>
> >
> >>       case EXC_INST_ILLEGAL:
> >>       case EXC_LOAD_MISALIGNED:
> >>       case EXC_STORE_MISALIGNED:
> >>
> >> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>

Regards,
Anup

