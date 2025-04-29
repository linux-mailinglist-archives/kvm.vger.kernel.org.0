Return-Path: <kvm+bounces-44791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 281BAAA0FDF
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3588216C6AD
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D343821CA14;
	Tue, 29 Apr 2025 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="LavjyAeF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C721858D
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745938893; cv=none; b=uQDsJfA5shTkGAVuodpuFaQZzx9Uj9iYbCTwHElBGDzNa7zhr5gdLWvLd+LDp2w3ZiOR5IKRltzH7zAR2bgqeI/eqMlCFwsdLVW7YS/XzMMPq+EuoH22nvNrNxDkJQOEe6zJSoo/qGGt799PpGYYQ7+WZnFYN3dt6OWOR5MPR+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745938893; c=relaxed/simple;
	bh=zBrKqhCfsBSldz6E7mX68CuqQb8grQqysBjP6gFyGPk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YrRIRIo9Wt0Q6foTP6WlPFFKfsgx6aX158VeuprMNvk8YjBV742HMj7xtE4WkicAWAaVtKFvL8mii86ePzeDUp1WsFmrBIpWNm08oq5/U9oPMnkXyJxmeOzBsCB0CMF8uL7PE300esuTu8CnqW9LRHaG9WclpN2xfzlUelPuz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=LavjyAeF; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85b3f92c8dfso173258939f.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1745938890; x=1746543690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHS4l6RlCuYVQuHb0jm+ZP/YKZBOyNxDq6lKlO8yTMI=;
        b=LavjyAeFr4biUpsjvilexN/UxSilVlE0c8oWzEsfHYeu57mEiHV9aZ6nFizuFaMfN5
         Q7BRMiOgC2PpblG6NMmZpiDau+sMUHyjdp2VSU8kN7cIzTptdI1K5KC3F9hJH55Q2bCo
         hmT2OY7yJZEDKV73JMXugvrg4xL7vqOKPKK33GsZ1uIkl6s4n6r9D+lW0hV5fzsdRS8d
         69gTwX3pIY6BywvyDk0M/LH2BKWOBzOMdqGG5X0bVkDKyBdoWXFYKfjffN3SmDMnzaeK
         PW38iek2XzDdY0V2V4cY/cPjVsMJiNWBdJ+jISLcSKQoFxRhJteNF2QmYbgNWwHZScwi
         MU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745938890; x=1746543690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHS4l6RlCuYVQuHb0jm+ZP/YKZBOyNxDq6lKlO8yTMI=;
        b=DT0rkyREF02MJYnNBcsuLgt5B2N9dQJuGLpliwwuv4IM7LSRzDweJ6PTmr/LJoJ2IX
         zlXE03OsCyjiNuvDi1DWLYvyiJga8HGcyRcZqD4bLBcmY2i4E9PjfTLm6Z6ogeuxXuBV
         FB/PCdJnbJHWhvHcGkI6TOwYj/VvPiht9cK9oNGpAfN+/40dACKrLbllcx+v1n4+cG40
         uH+Tphy/jSEDv2rhj2owb6hrCabaOAggW9sLst2eDvi2WZJ763qCFHnAaZylMEskyy0Q
         x0YydNbNdVzuojzA3LZOff4u2IZhHnzjBe5FdDnx56NwwlDT1TlmW5GvEunBsh338zVc
         fCLg==
X-Forwarded-Encrypted: i=1; AJvYcCVm3BH4dtA68Chynj8oS/+KT9j3rtnoHmLrbE8GOPx5hBx4+cTgyTAmjvvTmlGIxvoBsEo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4LZRcx/sm/IRL4VKd1I12iK06MSdWfDMd+1C91yl8Mxgpk60i
	GqNOvG/tN3xiWckGP8AtcJBGGoQ89ShCu/dehyCheQ+elxJhtFh/xS1pP/oQA+/aiS9aohEPDLl
	9RN2xazLsosITAeDg7hLUX7U595vqIYsbQL3Byw==
