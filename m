Return-Path: <kvm+bounces-53573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D10DBB141BC
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 20:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF5A162F4F
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA2C272817;
	Mon, 28 Jul 2025 18:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="03bCLprC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4261C1F0C
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753726096; cv=none; b=pvLYfFvkeircs77L2MsWha5E2PaZluM+Xdbu4svBuuttgo9yZ4g0VbAj895WTMCQ3MCvEvkVIShcjl42k353VRkywdgcTPKnGjqB3H/l4fHogAXLoptvq6bgZqlbx2/Kut4W3CCKjFPUCBBxYJ0UUUsPpgDt6H7v/kT8qZ4rooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753726096; c=relaxed/simple;
	bh=EVc0iEknCF3Ka4SHyQNJqg8MLMtEG5JaIjGM3psiOjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cs1Bp9s/mgA1HE7u+0t5ui/B8A+rf+4VxJWGbGa2CjT5QQbdsgsKsoZo17ZdNhlX3XWCuhj1f32cpGOq2cikljmp2ws7jNvX7AA2rOxpJaLKGnZDqNvAnyrZHK/MYQyLEQ4xS7VzsFisN1TABHTgj0fMv7Bv4oGw8vGdB4gpcx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=03bCLprC; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e8bbb605530so162619276.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 11:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753726094; x=1754330894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gmrGvfylvw3ZgqzNbgUCIxZfOpxfy+MGSCTqwUJs5I=;
        b=03bCLprC2Ls4UHUjZucCW8ZWhm8QnJTnU9jR/2u2U7HYhFN70q5vhsQ2Lgmbm/MTNy
         NcItjzDtdg1JwVb/5CSXUgpsSAQQPOGpIhb1euuyIpxLa5VKPrN7FcbjZ+E5rUd5Xrrg
         m8oUi2qYCbFWecQBjkK9X/TVSb+k0hcCvfzjxAmQhAViu5Asq/WIHT/7+HBC/RRuwFaE
         dTvlhIh/69CI8ejhvrYHVu2DIamtNiylE5DpgT0cHoCnXD6JGsXE9YEe9iXN11ADFdos
         JumYHY5SyDvebXK4nkrDGrz9CoakRyMOxuVekd8w7Ru+UFwlc2fDwPAAv5A8WlMAm4pO
         0uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726094; x=1754330894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gmrGvfylvw3ZgqzNbgUCIxZfOpxfy+MGSCTqwUJs5I=;
        b=DO4mQduCTOveVWBIJUFPxZRCdtOs/iK95xt4NuYJXc1gJGysEWr/1KS+CtRebimqFp
         KV92mAmB/FqXhEGQ3LgUBxq+QSIdsyRJW+Jf/MMQ2BXN1vp2tziETg0O2JZ+/m1mQ+Jj
         aVcBsaJWgDrJdu4RoNqY3oKYZwWn8UV/wFHVnnjXP8ACNDuElZWFjk9SjmrlQauS25w1
         /kCXRsns0fDPKQZBcqS0sPla+o0e3P+wQwYNn3pPiBzXyy0+0Hd0MvVWuqjraI/i1mWw
         Yyz+WdWLLETPhAxlWHsavN8np7xSc8jv2zg+S1EWZafNxfzk7FNuweM3KYcPnYhvhUXO
         y+8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCwJ7chPb8RbG0GtztHeG3/i3lkeGahc8Z+D8uhyglc98ovgwLYf2II496jAktWZyjrzY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy57V6kobVjlMM8lFCKkr4Uh1FufUbONUl5JVW21dqGNcJFZp/u
	YK2lO7vc7364m7G4I4cN4wA2b9VHYus+I1vfFFmTpCBAnBsLQKmw4Ic/d2M9EjY+MVXx1X1657m
	eKI861mpEEVmfOlDCGgVyKnk2T4oIrXitqT6ZcMjWzsYegTkljuuoPuJW
