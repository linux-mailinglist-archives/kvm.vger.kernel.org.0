Return-Path: <kvm+bounces-31711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4429E9C6847
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 05:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEFDC2851AD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CDA170A1C;
	Wed, 13 Nov 2024 04:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZT7wqmL2"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B00D1632D6
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 04:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731473857; cv=none; b=WHWBEfJUHC1195s4X5QLBWvQidHXgs/z28w1ks7C2kqyZBNTXPT2Ip6qSJB8NZDpnyoV/qQuBIC4aLhnG/2KkDBoSSv5LdhVcbeXpz5BD2U9GQQXiZTjzlT6Xp/6PHDvC/4HB8VAW/tpHhksQiNFqnrQUg0ntbPTrsrQ6PWhywE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731473857; c=relaxed/simple;
	bh=b72XHTpU2wmHlD8dOIC9NiqW6uRGz6C9BEqfSXwQ+xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjqjaqSncop27Js7QFRh2FqL3IPO9Hk4LWZMhvCMiD+CGdhVUCGMln97ZCbJOb7W1gQNM08uU1I6adWQ5/Nf3vYG9So/4PpwDsGbtHW4dKXFF99+x7Wi1tbkv+IfcVM3OJ0XjGy/sc43LkTCXd/IpKSVQMotqbsz9Vo5bcxk2k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZT7wqmL2; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j1HJo1ufOOxZgsH2EGvRK6a4aBfxJMGSr5VDtSY9Rgs=; b=ZT7wqmL2VOXcAirGj0kjVCjCvh
	4z2BhaS4iVOQ43YLyNmGY43VklL1/Z2O7Ma1NK4RzLuUHfFiUzS2WjkOYB5oKPoFJda3Bx7rTagGw
	jOZn1nnDPQGPUnhJMJHFu4kXX+w8FgWC1U4gfDubH4vy8aK6Mf6LRX/CMPitatQjucVjfC+qTKfkV
	JrRVjk2/BoA8zXvfKHLDICQwWNltHNpqfMqSmAxHbBBbPZSd6hJRwc1k5YwiM7C5ZPiZMducbEvnl
	VIh1yDHuoLwWUumcMyn/Y5kUfjO/K1qrgEniRYXqOBLcIrJyY+T6jb+nbxTL70sAmPUGrDVo22mWO
	vPHnMYtA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB5RY-0000000Fj5A-3sOC;
	Wed, 13 Nov 2024 04:57:29 +0000
Date: Wed, 13 Nov 2024 04:57:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Fuad Tabba <tabba@google.com>,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	rppt@kernel.org, jglisse@redhat.com, akpm@linux-foundation.org,
	muchun.song@linux.dev, simona@ffwll.ch, airlied@gmail.com,
	pbonzini@redhat.com, seanjc@google.com, jhubbard@nvidia.com,
	ackerleytng@google.com, vannapurve@google.com,
	mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com,
	quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org,
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
Message-ID: <ZzQxuAiJLbqm5xGO@casper.infradead.org>
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
 <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
 <ZzLnFh1_4yYao_Yz@casper.infradead.org>
 <e82d7a46-8749-429c-82fa-0c996c858f4a@redhat.com>
 <20241112135348.GA28228@nvidia.com>
 <430b6a38-facf-4127-b1ef-5cfe7c495d63@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430b6a38-facf-4127-b1ef-5cfe7c495d63@redhat.com>

On Tue, Nov 12, 2024 at 03:22:46PM +0100, David Hildenbrand wrote:
> On 12.11.24 14:53, Jason Gunthorpe wrote:
> > On Tue, Nov 12, 2024 at 10:10:06AM +0100, David Hildenbrand wrote:
> > > On 12.11.24 06:26, Matthew Wilcox wrote:
> > > > I don't want you to respin.  I think this is a bad idea.
> > > 
> > > I'm hoping you'll find some more time to explain what exactly you don't
> > > like, because this series only refactors what we already have.
> > > 
> > > I enjoy seeing the special casing (especially hugetlb) gone from mm/swap.c.

