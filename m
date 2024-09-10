Return-Path: <kvm+bounces-26181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6899726A7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58B3A1F244E2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8583E13AA46;
	Tue, 10 Sep 2024 01:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SJRu183N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5737165
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725932578; cv=none; b=nTvpcXt/och+3AREk30jvJO+UQwqV1WW0h5pC3fLmsERJBPoRU2WJc8CemA0heKT+1Q4pncI64DitchrOlUJZjRz2nROOAvNq3A1/ujafpHLeER44WIKnOdn69NY9ITvRDSLkAotcRZ2HPQosE8vQL6xQncnMCXr5m7opb4YTcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725932578; c=relaxed/simple;
	bh=+/PCdjNe2dfM+dCZ+mpa07o3EmJ3SWGbRgQEt41wOVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gLM5t0ryRo48Wy/M//Bl7DeosX2aYvt/bfzb+9cY7/elcuvFMXzo4dF+1VERj231loThwtXltHeftVwyxHBrr3n9aizCSFLG3e+p8k5pnUNVCAIA0g1oAS7Z6MKiJ44I2IdLpQj1C8v+wk6si8IU7qhxauRWMFL0plGsIvrjq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SJRu183N; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso11424823276.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 18:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725932576; x=1726537376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3ZJS4NCqs2daZcr/ed8Z/zqWEoFadweNh0PNCQlatA=;
        b=SJRu183NRVz7rbPeE6UQx7xwvsV4MNRoOXgiG6Jc3TqrgVx7zHEx8Ckx8l8aXQwI3s
         Wx1aHOupatPA2/RiVGDH65L8p4jY/uqXK6FDfoqaEntsj46NYW1OC5UV2kD/X+M8ncCh
         BcAC+GIxWvx3MLSWJm54P6In/n9YXwgz4KbuJ3V1FO/GhJcwQ1/UHhapQM58K8yloqaM
         Iag7A7AX807oku7o7MX6WcrYCnLWkrdmCBw+tQ8jPoKqVIvfsJshXf1vEbXgABuEWSB8
         VkGSFtV+emOSSLGe0E5pnMw5FdnsqcNdqjhaZlf5zrajc2gPtrRvFxXHc8HchkOT4O7C
         bCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725932576; x=1726537376;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s3ZJS4NCqs2daZcr/ed8Z/zqWEoFadweNh0PNCQlatA=;
        b=tzMG6Rj7xWPLoeaI/8pmVCmiz6dLgVq3LAOdlZwQWdp8FXk/mT8nfVLogl/D2h26Vy
         XOt1dj9A5LGb6SEKAkrJJMHifWwMDw+g2/p4yt0GHlm0L7TlCEnND+UOgx1qvhiBoYrX
         9AocFLcASsbpxpB/QzSpcuSGEBeVcGE0tJS3VDCHL5zfFYT4tRVoY6c1xeorHOAFBnkU
         8Ukx4QVcR1yR/+00ULv0d9APjgbgmK6da1H7VtSRGWzfXCcaorTdh2kZhCfTK8nr5V9f
         SNP7Lq8PESA12l8r8ulqM1YAV4QAvMJuRJ+cfaiHk6N8tt/j6ovjZs7OV+q2dTC9cUzs
         APmQ==
X-Forwarded-Encrypted: i=1; AJvYcCULkLFtpP0KQndmiAmJELHFcIzZlh7SqjN9yvr04kAcrozzTwPhW6yzqib69Y9tdlejwgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ5SZgWnfNbwTKvXo3H/wgsgd6j6hCmTOEb0k50Rza3HxPCxkw
	s7rgHjKwhOJWfzvldwQXMcVGMQTjTtiFxIcvtBZ1v4lSKAoB+zp2k53ntKzG32KpIq/ZoXO+c1y
	vSw==
X-Google-Smtp-Source: AGHT+IHR0cISWbNSGYzTHxwwKccQKA3RLZdDOFknSYtGDe+7IRQ53sx+JM4pizATZulD7JxEZowAqbSaKqY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f08:0:b0:e0b:f1fd:1375 with SMTP id
 3f1490d57ef6-e1d34a1fb19mr19944276.10.1725932575899; Mon, 09 Sep 2024
 18:42:55 -0700 (PDT)
Date: Mon, 9 Sep 2024 18:42:54 -0700
In-Reply-To: <CADrL8HWbNjv-w-ZJOxkLK78S5RePd2QXDuXV-=4iFVV29uHKyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
 <Zt9UT74XkezVpTuK@google.com> <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
 <Zt9wg6h_bPp8BKtd@google.com> <CADrL8HWbNjv-w-ZJOxkLK78S5RePd2QXDuXV-=4iFVV29uHKyg@mail.gmail.com>
