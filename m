Return-Path: <kvm+bounces-47531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 356C7AC1E4B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9DD817FC4F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 08:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E9E289812;
	Fri, 23 May 2025 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RD4QDQF3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BFE284B5A
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 08:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747987723; cv=none; b=gWzQ6SLoVx7nKJyTo8WFe8+trHbC4Q5f/BXEGlRK4lTZhrief5sJ9isUXiVKJvg3had7K5cUY1xPrKszyEhGvX50f5MdIR/vOHGgikvFyPRloO4RH3UibAu4kJk9z3u1K3BdC4je/auV/tx1Zk/YPmKav63dan8kCKZ7N5j4RaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747987723; c=relaxed/simple;
	bh=Kt+RxnY5pPOUYQ7akI1IF5qpab3LUOao0bxzBmS+RxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvNHjg7M+9WPy+RaUj50CN/ClBDaxZB8olX78Iz1621ey+vuK/RgYIZmdh80bzocjKuOKImVJJPwxoD7KTYSyD5b2MZ7RbrKmnwycsHFZVmCfc/hP/m4w8YoY6ye0VO1sV1XE1xZN0IB/BRObhN1NTbuoSuwbR8AdGvY6+5oCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RD4QDQF3; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-329107e3f90so61091091fa.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747987720; x=1748592520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dypiNcBVG4OJMnXknsT6VxHNsIlokeB6DjiUVywy6W8=;
        b=RD4QDQF3B4dm8aFADRsFpZ+bsz2mjkJHQq6KIQlYncKw6E3yhvkG2T2CkElSw406mS
         TbTDCWwQHKQBhxgKE+VzUnQ4ouM1wngyZLIKu6+2MO1NxL/O3C//0EZEnC0c5fKKTpHM
         vOEzLtzfhtzGdUlW1iLNQN+htF/LPG+Mda9VH5Wxp18WPqtdJ2EiKXWBLL7E3yJ/arXC
         pwE5lC7Ul60MKOo7VqxOVqeqMp4xHYJwfAHLk/TnXxkfY29uebJxSNeCAjAw1EoKYCTJ
         M0viOZTJNwCzpRFCWNGoReDzh1lRkHyjdq7UtXOzQ+DIR4PUKe+CqkpVpEVH/5R5CbcD
         +EXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747987720; x=1748592520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dypiNcBVG4OJMnXknsT6VxHNsIlokeB6DjiUVywy6W8=;
        b=X/Q/voCiK6hzKIkxsS/V6USwH4UH0dtE/UIodsIWeSSl9TMeRvgPEZ0IF8kEl5fiBC
         u6oy7hkf+SMh3yf7SeuNdVeRM106ZRlU0VVbek5MFFlaRRtryEiCmMNRUH4BdAjH7hhL
         rOH8Ch48UXYxgkmArQVy3JRQU0EKbgELqfCx5HXBHek4J2t3bz2jgMTN24rlSoJ85CkM
         zRbfwjCzY9WMOCip2hHSp6IL3E3EIWXNE4oTkoiSUo+wn32biTQ/7dgopHWMoL2qopwo
         /WOcWx2b8w1PVn6713JFodMTcbbKg4d30Cu+TaXezbBVTZSBRIbN7ZbMkoe68v4+XD3q
         JBRg==
X-Forwarded-Encrypted: i=1; AJvYcCUBxbxDIyG+zAzZ+hWJy/Rc0rhoTC7/97+8JPsuAT/L1aEBGC3DQH3L1VIfPa8vA8m+X74=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcD329UDmkKxZFGG/qqFpT3DIFXImrgmpY2Y2WN/yAOH/45zYJ
	pcwLnqGPHmMxW3R0J1xmSRvJCBnlZc59xjFW+umRriFdtZYw95uC+hrXxhBuwVSpl+8ivwFaXoD
	QIbAy5FfxASwQNc6Niokd0I+s6lMPbqP8KU6xY+9TgQ==
X-Gm-Gg: ASbGncuNdGD8fjnweCwfGBYMtzUDNuVOkXJWU0h6nORSLDbFatzhW8KBzwnaHVR/XjM
	aaFmIbKaeaHVB8KvWIa18XTZ6ZMZ4ihGT3XkMZqijGXMTlU7UoW3NmUQu14NSIH/MaOxsYJ7nG4
	4KnISsOx5fbmRCkRwB0raCtVZOkifPOB46
