Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD61349483
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 15:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCYOs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 10:48:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:18661 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhCYOs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 10:48:56 -0400
IronPort-SDR: jHzH3NkdsGAmoIkh/nWGpkNJkqYgh14Sle6FCO2BbsHPYkLBtdjOd/ZqNM5p7g0BC3F4yyoqbW
 sBWeMv6INcPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="254939201"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="254939201"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 07:48:55 -0700
IronPort-SDR: 656WrnzVakOkOImrR3o2UA+mvX/X/E9uvoRkEj5cB8+qIoLrVH2WG70uivgK/rOv4ngjJqfyrE
 L2GjwTiV80xg==
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="391757566"
Received: from jeffche1-mobl.amr.corp.intel.com (HELO [10.209.73.71]) ([10.209.73.71])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 07:48:55 -0700
Subject: Re: [RFC Part2 PATCH 07/30] mm: add support to split the large THP
 based on RMP violation
To:     Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-8-brijesh.singh@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <0edd1350-4865-dd71-5c14-3d57c784d62d@intel.com>
Date:   Thu, 25 Mar 2021 07:48:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210324170436.31843-8-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/21 10:04 AM, Brijesh Singh wrote:
> When SEV-SNP is enabled globally in the system, a write from the hypervisor
> can raise an RMP violation. We can resolve the RMP violation by splitting
> the virtual address to a lower page level.
> 
> e.g
> - guest made a page shared in the RMP entry so that the hypervisor
>   can write to it.
> - the hypervisor has mapped the pfn as a large page. A write access
>   will cause an RMP violation if one of the pages within the 2MB region
>   is a guest private page.
> 
> The above RMP violation can be resolved by simply splitting the large
> page.

What if the large page is provided by hugetlbfs?

What if the kernel uses the direct map to access the page instead of the
userspace mapping?

> The architecture specific code will read the RMP entry to determine
> if the fault can be resolved by splitting and propagating the request
> to split the page by setting newly introduced fault flag
> (FAULT_FLAG_PAGE_SPLIT). If the fault cannot be resolved by splitting,
> then a SIGBUS signal is sent to terminate the process.

Are users just supposed to know what memory types are compatible with
SEV-SNP?  Basically, don't use anything that might map a guest using
non-4k entries, except THP?

This does seem like a rather nasty aspect of the hardware.  For
everything else, if the virtualization page tables and the x86 tables
disagree, the TLB just sees the smallest page size.

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 7605e06a6dd9..f6571563f433 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1305,6 +1305,70 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
>  }
>  NOKPROBE_SYMBOL(do_kern_addr_fault);
>  
> +#define RMP_FAULT_RETRY		0
> +#define RMP_FAULT_KILL		1
> +#define RMP_FAULT_PAGE_SPLIT	2
> +
> +static inline size_t pages_per_hpage(int level)
> +{
> +	return page_level_size(level) / PAGE_SIZE;
> +}
> +
> +/*
> + * The RMP fault can happen when a hypervisor attempts to write to:
> + * 1. a guest owned page or
> + * 2. any pages in the large page is a guest owned page.
> + *
> + * #1 will happen only when a process or VMM is attempting to modify the guest page
> + * without the guests cooperation. If a guest wants a VMM to be able to write to its memory
> + * then it should make the page shared. If we detect #1, kill the process because we can not
> + * resolve the fault.
> + *
> + * #2 can happen when the page level does not match between the RMP entry and x86
> + * page table walk, e.g the page is mapped as a large page in the x86 page table but its
> + * added as a 4K shared page in the RMP entry. This can be resolved by splitting the address
> + * into a smaller page level.
> + */

These comments need to get wrapped a bit sooner.  Could you try to match
some of the others in the file?

