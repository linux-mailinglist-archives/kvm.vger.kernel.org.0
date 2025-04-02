Return-Path: <kvm+bounces-42465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81CD1A78B87
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 11:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4604416F023
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 09:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFB123642E;
	Wed,  2 Apr 2025 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NCoovo36"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38E62E336E;
	Wed,  2 Apr 2025 09:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743587295; cv=none; b=deChp1cotpb0eKzdmD589d2UHpAEcGxKGQGQZbRF+LoVi/zNIQoQagKKA1ZPsYcR3cZUL6jUZlviecRnqGii8u+gR2OFoVjOG3FxH/bK5iSqvWsw6cUTetfvRUWmEZFKR/ITKanGE8UUMPFqMG4ixHVejQ06gmZn+WV+vvSPxhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743587295; c=relaxed/simple;
	bh=suqT8iQBJa5FgnDU/SDufSS45NeX1L9jgaeHh5HkMQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gePeNWZ+q0EL0R8p35MVKl2qvQ7bE7D6C4epd5QoCzgIic7M6tOIaXyb9M93z7Y5uBxbays4zIOPddfwe+6YAct7b9LRNuEU26mOg4auNAp+5CUT4Xl2vImSyIv73022FFQzhf0zrStE+W9v5KLOkZ/wBGTmOKNeFO3OzOOpLUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NCoovo36; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B948940E0196;
	Wed,  2 Apr 2025 09:48:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OU8HO-_OgT_3; Wed,  2 Apr 2025 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1743587283; bh=eQ8xvnw8eM22oCBBLNZs7z0mUSAGUegwLd+uMwiuzkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NCoovo365/G/uMz3FKkUr9ljE2+3/qzDIbREAq39rFlmvdOqQcsNXArtjTQcUuERc
	 YyTPneYs8Pk+jK1gaYwiozbx0/BKQL3WC/5bg9LuDqZM8M3EQ2yZ7LggYo/1fq0CuR
	 ysfmE23QTcUVd23o6leBt4xG0YCTC47ABvIQ+fz5uquDiyzpeP6kuRqmj9CHjrizeX
	 8G1iU/BbR6S5KEd38NMOQBFBJ1FWSDpqk+RgiUv1nvwxy2bptlmsTl2VbHnCzrI4YY
	 p6zawB/PMVJmIPDbX6rbR52es2MNo5K2ew+9wOaXjmn1Nx3UosrHPAk7MMTYAkvlUM
	 AS2CC8eP5dzpa17L7kMkdWSpXA3uahSktPfax/48LNyK43TnRJLKHxJC8oC9jJV/PA
	 2cqa4RyvRDUEg0CX6ZmUsjQ8ZALj5ZLe0/x4q2Mfi5hIQbq5DBa4v/EvwMeHyb6Yzl
	 hxTnTbM7UwIHUCp3y9RPj8XIM39gW5iNI1/lNBFW1rMNUtPYxUKBmPIq2qS8TAV+WZ
	 BMjBNqpwhh7q8aEvfKt9wN9NG+b0KR7X4xFdFKLdyEOr77ohIrrhINO/u5KeNQfRmE
	 SzXvLjoD0j24Xtla0k9yoS8uUE7GiFKh0PVw1LjTHMzpantmhKgRprR4aK2Rz17d4e
	 /9N+azzQZLTjqll7KjJmvpVI=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4B58440E0232;
	Wed,  2 Apr 2025 09:47:43 +0000 (UTC)
Date: Wed, 2 Apr 2025 11:47:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250402094736.GAZ-0HuG0uVznq5wX_@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
 <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
 <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
 <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>

On Tue, Apr 01, 2025 at 10:42:17AM +0530, Neeraj Upadhyay wrote:
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index edc31615cb67..ecf86b8a6601 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -685,8 +685,14 @@
> >  #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
> >  #define MSR_AMD64_SNP_SMT_PROT_BIT	17
> >  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
> > +
> >  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
> > -#define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> > +#ifdef CONFIG_AMD_SECURE_AVIC
> > +#define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> > +#else
> > +#define MSR_AMD64_SNP_SECURE_AVIC	0
> > +#endif
> > +
> 
> I missed this part. I think this does not work because if CONFIG_AMD_SECURE_AVIC
> is not enabled, MSR_AMD64_SNP_SECURE_AVIC bit becomes 0 in both SNP_FEATURES_IMPL_REQ
> and SNP_FEATURES_PRESENT.
> 
> So, snp_get_unsupported_features() won't report SECURE_AVIC feature as not being
> enabled in guest launched with SECURE_AVIC vmsa feature enabled. Thoughts?

Your formulations are killing me :-P

... won't report.. as not being enabled ... with feature enabled.

Double negation with a positive at the end.

So this translates to

"will report as enabled when enabled"

which doesn't make too much sense.

*IF* you have CONFIG_AMD_SECURE_AVIC disabled, then you don't have SAVIC
support and then SAVIC VMSA feature bit better be 0.

Or what do you mean?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

