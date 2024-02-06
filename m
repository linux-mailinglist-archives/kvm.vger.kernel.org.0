Return-Path: <kvm+bounces-8067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEED84AC98
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 04:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84290B22895
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C347319A;
	Tue,  6 Feb 2024 03:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sTteBOu/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309D56B7C
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 03:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707188566; cv=none; b=EOcLFzzrDjZf4MsTfhFHYqfMfZHidRNuslskOUnu9i3NyQMN/GNqZ6NPk0pfDR++7p3loXUbCZi2wZdI0e1/PTW2Zo1b768/ZXKZRX86orGBOGZQ5ihc2kAyzL7yOyhC1DZJQayv/8wKhf2PITCfGWGU4zWt8/VDnUCY37ij678=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707188566; c=relaxed/simple;
	bh=kBzx4awxw5LVCDNkJdTstMCTGo6+HBvB8LVztcy5v/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RHN2TTwwj+mzgdoLF0+3DrsbO5HPzP1Xnn1JrO4x54Okdj6KSbZtil3XfFl7xLlLmttWNaiLmo8tVuuJHnXYS6Fevjxm9Kjtz3ryDnHuH0HSa926mUEHKoTEAqS1Ukl+eab9Lb6RXyHEDCdkMHUlYlP7gLSiL/AolxQ9w54tses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sTteBOu/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c670f70a37so5772119a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 19:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707188564; x=1707793364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaTcFjuXmqnsH7kqgmGjwl1nafZpPgrra2KesS58E+w=;
        b=sTteBOu/bmgYSMfAgpxmSuCzB7bcILb0Zl7z8BVLPcjZ7LBJ0Hq48gjQC5Gc0i6Xy7
         ax1K5xB7EbXFEJkQ/GrlFNUWFQgkp35jOey/95yy7ZC17CLnkjbpU2roL5zsXLr4k/m4
         9evToShmMc6Hl+X3BrgxOFHSCr6fGFO8z1pv9jZFr3uTThMx6wKXl4YPk3+I5jB4uD+z
         TyI2dSAHRF6gVZ++BOHvgerGINx0JJR0wChmEGFRnd2sYV79ZbnuVhPhCBvYRx+4cFQ8
         uV3qpfugQ3fkswA1a94pQd6OdMjKMA2K9EkB49vWH4YxTcP8o9ES7bi2ZAanzmESGIhN
         fIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707188564; x=1707793364;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WaTcFjuXmqnsH7kqgmGjwl1nafZpPgrra2KesS58E+w=;
        b=FreBob0U6dFUluSNxvEcXgIOxsZLLQsMwCaRtidJEXkQIwotuVMLtynxATv+qkCTa0
         akU6UUtK9AA8l5bfTMEju+SGOE6UceEi1XKvD6VrmFPZz5nfblAYd+QatJxI7ITaBNt9
         Xk1v+vcGWtRaXInKcRbTaNuJmfQoUI1L6cVyDGSxZSMbgej14hE2kR65i3tIS4JEA6hO
         UFoYM38vl057r4j7C3he+eJ6pnL9fmw4AweBWo5IriVhFwzZ+WlIwQ8kfytKksNoAlpS
         0Sy/nqL9cogjfyvdJ0Gy0iRQlnb/3z2OALzje3nejp4SE1nt+icn8dV6QyHHcXPy3sg6
         rPTQ==
X-Gm-Message-State: AOJu0YyWk5lEat0+v4V4aaOc0WLKT5zbx5X+7okkatt52jbP62Jz6xou
	eiRB9tEP0ukVu5EbUKCuToF0h41IVDkrF/GkhMx6c1dn4yPgB/CgZtVyD/lzsBSJl6qFmZctPMx
	0+Q==
X-Google-Smtp-Source: AGHT+IHPzWKRo2TUubxgvJzVlNzSkLxCmRqfd8HzDPV63ck/WwfGr/QOs7ddWuXNE+DfPtWKcMHcf/BKuBE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d8a:0:b0:5ca:45d0:dc1b with SMTP id
 bc10-20020a656d8a000000b005ca45d0dc1bmr25816pgb.9.1707188564462; Mon, 05 Feb
 2024 19:02:44 -0800 (PST)
Date: Mon, 5 Feb 2024 19:02:42 -0800
In-Reply-To: <CAD=HUj62vdy9CmqHWsAQi4S6i1ZH8uUE81p8Wu67pQd5vNRr+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-7-stevensd@google.com>
 <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com> <CAD=HUj62vdy9CmqHWsAQi4S6i1ZH8uUE81p8Wu67pQd5vNRr+w@mail.gmail.com>
Message-ID: <ZcGhUvUuiK090tcq@google.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023, David Stevens wrote:
> On Mon, Sep 18, 2023 at 6:58=E2=80=AFPM Dmitry Osipenko
> <dmitry.osipenko@collabora.com> wrote:
> >
> > On 9/11/23 05:16, David Stevens wrote:
> > > From: David Stevens <stevensd@chromium.org>
> > >
> > > Handle non-refcounted pages in __kvm_faultin_pfn. This allows the hos=
t
> > > to map memory into the guest that is backed by non-refcounted struct
> > > pages - for example, the tail pages of higher order non-compound page=
s
> > > allocated by the amdgpu driver via ttm_pool_alloc_page.
> > >
> > > The bulk of this change is tracking the is_refcounted_page flag so th=
at
> > > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. Th=
is is
> > > done by storing the flag in an unused bit in the sptes. There are no
> > > bits available in PAE SPTEs, so non-refcounted pages can only be hand=
led
> > > on TDP and x86-64.
> > >
> > > Signed-off-by: David Stevens <stevensd@chromium.org>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++--------=
--
> > >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> > >  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
> > >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> > >  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
> > >  include/linux/kvm_host.h        |  3 ++
> > >  virt/kvm/kvm_main.c             |  6 ++--
> > >  8 files changed, 76 insertions(+), 32 deletions(-)
> >
> > Could you please tell which kernel tree you used for the base of this
> > series? This patch #6 doesn't apply cleanly to stable/mainline/next/kvm
> >
> > error: sha1 information is lacking or useless (arch/x86/kvm/mmu/mmu.c).
> > error: could not build fake ancestor
>=20
> This series is based on the kvm next branch (i.e.
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dnext). The
> specific hash is d011151616e73de20c139580b73fa4c7042bd861.

Drat, found this too late.  Please use --base so that git appends the exact=
 base
commit.   From Documentation/process/maintainer-kvm-x86.rst:

Git Base
~~~~~~~~
If you are using git version 2.9.0 or later (Googlers, this is all of you!)=
,
use ``git format-patch`` with the ``--base`` flag to automatically include =
the
base tree information in the generated patches.

Note, ``--base=3Dauto`` works as expected if and only if a branch's upstrea=
m is
set to the base topic branch, e.g. it will do the wrong thing if your upstr=
eam
is set to your personal repository for backup purposes.  An alternative "au=
to"
solution is to derive the names of your development branches based on their
KVM x86 topic, and feed that into ``--base``.  E.g. ``x86/pmu/my_branch_nam=
e``,
and then write a small wrapper to extract ``pmu`` from the current branch n=
ame
to yield ``--base=3Dx/pmu``, where ``x`` is whatever name your repository u=
ses to
track the KVM x86 remote.

