Return-Path: <kvm+bounces-52234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74299B02C78
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 20:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63C6D7AF164
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 18:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AF328B3F6;
	Sat, 12 Jul 2025 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="X5XXcU2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E41F3B85;
	Sat, 12 Jul 2025 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752346035; cv=none; b=GydjaX5+OIS3+SNujm55N0ho+IzvJYUe9II6wmqmPwwiqGjNEZx51J3sEN2lKN+SIjCzc3sIZe1/DXPJvOB877hom6066VBc2/Qlz4YolUBM42c9UTb4bSpno6r/9t3buhfqFZ6rWz7vIGAZfZEuG1KOnyoT0DNOXZrkzmEglMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752346035; c=relaxed/simple;
	bh=vZHJd/EyhCeWVcS/kNi/tekdBeWGgTbd98m97HKj8rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLctZE2zRQZTbuFI4/JvxpboUdlitVhKtE7XOE6o6dFZ4LKXjxKBBsPnkHrHubS0KvqzijJBJTwTSue31AqYujjeeEFYz50IR3ySpmubvwufgR4Ey2RsYHVZH+It6mtBMw/BsHetsZJ+D78E7RvkIKPFYfKPvL114EijKJ4NfYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=X5XXcU2y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7EB1840E0198;
	Sat, 12 Jul 2025 18:47:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IiMW9QXRFUAO; Sat, 12 Jul 2025 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752346027; bh=rIKSthC2S+D7tehs9yM7s5VVdshVZuEZur+23cX4wP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X5XXcU2yj2sMeQ/UM0OtP7Gt4pZ5Vo0FurvDPZURWSwI4N7z9+y3zzU4JhOwISFyX
	 geBm4UHF0s+40pmmTLMl2RvEnL0vM9m6DN+N4DhQH8GDUKkhwr+u0UUV+vBH80MUpM
	 At04+ntGM1eZVXTLdLUeNqYYe5RIcXvTBWo/rNPSXRY00dTSbMmmh7u0F/xOlNxcaI
	 7ddZKPCREfoHNxqtSclCBnk4aglaHuznLIfNc0QC1HDVPMGi4fhQKSSQ6Ulk7Y+z2r
	 y9TmfZ2K535yDIf1i305HUQWeTUxvZXVQ6zqmnnFRBjRpJQd4C7zhI8iYYZIykDewR
	 SNXM7iHVvtMxmzlwsGV5td9pzrRxWa13IjUNsj6h5ACIAW1DWeiHD1uh4twt+epsNt
	 NTYWONHpCqZ1bl54zcp1iIQxjtWphK3eTrERh2A3NSYZ63zx8Lua7R/0gITyrPTskf
	 D8qgaWXCTdcUl7slDaz3j/5rxuCDYCWv7EXP2czFqTzWMA2gW1It13pNpaTVCu9h6x
	 /L7o2cF1xmIcVmGzeZL27juS+OgJaYLubPXDjFa3wC2fsh9QEZfd44arQlIq9wXvOW
	 yqZty8TTpDpCP9HJgZQMo2cVOMXLJWmtjOZ8NAvuA5EyP0U31StZQiSlkW7WOZnDNn
	 YX40LaZXe1LaiMXyMLP9SacA=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDAD740E00DC;
	Sat, 12 Jul 2025 18:46:45 +0000 (UTC)
Date: Sat, 12 Jul 2025 20:46:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for
 32bit/64bit access w/o type casting
Message-ID: <20250712184639.GFaHKtj_Clr_Oa3SgP@fat_crate.local>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
 <aG59lcEc3ZBq8aHZ@google.com>
 <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>
 <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
 <e8483f20-b8ee-4369-ad00-0154ff05d10c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e8483f20-b8ee-4369-ad00-0154ff05d10c@amd.com>

On Sat, Jul 12, 2025 at 10:38:08PM +0530, Neeraj Upadhyay wrote:
> It was more to imply like secure APIC-page rather than Secure-APIC page. I will change
> it to secure_avic_page or savic_apic_page, if one of these looks cleaner. Please suggest.

If the page belongs to the guest's secure AVIC machinery then it should be
called secure_avic_page to avoid confusion. Or at least have a comment above
it explaining what it is.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

