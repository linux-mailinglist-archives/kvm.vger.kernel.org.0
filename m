Return-Path: <kvm+bounces-19344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F14889041DB
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13ECD1C20DD8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D906EB74;
	Tue, 11 Jun 2024 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVzIqAnt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA4B5B05E
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124778; cv=none; b=tDJQDo175vPRKeEAiU8xVdEVOYuNoOLwhgd43jgw2GoWfIWmlEjZcN0aDUmo5tAJpulS4ouvc6amNVrHcfd5F8+Sroe2rPBhHDiBvAv9yqfuhrj7aclpuFno97ff4V/wRzrNzrg+GkoYJ2j0z+ZkaYzAkxMxnIc1pmIminmPXdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124778; c=relaxed/simple;
	bh=cUks1IzqDZ+RbXqF/1qmr4hcitIbzZ5D/+vX7HNk2w8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YHSXoRke60fQeIVFjMjj8l1nhkjFQLHOdgll+H0qIiAjla4fW+xzB5c1iAoi9t928PN2yBRNk1hKEHna0dIKCCsi4DbjI1ifdGceVIlC8TqANIj7qRSWg1EORzrlW379ykAM5w+kGoF4/Q3WbRCyvgmZ3teCVs5X9EDVyWYPBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVzIqAnt; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-44056f72257so131cf.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 09:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718124775; x=1718729575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNrvkbjbmCuGBxHxb5OVsA/4jQBqGMp/CsGTWofpaJ8=;
        b=IVzIqAntxily/mw4Rq9+/NxA4BqXIhL4kg4Q01RQi8RUzrwM0QN+RcGEWJC9bdiYyM
         66zcFYfXSIw2BDwl1zQ7dWU0/onZmxIWCp+5ofeBcRQvcxomVPGRcJK9uET4mMRHm34J
         rWsndsCOnykzYXUKpo3u7lw8X83QyvtNFsV9KyTOIF3By/VhwerTpTNiNK+gCujjjWJ3
         ISD+ogAkutdizmup/Vzq4VDq4jmbqysYPRnu1xzymOrF3zUu3JL9fcwZ5zpbTDQ2DT84
         m+3EMayQhYFq1w8TVQjOHihXpyhTZEYKIXz39Kk9+tVC+LlV488upckmyD1CEWL/hsVj
         sYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718124775; x=1718729575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNrvkbjbmCuGBxHxb5OVsA/4jQBqGMp/CsGTWofpaJ8=;
        b=TO/VgD7pRcS1n3XTZ5VCpMC8bSP94YTVZ2AhxaXKzlD9i7u60rTKNCrOrxBGUSLfE9
         to6+orYvVbi2gtcztcX7dya4OKQAUQYAYUvy9GWrhSxFAq1DE8GwTle8hMWgl+eslA8M
         Hg8lpsLfe82ZEJUOAaAKiFRAra868W+5bCa95S8dT5pGP6Xo8QKseCHPcfJcCA/BsAMV
         aWVs6iaQjJ3ZD1OCYxMYfEdqa3bPYx8rm66817Ay4DMSeHRuz5YS8eg3Yreq1GH7XXHA
         WzGYKysEz9o+NiuhKFTpND1nEPowN1rwg6TXPa/BEDnQgs776GhvG4ObLrKWGp5/ib6a
         c2dw==
X-Forwarded-Encrypted: i=1; AJvYcCVcwNfp1Zj4Jh7JS3ep+bK6T9lU3n6ewnRzZl7RMq4CVmG4kYyQSU9lOjGSOsTRq0SAzUCiy0jVaypeNzdWTSh+gjvj
X-Gm-Message-State: AOJu0Yz0S0pN+fke8/QJzRHSlRDh073rw/Q5DF4reQj3fwfQ1p03HP62
	q7vYNO7YAuuD8tMm/I09WQPHtL+s8jvTe7JgoPpXHaFlok5Lt0j1keJ9F40vdxo6VV+DMs1vjuy
	ZkgwU0SQD3zycRyyaPvbONKjO6m3CzCeJGCpZ
