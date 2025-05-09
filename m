Return-Path: <kvm+bounces-46063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BC9AB1361
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 14:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 200593B5788
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86ECA290BC2;
	Fri,  9 May 2025 12:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="XOTWavjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BB12900B5
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 12:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746793785; cv=none; b=WpjYeYx1lEAHqNFjBy8tlJdWeZ2SjP0O4eUrtxIlANmo2H8hAFd24dYK63pn9JPimo5msRWbVoHF7zNnai3BPoBzeTRmwi/11Vc9YtCCUZPigpqhVOz2DzXpaiaGWJQluB1Cbj1IMc5JOqbcDSpc4rh688M1a9iPM9HVMdxJVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746793785; c=relaxed/simple;
	bh=sFuyvUI2Q8wKOM1dcBqZnHhZp3tnHs1TQoRCszgMphg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AkRcBdINEPtYNme1/9XSGzrfAUFXaxnCfm1eIYMKhBmTRLCHnlCVY9DXFpBHkFtTrQWtvZ6MByR+Asae4cbb1Ewk+KDuEjHE5tedis93yk8060X03mh5ldVgFn1jen8FLhKwYIUq1/1qAAHENx9L112P5j/rUPiQhpwqSEpd2E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=XOTWavjH; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8647e143f28so172317339f.1
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 05:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746793783; x=1747398583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmSXbLbqCzPF90SNiwdHQn9vNmHfXn9lOr1cdvWu+qo=;
        b=XOTWavjHRMf/uXjiaxu5UzOhIq/wXx0YhulXtt6hnFV+ZywF3tL7mva3DQtW7eS1aW
         Hbo3NAjaswMz9Vp6kzyIVWbM2hO/sEdnScGkcQdtUhKDfsrkgMPlQAvUEYg03Mk4BT1C
         NFmjXps9uWsHwAnqp5QDxueRQv86HvE/ZyJn3WriMC5UTFI7u9uc547g1oFtPvcb6ynx
         pd4DfNe9UgNdYl02f0gIFIA2V2XszVjRFLHXlvKoCgkGTaxW8pwM+P5ozRQFrofhzmty
         od2QeoD1/OsgrIcFQNt++bxOPzZw5hMGPw0Z95mcxjF4TclKojq85cinc0uw1V2u634Y
         tG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746793783; x=1747398583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmSXbLbqCzPF90SNiwdHQn9vNmHfXn9lOr1cdvWu+qo=;
        b=sVV0lq7X9mnEYXpymL515V6ejLkQmq/B+N8xyGlZEe86Zkw/t/cNbIqpAEw24HCAe+
         z/ylASSNSlsqusKlqFu9dJYV/gvtGOfEyzHRE+x24O/Ck7ZdgPzWdzYbyKgMYkfL7nuB
         tZirpvimz9ShaqSKJ2tqhykMSBCFylusEreELR67JxiTqKjxyMGKX4w5ezXtkZv6nMW5
         XgrpP5PhTJTGLOqa3g2QNN8iH0X6Aque1fLSU5LgZboJPlPQIfRb4x8XgZKXG/IX79Jh
         gCbq0LmPMw2Qx3GDqyTXV2/xbOC0FmcC/CXVEkyUHjXqW/xW4Xoy3Hp6imHFTg+B/+4E
         wVDg==
X-Forwarded-Encrypted: i=1; AJvYcCWvfXHpVJ9QdVtCLvGwpni9U5S3VThJmqjUpfw2BAZoNAyvAksOY0+GB2WxOKTeSIQKysw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLirK9SnTWwlbV2HTYZEwncNaTWC1yeRfj3Czpv+Ej+gctvJgx
	kpRLpp8u0Sk/9pmUxRhm8qH1IUDU1YZjIfB3PN5Zzw/jUq9MlcNo8QPPK7NCLCYK97Nj/N4gd1s
	JNQf1UulBa3RgAoL3t39ZhU1Julw8OADE9SypNw==
X-Gm-Gg: ASbGncvd7HOLJcRNXYFQ50sw6ccV489lF4LE+Cvluwdt8APupqxeP30POvOS3c5akrU
	5VK8K+ktMJ8Hb/GnYvQoauZj5gtwGTdb3ukSemzMCFVS8rJ+hhCANb/ik2Ac3xfQeu3lrod1UjP
	FaT4gKzD83ToiNDK0vv0a3I8QVSbcaMf11OA==