> +static int handle_rmp_page_fault(unsigned long hw_error_code, unsigned long address)
> +{
> +	unsigned long pfn, mask;
> +	int rmp_level, level;
> +	rmpentry_t *e;
> +	pte_t *pte;
> +
> +	/* Get the native page level */
> +	pte = lookup_address_in_mm(current->mm, address, &level);
> +	if (unlikely(!pte))
> +		return RMP_FAULT_KILL;
> +
> +	pfn = pte_pfn(*pte);
> +	if (level > PG_LEVEL_4K) {
> +		mask = pages_per_hpage(level) - pages_per_hpage(level - 1);
> +		pfn |= (address >> PAGE_SHIFT) & mask;
> +	}

What is this trying to do, exactly?

> +	/* Get the page level from the RMP entry. */
> +	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
> +	if (!e) {
> +		pr_alert("SEV-SNP: failed to lookup RMP entry for address 0x%lx pfn 0x%lx\n",
> +			 address, pfn);
> +		return RMP_FAULT_KILL;
> +	}
> +
> +	/* Its a guest owned page */
> +	if (rmpentry_assigned(e))
> +		return RMP_FAULT_KILL;
> +
> +	/*
> +	 * Its a shared page but the page level does not match between the native walk
> +	 * and RMP entry.
> +	 */

For these two-line comments, please try to split the text fairly evenly
between the lines.

> +	if (level > rmp_level)
> +		return RMP_FAULT_PAGE_SPLIT;
> +
> +	return RMP_FAULT_RETRY;
> +}
> +
>  /* Handle faults in the user portion of the address space */
>  static inline
>  void do_user_addr_fault(struct pt_regs *regs,
> @@ -1315,6 +1379,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	struct task_struct *tsk;
>  	struct mm_struct *mm;
>  	vm_fault_t fault;
> +	int ret;
>  	unsigned int flags = FAULT_FLAG_DEFAULT;
>  
>  	tsk = current;
> @@ -1377,6 +1442,22 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (hw_error_code & X86_PF_INSTR)
>  		flags |= FAULT_FLAG_INSTRUCTION;
>  
> +	/*
> +	 * If its an RMP violation, see if we can resolve it.
> +	 */
> +	if ((hw_error_code & X86_PF_RMP)) {
> +		ret = handle_rmp_page_fault(hw_error_code, address);
> +		if (ret == RMP_FAULT_PAGE_SPLIT) {
> +			flags |= FAULT_FLAG_PAGE_SPLIT;
> +		} else if (ret == RMP_FAULT_KILL) {
> +			fault |= VM_FAULT_SIGBUS;
> +			mm_fault_error(regs, hw_error_code, address, fault);
> +			return;
> +		} else {
> +			return;
> +		}
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	/*
>  	 * Faults in the vsyscall page might need emulation.  The
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ecdf8a8cd6ae..1be3218f3738 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -434,6 +434,8 @@ extern pgprot_t protection_map[16];
>   * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
>   * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
>   * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
> + * @FAULT_FLAG_PAGE_SPLIT: The fault was due page size mismatch, split the region to smaller
> + *   page size and retry.
>   *
>   * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
>   * whether we would allow page faults to retry by specifying these two
> @@ -464,6 +466,7 @@ extern pgprot_t protection_map[16];
>  #define FAULT_FLAG_REMOTE			0x80
>  #define FAULT_FLAG_INSTRUCTION  		0x100
>  #define FAULT_FLAG_INTERRUPTIBLE		0x200
> +#define FAULT_FLAG_PAGE_SPLIT			0x400
>  
>  /*
>   * The default fault flags that should be used by most of the
> @@ -501,7 +504,8 @@ static inline bool fault_flag_allow_retry_first(unsigned int flags)
>  	{ FAULT_FLAG_USER,		"USER" }, \
>  	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
>  	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
> -	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
> +	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
> +	{ FAULT_FLAG_PAGE_SPLIT,	"PAGESPLIT" }
>  
>  /*
>   * vm_fault is filled by the pagefault handler and passed to the vma's
> diff --git a/mm/memory.c b/mm/memory.c
> index feff48e1465a..c9dcf9b30719 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4427,6 +4427,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +static int handle_split_page_fault(struct vm_fault *vmf)
> +{
> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	return 0;
> +}

Wait a sec, I thought this could fail.  Where's the "failed to split"
path?  Why does this even return an error code if it's always 0?

>  /*
>   * By the time we get here, we already hold the mm semaphore
>   *
> @@ -4448,6 +4454,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  	pgd_t *pgd;
>  	p4d_t *p4d;
>  	vm_fault_t ret;
> +	int split_page = flags & FAULT_FLAG_PAGE_SPLIT;
>  
>  	pgd = pgd_offset(mm, address);
>  	p4d = p4d_alloc(mm, pgd, address);
> @@ -4504,6 +4511,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  				pmd_migration_entry_wait(mm, vmf.pmd);
>  			return 0;
>  		}
> +
> +		if (split_page)
> +			return handle_split_page_fault(&vmf);
> +
>  		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
>  			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
>  				return do_huge_pmd_numa_page(&vmf, orig_pmd);

Is there a reason for the 'split_page' variable?  It seems like a waste
of space.
