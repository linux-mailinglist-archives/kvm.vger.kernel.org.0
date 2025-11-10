Return-Path: <kvm+bounces-62546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2200C48765
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCF193BC2A7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5789B3126C5;
	Mon, 10 Nov 2025 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x7bLVTj+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D883C30E0F1
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762797617; cv=none; b=EuvQTK03TlJw9hXVc2ywAZ5ukrE3nbTrYIXdYTPLON4qEuQwtSskjObF3MwVCafgeA/JDexXtbXT3IaJHmB//M4h08OtYLG99iO2IkDBhmYyRt3kuKYDJBUqIVfVtJ8g7JkCseYNFly+qJL1Z2VG96q4H59oup8RJH+ZN86+RmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762797617; c=relaxed/simple;
	bh=KwuE+ykLsSfJxVQf+roHLrsfTjhhdraAQZQgmO9Zpis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCj9lTsJdr1SxHAerNcVgWAuqIfWwJ3EBW1p3GmKc9WwT2hOW2iUPD5lI3PVIdiuomd98lYQCNibkrGT9RVD3rLoc7tl8Zqmn6Z3nieVaQm1QsaL7OuvyiRzAf6IU/j5JH/WPIWOz0d7BYs301wo2lhGvW8BHx22+cH89WXZoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x7bLVTj+; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ba4874edb5dso1930764a12.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762797615; x=1763402415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+FBIbgU0RyCEeb40QXmq/ArKKF8QIQ0Sqmp8yKewW4=;
        b=x7bLVTj+iCgK/Fe62ucqx5BolWgfQvglm3RL2dOwWz/9muopZ26z+GQpBF+T/txcLf
         gA44Af62QyjSGmOdYZ4pn3YTKJ47sAz8BCW7YiWOjilIznoQuHSIIL61qZescNFpmf/q
         um5tN/swHj+jqK1QSXouNbzE+txiuN45pI11B3n9Jc8X3Y1W6vM8BhKDySDX4pKtOJN5
         orzgz94SB7XTXy8Q8gUCnK3kV7UM7Ix/6E2vr5seG9Ty6nxr5+kwphPq9rp1bG2iNCxY
         6wPN8Frtz1S5f9kCNapK+Voi4sUStgzNiiQwLiZwoAehgHi+i5P/DdY3Qid7VMlViTyF
         Gadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762797615; x=1763402415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+FBIbgU0RyCEeb40QXmq/ArKKF8QIQ0Sqmp8yKewW4=;
        b=LcYwPYINWKTS4HvwLnO5NbSjwvJInXQ8JTkxjKvrvFXTI22YV22VTxwQ0rcJmv0dxS
         hx2aGu2ll+Z4dbk8oTT6wpa54F35sH7TNtr7pOT/cXF1wSBOMB355xRuewJ392kb262F
         /tHYpifDh67E4ImjuAfZkjbVjtSG1qOT/5XzDyewNzAWDEjKeQ0byf7C7E9q5x9f8iP3
         KZsj/kaEedXRYmxf47GKTRaoWi+vNhUh42ycp/bFUyAXKAnQPTEM2jLyHKK7+m3Cl4Tf
         ozKOkVoTs5+jh70drfsgg5gJK7FZ0af2AtE8YosfxCc+RW4+7m5pdN9qbgX7Jf0sm1vU
         mKdA==
X-Forwarded-Encrypted: i=1; AJvYcCWjiYypQIsxXFVODDU2gclclspy5fuOPx8yWwas/qMJHsf6Gd/bDQmMRIBtcFAzj+neX14=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhtYjGTUHKSi/lSIxrh18jDAqB9Dr0LVb3rz6tC5EorjaD9qYi
	FQXtI74+a6XBMvq9JFcz3tdhkWawv32I66a+QsGzA5I+bq9xbTkRJbSO8d+H3PdLQw==
X-Gm-Gg: ASbGnctWAeP24KcM8VSwxwg39ppOGJhv4mzwW00NWfc46RXr9GSp78c3rY3IL5H1ZdX
	erGL4sSZGbG2g8LZ0S5+6jMjrjsh0zSmUM9JlvuVhOHYYCjs1nqYm8GoT4JY2FvAfKn+3YhNzv1
	DASOQ7BKeB2OppZtem07gRIe1jkyM5qxTsrnmYYB1Eeym7dHv0J6C+zDrwfL32+EYlK751V5EFC
	LzjYCHDhOUn1yMjUc3x69AEH3rU9RwUqFUjc9BzpnpVoLrw8Gdcy9kUyYq8+Mb+4HoyKAxpRNlB
	KJpAQDtQz4WHsU+uWn2J2JQ9POO9Ls6jHoe0c9pidB3KMcIcFIpiOVF5OdwNGNXr6rT77eGeb3H
	2ZujdOonbfmKD/SEu9sIgH2aGE7RIiiRQzqrFmJqA9a5hH5y7Q6kGX6tZ5mqTnjT7arVnzQWrBM
	sArTkhZQbkQfL1u/teSbldmy1NZbCmQvG42g7nLYwU+dRF47jftV9U
