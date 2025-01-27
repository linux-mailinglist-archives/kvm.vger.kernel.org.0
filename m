Return-Path: <kvm+bounces-36682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64EFCA1DCF5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B616188633F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3025C194A6B;
	Mon, 27 Jan 2025 19:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fQlBRFSI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E3576C61
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007587; cv=none; b=oU/bBV37i/FN4L9phNh9rQZn94BB1qGiJG2lK/mpka+wnlBzVnM52QysxSNwKbrsKLmwsgRXepD2If1k9PHIA6RXedZzF2Aqa1iB8kKEVqH+sxOdhR7rpoQzf6+LX36xvKWNOuqLxM7j2vomio7R4EJTpufPaLeOrk8Uvh7nd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007587; c=relaxed/simple;
	bh=zvuHQdWbJEPCSA97hcnEvI7/hdUov7P/z4EKVTeRzuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gACuJ13pqvwst/HUM0tkuu7c+nlEGWex+Z5QmPF/oT3qtmfLrmP0ILWf9DSgk0stpWdnc8YOcUCJ3m95fT9nu24923xeiZPU1d6sOnahQrCC6vZ6PN6EYC663EL6mCIlyxPINCk8OLn7FJuorNFc4IJZ0faeJsuvT7MR5lvMQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fQlBRFSI; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e53a5ff2233so8706608276.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007585; x=1738612385; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haFwc8XvTPqfXgpJh0zP6HFjBdxdo3W5YFipWCYbP40=;
        b=fQlBRFSImzNID+yEXYyAnsTwureEwmMBm4Hbx42YwD7R6h4HG92Kx0iM4J3pffKIH5
         0f+nCjcl25bLwwoAQKUEdHvZny4LmYewFqdmYdjaLT8oeM76kBwsLry4F3eOKyi+RtAP
         z4UJlFy2fNi11a58fvxx+F8tmRzriGokVfMA1fCiGvLNWY8d0VQVYQtZAVrDCvgLzmoF
         Wq0M9wy2ATcWC/ZX/AqP1UkwgQ5xAhFQ/UAD+KkHFG/8RyzIr3rL4Mz3gEicTMjX9QOQ
         Tgk6dSQSmkXXnwA0/bDvGTwHWI1p/xwFCV603P6tTEIpV5zJRbRB8gdtgOsxBha9c6Wj
         L0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007585; x=1738612385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haFwc8XvTPqfXgpJh0zP6HFjBdxdo3W5YFipWCYbP40=;
        b=t/ZivI0HZjWQ59IpcRllvg1yZe9Rl3TjHFwJgj4S2ExBi5Z7yYz9cwpDyQ0dR6BvM2
         Bgh/3lg8K2Z9M+Jhe6s21jQqa1E4DAxzNrftb11v0ZHFtrB31xtb/shWH/TEugOuR8Pl
         vAulazMgpzA8YCY5N3BO6CjpLsziA7rnuFMf7529F57jmc/fDdaIC9X6EBafnM7hCCFz
         zSM/gt7sqioqOd3INq/vHMb7cZA6jAyWYShZJ/hN7POugPwaf5jWMns6Q89CSwcKQZs5
         Vr/jtWK1dohYuGaHgIVSWGXeElHGizOzVAv+BzNIhVMbslReF/WBChivCkMLniCNcjMi
         IKYw==
X-Forwarded-Encrypted: i=1; AJvYcCWGy1Dx1+t7NNaC8ct6AEBV+nK2dCSu2C9vi6fqVda/T3A9aAu334y0sM3g21ftR9t0zqM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw27Crx9vmPzlZnbrOH6JtgyuiREqxFgLaIR1dyGoLdmKn41Lo5
	pzVEtZVgaQqX+xk4/GThJVVUDErFLVX1Z/kBeQFVzzjvYPv71CYMvvrMS6lVOqTeVOBwBnnhhHs
	Snrz0VEqmqszQC2P8tThQ3A3PxPALjxghYUWg
