Return-Path: <kvm+bounces-63202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0DDC5C815
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 11:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5CAFE35CC3D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512B730DD2A;
	Fri, 14 Nov 2025 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JAF4+/hk"
X-Original-To: kvm@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F5630749A;
	Fri, 14 Nov 2025 10:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115031; cv=none; b=MSqknu8YGPA64yoftu9tlJsQP8sW4b7b/XbouP0gwhy/jXrimenWPwVZ+Hcp78N47QDpTe3yNOoSItDpmpwZrmvC+MgxILFg4td85QzY2vF9fZkTxIVFUX+M4fBuAKrQBjlha3fOmr7p7FetKRLVT1zVzsdMTFEbfSwJOLSzNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115031; c=relaxed/simple;
	bh=GLFtpjtJuopvO268pseNyWlZ2YMxSBCGJjmnlf4AZUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u18kzf2uo9wl0FAp33Ewn9djZruJJWHK10kh+Xa5sVP5OJII/X05utK3VuHfnhX+b0i7YTYACLq0Lk7nVtCbgQhvqpb2kQbvL0nYj0CDqC4XOghtzaJXvyk0DFag6pfOsixR1X/I0aPc5mpl++QrN4x3bmMldy6vRp4cKbvlLNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JAF4+/hk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=32q2hc7/9G/MIfSp616FjspbGcq4sVJbCdOWT3fi2JE=; 
	b=JAF4+/hkDGFoHkQ25yGG8EKeSRSUowSI2GxlEpO5NlVDNwLuuqZEfwNAmj8X+bS3x5xpNADbdYz
	eEFJoiOg9rSiuLeHgda97XdWOp5Fla22GgBpHx7N8gJi+hbvYq1NG3jhynXhAEHj75FTn0DUdBVyx
	SZMgQzyJldSvnjG+9pnVGszpHsIeW75Ay/OaajGbp53oxIOWofkd5rTRzoyXUuF8mTG2PMeU39wCm
	rUQZmM+ipmNYCAdiMgJA2/tYnwDUGlpmlJfKxhOoEJMNTyLQ02JTyoseYcZxGWTuyTyYv8atb5cmi
	JAhB8RSR1gLJnNak9XciuLWVpq0CkAalUNpg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqFZ-002xpA-28;
	Fri, 14 Nov 2025 17:37:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 17:37:49 +0800
Date: Fri, 14 Nov 2025 17:37:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
Message-ID: <aRb4bRhdnw0Yi-Zl@gondor.apana.org.au>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
 <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>

On Mon, Oct 27, 2025 at 02:33:50PM -0500, Tom Lendacky wrote:
> Supported policy bits are dependent on the level of SEV firmware that is
> currently running. Create an API to return the supported policy bits for
> the current level of firmware.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 37 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 20 +++++++++++++++++++
>  2 files changed, 57 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

