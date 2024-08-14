Return-Path: <kvm+bounces-24219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2367D95263A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 01:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C1721C21BCD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 23:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B31114EC6E;
	Wed, 14 Aug 2024 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WBBRj/2l"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8113C820
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 23:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723678577; cv=none; b=qr4tKGVxxL0MH8fbUFhHdWQkOrvcClJ7j93/fNRY/jS2jVCZaGAS4DfipvenHNm2zxnOdOX2JMfKwNN9viJOamkfVkCJjignLNNlGlHQ3Wj+DEFaNr8KnDLtpRVH08KN5H08CSlQRWTTOeLRJ+UBETDCC8gxlAcTKkk9g4vTfhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723678577; c=relaxed/simple;
	bh=gBhJ0E6NHaiZ08O1RQfUOyPily9ybMrVIhgj1p2E+dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRnJJaKIRehMGKNZPFdmwqQnoAK2X+1GVeQpuj796S+589gxOOrG9DCgqR+ECvKHD0cQEfdQOZ51SKUdNApA5wom6OwWyhAgAKqsoAznZ+9zR8axwppFv9+8ufMd+siXEiYkrXGBNoi52BR6pc7bS+PCH5s2rJxRvgF3/o4SqkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WBBRj/2l; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 14 Aug 2024 16:36:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723678572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x2WFD3PneXB3Rd+FYibt8Nz/Vwl/XrkmHsW23VAaN+4=;
	b=WBBRj/2lYUKohCoueMwI9fFFjIrOaFNP9VWxDVtNBkYmY4amkDR6AEL+BMkcd18ojnFBF7
	VGhYD+72w9C8RKDhRrRdFJ+hrPBIhRpr6XXBDQxPvU9oS3mzQSFGFUH/9bYqy0aGATnBIt
	x2vc8/ecLpBix79HoBhmWqz44F1VGQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Message-ID: <Zr0_Y7tQ-fBMKxKH@linux.dev>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com>
 <20240814144307.GP2032816@nvidia.com>
 <Zr0ZbPQHVNzmvwa6@google.com>
 <20240814221031.GA2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814221031.GA2032816@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 14, 2024 at 07:10:31PM -0300, Jason Gunthorpe wrote:

[...]

> > Nope.  KVM ARM does (see get_vma_page_shift()) but I strongly suspect that's only
> > a win in very select use cases, and is overall a non-trivial loss.  
> 
> Ah that ARM behavior was probably what was being mentioned then! So
> take my original remark as applying to this :)
> 
> > > I don't quite understand your safety argument, if the VMA has 1G of
> > > contiguous physical memory described with 4K it is definitely safe for
> > > KVM to reassemble that same memory and represent it as 1G.
> >
> > That would require taking mmap_lock to get the VMA, which would be a net negative,
> > especially for workloads that are latency sensitive.
> 
> You can aggregate if the read and aggregating logic are protected by
> mmu notifiers, I think. A invalidation would still have enough
> information to clear the aggregate shadow entry. If you get a sequence
> number collision then you'd throw away the aggregation.
> 
> But yes, I also think it would be slow to have aggregation logic in
> KVM. Doing in the main mmu is much better.

+1.

For KVM/arm64 I'm quite hesitant to change the behavior to PTE mappings
in this situation (i.e. dump get_vma_page_shift()), as I'm quite certain
that'll have a performance regression on someone's workload. But once we
can derive huge PFNMAP from the primary MMU then we should just normalize
on that.

-- 
Thanks,
Oliver

