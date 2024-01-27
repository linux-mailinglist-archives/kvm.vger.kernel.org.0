Return-Path: <kvm+bounces-7277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3F083ECF3
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 12:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 483E81F231D6
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 11:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9141920B3B;
	Sat, 27 Jan 2024 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eC4rs6Wd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514281E869;
	Sat, 27 Jan 2024 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706355776; cv=none; b=m4CoccuxWjVdLMxYfnsDDPUS0uUGa1QUeIbits8BRvLzRJ0+mjmwMnkR2cUZ1n9tlzxQyVPLS1xG0/p9U6CzAdCoHnTBMnBja7zl0aF7+s8p+tJ/bSum4DvteQAlNI9uSVVA/btKWzWgm42khLxV4q34xFaI4Q48mrtgDwnYCz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706355776; c=relaxed/simple;
	bh=nAOcTFP3pwvvDUbQsgTedOGhxngX6Aj/2e6lzNcC4KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZF4ed+98TDlcxjkWGRzP7FySZe2CdD2z7wlvQj/7+DdrU1iodYtvjXZNSIvQRB9LsLwewVThAO0+m4pzoEZ9ILjH3fnRnYFQcA433UnNmCUe76Gs6YWqWyiLnM7XF+/bpUEOrtwc48bwV9RD3nzu6wyLA39E2emgVoekbN/4cN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eC4rs6Wd; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4F3AA40E0196;
	Sat, 27 Jan 2024 11:42:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CIObjHhXZrUT; Sat, 27 Jan 2024 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706355768; bh=Z+24pU73zrvlVW/zZsFzlGVxb2gSvEeHL9ZKSaOfvm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eC4rs6WdjoEAKl2hlM4DT8Ngyn7hIzO1XtLqEGVdcosggtPTaawBo0zgWCPYL0fp0
	 tXHcSXmV9rsQa1LznoqFpESHm5PRtL6p7P9t91N+pCjdpT1nUmTFRfqvLzPi4yPncD
	 AbFcv6pi0dgWN3pzy7KBBMK5uYvXEf1+cCbxD3wogXe/gdKmqYtCs1R723GFv2uqTF
	 r9qdDIguH8bY6RrAQRDKIbyGKezDOrtTmgibvnjyMAPZ/mcYg+iNHpb6Qbq+lpoYaG
	 h/H3Xzhi5LwTQxppVDMluSTI+kUEINJjQkBkOVUlhk/xseeqzpv8bH0wc7bp0u2Sbc
	 bPelKuYVSeN74fAIy+GORMmBwW3Q0wjtRqCjXPfImX6pM3GEF6+1w8uetPJmV2MDsf
	 gmF1XSHCxkf1VTEMBYkknctBJfZrPSlBy5xIfAzqUf83N3nAJlCBEZg0vtyhS/2XwG
	 Mx6ApzoIcVSR17zE4NkrPPRoHVJ1e46DR3F24AYYrzcEQo2JQvwE3NNP3BXz/wY4Eh
	 f+j7/Rox/xWnB99wp6N7L8V+buOHpbNVVEAC2hNWsfizH9XIRtc1rFJXd6yXzU2VqM
	 9bGD1cD5mLnomB2H9Xxv5PJslPh068zLfH20RKayB50XALaa6PGfV1mhv1/y6bhKqu
	 pKzTDG5kVuhAuqJOMmtPjZy0=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7310540E016C;
	Sat, 27 Jan 2024 11:42:12 +0000 (UTC)
Date: Sat, 27 Jan 2024 12:42:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
 <20240126235420.mu644waj2eyoxqx6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126235420.mu644waj2eyoxqx6@amd.com>

On Fri, Jan 26, 2024 at 05:54:20PM -0600, Michael Roth wrote:
> Is something like this close to what you're thinking? I've re-tested with
> SNP guests and it seems to work as expected.
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 846e9e53dff0..c09497487c08 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -421,7 +421,12 @@ static int adjust_direct_map(u64 pfn, int rmp_level)
>         if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
>                 return -EINVAL;
> 
> -       if (WARN_ON_ONCE(rmp_level == PG_LEVEL_2M && !IS_ALIGNED(pfn, PTRS_PER_PMD)))
> +       if (!pfn_valid(pfn))

_text at VA 0xffffffff81000000 is also a valid pfn so no, this is not
enough.

Either this function should not have "direct map" in the name as it
converts *any* valid pfn not just the direct map ones or it should check
whether the pfn belongs to the direct map range.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

