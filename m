Return-Path: <kvm+bounces-54661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C1FB263A9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 13:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF9881898250
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 10:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BF52FDC41;
	Thu, 14 Aug 2025 10:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dgv0IKLI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2262FD1AF
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 10:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755168963; cv=none; b=OIKG41AZroTql3FeXsfVuWaVVYJkT4gR7booPxTxetAQFttu6B80vkafvLihTW/u4sNvQ3AlAxklZwgOD0pdHEwZJ0XWx7Ar1riaGJ9TnnPtFNdOlgvbexBuupQQmlWappt1f9LmlCNhuHfRw3YTd7LqTVZcTl1oi/RgiUrcT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755168963; c=relaxed/simple;
	bh=SnWVKlFdROyTxD4FPgJKlyQXDtnlktGbxkB63KC/6w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kmie2GwM8X50gHmdvHBMA1P92OPyhaz0mPx7faGnNahZf9ZsbApfpo5hYsOWVr2UBe9XK/cpJ+jBEis5AgPoJK4hn9GVrX8X94hhvvxHUSbt/BlM10EA4MpZvE+ywTv8VN7V+4r/J2zKOpTlF3EN6iyI3gltgkfIUCL8lZ1M2mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dgv0IKLI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E0BC4AF09;
	Thu, 14 Aug 2025 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755168963;
	bh=SnWVKlFdROyTxD4FPgJKlyQXDtnlktGbxkB63KC/6w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dgv0IKLI8pDHcJsBZq7GZ1Ctsfoe42N0WOf9O80T/84EUmc2PRpIm4zfr1NwTptvg
	 IIogtKNKj60AdaPx2uH3iFX36llNrnHhsuJCYZ7cO5gwLbZV+C5TnB7f+9LNriQR3/
	 OW73uUmHfbBX3r2rDjpU/tK5SvOoAcLXCFhFjE/fMgv9Z+/8LjCjszWP7hzgRC7Wcr
	 OwXbl7d3uXW7rDwePFAuNkgkEc9ju3L1iAhMBAe1S/0QNG+Rt0bSLXM/Pr/VsW2u3G
	 DrXvmZN5eW4k7xuo+V0daNJkypWD//YxnRoZzAmtjr5lWgyrftHcusC3a34Nq4m+Um
	 cpDLfRvPBduhg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id C2429F40066;
	Thu, 14 Aug 2025 06:56:01 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 14 Aug 2025 06:56:01 -0400
X-ME-Sender: <xms:wcCdaAZihc2dAVkVQGrNw6_va00PSx3Xow9aEJQEd_56CoDzLl8Mrg>
    <xme:wcCdaFwI1Yd7_cmBOoWHMNGnUV_8v1BjKB3vi8bATNu7uTUZ1Jt_UNo54VES5nWeD
    oXWGpZfjn3ZwhmSNIg>
X-ME-Received: <xmr:wcCdaGi44FP9ZeoBiu1vKk6fIdaodFCBDPWJnHK-CpmOi7SBYH2tKqZemlVr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugedtledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphhtth
    hopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtohepshgvrghn
    jhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhgrohdrghgrohesihhnthgvlh
    drtghomhdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopeigkeeisehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:wcCdaEqv2xmkvlFui-uMbSS3iBzVxjNw5dYtiIoCFqJ-iasghl0kLw>
    <xmx:wcCdaFewdvVbBZaPD8IOQjSAvLW6eDiWLh1GS0CvTxK-sXAFKp_kdQ>
    <xmx:wcCdaHcLU_oEBfZpNBh-7YCp2NutqsnQKDVBWtMDukS2o3YuF0sveQ>
    <xmx:wcCdaLeDRP8KPR1ZFWJ8hO4ESqPg65lEm1DFLkoYuUf13mgzVrR3Yg>
    <xmx:wcCdaNr_xUB8pGP24zFYQd3O5AHBfXYxN-raP3KdVONucQxP9W30dFuo>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Aug 2025 06:56:01 -0400 (EDT)
Date: Thu, 14 Aug 2025 11:55:57 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Message-ID: <rxtpzxy2junchgekpjxirkiuu7h4x4xwwrblzn4u5atf6yits3@artdh2hzqa34>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com>
 <f38f55de6f4d454d0288eb7f04c8c621fb7b9508.camel@intel.com>
 <d21a66fe-d2ce-46cc-b89e-b60b03eae3da@intel.com>
 <6bd46f35c7e9c027c8a4c713df7dc73e1d923f5b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bd46f35c7e9c027c8a4c713df7dc73e1d923f5b.camel@intel.com>

On Thu, Aug 14, 2025 at 12:14:40AM +0000, Edgecombe, Rick P wrote:
> On Wed, 2025-08-13 at 16:31 -0700, Dave Hansen wrote:
> > On 8/13/25 15:43, Edgecombe, Rick P wrote:
> > > I redid the test. Boot 10 TDs with 16GB of ram, run userspace to fault in memory
> > > from 4 threads until OOM, then shutdown. TDs were split between two sockets. It
> > > ended up with 1136 contentions of the global lock, 4ms waiting.
> > 
> > 4ms out of how much CPU time?
> 
> The whole test took about 60s wall time (minus the time of some manual steps).
> I'll have to automate it a bit more. But 4ms seemed safely in the "small"
> category.
> 
> > 
> > Also, contention is *NOT* necessarily bad here. Only _false_ contention.
> > 
> > The whole point of the lock is to ensure that there aren't two different
> > CPUs trying to do two different things to the same PAMT range at the
> > same time.
> > 
> > If there are, one of them *HAS* to wait. It can wait lots of different
> > ways, but it has to wait. That wait will show up as spinlock contention.
> > 
> > Even if the global lock went away, that 4ms of spinning might still be
> > there.
> 
> I assumed it was mostly real contention because the the refcount check outside
> the lock should prevent the majority of "two threads operating on the same 2MB
> region" collisions. The code is roughly:
> 
> 1:
>    if (atomic_inc_not_zero(2mb_pamt_refcount))
> 	return <it's mapped>;
> 2:
>    <global lock>
>    if (atomic_read(2mb_pamt_refcount) != 0) {
> 3:
> 	atomic_inc(2mb_pamt_refcount);
> 	<global unlock>
> 	return <it's mapped>;
>    }
>    <seamcall>
>    <global unlock>
> 4:
> 
> (similar pattern on the unmapping)
> 
> So it will only be valid contention if two threads try to fault in the *same* 2MB
> DPAMT region *and* lose that race around 1-3, but invalid contention if threads try
> to execute 2-4 at the same time for any different 2MB regions.
> 
> Let me go verify.

Note that in absence of the global lock here, concurrent PAMT.ADD would
also trigger some cache bouncing during pamt_walk() on taking shared
lock on 1G PAMT entry and exclusive lock on 2M entries in the same
cache (4 PAMT_2M entries per cache line). This is hidden by the global
lock.

You would not recover full contention time by removing the global lock.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

