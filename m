Return-Path: <kvm+bounces-30968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2615F9BF1AD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:30:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3D8AB25B90
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2134D203707;
	Wed,  6 Nov 2024 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="V1gbekAz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070E2036ED;
	Wed,  6 Nov 2024 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906985; cv=none; b=qnjCAA/JArXv2LnIFlS5Mee/GGgzAkNo947Uzr78Vz7O3zPBNB6T9kgohDjvzQtwMHQlomuaT+TOb+ponPYs7hWNcdmwoDxgWK1otPR4Wl1zjsO+GoAnkn72h6GCRLtwcOgDqSbYj4Uy3c8bknEf6ANZBsc87pjqFpxCTRzyY5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906985; c=relaxed/simple;
	bh=W19tRKOCMa+pU1wWhYzQOPLI8ukpvgHQLEsR3J2Xqkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6acTlaxX459e1yy/W7xJ9tiSeDBxSn3qS5Z6Rj/7SWDwpJgIjLUiPRZOHv9EVKUyGA2ID0FdhXqhewk1MUd8uw21XLFJx+DsSnXOhRjnEm2KjZX5MYDyrH0epq+/Rk9bcyDnIPrWJlSe/cRctPAg5DJaftYpbHuEJzs0+EgtUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=V1gbekAz; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 62FC740E0163;
	Wed,  6 Nov 2024 15:29:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bg2MlC6n-Sc0; Wed,  6 Nov 2024 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730906966; bh=eracO3TKdAG3lpmuW8AzlLLISI0xIUf6Lhrw64wxFpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V1gbekAzy+c/P4HIsgM3/A4aL7KKEkppqyVOlPQhZnBvAyFvY2b5Dezpca7r2Cg8u
	 nYWeNQ2fSstY5ZUzVgmnJsJFFiFmS4iCuuPOKhcqgJr9jUCRtN/goSIul07tJFMaye
	 i73YqPBWN3+zn2veeRZzXZfjZEnYZCcF6cT5sVY15FqYnbdo2vtYP7h0Ia6AXV4Ffp
	 /5cbTFd3C+8gRj6f7H2j+xGTXghYauTpqPh3t77F55Alf6nDB1XpHfesAz2pRncMAB
	 ypaX2pGzvNqz42WMWtYdQ5Rb85xTEIu2LnJ8IPInid/qf8LeAnD6fw3vdiPhmgoLDi
	 ShSCxneUdoi0f3C1I37HmlSd4hiairoqgV9tlxxFogYBkUfG3CkTP6e8ofKBGNKyM+
	 B78T4lPh2V6fMSGZ0My7Tezz74pHjjyE67uX7UaIy/k9XqvFnTLbmjK2gausfFhaxF
	 93iCSqrThjPP7PDA847izYhT1hPmJp+POk8HhB50bk6HMALG+OfsCnGFmhtaggzMjT
	 D2CRpBMh+zvOj+BUskmwgt6Uv6/3GdpffP1pxLXOzIHTTI95NdG/d8ZmZwcXvjQy4l
	 3rEST6oLqrrsF87SYtzP7R3vIFKe/D6kO+eG/wzWi1n6VpDqnLOyE9+JHwFNxcSeru
	 dzuu2YGbst/qlBEc8CobpqCo=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AFB3640E0261;
	Wed,  6 Nov 2024 15:29:19 +0000 (UTC)
Date: Wed, 6 Nov 2024 16:29:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
References: <20241104101543.31885-1-bp@kernel.org>
 <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyuJQlZqLS6K8zN2@google.com>

On Wed, Nov 06, 2024 at 07:20:34AM -0800, Sean Christopherson wrote:
> I prefer to be To:/Cc:'d on any patches that touch files that are covered by
> relevant MAINTAINERS entries.  IMO, pulling names/emails from git is useless noise
> the vast majority of the time.

Huh, that's what I did!

Please run this patch through get_maintainer.pl and tell me who else I should
have CCed.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