X-Gm-Gg: ASbGnctyIbbQIM0uXqDb3IXKF+cY+KsHQe1mW0MzhFBK53ceOxcb+KVVQYLpnZ8nB6R
	1/fqjesXV5ROu6VUu5baapLn/4+FODQGShtnky6sbK/Jf55Ywuv5NPUsRtcpy5Qw8btr8eGKNVd
	h0TfIEpxsFQbdI7OiuavaMoCeTAt0vmlclJA==
X-Google-Smtp-Source: AGHT+IHo2DZ3uMBqZ8yg3qd4VMFlyLDgboisK6S9lgCMm7JZ5BVsaB07IAemCjbCQKxGLUvsVPdmwklxacR8zt864hQ=
X-Received: by 2002:a05:6e02:3a0d:b0:3d6:d162:be02 with SMTP id
 e9e14a558f8ab-3d95d311a8cmr40608305ab.21.1745938890305; Tue, 29 Apr 2025
 08:01:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com> <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com> <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
In-Reply-To: <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 29 Apr 2025 20:31:18 +0530
X-Gm-Features: ATxdqUHbWefMOrW2Do9QiC5PVMhlBHVdqKQcPmZPNhp77_UlZJlXnw3QOAdLvxI
Message-ID: <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
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

On Tue, Apr 29, 2025 at 3:55=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
> > On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <r=
krcmar@ventanamicro.com> wrote:
> >>
> >> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> >> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <=
rkrcmar@ventanamicro.com> wrote:
> >> >> For a cleaner solution, we should add interfaces to perform the KVM=
-SBI
> >> >> reset request on userspace demand.  I think it would also be much b=
etter
> >> >> if userspace was in control of the post-reset state.
> >> >
> >> > Apart from breaking KVM user-space, this patch is incorrect and
> >> > does not align with the:
> >> > 1) SBI spec
> >> > 2) OS boot protocol.
> >> >
> >> > The SBI spec only defines the entry state of certain CPU registers
> >> > (namely, PC, A0, and A1) when CPU enters S-mode:
> >> > 1) Upon SBI HSM start call from some other CPU
> >> > 2) Upon resuming from non-retentive SBI HSM suspend or
> >> >     SBI system suspend
> >> >
> >> > The S-mode entry state of the boot CPU is defined by the
> >> > OS boot protocol and not by the SBI spec. Due to this, reason
> >> > KVM RISC-V expects user-space to set up the S-mode entry
> >> > state of the boot CPU upon system reset.
> >>
> >> We can handle the initial state consistency in other patches.
> >> What needs addressing is a way to trigger the KVM reset from userspace=
,
> >> even if only to clear the internal KVM state.
> >>
> >> I think mp_state is currently the best signalization that KVM should
> >> reset, so I added it there.
> >>
> >> What would be your preferred interface for that?
> >>
> >
> > Instead of creating a new interface, I would prefer that VCPU
> > which initiates SBI System Reset should be resetted immediately
> > in-kernel space before forwarding the system reset request to
> > user space.
>
> The initiating VCPU might not be the boot VCPU.
> It would be safer to reset all of them.

I meant initiating VCPU and not the boot VCPU. Currently, the
non-initiating VCPUs are already resetted by VCPU requests
so nothing special needs to be done.

>
> You also previously mentioned that we need to preserve the pre-reset
> state for userspace, which I completely agree with and it is why the
> reset happens later.

Yes, that was only for debug purposes from user space. At the
moment, there is no one using this for debug purposes so we
can sacrifice that.

>
> >             This way we also force KVM user-space to explicitly
> > set the PC, A0, and A1 before running the VCPU again after
> > system reset.
>
> We also want to consider reset from emulation outside of KVM.
>
> There is a "simple" solution that covers everything (except speed) --
> the userspace can tear down the whole VM and re-create it.
> Do we want to do this instead and drop all resets from KVM?

I think we should keep the VCPU resets in KVM so that handling
of system reset handling in user space remains simple. The user
space can also re-create the VM upon system reset but that is
user space choice.

Regards,
Anup