X-Google-Smtp-Source: AGHT+IETSJr/vthLSu4M/9Ufm7UR5Sik6z7Xo2T1/mUMxnuXtcmtqz9kCiAXEk/F0m7s9fStq+7fFskXaiSQE2MAAyQ=
X-Received: by 2002:a05:622a:550d:b0:441:3c01:d0fa with SMTP id
 d75a77b69052e-4414798d3c1mr3642241cf.23.1718124775151; Tue, 11 Jun 2024
 09:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-4-jthoughton@google.com> <ZmfnYnm3K_rHX_VB@linux.dev>
In-Reply-To: <ZmfnYnm3K_rHX_VB@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 11 Jun 2024 09:52:17 -0700
Message-ID: <CADrL8HUSOZumE403KF6yjdy5CVkjdDjiGHDwuhOaM7H9Jq5Cjw@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: arm64: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 10:58=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Jun 11, 2024 at 12:21:39AM +0000, James Houghton wrote:
> > Replace the MMU write locks (taken in the memslot iteration loop) for
> > read locks.
> >
> > Grabbing the read lock instead of the write lock is safe because the
> > only requirement we have is that the stage-2 page tables do not get
> > deallocated while we are walking them. The stage2_age_walker() callback
> > is safe to race with itself; update the comment to reflect the
> > synchronization change.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/arm64/kvm/Kconfig       |  1 +
> >  arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++------
> >  arch/arm64/kvm/mmu.c         | 26 ++++++++++++++++++++------
> >  3 files changed, 30 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 58f09370d17e..7a1af8141c0e 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -22,6 +22,7 @@ menuconfig KVM
> >       select KVM_COMMON
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_MMU_NOTIFIER
> > +     select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
> >       select HAVE_KVM_CPU_RELAX_INTERCEPT
> >       select KVM_MMIO
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 9e2bbee77491..b1b0f7148cff 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1319,10 +1319,10 @@ static int stage2_age_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >       data->young =3D true;
> >
> >       /*
> > -      * stage2_age_walker() is always called while holding the MMU loc=
k for
> > -      * write, so this will always succeed. Nonetheless, this delibera=
tely
> > -      * follows the race detection pattern of the other stage-2 walker=
s in
> > -      * case the locking mechanics of the MMU notifiers is ever change=
d.
> > +      * This walk may not be exclusive; the PTE is permitted to change
>
> s/may not/is not/

Will fix.

>
> > +      * from under us. If there is a race to update this PTE, then the
> > +      * GFN is most likely young, so failing to clear the AF is likely
> > +      * to be inconsequential.
> >        */
> >       if (data->mkold && !stage2_try_set_pte(ctx, new))
> >               return -EAGAIN;
> > @@ -1345,10 +1345,13 @@ bool kvm_pgtable_stage2_test_clear_young(struct=
 kvm_pgtable *pgt, u64 addr,
> >       struct kvm_pgtable_walker walker =3D {
> >               .cb             =3D stage2_age_walker,
> >               .arg            =3D &data,
> > -             .flags          =3D KVM_PGTABLE_WALK_LEAF,
> > +             .flags          =3D KVM_PGTABLE_WALK_LEAF |
> > +                               KVM_PGTABLE_WALK_SHARED,
> >       };
> > +     int r;
> >
> > -     WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> > +     r =3D kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     WARN_ON(r && r !=3D -EAGAIN);
>
> I could've been more explicit last time around, could you please tone
> this down to WARN_ON_ONCE() as well?

Will do, thanks.

>
> >       return data.young;
> >  }
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8bcab0cc3fe9..a62c27a347ed 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1773,25 +1773,39 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struc=
t kvm_gfn_range *range)
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> >       u64 size =3D (range->end - range->start) << PAGE_SHIFT;
> > +     bool young =3D false;
> > +
> > +     read_lock(&kvm->mmu_lock);
> >
> >       if (!kvm->arch.mmu.pgt)
> >               return false;
>
> I'm guessing you meant to have 'goto out' here, since this early return
> fails to drop the mmu_lock.

Ah sorry! Thanks for catching this.

