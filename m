Return-Path: <kvm+bounces-54373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F64B1FFF3
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A905817B7A7
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 07:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3A62D97A9;
	Mon, 11 Aug 2025 07:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOZ82Kbl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C3E27F724
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754896176; cv=none; b=iSIyc0gTM0h4RlG+wm/RNcVYwPq5hDuwmrRcHGzzTDBGkwp43muHnGFgFonVDoYxHlM6b1kYwM4Z/ptg13IQ3uEkHPsJY2/SCFQTxuw+//xBvNfEFtfORSmmHzAulQvCADnMcVHHzI+cXKMaID2c6LztAuvZ16qZ7+zBH6vBgcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754896176; c=relaxed/simple;
	bh=4OwovysFA7M60rkfyCAfepb4redWMUudpYWZ5bDjg4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCR0ghZYS9zdIknoSuQ0ooWbZThkm/NkPeWDZNOJktOqoin7AyiUK20mZsEmZA6j09GBW8+nYSPV6kXecUnfRFoMRd5SY4WlPz5Iu/kKMgfzpV65QwXVKofBT5EHqMfgwLU9g0rLTVKNLU3vuDTP1m37eCOAoPasIK0LO5r5XX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qOZ82Kbl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064F0C4CEF6;
	Mon, 11 Aug 2025 07:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754896175;
	bh=4OwovysFA7M60rkfyCAfepb4redWMUudpYWZ5bDjg4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qOZ82KblQv0RvyDtJlAc9d6Eh6EgSnl6rMY1pJ5PU+o4bXHuC42QnZcKam1ephN5P
	 KmHYFyvCiPfaXarZ6Vpdx7t9wQo1nRTgIkw4D5AaID/zkaXsERATpy3PCxjN87iHSm
	 Ldcfu7veg/u+YGLWGYrCL2l6RSpuXDgMtMXrnhJvxo+LF/3RRyoqSXwRFjdt/OVHG/
	 5oV934s2T7Dc05F8XIAdU7cbEcaTi3rKm/rd88joYB2g/BBtxDcZqBM2aTXPfjTPgJ
	 KlLMh0mN/u1vqQzyx5fQAxwMFfeada8ZSlVahnxTsZx0QFOfdpEypDYOSVNASr7Kid
	 sU/j0Jm5ucKNQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 218D0F40068;
	Mon, 11 Aug 2025 03:09:34 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 11 Aug 2025 03:09:34 -0400
X-ME-Sender: <xms:LpeZaE86z0qCZ-RdVeo3z-xixw5bXfx5qcRwKL8ZlmFf9igs6Ql73A>
    <xme:LpeZaDqIR00ofe4yGJAUXKp0LkUcjRoZvzmPmJ5roHl8Gm9NgNTTwtNB4VSIyck4f
    7IJkacuHJHfhyn5JX0>
X-ME-Received: <xmr:LpeZaC9SxNdAQvZ4DNZFMWQ2bwcsVHYTDoZipwDjG-stduiG9YjxoFH0JNr2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedukeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepfdhkrghssehk
    vghrnhgvlhdrohhrghdfuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgtdfgffekgeethfffffegjeduleevfeejgfeuhffhffeiteejueefhfehheff
    teenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppe
    hkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    fedtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrihgtkhdrphdrvggughgvtg
    homhgsvgesihhnthgvlhdrtghomhdprhgtphhtthhopehpsghonhiiihhnihesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghp
    thhtoheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtghpthhtohepsghpsegrlh
    hivghnkedruggvpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdp
    rhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhnghhose
    hrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:LpeZaMQvjyLP2mZGgVBenHvTOUiJUZZMDuRPL55tIBrohU7z5tS1Iw>
    <xmx:LpeZaDdRHjrmFgqNZh5zwvw44r46tQdEtfcEKd2f5on9HF2ntKomtQ>
    <xmx:LpeZaJI_9Yt1ZbDm0I8jvAcreoNwQq_1zbvUGzDn5KSivqkGrnXidA>
    <xmx:LpeZaIFbIjV2ytzvcglQF5NlKyYpkymLffo49djJcyKKyWwtcjhUsA>
    <xmx:LpeZaJ4wixMsuJjf2kM1k7bMifTM6S09hpGm7LoaXKwbp9HL1hWYXCWG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 03:09:33 -0400 (EDT)
