Return-Path: <kvm+bounces-54502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23BBDB22033
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 10:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B9C16257C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 08:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB3D2E03EB;
	Tue, 12 Aug 2025 08:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icJm+4Hy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B998614A60F;
	Tue, 12 Aug 2025 08:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985889; cv=none; b=TzdhCExieb4chY3RsJKA3pXXXfPa+hlAOYtYqsTpyq8ajYYCcTKuJysge4Xvy5bfSUtWe2RNf7YdHC7Crdg44vMukhrNkU0bxCWa8l0bea8mU62wN5ZPkD4EMIenZH/7FuL1s3OulZm+Hep963PxJ/j7sABxj4B5CSJg4CgcALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985889; c=relaxed/simple;
	bh=ZyReWlcffHTYComn/DA/6pf7MXj5iV6r/6JbT+q/nGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFznAW80Umgk+/40YZmhblLBLGNfri00jO0ZgaLD/71RWPeQeYLERJslcKxtNYJ8NSrPO4+t0tg23tt5scFLvFWH0vqCtL3DFiJC2rIllRlIuqG4xoZNaT1rHTHwsbeh+JrgHvaIUPTPQ7FnYLtuV52aDqXV8cRDzu0Cwpt7W6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icJm+4Hy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C95C4CEF7;
	Tue, 12 Aug 2025 08:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754985889;
	bh=ZyReWlcffHTYComn/DA/6pf7MXj5iV6r/6JbT+q/nGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=icJm+4Hyc5UfKQlm9+NdFODSOHl+7DaCF7bWFz9wbdufkvhzj5ASaAyVL+UdksFcn
	 z+h+2mJ+5q8kA8zEhKVaRjp+fjmkB7qvUdAadbiB7EPoiOc8JtTYQxLhvabZhTWEJG
	 RmoBc3bwnIPYexYIBGMuFrslSca+QZIGgKpADpE4BJmswp7IsuurEl3pi0UC2LVGD2
	 +mgn20FJw2hJ1V7bgwfeOz2CZJct16KVdTdZgroEVpBZ4uJGr9zZcxXlAukrQfkrAG
	 a4yXeVAzE1SU5I6s0KO3iGbUujeirrwN9bK6/l5QXA5uPXZ4X9Q1KvGQzch2VNsq5U
	 b4wf6CzUu+SqA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 74C98F40067;
	Tue, 12 Aug 2025 04:04:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 12 Aug 2025 04:04:48 -0400
X-ME-Sender: <xms:oPWaaKrTGD5gf99uULRgBXFEQ9h38C0AoExjXfgPxcEFEZ6pN3yaOQ>
    <xme:oPWaaFzx6VXoeoy38Ey3aK7pDetzP5czCHHIpRNVGwkNMU8w3psfjRooEF_TgMgyG
    4eMipRJYx2TiOvoM2g>
X-ME-Received: <xmr:oPWaaPpTtaqGWjlNTMF71ltc5FB8vbI7R6h01q4pOIm4wHO3A9kWlIPfEkPd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeegkedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttdejnecuhfhrohhmpedfkhgrshes
    khgvrhhnvghlrdhorhhgfdcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfduveffkeekvdfhheetkefhteefffetjeejfefhhfefieetfeefueeutdeh
    veejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspe
    epkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthho
    peefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvhgrnhhnrghpuhhrvhgvse
    hgohhoghhlvgdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglhgvrdgtohhm
    pdhrtghpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpd
    hrtghpthhtoheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    grihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopegsphesrghlihgvnhek
    rdguvgdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmih
    hnghhosehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:oPWaaK7e-GqeLNT8n3Lbyql3t0HyNIgdzuF8-tMisx-CemmPX_O39w>
    <xmx:oPWaaBjfDp7VkbAJT9uDPxtY-kYL5IfjOMoOyjQH062FnawFDWDz7g>
    <xmx:oPWaaA0fHfJA-u_ixajPz8C3GhOjQB1pCJ7t_bVnHG9hTNCHU4ucUA>
    <xmx:oPWaaPWyb_gsGoxdDBFF5Y-5TnlmTCboB1Z1nlAgI3LgQyvzhhLYpw>
    <xmx:oPWaaF0IG5yNscATDSwK3G3l_P6-o7qN9LZ7e7R1UDyscBQRmz8houeI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Aug 2025 04:04:47 -0400 (EDT)
Date: Tue, 12 Aug 2025 09:04:45 +0100
From: "kas@kernel.org" <kas@kernel.org>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com>
 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>