X-Gm-Gg: ASbGncuG6hng2uVyemaaKyf+Ki0Bled5qi8+cQRyOgK9oQpzbpM4OXpxDF8uNwCwG5H
	O59Xow7ZG6BIy3fZvTIj28Im3SSYe3GtS6lTsYP3Carj+myngaDrs/wVFedIxXqQFK0d/qw5rkt
	P+zzUAFLlNnmNVD98ea4KSlSnX/3Q2PPQYI1pt+ZrY/rK2nrMbCVb1rFYnjUZY2qTFVR0sgclHj
	1MTcEYxYbnQX9Nkcf5JhHl+Gh01sqZEqMlIW7l6upxrfrc=
X-Google-Smtp-Source: AGHT+IHjjBEZToln1GUKdNiNA5i+48eLmqUyHE2lIco0fXmKeAo87dihQyms53696HZtftCNENAtjjy50jxrFh37csY=
X-Received: by 2002:a05:6902:2192:b0:e8e:16d9:8f09 with SMTP id
 3f1490d57ef6-e8e2512a762mr683908276.17.1753726093352; Mon, 28 Jul 2025
 11:08:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
In-Reply-To: <aIFHc83PtfB9fkKB@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 11:07:37 -0700
X-Gm-Features: Ac12FXw88v-b_BueYv4w7UAtEPsyh5QQFnvb9K48s-JDnycsPo2ucd7UoV2kjdI
Message-ID: <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 1:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 07, 2025, James Houghton wrote:
> > From: Vipin Sharma <vipinsh@google.com>
> >
> > Use MMU read lock to recover TDP MMU NX huge pages. Iterate
>
> Wrap at ~75 chars.

Oh, I did indeed wrap the text pretty aggressively for this patch. Not
sure why that happened.

>
> > over the huge pages list under tdp_mmu_pages_lock protection and
> > unaccount the page before dropping the lock.
> >
> > We must not zap an SPTE if:
>
> No pronouns!

Right.

>
> > - The SPTE is a root page.
> > - The SPTE does not point at the SP's page table.
> >
> > If the SPTE does not point at the SP's page table, then something else
> > has change the SPTE, so we cannot safely zap it.
> >
> > Warn if zapping SPTE fails and current SPTE is still pointing to same
> > page table. This should never happen.
> >
> > There is always a race between dirty logging, vCPU faults, and NX huge
> > page recovery for backing a gfn by an NX huge page or an executable
> > small page. Unaccounting sooner during the list traversal is increasing
> > the window of that race. Functionally, it is okay, because accounting
> > doesn't protect against iTLB multi-hit bug, it is there purely to
> > prevent KVM from bouncing a gfn between two page sizes. The only
> > downside is that a vCPU will end up doing more work in tearing down all
> > the child SPTEs. This should be a very rare race.
> >
> > Zapping under MMU read lock unblocks vCPUs which are waiting for MMU
> > read lock. This optimizaion is done to solve a guest jitter issue on
> > Windows VM which was observing an increase in network latency.
>
> With slight tweaking:
>
> Use MMU read lock to recover TDP MMU NX huge pages.  To prevent
> concurrent modification of the list of potential huge pages, iterate over
> the list under tdp_mmu_pages_lock protection and unaccount the page
> before dropping the lock.
>
> Zapping under MMU read lock unblocks vCPUs which are waiting for MMU
> read lock, which solves a guest jitter issue on Windows VMs which were
> observing an increase in network latency.
>
> Do not zap an SPTE if:
> - The SPTE is a root page.
> - The SPTE does not point at the SP's page table.
>
> If the SPTE does not point at the SP's page table, then something else
> has change the SPTE, so KVM cannot safely zap it.

"has changed" (my mistake)

>
> Warn if zapping SPTE fails and current SPTE is still pointing to same
> page table, as it should be impossible for the CMPXCHG to fail due to all
> other write scenarios being mutually exclusive.
>
> There is always a race between dirty logging, vCPU faults, and NX huge
> page recovery for backing a gfn by an NX huge page or an executable
> small page.  Unaccounting sooner during the list traversal increases the
> window of that race, but functionally, it is okay.  Accounting doesn't
> protect against iTLB multi-hit bug, it is there purely to prevent KVM
> from bouncing a gfn between two page sizes. The only  downside is that a
> vCPU will end up doing more work in tearing down all  the child SPTEs.
> This should be a very rare race.

