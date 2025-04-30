Return-Path: <kvm+bounces-44845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBE2AA41CC
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F17F7A4CF3
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 04:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334A21D89E3;
	Wed, 30 Apr 2025 04:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="TtNUm2ul"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27A217BCE
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 04:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745986977; cv=none; b=VC625OsrybUEhco3+abAGgHSEJbSj/rPiztgSrxIBwFvhEkh0LZAw7HdgCTRwFVczfKnsLzmztiJbvAVUA232NG3qxvcFy4iH8tA6B0uEF0Dk4dQGGFJdgG0u+qqNlfbqQ8ffA7noEOGMM1lAJvwaKKHUOc4HrIAyAEQj0lBN3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745986977; c=relaxed/simple;
	bh=Yx6WbrttF0V4WRXtUsQP4mfcu57U09xOwR6fkBgktK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWETpjR4+lkRRid7klRCTm2ekecoiSLSe30QSYVhBr9biBKM8TrC4d3ly4KSEDdC0Zao7LGk5FsttY0kbv0hvFmeUX7gdIpkPURKPlA5fCDYiPKkn5swxXPFFb+bkBboc6UH3pw4OJ8QO4VRLeAMOG89gEQukm433y3jmulqfGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=TtNUm2ul; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d940c7ea71so22673055ab.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745986974; x=1746591774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38ct102e6rV67TAerTfgwlZVdfvCfH6VgRwQ5JTNiqY=;
        b=TtNUm2ulQ7iaNk60rJTlhN0yYQYomss26QnBhC7roBTImtDW1h1X0uZHW2oJU6mMuR
         ydQO9ikm7FIrSELS9G8oScdSlsAz1ApaNkpmhfpez6UGzsjjtKM3Q0igLjUPkI6cSz+a
         N3ukHyTojZbudLKmFN6MSSLRFPhaD9wRk3ZojCrpa1pw+tGw1cAn/EOFQsR9ahdFJoet
         yLYftqX33Ce4saYQqMP+43wVgXJ2oiGvb8Oby5+1BE//+AWdareWfItSIvRCdsniTvmA
         6VRIejzuEXui9+ptPkg2IJWcmApprQiJE6KfyB6FCG9Bhb2RLngb+A9D8EKdH2HxSuG7
         +Zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745986974; x=1746591774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38ct102e6rV67TAerTfgwlZVdfvCfH6VgRwQ5JTNiqY=;
        b=skNG6ntGyOqt7npoW9+V5bceHHq2fVQCz8TXokPVO9IygNKERBKdxcvbVbPfNfEHmO
         hpL04EmMZtQFfR8DL7ji10YEd9FXLvxIgeWPNoMFPfZlYC+aoQw9LELx05O2LRqKSzao
         dElNQG6CLELqnEX7VGLBghTGYf2Sf557mtZBsFdKi/0016gZcTi40BQ1B71Yt9Hvqih+
         NKkLOcZzLHO8L4s0DCj/wBX0DiI2aa6tQfG+RXpVmszETXY+mGFymai8dRIVgYXxVLub
         gAOn2K4PuHH8AH9UzrcxsNDPfVw2wenYQRPEgvBQFJ6KOX8lpgow5Mr3qvel43mHdZqj
         nFLw==
X-Forwarded-Encrypted: i=1; AJvYcCXMqJcQ/zhxtA5fXVHAbHtfoqCJTb2FEJjNpgxQjmAvQQVtQIqduZL0C/aroF1D+CoXU1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTeqNg4gwVNaGL+AKVkd+487lm7Mgy6kF6a0YTfTuLBqhBMTD7
	ohCu3MTcuL/ZnsfqhF7xMSwwgRZ6A5Jshl5gY/0LH14uJzdmwLf2NhQd2Qc0NNQohuETf9RB+LV
	olWDNRKCSby4/K3B6/B8x1pVDSwRrw1wkDU81tw==
X-Gm-Gg: ASbGncuOe27m5HS4El9QwHRW3KD4pGtJWFsEXDv0+PuaYmDRBwR/CVfJcffpkg7TF1N
	9Pd2357+45GOlQqFx9gjfY+tjiYKgBmiS4osDPU3G6fs549bhCghX+SA8sdE42NmwNlT/eLDK0b
	94PvVXaNC7voZn3ojElJW5ZVE=
X-Google-Smtp-Source: AGHT+IGl4iGmSaKp5RMw7EFDZJmn8F4FnfgYTHM0Ni9376soeIPJv4IoaKlXnzwrp9V2WncKuJ+CQDmMBVybP2mqJe8=
X-Received: by 2002:a05:6e02:4506:20b0:3d8:1e50:1d55 with SMTP id
 e9e14a558f8ab-3d967fc205dmr5957645ab.11.1745986974519; Tue, 29 Apr 2025
 21:22:54 -0700 (PDT)
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
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com>
In-Reply-To: <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 30 Apr 2025 09:52:43 +0530
X-Gm-Features: ATxdqUGmKl8csSBnKXlzPOE4lM8k7L-kt85DmcktMYspDC-PRgYE5KsnznLpoKg
Message-ID: <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
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

