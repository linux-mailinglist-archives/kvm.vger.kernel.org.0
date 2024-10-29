Return-Path: <kvm+bounces-29949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FBB29B4C36
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1602B226E6
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00CF206E9B;
	Tue, 29 Oct 2024 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="CZ2YPwp3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IAi9ysm8"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9661361;
	Tue, 29 Oct 2024 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730212625; cv=none; b=qZIBaDo5IvkURFbnrv5jACm+iaqz0O7Pieot2zFRoxwjg7ZhrX6S+zDfLY3J5YSaRlGMl3uMkM5eZ7EUsT8YsRhUoM4Glf3KeW1BqHnAWu8LkfZ/YFyxW7nmIkMufrKbxUGgwiiF5Qp0UmpvtEP6nWzeimsFAOWydCkRAk2NdTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730212625; c=relaxed/simple;
	bh=iOhDX5FV0VLbdeCkY5l1lzKjn8x1HtA48a32wtkAOps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNEm2wIbITPCQzKupnnpqKVpTzkCkTpLgqvf73ohc3ahajdD1N3mII8KWfC6D+wk8tTpZuzwahoKUj2I6+dROgajtMAXA6JspRvlqVZSl5mqkCWVlCMVbf5i9Kb6I0pnYb1axJ3ZzOgd2nxHe0V1Zqc4obEY+qrxHmdLWpGgj3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=CZ2YPwp3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IAi9ysm8; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8A2D211400C5;
	Tue, 29 Oct 2024 10:37:01 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 29 Oct 2024 10:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1730212621; x=
	1730299021; bh=uwXaMiHv60LoZZVSxHl13+Rw6h4A35GgnjzQx8o5D7o=; b=C
	Z2YPwp3oykk6NtIP0YO6NkUXaEtLk+xhaXp9MKfFeRByypJYQslVBLulpFuqSRPL
	5zu8JwrnXoD69mui7dlOyXA/lpdz8WAmm06oP+EECuZ8EK7fml48zKJEF/0UxB+4
	B3nta82114vcA/2WoGAJ/69oFkjrK1K/Tcz6fUAmZup9lSAPItasLA24qXmGM/ih
	unS9UiesZgTWtREQX7dOP8XVq8LqFzeAvhI8nXWDvG6/dAxbqlVRgHwUEJlzr+8k
	G8QF2xrDxz8JiCDHo5OuD4QCBbse3HtUtS0TEaOHxfBD4QtXguTo40g4lmO6DXMb
	eqL9cgh4OVgoI2KvUL4UA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1730212621; x=1730299021; bh=uwXaMiHv60LoZZVSxHl13+Rw6h4A35Ggnjz
	Qx8o5D7o=; b=IAi9ysm8RzqMmsjLZK6o/X0vbG4193OTjPVoEeXnm7UUfru5SYV
	7K31mPjR7ucw3DtuegrRwTFk1VtVVpptQxBDad/bWePMNwHeV8HZforh6Buf2xCT
	GhOmKidr+HtRp/E8PfrsHrtRYrHR1bi+nwZZ9pgWr4CVcjntwytc7XTbk+JqlwLa
	4PO72tBjy20mtGsqhn6IXfEJVdF+F4UA8GGpZhSXGM5Gmiv07AwtYFXta2i0zlt4
	qk4+BcFF3keK9JnblHsdxQx3zQOEBhWqzGHIpzG4oVltFWDaKfQsoMyVRFy/s7RL
	kIOnokVDx1aD74EQR/C13aM9vV18X7TEu5w==
X-ME-Sender: <xms:DPMgZ2O7aDuoZ7CZg2lJT-OV1_qz1VW_Ga7hJxFhXMujm1TyR5UExg>
    <xme:DPMgZ0_XLEVspY9LCWMsR7RPHCDvL3tOWVIwlNh5eDa8sSmaHWlbU51HkN8TooXMY
    TE1hlHtlmLHjXyEk2s>
