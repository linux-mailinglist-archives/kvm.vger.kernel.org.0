Return-Path: <kvm+bounces-12898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB17E88EF40
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 20:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A48C1C34FE8
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 19:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0B3152514;
	Wed, 27 Mar 2024 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYdq0+rM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FDC14EC5E;
	Wed, 27 Mar 2024 19:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567930; cv=none; b=nBgJR3UFAshexe6GMHLkNDQ1GEVbJOeWO8mPUzYgk12zcMwih8S8G51NnmNq+m52izvOajRd9lqPNpbqmihp75kg/3SNIbva1bMBzZywDzWGX1nVTETUz4FQrK7Yx2zmJIsrT2G30TRBPLRNvfCOtEZdxXxy0WRYjxnx8qnYFkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567930; c=relaxed/simple;
	bh=yeuQu+jqTI42Wa2gAXV625L8CFa/tTjtWqrljr2uD60=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Be1oM/kPgFWaAI11jk48p3qSifxna0gK3KMIA86Ara0PdBG0br+G0Y4Fs5mDIQUYrQ0wjEjfEU/rIDLhyH+840a33s9JUQ3e0ndKer7BNq7T9jVluJHoWrogEaUkJIwHXI6ttjW0wx03PUN2kC33U51S6v3rBiENnBT5AoPPNfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYdq0+rM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC35AC433C7;
	Wed, 27 Mar 2024 19:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711567930;
	bh=yeuQu+jqTI42Wa2gAXV625L8CFa/tTjtWqrljr2uD60=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ZYdq0+rMI9hEu5Ju+26MkM1KWzsmojzBoLZ5BwISDAlEVAX9cAXdcowR+/lrwLMzk
	 RI7plET5KE0LvC9sBVRKqyxnpEJrHi/ZezFIF2yQuLDpmmtdVNVuExQ7PNFW7qF1D4
	 +FA8Hy8eqkUV3SoWNM6Yf0D3TGsjohZjqROHjlnTIDzAoS1HKx8oMba4FO4DFeTMnx
	 lZktTUNomhUF0zU1LuPoK3yhVq26kfpUXgFLCNgDSOTB0ZkbrcF6SW/hy/DtB6nPT6
	 JEBF16O11kLpBKFRlfPRYbXEP+/jFJ37NJKpkpx8HPa2DHSfv51hPix066nnN0Eb5b
	 jD5GwpDQhNo+w==
Date: Wed, 27 Mar 2024 19:31:58 +0000
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
Subject: Re: Re: Re: folio_mmapped
Message-ID: <20240327193157.GA11880@willie-the-truck>
References: <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <20240319155648990-0700.eberman@hu-eberman-lv.qualcomm.com>
 <20240322163654.GG5634@willie-the-truck>
 <20240322111214274-0700.eberman@hu-eberman-lv.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240322111214274-0700.eberman@hu-eberman-lv.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Elliot,

On Fri, Mar 22, 2024 at 11:46:10AM -0700, Elliot Berman wrote:
> On Fri, Mar 22, 2024 at 04:36:55PM +0000, Will Deacon wrote:
> > On Tue, Mar 19, 2024 at 04:54:10PM -0700, Elliot Berman wrote:
> > > How would we add the restriction to anonymous memory?
> > > 
> > > Thinking aloud -- do you mean like some sort of "exclusive GUP" flag
> > > where mm can ensure that the exclusive GUP pin is the only pin? If the
> > > refcount for the page is >1, then the exclusive GUP fails. Any future
> > > GUP pin attempts would fail if the refcount has the EXCLUSIVE_BIAS.
> > 
> > Yes, I think we'd want something like that, but I don't think using a
> > bias on its own is a good idea as false positives due to a large number
> > of page references will then actually lead to problems (i.e. rejecting
> > GUP spuriously), no? I suppose if you only considered the new bias in
> > conjunction with the AS_NOGUP flag you proposed then it might be ok
> > (i.e. when you see the bias, you then go check the address space to
> > confirm). What do you think?
> > 
> 
> I think the AS_NOGUP would prevent GUPing the first place. If we set the
> EXCLUSIVE_BIAS value to something like INT_MAX, do we need to be worried
> about there being INT_MAX-1 valid GUPs and wanting to add another?  From
> the GUPer's perspective, I don't think it would be much different from
> overflowing the refcount.

I don't think we should end up in a position where a malicious user can
take a tonne of references and cause functional problems. For example,
look at page_maybe_dma_pinned(); the worst case is we end up treating
heavily referenced pages as pinned and the soft-dirty logic leaves them
perpetually dirtied. The side-effects of what we're talking about here
seem to be much worse than that unless we can confirm that the page
really is exclusive.

> > > > On the mmap() side of things for guest_memfd, a simpler option for us
> > > > than what has currently been proposed might be to enforce that the VMM
> > > > has unmapped all private pages on vCPU run, failing the ioctl if that's
> > > > not the case. It needs a little more tracking in guest_memfd but I think
> > > > GUP will then fall out in the wash because only shared pages will be
> > > > mapped by userspace and so GUP will fail by construction for private
> > > > pages.
> > > 
> > > We can prevent GUP after the pages are marked private, but the pages
> > > could be marked private after the pages were already GUP'd. I don't have
> > > a good way to detect this, so converting a page to private is difficult.
> > 
> > For anonymous memory, marking the page as private is going to involve an
> > exclusive GUP so that the page can safely be donated to the guest. In
> > that case, any existing GUP pin should cause that to fail gracefully.
> > What is the situation you are concerned about here?
> > 
> 
> I wasn't thinking about exclusive GUP here. The exclusive GUP should be
> able to get the guarantees we need.
> 
> I was thinking about making sure we gracefully handle a race to provide
> the same page. The kernel should detect the difference between "we're
> already providing the page" and "somebody has an unexpected pin". We can
> easily read the refcount if we couldn't take the exclusive pin to know.

Thanks, that makes sense to me. For pKVM, the architecture code also
tracks all the donated pages, so we should be able to provide additional
metadata here if we shuffle things around a little.

Will

