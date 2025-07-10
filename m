Return-Path: <kvm+bounces-52043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E4BB0056E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 16:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4913B0A0A
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 14:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7A8273D94;
	Thu, 10 Jul 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GM0qSzrP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C92027056F;
	Thu, 10 Jul 2025 14:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752158341; cv=none; b=MB/TCziAjsgCh4TPtZ8Oqte+ClGlcfdq3CmLYF8WayfN7O85ibgt1Etx5gy8fP73KsALAp/Tt9bbfl9o3q2+0cXL9Y/F5d0BmA6gRv0PWGKLticNZ2LKunT/2BrSce7pmlsZyufZqq7lFKFwwks3Y93V93UB01Vfkoe6GEPVIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752158341; c=relaxed/simple;
	bh=FD8hVarMca4aHYDMf0qBmS7TfITzJMau4Ayre3VV148=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhvFIrPvKvBlM+1tKwe0Qz/459Tf7Tt9AvlDUDTQmlr7GdBs0BMUruL3n4wrqbyYBWPaMbvMoz+g2u89OULKsZ5R4v1itr/j9R62q7X8n6GOiVjK7NHPaYFUOtZNta1F+l3PbGdBD/JhtOZAZG1W3YM1idj4Ozc7+TK1ZZxCmPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GM0qSzrP; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 99D8240E0218;
	Thu, 10 Jul 2025 14:38:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id c-rCGHqZO35y; Thu, 10 Jul 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1752158333; bh=FhbZcY5GA1HryF1g3erDNl7FlLcO1gA2VNO+aaalq6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GM0qSzrPaqKMRGUThyEc5iqYKjDRCOGwtj59bGXyntk+nyyjS58AEr3xAIG3xZXGG
	 HYq2d8ZQ/EW6IRSQ7bgaKAPLFaOHftE47UnyR4o/8D3QpsGCGh2TS2aX+f3PX9sY2r
	 a7NivCjvxazIwOC0xwqDyJwEEmW9KRfVeOSkHgRCLvLXN/U2rpIFNFMM0l6CBaSkR6
	 j4KxWrvCzWjWgaOtwZh1ClkHMHvIeM1/IARSorOtfBa7fhkIR07nvOwnMX87Lm8V0r
	 csexnEvrrMed21BnEC6NnhRaHT5vW0lAjJMl9BjjBgHnT667n6oCQxOYRwhwE3Uu5T
	 soTNNe19PMSNBeebPOToRn0taFHJBnooRFQh9FkglzmW727S0jVhL3pl1ZMoCVF0Lp
	 miD6Qrh2dCWX5Tu5+96NY9LvZCP9g2EIw9w+mBIBEGJGAf0ochXube1cyaMSuQycBG
	 iL7kXQBPO0g5D428rUz6VtXxJPOEW46vL8nPWI36OE1V8oksW4qZNbhpsdRTgqqZwQ
	 NwZ29hB31MzhX/dDBlp8z97/CQKrQoDBkWDjKrKcZXNX30ZqJ6q8gOxcirqwJIoRj+
	 ssT5CgT0HpaRbAFP7xa5gxsqaDxWZtBZJ5Rvcn+OKDBcSxD4GNn/QVQdTW+YYSmebU
	 TNYYlFAoFk2UH3AnGMjZJ1qk=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B41EA40E00DE;
	Thu, 10 Jul 2025 14:38:31 +0000 (UTC)
Date: Thu, 10 Jul 2025 16:38:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Kevin Loughlin <kevinloughlin@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Mingwei Zhang <mizhang@google.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <20250710143826.GBaG_QYo-9k2G7fvUG@fat_crate.local>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
 <aG_GlsJWRU0fVxt4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aG_GlsJWRU0fVxt4@google.com>

On Thu, Jul 10, 2025 at 06:56:38AM -0700, Sean Christopherson wrote:
> Yeah, AFAIK, no reason other than consistency.  GPL it.

Done. Tag x86_core_for_kvm on tip.

It should appear on the mirrors soon, I hope.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

