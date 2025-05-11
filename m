Return-Path: <kvm+bounces-46122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770D2AB28DA
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 15:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F7213B658B
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 13:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467A12580DD;
	Sun, 11 May 2025 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="tGNw0hPz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBFF2571B5
	for <kvm@vger.kernel.org>; Sun, 11 May 2025 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746971031; cv=none; b=Pb9fXcifg8YPHv/Eh9Vbu9MP3ZOcEz4PaKvCSTyK8aEUqe6Z7PoT51lg94DqiP/OVaQ0Z8zdRs32UXsZuOrF93iOknyuwcg9w1BjN7DwT30nfB5t7ttpg583MlW4mAjyPyZXn2bG/eyaHdr9nVcz8eg22Bwl+G6HvQ+e648C/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746971031; c=relaxed/simple;
	bh=FAXQEQiRSJBFkJYUsQBsiyj/bzB2dareIVDnQ2+JyzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/cxnY351oXJo7RDuC0tUw7YDEVbgho6uWwNlb7hB8UWEk+o4GARXinrZkMtxGHOvlm64N+74bGdS2dM+A7qJhQ1nKUoG9f/vIYDLDbk6DCW7sFj9h21aMWaHpUqgl0RTDZwtd6jfHQncG9JTfT5CHJ/5emq6vQgvOfbIKkl4vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=tGNw0hPz; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d8fc9dbce4so16750875ab.0
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 06:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746971029; x=1747575829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tikqvcPSSM0+ie8ei00WO4p/o6p01PdEuZ4eNfazi4=;
        b=tGNw0hPz9twQaPKDXrcehXDuK13xr9bKweC78DMS/FlZpWCHf1EGEXjAKA1XOBr8ci
         oIpMxhngXO51I7Yu8ikP2s7wZtPJVzBtNWY9sf6xu7OYc7z/8eGLDEQe61FST85HYFEx
         8E0t7D7idJZHzsoMEwAKSd+WAwwFDAcH/5/RkmJKza4Cl9STndLad6VuNONKWQZYiqcH
         cV2AC2H14akL3Huk7vEBnkT+Nv6sCQ+B3iQkZkYjiP1uBX9rmorMZyycUeofgpmI6WZY
         OeNELxsRlgTfGX8UGIAuINCpIpQxpXHSUxtmHjxAwMR6MUdILkTR+JZUympel+fqXbNQ
         M6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746971029; x=1747575829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7tikqvcPSSM0+ie8ei00WO4p/o6p01PdEuZ4eNfazi4=;
        b=uK8pEzO2XKz1AUiLksK3o2/gpVTy40fy1B5Oquwgru+bPbbfJMRYr7hRNfNKRW35y7
         B0l1i8aVuudoDKcKSk7rEAZtmZCg1Uo67b/EGSia+ZTdap0qzw/9gLlR9eiVXBGdr4Wn
         HfCjJPu3GFpOQi51jFOUDovQClICJFoHaQKx+mVL8TOzhsOqU8S2LqMwVrMlzTeog/4a
         V6jRU0J2ztr/iCgBqYT32KZv/EqATwd6wUfEQdG1P/qqRbID229NeCKnczT0cbBBPz4U
         oB0nRUhXmRH7A2Euk3cIsdvPRP5argfsoMscIBO0lJ/dnV6GtmYHjbUZO8AqP2g/oAWm
         pKUw==
X-Forwarded-Encrypted: i=1; AJvYcCXprM74HqcMt0ogJ0YQ7Kdiw+HANTgS5sd1bmZfOqVdQvAr0RJITr7nFFX85dRKbmW3lF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz9YX2tL/qfjm41TLtMbAmOHbwkgCfl3oraqce53jRXBR3AeFL
	9yPVAy3tU3fGlebWDmPPE6pm2lUaET9L6veoArXnhzZcse0fbzU4yV6p1hrskIsQgvsALMuVkuE
	Een6n7DJmcmRfPtvI41N7U6lVtftZlGHz4dEZUw==
X-Gm-Gg: ASbGncvWQwmuMWSJrGCaZ+hf214Qr69002voHpjFfbiMeuPchj+2IDd77JnyUwQ+RKv
	nms+CHOfdpf0t7PNUcxAJTK/j0jETw+5V28CvAkc7cm6Ua/H+eb/bDDCfLQJaAxHBeF3kzUmnq0
	pI49eyb6nB/b/EVMD/OLkMCojAq4S32hOD
