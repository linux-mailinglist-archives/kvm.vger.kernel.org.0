Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159372D625
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 09:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE2HVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 03:21:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32950 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfE2HVX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 03:21:23 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T7J00t124825
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:22 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssk89w9nd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:21 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 29 May 2019 08:21:19 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 08:21:14 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4T7LDwl53149950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 07:21:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AEFBAE055;
        Wed, 29 May 2019 07:21:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3C3BAE057;
        Wed, 29 May 2019 07:21:11 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.8.53])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 29 May 2019 07:21:11 +0000 (GMT)
Date:   Wed, 29 May 2019 10:21:10 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 02/62] mm: Add helpers to setup zero page mappings
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-3-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-3-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19052907-0020-0000-0000-000003418013
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052907-0021-0000-0000-000021947F7A
Message-Id: <20190529072109.GB3656@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:22PM +0300, Kirill A. Shutemov wrote:
> When kernel setups an encrypted page mapping, encryption KeyID is

Nit: "when kernel sets up an encrypted..."

> derived from a VMA. KeyID is going to be part of vma->vm_page_prot and
> it will be propagated transparently to page table entry on mk_pte().
> 
> But there is an exception: zero page is never encrypted and its mapping
> must use KeyID-0, regardless VMA's KeyID.
> 
> Introduce helpers that create a page table entry for zero page.
> 
> The generic implementation will be overridden by architecture-specific
> code that takes care about using correct KeyID.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  fs/dax.c                      | 3 +--
>  include/asm-generic/pgtable.h | 8 ++++++++
>  mm/huge_memory.c              | 6 ++----
>  mm/memory.c                   | 3 +--
>  mm/userfaultfd.c              | 3 +--
>  5 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index e5e54da1715f..6d609bff53b9 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1441,8 +1441,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>  		mm_inc_nr_ptes(vma->vm_mm);
>  	}
> -	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
> -	pmd_entry = pmd_mkhuge(pmd_entry);
> +	pmd_entry = mk_zero_pmd(zero_page, vmf->vma->vm_page_prot);
>  	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
>  	spin_unlock(ptl);
>  	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index fa782fba51ee..cde8b81f6f2b 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -879,8 +879,16 @@ static inline unsigned long my_zero_pfn(unsigned long addr)
>  }
>  #endif
> 
> +#ifndef mk_zero_pte
> +#define mk_zero_pte(addr, prot) pte_mkspecial(pfn_pte(my_zero_pfn(addr), prot))
> +#endif
> +
>  #ifdef CONFIG_MMU
> 
> +#ifndef mk_zero_pmd
> +#define mk_zero_pmd(zero_page, prot) pmd_mkhuge(mk_pmd(zero_page, prot))
> +#endif
> +
>  #ifndef CONFIG_TRANSPARENT_HUGEPAGE
>  static inline int pmd_trans_huge(pmd_t pmd)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 165ea46bf149..26c3503824ba 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -675,8 +675,7 @@ static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
>  	pmd_t entry;
>  	if (!pmd_none(*pmd))
>  		return false;
> -	entry = mk_pmd(zero_page, vma->vm_page_prot);
> -	entry = pmd_mkhuge(entry);
> +	entry = mk_zero_pmd(zero_page, vma->vm_page_prot);
>  	if (pgtable)
>  		pgtable_trans_huge_deposit(mm, pmd, pgtable);
>  	set_pmd_at(mm, haddr, pmd, entry);
> @@ -2101,8 +2100,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> 
>  	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
>  		pte_t *pte, entry;
> -		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
> -		entry = pte_mkspecial(entry);
> +		entry = mk_zero_pte(haddr, vma->vm_page_prot);
>  		pte = pte_offset_map(&_pmd, haddr);
>  		VM_BUG_ON(!pte_none(*pte));
>  		set_pte_at(mm, haddr, pte, entry);
> diff --git a/mm/memory.c b/mm/memory.c
> index ab650c21bccd..c5e0c87a12b7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2927,8 +2927,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	/* Use the zero-page for reads */
>  	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>  			!mm_forbids_zeropage(vma->vm_mm)) {
> -		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
> -						vma->vm_page_prot));
> +		entry = mk_zero_pte(vmf->address, vma->vm_page_prot);
>  		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
>  				vmf->address, &vmf->ptl);
>  		if (!pte_none(*vmf->pte))
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index d59b5a73dfb3..ac1ce3866036 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -122,8 +122,7 @@ static int mfill_zeropage_pte(struct mm_struct *dst_mm,
>  	pgoff_t offset, max_off;
>  	struct inode *inode;
> 
> -	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> -					 dst_vma->vm_page_prot));
> +	_dst_pte = mk_zero_pte(dst_addr, dst_vma->vm_page_prot);
>  	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
>  	if (dst_vma->vm_file) {
>  		/* the shmem MAP_PRIVATE case requires checking the i_size */
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

