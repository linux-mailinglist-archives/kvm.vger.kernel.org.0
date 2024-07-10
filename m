Return-Path: <kvm+bounces-21323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E44E392D55D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2154D1C214D8
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790BE194A5C;
	Wed, 10 Jul 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JhbcPp9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6032219346A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626714; cv=none; b=cn2EJ85fW55qUarSEkPpzBr6h5l02MfFD01u7c4ILz/lVokV6MjfcVX2FpTpoFqw/Bxe65Ugr9mZT06DUt7geJbUMO3PwNQcYyoC6K6r9Q4YV3UVuDIlbNlbswoFNzX3Dtd0TpIihvr9T6h2U5haA70lsPXxUhJ76mX9WTYlt3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626714; c=relaxed/simple;
	bh=Yd7wN4MEwb/4Ych5ZfYI8ZDswiwmmeax1EQOB34ZhJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OV6NMkMByKFIPNVh782CbD/9pkAG6o1Eji9yibVCkSNyc/cT0+7iObukijC+U44XRvhvzzBRruiA6ftwbeHWXGqAonLHNrBeZHnJos9O/tE06OqVaaaiRDfYe9wpOJLfuZ5hBh+r2KehSIDuiTIPrSbelcmtvQiSo6lPX++yVTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JhbcPp9X; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1faf6103680so32431075ad.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720626713; x=1721231513; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2S/Ws8T8aRzTnaLMwEZxjsu7iN6mSUkQ05y/iw/B/rc=;
        b=JhbcPp9X5fROXiRJpjfZ0mTQ03VjyXK7pGgWskvMAElOy0XU1wY7FW8pnmf31TUW+5
         IJE5TVBX6p6aMR3DMQCuoK2xWjf2cc2gfY5YzDvfnk8eLuaEDi3zKkqJHCSlY49p85PE
         kBiDvGCsOnONVXq76F3+DncpaMz5vVEvZmII1jNLiud3xbeUdZsUSWay20lZRI5dhZ/x
         zydhk13mynnlSzmb6CstIOU6IZkHLVw6WAIYzflqCQjLlsvApD6LLULYeEJBVJIpfa4u
         vgAFmX81ngYINnV6yuWPEtU5WdHvWcoOxCWRJ6VvguHWm5XmYStbm2BvlsMwYiBTXnKj
         atlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720626713; x=1721231513;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2S/Ws8T8aRzTnaLMwEZxjsu7iN6mSUkQ05y/iw/B/rc=;
        b=oi555ayoTGTZvbtsY7vTuJGzP/u+QqYDZoaN32UZFBFL/PTpMV/Z0J5/n3JXpYANYh
         Q/5nxFLDVsJ4yjhww3rsVpVWsUO0XZiihyxwx7Z2T9kkxqPfVBv0VlAVJETMPHLGR39K
         tMQGKjHyrawnxgImjl1QmMAqJn6aAr7b7wnkjOGcaHv1MXyPxKWVaCydn9h+1PxyXoJx
         f2gra1vJH4rszAq5n10rHtdfRCTZzYowoj1N2MCh7YcGqlKSkep8kS0EWmZGsjhfYV07
         hmkV99XURKOXzDBjkFLO9VfOGpBw1AEEvgfrEIVAfU5D8/QX10wFpnynJQlOYrr6ZNBk
         Yr+w==
X-Forwarded-Encrypted: i=1; AJvYcCWUmHGUqyzTEHjA93VTrsjsEAi0soEejIx9vBigSQs5mydEFkyKJZa25+Gc+qaw4dvW121otQdrBelgzDH1WsbJENgH
X-Gm-Message-State: AOJu0YwTXwWbsMSguSoINdRiQhxWEcRVETZJq/AN9MZQPCi4kaUOEeRO
	1CbHcOo9RerPGm+u+dOS21NZM0APobv0EPMflWWbcXaHy/zb4Pen5xjo3zPCq00NHakjM7qt60J
	74Q==
X-Google-Smtp-Source: AGHT+IGFDWyL4oVIv+kd3eR4ozKAgHx5u/arXUHJsTVnFMVwi1+9LesGIr7Enb4S0IMxOwQQwYsx6SyO0KU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dad2:b0:1f7:175a:69ab with SMTP id
 d9443c01a7336-1fbb6ce3e7dmr4023085ad.4.1720626712651; Wed, 10 Jul 2024
 08:51:52 -0700 (PDT)
Date: Wed, 10 Jul 2024 08:51:51 -0700
In-Reply-To: <CALzav=cwu3M2nLHwZLCTF=eGWx2Nq+=TuHMuGTfZCNa27mLs1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com> <171874683295.1901599.10170158200177384059.b4-ty@google.com>
 <CALzav=cwu3M2nLHwZLCTF=eGWx2Nq+=TuHMuGTfZCNa27mLs1A@mail.gmail.com>
Message-ID: <Zo6uFz187FBYnQiY@google.com>
Subject: Re: [PATCH v3 0/3] KVM: Set vcpu->preempted/ready iff scheduled out
 while running
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 01, 2024, David Matlack wrote:
> On Tue, Jun 18, 2024 at 2:41=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, 03 May 2024 11:17:31 -0700, David Matlack wrote:
> > > This series changes KVM to mark a vCPU as preempted/ready if-and-only=
-if
> > > it's scheduled out while running. i.e. Do not mark a vCPU
> > > preempted/ready if it's scheduled out during a non-KVM_RUN ioctl() or
> > > when userspace is doing KVM_RUN with immediate_exit=3Dtrue.
> > >
> > > This is a logical extension of commit 54aa83c90198 ("KVM: x86: do not
> > > set st->preempted when going back to user space"), which  stopped
> > > marking a vCPU as preempted when returning to userspace. But if users=
pace
> > > invokes a KVM vCPU ioctl() that gets preempted, the vCPU will be mark=
ed
> > > preempted/ready. This is arguably incorrect behavior since the vCPU w=
as
> > > not actually preempted while the guest was running, it was preempted
> > > while doing something on behalf of userspace.
> > >
> > > [...]
> >
> > Applied to kvm-x86 generic, with minor changelog tweaks (me thinks you'=
ve been
> > away from upstream too long ;-) ).  Thanks!
>=20
> Thanks for the cleanups. Looks like you replaced "[Tt]his commit"
> throughout. Anything else (so I can avoid the same mistakes in the
> future)?

I don't think so?  The "This commit" stuff is the only thing that I remembe=
r, so
any other tweaks can't be that important :-)

