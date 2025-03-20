Return-Path: <kvm+bounces-41566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEBFA6A843
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A07748A40D9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B1E224AF2;
	Thu, 20 Mar 2025 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Nzlx+CG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F81224228;
	Thu, 20 Mar 2025 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480252; cv=none; b=ZbTOuTqgOid3fYMatCM4mQKHQe5GYjTvQIzxk+49E7GFqNvoEl7seq4oqoqoy8DULWmG+HXwNgHhZsXRCLLrDuyu/BhhtTnaq1CdVKbcpOE6b87rRnc/ghNKKTejHJ9mex4sDPhn+zWJMpUeuZUnwWlFy2ktWhgvLDea3bOVocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480252; c=relaxed/simple;
	bh=FVcikiI2lacP9JSxWJbrpt9jBAjCrBGlViup+ZG8GzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXWgSWEcHqLCiSWPPjqAu9mhycdMNYE9zfC+cQ7dKqRnm3teerm+5TKrBc3r+SGQzuwS7oVzN2hrmh6o+bgc+7nuvMlNkbGxQIBiuJSxKKuCSSBBqsoFwkcAy7MQ0XpbdSQzWW7GBubd6MVs/OUlfMnvgjrTp/Ji/KzDlkcXOBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Nzlx+CG2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DD30540E01AC;
	Thu, 20 Mar 2025 14:17:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9e4An085VCGt; Thu, 20 Mar 2025 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742480243; bh=R4nwaOnRrRfOppIp7hpeF6UCm7njwKvTCIA2w/B2up4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nzlx+CG24LcU6YmUASZx8vBP+huyJCCy9K3TJO90BhBbOAumoMZJbF6bfArS0nfQy
	 x7M8d3pqjxaTeC6yYkk04NpTPJKRwK7bG24/etXUoRggLbEXFJi5DMsPrYzCF9ZdTl
	 xkh+KZNECNaBiWD4isdQbNuRNd0viNaXo3UmhY6vxNs5c8H16LT5pPCWiA0wnnPJ5n
	 HCn5ksoTWBYSgYR0uA2Ok1h5iofA/xmuzW6ZVfXAuRnxgko4LGUj5Pv6lgMBwTmEzZ
	 FdRqdDJCh2hTPMfvhpdcHLqNhL6HwIETLmzEKrRcNLSlmxJrZt/f/RePP2WFIZj6GM
	 7uTGdTkP5Oehk1G0Jb/D2C9gTCLERHB1uWaD+S+FrcrqvRXkYolMZU21mYG1l7kDXE
	 hlytzq/ff3l35FBuqcwV/e5hjEO8TF1iAKdwXQwobxF1KzusrtYxnsXLQTLLMhJAu0
	 134rLbHIE8RKEhN4sXd0f+jitSvWNkF5kYlcOBT0Q3nhcvurB4ffOsLCvbelZNZmeB
	 0brJlOzj/OD7pIB4qXJkqmnWgUjBl4uSmMzUQGZ5EeHSKpcgKmH/iuu+8OdDRdiJt/
	 G1XeX5msuafOlAzXbAUnAti6dbCuvSQYcgyAAmtolS+1YqT11dRbNkoXPOxploHtJq
	 toHgg5KGTvYhXyw6mJxGlGkY=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D58FD40E0213;
	Thu, 20 Mar 2025 14:17:12 +0000 (UTC)
Date: Thu, 20 Mar 2025 15:17:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH 0/5] Provide SEV-ES/SEV-SNP support for decrypting the
 VMSA
Message-ID: <20250320141707.GBZ9wjY42cY7_dQ4ql@fat_crate.local>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1742477213.git.thomas.lendacky@amd.com>

On Thu, Mar 20, 2025 at 08:26:48AM -0500, Tom Lendacky wrote:
> This series adds support for decrypting an SEV-ES/SEV-SNP VMSA in
> dump_vmcb() when the guest policy allows debugging.

I would really really love to have that so

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

