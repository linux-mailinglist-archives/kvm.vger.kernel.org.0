Return-Path: <kvm+bounces-30795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 258CC9BD5D0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9971F238A3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353A01EC00A;
	Tue,  5 Nov 2024 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jCRwbbzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B881DD0D0;
	Tue,  5 Nov 2024 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730834693; cv=none; b=aRuUdAT8DCPI8jNj0KS+g33f8ZkekdXnu3QNuPrEgDfkWdRHvcX5R9eLzVIaJnj2JmtxB2CVfsKsmio7H+Ltfu7SwZEIXcoJwC2BdvYQtCS34J86FJQQ8lfD2qLTs8byYwXE9UurWapj9YSv11VvDvL7jeFDybEdxhryXujhJ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730834693; c=relaxed/simple;
	bh=qwSYttQIfuIGWDJnGrwNQ7ztYvm8AwbNmNq5uaUdPlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjuCSpfxJhvM8aReP55r6K+KFiU735WI7cP9bC77W3EpUumUF27wB+osJak7jnu1upYzDCVIvw65AGdip7o/SDpozxS7DoEb4cBUWJajiYGb8tBwVL6iEpCArS+tCu35KJdfm0bggXaxyZzdAjBNJZcIyoYeoYNLidmHKs/XoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jCRwbbzQ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E2EC640E0191;
	Tue,  5 Nov 2024 19:24:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OvbG-xBIpPWQ; Tue,  5 Nov 2024 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730834684; bh=bpUdtWQq60oY7NHfKxuRWAg2XjlYpcz2VP30d1zYrq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jCRwbbzQyZTbyGr0mNMmnMwxGiuekoIvGhAIOuifvB9pZZp4dgH9xPKIJ2N1yMTCT
	 fvOUD28f8msYGhEcg1CGrs04DWF9rzmkG3ULCdnCL9GJaNRAHqE4O+1zIwdWzcTkYm
	 sYxWrs12ZLoCRQuRLJfFSnQSf9sthQH/T3rlEFxLlBc1kwADC6xvVuPxYmDcIPy55e
	 s7R9QTEOgo3wDzLO0NJzLZ8gOMVwUbLJ7SOYyEd2mhRNo10y+lXJCFBqFPkQbU+FTp
	 AMX/LttqgHBkrOkkHZJa+CpfJ/33WWZnX6bLrcq+EgHz7jvVrp79AUv/2HlojGYkd9
	 ipormw4RkWb++esf43LD5DtooLAMwMu6GuHxRDiRJM4hAobfNRQ+DqA33R5GOprrH7
	 ToR23+0VuBZhSqLc48zlpUQwvQwnVWn/iyyFfyyZxOc4drcRpirYaFpDET7Pu2z4rD
	 35GGov2WQ1FOmUztbrQxWqSmDcOtvN0evool1QDcE8ZMMsmxsfzB2I6hXmKfg1+S9X
	 wq4rFwUnOGcH1VCBaNwulsZcKLtZibPDYqoOylQ+vNRHdBW3h22pVt7RYXqc0uUXtX
	 BQpo2HQotVA+bMjyjSEmLP0Jmb88YVvI1IRM8z1mVO56hiRg2MKpl+D6tBDcUQy0nt
	 xj+Fuji2/aknvmGPcrRHnkzs=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8D32C40E015F;
	Tue,  5 Nov 2024 19:24:37 +0000 (UTC)
Date: Tue, 5 Nov 2024 20:24:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
References: <20241104101543.31885-1-bp@kernel.org>
 <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZypvePo2M0ZvC4RF@google.com>

On Tue, Nov 05, 2024 at 11:18:16AM -0800, Sean Christopherson wrote:
> It gets there, usually (as evidenced by my response).  But even for me, there's
> a non-zero chance I'll miss something that's only Cc'd to kvm@, largely because
> kvm@ is used by all things virt, i.e. it's a bit noisy:
> 
> $ git grep kvm@ MAINTAINERS | wc -l
> 29

Hm, ok, so what do you guys prefer to be CCed on? Everyone from
get_maintainer.pl's output? commit signers, authors, everyone? Or?

> Heh, I found that.  Not very helpful.
> 
> If you can't document the specifics, can you at least describe the performance
> implications?  It's practically impossible to give meaningful feedback without
> having any idea what the magic bit does.

Lemme see what I can get clearance on...

Stay tuned.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

