Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488BE3D0395
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 23:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhGTUZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 16:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbhGTUNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 16:13:32 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AB2C061574;
        Tue, 20 Jul 2021 13:53:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qa36so14911840ejc.10;
        Tue, 20 Jul 2021 13:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44qk/SPvu//rgjLJF5jwtYI5ft2vVL7G4C4DfylIoXY=;
        b=OftM9WCENnpMqTUJsIA3MKKjn708iT/Lw3yrY6lH1pEDZ27vJs7PaELvwkvhNb8fmq
         TjIN5vWnEzofvLkBgJEnMz+x9HVXlenHZlFjtpMGCMvkk8h6cYk1gulnF1aNzwJNTTLe
         +Wb57w1ZES/sxVHMNDmVbbYawPgdjbEyJSny4a3qM5jkJ1EmXKm6dzYC5fG0O6gGW/eW
         mrrsdNiL6JC6ad6SN09iCU9B6OXaIIEbe0vZElpqM2NfG0owmt+qu0lOZ5DNKdzBAK/Y
         s/1nloGCdGw9CWDd/JVvMBPp8MG2Kr5EyKI1mhcQ/Wl9BJ2PFTz2qkr3d2mCOfTwLTTN
         zfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44qk/SPvu//rgjLJF5jwtYI5ft2vVL7G4C4DfylIoXY=;
        b=PTJntb9Yj0H3GG2xCnYLnemGMTENnmwjqOPhpR9etYqMt+pQZhsEHdOV/VXkqMJtmu
         uSf/3KPFEZQyXRItMKts2E9vcUJNznMpI6lWWbAzLSrNe7X4Gcppu+452RPv2JiNpr2n
         R1+xZR2DTOr/g/BlscHCWwe3qZ7+GHCIwXr7inyq5N5HuBYIpokTyE9ig6fIP9ik+CTo
         oJFoU6hzyPk9LEhV5PavoWBqxX36ZxDvkjVXDfGnYDDMlBJ0vKbmKE+BbynpYDiUuIYB
         r8o+2dnGPvmUBUfr5wA2fTMP6BOdfyGKSjuufjJGeqCN4OW3fQOQtOo7hbcqfMYyGr80
         2Y5g==
X-Gm-Message-State: AOAM531wxD05YYXi+dZyLVlk0aNLM8BSybvVaU5oL16IfGVUGkY3nfM2
        dWxgjC6r5zFj82aWJlSjXk+sqCB2vr8Pvp4dGsc=
X-Google-Smtp-Source: ABdhPJwUAntyq17ENwtwuvmBlgGc6On+crRf2x/UG5Ey0hWO7A9tRypRUaEosm0MRG3hgYJ+pgeYJHAQyPd6Thw1qro=
X-Received: by 2002:a17:907:4cf:: with SMTP id vz15mr34336344ejb.161.1626814434101;
 Tue, 20 Jul 2021 13:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210720065529.716031-1-ying.huang@intel.com> <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
In-Reply-To: <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 20 Jul 2021 13:53:39 -0700
Message-ID: <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing code
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Huang Ying <ying.huang@intel.com>,
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
        Vasily Gorbik <gor@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021 at 7:25 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 20.07.21 08:55, Huang Ying wrote:
> > Before the commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> > handling"), the TLB flushing is done in do_huge_pmd_numa_page() itself
> > via flush_tlb_range().
> >
> > But after commit c5b5a3dd2c1f ("mm: thp: refactor NUMA fault
> > handling"), the TLB flushing is done in migrate_pages() as in the
> > following code path anyway.
> >
> > do_huge_pmd_numa_page
> >    migrate_misplaced_page
> >      migrate_pages
> >
> > So now, the TLB flushing code in do_huge_pmd_numa_page() becomes
> > unnecessary.  So the code is deleted in this patch to simplify the
> > code.  This is only code cleanup, there's no visible performance
> > difference.
> >
> > Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
> > Cc: Yang Shi <shy828301@gmail.com>
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > ---
> >   mm/huge_memory.c | 26 --------------------------
> >   1 file changed, 26 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index afff3ac87067..9f21e44c9030 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1440,32 +1440,6 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
> >               goto out;
> >       }
> >
> > -     /*
> > -      * Since we took the NUMA fault, we must have observed the !accessible
> > -      * bit. Make sure all other CPUs agree with that, to avoid them
> > -      * modifying the page we're about to migrate.
> > -      *
> > -      * Must be done under PTL such that we'll observe the relevant
> > -      * inc_tlb_flush_pending().
> > -      *
> > -      * We are not sure a pending tlb flush here is for a huge page
> > -      * mapping or not. Hence use the tlb range variant
> > -      */
> > -     if (mm_tlb_flush_pending(vma->vm_mm)) {
> > -             flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
> > -             /*
> > -              * change_huge_pmd() released the pmd lock before
> > -              * invalidating the secondary MMUs sharing the primary
> > -              * MMU pagetables (with ->invalidate_range()). The
> > -              * mmu_notifier_invalidate_range_end() (which
> > -              * internally calls ->invalidate_range()) in
> > -              * change_pmd_range() will run after us, so we can't
> > -              * rely on it here and we need an explicit invalidate.
> > -              */
> > -             mmu_notifier_invalidate_range(vma->vm_mm, haddr,
> > -                                           haddr + HPAGE_PMD_SIZE);
> > -     }
> > CC Paolo/KVM list so we also remove the mmu notifier here. Do we need those
> now in migrate_pages? I am not an expert in that code, but I cant find
> an equivalent mmu_notifier in migrate_misplaced_pages.
> I might be totally wrong, just something that I noticed.

Do you mean the missed mmu notifier invalidate for the THP migration
case? Yes, I noticed that too. But I'm not sure whether it is intended
or just missed.

Zi Yan is the author for THP migration code, he may have some clue.

>
> >       pmd = pmd_modify(oldpmd, vma->vm_page_prot);
> >       page = vm_normal_page_pmd(vma, haddr, pmd);
> >       if (!page)
> >
