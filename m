Return-Path: <kvm+bounces-43190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B001A86C97
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 12:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9331B66C3D
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 10:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536151D7995;
	Sat, 12 Apr 2025 10:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="McFtSU2O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PLMIUvIr"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3018A6AB;
	Sat, 12 Apr 2025 10:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454709; cv=none; b=RZ7737N12qElNe0e7u2A2BQUqAcJBg8rl+S6paenwi/Y0E2vHI33DkSHcz89+JdP4um8hzyo56zelIiZGsqDmWLmt+FzQabrLR5W8M03i1ClwwcxI60Vd5Hc/BFrcfzLHFJ6+aGMdBF01t3bRwrT+xYXLCinPxtr8MwVb4mYLKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454709; c=relaxed/simple;
	bh=FrZpGgFmCBdS3NdARYiimpGnDi2QEYs8YJOvqKwY1tU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Dh9Vgouvh4K146cSQRgcu7XTDyI8arjVpr6R5diZ5TjSlElw/FNbM0VrJJzASk6BLaCqpqRpRlQmueUbPicXgatH6iKYjvzQLkHMf/Zb4fQlQ8AIr0rsjT5oc/gC1aBNZzS8Hq0vDD3t1yFZjCiNLKgwg0+1eCZ60BhtzvbLKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=McFtSU2O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PLMIUvIr; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 15C3525401C4;
	Sat, 12 Apr 2025 06:45:06 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-05.internal (MEProxy); Sat, 12 Apr 2025 06:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1744454705;
	 x=1744541105; bh=kmyaGiukhBQ84frNIkSXQYkdJMrCRvN9saF+IdoGolw=; b=
	McFtSU2O/RqT/UjvqSkjQJDtCPRSD1SZoySx2Z/1dkwKTHSa/8qDdiyLRYwKVe8X
	LltppI835pFAs3Ep2YU4TgrpVfYcaKVG2DllSQFSa5jnuhDFeYCATwgXQurjKjPO
	XlH09a7JGANj0FRamRxpj28hJJo4EGNHNCW2pwKIguZQS+5SpgG0/b+aTb/7AJJ9
	ZiCzKOogOw5/C/rt9xFh0/ZEMAMziyYwa5yopDEWfzfSxfYSyPu9Aj+pht7QLPUM
	v3k8/LXov2dFpQcYWhPn481E155Jw2MUwUHAA+1VZMKVKmf3dOsw3tbpI0gmZXyp
	y/fDQsa0lRrpl9XLoru2Ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744454705; x=
	1744541105; bh=kmyaGiukhBQ84frNIkSXQYkdJMrCRvN9saF+IdoGolw=; b=P
	LMIUvIrQ7acjRyUNm4LblRDYmNP5hN6KoibRG/HW1c6J+OYeWBv6cmzO7nqzmLix
	nrXaFWnifZym/vBtgNSJGa4x5YwEOENKtOvCPBX6T8lqQJvh3YDopFKNnuXg2rcG
	We8s3/sFeArS1/2/NyRypI/4yW1XGExViDUQDXiDiL842amMw0cQ0jEqeZleLstg
	/kZOkr5pUm6Q5ywQks1ShwNLM6KeeiwapyhXQ6DxqdgWNEDtbU0mzdTEEM4StIWq
	KpGp9tiUhiY6gLAMGMl2ThAZNVXWgGo+4E1Nl1OjkHHfN9sTkezlNJIT+WyayY0Z
	f6dFUiLB+nrxQgLagBiYQ==
X-ME-Sender: <xms:MET6Z_diDxBf45Q4FT9Yc-FfdoDWLNKg87fTBYq_dVknQ10oYgSaeg>
    <xme:MET6Z1MpIV8PW5hw8sZilbHr9PPOZ6Or80WBYu4mU9vRYj6X3dYM9VIOSgi12YcDT
    4gUT3b5osphWq_zaXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvudegheefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnug
    gsrdguvgeqnecuggftrfgrthhtvghrnhephfdthfdvtdefhedukeetgefggffhjeeggeet
    fefggfevudegudevledvkefhvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohep
    udejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvg
    dprhgtphhtthhopegtihhmihhnrghghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohep
    shgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrh
    gruggvrggurdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhesihhnthgvlhdr
    tghomhdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprg
    hrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:MET6Z4iCI1Z1UjtxHKIclRx7AcbRXECDfBWxH5tTFHqr27KgKHikWg>
    <xmx:MET6Zw8wqB7vGkncjjXjDNU3ee2ushCEl3nMTnD9r4gtNE3D2zM_xA>
    <xmx:MET6Z7u04bQLDsNMyvj8owoi66BMJSGFy_sG8x4iZO28WLzUG3jCoQ>
    <xmx:MET6Z_GRxBPFmPnQey9UJy2lxW5nNOxPpOX_m_7pB5-HF7jAB6VQ5Q>
    <xmx:MUT6Z486sWR7ZefEk3LvUKJJ273YHrbFdOVmFnXmykwn8hRFL41LNb-f>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7DFE32220073; Sat, 12 Apr 2025 06:45:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Teb9e062682a72887
Date: Sat, 12 Apr 2025 12:44:44 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Mike Rapoport" <rppt@kernel.org>, "Dave Hansen" <dave.hansen@intel.com>
Cc: "Arnd Bergmann" <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <4a75978a-2368-4aab-bed6-ce44b6d3c323@app.fastmail.com>
In-Reply-To: <Z_o7B_vDPRL03iSN@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
 <Z_o7B_vDPRL03iSN@kernel.org>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Apr 12, 2025, at 12:05, Mike Rapoport wrote:
> On Fri, Apr 11, 2025 at 04:44:13PM -0700, Dave Hansen wrote:
>> Has anyone run into any problems on 6.15-rc1 with this stuff?
>> 
>> 0xf75fe000 is the mem_map[] entry for the first page >4GB. It obviously
>> wasn't allocated, thus the oops. Looks like the memblock for the >4GB
>> memory didn't get removed although the pgdats seem correct.
>
> That's apparently because of 6faea3422e3b ("arch, mm: streamline HIGHMEM
> freeing"). 
> Freeing of high memory was clamped to the end of ZONE_HIGHMEM which is 4G
> and after 6faea3422e3b there's no more clamping, so memblock_free_all()
> tries to free memory >4G as well.

Ah, I should have waited with my bisection, you found it first...

>> I'll dig into it some more. Just wanted to make sure there wasn't a fix
>> out there already.
>
> This should fix it.

Confirmed on 6.15-rc1.

     Arnd

