Return-Path: <kvm+bounces-48033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 915F0AC84CA
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A1AA1BC3CC6
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657AF220694;
	Thu, 29 May 2025 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CnVi6UAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF5F20B806;
	Thu, 29 May 2025 23:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748559785; cv=none; b=npovl6umFGXSFE91PulDmyr7rWvdVc8H2/uWxmZd7WzNNJe8DfrsmUFVXueDCsK56g+SRNFm3OWqooLbOTTbHhwj0VwJjrv2VGusq6SGGFxFiFpnXRmxU3/actwgz1epnISVyF6ux7OPgzBqfQ1Dlaj6z/c3KJh/6yuYb61+Y5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748559785; c=relaxed/simple;
	bh=6qhF68HE1ftdSgDFu+hBJobeV7v0fIYiQRZ+0S5XJnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVVWPWFpfL8El7KjMoJ5F50Z5YGiPBNLplj21CEyUO6eD/SJcrT74Z8e7+4UAeixaCaqf1Sr7fYs63phnrCZo6W6R++AzGnkLArX8868+Fc438h+E1iR7jTrSc4cUlWaU/MpYD58ycMHaQhI6rqX1ZtOIUIs7qg78VjbIMEwhpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CnVi6UAD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DC05F40E01A3;
	Thu, 29 May 2025 23:02:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id atm2818uktFj; Thu, 29 May 2025 23:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1748559768; bh=wPDpKpHJ7VOTju4owFMc/rz0TIuDFKjFr21HY0fPmN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CnVi6UADBW/LUL0mVSlUWvUhj+r8P4xxoh+dfN4fwDQuFXhnsM7PqC8uTe7wBVk9g
	 muXHC4nMiJvX6nbMX0JWIvbpSHouezBAJ+uf6gh0poMMYTAjqI6h0lhusLuOj/CqJ2
	 ow2kamCczrJ0QNtJe5MNjEUQ/FADWLXRMBLVgT+mNt+N2cvMfmmglRNGe/Cp+bBHHa
	 KV5JwsaSdDDmet8AVRIjz6q2TzNKbFv4Xtf3d7ouUxkjBt4ubqbZpJoJmzhulllTTo
	 5pvHGRYlxhBzNHqOS4ukXKrtJivt/c0OLHedwIPZI2lmNk8pZzSyo8hiFcZtv3Mjop
	 kqBsoC+uXpmfXD7UZDDfr/5aO+Kpk/h6yZPaU84kPPQra+xpGr42dx/l2N098mqJue
	 pJ7ibnddghb9MtvdVpZFeuFk79G/ELE1NsN6BLoEw76vhDsa1x5YE/YUgQW+eskwmm
	 ALIzP8B/Dd6Yk3ZhfDjfZ8LCWIBVxT0Z14PUzVgecbORVmafl/H0qAGkQLZH0xS2R9
	 urfgr2AOB5G/tuTZtNOTcX31N3UMggPYHhKqEnyO7H6Q0K0t/mfu+Td52V8yWvivhT
	 CvMUM+tTyZ22IR/TXDAAvc4uxj8kvluapJ6cNgmuMs6Yiv+f5UP4L01L/flM1Y+0rT
	 UOweecLjIrwKch7lEsNehDqE=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7685C40E016E;
	Thu, 29 May 2025 23:02:39 +0000 (UTC)
Date: Fri, 30 May 2025 01:02:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <20250529230233.GEaDjniaXGlxAU0NzA@fat_crate.local>
References: <20250527144546.42981-1-kraxel@redhat.com>
 <20250527162151.GAaDXmn8O3f_HYgRju@fat_crate.local>
 <77hywpberfkulac3q3hpupdmdpw2xbmlvzin4ks7xypikravkj@xjpi7gqscs6a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <77hywpberfkulac3q3hpupdmdpw2xbmlvzin4ks7xypikravkj@xjpi7gqscs6a>

On Wed, May 28, 2025 at 09:38:24AM +0200, Gerd Hoffmann wrote:
> Use case is coconut-svsm providing an uefi variable store and edk2
> runtime code doing svsm protocol calls to send requests to the svsm
> variable store.  edk2 needs a caa page mapping and a working rdmsr
> instruction for that.
> 
> Another less critical but useful case is edk2 debug logging to qemu
> debugcon port.  That needs a working cpuid instruction because edk2
> uses that to figure whenever sev is active and adapt ioport access
> accordingly.

Yeah, I'd like for those justifications be in the commit messages please.

> > We'd like to add them to our test pile.
> 
> That is a bit difficult right now because there are a number of pieces
> which need to fall into place before this is easily testable.  You need:
> 
>  * host kernel with vmplanes patch series (for snp vmpl support).
>  * coconut svsm with uefi variable store patches.
>  * edk2 patches so it talks to svsm for variable access.
>  * igvm support patches for qemu.
> 
> Hope I didn't forgot something ...

So why are you sending those for the kernel now is so many other things are
still moving?

What if something in those things change? Then you need to touch those
again...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

