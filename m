Return-Path: <kvm+bounces-55519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE1DB32180
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 19:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFA9FB22484
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 17:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F7428C85B;
	Fri, 22 Aug 2025 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JtC8Rvsr"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06825219313;
	Fri, 22 Aug 2025 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755883736; cv=none; b=kACgGXDwZh32u7Z6Ufr2msidB8ZYRPc2mKG7VA8woHAgh1YBbx/rmTZfxduMaul0u9nC6IkYfRoXIKGKXLGyD7kSflDPdjNcQ8/OIXohUWTDKUg3+OxQMRa0JXv3iuK1/Osaq+LfbdxPVFCrTR2zxcu5Pa3UgNBhQvYBOIaloIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755883736; c=relaxed/simple;
	bh=6kkTEJU2KoS3hItv8UxJLyTW6fWkgAxIh9+PZ3UZpeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLa8D6/b7blDdgxrEE4dPau9W7hG9qpV8kDD+RjdgAI83JFQLyF7iZRkIaVK9601f7byOyhI348aS/SN6qDMdHBKl8pJ0goi1iPzEejtCbJGVz67ZgWvZ7uNunqqVkOrZVE+o+SBT8whiFBG4LNCCuuNLRmslh6vaRH/ud5IS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JtC8Rvsr; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A33E340E00DD;
	Fri, 22 Aug 2025 17:28:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vGEtOENMZAre; Fri, 22 Aug 2025 17:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755883728; bh=m9nlcpGWpSmcOO7EK2gBfDgg34w/p8Vzv8g6LEEVeVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JtC8Rvsr8+qfEs1BE57IJs3CzLQUGAarOPpQFIPBWZR9qqED9tIDCxy07CTA6ay6w
	 Aifw8l5rh8S2u9XEmpaJ4J1fU4j+T72Bno8qoU6dxgE1tpiRXPpVF0toiAveWYAQZX
	 nmT0D9EqAoJCgZpzwEI8VkV9KzEvfnaEpT5J3yNiAXAr6cJj7j7GduoMgVzI31FRK6
	 PiwoIXEYsSZOpyrHniwKyct7P2egWZzN7bh1HkQPNEQ16cLdU2if1FcE+5iSWXV3La
	 z6kzGHxTucldi6WmT04TB5iqGQzdlkkUWeCc723RYAY5wkSamWZ5DIQicj794ofOtP
	 weBsnZx3vwJ8/jCMCo7B5DfYHs9JqcrzADALBzcdCnvzdEqrvutNDRGLrEoMDI3WAx
	 AUelRp/HJ6VghaV191P438bTFPyQz/6qWLdKMxkrbzAm3IUbEzbZUr1/Uc0SLkXEJm
	 hs/O+wiPzi4KlpSzdSi9u0PCdwY5BQgX84UdTJMuUoHsk4yP6nO/BdX5Tf6onriTFP
	 HUAzCDwsS4A1FPef2lC0pXZqbAtrcDnbb0/Hq18y/nKLZd9uZX6Y0+xa90xXkSzF2B
	 2WESxZ1LRMuBwymP4giWcouLV8saxbdwYTca7ehnccaIXEZHKdx14ntx59Y++xQKq6
	 X1qx5C72KSoVdYK4wYjrAAO8=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E57F440E0163;
	Fri, 22 Aug 2025 17:28:25 +0000 (UTC)
Date: Fri, 22 Aug 2025 19:28:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs
 for Secure AVIC
Message-ID: <20250822172820.GSaKiotPxNu-H9rYve@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-10-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-10-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:35PM +0530, Neeraj Upadhyay wrote:
> Subject: Re: [PATCH v9 09/18] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC

"vCPU"

> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Secure AVIC requires VGIF to be configured in VMSA. Configure

Please explain in one sentence here for the unenlightened among us what VGIF
is.

Also, I can't find anyhwere in the APM the requirement that SAVIC requires
VGIF. Do we need to document it?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

