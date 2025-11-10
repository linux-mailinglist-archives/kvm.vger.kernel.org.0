Return-Path: <kvm+bounces-62581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B7CC491F0
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D4041889D01
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F0B32AAC8;
	Mon, 10 Nov 2025 19:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="okuif7Mx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7658A28850E
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762803990; cv=none; b=HGw41h1cvcevN2WdTSB0wmdBHesjOQm5dV9DuZ6ZmhY9zOCeDg938DZlu+0yt7o2X5lg903OMqYXK4UZ6NnATrBMFSLyvI8+SBnWu/kGk939kP1xNy1S/WW75pIHZDCDz3+pezeskaizAgkxmugDJldIOniEqTr6SvGeKbSNaG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762803990; c=relaxed/simple;
	bh=YZGaIzpaEZLGappva0Ug2DJlxNAxd2ApsVVc832oRdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0E7LjYTDRYslh4r7JHPdSOXnuYcRfgqmvgOkeVsWhOcfsJH3zxB7kZAILs6XeVKZPAAi7NcFuRPvQnm35vth1VgignEjCAgtS4d7Xsp2jobhDuQateTJmJaIdKRO/1ZMy6kxs55OTyQlNG2EPQIBJRvCjXkFjw3Pm4Cv1LLMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=okuif7Mx; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-580144a31b0so1401448137.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 11:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762803987; x=1763408787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYTpMH/+7AmKmRXshRvtBV04IdawyBlwk+7ovqC25vc=;
        b=okuif7MxofwRcZacNsKUF79wne34F2KF3wLLAwQgkPeFHXu6pnr7MiWd+v1VmcmzZR
         v5hkV7ErRBK0oWVHoD6xlO033K5wQaqAQJG7kJEa0AxDW3QCxjJRmkREa2FEblrgilB+
         YFZ1Rr4JiPzMntRq7ER8L4WS9XAjc4oF6XNotj6LaIANev/MCfYX1M51Ot+f7W/0pfhM
         fSpGnGmiBp8ctwM1w2SNjdIVCuGsw3TCYDJpBwKa4w9rGDd2v0ZKqsrpMoOrw6soRaiZ
         He+yCfk9Y0s9aAAcecNR7cc17tCvzoTWniAmq7TyVY6/LskWoXOdr/e7juiWcedkHYzq
         zqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762803987; x=1763408787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aYTpMH/+7AmKmRXshRvtBV04IdawyBlwk+7ovqC25vc=;
        b=uxNg8kKWXqKCBY+Sfu0vILBK+zUmYgdk/TgDT4KeNuizrnpjYbhXVTBxzLLvPntQMF
         yPoUWmR1bF00/Ny3+EjXOclmC8Mvzd/q7oM+x6qdBvezvyQ6X/PicmAJMopk+0RhzhtN
         GuqiziNuRB2HM+nm3hX8XHOal9IPU7MLTv/ojev2u63G4yKkQGXy26iUwgcUZuciq866
         7IVfVl5aeapIcTZZGWdxWnp0B8hadaaAi+tFl2Rxs+ZaWyV+cuXMPV5qp3uGxeUXDIMW
         o2v6LfeZ8bjVtP8RQT/scIvroTN3pEKmivP8nI5bHDTnkZRaOs5Le6jJRxecJyVCN1j5
         ayyA==
X-Forwarded-Encrypted: i=1; AJvYcCWmF2neNgH2MooZ/xdWPeA9+LEtxmfc/WM9a8Vy4uPHaSV00lHPaJ4QXTXOl6NykaAvdqw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc+wArs0wL9r60tJ0pO4eIr+bQRmSMomjB/fGgkLqXqGJhSTLV
	K5K93pPGLXJwyq0D6+CaykLkOy5NqHHgl0jxr8U0iVuPFrj4cgCOMGKWh6PllHA4bqqOsZMpg94
	cL0DGx8ulBNISznVLg/HIv+uKIky6BLmY6BiTJVX4
