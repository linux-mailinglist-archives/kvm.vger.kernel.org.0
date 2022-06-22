Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C255554D37
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358249AbiFVOdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358066AbiFVOdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:33:17 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFE9622530;
        Wed, 22 Jun 2022 07:33:16 -0700 (PDT)
Received: from jpiotrowski-Surface-Book-3 (ip-037-201-214-204.um10.pools.vodafone-ip.de [37.201.214.204])
        by linux.microsoft.com (Postfix) with ESMTPSA id F368F20C5A72;
        Wed, 22 Jun 2022 07:33:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F368F20C5A72
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655908396;
        bh=ALGB76keBASr4hY7hNxpqQX9PoomTfBUh9uHAgUzoZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TQuQbeqWbRyJqyFmVhgUuEJoBS5K/iwNUxkPx+opP5jeWVfpzXQI4KzNOllCIS2zh
         mU8FnTjBX9ClQRIxHfXEKNV839Uq5DWJzew4nztCg0vmsZJ+56JSnTEpM4fqmceN0D
         tXbZpMynZVvEgvrwBOTlSQAdtEXVMixKZZIm5rYI=
Date:   Wed, 22 Jun 2022 16:33:04 +0200
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
Subject: Re: [PATCH Part2 v6 10/49] x86/fault: Add support to dump RMP entry
 on fault
Message-ID: <YrMoIOv3U+vehi/D@jpiotrowski-Surface-Book-3>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
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
> +{
> +	unsigned long pfn_end;
> +	struct rmpentry *e;
> +	int level;
> +
> +	e = __snp_lookup_rmpentry(pfn, &level);
> +	if (!e) {

__snp_lookup_rmpentry may return -errno so this should be:

  if (e != 1)

> +		pr_alert("failed to read RMP entry pfn 0x%llx\n", pfn);
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

  if (e != 1)

> +			return;
> +
> +		if (e->low || e->high)
> +			pr_alert("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				 pfn << PAGE_SHIFT, e->high, e->low);
> +		pfn++;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dump_rmpentry);
> +
>  /*
>   * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
>   * and -errno if there is no corresponding RMP entry.
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f5de9673093a..25896a6ba04a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -34,6 +34,7 @@
>  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
>  #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
>  #include <asm/irq_stack.h>
> +#include <asm/sev.h>			/* dump_rmpentry()		*/
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -290,7 +291,7 @@ static bool low_pfn(unsigned long pfn)
>  	return pfn < max_low_pfn;
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static void dump_pagetable(unsigned long address, bool show_rmpentry)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = &base[pgd_index(address)];
> @@ -346,10 +347,11 @@ static int bad_address(void *p)
>  	return get_kernel_nofault(dummy, (unsigned long *)p);
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static void dump_pagetable(unsigned long address, bool show_rmpentry)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = base + pgd_index(address);
> +	unsigned long pfn;
>  	p4d_t *p4d;
>  	pud_t *pud;
>  	pmd_t *pmd;
> @@ -367,6 +369,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(p4d))
>  		goto bad;
>  
> +	pfn = p4d_pfn(*p4d);
>  	pr_cont("P4D %lx ", p4d_val(*p4d));
>  	if (!p4d_present(*p4d) || p4d_large(*p4d))
>  		goto out;
> @@ -375,6 +378,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pud))
>  		goto bad;
>  
> +	pfn = pud_pfn(*pud);
>  	pr_cont("PUD %lx ", pud_val(*pud));
>  	if (!pud_present(*pud) || pud_large(*pud))
>  		goto out;
> @@ -383,6 +387,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pmd))
>  		goto bad;
>  
> +	pfn = pmd_pfn(*pmd);
>  	pr_cont("PMD %lx ", pmd_val(*pmd));
>  	if (!pmd_present(*pmd) || pmd_large(*pmd))
>  		goto out;
> @@ -391,9 +396,13 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pte))
>  		goto bad;
>  
> +	pfn = pte_pfn(*pte);
>  	pr_cont("PTE %lx", pte_val(*pte));
>  out:
>  	pr_cont("\n");
> +
> +	if (show_rmpentry)
> +		dump_rmpentry(pfn);
>  	return;
>  bad:
>  	pr_info("BAD\n");
> @@ -579,7 +588,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
>  		show_ldttss(&gdt, "TR", tr);
>  	}
>  
> -	dump_pagetable(address);
> +	dump_pagetable(address, error_code & X86_PF_RMP);
>  }
>  
>  static noinline void
> @@ -596,7 +605,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
>  
>  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
>  	       tsk->comm, address);
> -	dump_pagetable(address);
> +	dump_pagetable(address, false);
>  
>  	if (__die("Bad pagetable", regs, error_code))
>  		sig = 0;
> diff --git a/include/linux/sev.h b/include/linux/sev.h
> index 1a68842789e1..734b13a69c54 100644
> --- a/include/linux/sev.h
> +++ b/include/linux/sev.h
> @@ -16,6 +16,7 @@ int snp_lookup_rmpentry(u64 pfn, int *level);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> +void dump_rmpentry(u64 pfn);
>  #else
>  static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
>  static inline int psmash(u64 pfn) { return -ENXIO; }
> @@ -25,6 +26,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +static inline void dump_rmpentry(u64 pfn) { }
>  
>  #endif /* CONFIG_AMD_MEM_ENCRYPT */
>  #endif /* __LINUX_SEV_H */
> -- 
> 2.25.1
> 