X-Gm-Gg: ASbGncvBnFgtQRWH+S1KN1aD3RJJcuhm26iDqEK2Fo+1Oz6HcgX8MPeDbNrxDHot515
	M/OsUHR49ud6JsSxFzG7OzUgtRLXawawrdrvvVSO9I1L1Qm4gWckHSOgnfljE12tsTQD+ehpMrd
	UuI0zIkiUOs1gkCyYO
X-Google-Smtp-Source: AGHT+IGmdoCfwDVf5taXT304T55jMSvN/HfrQT5nEt2MOkA7Doh+zsVSeL+uQwanJ+YcyAPmKQuFSNPFVjyRF7LqOI0=
X-Received: by 2002:a05:690c:3747:b0:6f6:8b81:4cb4 with SMTP id
 00721157ae682-6f6eb9367b1mr326480397b3.31.1738007584399; Mon, 27 Jan 2025
 11:53:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-5-jthoughton@google.com> <Z4GjbCRgyBe7k9gw@google.com>
In-Reply-To: <Z4GjbCRgyBe7k9gw@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:52:28 -0800
X-Gm-Features: AWEUYZl9nStJwFmyMCWWiICcfcgbe8wNnl19VY7x9LR_yjX74-bpyEYCp6gqdcw
Message-ID: <CADrL8HW=eDMWadouN2x5DzDzg6yEX0sbFjacZRnRDUGzRDPJ2Q@mail.gmail.com>
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index a24fca3f9e7f..f26d0b60d2dd 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -39,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_pte=
p_t sptep, u64 new_spte)
> >  }
> >
> >  /*
> > - * SPTEs must be modified atomically if they are shadow-present, leaf
> > - * SPTEs, and have volatile bits, i.e. has bits that can be set outsid=
e
> > - * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
> > - * handler, and Accessed and Dirty bits can be set by the CPU.
> > + * SPTEs must be modified atomically if they have bits that can be set=
 outside
> > + * of the mmu_lock. This can happen for any shadow-present leaf SPTEs,=
 as the
> > + * Writable bit can be set by KVM's fast page fault handler, the Acces=
sed and
> > + * Dirty bits can be set by the CPU, and the Accessed and W/R/X bits c=
an be
> > + * cleared by age_gfn_range().
> >   *
> >   * Note, non-leaf SPTEs do have Accessed bits and those bits are
> >   * technically volatile, but KVM doesn't consume the Accessed bit of
> > @@ -53,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_=
t sptep, u64 new_spte)
> >  static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, in=
t level)
> >  {
> >       return is_shadow_present_pte(old_spte) &&
> > -            is_last_spte(old_spte, level) &&
> > -            spte_has_volatile_bits(old_spte);
> > +            is_last_spte(old_spte, level);
>
> I don't like this change on multiple fronts.  First and foremost, it resu=
lts in
> spte_has_volatile_bits() being wrong for the TDP MMU.  Second, the same l=
ogic
> applies to the shadow MMU; the rmap lock prevents a use-after-free of the=
 page
> that owns the SPTE, but the zapping of the SPTE happens before the writer=
 grabs
> the rmap lock.

Thanks Sean, yes I forgot about the shadow MMU case.

> Lastly, I'm very, very tempted to say we should omit Accessed state from
> spte_has_volatile_bits() and rename it to something like spte_needs_atomi=
c_write().
> KVM x86 no longer flushes TLBs on aging, so we're already committed to in=
correctly
> thinking a page is old in rare cases, for the sake of performance.  The o=
dds of
> KVM clobbering the Accessed bit are probably smaller than the odds of mis=
sing an
> Accessed update due to a stale TLB entry.
>
> Note, only the shadow_accessed_mask check can be removed.  KVM needs to e=
nsure
> access-tracked SPTEs are zapped properly, and dirty logging can't have fa=
lse
> negatives.

I've dropped the change to kvm_tdp_mmu_spte_need_atomic_write() and
instead applied this diff.

--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -142,8 +142,14 @@ bool spte_has_volatile_bits(u64 spte)
                return true;

        if (spte_ad_enabled(spte)) {
-               if (!(spte & shadow_accessed_mask) ||
-                   (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
+               /*
+                * Do not check the Accessed bit. It can be set (by the CPU=
)
+                * and cleared (by kvm_tdp_mmu_age_spte()) without holding
+                * the mmu_lock, but when clearing the Accessed bit, we do
+                * not invalidate the TLB, so we can already miss Accessed =
bit
+                * updates.
+                */
+               if (is_writable_pte(spte) && !(spte & shadow_dirty_mask))
                        return true;
        }

