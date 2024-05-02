Return-Path: <kvm+bounces-16405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6411A8B9763
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 11:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A8BE1F235E9
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 09:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAC453E20;
	Thu,  2 May 2024 09:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VlFbWNta"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52364524D4;
	Thu,  2 May 2024 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714641387; cv=none; b=UVIl49wCeM72CAUPVSD5cJwdz3T01f8mwdmO2r+c/U606WIHP8GEh2vJa6r4/Ij3g9K/qQ/UMvs/e9nQbghhf7lG6Bm3jlg442dOLaRBMcXI/SUC5mwVZ8VG95vw0DmeSDoTIQhqjmOCVV/eqOdS5LllRVKVvYKdH7AFEI/55RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714641387; c=relaxed/simple;
	bh=XpgtUboWUY4K6D8ln7r4Kd9Dv08JhYX+E7YkIpI3eo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyt4LOdExWE8Avd3+POYrvR/y0GPC41Z3W2GKnpRx7elJRued7kdvymIH7Stm/BTpVxMK4/wC5vDe/lCQyb4eM9dX1cv6wXNxvkoWq6zNETorC5GgVsIa552EqPiQJyBN3rhsfMohRXOFo69hCi7e4z11/92ieJQmCg70T8H18E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VlFbWNta; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zdfrErG2WKK57Kqg0tDJeJKezf1hsqRf679zsJ01Sx8=; b=VlFbWNta+BWffxnbEWRjYv+8ar
	0mSAZEi/5K7GE5WmbbDT+r4ARA9iQeFFKkzCACPe/gwvSf/LmUcAlJNX/ZoW8bwgnYR9QDAGNKCRl
	LzUKo6XjLhjBfyI4SmA0ITYpIXJydjEMOIR5DsW+FpCgValTn4WKP1/mCF21xbM9WHcwZgrRyRpU3
	FiEPtEuWLxgIvsZuc6BZmNuqB9C27xGU6sZ+HHCefx17Ax1NXRdpTkAdW+Lul7YwDGf4y9Ll5M8Pf
	tKmEV2OKo3OjFdHTXGjEEinxeVzjqku1MmncoJ0aeBuJXe50y5tEKJEF/VvmaENEvgQqxyQgc0DNI
	6DxwtawA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2SY5-00000001KYe-3aFr;
	Thu, 02 May 2024 09:16:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 82B8B30057A; Thu,  2 May 2024 11:16:17 +0200 (CEST)
Date: Thu, 2 May 2024 11:16:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tobias Huschle <huschle@linux.ibm.com>,
	Luis Machado <luis.machado@arm.com>,
	Jason Wang <jasowang@redhat.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	nd <nd@arm.com>, borntraeger@linux.ibm.com,
	Ingo Molnar <mingo@kernel.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20240502091617.GZ30852@noisy.programming.kicks-ass.net>
References: <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
 <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
 <20240319042829-mutt-send-email-mst@kernel.org>
 <4808eab5fc5c85f12fe7d923de697a78@linux.ibm.com>
 <ZjDM3SsZ3NkZuphP@DESKTOP-2CCOB1S.>
 <20240501105151.GG40213@noisy.programming.kicks-ass.net>
 <20240501112830-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501112830-mutt-send-email-mst@kernel.org>

On Wed, May 01, 2024 at 11:31:02AM -0400, Michael S. Tsirkin wrote:
> On Wed, May 01, 2024 at 12:51:51PM +0200, Peter Zijlstra wrote:

> > I'm still wondering why exactly it is imperative for t2 to preempt t1.
> > Is there some unexpressed serialization / spin-waiting ?
> 
> 
> I am not sure but I think the point is that t2 is a kworker. It is
> much cheaper to run it right now when we are already in the kernel
> than return to userspace, let it run for a bit then interrupt it
> and then run t2.
> Right, Tobias?

So that is fundamentally a consequence of using a kworker.

So I tried to have a quick peek at vhost to figure out why you're using
kworkers... but no luck :/

Also, when I look at drivers/vhost/ it seems to implement it's own
worker and not use normal workqueues or even kthread_worker. Did we
really need yet another copy of all that?

Anyway, I tried to have a quick look at the code, but I can't seem to
get a handle on what and why it's doing things.

