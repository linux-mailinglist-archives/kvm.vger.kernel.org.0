Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5824559E825
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245598AbiHWQxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 12:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242879AbiHWQxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:53:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A38131A02;
        Tue, 23 Aug 2022 06:21:39 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9893329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9893:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CA7901EC059D;
        Tue, 23 Aug 2022 15:21:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661260893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=88b9dtw5SGZz9ByR4SVq5jtelPnssUL5tht/iXbNMr0=;
        b=pdIFFaLF2Q5y9bCJ1IXNDS6T4Wx4YgPc/b9z/mTBbXwTqFdUzRZMyThTsuC8nQblA+NIw+
        yLDo4nIEPl/nfBvIJrqm5PSxkopiA4U0cqHMfliR6HYmWQcLLLGLR9WlAvXHJ9LuGWac95
        qZyJxJ6DZFrPdZlQdErBqscKg5MLx5I=
Date:   Tue, 23 Aug 2022 15:21:29 +0200
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
Subject: Re: [PATCH Part2 v6 10/49] x86/fault: Add support to dump RMP entry
 on fault
Message-ID: <YwTUWUkDVW+936VR@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:58PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled globally, a write from the host goes through the
> RMP check. If the hardware encounters the check failure, then it raises
> the #PF (with RMP set). Dump the RMP entry at the faulting pfn to help
> the debug.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  7 +++++++
>  arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/fault.c        | 17 +++++++++++----
>  include/linux/sev.h        |  2 ++
>  4 files changed, 65 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 6ab872311544..c0c4df817159 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -113,6 +113,11 @@ struct __packed rmpentry {
>  
>  #define rmpentry_assigned(x)	((x)->info.assigned)
>  #define rmpentry_pagesize(x)	((x)->info.pagesize)
> +#define rmpentry_vmsa(x)	((x)->info.vmsa)
> +#define rmpentry_asid(x)	((x)->info.asid)
> +#define rmpentry_validated(x)	((x)->info.validated)
> +#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
> +#define rmpentry_immutable(x)	((x)->info.immutable)

If you're going to do that, use inline functions pls so that it checks
the argument at least.

Also, add such functions only when they're called multiple times - no
need to add one for every field if you're going to access that field
only once in the whole kernel.

>  
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
> @@ -205,6 +210,7 @@ void snp_set_wakeup_secondary_cpu(void);
>  bool snp_init(struct boot_params *bp);
>  void snp_abort(void);
>  int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
> +void dump_rmpentry(u64 pfn);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -229,6 +235,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
>  {
>  	return -ENOTTY;
>  }
> +static inline void dump_rmpentry(u64 pfn) {}
>  #endif
>  
>  #endif
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 734cddd837f5..6640a639fffc 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2414,6 +2414,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
>  	return entry;
>  }
>  
> +void dump_rmpentry(u64 pfn)

External function - it better belong to a namespace:

sev_dump_rmpentry()

> +{
> +	unsigned long pfn_end;
> +	struct rmpentry *e;
> +	int level;
> +
> +	e = __snp_lookup_rmpentry(pfn, &level);
> +	if (!e) {
> +		pr_alert("failed to read RMP entry pfn 0x%llx\n", pfn);

Why alert?

Dumping stuff is either pr_debug or pr_info...

> +		return;
> +	}
> +
> +	if (rmpentry_assigned(e)) {
> +		pr_alert("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
> +			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
> +			rmpentry_assigned(e), rmpentry_immutable(e), rmpentry_pagesize(e),
> +			rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
> +			rmpentry_validated(e));
> +		return;
> +	}
> +
> +	/*
> +	 * If the RMP entry at the faulting pfn was not assigned, then we do not

Who's "we"?

> +	 * know what caused the RMP violation. To get some useful debug information,
> +	 * let iterate through the entire 2MB region, and dump the RMP entries if
> +	 * one of the bit in the RMP entry is set.
> +	 */
> +	pfn = pfn & ~(PTRS_PER_PMD - 1);
> +	pfn_end = pfn + PTRS_PER_PMD;
> +
> +	while (pfn < pfn_end) {
> +		e = __snp_lookup_rmpentry(pfn, &level);
> +		if (!e)
> +			return;
> +
> +		if (e->low || e->high)

This is going to confuse people because they're going to miss a zero
entry. Just dump the whole thing.

...

> @@ -579,7 +588,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
>  		show_ldttss(&gdt, "TR", tr);
>  	}
>  
> -	dump_pagetable(address);
> +	dump_pagetable(address, error_code & X86_PF_RMP);

Eww.

I'd prefer to see

	pfn = dump_pagetable(address);

	if (error_code & X86_PF_RMP)
		sev_dump_rmpentry(pfn);

instead of passing around this SEV-specific arg in generic x86 fault code.

The change to return the pfn from dump_pagetable() should be a pre-patch ofc.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
