Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4306A5739
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 11:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjB1KzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 05:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjB1Kyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 05:54:35 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DE02E82E;
        Tue, 28 Feb 2023 02:53:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=wuzongyong@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0Vcj3mWh_1677581630;
Received: from localhost(mailfrom:wuzongyong@linux.alibaba.com fp:SMTPD_---0Vcj3mWh_1677581630)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 18:53:51 +0800
Date:   Tue, 28 Feb 2023 18:53:50 +0800
From:   Wu Zongyong <wuzongyong@linux.alibaba.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
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
        nikunj.dadhania@amd.com, wutu.xq2@linux.alibaba.com
Subject: Re: [PATCH RFC v8 19/56] x86/fault: Return pfn from dump_pagetable()
 for SEV-specific fault handling.
Message-ID: <20230228105350.GA15593@L-PF27918B-1352.localdomain>
Reply-To: Wu Zongyong <wuzongyong@linux.alibaba.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-20-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220183847.59159-20-michael.roth@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 12:38:10PM -0600, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Return pfn from dump_pagetable() to do SEV-specific
> fault handling. Used for handling SNP RMP page fault.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/mm/fault.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index afd4cde17001..f2b16dcfbd9a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -311,7 +311,7 @@ static bool low_pfn(unsigned long pfn)
>  	return pfn < max_low_pfn;
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static unsigned long dump_pagetable(unsigned long address)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = &base[pgd_index(address)];
> @@ -345,8 +345,10 @@ static void dump_pagetable(unsigned long address)
>  
>  	pte = pte_offset_kernel(pmd, address);
>  	pr_cont("*pte = %0*Lx ", sizeof(*pte) * 2, (u64)pte_val(*pte));
> +	return 0;
>  out:
>  	pr_cont("\n");
> +	return 0;
>  }
>  
>  #else /* CONFIG_X86_64: */
> @@ -367,10 +369,11 @@ static int bad_address(void *p)
>  	return get_kernel_nofault(dummy, (unsigned long *)p);
>  }
>  
> -static void dump_pagetable(unsigned long address)
> +static unsigned long dump_pagetable(unsigned long address)
>  {
>  	pgd_t *base = __va(read_cr3_pa());
>  	pgd_t *pgd = base + pgd_index(address);
> +	unsigned long pfn;

pfn should be initialized otherwise this function may return an
uninitialized value.

>  	p4d_t *p4d;
>  	pud_t *pud;
>  	pmd_t *pmd;
> @@ -388,6 +391,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(p4d))
>  		goto bad;
>  
> +	pfn = p4d_pfn(*p4d);
>  	pr_cont("P4D %lx ", p4d_val(*p4d));
>  	if (!p4d_present(*p4d) || p4d_large(*p4d))
>  		goto out;
> @@ -396,6 +400,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pud))
>  		goto bad;
>  
> +	pfn = pud_pfn(*pud);
>  	pr_cont("PUD %lx ", pud_val(*pud));
>  	if (!pud_present(*pud) || pud_large(*pud))
>  		goto out;
> @@ -404,6 +409,7 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pmd))
>  		goto bad;
>  
> +	pfn = pmd_pfn(*pmd);
>  	pr_cont("PMD %lx ", pmd_val(*pmd));
>  	if (!pmd_present(*pmd) || pmd_large(*pmd))
>  		goto out;
> @@ -412,13 +418,14 @@ static void dump_pagetable(unsigned long address)
>  	if (bad_address(pte))
>  		goto bad;
>  
> +	pfn = pte_pfn(*pte);
>  	pr_cont("PTE %lx", pte_val(*pte));
>  out:
>  	pr_cont("\n");
> -
> -	return;
> +	return pfn;
>  bad:
>  	pr_info("BAD\n");
> +	return -1;
>  }
>  
>  #endif /* CONFIG_X86_64 */
> -- 
> 2.25.1
> 
> 
> 
> 
