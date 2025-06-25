Return-Path: <kvm+bounces-50738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7862AE8B4B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 19:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 082C9161D35
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5882C1587;
	Wed, 25 Jun 2025 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbRXq8ol"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E7328643E
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750871543; cv=none; b=fZUNHMuP3jYUfItAW9SPiCSK/vNPp9+Ack8jN92V9JWinDf6hfClJY1i1WDOV0Hi4RXVasFHh0u7BGb9tkWGLXy3rSWeL6p9RSlWnDCIYE7zfknMiqu8KnFHepR+n5QauRMLhOxpRyoDLaCCPOHeyyAkcDY1QJ7Xt4sHGgQqB44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750871543; c=relaxed/simple;
	bh=pqkIDhr4yYMMYnY/+fSGhDZ1uE7lj3oqlLUoR8xcxtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2Yf2Y0Gey6Zi468A3T1RuQrseh8UnzAw/+IDOk8I4zkzFLEBbyH2SXljczBvT3f+fVF83BZkRoXK6Eu/NfzrihlhIVkl0G3zUUsqAKEALCS8Q8fKifuXisudoJqz6lJJbhwoskKalnhy+0tNFwkP9ndiJpnitVPUkAPCpBzVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DbRXq8ol; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750871540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpMWnzwEQrz5g7Z8QpxeuZOo0PQWHqBUbD3/9JCskzM=;
	b=DbRXq8olfJCtGagUeXb2A1q8aNR+v9r1gYYT7buHmA8s3E5f5F4Rh43nS/Ua+FQnRrU0lj
	TxWsoB7AKdvO6mZxixqZi6Y25dNquaXaBOJrDpfMcXbYJaV5NGN9i3zXnEZuxydgq9c5ew
	XNx0SPjQ7uGyfYISXmcoaE7yPYCuHqE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-p8AjlfznNVKiWCfEF3pNvQ-1; Wed, 25 Jun 2025 13:12:17 -0400
X-MC-Unique: p8AjlfznNVKiWCfEF3pNvQ-1
X-Mimecast-MFC-AGG-ID: p8AjlfznNVKiWCfEF3pNvQ_1750871537
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5e2872e57so12898285a.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 10:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750871537; x=1751476337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpMWnzwEQrz5g7Z8QpxeuZOo0PQWHqBUbD3/9JCskzM=;
        b=BFoHO07cbCVpWy8DAHiuuFlL4YTeCTl5dxBbMe+7p9ku78AD2w5R3EH1n5G+SZhjru
         YHR0bYa2SYpDeKo9hRXs4oLlrV6oyFl9tvFdjn72e87OgvrYqGqz5sJmOxHDwkbgPbKN
         0zcRbhpkvtiqA0ws4OmCn5K1AMbIhgezGzp6dQ26LmErIrY6gnIqBwjzsg1rZQpR0yBo
         D/QKkFjathcRFGuDAaFPKK2SZ7drUFB0Ef+YGgc/YnBi7MJNHp8dWC+p0XIgxyHD7Z7k
         1KMj8QeGXTXirx3rKwiolbnW7FaQHHyXHSdQM2Z5BBZtP3c3PyprhtD5F6OCPmFPak2V
         QwYw==
X-Forwarded-Encrypted: i=1; AJvYcCXgDu4GPIxMQSS/Mb+6Z6WXZQv1GyiUzbnQc9MGcdTcc6pCtVGQSvD1A88EnQwDZJTVJ1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI8ITEqVbbEfapnDOEH/eGw5tCdpQCk20avJV/E8hbwpvN/KW2
	F/5cuWa0BOL4w0WZv/yeFo3ChDPJebp1WmpbjZaKqfWiH0mAQDUHZg4nADR5ytjGj0nMPaKJ8+o
	nShrzw/qwzdKJiWjmVKrvHArY8f0qMe9T1ZRbPfBjAP3BoyxiFZuqzA==
