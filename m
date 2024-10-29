Return-Path: <kvm+bounces-29951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 035139B4C98
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBED028356B
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E2319645D;
	Tue, 29 Oct 2024 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LlEbl5pZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C8B194C75;
	Tue, 29 Oct 2024 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730213414; cv=none; b=KhFcZ+QFoT9RQAGwS4YLUkNcYZOzltVWFa6JWIpVKloJtB0qLq3OXynQDQSkOfAZJBWkC/FPqW2kDAwTiWsVWYnWlEniRe341ELBua1YsjXO+kX/zozYzhGrhPtCF2b1qR8xrUg91/0GW8NsqqIR/3cQdC/z1+DIJ0D67l+KYdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730213414; c=relaxed/simple;
	bh=fZTyaj22JIkb2FcI9sUkxwBr6W8luWOnb0bVCY1x9uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JC9ZdaU7iFHPfNslNKhhovjyhiC9q00jj6kRu2TNUr8nAmsKGLaepMtgOy15TPe6Fq+BlWKOcM2PPn6KxZbblUtg9OTndWSjg/ZLfPTXIlEL3HXS+mmmuFZc0iwCFBGiJX+NLk7UcCEcykvlhTTHi0Z9MEWuPdnShp/2qInuu8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LlEbl5pZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D6BDA40E026B;
	Tue, 29 Oct 2024 14:50:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vdGI2Ly4XQ86; Tue, 29 Oct 2024 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730213405; bh=fRCUF/cK1sm6U9IMyeDRbWp4UtUVnrZkCEESVtrdtGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LlEbl5pZdVomYJRSM6CL3m9oSv41kUTusSPMILQUEx5DFwU4N5V6n6A0Q3Poyb3cI
	 1Zz8QALuZU6sg0YGbgCgbXjqSmZF90K980usoCCGLF6d+fl/+BSA2oPJq3ixoxqzdL
	 5V2+TrkvGsAtL1GaL6IcpeObY9Vt1ablCz/9wAYKO1SRxzDRrKecta4KsVRjJNtLLk
	 9iqyHlk+870D71yt38jq8lOuVkmBcgdUyHj/wEJxpQd3H3d5ArCOi0OVfDCtNvZ2Zn
	 FCXQQZsgISoKeOUYHdZI4kCXSrhFBto5bdA567NinVTWSSduOVjKHROhuKO0NYmHWk
	 fTmIfJxkiWt5xPgHOIrhi3Z0tX3xEzi0klAKCmZZkOxqXFJsu9GMs/onKhktgtIP/1
	 BiICgA4xmg4WcObYI1tBhmZOHJ6+SJ+zxM3u8cy3Ay1LJMG2jXf6xo39IB/paeAGp8
	 dDARy9iX2EoQW8swdFJqrtcQOaAcg+ywXsYlmikh6VbapmQpZim3vdQty9Tkso1saX
	 wdozgM+oCQHrCsZeONBK9FSdjjaPbX0fjjAUse8yINw3hzu5X2si+63rFSUJQniCkB
	 F3Y2jk6co+IT4/v/WztSd2d7NIpJw9MF/c9yAcQgMrX4r9g/5jFw5s6qtav69nJAx9
	 MtA7y7Q82vWZ60q5TPUfQNFk=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5E3EF40E0191;
	Tue, 29 Oct 2024 14:49:53 +0000 (UTC)
Date: Tue, 29 Oct 2024 15:49:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	"Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241029144948.GIZyD2DBjyg6FBLdo4@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
 <47219729-826f-b36b-e124-8ed404e7c6ff@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47219729-826f-b36b-e124-8ed404e7c6ff@amd.com>

On Tue, Oct 29, 2024 at 09:34:40AM -0500, Tom Lendacky wrote:
> TDX also makes use of initialization that happens in mem_encrypt_init()
> and mem_encrypt_setup_arch(), so it doesn't only use tdx_early_init().

I think he means that mem_encrypt_init() should do some more "generic" memory
encryption setup while the vendor-specific one should be concentrated in
vendor-specific calls.

But this is all meh - there are vendor checks in all the memory encryption
paths so I'm not sure what we're even discussing here actually...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

