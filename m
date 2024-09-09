Return-Path: <kvm+bounces-26154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C97229723EE
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 570801F2388B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 20:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E707D18A95B;
	Mon,  9 Sep 2024 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oU1Zh8FA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2374189F58
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 20:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725914833; cv=none; b=kPufWcV/2eE7h2LQL0KgMJaWd3DFWpbFswq4JWz10Uk6IM0ED8pe7qBl7oicdzNOd0SnhS3L+8Wn3+HL2weQQVTFxK/Evm137i/SQVSovRkeTTUnYKjJ3ZSTF1yZwSdixMeXKB+1Tzcq/efGhq/7PXa6BFtVC+gKYNRySDo/f8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725914833; c=relaxed/simple;
	bh=l5Hzxjri222Fvyf/O9QYlfINjialctqsSCbVUQ8Qon4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HdGAjjegUcZmWKGHyI3ykSmk1KWjSQVJG6Pt1FQZ0ZURDQQTwj6AyDJ6LqEnmf50jnomwQxkB9T3u0kNFsTSgVXLWvrlRVN76jujKJ806FX9jbh4a7WVnUvHjxR2sAMzY1jW546QVvx4YbqY9ysB+mJoQIO4awLzGrrJscr8gqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oU1Zh8FA; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e1a90780f6dso41615276.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 13:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725914830; x=1726519630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuORi0YnexlTPBY+zaBJd4hlVfj1J/9GYh5O24XYwo0=;
        b=oU1Zh8FAhZOPaKfdKAhaSKTYfjhwgHY+dFzVDyyntmNLGGpOJ7x+Du83NyfuTpUPC9
         l23TtZmBC3cTbXeGTXfQFK0TuPQAGFgOkeGUgmZagRDPa1ig58T7F8G0lsintzMmsHTh
         Uwshxqz5uZx5FREo0qL95zd8hSeKgMqByFLeNaGa8eq7jZ/6KJDNwVuxKtfQFCB88Ywj
         7dD2+j26uY4DnRUuI0LhyHF5iqq+7biQMkC/9YolMJOYDhUryj/TS7MBg11C/hrwr9Qy
         KdIF3STVO/GjXc9TtFd2Vvedohm8/mWtut9/UOCFZIg/CLmO5nqT7EIwUKX2JCYKSGHS
         6XJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725914830; x=1726519630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuORi0YnexlTPBY+zaBJd4hlVfj1J/9GYh5O24XYwo0=;
        b=mZJl2df2nB8FY6CG/EZHlW0TNZElCiMdKGAmp1khbttqXKr4WtZ3/OcIYTN+WTHrYM
         BbbjmwW/EimHYj456cRazVw4a4qO8ULqH/ZOHTG+alTNx41p9cmfp+5Qb3t3apC2yUwm
         D5FdB0JX3K+gU0tHFGKgjm/cr0AD/4MqHdoyz5PcdQ7pCFd0gMYQtYKpe0DggFYyEeeT
         dfRiCK58PkkOtD/yK/HP/RT336bcVlMfCUwk7TFx/U8kXZT5V2gffU12w2/oiSsEhP5S
         BjhIFn2QNEZAJdcQDiDDeWf9KPOcUnOq/TsVzURD+cWJ7SbnSrC0dWSZI41/BQeZurwo
         C/4w==
X-Forwarded-Encrypted: i=1; AJvYcCX7hucO6702s141yOeQcYQhL9TlJqlUgkPehjFUPsGMmeUmg084iscSzasF7KiV7gpRmJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTssHFM3KfJgqOwWMa4IU/yu7Rl0IUMOBSAyxrLwzt6cS284BH
	qldu0V7h1Qx166IFvWJDV3UEqud7BNC9HJBFIT9krpuPavRqBilDCe32JTuKr+cnV5AH0OJEVoR
	n4UjwdIyCLeHFA0r7YzmxfE2+CBVHj/VDmeqD
X-Google-Smtp-Source: AGHT+IEyKzunwyxeaUilc19ZD35nlfeHPyC3pCh4uXJoVC0EatorN5C8T1z2x/R7Ge97ynwgsqZM8/KF2GWi6s3/108=
X-Received: by 2002:a25:a2c4:0:b0:e1d:3a7f:2f85 with SMTP id
 3f1490d57ef6-e1d3a7f30c9mr10763041276.24.1725914830348; Mon, 09 Sep 2024
 13:47:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com> <Zt9UT74XkezVpTuK@google.com>