Thanks, this is much better.

>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Co-developed-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 107 ++++++++++++++++++++++++-------------
> >  arch/x86/kvm/mmu/tdp_mmu.c |  42 ++++++++++++---
> >  2 files changed, 105 insertions(+), 44 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b074f7bb5cc58..7df1b4ead705b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7535,12 +7535,40 @@ static unsigned long nx_huge_pages_to_zap(struc=
t kvm *kvm,
> >       return ratio ? DIV_ROUND_UP(pages, ratio) : 0;
> >  }
> >
> > +static bool kvm_mmu_sp_dirty_logging_enabled(struct kvm *kvm,
> > +                                          struct kvm_mmu_page *sp)
> > +{
> > +     struct kvm_memory_slot *slot =3D NULL;
> > +
> > +     /*
> > +      * Since gfn_to_memslot() is relatively expensive, it helps to sk=
ip it if
> > +      * it the test cannot possibly return true.  On the other hand, i=
f any
> > +      * memslot has logging enabled, chances are good that all of them=
 do, in
> > +      * which case unaccount_nx_huge_page() is much cheaper than zappi=
ng the
> > +      * page.
>
> And largely irrelevant, because KVM should unaccount the NX no matter wha=
t.  I
> kinda get what you're saying, but honestly it adds a lot of confusion, es=
pecially
> since unaccount_nx_huge_page() is in the caller.
>
> > +      *
> > +      * If a memslot update is in progress, reading an incorrect value=
 of
> > +      * kvm->nr_memslots_dirty_logging is not a problem: if it is beco=
ming
> > +      * zero, gfn_to_memslot() will be done unnecessarily; if it is be=
coming
> > +      * nonzero, the page will be zapped unnecessarily.  Either way, t=
his only
> > +      * affects efficiency in racy situations, and not correctness.
> > +      */
> > +     if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
>
> Short-circuit the function to decrease indentation, and so that "slot" do=
esn't
> need to be NULL-initialized.
>
> > +             struct kvm_memslots *slots;
> > +
> > +             slots =3D kvm_memslots_for_spte_role(kvm, sp->role);
> > +             slot =3D __gfn_to_memslot(slots, sp->gfn);
>
> Then this can be:
>
>         slot =3D __gfn_to_memslot(kvm_memslots_for_spte_role(kvm, sp->rol=
e), sp->gfn);
>
> without creating a stupid-long line.
>
> > +             WARN_ON_ONCE(!slot);
>
> And then:
>
>         if (WARN_ON_ONCE(!slot))
>                 return false;
>
>         return kvm_slot_dirty_track_enabled(slot);
>
> With a comment cleanup:
>
>         struct kvm_memory_slot *slot;
>
>         /*
>          * Skip the memslot lookup if dirty tracking can't possibly be en=
abled,
>          * as memslot lookups are relatively expensive.
>          *
>          * If a memslot update is in progress, reading an incorrect value=
 of
>          * kvm->nr_memslots_dirty_logging is not a problem: if it is beco=
ming
>          * zero, KVM will  do an unnecessary memslot lookup;  if it is be=
coming
>          * nonzero, the page will be zapped unnecessarily.  Either way, t=
his
>          * only affects efficiency in racy situations, and not correctnes=
s.
>          */
>         if (!atomic_read(&kvm->nr_memslots_dirty_logging))
>                 return false;
>
>         slot =3D __gfn_to_memslot(kvm_memslots_for_spte_role(kvm, sp->rol=
e), sp->gfn);
>         if (WARN_ON_ONCE(!slot))
>                 return false;
>
>         return kvm_slot_dirty_track_enabled(slot);

LGTM, thanks!

> > @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(struct kvm=
 *kvm,
> >       rcu_read_lock();
> >
> >       for ( ; to_zap; --to_zap) {
> > -             if (list_empty(nx_huge_pages))
> > +#ifdef CONFIG_X86_64
>
> These #ifdefs still make me sad, but I also still think they're the least=
 awful
> solution.  And hopefully we will jettison 32-bit sooner than later :-)

Yeah I couldn't come up with anything better. :(

