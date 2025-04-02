Return-Path: <kvm+bounces-42505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B9EA7956C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C51C1886694
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B60A1DDA18;
	Wed,  2 Apr 2025 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jH+am6jM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7E5C96;
	Wed,  2 Apr 2025 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743619738; cv=none; b=YQpHy11e65QzF/ql2DwZyl/dxiUtFZbjRVAi3KyRQGtqiin6epXn6QQ9blGSgnUB8XiWvZB1IdoocPx3XRZXSSrlAhLnxYbynEsVTYhVRRV6M3jEbEZSGn0pjnuxhngixHP0BRHLJqKq8dMcECbA6jO3tRWCG7wphDZ6IlC0oQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743619738; c=relaxed/simple;
	bh=BN8pPeaB18+ZGS9verxlJtdxTpoi9iF6l/UuLF+vi5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjwzPoS1vRjXA59GsnN9vm3gCvIDEWPqY8Czk0AhGaLqEOXQeXW4fCnCs2O2cIR+tdcQfYW29C3Qv6dnlquo8EhgUobIldK2Zwgzy4Qgw73oQiOeT8TD5+cd25ZHAg4lyfqeGBaVKaFgiUP3cngmnfOZehBoRPKdz2iMQG6mT/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jH+am6jM; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4832940E021E;
	Wed,  2 Apr 2025 18:48:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BlN6ygf2ytRz; Wed,  2 Apr 2025 18:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1743619731; bh=ZdCGke78EY8DavBNUh6kV+s+XrFkLl05AHZqQYloNCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jH+am6jMo/hklHNdoMkyaC5WM5A87ZpJT9kNiDGkXPjdkIB4c3CghA881NpAbfVeO
	 y+1MN+c2Cq6+RjOOapDYIbUFWvKE6CucvxJoh9BOuXOOjlc5CEUpVhbdWjz8xHyHfN
	 /iIUIR6Gc60aZsebdxCh9Sdl2de/+gu+L+E8wbb6XXB9BCpihJQQG/ygTBi7d8mha1
	 PiVGswv7s4zzOH6BQPZ2qb5Z5kFD/LWWTT/UYfsFgdbPvn/g/96h1R3H+jXAYsHMdi
	 YDEKXptaHLxk3spBlnY/IO06DbeCH1+k9w6vAoXWdhQreVc5kWyfJXc3gZD/0uLFBu
	 3wxJMHBMvGHG7wWOz4+OK/NbMozQCY7T2unVg4Kxw4TSLMFLbQoeMuvzaNhIiv5aYJ
	 s/i3h/smjCCyutCrt9iO0f6r6QApH1HKFTQ1hHT2h7yT1kxkN5R4t1D/9rQTDPNYoV
	 7AAIEXMrHopvAMQG+pGLfsM05BCJbY8QVRi2c9BwFLDcCeIO5oZB9lJxCM0ZKn0/PZ
	 i9WHMY1uFnb6VeudE1NJQmR7ywiK+mtI57RAhfPNim/fBzMfULoMyBJhsGsd0acr0F
	 BwsRe62AhnKXKH/8QpqVw5LV+S4hVLfeh4QC2A2S2cY4DSIE+moSSzXJmdmZwskDaz
	 u+T7Zpv0LPYcGxCVVBnPVMXk=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B0CEF40E0196;
	Wed,  2 Apr 2025 18:48:26 +0000 (UTC)
Date: Wed, 2 Apr 2025 20:48:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Message-ID: <20250402184820.GJZ-2GdG-CWRxEwTmy@fat_crate.local>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
 <20250402182928.GAZ-2CCBR2BAgpwVLf@fat_crate.local>
 <qeg7tr5jvmyyxvftl4k4qsa4hxga7hzvqcs2xbhfpeun5yhn3r@ua6pawrgxix5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <qeg7tr5jvmyyxvftl4k4qsa4hxga7hzvqcs2xbhfpeun5yhn3r@ua6pawrgxix5>

On Wed, Apr 02, 2025 at 11:44:15AM -0700, Josh Poimboeuf wrote:
> It helps it stand out more? :-)

Please don't.

Someone thought that it is a good idea to start using that // ugliness all of
a sudden.

So we decided we should limit it in tip:

Documentation/process/maintainer-tip.rst

The paragrapn that starts with "Use C++ style, tail comments when documenting
..."

> I was thinking the calling interface is a bit nonstandard.  But actually
> it's fine to call from C as those registers are already caller-saved
> anyway.  So yeah, let's drop the '__'.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

