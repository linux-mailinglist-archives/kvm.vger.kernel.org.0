Return-Path: <kvm+bounces-64660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C50C8A0E3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 14:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFE1C3AFF95
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0974325700;
	Wed, 26 Nov 2025 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JY0C6mtp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20BD2F83C2
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764164135; cv=none; b=EqoeZ6X0iKDV9OZwTNZKSpSwkX9OvmT5S6/4B5flAL8t+Zvie9/y96BxeKs87d5+NytnH+zc6C2uWmqsnznoZdpI9RyJSgeqX3G83BLafwADsCtnwzNGzZXHFC66eIkDb9XiD3LX5Ixv0bQoT+sMtNaxE4GhoJhVsrsvH4IzbOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764164135; c=relaxed/simple;
	bh=4XGqkkwvJhzBKDjFg2Nnsb4TmPPMhIbPH+8e/8mp2ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8sLDsEiTHQO9q4qpD6ZhfI7W91eVMzGhdlEVW4I/AvthSVuUlXU1HSmTykEe4D1mQ+iZBnPcW6DN/wYVH4ev6P6ZLbfkZJY3a/CUGmfxWDIeZuoTj1/l/RoszsUT3JthFLTl6pwkoWlabmlVSV3o17pyFpUEOo13GEm4WKuLT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JY0C6mtp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217A4C116B1;
	Wed, 26 Nov 2025 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764164134;
	bh=4XGqkkwvJhzBKDjFg2Nnsb4TmPPMhIbPH+8e/8mp2ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JY0C6mtpEbbp8hcUXrcQeLTsv2QwCTGEhvheJbSbf7I3ZphXKsTqTlk2skKroOQc8
	 acK62TJD1T09SzIrsALglUVSqkHIDbWmPfEaNo5CGR9qSpHukKdhX04Nd8AUrbhKHb
	 Fwz6lsYUM3lleDDzcZtJ8++h49Kc3sS/4Zqt5G6qI6M37DgLm/WI9yf+2x++29v5jx
	 pP5Cwk6p24jpOVq0tLtRARQgWztVE8x24sIeT4XTN9jEfNxcMBqMi8+MiWtZDib9lL
	 0JCVHBIb6f9//JJULKJOX/PlTKvJVKWdxLp0yt3k4D2exnvr0fmrFzmi9ZV1fUwdM8
	 /KlMpPRi778Iw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 40BCAF4006A;
	Wed, 26 Nov 2025 08:35:33 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 26 Nov 2025 08:35:33 -0500
X-ME-Sender: <xms:JQInaa42TQblY7RRf2U3HRqhwrs1gYxEOQHsaLzUaroUTex35cd7aA>
    <xme:JQInaUB8cMhxadfJ9Z2TTPjUWtjV5Bx6X5GDZ3-MdSGSqaNKo4-HcG77qrc9GO2Ob
    R7WRZZMlV9JnTcvePiUzB0aoUvT854x5NSDv3kEhEVCxMnwt_pJBw>
X-ME-Received: <xmr:JQInaXTFXG0TNo27PTzFVbCMA8O7DpjiKrd-14OKgpWAQyoWivMwKSfcn2pD3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeeggeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:JQInabaJyxx-mbaF31wM2g5jEO4gi9ZFCSAo9P8W6mAtSojQzS4UkQ>
    <xmx:JQInacXUREImYZ0LM3YGbGi9tX2s5j6lQ1KHKNfgnq2adxGMYZarvQ>
    <xmx:JQInaYWJmbk3LcuJXtl-xVWAqXl0VhJKXAw-QuWpxbAZaoSQhQps2A>
    <xmx:JQInae8x-_dIwaLy3xxK5f57bLc0WEVBJ6FjLHCfIWzm6Rh7nNjh6A>
    <xmx:JQInaVr-t4hQ_Ks12EFzYVlmgxgBhQd-iuPSK5VdHB8Bl8ixa1l6YqIt>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 08:35:32 -0500 (EST)
Date: Wed, 26 Nov 2025 13:35:31 +0000
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
Message-ID: <qvsi3xht4kn3iwkx5xw2p7zsq4cvpg4xhq3ra52fe34xjpixfo@fsgchsobc343>
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
 <20251126100205.1729391-2-xiaoyao.li@intel.com>
 <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
 <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>

On Wed, Nov 26, 2025 at 08:17:18PM +0800, Xiaoyao Li wrote:
> On 11/26/2025 7:25 PM, Kiryl Shutsemau wrote:
> > On Wed, Nov 26, 2025 at 06:02:03PM +0800, Xiaoyao Li wrote:
> > > When the host enables split lock detection feature, the split lock from
> > > guests (normal or TDX) triggers #AC. The #AC caused by split lock access
> > > within a normal guest triggers a VM Exit and is handled in the host.
> > > The #AC caused by split lock access within a TDX guest does not trigger
> > > a VM Exit and instead it's delivered to the guest self.
> > > 
> > > The default "warning" mode of handling split lock depends on being able
> > > to temporarily disable detection to recover from the split lock event.
> > > But the MSR that disables detection is not accessible to a guest.
> > > 
> > > This means that TDX guests today can not disable the feature or use
> > > the "warning" mode (which is the default). But, they can use the "fatal"
> > > mode.
> > > 
> > > Force TDX guests to use the "fatal" mode.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > >   arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
> > >   1 file changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
> > > index 981f8b1f0792..f278e4ea3dd4 100644
> > > --- a/arch/x86/kernel/cpu/bus_lock.c
> > > +++ b/arch/x86/kernel/cpu/bus_lock.c
> > > @@ -315,9 +315,24 @@ void bus_lock_init(void)
> > >   	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
> > >   }
> > > +static bool split_lock_fatal(void)
> > > +{
> > > +	if (sld_state == sld_fatal)
> > > +		return true;
> > > +
> > > +	/*
> > > +	 * TDX guests can not disable split lock detection.
> > > +	 * Force them into the fatal behavior.
> > > +	 */
> > > +	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > > +
> > >   bool handle_user_split_lock(struct pt_regs *regs, long error_code)
> > >   {
> > > -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
> > > +	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
> > >   		return false;
> > 
> > Maybe it would be cleaner to make it conditional on
> > cpu_model_supports_sld instead of special-casing TDX guest?
> > 
> > #AC on any platfrom when we didn't asked for it suppose to be fatal, no?
> 
> But TDX is the only one has such special non-architectural behavior.
> 
> For example, for normal VMs under KVM, the behavior is x86 architectural.
> MSR_TEST_CTRL is not accessible to normal VMs, and no split lock #AC will be
> delivered to the normal VMs because it's handled by KVM.

How does it contradict what I suggested?

For both normal VMs and TDX guest, cpu_model_supports_sld will not be
set to true. So check for cpu_model_supports_sld here is going to be
NOP, unless #AC actually delivered, like we have in TDX case. Handling
it as fatal is sane behaviour in such case regardless if it TDX.

And we don't need to make the check explicitly about TDX guest.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

