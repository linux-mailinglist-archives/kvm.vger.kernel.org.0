Return-Path: <kvm+bounces-54501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD9FB2202B
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 10:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 825C02A64CC
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 08:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3F22E03EE;
	Tue, 12 Aug 2025 08:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfZwk1dZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9A01D2F42
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 08:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985793; cv=none; b=nefI0kGM8WPz1OiC0O4kmvpADjgfR4d2yrHMPHJuMmt4KhFN5Zqu20Cp6595gZ+T5h3gmBr0DgyabxWCc1LtRnuJ1NgpjZFyTNrL0IvD3+hucQftDf57ulEInPnYRFlZ1lgSd0HQy4HIc/kI+HcoGpgoHsBdGVtSnpTfy7toEmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985793; c=relaxed/simple;
	bh=XAGEFLEgMg5bXTIi6k5TRpv+Bffza3mM6uFPwGcBCIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BF0JMMEfBwdM+E3zZESRhMG41o99GzP6ySlaZtg4+FtjwWSzqbWPn4BK3aIq5jTLiAHAZpgrO9rb/xOgp3Bwwe8w7iY/NCBVhRb+B2T7xYr0/qGFLRgw6qsQTYdm9MJ1UnitrItGysuyq1EpqeO+7hOXwg8IjWj8CoZzExlg7Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfZwk1dZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33571C4CEF8;
	Tue, 12 Aug 2025 08:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754985792;
	bh=XAGEFLEgMg5bXTIi6k5TRpv+Bffza3mM6uFPwGcBCIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rfZwk1dZDhofscSyN2+Drsq9S4gSY4qsf8Bx0Ge8SREnBupCae8nxceRMWKl006jU
	 Mm7+OwfsitbW604WBP+mS5vsfMPWdvBtKa33uI3qopgI1Ydb0R3+aHYaRc5phYV3y/
	 l0tzIsHiEsNs4ebwaL52qZU5FUGJwxCQKGbcz9zhB+WxnaW7QncUXr6MVWOm408QY5
	 BKnL9yGJYZCzP2VzD50LJD2j3uJRU9T15rrAfCOv0kHmDlcXsmQKB1QkRkbaOYyPRr
	 l1FkEX9v1NsJYggwifi6vB95CUNGaZZ0gV0SlX4Mdz0Uq17k32QN+Rrr/uuHuZci2z
	 oAtvdFa6hGEBQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5B9B0F40066;
	Tue, 12 Aug 2025 04:03:11 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 12 Aug 2025 04:03:11 -0400
X-ME-Sender: <xms:P_WaaCBFvQ0EHyNWFZTmb_likmN4d9su0320PVOu8-uubGbm3s2o6Q>
    <xme:P_WaaDfpBWEMgiTThti3u4WPwZmPKH589oSZRM-gpmJ__X9ch01Bc5A1nYrtqL6JG
    zj67ad7zzCzRpOreNs>
X-ME-Received: <xmr:P_WaaOjrMhqS6NjMTAwLrKCxr2TSkLtrRlFvam0UOhrlTux2qBIac1NOleya>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeegkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepfdhkrghssehk
    vghrnhgvlhdrohhrghdfuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgtdfgffekgeethfffffegjeduleevfeejgfeuhffhffeiteejueefhfehheff
    teenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppe
    hkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    fedtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehsvggrnhhjtgesghhoohhglh
    gvrdgtohhmpdhrtghpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehinhhtvghl
    rdgtohhmpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopegsphesrg
    hlihgvnhekrdguvgdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopeihrghnrdihrdiihh
    grohesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:P_WaaInZTu7seDXCWBOLVukpjjPJ_fStCDd-0GlPIiJXXdqELn2lCg>
    <xmx:P_WaaBiY3IRSzuxPWRFrcSx0Id8TiMny0pDXawRBnzO5qIDaZ_f1IA>
    <xmx:P_WaaF-TE8htLB_-0BeEHND0dpdYlk9dOJDU74jFPbrIlSbwR_wQtQ>
    <xmx:P_WaaMo3UhQs4sVg0swzD1JCtSOE-Qena-4J_2O6SMRCQOGScjgTAg>
    <xmx:P_WaaLORIXwIZESNizGERH2u2VkRiZy2SODCzHngndwibj-iIQU0Gnmp>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Aug 2025 04:03:10 -0400 (EDT)
Date: Tue, 12 Aug 2025 09:03:07 +0100
From: "kas@kernel.org" <kas@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Kai Huang <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <cxww35wskgjssvb7l7xedu4dimjpxunzoadexeg2qcev6ch2kc@xeed2z7ivaxk>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJqgosNUjrCfH_WN@google.com>