X-Gm-Gg: ASbGncsxe9bACYdNMb++paZDLwy0GgvPxyMVFMkZoM7ZJTLR1FoWzsTdS7hiE/YfDvc
	et/flXIvfteINp9L5W8o4lFoNA5khtwVF28BWqmDylNaBBgEvLEhZooLaFQpup7NWusEkNKgaHf
	q67UNHukmnQiklNllg+xf6jnRDPSek7nR+rf/AKzIJwSQRwWTOwICmywyiQVGOGIP98C5uJXCPA
	cotPPDQqphaOt3a5yGTEXzIcdKWMp5ZaFiF68B0i6U3idv2aPFznTVfd0U/Oc7+x7tf6ZIYL+Ei
	rYIs3m6ItQKkPQ==
X-Received: by 2002:a05:620a:4893:b0:7cc:aedc:d0c1 with SMTP id af79cd13be357-7d429679b10mr490568685a.5.1750871536970;
        Wed, 25 Jun 2025 10:12:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyrt+UA8j4eJN5Kl/iuZzYbNEyvfMEcAUbDYG7hfuDyGNjFN3bqqLY7ZZU1ZAyKHWHlsX1Fg==
X-Received: by 2002:a05:620a:4893:b0:7cc:aedc:d0c1 with SMTP id af79cd13be357-7d429679b10mr490563685a.5.1750871536438;
        Wed, 25 Jun 2025 10:12:16 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d41d5ffcfcsm259507785a.68.2025.06.25.10.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 10:12:15 -0700 (PDT)
Date: Wed, 25 Jun 2025 13:12:11 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aFwt6wjuDzbWM4_C@x1.local>
References: <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
 <20250625130711.GH167785@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250625130711.GH167785@nvidia.com>

On Wed, Jun 25, 2025 at 10:07:11AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 24, 2025 at 08:48:45PM -0400, Peter Xu wrote:
> > > My feeling, and the reason I used the phrase "pgoff aligned address",
> > > is that the owner of the file should already ensure that for the large
> > > PTEs/folios:
> > >  pgoff % 2**order == 0
> > >  physical % 2**order == 0
> > 
> > IMHO there shouldn't really be any hard requirement in mm that pgoff and
> > physical address space need to be aligned.. but I confess I don't have an
> > example driver that didn't do that in the linux tree.
> 
> Well, maybe, but right now there does seem to be for
> THP/hugetlbfs/etc. It is a nice simple solution that exposes the
> alignment requirements to userspace if it wants to use MAP_FIXED.
> 
> > > To me this just keeps thing simpler. I guess if someone comes up with
> > > a case where they really can't get a pgoff alignment and really need a
> > > high order mapping then maybe we can add a new return field of some
> > > kind (pgoff adjustment?) but that is so weird I'd leave it to the
> > > future person to come and justfiy it.
> > 
> > When looking more, I also found some special cased get_unmapped_area() that
> > may not be trivially converted into the new API even for CONFIG_MMU, namely:
> > 
> > - io_uring_get_unmapped_area
> > - arena_get_unmapped_area (from bpf_map->ops->map_get_unmapped_area)
> > 
> > I'll need to have some closer look tomorrow.  If any of them cannot be 100%
> > safely converted to the new API, I'd also think we should not introduce the
> > new API, but reuse get_unmapped_area() until we know a way out.
> 
> Oh yuk. It is trying to avoid the dcache flush on some kernel paths
> for virtually tagged cache systems.
> 
> Arguably this fixup should not be in io_uring, but conveying the right
> information to the core code, and requesting a special flush
> avoidance mapping is not so easy.

IIUC it still makes sense to be with io_uring, because only io_uring
subsystem knows what to align against.  I don't yet understand how generic
mm can do this, after all generic mm doesn't know the address that io_uring
is using (from io_region_get_ptr()).

