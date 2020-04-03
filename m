Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F223D19E06F
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgDCVjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:39:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgDCVjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:39:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033LXeOK113525;
        Fri, 3 Apr 2020 21:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=KRL1+mUHaY//oba79AedQOt9d/q/waQ62JIEXq5RGS8=;
 b=AMCyGRrGxUOc3naCBWt3vBNYh+PZHLXnC11oVC/jQ4s3RlVYud+QBwUOvuDqZ08jjRHn
 f6SlRDR64/eG3l6Pt6tbQnCex5PT2XkUHSkc5c+lCUInfX2jf1yugjtIH9IntDr96IgC
 TXVlOiLBXLOrtI5eo7citvwxIY5+JVGkHLbrmyb7U8FaHwVe9e1v2TUAs+5eGuwSxnET
 ybod6r9f0Wkldzl95AEy2AxxIdX96oEiCJoLbd6eKQV1PRnxvZ/y0NvVPkwIR/SNyfPt
 vpQLyQ0I69pF4fehKXkLDpCSGjz+1q9natnCDMK0bJdiYH4pZy6BbmIX39Es3lqskbD+ uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yunnweg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:38:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033LX4E0025955;
        Fri, 3 Apr 2020 21:36:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2p02h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 21:36:57 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033Lashx001400;
        Fri, 3 Apr 2020 21:36:54 GMT
Received: from vbusired-dt (/10.154.116.130)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 14:36:53 -0700
Date:   Fri, 3 Apr 2020 16:36:49 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 10/14] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20200403213649.GA730301@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <05c9015fb13b25c07a84d5638a7cd65a8c136cf0.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05c9015fb13b25c07a84d5638a7cd65a8c136cf0.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:22:38 +0000, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
> 
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor need to know the page encryption
s/need/needs/
> status during the guest migration.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  arch/x86/include/asm/paravirt.h       | 10 +++++
>  arch/x86/include/asm/paravirt_types.h |  2 +
>  arch/x86/kernel/paravirt.c            |  1 +
>  arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
>  arch/x86/mm/pat/set_memory.c          |  7 ++++
>  5 files changed, 76 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 694d8daf4983..8127b9c141bf 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>  	PVOP_VCALL1(mmu.exit_mmap, mm);
>  }
>  
> +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> +						bool enc)
> +{
> +	PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
> +}
> +
>  #ifdef CONFIG_PARAVIRT_XXL
>  static inline void load_sp0(unsigned long sp0)
>  {
> @@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
>  static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>  {
>  }
> +
> +static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
> +{
> +}
>  #endif
>  #endif /* __ASSEMBLY__ */
>  #endif /* _ASM_X86_PARAVIRT_H */
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 732f62e04ddb..03bfd515c59c 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -215,6 +215,8 @@ struct pv_mmu_ops {
>  
>  	/* Hook for intercepting the destruction of an mm_struct. */
>  	void (*exit_mmap)(struct mm_struct *mm);
> +	void (*page_encryption_changed)(unsigned long vaddr, int npages,
> +					bool enc);
>  
>  #ifdef CONFIG_PARAVIRT_XXL
>  	struct paravirt_callee_save read_cr2;
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index c131ba4e70ef..840c02b23aeb 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
>  			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
>  
>  	.mmu.exit_mmap		= paravirt_nop,
> +	.mmu.page_encryption_changed	= paravirt_nop,
>  
>  #ifdef CONFIG_PARAVIRT_XXL
>  	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index f4bd4b431ba1..c9800fa811f6 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/bitops.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/fixmap.h>
> @@ -29,6 +30,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/kvm_para.h>
>  
>  #include "mm_internal.h"
>  
> @@ -196,6 +198,47 @@ void __init sme_early_init(void)
>  		swiotlb_force = SWIOTLB_FORCE;
>  }
>  
> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> +					bool enc)
> +{
> +	unsigned long sz = npages << PAGE_SHIFT;
> +	unsigned long vaddr_end, vaddr_next;
> +
> +	vaddr_end = vaddr + sz;
> +
> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> +		int psize, pmask, level;
> +		unsigned long pfn;
> +		pte_t *kpte;
> +
> +		kpte = lookup_address(vaddr, &level);
> +		if (!kpte || pte_none(*kpte))
> +			return;
> +
> +		switch (level) {
> +		case PG_LEVEL_4K:
> +			pfn = pte_pfn(*kpte);
> +			break;
> +		case PG_LEVEL_2M:
> +			pfn = pmd_pfn(*(pmd_t *)kpte);
> +			break;
> +		case PG_LEVEL_1G:
> +			pfn = pud_pfn(*(pud_t *)kpte);
> +			break;
> +		default:
> +			return;
> +		}
> +
> +		psize = page_level_size(level);
> +		pmask = page_level_mask(level);
> +
> +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> +
> +		vaddr_next = (vaddr & pmask) + psize;
> +	}
> +}
> +
>  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  {
>  	pgprot_t old_prot, new_prot;
> @@ -253,12 +296,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  					   unsigned long size, bool enc)
>  {
> -	unsigned long vaddr_end, vaddr_next;
> +	unsigned long vaddr_end, vaddr_next, start;
>  	unsigned long psize, pmask;
>  	int split_page_size_mask;
>  	int level, ret;
>  	pte_t *kpte;
>  
> +	start = vaddr;
>  	vaddr_next = vaddr;
>  	vaddr_end = vaddr + size;
>  
> @@ -313,6 +357,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  
>  	ret = 0;
>  
> +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> +					enc);
>  out:
>  	__flush_tlb_all();
>  	return ret;
> @@ -451,6 +497,15 @@ void __init mem_encrypt_init(void)
>  	if (sev_active())
>  		static_branch_enable(&sev_enable_key);
>  
> +#ifdef CONFIG_PARAVIRT
> +	/*
> +	 * With SEV, we need to make a hypercall when page encryption state is
> +	 * changed.
> +	 */
> +	if (sev_active())
> +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> +#endif
> +
>  	pr_info("AMD %s active\n",
>  		sev_active() ? "Secure Encrypted Virtualization (SEV)"
>  			     : "Secure Memory Encryption (SME)");
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index c4aedd00c1ba..86b7804129fc 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -26,6 +26,7 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/paravirt.h>
>  
>  #include "../mm_internal.h"
>  
> @@ -1987,6 +1988,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	 */
>  	cpa_flush(&cpa, 0);
>  
> +	/* Notify hypervisor that a given memory range is mapped encrypted
> +	 * or decrypted. The hypervisor will use this information during the
> +	 * VM migration.
> +	 */
> +	page_encryption_changed(addr, numpages, enc);
> +
>  	return ret;
>  }
>  
> -- 
> 2.17.1
> 