X-ME-Received: <xmr:DPMgZ9T-vLNyBMFesBPcxu6FUXaJadWm0-Gc6S-S24M0nPiXQ97zikokd_7Xa1NO91rumw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdekuddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehnvggvrhgrjhdruhhprgguhhihrgihsegrmhgurdgtohhmpdhrtghpthhtohep
    sghpsegrlhhivghnkedruggvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhi
    gidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    epuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthho
    pehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepnhhikh
    hunhhjsegrmhgurdgtohhmpdhrtghpthhtohepshgrnhhtohhshhdrshhhuhhklhgrsegr
    mhgurdgtohhm
X-ME-Proxy: <xmx:DPMgZ2tkvlzNbwN95cuAEIYRDCdpmIXitZ7TNyNO4FOQu0fpvBwb2w>
    <xmx:DPMgZ-enMCSdHCNXLKltlMNoEs9_8ux-TJFA7fhgba9wQHea0w11Kw>
    <xmx:DPMgZ62ja7sZD9-vN4W_eIRK9T5q4skH_GSp6slPwVirvIi4WY4bfg>
    <xmx:DPMgZy-w-91PiKc6AEa7eI4yB_L1ibwHVNUB03n0kcIs13zXbK7WQA>
    <xmx:DfMgZxVdwuYloCbpul0lq2zf02R3DnajeCEkxEvDmRQDOg3caZGk4nE0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Oct 2024 10:36:55 -0400 (EDT)
Date: Tue, 29 Oct 2024 16:36:50 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, 
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <mzrkt3qm35tluz3sh3weg7g2xf6xozgmiimenyidubcyofyrng@a63x6gie4vqy>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
 <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
 <submtt3ajyq54jyyywf3pb36nto27ojtuchjvhzycrplvfzrke@sieiu6mqa6xi>
 <8015deec-08e7-4908-85e1-d42f55f4bb6b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8015deec-08e7-4908-85e1-d42f55f4bb6b@amd.com>

On Tue, Oct 29, 2024 at 05:45:23PM +0530, Neeraj Upadhyay wrote:
> 
> 
> On 10/29/2024 5:21 PM, Kirill A. Shutemov wrote:
> > On Tue, Oct 29, 2024 at 03:54:24PM +0530, Neeraj Upadhyay wrote:
> >> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> >> index aeda74bf15e6..08156ac4ec6c 100644
> >> --- a/arch/x86/kernel/apic/apic.c
> >> +++ b/arch/x86/kernel/apic/apic.c
> >> @@ -1163,6 +1163,9 @@ void disable_local_APIC(void)
> >>         if (!apic_accessible())
> >>                 return;
> >>
> >> +       if (apic->teardown)
> >> +               apic->teardown();
> >> +
> >>         apic_soft_disable();
> >>
> >>  #ifdef CONFIG_X86_32
> > 
> > Hm. I think it will call apic->teardown() for all but the one CPU that
> > does kexec. I believe we need to disable SAVIC for all CPUs.
> > 
> 
> I see it being called for all CPUs.
> 
> For the CPU doing kexec, I see below backtrace, which lands into disable_local_APIC()
> 
> disable_local_APIC
> native_stop_other_cpus
> native_machine_shutdown
> machine_shutdown
> kernel_kexec
> 
> For the other CPUs, it is below:
> 
> disable_local_APIC
> stop_this_cpu
> __sysvec_reboot
> sysvec_reboot

Backtraces are backwards, but, yeah, I missed reboot path.

> > Have you tested the case when the target kernel doesn't support SAVIC and
> > tries to use a new interrupt vector on the boot CPU? I think it will
> > break.
> > 
> 
> For a VM launched with VMSA feature containing Secure AVIC, the target
> kernel also is required to support Secure AVIC. Otherwise, guest bootup
> would fail. I will capture this information in the documentation.
> So, as far as I understand, SAVIC kernel kexecing into a non-SAVIC kernel
> is not a valid use case.

Hm. I thought if SAVIC is not enabled by the guest the guest would boot
without the secure feature, no?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

