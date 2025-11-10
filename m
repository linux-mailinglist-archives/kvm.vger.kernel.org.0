Return-Path: <kvm+bounces-62642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 65704C49B5D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 347EF4EE713
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6728E303A0D;
	Mon, 10 Nov 2025 23:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IikgJAJY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E1525A2CF
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762816265; cv=none; b=YEP5J4YI1TERDGtEcA7VrLsItQH/9e+rDLtCZDQZyRI2FpWAGbh0yuli+HqJxBbr/8MTm/+/Nuwwpg2ty+GPSXNVdCKgX5UjrUz+cjoF5bWHXU3PVD6DIUDKXRFSsBRHtR2tppGkOmq7Qo0xBlfGhCAcMys3SL6HDsRYqN1Bno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762816265; c=relaxed/simple;
	bh=oy4PYXmHoEtc6GzRMLznOBsBdCS3C8+y7ilLIEcWVkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeAupAJi2bJL4quugTl6cR5bIiiyurcNPNy51X4HjS6AG2mntZghbdbx/3OnhmyQjRPKzE+K+haNZxNgKcnHbZRDizADRBXPwStYApvoEXQLFW2zaGzZw824g3UMANIH9YExEE5hAgWAxKn5sPcv+55UJJMlZO9BMnSGl/GoIKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IikgJAJY; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-93518a78d0aso1894244241.3
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762816260; x=1763421060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fe3hpRNA8+2yS1IV8mVqev+0HjRgVaWf6xg9qC+EZWY=;
        b=IikgJAJYO7ypEHKSOQQPU5bB6Wqg+NOJJ1px1OuYYpexLXY+TOFyOhuUoh4lDe+mHY
         gZEnzo8N1OFy+CNZ3o56j4KxD8/7ZmdL8CgrKFlrQQKOAZOLGsQur1AG8Kbpmdtt+1rb
         xAapAcu5NisXX2kqJGBThKt/2EBDfI0JE2gUYfSn11Kx41wycdCG6Texa264b1Oj8dNd
         d511ID1xfWJ4LYJsFt1jjp3Pl2jUMtrC4RklFe/ftbWvRpgD9EUjz7KBuFGD/BFBZ8fv
         rplH1gtEgWIHe2n2kXmscSMvGyIEdsK1p73sF53EDkUHAG9A8lyQ6Hsy5xIanivjZBmv
         mRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762816260; x=1763421060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fe3hpRNA8+2yS1IV8mVqev+0HjRgVaWf6xg9qC+EZWY=;
        b=c5t81WWisVb3yPtUO1J9cQJS+OC8NUZjqi/DwuXn8/tOFaYTxSBsV3QnowynIjt6Eo
         F1/I3HjYsZ26DnfGUfKIQRG7G+f9kjad4Qu2mrK10yIbo4dQkTQl+uqiQkkC8Ga1Y7Z3
         rL7Oi2M/6KCyD71b7d8rScl0BLE+/21eWCFvx1oN9CaLHof9LmqMAdaAmskaebraz/qV
         SuADPTfF4gFcOGzbGK4S052ChzY1HdXkjOgqBRDYifUhJgvWnfjfUiImpAEndGs4fgFt
         kSo2/EFyfkzWsz1CQO2n051uszNb2qmCtubl+ns8+SVkayTL12zH5vL6tQoAuj3MZoUi
         T32w==
X-Forwarded-Encrypted: i=1; AJvYcCWdgJXd2bW/B+t80oEm4AT9JyUC9/ESAVcenqomjqAZlm5wSZ1ShZwtrk3uS87BPQGvy9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ5TtICsZvFSXoZiEGmwuS9x0Eh9dyRcgDnvpFaNsIdZBcpThX
	ib+aOKuOGIigNEOFzt60SdymOa9M+5Tm3doCYuFUNpK/nr3XOzSmFDfmsgASGPpWOl9HWr8e5yJ
	SdHqBf+C24/nKcq1DB5/gtlh+usZMiFhq5XNE1cat
X-Gm-Gg: ASbGncuFulTP4yTCYHE0+o7p52pR9H7JKVk8PoTq7dVfCisLQwKX9gx3WGhiC1DnFnL
	yIETmAOwvsaCyOGDpPm6aV/8oaaonwQWR/PvoCu4wMq3I4uCVdM11rARf2FAV+XihIj+UF5mM0F
	iASiQ3bRvh047o9EQ94W/CMCsNUsVLojQUqIzuYNTRF1ikyr7jR4xwnwO4gq2pQmAYvNoMvavFa
	I6fwVbWrEyO6Fl1GMUla7wf5Pb+Tq2AAAHIcpZdmG4Rhp30Xi+MXEfh7qikF76DuUGzgoU=
X-Google-Smtp-Source: AGHT+IG10pMqFikx6RT/tqFrSskWIl05KHs+Ee/7So6I7n//cYDrDuZ+0tQc4Cge9MmUfj2dpGGMRK/SP0GpB1MqStk=
X-Received: by 2002:a05:6102:6c9:b0:5dd:87d8:b4d0 with SMTP id
 ada2fe7eead31-5ddc47cb960mr3853994137.36.1762816260026; Mon, 10 Nov 2025
 15:11:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107222058.2009244-1-dmatlack@google.com> <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
 <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com> <20251108143710.318702ec.alex@shazbot.org>
 <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com> <20251110081709.53b70993.alex@shazbot.org>
 <aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com> <aRIoKJk0uwLD-yGr@google.com>
 <20251110113757.22b320b8.alex@shazbot.org> <CALzav=d2w1Q4_P2AjfM0aantjtdKW_1jRUMprRQiC2SCk77ewg@mail.gmail.com>
In-Reply-To: <CALzav=d2w1Q4_P2AjfM0aantjtdKW_1jRUMprRQiC2SCk77ewg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 10 Nov 2025 15:10:29 -0800
X-Gm-Features: AWmQ_bmDZciMUKGHoSS8OLtj-UmPvjMnOPIRPcTeX7KbdqztKskzw8EnCLWnFe0
Message-ID: <CALzav=djghffsrexibhTK5AGsNe=QmHNfm-64NSP0OAGE+K6MQ@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 11:45=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On Mon, Nov 10, 2025 at 10:38=E2=80=AFAM Alex Williamson <alex@shazbot.or=
g> wrote:
> >
> > On Mon, 10 Nov 2025 18:00:08 +0000
> > David Matlack <dmatlack@google.com> wrote:
> > > AlexW, how much time do we have to get AlexM's series ready? I am fin=
e
> > > with doing (3), then (2), and dropping (1) if there's enough time.
> >
> > I'll certainly agree that it'd be a much better precedent if the self
> > test were initially working, but also we should not increase the scope
> > beyond what we need to make it work for v6.18.  If we can get that done
> > in the next day or two, add it to linux-next mid-week, and get Linus to
> > pull for rc6, I think that'd be reasonable.  Thanks,
>
> Ack. I'll send a small series with this patch plus a patch to replace
> iova=3Dvaddr with iova=3D4G, and we can use that as a back-up plan if
> AlexM's iova allocator isn't ready in time for 6.18.

I think we have a good chance to get the allocator series ready in
time for 6.18 (AlexM is quick :), so I'll hold off on sending a v2 of
my short term fixes.

