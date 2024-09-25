Return-Path: <kvm+bounces-27460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 416D6986454
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44A63B23187
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16B97581F;
	Wed, 25 Sep 2024 15:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="QC6DhPC+"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482752F76;
	Wed, 25 Sep 2024 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727277305; cv=pass; b=EJitmFZiAfGUhM0V4T28ePTYVfkzqfMK/g+B+Vy0h+4fhHd9WPUBjN2g1NNlGKtR+O4msMKzay7cXQqxfifdcG2pFnkVLeH7AlzqiLl+1gWJTuDGeUe3FMy85QjvHOnxmeZ7ja9148ic1I8qnkW1jp+V8zEyBfxQTOqHrnZ8qk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727277305; c=relaxed/simple;
	bh=VM/YYffBWkguWTHJS2ZypByDinCPYMqILQPCR+ZVSNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XK4MQOP5SgTiqEabiJnL5jIkGPT/T86ZQd3uCAruDazAq3+d4irZw437IxAXxJkBgFeRq0SD8KutcMXiEiRqun2PIy5xXbtbd7v8RMkNfMrkMbBLivjgbmGttAR5n+L1BF4qikWTAohvVbTi38ETOprPyqUlmVtGAKnOhD06oLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=QC6DhPC+; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [96.47.72.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4XDKzB4mRwz4K5k;
	Wed, 25 Sep 2024 15:15:02 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [96.47.72.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4XDKzB3dNZz4NQH;
	Wed, 25 Sep 2024 15:15:02 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1727277302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ2gwEj7+IQtC9Il0Y7ZgRAIbHvah9E9o2WhQEI5lc=;
	b=QC6DhPC+Fa32OFil9l2pEimeAzgo6mYg9N6fjyvjBnbvg3GQRJPVQSymBs5LSv9A0vTPYi
	ovyAW2X3CwP/JTRSMdo/os3ZztkTs287jZa0ZLXL0qA29qPG75KVNOnc8Nt69iN9lDenc6
	XsJCSFwLmLYZiiilTugH8bkH1KwlX/Y6BaWZevksOyLCKesFFm2JaQ2HdrVNsED2A85yT0
	W8dFWYDBPoWvmRXJmNuX7L4/bKiYJz1gefFqHEIw6GEX2KzDMScqGXvwWJa3s7PzAdH4M7
	lP9KQMny/A9ILiRFgW2RG143Oh4qz6oxJq0RCsWcJDBLt4gQwL4E40Bpcc7k5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1727277302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ2gwEj7+IQtC9Il0Y7ZgRAIbHvah9E9o2WhQEI5lc=;
	b=PmYz6sxd3J/oDN4eJCdOOgbyCylKcpXc11DPggBw3QcfN1hGAq1OBoPAdOi28yuLCXSA5q
	vaYViKgnpFCXkP0hH1miq1hiA3IT8kATi8OaSCuKFu0EdIndv10UgWn1HH/6NqS6nSnD9K
	z/F6TTwMUw75On1QyWf7mSCbpuMwVma3nCpO/sR/+4ymdMCINl9FkcmpB9k1/UQNn3F9JO
	PRDStVrFeBdEu4ls/i11K6XM1TKZUHlwKZVEkFRNrnFhC6aMzpE8Bw2hkpy3zfurhZpQyX
	q05YwGmfZT/j5CkpKPhhKLIEDhghLStOt57zS7Hi4ijfr1k7WY5XPGMLa0PVdw==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1727277302; a=rsa-sha256; cv=none;
	b=E1oSMUz8fCyKpiwrPeIox5gtDyLvZF2+LDC2U9y2XQ1c2fvAwRSv+SocX39mTPynnlpqjK
	CJAcWW8Zps2xmxvf00UTePQy+at2dQ8SW/O+J4w4QR2sGXXa9pZ3hwzKAOUXkS2t52wYnc
	sjvFZM/4xgndC5okLYdvZNiQxJn24RrqwtfrmhAB8VS/svR07x/HWzA0PCWuK5rUJ1nQUm
	OIaJ7RJV512QkLtXve0qPZbmetRBnsocd2zquslLtVXb7dT4v6E4+UYLl6nIHPhU6P+V2y
	x6oyjFsQwp78j/13UQ9xCdBkHyZpdAKO2PzSIm4m6z0AdcOa8ejoOnqU5+/G0A==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id 74228E953; Wed, 25 Sep 2024 15:15:02 +0000 (UTC)
Date: Wed, 25 Sep 2024 15:15:02 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com,
	vineethrp@google.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Srikar Dronamraju <srikar@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] sched: Don't try to catch up excess steal time.
Message-ID: <ZvQo9gJgTlZ3nB03@freefall.freebsd.org>
References: <20240911111522.1110074-1-suleiman@google.com>
 <f0535c47ea81a311efd5cade70543cdf7b25b15c.camel@infradead.org>
 <ZvQPTYo2oCN-4YTM@freefall.freebsd.org>
 <c393230b8c258ab182f85b74cbc9f866acc2a5a2.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c393230b8c258ab182f85b74cbc9f866acc2a5a2.camel@infradead.org>

On Wed, Sep 25, 2024 at 03:26:56PM +0100, David Woodhouse wrote:
> On Wed, 2024-09-25 at 13:25 +0000, Suleiman Souhlal wrote:
> > > 
> > > I'm still not utterly convinced this is the right thing to do, though.
> > > It means you will constantly undermeasure the accounting of steal time
> > > as you discard the excess each time.
> > > 
> > > The underlying bug here is that we are sampling the steal time and the
> > > time slice at *different* times. This update_rq_clock_task() function
> > > could be called with a calculated 'delta' argument... and then
> > > experience a large amount of steal time *before* calling
> > > paravirt_steal_clock(), which is how we end up in the situation where
> > > the calculated steal time exceeds the running time of the previous
> > > task.
> > > 
> > > Which task *should* that steal time be accounted to? At the moment it
> > > ends up being accounted to the next task to run — which seems to make
> > > sense to me. In the situation I just described, we can consider the
> > > time stolen in update_rq_clock_task() itself to have been stolen from
> > > the *incoming* task, not the *outgoing* one. But that seems to be what
> > > you're objecting to?
> > 
> > This is a good description of the problem, except that the time stolen
> > in update_rq_clock_task() itself is actually being stolen from the 
> > outgoing task. This is because we are still trying to calculate how long
> > it ran for (update_curr()), and time hasn't started ticking for the
> > incoming task yet. We haven't set the incoming task's exec_start with the
> > new clock_task time yet.
> > 
> > So, in my opinion, it's wrong to give that time to the incoming task.
> 
> That makes sense. That steal time is actually stolen from *neither*
> task, since it's after the 'end' timestamp of the outgoing task, and
> before the 'start' timestamp of the incoming task.
> 
> So where *should* it be accounted?
> 
> Or is it actually correct to drop it completely?
> 
> If you can make a coherent case for the fact that dropping it is really
> the right thing to do (not *just* that it doesn't belong to the
> outgoing task, which is the case you make in your existing commit
> message), then I suppose I'm OK with your patch as-is.
> > 

Yes, that's a good way to put it: The excess steal time isn't actually
being stolen from anyone.
And since it's not being stolen from anyone, isn't the right thing to do
to drop it?

There might still be extra steal time that doesn't exceed the current
'delta' from the race between reading the two values, that would still
be erroneously accounted to the outgoing task, which this patch doesn't
address, but we know that any steal > delta is from this race and should
be dropped.

-- Suleiman


