Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6AD358220
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhDHLlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDHLlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 07:41:03 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F8DC061760;
        Thu,  8 Apr 2021 04:40:52 -0700 (PDT)
Received: from zn.tnic (p200300ec2f09500084b1bf46b8ecfaeb.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:84b1:bf46:b8ec:faeb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7BF11EC04AD;
        Thu,  8 Apr 2021 13:40:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617882050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=plX216BNHZpcdz+f4ezGrAm+clkBLv3CioAX+/V0FCI=;
        b=CM6KwhEJJDYkpU1MkaNUy+O8kqCdbz/v/4nwutkxBp1G82BD4HVmT19fVEb+tKL2QmILHW
        A69sDsWiAn0b1b0SVbxDnPBdBxoc6CdUBYAJ7cDCzgyWlvWAhUEpr1lsNYeG46ZV0mbu2I
        FwE67St5EeEOf40dMYLV1NAcZtlsLuM=
Date:   Thu, 8 Apr 2021 13:40:49 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 09/13] x86/kernel: add support to validate
 memory in early enc attribute change
Message-ID: <20210408114049.GI10192@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-10-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-10-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:20AM -0500, Brijesh Singh wrote:
> @@ -63,6 +63,10 @@ struct __packed snp_page_state_change {
>  #define GHCB_REGISTER_GPA_RESP	0x013UL
>  #define		GHCB_REGISTER_GPA_RESP_VAL(val)		((val) >> 12)
>  
> +/* Macro to convert the x86 page level to the RMP level and vice versa */
> +#define X86_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
> +#define RMP_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)

Please add those with the patch which uses them for the first time.

Also, it seems to me the names should be

X86_TO_RMP_PG_LEVEL
RMP_TO_X86_PG_LEVEL

...

> @@ -56,3 +56,108 @@ void sev_snp_register_ghcb(unsigned long paddr)
>  	/* Restore the GHCB MSR value */
>  	sev_es_wr_ghcb_msr(old);
>  }
> +
> +static void sev_snp_issue_pvalidate(unsigned long vaddr, unsigned int npages, bool validate)

pvalidate_pages() I guess.

> +{
> +	unsigned long eflags, vaddr_end, vaddr_next;
> +	int rc;
> +
> +	vaddr = vaddr & PAGE_MASK;
> +	vaddr_end = vaddr + (npages << PAGE_SHIFT);
> +
> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {

Yuck, that vaddr_next gets initialized at the end of the loop. How about
using a while loop here instead?

	while (vaddr < vaddr_end) {

		...

		vaddr += PAGE_SIZE;
	}

then you don't need vaddr_next at all. Ditto for all the other loops in
this patch which iterate over pages.

> +		rc = __pvalidate(vaddr, RMP_PG_SIZE_4K, validate, &eflags);

So this function gets only 4K pages to pvalidate?

> +

^ Superfluous newline.

> +		if (rc) {
> +			pr_err("Failed to validate address 0x%lx ret %d\n", vaddr, rc);

You can combine the pr_err and dump_stack() below into a WARN() here:

		WARN(rc, ...);

> +			goto e_fail;
> +		}
> +
> +		/* Check for the double validation condition */
> +		if (eflags & X86_EFLAGS_CF) {
> +			pr_err("Double %salidation detected (address 0x%lx)\n",
> +					validate ? "v" : "inv", vaddr);
> +			goto e_fail;
> +		}

As before - this should be communicated by a special retval from
__pvalidate().

> +
> +		vaddr_next = vaddr + PAGE_SIZE;
> +	}
> +
> +	return;
> +
> +e_fail:
> +	/* Dump stack for the debugging purpose */
> +	dump_stack();
> +
> +	/* Ask to terminate the guest */
> +	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

Another termination reason to #define.

> +}
> +
> +static void __init early_snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
> +{
> +	unsigned long paddr_end, paddr_next;
> +	u64 old, val;
> +
> +	paddr = paddr & PAGE_MASK;
> +	paddr_end = paddr + (npages << PAGE_SHIFT);
> +
> +	/* save the old GHCB MSR */
> +	old = sev_es_rd_ghcb_msr();
> +
> +	for (; paddr < paddr_end; paddr = paddr_next) {
> +
> +		/*
> +		 * Use the MSR protocol VMGEXIT to request the page state change. We use the MSR
> +		 * protocol VMGEXIT because in early boot we may not have the full GHCB setup
> +		 * yet.
> +		 */
> +		sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(paddr >> PAGE_SHIFT, op));
> +		VMGEXIT();

Yeah, I know we don't always strictly adhere to 80 columns but there's
no real need not to fit that in 80 cols here so please shorten names and
comments. Ditto for the rest.

> +
> +		val = sev_es_rd_ghcb_msr();
> +
> +		/* Read the response, if the page state change failed then terminate the guest. */
> +		if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP)
> +			sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

if (...)
	goto fail;

and add that fail label at the end so that all the error handling path
is out of the way.

> +
> +		if (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0) {

s/!= 0//

> +			pr_err("Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
> +					op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared",
> +					paddr, GHCB_SNP_PAGE_STATE_RESP_VAL(val));
> +
> +			/* Dump stack for the debugging purpose */
> +			dump_stack();

WARN as above.

> @@ -49,6 +50,27 @@ bool sev_enabled __section(".data");
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>  
> +/*
> + * When SNP is active, this routine changes the page state from private to shared before
> + * copying the data from the source to destination and restore after the copy. This is required
> + * because the source address is mapped as decrypted by the caller of the routine.
> + */
> +static inline void __init snp_aware_memcpy(void *dst, void *src, size_t sz,
> +					   unsigned long paddr, bool dec)

snp_memcpy() simply.

> +{
> +	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +
> +	/* If the paddr need to accessed decrypted, make the page shared before memcpy. */

*needs*

> +	if (sev_snp_active() && dec)

Flip that test so that you don't have it twice in the code:

	if (!sev_snp_active()) {
		memcpy(dst, src, sz);
	} else {
		...
	}


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
