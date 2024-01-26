Return-Path: <kvm+bounces-7196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BD983E1DF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D3E21C241A2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F808224E0;
	Fri, 26 Jan 2024 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dZ7IOSuV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791FF1DDFC;
	Fri, 26 Jan 2024 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294673; cv=none; b=qZfR5f9PVsjsihMp6Ov/gZgFJDT1e1qXjWAB6h+P3xjHuH0ut8EPm7GdU0R70u3oz9jGTg1q+pnEH3sheA2UFoENbR2GVMRo6Yn9AGCjxAb2bgWD0X4WRsgUr4SbKLPjCjFPDCEHVXmQsKzD+JOspCghSepaZSOng8k/fQP83nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294673; c=relaxed/simple;
	bh=nf/POY29CG3Y+BqXT0M1LE29Qv40vbKTyyGYz43XKHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTqiWFPgDEIQIOFIcwn/h4s9ns9HfyZXOmfUQ//Z9OUptYZraRfBMfjgFp7POOEoV7hdar63JIPvztMLUMOBJSA5kIH79V0YcORWjontguAUtI09oMO2FnPu8Rs+0tA0Y1uz12XAGpFotfTUuCnohqGlmghBtpT+hSSYafEL4x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dZ7IOSuV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5BA7F40E01A9;
	Fri, 26 Jan 2024 18:44:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pobZP-BeJfAp; Fri, 26 Jan 2024 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706294665; bh=duwCYa0fwFKf6HI10qA1Z2xg/PK3N1HXBTl9zUoAe5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZ7IOSuVpOKnAq6iSSA/5BPQOosteryR4BL/dDYOzqOz7mbKP7XKS6DYNmYUuR7zQ
	 ucDQCB+3oYkx5yez0vnxL08sdZIHI9XeqjTUjLhjeHjRH7KTfwFIhsp5Upqd2fz4iG
	 IN6ieFmKw228wvOseFZAsBm4kuZ71QDY8XcRQrU3wwPB4gA/y0d1umlumNSy6PlR/6
	 lFGPR1q0bFT80L8ZguOxanmGs9TLwgCOjQ+szOZi1iLGLfwkzYu13S2M9ozFFTiItu
	 7aI1enA/as9CDGUCSqQLNtBO4im+L9sC7Wa2DDCtzOndx7PlKaP7XsYLJMYIwich8A
	 HX2OWGwk+ZT1kNCsTNBihyxgyFzxn/h2k06fdbe5unNqSE+LfH7Oss/wbqBFz6pnQW
	 I0VK/FW7wQAMQ89hI2Bm3AHl45qD6NlDpKSr4dfgRIOQZgENQYbIUtrQlTyZK/ccNF
	 lFtJ68KKeAM5oX+Lokm9bWJvRMAaoTS7IHcX0AB7Dtg2x14FNrH9oNNX6vvQJo4BIb
	 YS+H0YBgJqjXVhNmVsCkdnJQ6EDEx9ledNnVioJksK+fIyC+nlYnDb2XKLoC775Pcn
	 KKFax279Nwwcmuvkq/sobr8XRY8Fuv8Su6Lo4xnRYi/aYYKe/ZlP29oc3397HujdT9
	 w/8zEkJUX+JWvm6vs5bQrgZs=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 853E840E00C5;
	Fri, 26 Jan 2024 18:43:48 +0000 (UTC)
Date: Fri, 26 Jan 2024 19:43:40 +0100
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
Message-ID: <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126170415.f7r4nvsrzgpzcrzv@amd.com>

On Fri, Jan 26, 2024 at 11:04:15AM -0600, Michael Roth wrote:
> vaddr comes from pfn_to_kaddr(pfn), i.e. __va(paddr), so it will
> necessarily be a direct-mapped address above __PAGE_OFFSET.

Ah, true.

> For upper-end, a pfn_valid(pfn) check might suffice, since only a valid
> PFN would have a possibly-valid mapping wthin the directmap range.

Looking at it, yap, that could be a sensible thing to check.

> These are PFNs that are owned/allocated-to the caller. Due to the nature
> of the directmap it's possible non-owners would write to a mapping that
> overlaps, but vmalloc()/etc. would not create mappings for any pages that
> were not specifically part of an allocation that belongs to the caller,
> so I don't see where there's any chance for an overlap there. And the caller
> of these functions would not be adjusting directmap for PFNs that might be
> mapped into other kernel address ranges like kernel-text/etc unless the
> caller was specifically making SNP-aware adjustments to those ranges, in
> which case it would be responsible for making those other adjustments,
> or implementing the necessary helpers/etc.

Why does any of that matter?

If you can make this helper as generic as possible now, why don't you?

> I'm not aware of such cases in the current code, and I don't think it makes
> sense to attempt to try to handle them here generically until such a case
> arises, since it will likely involve more specific requirements than what
> we can anticipate from a theoretical/generic standpoint.

Then that's a different story. If it will likely involve more specific
handling, then that function should deal with pfns for which it can DTRT
and for others warn loudly so that the code gets fixed in time.

IOW, then it should check for the upper pfn of the direct map here and
we have two, depending on the page sizes used...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