X-Google-Smtp-Source: AGHT+IHp3DAd3qnbQTzEXrr/AOZUFWtye6vkktK43JI1h3+333nR09AfAjWbSTrZebXAYTQjM4E8ILVD9YcJzu9MLfI=
X-Received: by 2002:a05:6e02:1605:b0:3d0:239a:c46a with SMTP id
 e9e14a558f8ab-3da7e1e6ff5mr39960875ab.9.1746793779664; Fri, 09 May 2025
 05:29:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com>
 <20250508142842.1496099-4-rkrcmar@ventanamicro.com> <CAAhSdy2nOBndtJ46yHbdjc2f0cNoPV3kjXth-q57cXt8jZA6bQ@mail.gmail.com>
 <D9RHYLQHCFP1.24E5305A5VDZH@ventanamicro.com> <CAAhSdy2U_LsoVm=4jdZQWdOkPkCH8c2bk6rsts8rY+ZGKwVuUg@mail.gmail.com>
 <20250509-0811f32c1643d3db0ad04f63@orel>
In-Reply-To: <20250509-0811f32c1643d3db0ad04f63@orel>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 9 May 2025 17:59:28 +0530
X-Gm-Features: AX0GCFsIuiVVtRxrNte_DR3qLk13RCLnfai43T5xiVxY6FHBVScamxZ1lBQWA4g
Message-ID: <CAAhSdy389g=cvi81e7SKAi=2KTC2y9bd17aHniTUr4RNY=Kokg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
To: Andrew Jones <ajones@ventanamicro.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 5:49=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Fri, May 09, 2025 at 05:33:49PM +0530, Anup Patel wrote:
> > On Fri, May 9, 2025 at 2:16=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
> > >
> > > 2025-05-09T12:25:24+05:30, Anup Patel <anup@brainfault.org>:
> > > > On Thu, May 8, 2025 at 8:01=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 =
<rkrcmar@ventanamicro.com> wrote:
> > > >>
> > > >> Add a toggleable VM capability to modify several reset related cod=
e
> > > >> paths.  The goals are to
> > > >>  1) Allow userspace to reset any VCPU.
> > > >>  2) Allow userspace to provide the initial VCPU state.
> > > >>
> > > >> (Right now, the boot VCPU isn't reset by KVM and KVM sets the stat=
e for
> > > >>  VCPUs brought up by sbi_hart_start while userspace for all others=
.)
> > > >>
> > > >> The goals are achieved with the following changes:
> > > >>  * Reset the VCPU when setting MP_STATE_INIT_RECEIVED through IOCT=
L.
> > > >
> > > > Rather than using separate MP_STATE_INIT_RECEIVED ioctl(), we can
> > > > define a capability which when set, the set_mpstate ioctl() will re=
set the
> > > > VCPU upon changing VCPU state from RUNNABLE to STOPPED state.
> > >
> > > Yeah, I started with that and then realized it has two drawbacks:
> > >
> > >  * It will require larger changes in userspaces, because for
> > >    example QEMU now first loads the initial state and then toggles th=
e
> > >    mp_state, which would incorrectly reset the state.
> > >
> > >  * It will also require an extra IOCTL if a stopped VCPU should be
> > >    reset
> > >     1) STOPPED -> RUNNING (=3D reset)
> > >     2) RUNNING -> STOPPED (VCPU should be stopped)
> > >    or if the current state of a VCPU is not known.
> > >     1) ???     -> STOPPED
> > >     2) STOPPED -> RUNNING
> > >     3) RUNNING -> STOPPED
> > >
> > > I can do that for v3 if you think it's better.
> >
> > Okay, for now keep the MP_STATE_INIT_RECEIVED ioctl()
> >
> > >
> > > >>  * Preserve the userspace initialized VCPU state on sbi_hart_start=
.
> > > >>  * Return to userspace on sbi_hart_stop.
> > > >
> > > > There is no userspace involvement required when a Guest VCPU
> > > > stops itself using SBI HSM stop() call so STRONG NO to this change.
> > >
> > > Ok, I'll drop it from v3 -- it can be handled by future patches that
> > > trap SBI calls to userspace.
> > >
> > > The lack of userspace involvement is the issue.  KVM doesn't know wha=
t
> > > the initial state should be.
> >
> > The SBI HSM virtualization does not need any KVM userspace
> > involvement.
> >
> > When a VCPU stops itself using SBI HSM stop(), the Guest itself
> > provides the entry address and argument when starting the VCPU
> > using SBI HSM start() without any KVM userspace involvement.
> >
> > In fact, even at Guest boot time all non-boot VCPUs are brought-up
> > using SBI HSM start() by the boot VCPU where the Guest itself
> > provides entry address and argument without any KVM userspace
> > involvement.
>
> HSM only specifies the state of a few registers and the ISA only a few
> more. All other registers have IMPDEF reset values. Zeros, like KVM
> selects, are a good choice and the best default, but if the VMM disagrees=
,
> then it should be allowed to select what it likes, as the VMM/user is the
> policy maker and KVM is "just" the accelerator.

