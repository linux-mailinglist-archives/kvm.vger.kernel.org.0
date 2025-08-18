Return-Path: <kvm+bounces-54917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C9DCB2B259
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9CDD3A226C
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205632367CD;
	Mon, 18 Aug 2025 20:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MK0ijr+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F9224249;
	Mon, 18 Aug 2025 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548821; cv=none; b=ncsYmFGoomvGo3goWV0WnCJ81L9oMcQrbiPYIwjf+V96HMxHRkOECbJ1DmjpKLOvhJWo+QlEvmC9BpOLzOeT2lREcZHvEJp2nA5fPaFGTQjJyB/8AkPIs9Y+t75k+uIQy0gL28Q7IdnxaTUr/KNmqpqi29AW7IviFrUtgTgEtrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548821; c=relaxed/simple;
	bh=uJHM7zqualHncQ2D/N60mSa5yjpVHHhYO1mWjPe3lSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XO9zkVOX4NkdjiRKrovyoK2yNALHx6156TF2SOE3g8Pqoee6r2mk4fMMnyUr/CaDK+zChh5Pkpq0+yyXmyTvoUF++y/vnpvohFWcVcWFivKXK4hfcZfl1sGZnJZ0oExsilgNEYSxHIxULgFHk13EIjPhcqb6tO8RBMMx42d0d5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MK0ijr+d; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 555F240E0206;
	Mon, 18 Aug 2025 20:26:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pTj2BnPgEFZ6; Mon, 18 Aug 2025 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755548810; bh=0nIMB7ikC6ejc5RbpVtflEInq4HoCk8mbrbVxRKRxN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MK0ijr+dG3B5akrOWciMqtdcN6dTfNUMNmuAnneRc315ifM4q7m8d98GORCaGwv3W
	 TcvLgIN2EkxAlmMP7rgg4QQwIIcJF49qdk/qV0em0yCasDzUqH8s4e7f6SrUXPnJlX
	 BrnQ0zDnArKfXpoKNalX+0H4oI5bz/1UmlE5OqplPcGSvdjrhXLEpbkLyClNy27xaX
	 npmPRXovMCCOHj7eP0E9rUrKYUAaMMYZMBRJjIpkYKCImmS26ifCthObFntFd3fRhd
	 4GrVmiGYOsvrRTzJxwKAzrji4IChXwkzzxsIAVRnsH6UHXq4miDmCzQS6LlHGWCSIp
	 FKWwC7ImxYfCo+l5wWT+bH4j777LYiVTMGP4BtGx5qnovtr6prlh9QaBdhqFaE8XPx
	 9xx2Bb62xrUSvu0HJ+C9oBv0LKwc/c0tCpDBRzmxlcOq4TLnKPbcKb6lyHJnr9lPTg
	 TEJGD2ffre1QOkR8i1nNNkv3g8exl5d4PA9xcldVwoQcTTa6B5ZFeknakUBsp7/LBO
	 XjkHCnTAXwyJS4AqDIVV4Q+8p3DcgWUQ26cfBQYkp5qqU2SP3uySIETrkTAKK55NNh
	 LtUM03WhYeFnhsh6PVBSkdAf1YcHpg9jVPESLxods3QfrTnvNUGjMT1hsYN27dxfpW
	 pPnukvGBtNdYGLetLoqI4i1s=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6178F40E0217;
	Mon, 18 Aug 2025 20:26:31 +0000 (UTC)
Date: Mon, 18 Aug 2025 22:26:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, nikunj@amd.com, davem@davemloft.net,
	aik@amd.com, ardb@kernel.org, michael.roth@amd.com,
	Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/3] crypto: ccp - Add AMD Seamless Firmware
 Servicing (SFS) driver
Message-ID: <20250818202625.GOaKOMcWWfaknAeynd@fat_crate.local>
References: <cover.1755548015.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1755548015.git.ashish.kalra@amd.com>

On Mon, Aug 18, 2025 at 08:18:12PM +0000, Ashish Kalra wrote:
> Ashish Kalra (3):
>   x86/sev: Add new quiet parameter to snp_leak_pages() API
>   crypto: ccp - Add new HV-Fixed page allocation/free API.
>   crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver

I'm guessing this "RESEND" is supposed to invalidate the one you sent earlier:

https://lore.kernel.org/all/cover.1755545773.git.ashish.kalra@amd.com/

?

In the future, please explain when you resend so that people do not get
confused by multiple patchsets.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

