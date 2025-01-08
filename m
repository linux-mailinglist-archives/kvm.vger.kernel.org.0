Return-Path: <kvm+bounces-34812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C3EA0640D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2064A1678E6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F0220103D;
	Wed,  8 Jan 2025 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BwPiIO4C"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47B71F4E32;
	Wed,  8 Jan 2025 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360098; cv=none; b=lYZP9chjnn41VK/eKKI1sZsJ7I1SApJaBrdKgjNJQTmAbjJOm84HfgXoqSmc8+HsDw397q/3TOvqwhd5hnsFkVoZHyjoIauZRQYSZZr7Ntfk3R0TNzgQBxyj0M0+pfZcijznroy6YL8reKHvQKq2kX9MeivsdEgAXBRo1xVBEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360098; c=relaxed/simple;
	bh=1piCdTXARUyAQZTugfblzOdBQAiS14dIYXHBFb20FgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNr09n9w4hArpYivoK2VURaAUahaevtTYLun76F++aQbyQ777WQsRktpkZS28YzLDJzikAvXK5IaNDPjvig3tHyRJ0WaNlIR7BgQZhWAYo24OY06UXzeDXMEyylDbfkEiqiEhnZXwmQ+49Jscyr3uh/bDrKwsw7K7cS4SDXtFZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BwPiIO4C; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A64C940E0286;
	Wed,  8 Jan 2025 18:14:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7DuWarOuj-vD; Wed,  8 Jan 2025 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736360089; bh=xNYiKlwa3kj8BpqIAS4B0qWDplcNM2XhSUe24FD5yJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BwPiIO4CGdFN140zwNgH04L3L+gE7b2N2ctJMOA7tPXp+TjRxO4N92fgpRRfjrxqU
	 ozl1qcF+VggHBELxtozFjRkcBTDbbh4RNgVSCGX2FGPS8JrYLC/cXErFpob6HO0oNy
	 Dx1/I+NC4BNV3RGIHWanF3gSQ8D+cgM36U0akHSFIGj2uKdc8TNqHp53uChLf9wJRW
	 kNMSaLqOYVMs61s+C50uFoc6HqKjMNmaTuu3ZnK9qOcYcCMQusS303glYLXY2vHTk8
	 wHSp5FUKZZ1JfQLAn6NYhnM9d/kFGFoVw8Kva4Lk+kNcMIrhT6amEkY45+A8zr7lpI
	 xXrTBqZBGJB8WKDHegyLduaabsZmj3cw3ipsmRXuVFwdZVW09dGhPLZN8TwHgDgNhd
	 TnCuHLW5PbS6LsxuHJyeumuH0Nv9P298xNRjptlNzPuMrWLH+6IVmz24HpHUQfqWni
	 nif5lf3UiZWiEY1GYRTTF0YV0WXefmmLLm6MP30jKUMo/4FQQe0Hq6i+9RhNfzyJlI
	 E3PpMKsn2Pdj6i+VQhMIUogNFO29neGuCXKAHShDpOv7dx+EHmivCriF6rvs0fq1/O
	 OT/Eptcj/W8HtUnvvjasH6/Qq35q/G0TLxPRVtTYxdYWuULespAf4Zrpv3NOQVzjpX
	 gMS65JQ5bG65pOXjJljRHKeE=
Received: from zn.tnic (p200300ea971f938F329C23FFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CB02A40E01F9;
	Wed,  8 Jan 2025 18:14:40 +0000 (UTC)
Date: Wed, 8 Jan 2025 19:14:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z36zWVBOiBF4g-mW@google.com>

On Wed, Jan 08, 2025 at 09:18:17AM -0800, Sean Christopherson wrote:
> then my vote is to go with the user_return approach.  It's unfortunate that
> restoring full speculation may be delayed until a CPU exits to userspace or KVM
> is unloaded, but given that enable_virt_at_load is enabled by default, in practice
> it's likely still far better than effectively always running the host with reduced
> speculation.

I guess. Kaplan just said something to that effect so I guess we can start
with that and then see who complains and address it if she cries loud enough.
:-P

> No?  svm_vcpu_load() emits IBPB when switching VMCBs, i.e. when switching between

Bah, nevermind. I got confused by our own whitepaper. /facepalm.

So here's the deal:

The machine has SRSO_USER_KERNEL_NO=1. Which means, you don't need safe-RET.
So we fallback to ibpb-on-vmexit.

Now, if the machine sports BpSpecReduce, we do that and that covers all the
vectors. Otherwise, IBPB-on-VMEXIT it is.

The VM/VM attack vector the paper is talking about and having to IBPB is for
the Spectre v2 side of things. Not SRSO.

Yeah, lemme document that while it is fresh in my head. This is exactly why
I wanted Josh to start mitigation documentation - exactly for such nasties.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