On Tue, Apr 29, 2025 at 9:51=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-04-29T20:31:18+05:30, Anup Patel <anup@brainfault.org>:
> > On Tue, Apr 29, 2025 at 3:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >>
> >> 2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
> >> > On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99=
 <rkrcmar@ventanamicro.com> wrote:
> >> >>
> >> >> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> >> >> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=
=99 <rkrcmar@ventanamicro.com> wrote:
> >> >> >> For a cleaner solution, we should add interfaces to perform the =
KVM-SBI
> >> >> >> reset request on userspace demand.  I think it would also be muc=
h better
> >> >> >> if userspace was in control of the post-reset state.
> >> >> >
> >> >> > Apart from breaking KVM user-space, this patch is incorrect and
> >> >> > does not align with the:
> >> >> > 1) SBI spec
> >> >> > 2) OS boot protocol.
> >> >> >
> >> >> > The SBI spec only defines the entry state of certain CPU register=
s
> >> >> > (namely, PC, A0, and A1) when CPU enters S-mode:
> >> >> > 1) Upon SBI HSM start call from some other CPU
> >> >> > 2) Upon resuming from non-retentive SBI HSM suspend or
> >> >> >     SBI system suspend
> >> >> >
> >> >> > The S-mode entry state of the boot CPU is defined by the
> >> >> > OS boot protocol and not by the SBI spec. Due to this, reason
> >> >> > KVM RISC-V expects user-space to set up the S-mode entry
> >> >> > state of the boot CPU upon system reset.
> >> >>
> >> >> We can handle the initial state consistency in other patches.
> >> >> What needs addressing is a way to trigger the KVM reset from usersp=
ace,
> >> >> even if only to clear the internal KVM state.
> >> >>
> >> >> I think mp_state is currently the best signalization that KVM shoul=
d
> >> >> reset, so I added it there.
> >> >>
> >> >> What would be your preferred interface for that?
> >> >>
> >> >
> >> > Instead of creating a new interface, I would prefer that VCPU
> >> > which initiates SBI System Reset should be resetted immediately
> >> > in-kernel space before forwarding the system reset request to
> >> > user space.
> >>
> >> The initiating VCPU might not be the boot VCPU.
> >> It would be safer to reset all of them.
> >
> > I meant initiating VCPU and not the boot VCPU. Currently, the
> > non-initiating VCPUs are already resetted by VCPU requests
> > so nothing special needs to be done.

There is no designated boot VCPU for KVM so let us only use the
term "initiating" or "non-initiating" VCPUs in context of system reset.

>
> Currently, we make the request only for VCPUs brought up by HSM -- the
> non-boot VCPUs.  There is a single VCPU not being reset and resetting
> the reset initiating VCPU changes nothing. e.g.
>
>   1) VCPU 1 initiates the reset through an ecall.
>   2) All VCPUs are stopped and return to userspace.

When all VCPUs are stopped, all VCPUs except VCPU1
(in this example) will SLEEP because we do
"kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP)"
so none of the VCPUs except VCPU1 (in this case) will
return to userspace.

>   3) Userspace prepares VCPU 0 as the boot VCPU.
>   4) VCPU 0 executes without going through KVM reset paths.

Userspace will see a system reset event exit for the
initiating VCPU by that time all other VCPUs are already
sleeping with mp_state =3D=3D KVM_MP_STATE_STOPPED.

>
> The point of this patch is to reset the boot VCPU, so we reset the VCPU
> that is made runnable by the KVM_SET_MP_STATE IOCTL.

Like I said before, we don't need to do this. The initiating VCPU
can be resetted just before exiting to user space for system reset
event exit.

>
> For design alternatives, it is also possible to reset immediately in an
> IOCTL instead of making the reset request.
>
> >> You also previously mentioned that we need to preserve the pre-reset
> >> state for userspace, which I completely agree with and it is why the
> >> reset happens later.
> >
> > Yes, that was only for debug purposes from user space. At the
> > moment, there is no one using this for debug purposes so we
> > can sacrifice that.
>
> We still can't immediately reset the boot VCPU, because it might already
> be in userspace.  We don't really benefit from immediately resetting the
> initiating VCPU.
> Also, making the reset request for all VCPUs from the initiating VCPU
> has some undesirable race conditions we would have to prevent, so I do
> prefer we go the IOCTL reset way.

All VCPUs are sleeping with mp_state =3D=3D KVM_MP_STATE_STOPPED
when userspace sees system reset exit on the initiating VCPU so I don't
see any race condition if we also reset the initiating VCPU before exiting
to userspace.

>
> >> >             This way we also force KVM user-space to explicitly
> >> > set the PC, A0, and A1 before running the VCPU again after
> >> > system reset.
> >>
> >> We also want to consider reset from emulation outside of KVM.
> >>
> >> There is a "simple" solution that covers everything (except speed) --
> >> the userspace can tear down the whole VM and re-create it.
> >> Do we want to do this instead and drop all resets from KVM?
> >
> > I think we should keep the VCPU resets in KVM so that handling
> > of system reset handling in user space remains simple. The user
> > space can also re-create the VM upon system reset but that is
> > user space choice.
>
> Ok.

Regards,
Anup

