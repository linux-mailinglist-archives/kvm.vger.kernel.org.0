Return-Path: <kvm+bounces-26151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B806972317
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01A2F28545B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 20:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5FF189F39;
	Mon,  9 Sep 2024 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eNG4/Jbq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869773440
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725912147; cv=none; b=mNF1RKmR0E5nYZACmH7MV9TQhibfnzLbtdRwyEVF8Em4VJ+F0V6pfEh1cHuyuCam87ujlF4DHVaXVQcKB+9+sGREhutyak5UJUNrJMH8DxXJkpbOkRvhsudiqb5xKKAysDiGy+NyCxsD1hXol7ABXEHGa9aa7y2MOKJtgSWmWRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725912147; c=relaxed/simple;
	bh=1ODmmtnmvSE5XRGtj8DOvZPJXzuhlWwoNiUgJyWhAbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TMlq0pfRIEXEOurqPMrdsu0UKu3g1IZx6/aN/XCih0a2ytyRJFoWNj7WGxAqOg2CYfyyUQPFAAbvQnT3Ce0qXkCTpqQkbqVjGYEW1SCyHZz8xCJKRFUTWUq8qmN4KCPIJHma/AWCcArgMDrW7QPwIabbNQlaUOgsJ1z7Mycq8Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eNG4/Jbq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7178f096d62so5277629b3a.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 13:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725912145; x=1726516945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rr+lD+q3Ps7g7hEL9ueNYiUSI8mUGp2LqUsSmeSLAjw=;
        b=eNG4/JbqhSgDgN0Laaho070Fb8E5X4hHpJeqIiQ24DCt9maA1HdAKjky1VcZ2upk9V
         8gykxCeW/CFouF+CE0s73XfswwiBafWQ38YeI3L+IN+RMk73wDWCVg1k2DZ9p/WvYEsB
         /kIQD0VraZo9Z063ugZv/YwsquLKUFHMNIFsCsVwpb74icOfzfuqrJOHUE/S0YXvYxqu
         pbn5Jhu2dHvARgVpsDjDAunWtdw7To6C7jfG4AEOUVseoLfEUZEEA/3or1+qtqnl/cCH
         tuKBt2XNWl0ZypIvZgEXtwIKq9Z/Glk7emRQycrWgFSbh/TTvL2Tl9RpjuIKLHbyFlos
         uyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725912145; x=1726516945;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rr+lD+q3Ps7g7hEL9ueNYiUSI8mUGp2LqUsSmeSLAjw=;
        b=coCGDu/uVxJQQUHcJLeJ22ugK4RM2yjR5L4qKcZVWvp4ySfrfAda8PUTGDfhytUmzB
         tRgE2mN+CTQ1fx05Eyf7PCKm6t1yWmLjp3NETTGBI4f1CZWKvDQu17eHf5UjA5IDmj+l
         /sc4spsAfYPSZwuUsFUp38uLiu4X1SLmAn+mxvLVVDRVxSkNXa/AIrNzPOlR0BwC8LN8
         017oVw+qeFgry3scpb1ZzqGgXknTDX+lpan2QILNLh+fpTfrX3hBJcLQ/jXMTBqHzchR
         8G12+KwQngi4MHgO+WgtZKlQCq9JTW3NUcxW2CdxgeENvdkejcN0S3p1GDlbRsPps2PG
         6hIw==
X-Forwarded-Encrypted: i=1; AJvYcCWQIJeSCEUdGzNnKW/YY85Ij37dbPi9Lc1qZJ1cM4vKOtI4XTKvMX2qctO1oTRTpRkIr9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWe2pR8PTORn+/pgfvUh8A4ZT4q+qyz0a3KcEqai6iGiQQqF7n
	pzh/y1RYICpsyx/Pl1olTH/CkQteKWu9Ysjdvbgpff20nonmo9Nr4l8EW0c9BR0KW/lfPtwcsV0
	t+g==
X-Google-Smtp-Source: AGHT+IG1s1GuYsk1z43Z4CzStskFM+tIz4IfpgT/98Yn34azkMBxGxNrVMhcaLocwmoIBYFDNo8i5Y6ja+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2f8d:b0:717:9643:2043 with SMTP id
 d2e1a72fcca58-718d5f2eb5fmr29044b3a.4.1725912144952; Mon, 09 Sep 2024
 13:02:24 -0700 (PDT)
