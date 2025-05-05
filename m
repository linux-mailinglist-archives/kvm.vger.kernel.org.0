Return-Path: <kvm+bounces-45419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A063AA977B
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44576188807F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 15:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B550D25DD07;
	Mon,  5 May 2025 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="XJXPDxDN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1763324EAAF;
	Mon,  5 May 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746458767; cv=none; b=T15YaGR/ze0NrUrOP+nAk7k0GXN4iADFVV/bxjc/eE1cG6eW88gsw7ccJOzdaKTlqxUVHg/ksGontsetClbsZh+yCduAiH+SURN1sn2AlwAah37ukoq+EQ1t9Z4mhXDfLc4hfhYVMjquK89Xe05FB5kpbw8P4sGQmrpyaiRlnJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746458767; c=relaxed/simple;
	bh=UOI1l9hXayxU7heQlHejQDTdK48z/ikCPJtKU8eW2Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrfZx6qUjQqyP5MlBdhVqMjkjvg6augme/y6ZmKtFAuu6iJXMg3O032cX8ohrpvnMJwL5KPBYq9p0t8or7l5ntBdo00IusUWWrvIzTAH+eduMbUzMdRGQLlAnQXtLjv0hO4X98EoJHQHF99i8XSIBmNuFVRAacoKGQ5RdUvUS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=XJXPDxDN; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 12A9B40E0222;
	Mon,  5 May 2025 15:25:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CTV22dvS23vv; Mon,  5 May 2025 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746458752; bh=+kOANE/cLZ/tF/AlN+hQkP75TG40P8eKkj9SOzjdBZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJXPDxDNLgbs9J094UB1VoMYWWfWifTmV11cLfdscQagTWX2wtgzs2ZLdq24tDozj
	 /F5jgqSiv6vD5c+U2q3oUPgHW5BzHhoW+hvjES9O6byFdm+AJKbpbq1oQWsgwI633W
	 3XCrvH+urBOcFd9SzOWf4K+oitussszM8FixNeLKm08TiG4uUWEdtlzsimORGK5gsB
	 P3OU4Szx2T5o/VhPTeyq61c7UkVmCmD4rXsMstIQqjQ5JXObriRZh/KkKfDQcMQUEj
	 3gpLX1o0JfRGrKcQjJmovofCnE5h757QfTRw3fSA66j+/C/VRVYQJetEZlFlnbjLOK
	 tZm5vPFIlEWK7sMOZiD0471bPDvOX70tCwwCH5XYLeNSsCAGdvNRYylVRfqCxLyKLT
	 1s+jPcpPnNEKTgLJF9qGkRfJ77tSQbRWX5Mt2GZU6zYYYMQfWeXFnx9xYFlYXB1anX
	 U7s4+A8XGJgYFJvi1RmF+bWxwM++Tusa0g1d+ohpX5XnXpbApbv9rjIvam7Fwhrf6F
	 xdYzOFVGsIpZEeq/PAWMxJ6g8bMcOEpJJUeUPusSSJehV22MsH4vvlHugMhnTWLJxi
	 eE03tP/DRDVDPIed38HB0MWqOVUU7kFPjjoE834CLtk8w+yI1+e3gqeGPifkCUjSWc
	 f3LWLF+CKMpFosY3KuidQHbE=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 09B8140E0196;
	Mon,  5 May 2025 15:25:38 +0000 (UTC)
Date: Mon, 5 May 2025 17:25:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>,
	Michael Larabel <Michael@michaellarabel.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Message-ID: <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
References: <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aBOnzNCngyS_pQIW@google.com>

On Thu, May 01, 2025 at 09:56:44AM -0700, Sean Christopherson wrote:
> Heh, I considered that, and even tried it this morning because I thought it wouldn't
> be as tricky as I first thought, but turns out, yeah, it's tricky.  The complication
> is that KVM needs to ensure BP_SPEC_REDUCE=1 on all CPUs before any VM is created.
> 
> I thought it wouldn't be _that_ tricky once I realized the 1=>0 case doesn't require
> ordering, e.g. running host code while other CPUs have BP_SPEC_REDUCE=1 is totally
> fine, KVM just needs to ensure no guest code is executed with BP_SPEC_REDUCE=0.
> But guarding against all the possible edge cases is comically difficult.
> 
> For giggles, I did get it working, but it's a rather absurd amount of complexity

Thanks for taking the time to explain - that's, well, funky. :-\

Btw, in talking about this, David had this other idea which sounds
interesting:

How about we do a per-CPU var which holds down whether BP_SPEC_REDUCE is
enabled on the CPU?

It'll toggle the MSR bit before VMRUN on the CPU when num VMs goes 0=>1. This
way you avoid the IPIs and you set the bit on time.

You'd still need to do an IPI on VMEXIT when VM count does 1=>0 but that's
easy.

Dunno, there probably already is a per-CPU setting in KVM so you could add
that to it...

Anyway, something along those lines...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

