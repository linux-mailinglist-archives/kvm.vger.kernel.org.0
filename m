Return-Path: <kvm+bounces-24218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7848395262F
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 01:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17239B22F50
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 23:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5679714EC6E;
	Wed, 14 Aug 2024 23:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nsc/bZr/"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F015A1494D9
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 23:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723678083; cv=none; b=KrkyUCVNrMgCv18hQsaSQH/HaVfRI088bS934gGDYgV4UqcWKgtSurbU30w6AKHa1O+6FOmfi3On4kDRvrKtZc1N/1rwh515hfngDi/xexH7SQrJZptd/OsedOucTGc9Mnn/9sygGuK5K9r84yu8Sb5q34Ve2lySlD2UhHFyGUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723678083; c=relaxed/simple;
	bh=dYa2tzAJ6Cdw1W4KgGQX8E+iTD2pOCbZkqL986wEhDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGYXKFbQN4xE6nUzqvqZSAzfKsDgnn69ai70lYm7sitSfWKwNuVpy2FYLZqnR4VzN7VHLILwFXxdDt6ohlTEP5aoK/HCJJ2uJ/HtSOfvR0WkGO2C42zUcCxUt8ERACNBvSRLHDxKwE9EqSeLF14SvKMecLot4LGoaugJ5xt5dNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nsc/bZr/; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 14 Aug 2024 16:27:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723678078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8eQ90tE9+0xy2m1p8J2TRyAO3oFmDIcWuzH3FCL6Ggw=;
	b=nsc/bZr/eIAVrZJRD7FjVR0EMURLDMYdP2P6CaJSQamBq1RarDknj2/UwwhEWTNcIxAdwt
	4tStaF6wh0JB9KM4qNfkpXnLwEDP+/IdOhbNWv7jY7g8xjwVLvzwJvsMy9C5F1QgUQcNWF
	JVk9O7hDFOKVn4LwjePpEZMMjlHuYbw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>,
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
Message-ID: <Zr09cyPZNShzeZc6@linux.dev>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com>
 <20240814144307.GP2032816@nvidia.com>
 <Zr0ZbPQHVNzmvwa6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr0ZbPQHVNzmvwa6@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 14, 2024 at 01:54:04PM -0700, Sean Christopherson wrote:
> TL;DR: it's probably worth looking at mmu_stress_test (was: max_guest_memory_test)
> on arm64, specifically the mprotect() testcase[1], as performance is significantly
> worse compared to x86,

Sharing what we discussed offline:

Sean was using a machine w/o FEAT_FWB for this test, so the increased
runtime on arm64 is likely explained by the CMOs we're doing when
creating or invalidating a stage-2 PTE.

Using a machine w/ FEAT_FWB would be better for making these sort of
cross-architecture comparisons. Beyond CMOs, we do have some 

> and there might be bugs lurking the mmu_notifier flows.

Impossible! :)

> Jumping back to mmap_lock, adding a lock, vma_lookup(), and unlock in x86's page
> fault path for valid VMAs does introduce a performance regression, but only ~30%,
> not the ~6x jump from x86 to arm64.  So that too makes it unlikely taking mmap_lock
> is the main problem, though it's still good justification for avoid mmap_lock in
> the page fault path.

I'm curious how much of that 30% in a microbenchmark would translate to
real world performance, since it isn't *that* egregious. We also have
other uses for getting at the VMA beyond mapping granularity (MTE and
the VFIO Normal-NC hint) that'd require some attention too.

-- 
Thanks,
Oliver

