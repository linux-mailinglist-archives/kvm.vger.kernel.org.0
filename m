Return-Path: <kvm+bounces-47655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F85CAC2EA7
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 11:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 733F51BA6DC0
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 10:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC61199938;
	Sat, 24 May 2025 09:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PeegiFVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184EC189F57
	for <kvm@vger.kernel.org>; Sat, 24 May 2025 09:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748080781; cv=none; b=HHfZB24d8BIhhb/XyNNK7c0zTmA+csit+k1VGUuzWI0MiTmDpyD1ajboUjRFBnCiFzsLNlND1rhLxaNGEW/54WqGeorungd8LFKIgX+I+EhyOuuv4sddThE7yaDz1Nl4H6n6u0GBlNws2NwOzmupK68G2w6lOTtOhkdR/yZLbZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748080781; c=relaxed/simple;
	bh=1+ccjy4J6ssUAnWhBMooJBSNzGxpchE41YxEikSYJuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m55og4s/zohKJO8/XoyUcH+Zl0dUFWNozTc7G2AgtqSX+K6eQVpTRpdGFgOREJS+waNcPJ48OkxvMt1rxNAt9dweXE8eeSPniU91m0M9kINrH3QsIFTyIzsrKnxErWMBEXU9+aymxVHpyW2GzwO0cCtrZxNPmuoe50XE4qdz3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=PeegiFVn; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-32909637624so7202041fa.1
        for <kvm@vger.kernel.org>; Sat, 24 May 2025 02:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748080777; x=1748685577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwk0CPkVmc1YZ0kia1s+sTbANdHsNTOd/9lbjHB/VFE=;
        b=PeegiFVnWf5Ts2uH6v3hI9G/2NFDJ2te2HcYumJXAJyj891pgTi5cV5FiiRmrZyfHi
         qAKuFfYug+ZtDPqSwUzk0fptCWjZsSWtzdlHQu8QKLYJPbSv3rfeeDXb3iWkr2mOh5bd
         5kRhZ3bvbij8GTVBu5IHmYk2jfobUiqOY3SRLZa3GvuEOnrFFqQm4/rSggRC0i3+egdw
         o3UagTgAxLCyz+h3IYmQPcPJ/ppOCifbJxWH94t24AseD0QAPGog6rGwnLmawQOZWCoi
         xWdhK2EEPsorSpyIbG1bTcCDRePMK9ZFK5HZssmfUnDKbaOMgRqkXRRk67CrAJJlnWxg
         sWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748080777; x=1748685577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwk0CPkVmc1YZ0kia1s+sTbANdHsNTOd/9lbjHB/VFE=;
        b=bLwyJpJyf/ndBiZRxQYGNDXTMRTZpUjy0q/YwRpwLbaXcmK2k7ifaEBDJvAqRFjUDu
         UM1NK/N/L9dIrwQlAR/YPl2pgpoUMEsLUdq7Uldb0LvsD8v0k8j72NTHAUG1SfU8eJHh
         MLJqjPNk1UU9IM3Yu8wjiGs067xPMlkuWrKK7dH5kxr3Fl/qbQMFSTe+XrxH61jQkEkH
         T+e8weRMbkjvTkp4MoyguestjNTXwec8ZrS4QZ0b4nw9Q9uHL+KNlIYOtpncO+J1wt6z
         88FefSISOuDO87EiSO6w6muoQIF/se8KZX7DxRCTdR6+nfr/RMuNAwFH6g3ENKRMBNEx
         3vXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWGjeZJ0yZxaxFpgiQp0pDxRwxOTXSJCM0EbhhY86UsKB6aj+b/mFE4sxKplhiJONY+5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMrExx4REoJZnbXtdPCvTMMCsVCHPIn0GlJosy7pVacAGHopxD
	hwZ0mZCDbXXti/3g08X6h0D4YPyWSXMYEE80VzTT9Ii9PMqOYVsCNL8h77Ms42NlmQ49Sx8FSuj
	emGvcbPW9Otn7onoNrH8/yZ+PS80iRRo0COeIO8D3oQ==
X-Gm-Gg: ASbGncvAsFCpKGVozgt/QvoHKBblWPVqrBqzwtTNyS3jDAtwESdpNBsLahx6IevV5Bb
	BqTM+OOdHQYmZ6+DQUHwvaoC6QHMVGHCAm8kW6IbSm++5G5qTXM7Uzr4T/UHRZDeKqL1PU/HADK
	Vlfgvdtc55bAJAxDHI+57H8mkRh4o+52t9
X-Google-Smtp-Source: AGHT+IHjgrohb9C7yK1DIb8LPLEOKiD2vUkC6Rdz0ITXvpl70EQUPs/0DeMIVSzjubHDmyPSRoXujAeKMH9X0LsH5zI=
X-Received: by 2002:a05:651c:1508:b0:329:23c5:6408 with SMTP id
 38308e7fff4ca-3295b9c6db5mr5687001fa.16.1748080777039; Sat, 24 May 2025
 02:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
 <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev> <DA3CUGMQXZNW.2BF5WWE4ANFS0@ventanamicro.com>
 <CAK9=C2Xi3=9JL5f=0as2nEYKuRVTtJoL6Vdt_y2E06ta6G_07A@mail.gmail.com> <DA3FGGI5PEZG.3T26KJXT2QO8M@ventanamicro.com>
