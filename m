Return-Path: <kvm+bounces-47988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 040DFAC80C8
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 18:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01D3EA2656F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 16:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A7E22D9F9;
	Thu, 29 May 2025 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WSo3BFXe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09CB22B8CF
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748535467; cv=none; b=q3fxc37DruRyC6mmkQLvXc7sBCcaXRLJWKoOeEOKGNR1T6dEI3S4ZZQJzPb3OyPIS3qT+/z1eHFvxs9V4hpS014AjLxQgMdugRyIVD/TGz0AxPXZYfxvzrRslNbVxhlcaLshWjYKvLqOjUAimDbcUOsOFNizOT1M51lpQJ5MCk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748535467; c=relaxed/simple;
	bh=qdz6hBl1zKNtjJs9q/5z5I8Zm2mnRaEEneEX4tmGMvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4ZdelE86CFQc7a3dW4vAW76ZcWt9P8icDk4jCNKn2Wb+rRMO145Xi2baKHlKLQd/zbGtafTr64iFWYCE9TSMvGJbKxVNahl3J0vEXm1RsXn2McRxnzojjW2QnlNcp+CgfWW0zWrORz118TonQCjY9kYVRhCY7cvEy6N/kAMBYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WSo3BFXe; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e7da03bb0cdso750592276.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 09:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748535465; x=1749140265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFXz1a5AzZ0BGVhwiRYx2U+xdcfYzrs9yjeyMb/mIK4=;
        b=WSo3BFXe2njQAne/kwJ26wC+OeLiKtjPMZuIHtg3pB0p1wc+1m7vlSZaAB4OIX1OJe
         QaHk9kNc+q0VgEdJNA8j4AMnszIHzQZmeq/1IIVpYVE7jX7LcNBeYVu/oHjkRmrIuYFq
         dgFBuwcjBhWQt3cKF1KUIsBzmlevQ4dPCbOlgJgPy11LWEWQZLo1WeuZpeNCmh/N6oS7
         53J/CYEYiTJGMLpFKUPRciyI06/n+GmBiMl3kD+VtAe+uyMHWP3E2fFzDhRMQ+n98NXg
         /xMCc1mFpk8P/DEdfhg7FPjCZEIZAWSzqqoOBp2tMN/2I1iZYwFMwfBXifZB7YCJUNYs
         V+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748535465; x=1749140265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nFXz1a5AzZ0BGVhwiRYx2U+xdcfYzrs9yjeyMb/mIK4=;
        b=vNNUTM++HtQXj9gAhqaUWKsQEnZboAyri08kGxNJy0PkekIeAik0NaqAmIA+21y8qw
         uR1LjOHplKzmBA/JijeEsBCuzzlSjuWnHsXckTJqIA8WdBT5yaARCV5d6N8eWNOb8+93
         /rlJgFV0czgGpdmkD/mcJy7p5dz+dhWk56dtwFkOJHRarmx4yt77+OFoQaPIVpu4iyGV
         lvWt3NnCpMvRIGRdED0eJPeSJiSAYaSeYSQhzWaToU9oDayDQ88jcYmkJOEo9dFqArXV
         pGd2JhEyqlvAtYDPohBHUlkHEQK7yVmwukAYXBfE9QrBsGcQ8BKHUOVRivH3/EGVi1ao
         5I1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUKz3PdYTaIvpyZoi71cpKsK8h684m1x+3d+iZ/l1hEEGS5X1EQ83/iWc5AW0pu8xZ1/GM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz80uo6DXfR1j+giRemYmvilzk5dnlShW7AFylPWTczzgrm/eV
	+RHFnyJRvIJ7nFKL0z9BV7JVDYBz+81flLZoBC0+pjUoZgI2Lf3B5YgMFdff5zJDhAwrSQxvbKJ
	0htUmY43mxuY3Gj7YjUx7P/pwrZnsQXBBTXXk4RKj
X-Gm-Gg: ASbGncv/bO1RHKXKxb2D9jWgdhucGrjrC+vCf0oymG0E8akSs2pWsjWrvdRr6Bl9iIl
	xC3QIqEwOWi2XFkjSu7wJDkddH7WKHI8AusrYWJohABZQzEL3+RS0xqhvRUMHZT/jwI731HJL/G
	sNMVF8MLLlAW0Gvwx7KFr9NsqIt0k3oyCymRd4tUgYftKu2oJuctJv4h/QtBNsDe+Hiiu45mT45
	yjAYA==
X-Google-Smtp-Source: AGHT+IF2r9KlCyWj26WmElOEW91mfbdAeVcd/eA82K9ZIcXgbLmgmEn0mrSZRnVH71gS/1JkigbmLcuptMyfDe0ic3c=
X-Received: by 2002:a05:6902:2b10:b0:e7a:b37b:725e with SMTP id
 3f1490d57ef6-e7f81e54c0bmr349501276.24.1748535464377; Thu, 29 May 2025
 09:17:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <aBqlkz1bqhu-9toV@google.com> <CADrL8HXjLjVyFiFee9Q58TQ9zBfXiO+VG=25Rw4UD+fbDmxQFg@mail.gmail.com>
 <aDh9GtncjlVvvVJ1@google.com>
