Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9069F2D628
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 09:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfE2HVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 03:21:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbfE2HVj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 03:21:39 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T7J1lN124863
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssk89w9x9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 03:21:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 29 May 2019 08:21:35 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 08:21:29 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4T7LSjP58589384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 07:21:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FB3E42041;
        Wed, 29 May 2019 07:21:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDDB442042;
        Wed, 29 May 2019 07:21:26 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.8.53])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 29 May 2019 07:21:26 +0000 (GMT)
Date:   Wed, 29 May 2019 10:21:25 +0300
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
Subject: Re: [PATCH, RFC 05/62] mm/page_alloc: Handle allocation for
 encrypted memory
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-6-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-6-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19052907-0008-0000-0000-000002EB7A67
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052907-0009-0000-0000-0000225849F8
Message-Id: <20190529072124.GC3656@rapoport-lnx>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:25PM +0300, Kirill A. Shutemov wrote:
> For encrypted memory, we need to allocate pages for a specific
> encryption KeyID.
> 
> There are two cases when we need to allocate a page for encryption:
> 
>  - Allocation for an encrypted VMA;
> 
>  - Allocation for migration of encrypted page;
> 
> The first case can be covered within alloc_page_vma(). We know KeyID
> from the VMA.
> 
> The second case requires few new page allocation routines that would
> allocate the page for a specific KeyID.
> 
> An encrypted page has to be cleared after KeyID set. This is handled
> in prep_encrypted_page() that will be provided by arch-specific code.
> 
> Any custom allocator that dials with encrypted pages has to call

Nit:                       ^ deals

> prep_encrypted_page() too. See compaction_alloc() for instance.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/gfp.h     | 45 ++++++++++++++++++++++++++++++++-----
>  include/linux/migrate.h | 14 +++++++++---
>  mm/compaction.c         |  3 +++
>  mm/mempolicy.c          | 27 ++++++++++++++++------
>  mm/migrate.c            |  4 ++--
>  mm/page_alloc.c         | 50 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 126 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index b101aa294157..1716dbe587c9 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -463,16 +463,43 @@ static inline void arch_free_page(struct page *page, int order) { }
>  static inline void arch_alloc_page(struct page *page, int order) { }
>  #endif
> 
> +#ifndef prep_encrypted_page

An explanation of what is expected from the architecture specific
implementation would be nice.

