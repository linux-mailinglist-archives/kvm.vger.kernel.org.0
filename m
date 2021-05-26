Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F91391520
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhEZKkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:40:52 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55320 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234122AbhEZKkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 06:40:47 -0400
Received: from zn.tnic (p200300ec2f0d49009660c40ecb662901.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4900:9660:c40e:cb66:2901])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2AA5A1EC00F8;
        Wed, 26 May 2021 12:39:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622025554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=g9dNXTvExJ3cd33K4Wld6VeYZzjucB17xfxJdo3/PL0=;
        b=caceP+P8UfWjIqjOsEblDwhryr8BNvDvHTbFtkcFJTleUCKtsjdmrhVyNu77XR/0Ztf0RT
        fd4MDJLUccd89H6jFTJTg3nqA0dyi0l8OInRxx7nH4/sXB+I9Ymc2perW+XgcDTP6vCjuf
        lF4h+GMOUq/IvVjGwboZaSQBqclWvGE=
Date:   Wed, 26 May 2021 12:39:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 14/20] x86/sev: Add helper for validating
 pages in early enc attribute changes
Message-ID: <YK4lTP+bHBzUxAOZ@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-15-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-15-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:10AM -0500, Brijesh Singh wrote:
> +static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool validate)
> +{
> +	unsigned long vaddr_end;
> +	int rc;
> +
> +	vaddr = vaddr & PAGE_MASK;
> +	vaddr_end = vaddr + (npages << PAGE_SHIFT);
> +
> +	while (vaddr < vaddr_end) {
> +		rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
> +		if (rc) {
> +			WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc);

WARN does return the condition it warned on, look at its definition.

IOW, you can do (and btw e_fail is not needed either):

                rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
                if (WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc))
			sev_es_terminate(1, GHCB_TERM_PVALIDATE);

Ditto for the other WARN.

But looking at that function more, you probably could reorganize it a
bit and do this instead:

	...

        while (vaddr < vaddr_end) {
                if (!pvalidate(vaddr, RMP_PG_SIZE_4K, validate)) {
                        vaddr = vaddr + PAGE_SIZE;
                        continue;
                }

                WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc);
                sev_es_terminate(1, GHCB_TERM_PVALIDATE);
        }
}

and have the failure case at the end and no labels or return statements
for less clutter.

> +			goto e_fail;
> +		}
> +
> +		vaddr = vaddr + PAGE_SIZE;
> +	}
> +
> +	return;
> +
> +e_fail:
> +	sev_es_terminate(1, GHCB_TERM_PVALIDATE);
> +}
> +
> +static void __init early_snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
> +{
> +	unsigned long paddr_end;
> +	u64 val;
> +
> +	paddr = paddr & PAGE_MASK;
> +	paddr_end = paddr + (npages << PAGE_SHIFT);
> +
> +	while (paddr < paddr_end) {
> +		/*
> +		 * Use the MSR protcol because this function can be called before the GHCB

WARNING: 'protcol' may be misspelled - perhaps 'protocol'?
#209: FILE: arch/x86/kernel/sev.c:562:
+                * Use the MSR protcol because this function can be called before the GHCB


I think I've said this before:

Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense.

> +		 * is established.
> +		 */
> +		sev_es_wr_ghcb_msr(GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, op));
> +		VMGEXIT();
> +
> +		val = sev_es_rd_ghcb_msr();
> +
> +		if (GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP)

Does that one need a warning too or am I being too paranoid?

> +			goto e_term;
> +
> +		if (GHCB_MSR_PSC_RESP_VAL(val)) {
> +			WARN(1, "Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
> +				op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared", paddr,
> +				GHCB_MSR_PSC_RESP_VAL(val));
> +			goto e_term;

                if (WARN(GHCB_MSR_PSC_RESP_VAL(val),
                         "Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
                         op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared", 
                         paddr, GHCB_MSR_PSC_RESP_VAL(val)))
                        goto e_term;


> +		}
> +
> +		paddr = paddr + PAGE_SIZE;
> +	}
> +
> +	return;
> +
> +e_term:
> +	sev_es_terminate(1, GHCB_TERM_PSC);
> +}
> +
> +void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
> +					 unsigned int npages)
> +{
> +	if (!sev_snp_active())
> +		return;
> +
> +	 /* Ask hypervisor to add the memory pages in RMP table as a 'private'. */
> +	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_PRIVATE);
> +
> +	/* Validate the memory pages after its added in the RMP table. */

				     after they've been added...

> +	pvalidate_pages(vaddr, npages, 1);
> +}
> +
> +void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
> +					unsigned int npages)
> +{
> +	if (!sev_snp_active())
> +		return;
> +
> +	/* Invalidate memory pages before making it shared in the RMP table. */

Ditto.

> +	pvalidate_pages(vaddr, npages, 0);
> +
> +	 /* Ask hypervisor to make the memory pages shared in the RMP table. */
> +	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
> +}
> +
>  int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
>  {
>  	u16 startup_cs, startup_ip;
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 076d993acba3..f722518b244f 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -30,6 +30,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/sev.h>
>  
>  #include "mm_internal.h"
>  
> @@ -50,6 +51,30 @@ bool sev_enabled __section(".data");
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>  
> +/*
> + * When SNP is active, this routine changes the page state from private to

s/this routine changes/change/

> + * shared before copying the data from the source to destination and restore
> + * after the copy. This is required because the source address is mapped as
> + * decrypted by the caller of the routine.
> + */
> +static inline void __init snp_memcpy(void *dst, void *src, size_t sz, unsigned long paddr,
> +				     bool dec)

					 decrypt

> +{
> +	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +
> +	if (dec) {
> +		/* If the paddr needs to be accessed decrypted, make the page shared before memcpy. */
> +		early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);
> +
> +		memcpy(dst, src, sz);
> +
> +		/* Restore the page state after the memcpy. */
> +		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
> +	} else {
> +		memcpy(dst, src, sz);
> +	}

Hmm, this function needs reorg. How about this:

/*
 * When SNP is active, change the page state from private to shared before
 * copying the data from the source to destination and restore after the copy.
 * This is required because the source address is mapped as decrypted by the
 * caller of the routine.
 */
static inline void __init snp_memcpy(void *dst, void *src, size_t sz,
                                     unsigned long paddr, bool decrypt)
{
        unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;

        if (!sev_snp_active() || !decrypt) {
                memcpy(dst, src, sz);
                return;
	}

        /*
         * If the paddr needs to be accessed decrypted, mark the page
         * shared in the RMP table before copying it.
         */
        early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);

        memcpy(dst, src, sz);

        /* Restore the page state after the memcpy. */
        early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
}


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
