Return-Path: <kvm+bounces-11703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3BA879F8B
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588FA1C21048
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 23:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED2C47768;
	Tue, 12 Mar 2024 23:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJbE9yie"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C968467;
	Tue, 12 Mar 2024 23:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710285196; cv=none; b=Q6BI/qjHlwi2S7p33TIeb9MMgxXHNIwHM5vhVUOkFWFbH0s5z240IMq0rYJ2WrE4gl5Dmv/S/k+JOd7v6I6WhrjDPOvQByZTe+8yRDLf49bGAWmKGCYOCFjiGGGs8kTSlgJgT0P9x3egyWorWqXr3Wbn3YXiuS+odQnJKfE4f14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710285196; c=relaxed/simple;
	bh=7NwAqzcbnrvXpLI+g+cYC9rPgqiwHgqcCGd321u9IaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFoELQB+yUG3Yls+gMJ0ih2f90A1y6ITS6vxUKYxfOD8gymiNCZJEV+YSVcRd0EBAoZp+/hdRLpBP9Cm+x7F6HaB87pCzBRElkduLl753zq+FngWiiO3vwSspg/IhygVLaWKWnnDECK6kXd3rVV+5PgVLoc7sT+f4jO9nNWEEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJbE9yie; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6D6C433C7;
	Tue, 12 Mar 2024 23:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710285195;
	bh=7NwAqzcbnrvXpLI+g+cYC9rPgqiwHgqcCGd321u9IaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJbE9yiePEehho9goUJFvFbQiYTBmie9ybqS8PYl4CbfH4mGo7nZBFYiJVzhXDH/h
	 r0DB0A0X4I/37xQkdTbGWom5qNLYBUo4/wlMwrCTZUiQMDr5GvSxFWOCWIRXxfubFA
	 U06YJHKHBhw0Y/AkpM765vfubCmIE2rSxbzWEllVKkOy8qm5tcRGwZnxZO2ogeo5qK
	 vnpEbwxLh5NfLOV6lgkl3ebeb1ChaA8BXCtq0oVLJt7yjgatR6GE813/yIlEKOSkQ0
	 DShnQjxKoV7Y5kEs8leNLcQmAFLsSv1EkFwwHtfEYwJY9cXc1gtRsia8KRlIYnzOmb
	 y/LGfMFvIkXVw==
Date: Wed, 13 Mar 2024 00:13:13 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: jalliste@amazon.co.uk, mhiramat@kernel.org, akpm@linux-foundation.org,
	pmladek@suse.com, rdunlap@infradead.org, tsi@tuyoix.net,
	nphamcs@gmail.com, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	pbonzini@redhat.com, seanjc@google.com, paulmck@kernel.org
Subject: Re: [RFC] cputime: Introduce option to force full dynticks
 accounting on NOHZ & NOHZ_IDLE CPUs
Message-ID: <ZfDhiakZWIYGSUTl@pavilion.home>
References: <20240219175735.33171-1-nsaenz@amazon.com>
 <CZR39LW50A9F.1DWG2FYJ3OZP8@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CZR39LW50A9F.1DWG2FYJ3OZP8@amazon.com>

Le Mon, Mar 11, 2024 at 05:15:26PM +0000, Nicolas Saenz Julienne a écrit :
> Hi Frederic,
> 
> On Mon Feb 19, 2024 at 5:57 PM UTC, Nicolas Saenz Julienne wrote:
> > Under certain extreme conditions, the tick-based cputime accounting may
> > produce inaccurate data. For instance, guest CPU usage is sensitive to
> > interrupts firing right before the tick's expiration. This forces the
> > guest into kernel context, and has that time slice wrongly accounted as
> > system time. This issue is exacerbated if the interrupt source is in
> > sync with the tick, significantly skewing usage metrics towards system
> > time.
> >
> > On CPUs with full dynticks enabled, cputime accounting leverages the
> > context tracking subsystem to measure usage, and isn't susceptible to
> > this sort of race conditions. However, this imposes a bigger overhead,
> > including additional accounting and the extra dyntick tracking during
> > user<->kernel<->guest transitions (RmW + mb).
> >
> > So, in order to get the best of both worlds, introduce a cputime
> > configuration option that allows using the full dynticks accounting
> > scheme on NOHZ & NOHZ_IDLE CPUs, while avoiding the expensive
> > user<->kernel<->guest dyntick transitions.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> > Signed-off-by: Jack Allister <jalliste@amazon.co.uk>
> > ---
> 
> Would you be opposed to introducing a config option like this? Any
> alternatives you might have in mind?

I'm not opposed to the idea no. It is not the first time I hear about people
using generic virt Cputime accounting for precise stime/utime measurements on
benchmarks. But let me sit down and have a look at your patch. Once I find
my way through performance regression reports and rcutorture splats anyway...

Thanks!