Message-ID: <Zt-kHjtTVrONMU1V@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, James Houghton wrote:
> On Mon, Sep 9, 2024 at 3:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Mon, Sep 09, 2024, James Houghton wrote:
> > > On Mon, Sep 9, 2024 at 1:02=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > Hmm, no, not smp_rmb().  If anything, the appropriate barrier here =
would be
> > > > smp_mb__after_spinlock(), but I'm pretty sure even that is misleadi=
ng, and arguably
> > > > even wrong.
> > >
> > > I don't think smp_mb__after_spinlock() is right either. This seems to
> > > be used following the acquisition of a spinlock to promote the memory
> > > ordering from an acquire barrier (that is implicit with the lock
> > > acquisition, e.g. [1]) to a full barrier. IIUC, we have no need for a
> > > stronger-than-usual barrier. But I guess I'm not really sure.
> > >
> > > In this case, I'm complaining that we don't have the usual memory
> > > ordering restrictions that come with a spinlock.
> >
> > What makes you think that?
>=20
> Ok I was under the impression that try_cmpxchg() did not carry memory
> ordering guarantees (i.e., I thought it was try_cmpxchg_relaxed()).
> Sorry....
>=20
> So the way I would write this is with try_cmpxchg_relaxed() in the
> loop and then smp_rmb() after we break out of the loop, at least for
> the `old_val !=3D 0` case. Kinda like this [4].
>=20
> Did you really want try_cmpxchg(), not try_cmpxchg_relaxed()?

Heh, why would I care?  On x86, they are the same thing.  Yeah, I could tea=
se out
some subtle difference to super precisely describe KVM's behavior, but that=
 more
or less defeats the value proposition of total-store ordered architectures:=
 take
on more complexity in hardware (and possibly loss in performance) to allow =
for
simpler software.

> Just comparing against bit_spin_lock, test_and_set_bit_lock()
> documents the requirement for acquire barrier semantics[5].

Again, that's generic library code.

> [4]: https://elixir.bootlin.com/linux/v6.10.9/source/kernel/locking/rtmut=
ex.c#L253
> [5]: https://elixir.bootlin.com/linux/v6.10.9/source/include/asm-generic/=
bitops/instrumented-lock.h#L51

...

> > And jumping back to the "we don't have the usual memory ordering
> > restrictions that come with a spinlock", x86's virt_spin_lock() uses
> > atomic_try_cmpxchg().  So while using the acquire variant here is obvio=
usly
> > not wrong, it also feels somewhat weird.
>=20
> Yeah that's fine. atomic_try_cmpxchg() is at least as strong as
> atomic_try_cmpxchg_acquire(), so there is no issue.
>=20
> But if virt_spin_lock() were written to use atomic_try_cmpxchg_relaxed() =
(and
> nothing else) instead, then you'd complain right?

I'd complain because someone made me think hard for no reason. :-)

