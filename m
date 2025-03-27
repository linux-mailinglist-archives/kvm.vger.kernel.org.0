Return-Path: <kvm+bounces-42093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2E5A7288F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C30863B6AB2
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E35770838;
	Thu, 27 Mar 2025 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ge2tIvO5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452CC4A07
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743040559; cv=none; b=RP/MwftCrWgLDf9pvLFQdwRVPLHZCyKqzz6ciWAx2kmOsWvBr3L4B18lxV4F8N+6y0Riv0dn5CLoR+q3slYaT2cYZMAVjXomDtqGe1nje5bTdYMS7SfilkRR6xwdBXCa77ZbpE7UM8pEM6FilftgMAbX4jEgFSfGejdrfT6CtfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743040559; c=relaxed/simple;
	bh=a68lz9JcQSBavQyduKhLRKpiNClg6xfa4+1OZ8ioJ9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PPfCq211ZZulxPHSLcUjffEIRfrKJdUEhAi1jD5r8zifuBr8Fzs23YX/RABRd5+CNK+qhTdt5np6lCvTq9ejhQtfqYDYNWkPhNGnwV4RBaAZhBfatYSasBG8w8qitaaAqLY9pr+ap+sq48jxiruIpu57CRObT7iY7XwsZTXGPN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ge2tIvO5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso1178608a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743040557; x=1743645357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nL2Dl7aHbf0dGqs5JcynZqdOq7r3zC+FjBGKQXAT1Og=;
        b=ge2tIvO55BIx7hvaGgWH56TAqzpoKt1asxkYalAW0ZAcl9sjJUD3Rl4Sn228ryiNbj
         1FZExmMZfZeMgZSreNC9TPErJqq4dPLNH9wyyPmMpJkbMl2aXpeil12r8FWy20N5+35E
         FPotpk4N1suroBOtZuIHHNX29CCnV/pbJ/5qVOkLNuBq7HNYq3Dyr9VVoREND/irn3rC
         mPzX13gMQGpjKuOfhrDQW3ic+OJ15fyVdWNH5SzM0F4b+YmwJITQOIu5EsUvP90abaZx
         JuRegUKYqeAj8hGf2s6x4ZTPYm3j1pD40+f3zEpvZzfnzB1mmamMTYzvwbcJG1SQLW3K
         9QtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743040557; x=1743645357;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nL2Dl7aHbf0dGqs5JcynZqdOq7r3zC+FjBGKQXAT1Og=;
        b=N07L/Rz+9aAm5czVUqNukwFAR590xgbk2vQ8IbtxfQq/5NCswWMiba1k9Q08Flnxuh
         iiA24WAyXJkQ6g9Jmd6r2tfsM88rQeFO6FAhRVtQm/yVbgL2B0vwv5T47lJe9rPZQj8L
         93DLRWwmDbAW/zCdfmI6UsqMyNjzvDOz7S+YXTGflFUKgd1U9alpVvcil/TSlj9qaVjb
         04qZFUpIYaqcHypWIX5nsyzVOZ4IQg4BiUrq1ijw85it4/KbKM8ugnC6VXqFc/R1oMBO
         0/+MnW3txzaYJgBCljvBEZ8PXzfV+iTrPtezDU/fs5bX4+0JR5R02wyB3oP38g6VJE5k
         GlYw==
X-Forwarded-Encrypted: i=1; AJvYcCX6nhJMq4ezcTPXKvcQjWpYIO2Chv2iHyTtFnzNzHWO/ImX3TiCk9A7J/O6BN2gjiPMafk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxL8zgoZM5lT5pRTbUNKMRwswTciZ5c+h/G2re25UdhaLbIKAX
	He3l6m5IwyzbmPy/FwratYm3QJ8fVbuxeBZmJa6ZEjvQPzk1a0yuKGmjawHFmyL8CW8fPh72lza
	GRA==
X-Google-Smtp-Source: AGHT+IEfwvWga4q7lvhLPDENhsAb7G3rkv8tEZdsZcr/UUcxc0nnbiUdoNTNjhEeozTWOF/6PLRrloEjC8g=
X-Received: from pjyr7.prod.google.com ([2002:a17:90a:e187:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fc48:b0:301:6343:1626
 with SMTP id 98e67ed59e1d1-303a7c5b67fmr2721967a91.1.1743040557543; Wed, 26
 Mar 2025 18:55:57 -0700 (PDT)
Date: Wed, 26 Mar 2025 18:55:55 -0700
In-Reply-To: <CAHBxVyFLeZFwEnJYa-oUbAKVimdVsr=Ct76Jf=TyWeoAkHe8yQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250317-kvm_exit_fix-v1-1-aa5240c5dbd2@rivosinc.com>
 <Z9hI5vEHngcKvvRa@google.com> <CAHBxVyFLeZFwEnJYa-oUbAKVimdVsr=Ct76Jf=TyWeoAkHe8yQ@mail.gmail.com>
Message-ID: <Z-SwK1xO_S4phG2o@google.com>
Subject: Re: [PATCH] RISC-V: KVM: Teardown riscv specific bits after kvm_exit
From: Sean Christopherson <seanjc@google.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025, Atish Kumar Patra wrote:
> On Mon, Mar 17, 2025 at 9:08=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Mon, Mar 17, 2025, Atish Patra wrote:
> > >  arch/riscv/kvm/main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > > index 1fa8be5ee509..4b24705dc63a 100644
> > > --- a/arch/riscv/kvm/main.c
> > > +++ b/arch/riscv/kvm/main.c
> > > @@ -172,8 +172,8 @@ module_init(riscv_kvm_init);
> > >
> > >  static void __exit riscv_kvm_exit(void)
> > >  {
> > > -     kvm_riscv_teardown();
> > > -
> > >       kvm_exit();
> > > +
> > > +     kvm_riscv_teardown();
> >
> > I wonder if there's a way we can guard against kvm_init()/kvm_exit() be=
ing called
> > too early/late.  x86 had similar bugs for a very long time, e.g. see co=
mmit
> > e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/k=
vm to userspace").
> >
> > E.g. maybe we do something like create+destroy a VM at the end of kvm_i=
nit() and
> > the beginning of kvm_exit()?  Not sure if that would work for kvm_exit(=
), but it
> > should definitely be fine for kvm_init().
> >
> Yes. That would be super useful. I am not sure about the exact
> mechanism to achieve that though.

Me either :-)

> Do you just test code guarded within a new config that just
> creates/destroys a dummy VM ?

That's only idea I could come up with too, but I don't particulary like it.

> May be kunit test for KVM fits here in some way ?

I don't think a kunit test would be a good fit, there are likely too many
dependencies, and I'm pretty sure we'd still need to hack KVM.

