Return-Path: <kvm+bounces-28413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD7E99834F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D28231F21B08
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393671BE874;
	Thu, 10 Oct 2024 10:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="d6UDYk1y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GTucPEDk"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2530118C03D;
	Thu, 10 Oct 2024 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728555271; cv=none; b=Mnl66BeEa+jK3+CAN6aaFPrlKLySa/PxImXR6eCKz+gPnGAflCoZsgN95E7E6vK3N23KwsFxE16n7rcZB17tj9ct2aPOZK0yWx9CBzW4yeqpU/Qlspx6/97QHhRyBKLmExYuajwmkUYDJgh1kbht69DC8xEAO2qpTef1wnFokLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728555271; c=relaxed/simple;
	bh=4XOtTBDm80OCEtb00/GJBSJ0Kj8E7EAKTwU4AEHFFIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RU3JeXwU8aKOJw4ilZ2PbohZ1KailyyKDlUHmM3MEKcnoPztSM1pFiDaQFBRR9HDWZfyS4wUuL232wjEbctQ00SkrmsLwSQgJdGb+qxclWh7feaZ5pr6ITRB65Hiyvtc/54nqFUt9BNuzOXuKYlII9CSEQ7LxlxK10qspiB4VhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=d6UDYk1y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GTucPEDk; arc=none smtp.client-ip=103.168.172.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 1B9A5200A8D;
	Thu, 10 Oct 2024 06:14:28 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 10 Oct 2024 06:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728555268; x=
	1728562468; bh=NXHWpk/5+EQAj4xJzSdQnJKqj7apSDgb8yWFmClPgYI=; b=d
	6UDYk1yz+a/v0elUD0ReW9J/h7naA0kWjZwY1SmcWd23AWrO27HUenUp3BCOVYKW
	Y5kPp7n7Xhaw/2Sdof5rHtNh5n6FgWET88Is8foFKHfSPrYCLyUZKbVJGx7X7i4Y
	WbvBRyVPUNokB3Xd2QySpCCGZf5GFzSqfPS3GSxGTUNtTblxPb/cIWJrs3mfmLVQ
	61sRKuylLJypcU0aa9mTyKY/3I0BlRrHh0bx0yzy4eud736yMqxOx0DZE5I2sSu/
	fxGw95L6riD8ClxHUKVAOyfrJHDb5AkRRrUpCJ2yO7XD0EeJm1aRgjU2jM9qLf4g
	6aMJdEAZ9PO3QxCNCH3TQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728555268; x=1728562468; bh=NXHWpk/5+EQAj4xJzSdQnJKqj7ap
	SDgb8yWFmClPgYI=; b=GTucPEDkbbaL9wcHDUrx+QDdHlrrQx9GJxTx/JRgyh7y
	gzth01EghcsdF2lpsLBy2eZA88mMZWclDNG6pcN9F4Pp2PTjFleW0kY+Mv+QSzGo
	CZW97jdGXZEu6cuKgj87Hay8yRCdf4n1RUQL5aolbJJd5dAzpzvGWcZprbOrv7pG
	3XUSZ3C2E2fGPM1Svt0wu9WGL7pDk3jOGm2EceC1um4mHtfzmxLbWxcEgUurJTzf
	pVs75J1pg5/cg7/eoq0BiMkXRApI1Hcd1p9Uqkl+8hWBUrvEvr8Z4cgSCt6Zy2R0
	9gEg0zxboWudIufgDw3Q5mYvHkkSAAyoFr7goiHMfQ==
X-ME-Sender: <xms:AKkHZ3tx2lp6y25YOCi1TiKPcSVw6WDGepNp_xRbQFkxbzhG1edG5A>
    <xme:AKkHZ4fvUIAMx9savshJg6R82OPDDalOuzMbFG8AVo9_ma2ApDEThRzbZ4ojnXKg4
    GjrZJGfS82TGX6ojoQ>
X-ME-Received: <xmr:AKkHZ6yefTOeZpEa7uECkJ7zqr8qstNsC5_efEiogLhGgAeFNBh-SpTbxyGlbxBPvzXW1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdefhedgvdejucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:AKkHZ2ODfnzocGPow7KDLhe41iato70gAk-7vPYXfbRfvN02muJXag>
    <xmx:AKkHZ3-ncOE6aD2k7LuD51g8_jc18sWtwQJGuCMw3Wnb9e643uTiuA>
    <xmx:AKkHZ2UHbj8BuMxQ5qHVW1rXiXqWW2VyGweeRTrXcj5h9cBWWge0cA>
    <xmx:AKkHZ4d1N7Yqtbt4bQDOZL_fd5XxlgxvmD0uog2S1wt07Gj2cpNWUg>
    <xmx:BKkHZ_am_WdwVLgVtjHltkYQp8SuLRBIluzNFJsfn3VPZcavTYCIa7RL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Oct 2024 06:14:08 -0400 (EDT)
Date: Thu, 10 Oct 2024 13:14:03 +0300
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
Message-ID: <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
References: <20241010085930.1546800-1-tabba@google.com>
 <20241010085930.1546800-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010085930.1546800-5-tabba@google.com>

On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> +out:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_put(folio);
> +		folio_unlock(folio);

Hm. Here and in few other places you return reference before unlocking.

I think it is safe because nobody can (or can they?) remove the page from
pagecache while the page is locked so we have at least one refcount on the
folie, but it *looks* like a use-after-free bug.

Please follow the usual pattern: _unlock() then _put().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

