Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5631C72CB1B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjFLQMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjFLQMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 12:12:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177F122;
        Mon, 12 Jun 2023 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686586335; x=1718122335;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5KFn1g9QXL7PSHf/uoACePAASUQ7zOXitZhS2hdbsts=;
  b=eIsi7I1tZtMujWSaFatzxDusk0d3+vR2DmgDuCmEFkpgwsNg73Dddle5
   LnSUbxm3g0ggPeQ12W0CF4XLGGakfeeSq4McwjknsGXw9TApCEbqNqQ5L
   Nj7WORkiWL72XV58drE5WMQ5TVdjZ6PyslJdAFVWRizSDzduQ/Gv3kpu3
   IF8mIn01QJ1F6LDddF2Yb/G3llOh/y3IARZWkVXPJqQBTPD9yVn6EXi/c
   SGYVjDW6ZgaDXVi4buffTR4l9MAb3Z+rf7P/6llEdOW5q2NxDAW+UTMTh
   J41yN3Brdk17ZSlE63U5IkEtlUDU8IJn/Ol9jqD5QakYzoIhU0ETqCOZG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="337723191"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="337723191"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="801072508"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="801072508"
Received: from spmantha-mobl1.amr.corp.intel.com (HELO [10.209.43.2]) ([10.209.43.2])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:08:59 -0700
Message-ID: <59d5ca67-6a31-1929-8d2f-0e3314626893@intel.com>
Date:   Mon, 12 Jun 2023 09:08:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 09/51] x86/sev: Add RMP entry lookup helpers
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-10-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230612042559.375660-10-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/23 21:25, Michael Roth wrote:
> +/*
> + * The RMP entry format is not architectural. The format is defined in PPR
> + * Family 19h Model 01h, Rev B1 processor.
> + */
> +struct rmpentry {
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
> +} __packed;

What's 'high' used for?  The PPR says it's reserved.  Why not call it
reserved?

It _looks_ like it's only used for a debugging pr_info().  It makes the
struct look kinda goofy.  I'd much rather limit the goofiness to the
"dumping" code, like:

     u64 *__e = (void *)e;
     ....
     pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
                               pfn << PAGE_SHIFT, __e[0], __e[1]);

BTW, why does it do any good to dump all these reserved fields?

>  /*
>   * The first 16KB from the RMP_BASE is used by the processor for the
>   * bookkeeping, the range needs to be added during the RMP entry lookup.
>   */
>  #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> +#define RMPENTRY_SHIFT			8
> +#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ +		\
> +				 (((unsigned long)x) >> RMPENTRY_SHIFT))

Is RMPENTRY_SHIFT just log2(sizeof(struct rmpentry))?  If so, wouldn't
this be a *LOT* more obvious to be written:

unsigned long rmptable_offset(unsigned long paddr)
{
	return 	RMPTABLE_CPU_BOOKKEEPING_SZ +
		paddr / sizeof(struct rmpentry);
}

??

It removes a cast, gives 'x' a real name, removes a random magic number
#define and is clearer to boot.

>  static unsigned long rmptable_start __ro_after_init;
>  static unsigned long rmptable_end __ro_after_init;
> @@ -210,3 +235,63 @@ static int __init snp_rmptable_init(void)
>   * the page(s) used for DMA are hypervisor owned.
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +static inline unsigned int rmpentry_assigned(const struct rmpentry *e)
> +{
> +	return e->info.assigned;
> +}
> +
> +static inline unsigned int rmpentry_pagesize(const struct rmpentry *e)
> +{
> +	return e->info.pagesize;
> +}

I think these are a little silly.  If you're going to go to the trouble
of using bitfields, you don't need helpers for every bitfield.  I say
either use bitfields without helpers or just regular old:

#define RMPENTRY_ASSIGNED_MASK	BIT(1)

and then *maybe* you can make helpers for them.

> +static int rmptable_entry(unsigned long paddr, struct rmpentry *entry)
> +{
> +	unsigned long vaddr;
> +
> +	vaddr = rmptable_start + rmptable_page_offset(paddr);
> +	if (unlikely(vaddr > rmptable_end))
> +		return -EFAULT;

This seems like more of a WARN_ON_ONCE() kind of thing than just an
error return.  Isn't it a big deal if an invalid (non-RMP-covered)
address makes it in here?

> +	*entry = *(struct rmpentry *)vaddr;
> +
> +	return 0;
> +}
> +
> +static int __snp_lookup_rmpentry(u64 pfn, struct rmpentry *entry, int *level)
> +{

I've been bitten by pfn vs. paddr quite a few times.  I'd really
encourage you to add it to the names if you're going to pass them
around, like __snp_lookup_rmpentry_pfn().

> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	struct rmpentry large_entry;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;

OK, so if you're running on non-SNP hardware, you return -ENXIO here.
Remember this please.

> +	ret = rmptable_entry(paddr, entry);
> +	if (ret)
> +		return ret;
> +
> +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
> +	ret = rmptable_entry(paddr & PMD_MASK, &large_entry);
> +	if (ret)
> +		return ret;
> +
> +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(&large_entry));
> +
> +	return 0;
> +}

This is a bit weird.  Should it say something like this?

To do an 4k RMP lookup the hardware looks at two places in the RMP:

	1. The actual 4k RMP entry
	2. The 2M entry that "covers" the 4k entry

The page size is not indicated in the 4k entries at all.  It is solely
indicated by the 2M entry.

> +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
> +{
> +	struct rmpentry e;
> +	int ret;
> +
> +	ret = __snp_lookup_rmpentry(pfn, &e, level);
> +	if (ret)
> +		return ret;
> +
> +	*assigned = !!rmpentry_assigned(&e);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..bf0378136289 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -171,4 +171,8 @@ struct snp_psc_desc {
>  #define GHCB_ERR_INVALID_INPUT		5
>  #define GHCB_ERR_INVALID_EVENT		6
>  
> +/* RMP page size */
> +#define RMP_PG_SIZE_4K			0
> +#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +
>  #endif
> diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> new file mode 100644
> index 000000000000..30d47e20081d
> --- /dev/null
> +++ b/arch/x86/include/asm/sev-host.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AMD SVM-SEV Host Support.
> + *
> + * Copyright (C) 2023 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + *
> + */
> +
> +#ifndef __ASM_X86_SEV_HOST_H
> +#define __ASM_X86_SEV_HOST_H
> +
> +#include <asm/sev-common.h>
> +
> +#ifdef CONFIG_KVM_AMD_SEV
> +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
> +#else
> +static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
> +#endif

Above, -ENXIO was returned when SEV-SNP was not supported.  Here, 0 is
returned when it is compiled out.  That inconsistent.

Is snp_lookup_rmpentry() acceptable when SEV-SNP is in play?  I'd like
to see consistency between when it is compiled out and when it is
compiled in but unsupported on the CPU.

> +#endif
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index d34c46db7dd1..446fc7a9f7b0 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,9 +81,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  /* Software defined (when rFlags.CF = 1) */
>  #define PVALIDATE_FAIL_NOUPDATE		255
>  
> -/* RMP page size */
> -#define RMP_PG_SIZE_4K			0
> -
>  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>  
>  /* SNP Guest message request */

