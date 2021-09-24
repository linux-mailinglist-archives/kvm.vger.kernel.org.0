Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B02416F83
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbhIXJvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 05:51:37 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56210 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245340AbhIXJvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 05:51:37 -0400
Received: from zn.tnic (p200300ec2f0dd600d43e805889b23e24.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:d600:d43e:8058:89b2:3e24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7CF6F1EC0545;
        Fri, 24 Sep 2021 11:49:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632476998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BUpgk3dKEy8b32WZnzp1rzB730dZntv9H5UAz8bOGWk=;
        b=lBrUymj/1QmZ4FQNJqYn/gxECEVEdHAREMp+ape5AjP0I4nJev+JIBIrOD29llxaI00Fe2
        P14LnS7io2ZUdJ2JtgJTB2P4u9GLS4VrR09dA9mKUHmwTDVTTtQQMzpkB/jRIc6iuVq8/S
        HyIw7qYuftFTRUW4mi2RTSTAobe14Do=
Date:   Fri, 24 Sep 2021 11:49:52 +0200
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
Subject: Re: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
Message-ID: <YU2fQMgw+PIBzSE4@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-5-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-5-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:37AM -0500, Brijesh Singh wrote:
> +struct __packed rmpentry {
> +	union {
> +		struct {
> +			u64	assigned	: 1,
> +				pagesize	: 1,
> +				immutable	: 1,
> +				rsvd1		: 9,
> +				gpa		: 39,
> +				asid		: 10,
> +				vmsa		: 1,
> +				validated	: 1,
> +				rsvd2		: 1;
> +		} info;
> +		u64 low;
> +	};
> +	u64 high;
> +};

__packed goes at the end of the struct definition.

> +
> +#define rmpentry_assigned(x)	((x)->info.assigned)
> +#define rmpentry_pagesize(x)	((x)->info.pagesize)

Inline functions pls so that you can get typechecking too.

>  
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 7936c8139c74..f383d2a89263 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -54,6 +54,8 @@
>   * bookkeeping, the range need to be added during the RMP entry lookup.
>   */
>  #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +#define RMPENTRY_SHIFT			8
> +#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ + (((unsigned long)x) >> RMPENTRY_SHIFT))
>  
>  /* For early boot hypervisor communication in SEV-ES enabled guests */
>  static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
> @@ -2376,3 +2378,44 @@ static int __init snp_rmptable_init(void)
>   * available after subsys_initcall().
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +	unsigned long vaddr, paddr = pfn << PAGE_SHIFT;
> +	struct rmpentry *entry, *large_entry;
> +
> +	if (!pfn_valid(pfn))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return ERR_PTR(-ENXIO);

I think that check should happen first.

> +
> +	vaddr = rmptable_start + rmptable_page_offset(paddr);
> +	if (unlikely(vaddr > rmptable_end))
> +		return ERR_PTR(-ENXIO);

Maybe the above -E should be -ENOENT instead so that you have unique
error types for each check to facilitate debugging.

> +
> +	entry = (struct rmpentry *)vaddr;
> +
> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */

That comment needs rewriting.

> +	vaddr = rmptable_start + rmptable_page_offset(paddr & PMD_MASK);
> +	large_entry = (struct rmpentry *)vaddr;
> +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(large_entry));
> +
> +	return entry;
> +}
> +
> +/*
> + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
> + * and -errno if there is no corresponding RMP entry.
> + */

kernel-doc format since it is being exported.

> +int snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +	struct rmpentry *e;
> +
> +	e = __snp_lookup_rmpentry(pfn, level);
> +	if (IS_ERR(e))
> +		return PTR_ERR(e);
> +
> +	return !!rmpentry_assigned(e);
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);

This export is for kvm, I presume?

> diff --git a/include/linux/sev.h b/include/linux/sev.h
> new file mode 100644
> index 000000000000..1a68842789e1
> --- /dev/null
> +++ b/include/linux/sev.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AMD Secure Encrypted Virtualization
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#ifndef __LINUX_SEV_H
> +#define __LINUX_SEV_H
> +
> +/* RMUPDATE detected 4K page and 2MB page overlap. */
> +#define RMPUPDATE_FAIL_OVERLAP		7
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +int snp_lookup_rmpentry(u64 pfn, int *level);
> +int psmash(u64 pfn);
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
> +int rmp_make_shared(u64 pfn, enum pg_level level);
> +#else
> +static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
> +static inline int psmash(u64 pfn) { return -ENXIO; }
> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
> +				   bool immutable)
> +{
> +	return -ENODEV;
> +}
> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +
> +#endif /* CONFIG_AMD_MEM_ENCRYPT */
> +#endif /* __LINUX_SEV_H */
> -- 

What is going to use this linux/ namespace header?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
