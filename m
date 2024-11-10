Return-Path: <kvm+bounces-31364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7D19C31E3
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 13:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAB0D281014
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 12:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DA015697A;
	Sun, 10 Nov 2024 12:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VfdD7tcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B7156641;
	Sun, 10 Nov 2024 12:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731240787; cv=none; b=qxO3RPtzmS95remoypJRk/BR2Id2ivul7WIfHuNg94VEIKr29T2h/edH2rwbegGjqWT/uxVB4y6RrmfqAY6aCa7M6NxzYxhxF5TFtf2FgnvDPWoxCvHbz44tNaFH0Xs6Bb7idk3gClBQhPMMzLctqmbk0yYcHpyiAwzm37fZDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731240787; c=relaxed/simple;
	bh=nOO1dgvobiM+f4GCJ6I9QkKZqASoAXsi9zs7D2PUhvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeXsOmjlN/WHcP6Oag+HY7IrR/dkJJ0RasBnEdMIPUfZcnQo6F9oZgecYOHpU+iKWXOfiAFMEBXYco+VWu/8HfIxf20QqOiGgBqpM5XWzgc3wQ3k/4rwBcXGTCs5RLZjIc0PU3GGNpT3HzolIzNWy8VYEtkip+sBZ8N8+H9n7t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VfdD7tcf; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 008ED40E0169;
	Sun, 10 Nov 2024 12:12:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p_LATjndv3US; Sun, 10 Nov 2024 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731240771; bh=J5rfGgOgZejdW5ZtDNskobOn6mfblcYV3LEka+BKC7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VfdD7tcfLbypMESwthzvbEXpuM6LFGMKqyZD+IO8Dso/VPZ3xg6i4lPbMLv3j8RXI
	 C6HsrLei4x4XLnew70jPB0oGYJ9xilm5l5FOY/+6k0ZKCn4y0vaHvFDycRzcQ83DoZ
	 xC1xhfBiTDxZc0WUIk7BV2NqH49wC6/pQAM9den/RvX2tjEqZgR3DaFsAld1HEmIyX
	 bx/6vBTxo6rYvA/GCsvVUCbfe9uO2LNn2OhM84YvlACprw5RNKtdJY0qKnekmqyF0V
	 o7FLFUjv5BL3R3VPGpopQH1lbfK/XxGhHjtLKX1/sciJVSmecnzwA/6ooyNy/A6cKz
	 IP1u73XWFBiPPyvRSm3GPMpdOi/N4HIwxkqAwtbUBeTNmK5cLlw9wI5sfFbL7VoEw5
	 iw8DPdQzGdoqwwUN1Xiv17revcUa754lzgCy3AyFzdtvJZuvsN8Nxp0PFyKnFR/GQl
	 fM2Ns1VWADZ/esw5tZMHJs3VjTzGInRLAIFkh59+HtG4lnEWh3w1bDyd6yzAyHpyLn
	 m7a7zfnstEidwSWFe+uAE3jp9SoihCOO8EVpDsV5VlzfG1E5op2yu98IInoFHMbLqL
	 tSVXJso73qBpBtf1R0H2XW/8pYIOnrkrTEeuvf7bs/2HH877xEdjN1GHZaxp+U3jW/
	 PdCbWfjXf/hysTpa6NRFySbM=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A6A9A40E015F;
	Sun, 10 Nov 2024 12:12:30 +0000 (UTC)
Date: Sun, 10 Nov 2024 13:12:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [sos-linux-ext-patches] [RFC 05/14] x86/apic: Initialize APIC ID
 for Secure AVIC
Message-ID: <20241110121221.GAZzCjJU1AUfV8vR3Q@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
 <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
 <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>

On Sun, Nov 10, 2024 at 09:25:34AM +0530, Neeraj Upadhyay wrote:
> Given that in step 3, hv uses "apic_id" (provided by guest) to find the
> corresponding vCPU information, "apic_id" and "hv_apic_id" need to match.
> Mismatch is not considered as a fatal event for guest (snp_abort() is not
> triggered) and a warning is raise,

What is it considered then and why does the warning even exist?

What can anyone do about it?

If you don't kill the guest, what should the guest owner do if she sees that
warning?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

