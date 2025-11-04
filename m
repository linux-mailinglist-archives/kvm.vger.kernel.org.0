Return-Path: <kvm+bounces-61954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C6FC303E4
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 43DFF34CF55
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD60A191493;
	Tue,  4 Nov 2025 09:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pv2pCmVd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E03E1DED5C
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 09:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248290; cv=none; b=OQI2/o35qf8BWBUqP9OfcvHQdv1wH2sYaZ//fMyLE5A+I05qTaSUgtysVV0K4Lx0q1MdzvX+QWY4IyTP89Ao+D9BUTXBRsHyDl3I7Bri4PTYdsAQhqXUnjCOPSHNs0z6TmYgLvLJUkYPvHHkQjBp3kknmaifzRNb1ph95wz42Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248290; c=relaxed/simple;
	bh=cGxuUbn5w0fAmAQr8mtNRuVKRUjaBfX+O1QubwOpstw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMH+ZeNHM/uT/ZtL3LaAfAzq9wOjiT0+ed/uL2HhlzjlbKCshAxgF1/dXJ98vJvQLvi88h5YAsNF9t5z5NHFOYeNCcFugVqqeK48TqtGQwCOOpqmwmYZyZx2ciFfCx45q2kIu5Y1HvevCTPxqtTc7BpT0SrE0vl6yUsHmTiEa3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pv2pCmVd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6743EC4CEF7;
	Tue,  4 Nov 2025 09:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762248289;
	bh=cGxuUbn5w0fAmAQr8mtNRuVKRUjaBfX+O1QubwOpstw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pv2pCmVdpPLy7Hre6IDXynmLiixOOto+M70AeYpNxrfZYIXS41txO3OnPLcUSdGmd
	 /8fPSg69YfSwtJN8X51hwLk1INnMxpuoyZWFLKwHXnV8RqsHtz4j4ZaIBsfsj0pqNe
	 K4XxCHiufx6Shvl3CBOpsIJUq1YXJ/LljyaL7LiAwFROhBHRjw9iEiYS3ztxtKzX1y
	 Q/eNUJoTQJL12wnbLwcnG88R4vCXp7+lbFNvtjVf41wuA+3vEeEe3tmz/hPSXymySz
	 r83lOkGjnbhgjGDKXOZoX8i1GsigFIvnf01qf7Hn1e89579WyAYdnH0AXWhDeoDWbF
	 9xh/aUj0iQ5wA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id A4958F40078;
	Tue,  4 Nov 2025 04:24:48 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 04 Nov 2025 04:24:48 -0500
X-ME-Sender: <xms:YMYJafqVN3XRLN3D-A8jjihfl7y42IMX25eb4cPO6Tr5HEdpmqQVlg>
    <xme:YMYJaVGJKuetKDPlmKJdMT59f7zKWErckB32buh1-F6Fq9G2N1fkGJ_PhosnUX4dN
    jJsOf_FrTbmDcPFGCN1sb6JsXwKL9i9C5B7MOY9lkhgRwsgCFioaqk>
X-ME-Received: <xmr:YMYJaa5jGMmto7qa8T9UTwRHJq6-_E6XXgXfG2pVlgcJjEbpZqHGHMbmhIvMhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukedtieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohephhhprgesiiihthhorhdrtg
    homhdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopehk
    vhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgsohhniihinhhise
    hrvgguhhgrthdrtghomhdprhgtphhtthhopehrihgtkhdrphdrvggughgvtghomhgsvges
    ihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:YMYJaQD0-qmFcn817TA0ILLtLa9FqotGq3FWEN1pVOU1x7yP760BiQ>
    <xmx:YMYJaVQwXO-URSD7g7fWs8EHPBUhNkC92BJ_2wImN7cGy-u6BlrqJw>
    <xmx:YMYJaQeneLaBF_lia9fY8imUj9Z79fOPxWPO6lElFjRfzoZwuAcN-w>
    <xmx:YMYJaeQY4iBXzg3Om6hBpDE4aizaO_rNX0YEkwY64tLHlZyvCxisjA>
    <xmx:YMYJac1mQCYGxCB6EaFfgMT75S9mn2txmhl7X1Z6pAYZpFiohoN6SIvn>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Nov 2025 04:24:48 -0500 (EST)
Date: Tue, 4 Nov 2025 09:24:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [v2][PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0
 for NULL
Message-ID: <eygttaxlyd6ar3cintcqxa6ppqsnqcffxhm5odcfkun5xp7pdp@alwt557ghomc>
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
 <20251103234439.DC8227E4@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103234439.DC8227E4@davehans-spike.ostc.intel.com>

On Mon, Nov 03, 2025 at 03:44:39PM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Stop using 0 for NULL.
> 
> sparse moans:
> 
> 	... arch/x86/kvm/vmx/tdx.c:859:38: warning: Using plain integer as NULL pointer
> 
> for several TDX pointer initializations. While I love a good ptr=0
> now and then, it's good to have quiet sparse builds.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: a50f673f25e0 ("KVM: TDX: Do TDX specific vcpu initialization")
> Fixes: 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Kirill A. Shutemov" <kas@kernel.org>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

