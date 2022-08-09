Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDF858DC92
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiHIQz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 12:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245147AbiHIQzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 12:55:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080F7219C;
        Tue,  9 Aug 2022 09:55:52 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9800329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9800:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 846E71EC04DA;
        Tue,  9 Aug 2022 18:55:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660064147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=i7kJIpddtAemUYbgwpjR+4WVlcQgX2AjGxouk8jTwJY=;
        b=blu9wbGO3QfuTP67zh1c5NXyUm2UZXKneyuQAV4DlBW+3FkBSt5IQS+Wsj9rXAky4XiOeq
        PddJJlBMbTiPpLXr3YFUe18BbIi8o3W2ISdjJoFT1eyE/B449QmkPRcoLI2WIAsad/DRrv
        igZVfxy8u8RHoHuNCxklMtQTvkICyCA=
Date:   Tue, 9 Aug 2022 18:55:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YvKRjxgipxLSNCLe@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled globally, a write from the host goes through the

globally?

Can SNP be even enabled any other way?

I see the APM talks about it being enabled globally, I guess this means
the RMP represents *all* system memory?

> @@ -1209,6 +1210,60 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
>  }
>  NOKPROBE_SYMBOL(do_kern_addr_fault);
>  
> +static inline size_t pages_per_hpage(int level)
> +{
> +	return page_level_size(level) / PAGE_SIZE;
> +}
> +
> +/*
> + * Return 1 if the caller need to retry, 0 if it the address need to be split
> + * in order to resolve the fault.
> + */

Magic numbers.

Pls do instead:

enum rmp_pf_ret {
	RMP_PF_SPLIT	= 0,
	RMP_PF_RETRY	= 1,
};

and use those instead.

> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> +				      unsigned long address)
> +{
> +	int rmp_level, level;
> +	pte_t *pte;
> +	u64 pfn;
> +
> +	pte = lookup_address_in_mm(current->mm, address, &level);
> +
> +	/*
> +	 * It can happen if there was a race between an unmap event and
> +	 * the RMP fault delivery.
> +	 */

You need to elaborate more here: a RMP fault can happen and then the
page can get unmapped? What is the exact scenario here?

> +	if (!pte || !pte_present(*pte))
> +		return 1;
> +
> +	pfn = pte_pfn(*pte);
> +
> +	/* If its large page then calculte the fault pfn */
> +	if (level > PG_LEVEL_4K) {
> +		unsigned long mask;
> +
> +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> +		pfn |= (address >> PAGE_SHIFT) & mask;

Oh boy, this is unnecessarily complicated. Isn't this

	pfn |= pud_index(address);

or
	pfn |= pmd_index(address);

depending on the level?

I think it is but it needs more explaining.

In any case, those are two static masks exactly and they don't need to
be computed for each #PF.

> diff --git a/mm/memory.c b/mm/memory.c
> index 7274f2b52bca..c2187ffcbb8e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4945,6 +4945,15 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +static int handle_split_page_fault(struct vm_fault *vmf)
> +{
> +	if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
> +		return VM_FAULT_SIGBUS;

Yah, this looks weird: generic code implies that page splitting after a
#PF makes sense only when SEV is present and none otherwise.

Why?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
