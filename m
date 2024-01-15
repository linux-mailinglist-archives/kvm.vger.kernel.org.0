Return-Path: <kvm+bounces-6209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F2982D593
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC543281DAA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7447C2D2;
	Mon, 15 Jan 2024 09:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AJiodlRV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8A7C123;
	Mon, 15 Jan 2024 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AB29140E016C;
	Mon, 15 Jan 2024 09:10:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TTazglQcC3xF; Mon, 15 Jan 2024 09:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705309828; bh=gJlM2Kv3+3MOq/kI/Vq1T5vWHhg6n3QBRVvBSciq/WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AJiodlRVfuq8IL4OHlBKxL2GoRaWKRVgTApjGmeEVcOopb1jey77jYuYcnHjEG9hs
	 9Y8JDPi12IdkJPFc+u7c3MyF3w7JwGPoC/KXy/hBMFRXJ00bxOISgsBXHUajYBBLvF
	 YvT7l8r/nlQJ2LgbjsCMBpM8SmuW4PQaKpCIayRZLnL++k5HEBKilYQicld0Hj/gNB
	 4loDnAwYb+gG0CL7YDj8ZQza5lRVHGc2gS0z6fBJJ06T0A1Yz2yC8TUZ3k8nZNorc/
	 TEDMrEy6lvqrCL3GLTa9UBnnSKggfQHTvuT3bHIvPiagueLZZXxsQRKd168I2jZwXo
	 CrUnOK96Qir8twcfZB06NaDJo6R4tELtpgqGbp3Gc3+NzObAC2Pqig+mTcLvNnvtni
	 kxZEiAZ1fKxZYf3EDox8h8rzVKhv117TmBbrs0RJ6XXbhDVelisPjjr8tVBNnogcaK
	 5rpcvQ4Fay4l29JWGGPtemJ4xPUmk9zF2GHN2/8wsvDel0Akf6mNo+YR32A9fm2wyn
	 AV1XWM13uhGnhx37NHy8a9rP7EV68Xl8Cb/vJTH9jABr1FHEbiaYv/OeKN0X/afP5e
	 IoDyKqdaQQ+vq0/cKkkqoegLmw1PCWjliSOOTlBDWh2KOqkmjDpdOy+OlU96hBOgL6
	 UfeeTNaMV22VtaRAJThDiia4=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A643940E01A9;
	Mon, 15 Jan 2024 09:09:49 +0000 (UTC)
Date: Mon, 15 Jan 2024 10:09:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240115090948.GBZaT2XKw00PokD-WJ@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>

On Fri, Jan 12, 2024 at 12:00:01PM -0800, Dave Hansen wrote:
> I thought we agreed long ago to just demote the whole direct map to 4k
> on kernels that might need to act as SEV-SNP hosts.  That should be step
> one and this can be discussed as an optimization later.

Do we have a link to that agreement somewhere?

I'd like to read why we agreed. And looking at Mike's talk:
https://lwn.net/Articles/931406/ - what do we wanna do in general with
the direct map granularity?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

