Return-Path: <kvm+bounces-28448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4129998A5F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 828A7287C1B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D63A1EABDB;
	Thu, 10 Oct 2024 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="G6Dmp57C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="T6CZztMf"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02571CCEFA;
	Thu, 10 Oct 2024 14:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728571022; cv=none; b=ZC4699HQ4YYYPlQ27ewfBkQS5SJ3humdquQVohgVz3AAfVnvYTbPvNnNqdk+IgPXpzv5hhZYU1nRTq2U4uioBpV62JwxZTtob2pI5o5MYuPZ3BcFvG2r2a7/uiN2zUaocz01FsM3/3JoAtZuEbTSqYF/3D5J6AG30yf2M3zyGr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728571022; c=relaxed/simple;
	bh=+eRxpZf4A8uSZWrwnpAMgODuE281mC7Oh2bHtUxas7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkPsDcpyR1Psy2kg3xXBgofOtS+HuAL8pxE8XjbG3rQkV7z8dRxVk+AoemEtJQzVe9tPedvvalALtqsHaYFdcA0mjcuY14REuWvwJnYAyWn0rviu9aEQZ6wyrJxtmrmckpyXnoEO5LI4AhbBLScgGZb+fk79t/TIUe5tSRG7wm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=G6Dmp57C; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=T6CZztMf; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id D168E2007A3;
	Thu, 10 Oct 2024 10:36:58 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 10 Oct 2024 10:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728571018; x=
	1728578218; bh=flRm1BokDLMvxzrVka91UpcRv5MTRteKyP5Z9UtyoZQ=; b=G
	6Dmp57C8sQ6+zv6SVu5LZ/o9uljIOnJsNgWQ2OLf38ArVUZhaAT7udceSAYnbMmG
	J2wl+vqWhxEJNXJCG+3IqZyqwqyK749SE5ibpielzwV+5rpFgj+JPmqBNXsGEl/6
	O1N4ilE4nzy3dFYvoqiL16YMw7ivwJ8XpAr0RtM5bfTX1jRy61oaHUXSwFxk+an2
	59A2X5x06Zgs5yk3nTh5Qd5/NJxzSRJPYcuqYxPUbgECfvZZdn2Dc1md1mwWu/Rh
	AkeTt68L3hXshMWGXcqGASiZG7yqcgfC4nHHcEOjYTXlFcWAZvbkkkk+NolfvLmM
	C6ucG3qzQLlYAgXSDRX/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728571018; x=1728578218; bh=flRm1BokDLMvxzrVka91UpcRv5MT
	RteKyP5Z9UtyoZQ=; b=T6CZztMfwwkJxguBMq3sg4Qa+DsdBBF5N9noGqlJ24xz
	AJKH5WVxYSxA0+IdfcY89VBA3NaSpr8EK046g400FSPFYCsSi6bGOX04C9qnn7Pt
	43SAkNe4RNjOdO0xPF970xWSSloZdqJQhZwOeupOyJLxk66ZxNnJ8IdJO7LxF6Gr
	KgwWHfmOpfFLV+o2JXrbmh8AHEnOuaXGbYa9YQZZ/4nwGF9eZjAAMf+ov9Fyiz1P
	fo1/o8+hpZRST5Hvkx1wolgjUmtRmjogOI4sirASfY6OFhMaG/KrOsvF2ggVReeJ
	+4JTDv/5Ux7epfZiyE7X2ztVF3hXOvgi+Jh1HtRNQQ==
X-ME-Sender: <xms:iOYHZzd99__K9bi2wyMlu-g-lRxGUf6d51NBtGM_sE1s1J0hAvu1ig>
    <xme:iOYHZ5PWib-EN-rzieFJchbC9alOYDTZvk5KSZWvZzKJlAvOHc9Ro5MQiBxAm4SVL
    xh-KYnJXHPzHW2LQHg>
