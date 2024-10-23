Return-Path: <kvm+bounces-29457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFEA9ABB4E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 04:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84A011F24672
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 02:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74D44E1CA;
	Wed, 23 Oct 2024 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eXIZhoc9"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE63928DD0;
	Wed, 23 Oct 2024 02:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729649057; cv=none; b=NFrb3+zfOi1rd6nXai5nAY9jbGDIC4/NNLJSEDdFaWwoRBxTz4Q8F7eYvh2yit3+5vOAbGOryERzgTAPN5T5uq5X4sQJ3PgYH7UlgLI3m+HqdDOLOpQyXeuckzN6mbqKxKUve0wgNfVx+TJ4i7OIfLgLXs4EzBD2v8p+wIpRYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729649057; c=relaxed/simple;
	bh=R4GGG33lUKGQnK9hCXXz7w12TC6kQJDQkpXGRbWbwpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJDuQMFtIxB2r7ms6WOQXMOv6YgyltmemAqGpdwfhehuSQmEOlT9tZrKuVFQtufvzrvxlkshGibEW3gbrVH8XQuOuSMEpiOKM+vSyPDvDupT7tcyUw3mVmH5qHJ+Eya3RhHlhqXftGm19OaeQ38wL2gMlM5uUp1du2z5+c06eyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eXIZhoc9; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 23 Oct 2024 02:04:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729649053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTDEQxtL/e15npVRRblX1oHt3rcZenqRAA28VnZ+D7Q=;
	b=eXIZhoc9TWuSBnwsavc9/J5Z7v7U1C5BMrOQyHH3rqg/Ek6KpEz+5L98tc+uhzAH3yAWew
	6Hl+Zj+c9bioi5qtX17tmHvMgtXbdotK3zuBFfXmw4HIMxi5xd/NcYahSK69rhSlxjEn0Q
	IMghs7iVcnFSvyFfoopgoQaGPL0eoVc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] mm: page_alloc: move mlocked flag clearance into
 free_pages_prepare()
Message-ID: <ZxhZl3Qi2sRIWRIb@google.com>
References: <20241021173455.2691973-1-roman.gushchin@linux.dev>
 <Zxa60Ftbh8eN1MG5@casper.infradead.org>
 <ZxcKjwhMKmnHTX8Q@google.com>
 <ZxcgR46zpW8uVKrt@casper.infradead.org>
 <ZxcrJHtIGckMo9Ni@google.com>
 <CAJD7tkb2oUre-tgVyW6XgUaNfGQSSKp=QNAfB0iZoTvHcc0n0w@mail.gmail.com>
 <ZxfHNo1dUVcOLJYK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxfHNo1dUVcOLJYK@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 22, 2024 at 08:39:34AM -0700, Sean Christopherson wrote:
> On Tue, Oct 22, 2024, Yosry Ahmed wrote:
> > On Mon, Oct 21, 2024 at 9:33 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> > >
> > > On Tue, Oct 22, 2024 at 04:47:19AM +0100, Matthew Wilcox wrote:
> > > > On Tue, Oct 22, 2024 at 02:14:39AM +0000, Roman Gushchin wrote:
> > > > > On Mon, Oct 21, 2024 at 09:34:24PM +0100, Matthew Wilcox wrote:
> > > > > > On Mon, Oct 21, 2024 at 05:34:55PM +0000, Roman Gushchin wrote:
> > > > > > > Fix it by moving the mlocked flag clearance down to
> > > > > > > free_page_prepare().
> > > > > >
> > > > > > Urgh, I don't like this new reference to folio in free_pages_prepare().
> > > > > > It feels like a layering violation.  I'll think about where else we
> > > > > > could put this.
> > > > >
> > > > > I agree, but it feels like it needs quite some work to do it in a nicer way,
> > > > > no way it can be backported to older kernels. As for this fix, I don't
> > > > > have better ideas...
> > > >
> > > > Well, what is KVM doing that causes this page to get mapped to userspace?
> > > > Don't tell me to look at the reproducer as it is 403 Forbidden.  All I
> > > > can tell is that it's freed with vfree().
> > > >
> > > > Is it from kvm_dirty_ring_get_page()?  That looks like the obvious thing,
> > > > but I'd hate to spend a lot of time on it and then discover I was looking
> > > > at the wrong thing.
> > >
> > > One of the pages is vcpu->run, others belong to kvm->coalesced_mmio_ring.
> > 
> > Looking at kvm_vcpu_fault(), it seems like we after mmap'ing the fd
> > returned by KVM_CREATE_VCPU we can access one of the following:
> > - vcpu->run
> > - vcpu->arch.pio_data
> > - vcpu->kvm->coalesced_mmio_ring
> > - a page returned by kvm_dirty_ring_get_page()
> > 
> > It doesn't seem like any of these are reclaimable,
> 
> Correct, these are all kernel allocated pages that KVM exposes to userspace to
> facilitate bidirectional sharing of large chunks of data.
> 
> > why is mlock()'ing them supported to begin with?
> 
> Because no one realized it would be problematic, and KVM would have had to go out
> of its way to prevent mlock().
> 
> > Even if we don't want mlock() to err in this case, shouldn't we just do
> > nothing?
> 
> Ideally, yes.
> 
> > I see a lot of checks at the beginning of mlock_fixup() to check
> > whether we should operate on the vma, perhaps we should also check for
> > these KVM vmas?
> 
> Definitely not.  KVM may be doing something unexpected, but the VMA certainly
> isn't unique enough to warrant mm/ needing dedicated handling.
> 
> Focusing on KVM is likely a waste of time.  There are probably other subsystems
> and/or drivers that .mmap() kernel allocated memory in the same way.  Odds are
> good KVM is just the messenger, because syzkaller knows how to beat on KVM.  And
> even if there aren't any other existing cases, nothing would prevent them from
> coming along in the future.

Yeah, I also think so.
It seems that bpf/ringbuf.c contains another example. There are likely more.

So I think we have either to fix it like proposed or on the mlock side.

