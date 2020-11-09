Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40F2AB896
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgKIMuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 07:50:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbgKIMtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 07:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604926156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMq65+RS221tbZEZxH7zJ+KzWE6w9fiXN4qoifV9OXk=;
        b=VXkrl5WBtc3aLDWLPa+uhaa8qVpFV+UIQh08hWmWzR51xyR+bUiDND5GWmTD4Obrs3JHC9
        CWA/tDmlyGO0h+5hKHgTqN2y1+8cNkiylC9lYOGLwkPQ2VfaFyfWIAqMtQ7ayKUsM3MHMQ
        dt1lU8/XchTBDmlbm3MpnUmtFAgNLis=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-6wYlJr6uPE2AZ3Bahlamgg-1; Mon, 09 Nov 2020 07:49:14 -0500
X-MC-Unique: 6wYlJr6uPE2AZ3Bahlamgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0FA79CC08;
        Mon,  9 Nov 2020 12:49:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B6311A268;
        Mon,  9 Nov 2020 12:49:10 +0000 (UTC)
Date:   Mon, 9 Nov 2020 13:49:07 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Add mmu_get_pte() to the MMU API
Message-ID: <20201109124907.bgukuhilbbhcaxix@kamzik.brq.redhat.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201102115311.103750-2-nikos.nikoleris@arm.com>
 <f347911e-bca6-3124-7f4a-4a61ec0cb7ab@arm.com>
 <4a142934-732d-d5de-dbc0-75728f1484b7@arm.com>
 <dc229673-8bf8-7b4a-554b-2515895ce48f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc229673-8bf8-7b4a-554b-2515895ce48f@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 12:36:36PM +0000, Alexandru Elisei wrote:
> Hi Nikos,
> 
> On 11/7/20 11:01 AM, Nikos Nikoleris wrote:
> > Hi Alex,
> >
> > On 05/11/2020 14:27, Alexandru Elisei wrote:
> >> Hi Nikos,
> >>
> >> Very good idea! Minor comments below.
> >>
> >> On 11/2/20 11:53 AM, Nikos Nikoleris wrote:
> >>> From: Luc Maranget <Luc.Maranget@inria.fr>
> >>>
> >>> Add the mmu_get_pte() function that allows a test to get a pointer to
> >>> the PTE for a valid virtual address. Return NULL if the MMU is off.
> >>>
> >>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> >>
> >> Missing Signed-off-by from Luc Maranget.
> >>
> >>> ---
> >>>   lib/arm/asm/mmu-api.h |  1 +
> >>>   lib/arm/mmu.c         | 23 ++++++++++++++---------
> >>>   2 files changed, 15 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> >>> index 2bbe1fa..3d04d03 100644
> >>> --- a/lib/arm/asm/mmu-api.h
> >>> +++ b/lib/arm/asm/mmu-api.h
> >>> @@ -22,5 +22,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t
> >>> virt_offset,
> >>>   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
> >>>                      phys_addr_t phys_start, phys_addr_t phys_end,
> >>>                      pgprot_t prot);
> >>> +extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
> >>>   extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
> >>>   #endif
> >>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> >>> index 51fa745..2113604 100644
> >>> --- a/lib/arm/mmu.c
> >>> +++ b/lib/arm/mmu.c
> >>> @@ -210,7 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
> >>>       return addr;
> >>>   }
> >>>   -void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
> >>> +pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
> >>
> >> I was thinking it might be nice to have a comment here reminding callers to use
> >> break-before-make when necessary, with a reference to the pages in the Arm ARM
> >> where the exact conditions can be found (D5-2669 for armv8, B3-1378 for armv7). It
> >> might save someone a lot of time debugging a once in 100 runs bug because they
> >> forgot to do break-before-make. And having the exact page number will make it much
> >> easier to find the relevant section.
> >
> > Good idea if this is part of the API, it would be good to have a reference to
> > break-before-make. I am thinking of adding it in lib/arm/asm/mmu-api.h where the
> > MMU API is, just before the declaration:
> >
> > extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
> >
> > or would you rather have it in lib/arm/mmu.c with the code?
> 
> There are no function comments anywhere in mmu-api.h or mmu.c, so I guess it's up
> to you where you want to put it. I believe the usual convention is to put the
> comments where the function is implemented because it's easier to understand what
> the function does if the comment is right above it, and it makes it easier if you
> have one prototype in a header file and multiple implementations in different .c
> files. I see some comments in io.c and gic.c which seem to follow this convention
> (unless Drew prefers otherwise).
>

I prefer the comment at the implementation.

Thanks,
drew 

