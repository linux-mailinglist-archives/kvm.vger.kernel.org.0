Return-Path: <kvm+bounces-6157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 161E082C603
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4641C248F1
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 19:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BE916416;
	Fri, 12 Jan 2024 19:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DX0FsTFd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150015AFA;
	Fri, 12 Jan 2024 19:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A48A040E01B2;
	Fri, 12 Jan 2024 19:49:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id imhhkVXVMXrF; Fri, 12 Jan 2024 19:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705088974; bh=i7t/gbr0Sua0zSEsqr5ie7pHsjRKCUl3wglMN7YEUCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DX0FsTFd61uczDuI00EEc8hfZRLb8OsM3do0ibe0SGqXXPj3x93TQ/l37EENsnPgV
	 EFzlm393Z3Oi4Za9/TN04A52JCzCLtwzDhe9YeXA+8TRmUHRHP3JIRXKdu7wgJvVw9
	 2unwjYWMvVBew2/YgRhTqM00hDSSVRhYEvNvCIQ8kN2wUdYl82l70w6u9BBbUNHHm4
	 ihez0Gw1ET0zJt5gVIATaNJsjLKxFj0+0/TwjITurvaKtpkqBir3qd6F4B3MNlSWnB
	 XnfRZuieaBPnRB8pLcH7AUT/HIdxfhacJS09zdyknlJob1/dvkp6dqX3Z/tiJurmfc
	 O6Kx5ZLcyX0Xknu1pvIKnviTBX/S6Tdlt7VY9ff5EYA5dU2N+tyL02UFfrdMgYBNE8
	 9NcVSYT1EtWupp3EEiedDG7Zsu4Uo+KXIXQJL/wHtyv3xwEtiO5MA+TF6FkBTHGOcH
	 /8ALP4anxGJRe2VWygfdFWtdbBzQHX5AbVmAYBcwAZmhVu+buvUKt5O6pcMcltkTQU
	 Fx1F2jvdZe0so2aEJ+IJC13J2BBnFYd+4TbmeL+qKsC9TI94YsvE3rgV1zHpFP/uDr
	 rUWevP4bgdkcJAZwHsloCvi6ZL3hAPoimXjCyCK11iKGQtgdpr2+VJJDfu8+1ScK2p
	 rI4SZ1VuDPxVKdP+P3pHuNN8=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9E43B40E00C5;
	Fri, 12 Jan 2024 19:48:55 +0000 (UTC)
Date: Fri, 12 Jan 2024 20:48:49 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240112194849.GDZaGXoTeYkx3GYSsQ@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-12-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:39AM -0600, Michael Roth wrote:
>  static int rmpupdate(u64 pfn, struct rmp_state *state)
>  {
>  	unsigned long paddr = pfn << PAGE_SHIFT;
> -	int ret;
> +	int ret, level, npages;
>  
>  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>  		return -ENODEV;
>  
> +	level = RMP_TO_PG_LEVEL(state->pagesize);
> +	npages = page_level_size(level) / PAGE_SIZE;
> +
> +	/*
> +	 * If the kernel uses a 2MB directmap mapping to write to an address,
> +	 * and that 2MB range happens to contain a 4KB page that set to private
> +	 * in the RMP table, an RMP #PF will trigger and cause a host crash.
> +	 *
> +	 * Prevent this by removing pages from the directmap prior to setting
> +	 * them as private in the RMP table.
> +	 */
> +	if (state->assigned && invalidate_direct_map(pfn, npages))
> +		return -EFAULT;

Well, the comment says one thing but the code does not do quite what the
text says:

* where is the check that pfn is part of the kernel direct map?

* where is the check that this address is part of a 2M PMD in the direct
map so that the situation is even given that you can have a 4K private
PTE there?

What this does is simply invalidate @npages unconditionally.

Then, __set_pages_np() already takes a number of pages and a start
address. Why is this thing iterating instead of sending *all* npages in
one go?

Yes, you'd need two new helpers, something like:

set_pages_present(struct page *page, int numpages)
set_pages_non_present(struct page *page, int numpages)

which call the lowlevel counterparts.

For some reason I remember asking this a while ago...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

