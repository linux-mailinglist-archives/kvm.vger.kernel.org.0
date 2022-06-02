Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D9553B876
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiFBL7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiFBL7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 07:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B96713C1C9;
        Thu,  2 Jun 2022 04:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A77616ED;
        Thu,  2 Jun 2022 11:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC475C385A5;
        Thu,  2 Jun 2022 11:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654171163;
        bh=7wB+JR5L26iDvtyWDCetlIK56JTTRdnWPOpw4hq0hUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKIyrmFq1Njrtb0hkqfMBDD7/axk70SVWIc24ndvLN5aOOHN75sVLOBegWJC2SESb
         qFX0I/Gdw7tvBLWoqsESOzEc5e9VZUwY/xy1zIBRJy7k/+IEVXwoZjf+h2OpS7JMT6
         Y1Al7wRSciVyot0vRc4H97bfIX8T1OVJqWo/zJg3h7ryDCH+Nl9e8RfT587T86EjHY
         H5W+spyZqm4jcp00H306fFAEPzS2OtSLdHWqgSve3NAWIr4/sY52Vt0dmIh49UFfPG
         V0hlPs87m+HgmekoaHiVIehSiDdFXyyHOJJlEblkIhhBMWyEzUwTmgqWlrJeQF3lEr
         OBcEnyFOChQbA==
Date:   Thu, 2 Jun 2022 14:57:31 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
Message-ID: <Ypilq47Tsd8ThPU9@kernel.org>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-5-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-5-brijesh.singh@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:37AM -0500, Brijesh Singh wrote:
> The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> entry for a given page. The RMP entry format is documented in AMD PPR, see
> https://bugzilla.kernel.org/attachment.cgi?id=296015.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 27 ++++++++++++++++++++++++
>  arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
>  include/linux/sev.h        | 30 ++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
>  create mode 100644 include/linux/sev.h
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index a5f0a1c3ccbe..5b1a6a075c47 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -9,6 +9,7 @@
>  #define __ASM_ENCRYPTED_STATE_H
>  
>  #include <linux/types.h>
> +#include <linux/sev.h>
>  #include <asm/insn.h>
>  #include <asm/sev-common.h>
>  #include <asm/bootparam.h>
> @@ -77,6 +78,32 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +
> +/*
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
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
> +
> +#define rmpentry_assigned(x)	((x)->info.assigned)
> +#define rmpentry_pagesize(x)	((x)->info.pagesize)
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
> +
> +	vaddr = rmptable_start + rmptable_page_offset(paddr);
> +	if (unlikely(vaddr > rmptable_end))
> +		return ERR_PTR(-ENXIO);
> +
> +	entry = (struct rmpentry *)vaddr;
> +
> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
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

According to /usr/include/asm-generic/errno.h, there is 133
error codes. Why you need so many just to say that there
is no entry?

> + */
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

nit: this is redundant.

Each git commit has an author-field.

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
> 2.17.1
> 

BR, Jarkko