Till now there are no such IMPDEF reset values expected. We will
cross that bridge when needed. Although, I doubt we will ever need it.

>
> >
> > >
> > > >>  * Don't make VCPU reset request on sbi_system_suspend.
> > > >
> > > > The entry state of initiating VCPU is already available on SBI syst=
em
> > > > suspend call. The initiating VCPU must be resetted and entry state =
of
> > > > initiating VCPU must be setup.
> > >
> > > Userspace would simply call the VCPU reset and set the complete state=
,
> > > because the userspace exit already provides all the sbi information.
> > >
> > > I'll drop this change.  It doesn't make much sense if we aren't fixin=
g
> > > the sbi_hart_start reset.
> > >
> > > >> The patch is reusing MP_STATE_INIT_RECEIVED, because we didn't wan=
t to
> > > >> add a new IOCTL, sorry. :)
> > > >>
> > > >> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.c=
om>
> > > >> ---
> > > >> If you search for cap 7.42 in api.rst, you'll see that it has a wr=
ong
> > > >> number, which is why we're 7.43, in case someone bothers to fix AR=
M.
> > > >>
> > > >> I was also strongly considering creating all VCPUs in RUNNABLE sta=
te --
> > > >> do you know of any similar quirks that aren't important, but could=
 be
> > > >> fixed with the new userspace toggle?
> > > >
> > > > Upon creating a VM, only one VCPU should be RUNNABLE and all
> > > > other VCPUs must remain in OFF state. This is intentional because
> > > > imagine a large number of VCPUs entering Guest OS at the same
> > > > time. We have spent a lot of effort in the past to get away from th=
is
> > > > situation even in the host boot flow. We can't expect user space to
> > > > correctly set the initial MP_STATE of all VCPUs. We can certainly
> > > > think of some mechanism using which user space can specify
> > > > which VCPU should be runnable upon VM creation.
> > >
> > > We already do have the mechanism -- the userspace will set MP_STATE o=
f
> > > VCPU 0 to STOPPED and whatever VCPUs it wants as boot with to RUNNABL=
E
> > > before running all the VCPUs for the first time.
> >
> > Okay, nothing to be done on this front.
> >
> > >
> > > The userspace must correctly set the initial MP state anyway, because=
 a
> > > resume will want a mp_state that a fresh boot.
> > >
> > > > The current approach is to do HSM state management in kernel
> > > > space itself and not rely on user space. Allowing userspace to
> > > > resetting any VCPU is fine but this should not affect the flow for
> > > > SBI HSM, SBI System Reset, and SBI System Suspend.
> > >
> > > Yes, that is the design I was trying to change.  I think userspace
> > > should have control over all aspects of the guest it executes in KVM.
> >
> > For SBI HSM, the kernel space should be the only entity managing.
>
> The VMM should always be the only manager. KVM can provide defaults in
> order to support simple VMMs that don't have opinions, but VMMs concerned
> with managing all state on behalf of their users' choices and to ensure
> successful migrations, will want to be involved.

I think you misunderstood my comment. VMM is still the over manager
but the VCPU SBI HSM states are managed by the kernel KVM.

Regards,
Anup

>
> Thanks,
> drew
>
> >
> > >
> > > Accelerating SBI in KVM is good, but userspace should be able to say =
how
> > > the unspecified parts are implemented.  Trapping to userspace is the
> > > simplest option.  (And sufficient for ecalls that are not a hot path.=
)
> > >
> >
> > For the unspecified parts, we have KVM exits at appropriate places
> > e.g. SBI system reset, SBI system suspend, etc.
> >
> > Regards,
> > Anup

