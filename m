Return-Path: <kvm+bounces-45129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43963AA60F7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C20F7AF468
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F169C20D4E1;
	Thu,  1 May 2025 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vvw1f1nb"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9124F2045AD;
	Thu,  1 May 2025 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746114665; cv=none; b=cn+t00PWne9+QunekA65rTmH8ySSyhV2SChyGEd6pb0Vl0f1cfeByxGVhyRDkHCCGWfYUlZbDegaF7Rd4jcRC+Emfqg8ihEZkaPlkq5ABl47UJamvWkayP2Tl/sOszSiazbin71yOh/cIx2VUbZBvjww6tZWx5B+RbC3svX+A10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746114665; c=relaxed/simple;
	bh=P3VRTKEBNLquqRhFZYT5aVzDoqfQbBS2lj2/Gfm1dd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+csb2EvG4omLqV+RSBICk21IOsq1QQalox5TOATTEQU9tJDtKotCU9mQeUI67dKt/i8jCBWLGwbyUo54RXzZ2sZaJEIZAsMujO+003Z7e19lPLYkdhtpyTFEZy0nxdPXHo6hDQgLaBRsbKDB0ILgzqzhWTeyxhJud3CsHK5UA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vvw1f1nb; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P3VRTKEBNLquqRhFZYT5aVzDoqfQbBS2lj2/Gfm1dd8=; b=Vvw1f1nb4tZTNYWo7mO6z9pHzV
	MDmnoqAqu2hmb0i0BZCMhG/WDMQlC58Cw73kwpES9YsUR9uVYBATrwEJOHRNIo/+tiKLtb+lnOGfX
	3RQDTcQJHo8yw/zOwlj2RzWNFYXhC2VQIUF/gJjLBZWYPMdo4SndGy1x8v2X1nLPEmzP9XY04eDER
	6wiFSA1LKBYitCkX2q34LCGcLleraMkw5CpiczInfDqlRcnA1DkoaezY3MLQ7ZnDpb3tBsrvLAH0S
	h83K01vh+L05Z2s0lZBeMEnAZ2cFAgQ3S5nprdKJg8w8nz2cckeve7tiH0FBgOln3Yo1AMJl2OmyX
	jjUfpXpQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAWBP-00000000vWm-1k5y;
	Thu, 01 May 2025 15:50:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 04927300642; Thu,  1 May 2025 17:50:43 +0200 (CEST)
Date: Thu, 1 May 2025 17:50:42 +0200
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
Message-ID: <20250501155042.GR4198@noisy.programming.kicks-ass.net>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
 <20250429123504.GA13093@lst.de>
 <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com>
 <20250501150229.GU4439@noisy.programming.kicks-ass.net>
 <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>

On Thu, May 01, 2025 at 03:22:55PM +0000, Brendan Jackman wrote:

> Whereas enlarging the pool of functions that you can _optionally target_
> for tracing, or nice reliable breakpoints in GDB, and disasm that's
> easier to mentally map back to C, seems like a helpful improvement for
> test builds. Personally I sometimes spam a bunch of `noinline` into code
> I'm debugging so this seems like a way to just slap that same thing on
> the whole tree without dirtying the code, right?

Dunno, I'm more of the printk school of debugging. Very rarely do I
bother with GDB (so rare in fact that I have to look up how to even do
this).