X-Google-Smtp-Source: AGHT+IGyy1tvQ5e1+LwmeN6aMxyvc+Kf3eAUBMdPUntGYmvmLxOM06L/3VzGSjkoX8RjJISKXUhUmqEwo7e719ksem0=
X-Received: by 2002:a05:6e02:1fc8:b0:3d0:26a5:b2c with SMTP id
 e9e14a558f8ab-3da7e34871amr88924955ab.8.1746971028558; Sun, 11 May 2025
 06:43:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com>
 <20250508142842.1496099-4-rkrcmar@ventanamicro.com> <CAAhSdy2nOBndtJ46yHbdjc2f0cNoPV3kjXth-q57cXt8jZA6bQ@mail.gmail.com>
 <D9RHYLQHCFP1.24E5305A5VDZH@ventanamicro.com> <CAAhSdy2U_LsoVm=4jdZQWdOkPkCH8c2bk6rsts8rY+ZGKwVuUg@mail.gmail.com>
 <20250509-0811f32c1643d3db0ad04f63@orel> <CAAhSdy389g=cvi81e7SKAi=2KTC2y9bd17aHniTUr4RNY=Kokg@mail.gmail.com>
 <D9ROL5UEYYHX.1B1FE6LZJ9ESO@ventanamicro.com>
In-Reply-To: <D9ROL5UEYYHX.1B1FE6LZJ9ESO@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 11 May 2025 19:13:37 +0530
X-Gm-Features: AX0GCFs_ezw8XJlOzMkddRA3UmJgoXKaRdAdTo6LGXAA1hZrT5A6WwM3ss5-FXk
Message-ID: <CAAhSdy3j0Uf52hs+_gRxkROTA4sjMkLk1sMtv=XZWsyv15TBSw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Andrew Jones <ajones@ventanamicro.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 7:27=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> 2025-05-09T17:59:28+05:30, Anup Patel <anup@brainfault.org>:
> > On Fri, May 9, 2025 at 5:49=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> >> On Fri, May 09, 2025 at 05:33:49PM +0530, Anup Patel wrote:
> >> > On Fri, May 9, 2025 at 2:16=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <=
rkrcmar@ventanamicro.com> wrote:
> >> > > 2025-05-09T12:25:24+05:30, Anup Patel <anup@brainfault.org>:
> >> > > > On Thu, May 8, 2025 at 8:01=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=
=99 <rkrcmar@ventanamicro.com> wrote:
> >> > > >>  * Preserve the userspace initialized VCPU state on sbi_hart_st=
art.
> >> > > >>  * Return to userspace on sbi_hart_stop.
> >> > > >
> >> > > > There is no userspace involvement required when a Guest VCPU
> >> > > > stops itself using SBI HSM stop() call so STRONG NO to this chan=
ge.
> >> > >
> >> > > Ok, I'll drop it from v3 -- it can be handled by future patches th=
at
> >> > > trap SBI calls to userspace.
> >> > >
> >> > > The lack of userspace involvement is the issue.  KVM doesn't know =
what
> >> > > the initial state should be.
> >> >
> >> > The SBI HSM virtualization does not need any KVM userspace
> >> > involvement.
> >> >
> >> > When a VCPU stops itself using SBI HSM stop(), the Guest itself
> >> > provides the entry address and argument when starting the VCPU
> >> > using SBI HSM start() without any KVM userspace involvement.
> >> >
> >> > In fact, even at Guest boot time all non-boot VCPUs are brought-up
> >> > using SBI HSM start() by the boot VCPU where the Guest itself
> >> > provides entry address and argument without any KVM userspace
> >> > involvement.
> >>
> >> HSM only specifies the state of a few registers and the ISA only a few
> >> more. All other registers have IMPDEF reset values. Zeros, like KVM
> >> selects, are a good choice and the best default, but if the VMM disagr=
ees,
> >> then it should be allowed to select what it likes, as the VMM/user is =
the
> >> policy maker and KVM is "just" the accelerator.
> >
> > Till now there are no such IMPDEF reset values expected. We will
> > cross that bridge when needed. Although, I doubt we will ever need it.
>
> The IMPDEF issue already exists.  KVM resets scounteren to 7, but
> userspace wants it to be different, likely 0.

The scounteren set to 7 is temporary workaround which is supposed
to be removed once Guest Linux initializes scounteren correctly at
boot time. At this point in time we can remove this scounteren
workaround from KVM because the SBI PMU driver is initializing
scounteren correctly since many kernel releases.
(Refer, pmu_sbi_starting_cpu() in drivers/perf/riscv_pmu_sbi.c)

If we absolutely need a mechanism for userspace to provide custom
reset values of CSRs then we should use the existing ONE_REG
interface to define a new type using which CSR reset values can be
set at VM creation time. But, I still think we don't need such a
mechanism immediatly.

Regards,
Anup

