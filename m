Return-Path: <kvm+bounces-7695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBC2845554
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 11:30:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E71762912FB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE63D15B99D;
	Thu,  1 Feb 2024 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e3027xbY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9DF15B96E;
	Thu,  1 Feb 2024 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706783412; cv=none; b=R96Te8PnpHKOqAFyRAEVRSRJZf1WcHLLWSZD1RiTTi3QgASlBSSLo3d36J01zvClp+7l31GkjhidOaQ963SWV3uobsLegqP0Ofy5ecxEGU0YGOGJ6aybB92pJJIpLmsATqJvl//TIL9L/ny/iIdfJRPixoY8fQze+onzf/cL3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706783412; c=relaxed/simple;
	bh=hkxe3RRd1kMjzW+0Bw8TfFoFkJcpMZftimo9SVEgji0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoRTrZHxEL9Q/bV5pOl0xa3hiuUgyrGUpNy+1CZQw9z65xSANxnXXUhrfx8ZXFMiedRpt9pgSuk30ZfXTUSXKIHyP9GUyEp5PQnTeea+kALRkUZIJc9KtdFtLdqnhmEtZdOdolwCxXjrzblM7IzujRmMO/pzWV+VKQlLfktsozI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e3027xbY; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5956740E01A2;
	Thu,  1 Feb 2024 10:30:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EkmV47niBGgf; Thu,  1 Feb 2024 10:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706783404; bh=6nY6T5PvIjKKLumCcm7k0MIRlTMiw061kXfO9W2fLyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e3027xbYpcXstWm2F9mg90OqQrj5jyBvIjW9RaBbGaqLTDQ6yKvgSQkEqD9A84kXm
	 +pcr7c4AA0eShN5S3WraUbtdDMyW6F7t5IJR80FPe2Qm3g90/DS7mackk79q+picGm
	 0I+hTYBqVmmPTRqok6W7aTQ0smfO4ob5Y68uRKY2VanRoAD4Wkze/kdH+mQDAN90nO
	 ChmiCRlOx+Sxb1x/mecnpuVgy5GZehezm8hkz0jrN6tsk1233tq2I0zJEHOuhLnWZt
	 NWm9+qwZe0nVAtKiM1D7OwE2rnbQRXH9/7iAbYMyM1ZxOdQkU4yjo2cX/R98DwsF6L
	 ejyQee8Qc7Mhh9IUZ2XXn5QKlhi8S8CX5m10oGP3w5D0qduB2GxP1vZ55VZ7Bqubnk
	 0wnFL8StTOt0tVkzOWYilR3fvcrkVPjlyZdDjeKthvJlgSV+ywnMAyOfJ5xPADBIaY
	 EH1gq5S31uBvF2La/RnoT+WXhOD49GSXMIFkIM5sSL0/LmIq7LL7x0J178EozIeuB0
	 HL011PaqCDQLMxgKWv9gbqWikqBaEpLoAh34E4D2eB+nVGABLu+xDRPTHDxi95PKin
	 eC2vftIHkwjsAYscb8/lbh6+NJ0nRNk19zfjvIiYTgUQQVjG+r+l2CIAzVnojY0V3u
	 RJY/rHFVoJqhFphXl7P5Py64=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 08AE740E00B2;
	Thu,  1 Feb 2024 10:29:52 +0000 (UTC)
Date: Thu, 1 Feb 2024 11:29:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>

On Wed, Jan 31, 2024 at 07:28:05PM +0530, Nikunj A. Dadhania wrote:
> Changed to "req" for all the guest request throughout the file. Other "req" 
> usage are renamed appropriately.

Yes, better from what I can tell.

However, I can't apply this patch in order to have a better look, it is
mangled. Next time, before you send a patch this way, send it yourself
first and try applying it.

If it doesn't work, throw away your mailer and use a proper one:

Documentation/process/email-clients.rst

> Subject: [PATCH] virt: sev-guest: Add SNP guest request structure
> 
> Add a snp_guest_req structure to simplify the function arguments. The
> structure will be used to call the SNP Guest message request API
> instead of passing a long list of parameters. Use "req" as variable name
> for guest req throughout the file and rename other variables appropriately.
> 
> Update snp_issue_guest_request() prototype to include the new guest request
> structure and move the prototype to sev_guest.h.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Tested-by: tags must be dropped if you change a patch in a non-trivial
way. And this change is not that trivial I'd say.

> ---
>  .../x86/include/asm}/sev-guest.h              |  18 ++
>  arch/x86/include/asm/sev.h                    |   8 -
>  arch/x86/kernel/sev.c                         |  16 +-
>  drivers/virt/coco/sev-guest/sev-guest.c       | 195 ++++++++++--------
>  4 files changed, 135 insertions(+), 102 deletions(-)
>  rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)

I didn't notice this before: why am I getting a sev-guest.h header in
arch/x86/?

Lemme quote again the file paths we agreed upon:

https://lore.kernel.org/all/Yg5nh1RknPRwIrb8@zn.tnic/

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