In-Reply-To: <aDh9GtncjlVvvVJ1@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 May 2025 12:17:07 -0400
X-Gm-Features: AX0GCFtfh9MpZ-FDeJh2HrOczvbP9Hqyb2MdkVjRGdhWtHrFMpUcFHJvfRdVctg
Message-ID: <CADrL8HUVf0wekmZHfZeb59w1j1=gFhs6oRZgNkufB3gOL-TENQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 11:28=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, May 28, 2025, James Houghton wrote:
> > The only thing that I want to call out again is that this UAPI works
> > great for when we are going from userfault --> !userfault. That is, it
> > works well for postcopy (both for guest_memfd and for standard
> > memslots where userfaultfd scalability is a concern).
> >
> > But there is another use case worth bringing up: unmapping pages that
> > the VMM is emulating as poisoned.
> >
> > Normally this can be handled by mm (e.g. with UFFDIO_POISON), but for
> > 4K poison within a HugeTLB-backed memslot (if the HugeTLB page remains
> > mapped in userspace), KVM Userfault is the only option (if we don't
> > want to punch holes in memslots). This leaves us with three problems:
> >
> > 1. If using KVM Userfault to emulate poison, we are stuck with small
> > pages in stage 2 for the entire memslot.
> > 2. We must unmap everything when toggling on KVM Userfault just to
> > unmap a single page.
> > 3. If KVM Userfault is already enabled, we have no choice but to
> > toggle KVM Userfault off and on again to unmap the newly poisoned
> > pages (i.e., there is no ioctl to scan the bitmap and unmap
> > newly-userfault pages).
> >
> > All of these are non-issues if we emulate poison by removing memslots,
> > and I think that's possible. But if that proves too slow, we'd need to
> > be a little bit more clever with hugepage recovery and with unmapping
> > newly-userfault pages, both of which I think can be solved by adding
> > some kind of bitmap re-scan ioctl. We can do that later if the need
> > arises.
>
> Hmm.
>
> On the one hand, punching a hole in a memslot is generally gross, e.g. re=
quires
> deleting the entire memslot and thus unmapping large swaths of guest memo=
ry (or
> all of guest memory for most x86 VMs).
>
> On the other hand, unless userspace sets KVM_MEM_USERFAULT from time zero=
, KVM
> will need to unmap guest memory (or demote the mapping size a la eager pa=
ge
> splitting?) when KVM_MEM_USERFAULT is toggled from 0=3D>1.
>
> One thought would be to change the behavior of KVM's processing of the us=
erfault
> bitmap, such that KVM doesn't infer *anything* about the mapping sizes, a=
nd instead
> give userspace more explicit control over the mapping size.  However, on =
non-x86
> architectures, implementing such a control would require a non-trivial am=
ount of
> code and complexity, and would incur overhead that doesn't exist today (i=
.e. we'd
> need to implement equivalent infrastructure to x86's disallow_lpage track=
ing).
>
> And IIUC, another problem with KVM Userfault is that it wouldn't Just Wor=
k for
> KVM accesses to guest memory.  E.g. if the HugeTLB page is still mapped i=
nto
> userspace, then depending on the flow that gets hit, I'm pretty sure that=
 emulating
> an access to the poisoned memory would result in KVM_EXIT_INTERNAL_ERROR,=
 whereas
> punching a hole in a memslot would result in a much more friendly KVM_EXI=
T_MMIO.

Oh, yes, of course. KVM Userfault is not enough for memory poison
emulation for non-guest-memfd memslots. Like how for these memslots we
need userfaultfd to do post-copy properly, for memory poison, we still
need userfaultfd (so 4K emulated poison within a HugeTLB memslot is
not possible).

So yeah in this case (4K poison in a still-mapped HugeTLB page), we
would need to punch a hole and get KVM_EXIT_MMIO. SGTM.

For guest_memfd memslots, we can handle uaccess to emulated poison
like tmpfs: with UFFDIO_POISON (Nikita has already started on
UFFDIO_CONTINUE support[1]). We *could* make the gmem page fault
handler (what Fuad is implementing) respect KVM Userfault, but that
isn't necessary (and would look quite like a reimplementation of
userfaultfd).

[1]: https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.com=
/

> All in all, given that KVM needs to correctly handle hugepage vs. memslot
> alignment/size issues no matter what, and that KVM has well-established b=
ehavior
> for handling no-memslot accesses, I'm leaning towards saying userspace sh=
ould
> punch a hole in the memslot in order to emulate a poisoned page.  The onl=
y reason
> I can think of for preferring a different approach is if userspace can't =
provide
> the desired latency/performance characteristics when punching a hole in a=
 memslot.
> Hopefully reacting to a poisoned page is a fairly slow path?

In general, yes it is. Memory poison is rare.

For non-HugeTLB (tmpfs or guest_memfd), I don't think we need to punch
a hole, so that's good. For HugeTLB, there are two circumstances that
are perhaps concerning:

1. Learning about poison during post-copy? This should be vanishingly
rare, as most poison is discovered in the first pre-copy pass. If we
didn't do *any* pre-copy passes, then it could be a concern.
2. Learning about poison during pre-copy after shattering? If doing
lazy page splitting with incremental dirty log clearing, this isn't a
*huge* problem, otherwise it could be.

I think userspace has two ways out: (1) don't make super large
memslots, or (2) don't use HugeTLB.

Just to be clear, this isn't really an issue with KVM Userfault -- in
its current form (not preventing KVM's uaccess), it cannot help here.

