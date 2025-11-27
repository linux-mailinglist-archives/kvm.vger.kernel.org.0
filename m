Return-Path: <kvm+bounces-64887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F2590C8F791
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 55B314E3DDC
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271192C3276;
	Thu, 27 Nov 2025 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLJsO6W4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC3C2C21F4;
	Thu, 27 Nov 2025 16:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764260169; cv=none; b=DZ5/94qkhEsS+xPIhgXbSbt3Cu6QWxkFj42rX3dj85QeK2SNX5xW5W176zquiYniZQF53cpZ1OxKqPobll8qBr3xhn3RxNPvkaNf6xby4VWlcKexGvlN4y0m6RBiRqk8zYDy9A2y3CDByE3a4uLpSziXHtXgQms9cmtHBWLl4Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764260169; c=relaxed/simple;
	bh=DxyEO2achLy43ZF8FixNtv4NmW3wAN1qt36huPNhZ60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vu8jGG97xhe06yZ1x54YwHRmER3MPcWsekt9a/082JO89K0L5+D60Vxb1EaBOeVTuiHQv8tk7VPo81lQ135ttw3WedD9HcTTDwDhe6pe7aeL+1WcidjjGGREIUUMOdLOtXrlqL2jL6HUapKjYmGqoExptNvI5Tie9p0JN7dLVEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLJsO6W4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83441C4AF09;
	Thu, 27 Nov 2025 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764260168;
	bh=DxyEO2achLy43ZF8FixNtv4NmW3wAN1qt36huPNhZ60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rLJsO6W4codxoABkXpTrovOn3jiWhgTO1CkOcMqm/EhgSwtM/87EZ7oKU/mm59gMC
	 o1oM0gxtkHdMHsvk4eRFL8WaFQVLOuhWf1byrstKXyNa0rFJ05XJJDb3+QIW4dWNKR
	 fde1C88w994v10YAcsr86xp8UdhZQDzmRpGn366hLjrNCAe1e4mygF1Btu2IEnf3Cv
	 hwrZpgNhpmuy6Um05UcGirK/VfyGKuhpg24JGXHSMouI+FbJtKseKufIg4oN3oG72Q
	 LFtgpR+0UllpDNdc79NPOrcUXqHxh6x/036m1GqPmohx+YMJmrQBsIqSkl4uIy9G0D
	 DqoPBvO6RFEQw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id C8040F4008A;
	Thu, 27 Nov 2025 11:16:07 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 27 Nov 2025 11:16:07 -0500
X-ME-Sender: <xms:R3koaW68d8gZPWehZlW8HrtUJqjx0jwlNGPeVNMxZueI73C1niz0dw>
    <xme:R3koaQDvtXXCj-Wvm78PFVpOHd-446CyChVyzhGxDQ0nXqmxS9eZ4Nqs6FDvoKKjq
    1XDIIDb-McG8NLKdMkEP2ZNMzZvHCu9Fhm6nHqBssZ_2jmN5VgwNue8>
X-ME-Received: <xmr:R3koaTQhB-IrFNtnXBreisM3Ru3yvWEU7qWVoooZqUhjGsho7V9GdZ4YLptTlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejieekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeigihgrohihrghordhlihesihhnthgvlhdrtghomhdprhgtphhtthhopegurghvvg
    drhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepthhglhig
    sehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrd
    gtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepgiekiees
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohephhhprgesiiihthhorhdrtghomhdprhgtph
    htthhopehrihgtkhdrphdrvggughgvtghomhgsvgesihhnthgvlhdrtghomhdprhgtphht
    thhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:R3koaXYaw-woMvOP84AyHjRbpp9Yys0CZbkQTBRvh8JIBVv4475D4A>
    <xmx:R3koaYX2uSumCs_f9Dpx61SJNW6fDtqZA1_Kxobf-7RxCD0aX5DRBQ>
    <xmx:R3koaUVoy_n7mWx1VcOK9H7hMMlzm9xNeZt-0n6BWewEJOWOc9ssDg>
    <xmx:R3koaa-JV_RWWHk_YFTWr-VyYQXbVF9hSbpnx7Gb9quNsaCcx-jB0g>
    <xmx:R3koaRrb31cSy0mGi4vFB7QUIZSHf8kesXkaEyfLM8TB7XDZu45-JfMQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 11:16:07 -0500 (EST)
