Return-Path: <kvm+bounces-12899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA52888EF46
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 20:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAA31B26221
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 19:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D0814E2E1;
	Wed, 27 Mar 2024 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ug84oDOw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802C6380;
	Wed, 27 Mar 2024 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568106; cv=none; b=PLjsNZnoGH6kpX4w/RkkUGc7Bo1z/rdfLqBbT79qIkaOgfJofu67pAu5UjTB5rkEYJItLUGIb6EkuXMRtZtvj+p55Pv5CJ/8roroiaKASi8jvkMZqbRAOyCeH25iNMH6UXxf9nfALU7fUfkf+QXtteFd9LhkVm81zQBgwUcgL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568106; c=relaxed/simple;
	bh=fsAJPDxY5k+RVFU285F2zO/6g9dguCSmR7ujBN43Icc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIfWtl3fkDPQSWqs5VfD/uOq82RbKm8+sJZGI04fsWQcGDiZNzgVHUzXqMDXCHRIAOn57VZRy6LfLra8c9cfbOxhkLLsU3jDVQ5SPTpcTVDopmA9qKea5U3+tPoFr5B/Y2i9WezdMxWNPWcHI0onmFuzIhNYvb75wqw752jg6TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ug84oDOw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A772FC433C7;
	Wed, 27 Mar 2024 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711568106;
	bh=fsAJPDxY5k+RVFU285F2zO/6g9dguCSmR7ujBN43Icc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ug84oDOw6aPYjICltOnqhWhzEFiXYKKph4kH3bDLOjIAV/7mNGG6pmGv1LaVX+t06
	 aYH2raWE09uPQDhcf/iAytXNzSx0WJlY0zzObFPn/uVVB0dMtyk6AzHTG6KzxkrTh+
	 +UhKUm7eOZTQ9cQMAxRlTX1QKkMTs6wn7KAl6rspNsjxU3mbqw5QRnFAkgomWWkAEF
	 6aw51O6AWJOeUrfyq+8nMmzGOAlSZ9PoFDegPoUvdVAeHVR792BzubgR83h0ne7aVF
	 a14nWnni9iCIkU3l0KUsZTNa1gfUFV/zj1uplb4DIAhZDnLF18aYLbGUMJgG7VpzqV
	 CuhJpYj4Rw7fw==
Date: Wed, 27 Mar 2024 19:34:54 +0000
From: Will Deacon <will@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Quentin Perret <qperret@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	ackerleytng@google.com, mail@maciej.szmigiero.name,
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, keirf@google.com,
	linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <20240327193454.GB11880@willie-the-truck>
References: <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi again, David,

On Fri, Mar 22, 2024 at 06:52:14PM +0100, David Hildenbrand wrote:
> On 19.03.24 15:31, Will Deacon wrote:
> sorry for the late reply!

Bah, you and me both!

> > On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > > On 19.03.24 01:10, Sean Christopherson wrote:
> > > > On Mon, Mar 18, 2024, Vishal Annapurve wrote:
> > > > > On Mon, Mar 18, 2024 at 3:02 PM David Hildenbrand <david@redhat.com> wrote:
> >  From the pKVM side, we're working on guest_memfd primarily to avoid
> > diverging from what other CoCo solutions end up using, but if it gets
> > de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> > today with anonymous memory, then it's a really hard sell to switch over
> > from what we have in production. We're also hoping that, over time,
> > guest_memfd will become more closely integrated with the mm subsystem to
> > enable things like hypervisor-assisted page migration, which we would
> > love to have.
> 
> Reading Sean's reply, he has a different view on that. And I think that's
> the main issue: there are too many different use cases and too many
> different requirements that could turn guest_memfd into something that maybe
> it really shouldn't be.

No argument there, and we're certainly not tied to any specific
mechanism on the pKVM side. Maybe Sean can chime in, but we've
definitely spoken about migration being a goal in the past, so I guess
something changed since then on the guest_memfd side.

Regardless, from our point of view, we just need to make sure that
whatever we settle on for pKVM does the things we need it to do (or can
at least be extended to do them) and we're happy to implement that in
whatever way works best for upstream, guest_memfd or otherwise.

