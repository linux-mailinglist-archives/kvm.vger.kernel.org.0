Return-Path: <kvm+bounces-12503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D34D8870F8
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AE7428376D
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 16:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592785B693;
	Fri, 22 Mar 2024 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEE6PZM8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328C1E88C;
	Fri, 22 Mar 2024 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711125427; cv=none; b=T+Gu5X05JGEENw0RALmZ/UcTUVmp1behONSmPKICbi76cVbuPyjlaHaqztYJtM+VJrAKmZEYflHoxPuU9nX5Y7+87R43sURJ0dHGmWnSxy4be0wGN0KmPeIzMi1+k+eX+PLMdxfyjdllk1CUgh40N6M8uzZ58N+PMWjK+wzR9Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711125427; c=relaxed/simple;
	bh=kpI1XVaJR1CUFGH8krGg+ZJLwJmLQ8ad0Vm0wyTpeUY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrfVtElgXab5Qeio/cxSXWaRxbB/XLCTqMuhB08R1rG7HeZtb/Qhg2cnr9VcQjwjG70wFjS0+ll3jufEngnLCztCT6Xim0twbIhWVsCilI7WJHSdaq9WAtFmZGwyeuEiV3Bp5b5PaaMZwk8F7iuVQu7pbUZu4OajSS49ZsWjfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEE6PZM8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B675DC433C7;
	Fri, 22 Mar 2024 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711125427;
	bh=kpI1XVaJR1CUFGH8krGg+ZJLwJmLQ8ad0Vm0wyTpeUY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CEE6PZM8w8lDdEJgVst5JX+v31QAvyVZC/BCz+IHwZHq3Ddc58ya3MVKHvxyiJCDb
	 pAwtE+o7XWrUvazZYhZTVve/CiPqRXpcYv+9pKhs1fR1JjwVUZNnaHJcJp7AodfyAO
	 JEfa7pwhAPHNfflTimR0ROr2XAuQb+pa6vJ4VmLg5On+J7TbDNYkSc6/zb9Rg8IsuP
	 bte2LaeAEGfdXq2dVcu5T9DX0bWjkvr3X6F+1QXcup2CJWL1oywpSOMNTdHc7XAdvG
	 64TVpmptmAq+/NdRk8VB+/rKVp5wJCvTBcE8lSQebP7Bk7WnVczXrfmDZwbpBi/KTb
	 vDTEjKnijw9tw==
Date: Fri, 22 Mar 2024 16:36:55 +0000
From: Will Deacon <will@kernel.org>
To: David Hildenbrand <david@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
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
Subject: Re: Re: folio_mmapped
Message-ID: <20240322163654.GG5634@willie-the-truck>
References: <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <20240319155648990-0700.eberman@hu-eberman-lv.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319155648990-0700.eberman@hu-eberman-lv.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Elliot,

On Tue, Mar 19, 2024 at 04:54:10PM -0700, Elliot Berman wrote:
> On Tue, Mar 19, 2024 at 02:31:19PM +0000, Will Deacon wrote:
> > On Tue, Mar 19, 2024 at 11:26:05AM +0100, David Hildenbrand wrote:
> > > On 19.03.24 01:10, Sean Christopherson wrote:
> > > > +1.  I am not completely opposed to letting SNP and TDX effectively convert
> > > > pages between private and shared, but I also completely agree that letting
> > > > anything gup() guest_memfd memory is likely to end in tears.
> > > 
> > > Yes. Avoid it right from the start, if possible.
> > > 
> > > People wanted guest_memfd to *not* have to mmap guest memory ("even for
> > > ordinary VMs"). Now people are saying we have to be able to mmap it in order
> > > to GUP it. It's getting tiring, really.
> > 
> > From the pKVM side, we're working on guest_memfd primarily to avoid
> > diverging from what other CoCo solutions end up using, but if it gets
> > de-featured (e.g. no huge pages, no GUP, no mmap) compared to what we do
> > today with anonymous memory, then it's a really hard sell to switch over
> > from what we have in production. We're also hoping that, over time,
> > guest_memfd will become more closely integrated with the mm subsystem to
> > enable things like hypervisor-assisted page migration, which we would
> > love to have.
> > 
> > Today, we use the existing KVM interfaces (i.e. based on anonymous
> > memory) and it mostly works with the one significant exception that
> > accessing private memory via a GUP pin will crash the host kernel. If
> > all guest_memfd() can offer to solve that problem is preventing GUP
> > altogether, then I'd sooner just add that same restriction to what we
> > currently have instead of overhauling the user ABI in favour of
> > something which offers us very little in return.
> 
> How would we add the restriction to anonymous memory?
> 
> Thinking aloud -- do you mean like some sort of "exclusive GUP" flag
> where mm can ensure that the exclusive GUP pin is the only pin? If the
> refcount for the page is >1, then the exclusive GUP fails. Any future
> GUP pin attempts would fail if the refcount has the EXCLUSIVE_BIAS.

Yes, I think we'd want something like that, but I don't think using a
bias on its own is a good idea as false positives due to a large number
of page references will then actually lead to problems (i.e. rejecting
GUP spuriously), no? I suppose if you only considered the new bias in
conjunction with the AS_NOGUP flag you proposed then it might be ok
(i.e. when you see the bias, you then go check the address space to
confirm). What do you think?

> > On the mmap() side of things for guest_memfd, a simpler option for us
> > than what has currently been proposed might be to enforce that the VMM
> > has unmapped all private pages on vCPU run, failing the ioctl if that's
> > not the case. It needs a little more tracking in guest_memfd but I think
> > GUP will then fall out in the wash because only shared pages will be
> > mapped by userspace and so GUP will fail by construction for private
> > pages.
> 
> We can prevent GUP after the pages are marked private, but the pages
> could be marked private after the pages were already GUP'd. I don't have
> a good way to detect this, so converting a page to private is difficult.

For anonymous memory, marking the page as private is going to involve an
exclusive GUP so that the page can safely be donated to the guest. In
that case, any existing GUP pin should cause that to fail gracefully.
What is the situation you are concerned about here?

> > We're happy to pursue alternative approaches using anonymous memory if
> > you'd prefer to keep guest_memfd limited in functionality (e.g.
> > preventing GUP of private pages by extending mapping_flags as per [1]),
> > but we're equally willing to contribute to guest_memfd if extensions are
> > welcome.
> > 
> > What do you prefer?
> > 
> 
> I like this as a stepping stone. For the Android use cases, we don't
> need to be able to convert a private page to shared and then also be
> able to GUP it.

I wouldn't want to rule that out, though. The VMM should be able to use
shared pages just like it can with normal anonymous pages.

> I don't think this design prevents us from adding "sometimes you can
> GUP" to guest_memfd in the future.

Technically, I think we can add all the stuff we need to guest_memfd,
but there's a desire to keep that as simple as possible for now, which
is why I'm keen to explore alternatives to unblock the pKVM upstreaming.

Will

