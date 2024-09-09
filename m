Return-Path: <kvm+bounces-26161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC719724E6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE9BEB22EA7
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE3A18C935;
	Mon,  9 Sep 2024 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5uEwTjG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446D18A95C
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 22:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725919367; cv=none; b=NhOTcoqLmEcnbBzoTrOfaoD4lRKkCVwD0Fhq3TLXr/VQgoPKpXjr/3WOYvNOPcmQ2uXtFQ5Z1hyixFg1IIS+G6D3tp57DjKcL4EZwqr6OWuQ+sl2uy53XaD8GDH3mXip3FHjIscwdir7G2q/D43o+mbHNC7f4CwaS432aW+GpLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725919367; c=relaxed/simple;
	bh=DUFY+DZfO7+AqwuFLy5LudZkwjfnVz4AclZWLG53KJU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hk1WQ4Z32slVaM20BZHpPk3vTq1Awpb2PhZkI+lh21ENqFpI41HYvQwJ6YKYOFYEYyukOup04TML08eXYg5paZgVp3qA2cv7VhhZ4GRI7328t5N1qwJFiqgDCh/EUb+vX7Cse9FqM+QdWoI8oYowamNPwXoR4ALxf42bRiabxyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5uEwTjG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d1fe1dd173so4988530a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 15:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725919365; x=1726524165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDN/fD1fWlVYUsfWFNeY11plKSbG6eNq65vUSIIaXZo=;
        b=I5uEwTjG4JUhXMY02AlABDcsXKPqn0Eu+mKJNBT/QqHgJY6aOX20q5K/if7igaRUtV
         RZpTif3kEL6LCjYB3OQduF4DKewuejab+5AwRKhb7tByrE7dToce1mK9jZq5LSt4IUaZ
         3aVCEo3SRpz7xG/66ymnNFT0NZOHVurQgt27NatEVK1xWfWqeY1kgLeuQndZxdutEBUR
         0NW7HeEFHlDRlBapjd/tqqY2NY/fQl26dl4QeoF0S7ptUWglLl9TKtV6uZ23gxSay6rr
         xX9sifGgTyeCUlamYzaWY8FXl8xhMNaHghuduKj3PvptB3B5yHK56chGJT5rf56OPV6r
         NFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725919365; x=1726524165;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eDN/fD1fWlVYUsfWFNeY11plKSbG6eNq65vUSIIaXZo=;
        b=jB4ACdk4/rIiY/J4OcVrJW1m73lE2wlZPxuH7qeUqYnhlCDZ2V610XNkqrcHj01GkJ
         6nAKGL4Cg/Yzyyy+egX0mEA9lJKWiCqJ2UHkXF3UfCpntXYoZpHN20dken/pIdfEXaeo
         geJksS35JeHuFbbjKdyrXXs/eYlpvQvNISXTv78+lrQxaw7fLUp8t+OWLG3NaBjQdzo5
         MS53OcbUf3zm137RUmUu7aK++MuxuFhxzDb4bmj+rKL4CAGxxb+ypKGwV0oWsheTO0nx
         tUxrD6l0OVxp8QKKzgvDYobO9iN0i8811wLqFyZAofZFkADHSzdtW2rh8dcG+zdQkenu
         eVPA==
X-Forwarded-Encrypted: i=1; AJvYcCVkZWQWpMQUK02/WWrvt6F8FMkSCQBMGQfQIDgFVHywH8blbc8UAuVWuWScwN7N247d80s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrLB6mw3rnmYoUp4voWnEsSkSxYEKsRreV5BU2laZPaCd8gnvV
	RiYX9TdcrYnD2RKVe3n06wOX2CcJ2por2RlZH5j5VB7t2CyJZygt119HdhCCZ2Y2itN0FiG4pN0
	o4g==
