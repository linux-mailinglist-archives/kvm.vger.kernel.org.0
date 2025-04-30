Return-Path: <kvm+bounces-44883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29017AA481B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5B721B676D8
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E5D2356D3;
	Wed, 30 Apr 2025 10:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Af8K5xNi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDBE27453
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 10:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746008247; cv=none; b=f3YkzAfqhoh/pW6Y+DxzntcPC4LsGNJEjXJVo3VC8B3qInYwirBGWBG9A6wd8pIkRYMbuTGCnV01sXDbyTK0JdLc9Z5Kyf3B0h+VbB28SP2Ho56FrHrTJmhGTS42Ei7k1YL5GDsdPxUSWZNVfEt+iUuIr8EAmSkcrN36gi+5+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746008247; c=relaxed/simple;
	bh=l6Akiwz1X/gmRhz9aerO4WHMzRbLPunTL4DkbvHyF8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDg6nfmgMCOTOxDJ+8Ti1SJPnV157x0omRY5wuh6eOcLh8Osl/QYSNmUwfHIPTT+XhmLTGyJn3Nkc2zrD9r0gB/rFYcWLgEyZu3GIytyseRjBSVkNF/zj4UXTL48yUgaOECM63aWaf/PYeejSeiNhtA+4CTZzmqOfU1etsB9DkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Af8K5xNi; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85d9a87660fso677538539f.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746008244; x=1746613044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hajr35wXoEFgGrgtJMs5DcJw47JrmZH1jIC06j4iHhQ=;
        b=Af8K5xNiSTsOR/ormiKqIj2SGC2Ny9pUaxpzpbWE0RRU/1jYcvUGYDMvCoAGQhQnVt
         cUsj0h7ddMyZsP+xm7CTKZ+SohEnM4K4qm9ul677h2Fyfcpo7IO/bnTInxMsrMub9eQZ
         bQIPUvr+euBuktaOZxYG8U1FGSZg2hKRBPl3Bz1JbNovFEhgYTZdlcIWjMX1hZidFoaL
         01RCjSgyKqjNshXigJtbuNEMU3JLuuEclX2Wq/1fThWJ4Rys126jvtD9Zaqb5KYYay4D
         w1cVtV+nVcbIIYqoQaifDq2co/fWmXWW3FQiqECYoN3jX0eJ13w2PUh93qrr0OXRVEoG
         0eWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746008244; x=1746613044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hajr35wXoEFgGrgtJMs5DcJw47JrmZH1jIC06j4iHhQ=;
        b=JF1U9moznTF1kl5+veQgo47PASOrEAr6UoYZa4e6c+nwsD02s8HoJZtjZIcu5Su2WL
         Znc/yAcb93vEAMLnzkbb6hJrxXKEJCvr8q74+uJJ/0q4kgsHmnBYPdN1gzC+/qTqaGwy
         qKP0md8H2T/XsFw2ttqbw7GofeSdxtopDPGpNA3TuxQ8IdDBqWQcvxLC51xHYsOyFqQ/
         DnRjNMmp9FJDhS7nd3SJwN9tmXV24kLsrXvajcrz5xwL2qLSOAMyPXUEZjlGZvoioWHd
         pwBXRHJObkiMBM2UoYEyWBjNTXa83lTDpdVZd3El/zudwRx3iH6QmMEHbLh2t5ZheZL6
         G3bw==
X-Forwarded-Encrypted: i=1; AJvYcCUL0Iexd17rLRkRPIMZHN+v1PTonA8pVyOeOomPtbps2t2bpivGg04ItGHXAWKEHnq3iSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1upZNUIk2ekcBar1lKhXJjpznoB79Cq55CYl3td0ES5z3B6/i
	hCqRLu1EW1+hRQ5Q0wU/ff2G++x/rQ+bfff+VvoniGER6QFhFZ7sw9Mh68SIkRRqXR1NSUHgqCc
	ztgm9IS7QH9z2yH9Rfc+HIy9wVHrsfyIIe8JW4A==