> 
> But again I suspect the pgoff is the right solution.
> 
> IIRC this is handled by forcing a few low virtual address bits to
> always match across all user mappings (the colour) via the pgoff. This
> way the userspace always uses the same cache tag and doesn't become
> cache incoherent. ie:
> 
>    user_addr % PAGE_SIZE*N == pgoff % PAGE_SIZE*N
> 
> The issue is now the kernel is using the direct map and we can't force

After I read the two use cases, I mostly agree.  Just one trivial thing to
mention, it may not be direct map but vmap() (see io_region_init_ptr()).

> a random jumble of pages to have the right colours to match
> userspace. So the kernel has all those dcache flushes sprinkled about
> before it touches user mapped memory through the direct map as the
> kernel will use a different colour and cache tag.
> 
> So.. if iouring selects a pgoff that automatically gives the right
> colour for the userspace mapping to also match the kernel mapping's
> colour then things should just work.
> 
> Frankly I'm shocked that someone invested time in trying to make this
> work - the commit log says it was for parisc and only 2 years ago :(
> 
> d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing requirements")
> 
> I thought such physically tagged cache systems were long ago dead and
> buried..

Yeah.. internet says parisc stopped shipping since 2005.  Obviously
there're still people running io_uring on parisc systems, more or less.
This change seems to be required to make io_uring work on parisc or any
vipt.

> 
> Shouldn't this entirely reject MAP_FIXED too?

It already does, see (io_uring_get_unmapped_area(), of parisc):

	/*
	 * Do not allow to map to user-provided address to avoid breaking the
	 * aliasing rules. Userspace is not able to guess the offset address of
	 * kernel kmalloc()ed memory area.
	 */
	if (addr)
		return -EINVAL;

I do not know whoever would use MAP_FIXED but with addr=0.  So failing
addr!=0 should literally stop almost all MAP_FIXED already.

Side topic, but... logically speaking this should really be fine when
!SHM_COLOUR.  This commit should break MAP_FIXED for everyone on io_uring,
but I guess nobody really use MAP_FIXED for io_uring fds..

It's also utterly confusing to set addr=ptr for parisc, fundamentally addr
here must be a kernel va not user va, so it'll (AFAIU) 100% fail later with
STACK_SIZE checks..  IMHO we should really change this to:

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 725dc0bec24c..1225a9393dc5 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -380,12 +380,10 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
         */
        filp = NULL;
        flags |= MAP_SHARED;
-       pgoff = 0;      /* has been translated to ptr above */
 #ifdef SHM_COLOUR
-       addr = (uintptr_t) ptr;
-       pgoff = addr >> PAGE_SHIFT;
+       pgoff = (uintptr_t)ptr >> PAGE_SHIFT;
 #else
-       addr = 0UL;
+       pgoff = 0;      /* has been translated to ptr above */
 #endif
        return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 }

And avoid the confusing "addr=ptr" setup.  This might be too off-topic,
though.

Then I also looked at the other bpf arena use case, which doubled the len
when requesting VA and does proper round ups for 4G:

arena_get_unmapped_area():
	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
        ...
	return round_up(ret, SZ_4G);

AFAIU, this is buggy.. at least we should check "round_up(ret, SZ_4G)"
still falls into the (ret, ret+2*len) region... or AFAIU we can return some
address that might be used by other VMAs already..

But in general that smells like a similar alignment issue, IIUC.  So might
be applicable for the new API.

Going back to the topic of this series - I think the new API would work for
io_uring and parisc too if I can return phys_pgoff, here what parisc would
need is:

#ifdef SHM_COLOUR
        *phys_pgoff = io_region_get_ptr(..) >> PAGE_SHIFT;
#else
        *phys_pgoff = pgoff;
#endif

Here *phys_pgoff (or a rename) would be required to fetch the kernel VA (no
matter direct mapping or vmap()) offset, to avoid aliasing issue.

Should I go and introduce the API with *phys_pgoff returned together, then?
I'll still need to scratch my head on how to properly define it, but it at
least will also get vfio use case decouple with spec dependency.

Thanks,

-- 
Peter Xu


