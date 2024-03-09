Return-Path: <kvm+bounces-11440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F091B876F3E
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 06:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63F8A2820DC
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 05:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D8C2CCB3;
	Sat,  9 Mar 2024 05:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eRJRVBpP"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D611E49B;
	Sat,  9 Mar 2024 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709960521; cv=none; b=F4wb2U7pVfMq+IP7zz4afR40HqTxcPeo2Q9H7iYvdEvPjSHwfxA1RKsUQY9mKdDJMK8xpAWmf0QhxbHWrF8CFgUoFauZKS6OY2nMl7bQXBpANvy+rUhAzUFZGl8UxVen0cA8ZzsEEHE8p7Z2NREuknOuyOHY0HwxH1L1Gj2pxNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709960521; c=relaxed/simple;
	bh=q/mKtUyIHp2P1tXA8EgYGneMh+II7SaGDgn8hCOM4Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJ9usRDzdPwhj3OmzkCMwY271JdIP88ptlpegFkOXJ5BflK9qG6Df8T1H6VlXsvoT02ebF37JljgJXF8Jrp1Gxu6fhdsvKOKUEvslYRV6zUYPLOJ6mkvURUg3NjyuSHJQvuzF00GfTKplEIEoGWEPiLVBWTCLnPotHNKzS6/QTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eRJRVBpP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=+dmMM5sP7jm3IQ10EcQ/oF53RCutABKC3zszuGrAmug=; b=eRJRVBpP+hDPeoTydnpfcslrF5
	OKFRYKTa5B6RZFEBTEK6/4mjHjm28ta2hKtmtGrqjxGKR5O734E0NeGJmlm7ExuM2STIynpmddZ9H
	qO8ZldGhRT0e1F6gZPRniijUVk0O+fBLf1pg06nGeYsL+0mcB/0raj038qT01w/YGdX0qjqJ8YeQt
	woBYG23ofHBQd1n1UALctDWDNUNohTngFj1uTLmnn31gMErQOZ2xlbFW/LMNQsPG2daE8JQDEHeW2
	RJOJ4cJJAouXMC0fwU/wHVZlFwOQTNDearcplJIJuDsDRdR576zbwrra/FDh9Ne3MLTh9A8/t2JUa
	BZxbM+cA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rioq9-0000000D3Cq-1PKl;
	Sat, 09 Mar 2024 05:01:45 +0000
Date: Sat, 9 Mar 2024 05:01:45 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Gowans, James" <jgowans@amazon.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Roy, Patrick" <roypat@amazon.co.uk>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>,
	"Graf (AWS), Alexander" <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
Message-ID: <ZevtORMrVbTsauzn@casper.infradead.org>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>

On Fri, Mar 08, 2024 at 03:50:05PM +0000, Gowans, James wrote:
> Currently when using anonymous memory for KVM guest RAM, the memory all
> remains mapped into the kernel direct map. We are looking at options to
> get KVM guest memory out of the kernel’s direct map as a principled
> approach to mitigating speculative execution issues in the host kernel.
> Our goal is to more completely address the class of issues whose leak
> origin is categorized as "Mapped memory" [1].

One of the things that is holding Linux back is the inability to do I/O
to memory which is not part of memmap.  _So Much_ of our infrastructure
is based on having a struct page available to stick into an sglist, bio,
skb_frag, or whatever.  The solution to this is to move to a (phys_addr,
length) tuple instead of (page, offset, len) tuple.  I call this "phyr"
and I've written about it before.  I'm not working on this as I have
quite enough to do with the folio work, but I hope somebody works on it
before I get time to.

