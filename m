Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4C53D0477
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 00:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhGTVlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 17:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbhGTVja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 17:39:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868B7C061574;
        Tue, 20 Jul 2021 15:20:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dj21so30442760edb.0;
        Tue, 20 Jul 2021 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x7JmVa6y/UxTfaCe/AUj//AP0XdgR4+S1fhuystE3/E=;
        b=dOx3ohMHYsSpOXQotFv5lOPfvph/3jbXKrJ0oui54VB8nSBB/IAU+BrevrzWGLK8nZ
         smFmnrIWTZpV3tcYPTBKyElteqS32VFq7qlj1MzRjt3CDCLBOmocuYGSFBhCkXw7xfA7
         oPN7A2ic7NbwczD68m/6oLn8Xsd9dBgHNtjHI2ew8kERXttIxYoPnDeEddH4zmKkG9gb
         tP+Djl14Q7lQMAsBkjCDBzj/nW9WPx8AH4fywuLWgefGIYUySLYVatOduXt+NGqGb4BI
         /WWEygmlFnpBafBlEwa7Kao9jnuo2+OW66etEyaVwRBsR/E7kODjTMmfvNhxaEq7W93A
         lMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x7JmVa6y/UxTfaCe/AUj//AP0XdgR4+S1fhuystE3/E=;
        b=eriFL2xXWas5r2C96sQd64Z3i7HFlWzUBIAAJZt0I5A03eMjHrJsW6K1qZvSmq3ChU
         EXWry6XM/P9MFLKLSYCUUvRr7hmGuyhR7gvXotE1RZs/QvKhCb/zmM4dXMZONB2DDg4p
         Ajz/65klzGF6pjqm7RsR8+0lFK2ERBsk7WOYIPkBALKmb7obBvSrvEECwb9e95n1jnjZ
         5fK5X0pjHvdjQwM9XGUsfm7mfwxvQaTUms4nbo4XfELzF88HrNwjQ03/gCQ0t2y1A8Wq
         pr9gfGKXogumk7TaSrlJfJ3oUrDX385k4mw5dXvFSfUqTc5Lr45On98lc3IJlsLBfJvm
         jkfg==
X-Gm-Message-State: AOAM5309PIpBZ0BNLv547gq37zkyFvIPCisX3Q/M0qIDHqKFDBf54rEv
        sSlg7i3ilSRKj+Z0Vht6Ly9AvZWQ8Aw/XgpOAwQ=
X-Google-Smtp-Source: ABdhPJy9MwCAIcgSAEgHMfp+2OI6E/qr+2onYU8cfXajbpCOvqYq5P+fl6VSck1kFuwoULawBqq318bklW+vXBgGIC4=
X-Received: by 2002:aa7:c689:: with SMTP id n9mr44215925edq.151.1626819605059;
 Tue, 20 Jul 2021 15:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210720065529.716031-1-ying.huang@intel.com> <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
 <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com> <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
In-Reply-To: <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 20 Jul 2021 15:19:50 -0700
Message-ID: <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code
To:     Zi Yan <ziy@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021 at 2:04 PM Zi Yan <ziy@nvidia.com> wrote:
>
> On 20 Jul 2021, at 16:53, Yang Shi wrote:
>
> > On Tue, Jul 20, 2021 at 7:25 AM Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> >>
> >>
> >>
> >> On 20.07.21 08:55, Huang Ying wrote:
> >>> Before the commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> >>> handling"), the TLB flushing is done in do_huge_pmd_numa_page() itsel=
f
> >>> via flush_tlb_range().
> >>>
> >>> But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> >>> handling"), the TLB flushing is done in migrate_pages() as in the
> >>> following code path anyway.
> >>>
> >>> do_huge_pmd_numa_page
> >>>    migrate_misplaced_page
> >>>      migrate_pages
> >>>
> >>> So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
> >>> unnecessary.  So the code is deleted in this patch to simplify the
> >>> code.  This is only code cleanup, there's no visible performance
> >>> difference.
> >>>
> >>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> >>> Cc: Yang Shi <shy828301@gmail.com>
> >>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> >>> Cc: Mel Gorman <mgorman@suse.de>
> >>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> >>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> >>> Cc: Heiko Carstens <hca@linux.ibm.com>
> >>> Cc: Hugh Dickins <hughd@google.com>
> >>> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Vasily Gorbik <gor@linux.ibm.com>
> >>> Cc: Zi Yan <ziy@nvidia.com>
> >>> ---
> >>>   mm/huge_memory.c | 26 --------------------------
> >>>   1 file changed, 26 deletions(-)
> >>>
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index afff3ac87067..9f21e44c9030 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fau=
lt *vmf)
> >>>               goto out;
> >>>       }
> >>>
> >>> -     /*
> >>> -      * Since we took the NUMA fault, we must have observed the !acc=
essible
> >>> -      * bit. Make sure all other CPUs agree with that, to avoid them
> >>> -      * modifying the page we're about to migrate.
> >>> -      *
> >>> -      * Must be done under PTL such that we'll observe the relevant
> >>> -      * inc_tlb_flush_pending().
> >>> -      *
> >>> -      * We are not sure a pending tlb flush here is for a huge page
> >>> -      * mapping or not. Hence use the tlb range variant
> >>> -      */
> >>> -     if (mm_tlb_flush_pending(vma->vm_mm)) {
> >>> -             flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
> >>> -             /*
> >>> -              * change_huge_pmd() released the pmd lock before
> >>> -              * invalidating the secondary MMUs sharing the primary
> >>> -              * MMU pagetables (with ->invalidate_range()). The
> >>> -              * mmu_notifier_invalidate_range_end() (which
> >>> -              * internally calls ->invalidate_range()) in
> >>> -              * change_pmd_range() will run after us, so we can't
> >>> -              * rely on it here and we need an explicit invalidate.
> >>> -              */
> >>> -             mmu_notifier_invalidate_range(vma->vm_mm, haddr,
> >>> -                                           haddr + HPAGE_PMD_SIZE);
> >>> -     }
> >>> CC Paolo/KVM list so we also remove the mmu notifier here. Do we need=
 those
> >> now in migrate_pages? I am not an expert in that code, but I cant find
> >> an equivalent mmu_notifier in migrate_misplaced_pages.
> >> I might be totally wrong, just something that I noticed.
> >
> > Do you mean the missed mmu notifier invalidate for the THP migration
> > case? Yes, I noticed that too. But I'm not sure whether it is intended
> > or just missed.
>
> From my understand of mmu_notifier document, mmu_notifier_invalidate_rang=
e()
> is needed only if the PTE is updated to point to a new page or the page p=
ointed
> by the PTE is freed. Page migration does not fall into either case.
> In addition, in migrate_pages(), more specifically try_to_migrate_one(),
> there is a pair of mmu_notifier_invalidate_range_start() and
> mmu_notifier_invalidate_range_end() around the PTE manipulation code, whi=
ch should
> be sufficient to notify secondary TLBs (including KVM) about the PTE chan=
ge
> for page migration. Correct me if I am wrong.

Thanks, I think you are correct. By looking into commit 7066f0f933a1
("mm: thp: fix mmu_notifier in migrate_misplaced_transhuge_page()"),
the tlb flush and mmu notifier invalidate were needed since the old
numa fault implementation didn't change PTE to migration entry so it
may cause data corruption due to the writes from GPU secondary MMU.

The refactor does use the generic migration code which converts PTE to
migration entry before copying data to the new page.

>
> =E2=80=94
> Best Regards,
> Yan, Zi