On Mon, Aug 11, 2025 at 07:31:26PM -0700, Vishal Annapurve wrote:
> On Mon, Aug 11, 2025 at 7:02 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Aug 11, 2025, Rick P Edgecombe wrote:
> > > On Mon, 2025-08-11 at 07:31 +0100, kas@kernel.org wrote:
> > > > > I don't see any other reason for the global spin lock, Kirill was that
> > > > > it?  Did you consider also adding a lock per 2MB region, like the
> > > > > refcount? Or any other granularity of lock besides global? Not saying
> > > > > global is definitely the wrong choice, but seems arbitrary if I got the
> > > > > above right.
> > > >
> > > > We have discussed this before[1]. Global locking is problematic when you
> > > > actually hit contention. Let's not complicate things until we actually
> > > > see it. I failed to demonstrate contention without huge pages. With huge
> > > > pages it is even more dubious that we ever see it.
> > > >
> > > > [1]
> > > > https://lore.kernel.org/all/4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com/
> > >
> > > Ah, I see.
> > >
> > > I just did a test of simultaneously starting 10 VMs with 16GB of ram (non huge
> >
> > How many vCPUs?  And were the VMs actually accepting/faulting all 16GiB?
> >
> > There's also a noisy neighbor problem lurking.  E.g. malicious/buggy VM spams
> > private<=>shared conversions and thus interferes with PAMT allocations for other
> > VMs.
> >
> > > pages) and then shutting them down. I saw 701 contentions on startup, and 53
> > > more on shutdown. Total wait time 2ms. Not horrible but not theoretical either.
> > > But it probably wasn't much of a cacheline bouncing worse case.
> >
> > Isn't the SEAMCALL done while holding the spinlock?  I assume the latency of the
> > SEAMCALL is easily the long pole in the flow.
> >
> > > And I guess this is on my latest changes not this exact v2, but it shouldn't
> > > have changed.
> > >
> > > But hmm, it seems Dave's objection about maintaining the lock allocations would
> > > apply to the refcounts too? But the hotplug concerns shouldn't actually be an
> > > issue for TDX because they gets rejected if the allocations are not already
> > > there. So complexity of a per-2MB lock should be minimal, at least
> > > incrementally. The difference seems more about memory use vs performance.
> > >
> > > What gives me pause is in the KVM TDX work we have really tried hard to not take
> > > exclusive locks in the shared MMU lock path. Admittedly that wasn't backed by
> > > hard numbers.
> >
> > Maybe not for TDX, but we have lots and lots of hard numbers for why taking mmu_lock
> > for write is problematic.  Even if TDX VMs don't exhibit the same patterns *today*
> > as "normal" VMs, i.e. don't suffer the same performance blips, nothing guarantees
> > that will always hold true.
> >
> > > But an enormous amount of work went into lettings KVM faults happen under the
> > > shared lock for normal VMs. So on one hand, yes it's premature optimization.
> > > But on the other hand, it's a maintainability concern about polluting the
> > > existing way things work in KVM with special TDX properties.
> > >
> > > I think we need to at least call out loudly that the decision was to go with the
> > > simplest possible solution, and the impact to KVM. I'm not sure what Sean's
> > > opinion is, but I wouldn't want him to first learn of it when he went digging
> > > and found a buried global spin lock in the fault path.
> >
> > Heh, too late, I saw it when this was first posted.  And to be honest, my initial
> > reaction was very much "absolutely not" (though Rated R, not PG).  Now that I've
> > had time to think things through, I'm not _totally_ opposed to having a spinlock
> > in the page fault path, but my overall sentiment remains the same.
> >
> > For mmu_lock and related SPTE operations, I was super adamant about not taking
> > exclusive locks because based on our experience with the TDP MMU, converting flows
> > from exclusive to shared is usually significantly more work than developing code
> > for "shared mode" straightaway (and you note above, that wasn't trivial for TDX).
> > And importantly, those code paths were largely solved problems.  I.e. I didn't
> > want to get into a situation where TDX undid the parallelization of the TDP MMU,
> > and then had to add it back after the fact.
> >
> > I think the same holds true here.  I'm not completely opposed to introducing a
> > spinlock, but I want to either have a very high level of confidence that the lock
> > won't introduce jitter/delay (I have low confidence on this front, at least in
> > the proposed patches), or have super clear line of sight to making the contention
> > irrelevant, without having to rip apart the code.
> >
> > My biggest question at this point is: why is all of this being done on-demand?
> > IIUC, we swung from "allocate all PAMT_4K pages upfront" to "allocate all PAMT_4K
> > pages at the last possible moment".  Neither of those seems ideal.
> >
> > E.g. for things like TDCS pages and to some extent non-leaf S-EPT pages, on-demand
> > PAMT management seems reasonable.  But for PAMTs that are used to track guest-assigned
> > memory, which is the vaaast majority of PAMT memory, why not hook guest_memfd?
> 
> This seems fine for 4K page backing. But when TDX VMs have huge page
> backing, the vast majority of private memory memory wouldn't need PAMT
> allocation for 4K granularity.
> 
> IIUC guest_memfd allocation happening at 2M granularity doesn't
> necessarily translate to 2M mapping in guest EPT entries. If the DPAMT
> support is to be properly utilized for huge page backings, there is a
> value in not attaching PAMT allocation with guest_memfd allocation.

Right.

It also requires special handling in many places in core-mm. Like, what
happens if THP in guest memfd got split. Who would allocate PAMT for it?
Migration will be more complicated too (when we get there).

-- 
Kiryl Shutsemau / Kirill A. Shutemov

