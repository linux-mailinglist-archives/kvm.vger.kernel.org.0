Return-Path: <kvm+bounces-18694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C47C8FA62F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 01:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 531D41C22015
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 23:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053F913D258;
	Mon,  3 Jun 2024 23:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XIgrM0kW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FB11DDD6
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 23:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717455790; cv=none; b=FnJPNqXM5afKGbLS0a9IiIRa7OH+p68lHy6und4EL79K9Ao9vYIGnCkghJf6q7s6MyHnwXPZs/TCEjEfi4JfgQNjpxF8RRwIUirVGPNzWkyDA4ntggwrcNpZyxORBbAQ7OvSpmWilOP9Y6TrDSCGP3F3vOwuLUwLimVJ8qUaZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717455790; c=relaxed/simple;
	bh=5+qBTnQ2jcGHCKlfoNDyIJ+P5xpxSFVMeOuIzIxDers=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJuC95tkmY8qXQaK496NJj0lfY4QmvUdtDlWH17uAzdjoXzNqTlSAw7KSiRGtaHIbnt2/VpwM4Jqn/fo8iXdfTOcEFyNVFhmzPu4FuYkyY8fCIsGhRtS8K55PU0yvCeEKj/jJq19agT2cN55I7PH6v0JYPFIEtqd1Eqef7XuPXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XIgrM0kW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f621072a44so27679435ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 16:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717455788; x=1718060588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0SJTxFtK/1G56YdHzcPYdHV7zjy1ZVa0L4hU78kSrI=;
        b=XIgrM0kWAEj+URv/Dne3kB27vhcsJRugxnvS3o91CPtO/pwBHFAS2R1dTPRPSWyaGz
         3oq5a6dayl7peIE5ODohYlC+eEh305/IZr/SO2soaJOCDIDRbzlh2CgGQYUUAGN+OhsK
         rHNB7puHXCKRUZR8S3+iFQYl/CRP+J5AnOC6rn2aamm8YJeY3JM6UnCFzB6Bksevkwzt
         uPqZfjdCVEklBbGKzx5n1g2+ZyrGgdp6w9oZ0Ki42tAq5H38XzjCZuf3A1sqGMReBf2I
         LjG8aat0MOiBKhGs3SiXz4GD1/C5ALgFFDOvScIUL9Jl6PnstWwUVHBbgDSFYFBSNsVJ
         +upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717455788; x=1718060588;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w0SJTxFtK/1G56YdHzcPYdHV7zjy1ZVa0L4hU78kSrI=;
        b=UuuWjGyP1hQKT1uMSXMfkN+zT3qX7/D+PDtAUR0e1Pm0N4ruNjyhMCu0PImobizvUk
         czglAjsXEE9tKZJiJq7R2XJC2EBU/oWQdisd+8pwT9cQcdHYYyRS8k3bOMcVOQd5OJ48
         eI3AmdwEvLBgb+8gLb2uJxPbOiR+ldd948vuJXBeoKx0Fa8BGaFx4uPCKwosqClDrz+h
         GhqSd+43xSWxH6tfYI6eSddgUrZsYwCAgO44vqHpW1a85ViEl4OkoRJEHPYVzzQTF7kT
         xePfJ4LR9vaPEipJSmVOq2Ihwl2nO1hEzI2qhDKZG/DSq4FOhap3+PqdNPq8g8AvIK5n
         oXYA==
X-Forwarded-Encrypted: i=1; AJvYcCX+zS+Mhuq1qwTTy5jsTg1ofNEg4RuULIIICiFFLzhxg/MRFCRfngUAcNHtkxGLQ0w5cZxArfiETQ8d+hcVtw3TJL0+
X-Gm-Message-State: AOJu0YzcVynebkW3awgAesows8cPMPCZUdPqH128cdY+SL0yA3qHhlzk
	pNRPFIUB5dg4CQKMnr+MI980s5eAd8KkDpr4J3ZD1S31lCFKLiY0++YoKIqPqyMfhk7oSJD7EyF
	DJg==
X-Google-Smtp-Source: AGHT+IH9puzU5V8aMTwgzoabUylaHv5IhJEL6Kgk0jFfHrRaPIZ6XCL4YZWlIMRWpWZxlsRoR1ZSqKiiwm0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea05:b0:1f6:3891:794a with SMTP id
 d9443c01a7336-1f638917b67mr7110545ad.10.1717455787406; Mon, 03 Jun 2024
 16:03:07 -0700 (PDT)
