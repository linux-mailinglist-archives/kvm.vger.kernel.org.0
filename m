Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441213D30A1
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 02:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhGVXXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 19:23:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:59790 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhGVXXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 19:23:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="191362670"
X-IronPort-AV: E=Sophos;i="5.84,262,1620716400"; 
   d="scan'208";a="191362670"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 17:03:51 -0700
X-IronPort-AV: E=Sophos;i="5.84,262,1620716400"; 
   d="scan'208";a="512883953"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.119])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 17:03:46 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mel Gorman <mgorman@suse.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB
 flushing code
References: <20210720065529.716031-1-ying.huang@intel.com>
        <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
        <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
        <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
        <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
        <YPhAEcHOCZ5yII/T@google.com>
        <87lf5z9osl.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <572f1ddd-9ac6-fb09-9a24-1c667dbd1d03@de.ibm.com>
Date:   Fri, 23 Jul 2021 08:03:42 +0800
In-Reply-To: <572f1ddd-9ac6-fb09-9a24-1c667dbd1d03@de.ibm.com> (Christian
        Borntraeger's message of "Thu, 22 Jul 2021 09:36:07 +0200")
Message-ID: <878s1xaobl.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> On 22.07.21 02:26, Huang, Ying wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>>>
>>>> Thanks, I think you are correct. By looking into commit 7066f0f933a1
>>>> ("mm: thp: fix mmu_notifier in migrate_misplaced_transhuge_page()"),
>>>> the tlb flush and mmu notifier invalidate were needed since the old
>>>> numa fault implementation didn't change PTE to migration entry so it
>>>> may cause data corruption due to the writes from GPU secondary MMU.
>>>>
>>>> The refactor does use the generic migration code which converts PTE to
>>>> migration entry before copying data to the new page.
>>>
>>> That's my understanding as well, based on this blurb from commit 7066f0f933a1.
>>>
>>>      The standard PAGE_SIZEd migrate_misplaced_page is less accelerated and
>>>      uses the generic migrate_pages which transitions the pte from
>>>      numa/protnone to a migration entry in try_to_unmap_one() and flushes TLBs
>>>      and all mmu notifiers there before copying the page.
>>>
>>> That analysis/justification for removing the invalidate_range() call should be
>>> captured in the changelog.  Confirmation from Andrea would be a nice bonus.
>> When we flush CPU TLB for a page that may be shared with device/VM
>> TLB,
>> we will call MMU notifiers for the page to flush the device/VM TLB.
>> Right?  So when we replaced CPU TLB flushing in do_huge_pmd_numa_page()
>> with that in try_to_migrate_one(), we will replace the MMU notifiers
>> calling too.  Do you agree?
>
> Can someone write an updated commit messages that contains this information?

Hi, Andrew,

Can you help to add the following text to the end of the original patch
description?

"
The mmu_notifier_invalidate_range() in do_huge_pmd_numa_page() is
deleted too.  Because migrate_pages() takes care of that too when CPU
TLB is flushed.
"

Or, if you prefer the complete patch, it's as below.

Best Regards,
Huang, Ying

------------------------------------8<---------------------------------------------
From a7ce0c58dcc0d2f0d87b43b4e93a6623d78c9c25 Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Tue, 13 Jul 2021 13:41:37 +0800
Subject: [PATCH -V2] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing
 code

Before the commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
handling"), the TLB flushing is done in do_huge_pmd_numa_page() itself
via flush_tlb_range().

But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
handling"), the TLB flushing is done in migrate_pages() as in the
following code path anyway.

do_huge_pmd_numa_page
  migrate_misplaced_page
    migrate_pages

So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
unnecessary.  So the code is deleted in this patch to simplify the
code.  This is only code cleanup, there's no visible performance
difference.

The mmu_notifier_invalidate_range() in do_huge_pmd_numa_page() is
deleted too.  Because migrate_pages() takes care of that too when CPU
TLB is flushed.

Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
---
 mm/huge_memory.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afff3ac87067..9f21e44c9030 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 		goto out;
 	}
 
-	/*
-	 * Since we took the NUMA fault, we must have observed the !accessible
-	 * bit. Make sure all other CPUs agree with that, to avoid them
-	 * modifying the page we're about to migrate.
-	 *
-	 * Must be done under PTL such that we'll observe the relevant
-	 * inc_tlb_flush_pending().
-	 *
-	 * We are not sure a pending tlb flush here is for a huge page
-	 * mapping or not. Hence use the tlb range variant
-	 */
-	if (mm_tlb_flush_pending(vma->vm_mm)) {
-		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
-		/*
-		 * change_huge_pmd() released the pmd lock before
-		 * invalidating the secondary MMUs sharing the primary
-		 * MMU pagetables (with ->invalidate_range()). The
-		 * mmu_notifier_invalidate_range_end() (which
-		 * internally calls ->invalidate_range()) in
-		 * change_pmd_range() will run after us, so we can't
-		 * rely on it here and we need an explicit invalidate.
-		 */
-		mmu_notifier_invalidate_range(vma->vm_mm, haddr,
-					      haddr + HPAGE_PMD_SIZE);
-	}
-
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
 	page = vm_normal_page_pmd(vma, haddr, pmd);
 	if (!page)
-- 
2.30.2