In-Reply-To: <DA3FGGI5PEZG.3T26KJXT2QO8M@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sat, 24 May 2025 15:29:24 +0530
X-Gm-Features: AX0GCFvjN4tLJf931vhSTBQcQ-Oi7hhKwuha27TH5Ttck32Fq0uFOwLQ8zCE2Zw
Message-ID: <CAK9=C2Xbx-bHUwXXUM4oVvOhnzhK80ygvTzfMNu0-DkcLx_8Og@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] RISC-V: KVM: VCPU reset fixes
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 2:50=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-05-23T13:38:26+05:30, Anup Patel <apatel@ventanamicro.com>:
> > On Fri, May 23, 2025 at 12:47=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <r=
krcmar@ventanamicro.com> wrote:
> >>
> >> 2025-05-22T14:43:40-07:00, Atish Patra <atish.patra@linux.dev>:
> >> > On 5/15/25 7:37 AM, Radim Kr=C3=84m=C3=83=C2=A1=C3=85 wrote:
> >> >> Hello,
> >> >>
> >> >> the design still requires a discussion.
> >> >>
> >> >> [v3 1/2] removes most of the additional changes that the KVM capabi=
lity
> >> >> was doing in v2.  [v3 2/2] is new and previews a general solution t=
o the
> >> >> lack of userspace control over KVM SBI.
> >> >>
> >> >
> >> > I am still missing the motivation behind it. If the motivation is SB=
I
> >> > HSM suspend, the PATCH2 doesn't achieve that as it forwards every ca=
ll
> >> > to the user space. Why do you want to control hsm start/stop from th=
e
> >> > user space ?
> >>
> >> HSM needs fixing, because KVM doesn't know what the state after
> >> sbi_hart_start should be.
> >> For example, we had a discussion about scounteren and regardless of wh=
at
> >> default we choose in KVM, the userspace might want a different value.
> >> I don't think that HSM start/stop is a hot path, so trapping to
> >> userspace seems better than adding more kernel code.
> >
> > There are no implementation specific S-mode CSR reset values
> > required at the moment.
>
> Jessica mentioned that BSD requires scounteren to be non-zero, so
> userspace should be able to provide that value.
>
> I would prefer if KVM could avoid getting into those discussions.
> We can just just let userspace be as crazy as it wants.

The supervisor OS must not expect a particular state of S-mode
CSRs other than what is defined in the boot protocol or the SBI
specification.

Like mentioned before, scounteren setup in KVM RISC-V and
OpenSBI is a HACK for buggy OSes which don't set up scounteren
CSR correctly when a HART comes-up. Even KVM user space
should not entertain such HACKs.

>
> >                         Whenever the need arises, we will extend
> > the ONE_REG interface so that user space can specify custom
> > CSR reset values at Guest/VM creation time. We don't need to
> > forward SBI HSM calls to user space for custom S-mode CSR
> > reset values.
>
> The benefits of adding a new ONE_REG interface seem very small compared
> to the drawbacks of having extra kernel code.

Forwarding HSM stop to userspace will slow down CPU hotplug
on Guest side. Further, this directly impacts SBI system suspend
performance for Guest because Guest is supposed to turn-off all
VCPUs except one before entering the SBI system suspend state.

>
> If userspace would want to reset or setup new multi-VCPUs VMs often, we
> could add an interface that loads the whole register state from
> userspace in a single IOCTL, because ONE_REG is not the best interface
> for bulk data transfer either.

Instead of inventing a new interface, we can simply improve the
ONE_REG interface to allow bulk read/write of multiple ONE_REG
registers which will benefit other architectures as well.

If required in the future, this bulk ONE_REG read/write interface
can also be used to load reset state of VCPU CSRs.

>
> >> Forwarding all the unimplemented SBI ecalls shouldn't be a performance
> >> issue, because S-mode software would hopefully learn after the first
> >> error and stop trying again.
> >>
> >> Allowing userspace to fully implement the ecall instruction one of the
> >> motivations as well -- SBI is not a part of RISC-V ISA, so someone mig=
ht
> >> be interested in accelerating a different M-mode software with KVM.
> >>
> >> I'll send v4 later today -- there is a missing part in [2/2], because
> >> userspace also needs to be able to emulate the base SBI extension.
> >>
> >
> > [...]          The best approach is to selectively forward SBI
> > calls to user space where needed (e.g. SBI system reset,
> > SBI system suspend, SBI debug console, etc.).
>
> That is exactly what my proposal does, it's just that the userspace says
> what is "needed".

Nope, the approach taken by your patch is problematic because
for example userspace might disable SBI RFENCE or SBI PMU
with no means to implement these SBI extensions in user space.

We can't blindly forward an SBI extension to userspace when
userspace lacks the capability to implement this extension.

>
> If we started with this mechanism, KVM would not have needed to add
> SRST/SUSP/DBCN SBI emulation at all -- they would be forwarded as any
> other unhandled ecall.

SBI SRST extension is implemented in kernel space because
we are re-using the existing KVM_EXIT_SYSTEM_EVENT so
that we can also re-use existing KVM_EXIT_SYSTEM_EVENT
related code on userspace side.

SBI SUSP and DBCN are already forward to user space and
we only have a minimal code in kernel space to ensure that:
1) In-kernel SBI BASE extension is aware of these extensions
2) These are forwarded to userspace only when userspace
    enables these extensions.

In addition to the above, we are blindly forwarding SBI
experimental and vendor extensions to user space so
user space can do its own thing by implementing these
extensions.

Regards,
Anup

