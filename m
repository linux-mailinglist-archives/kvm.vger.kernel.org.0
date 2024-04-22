Return-Path: <kvm+bounces-15507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD3038ACE12
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CFCA1C20DB4
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3365514F9C6;
	Mon, 22 Apr 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VoY1bN+O"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43B14A0A5;
	Mon, 22 Apr 2024 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713792082; cv=none; b=VaDw5Cmw+HvUgQ8tDVsJvH7NqXzJ5CFGWB3BmHkerDLUu9Z8AKmyulxVN5sErn0QlladBnZrqzxWWlrCFOHYqPxKyU9QKAuQTX8MhN+L8M3GOTLpExwGMgx4kA1esH4iBy5SA5HiWzI/rvAekfCROuN+fEvYMfFvHGJvwIecCLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713792082; c=relaxed/simple;
	bh=Fi/Kj9+94NcE9a5ZJKJUVabbMQxyLBICBsXctDkZz8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hx9jyDk3WZeNnnpUfTYTK1OwquOydp5Bnb8ZaJ6FnOrbQdgzghUExMb3Ba1cYXMHHgx52+pLumoj+wn4COg+R5bgHtauMhW7wAxyMtYPOKdvfuywskoi0S8iqi/OOk1I+X5gAhhw/C2EZ0qwbGObelgpdHLjDGmszU1xAkxwKlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VoY1bN+O; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6F46E40E00B2;
	Mon, 22 Apr 2024 13:21:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id o2pv-CWzm5dx; Mon, 22 Apr 2024 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713792067; bh=qOrg2ibxyqov2YElrOiwuEVLBePFzrFxswqJwqOfGxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoY1bN+OdH5RTq9n52kLhMlx2EmPV6ij4zD31Pr88WcXO+gW85rHGBF/sQQ9ThzJL
	 5Uma7jdRjTt6ih0JxIN+pSzJAeX7CRTdz5rFg7C4Xg7vzK6Lisd+dr+xAbtb/5duzw
	 R9mwE8FemHSktoUfZ1CXenSTIEf+SrK8GEezafI6kR725f+kKzOTeALx0jph7D3p8f
	 LgAFuuayksMJI0ePpnX4q60MeIPpllInHi1OwoAiV/syFM730gUvpXt9Qp3fI95PZt
	 9upa9kUybXCCYm0Y7SMF0jTvo6oYyUPi2aRo1/jAFHUO7p5mrFRK+RTRRD819f/XgE
	 J3szI4PaMN+8Xeni9mX4PCq+moFTx+F3HNud+QiFlREdx/CU/ttFVi7x0zVwIDnr7/
	 jy7LiXtSLB37pD+rHefFMHYSts8M2k/qZJjWxy6chsIne8VFx6P9YynB4Daz8heLYL
	 epUzlMPa+3P471bIcDYKe8V+cxbdrBBeCK6ZXXa6kANntRSClAZutSAlg0kzvn/nRD
	 nkrrzfWrWPzaSIcg2NQ+mJoB6sPY0c3uem0PYpucI5kVPn1QoV7GWDLysRcoMoS8Ha
	 9llgegMXeBsFcHBtO3R+EjBQFobXlwY8AGneeLnSX2HOlMDRnxtGiBkNdmaDmJLeci
	 0Ym6/Sj4Gk7WmWvnr2567zmI=
Received: from nazgul.tnic (unknown [IPv6:2a02:3038:209:d596:9e4e:36ff:fe9e:77ac])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7219740E0240;
	Mon, 22 Apr 2024 13:20:56 +0000 (UTC)
Date: Mon, 22 Apr 2024 15:20:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 08/16] x86/mm: Add generic guest initialization hook
Message-ID: <20240422132058.GBZiZkOqU0zFviMzoC@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-9-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240215113128.275608-9-nikunj@amd.com>

On Thu, Feb 15, 2024 at 05:01:20PM +0530, Nikunj A Dadhania wrote:
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index d035bce3a2b0..68aa06852466 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -89,6 +89,8 @@ void __init mem_encrypt_init(void)
>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>  	swiotlb_update_mem_attributes();
>  
> +	x86_platform.guest.enc_init();
> +
>  	print_mem_encrypt_feature_info();

Why all this hoopla if all you need is to call it once in mem_encrypt.c?

IOW, you can simply call snp_secure_tsc_prepare() there, no?

Those function pointers are to be used in generic code in order to hide
all the platform-specific hackery but mem_encrypt.c is not really
generic code, I'd say...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

