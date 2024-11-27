Return-Path: <kvm+bounces-32560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CCD69DA368
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 08:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18318B2134C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A8915B0F2;
	Wed, 27 Nov 2024 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cz1p9C04"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96C618E0E;
	Wed, 27 Nov 2024 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732694334; cv=none; b=LPir4k34RnyQKMbt0VPOKx3Ud1gWmUFmIIFmL+yY7LXErNO/G+QmGgpNvxdzpC9JMcUA3lPWHvx38eVrB2APmQqln55M4bH20FSZdM4+w8Gy6PP1VdtC3Xh06Gq1VXaRvcazJ1JtqeUWIOSg1TisNyz7bwG7v0h72eWl2AFJP2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732694334; c=relaxed/simple;
	bh=6JyzI5o2AujomxV45o4ngewZg7a7VRndqzge/Zg0rSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abab1CZuxcKy+DapnCpunORc6bMArilijzvxcmEv4DkjAaoFLN2IzzaKG9NkYn5icbEwuU23GabS/OPctUU7a0e6X3V9wuanTJMRYY6ngKP5TjO9XRHVA0o5U4UPcS8BJ5AvNFXCMKRTd2kyZti10DySfI08nVa7IcjLWOAZjGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cz1p9C04; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1D49640E01D6;
	Wed, 27 Nov 2024 07:58:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CfYpScBxOcRs; Wed, 27 Nov 2024 07:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732694326; bh=im+StteL0walDEw+HJ2ysBCjd+H+8Az7ZF6UhoPbYq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cz1p9C04M5VnEcZL2auXIhLu7WIZ0ywfapGrJGTKMEyLEQP4AnN+D5npiHAyttgqM
	 gNd8osuCdO3YrNb9N41cAKLS8tE7AmSEGbPsoWxhzWCQXneqhl/n4P9OOAJKlwvp/k
	 cMCWyKLn5rORIg7V/AzwRgviHF8gmbCCrM06h/wAZfoyesari3/Ygg7yQ5dBpUPySu
	 2GJoK3F6eaKe3u1TKYL2rYzFaGzCkzW5A1uy4TcUNChDLbF3UMwc5J/RyUpYXlxTyl
	 HnR1u1UD7UAZbFzHMQcvXj/avQgoIZVHaUluejm4iKRX6IGy5jLzGMJ5cwbjeWOFM4
	 KNSECS1q5BN1jCzJ+Jxblr8K6nFGx688X2L732ng3jL0hv8C4xHDxhCfTukA+7Bb8W
	 EowCm9mVqQOSIBzkXbiOBmUEaQCGYUqoaVvAx36Aeou0tuVomvyKVW7U4UtP9BeaBK
	 HM4A2vPZzNXnTp5OT0qDOWosMHEc3zNS+qwxWUJIzkrn2onglpkKjHp3ehGTzohR3m
	 Tvk69d4nqvgVRSA+wZF+m47hKYS+kuobbs1LKWy+pu0xGjAank9l07NOmBNDrH/yIJ
	 WgCr9C8QEWOAUKIYBFjS4w9E3earPFgKGCWwEKV7MQ4Z00GWMwznMZsSYPgRGFabOX
	 Lg4ulo1ihyp2XMloA9cxPt6Q=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5113E40E0169;
	Wed, 27 Nov 2024 07:58:31 +0000 (UTC)
Date: Wed, 27 Nov 2024 08:58:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Message-ID: <20241127075825.GDZ0bRIf0bWrtzYDSK@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
 <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
 <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>
 <20241127065510.GBZ0bCTl8hptbdph2p@fat_crate.local>
 <a76d9b6c-5578-4384-970d-2642bff3a268@zytor.com>
 <20241127071008.GCZ0bF0EGespFhxwlP@fat_crate.local>
 <43e47da0-1257-4e68-9669-8e3d4915fa57@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <43e47da0-1257-4e68-9669-8e3d4915fa57@zytor.com>

On Tue, Nov 26, 2024 at 11:32:13PM -0800, Xin Li wrote:
> It's self-contained. 

It better be. Each patch needs to build and boot on its own.

> Another approach is to send cleanup patches in a separate preparation patch
> set.

Not in this case. The next patch shows *why* you're doing the cleanup so it
makes sense for them going together.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

