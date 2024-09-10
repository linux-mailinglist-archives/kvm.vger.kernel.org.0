Return-Path: <kvm+bounces-26176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5074E97262D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 02:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E714284A02
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA9028DC3;
	Tue, 10 Sep 2024 00:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l7022Qmw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7B1E4B0
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 00:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725928178; cv=none; b=qiO3hbnWbr+G3e+67phh49BbgXsULmGqF87+bqtTuot5xWhPAnhrMKdKCRQNKo9iXSz/wwfAPtVajP2LjdKPLVso85s2DIO93KrrFO1YKmdduhlYmJLYQT8G76lZM8KpMxknySWUiEDNGQKB0XhUdZNd7hxDUp04k36CnTndCvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725928178; c=relaxed/simple;
	bh=+LGdamhgZ8ZUsQHy5r6cV9WL04chr5Tu66fgTRgJXgk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jp9kAIUDHkjxo3FLhkZvaFh6QvS/sYzWup+XzvYJUYwAOQktfNuDcmbp77fz2TgifwjQF7s1aCFbrIex6jppDmYBMEXDl2WYaP1wKicmtzTS4W586MYCmt3w4O61Ici33X3u7yLtXqdvFu8llTp9bnj653sdxctlb4MaEKHd/YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l7022Qmw; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-6da395fb97aso984097b3.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 17:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725928175; x=1726532975; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHM2I1sQ9+0AOyF9datK6mfjd6+l7ZePwvm96Pc4Mt8=;
        b=l7022Qmw8+Jr7VPBBopfTTvIDG4gJIRApPCjvOlrlCqjJ3xkV2YHwYoFYZEWkwCJ+g
         LMHvrPQKbu4oIdNzxY0rL0JAJBgMK2Rb8YhkBY9ME6NswDhQfZ3XBcgSVYHhQ5WdHOcu
         PNS9VfFYqYlhBgOhHYaXOD+bYCZ3/j/Jv9RQkTUaTL1kfKl7wBxc1MBRTswNUysYK0dZ
         91hguX4oMzk4OTUF7dzeF2YGjqxl7RBBzeGfmzf3IDXJGDPsdmf25lxTac0MeFUYdfFt
         RWX3yv1AUH7FE9whQO9c6g6R4pc/9HpTa8N0qAFLm4FV6WUkzBpdwIkN8OZNbC+qOncs
         7c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725928175; x=1726532975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHM2I1sQ9+0AOyF9datK6mfjd6+l7ZePwvm96Pc4Mt8=;
        b=XR/m7v4B8Db8D3snYoESj9aHjJF7qqnkuwIXOXXCMBZ9mM0e9Km3CXdFIUKDbP3DbI
         x467RM3kuB6GCfPvlQLXyAZPS7r85vlq0Q5eS5dh4Xe3IO9UroHx/7UrMIEzjL4edxPQ
         yjWvBHianmv8pH2jg7qz+mTg5PZpGi/4SraUrT8jlLEmUrR7aZXP02QGWN/AnOzqGwAg
         uglchf67h/iO6SpZNjcqTjIFKxMSxJEhMOhAF2qMaeABM+m5UD4LR2bCs2+E/xxD/NE4
         /RX3ToTebjjZ3IEAk4Sy16zue8EIpUchU0exR5iorItOwmSJLmO/m2t5avEDzadBPf0s
         n/mg==
X-Forwarded-Encrypted: i=1; AJvYcCVJz/w4a9wwoVF1nUpwLMZCo/TX3h+apzc76uFeLz9iCC6qEuQmRTxi2hjj6NIJ0XFrWOc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUh4jqRvtqm1hhUwCzU04I/5Y9fLB+WIFV2n3Ihnwnjkrn5KWX
	Ecadk3ng7T0djnRLfjJx8cmISpHNcrP2EO6A4KskivnaxR/zxayGzMhSg0CWB7uFyjLWUw+crVV
	8Zk3zh5Ymv5QuNwuQueAofLFZp5nuQ/fqJO+s
X-Google-Smtp-Source: AGHT+IHRi8kepffMG3E1kWbCyPzV5UjUrCfVTSaQwbWTluDdzIPywbZETPWbA3vOLXNhxogYciZkEb8yleqLxMDAJ6A=
X-Received: by 2002:a05:690c:399:b0:6af:a6aa:2b3a with SMTP id
 00721157ae682-6db44d62bb3mr143076897b3.1.1725928175049; Mon, 09 Sep 2024
 17:29:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
 <Zt9UT74XkezVpTuK@google.com> <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
 <Zt9wg6h_bPp8BKtd@google.com>