X-Google-Smtp-Source: AGHT+IGGtNJ9J2pBPzXxJKnIWU60VR/rN6PzOzfLZuYkuT2leAPAotkJrTHJr1E+W8UKZjnsjesbS347OZw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9517:0:b0:718:da6:277e with SMTP id
 41be03b00d2f7-7d79f5b5f0fmr37096a12.2.1725919365275; Mon, 09 Sep 2024
 15:02:45 -0700 (PDT)
Date: Mon, 9 Sep 2024 15:02:43 -0700
In-Reply-To: <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
 <Zt9UT74XkezVpTuK@google.com> <CADrL8HW-mOAyF0Gcw7UbkvEvEfcHDxEir0AiStkqYzD5x8ZGpg@mail.gmail.com>
Message-ID: <Zt9wg6h_bPp8BKtd@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, James Houghton wrote:
> On Mon, Sep 9, 2024 at 1:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Mon, Sep 09, 2024, James Houghton wrote:
> > > On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > + */
> > > > +#define KVM_RMAP_LOCKED        BIT(1)
> > > > +
> > > > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head=
)
> > > > +{
> > > > +       unsigned long old_val, new_val;
> > > > +
> > > > +       old_val =3D READ_ONCE(rmap_head->val);
> > > > +       if (!old_val)
> > > > +               return 0;
> > > > +
> > > > +       do {
> > > > +               /*
> > > > +                * If the rmap is locked, wait for it to be unlocke=
d before
> > > > +                * trying acquire the lock, e.g. to bounce the cach=
e line.
> > > > +                */
> > > > +               while (old_val & KVM_RMAP_LOCKED) {
> > > > +                       old_val =3D READ_ONCE(rmap_head->val);
> > > > +                       cpu_relax();
> > > > +               }
> > > > +
> > > > +               /*
> > > > +                * Recheck for an empty rmap, it may have been purg=
ed by the
> > > > +                * task that held the lock.
> > > > +                */
> > > > +               if (!old_val)
> > > > +                       return 0;
> > > > +
> > > > +               new_val =3D old_val | KVM_RMAP_LOCKED;
> > > > +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
> > >
> > > I think we (technically) need an smp_rmb() here. I think cmpxchg
> > > implicitly has that on x86 (and this code is x86-only), but should we
> > > nonetheless document that we need smp_rmb() (if it indeed required)?
> > > Perhaps we could/should condition the smp_rmb() on `if (old_val)`.
> >
> > Hmm, no, not smp_rmb().  If anything, the appropriate barrier here woul=
d be
> > smp_mb__after_spinlock(), but I'm pretty sure even that is misleading, =
and arguably
> > even wrong.
>=20
> I don't think smp_mb__after_spinlock() is right either. This seems to
> be used following the acquisition of a spinlock to promote the memory
> ordering from an acquire barrier (that is implicit with the lock
> acquisition, e.g. [1]) to a full barrier. IIUC, we have no need for a
> stronger-than-usual barrier. But I guess I'm not really sure.
>=20
> In this case, I'm complaining that we don't have the usual memory
> ordering restrictions that come with a spinlock.

What makes you think that?

> > For the !old_val case, there is a address/data dependency that can't be=
 broken by
> > the CPU without violating the x86 memory model (all future actions with=
 relevant
> > memory loads depend on rmap_head->val being non-zero).  And AIUI, in th=
e Linux
> > kernel memory model, READ_ONCE() is responsible for ensuring that the a=
ddress
> > dependency can't be morphed into a control dependency by the compiler a=
nd
> > subsequently reordered by the CPU.
> >
> > I.e. even if this were arm64, ignoring the LOCK CMPXCHG path for the mo=
ment, I
> > don't _think_ an smp_{r,w}mb() pair would be needed, as arm64's definit=
ion of
> > __READ_ONCE() promotes the operation to an acquire.
> >
> > Back to the LOCK CMPXCHG path, KVM_RMAP_LOCKED implements a rudimentary=
 spinlock,
> > hence my smp_mb__after_spinlock() suggestion.  Though _because_ it's a =
spinlock,
> > the rmaps are fully protected by the critical section.
>=20
> I feel like a spinlock must include the appropriate barriers for it to
> correctly function as a spinlock, so I'm not sure I fully understand
> what you mean here.

On TSO architectures, the atomic _is_ the barrier.  E.g. atomic_try_cmpxchg=
_acquire()
eventually resolves to atomic_try_cmpxchg() on x86.  And jumping back to th=
e
"we don't have the usual memory ordering restrictions that come with a spin=
lock",
x86's virt_spin_lock() uses atomic_try_cmpxchg().  So while using the acqui=
re
variant here is obviously not wrong, it also feels somewhat weird.  Though =
some
of that is undoubtedly due to explicit "acquire" semantics being rather rar=
e in
x86.

> > And for the SPTEs, there is no required ordering.  The reader (aging
> > thread) can observe a !PRESENT or a PRESENT SPTE, and must be prepared =
for
> > either.  I.e. there is no requirement that the reader observe a PRESENT
> > SPTE if there is a valid rmap.
>=20
> This makes sense.
>=20
> > So, unless I'm missing something, I would prefer to not add a smp_mb__a=
fter_spinlock(),
> > even though it's a nop on x86 (unless KCSAN_WEAK_MEMORY=3Dy), because i=
t suggests
> > an ordering requirement that doesn't exist.
>=20
> So we have: the general kvm_rmap_lock() and the read-only
> kvm_rmap_lock_readonly(), as introduced by the next patch[2]. I'll use
> those names (sorry if it's confusing).
>=20
> For kvm_rmap_lock(), we are always holding mmu_lock for writing. So
> any changes we make to the rmap will be properly published to other
> threads that subsequently grab kvm_rmap_lock() because we had to
> properly release and then re-acquire mmu_lock, which comes with the
> barriers I'm saying we need.
>=20
> For kvm_rmap_lock_readonly(), we don't hold mmu_lock, so there is no
> smp_rmb() or equivalent. Without an smp_rmb() somewhere, I claim that
> it is possible that there may observe external changes to the
> pte_list_desc while we are in this critical section (for a
> sufficiently weak architecture). The changes that the kvm_rmap_lock()
> (mmu_lock) side made were half-published with an smp_wmb() (really
> [3]), but the read side didn't use a load-acquire or smp_rmb(), so it
> hasn't held up its end of the deal.
>=20
> I don't think READ_ONCE() has the guarantees we need to be a
> sufficient replacement for smp_rmb() or a load-acquire that a real
> lock would use, although I agree with you that, on arm64, it
> apparently *is* a sufficient replacement.
>=20
> Now this isn't a problem if the kvm_rmap_lock_readonly() side can
> tolerate changes to pte_list_desc while in the critical section. I
> don't think this is true (given for_each_rmap_spte_lockless),
> therefore an smp_rmb() or equivalent is (technically) needed.
>=20
> Am I confused?

Yes, I think so.  kvm_rmap_lock_readonly() creates a critical section that =
prevents
any pte_list_desc changes.  rmap_head->val, and every pte_list_desc that is=
 pointed
at by rmap_head->val in the KVM_RMAP_MULTI case, is protected and cannot ch=
ange.

The SPTE _value_ that is pointed at by rmap_head->val or pte_list_desc.spte=
s[]
can change, but the pointers themselves cannot.  And with aging, the code i=
s
completely tolerant of an instable SPTE _value_ because test-only doesn't c=
are
about false negatives/positives, and test-and-clear is itself an atomic acc=
ess
i.e. won't corrupt a SPTE (and is also tolerant of false positives/negative=
s).

>=20
> (Though all of this works just fine as written on x86.)
>=20
> [1]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/rwb=
ase_rt.c#L62
> [2]: https://lore.kernel.org/kvm/20240809194335.1726916-21-seanjc@google.=
com/
> [3]: https://elixir.bootlin.com/linux/v6.11-rc7/source/kernel/locking/rwb=
ase_rt.c#L190

