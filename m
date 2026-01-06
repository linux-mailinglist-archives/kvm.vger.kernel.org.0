Return-Path: <kvm+bounces-67136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A73CF8067
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE38F30DBDF4
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C8A326D44;
	Tue,  6 Jan 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tu7fMHjB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA28319858
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 11:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698390; cv=none; b=ZY6s3cqtat6NbS33hjI4pEmInUwoyN0Z8VfVDARWtIJ9TlUAz8TUFbMDfaJhaWvxpNqAn18bVeLYm9Tbi8Ai3y8as4d2nze/wDfwpH9Ka3Q3RhFlfl+zBjozCdK2wYzUEGjZCDFOe9+YzkONWAhP1O+SapklbX6xa2XEW3LLod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698390; c=relaxed/simple;
	bh=3hYa67AZxQskBjBVOM5HLsNEGDB4u77knbx55k4aQfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TppRdXXVjXyF8VEmU5HjDEf9A4On69nQfkI3bkz6yBhutiCAxPZBpp3NFlClVFvGFvWYTGvuhVCeWPXy9gi+8wU2rkAZZlrFoVrRT8UMIFr0Ongae6E9wj9xBHtuMg+U2yFmnvkaM1xl1SbnRMLp0d3LR7m8My2HWOrkrUbPbW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tu7fMHjB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4F7C4AF0B;
	Tue,  6 Jan 2026 11:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767698389;
	bh=3hYa67AZxQskBjBVOM5HLsNEGDB4u77knbx55k4aQfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tu7fMHjBaf0QmS5qLP1wx25TU8jDevZF0g3Ke2nEaEuJ1O/2eOStwuA3Q2jntDrtg
	 yyXmk8hyHV9nWowzFBJuEonZX/hOQgXPNHGFVhXoIWfFPwQ2Q/IOzUHMtVSAlw6qTA
	 0mRASy6ZPQowDgdkFRv9Vhuw2ZYOdo78pM3NEljdhwPEV+CLmRCqbYTH8ueR22g1Y6
	 e9OUbX0VrRhHGMj+L6f5LV3LC4Fu0Ohum2H6R7jigGLdqpy0PA3mbjmSfWp8/jKqD2
	 oOogJJms2IZIDmlt2IzU3em10F7MtXIx20WseFJGauFOML6rlilFStBIQIp8/qzjee
	 lROeeczQZDrVg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 91AB8F40068;
	Tue,  6 Jan 2026 06:19:48 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 06 Jan 2026 06:19:48 -0500
X-ME-Sender: <xms:1O9caW9QaelhreG_g7p3C1HCHYpt4oF7Ve9llVJ8U0h-ze7yqBMiHQ>
    <xme:1O9caUW0DrYZcgaP0FiUyaj00gwyz30pStE1xGajEYKcHpWn5QBU8vMYwRKbaTnyt
    o-0DEBFwBDuxD0F15riuio7XqbnHFD0VFxYeMd7koz6Z96KZOCrxbYx>
X-ME-Received: <xmr:1O9caTZRDY_jN4Cbu2Eaf42Lyv4ZYh86KBzorBeNplEOK93Q-WrN-lJMP48q2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutddttdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegthhgrohdrghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhs
    thhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhhishhhrghlrdhlrdhvvghrmhgrsehinhhtvghlrdgtohhmpdhrtg
    hpthhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopegurghn
    rdhjrdifihhllhhirghmshesihhnthgvlhdrtghomhdprhgtphhtthhopeihihhluhhnrd
    iguheslhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:1O9caWrkkWPA8LVLIC5FZJe-_MBDrP_W5bCKtL1wVFNfG4l-9wyyrw>
    <xmx:1O9caS419f9F2w7iSO-V33UwCg3LYJUB6FDSXqZU2bl5eFgZ4eep7A>
    <xmx:1O9caYV5Jhd8rbdTWASP9hqamYMbSsANcNETYBPbVIiuOLL0q91wFQ>
    <xmx:1O9caYuGCdTDftnSiWBUxkcQrIqS1n0uKigpWFxNa1DjMBUTW2hNUQ>
    <xmx:1O9caVpHaCYrxTPNAVt3BA_BmBMjWUZpIbxthvwHHJ8toXv4rkbkxC4B>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jan 2026 06:19:48 -0500 (EST)
Date: Tue, 6 Jan 2026 11:19:46 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, vishal.l.verma@intel.com, kai.huang@intel.com, 
	dan.j.williams@intel.com, yilun.xu@linux.intel.com, vannapurve@google.com, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <idebornlxlwj4zuk4h3upaibez7vcqiynzuqj65q6sycidax65@uqsqfqqosekx>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <aVywHbHlcRw2tM/X@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVywHbHlcRw2tM/X@intel.com>

On Tue, Jan 06, 2026 at 02:47:57PM +0800, Chao Gao wrote:
> On Mon, Jan 05, 2026 at 10:38:19AM +0000, Kiryl Shutsemau wrote:
> >On Sun, Jan 04, 2026 at 11:43:43PM -0800, Chao Gao wrote:
> >> Hi reviewers,
> >> 
> >> This series is quite straightforward and I believe it's well-polished.
> >> Please consider providing your ack tags. However, since it depends on
> >> two other series (listed below), please review those dependencies first if
> >> you haven't already.
> >> 
> >> Changes in v2:
> >>  - Print TDX Module version in demsg (Vishal)
> >>  - Remove all descriptions about autogeneration (Rick)
> >>  - Fix typos (Kai)
> >>  - Stick with TDH.SYS.RD (Dave/Yilun)
> >>  - Rebase onto Sean's VMXON v2 series
> >> 
> >> === Problem & Solution === 
> >> 
> >> Currently, there is no user interface to get the TDX Module version.
> >> However, in bug reporting or analysis scenarios, the first question
> >> normally asked is which TDX Module version is on your system, to determine
> >> if this is a known issue or a new regression.
> >> 
> >> To address this issue, this series exposes the TDX Module version as
> >> sysfs attributes of the tdx_host device [*] and also prints it in dmesg
> >> to keep a record.
> >
> >The version information is also useful for the guest. Maybe we should
> >provide consistent interface for both sides?
> 
> Note that only the Major and Minor versions (like 1.5 or 2.0) are available to
> the guest; the TDX Module doesn't allow guests to read the update version.
> Given this limitation, exposing version information to guests isn't
> particularly useful.

Ughh. I didn't realize this info is not available to the guest. This is
unnecessary strict. Isn't it derivable from measurement report anyway?

> And in my opinion, exposing version information to guests is also unnecessary
> since the module version can already be read from the host with this series.
> In debugging scenarios, I'm not sure why the TDX module would be so special
> that guests should know its version but not other host information, such as
> host kernel version, microcode version, etc. None of these are exposed to guest
> kernel (not to mention guest userspace).

I already dump attributes and TD CTLS on guest boot, because it is
useful for debug. Version and features can also be useful for reports
from the field. Reported may not have access to hypervisor. Or it would
require additional round trip to get this info from reported.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