In-Reply-To: <Zt9wg6h_bPp8BKtd@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 9 Sep 2024 17:28:58 -0700
Message-ID: <CADrL8HWbNjv-w-ZJOxkLK78S5RePd2QXDuXV-=4iFVV29uHKyg@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 3:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Sep 09, 2024, James Houghton wrote:
> > On Mon, Sep 9, 2024 at 1:02=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Mon, Sep 09, 2024, James Houghton wrote:
> > > > On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > + */
> > > > > +#define KVM_RMAP_LOCKED        BIT(1)
> > > > > +
> > > > > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_he=
ad)
> > > > > +{
> > > > > +       unsigned long old_val, new_val;
> > > > > +
> > > > > +       old_val =3D READ_ONCE(rmap_head->val);
> > > > > +       if (!old_val)
> > > > > +               return 0;
> > > > > +
> > > > > +       do {
> > > > > +               /*
> > > > > +                * If the rmap is locked, wait for it to be unloc=
ked before
> > > > > +                * trying acquire the lock, e.g. to bounce the ca=
che line.
> > > > > +                */
> > > > > +               while (old_val & KVM_RMAP_LOCKED) {
> > > > > +                       old_val =3D READ_ONCE(rmap_head->val);
> > > > > +                       cpu_relax();
> > > > > +               }
> > > > > +
> > > > > +               /*
> > > > > +                * Recheck for an empty rmap, it may have been pu=
rged by the
> > > > > +                * task that held the lock.
> > > > > +                */
> > > > > +               if (!old_val)
> > > > > +                       return 0;
> > > > > +
> > > > > +               new_val =3D old_val | KVM_RMAP_LOCKED;
> > > > > +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val)=
);
> > > >
> > > > I think we (technically) need an smp_rmb() here. I think cmpxchg
> > > > implicitly has that on x86 (and this code is x86-only), but should =
we
> > > > nonetheless document that we need smp_rmb() (if it indeed required)=
?
> > > > Perhaps we could/should condition the smp_rmb() on `if (old_val)`.
> > >
> > > Hmm, no, not smp_rmb().  If anything, the appropriate barrier here wo=
uld be
> > > smp_mb__after_spinlock(), but I'm pretty sure even that is misleading=
, and arguably
> > > even wrong.
> >
> > I don't think smp_mb__after_spinlock() is right either. This seems to
> > be used following the acquisition of a spinlock to promote the memory
> > ordering from an acquire barrier (that is implicit with the lock
> > acquisition, e.g. [1]) to a full barrier. IIUC, we have no need for a
> > stronger-than-usual barrier. But I guess I'm not really sure.
> >
> > In this case, I'm complaining that we don't have the usual memory
> > ordering restrictions that come with a spinlock.
>
> What makes you think that?

Ok I was under the impression that try_cmpxchg() did not carry memory
ordering guarantees (i.e., I thought it was try_cmpxchg_relaxed()).
Sorry....

So the way I would write this is with try_cmpxchg_relaxed() in the
loop and then smp_rmb() after we break out of the loop, at least for
the `old_val !=3D 0` case. Kinda like this [4].

Did you really want try_cmpxchg(), not try_cmpxchg_relaxed()?

Just comparing against bit_spin_lock, test_and_set_bit_lock()
documents the requirement for acquire barrier semantics[5].

[4]: https://elixir.bootlin.com/linux/v6.10.9/source/kernel/locking/rtmutex=
.c#L253
[5]: https://elixir.bootlin.com/linux/v6.10.9/source/include/asm-generic/bi=
tops/instrumented-lock.h#L51

>
> > > For the !old_val case, there is a address/data dependency that can't =
be broken by
> > > the CPU without violating the x86 memory model (all future actions wi=
th relevant
> > > memory loads depend on rmap_head->val being non-zero).  And AIUI, in =
the Linux
> > > kernel memory model, READ_ONCE() is responsible for ensuring that the=
 address
> > > dependency can't be morphed into a control dependency by the compiler=
 and
> > > subsequently reordered by the CPU.
> > >
> > > I.e. even if this were arm64, ignoring the LOCK CMPXCHG path for the =
moment, I
> > > don't _think_ an smp_{r,w}mb() pair would be needed, as arm64's defin=
ition of
> > > __READ_ONCE() promotes the operation to an acquire.
> > >
> > > Back to the LOCK CMPXCHG path, KVM_RMAP_LOCKED implements a rudimenta=
ry spinlock,
> > > hence my smp_mb__after_spinlock() suggestion.  Though _because_ it's =
a spinlock,
> > > the rmaps are fully protected by the critical section.
> >
> > I feel like a spinlock must include the appropriate barriers for it to
> > correctly function as a spinlock, so I'm not sure I fully understand
> > what you mean here.
>
> On TSO architectures, the atomic _is_ the barrier.  E.g. atomic_try_cmpxc=
hg_acquire()
> eventually resolves to atomic_try_cmpxchg() on x86.

Yeah I'm with you here.

> And jumping back to the
> "we don't have the usual memory ordering restrictions that come with a sp=
inlock",
> x86's virt_spin_lock() uses atomic_try_cmpxchg().  So while using the acq=
uire
> variant here is obviously not wrong, it also feels somewhat weird.

Yeah that's fine. atomic_try_cmpxchg() is at least as strong as
atomic_try_cmpxchg_acquire(), so there is no issue.

