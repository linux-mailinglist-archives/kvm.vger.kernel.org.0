Return-Path: <kvm+bounces-58135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEF7B88AC2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64D0E1BC62C1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7E32F4A1F;
	Fri, 19 Sep 2025 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baC3GNGE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F257C2EFDBA
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758275741; cv=none; b=tzhoNJmTvDlof2DE4j2qXxmgC+9RtO1i570DnfyBdAyW8WPu94KEEhRr3G/uK9pPuvZGx1dpQgdpWA6VwWke5fjmZdlVi2eigyhDY/HvsUrtRkfp2ex41gQazwATOqSMTajc/7Oz9Q1GE+0bgzSzMpgwGGUFQGkU8024/QDRQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758275741; c=relaxed/simple;
	bh=9ZYD2O5yqvIh6f2etaVtF8OL7RJcUChYaE/qwOAMi68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3rh4hXc9f+FCtJlELRa3e+7GdpQ4FLUDt1Yxg0p92eyHVqsp3Xjl44pjDEhZKV/mYooVwoEoN6hAp9F95pI3iqnaQQx1ysiaLWKZa5oF4FUAQhxHZZm/l/gUgC99F2IuqJ9Kol0RFA6kt/QVxEFYeTRQr6zzdLAnt8xhRHBciY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baC3GNGE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28686C4AF09;
	Fri, 19 Sep 2025 09:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758275740;
	bh=9ZYD2O5yqvIh6f2etaVtF8OL7RJcUChYaE/qwOAMi68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=baC3GNGE1xdksGHpX5XvUBE3VcB5lk/WLyPycF2N9is0Dmedj6TUGgmQkywVsJUee
	 EsOLpTl1u0puEOAQYlwBAt1hx7YzdDJAlnsQzzDQSdxjXWr54DkZCzAFMHhIplTZ0H
	 9oo0lxxAUmKqg94HXULOIChSOzrId1jyqtQLVvEIkuECJrGxkyW5wmq8wUwv+AVc3a
	 txho3XIn3AZm2+pbV8DIPkK81qKMMAVaegZfZKHlrp4JB2gxxw3yZYQZilQQq1uTGg
	 2EF3o959iTcAWLmizpWrHDp01cqqjfa4tKZUkVzec8v7KIO6oGs9X3H1JIByceeLbV
	 v4ERtC0A+JMvQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3B42FF40066;
	Fri, 19 Sep 2025 05:55:39 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 19 Sep 2025 05:55:39 -0400
X-ME-Sender: <xms:myjNaKSpRft0M17CjMw02_r2ZwJJHvB44EznM8BsQwZm6BbCa3ReBg>
    <xme:myjNaKJ6s8wWRTwh5nH87PAsHcOx2WQDG4tmO-qvRJ9nUHnAblHHpFGDYYSOMG6BB
    gqmDNYqQ-fpJGAUnUY>
X-ME-Received: <xmr:myjNaDZEyo0_kh-KtL8ADANnSNDsdahLH27NcgUkCvorU5WTKtyvrSLifdOzCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegkeeltdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epsghpsegrlhhivghnkedruggvpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghl
    rdgtohhmpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlh
    drtghomhdprhgtphhtthhopehishgrkhhurdihrghmrghhrghtrgesihhnthgvlhdrtgho
    mhdprhgtphhtthhopehkrghirdhhuhgrnhhgsehinhhtvghlrdgtohhmpdhrtghpthhtoh
    epkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgt
    ohgtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvg
    hrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:myjNaABKzxu2sSXbXhS5z5-0W_pWtcvSEN2KgR32kwXkj9CxPq1oPw>
    <xmx:myjNaNUT9xp0OH81Os2dAT3Uz-702MbCGapEafwSLMeGjElIPOX2_Q>
    <xmx:myjNaB2ciEcOrg2hLdEK-GddKSEumHG-JxAz7Ka9EmlTCyzUvc_-yA>
    <xmx:myjNaGU-EExkmFeJpecZLrzdELuRW9vx4AfT44Mtcbo2f2iPPD-0Dw>
    <xmx:myjNaPDPpPnbky2_KeTujRdtDDrQ9VZCFlCvfGESI68nDGxa9G_uzUwc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 05:55:38 -0400 (EDT)
Date: Fri, 19 Sep 2025 10:55:36 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@linux.intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	yan.y.zhao@intel.com, vannapurve@google.com
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Message-ID: <l3wzjxkokrcuu7mguuojr5vnzfwjpjfxgg3d6pw5zmmgsgpdfv@wz6gvpglqkiz>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-13-rick.p.edgecombe@intel.com>

On Thu, Sep 18, 2025 at 04:22:20PM -0700, Rick Edgecombe wrote:
> In the KVM fault path pagei, tables and private pages need to be

Typo.

> installed under a spin lock. This means that the operations around
> installing PAMT pages for them will not be able to allocate pages.
> 

> +static inline struct page *get_tdx_prealloc_page(struct tdx_prealloc *prealloc)
> +{
> +	struct page *page;
> +
> +	page = list_first_entry_or_null(&prealloc->page_list, struct page, lru);
> +	if (page) {
> +		list_del(&page->lru);
> +		prealloc->cnt--;
> +	}
> +

For prealloc->cnt == 0, kvm_mmu_memory_cache_alloc() does allocation
with GFP_ATOMIC after WARN().

Do we want the same here?


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

