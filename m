Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2D53D1AB7
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 02:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhGUXqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 19:46:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:39215 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhGUXqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 19:46:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="191814944"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="191814944"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 17:26:40 -0700
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; 
   d="scan'208";a="501534993"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.119])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 17:26:36 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date:   Thu, 22 Jul 2021 08:26:34 +0800
In-Reply-To: <YPhAEcHOCZ5yII/T@google.com> (Sean Christopherson's message of
        "Wed, 21 Jul 2021 15:41:05 +0000")
Message-ID: <87lf5z9osl.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:
>> 
>> Thanks, I think you are correct. By looking into commit 7066f0f933a1
>> ("mm: thp: fix mmu_notifier in migrate_misplaced_transhuge_page()"),
>> the tlb flush and mmu notifier invalidate were needed since the old
>> numa fault implementation didn't change PTE to migration entry so it
>> may cause data corruption due to the writes from GPU secondary MMU.
>> 
>> The refactor does use the generic migration code which converts PTE to
>> migration entry before copying data to the new page.
>
> That's my understanding as well, based on this blurb from commit 7066f0f933a1.
>
>     The standard PAGE_SIZEd migrate_misplaced_page is less accelerated and
>     uses the generic migrate_pages which transitions the pte from
>     numa/protnone to a migration entry in try_to_unmap_one() and flushes TLBs
>     and all mmu notifiers there before copying the page.
>
> That analysis/justification for removing the invalidate_range() call should be
> captured in the changelog.  Confirmation from Andrea would be a nice bonus.

When we flush CPU TLB for a page that may be shared with device/VM TLB,
we will call MMU notifiers for the page to flush the device/VM TLB.
Right?  So when we replaced CPU TLB flushing in do_huge_pmd_numa_page()
with that in try_to_migrate_one(), we will replace the MMU notifiers
calling too.  Do you agree?

Best Regards,
Huang, Ying
