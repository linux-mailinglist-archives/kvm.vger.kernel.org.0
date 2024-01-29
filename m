Return-Path: <kvm+bounces-7388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F8984137C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A280928B5F9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E17348790;
	Mon, 29 Jan 2024 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="R61YC1vh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5876022;
	Mon, 29 Jan 2024 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556556; cv=none; b=cABHIAMkfBqjXHcZxlE04QJ4J4vrA/pj3qU1pPgNgXsVWRhwyFXDRzDC95clya9+EHZKb0ClzzYZft2WvrgRO5tSo/hjaourJxDU8biEOERuSMi3CHGY5E3uZnQvSbI/cgII3HT5wMzPTpm5780BaPuk3+8YvL2/sKAkETKyiq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556556; c=relaxed/simple;
	bh=VQQ3cJA1L0hatrI0mRr0aOpyfpRd+ae2raDJzQ4r4Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hn3crknw1APgQs1mSxwdqbj0oZq/q0d8AURaQjVv49PthIv+los4jKOcUw5crGCdQtmZuP8uMZNwb0iwHp6RWYfEkDhghdBamAZjkayx5xN5fXTT5b2R0GfUbpgSmLnU4l4yZ25kR2i/f3y7n0J+CqzPSMv9JHngko7t37sofaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=R61YC1vh; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 09DB240E00C5;
	Mon, 29 Jan 2024 19:29:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aHknbiBvH0yA; Mon, 29 Jan 2024 19:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706556544; bh=svaXdVUso9XIpSV+g65yFy2vYB9o70I/9oMzH+fLOv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R61YC1vhG4HxoGwH8d9NMiAqt/ypwcQvlKP7/NVPICMBvVV7t1AM5FG/fiLUAZe9f
	 rXTwSsUgMGD68KxLZxgNDccSBb2vRbjVIX8SYndLfknLagsvbX6/simSi66tVLOUfx
	 JOoDqACAYKB27snRlrOIbA02RaY003wIud6RAd1y9MZl5+uBZi/JWx0KSvEAjLPRxJ
	 bTLlLxYzX2WEgwS4q9lIA5kDrwgBlxWLx47JOTwGtXJn7Go2qyY9sfg8dGiJJpYm2a
	 UFKuQB8CP5F3q7Ge54sEqaqdNFaqPR34dxmroO1YIGiEL18/kqrE96bU3E/prCO0HN
	 JdlXpSx0kQdg3svTOtIElL688qRJ9lp3bJcvYc6o0tvFMBHvJHtgLAVp+nK1AZwDvL
	 F7G/vWMl9WfLyM7TkJKUbtAn6sBeqm4QApmgxwq0xwyblmpXpOyqYQUOHCp6O4//yG
	 0t0QDFFhTi6Uvg2L7rerfGTNAhM0dP5mZihtHDC3zaVrubgjsgXf4FntZGS//zhlBr
	 Bn4cO4vmOc0D/dH/QDwqsQYV2DAatN0swyETnk2BpP1Ctb5r0ZyEYakZ7ST2z13yRO
	 RdAAuyaqOO6eyOjtkZ5CYM/idgTNpPGpL4NCYNuOrCGDiyBQwzRJJayTjrUS+VH49O
	 l9U/vVKCVSs0caq7HcOL5KUI=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A636140E016C;
	Mon, 29 Jan 2024 19:28:26 +0000 (UTC)
Date: Mon, 29 Jan 2024 20:28:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Liam Merwick <liam.merwick@oracle.com>
Cc: Michael Roth <michael.roth@amd.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"jroedel@suse.de" <jroedel@suse.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"slp@redhat.com" <slp@redhat.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"tobin@ibm.com" <tobin@ibm.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kirill@shutemov.name" <kirill@shutemov.name>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"alpergun@google.com" <alpergun@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 10/25] x86/sev: Add helper functions for RMPUPDATE and
 PSMASH instruction
Message-ID: <20240129192820.GEZbf8VBsDhI0Be8y0@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-11-michael.roth@amd.com>
 <23cb85b1-4072-45a4-b7dd-9afd6ad20126@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <23cb85b1-4072-45a4-b7dd-9afd6ad20126@oracle.com>

On Mon, Jan 29, 2024 at 06:00:36PM +0000, Liam Merwick wrote:
> asid is typically a u32 (or at least unsigned) - is it better to avoid 
> potential conversion issues with an 'int'?

struct rmp_state.asid is already u32 but yeah, lemme fix that.

> Otherwise
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

