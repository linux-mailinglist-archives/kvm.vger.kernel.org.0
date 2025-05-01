Return-Path: <kvm+bounces-45102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F4AAA6067
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FDF2189BAEA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F68F202F9F;
	Thu,  1 May 2025 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QE9K7S0F"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41321EA7C6;
	Thu,  1 May 2025 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111791; cv=none; b=A1NB3QJuSlt0AQJcIAzD5Glj4GSf98aU4GhqvCEBi9zz/UQ/v3vlbQl75P/LWG3EFuuXHRy2XnBKrZ6KQF3tIKpxURGOumJ3nyWyqS8zTo/GUqEeWFwZEbsjq0wo17l0W7GFY8VJkuQhXmsw1/P6PMMZKcSwRKirm3FTa4ylEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111791; c=relaxed/simple;
	bh=4ySaPdEMd4+Vb4yQ+0YUSkKNLjFLCkYhYBoAAExMs3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkA40cvOe/OtEv8hBUGlPDxu68SZALFpXB3HobIqYdNeHwgSfoTWLTJZ5JUaYhONFPxWvst8EFgVOjLN10UQWtklOi2tY02YJ5IR9q9NZJ1UFQwpGz/Bl1d7ChOcc8FtSc0eCQ0qGX8rybZc9CV1WKY1Ja0eSpow47+EvI3u3GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QE9K7S0F; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SknNweDJMYv6Cc7JXUCuginAJHi4T0ZKllMpOn1Yf9A=; b=QE9K7S0FqJXdRMiI2MUQfyFVKN
	zJkaOZZAvX0UK9xBOJnD6xr1oo4dLko0vESRIIkP4sjHHPxZkleb2D8Zai321exEYA2JJr82ElX7s
	y72vsCa48dbNhj3sR2u6AvvpDc6GUftTpqrd7fLDiVr8l4ZJcPOvCc/B4Kso/X5VwtY001koeorb7
	w0lpR1LpdbzQwtNNGzQXqNnli6Sbl3pH+QAdCVePhkf3FUFd/ngVNiv41q8dPOdm8t1mbTM/UmJ5P
	NuryBBTCcNBBOjT/+JRWnUfQQL+DhMwA+igl0308JTBNEPRBnnqN+OImNHFtw2Imib6YH9ERSKUcP
	cmUpe09A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAVQk-00000000oH8-33tB;
	Thu, 01 May 2025 15:02:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1B7DC30072F; Thu,  1 May 2025 17:02:30 +0200 (CEST)
Date: Thu, 1 May 2025 17:02:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Christoph Hellwig <hch@lst.de>, chenlinxuan@uniontech.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org,
	llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>,
	kasan-dev@googlegroups.com, xen-devel@lists.xenproject.org,
	Changbin Du <changbin.du@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC v3 0/8] kernel-hacking: introduce
 CONFIG_NO_AUTO_INLINE
Message-ID: <20250501150229.GU4439@noisy.programming.kicks-ass.net>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
 <20250429123504.GA13093@lst.de>
 <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com>

On Thu, May 01, 2025 at 02:19:47PM +0000, Brendan Jackman wrote:
> On Tue Apr 29, 2025 at 12:35 PM UTC, Christoph Hellwig wrote:
> > On Tue, Apr 29, 2025 at 12:06:04PM +0800, Chen Linxuan via B4 Relay wrote:
> >> This series introduces a new kernel configuration option NO_AUTO_INLINE,
> >> which can be used to disable the automatic inlining of functions.
> >> 
> >> This will allow the function tracer to trace more functions
> >> because it only traces functions that the compiler has not inlined.
> >
> > This still feels like a bad idea because it is extremely fragile.
> 
> Can you elaborate on that - does it introduce new fragility?

given it needs to sprinkle __always_inline around where it wasn't needed
before, yeah.

Also, why would you want this? function tracer is already too much
output. Why would you want even more?



