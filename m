Return-Path: <kvm+bounces-54567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF77BB24325
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EA5E7AB140
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 07:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B2C2E36F1;
	Wed, 13 Aug 2025 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McGU4oFR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAA82D4B6F;
	Wed, 13 Aug 2025 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071407; cv=none; b=cZO3XlFu8uwL1LDNmMR0JG9Mq5G/qENsEMPUnVzm3kq2gLXN6iu9i/cbDAUxFoznsbeDT/0zfZij4pvZ7mHBRbLUgxeFr/eM+YtccoO9QuEg87tOGq4AOPLoKr9mVsrKozDtyGo0oe1FjH75OT9G2mRLbYMSHENQMGxW1gJonaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071407; c=relaxed/simple;
	bh=qflKKzsxeh62DKmEZ0kFSloy6cvOENKAOLB7/nti7tE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b34Wpk+DvqtqQn/kSAFpk0QwWmRk8w9h+PWsm9ycJqdXRead4Q+t5+Wpwq4RAMpwQvR4JgFvSjbm9Wyd7uBRkCSnAEj8/0lhYC8tCQ4Wf1B55ZYVSUysT5QMnK2kDVmP74zB8U0cRkQnPWiLVAJaBGn/Cutt+SEd7n5ZIvGC/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McGU4oFR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9B4C4AF0B;
	Wed, 13 Aug 2025 07:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755071405;
	bh=qflKKzsxeh62DKmEZ0kFSloy6cvOENKAOLB7/nti7tE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=McGU4oFROenBDz8M3ormS6YmSF463XidneJBObfJ/rDQUE5A3kZk4qAvoTbQR9RqA
	 LG/Ts8b25T3QjMZIXefhBCl9tz+KX85U72Hiyhw/6/D1pBAlxrLznEUdQPLWQLQtNq
	 sW9FIhlvbBfFVzVI/ESEJw++jpRi8vFWzHbOLn9SQTb9C6nAG49Jsaxd7cC9G2w5N6
	 GVNKz/TIwUeC0KPpO4XSx+P+9Kw0VjnxXzN2vReCxYjVbk18gmFB7XyoIYLM3oL/Jz
	 Vsgavig0yS+bt9LyyE3BX04b9KSYknFuFhrRAybnIByBCKHNg1CRuoH/GwO/E7gmTl
	 bsqA9Oe2BbLLw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1B596F40066;
	Wed, 13 Aug 2025 03:50:04 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 13 Aug 2025 03:50:04 -0400
X-ME-Sender: <xms:rEOcaPwpH6jsxg4WmH4rcN4nwc8q371Z1Dty_L9HTzcg9_OcaXmIzw>
    <xme:rEOcaEZewtsXU9O0pEjLsCfeZflK3RZ73QHacRDd8aE7-52m3pvePvUSrJbTRjZ3v
    wAgshGUGanS2h2Y-n4>
X-ME-Received: <xmr:rEOcaJzvbW257D_ZcZc6zMiCcgZ-brsobVBFtULdCx1VaxeHlFkw0ABRpUlb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeejieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtieetueehudeluedvffeguedvfffgueehfeelueejhffhudegtdetfeeiledv
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpth
    htohepvhgrnhhnrghpuhhrvhgvsehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhgr
    ohdrghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglh
    gvrdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    sghpsegrlhhivghnkedruggvpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlh
    drtghomhdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthho
    peihrghnrdihrdiihhgrohesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:rEOcaKiuviTk7n1zq0wJGw7BIqQfNvLfkF4dHRuC-qux6OGfzj36Uw>
    <xmx:rEOcaIoIm_Yixx5yZv5E652V24rIQUz9Q7KxPaa9HEBRSzo877ogbQ>
    <xmx:rEOcaJcwH6Q3OlyZh8HAvqXQEio1DeFOP1tSUEELwtg2qTj2Y6ylxg>
    <xmx:rEOcaLcmS3ZVu7IFnSwVMXlqQC-xg11JTA2CAYirOwptq29rdiC-vA>
    <xmx:rEOcaPedY08DOYOLtSuzjmWc5ZnQugGWfzrOtKG3lM8olODaWt6a6q2S>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Aug 2025 03:50:02 -0400 (EDT)
Date: Wed, 13 Aug 2025 08:49:59 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <z6itjtzwv6pelozn6f2kp6k4s5baeodjlptrsccbvipbfzifuh@4opoeluu6anb>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com>
 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>

On Tue, Aug 12, 2025 at 03:12:52PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-08-12 at 09:04 +0100, kas@kernel.org wrote:
> > > > E.g. for things like TDCS pages and to some extent non-leaf S-EPT pages,
> > > > on-demand
> > > > PAMT management seems reasonable.  But for PAMTs that are used to track
> > > > guest-assigned
> > > > memory, which is the vaaast majority of PAMT memory, why not hook
> > > > guest_memfd?
> > > 
> > > This seems fine for 4K page backing. But when TDX VMs have huge page
> > > backing, the vast majority of private memory memory wouldn't need PAMT
> > > allocation for 4K granularity.
> > > 
> > > IIUC guest_memfd allocation happening at 2M granularity doesn't
> > > necessarily translate to 2M mapping in guest EPT entries. If the DPAMT
> > > support is to be properly utilized for huge page backings, there is a
> > > value in not attaching PAMT allocation with guest_memfd allocation.
> > 
> > Right.
> > 
> > It also requires special handling in many places in core-mm. Like, what
> > happens if THP in guest memfd got split. Who would allocate PAMT for it?
> > Migration will be more complicated too (when we get there).
> 
> I actually went down this path too, but the problem I hit was that TDX module
> wants the PAMT page size to match the S-EPT page size. And the S-EPT size will
> recall.

With DPAMT, when you pass page pair to PAMT.ADD they will be stored in the
PAMT_2M entry. So PAMT_2M entry cannot be used as a leaf entry anymore.

In theory, TDX module could stash them somewhere else, like generic memory
pool to be used for PAMT_4K when needed. But it is significantly different
design to what we have now with different set of problems.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