X-Google-Smtp-Source: AGHT+IGHjoAS8C7KWE16K0e/KgayTVCcNPeK4+yxSxPn5qtvVWpUg17vAs36VrEJDIpQyCGi1271fA==
X-Received: by 2002:a17:902:cf42:b0:295:8da5:c631 with SMTP id d9443c01a7336-297e56ce70bmr113736165ad.42.1762797614242;
        Mon, 10 Nov 2025 10:00:14 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2983e3161a5sm7922865ad.110.2025.11.10.10.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:00:13 -0800 (PST)
Date: Mon, 10 Nov 2025 18:00:08 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
Message-ID: <aRIoKJk0uwLD-yGr@google.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
 <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
 <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
 <20251108143710.318702ec.alex@shazbot.org>
 <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
 <20251110081709.53b70993.alex@shazbot.org>
 <aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com>

On 2025-11-10 08:48 AM, Alex Mastro wrote:
> On Mon, Nov 10, 2025 at 08:17:09AM -0700, Alex Williamson wrote:
> > On Sat, 8 Nov 2025 17:20:10 -0800
> > Alex Mastro <amastro@fb.com> wrote:
> > 
> > > On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:
> > > > On Sat, 8 Nov 2025 12:19:48 -0800
> > > > Alex Mastro <amastro@fb.com> wrote:  
> > > > > Here's my attempt at adding some machinery to query iova ranges, with
> > > > > normalization to iommufd's struct. I kept the vfio capability chain stuff
> > > > > relatively generic so we can use it for other things in the future if needed.  
> > > > 
> > > > Seems we were both hacking on this, I hadn't seen you posted this
> > > > before sending:
> > > > 
> > > > https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u
> > > > 
> > > > Maybe we can combine the best merits of each.  Thanks,  
> > > 
> > > Yes! I have been thinking along the following lines
> > > - Your idea to change the end of address space test to allocate at the end of
> > >   the supported range is better and more general than my idea of skipping the
> > >   test if ~(iova_t)0 is out of bounds. We should do that.
> > > - Introducing the concept iova allocator makes sense.
> > > - I think it's worthwhile to keep common test concepts like vfio_pci_device
> > >   less opinionated/stateful so as not to close the door on certain categories of
> > >   testing in the future. For example, if we ever wanted to test IOVA range
> > >   contraction after binding additional devices to an IOAS or vfio container.
> > 
> > Yes, fetching the IOVA ranges should really occur after all the devices
> > are attached to the container/ioas rather than in device init.  We need
> > another layer of abstraction for the shared IOMMU state.  We can
> > probably work on that incrementally.

I am working on pulling the iommu state out of struct vfio_pci_device
here:

  https://lore.kernel.org/kvm/20251008232531.1152035-5-dmatlack@google.com/

But if we keep the iova allocator a separate object, then we can
introduce it mosty indepently from this series. I imagine the only thing
that will change is passing a struct iommu * instead of a struct
vfio_pci_device * when initializing the allocator.

> > 
> > I certainly like the idea of testing range contraction, but I don't
> > know where we can reliably see that behavior.
> 
> I'm not sure about the exact testing strategy for that yet either actually.
> 
> > > - What do you think about making the concept of an IOVA allocator something
> > >   standalone for which tests that need it can create one? I think it would
> > >   compose pretty cleanly on top of my vfio_pci_iova_ranges().
> > 
> > Yep, that sounds good.  Obviously what's there is just the simplest
> > possible linear, aligned allocator with no attempt to fill gaps or
> > track allocations for freeing.  We're not likely to exhaust the address
> > space in an individual unit test, I just wanted to relieve the test
> > from the burden of coming up with a valid IOVA, while leaving some
> > degree of geometry info for exploring the boundaries.
> 
> Keeping the simple linear allocator makes sense to me.
> 
> > Are you interested in generating a combined v2?
> 
> Sure -- I can put up a v2 series which stages like so
> - adds stateless low level iova ranges queries
> - adds iova allocator utility object
> - fixes end of ranges tests, uses iova allocator instead of iova=vaddr 

+1 to getting rid of iova=vaddr.

But note that the HugeTLB tests in vfio_dma_mapping_test.c have
alignment requirements to pass on Intel (since it validates the pages
are mapped at the right level in the I/O page tables using the Intel
debugfs interface).

> > TBH I'm not sure that just marking a test as skipped based on the DMA
> > mapping return is worthwhile with a couple proposals to add IOVA range
> > support already on the table.  Thanks,
> 
> I'll put up the new series rooted on linux-vfio/next soon.

I think we should try to get vfio_dma_mapping_test back to passing in
time for Linux 6.18, since the newly failing test was added in 6.18.

The sequence I was imagining was:

 1. Merge the quick fix to skip the test into 6.18.
 2. Split struct iommu from struct vfio_pci_device.
 3. Add iova allocator.

AlexW, how much time do we have to get AlexM's series ready? I am fine
with doing (3), then (2), and dropping (1) if there's enough time.