But if virt_spin_lock() were written to use
atomic_try_cmpxchg_relaxed() (and nothing else) instead, then you'd
complain right? It would work on x86 (I think?), but it's not written
properly! That's basically what I'm saying in this thread.

> Though some
> of that is undoubtedly due to explicit "acquire" semantics being rather r=
are in
> x86.
>
> > > And for the SPTEs, there is no required ordering.  The reader (aging
> > > thread) can observe a !PRESENT or a PRESENT SPTE, and must be prepare=
d for
> > > either.  I.e. there is no requirement that the reader observe a PRESE=
NT
> > > SPTE if there is a valid rmap.
> >
> > This makes sense.
> >
> > > So, unless I'm missing something, I would prefer to not add a smp_mb_=
_after_spinlock(),
> > > even though it's a nop on x86 (unless KCSAN_WEAK_MEMORY=3Dy), because=
 it suggests
> > > an ordering requirement that doesn't exist.
> >
> > So we have: the general kvm_rmap_lock() and the read-only
> > kvm_rmap_lock_readonly(), as introduced by the next patch[2]. I'll use
> > those names (sorry if it's confusing).
> >
> > For kvm_rmap_lock(), we are always holding mmu_lock for writing. So
> > any changes we make to the rmap will be properly published to other
> > threads that subsequently grab kvm_rmap_lock() because we had to
> > properly release and then re-acquire mmu_lock, which comes with the
> > barriers I'm saying we need.
> >
> > For kvm_rmap_lock_readonly(), we don't hold mmu_lock, so there is no
> > smp_rmb() or equivalent. Without an smp_rmb() somewhere, I claim that
> > it is possible that there may observe external changes to the
> > pte_list_desc while we are in this critical section (for a
> > sufficiently weak architecture). The changes that the kvm_rmap_lock()
> > (mmu_lock) side made were half-published with an smp_wmb() (really
> > [3]), but the read side didn't use a load-acquire or smp_rmb(), so it
> > hasn't held up its end of the deal.
> >
> > I don't think READ_ONCE() has the guarantees we need to be a
> > sufficient replacement for smp_rmb() or a load-acquire that a real
> > lock would use, although I agree with you that, on arm64, it
> > apparently *is* a sufficient replacement.
> >
> > Now this isn't a problem if the kvm_rmap_lock_readonly() side can
> > tolerate changes to pte_list_desc while in the critical section. I
> > don't think this is true (given for_each_rmap_spte_lockless),
> > therefore an smp_rmb() or equivalent is (technically) needed.
> >
> > Am I confused?
>
> Yes, I think so.  kvm_rmap_lock_readonly() creates a critical section tha=
t prevents
> any pte_list_desc changes.  rmap_head->val, and every pte_list_desc that =
is pointed
> at by rmap_head->val in the KVM_RMAP_MULTI case, is protected and cannot =
change.

I take back what I said about this working on x86. I think it's
possible for there to be a race.

Say...

1. T1 modifies pte_list_desc then unlocks kvm_rmap_unlock().
2. T2 then locks kvm_rmap_lock_readonly().

The modifications that T1 has made are not guaranteed to be visible to
T2 unless T1 has an smp_wmb() (or equivalent) after the modfication
and T2 has an smp_rmb() before reading the data.

Now the way you had it, T2, because it uses try_cmpxchg() with full
ordering, will effectively do a smp_rmb(). But T1 only does an
smp_wmb() *after dropping the mmu_lock*, so there is a race. While T1
still holds the mmu_lock but after releasing the kvm_rmap_lock(), T2
may enter its critical section and then *later* observe the changes
that T1 made.

Now this is impossible on x86 (IIUC) if, in the compiled list of
instructions, T1's writes occur in the same order that we have written
them in C. I'm not sure if WRITE_ONCE guarantees that this reordering
at compile time is forbidden.

So what I'm saying is:

1. kvm_rmap_unlock() must have an smp_wmb().
2. If you change kvm_rmap_lock() to use try_cmpxchg_relaxed() (which
is what I think you want), then you must also have an smp_rmb()
following a successful cmpxchg/acquisition (at least for the case
where we then follow the pte_list_desc pointer).

> The SPTE _value_ that is pointed at by rmap_head->val or pte_list_desc.sp=
tes[]
> can change, but the pointers themselves cannot.  And with aging, the code=
 is
> completely tolerant of an instable SPTE _value_ because test-only doesn't=
 care
> about false negatives/positives, and test-and-clear is itself an atomic a=
ccess
> i.e. won't corrupt a SPTE (and is also tolerant of false positives/negati=
ves).

I think we're on the same page for the rest of this.

>
> >
> > (Though all of this works just fine as written on x86.)
> >
> > [1]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/r=
wbase_rt.c#L62
> > [2]: https://lore.kernel.org/kvm/20240809194335.1726916-21-seanjc@googl=
e.com/
> > [3]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/r=
wbase_rt.c#L190