On Mon, Aug 11, 2025 at 07:02:10PM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Rick P Edgecombe wrote:
> > On Mon, 2025-08-11 at 07:31 +0100, kas@kernel.org wrote:
> > > > I don't see any other reason for the global spin lock, Kirill was that
> > > > it?  Did you consider also adding a lock per 2MB region, like the
> > > > refcount? Or any other granularity of lock besides global? Not saying
> > > > global is definitely the wrong choice, but seems arbitrary if I got the
> > > > above right.
> > > 
> > > We have discussed this before[1]. Global locking is problematic when you
> > > actually hit contention. Let's not complicate things until we actually
> > > see it. I failed to demonstrate contention without huge pages. With huge
> > > pages it is even more dubious that we ever see it.
> > > 
> > > [1]
> > > https://lore.kernel.org/all/4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com/
> > 
> > Ah, I see.
> > 
> > I just did a test of simultaneously starting 10 VMs with 16GB of ram (non huge
> 
> How many vCPUs?  And were the VMs actually accepting/faulting all 16GiB?
> 
> There's also a noisy neighbor problem lurking.  E.g. malicious/buggy VM spams
> private<=>shared conversions and thus interferes with PAMT allocations for other
> VMs.
> 
> > pages) and then shutting them down. I saw 701 contentions on startup, and 53
> > more on shutdown. Total wait time 2ms. Not horrible but not theoretical either.
> > But it probably wasn't much of a cacheline bouncing worse case.
> 
> Isn't the SEAMCALL done while holding the spinlock?  I assume the latency of the
> SEAMCALL is easily the long pole in the flow.
> 
> > And I guess this is on my latest changes not this exact v2, but it shouldn't
> > have changed.
> > 
> > But hmm, it seems Dave's objection about maintaining the lock allocations would
> > apply to the refcounts too? But the hotplug concerns shouldn't actually be an
> > issue for TDX because they gets rejected if the allocations are not already
> > there. So complexity of a per-2MB lock should be minimal, at least
> > incrementally. The difference seems more about memory use vs performance.

I don't see jump to per-2MB locking remotely justified. We can scale
number of locks gradually with the amount of memory in the system: have
a power-of-2 set of locks and 2MB range to the lock with %.

Note that it is trivial thing to add later on and doesn't need to be
part of initial design.

> > What gives me pause is in the KVM TDX work we have really tried hard to not take
> > exclusive locks in the shared MMU lock path. Admittedly that wasn't backed by
> > hard numbers.
> 
> Maybe not for TDX, but we have lots and lots of hard numbers for why taking mmu_lock
> for write is problematic.  Even if TDX VMs don't exhibit the same patterns *today*
> as "normal" VMs, i.e. don't suffer the same performance blips, nothing guarantees
> that will always hold true.
>  
> > But an enormous amount of work went into lettings KVM faults happen under the
> > shared lock for normal VMs. So on one hand, yes it's premature optimization.
> > But on the other hand, it's a maintainability concern about polluting the
> > existing way things work in KVM with special TDX properties.
> > 
> > I think we need to at least call out loudly that the decision was to go with the
> > simplest possible solution, and the impact to KVM. I'm not sure what Sean's
> > opinion is, but I wouldn't want him to first learn of it when he went digging
> > and found a buried global spin lock in the fault path.
> 
> Heh, too late, I saw it when this was first posted.  And to be honest, my initial
> reaction was very much "absolutely not" (though Rated R, not PG).  Now that I've
> had time to think things through, I'm not _totally_ opposed to having a spinlock
> in the page fault path, but my overall sentiment remains the same.
> 
> For mmu_lock and related SPTE operations, I was super adamant about not taking
> exclusive locks because based on our experience with the TDP MMU, converting flows
> from exclusive to shared is usually significantly more work than developing code
> for "shared mode" straightaway (and you note above, that wasn't trivial for TDX).
> And importantly, those code paths were largely solved problems.  I.e. I didn't
> want to get into a situation where TDX undid the parallelization of the TDP MMU,
> and then had to add it back after the fact.
> 
> I think the same holds true here.  I'm not completely opposed to introducing a
> spinlock, but I want to either have a very high level of confidence that the lock
> won't introduce jitter/delay (I have low confidence on this front, at least in
> the proposed patches), or have super clear line of sight to making the contention
> irrelevant, without having to rip apart the code.

I think there is a big difference with mmu_lock.

mmu_lock is analogous to mmap_lock in core-mm. It serializes page fault
against other mmu operation and have inherently vast scope.

pamt_lock on other hand is at very bottom of callchain and with very
limited scope. It is trivially scalable by partitioning.

Translating problems you see with mmu_lock onto pamt_lock seems like an
overreaction.

-- 
Kiryl Shutsemau / Kirill A. Shutemov

