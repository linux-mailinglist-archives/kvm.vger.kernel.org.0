Return-Path: <kvm+bounces-65208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3ACDC9F2BC
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EB82A347D87
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBE72FB963;
	Wed,  3 Dec 2025 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWO2lPxt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6592DCF57
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764769566; cv=none; b=BV5J7mdX1e3ludJCR0IGLLo5bzCDhdSqVm8SaYMmgT0tucbKzQbE533PVE+0KgAXPQSQ83Gw22Slozo4d44DXJRrvrWJA2EwwlDTKJQgJaMAAYmYZXaIGHRYsOhfbo+Mv+wsNYBx0xguvrhcF9F/GxHyV6aPbFNRnRHB4F3MR1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764769566; c=relaxed/simple;
	bh=HvaiGQ8VgJGUAelJrWy0UIgcjYpLDh9ds9yaPkV1opU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bE/KzyABsmd9dQWqqhVshxJhxc5MZdbK9S7gtXAFq562wb5CtNNXXhaPDxVN8LAV+hIMXeUPyAQ9J83FfkkcBBKBWBeiFHwhzD2FeYF0X35jMGCxhJbkJf93cO+5oMTUZ5XNShnRvbSRr/wn9XwHy5/kfA1PfhsxVIU8Dh8310s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWO2lPxt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69AAC116B1;
	Wed,  3 Dec 2025 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764769566;
	bh=HvaiGQ8VgJGUAelJrWy0UIgcjYpLDh9ds9yaPkV1opU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hWO2lPxtqezARQRAtJM6tLQWySwAF92n4k+ZdPpos59y5B0+jq0pah+fUYMJ8XbWF
	 Dmr1gaMxmzBkic2uF3cS7yJafUV78IEtWm1T5S0tHQyLOVuFJdV0hpE5J6E/2LBbdr
	 8PGFnH30GJksxMnOiIHbuaNVDw8pN/ijrQ8+NMKD/OtAOUoieKjH5ZTXuzUfsJTfCa
	 5GHgbJbLmucYq5zbcDo8qUVyt/MzZAigBzbhHkE/ww/l00CJwZ2gbytzkAa2KosC3E
	 tCNSJOL726IaYBcJlpTeghePiIeeorOKCEQbdHK2NfJSIvdQEz7uwO3yCJBS80Nwjf
	 D7UoaFlK6GEiA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id BC686F40078;
	Wed,  3 Dec 2025 08:46:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 03 Dec 2025 08:46:04 -0500
X-ME-Sender: <xms:HD8waaaGv63GhIgE_YxDXs4qGeY9th8fLdWMhmaoww1MSHHVguN8jw>
    <xme:HD8waaKi8sB9QDGpY-_0HbfGJYkNxKREI5_3ybYt0O47DZXuO-Ix7XueZWFLwo4fO
    EmaNNxyFmAVVbGOpmu1qkhcBfXp9kBN1OJljnTUzDbfFfp2Tu-L1dm9>
X-ME-Received: <xmr:HD8waUiV5la7tNfAKvOCM8_Em8gRUKeRu7whC5tGC7YCnS9zjOikZLC_uWLqsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtthhope
    hkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtgho
    tghosehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepkhgrihdrhhhurghngh
    esihhnthgvlhdrtghomhdprhgtphhtthhopeigihgrohihrghordhlihesihhnthgvlhdr
    tghomhdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtg
    hpthhtohephigrnhdrhidriihhrghosehinhhtvghlrdgtohhmpdhrtghpthhtohepsghi
    nhgsihhnrdifuhesihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhooh
    hglhgvrdgtohhm
X-ME-Proxy: <xmx:HD8waVSaEAzBCG1A5ATH3HA5nOgRfEFOOTeuH0Mp4D6jCB1a5IYJ2g>
    <xmx:HD8waZ6Qk7I8ZXJEHZOlPCp3YpCQLvp_TGFrOb_MTnQjq3UCCfS_yQ>
    <xmx:HD8waaPLQ0fp0uNQPtw1JC0SqDBhaLijEIMc8ysnOBqrfkjEB-QICQ>
    <xmx:HD8wacQUqEv8ppvIg6JDId3Ng50zrHqqgCVwKyMQq84IkiE2LTqYxA>
    <xmx:HD8waVWZIGTR9T-xUlXfmXrQ30IAkx2r-LjFYBTcWQV2Kp3n02CTVGX8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Dec 2025 08:46:04 -0500 (EST)
Date: Wed, 3 Dec 2025 13:46:03 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>

On Tue, Dec 02, 2025 at 08:02:38PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2025-12-02 at 09:38 +0200, Nikolay Borisov wrote:
> > > Yea, it could be simpler if it was always guaranteed to be 2 pages. But it
> > > was
> > > my understanding that it would not be a fixed size. Can you point to what
> > > docs
> > > makes you think that?
> > 
> > Looking at the PHYMEM.PAMT.ADD ABI spec the pages being added are always 
> > put into pair in rdx/r8. So e.g. looking into tdh_phymem_pamt_add rcx is 
> > set to a 2mb page, and subsequently we have the memcpy which simply sets 
> > the rdx/r8 input argument registers, no ? Or am I misunderstanding the 
> > code?
> 
> Hmm, you are totally right. The docs specify the size of the 4k entries, but
> doesn't specify that Dynamic PAMT is supposed to provide larger sizes in the
> other registers. A reasonable reading could assume 2 pages always, and the usage
> of the other registers seems like an assumption.
> 
> Kirill, any history here?

There was a plan to future prove DPAMT by allowing PAMT descriptor to
grow in the future. The concrete approach was not settled last time I
checked. This code was my attempt to accommodate it. I don't know if it
fits the current plan.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

