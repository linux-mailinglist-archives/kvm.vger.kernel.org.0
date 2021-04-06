Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA13550F5
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 12:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhDFKeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 06:34:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36162 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237740AbhDFKeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 06:34:08 -0400
Received: from zn.tnic (p200300ec2f0a0d00cae560cc4b979d7d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:cae5:60cc:4b97:9d7d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 279801EC0249;
        Tue,  6 Apr 2021 12:33:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617705239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XHohCERsyobAxMQ1TTVk7xqz1Z2axGr2mx6JgbSETx8=;
        b=RP6aMbZLMrOiIpWm0oo+PnYAWkMEZp6DPl/Xdl2hMIOV8/nzGZBfUagUS15mHg1KIeOnjv
        haEw0ABDKb2J1Am5CyINKsi5fFeo/K6T3jNJSPM8BUM8dcrowbNuEfhJbkdnZ+eQDEb4GO
        nqB3VbnfjRhsWyxHp5jcgDBo6gN6Ed8=
Date:   Tue, 6 Apr 2021 12:33:58 +0200
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
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate
 the memory used for the GHCB
Message-ID: <20210406103358.GL17806@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-7-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:17AM -0500, Brijesh Singh wrote:
> Many of the integrity guarantees of SEV-SNP are enforced through the
> Reverse Map Table (RMP). Each RMP entry contains the GPA at which a
> particular page of DRAM should be mapped. The VMs can request the
> hypervisor to add pages in the RMP table via the Page State Change VMGEXIT
> defined in the GHCB specification section 2.5.1 and 4.1.6. Inside each RMP
> entry is a Validated flag; this flag is automatically cleared to 0 by the
> CPU hardware when a new RMP entry is created for a guest. Each VM page
> can be either validated or invalidated, as indicated by the Validated
> flag in the RMP entry. Memory access to a private page that is not
> validated generates a #VC. A VM can use PVALIDATE instruction to validate
> the private page before using it.

I guess this should say "A VM must use the PVALIDATE insn to validate
that private page before using it." Otherwise it can't use it, right.
Thus the "must" and not "can".

> To maintain the security guarantee of SEV-SNP guests, when transitioning
> a memory from private to shared, the guest must invalidate the memory range
> before asking the hypervisor to change the page state to shared in the RMP
> table.

So first you talk about memory pages, now about memory range...

> After the page is mapped private in the page table, the guest must issue a

... and now about pages again. Let's talk pages only pls.

> page state change VMGEXIT to make the memory private in the RMP table and
> validate it. If the memory is not validated after its added in the RMP table
> as private, then a VC exception (page-not-validated) will be raised.

Didn't you just say this already above?

> We do

Who's "we"?

> not support the page-not-validated exception yet, so it will crash the guest.
> 
> On boot, BIOS should have validated the entire system memory. During
> the kernel decompression stage, the VC handler uses the
> set_memory_decrypted() to make the GHCB page shared (i.e clear encryption
> attribute). And while exiting from the decompression, it calls the
> set_memory_encyrpted() to make the page private.

Hmm, that commit message needs reorganizing, from
Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

So this should say something along the lines of "Add helpers for validating
pages in the decompression stage" or so.

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org

Btw, you don't really need to add those CCs to the patch - it is enough
if you Cc the folks when you send the patches with git.

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/boot/compressed/Makefile       |   1 +
>  arch/x86/boot/compressed/ident_map_64.c |  18 ++++
>  arch/x86/boot/compressed/sev-snp.c      | 115 ++++++++++++++++++++++++
>  arch/x86/boot/compressed/sev-snp.h      |  25 ++++++
>  4 files changed, 159 insertions(+)
>  create mode 100644 arch/x86/boot/compressed/sev-snp.c
>  create mode 100644 arch/x86/boot/compressed/sev-snp.h
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index e0bc3988c3fa..4d422aae8a86 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -93,6 +93,7 @@ ifdef CONFIG_X86_64
>  	vmlinux-objs-y += $(obj)/mem_encrypt.o
>  	vmlinux-objs-y += $(obj)/pgtable_64.o
>  	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
> +	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-snp.o

Yeah, as before, make that a single sev.o and put everything in it.

>  endif
>  
>  vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
> diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
> index f7213d0943b8..0a420ce5550f 100644
> --- a/arch/x86/boot/compressed/ident_map_64.c
> +++ b/arch/x86/boot/compressed/ident_map_64.c
> @@ -37,6 +37,8 @@
>  #include <asm/setup.h>	/* For COMMAND_LINE_SIZE */
>  #undef _SETUP
>  
> +#include "sev-snp.h"
> +
>  extern unsigned long get_cmd_line_ptr(void);
>  
>  /* Used by PAGE_KERN* macros: */
> @@ -278,12 +280,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
>  	if ((set | clr) & _PAGE_ENC)
>  		clflush_page(address);
>  
> +	/*
> +	 * If the encryption attribute is being cleared, then change the page state to
> +	 * shared in the RMP entry. Change of the page state must be done before the
> +	 * PTE updates.
> +	 */
> +	if (clr & _PAGE_ENC)
> +		sev_snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);

The statement above already looks at clr - just merge the two together.

