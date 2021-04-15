Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33FF36108E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhDOQ5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 12:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDOQ5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 12:57:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4D1C061574;
        Thu, 15 Apr 2021 09:57:18 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ace002a6aea191a6cda8f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ce00:2a6a:ea19:1a6c:da8f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA2F71EC0518;
        Thu, 15 Apr 2021 18:57:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618505834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ssLL2NClrrsFyaLaoAWuOz/cf3x+Tj+t14k/W0AGB/E=;
        b=CyzjZzEEj58xGorNZdZE7IJ+pq0wpH73fEnomHbUsDszk83CPnmjec9iesU+6ALC1QxQEI
        0nBBMm6VOdq8wrGVkXCk1/5tt2MVe41ayn4ISnYaw10tgtXOnFsbG7Q+vgKMOMwf60Jpoi
        aK2D67UjFNRopXf6gP/O+Cpsgw1VqII=
Date:   Thu, 15 Apr 2021 18:57:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
Message-ID: <20210415165711.GD6318@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-3-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:08PM -0500, Brijesh Singh wrote:
> The lookup_page_in_rmptable() can be used by the host to read the RMP
> entry for a given page. The RMP entry format is documented in PPR
> section 2.1.5.2.

I see

Table 15-36. Fields of an RMP Entry

in the APM.

Which PPR do you mean? Also, you know where to put those documents,
right?

> +/* RMP table entry format (PPR section 2.1.5.2) */
> +struct __packed rmpentry {
> +	union {
> +		struct {
> +			uint64_t assigned:1;
> +			uint64_t pagesize:1;
> +			uint64_t immutable:1;
> +			uint64_t rsvd1:9;
> +			uint64_t gpa:39;
> +			uint64_t asid:10;
> +			uint64_t vmsa:1;
> +			uint64_t validated:1;
> +			uint64_t rsvd2:1;
> +		} info;
> +		uint64_t low;
> +	};
> +	uint64_t high;
> +};
> +
> +typedef struct rmpentry rmpentry_t;

Eww, a typedef. Why?

struct rmpentry is just fine.

> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 39461b9cb34e..06394b6d56b2 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -34,6 +34,8 @@
>  
>  #include "mm_internal.h"
>  

<--- Needs a comment here to explain the magic 0x4000 and the magic
shift by 8.

> +#define rmptable_page_offset(x)	(0x4000 + (((unsigned long) x) >> 8))
> +
>  /*
>   * Since SME related variables are set early in the boot process they must
>   * reside in the .data section so as not to be zeroed out when the .bss
> @@ -612,3 +614,33 @@ static int __init mem_encrypt_snp_init(void)
>   * SEV-SNP must be enabled across all CPUs, so make the initialization as a late initcall.
>   */
>  late_initcall(mem_encrypt_snp_init);
> +
> +rmpentry_t *lookup_page_in_rmptable(struct page *page, int *level)

snp_lookup_page_in_rmptable()

> +{
> +	unsigned long phys = page_to_pfn(page) << PAGE_SHIFT;
> +	rmpentry_t *entry, *large_entry;
> +	unsigned long vaddr;
> +
> +	if (!static_branch_unlikely(&snp_enable_key))
> +		return NULL;
> +
> +	vaddr = rmptable_start + rmptable_page_offset(phys);
> +	if (WARN_ON(vaddr > rmptable_end))

Do you really want to spew a warn on splat for each wrong vaddr? What
for?

> +		return NULL;
> +
> +	entry = (rmpentry_t *)vaddr;
> +
> +	/*
> +	 * Check if this page is covered by the large RMP entry. This is needed to get
> +	 * the page level used in the RMP entry.
> +	 *

No need for a new line in the comment and no need for the "e.g." thing
either.

Also, s/the large RMP entry/a large RMP entry/g.

> +	 * e.g. if the page is covered by the large RMP entry then page size is set in the
> +	 *       base RMP entry.
> +	 */
> +	vaddr = rmptable_start + rmptable_page_offset(phys & PMD_MASK);
> +	large_entry = (rmpentry_t *)vaddr;
> +	*level = rmpentry_pagesize(large_entry);
> +
> +	return entry;
> +}
> +EXPORT_SYMBOL_GPL(lookup_page_in_rmptable);

Exported for kvm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
