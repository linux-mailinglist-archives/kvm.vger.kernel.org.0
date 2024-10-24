Return-Path: <kvm+bounces-29621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B49E19AE277
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 578E4B2156E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48D81C07EB;
	Thu, 24 Oct 2024 10:25:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBD9155345
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729765532; cv=none; b=YCH7jMABFhYeUbBVUoBIHI+BaJIdxP+Hd4FDZ7dVPh6yuYE5oCvPK7GgWxZTddU7sXpaF9I8GcYZ1nfs0MGrFn3mAC4Q3pUr7Jx7m1FnPlBeu2VJ3wUiSUZZlzBlInoYJ0ewUCzvx4JKDPCQu/cumpP2xXr3/w25D4gEo96o8VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729765532; c=relaxed/simple;
	bh=zRX2KORi9cvakJYcLiZ81Ucj8x+qnSJGT517IP0G8+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeOqPznE8uSYg9LPQBL7kFGwCfw6OjvDgPqHTOX17xqQWHQ8errkIjk48eAR5qrgINlx9C7ZfB9RnBx9VnLB+aTCoPICoLGIHuEDENffXT1NMWTmPVBukY+17iEvSUhhq0vWbYm57aWtx27x+fhVXuQ8kxOPcoeI6QNvNNWA56o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1t3v1g-005aD0-0s;
	Thu, 24 Oct 2024 12:25:08 +0200
Date: Thu, 24 Oct 2024 12:25:08 +0200
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fast forward the iterator when zapping the TDP
 MMU
Message-ID: <ZxoghG8+7xAHh3bu@mias.mediconcil.de>
References: <20241023091902.2289764-1-bk@alpico.io>
 <ZxmGdhwr9BlhUQ_Y@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxmGdhwr9BlhUQ_Y@google.com>

On Wed, Oct 23, 2024 at 04:27:50PM -0700, Sean Christopherson wrote:
> On Wed, Oct 23, 2024, Bernhard Kauer wrote:
> > Zapping a root means scanning for present entries in a page-table
> > hierarchy. This process is relatively slow since it needs to be
> > preemtible as millions of entries might be processed.
> > 
> > Furthermore the root-page is traversed multiple times as zapping
> > is done with increasing page-sizes.
> > 
> > Optimizing for the not-present case speeds up the hello microbenchmark
> > by 115 microseconds.
> 
> What is the "hello" microbenchmark?  Do we actually care if it's faster?

Hello is a tiny kernel that just outputs "Hello world!" over a virtual
serial port and then shuts the VM down.  It is the minimal test-case that
reveals performance bottlenecks hard to see in the noise of a big system.

Does it matter?  The case I optimized might be only relevant for
short-running virtual machines.  However, you found more users of
the iterator that might benefit from it.

 
> Are you able to determine exactly what makes iteration slow? 

I've counted the loop and the number of entries removed:

	[24661.896626] zap root(0, 1) loops 3584 entries 2
	[24661.896655] zap root(0, 2) loops 2048 entries 3
	[24661.896709] zap root(0, 3) loops 1024 entries 2
	[24661.896750] zap root(0, 4) loops 512 entries 1
	[24661.896812] zap root(1, 1) loops 512 entries 0
	[24661.896856] zap root(1, 2) loops 512 entries 0
	[24661.896895] zap root(1, 3) loops 512 entries 0
	[24661.896938] zap root(1, 4) loops 512 entries 0


So for this simple case one needs 9216 iterations to go through 18 pagetables
with 512 entries each. My patch reduces this to 303 iterations.


	[24110.032368] zap root(0, 1) loops 118 entries 2
	[24110.032374] zap root(0, 2) loops 69 entries 3
	[24110.032419] zap root(0, 3) loops 35 entries 2
	[24110.032421] zap root(0, 4) loops 17 entries 1
	[24110.032434] zap root(1, 1) loops 16 entries 0
	[24110.032435] zap root(1, 2) loops 16 entries 0
	[24110.032437] zap root(1, 3) loops 16 entries 0
	[24110.032438] zap root(1, 4) loops 16 entries 0


Given the 115 microseconds one loop iteration is roughly 13 nanoseconds. 
With the updates to the iterator and the various checks this sounds
reasonable to me.  Simplifying the inner loop should help here.


> partly because maybe there's a more elegant solution.

Scanning can be avoided if one keeps track of the used entries.

 
> Regardless of why iteration is slow, I would much prefer to solve this for all
> users of the iterator.  E.g. very lightly tested, and not 100% optimized (though
> should be on par with the below).

Makes sense. I tried it out and it is a bit slower. One can optimize
the while loop in try_side_step() a bit further.

