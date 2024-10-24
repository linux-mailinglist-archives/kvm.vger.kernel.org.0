Return-Path: <kvm+bounces-29637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 910989AE574
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5088F2840A3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA7E1D63FF;
	Thu, 24 Oct 2024 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XYoXAYRD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A0014A0AA;
	Thu, 24 Oct 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729774819; cv=none; b=syKl4cyUIlPT7O4pdLobOpsxGtdd51AFSIEQzZyV9BY7MBhq2bi3FQjDNW4DRgfeWM4xjJ/aOkr93GId8DZuE5zJ9boilpr/IdGc/q5yff5cIxTtgfGtRdkidu8QRc3a5854hmCwCTZngoI2/9nqowKYTryBcNTbhdeHDv15a0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729774819; c=relaxed/simple;
	bh=lL3ukI5cUECPzC7oF3YeBE2bBA8PoW0+iC3WgiiN0Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuMG+lD/CqLOOY7cOlvn29ijAWTxawszBRWmylXC47z0gQwOl5XDKRMEek/epiFYQ10+oWe3BdM946IIfSUXN84eIL3s2bGeYq36qNgsW2KJ3bQpPg9SpLyGAFpE4yZ+9MZ50QC6LpqFO/1TENwX7frL9r6m063Y5vnqylzOmJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XYoXAYRD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5028C40E0284;
	Thu, 24 Oct 2024 13:00:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GG_9DrpBbj5r; Thu, 24 Oct 2024 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1729774811; bh=EzikBre0wS3BnINAUIflaHw8OpNMIUIIU9EhiMvAqno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYoXAYRD0ZSRfy+r4WYmxAbVAK23HL9D/gKyFABqq8S9cCNBhmoBY3WyiPArEiEeW
	 o2FbTJcdP8KCbyfAqFD+aDH19TMucoDOXprU1BRCWkhTbaFd3Mlcwt4wm+MWiqPJYD
	 FacGeHoCkqOguhr+HOVOuBDLsIEMHyuWwwXuprEsGYH0VvKkgiBjz/jglr10OHjEqv
	 YvQroFlu0XrQa5tI/vGjoKoxcvS5uCzGAMfeUKeDBogjDHwnNDq6ng04RBv6WNoVcY
	 p5edDgr7t5ixsMwXZi5ZXbC2/nJ9oxgdg5Z92+z2aem613NSnf4LQFdy1Ybo9H+Ckt
	 2lLvIy6RwHJ05nTu226xs8MEYwDwjbKtjd7Wk53A9whOAG2/gBbM50bPP0av5255QT
	 L2a089Dx55QZZjyfjYww6tycyVFwAvzP7NvoScek6D9FwBCVRZfbTej0Kpuv7UYG3K
	 YS+0WhejvtnBeP4RMSZsAwAhKfc+spNl9YoRuXcFlUBNaCHDqI9dedoG90UlNCyIpN
	 1PbdP1HpoF8Xmfu9Fpdmku6zoX7NwvCCuM2prnFWTPf1oPLch+uPkoRZjBDacV/P64
	 jP2ORCC45epz6kOQ/F2OPxV6EXqb5vDk92M2CxqBVm7q7pc8wLshZZRvs5W73+Cobt
	 yFVd7mYJDh9hOAnieY1rFub0=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0695440E0198;
	Thu, 24 Oct 2024 12:59:52 +0000 (UTC)
Date: Thu, 24 Oct 2024 14:59:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
Message-ID: <20241024125947.GDZxpEw9BLJ46B5VKC@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
 <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
 <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
 <12f51956-7c53-444d-a39b-8dc4aa40aa92@amd.com>
 <20241024114912.GCZxo0ODKlXYGMnrdk@fat_crate.local>
 <358df653-e572-4e76-954a-15b230d09263@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <358df653-e572-4e76-954a-15b230d09263@amd.com>

On Thu, Oct 24, 2024 at 06:01:16PM +0530, Neeraj Upadhyay wrote:
> With Secure AVIC enabled, source vCPU directly writes to the Interrupt
> Request Register (IRR) offset in the target CPU's backing page. So, the IPI
> is directly requested in target vCPU's backing page by source vCPU context
> and not by HV.

So the source vCPU will fault in the target vCPU's backing page if it is not
there anymore. And if it is part of a 2M translation, the likelihood that it
is there is higher.

> As I clarified above, it's the source vCPU which need to load each backing
> page.

So if we have 4K backing pages, the source vCPU will fault-in the target's
respective backing page into its TLB and send the IPI. And if it is an IPI to
multiple vCPUs, then it will have to fault in each vCPU's backing page in
succession.

However, when the target vCPU gets to VMRUN, the backing page will have to be
faulted in into the target vCPU's TLB too.

And this is the same with a 2M backing page - the target vCPUs will have to
fault that 2M page translation too.

But then if the target vCPU wants to send IPIs itself, the 2M backing pages
will be there already. Hmmm.

> I don't have the data at this point. That is the reason I will send this
> contiguous allocation as a separate patch (if required) when I can get data
> on some workloads which are impacted by this.

Yes, that would clarify whether something more involved than simply using 4K
pages is needed.

> For smp_call_function_many(), where a source CPU sends IPI to multiple CPUs,
> source CPU writes to backing pages of different target CPUs within this function.
> So, accesses have temporal locality. For other use cases, I need to enable
> perf with Secure AVIC to collect the TLB misses on a IPI benchmark and get
> back with the numbers.

Right, I can see some TLB walks getting avoided if you have a single 2M page
but without actually measuring it, I don't know. If I had to venture a guess,
it probably won't show any difference but who knows...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

