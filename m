Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D23CFC40
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhGTNrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 09:47:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238463AbhGTNpU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 09:45:20 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16KE63IH086006;
        Tue, 20 Jul 2021 10:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6ZxlFXPrsd/fsarVq1ctAW2etfUTeiHa1pr/LQKxuI4=;
 b=PtJ/F/5jojBAXjyhpuBBxyjxpHkyBsmInV89gFddE1+ZF76XW+FB9VClFcAUnqxKPub7
 9t8tNWNLu9GMpECJYVQir7oe2vSZ+7lCmF93Z8HEaKBpzXCjJ6wdegIPQ4mkWsRBKDHS
 EsFZXIeE1TSiQyh43BSkw1H0YK1SH89Y8KobUT7TTGsrf7rtait9sZTE/auQLT1Fju8e
 /qMfMSvNQwjzGU9i06k1tl0hVLUk6OMV1du7F/f+Yio0cSw8nWc6CESdJW1RGoJ4JOka
 cv9zN3ADwJk0JczVjQUrszyfG3v3mWmMsRr5u4Q2PC6kLgDsbZVBDMHZd8nstRT227sJ /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wv47pywd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 10:25:44 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16KE6fQG090841;
        Tue, 20 Jul 2021 10:25:43 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39wv47pyv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 10:25:43 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16KEFKVJ005875;
        Tue, 20 Jul 2021 14:25:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu89c5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 14:25:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16KEPcMu27263320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 14:25:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 112B55204F;
        Tue, 20 Jul 2021 14:25:38 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.91.99])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6F55652065;
        Tue, 20 Jul 2021 14:25:37 +0000 (GMT)
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing
 code
To:     Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yang Shi <shy828301@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mel Gorman <mgorman@suse.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
References: <20210720065529.716031-1-ying.huang@intel.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
Date:   Tue, 20 Jul 2021 16:25:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720065529.716031-1-ying.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FU4yu0Zn1I8QZgVMsco2mndyx-fhnmiq
X-Proofpoint-GUID: LYxMiQJt1hqM8Xe1uAAPGe35_SqVz3wM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-20_07:2021-07-19,2021-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20.07.21 08:55, Huang Ying wrote:
> Before the commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> handling"), the TLB flushing is done in do_huge_pmd_numa_page() itself
> via flush_tlb_range().
> 
> But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> handling"), the TLB flushing is done in migrate_pages() as in the
> following code path anyway.
> 
> do_huge_pmd_numa_page
>    migrate_misplaced_page
>      migrate_pages
> 
> So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
> unnecessary.  So the code is deleted in this patch to simplify the
> code.  This is only code cleanup, there's no visible performance
> difference.
> 
> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 26 --------------------------
>   1 file changed, 26 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afff3ac87067..9f21e44c9030 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
>   		goto out;
>   	}
>   
> -	/*
> -	 * Since we took the NUMA fault, we must have observed the !accessible
> -	 * bit. Make sure all other CPUs agree with that, to avoid them
> -	 * modifying the page we're about to migrate.
> -	 *
> -	 * Must be done under PTL such that we'll observe the relevant
> -	 * inc_tlb_flush_pending().
> -	 *
> -	 * We are not sure a pending tlb flush here is for a huge page
> -	 * mapping or not. Hence use the tlb range variant
> -	 */
> -	if (mm_tlb_flush_pending(vma->vm_mm)) {
> -		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
> -		/*
> -		 * change_huge_pmd() released the pmd lock before
> -		 * invalidating the secondary MMUs sharing the primary
> -		 * MMU pagetables (with ->invalidate_range()). The
> -		 * mmu_notifier_invalidate_range_end() (which
> -		 * internally calls ->invalidate_range()) in
> -		 * change_pmd_range() will run after us, so we can't
> -		 * rely on it here and we need an explicit invalidate.
> -		 */
> -		mmu_notifier_invalidate_range(vma->vm_mm, haddr,
> -					      haddr + HPAGE_PMD_SIZE);
> -	}
> CC Paolo/KVM list so we also remove the mmu notifier here. Do we need those
now in migrate_pages? I am not an expert in that code, but I cant find
an equivalent mmu_notifier in migrate_misplaced_pages.
I might be totally wrong, just something that I noticed.

>   	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
>   	page = vm_normal_page_pmd(vma, haddr, pmd);
>   	if (!page)
> 