Date: Mon, 11 Aug 2025 07:31:09 +0100
From: "kas@kernel.org" <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>

On Fri, Aug 08, 2025 at 11:18:40PM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > Dynamic PAMT enabling in kernel
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Kernel maintains refcounts for every 2M regions with two helpers
> > tdx_pamt_get() and tdx_pamt_put().
> > 
> > The refcount represents number of users for the PAMT memory in the region.
> > Kernel calls TDH.PHYMEM.PAMT.ADD on 0->1 transition and
> > TDH.PHYMEM.PAMT.REMOVE on transition 1->0.
> > 
> > The function tdx_alloc_page() allocates a new page and ensures that it is
> > backed by PAMT memory. Pages allocated in this manner are ready to be used
> > for a TD. The function tdx_free_page() frees the page and releases the
> > PAMT memory for the 2M region if it is no longer needed.
> > 
> > PAMT memory gets allocated as part of TD init, VCPU init, on populating
> > SEPT tree and adding guest memory (both during TD build and via AUG on
> > accept). Splitting 2M page into 4K also requires PAMT memory.
> > 
> > PAMT memory removed on reclaim of control pages and guest memory.
> > 
> > Populating PAMT memory on fault and on split is tricky as kernel cannot
> > allocate memory from the context where it is needed. These code paths use
> > pre-allocated PAMT memory pools.
> > 
> > Previous attempt on Dynamic PAMT enabling
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > The initial attempt at kernel enabling was quite different. It was built
> > around lazy PAMT allocation: only trying to add a PAMT page pair if a
> > SEAMCALL fails due to a missing PAMT and reclaiming it based on hints
> > provided by the TDX module.
> > 
> > The motivation was to avoid duplicating the PAMT memory refcounting that
> > the TDX module does on the kernel side.
> > 
> > This approach is inherently more racy as there is no serialization of
> > PAMT memory add/remove against SEAMCALLs that add/remove memory for a TD.
> > Such serialization would require global locking, which is not feasible.
> > 
> > This approach worked, but at some point it became clear that it could not
> > be robust as long as the kernel avoids TDX_OPERAND_BUSY loops.
> > TDX_OPERAND_BUSY will occur as a result of the races mentioned above.
> > 
> > This approach was abandoned in favor of explicit refcounting.
> 
> On closer inspection this new solution also has global locking. It
> opportunistically checks to see if there is already a refcount, but otherwise
> when a PAMT page actually has to be added there is a global spinlock while the
> PAMT add/remove SEAMCALL is made. I guess this is going to get taken somewhere
> around once per 512 4k private pages, but when it does it has some less ideal
> properties:
>  - Cache line bouncing of the lock between all TDs on the host
>  - An global exclusive lock deep inside the TDP MMU shared lock fault path
>  - Contend heavily when two TD's shutting down at the same time?
> 
> As for why not only do the lock as a backup option like the kick+lock solution
> in KVM, the problem would be losing the refcount race and ending up with a PAMT
> page getting released early.
> 
> As far as TDX module locking is concerned (i.e. BUSY error codes from pamt
> add/remove), it seems this would only happen if pamt add/remove operate
> simultaneously on the same 2MB HPA region. That is completely prevented by the
> refcount and global lock, but it's a bit heavyweight. It prevents simultaneously
> adding totally separate 2MB regions when we only would need to prevent
> simultaneously operating on the same 2MB region.
> 
> I don't see any other reason for the global spin lock, Kirill was that it? Did
> you consider also adding a lock per 2MB region, like the refcount? Or any other
> granularity of lock besides global? Not saying global is definitely the wrong
> choice, but seems arbitrary if I got the above right.

We have discussed this before[1]. Global locking is problematic when you
actually hit contention. Let's not complicate things until we actually
see it. I failed to demonstrate contention without huge pages. With huge
pages it is even more dubious that we ever see it.

[1] https://lore.kernel.org/all/4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com/

-- 
Kiryl Shutsemau / Kirill A. Shutemov