X-Gm-Gg: ASbGncvdabIL4nvDu3+148fYa6K9qoAAvox0uDGT6uaFGUEnZtyspc/EBzPUtFpC3LH
	6xUHXOtJTd9QLQ9ibGd2beNz3nz/2cYonq7OsfOG/cxP5Vyv/xkXZRT65+f/yqfvyQcfqwzOHdi
	kgTcJjkmZd6F8uU1ygNr9t8nY=
X-Google-Smtp-Source: AGHT+IGfWKyj+8R/G3n3W48fayDFA5SRi91kVSTDvys0efjshDa91rFnxHxj6m5gFXeVWQDRSR/ZJT9BcvR1UL47KAQ=
X-Received: by 2002:a05:6e02:2707:b0:3d8:1768:242f with SMTP id
 e9e14a558f8ab-3d967fa3de9mr20815675ab.2.1746008244393; Wed, 30 Apr 2025
 03:17:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com> <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com> <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com> <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com> <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
 <CAAhSdy20pq3KvbCeST=h+O5PWfs2E4uXpX9BbbzE7GJzn+pzkA@mail.gmail.com> <D9JTZ6HH00KY.1B1SKH1Z0UI1S@ventanamicro.com>
In-Reply-To: <D9JTZ6HH00KY.1B1SKH1Z0UI1S@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 30 Apr 2025 15:47:13 +0530
X-Gm-Features: ATxdqUF_q2ij9AhnCkW-YqEHHIjuO1czpMVKF6K9iOnegwjVM1IJPR_3stGj_7I
Message-ID: <CAAhSdy0TfpWQ-kC_gUUCU0oC5dR45A1v9q84H2Tj9A8kdO0d1A@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 1:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-04-30T10:56:35+05:30, Anup Patel <anup@brainfault.org>:
> > On Wed, Apr 30, 2025 at 9:52=E2=80=AFAM Anup Patel <anup@brainfault.org=
> wrote:
> >>
> >> On Tue, Apr 29, 2025 at 9:51=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <r=
krcmar@ventanamicro.com> wrote:
> >> >
> >> > 2025-04-29T20:31:18+05:30, Anup Patel <anup@brainfault.org>:
> >> > > On Tue, Apr 29, 2025 at 3:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=
=99 <rkrcmar@ventanamicro.com> wrote:
> >> > >>
> >> > >> 2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
> >> > >> > On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=
=C5=99 <rkrcmar@ventanamicro.com> wrote:
> >> > >> >>
> >> > >> >> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> >> > >> >> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=
=C5=99 <rkrcmar@ventanamicro.com> wrote:
> >> > >> >> >> For a cleaner solution, we should add interfaces to perform=
 the KVM-SBI
> >> > >> >> >> reset request on userspace demand.  I think it would also b=
e much better
> >> > >> >> >> if userspace was in control of the post-reset state.
> >> > >> >> >
> >> > >> >> > Apart from breaking KVM user-space, this patch is incorrect =
and
> >> > >> >> > does not align with the:
> >> > >> >> > 1) SBI spec
> >> > >> >> > 2) OS boot protocol.
> >> > >> >> >
> >> > >> >> > The SBI spec only defines the entry state of certain CPU reg=
isters
> >> > >> >> > (namely, PC, A0, and A1) when CPU enters S-mode:
> >> > >> >> > 1) Upon SBI HSM start call from some other CPU
> >> > >> >> > 2) Upon resuming from non-retentive SBI HSM suspend or
> >> > >> >> >     SBI system suspend
> >> > >> >> >
> >> > >> >> > The S-mode entry state of the boot CPU is defined by the
> >> > >> >> > OS boot protocol and not by the SBI spec. Due to this, reaso=
n
> >> > >> >> > KVM RISC-V expects user-space to set up the S-mode entry
> >> > >> >> > state of the boot CPU upon system reset.
> >> > >> >>
> >> > >> >> We can handle the initial state consistency in other patches.
> >> > >> >> What needs addressing is a way to trigger the KVM reset from u=
serspace,
> >> > >> >> even if only to clear the internal KVM state.
> >> > >> >>
> >> > >> >> I think mp_state is currently the best signalization that KVM =
should
> >> > >> >> reset, so I added it there.
> >> > >> >>
> >> > >> >> What would be your preferred interface for that?
> >> > >> >>
> >> > >> >
> >> > >> > Instead of creating a new interface, I would prefer that VCPU
> >> > >> > which initiates SBI System Reset should be resetted immediately
> >> > >> > in-kernel space before forwarding the system reset request to
> >> > >> > user space.
> >> > >>
> >> > >> The initiating VCPU might not be the boot VCPU.
> >> > >> It would be safer to reset all of them.
> >> > >
> >> > > I meant initiating VCPU and not the boot VCPU. Currently, the
> >> > > non-initiating VCPUs are already resetted by VCPU requests
> >> > > so nothing special needs to be done.
> >>
> >> There is no designated boot VCPU for KVM so let us only use the
> >> term "initiating" or "non-initiating" VCPUs in context of system reset=
.
>
> That is exactly how I use it.  Some VCPU will be the boot VCPU (the VCPU
> made runnable by KVM_SET_MP_STATE) and loaded with state from userspace.
>
> RISC-V doesn't guarantee that the boot VCPU is the reset initiating
> VCPU, so I think KVM should allow it.

