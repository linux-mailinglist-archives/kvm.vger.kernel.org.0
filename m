Return-Path: <kvm+bounces-5878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 802B2828604
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 13:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF0BA1C23517
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 12:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E1D381D5;
	Tue,  9 Jan 2024 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e3uzqzD6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F28381C0;
	Tue,  9 Jan 2024 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 29D7240E0196;
	Tue,  9 Jan 2024 12:29:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8LgGsJKL99AU; Tue,  9 Jan 2024 12:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704803390; bh=+Ncz7siEkTjAJGaRbmWjV3uElamE3ik/Pui2Em7ihyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e3uzqzD6Sd0ujUJUSC7MRPxWi8vbuKwJ4aZJ/7hlC5WIahofUZyUqu6erDbkVtFKi
	 /CFGubT/bagkKI2OzvP8iOpAbgvKCGUTWjZO2fXWeLrv01DN7vwzpg2LQuOg4SYQ5c
	 rHNecCB5hRIycePIdkdlF2UbRLptkbp6CbKVs3/er+Ry1bO/1VV7Dau+807YKwMa6u
	 jeL12ntBz1dCGaOaIznhk4bYEgy3OGYr2HRemzpEpQa6Q4tw4YsqULxGCo2TxZewvh
	 EkZ8s1eqQzmkqEw/T4c3DnAg86Gs/xIiVJO1h+9el0i82Qlmgu1vraVH2f2D9rddnd
	 4DlViFsbCMmTT55sZIiZwvcahCDpMeUqODB0mDtobxwo1PTYIKOb/t2Baido8+qqPD
	 ZanyMSPeFcah1u+N9U8Gbs7b8xonaGmffMjGWR+HPMsgRRa9+1T6QHBDzzEvR/3zHx
	 ZPCkvdjka+ahnZPdOQfgsrfQphChY+NGwYX1/ZXljnBJkahyko326kvCZMr91kOuey
	 TGQlBpHNhGX9t1haLmDSI4QK+fAdBe6qS12uCaTY7neuVUN4wJ8aOdWjAXaibVyfdm
	 OZL1rADRWyLuz4u8IAUdY6MSY/14h/A6Ra70eDUxvNbWmcjE6vDDR+mV5NX3ecrDEr
	 UqQzXXr459AV1ZddaxUfdVGA=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3868140E01F9;
	Tue,  9 Jan 2024 12:29:11 +0000 (UTC)
Date: Tue, 9 Jan 2024 13:29:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
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
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240109122906.GCZZ08Esh86vhGwVx1@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
 <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
 <20240105162142.GEZZgslgQCQYI7twat@fat_crate.local>
 <0c4aac73-10d8-4e47-b6a8-f0c180ba1900@linux.microsoft.com>
 <20240108170418.GDZZwrEiIaGuMpV0B0@fat_crate.local>
 <b5b57b60-1573-44f4-8161-e2249eb6f9b6@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b5b57b60-1573-44f4-8161-e2249eb6f9b6@linux.microsoft.com>

On Tue, Jan 09, 2024 at 12:56:17PM +0100, Jeremi Piotrowski wrote:
> Can we please not assume I am acting in bad faith.

No you're not acting with bad faith.

What you're doing, in my experience so far is, you come with some weird
HV + guest models which has been invented somewhere, behind some closed
doors, then you come with some desire that the upstream kernel should
support it and you're not even documenting it properly and I'm left with
asking questions all the time, what is this, what's the use case,
blabla.

Don't take this personally - I guess this is all due to NDAs,
development schedules, and whatever else and yes, I've heard it all.

But just because you want this, we're not going to jump on it and
support it unconditionally. It needs to integrate properly with the rest
of the kernel and if it doesn't, it is not going upstream. That simple.

> I am explicitly trying to integrate nicely with AMD's KVM SNP host
> patches to cover an additional usecase and get something upstreamable.

And yet I still have no clue what your use case is. I always have to go
ask behind the scenes and get some half-answers about *maybe* this is
what they support.

Looking at the patch you pointed at I see there a proper explanation of
your nested SNP stuff. Finally!

From now on, please make sure your use case is properly explained
before you come with patches.

> The RMP in nested SNP is only used for kernel bookkeeping and so its
> allocation is optional. KVM could do without reading the RMP directly
> altogether (by tracking the assigned bit somewhere) but that would be
> a design change and I'd rather see the KVM SNP host patches merged in
> their current shape. Which is why the patch I linked allocates
> a (shadow) RMP from the kernel.

At least three issues I see with that:

- the allocation can fail so it is a lot more convenient when the
  firmware prepares it

- the RMP_BASE and RMP_END writes need to be verified they actially did
  set up the RMP range because if they haven't, you might as well
  throw SNP security out of the window. In general, letting the kernel
  do the RMP allocation needs to be verified very very thoroughly.

- a future feature might make this more complicated

> I would very much appreciate if we would not prevent that usecase from
> working - that's why I've been reviewing and testing multiple
> revisions of these patches and providing feedback all along.

I very much appreciate the help but we need to get the main SNP host
stuff in first and then we can talk about modifications.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

