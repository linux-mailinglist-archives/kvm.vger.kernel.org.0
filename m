Return-Path: <kvm+bounces-6489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B2C8355AC
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 13:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 240641C20CF1
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E2637159;
	Sun, 21 Jan 2024 12:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HoXqq8RL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29E1EB37;
	Sun, 21 Jan 2024 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705840208; cv=none; b=Q9gCkq7OkU7mww2553BRrq6MCmgEaoMZLkt7lB0e1SxGlVKMcF0EgV5aBhNzBTG+RjCHH/3hbjYJ7OU5J7d+WZBe+sgXylyNL5gZTFsQzjAHmoDPS1z/ZrUM2BI71VnXEdn/Hv2euhG37FRIygiUKBAkUb9A5Ty4H/PCDhlkYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705840208; c=relaxed/simple;
	bh=ztkX7DRtmPZ9xFv88EQYh8GKYpQQYTtlDcny+ZecGMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qT8grWN6l6R7Yot+GNqqzv7GBTazY5MQy4yKzr6g3NRMphwUy98VVnyUdVVdrLVw+Dy2HUMEeU3MaCYW2YEtVd2zVvCr+NgOxPT7lHObpTQwFePhKzRWSNMkVmg3V0E0UQzH3S4BFUdIBrYI/TmHFGfWgCuuTFuvD9RgBjlaqkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HoXqq8RL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 258FA40E01B2;
	Sun, 21 Jan 2024 12:30:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ajngsX_v5-la; Sun, 21 Jan 2024 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705840201; bh=lJOxa1NCDjYe68V4/rORBTiQrTtE7y7uT1l5Klq2ts0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HoXqq8RLCkrmpO1QjbLu1QiCwSLvezQ5ioigMzvYr66LSize0qo3TpiqiL3Yn2Nmh
	 HC6JckuX70qENvSuyYR8ynjc+jc3rdWJUaCamJgQMsw427FJCNEKl3FualnU2PvdVH
	 yffKTLyLwQQh9694fcNi3HYSkuUUB0+QKxYAG1fToyzyAZZypqqvja562aJYk5HIu4
	 Pc79qQYcWZkrNeyEsSyMfj9v6Tz6w71IvHPaao5IBMVRqyuf7M/YadI910GrXWgvaf
	 6KS6s2sxb98gs638wTLulRLGl6WxkJZDEVSlJT2Rwl84d+0EG18EBWShkc00G+NRr/
	 ZBbnsB6y2TpRZMWVPTOTcccrHBENDFcQXegSCBsijmZ5QdO0krPWcARIBe1I/4Ecyk
	 UxFz7hnMgjqvlImjR4pDQgRplQ7gREMljXGRcMmzcdIL2Dc9+MeIPoAG6jdzrbzeis
	 zqtdBGy1inZ8R9eLSmVTczviJ1TqlYF84k4uwFhnknnmVT1srVdxPjf8z2ZDGrb6Yw
	 oWLDfB0TUkNXFMr/uqyWAx69H+1gKxH1SlAohCZkG0WG1qP18s1rev/U/HW5qLV9RC
	 YNoGWwIkXh3xKJxGtSxtzXMZmq5oxCn2V9bvdgJMBqMXtC8pkCwJJJp9X6klrUC8AX
	 hBNfZ6xIXOm+lBiCqr0HWBy0=
Received: from zn.tnic (pd953099d.dip0.t-ipconnect.de [217.83.9.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5303540E016C;
	Sun, 21 Jan 2024 12:29:25 +0000 (UTC)
Date: Sun, 21 Jan 2024 13:29:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com,
	"liam.merwick@oracle.com Brijesh Singh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 24/26] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Message-ID: <20240121122903.GNZa0OD21W0UxLmOAm@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-25-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-25-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:52AM -0600, Michael Roth wrote:
> +	/* Change the page state before accessing it */
> +	if (snp_reclaim_pages(__pa(data), 1, true)) {
> +		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
> +		return -EFAULT;
> +	}

This looks weird and it doesn't explain why this needs to happen.
SNP_PLATFORM_STATUS text doesn't explain either.

So, what's up?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

