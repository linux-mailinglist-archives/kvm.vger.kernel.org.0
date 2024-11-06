Return-Path: <kvm+bounces-30997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C0D9BF2F7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A89311C246B9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C338204942;
	Wed,  6 Nov 2024 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K1QDha32"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B743A1DEFC7;
	Wed,  6 Nov 2024 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909625; cv=none; b=kvAkdHfoE8AbNenl9caNkEAKjOOGbv8qZ6gX4srRcsC0+Bofqzw1m9iyVlPcjtgZns8d/5HROCUGTF2cYBBTndd+3v3f65o68/oQ+AIXRAc0ijT8MqZ7AMxsNSeCpmf6KhNg4rEkspPPKBfNX5mI70FXostISBydxsj7RReH2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909625; c=relaxed/simple;
	bh=fMW/VsOUBf/Zzj/r5YgUE0W40cX8c/8i64nz6ZYNeH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBqARlLz0jYJ9fU0E0qAmTaEhVG1nB/Vz7WcD+fWbrTOlp940rVjYS3dSwnUObSQGdWZdKKWqmZIrWivX8drNdHMPbp0Rg/yp7hSFvePOaUSo2zxeqPXHO7y9PNom1LXk2ES068l5gDeqw04Yw43WMc66F3d7UZUkM87FuGtRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K1QDha32; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A727340E0169;
	Wed,  6 Nov 2024 16:13:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lFXbq98d3ilJ; Wed,  6 Nov 2024 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730909615; bh=yem5yUNBo739fH9yVwWSEMahuq8YLo7+oLjxfHLmaBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K1QDha32VM+gvATPnBylkqxb7p/63c29FuKywJ98uiYe189FEdixJM+JckTpBromM
	 Lg2ZjyHGgqp7x7iTS4IUywRzQ01m4S+fCPO3oGnB4ffc0tPXjmCy1GRmF9TNGx1L5w
	 Je8wR4Kg4q3NJ4Ml//Bs64J9yoqpPTvhH2c9x7G4HRI/eVj8u8te+EOcvAMr8xSmPl
	 d3HLo7tiMZnZqISypm0WTjZpOBwxhTnvYq2ZqQ9AqNq/rZNOK1pZ1VrqPBVnMUbrxh
	 Wv8VaNe1GFzHTQ+8iSsvFY523cqnHU1McvZA6JFnBB3lRnCCDqs6YhFuHOn0NLnVKG
	 Kg2v1aVDmnGK0TzlYq9M0NSQ4MZUxtEQTqzzbCrgbnXaBfyyEeMOBzXbbqir9s+LPN
	 iBQZ/qc7FLu2IkE+j16SetEn9TWkmJS9DEPsI0dPOOrdM2CToydl7I3jUn7zKWdVoc
	 yXJWPBd0X/HkwkCUULIoXTulyA+PTzKdN50Npm4/eJkENPSyMx16B4gwzYhbK1/jgo
	 Bd0MWOZwhfiV/56n1Sy4Mkl40008JcMGRIHUN5DE9D15q6SNfZ167ClMP9Qll8L8cd
	 6QZv717JiKGvI8vyRPx8fn2p2y1F+xP3Bk6YbEN8bIDNvGFX99JBrV+shhJadqpH7I
	 +mrMK8DFcVhqSGBnnyGfqeZI=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7200040E0191;
	Wed,  6 Nov 2024 16:13:28 +0000 (UTC)
Date: Wed, 6 Nov 2024 17:13:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
Message-ID: <20241106161323.GGZyuVo2Vwg8CCIpxR@fat_crate.local>
References: <20241104101543.31885-1-bp@kernel.org>
 <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
 <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
 <ZypvePo2M0ZvC4RF@google.com>
 <20241105192436.GFZypw9DqdNIObaWn5@fat_crate.local>
 <ZyuJQlZqLS6K8zN2@google.com>
 <20241106152914.GFZyuLSvhKDCRWOeHa@fat_crate.local>
 <ZyuMsz5p26h_XbRR@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyuMsz5p26h_XbRR@google.com>

On Wed, Nov 06, 2024 at 07:35:15AM -0800, Sean Christopherson wrote:
> You didn't though.  The original mail Cc'd kvm@, but neither Paolo nor I.

I think we established that tho - I didn't know that kvm@ doesn't CC you guys.
Probably should document that somewhere.

Uff, lemme try again. As already explained:

>   $ ./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nofixes -- <patch>
>   Thomas Gleixner <tglx@linutronix.de>
>   Ingo Molnar <mingo@redhat.com>
>   Borislav Petkov <bp@alien8.de>
>   Dave Hansen <dave.hansen@linux.intel.com>
>   "H. Peter Anvin" <hpa@zytor.com>
>   Peter Zijlstra <peterz@infradead.org>

those above are behind the mail alias x86@kernel.org so no need to CC each and
every one of them.

>   Josh Poimboeuf <jpoimboe@kernel.org>
>   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Those folks are CCed as per MAINTAINERS as they wanted to look at bugs.c
tragedies.

>   Sean Christopherson <seanjc@google.com>
>   Paolo Bonzini <pbonzini@redhat.com>
>   linux-kernel@vger.kernel.org

LKML is CCed.

>   kvm@vger.kernel.org

I hope that clarifies the situation.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

