Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E082416E56
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245011AbhIXI7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:59:48 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39176 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244621AbhIXI7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 04:59:47 -0400
Received: from zn.tnic (p200300ec2f0dd600c2485b7778a62ff5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:d600:c248:5b77:78a6:2ff5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9AB971EC0301;
        Fri, 24 Sep 2021 10:58:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632473889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zbrXJ+Aq13n8UVfal2GI8gct0tLpzbzh+GqS6QUuaMw=;
        b=aFqyiPJTWFX5uUkQhS+kBmP+bUUPiLH8EjyILF4GTVdoFvA6b2u+Fv6jA7UrmTcZtlIX5Q
        4iumgmzRgLKaqra0iHWdvpo5TmojDNzXZzOw02VdVjtF8sF2j1qAGy4+Xp/2xHgrNCj+d5
        reS24NO3h3kwUNszgz2e0/+E0rMt9nE=
Date:   Fri, 24 Sep 2021 10:58:03 +0200
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
Subject: Re: [PATCH Part2 v5 03/45] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <YU2TGxrpwMD8QLnk@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-4-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-4-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:36AM -0500, Brijesh Singh wrote:
> @@ -542,6 +544,10 @@
>  #define MSR_AMD64_SYSCFG		0xc0010010
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
>  #define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_EN_BIT		24
> +#define MSR_AMD64_SYSCFG_SNP_EN		BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT	25
> +#define MSR_AMD64_SYSCFG_SNP_VMPL_EN	BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)

While you're here, move all defines that belong to that MSR which
we decided it is architectural after all, above the definition of
MSR_AMD64_NB_CFG above.

>  #define MSR_K8_INT_PENDING_MSG		0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index ab17c93634e9..7936c8139c74 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -24,6 +24,8 @@
>  #include <linux/sev-guest.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> +#include <linux/cpumask.h>
> +#include <linux/iommu.h>
>  
>  #include <asm/cpu_entry_area.h>
>  #include <asm/stacktrace.h>
> @@ -40,11 +42,19 @@
>  #include <asm/efi.h>
>  #include <asm/cpuid.h>
>  #include <asm/setup.h>
> +#include <asm/apic.h>
> +#include <asm/iommu.h>
>  
>  #include "sev-internal.h"
>  
>  #define DR7_RESET_VALUE        0x400
>  
> +/*
> + * The first 16KB from the RMP_BASE is used by the processor for the

s/for the/for/

> + * bookkeeping, the range need to be added during the RMP entry lookup.

s/need/needs/ ... s/during the/during /

> + */
> +#define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000

Too long: just call it RMP_BASE_OFFSET.

> +static bool get_rmptable_info(u64 *start, u64 *len)
> +{
> +	u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
> +
> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
> +
> +	if (!rmp_base || !rmp_end) {
> +		pr_info("Memory for the RMP table has not been reserved by BIOS\n");
> +		return false;
> +	}
> +
> +	rmp_sz = rmp_end - rmp_base + 1;
> +
> +	/*
> +	 * Calculate the amount the memory that must be reserved by the BIOS to
> +	 * address the full system RAM. The reserved memory should also cover the
> +	 * RMP table itself.
> +	 *
> +	 * See PPR Family 19h Model 01h, Revision B1 section 2.1.5.2 for more
> +	 * information on memory requirement.
> +	 */
> +	nr_pages = totalram_pages();
> +	calc_rmp_sz = (((rmp_sz >> PAGE_SHIFT) + nr_pages) << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;

use totalram_pages() directly here - nr_pages is assigned to only once.

> +
> +	if (calc_rmp_sz > rmp_sz) {
> +		pr_info("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
> +			calc_rmp_sz, rmp_sz);
> +		return false;
> +	}
> +
> +	*start = rmp_base;
> +	*len = rmp_sz;
> +
> +	pr_info("RMP table physical address 0x%016llx - 0x%016llx\n", rmp_base, rmp_end);

		"RMP table physical address range: [ ... - ... ]\n", ...

...

> +/*
> + * This must be called after the PCI subsystem. This is because before enabling
> + * the SNP feature we need to ensure that IOMMU supports the SEV-SNP feature.

"... it needs to be ensured that... "

> + * The iommu_sev_snp_support() is used for checking the feature, and it is
> + * available after subsys_initcall().
> + */
> +fs_initcall(snp_rmptable_init);
> -- 
> 2.17.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