X-Gm-Gg: ASbGncsNU9p2lC1PjSG/xfGLrKb+HMJDh2yEx72QFg81HFPzdMaz5k2uMtETgDHB3nt
	ndVCi4BhK4SYQKHpIDeJ5gKJPgyz6es4hEUK49FWEzVOoQUCwswmwLHimrl2sprY7kW5jr1wLqE
	KWkRCCoyNr7x8JF4TEUeiOoBinGRlc6BYjkY2NeB2ycXw0HPRRb6t3E2m1dgaKBnGLLO8XkpEEU
	jPbQDFq9hYV0f+es1FBBf2V+ZcoUYa+83nDr6lFtOTx2bFhnBIzEQffgQ4Cgjmzw07Mk6Dai0wC
	wi/7HA==
X-Google-Smtp-Source: AGHT+IFrPIDtYP60imdNibriTTZFyFrg+kjwiw3cwvkj6Zc23sMdHolxpslhziSXkbR/ghaQ1HgKcIIE93DXZLTrHBI=
X-Received: by 2002:a05:6102:26c6:b0:5db:cc92:26f9 with SMTP id
 ada2fe7eead31-5ddc47df8damr3248309137.39.1762803986990; Mon, 10 Nov 2025
 11:46:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107222058.2009244-1-dmatlack@google.com> <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
 <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com> <20251108143710.318702ec.alex@shazbot.org>
 <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com> <20251110081709.53b70993.alex@shazbot.org>
 <aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com> <aRIoKJk0uwLD-yGr@google.com> <20251110113757.22b320b8.alex@shazbot.org>
In-Reply-To: <20251110113757.22b320b8.alex@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 10 Nov 2025 11:45:58 -0800
X-Gm-Features: AWmQ_bk67Z3e_yqE6nHsy2EDKFAt5tOOA0GQBcdd5DTPf5JePRQJHPfsb4jsmaM
Message-ID: <CALzav=d2w1Q4_P2AjfM0aantjtdKW_1jRUMprRQiC2SCk77ewg@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 10:38=E2=80=AFAM Alex Williamson <alex@shazbot.org>=
 wrote:
>
> On Mon, 10 Nov 2025 18:00:08 +0000
> David Matlack <dmatlack@google.com> wrote:
>
> > On 2025-11-10 08:48 AM, Alex Mastro wrote:
> > > On Mon, Nov 10, 2025 at 08:17:09AM -0700, Alex Williamson wrote:
> > > > On Sat, 8 Nov 2025 17:20:10 -0800
> > > > Alex Mastro <amastro@fb.com> wrote:
> > > >
> > > > > On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:
> > > > > > On Sat, 8 Nov 2025 12:19:48 -0800
> > > > > > Alex Mastro <amastro@fb.com> wrote:
> > > > > > > Here's my attempt at adding some machinery to query iova rang=
es, with
> > > > > > > normalization to iommufd's struct. I kept the vfio capability=
 chain stuff
> > > > > > > relatively generic so we can use it for other things in the f=
uture if needed.
> > > > > >
> > > > > > Seems we were both hacking on this, I hadn't seen you posted th=
is
> > > > > > before sending:
> > > > > >
> > > > > > https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot=
.org/T/#u
> > > > > >
> > > > > > Maybe we can combine the best merits of each.  Thanks,
> > > > >
> > > > > Yes! I have been thinking along the following lines
> > > > > - Your idea to change the end of address space test to allocate a=
t the end of
> > > > >   the supported range is better and more general than my idea of =
skipping the
> > > > >   test if ~(iova_t)0 is out of bounds. We should do that.
> > > > > - Introducing the concept iova allocator makes sense.
> > > > > - I think it's worthwhile to keep common test concepts like vfio_=
pci_device
> > > > >   less opinionated/stateful so as not to close the door on certai=
n categories of
> > > > >   testing in the future. For example, if we ever wanted to test I=
OVA range
> > > > >   contraction after binding additional devices to an IOAS or vfio=
 container.