Date: Thu, 27 Nov 2025 16:16:06 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Reinette Chatre <reinette.chatre@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
Message-ID: <f2hkqt5xtmej7cfnuytigcfszr3qja4l6ywww4qrqxjbqmlko2@r75b6deae2hd>
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
 <20251126100205.1729391-2-xiaoyao.li@intel.com>
 <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
 <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>
 <qvsi3xht4kn3iwkx5xw2p7zsq4cvpg4xhq3ra52fe34xjpixfo@fsgchsobc343>
 <0f8983e9-0e23-4a05-8015-de6e2218d8a5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f8983e9-0e23-4a05-8015-de6e2218d8a5@intel.com>

On Thu, Nov 27, 2025 at 10:00:58AM +0800, Xiaoyao Li wrote:
> On 11/26/2025 9:35 PM, Kiryl Shutsemau wrote:
> > On Wed, Nov 26, 2025 at 08:17:18PM +0800, Xiaoyao Li wrote:
> > > On 11/26/2025 7:25 PM, Kiryl Shutsemau wrote:
> > > > On Wed, Nov 26, 2025 at 06:02:03PM +0800, Xiaoyao Li wrote:
> > > > > When the host enables split lock detection feature, the split lock from
> > > > > guests (normal or TDX) triggers #AC. The #AC caused by split lock access
> > > > > within a normal guest triggers a VM Exit and is handled in the host.
> > > > > The #AC caused by split lock access within a TDX guest does not trigger
> > > > > a VM Exit and instead it's delivered to the guest self.
> > > > > 
> > > > > The default "warning" mode of handling split lock depends on being able
> > > > > to temporarily disable detection to recover from the split lock event.
> > > > > But the MSR that disables detection is not accessible to a guest.
> > > > > 
> > > > > This means that TDX guests today can not disable the feature or use
> > > > > the "warning" mode (which is the default). But, they can use the "fatal"
> > > > > mode.
> > > > > 
> > > > > Force TDX guests to use the "fatal" mode.
> > > > > 
> > > > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > > ---
> > > > >    arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
> > > > >    1 file changed, 16 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
> > > > > index 981f8b1f0792..f278e4ea3dd4 100644
> > > > > --- a/arch/x86/kernel/cpu/bus_lock.c
> > > > > +++ b/arch/x86/kernel/cpu/bus_lock.c
> > > > > @@ -315,9 +315,24 @@ void bus_lock_init(void)
> > > > >    	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
> > > > >    }
> > > > > +static bool split_lock_fatal(void)
> > > > > +{
> > > > > +	if (sld_state == sld_fatal)
> > > > > +		return true;
> > > > > +
> > > > > +	/*
> > > > > +	 * TDX guests can not disable split lock detection.
> > > > > +	 * Force them into the fatal behavior.
> > > > > +	 */
> > > > > +	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
> > > > > +		return true;
> > > > > +
> > > > > +	return false;
> > > > > +}
> > > > > +
> > > > >    bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> > > > >    {
> > > > > -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
> > > > > +	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
> > > > >    		return false;
> > > > 
> > > > Maybe it would be cleaner to make it conditional on
> > > > cpu_model_supports_sld instead of special-casing TDX guest?
> > > > 
> > > > #AC on any platfrom when we didn't asked for it suppose to be fatal, no?
> > > 
> > > But TDX is the only one has such special non-architectural behavior.
> > > 
> > > For example, for normal VMs under KVM, the behavior is x86 architectural.
> > > MSR_TEST_CTRL is not accessible to normal VMs, and no split lock #AC will be
> > > delivered to the normal VMs because it's handled by KVM.
> > 
> > How does it contradict what I suggested?
> > 
> > For both normal VMs and TDX guest, cpu_model_supports_sld will not be
> > set to true. So check for cpu_model_supports_sld here is going to be
> > NOP, unless #AC actually delivered, like we have in TDX case. Handling
> > it as fatal is sane behaviour in such case regardless if it TDX.
> > 
> > And we don't need to make the check explicitly about TDX guest.
> 
> Well, it depends on how defensive we would like to be, and whether to
> specialize or commonize the issue.
> 
> Either can work. If the preference and agreement are to commonize the issue,
> I can do it in v2. And in this direction, what should we do with the patch
> 2? just drop it since it's specialized for TDX ?

I am not sure. Leaving it as produces produces false messages which is
not good, but not critical.

Maybe just clear X86_FEATURE_BUS_LOCK_DETECT and stop pretending we
control split-lock behaviour from the guest?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

