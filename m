Return-Path: <kvm+bounces-30792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF18E9BD581
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B1D9B235B6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671551EABB9;
	Tue,  5 Nov 2024 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fGWFDT5F"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ADC17BEB7;
	Tue,  5 Nov 2024 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730833007; cv=none; b=kt6Cw6G8Jnbx9C8fOmF62hLgeiuUWQebaKDnbouxR1430UwLmjhaKGVWugwLIxCj10lBPF70TsTT2ctjWr7SJWMu1fjur8F4DOqDibStP5mwOjuv2+kyxP8I3O0zrOGske6Iqkc24WLRRPCr1CerpTW5XNT5ncc6wIkBx59Cb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730833007; c=relaxed/simple;
	bh=fDC+DC04AfobfCKsqsE3Ncv8lSY4rjtZpnZG07u3rTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tu3armQg0Ore4bV4bDT7B/VAX2+eVaYr37IfP7WXlGjwN4+0+IVCmNEjpu8Baq2CF3uOkxmDgIncbwCFGKv4DT5zcKoMSisQbmB0ZYUfLpzreykLwo+z/LBW0sXeOJJ1R0Phn7n4/gA0mpqFFoNO7a3o8Np2peQ6NJungApsHeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fGWFDT5F; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2433B40E0163;
	Tue,  5 Nov 2024 18:56:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aiURuSV21_uG; Tue,  5 Nov 2024 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730832996; bh=I8aW/VbKaY+7owU4pno9TABnD0uUjvFF1k94INRxs74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fGWFDT5FA71o6hWu8Nm7s9Eu72+jEPTyjYS4pkiGEsEef+gdMZcUvz3rl3jVVqLkL
	 R7JAaJKCxKsJLqvwMbSLj7q8b1bFrrPdan0mrBcqkDPbsxf2LxsGFihccvVatjV1St
	 V5i6UTSpo8YOWg/NcEucuCWUE6CY/mr3bS0OVOSuxO+MSoQPtspB8AV7DqHxH6DBeD
	 hTB3HLKUhF4Z4Z2W6YSjE32RDPNjacopPkF06CrjSWA1m4QlA4XlMVKHxz8dBusA5d
	 DXlLx+Gng29Y195nvDN0Px9M52QxrkV2r6Xr59th3lLLYuU4HIaugnydl6CxIwbknN
	 hnWH9Y6bn0me32aiXvuisb3ICuTYOoh97OAjqArp9gSswDs9EjUUpm/sK5G0gntuni
	 Y0jBJZP2ftC3QI9h6mwndzuaHWT281UCn4ySrBcaP1oaQorJXoi+vcEu1j/7GgTyec
	 v/CnAm0sh0BeLG2Er4FVwYSCdfEIag6MDX8/NBZ+cLNZ1bvDnRYZRMpbj/Vnz5Qq4h
	 c4McqlAK60+ZTEWOcIBbHO2TRT4oD2IWdlwSy5Ts6AsZc8x6ZhvL8ouo+cNs69QNdA
	 3X6Sv1MaKfZvn8ioCKsUVPbJTznDD+uuiPpOBVwTNG+x8NVVipJCu4kciBHoUBoBdl
	 Vdg3UdE6zwZ64RhR/R4cu1cA=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C0A140E0028;
	Tue,  5 Nov 2024 18:56:29 +0000 (UTC)
Date: Tue, 5 Nov 2024 19:56:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
References: <20241104101543.31885-1-bp@kernel.org>
 <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZypfjFjk5XVL-Grv@google.com>

On Tue, Nov 05, 2024 at 10:10:20AM -0800, Sean Christopherson wrote:
> All of the actual maintainers.

Which maintainers do you mean? tip ones? If so, they're all shorted to
x86@kernel.org.

> AFAIK, Paolo doesn't subscribe to kvm@.

Oh boy, srsly?! I thought I'd reach the proper crowd with
kvm@vger.kernel.org...

> > Meh, I can split them if you really want me to.
> 
> I do.

Sure, next revision.

> What does the bit actually do?  I can't find any useful documentation, and the
> changelog is equally useless.


"Processors which set SRSO_MSR_FIX=1 support an MSR bit which mitigates SRSO
across guest/host boundaries. Software may enable this by setting bit
4 (BpSpecReduce) of MSR C001_102E. This bit can be set once during boot and
should be set identically across all processors in the system."

From: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf

I think that's the only public info we have on that bit.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

