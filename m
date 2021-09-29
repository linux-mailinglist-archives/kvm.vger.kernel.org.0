Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB941C6C1
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 16:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344413AbhI2OgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 10:36:12 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52556 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245348AbhI2OgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 10:36:11 -0400
Received: from zn.tnic (p200300ec2f0bd10038530ecc14d583ae.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:3853:ecc:14d5:83ae])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 507141EC0814;
        Wed, 29 Sep 2021 16:34:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632926069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QEjtvugqBhl7avNSjLLykeMqMn1pT0fAYHoaCtxwC5g=;
        b=MJo8kK7EEisTu1gSO8tYOUFR16AEjm3UOf6KENNVp/6jifrPD0u/+Qt776B+Japu3N9iQD
        ZT6LtQ5jo1Mc2o/H3GZcZ6tCcc8PaER5x1Meb0gImR+qXsi1u2RomCSKiP3kydsb/BXhZR
        ZR/sGDuV/wVyW4a+UDkQ7NYR6prpmXk=
Date:   Wed, 29 Sep 2021 16:34:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 06/45] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Message-ID: <YVR5cOQOJxy12DcR@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-7-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:39AM -0500, Brijesh Singh wrote:
> Subject: Re: [PATCH Part2 v5 06/45] x86/sev: Invalid pages from direct map when adding it to RMP table

That subject needs to have a verb. I think that verb should be
"Invalidate".

> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used with standard x86 and IOMMU page tables to enforce memory
> restrictions and page access rights. The RMP check is enforced as soon as
> SEV-SNP is enabled globally in the system. When hardware encounters an
> RMP checks failure, it raises a page-fault exception.
> 
> The rmp_make_private() and rmp_make_shared() helpers are used to add
> or remove the pages from the RMP table.

> Improve the rmp_make_private() to
> invalid state so that pages cannot be used in the direct-map after its
> added in the RMP table, and restore to its default valid permission after
> the pages are removed from the RMP table.

That sentence needs rewriting into proper english.

The more important thing is, though, this doesn't talk about *why*
you're doing this: you want to remove pages from the direct map when
they're in the RMP table because something might modify the page and
then the RMP check will fail?

Also, set_direct_map_invalid_noflush() simply clears the Present and RW
bit of a pte.

So what's up?

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/sev.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 8627c49666c9..bad41deb8335 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2441,10 +2441,42 @@ int psmash(u64 pfn)
>  }
>  EXPORT_SYMBOL_GPL(psmash);
>  
> +static int restore_direct_map(u64 pfn, int npages)

restore_pages_in_direct_map()

> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
> +		if (ret)
> +			goto cleanup;
> +	}

So this is looping over a set of virtually contiguous pages, I presume,
and if so, you should add a function called

	set_memory_p_rw()

to arch/x86/mm/pat/set_memory.c which does

	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT | _PAGE_RW), 0);

so that you can do all pages in one go.

> +
> +cleanup:
> +	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i);
> +	return ret;
> +}
> +
> +static int invalid_direct_map(unsigned long pfn, int npages)

invalidate_pages_in_direct_map()

or so.

> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < npages; i++) {
> +		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));

Same as above but that helper should do the reverse:

set_memory_np_ro()
{
	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT | _PAGE_RW), 0);
}

Btw, please add those helpers in a separate patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
