Return-Path: <kvm+bounces-18349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E3F8D419B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3A84286B8A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 22:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A6D200105;
	Wed, 29 May 2024 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQASlsLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E861CB328
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717023487; cv=none; b=MvLJouzgr+OtqLYuEYyQxqP19uG2wMtt6SI5RLwTwovRVtmrHC5ycOuE0SV861ko0JHvbDNQkZQaHxPs0hZ3cRHAmOiubJKy4GZ8Lcqe6C5J85O9GVMQMKyfvifv7YOjykyleIeuV0dlMM5jur0Tna1CaINTapqQJjL5W6mNl7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717023487; c=relaxed/simple;
	bh=ILTrqYj7gGL+uJmOCLBAjzct0EhWj0aN1ME6oQovXBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gaaZEoZLWfSbzT1OOcEEQ3gmfH0GmxnPbOZIRhSHFlWW7yQulLAYGaHWXjMvYIhFZyhnK2NwGj4vxbilCbNUBACqkj+j7NkfFFa3xX5BksY8djiKwbzmlnRRV8u6NU/ByypGkqHqvT/IiJ9AwEUW2OAKYsRmfRiT12+3rJ5ClGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQASlsLC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78efda253so382610276.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717023484; x=1717628284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXQ4aAmXpFR+Rnn+LVSp/P9w+zocv3IAjl6jcVlXHAQ=;
        b=hQASlsLCL8kat+pj2/OkA1ZECcq0+xKl8UztvJtH9+LXg6cCfWSX0oohqQTDHgHoIb
         J6rtEUd3mudMo4BrLifi5jjMNrb//SYmWuebakj8yeapa+M7cM5rUoZcZlx3Ve+NlJDg
         zd/JJqHa5+YYXVp4BgXx5VQTmO3mwBsaM7h74wh90vWCuVcNEX66rVWxK5hJ7BvneDvO
         CajLCrG7dWW7LRy2ArZt5Y6OfZjNOArR1+A54pEBICg/tKqOHQxZTurZ7Wor7jsvEqOW
         reBjDmxC96PJzNL61dz+shkHdzwkmQRJziF8517eNEIX/mNdrh/qkIuS3DWbDtU6yAAX
         Q/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717023484; x=1717628284;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lXQ4aAmXpFR+Rnn+LVSp/P9w+zocv3IAjl6jcVlXHAQ=;
        b=AaOazg6O8lN6TmwaOwGFPrNBrLxANewA2gDNmif+Cu+5x8ThdpW03av9gc0tDlULnp
         xu/ZPRa+mqDEwNvATTDUIetgxLQLuUSDxos8ium3uKI35NBKh418r3bfnqnUlih9EGt9
         XXVyfBqojAL0QHPwz8c2ZMdDwwpjQDx3u0nyHKL/H2YaMf8uHWtePXlSj6aHR0KbSq70
         RaRnFhv01vyBmosXUWPs9b+XJLiN8GyGlYwE5Ba2VoZZkamXsEEEUkvbWc1kcuYTRvTb
         6BiDkuJYspzvkTRXBbmGlT2CuzU7COEGgYnzmhluEWee2AkAdqhBgouNoWNXaXQ4BHjf
         cszQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRNa204BwL3uDl/rPkAXDGXhGCG+oLb+Oqc9YwPPW13sLx6L2eYUapNLSb7icL+XRJ7UoHI5zBBrYMKuK/2R7kKSG9
X-Gm-Message-State: AOJu0YydU82T8vk5PGtRX7Er5RHjcOAMJEgtpZdJp9QmOdmFcKqMHaAh
	0lR3/qS9U5YXX0+25TDsbznGshDpRW4HR61uNPikR2yadblPE1P5GJVBggprdngbBuP2gaI38M5
	kZg==
X-Google-Smtp-Source: AGHT+IEcoxWAWGQljmQC1ObvPASoASZSWeSUzQr2Szq7dgxCnuAYyloQCwOCyj3B7twEp9K1BnNOHbqA4OU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dfa:5838:b919 with SMTP id
 3f1490d57ef6-dfa5a68828dmr142777276.10.1717023484293; Wed, 29 May 2024
 15:58:04 -0700 (PDT)
Date: Wed, 29 May 2024 15:58:02 -0700
In-Reply-To: <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
Message-ID: <Zley-u_dOlZ-S-a6@google.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Ankit Agrawal <ankita@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Bibo Mao <maobibo@loongson.cn>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024, Yu Zhao wrote:
> On Wed, May 29, 2024 at 3:59=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, May 29, 2024, Yu Zhao wrote:
> > > On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@g=
oogle.com> wrote:
> > > >
> > > > Secondary MMUs are currently consulted for access/age information a=
t
> > > > eviction time, but before then, we don't get accurate age informati=
on.
> > > > That is, pages that are mostly accessed through a secondary MMU (li=
ke
> > > > guest memory, used by KVM) will always just proceed down to the old=
est
> > > > generation, and then at eviction time, if KVM reports the page to b=
e
> > > > young, the page will be activated/promoted back to the youngest
> > > > generation.
> > >
> > > Correct, and as I explained offline, this is the only reasonable
> > > behavior if we can't locklessly walk secondary MMUs.
> > >
> > > Just for the record, the (crude) analogy I used was:
> > > Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
> > > but you are only allowed to pick up 10 of them (and put them in your
> > > pocket). A smart move would be to survey the room *first and then*
> > > pick up the largest ones. But if you are carrying a 500 lbs backpack,
> > > you would just want to pick up whichever that's in front of you rathe=
r
> > > than walk the entire room.
> > >
> > > MGLRU should only scan (or lookaround) secondary MMUs if it can be
> > > done lockless. Otherwise, it should just fall back to the existing
> > > approach, which existed in previous versions but is removed in this
> > > version.
> >
> > IIUC, by "existing approach" you mean completely ignore secondary MMUs =
that
> > don't implement a lockless walk?
>=20
> No, the existing approach only checks secondary MMUs for LRU folios,
> i.e., those at the end of the LRU list. It might not find the best
> candidates (the coldest ones) on the entire list, but it doesn't pay
> as much for the locking. MGLRU can *optionally* scan MMUs (secondary
> included) to find the best candidates, but it can only be a win if the
> scanning incurs a relatively low overhead, e.g., done locklessly for
> the secondary MMU. IOW, this is a balance between the cost of
> reclaiming not-so-cold (warm) folios and that of finding the coldest
> folios.

Gotcha.

I tend to agree with Yu, driving the behavior via a Kconfig may generate si=
mpler
_code_, but I think it increases the overall system complexity.  E.g. distr=
os
will likely enable the Kconfig, and in my experience people using KVM with =
a
distro kernel usually aren't kernel experts, i.e. likely won't know that th=
ere's
even a decision to be made, let alone be able to make an informed decision.

Having an mmu_notifier hook that is conditionally implemented doesn't seem =
overly
complex, e.g. even if there's a runtime aspect at play, it'd be easy enough=
 for
KVM to nullify its mmu_notifier hook during initialization.  The hardest pa=
rt is
likely going to be figuring out the threshold for how much overhead is too =
much.

