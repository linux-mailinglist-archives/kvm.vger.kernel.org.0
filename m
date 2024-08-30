Return-Path: <kvm+bounces-25558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFDE966828
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FCF41F23C84
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0871BBBCD;
	Fri, 30 Aug 2024 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VxiwD7GQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF031B78E8
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725039526; cv=none; b=nWoNOHBbPu32L+Iwfyc3SuoRE+HIrBsrolXJIji2M3XxKiSkrfIo+kA/We4VhKYMJR5/WWdnAWiH5aEmS+tCUWf4+bMsCDXqJ9V4zKRu/VNwDyaeAzJa4rJ4D0KsAYUyAKv5J7dPoMYs+NOQfqdLt2e22nMAGhK5dGtfwRQnSdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725039526; c=relaxed/simple;
	bh=lge5FERVK6kb/J6uzbFQGyu7nF5jed3VoSj6+WRGVyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLnJ8KsnBSDaEyEjopTshcDIusG6qh312QPCpNuax78dmEsFwt7cohnKRLBnH3nt26w8/Aza7RVdh4f/lSeA1EkaY1zzD972nPB0Jf5HSsAWAG1kPcfadz4PTKnCQqr6RpNeR2s5zq4C78QqK7e2hXMUYPXSncv9w7mWjv9kH6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VxiwD7GQ; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 Aug 2024 10:38:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725039522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d6L+KI/2jSnOcw8BblWMkOB9gllIb6gCZOsYWN7xgAE=;
	b=VxiwD7GQ9XhGMOI+EnUY1hbVf1hzgYZ5y62ghG8H7NgsCgvXK4O4uAcphI2s+QGcMzw68d
	UaCmBNo7L8WOVI0SB8xsTf4TWWtvlNsKEr9IyKBJdR3cffMLp9Ra0WD2saR02EGGsiHuqM
	Gm5puFHjnuYd9wcQ2Fo4PIH+Gvr10zY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Cc: James Houghton <jthoughton@google.com>, Yu Zhao <yuzhao@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <ZtIDmc_V62ZqrbxW@linux.dev>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com>
 <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com>
 <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev>
 <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
 <ZtEW5Iym5QsJbONM@linux.dev>
 <CALzav=daN3y9nXNuj7pPpn2u_aAQ84t161z3odP=MGLYCLfYMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=daN3y9nXNuj7pPpn2u_aAQ84t161z3odP=MGLYCLfYMQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

Hey David,

On Fri, Aug 30, 2024 at 08:33:59AM -0700, David Matlack wrote:
> On Thu, Aug 29, 2024 at 5:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Thu, Aug 29, 2024 at 05:33:00PM -0700, James Houghton wrote:
> > > On Mon, Aug 19, 2024 at 1:42 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > Asking since you had a setup / data earlier on when you were carrying
> > > > the series. Hopefully with supportive data we can get arm64 to opt-in
> > > > to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.
> > >
> > > I'll keep trying some other approaches I can take for getting similar
> > > testing that Yu had; it is somewhat difficult for me to reproduce
> > > those tests (and it really shouldn't be.... sorry).
> >
> > No need to apologize. Getting good test hardware for arm64 is a complete
> > chore. Sure would love a functional workstation with cores from this
> > decade...
> >
> > > I think it makes most sense for me to drop the arm64 patch for now and
> > > re-propose it (or something stronger) alongside enabling aging. Does
> > > that sound ok?
> >
> > I'm a bit disappointed that we haven't gotten forward progress on the
> > arm64 patches, but I also recognize this is the direction of travel as
> > the x86 patches are shaping up.
> >
> > So yeah, I'm OK with it, but I'd love to get the arm64 side sorted out
> > soon while the context is still fresh.
> 
> Converting the aging notifiers to holding mmu_lock for read seems like
> a pure win and minimal churn. Can we keep that patch in v7 (which
> depends on the lockless notifier refactor, i.e. is not completely
> stand-alone)? We can revisit enabling MGLRU on arm64 in a subsequent
> series.

Even though the churn is minimal in LOC, locking changes are significant. If
one thing has become clear, there are some strong opinions about arm64
participating in MGLRU w/ the read lock. So it is almost guaranteed that
these read lock changes will eventually get thrown out in favor of an
RCU-protected walker.

Then we're stuck with potentially 3 flavors of locking in kernels that
people actually use, and dealing with breakage that only affects that
intermediate step is gonna be annoying.

-- 
Thanks,
Oliver