> It would work on x86 (I think?), but it's not written properly! That's
> basically what I'm saying in this thread.
>=20
> > Though some of that is undoubtedly due to explicit "acquire" semantics
> > being rather rare in x86.
> >
> > > > And for the SPTEs, there is no required ordering.  The reader (agin=
g
> > > > thread) can observe a !PRESENT or a PRESENT SPTE, and must be prepa=
red for
> > > > either.  I.e. there is no requirement that the reader observe a PRE=
SENT
> > > > SPTE if there is a valid rmap.
> > >
> > > This makes sense.
> > >
> > > > So, unless I'm missing something, I would prefer to not add a smp_m=
b__after_spinlock(),
> > > > even though it's a nop on x86 (unless KCSAN_WEAK_MEMORY=3Dy), becau=
se it suggests
> > > > an ordering requirement that doesn't exist.
> > >
> > > So we have: the general kvm_rmap_lock() and the read-only
> > > kvm_rmap_lock_readonly(), as introduced by the next patch[2]. I'll us=
e
> > > those names (sorry if it's confusing).
> > >
> > > For kvm_rmap_lock(), we are always holding mmu_lock for writing. So
> > > any changes we make to the rmap will be properly published to other
> > > threads that subsequently grab kvm_rmap_lock() because we had to
> > > properly release and then re-acquire mmu_lock, which comes with the
> > > barriers I'm saying we need.
> > >
> > > For kvm_rmap_lock_readonly(), we don't hold mmu_lock, so there is no
> > > smp_rmb() or equivalent. Without an smp_rmb() somewhere, I claim that
> > > it is possible that there may observe external changes to the
> > > pte_list_desc while we are in this critical section (for a
> > > sufficiently weak architecture). The changes that the kvm_rmap_lock()
> > > (mmu_lock) side made were half-published with an smp_wmb() (really
> > > [3]), but the read side didn't use a load-acquire or smp_rmb(), so it
> > > hasn't held up its end of the deal.
> > >
> > > I don't think READ_ONCE() has the guarantees we need to be a
> > > sufficient replacement for smp_rmb() or a load-acquire that a real
> > > lock would use, although I agree with you that, on arm64, it
> > > apparently *is* a sufficient replacement.
> > >
> > > Now this isn't a problem if the kvm_rmap_lock_readonly() side can
> > > tolerate changes to pte_list_desc while in the critical section. I
> > > don't think this is true (given for_each_rmap_spte_lockless),
> > > therefore an smp_rmb() or equivalent is (technically) needed.
> > >
> > > Am I confused?
> >
> > Yes, I think so.  kvm_rmap_lock_readonly() creates a critical section t=
hat prevents
> > any pte_list_desc changes.  rmap_head->val, and every pte_list_desc tha=
t is pointed
> > at by rmap_head->val in the KVM_RMAP_MULTI case, is protected and canno=
t change.
>=20
> I take back what I said about this working on x86. I think it's
> possible for there to be a race.
>=20
> Say...
>=20
> 1. T1 modifies pte_list_desc then unlocks kvm_rmap_unlock().
> 2. T2 then locks kvm_rmap_lock_readonly().
>=20
> The modifications that T1 has made are not guaranteed to be visible to
> T2 unless T1 has an smp_wmb() (or equivalent) after the modfication
> and T2 has an smp_rmb() before reading the data.
>=20
> Now the way you had it, T2, because it uses try_cmpxchg() with full
> ordering, will effectively do a smp_rmb(). But T1 only does an
> smp_wmb() *after dropping the mmu_lock*, so there is a race. While T1
> still holds the mmu_lock but after releasing the kvm_rmap_lock(), T2
> may enter its critical section and then *later* observe the changes
> that T1 made.
>=20
> Now this is impossible on x86 (IIUC) if, in the compiled list of
> instructions, T1's writes occur in the same order that we have written
> them in C. I'm not sure if WRITE_ONCE guarantees that this reordering
> at compile time is forbidden.
>=20
> So what I'm saying is:
>=20
> 1. kvm_rmap_unlock() must have an smp_wmb().

No, because beating a dead horse, this is not generic code, this is x86.=20

> 2. If you change kvm_rmap_lock() to use try_cmpxchg_relaxed() (which
> is what I think you want),=20

No, I don't.  If this were generic code, then it would be a different conve=
rsation,
but using a "relaxed" atomic in x86 specific code is nonsensical, because s=
uch an
operation simply does not exist in the world of x86.  There are memory oper=
ations
that have relaxed ordering, but none of them are atomic; they are very much=
 the
exact opposite of atomic.

E.g. the only references to _relaxed that you'll find in x86 are to overrid=
e the
generics to x86's non-relaxed semantics.

$ git grep _relaxed arch/x86
arch/x86/include/asm/io.h:#define readb_relaxed(a) __readb(a)
arch/x86/include/asm/io.h:#define readw_relaxed(a) __readw(a)
arch/x86/include/asm/io.h:#define readl_relaxed(a) __readl(a)
arch/x86/include/asm/io.h:#define writeb_relaxed(v, a) __writeb(v, a)
arch/x86/include/asm/io.h:#define writew_relaxed(v, a) __writew(v, a)
arch/x86/include/asm/io.h:#define writel_relaxed(v, a) __writel(v, a)
arch/x86/include/asm/io.h:#define readq_relaxed(a)      __readq(a)
arch/x86/include/asm/io.h:#define writeq_relaxed(v, a)  __writeq(v, a)

There are a few places in KVM x86 where _acquire() and _release() variants =
are
used, but that's done purely to document the roles and who is doing what, a=
nd
almost always (maybe always?) when there are lockless programming shenaniga=
ns
in play.

E.g. kvm_recalculate_apic_map() is probably the closest example, where KVM =
uses
atomic_read_acquire(), atomic_cmpxchg_acquire(), and atomic_cmpxchg_release=
() to
document the ordering between marking the map as dirty and actually process=
ing
the map.  But that is still quite different, as apic_map_dirty is not a spi=
nlock,
there isn't a direct data/address dependency between apic_map_dirty and all=
 of
the data it consumes, _and_ the data that is guarded by apic_map_dirty can =
be
modified by other vCPUs _while it is being processed_.

Hmm, actually, sev_lock_two_vms() is arguably a better comparison.  That's =
also
a rudimentary spinlock (try-lock only behavior).

If kvm_rmap_head.val were an int, i.e. could be unionized with an atomic_t,=
 then
I wouldn't be opposed to doing this in the locking code to document things:

 s/READ_ONCE/atomic_read_acquire
 s/WRITE_ONCE/atomic_set_release
 s/try_cmpxchg/atomic_cmpxchg_acquire

But it's an "unsigned long", and so trying to massage it into the above isn=
't a
net positive for me.  This is gnarly x86 specific code; it's very unlikely =
that
someone will be able to understand the rest of the rmap code, but won't be =
able
to understand that the code is safe due to x86's strong memory ordering.

> then you must also have an smp_rmb() following a successful
> cmpxchg/acquisition (at least for the case where we then follow the
> pte_list_desc pointer).

