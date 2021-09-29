Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549E041CC04
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 20:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346328AbhI2SkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346286AbhI2SkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 14:40:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DF4C06161C;
        Wed, 29 Sep 2021 11:38:36 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bd10085b5178de8b08a0e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:85b5:178d:e8b0:8a0e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2F3AD1EC0136;
        Wed, 29 Sep 2021 20:38:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632940715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Bo+gAEaB3c3ilgMX8OgreD8PMGNiwY4UFgAUH1GnA0M=;
        b=BX2CAl3ohCbYKJL64okCa2H8GmBJcotMMGimHp4e44UXgDWZIafY5Ao8UiKadDFMQALdAS
        gIdU97e8g1oAMrREVviFDVlwyhtq/V1wr/uhEtNyNGYdP92oJjJPdwINQnMqgBCa8WEObR
        NziEBHyhnhpkYJ/9PGQskFQSTwbjg00=
Date:   Wed, 29 Sep 2021 20:38:31 +0200
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
Subject: Re: [PATCH Part2 v5 09/45] x86/fault: Add support to dump RMP entry
 on fault
Message-ID: <YVSyp0emhzQeMzI4@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-10-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-10-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:42AM -0500, Brijesh Singh wrote:
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
> index 92ced9626e95..569294f687e6 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -106,6 +106,11 @@ struct __packed rmpentry {
>  
>  #define rmpentry_assigned(x)	((x)->info.assigned)
>  #define rmpentry_pagesize(x)	((x)->info.pagesize)
> +#define rmpentry_vmsa(x)	((x)->info.vmsa)
> +#define rmpentry_asid(x)	((x)->info.asid)
> +#define rmpentry_validated(x)	((x)->info.validated)
> +#define rmpentry_gpa(x)		((unsigned long)(x)->info.gpa)
> +#define rmpentry_immutable(x)	((x)->info.immutable)

If some of those accessors are going to be used only in dump_rmpentry(),
then you don't really need them.

>  
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
> @@ -165,6 +170,7 @@ void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op
>  void snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
>  void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
>  void snp_set_wakeup_secondary_cpu(void);
> +void dump_rmpentry(u64 pfn);
>  #ifdef __BOOT_COMPRESSED
>  bool sev_snp_enabled(void);
>  #else
> @@ -188,6 +194,7 @@ static inline void snp_set_memory_shared(unsigned long vaddr, unsigned int npage
>  static inline void snp_set_memory_private(unsigned long vaddr, unsigned int npages) { }
>  static inline void snp_set_wakeup_secondary_cpu(void) { }
>  static inline void sev_snp_cpuid_init(struct boot_params *bp) { }
> +static inline void dump_rmpentry(u64 pfn) {}
>  #ifdef __BOOT_COMPRESSED
>  static inline bool sev_snp_enabled { return false; }
>  #else
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index bad41deb8335..8b3e83e50468 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2404,6 +2404,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
>  	return entry;
>  }
>  
> +void dump_rmpentry(u64 pfn)

snp_dump_rmpentry()

> +{
> +	unsigned long pfn_end;
> +	struct rmpentry *e;
> +	int level;
> +
> +	e = __snp_lookup_rmpentry(pfn, &level);
> +	if (!e) {
> +		pr_alert("failed to read RMP entry pfn 0x%llx\n", pfn);
> +		return;
> +	}
> +
> +	if (rmpentry_assigned(e)) {
> +		pr_alert("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
> +			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,

WARNING: quoted string split across lines
#174: FILE: arch/x86/kernel/sev.c:2421:
+		pr_alert("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
+			" asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,

> +			rmpentry_assigned(e), rmpentry_immutable(e), rmpentry_pagesize(e),
> +			rmpentry_gpa(e), rmpentry_asid(e), rmpentry_vmsa(e),
> +			rmpentry_validated(e));
> +		return;
> +	}
> +
> +	/*
> +	 * If the RMP entry at the faulting pfn was not assigned, then we do not
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

return? You mean "continue;" ?

> +
> +		if (e->low || e->high)
> +			pr_alert("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				 pfn << PAGE_SHIFT, e->high, e->low);
> +		pfn++;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dump_rmpentry);

Why is that exported? Some module will be calling it too?

> +
>  /*
>   * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
>   * and -errno if there is no corresponding RMP entry.
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f2d543b92f43..9cd33169dfb5 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -33,6 +33,7 @@
>  #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
>  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
>  #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
> +#include <asm/sev.h>			/* dump_rmpentry()		*/
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -289,7 +290,7 @@ static bool low_pfn(unsigned long pfn)
>  	return pfn < max_low_pfn;
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static void dump_pagetable(unsigned long address, bool show_rmpentry)

I think passing in error_code and testing X86_PF_RMP inside should
make this a bit more palatable than simply "grafting" SNP-specific
functionality to generic paths.

Thx. 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