> > We're happy to pursue alternative approaches using anonymous memory if
> > you'd prefer to keep guest_memfd limited in functionality (e.g.
> > preventing GUP of private pages by extending mapping_flags as per [1]),
> > but we're equally willing to contribute to guest_memfd if extensions are
> > welcome.
> > 
> > What do you prefer?
> 
> Let me summarize the history:

First off, thanks for piecing together the archaeology...

> AMD had its thing running and it worked for them (but I recall it was hacky
> :) ).
> 
> TDX made it possible to crash the machine when accessing secure memory from
> user space (MCE).
> 
> So secure memory must not be mapped into user space -- no page tables.
> Prototypes with anonymous memory existed (and I didn't hate them, although
> hacky), but one of the other selling points of guest_memfd was that we could
> create VMs that wouldn't need any page tables at all, which I found
> interesting.

Are the prototypes you refer to here based on the old stuff from Kirill?
We followed that work at the time, thinking we were going to be using
that before guest_memfd came along, so we've sadly been collecting
out-of-tree patches for a little while :/

> There was a bit more to that (easier conversion, avoiding GUP, specifying on
> allocation that the memory was unmovable ...), but I'll get to that later.
> 
> The design principle was: nasty private memory (unmovable, unswappable,
> inaccessible, un-GUPable) is allocated from guest_memfd, ordinary "shared"
> memory is allocated from an ordinary memfd.
> 
> This makes sense: shared memory is neither nasty nor special. You can
> migrate it, swap it out, map it into page tables, GUP it, ... without any
> issues.

Slight aside and not wanting to derail the discussion, but we have a few
different types of sharing which we'll have to consider:

  * Memory shared from the host to the guest. This remains owned by the
    host and the normal mm stuff can be made to work with it.

  * Memory shared from the guest to the host. This remains owned by the
    guest, so there's a pin on the pages and the normal mm stuff can't
    work without co-operation from the guest (see next point).

  * Memory relinquished from the guest to the host. This actually unmaps
    the pages from the host and transfers ownership back to the host,
    after which the pin is dropped and the normal mm stuff can work. We
    use this to implement ballooning.

I suppose the main thing is that the architecture backend can deal with
these states, so the core code shouldn't really care as long as it's
aware that shared memory may be pinned.

> So if I would describe some key characteristics of guest_memfd as of today,
> it would probably be:
> 
> 1) Memory is unmovable and unswappable. Right from the beginning, it is
>    allocated as unmovable (e.g., not placed on ZONE_MOVABLE, CMA, ...).
> 2) Memory is inaccessible. It cannot be read from user space, the
>    kernel, it cannot be GUP'ed ... only some mechanisms might end up
>    touching that memory (e.g., hibernation, /proc/kcore) might end up
>    touching it "by accident", and we usually can handle these cases.
> 3) Memory can be discarded in page granularity. There should be no cases
>    where you cannot discard memory to over-allocate memory for private
>    pages that have been replaced by shared pages otherwise.
> 4) Page tables are not required (well, it's an memfd), and the fd could
>    in theory be passed to other processes.
> 
> Having "ordinary shared" memory in there implies that 1) and 2) will have to
> be adjusted for them, which kind-of turns it "partially" into ordinary shmem
> again.

Yes, and we'd also need a way to establish hugepages (where possible)
even for the *private* memory so as to reduce the depth of the guest's
stage-2 walk.

> Going back to the beginning: with pKVM, we likely want the following
> 
> 1) Convert pages private<->shared in-place
> 2) Stop user space + kernel from accessing private memory in process
>    context. Likely for pKVM we would only crash the process, which
>    would be acceptable.
> 3) Prevent GUP to private memory. Otherwise we could crash the kernel.
> 4) Prevent private pages from swapout+migration until supported.
> 
> 
> I suspect your current solution with anonymous memory gets all but 3) sorted
> out, correct?

I agree on all of these and, yes, (3) is the problem for us. We've also
been thinking a bit about CoW recently and I suspect the use of
vm_normal_page() in do_wp_page() could lead to issues similar to those
we hit with GUP. There are various ways to approach that, but I'm not
sure what's best.

> I'm curious, may there be a requirement in the future that shared memory
> could be mapped into other processes? (thinking vhost-user and such things).

It's not impossible. We use crosvm as our VMM, and that has a
multi-process sandbox mode which I think relies on just that...

Cheers,

Will

(btw: I'm getting some time away from the computer over Easter, so I'll be
 a little slow on email again. Nothing personal!).

