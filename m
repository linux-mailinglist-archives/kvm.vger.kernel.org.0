Return-Path: <kvm+bounces-67061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BF32FCF4E43
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 18:05:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5715B303DABE
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 17:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD65309DDB;
	Mon,  5 Jan 2026 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/oBQS+P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2224291E;
	Mon,  5 Jan 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767632660; cv=none; b=aG4nJ9IyQb5uVheLc4HEr2wyfUUmYdF6JOyCEDWyw+JAE5Z68xkGtgAW8xO9yrYBGNtZO5bOLxLAtcPcFhveboXdd8g22Umz0jbbhsZgM3pMcu7dGuFrh5MiRUCU0VTjjyNCqAbfL6PDhrzSi+53MbbrC8Ixyi9R4s2GkJ3Tbpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767632660; c=relaxed/simple;
	bh=vxlEn+hklinv8UTikxv4hRvOUtpEt0rA+MNF7Vfsos4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPDslrtC4E4MMDJcTqWw5oX9W3X8TOnp37EJsGPWcEZgX8JowFBBI0pnTd1W5xrEuJ8OCPHrE8xSPzEYp2CLKBkIZ69a2mp+PUPruqDoxwsM/t2Wwu0HIAc3Q/j3rkGQzX52rL9YJQVnm00S8OdK80JJ8hiZJPVtptSwiZbkmNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/oBQS+P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281D0C19421;
	Mon,  5 Jan 2026 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632659;
	bh=vxlEn+hklinv8UTikxv4hRvOUtpEt0rA+MNF7Vfsos4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j/oBQS+PwIrcTkaUnHZbUgFpOJBOYgKOF+60Q8u17Zi8u5r8pOD4a8x0oM2R50y8H
	 MZuTz9YksBy9UYHmm16kn0PVKPatc+AowYSfDSAdQ69ECE8UnDa8WcOBt4ZUXoiKQx
	 iwFfq10VrGql2X6WvbLRRQk0BxMbKuLnSO3LgLjvzvY9Hv7Unuxo2cpjcZtJfvBEDF
	 0YZeyA95fH9IgZVTziVpkA/dkx+jQcThke+xajp8N1JIi7gJ3VcH4PoL/TecXnfRF8
	 NghCiKHFoTB7njoTaJ/UbYcZVcV8TpedcaMXZ/mBsPnrKv3HUbXFEyTOk1jjL00gEx
	 TXZQZ6r5NKH8A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 489C6F4006C;
	Mon,  5 Jan 2026 12:04:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 05 Jan 2026 12:04:18 -0500
X-ME-Sender: <xms:Eu9baW4k4PNlUQ63yqjMUGbQK0xW8YJKb0nxtJysfYwk3bDdmvgqTA>
    <xme:Eu9baWu8stRKVmwRTzHgwz1NUrwT8TL98eXVs_9-duItwVgrf92CX4X0LihJSfyAc
    jmaB-WOIj3vKUl2HVPV6ARNCjqt0QJrx4t2MxZrHGlbKy1WaJgR-04>
X-ME-Received: <xmr:Eu9baebxk381x_kwpzD-RIibbZJ1BMxaXuIHBO3qOchAc0ieqM4jRxnhB4am9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeljeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeetleelgfeivdfggfefhffgffeivdehgeevgeefgeetgfffvdegffejudejheduueen
    ucffohhmrghinheptghhrghtghhpthdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnhesih
    hnthgvlhdrtghomhdprhgtphhtthhopegthhgrohdrghgrohesihhnthgvlhdrtghomhdp
    rhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhi
    nhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgi
    ekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhishhhrghlrdhlrdhvvghrmhgr
    sehinhhtvghlrdgtohhmpdhrtghpthhtohepkhgrihdrhhhurghnghesihhnthgvlhdrtg
    homhdprhgtphhtthhopegurghnrdhjrdifihhllhhirghmshesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:Eu9baV9uXMnOwBMN1czBigTm5fQ1lMbE-Tz3cftYdAFyU6-HUrf38g>
    <xmx:Eu9baebbyAiQq5p-92-tJB9UxA77yQ3MrQBK46xRstM8rmt90Jdu2g>
    <xmx:Eu9baTStDMJbM8dbO9YQWdNPCbQZubD6CHe8UcL-VgSGHsYzytxjCg>
    <xmx:Eu9badmzstHaUSbhXZy-r-YyKUvVT9bRxO6AfgVsYtPsKPFiO6ds7w>
    <xmx:Eu9bafLRIGQjRjlTElsOtFSCNtQNWb1FNxT-XoqIOrfVrjundnb7gC8A>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jan 2026 12:04:17 -0500 (EST)
Date: Mon, 5 Jan 2026 17:04:16 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	vishal.l.verma@intel.com, kai.huang@intel.com, dan.j.williams@intel.com, 
	yilun.xu@linux.intel.com, vannapurve@google.com, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <zhsopfh4qddsg2q5xj26koahf2xzyg2qvn7oo4sqyd3z4mhnly@u7bwmrzxqbhx>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>

On Mon, Jan 05, 2026 at 08:04:21AM -0800, Dave Hansen wrote:
> On 1/5/26 02:38, Kiryl Shutsemau wrote:
> >> To address this issue, this series exposes the TDX Module version as
> >> sysfs attributes of the tdx_host device [*] and also prints it in dmesg
> >> to keep a record.
> > The version information is also useful for the guest. Maybe we should
> > provide consistent interface for both sides?
> 
> Could you elaborate a bit on what constitutes consistency here?
> 
> Do you mean simply ensuring that the TDX module version _is_ exposed on
> both hosts and guests, like in:
> 
> 	/sys/devices/faux/tdx_host/version
> 
> and (making this one up):
> 
> 	/sys/devices/faux/tdx_guest/version
> 
> Note the "host" vs. "guest"   ^^^^^
> 
> Or, that the TDX module version be exposed in the *same* ABI in both
> host and guest, like:
> 
> 	/sys/devices/faux/tdx/version

I am not sure. It depends on what will be in these directories besides
the version. We might want to dump TDX features too, they are common for
host and guest. But there are going to be guest/td specific things (like
attributes or TD CTLS) and stuff that is only relevant for the host.

Maybe it is better to keep them separate, but with the common scheme. It
will keep door open for nested TDs (not partitioning) if they ever happen.
It might require two directories in the same environment.

I also wounder if it is possible to share code of this metadata retrieval
between guest and host. It should be doable.

> Generally, I find myself really wanting to know how this fits into the
> larger picture. Using this "faux" device really seems novel and
> TDX-specific. Should it be?
> 
> What are other CPU vendors doing for this? SEV? CCA? S390? How are their
> firmware versions exposed? What about other things in the Intel world
> like CPU microcode or the billion other chunks of firmware? How about
> hypervisors? Do they expose their versions to guests with an explicit
> ABI? Are those exposed to userspace?

My first thought was that it should be under /sys/hypervisor/, no?

So far hypervisor_kobj only used by Xen and S390.

> For instance, I hear a lot of talk about updating the TDX module. But is
> this interface consistent with doing updates? Long term, I was hoping
> that TDX firmware could get treated like any other blob of modern
> firmware and have fwupd manage it, so I asked:
> 
> 	https://chatgpt.com/share/695be06c-3d40-8012-97c9-2089fc33cbb3
> 
> My read on your approach here is that our new LLM overlords might
> consider it the "last resort".

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

