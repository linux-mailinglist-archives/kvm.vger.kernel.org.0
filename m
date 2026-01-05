Return-Path: <kvm+bounces-67069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE95CF525C
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4A3B3031784
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A669533A9D6;
	Mon,  5 Jan 2026 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOJ/0sVw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D83246E4;
	Mon,  5 Jan 2026 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767636235; cv=none; b=do0A4dkxgJ0/bfZyzZi95v92nWqrYAP/FLeZn+pC8lfd3AgRZfniElJEyglY8MmI56gCHNXdol5kEQs/+orUn62vEZzpym/NM7GJMWKRMZLOS2ItjHjco4od3WK9S4o1flJQoSm2/9VJtWxc1WvqEN5BY6bwQme0TC+ltzHEQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767636235; c=relaxed/simple;
	bh=Rx9Dh5v9FKLm3TAH7X9oHG0AANMqTq50IU73toEHYtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1C0AZgKSZIJJM0l2EyNRJxhcx5cKWa5iD3KYYQ9FqKc+Lk1DpmsUk8Va9/wnE8I0r4IKb3GkGPTF8XJuaASw9hAVlDuD9ZoZ8LTiJlSs3VgiK4Wv6zDydSxbcDlmHGa1X9Swf9kH44bkRzwhcF5JeziPMBmgCdwIIYTf7k2AqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOJ/0sVw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CA8C116D0;
	Mon,  5 Jan 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767636235;
	bh=Rx9Dh5v9FKLm3TAH7X9oHG0AANMqTq50IU73toEHYtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOJ/0sVwU6Nu9v4k39WwZuqXkRPyUiZ39wgLJGshVE97haS/a/vjDxdQ9pHK3ORha
	 x4zS3ZkAAsyzZEMnmXu6dMhHVGBYvu2iq0sNmRa3sXP7flxdnTRDC7fWr1cYzaoeQI
	 fTWsY3Atopbr4vrCv+EBIdvG/yAYcap7iz9qgX08qaUqbhliN+spx63Ls13WrV8iW5
	 9dm42EARuQ/oyQeWpEV3C0X9Hg89HssejO6nD+YFf5+MfXu0E+vuU4UtvzYPfWxQKF
	 SnnJ4+IDNwmIYITU/EpPRCOYheIqRLS/eVMY+WN7j+MlN4eKzI5ZikbNwOZOwc1bkt
	 NcErLpLjeR3Yg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id E8C15F40071;
	Mon,  5 Jan 2026 13:03:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 05 Jan 2026 13:03:53 -0500
X-ME-Sender: <xms:Cf1baccKwenw4QgMvQrJaqiemlz19bq7R7M3Q76MhH8HaYmW2uVDcA>
    <xme:Cf1baVDGdByLltJ10-8o8jYy97XGYCGWTYtwY5SKkk_rsq5YNeeJYM0grlM_zYlsB
    UqI_yVoPxReHRs6LqFqzrlkplWdoyNG-sciuXboHMwk0gdX16y0NZet>
X-ME-Received: <xmr:Cf1baWfmMRe7jP3QNGsmVoXiLBqpMTgex7gKG133g7vaHnN-QhR0rCh7qJQH4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeljeeljecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhgvrdhhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopegthhgroh
    drghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuh
    igrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epvhhishhhrghlrdhlrdhvvghrmhgrsehinhhtvghlrdgtohhmpdhrtghpthhtohepkhgr
    ihdrhhhurghnghesihhnthgvlhdrtghomhdprhgtphhtthhopegurghnrdhjrdifihhllh
    hirghmshesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:Cf1baUxvNYboyB3oIIBMq5LOv3cm_aY81UXcRxei1icpfxanTzsJmA>
    <xmx:Cf1bac8uf8jidjzY3ROR_mexG9ng8dk2SKtcucFAlBj63iRSScy6Ew>
    <xmx:Cf1baWlQ960j5-TwAqNGOaIWzBxd9Dyl6AUv4EThU-BoMXoyjg39oA>
    <xmx:Cf1baWrPF35inpT0p3PubfZjCwtoiRb5WROETQoDNAYa718nC-8SXg>
    <xmx:Cf1baa_UncmXMqKm4r6TOdNO9W2AinSDNs-ulNHINO5SWu2wEnSniKIr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jan 2026 13:03:53 -0500 (EST)
Date: Mon, 5 Jan 2026 18:03:52 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	vishal.l.verma@intel.com, kai.huang@intel.com, dan.j.williams@intel.com, 
	yilun.xu@linux.intel.com, vannapurve@google.com, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <spfgdkv5cnerut7sl3kkrdhgnvpg6xidhey5rmtjmnswtiowfv@uuhvtiv4wztk>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
 <d45cc504-509c-48a7-88e2-374e00068e79@intel.com>
 <zhsopfh4qddsg2q5xj26koahf2xzyg2qvn7oo4sqyd3z4mhnly@u7bwmrzxqbhx>
 <7cbac499-6145-4b83-873c-c2d283f9cb79@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbac499-6145-4b83-873c-c2d283f9cb79@intel.com>

On Mon, Jan 05, 2026 at 09:19:07AM -0800, Dave Hansen wrote:
> On 1/5/26 09:04, Kiryl Shutsemau wrote:
> >> What are other CPU vendors doing for this? SEV? CCA? S390? How are their
> >> firmware versions exposed? What about other things in the Intel world
> >> like CPU microcode or the billion other chunks of firmware? How about
> >> hypervisors? Do they expose their versions to guests with an explicit
> >> ABI? Are those exposed to userspace?
> > My first thought was that it should be under /sys/hypervisor/, no?
> > 
> > So far hypervisor_kobj only used by Xen and S390.
> 
> As with everything else around TDX, it's not clear to me. The TDX module
> is a new middle ground between the hypervisor and CPU. It's literally
> there to arbitrate between the trusted CPU world and the untrusted
> hypervisor world.

The TDX module has absorbed some functionality that was traditionally
provided by the hypervisor. Treating it as a hypervisor is a valid
option. But, yeah, I agree that it is not an exact match.

> It's messy because there was (previously) no component there. It's new
> space. We could (theoretically) a Linux guest running under Xen the
> hypervisor using TDX. So we can't trivially just take over
> /sys/hypervisor for TDX.

Note that Xen uses /sys/hypervisor/xen, so there's no conflict, we can
have both xen and tdx_whatever there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

