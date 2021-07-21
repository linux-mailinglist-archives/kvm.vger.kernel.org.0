Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02B23D12AC
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbhGUPAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhGUPAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:00:34 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F38C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:41:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o4so2252170pgs.6
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Ix6B2u9o/3NyIeJsNBLENdZ3uGHmD3Meu6yoqcTW5I=;
        b=tjb/HC71RJXdMuiHb+AnXkVgM/b6xHvu74cDA1hoYQB5GURWM5En8OJFJhSG1hJ6Tz
         OgMrefJI/AmSw9VD0fKAVxTIznanZAurCA3hSMMniT4v+fhVBLtwRwTZa4+OwS/SmroK
         b8WNlQL+ZWBI7oxCqX27JhmuIlu0UD6V7UiKO71zfiw0wYgMi5ss3yh91VzLcPATycpe
         xhkOdts328XxPJVZZ1DZOJaz9ArcXfEANrzfrlH0mJMOPGwmbZojZqyZFxiDRkY+mHTb
         kfAj/M/ld91js53aOxvPHZlqZr008CtZqa26/qI3kKe3QoX46FPPZF45FVmqTPpRMuXB
         TPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Ix6B2u9o/3NyIeJsNBLENdZ3uGHmD3Meu6yoqcTW5I=;
        b=UCQ96ha8cHygT78JTSkgqwRYZnkfOT/bxNqdY9dr5zFEMo/fCBz+OEe2ORR6ECTpTA
         u+M2TSrXNOzHy4n6UMWe6ZV1Wh8doZHcmNf2lr7uMcPEqbHGonGACaEoXr+kQHqdbl9C
         3ZY9x4UtWV5m+VNDTeEstrzgZSCYfZ6lkV5xQdoaXBYhLywf4x1bXmFCUKpYku7BkaDh
         Z9WZ2AvNiBG9M0hPdgscc3soiMkqrpNsG3QQ54BaHAqq8yYG0hoJEYLcDS6adi+/LTvH
         icjFebpCDuDPBrhnadQNmfXJOd0SNKdSepYKVNq5EatBdyXJgMCjpsbszMUZTraC4oYr
         858A==
X-Gm-Message-State: AOAM531wjy+pu4+LzdAi1GZ+8qe4jphstQPAuGfOUGhI3Y2nu6zoFMVb
        TBKoNUt7Tkpg9Yd4kQK7L3cKvA==
X-Google-Smtp-Source: ABdhPJw/juHLapeaWRI6rtDXP+E4A+f92IwSfymckdLGVJNaVuw4xv640AwY1BHgGf1VvCv0zWjvIA==
X-Received: by 2002:aa7:93a2:0:b029:333:64d3:e1f7 with SMTP id x2-20020aa793a20000b029033364d3e1f7mr33712898pff.25.1626882069640;
        Wed, 21 Jul 2021 08:41:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 19sm12148673pgh.6.2021.07.21.08.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:41:09 -0700 (PDT)
Date:   Wed, 21 Jul 2021 15:41:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Zi Yan <ziy@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Huang Ying <ying.huang@intel.com>,
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
Message-ID: <YPhAEcHOCZ5yII/T@google.com>
References: <20210720065529.716031-1-ying.huang@intel.com>
 <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
 <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
 <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
 <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021, Yang Shi wrote:
> On Tue, Jul 20, 2021 at 2:04 PM Zi Yan <ziy@nvidia.com> wrote:
> >
> > On 20 Jul 2021, at 16:53, Yang Shi wrote:
> >
> > > On Tue, Jul 20, 2021 at 7:25 AM Christian Borntraeger
> > > <borntraeger@de.ibm.com> wrote:
> > >>> -     if (mm_tlb_flush_pending(vma->vm_mm)) {
> > >>> -             flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
> > >>> -             /*
> > >>> -              * change_huge_pmd() released the pmd lock before
> > >>> -              * invalidating the secondary MMUs sharing the primary
> > >>> -              * MMU pagetables (with ->invalidate_range()). The
> > >>> -              * mmu_notifier_invalidate_range_end() (which
> > >>> -              * internally calls ->invalidate_range()) in
> > >>> -              * change_pmd_range() will run after us, so we can't
> > >>> -              * rely on it here and we need an explicit invalidate.
> > >>> -              */
> > >>> -             mmu_notifier_invalidate_range(vma->vm_mm, haddr,
> > >>> -                                           haddr + HPAGE_PMD_SIZE);
> > >>> -     }
> > >>> CC Paolo/KVM list so we also remove the mmu notifier here. Do we need those
> > >> now in migrate_pages? I am not an expert in that code, but I cant find
> > >> an equivalent mmu_notifier in migrate_misplaced_pages.
> > >> I might be totally wrong, just something that I noticed.
> > >
> > > Do you mean the missed mmu notifier invalidate for the THP migration
> > > case? Yes, I noticed that too. But I'm not sure whether it is intended
> > > or just missed.
> >
> > From my understand of mmu_notifier document, mmu_notifier_invalidate_range()
> > is needed only if the PTE is updated to point to a new page or the page pointed
> > by the PTE is freed. Page migration does not fall into either case.

The "new page" part of

  a page table entry is updated to point to a new page

is referring to a different physical page, i.e. a different pfn, not a different
struct page.  do_huge_pmd_numa_page() is moving a THP between nodes, thus it's
changing the backing pfn and needs to invalidate secondary MMUs at some point.

> > In addition, in migrate_pages(), more specifically try_to_migrate_one(),
> > there is a pair of mmu_notifier_invalidate_range_start() and
> > mmu_notifier_invalidate_range_end() around the PTE manipulation code, which should
> > be sufficient to notify secondary TLBs (including KVM) about the PTE change
> > for page migration. Correct me if I am wrong.
> 
> Thanks, I think you are correct. By looking into commit 7066f0f933a1
> ("mm: thp: fix mmu_notifier in migrate_misplaced_transhuge_page()"),
> the tlb flush and mmu notifier invalidate were needed since the old
> numa fault implementation didn't change PTE to migration entry so it
> may cause data corruption due to the writes from GPU secondary MMU.
> 
> The refactor does use the generic migration code which converts PTE to
> migration entry before copying data to the new page.

That's my understanding as well, based on this blurb from commit 7066f0f933a1.

    The standard PAGE_SIZEd migrate_misplaced_page is less accelerated and
    uses the generic migrate_pages which transitions the pte from
    numa/protnone to a migration entry in try_to_unmap_one() and flushes TLBs
    and all mmu notifiers there before copying the page.

That analysis/justification for removing the invalidate_range() call should be
captured in the changelog.  Confirmation from Andrea would be a nice bonus.
