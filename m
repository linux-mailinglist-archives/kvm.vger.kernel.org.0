Return-Path: <kvm+bounces-50298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73235AE3C5E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 930E33A3DC3
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D56423C503;
	Mon, 23 Jun 2025 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RUMaKSb4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1A22DF86
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750674613; cv=none; b=QUVbEqDQ6fax66B2qdTB+GoMLlpTK9YW1g8KoDoOCiGo0ig8mTEdVVLFKHwVAJfyBijlM2wB+Gqg59nn9605ZqDrEi5TIMgZdf7jNfL03EtvxZZ9TnrTPMHCZ93pWALynzUXGLYmMozDYaHHPOUroQ/+oJdfI0VDPugRV3P67bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750674613; c=relaxed/simple;
	bh=15q1L8C4ZgBW7rR9Tk0j0vLXF86Ag6TO7eVagqgQQ0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMGj+q3XoUWeAIKEFOxrZUwzuV3IZ8TmhjWQuGyV/Nqeu5zPMYEvm7G0RQ3J0RDlAzos56+MEiBTHD87GoQ8fdtNulsEnGFffAUbWgK8s4PITK+nsPQLawhpPy7hY23Q7FiywqIZ7kXFxFaHERBJQ0Hb2bWOoY773SMW39vXInQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RUMaKSb4; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b31befde0a0so2431236a12.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 03:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750674611; x=1751279411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2Xh6Dpoc9NJla9DLdZ/WLUd9H1GHAIOhYhI+2Em4eg=;
        b=RUMaKSb4NPfcCoqRmbjrw7DoNO7P3hcwf/eU+8PiSTHvM2yRCo450Af5dQe8qVtbu1
         unpqKnRykrdoQL3p8X7j1iTGmzD8q/LF6zmAwE7ftuCe5mBXmaHEdVtYoeSg78V40QEm
         16CrARRWNZE0CaRbtlwKrMXaQRmM1tq7S0ad1rvPOTA/k1JkbK04y406/NFcj0fY6Bqd
         h78dJhTthOpk522xDMoEpfAfA3Th7k7F50hqpqM1PxNbxZDlOHx2KlT/EEFLTDlyP0sO
         SvA5vYzLrfIgi1TN9PD3b2ILlHyeh9oElYhcq1O/ES3Yi+y7JBd4w1THVTIc39xXfNrK
         uhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750674611; x=1751279411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2Xh6Dpoc9NJla9DLdZ/WLUd9H1GHAIOhYhI+2Em4eg=;
        b=L9A6d+zN000pQRT6XC/bI18+dOdRNoZd+6KdCj+gj38HwY5Hmuyglyip/y0NIu2z/o
         3ycVO8JUfTfXx9D7P4MkMufaNWPhRC1GcovjqQ/xv6tXUu4S68UiDfhNi62KgdZPUPhK
         3T3dKKoqzDri/Q6N3AqZ+EpBF6Bk5odIArwhzP1Y0t8bNm7bWp3la73B7e9ZupayGJS8
         c+3Od8yVipvhXzCjcPYIKpVWONaKhBrCK7CyD2vgctKxXO5Ykojq+Qh0WU2rzMXdxOD/
         VcG5DJzysXZzNRzEEcXjQzHS2Un7e6reifxpxzN2GhVc5sJ+OukLTgwxC8lUIWUkTKuy
         hMpA==
X-Forwarded-Encrypted: i=1; AJvYcCXCMkwZTGGmnMV43Db0PeAJfvHYV7Vr9kg+o050xVFSBWxE/bbvw4y/aHO+GR0SdsTfGfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwXREuJCMLEBoKz2vjtJOOQX9F0z56jIP/U3wpJZ1t6OOUjbLZ
	1IW3erTTczVZ1/4Z+GW1ZD6enz5803Q3quCwcaCBlVMMWnaBXkP1lHKgd6nEnSSmYpelVrnJWi8
	Ic6EdC7uUn3TgD6aD+CkpClAgp94u+BdKi2z4zmP4qA==