X-ME-Received: <xmr:iOYHZ8jGXKXMheY8rKRT6au5s_qg07IasgHtt3QUQEdsBOWuC8x6ysKfvVFulrQ3H3PMXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefhedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepiedupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtrggssggrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvhhmsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqmhhsmhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggt
    khdrohhrghdprhgtphhtthhopehpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehm
    phgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopegrnhhuphessghrrghinh
    hfrghulhhtrdhorhhgpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhi
    vhgvrdgtohhm
X-ME-Proxy: <xmx:iOYHZ0-_W7hu5Wp8SyaR6znszN1si28MLWPMF6Fw2-TX2wuw-utj2Q>
    <xmx:iOYHZ_syCQgTa_Z-EWTd2w3h5dhvP4XaOZ85ECFkHqvfkWWQm28U6A>
    <xmx:iOYHZzHTAtreKpmBFpRxbnCJrukLJBMwrdv1I8s2wdyo61RjDUpgFg>
    <xmx:iOYHZ2ODu_6295lFX94QPuBxXBmkl1gkJpK2295FCcb8-cKPYpqZ-g>
    <xmx:iuYHZ3IO1JbgI3yM2KATGNWCOTZB8b5VyPXiIkp_JmiB9hG5LgbVSRK3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Oct 2024 10:36:39 -0400 (EDT)
Date: Thu, 10 Oct 2024 17:36:34 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, 	paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, 	viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, 	akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, 	chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, 	vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, 	david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, 	liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, 	suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com,
 	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, 	quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
 	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
 	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
 qperret@google.com, 	keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, 	jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
 	hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
Message-ID: <w6oyjtjsroycxgiicnnrjcaddpl5vz6lfzvedtaz4miilsnkga@xyylfwo3ezcn>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
 <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com>
 <mr26r6uvvvdevwqz6flhnzbqjwkf7ucictnjhk3xsuktwsujh5@ncf57r3v6w6p>
 <CA+EHjTwEmXcQhCzGJG1icBzHvWEBUVVH33-ng60ngup6LMcC4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwEmXcQhCzGJG1icBzHvWEBUVVH33-ng60ngup6LMcC4Q@mail.gmail.com>

On Thu, Oct 10, 2024 at 03:28:38PM +0100, Fuad Tabba wrote:
> On Thu, 10 Oct 2024 at 13:21, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > On Thu, Oct 10, 2024 at 11:23:55AM +0100, Fuad Tabba wrote:
> > > Hi Kirill,
> > >
> > > On Thu, 10 Oct 2024 at 11:14, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > > >
> > > > On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > > > > +out:
> > > > > +     if (ret != VM_FAULT_LOCKED) {
> > > > > +             folio_put(folio);
> > > > > +             folio_unlock(folio);
> > > >
> > > > Hm. Here and in few other places you return reference before unlocking.
> > > >
> > > > I think it is safe because nobody can (or can they?) remove the page from
> > > > pagecache while the page is locked so we have at least one refcount on the
> > > > folie, but it *looks* like a use-after-free bug.
> > > >
> > > > Please follow the usual pattern: _unlock() then _put().
> > >
> > > That is deliberate, since these patches rely on the refcount to check
> > > whether the host has any mappings, and the folio lock in order not to
> > > race. It's not that it's not safe to decrement the refcount after
> > > unlocking, but by doing that i cannot rely on the folio lock to ensure
> > > that there aren't any races between the code added to check whether a
> > > folio is mappable, and the code that checks whether the refcount is
> > > safe. It's a tiny window, but it's there.
> > >
> > > What do you think?
> >
> > I don't think your scheme is race-free either. gmem_clear_mappable() is
> > going to fail with -EPERM if there's any transient pin on the page. For
> > instance from any physical memory scanner.
> 
> I remember discussing this before. One question that I have is, is it
> possible to get a transient pin while the folio lock is held, or would
> that have happened before taking the lock?

Yes.

The normal pattern is to get the pin on the page before attempting to lock
it.

In case of physical scanners it happens like this:

1. pfn_to_page()/pfn_folio()
2. get_page_unless_zero()/folio_get_nontail_page()
3. lock_page()/folio_lock() if needed

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

