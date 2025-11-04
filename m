Return-Path: <kvm+bounces-61953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5DA7C30432
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1AD189618D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2271153BED;
	Tue,  4 Nov 2025 09:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KocpVr9N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFEE1EA84
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 09:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248236; cv=none; b=r/MDCZUWsbtEdaXbHt96XERUFYyXrEQ+KJTtYLqjVlPWy/eR6dd5Nx4PNEysNdBrxAcrKGVHHXLJ2MpTId/ZVjqiPH92agC8DUwv05Ed2Fg+iQLw8Btmumun6rKtEzeEH6IUD+gD0tcdpxiGxpoUZekH5AYIoPYvSfFy7/6FqBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248236; c=relaxed/simple;
	bh=nn+pSgqE05qlXhp5xrrNooKd/IT5Tw+jAVmsSuLPC5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hd9NY6nyYJATWmcpksGUBjrCICBlldDe+0rDhX+KeyqkH7vitSA1GazELybou8mhw3ZOzPauojzDQnxLsownc0CDGpcS5dj6I8pZCS95lQU0FSPNEc/5Qh5YG4Z6x7+ISlnr+ryCFxAVGc0QVVhH21xVyNg0ZHToklnJFCzM7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KocpVr9N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC82C4CEF7;
	Tue,  4 Nov 2025 09:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762248236;
	bh=nn+pSgqE05qlXhp5xrrNooKd/IT5Tw+jAVmsSuLPC5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KocpVr9NQ5hk/2FemqFb32mdMyU0PYMCpAKLp26F0/3NS9Q36dC8Eb1gj42HXUI7F
	 LMbjigl/buzgauQuAPnpHqbk2zUaXfbUUXp70DL2/49hrKd930MWNC2V1Rwf8AvF6I
	 5aWlmqRqkIGw/dl1cElkoeoeRAsqjKjoDm0wA421A334KKfA3HDdSJeUclSDlc3HxL
	 Smi5n3xFnhTNjo9jB2b4pgPuEU/3sLnFjllFPiq8+IAhHi7JPRKfQ0tTtTRCDk2Rrt
	 ZvBWN4jCQIRMxZkejmcK8ETQ24SFUwXQjVNxMOWuq+MeuS4QmvxmbOkpg0STXrV0Qd
	 5PeBoSCtgS5+w==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 352BEF40078;
	Tue,  4 Nov 2025 04:23:55 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 04 Nov 2025 04:23:55 -0500
X-ME-Sender: <xms:K8YJad607quwV_M_BtCdBN09Q04X-jBEkFayn2IYhaM9XmcJdC6_sg>
    <xme:K8YJaWWIE-v5wvDVa0w_IcVaE3QtLK1WgKW3RDY2YtTTQTFCF2ruM3JkNuHBtrDyt
    P7_pwDOr6SGC_kWHdWEvoPlB6sMyFBloPYvqspJDqOkGuTYUc2-ZZ8>
X-ME-Received: <xmr:K8YJaTL36EZtuyy9R4C_ycDsaJwuKFshvCLbIa4GcgCCIL4Xvs4NmjZb8LTabw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukedtieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:K8YJaTRbAhYYgfUoftVSMZ_r7ItmpDXokerXUGiUHb_FfKCcdfNE4A>
    <xmx:K8YJaXjZK9GC34-w_O6DSpba2C0Vz4Vy3PnqvdrlEJRB8qETHkzA_w>
    <xmx:K8YJaVsDCpOd5GSAniM-ADac6umfQk8mMNcOZusSx6NGNHbV313F6Q>
    <xmx:K8YJaajgKZk7Q87e1SNIbjR0B-iPmxZ-MKNysZPvjm0IQrGqFn3xlQ>
    <xmx:K8YJaUGN-voS8fs3xCiZuspccyKTZcGviiYY3GcT0SypoI6PKwxBeZRw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Nov 2025 04:23:54 -0500 (EST)
Date: Tue, 4 Nov 2025 09:23:52 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [v2][PATCH 1/2] x86/virt/tdx: Remove __user annotation from
 kernel pointer
Message-ID: <7lrtlgncz3qaycmyg2sk5hkhzexlfwo5snr43ixg3kmxrzh3ub@biackh7rexlo>
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
 <20251103234437.A0532420@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103234437.A0532420@davehans-spike.ostc.intel.com>

On Mon, Nov 03, 2025 at 03:44:37PM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Separate __user pointer variable declaration from kernel one.
> 
> There are two 'kvm_cpuid2' pointers involved here. There's an "input"
> side: 'td_cpuid' which is a normal kernel pointer and an 'output'
> side. The output here is userspace and there is an attempt at properly
> annotating the variable with __user:
> 
> 	struct kvm_cpuid2 __user *output, *td_cpuid;
> 
> But, alas, this is wrong. The __user in the definition applies to both
> 'output' and 'td_cpuid'. Sparse notices the address space mismatch and
> will complain about it.
> 
> Fix it up by completely separating the two definitions so that it is
> obviously correct without even having to know what the C syntax rules
> even are.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Fixes: 488808e682e7 ("KVM: x86: Introduce KVM_TDX_GET_CPUID")
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

