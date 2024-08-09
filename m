Return-Path: <kvm+bounces-23741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2636C94D5E7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD5FF1F21C4C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2D4145B25;
	Fri,  9 Aug 2024 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpghzWq7"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A88C13A260
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723226266; cv=none; b=ED66lgoM2aHHylFwiWDkdjtRA1Hd6fROGnJ/6/4ErVkEzM2/MLoY6XtKeu8rHHUBhg91B6PhfWZRV/g+PIIK1H/vg70AngfK5YRr6Dsl/OxSYr+Yo3zFx/A/9SmGRd/Ta6gfspA8xiST9hCDa/WaO3BXWhsXzI/xPgNqWUkjRaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723226266; c=relaxed/simple;
	bh=M3I/44k+uR5m7epeM37cjY4gzbwANuK8YqLBOrSkVB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGRExPSPx31CCY0Q877XnNZsgQAfv9sk7/nnUY+N/CimRvgsHAH5+N6hZWxuCEx9f/YqZSKLG9kUBt5sF1Fi8eJgX38/KM7V8raXVQ54PdRgD/ll3Z9KstZwgkWQJ9yySj7Iv0G9859sYhpaPyASVpczf+fOqTjvLoAmd1oxick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CpghzWq7; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 9 Aug 2024 10:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723226262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCB95XDzz6j5az3tqR2K6rgl2D1WFAaOInOOblCkU54=;
	b=CpghzWq79A+GWWU1TpKng7AfD3bm/rGpsuk2q3JE5z3uW9ha06y3bZc3aHJqCUN6/ltP1f
	X6lycKrYMXJHCtCNxVTw+f8WXJw0IpfeNuL0Bm5Cq+voqEYkZZ1tGO4/rD9wWwcMQUKdeq
	44rNXpxK//B4aq16MD25e2IypYB2EF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for
 KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZrZYkCIK3oW47Suq@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev>
 <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
 <ZrJ9DhNol2pUWp2M@linux.dev>
 <ZrOBdBBAQZ55uoZt@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrOBdBBAQZ55uoZt@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 07:15:16AM -0700, Sean Christopherson wrote:
> On Tue, Aug 06, 2024, Oliver Upton wrote:
> > This sort of language generally isn't necessary in UAPI descriptions. We
> > cannot exhaustively describe the ways userspace might misuse an
> > interface.
> 
> I don't disagree in general, but I think this one is worth calling out because
> it's easy to screw up and arguably the most likely "failure" scenario.  E.g. KVM
> has had multiple bugs (I can think of four off the top of my head) where a vCPU
> gets stuck because KVM doesn't resolve a fault.  It's not hard to imagine userspace
> doing the same.

Yeah, I don't see any reason to go and rip it out, just a suggestion for
the next time around.

-- 
Thanks,
Oliver

