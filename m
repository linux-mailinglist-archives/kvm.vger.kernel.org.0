Return-Path: <kvm+bounces-53565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6375EB14038
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D568216F7D0
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94761274FD9;
	Mon, 28 Jul 2025 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="U9wG57zM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CC52737F9
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753719669; cv=none; b=nWRCfXW2U9A4qP/lVymwuwH6/rWdYtT6C6yaUy2r2aEjXS3/Me+NeowZ7MHpa9Q3AumIFFH5bwlklIysT0a+TeTNJ9gFvVx3+sVshal1KIchxSzRAwEYUjprcuNx1Dwv1o4Eshb4FmHeFUbIYCGInDC2EfeKWblid0rESGgo3o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753719669; c=relaxed/simple;
	bh=h6xk8HbCLTXjMxNkdmZRSKf8yzuLlmmWE+kuseuM7Xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QdeZ44+tb/ncWxSqgjroVVHWdTNKxNPk4kXJj8oFX3VXWK4vISpTRBPzf7picJvZGEnF43ysnIYlxHrTAGzujIpyBycxSoJiMO2A51O+sEVDSlGMwpR3jsNlocP8AkP6nRYE7oFZBZW868KLwGareoFaQCOL/p/Vh8oFf+VaUYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=U9wG57zM; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54b10594812so4670212e87.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1753719666; x=1754324466; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdcfVN+MxsrGTHCCym31hzeoZnEEz01BYzSO86n5f30=;
        b=U9wG57zMGjSiXWytzqxQudp68rFI2z7RAAeVc4UJ+ytW2mhz5YiNiaQsM5vxiCwjZ6
         t5WfI+FvR4md7zt4RZQl3JUAxQ0yK2BHr/rEtCvXgBNo5M9nQAnwuw3zmAG6zBAQQdqs
         R0yhMoxW4GiyghP949lrZvx3Ob7XJ9DldorqKD4INSb1lInf9TNLR+vL3LGoe3z7FrKe
         z2zv+4XgS3afKBDx0B9hO4UansI6q8IjDq1HkAP7YzvW9fPhd2mygnRpTnlQ2NeDpzZC
         8HzzXRgHT5E5HN7HRYKguqL4bd9l+eEtMzl6cFjDVALjy29szGFEyde3VqfxKKZZkgff
         TmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753719666; x=1754324466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdcfVN+MxsrGTHCCym31hzeoZnEEz01BYzSO86n5f30=;
        b=Pj833CttuA6gPiZZQ7EM35Uw+beX0i/sPCG9EJcN1Czg8LxjEnDdr4YQm+wrqQ7qAA
         lVglKDqxjl+SI3DvNToJgd38y6fb6CzrayyV8IUGdOgpeJQm6xeZqgeli5+LAZkJb8Ao
         HmYHCSi/WtLPb9KRG7l1BuuI4RQNuqsllfOjMdGnDBLcOH3UbUCaWXykOHkJVNeX0iJe
         5vG2Rcake4B/utW6NBd9lQSqeMNLwX1BN9VXebqASOwve6Bh8KIIjitjx/xvzcb9dQOI
         JqSMK7L4xV33cSu3a4/Wo/6Y59gxmR7pqjFK1k/EIMRDKyZ53kpytdupu3zVbiq3O+2H
         YGcw==
X-Forwarded-Encrypted: i=1; AJvYcCV6mNJl5ZZZXE8rdY8FIj+6BM4hIdBga/8QixE/20Gk9kwa1yrK/TObgg0rO0yv9RGg4rM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDsm6VBDv1Vj4RoarrCjgQEV1+dE4UfMcEEnsEYxF6yZmycH17
	g5xn1t1LAn3j3a9WyQ5gMx4twNqVbHxM6A67VQbza89tq+P960LHSopgZ6+alSGlIhvjjbyOrTk
	BV8Ci4IBSMBFQgzrXbXMe/HPsrcE7Es3mM5C1NWmuxA==
X-Gm-Gg: ASbGncupmPm99oLPNzAQHMhQ5VXXztNoBKxZx8tPZK6t69yhg7tbxtY/XGXhT3i+/GV
	o9IR8qpRDCXGCK9mmTZAUVvuxvU7WjCfxJRZLdHoRoy//kTKjy6/z6JebvCK4jZBdZAly53Y7Mt
	gFS5Msguq9ckRzPLIvWQubDmWVOfgBqfeVqTBKfd+WPD62zCltb7/Z2aW/udQyss1Pu39E0qK4m
	AbN2M/il+JPkfDDyg==
X-Google-Smtp-Source: AGHT+IHPLWkIq2Hzkwnhy9Ql1/JeVtlbcWB5zYvVu9QjQS7I5BuWgmz/R499rplid2VZ9bWvtdvBHjhnVq21Gaelowo=
X-Received: by 2002:a05:6512:3c88:b0:556:2764:d1f7 with SMTP id
 2adb3069b0e04-55b5f3d5c4dmr3655639e87.12.1753719665845; Mon, 28 Jul 2025
 09:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
 <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com> <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com>
In-Reply-To: <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 28 Jul 2025 21:50:53 +0530
X-Gm-Features: Ac12FXxd7LAtATGvK2Wpz-J7Et8u7nnsl8CdfP7VqiT2IgK5SUBwlBJP0RG-15Q
Message-ID: <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 9:43=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Mon, Jul 28, 2025 at 5:55=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Mon, Jul 28, 2025 at 9:22=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.=
com> wrote:
> > >
> > > On Fri, Jul 25, 2025 at 2:06=E2=80=AFPM Anup Patel <anup@brainfault.o=
rg> wrote:
> > > >       RISC-V: perf/kvm: Add reporting of interrupt events
> > >
> > > Something here ate Quan Zhou's Signed-off-by line, which is present a=
t
> > > https://lore.kernel.org/r/9693132df4d0f857b8be3a75750c36b40213fcc0.17=
26211632.git.zhouquan@iscas.ac.cn
> > > but not in your branch.
> >
> > There were couple of "---" lines in patch description which
> > created problems for me so I tried fixing manually and
> > accidentally ate Signed-off-by.
> >
> > Sorry about that.
>
> No problem. Another (and more important) question, for SBI FWFT I
> don't see any way for userspace to 1) pick which features are
> available 2) retrieve the state and put it back into KVM. Am I missing
> something?

Currently, userspace only has a way to enable/disable the entire
SBI FWFT extension. We definitely need to extend ONE_REG
interface to allow userspace save/restore SBI FWFT state. I am
sure this will happen pretty soon (probably next merge window).

At the moment, I am not sure whether userspace also needs a
way to enable/disable individual features of SBI FWFT extension.
What do you think ?

Regards,
Anup

