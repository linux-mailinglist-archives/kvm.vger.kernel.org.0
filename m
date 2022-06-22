Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DC554D0A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358546AbiFVOa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358476AbiFVOaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:30:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBACF3D1FA;
        Wed, 22 Jun 2022 07:29:57 -0700 (PDT)
Received: from jpiotrowski-Surface-Book-3 (ip-037-201-214-204.um10.pools.vodafone-ip.de [37.201.214.204])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9AC3920C6373;
        Wed, 22 Jun 2022 07:29:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9AC3920C6373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655908197;
        bh=bVDr9RYnzo39JQHeopAO6RxPbu1Q/PG027aMK308rQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOc2OKiv3+v0ydBT5qmIFyFHOX1Mkeyz/Nrs+5/dczXKnanmkumFEqYmlp2XsH6Zt
         5ZdEYUSJbpCG8tKB9AcboxNHlGthWy9P4SLXbHCjtSo5IIMnEw0tdUlVtGLVtTYdnH
         GudTIHbBI+d/tKJtyZ4Bz2gQI47huA3c9BMviP7s=
Date:   Wed, 22 Jun 2022 16:29:43 +0200
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
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
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YrMnV7QLUpT1GQAj@jpiotrowski-Surface-Book-3>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:43PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled globally, a write from the host goes through the
> RMP check. When the host writes to pages, hardware checks the following
> conditions at the end of page walk:
> 
> 1. Assigned bit in the RMP table is zero (i.e page is shared).
> 2. If the page table entry that gives the sPA indicates that the target
>    page size is a large page, then all RMP entries for the 4KB
>    constituting pages of the target must have the assigned bit 0.
> 3. Immutable bit in the RMP table is not zero.
> 
> The hardware will raise page fault if one of the above conditions is not
> met. Try resolving the fault instead of taking fault again and again. If
> the host attempts to write to the guest private memory then send the
> SIGBUS signal to kill the process. If the page level between the host and
> RMP entry does not match, then split the address to keep the RMP and host
> page levels in sync.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/mm/fault.c      | 66 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mm.h       |  3 +-
>  include/linux/mm_types.h |  3 ++
>  mm/memory.c              | 13 ++++++++
>  4 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index a4c270e99f7f..f5de9673093a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -19,6 +19,7 @@
>  #include <linux/uaccess.h>		/* faulthandler_disabled()	*/
>  #include <linux/efi.h>			/* efi_crash_gracefully_on_page_fault()*/
>  #include <linux/mm_types.h>
> +#include <linux/sev.h>			/* snp_lookup_rmpentry()	*/
>  
>  #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
>  #include <asm/traps.h>			/* dotraplinkage, ...		*/
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
> +	}
> +
> +	/*
> +	 * If its a guest private page, then the fault cannot be resolved.
> +	 * Send a SIGBUS to terminate the process.
> +	 */
> +	if (snp_lookup_rmpentry(pfn, &rmp_level)) {

snp_lookup_rmpentry returns 0, 1 or -errno, so this should likely be:

  if (snp_lookup_rmpentry(pfn, &rmp_level) != 1)) {

> +		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
> +		return 1;
> +	}
> +
> +	/*
> +	 * The backing page level is higher than the RMP page level, request
> +	 * to split the page.
> +	 */
> +	if (level > rmp_level)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  /*
>   * Handle faults in the user portion of the address space.  Nothing in here
>   * should check X86_PF_USER without a specific justification: for almost
> @@ -1306,6 +1361,17 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (error_code & X86_PF_INSTR)
>  		flags |= FAULT_FLAG_INSTRUCTION;
>  
> +	/*
> +	 * If its an RMP violation, try resolving it.
> +	 */
> +	if (error_code & X86_PF_RMP) {
> +		if (handle_user_rmp_page_fault(regs, error_code, address))
> +			return;
> +
> +		/* Ask to split the page */
> +		flags |= FAULT_FLAG_PAGE_SPLIT;
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	/*
>  	 * Faults in the vsyscall page might need emulation.  The
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index de32c0383387..2ccc562d166f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -463,7 +463,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
>  	{ FAULT_FLAG_USER,		"USER" }, \
>  	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
>  	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
> -	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
> +	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
> +	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
>  
>  /*
>   * vm_fault is filled by the pagefault handler and passed to the vma's
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6dfaf271ebf8..aa2d8d48ce3e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -818,6 +818,8 @@ typedef struct {
>   *                      mapped R/O.
>   * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
>   *                        We should only access orig_pte if this flag set.
> + * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the
> + *                         region to smaller page size and retry.
>   *
>   * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
>   * whether we would allow page faults to retry by specifying these two
> @@ -855,6 +857,7 @@ enum fault_flag {
>  	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
>  	FAULT_FLAG_UNSHARE =		1 << 10,
>  	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
> +	FAULT_FLAG_PAGE_SPLIT =		1 << 12,
>  };
>  
>  typedef unsigned int __bitwise zap_flags_t;
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
> +
> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	return 0;
> +}
> +
>  /*
>   * By the time we get here, we already hold the mm semaphore
>   *
> @@ -5024,6 +5033,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  				pmd_migration_entry_wait(mm, vmf.pmd);
>  			return 0;
>  		}
> +
> +		if (flags & FAULT_FLAG_PAGE_SPLIT)
> +			return handle_split_page_fault(&vmf);
> +
>  		if (pmd_trans_huge(vmf.orig_pmd) || pmd_devmap(vmf.orig_pmd)) {
>  			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
>  				return do_huge_pmd_numa_page(&vmf);
> -- 
> 2.25.1
> 