X-Gm-Gg: ASbGncuWNu2zQUj5Yna2zveXDXkog4bSUPVMdNyh9CqMpoS9Yj9/HCwzNnBMiibzbeV
	iE0EEGvfLw1DImMVOnxZk2AzJ4kNLxDFMKMNtYt5f/kanhzRFTHR40aITa4OyOSw44B4s6Lui+3
	Ho8TZs+Sz2lMftBGScPI+xhgKD+Bl0F8DTprlQ8D4ARpI57XVEOsFkFW9E
X-Google-Smtp-Source: AGHT+IHUUgFd5CAVoui8WeB8d4VDjaMayhZu3ZI45zZpLWDJx7B3fRr4MhP36Fw+gyvFSnnTysBzyBVcg3Vlfp8B2jA=
X-Received: by 2002:a17:90b:5690:b0:312:f0d0:bc4 with SMTP id
 98e67ed59e1d1-3159d626112mr16340875a91.5.1750674610724; Mon, 23 Jun 2025
 03:30:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com> <CAPYmKFvcnDJWXAUEX8oY6seQrgwKiZjDqrJ_R2rJ4kWq7RQUSg@mail.gmail.com>
 <DATTT5U64J4L.3UTDRVT2YP7GT@ventanamicro.com>
In-Reply-To: <DATTT5U64J4L.3UTDRVT2YP7GT@ventanamicro.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 23 Jun 2025 18:29:59 +0800
X-Gm-Features: AX0GCFtfoIOnfs7J2STs_OR-jY-38t6kH55fmz7DcsUlJBJ7-TA3sUK7F3GCaB8
Message-ID: <CAPYmKFtyJ-6N8ArP04QJNMFC3ScRnvp_9rijufQEnJRz4UrBQQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Radim,

On Mon, Jun 23, 2025 at 6:04=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> 2025-06-22T18:11:49+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> > Hi Radim,
> >
> > On Fri, Jun 20, 2025 at 8:04=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >>
> >> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> >> > Delegate illegal instruction fault to VS mode in default to avoid su=
ch
> >> > exceptions being trapped to HS and redirected back to VS.
> >> >
> >> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> >> > ---
> >> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/=
asm/kvm_host.h
> >> > @@ -48,6 +48,7 @@
> >> > +                                      BIT(EXC_INST_ILLEGAL)    | \
> >>
> >> You should also remove the dead code in kvm_riscv_vcpu_exit.
> >
> > I only want to delegate it by default. And KVM may still want to
> > delegate different exceptions for different VMs like what it does for
> > EXC_BREAKPOINT.
>
> (I think we could easily reintroduce the code if KVM wants to do that in
>  the future.  I also think that it's bad that this patch is doing an
>  observable change without userspace involvement -- the counting of KVM
>  SBI PMU events, but others will probably disagree with me on this.)
>
> >                 So maybe it is better to reserve these codes?
>
> Possibly, the current is acceptable if you have considered the
> implications on PMU events.

So maybe it comes back to our discussion on the difference between vs
insn fault and illegal insn fault again~ In my personal opinion, it
seems to be a waste of CPU resources to trap illegal instruction to
HS-mode hypervisor, which does nothing but redirect it back to VS-mode
guest kernel. I think it is OK (and maybe it should) to record 0
illegal instruction exits in KVM PMU. If someone wants illegal insn to
trigger an vcpu exit, then an ioctl can be provided to remove the
delegation like what KVM_SET_GUEST_DEBUG does.

>
> >> And why not delegate the others as well?
> >> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
> >>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
> >
> > Thanks for the reminder. I will have a test and resend the patch if it =
works.
>
> The misaligned exceptions are already being worked on, so don't waste
> your time on them, sorry.

Thanks for the reminder too. I did not consider this before. I will
leave the MISALIGNED faults alone.

Best Regards,

Xu Lu

