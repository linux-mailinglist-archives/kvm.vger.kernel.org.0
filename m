Return-Path: <kvm+bounces-19862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B9590D39A
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9C291C248C6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF0B19D068;
	Tue, 18 Jun 2024 13:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Np9hyOb1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E8513A899;
	Tue, 18 Jun 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718718592; cv=none; b=ZLyG2wuck3sJA7TKCwcHpbJD5OmhF9QEoheNaADv3gUosahGVBQiO/IidlV15xb1xzfwJ9f4D1iL9Nd88Hlf1B2myJDBws6o5ddNhAjRTWOQ0JTXx5gRKEv//E4ge+WWCLZSODhFnOEajeBm3Encv5PSiTAYokEpDv0ogWHAnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718718592; c=relaxed/simple;
	bh=486EuC1Qa+540iWb9uOgEPEU+eCRbRp/ccQhLGFvMKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkQn3JkK9zsDrB8KrgKWDaSbW0ocnBIuZNA7ORhAFepr5oNLObiyA4cZkx8l/WnjcQzzML2oF6dFAe00xRtxqD/6UE+ZtwGNoCwBkkJOEZYvhnV1Wvj2APu/j7+hm9ZT+G+WQIr5J60r4C7IWNLSVHlQdYmYIpMSdhKALU1OUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Np9hyOb1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2E57740E0219;
	Tue, 18 Jun 2024 13:49:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z7ezAWjHbROx; Tue, 18 Jun 2024 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1718718582; bh=XPQQaX4opESoUj6CHeeMTyyF5g0cOfCXuQkyPS5k100=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Np9hyOb1RtEO55hrgA0hHeSV9w1EYvbncvtWXGzYLP8N/JFV7qVXO426ZioYu4W1z
	 paBwGIxswnWkBHSGz/GX3piH/tO03FE+rJpj9rYpPGepn9ZNyFUsezXgtpIYdcbmB1
	 1ntF4hKuokgLtzb6VgeMqP8UvNVY7vV2ECkiUUXWifNWJVswmm/ZB+Z3Ph9jt13KLp
	 LnQjUPkWpZIGrx2WyqnRgIXud8RZ6YXsJMrr2GeCVUI3QuaUQr6ycseubAXvt55YnS
	 J8seAcQSwLSgMvxyJ2IhH2lElJp/oV36ipqKHOIsxlRJXstjDMg79ah6gwIm/uUEo/
	 DiTGft/InIrGl+Ysq0Nl5VfCqnPSVYpHe3mJ8yci3ZxiDfCnbNUw7l+VKt/X8Elp3D
	 9MdUsQ/tZdUFb+kad9cAbFc97XUYn3jHPHafripMFLD5monW5DMFWnBPmKQaKDpfev
	 DZVUipbHCUWIJP2XjQsKJ2Drm2gCjf9B69oHM3Rg4xQpWOLqPA2XY/IjLqyz2S8vRR
	 ZAAppGHtRd+lg+fznCsSZPOQbz/Er0eW1Cqbz3gtzG9t3MWxe9E0wS4U3CRpvJy6wF
	 00UDaJkG7/98+1E5o2Z1oW3+CxIcRXw6s1mbMFt4gqNnmgaoiwHKZXO5IfhqVB0eEt
	 YmL5wlg1Te182yf+yT1RZZPM=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC0E740E019D;
	Tue, 18 Jun 2024 13:49:37 +0000 (UTC)
Date: Tue, 18 Jun 2024 15:49:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: SVM: Use compound literal in lieu of
 __maybe_unused rdmsr() param
Message-ID: <20240618134937.GFZnGQcd1iF1k5Nn1Q@fat_crate.local>
References: <20240617210432.1642542-1-seanjc@google.com>
 <20240617210432.1642542-4-seanjc@google.com>
 <20240618102434.GDZnFgYsJHTGibyuX1@fat_crate.local>
 <ZnGPSEB9GOclr9yO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnGPSEB9GOclr9yO@google.com>

On Tue, Jun 18, 2024 at 06:44:40AM -0700, Sean Christopherson wrote:
> Yeah, I'm 50/50 on whether it's too clever.  I'm totally fine keeping msr_hi,
> what I really want to do is rewrite the rdmsr() macros to return values :-/

... and make them inline functions while at it? And perhaps unify that mess:
rdmsr, rdmsrl, rdmsr_safe, __rdmsr... And, and, ... And, and, ...

Yeah, it certainly needs scrubbing.

Once we agree on the approach we can split the work so that it can get done
gradually, without any humongous patchsets converting the world and flag days
and what not breakage...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