I don't.  The list of 'if's is better than the indirect function call.
That's terribly expensive, and the way we reuse the lru.next field
is fragile.  Not to mention that it introduces a new thing for the
hardening people to fret over.

> > And, IMHO, seems like overkill. We have only a handful of cases -
> > maybe we shouldn't be trying to get to full generality but just handle
> > a couple of cases directly? I don't really think it is such a bad
> > thing to have an if ladder on the free path if we have only a couple
> > things. Certainly it looks good instead of doing overlaying tricks.
> 
> I'd really like to abstract hugetlb handling if possible. The way it stands
> it's just very odd.

There might be ways to make that better.  I haven't really been looking
too hard at making that special handling go away.

> We'll need some reliable way to identify these folios that need care.
> guest_memfd will be using folio->mapcount for now, so for now we couldn't
> set a page type like hugetlb does.

If hugetlb can set lru.next at a certain point, then guestmemfd could
set a page type at a similar point, no?

> > Also how does this translate to Matthew's memdesc world?

In a memdesc world, pages no longer have a refcount.  We might still
have put_page() which will now be a very complicated (and out-of-line)
function that looks up what kind of memdesc it is and operates on the
memdesc's refcount ... if it has one.  I don't know if it'll be exported
to modules; I can see uses in the mm code, but I'm not sure if modules
will have a need.

Each memdesc type will have its own function to call to free the memdesc.
So we'll still have folio_put().  But slab does not have, need nor want
a refcount, so it'll just slab_free().  I expect us to keep around a
list of recently-freed memdescs of a particular type with their pages
still attached so that we can allocate them again quickly (or reclaim
them under memory pressure).  Once that freelist overflows, we'll free
a batch of them to the buddy allocator (for the pages) and the slab
allocator (for the memdesc itself).

> guest_memfd and hugetlb would be operating on folios (at least for now),
> which contain the refcount,lru,private, ... so nothing special there.
> 
> Once we actually decoupled "struct folio" from "struct page", we *might*
> have to play less tricks, because we could just have a callback pointer
> there. But well, maybe we also want to save some space in there.
> 
> Do we want dedicated memdescs for hugetlb/guest_memfd that extend folios in
> the future? I don't know, maybe.

I've certainly considered going so far as a per-fs folio.  So we'd
have an ext4_folio, an btrfs_folio, an iomap_folio, etc.  That'd let us
get rid of folio->private, but I'm not sure that C's type system can
really handle this nicely.  Maybe in a Rust world ;-)

What I'm thinking about is that I'd really like to be able to declare
that all the functions in ext4_aops only accept pointers to ext4_folio,
so ext4_dirty_folio() can't be called with pointers to _any_ folio,
but specifically folios which were previously allocated for ext4.

I don't know if Rust lets you do something like that.

> I'm currently wondering if we can use folio->private for the time being.
> Either
> 
> (a) If folio->private is still set once the refcount drops to 0, it
> indicates that there is a freeing callback/owner_ops. We'll have to make
> hugetlb not use folio->private and convert others to clear folio->private
> before freeing.
> 
> (b) Use bitX of folio->private to indicate that this has "owner_ops"
> meaning. We'll have to make hugetlb not use folio->private and make others
> not use bitX. Might be harder and overkill, because right now we only really
> need the callback when refcount==0.
> 
> (c) Use some other indication that folio->private contains folio_ops.

I really don't want to use folio_ops / folio_owner_ops.  I read
https://lore.kernel.org/all/CAGtprH_JP2w-4rq02h_Ugvq5KuHX7TUvegOS7xUs_iy5hriE7g@mail.gmail.com/
and I still don't understand what you're trying to do.

Would it work to use aops->free_folio() to notify you when the folio is
being removed from the address space?

