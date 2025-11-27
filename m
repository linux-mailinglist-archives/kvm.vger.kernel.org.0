Return-Path: <kvm+bounces-64885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C396C8F710
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACB43AC9AB
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCE73376A0;
	Thu, 27 Nov 2025 16:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVbP4vYE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6419931A065;
	Thu, 27 Nov 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764259495; cv=none; b=YlM/F0nbhHNXUkoLs+19A4MJD6Fyuzbs2NSgHXew1IpaM1+YvJnWfhFhVgde8pJfYz0wENFR2Dst/dto0qvI0Evtakui1yApUg9fPnPn7BKJJwnk9I2oGGV/7eHqgGrAOGmbsFHVYoQIKEmEFReJEdQU90Z98U/2OQMEjvXeC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764259495; c=relaxed/simple;
	bh=0AGi45zE5oD7fgJJwyTu7DJC2zOFoRzm28PL3pXzBJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjuO32tYyCGQKIkfBh0n/Gu1xf9bc9Y/B3a3PxbPSSXORodGbSl0KBKOxPE5RSIbKWd+6soa4s1qfMX7xO4OqMAJ6Tr8X6aViMiEF22YzxQipp03hhfFVpEgKA9Nsrz6+P/UmUAOpa9MA5P0WKVYDJODiQx+yzY0hz4RCi6/f7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVbP4vYE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79141C116C6;
	Thu, 27 Nov 2025 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764259495;
	bh=0AGi45zE5oD7fgJJwyTu7DJC2zOFoRzm28PL3pXzBJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVbP4vYES/bYJ1Nm7FSb+6ELambagvqVMVZbBEuaz9rUkpf6F3pLy4UOIuv1MJ9iL
	 P0HmD/+zmubrC5kMGvQWEAXM21lzv7peVlg6TAgQi/H85ppGKXv8Y5glT5UtFyS2pb
	 ofMzUkc0vLiSSBRPFIQqDw+VORpXbBD6zLERGXeqZSvVeAzT8xuClUqDIitbj5d8ug
	 CClVu8+ynKUn3ciSUC7yiKatUGAlCANvPMV2HlQgikUeVRKGx6Z2nm+Yv9+A9ek/U1
	 WsDO4y20KhUbuDuzUcXcjyg5W4nPv2nJNHA24NVb6Ss7NN0kk7vLGwreOejeSSX/63
	 5kkFjBHPW6Giw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id AEE05F4008E;
	Thu, 27 Nov 2025 11:04:53 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Nov 2025 11:04:53 -0500
X-ME-Sender: <xms:pXYoaYALUCRgGO8Mam32bMuroYAHkeHxtL3aco2vBos4sMkRAeB5oQ>
    <xme:pXYoaQrJ9Pe2LqjIHQMyEqtbH001DugYUfeEhJ5vi8llqoGL17CT3mGrzVDVfMXim
    -F8XRgUZfrFYOVZsWsA3pcB7gQA2CrqboKKGwXBERehGN8bKqM-4BU>
X-ME-Received: <xmr:pXYoaSFHQks44hb9oDmfC5Ln9dAINTCTtPZtR0YvaWgogPAU4HqVhl1T-Xc85g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtieetueehudeluedvffeguedvfffgueehfeelueejhffhudegtdetfeeiledv
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeegtddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpth
    htohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdgtohgtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehkrghirdhhuh
    grnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtohepgihirghohigrohdrlhhisehinhht
    vghlrdgtohhmpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhesihhnthgvlhdrtghomh
    dprhgtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthho
    pegsihhnsghinhdrfihusehinhhtvghlrdgtohhmpdhrtghpthhtohepshgvrghnjhgtse
    hgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:pXYoaYyEJJimpP_tzZWoR2XTiPFeHpxQ2b1bY5FuNuvWBgayoRoi3w>
    <xmx:pXYoaQ5XuQKgmRMS47p5G9V6h_68XBYYxVhDdueVW3hwxcatOlxPog>
    <xmx:pXYoadANfFYoXLgqJLvgNIc9cvORK7oHvmNClRr_sue4N6i2S8D9eg>
    <xmx:pXYoaV1oqPUC1E_MVwopH_fEJnq9TyJiZfABlu2zLfkNLwMt8hIPwA>
    <xmx:pXYoaQHuxgS5XJHCjvnskra6GUMoPlP6gY7ddBEC-f1hFXObAWMvt65o>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 11:04:52 -0500 (EST)
Date: Thu, 27 Nov 2025 16:04:52 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Message-ID: <d7leyylgtg7u5rsmfpy4kwkbvzlketw7lquw6gk42ydgrzej6z@7eyts5imw3yo>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
 <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
 <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>

On Wed, Nov 26, 2025 at 08:47:07PM +0000, Edgecombe, Rick P wrote:
> Kiryl, curious if you have any comments on the below...
> 
> On Wed, 2025-11-26 at 16:45 +0200, Nikolay Borisov wrote:
> > > +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void
> > > *data)
> > > +{
> > > +	struct page *page;
> > > +	pte_t entry;
> > > +
> > > +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > > +	if (!page)
> > >    		return -ENOMEM;
> > >    
> > > +	entry = mk_pte(page, PAGE_KERNEL);
> > > +
> > > +	spin_lock(&init_mm.page_table_lock);
> > > +	/*
> > > +	 * PAMT refcount populations can overlap due to rounding of the
> > > +	 * start/end pfn. Make sure the PAMT range is only populated once.
> > > +	 */
> > > +	if (pte_none(ptep_get(pte)))
> > > +		set_pte_at(&init_mm, addr, pte, entry);
> > > +	else
> > > +		__free_page(page);
> > > +	spin_unlock(&init_mm.page_table_lock);
> > 
> > nit: Wouldn't it be better to perform the pte_none() check before doing 
> > the allocation thus avoiding needless allocations? I.e do the 
> > alloc/mk_pte only after we are 100% sure we are going to use this entry.
> 
> Yes, but I'm also wondering why it needs init_mm.page_table_lock at all. Here is
> my reasoning for why it doesn't:
> 
> apply_to_page_range() takes init_mm.page_table_lock internally when it modified
> page tables in the address range (vmalloc). It needs to do this to avoid races
> with other allocations that share the upper level page tables, which could be on
> the ends of area that TDX reserves.
> 
> But pamt_refcount_populate() is only operating on the PTE's for the address
> range that TDX code already controls. Vmalloc should not free the PMD underneath
> the PTE operation because there is an allocation in any page tables it covers.
> So we can skip the lock and also do the pte_none() check before the page
> allocation as Nikolay suggests.
> 
> Same for the depopulate path.

I cannot remember/find a good reason to keep the locking around.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

