Return-Path: <kvm+bounces-69843-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mG8tOf+dgGl2/wIAu9opvQ
	(envelope-from <kvm+bounces-69843-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:52:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 77AC1CC81E
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B19D530157D7
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 12:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CBA1C3F0C;
	Mon,  2 Feb 2026 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fByy43pZ"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D4E54774;
	Mon,  2 Feb 2026 12:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770036728; cv=none; b=GReDQtDD2v0L9ZYTUSQNTXejJbbv3j2QWb/136zWjnNGRTCV7BSYLiALAmEgjWVjv4r+kDCjV4DvBoNZlprX803hEuMRrREApWrtGd2kfGS+FQHxFPFyLBw5VgSzGKLau5sbSg0NYnMhn+wRgkQZWu9C/Zb4PQXdSssQofe5OWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770036728; c=relaxed/simple;
	bh=lru2yyaiBhkqPmn0DEoUzd8wpXzMSS28OTVqgMEXZ8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRgGZUqsyFaOJxSfQX1HJNWIRkaI81o/IzQ04uzEKO5jygXMgdstHdxXgM+JNmBUGis64LJhQ4Njuq0LnoLI8HcBVRFTyZf3boCVJ3m064cBahYyh8NMux9Mf2GLrik4J0oJcZO6lowKic1r226+aQPH0KKnEEl2oC4l8xby4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fByy43pZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yY07cg0hwKCQwR25CLGXxidJIQ1squuIk4ZcGlGC93E=; b=fByy43pZRv6IaSc7ayvOokHhhm
	5nHBXvsWjBjdd/xvRrfB8JohvFI92kqsc+T8fxnQS8DspTZJBokZ+++dD2QJ673IPcJR7hMFjZagM
	5kEV22tYADCLkQLgG8je7md7HqxtQGwQC3REA1XhKC0+SbEKiFX7am6PwbUYOt7kZh5H/x57al9U0
	SvCvl0kh8/DdAI2aqGOlxbk6ddSWY79OoHHR7Vx6h4gkngqasafqwe28K7Mef5K6oZp8j+OxWfo8W
	hH4pWxQqtb/6uPMkNeFaRG4IkkrYkI9OytHqnVhhXbns4/mDpnHL/1qVI6GopYwxVNLXMp3h/E3ny
	uvrKmnWA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmtPA-0000000ETbd-13uw;
	Mon, 02 Feb 2026 12:51:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E0777300208; Mon, 02 Feb 2026 13:51:46 +0100 (CET)
Date: Mon, 2 Feb 2026 13:51:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69843-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[noisy.programming.kicks-ass.net:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:dkim]
X-Rspamd-Queue-Id: 77AC1CC81E
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 08:14:32PM +0800, Lance Yang wrote:

> > > +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
> > 
> > Pairs how? The start thing does something like:
> > 
> > 	[W] active_lockless_pt_walk_mm = mm
> > 	MB
> > 	[L] page-tables
> > 
> > So this is:
> > 
> > 	[L] page-tables
> > 	RMB
> > 	[L] active_lockless_pt_walk_mm
> > 
> > ?
> 
> On the walker side (pt_walk_lockless_start):
> 
>  [W]  active_lockless_pt_walk_mm = mm
>  MB
>  [L] page-tables (walker reads page tables)
> 
> So the walker publishes "I'm walking this mm" before reading page tables.
> 
> On the sync side we don't read page-tables. We do:
> 
>  RMB
>  [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)
> 
> We need to observe the walker's store of active_lockless_pt_walk_mm before
> we decide which CPUs to IPI.
> 
> So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.
> 
> That pairs with the full barrier in pt_walk_lockless_start().

No it doesn't; this is not how memory barriers work.

