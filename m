Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B761335C599
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhDLLtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbhDLLtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 07:49:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320FEC061574;
        Mon, 12 Apr 2021 04:49:06 -0700 (PDT)
Received: from zn.tnic (p200300ec2f052100338fe73c52330fca.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:2100:338f:e73c:5233:fca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CA25B1EC03CA;
        Mon, 12 Apr 2021 13:49:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618228145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FsqrOL3l5LXEPwYfRPsXmq+eeLShFhFarzUk0hvvlG0=;
        b=B7ny3B62ddp4Rk9c0HWBOD+i4Zx/bORdlsugtojTDtXwRStfe/qSS6rxXxfVcxYoz+/uxl
        nlrT+HhncCm8oG5EjfR8q2w4GZtjWjI8QfF9pv05uoZ95A8kMxp/ng9sdxFAkXdKg7m6zo
        LDHSnlHW38Ul7gG/H15bJWcQl1C5gfA=
Date:   Mon, 12 Apr 2021 13:49:01 +0200
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
Subject: Re: [RFC Part1 PATCH 13/13] x86/kernel: add support to validate
 memory when changing C-bit
Message-ID: <20210412114901.GB24283@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-14-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-14-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:24AM -0500, Brijesh Singh wrote:
> @@ -161,3 +162,108 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
>  	 /* Ask hypervisor to make the memory shared in the RMP table. */
>  	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
>  }
> +
> +static int snp_page_state_vmgexit(struct ghcb *ghcb, struct snp_page_state_change *data)

That function name definitely needs changing. The
vmgexit_page_state_change() one too. They're currenty confusing as hell
and I can't know what each one does without looking at its function
body.

> +{
> +	struct snp_page_state_header *hdr;
> +	int ret = 0;
> +
> +	hdr = &data->header;
> +
> +	/*
> +	 * The hypervisor can return before processing all the entries, the loop below retries
> +	 * until all the entries are processed.
> +	 */
> +	while (hdr->cur_entry <= hdr->end_entry) {

This doesn't make any sense: snp_set_page_state() builds a "set" of
pages to change their state in a loop and this one iterates *again* over
*something* which I'm not even clear on what.

Is something setting cur_entry to end_entry eventually?

In any case, why not issue those page state changes one-by-one in
snp_set_page_state() or is it possible that HV can do a couple of
them in one go so you have to poke it here until it sets cur_entry ==
end_entry?

> +		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));

Why do you have to call that here for every loop iteration...

> +		ret = vmgexit_page_state_change(ghcb, data);

.... and in that function too?!

> +		/* Page State Change VMGEXIT can pass error code through exit_info_2. */
> +		if (ret || ghcb->save.sw_exit_info_2)
> +			break;
> +	}
> +
> +	return ret;

You don't need that ret variable - just return value directly.

> +}
> +
> +static void snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
> +{
> +	unsigned long paddr_end, paddr_next;
> +	struct snp_page_state_change *data;
> +	struct snp_page_state_header *hdr;
> +	struct snp_page_state_entry *e;
> +	struct ghcb_state state;
> +	struct ghcb *ghcb;
> +	int ret, idx;
> +
> +	paddr = paddr & PAGE_MASK;
> +	paddr_end = paddr + (npages << PAGE_SHIFT);
> +
> +	ghcb = sev_es_get_ghcb(&state);

That function can return NULL.

> +	data = (struct snp_page_state_change *)ghcb->shared_buffer;
> +	hdr = &data->header;
> +	e = &(data->entry[0]);

So

	e = data->entry;

?

> +	memset(data, 0, sizeof (*data));
> +
> +	for (idx = 0; paddr < paddr_end; paddr = paddr_next) {

As before, a while loop pls.

> +		int level = PG_LEVEL_4K;

Why does this needs to happen on each loop iteration? It looks to me you
wanna do below:

	e->pagesize = X86_RMP_PG_LEVEL(PG_LEVEL_4K);

instead.

> +
> +		/* If we cannot fit more request then issue VMGEXIT before going further.  */
				   any more requests

No "we" pls.


> +		if (hdr->end_entry == (SNP_PAGE_STATE_CHANGE_MAX_ENTRY - 1)) {
> +			ret = snp_page_state_vmgexit(ghcb, data);
> +			if (ret)
> +				goto e_fail;

WARN

> +
> +			idx = 0;
> +			memset(data, 0, sizeof (*data));
> +			e = &(data->entry[0]);
> +		}

The order of the operations in this function looks weird: what you
should do is:

	- clear stuff, memset etc.
	- build shared buffer
	- issue vmgexit

so that you don't have the memset and e reinit twice and the flow can
be more clear and you don't have two snp_page_state_vmgexit() function
calls when there's a trailing set of entries which haven't reached
SNP_PAGE_STATE_CHANGE_MAX_ENTRY.

Maybe a double-loop or so.

...

> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 16f878c26667..19ee18ddbc37 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -27,6 +27,8 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/mem_encrypt.h>
> +#include <asm/sev-snp.h>
>  
>  #include "../mm_internal.h"
>  
> @@ -2001,8 +2003,25 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	 */
>  	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
>  
> +	/*
> +	 * To maintain the security gurantees of SEV-SNP guest invalidate the memory before
> +	 * clearing the encryption attribute.
> +	 */

Align that comment on 80 cols, just like the rest of the comments do in
this file. Below too.

> +	if (sev_snp_active() && !enc) {

Push that sev_snp_active() inside the function. Below too.

> +		ret = snp_set_memory_shared(addr, numpages);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret = __change_page_attr_set_clr(&cpa, 1);
>  
> +	/*
> +	 * Now that memory is mapped encrypted in the page table, validate the memory range before
> +	 * we return from here.
> +	 */
> +	if (!ret && sev_snp_active() && enc)
> +		ret = snp_set_memory_private(addr, numpages);
> +
>  	/*
>  	 * After changing the encryption attribute, we need to flush TLBs again
>  	 * in case any speculative TLB caching occurred (but no need to flush

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