> > > >
> > > > Yes, fetching the IOVA ranges should really occur after all the dev=
ices
> > > > are attached to the container/ioas rather than in device init.  We =
need
> > > > another layer of abstraction for the shared IOMMU state.  We can
> > > > probably work on that incrementally.
> >
> > I am working on pulling the iommu state out of struct vfio_pci_device
> > here:
> >
> >   https://lore.kernel.org/kvm/20251008232531.1152035-5-dmatlack@google.=
com/
> >
> > But if we keep the iova allocator a separate object, then we can
> > introduce it mosty indepently from this series. I imagine the only thin=
g
> > that will change is passing a struct iommu * instead of a struct
> > vfio_pci_device * when initializing the allocator.
> >
> > > >
> > > > I certainly like the idea of testing range contraction, but I don't
> > > > know where we can reliably see that behavior.
> > >
> > > I'm not sure about the exact testing strategy for that yet either act=
ually.
> > >
> > > > > - What do you think about making the concept of an IOVA allocator=
 something
> > > > >   standalone for which tests that need it can create one? I think=
 it would
> > > > >   compose pretty cleanly on top of my vfio_pci_iova_ranges().
> > > >
> > > > Yep, that sounds good.  Obviously what's there is just the simplest
> > > > possible linear, aligned allocator with no attempt to fill gaps or
> > > > track allocations for freeing.  We're not likely to exhaust the add=
ress
> > > > space in an individual unit test, I just wanted to relieve the test
> > > > from the burden of coming up with a valid IOVA, while leaving some
> > > > degree of geometry info for exploring the boundaries.
> > >
> > > Keeping the simple linear allocator makes sense to me.
> > >
> > > > Are you interested in generating a combined v2?
> > >
> > > Sure -- I can put up a v2 series which stages like so
> > > - adds stateless low level iova ranges queries
> > > - adds iova allocator utility object
> > > - fixes end of ranges tests, uses iova allocator instead of iova=3Dva=
ddr
> >
> > +1 to getting rid of iova=3Dvaddr.
> >
> > But note that the HugeTLB tests in vfio_dma_mapping_test.c have
> > alignment requirements to pass on Intel (since it validates the pages
> > are mapped at the right level in the I/O page tables using the Intel
> > debugfs interface).
> >
> > > > TBH I'm not sure that just marking a test as skipped based on the D=
MA
> > > > mapping return is worthwhile with a couple proposals to add IOVA ra=
nge
> > > > support already on the table.  Thanks,
> > >
> > > I'll put up the new series rooted on linux-vfio/next soon.
> >
> > I think we should try to get vfio_dma_mapping_test back to passing in
> > time for Linux 6.18, since the newly failing test was added in 6.18.
> >
> > The sequence I was imagining was:
> >
> >  1. Merge the quick fix to skip the test into 6.18.
>
> We'd still have the iova=3Dvaddr failure on some platforms, but could
> hack around that by hard coding some "well supporteD" IOVA like 0 or
> 4GB.

Good point. We tried using IOVA=3D0 internally for a while but hit
issues on ARM platforms that have a reserved region at [0x8000000,
0x8100000). So I think iova=3D4GB would be better.

>
> >  2. Split struct iommu from struct vfio_pci_device.
> >  3. Add iova allocator.
> >
> > AlexW, how much time do we have to get AlexM's series ready? I am fine
> > with doing (3), then (2), and dropping (1) if there's enough time.
>
> I'll certainly agree that it'd be a much better precedent if the self
> test were initially working, but also we should not increase the scope
> beyond what we need to make it work for v6.18.  If we can get that done
> in the next day or two, add it to linux-next mid-week, and get Linus to
> pull for rc6, I think that'd be reasonable.  Thanks,

Ack. I'll send a small series with this patch plus a patch to replace
iova=3Dvaddr with iova=3D4G, and we can use that as a back-up plan if
AlexM's iova allocator isn't ready in time for 6.18.