X-Google-Smtp-Source: AGHT+IGBWGbvTx7BQMeoVdfMzTjiV714zLjub63DnKd4CcjGSz5Rh79IxGXRhtq0036FNv1p8KYTEfYuBPB1oZQn9Xs=
X-Received: by 2002:a05:651c:e18:b0:30b:f775:bb25 with SMTP id
 38308e7fff4ca-328097a7fd4mr82948211fa.36.1747987719490; Fri, 23 May 2025
 01:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com>
 <1a7a81fd-cf15-4b54-a805-32d66ced4517@linux.dev> <DA3CUGMQXZNW.2BF5WWE4ANFS0@ventanamicro.com>
In-Reply-To: <DA3CUGMQXZNW.2BF5WWE4ANFS0@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 23 May 2025 13:38:26 +0530
X-Gm-Features: AX0GCFue-dsAlqCUbca0f2FbyJ1Uuu3t8ikYPvU9ghMwoHzDApFhc1zUuloECeE
Message-ID: <CAK9=C2Xi3=9JL5f=0as2nEYKuRVTtJoL6Vdt_y2E06ta6G_07A@mail.gmail.com>
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

On Fri, May 23, 2025 at 12:47=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>
> 2025-05-22T14:43:40-07:00, Atish Patra <atish.patra@linux.dev>:
> > On 5/15/25 7:37 AM, Radim Kr=C3=84m=C3=83=C2=A1=C3=85 wrote:
> >> Hello,
> >>
> >> the design still requires a discussion.
> >>
> >> [v3 1/2] removes most of the additional changes that the KVM capabilit=
y
> >> was doing in v2.  [v3 2/2] is new and previews a general solution to t=
he
> >> lack of userspace control over KVM SBI.
> >>
> >
> > I am still missing the motivation behind it. If the motivation is SBI
> > HSM suspend, the PATCH2 doesn't achieve that as it forwards every call
> > to the user space. Why do you want to control hsm start/stop from the
> > user space ?
>
> HSM needs fixing, because KVM doesn't know what the state after
> sbi_hart_start should be.
> For example, we had a discussion about scounteren and regardless of what
> default we choose in KVM, the userspace might want a different value.
> I don't think that HSM start/stop is a hot path, so trapping to
> userspace seems better than adding more kernel code.

There are no implementation specific S-mode CSR reset values
required at the moment. Whenever the need arises, we will extend
the ONE_REG interface so that user space can specify custom
CSR reset values at Guest/VM creation time. We don't need to
forward SBI HSM calls to user space for custom S-mode CSR
reset values.

>
> Forwarding all the unimplemented SBI ecalls shouldn't be a performance
> issue, because S-mode software would hopefully learn after the first
> error and stop trying again.
>
> Allowing userspace to fully implement the ecall instruction one of the
> motivations as well -- SBI is not a part of RISC-V ISA, so someone might
> be interested in accelerating a different M-mode software with KVM.
>
> I'll send v4 later today -- there is a missing part in [2/2], because
> userspace also needs to be able to emulate the base SBI extension.
>

Emulating entire SBI in user space has may challenges, here
are few:

1) SBI IPI in userspace will require an ioctl to trigger VCPU local
interrupt which does not exist. We only have KVM ioctls to trigger
external interrupts and MSIs.

2) SBI RFENCE in userspace will requires HFENCE operation in
user space which is not allowed by RISC-V ISA.

3) SBI PMU uses Linux perf framework APIs to share counters
between host and guest. The Linux perf APIs for guest perf events
are not available to userspace as syscall or ioctl.

4) SBI STA uses sched_info.run_delay which I am sure is not
available to user space.

5) SBI NACL when implemented will be using tons of HS-mode
functionality (HS-mode CSRs, HFENCEs, etc.) to achieve the
nested world-switch and none of these are accessible to userspace.

6) SBI FWFT may require programming hstateenX CSRs which
are not accessible to userspace.

7) SBI DBTR requires direct coordination between the KVM RISC-V
and kernel hw_breakpoint driver to share the debug triggers.

... and so on ...

Based on the above, emulating the entire SBI in user space is
a non-starter. The best approach is to selectively forward SBI
calls to user space where needed (e.g. SBI system reset,
SBI system suspend, SBI debug console, etc.).

Regards,
Anup

