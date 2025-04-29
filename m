Return-Path: <kvm+bounces-44682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A64AA020C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87263465BF5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83122741BD;
	Tue, 29 Apr 2025 05:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QIHC3Ey5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D601626FDAF
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745905815; cv=none; b=Mh4Bg6RlUJnhIjKZDoRP+60ORECUYQH7k8fYwDak5sfv+pNN+drVj/ThE3D/YftWCq2j6LXxAI1oJEg1saDrPHTjuVMqFQ5YKYbHjDHiYeq+rmtU7kfnK+4RgBk+ULRIplaoE05S6xeafhulHeGbZohbnGLanAO1K3rFFCHt4u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745905815; c=relaxed/simple;
	bh=TC1pQF5+8x3TfRsyAFIm5rUMUBIGwkayJC79GBtSdMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LoQZxIrXZC88MDbthXDw/3fdbY7R6XX6IHipb+DCoITCau2EmZyRw6dxl08ePdMzTFtKh+rDt+ZQ08SaF5CaMN98BdjiSO2uVfeOvvxFTWtrIQmhrGHXY2UyWAYY+iwIeKAxSIm4ojoPOHn0ba924wcYiFON4KYwyobG7ALMT8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QIHC3Ey5; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30bf1d48843so49002771fa.2
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745905812; x=1746510612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWfOibW0zJXCdtORmeJHJfO7jAlDvwO4GvsgR2VT7fc=;
        b=QIHC3Ey5/8YvPSYOJTKp/LRCAkdTM5zEwbX0jszmfbqizmNivX492lU/o4CRdv1Wtf
         1ek59gQVykIyclnpwPnm1Z9Gb35V0WvhfKYDj/dUHs7pPh8JUb2L1DLMlrylIwjjii4Q
         vQHUQ8CLZRivsfC876alucYmAR6ugln+FvyJ7C1dAe/eKVeAcu6BsdPE9CUgeXBVQWR7
         qw+iDIxd5zjPksyWodtUSriqQgTZF6AWQtqTZbsRqTJjMXQTIu1W1rzj1sNEcvWEHB48
         aOHM4BtPIR465AlcOHaeqw8RPEt3ssBz5WLzktMAzs81hnAXSRnp80pjWmYZdnxULgw+
         aXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745905812; x=1746510612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWfOibW0zJXCdtORmeJHJfO7jAlDvwO4GvsgR2VT7fc=;
        b=dVEocscgbhyKnjGaXdtloAAd4y6b/EqewPZQgLzvk2SNqyiiHocKQHZbx4DefW5lpr
         SXHs4QrlLyqKD5LJCaGnbmpzIq2pA6HD7TsKjTxAxaxBi8QvSrv1VsMp2peod3iPptPi
         OoQ2F73U85sqfn2z5MQ/6ue8ANtgXQfPn0kU7VAjFm1U6+O1Ne5L2V2/nvMf5mBSdRBP
         1LT5JkxRwJyhvy6kUkjHbStNj7qLjYZkzljVpznMHQWrxjfodIm8DYcs/vi9eUn85CWZ
         CtFLlebo4SQ9E2n+UJ83f5Sz2v/KcJjzdUiXbelvqMc5ytNzFiXr0OY2KN2HTbIY1JcW
         P8QA==
X-Forwarded-Encrypted: i=1; AJvYcCXi0MAXYuGaQdNVN6Kx2ce5Z8HxmicfZFv1hbUyfMcEp6Z9CtjaNeQlQw2WYMFetPUvnR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYHDIQ8VHAOwNjGiYY2vJ8h17ha2aJnHZz+wAQ2XnUp48vZYS2
	7I+C0wmKXqkg60+iE2t35Tdp/FLo3TrTTNIUJRegMNX+TG9AlePAKejteylOILMFq59L70xEkq+
	kvqGZ+jFi9Q+F7h8+KU0fVH9vLcv1l+SOw+nGkA==
X-Gm-Gg: ASbGncsrMAC69+A5KkX8DkSRQULsyCFqaJq0UY1lLnCOUZCkAmazTKIP0DOCE/SuBdi
	EhiADsgiaun5iFZgOqJkRXdD1l0ToxDdwSfVnhkLQJNhpspHohf+zhyM8nNN0qEFu3BetgzQ4Hv
	pQFQT9Mo8LnvtO8lIseLEMTvWD7L/q3BzqlA==
X-Google-Smtp-Source: AGHT+IEXIWagJECOG4RLoTrQYomZ3sHcSOAll8CYP8clhn9zHjblZNubHzN3OqgFWmMSijyY1wb9UjZJkI4zeEP4uLw=
X-Received: by 2002:a2e:be9e:0:b0:30c:460f:f56 with SMTP id
 38308e7fff4ca-31d34d60533mr6426041fa.20.1745905811969; Mon, 28 Apr 2025
 22:50:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-6-rkrcmar@ventanamicro.com> <CAAhSdy1RSpVCUzD+Aqbhh7aiQPmC2zdvuQfuOsmYNJrF3HxCsA@mail.gmail.com>
 <D9IGVF0OY4WJ.1O1BX0M2LWUVM@ventanamicro.com>
In-Reply-To: <D9IGVF0OY4WJ.1O1BX0M2LWUVM@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 29 Apr 2025 11:20:00 +0530
X-Gm-Features: ATxdqUGsRoK2KaLKI32KI2F__RZN-02oqDCocnMiqzg_aZlzW8XBSk76LkacWdo
Message-ID: <CAK9=C2W3gLpeOmOcX3sp+J1zuBkWek7nO8tV79=gaWx+QZ6rgQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: RISC-V: remove unnecessary SBI reset state
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 11:31=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>
> 2025-04-28T17:46:01+05:30, Anup Patel <anup@brainfault.org>:
> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
> >>
> >> The SBI reset state has only two variables -- pc and a1.
> >> The rest is known, so keep only the necessary information.
> >>
> >> The reset structures make sense if we want userspace to control the
> >> reset state (which we do), but I'd still remove them now and reintrodu=
ce
> >> with the userspace interface later -- we could probably have just a
> >> single reset state per VM, instead of a reset state for each VCPU.
> >
> > The SBI spec does not define the reset state of CPUs. The SBI
> > implementations (aka KVM RISC-V or OpenSBI) or platform
> > firmwares are free to clear additional registers as part system
> > reset or CPU.
> >
> > As part of resetting the VCPU, the in-kernel KVM clears all
> > the registers.
>
> Yes, but instead of doing a simple memset(0), KVM carriers around a lot
> of data with minimal information value.  Reset is not really a fast
> path, so I think it would be good to have the code there as simple as
> possible.
>
> > The setting of PC, A0, and A1 is only an entry condition defined
> > for CPUs brought-up using SBI HSM start or SBI System suspend.
>
> That is why this patch has to add kvm_vcpu_reset_state, to remember the
> state of pc and a1.  (a0 is hart id and can be figured out.)
>
> > We should not go ahead with this patch.
>
> This patch only does refactoring.  Do you think the current reset
> structures are better?
>

I am fine getting rid of reset structures as long as we have
memset(0) in-place to achieve the same thing.

Regards,
Anup

