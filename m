Return-Path: <kvm+bounces-7282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB78283EE3D
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 17:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7723F2842C7
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 16:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC2F2C1A3;
	Sat, 27 Jan 2024 16:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="R8rDkWRY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C3224DD;
	Sat, 27 Jan 2024 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706371856; cv=none; b=qZl7ASHInW/uVOVYPo+PYiv1sC9K0QJcum57Fmh8rfsRV4BE42oFMjm+SUQvYljqNFYNn15mY5er60i+jKlWoyZvzs+sTGI2jesn1sUdddO9rs918is7hsWZl9IMNz7WK9BiPoV9T9WpUPyzcyvBzVnCmYaf+V3ThzU7OpYU6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706371856; c=relaxed/simple;
	bh=GC4fVdRsHNvUDt/q1fyQJYqojn4dlLXr9MCgr6ezbYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltMmHwmfInfnWR1njZU35H7qniPUiabCAESEKKhLH11GMRPGfq+iGMjS9OPV0tov579HHKtVG7O83IWGXAPxSm+ArKiLRxXxBPi7mrRyGSxadx+6e4QybmGJ6EA2AGwoT6tfnPT1ftlBYvjZujvOKlFk2xQDqMyPpPNSuyON8Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=R8rDkWRY; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 54F6740E01A9;
	Sat, 27 Jan 2024 16:03:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lu71nTCNoEp9; Sat, 27 Jan 2024 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706371414; bh=zJjvOvg09j/JxgCLQEW8hFY2bFZEzCn3tUUE3IeXvDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R8rDkWRY9JApzGfMhoO/ltUpWhxXsJorl0xs3AW2oEMUGgqBJJ7et23aCsX/6rSk7
	 L1JZYSWGKq7guE8YqyGaMRXJrgA5qVJ9suCJL5LaRAjq9FgHLzJdkEZMxnSFMc2dtO
	 gI4C12ZpMQGXlnS6ee8Hmd71QGrLYIjVdKj4p1Ryh0bmpobnRyMq49pcLhPYQikihj
	 ue5l4fe7Nu2OCWJjYUTML+jOR/Z+9YoxQUnqYVWHEPdCUjY9UuUpJc4g+VS02kKWIW
	 m6wXthg1Rtf8TnMSi5t1h7SkVGOiOlGC4YOldUaHQHzwLVqUUOuKrYZ3JBzjl4bi04
	 rs90xV6Ajdo+l1b0MRawQxxeu/ulhLAeopq07RMbJff6rXn1FQFYWl397VI847fDKM
	 ETxBr43+USwVBUxwmJYsP0SHnk4yZUfN6etUbxgZlUqlH9uzKgyIY95J0r5YXAXZl6
	 iLYItOwjknaULfEgslHWFl6kTpSlysbnoqnWLxZeb/icAB9I6CmJ7keyRbjk7M3QFB
	 liy7SwZp6fLivc4G3qmFGJ/LpDY3kVBGUC1ykFRxaYnoSobjO181UN8BzgedLbuQFB
	 1MtGE0JiOZbMIg+4bbG09P2gpteSN1AQ0jQW/wgSXWwaEcucT55dtP6lvCMlfx8Ozk
	 GL8HCR0ME/5W6ZUstLeOYxkE=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 64B8D40E016C;
	Sat, 27 Jan 2024 16:02:58 +0000 (UTC)
Date: Sat, 27 Jan 2024 17:02:49 +0100
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
Message-ID: <20240127160249.GDZbUpKW_cqRzdYn7Z@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
 <20240126235420.mu644waj2eyoxqx6@amd.com>
 <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
 <20240127154506.v3wdio25zs6i2lc3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240127154506.v3wdio25zs6i2lc3@amd.com>

On Sat, Jan 27, 2024 at 09:45:06AM -0600, Michael Roth wrote:
> directmap maps all physical memory accessible by kernel, including text
> pages, so those are valid PFNs as far as this function is concerned.

Why don't you have a look at

Documentation/arch/x86/x86_64/mm.rst

to sync up on the nomenclature first?

   ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)

   ...

   ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0

and so on.

> The expectation is that the caller is aware of what PFNs it is passing in,

There are no expectations. Have you written them down somewhere?

> This function only splits mappings in the 0xffff888000000000 directmap
> range.

This function takes any PFN it gets passed in as it is. I don't care
who its users are now or in the future and whether they pay attention
what they pass into - it needs to be properly defined.

Mike, please get on with the program. Use the right naming for the
function and basta.

IOW, this:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 0a8f9334ec6e..652ee63e87fd 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -394,7 +394,7 @@ EXPORT_SYMBOL_GPL(psmash);
  * More specifics on how these checks are carried out can be found in APM
  * Volume 2, "RMP and VMPL Access Checks".
  */
-static int adjust_direct_map(u64 pfn, int rmp_level)
+static int split_pfn(u64 pfn, int rmp_level)
 {
 	unsigned long vaddr = (unsigned long)pfn_to_kaddr(pfn);
 	unsigned int level;
@@ -405,7 +405,12 @@ static int adjust_direct_map(u64 pfn, int rmp_level)
 	if (WARN_ON_ONCE(rmp_level > PG_LEVEL_2M))
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(rmp_level == PG_LEVEL_2M && !IS_ALIGNED(pfn, PTRS_PER_PMD)))
+       if (!pfn_valid(pfn))
+               return -EINVAL;
+
+       if (rmp_level == PG_LEVEL_2M &&
+           (!IS_ALIGNED(pfn, PTRS_PER_PMD) ||
+            !pfn_valid(pfn + PTRS_PER_PMD - 1)))
 		return -EINVAL;
 
 	/*
@@ -456,7 +461,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 
 	level = RMP_TO_PG_LEVEL(state->pagesize);
 
-	if (adjust_direct_map(pfn, level))
+	if (split_pfn(pfn, level))
 		return -EFAULT;
 
 	do {


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

