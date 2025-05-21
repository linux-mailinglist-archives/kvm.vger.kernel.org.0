Return-Path: <kvm+bounces-47261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6EEABF324
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 13:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 584593BF07B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EB826461F;
	Wed, 21 May 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J+ZA1LkN"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571BE22B8B1;
	Wed, 21 May 2025 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747827763; cv=none; b=HImsbcJVselinqpCoTyUrGKtbvQf59aSEZMKju42YQ8HilnZ54WQEbmiwDaF1TLZF7pAH/OWeVGh/2u+N+zBjG44EbzUIQokSq2MyF/tS4SHUXyGXDqTRXbJHJSFCAh8huowD5356njkIoNXSXUzIpCzHoMTWTCVnB+5Kwdh9Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747827763; c=relaxed/simple;
	bh=BBLaqALTYPrcSvGY4FSvdax+qvgZN3k55RMHh1U2OpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHY56iR6eTMoTOE3qRu2+2HVhTHl6YX2c1eZDgrJUpBA2/ftcf9WcI5xFuJwYnySV6uaQE2xdSow6LE0dafQ+ZUH30ErhC1VfVDKDYd37ZdMwD+WuEA34LHiJZxhvt0PrIWlB4zNCXEKuceKyV2nLuCgHxUiJBQJqYUCGEjasaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J+ZA1LkN; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+KOoH+QcbNIcFt9a+edbvuTeUreK6auzBcTQsLb2atU=; b=J+ZA1LkNIZvB2wt5zV0IUe5eaO
	GhuaqpVSmOn9urMlfTUl+99lOTpOO+f/pKPDMPFnU/NqePPiHuAxDYGupA+8qh8qXhRmbs6tX5hE8
	u6dkqBqpoh9TKIkQUILB0b5bVr+1imyLQj2jeTKmC7U4WmTqUpYnlhopptqDp7qC8cUMr6p90Zm69
	nettF2xLWVUEiEI+dsK0hKGlo+GYUn+gXM7kr0szlrZOAI+qdeOvSb5knGoIDiA2s70Jaf8XMvICI
	XanMgNn2dhRd352C3mtDH/+o4D/POcJxcolPn7egKhWx163FR8YjlkoLPFs9VpXbLQOF2bZ3QVm88
	+pS+1Drg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uHhqE-00000000vno-2rKA;
	Wed, 21 May 2025 11:42:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C9BC1300348; Wed, 21 May 2025 13:42:33 +0200 (CEST)
Date: Wed, 21 May 2025 13:42:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>, mhklinux@outlook.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
	David Matlack <dmatlack@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from
 add_wait_queue_priority()
Message-ID: <20250521114233.GC39944@noisy.programming.kicks-ass.net>
References: <20250519185514.2678456-1-seanjc@google.com>
 <20250519185514.2678456-9-seanjc@google.com>
 <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
 <aC0AEJX0FIMl9lDy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC0AEJX0FIMl9lDy@google.com>

On Tue, May 20, 2025 at 03:20:00PM -0700, Sean Christopherson wrote:
> On Tue, May 20, 2025, Peter Zijlstra wrote:
> > On Mon, May 19, 2025 at 11:55:10AM -0700, Sean Christopherson wrote:
> > > Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
> > > differentiate it from add_wait_queue_priority_exclusive().  The one and
> > > only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
> > > unconditionally returns '0', i.e. doesn't actually operate in exclusive
> > > mode.
> > 
> > I find:
> > 
> > drivers/hv/mshv_eventfd.c:      add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
> > drivers/xen/privcmd.c:  add_wait_queue_priority(wqh, &kirqfd->wait);
> > 
> > I mean, it might still be true and all, but hyperv seems to also use
> > this now.
> 
> Oh FFS, another "heavily inspired by KVM".  I should have bribed someone to take
> this series when I had the chance.  *sigh*
> 
> Unfortunately, the Hyper-V code does actually operate in exclusive mode.  Unless
> you have a better idea, I'll tweak the series to:
> 
>   1. Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() and have the callers
>      explicitly set the flag, 
>   2. Add a patch to drop WQ_FLAG_EXCLUSIVE from Xen privcmd entirely.
>   3. Introduce add_wait_queue_priority_exclusive() and switch KVM to use it.
> 
> That has an added bonus of introducing the Xen change in a dedicated patch, i.e.
> is probably a sequence anyways.
> 
> Alternatively, I could rewrite the Hyper-V code a la the KVM changes, but I'm not
> feeling very charitable at the moment (the complete lack of documentation for
> their ioctl doesn't help).

Works for me. Michael is typically very responsive wrt hyperv (but you
probably know this).