We do allow any VCPU to be the boot VCPU. I am not sure why you
think otherwise.

>
> >> > Currently, we make the request only for VCPUs brought up by HSM -- t=
he
> >> > non-boot VCPUs.  There is a single VCPU not being reset and resettin=
g
> >> > the reset initiating VCPU changes nothing. e.g.
> >> >
> >> >   1) VCPU 1 initiates the reset through an ecall.
> >> >   2) All VCPUs are stopped and return to userspace.
> >>
> >> When all VCPUs are stopped, all VCPUs except VCPU1
> >> (in this example) will SLEEP because we do
> >> "kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP)"
> >> so none of the VCPUs except VCPU1 (in this case) will
> >> return to userspace.
>
> Userspace should be able to do whatever it likes -- in my example, all
> the VCPUs are brought to userspace and a different boot VCPU is
> selected.

In your example, the VCPU1 (initiating VCPU) need not be the
boot VCPU after system reset. The user space can setup some
other VCPU as boot VCPU (by setting its MPSTATE, PC, A0,
and A1) and simply do ioctl_run() for the initiating VCPU without
changing its MPSTATE.

>
> (Perhaps userspace wanted to record their reset pre-reset state, or
>  maybe it really wants to boot with a designated VCPU.)
>
> >> >   3) Userspace prepares VCPU 0 as the boot VCPU.
> >> >   4) VCPU 0 executes without going through KVM reset paths.
> >>
> >> Userspace will see a system reset event exit for the
> >> initiating VCPU by that time all other VCPUs are already
> >> sleeping with mp_state =3D=3D KVM_MP_STATE_STOPPED.
> >>
> >> >
> >> > The point of this patch is to reset the boot VCPU, so we reset the V=
CPU
> >> > that is made runnable by the KVM_SET_MP_STATE IOCTL.
> >>
> >> Like I said before, we don't need to do this. The initiating VCPU
> >> can be resetted just before exiting to user space for system reset
> >> event exit.
>
> You assume initiating VCPU =3D=3D boot VCPU.
>
> We should prevent KVM_SET_MP_STATE IOCTL for all non-initiating VCPUs if
> we decide to accept the assumption.

There is no such assumption.

>
> I'd rather choose a different design, though.
>
> How about a new userspace interface for IOCTL reset?
> (Can be capability toggle for KVM_SET_MP_STATE or a straight new IOCTL.)
>
> That wouldn't "fix" current userspaces, but would significantly improve
> the sanity of the KVM interface.

I believe the current implementation needs a few improvements
that's all. We certainly don't need to introduce any new IOCTL.

Also, keep in mind that so far we have avoided any RISC-V
specific KVM IOCTLs and we should try to keep it that way
as long as we can.

Regards,
Anup

