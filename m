Return-Path: <kvm+bounces-49399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 945AAAD8553
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91EA03B77F4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31AC26B76A;
	Fri, 13 Jun 2025 08:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RckmzAuk"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBA92DA75C;
	Fri, 13 Jun 2025 08:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749802622; cv=none; b=DV/u1H2LSDLvSWanuCIrEFrwtzcTKJ1GRhMIvjBvY9cnJuQucbHQSasofX7AldKvVqeC4w8+x7y7Zb8asIw3RW5UX1LFZJPY+BeMi8cll+WkMRRtkZHiDlYXd3Adi8mEzoHP9LBTBTow+URWAspAGFuLiTvmcaZ6SlC6FFdTAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749802622; c=relaxed/simple;
	bh=H4deeWKRL6AgEikg2A95hz/5EWAQbTQHXmoiGwW6PN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aqcj5pN6JG9UviMVnJj15FQMyMY7ybqHtXCdd+vhp3avei5yeTYLA4hiLxrhCa9sfxRQngAmnJKmjkv8yzKJ1+AspQpymNTcGMyXP+RxhzlafpIyzKy8vws6+yqgyE9uVLy3m2cThisYhTjybsnHbpgOj6tRS6GXGM4ObAsLSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RckmzAuk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yaQiofcaLiQxJiuWGi7UrpBvMseIMqRXIHUvBXcjvqI=; b=RckmzAukmizQjC4JKkpf3G2KmE
	K1FswB8504q+tScQCsNozZLRkf3uhhiz0eduogrXGANH9dcFn5dDZqmkzc90m+zYt5IIWmkIRU0Pz
	9G0gv8GN3wBmc+3vHtN9IuheHgSAmxhd9PcfKZzAygvdIG50ZuGX2ilS904v6X/++U1bI2kZXAefa
	NoF0wKOiYQhopCRYmPi4p8z5EJ/qygGwTemWZ7ZXy9YHWPs7WkzFyaTJ8nY5aTjjCviKIkc+5gWIZ
	YLFtq9HgOtOK7Z/YZnR4nuJVZSBlfpMmLlZgpIQyn2WiXeKYYOC9LAr0kc78FS0ShYqe/CVXVWvwX
	c0MzlFyg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPzab-0000000Cj1f-2CZL;
	Fri, 13 Jun 2025 08:16:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F21F6308637; Fri, 13 Jun 2025 10:16:10 +0200 (CEST)
Date: Fri, 13 Jun 2025 10:16:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, brgerst@gmail.com,
	tony.luck@intel.com, fenghuay@nvidia.com
Subject: Re: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its
 architectural reset value
Message-ID: <20250613081610.GK2273038@noisy.programming.kicks-ass.net>
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613070118.3694407-3-xin@zytor.com>
 <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
 <f5ceeceb-d134-4d51-99d1-d8c6cfd7134f@zytor.com>
 <310B2567-8680-4E1D-B1BB-A56809466ED4@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <310B2567-8680-4E1D-B1BB-A56809466ED4@zytor.com>

On Fri, Jun 13, 2025 at 12:59:04AM -0700, H. Peter Anvin wrote:

> Incidentally, do you know the following x86 register sequences in the proper order?
> 
> ax, cx, dx, bx, sp, bp, si, di, ...

Yes, I get annoyed at that every time I decode regs :-)

> al, cl, dl, bl, ah, ch, dh, bh
> es, cs, ss, ds, fs, gs

These I don't know from the top of my head -- I've not had to use them enough.