> +static inline void prep_encrypted_page(struct page *page, int order,
> +		int keyid, bool zero)
> +{
> +}
> +#endif
> +
> +/*
> + * Encrypted page has to be cleared once keyid is set, not on allocation.
> + */
> +static inline bool deferred_page_zero(int keyid, gfp_t *gfp_mask)
> +{
> +	if (keyid && (*gfp_mask & __GFP_ZERO)) {
> +		*gfp_mask &= ~__GFP_ZERO;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  struct page *
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>  							nodemask_t *nodemask);
> 
> +struct page *
> +__alloc_pages_nodemask_keyid(gfp_t gfp_mask, unsigned int order,
> +		int preferred_nid, nodemask_t *nodemask, int keyid);
> +
>  static inline struct page *
>  __alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
>  {
>  	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
>  }
> 
> +struct page *__alloc_pages_node_keyid(int nid, int keyid,
> +		gfp_t gfp_mask, unsigned int order);
> +
>  /*
>   * Allocate pages, preferring the node given as nid. The node must be valid and
>   * online. For more general interface, see alloc_pages_node().
> @@ -500,6 +527,19 @@ static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>  	return __alloc_pages_node(nid, gfp_mask, order);
>  }
> 
> +static inline struct page *alloc_pages_node_keyid(int nid, int keyid,
> +		gfp_t gfp_mask, unsigned int order)
> +{
> +	if (nid == NUMA_NO_NODE)
> +		nid = numa_mem_id();
> +
> +	return __alloc_pages_node_keyid(nid, keyid, gfp_mask, order);
> +}
> +
> +extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
> +			struct vm_area_struct *vma, unsigned long addr,
> +			int node, bool hugepage);
> +
>  #ifdef CONFIG_NUMA
>  extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
> 
> @@ -508,14 +548,9 @@ alloc_pages(gfp_t gfp_mask, unsigned int order)
>  {
>  	return alloc_pages_current(gfp_mask, order);
>  }
> -extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
> -			struct vm_area_struct *vma, unsigned long addr,
> -			int node, bool hugepage);
>  #else
>  #define alloc_pages(gfp_mask, order) \
>  		alloc_pages_node(numa_node_id(), gfp_mask, order)
> -#define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
> -	alloc_pages(gfp_mask, order)
>  #endif
>  #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
>  #define alloc_page_vma(gfp_mask, vma, addr)			\
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index e13d9bf2f9a5..a6e068762d08 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -38,9 +38,16 @@ static inline struct page *new_page_nodemask(struct page *page,
>  	unsigned int order = 0;
>  	struct page *new_page = NULL;
> 
> -	if (PageHuge(page))
> +	if (PageHuge(page)) {
> +		/*
> +		 * HugeTLB doesn't support encryption. We shouldn't see
> +		 * such pages.
> +		 */
> +		if (WARN_ON_ONCE(page_keyid(page)))
> +			return NULL;
>  		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
>  				preferred_nid, nodemask);
> +	}
> 
>  	if (PageTransHuge(page)) {
>  		gfp_mask |= GFP_TRANSHUGE;
> @@ -50,8 +57,9 @@ static inline struct page *new_page_nodemask(struct page *page,
>  	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
>  		gfp_mask |= __GFP_HIGHMEM;
> 
> -	new_page = __alloc_pages_nodemask(gfp_mask, order,
> -				preferred_nid, nodemask);
> +	/* Allocate a page with the same KeyID as the source page */
> +	new_page = __alloc_pages_nodemask_keyid(gfp_mask, order,
> +				preferred_nid, nodemask, page_keyid(page));
> 
>  	if (new_page && PageTransHuge(new_page))
>  		prep_transhuge_page(new_page);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3319e0872d01..559b8bd6d245 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1557,6 +1557,9 @@ static struct page *compaction_alloc(struct page *migratepage,
>  	list_del(&freepage->lru);
>  	cc->nr_freepages--;
> 
> +	/* Prepare the page using the same KeyID as the source page */
> +	if (freepage)
> +		prep_encrypted_page(freepage, 0, page_keyid(migratepage), false);
>  	return freepage;
>  }
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 14b18449c623..5cad39fb7b35 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -961,22 +961,29 @@ static void migrate_page_add(struct page *page, struct list_head *pagelist,
>  /* page allocation callback for NUMA node migration */
>  struct page *alloc_new_node_page(struct page *page, unsigned long node)
>  {
> -	if (PageHuge(page))
> +	if (PageHuge(page)) {
> +		/*
> +		 * HugeTLB doesn't support encryption. We shouldn't see
> +		 * such pages.
> +		 */
> +		if (WARN_ON_ONCE(page_keyid(page)))
> +			return NULL;
>  		return alloc_huge_page_node(page_hstate(compound_head(page)),
>  					node);
> -	else if (PageTransHuge(page)) {
> +	} else if (PageTransHuge(page)) {
>  		struct page *thp;
> 
> -		thp = alloc_pages_node(node,
> +		thp = alloc_pages_node_keyid(node, page_keyid(page),
>  			(GFP_TRANSHUGE | __GFP_THISNODE),
>  			HPAGE_PMD_ORDER);
>  		if (!thp)
>  			return NULL;
>  		prep_transhuge_page(thp);
>  		return thp;
> -	} else
> -		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
> -						    __GFP_THISNODE, 0);
> +	} else {
> +		return __alloc_pages_node_keyid(node, page_keyid(page),
> +				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
> +	}
>  }
> 
>  /*
> @@ -2053,9 +2060,13 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>  {
>  	struct mempolicy *pol;
>  	struct page *page;
> -	int preferred_nid;
> +	bool deferred_zero;
> +	int keyid, preferred_nid;
>  	nodemask_t *nmask;
> 
> +	keyid = vma_keyid(vma);
> +	deferred_zero = deferred_page_zero(keyid, &gfp);
> +
>  	pol = get_vma_policy(vma, addr);
> 
>  	if (pol->mode == MPOL_INTERLEAVE) {
> @@ -2097,6 +2108,8 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>  	page = __alloc_pages_nodemask(gfp, order, preferred_nid, nmask);
>  	mpol_cond_put(pol);
>  out:
> +	if (page)
> +		prep_encrypted_page(page, order, keyid, deferred_zero);
>  	return page;
>  }
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 663a5449367a..04b36a56865d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1880,7 +1880,7 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
>  	int nid = (int) data;
>  	struct page *newpage;
> 
> -	newpage = __alloc_pages_node(nid,
> +	newpage = __alloc_pages_node_keyid(nid, page_keyid(page),
>  					 (GFP_HIGHUSER_MOVABLE |
>  					  __GFP_THISNODE | __GFP_NOMEMALLOC |
>  					  __GFP_NORETRY | __GFP_NOWARN) &
> @@ -2006,7 +2006,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
>  	int page_lru = page_is_file_cache(page);
>  	unsigned long start = address & HPAGE_PMD_MASK;
> 
> -	new_page = alloc_pages_node(node,
> +	new_page = alloc_pages_node_keyid(node, page_keyid(page),
>  		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
>  		HPAGE_PMD_ORDER);
>  	if (!new_page)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c02cff1ed56e..ab1d8661aa87 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3930,6 +3930,41 @@ should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_fla
>  }
>  #endif /* CONFIG_COMPACTION */
> 
> +#ifndef CONFIG_NUMA
> +struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		int node, bool hugepage)
> +{

Having NUMA and !NUMA alloc_pages_vma() in different place is confusing,
but I don't have a better suggestion :(

> +	struct page *page;
> +	bool deferred_zero;
> +	int keyid = vma_keyid(vma);
> +
> +	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
> +	page = alloc_pages(gfp_mask, order);
> +	if (page)
> +		prep_encrypted_page(page, order, keyid, deferred_zero);
> +
> +	return page;
> +}
> +#endif
> +
> +struct page * __alloc_pages_node_keyid(int nid, int keyid,
> +		gfp_t gfp_mask, unsigned int order)
> +{

A kerneldoc description would be appreciated

> +	struct page *page;
> +	bool deferred_zero;
> +
> +	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> +	VM_WARN_ON(!node_online(nid));
> +
> +	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
> +	page = __alloc_pages(gfp_mask, order, nid);
> +	if (page)
> +		prep_encrypted_page(page, order, keyid, deferred_zero);
> +
> +	return page;
> +}

Shouldn't it be EXPORT_SYMBOL?

> +
>  #ifdef CONFIG_LOCKDEP
>  static struct lockdep_map __fs_reclaim_map =
>  	STATIC_LOCKDEP_MAP_INIT("fs_reclaim", &__fs_reclaim_map);
> @@ -4645,6 +4680,21 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
>  }
>  EXPORT_SYMBOL(__alloc_pages_nodemask);
>
> +struct page *
> +__alloc_pages_nodemask_keyid(gfp_t gfp_mask, unsigned int order,
> +		int preferred_nid, nodemask_t *nodemask, int keyid)
> +{

A kerneldoc description would be appreciated

> +	struct page *page;
> +	bool deferred_zero;
> +
> +	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
> +	page = __alloc_pages_nodemask(gfp_mask, order, preferred_nid, nodemask);
> +	if (page)
> +		prep_encrypted_page(page, order, keyid, deferred_zero);
> +	return page;
> +}
> +EXPORT_SYMBOL(__alloc_pages_nodemask_keyid);
> +
>  /*
>   * Common helper functions. Never use with __GFP_HIGHMEM because the returned
>   * address cannot represent highmem pages. Use alloc_pages and then kmap if
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