Date: Mon, 3 Jun 2024 16:03:05 -0700
In-Reply-To: <CADrL8HW44Hx_Ejx_6+FVKt1V17PdgT6rw+sNtKzumqc9UCVDfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
 <20240529180510.2295118-3-jthoughton@google.com> <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
 <ZlelW93_T6P-ZuSZ@google.com> <CAOUHufZdEpY6ra73SMHA33DegKxKaUM=Os7A7aDBFND6NkbUmQ@mail.gmail.com>
 <Zley-u_dOlZ-S-a6@google.com> <CADrL8HXHWg_MkApYQTngzmN21NEGNWC6KzJDw_Lm63JHJkR=5A@mail.gmail.com>
 <CAOUHufZq6DwpStzHtjG+TOiHaQ6FFbkTfHMCe8Yy0n_M9MKdqw@mail.gmail.com> <CADrL8HW44Hx_Ejx_6+FVKt1V17PdgT6rw+sNtKzumqc9UCVDfA@mail.gmail.com>
Message-ID: <Zl5LqcusZ88QOGQY@google.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
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

On Mon, Jun 03, 2024, James Houghton wrote:
> On Thu, May 30, 2024 at 11:06=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrot=
e:
> > What I don't think is acceptable is simplifying those optimizations
> > out without documenting your justifications (I would even call it a
> > design change, rather than simplification, from v3 to v4).
>=20
> I'll put back something similar to what you had before (like a
> test_clear_young() with a "fast" parameter instead of "bitmap"). I
> like the idea of having a new mmu notifier, like
> fast_test_clear_young(), while leaving test_young() and clear_young()
> unchanged (where "fast" means "prioritize speed over accuracy").

Those two statements are contradicting each other, aren't they?  Anyways, I=
 vote
for a "fast only" variant, e.g. test_clear_young_fast_only() or so.  gup() =
has
already established that terminology in mm/, so hopefully it would be famil=
iar
to readers.  We could pass a param, but then the MGLRU code would likely en=
d up
doing a bunch of useless indirect calls into secondary MMUs, whereas a dedi=
cated
hook allows implementations to nullify the pointer if the API isn't support=
ed
for whatever reason.

And pulling in Oliver's comments about locking, I think it's important that=
 the
mmu_notifier API express it's requirement that the operation be "fast", not=
 that
it be lockless.  E.g. if a secondary MMU can guarantee that a lock will be
contented only in rare, slow cases, then taking a lock is a-ok.  Or a secon=
dary
MMU could do try-lock and bail if the lock is contended.

That way KVM can honor the intent of the API with an implementation that wo=
rks
best for KVM _and_ for MGRLU.  I'm sure there will be future adjustments an=
d fixes,
but that's just more motivation for using something like "fast only" instea=
d of
"lockless".

> > > I made this logic change as part of removing batching.
> > >
> > > I'd really appreciate guidance on what the correct thing to do is.
> > >
> > > In my mind, what would work great is: by default, do aging exactly
> > > when KVM can do it locklessly, and then have a Kconfig to always have
> > > MGLRU to do aging with KVM if a user really cares about proactive
> > > reclaim (when the feature bit is set). The selftest can check the
> > > Kconfig + feature bit to know for sure if aging will be done.
> >
> > I still don't see how that Kconfig helps. Or why the new static branch
> > isn't enough?
>=20
> Without a special Kconfig, the feature bit just tells us that aging
> with KVM is possible, not that it will necessarily be done. For the
> self-test, it'd be good to know exactly when aging is being done or
> not, so having a Kconfig like LRU_GEN_ALWAYS_WALK_SECONDARY_MMU would
> help make the self-test set the right expectations for aging.
>=20
> The Kconfig would also allow a user to know that, no matter what,
> we're going to get correct age data for VMs, even if, say, we're using
> the shadow MMU.

Heh, unless KVM flushes, you won't get "correct" age data.

> This is somewhat important for me/Google Cloud. Is that reasonable? Maybe
> there's a better solution.

Hmm, no?  There's no reason to use a Kconfig, e.g. if we _really_ want to p=
rioritize
accuracy over speed, then a KVM (x86?) module param to have KVM walk nested=
 TDP
page tables would give us what we want.

But before we do that, I think we need to perform due dilegence (or provide=
 data)
showing that having KVM take mmu_lock for write in the "fast only" API prov=
ides
better total behavior.  I.e. that the additional accuracy is indeed worth t=
he cost.