Date: Mon, 9 Sep 2024 13:02:23 -0700
In-Reply-To: <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HWACwbzraG=MbDoORJ8ramDxb-h9yb0p4nx9-wq4o3c6A@mail.gmail.com>
Message-ID: <Zt9UT74XkezVpTuK@google.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, James Houghton wrote:
> On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > +/*
> > + * rmaps and PTE lists are mostly protected by mmu_lock (the shadow MM=
U always
> > + * operates with mmu_lock held for write), but rmaps can be walked wit=
hout
> > + * holding mmu_lock so long as the caller can tolerate SPTEs in the rm=
ap chain
> > + * being zapped/dropped _while the rmap is locked_.
> > + *
> > + * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entries =
must be
> > + * done while holding mmu_lock for write.  This allows a task walking =
rmaps
> > + * without holding mmu_lock to concurrently walk the same entries as a=
 task
> > + * that is holding mmu_lock but _not_ the rmap lock.  Neither task wil=
l modify
> > + * the rmaps, thus the walks are stable.
> > + *
> > + * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RMAP=
_LOCKED,
> > + * only the rmap chains themselves are protected.  E.g. holding an rma=
p's lock
> > + * ensures all "struct pte_list_desc" fields are stable.
>=20
> This last sentence makes me think we need to be careful about memory orde=
ring.
>=20
> > + */
> > +#define KVM_RMAP_LOCKED        BIT(1)
> > +
> > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> > +{
> > +       unsigned long old_val, new_val;
> > +
> > +       old_val =3D READ_ONCE(rmap_head->val);
> > +       if (!old_val)
> > +               return 0;
> > +
> > +       do {
> > +               /*
> > +                * If the rmap is locked, wait for it to be unlocked be=
fore
> > +                * trying acquire the lock, e.g. to bounce the cache li=
ne.
> > +                */
> > +               while (old_val & KVM_RMAP_LOCKED) {
> > +                       old_val =3D READ_ONCE(rmap_head->val);
> > +                       cpu_relax();
> > +               }
> > +
> > +               /*
> > +                * Recheck for an empty rmap, it may have been purged b=
y the
> > +                * task that held the lock.
> > +                */
> > +               if (!old_val)
> > +                       return 0;
> > +
> > +               new_val =3D old_val | KVM_RMAP_LOCKED;
> > +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
>=20
> I think we (technically) need an smp_rmb() here. I think cmpxchg
> implicitly has that on x86 (and this code is x86-only), but should we
> nonetheless document that we need smp_rmb() (if it indeed required)?
> Perhaps we could/should condition the smp_rmb() on `if (old_val)`.

Hmm, no, not smp_rmb().  If anything, the appropriate barrier here would be
smp_mb__after_spinlock(), but I'm pretty sure even that is misleading, and =
arguably
even wrong.

For the !old_val case, there is a address/data dependency that can't be bro=
ken by
the CPU without violating the x86 memory model (all future actions with rel=
evant
memory loads depend on rmap_head->val being non-zero).  And AIUI, in the Li=
nux
kernel memory model, READ_ONCE() is responsible for ensuring that the addre=
ss
dependency can't be morphed into a control dependency by the compiler and
subsequently reordered by the CPU.

I.e. even if this were arm64, ignoring the LOCK CMPXCHG path for the moment=
, I
don't _think_ an smp_{r,w}mb() pair would be needed, as arm64's definition =
of
__READ_ONCE() promotes the operation to an acquire.

Back to the LOCK CMPXCHG path, KVM_RMAP_LOCKED implements a rudimentary spi=
nlock,
hence my smp_mb__after_spinlock() suggestion.  Though _because_ it's a spin=
lock,
the rmaps are fully protected by the critical section.  And for the SPTEs, =
there
is no required ordering.  The reader (aging thread) can observe a !PRESENT =
or a
PRESENT SPTE, and must be prepared for either.  I.e. there is no requiremen=
t that
the reader observe a PRESENT SPTE if there is a valid rmap.

So, unless I'm missing something, I would prefer to not add a smp_mb__after=
_spinlock(),
even though it's a nop on x86 (unless KCSAN_WEAK_MEMORY=3Dy), because it su=
ggests
an ordering requirement that doesn't exist.

> kvm_rmap_lock_readonly() should have an smb_rmb(), but it seems like
> adding it here will do the right thing for the read-only lock side.
>=20
> > +
> > +       /* Return the old value, i.e. _without_ the LOCKED bit set. */
> > +       return old_val;
> > +}
> > +
> > +static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
> > +                           unsigned long new_val)
> > +{
> > +       WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
>=20
> Same goes with having an smp_wmb() here. Is it necessary? If so,
> should it at least be documented?
>=20
> And this is *not* necessary for kvm_rmap_unlock_readonly(), IIUC.
>=20
> > +       WRITE_ONCE(rmap_head->val, new_val);
> > +}

