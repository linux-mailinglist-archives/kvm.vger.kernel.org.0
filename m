Return-Path: <kvm+bounces-67372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 915CED02509
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 12:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 645FC3165353
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE561495503;
	Thu,  8 Jan 2026 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULkfgm5C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF1C43AD45
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869425; cv=none; b=mamBc7mLNwUmJ+ts+TzVvCq9tZEwHCrwKIwfupTfbU1p1hErjsj/kP2nJl2NDsh78G+Hyx03+xpzZ7oP1QZF+I9smq9hF8kOhe3lDtXw9ZmIlZz8nQd5v9Sw+2NQx2B9cMWdh+eigiUWd/p9NwnnIu5DHPPd95EwuNu4OX05C6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869425; c=relaxed/simple;
	bh=Ggenv12d+ttz8VP++ueRzUs74PHjWjbnismLAU+Rr7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyyzwIYyVi5pvOwtf1MELinnthLy4mENk3PqY9KO8OzAvGdudE0Bd9SFxkD4sbI3r8fURxhHtvdtpmb/uCkhNkxNiFYtbiCk+JKWFzMeD4kC7qUBr7tveFBOFfa3uRh9WXYJSiFJFmBl40ONbkV2YxBg85/QHM6cGIXzHlqtkus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULkfgm5C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C68C116C6
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767869423;
	bh=Ggenv12d+ttz8VP++ueRzUs74PHjWjbnismLAU+Rr7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ULkfgm5CvLeoK1QDvT0iaiWBBCqvShhWV0a+5JRaOWD/i4JW8KR6Kb06hB6lSKfpB
	 wxknNyMQb+byQhT4BOiY3Pg+VfnGIQjMGAWF0A37smK49ln4rGpIJntEFNchBrp7eT
	 ZhqtET5bUgIBmcQR6cwzRnZ/vPia3yXHpRR+6HmVMZ/nB/xarTOCHeAlYR4QOhAfkf
	 5iVVtre1ThHlvYC/Odpqre8QJA2sbXLwH4DCmJ313/3WmMki4pLCZbPJ205xMoQiVo
	 xm9W0OwSYxuk2eRbPE1fZnz2IP3lak/vf2CqrBns1o7d5F5Nc7bGJKqJaQtAzQLikq
	 lHDglU5u3lHkg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8E324F40068;
	Thu,  8 Jan 2026 05:50:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 08 Jan 2026 05:50:22 -0500
X-ME-Sender: <xms:7otfaeVeddqMEgeLDRxlhLEnW6-vUI_Kq0rZFPaF6lc_8OMFTVSgUw>
    <xme:7otfaasFX_aMhlR40X-ukADFpzeeKgI-vdZlqJS_LU2IoKKrBztuvvAdbPWe25cWY
    KBG8M_Wprv0tgjUlMVF3z4luFPGikk5CDia1vi6K8AXbB6VN9nHyt4>
X-ME-Received: <xmr:7otfaQNqB8Sn1qbLNLx5DHFUKdXa1H_RcFDY9FihYr72v5mCUSK-xxd7YK8Olw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdehjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehvihhshhgrlhdrlhdrvhgvrhhmrgesihhnthgvlhdrtghomhdprhgtphhtthhope
    hlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdgtohgtoheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhope
    hkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheptghhrghordhgrghosehinhhtvghlrdgtohhmpdhrtg
    hpthhtohepuggrnhdrjhdrfihilhhlihgrmhhssehinhhtvghlrdgtohhmpdhrtghpthht
    ohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopehtghhlgieslh
    hinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:7otfaZkUIAm1WNhy-nIynLX7XFuyxFZWzLOvs8GWZOd4vT2CKfVWsw>
    <xmx:7otfaWzpT7rO-J-OsfCMPHUi9brTiXata66x97y7DvFIvxFBs490Dg>
    <xmx:7otfaaBe06aXNjmQgSCEekW7gYqRAn_VqV1dunDBd0vkzIafWUNUCA>
    <xmx:7otfaW4w9c1kn1rrbsEuncB7ItZH6k1fPQin9dLGLvZX8py7x5Moig>
    <xmx:7otfaW104_3jnfk7-mrWVjFzaF49aCDEonVM8wqSIoqYHtP2zvYLQFn1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jan 2026 05:50:22 -0500 (EST)
Date: Thu, 8 Jan 2026 10:50:21 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Print TDX module version during init
Message-ID: <orjok4cskwinwuuqkyovqu7tkfygdkiqlxc2sbdvi2jicpygi4@dgg76ojxkhak>
References: <20260107-tdx_print_module_version-v1-0-822baa56762d@intel.com>
 <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-tdx_print_module_version-v1-2-822baa56762d@intel.com>

On Wed, Jan 07, 2026 at 05:31:29PM -0700, Vishal Verma wrote:
> It is useful to print the TDX module version in dmesg logs. This allows
> for a quick spot check for whether the correct/expected TDX module is
> being loaded, and also creates a record for any future problems being
> investigated. This was also requested in [1].
> 
> Include the version in the log messages during init, e.g.:
> 
>   virt/tdx: TDX module version: 1.5.24
>   virt/tdx: 1034220 KB allocated for PAMT
>   virt/tdx: module initialized
> 
> ..followed by remaining TDX initialization messages (or errors).
> 
> Print the version early in init_tdx_module(), right after the global
> metadata is read, which makes it available even if there are subsequent
> initialization failures.

One thing to note that if metadata read fails, we will not get there.

The daisy chaining we use for metadata read makes it fragile. Some
metadata fields are version/feature dependant, like you can see in DPAMT
case.

It can be useful to dump version information, even if get_tdx_sys_info()
fails. Version info is likely to be valid on failure.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