I've also included a new patch to rename spte_has_volatile_bits() to
spte_needs_atomic_write() like you suggested. I merely renamed it in
all locations, including documentation; I haven't reworded the
documentation's use of the word "volatile."

>
> >  }
> >
> >  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spt=
e,
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4508d868f1cd..f5b4f1060fff 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -178,6 +178,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(stru=
ct kvm *kvm,
> >                    ((_only_valid) && (_root)->role.invalid))) {        =
       \
> >               } else
> >
> > +/*
> > + * Iterate over all TDP MMU roots in an RCU read-side critical section=
.
>
> Heh, that's pretty darn obvious.  It would be far more helpful if the com=
ment
> explained the usage rules, e.g. what is safe (at a high level).

How's this?

+/*
+ * Iterate over all TDP MMU roots in an RCU read-side critical section.
+ * It is safe to iterate over the SPTEs under the root, but their values w=
ill
+ * be unstable, so all writes must be atomic. As this routine is meant to =
be
+ * used without holding the mmu_lock at all, any bits that are flipped mus=
t
+ * be reflected in kvm_tdp_mmu_spte_need_atomic_write().
+ */

> > + */
> > +#define for_each_valid_tdp_mmu_root_rcu(_kvm, _root, _as_id)          =
       \
> > +     list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)  =
       \
> > +             if ((_as_id >=3D 0 && kvm_mmu_page_as_id(_root) !=3D _as_=
id) ||     \
> > +                 (_root)->role.invalid) {                             =
       \
> > +             } else
> > +
> >  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)                   \
> >       __for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
> >
> > @@ -1168,16 +1177,16 @@ static void kvm_tdp_mmu_age_spte(struct tdp_ite=
r *iter)
> >       u64 new_spte;
> >
> >       if (spte_ad_enabled(iter->old_spte)) {
> > -             iter->old_spte =3D tdp_mmu_clear_spte_bits(iter->sptep,
> > -                                                      iter->old_spte,
> > -                                                      shadow_accessed_=
mask,
> > -                                                      iter->level);
> > +             iter->old_spte =3D tdp_mmu_clear_spte_bits_atomic(iter->s=
ptep,
> > +                                             shadow_accessed_mask);
>
> Align, and let this poke past 80:
>
>                 iter->old_spte =3D tdp_mmu_clear_spte_bits_atomic(iter->s=
ptep,
>                                                                 shadow_ac=
cessed_mask);

Done.

> >               new_spte =3D iter->old_spte & ~shadow_accessed_mask;
> >       } else {
> >               new_spte =3D mark_spte_for_access_track(iter->old_spte);
> > -             iter->old_spte =3D kvm_tdp_mmu_write_spte(iter->sptep,
> > -                                                     iter->old_spte, n=
ew_spte,
> > -                                                     iter->level);
> > +             /*
> > +              * It is safe for the following cmpxchg to fail. Leave th=
e
> > +              * Accessed bit set, as the spte is most likely young any=
way.
> > +              */
> > +             (void)__tdp_mmu_set_spte_atomic(iter, new_spte);
>
> Just a reminder that this needs to be:
>
>                 if (__tdp_mmu_set_spte_atomic(iter, new_spte))
>                         return;
>

Already applied, thanks!


> >       }
> >
> >       trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->leve=
l,
> > --
> > 2.47.0.199.ga7371fff76-goog
> >