In-Reply-To: <Zt9UT74XkezVpTuK@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 9 Sep 2024 13:46:34 -0700
Message-ID: <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 1:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Sep 09, 2024, James Houghton wrote:
> > On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > + */
> > > +#define KVM_RMAP_LOCKED        BIT(1)
> > > +
> > > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> > > +{
> > > +       unsigned long old_val, new_val;
> > > +
> > > +       old_val =3D READ_ONCE(rmap_head->val);
> > > +       if (!old_val)
> > > +               return 0;
> > > +
> > > +       do {
> > > +               /*
> > > +                * If the rmap is locked, wait for it to be unlocked =
before
> > > +                * trying acquire the lock, e.g. to bounce the cache =
line.
> > > +                */
> > > +               while (old_val & KVM_RMAP_LOCKED) {
> > > +                       old_val =3D READ_ONCE(rmap_head->val);
> > > +                       cpu_relax();
> > > +               }
> > > +
> > > +               /*
> > > +                * Recheck for an empty rmap, it may have been purged=
 by the
> > > +                * task that held the lock.
> > > +                */
> > > +               if (!old_val)
> > > +                       return 0;
> > > +
> > > +               new_val =3D old_val | KVM_RMAP_LOCKED;
> > > +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
> >
> > I think we (technically) need an smp_rmb() here. I think cmpxchg
> > implicitly has that on x86 (and this code is x86-only), but should we
> > nonetheless document that we need smp_rmb() (if it indeed required)?
> > Perhaps we could/should condition the smp_rmb() on `if (old_val)`.
>
> Hmm, no, not smp_rmb().  If anything, the appropriate barrier here would =
be
> smp_mb__after_spinlock(), but I'm pretty sure even that is misleading, an=
d arguably
> even wrong.

I don't think smp_mb__after_spinlock() is right either. This seems to
be used following the acquisition of a spinlock to promote the memory
ordering from an acquire barrier (that is implicit with the lock
acquisition, e.g. [1]) to a full barrier. IIUC, we have no need for a
stronger-than-usual barrier. But I guess I'm not really sure.

In this case, I'm complaining that we don't have the usual memory
ordering restrictions that come with a spinlock.

> For the !old_val case, there is a address/data dependency that can't be b=
roken by
> the CPU without violating the x86 memory model (all future actions with r=
elevant
> memory loads depend on rmap_head->val being non-zero).  And AIUI, in the =
Linux
> kernel memory model, READ_ONCE() is responsible for ensuring that the add=
ress
> dependency can't be morphed into a control dependency by the compiler and
> subsequently reordered by the CPU.
>
> I.e. even if this were arm64, ignoring the LOCK CMPXCHG path for the mome=
nt, I
> don't _think_ an smp_{r,w}mb() pair would be needed, as arm64's definitio=
n of
> __READ_ONCE() promotes the operation to an acquire.
>
> Back to the LOCK CMPXCHG path, KVM_RMAP_LOCKED implements a rudimentary s=
pinlock,
> hence my smp_mb__after_spinlock() suggestion.  Though _because_ it's a sp=
inlock,
> the rmaps are fully protected by the critical section.

I feel like a spinlock must include the appropriate barriers for it to
correctly function as a spinlock, so I'm not sure I fully understand
what you mean here.

> And for the SPTEs, there
> is no required ordering.  The reader (aging thread) can observe a !PRESEN=
T or a
> PRESENT SPTE, and must be prepared for either.  I.e. there is no requirem=
ent that
> the reader observe a PRESENT SPTE if there is a valid rmap.

This makes sense.

> So, unless I'm missing something, I would prefer to not add a smp_mb__aft=
er_spinlock(),
> even though it's a nop on x86 (unless KCSAN_WEAK_MEMORY=3Dy), because it =
suggests
> an ordering requirement that doesn't exist.

So we have: the general kvm_rmap_lock() and the read-only
kvm_rmap_lock_readonly(), as introduced by the next patch[2]. I'll use
those names (sorry if it's confusing).

For kvm_rmap_lock(), we are always holding mmu_lock for writing. So
any changes we make to the rmap will be properly published to other
threads that subsequently grab kvm_rmap_lock() because we had to
properly release and then re-acquire mmu_lock, which comes with the
barriers I'm saying we need.

For kvm_rmap_lock_readonly(), we don't hold mmu_lock, so there is no
smp_rmb() or equivalent. Without an smp_rmb() somewhere, I claim that
it is possible that there may observe external changes to the
pte_list_desc while we are in this critical section (for a
sufficiently weak architecture). The changes that the kvm_rmap_lock()
(mmu_lock) side made were half-published with an smp_wmb() (really
[3]), but the read side didn't use a load-acquire or smp_rmb(), so it
hasn't held up its end of the deal.

I don't think READ_ONCE() has the guarantees we need to be a
sufficient replacement for smp_rmb() or a load-acquire that a real
lock would use, although I agree with you that, on arm64, it
apparently *is* a sufficient replacement.

Now this isn't a problem if the kvm_rmap_lock_readonly() side can
tolerate changes to pte_list_desc while in the critical section. I
don't think this is true (given for_each_rmap_spte_lockless),
therefore an smp_rmb() or equivalent is (technically) needed.

Am I confused?

(Though all of this works just fine as written on x86.)

[1]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/rwbas=
e_rt.c#L62
[2]: https://lore.kernel.org/kvm/20240809194335.1726916-21-seanjc@google.co=
m/
[3]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/rwbas=
e_rt.c#L190

