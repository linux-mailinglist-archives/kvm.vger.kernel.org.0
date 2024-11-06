Return-Path: <kvm+bounces-31004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CA09BF365
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7577AB22706
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B9A2064E8;
	Wed,  6 Nov 2024 16:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cxklaOao"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B662205E03;
	Wed,  6 Nov 2024 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911179; cv=none; b=n1CwsApv3owkeZnukMZZYu/nb3yGfUKGyhuMMrcObeNeXI0JicB0QNVpEq+UDcYnzd/fqWdHlbZpn/WmZBRDQvlaMVd5qcjaGkRV+0BkYtn7b1RqnvA63MISYG5ol2SsfUoUe6/f8ntHGX5bZwCpw27uns/ZARMEQSr36Bw0HrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911179; c=relaxed/simple;
	bh=GYA9MjkDaBwgqN2oIjbmN7LMWTymbZq5fZknTihzdzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mSx0guakMt36c9/TFrJ9Dc2XAom9i7QxIe1oXvoms69YTQiRqzjt8P7c4D2d/uDr6AJPxY8Blh4+1r06v7w/u/yizEb/pRAZBWVYSE6shZU9ZxoBuZUEY4A6KhkoE+mRw6mxubNm1brv4iJ4yfB24s3tNhGjGUfKFFZo+iHLtus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cxklaOao; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5E51D40E0261;
	Wed,  6 Nov 2024 16:39:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LuXQmxtn_8tI; Wed,  6 Nov 2024 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730911171; bh=N5nZZCAdqn2VYgszp7ps4wrf9AaLj8hMUMFS/viYIUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cxklaOaoZ+/u9QxkuI7JfwicbfBNsdhjyuyCPdG3qwZPRo7kdxE1fleSVpmcGpyzg
	 cPpm022f8s8/j14ohof8v/jwhsZAaIGXNzCwuhk9ntt3M5b09UhSPkVLNbNRr4l4IA
	 oNSVIqGDelUUbb1uxJtukMmeN/ONRQlHPae97+9Lbr9HJM75vIpnklCIqa7Ldnhcpm
	 1amZS7QqJIpfbVKZU1q31f8VKpWTbXctRMRQcLffWcO8vWc4syRB9DJUEgpBtgYV8o
	 EnbUxoTV86EpMsGasaYAeXLI8pZ92dRqH0cdwHg7NCraMN8BRoYNxyb/hL9zs4v18N
	 9KEwH1T9oQOqOnugAZIWM6BsUb4Kj1hIcSPLr1QDMfwuOssyILtgRZIVHh8LcIbw53
	 i7iaor+C2woPcJ4Ho1iSqnvfoyd1lUNR25eOFlEFnHONCh/hqKe1qEZ9daO0cFWaIt
	 sqHKtTNl9EUn1pWlitzcYIcSqv/ItPqLmBb9CvSgE3m5QfhOsjM0E43Ea44blE02af
	 ogsEIE024z/gqAWnTaPxb1uVgkuFtqmBdMp2npZoi+g9eWCmO073VsePH5Bd3C/HhI
	 /RZhhbdAnTA3dbT/Vlir+Dg71pn9YFO4iRlJiwzS5GAf/AuCsfNrI4CueUsOyG5Vjc
	 V4B2jlqc1owDE9Ak1+GEtv5I=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2158640E0191;
	Wed,  6 Nov 2024 16:39:24 +0000 (UTC)
Date: Wed, 6 Nov 2024 17:39:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241106163918.GIZyubtm2zhu6CZmI8@fat_crate.local>
References: <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com>
 <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
 <ZyuMsz5p26h_XbRR@google.com>
 <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
 <ZyuWoiUf2ghGvj7s@google.com>
 <20241106162525.GHZyuYdWswAoGAUEUM@fat_crate.local>
 <ZyuZAzqQIXudhbxi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyuZAzqQIXudhbxi@google.com>

On Wed, Nov 06, 2024 at 08:27:47AM -0800, Sean Christopherson wrote:
> LOL, doesn't that kind of defeat the purpose of MAINTAINERS?

You're new here, right? :-P :-P

And you sound like everyone is supposed to unanimously adhere to the rules
we've all agreed upon. Oh well, I will make sure to point you to such
"exceptions" I come across in the future.

And no, I'm better off simply doing those small "exceptions" instead of
dropping into the fruitles abyss of endless discussions which will cause me
nothing but white hair so...

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