> +
>  	/* Update PTE */
>  	pte = *ptep;
>  	pte = pte_set_flags(pte, set);
>  	pte = pte_clear_flags(pte, clr);
>  	set_pte(ptep, pte);
>  
> +	/*
> +	 * If the encryption attribute is being set, then change the page state to
> +	 * private in the RMP entry. The page state must be done after the PTE
> +	 * is updated.
> +	 */
> +	if (set & _PAGE_ENC)
> +		sev_snp_set_page_private(pte_pfn(*ptep) << PAGE_SHIFT);
> +
>  	/* Flush TLB after changing encryption attribute */
>  	write_cr3(top_level_pgt);
>  
> diff --git a/arch/x86/boot/compressed/sev-snp.c b/arch/x86/boot/compressed/sev-snp.c
> new file mode 100644
> index 000000000000..5c25103b0df1
> --- /dev/null
> +++ b/arch/x86/boot/compressed/sev-snp.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * AMD SEV SNP support
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + */
> +
> +#include "misc.h"
> +#include "error.h"
> +
> +#include <asm/msr-index.h>
> +#include <asm/sev-snp.h>
> +#include <asm/sev-es.h>
> +
> +#include "sev-snp.h"
> +
> +static bool sev_snp_enabled(void)
> +{
> +	unsigned long low, high;
> +	u64 val;
> +
> +	asm volatile("rdmsr\n" : "=a" (low), "=d" (high) :
> +			"c" (MSR_AMD64_SEV));
> +
> +	val = (high << 32) | low;
> +
> +	if (val & MSR_AMD64_SEV_SNP_ENABLED)
> +		return true;
> +
> +	return false;
> +}

arch/x86/boot/compressed/mem_encrypt.S already touches
MSR_AMD64_SEV - you can extend that function there and cache the
MSR_AMD64_SEV_SNP_ENABLED too, depending on where you need it. That
function is called in .code32 though.

If not, you should at least cache the MSR so that you don't have to read
it each time.

> +
> +/* Provides sev_snp_{wr,rd}_ghcb_msr() */
> +#include "sev-common.c"
> +
> +/* Provides sev_es_terminate() */
> +#include "../../kernel/sev-common-shared.c"
> +
> +static void sev_snp_pages_state_change(unsigned long paddr, int op)

no need for too many prefixes on static functions - just call this one
__change_page_state() or so, so that the below one can be called...

> +{
> +	u64 pfn = paddr >> PAGE_SHIFT;
> +	u64 old, val;
> +
> +	/* save the old GHCB MSR */
> +	old = sev_es_rd_ghcb_msr();

Why do you need to save/restore GHCB MSR? Other callers simply go and
write into it the new command...

> +
> +	/* Issue VMGEXIT to change the page state */
> +	sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(pfn, op));
> +	VMGEXIT();
> +
> +	/* Read the response of the VMGEXIT */
> +	val = sev_es_rd_ghcb_msr();
> +	if ((GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP) ||
> +	    (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0))

No need for the "!= 0"

> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);

So what does that mean?

*Any* and *all* page state changes which fail immediately terminate a
guest? Why?

Then, how do we communicate this to the guest user what has happened?

Can GHCB_SEV_ES_REASON_GENERAL_REQUEST be something special like

GHCB_SEV_ES_REASON_PSC_FAILURE

or so, so that users know what has happened?

> +	/* Restore the GHCB MSR value */
> +	sev_es_wr_ghcb_msr(old);
> +}
> +
> +static void sev_snp_issue_pvalidate(unsigned long paddr, bool validate)

That one you can call simply "pvalidate" and then the layering with
__pvalidate works too.

> +{
> +	unsigned long eflags;
> +	int rc;
> +
> +	rc = __pvalidate(paddr, RMP_PG_SIZE_4K, validate, &eflags);
> +	if (rc) {
> +		error("Failed to validate address");
> +		goto e_fail;
> +	}
> +
> +	/* Check for the double validation and assert on failure */
> +	if (eflags & X86_EFLAGS_CF) {
> +		error("Double validation detected");
> +		goto e_fail;
> +	}
> +
> +	return;
> +e_fail:
> +	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> +}
> +
> +static void sev_snp_set_page_private_shared(unsigned long paddr, int op)

... change_page_state()

> +{
> +	if (!sev_snp_enabled())
> +		return;
> +
> +	/*
> +	 * We are change the page state from private to shared, invalidate the pages before

s/We are//

> +	 * making the page state change in the RMP table.
> +	 */
> +	if (op == SNP_PAGE_STATE_SHARED)
> +		sev_snp_issue_pvalidate(paddr, false);

The new RMP Validated bit is specified in EDX[0]. The C standard defines

	false == 0
	true == 1

but make that explicit pls:

	pvalidate(paddr, 0);
	pvalidate(paddr, 1);

> +
> +	/* Request the page state change in the RMP table. */
> +	sev_snp_pages_state_change(paddr, op);
> +
> +	/*
> +	 * Now that pages are added in the RMP table as a private memory, validate the
> +	 * memory range so that it is consistent with the RMP entry.
> +	 */
> +	if (op == SNP_PAGE_STATE_PRIVATE)
> +		sev_snp_issue_pvalidate(paddr, true);
> +}
> +
> +void sev_snp_set_page_private(unsigned long paddr)
> +{
> +	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_PRIVATE);
> +}
> +
> +void sev_snp_set_page_shared(unsigned long paddr)
> +{
> +	sev_snp_set_page_private_shared(paddr, SNP_PAGE_STATE_SHARED);
> +}
> diff --git a/arch/x86/boot/compressed/sev-snp.h b/arch/x86/boot/compressed/sev-snp.h
> new file mode 100644
> index 000000000000..12fe9581a255
> --- /dev/null
> +++ b/arch/x86/boot/compressed/sev-snp.h

A single sev.h I guess.

> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AMD SEV Secure Nested Paging Support
> + *
> + * Copyright (C) 2021 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#ifndef __COMPRESSED_SECURE_NESTED_PAGING_H
> +#define __COMPRESSED_SECURE_NESTED_PAGING_H

Look at how other x86 headers define their guards' format.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
