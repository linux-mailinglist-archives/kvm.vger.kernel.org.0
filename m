Return-Path: <kvm+bounces-40852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F97EA5E43A
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 20:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 710D3189B317
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 19:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A3C257458;
	Wed, 12 Mar 2025 19:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ENrH6X+I"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29A2D600;
	Wed, 12 Mar 2025 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741807066; cv=none; b=OvpX8bLzJ2tsAt8r9sOXrLXV9be27IwJA4rKhc3u+LZ72Zb4zTR6CKmi10b9eYriRZfCyCg8EjKwQH1+framdOgM2fR3nk6kwkPCIGtfnmsTig0cJ7DKnpi59jHkuz7ASPxIe/13dDsDxcGScDrenvmsjk3exjGIeGPkyGieEuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741807066; c=relaxed/simple;
	bh=WEKJAekWPjfqo3lfv1Dyzf0uWosAD0YT/LiQziRSKgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUoewcnncBRn1UYlJbdgV4eP7XgTnbW+Iqi6L6C4MpRpAHal2s2td6z+M2I04cQSyG0iXCVTk9otoREnWnj+OqMbm4kEeaHo8v01xGbdNonT5iM3ZulDlDzFiYzA4oR+aLYKAj6lKXgDoU4OCV9pAA5otYBo+TZsgRIp0S0A24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ENrH6X+I; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E28AC40E022F;
	Wed, 12 Mar 2025 19:17:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jBeu_8bNW2Nt; Wed, 12 Mar 2025 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741807056; bh=aeg6Jv9b/RYuP9TlI11mhTNvcd7oqMuQcLDmmeS7GDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ENrH6X+IquT7fjOKeplCrFfUc6fiGC10ZAEfbb8HL4xvBWYRDxUx0srOLlSZKt9kF
	 Ctp9igS8sEeKy8TMgiVZLIwI6Kg6FAfiZLZAs7xLU98RLDCbVgSzmBu9e/ZtCOMXv+
	 nldHxALGSHc9RWjZG9GKf50PX3FogEu2hlBdqfJf4YRQEUOBDFVl9k/WuRK6SO4Nxe
	 rESi3jiBTHgtn56wCTBXz8sN++FubqLn+vmyHx8gI0gyLbgr0cuNxGTZiO8ETafo6q
	 eyUS6gKdColziuFVCm2mCwGAwA97+kNCPKLEfB3jG+gAQVicnr693ioa1ZFatGhaGl
	 rIe0cKmxSBaZQ8cnpFGidsX6F9+zDHqZqipeTkmTGEKfv6FK+doIaKl7w8LCuEjQ7g
	 9XjopUA8VscpGE6D18diewnSeyVfW3yl88Ztsm5e/Fb7NDfn3azcDEQumAFpAGsAFb
	 dxvlz4m3ZnWYv6arW2pZH8wRTZBCvfeEZ3OofPzaTGFP0g7xK7Y8yniz6NlVIV8NY8
	 tmXHrYixVnNgWqU4Zxqx90gje78hCrHclrASrSuE4JEpRjPJ6SRbPRY0yKSCGvEyga
	 5ElFVfWK1u3SrWrrqmaGB+HVgN6ieWjts0OsDy8qZJ/aYwyMmxXdb1qyCubU7wW3hX
	 PIZdRYmMgbw5YBgspaYIUdjw=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 593A840E0219;
	Wed, 12 Mar 2025 19:17:24 +0000 (UTC)
Date: Wed, 12 Mar 2025 20:17:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250312191717.GGZ9Hdvbi_kRZYaaVE@fat_crate.local>
References: <20250303150557.171528-1-derkling@google.com>
 <20250311120340.GFZ9AmnAcZg-4pXOBv@fat_crate.local>
 <Z9A8djMzajTAOawM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z9A8djMzajTAOawM@google.com>

On Tue, Mar 11, 2025 at 01:36:54PM +0000, Brendan Jackman wrote:
> This seems like a good idea to me, assuming we want ASI in the code
> eventually it seems worthwhile to make visible the places where we
> know we'll want to update the code when we get it in.
> 
> In RFCv2 this would be static_asi_enabled() [1] - I think in the
> current implementation it would be fine to use it directly, but in
> general we do need to be aware of initializion order.

Right, I'd suggest you whack that thing and use cpu_feature_enabled()
directly. No need for the indirection.

And I see you're setting X86_FEATURE_ASI in asi_check_boottime_disable() - I'm
presuming that's early enough so that cpu_select_mitigations() in bugs.c can
see it so that srso_select_mitigation() can act accordingly...

> Of course I'm biased here, from my perspective having such mentions of
> ASI in the code is unambiguously useful. But if others perceived it as
> useless noise I would understand!

Yeah, well, it'll be a single feature check in srso_select_mitigation() with
a big-fat comment in it explaining why so I think that should be ok...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

