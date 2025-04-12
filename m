Return-Path: <kvm+bounces-43189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1E9A86C91
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 12:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA878C862E
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 10:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218051C7005;
	Sat, 12 Apr 2025 10:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="O9Oce6gG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="H7dqiS5i"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05AD18FDB9;
	Sat, 12 Apr 2025 10:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454450; cv=none; b=EYgRJokRC3GN1GGnY+3ZxW8fRl2p7Bl0akufczBWa6onum7u4sVvhuxMsXt8bM8tfndf6qIm/y6rxMksgNrPeQgtaA9aXsgJpFnuUmKFuzXJ+fekrxlEjnr/z075lxxfUWw9wZ8paFUomt8Ugw9+n7toS5O/wQ47SigIfJV9WjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454450; c=relaxed/simple;
	bh=rDN+VzIu8yNsPl9xK8t+PzXJNplsjhQtHNIrKRlUPMI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=oA02SJ1lBk7swtqO3gKYQpQHktFtAQZGJ9RBoW3pt9ll5QD4TJiQ5Geqc2td7OqPZubTzmfSVsQHkna3oUf/LZXrHd/3qe0XzYZznXXxIJ9mttmLxy9oAB201Q58WcxE4FK9NeSL0Nnswtb9l5yBRCnpf4svTRFE91T9SAP2O8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=O9Oce6gG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=H7dqiS5i; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6F89F25401B3;
	Sat, 12 Apr 2025 06:40:45 -0400 (EDT)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-05.internal (MEProxy); Sat, 12 Apr 2025 06:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1744454445;
	 x=1744540845; bh=ojMQWqhdKFfWAl/DhyMDc2l5WroObBJp0bFrITkV2Q8=; b=
	O9Oce6gGzI0rt5Oil3vBlwpV3gp6IRH5mEVzLWB0f9dp7sbR7ihOcMN4x4uf/Sfp
	0Jro2x5noexfEBV72ODJPlv4nUHRykI4F9PR9ib/CpDnTU0PXlC9kBJHA36dbJ99
	1QmH3Swq8BS0wz/ogH+w68rZK3akyNFyjIqqKt7MuQnWOWzxiAFFzeTsIq1Odc3R
	p6Emfdnh5PqfXbHU911XKFQd1KyzOBfoFPVD+Dz/SHW0XzH/ReTOnjs1Q3yOB+/9
	wzKZRvia3i5rm9gSs2xEfjFQIDHr9ne7HEubJKG0kLFF8IjJqng5JkUvB3BEIKha
	UaAXrZy/Gu6KR9JvyLp3ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744454445; x=
	1744540845; bh=ojMQWqhdKFfWAl/DhyMDc2l5WroObBJp0bFrITkV2Q8=; b=H
	7dqiS5iBIJQsjVE5OnyVQ1M1tDfFwvWAUqs00s3LuI7TNriotdw090OpHyKmV5oi
	qwAgS/9QUTVBHDbuFXDPUbTJEqqasSrCy8JXT7s8PKJPkdY5UTEjj5S9Tsd9pkfV
	qTx35FaN4iqKLeklo3aAhf/hRwqt9u9Y4sFcsU1UW0O+SQMwoCVPKCNLZjNqKGj8
	IFYUKBL/Uy0f2JJgBMje/3dqxUA8620xJHekWV7xZEm8CA58EFBK03gDKvXuIX73
	Qd2RRaOCOi26xXjDtezgc1mzf7XJDZtEWOqeYsTOoUnXu0V1td0XQGRaMn7w7sf2
	pQ2LuijzMbkTVsfzm7TCA==
X-ME-Sender: <xms:K0P6Z3xOohakry2MGb_Alq9a_jRsyf9lwjgwvIpFNLX1hZRq0q_E8g>
    <xme:K0P6Z_Tu5J9VhXOPxTIcUyhtlbPgERbMDnkQjzM8vfpHEhbUoPbcwLpfqWI1y4ozy
    gXRyq1cS2oA-IzWtWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvudeghedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtjeertder
    tddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnug
    gsrdguvgeqnecuggftrfgrthhtvghrnhepfefhheetffduvdfgieeghfejtedvkeetkeej
    feekkeelffejteevvdeghffhiefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnuges
    rghrnhgusgdruggvpdhnsggprhgtphhtthhopedujedpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtoheptghimhhinhgrghhh
    ihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglhgvrdgtoh
    hmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthho
    pegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghnugihse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:K0P6ZxVOeZsq47B8OlQ4YOlVw3xEx-662eANF0wLctHBudNeKbu2Cg>
    <xmx:K0P6ZxiJDKUJ7GEzbwz1fg2DyIdb0hmvvPHVchreUWa-7vip6M7FQA>
    <xmx:K0P6Z5Cz5ffHSYkc_lHX4qJctl2PyaC_UAQrYAL7qVasS67Ylrgwhw>
    <xmx:K0P6Z6Jwx9XoTHqQ4TO-_8Pj2GIXCVUzUyIlF5lwZ1WM0LVOdWag8g>
    <xmx:LUP6ZySBkx5vHZEBoMomoMpEYjRIEu1pkK2ItoWBBLWcjaVXdcjw8Spf>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 650232220073; Sat, 12 Apr 2025 06:40:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Teb9e062682a72887
Date: Sat, 12 Apr 2025 12:40:13 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Dave Hansen" <dave.hansen@intel.com>, "Arnd Bergmann" <arnd@kernel.org>,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org,
 "Mike Rapoport" <rppt@kernel.org>, "Mike Rapoport" <rppt@kernel.org>
Message-Id: <2615bf9e-61a4-488e-8842-3230de4f5033@app.fastmail.com>
In-Reply-To: <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Apr 12, 2025, at 01:44, Dave Hansen wrote:
> Has anyone run into any problems on 6.15-rc1 with this stuff?
>
> 0xf75fe000 is the mem_map[] entry for the first page >4GB. It obviously
> wasn't allocated, thus the oops. Looks like the memblock for the >4GB
> memory didn't get removed although the pgdats seem correct.
>
> I'll dig into it some more. Just wanted to make sure there wasn't a fix
> out there already.
>
> The way I'm triggering this is booting qemu with a 32-bit PAE kernel,
> and "-m 4096" (or more).

I have reproduced the bug now and found that it did not happen in
my series. Bisection points to Mike Rapoport's highmem series,
specifically  6faea3422e3b ("arch, mm: streamline HIGHMEM freeing")

There was a related bug that was caused by an earlier version
of my series when I also removed CONFIG_PHYS_ADDR_T_64BIT
https://lore.kernel.org/all/202412201005.77fb063-lkp@intel.com/

    Arnd

