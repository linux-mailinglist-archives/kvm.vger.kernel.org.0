Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01D15EA5CC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiIZMTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 08:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiIZMS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 08:18:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 535D18E4C4
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 04:01:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A961ED1;
        Mon, 26 Sep 2022 04:00:40 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC7BC3F66F;
        Mon, 26 Sep 2022 04:00:32 -0700 (PDT)
Date:   Mon, 26 Sep 2022 12:01:28 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end
 parameter as unused in setup_mmu()
Message-ID: <YzGGiDBtJ4z/sLS7@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-8-alexandru.elisei@arm.com>
 <20220920085815.qk6js67qjvken2kt@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920085815.qk6js67qjvken2kt@kamzik>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 10:58:15AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:46AM +0100, Alexandru Elisei wrote:
> > phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
> > room for the vmalloc area to grown down. This was made useless in commit
> > c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
> > setup_mmu() was changed to map all the detected memory regions without
> > changing their limits.
> 
> c1cd1a2bed69 was a start, but as that commit says, the 3G-4G region was
> still necessary due to assumptions in the virtual memory allocator. This
> patch needs to point out a vmalloc commit which removes that assumption
> as well for its justification.

By "made useless" I mean that after that commit phys_end has no influence
on the way setup_mmu() creates the translation tables.

Yes, it's a problem because on real hardware or with kvmtool, which allows
the user to specify where RAM starts, the test can be loaded at the same
address from where vmalloc() will start allocating memory. But I think that
should be fixed separately from this series, maybe as part of the main
UEFI series, or as a separate patch(es).

I'll drop this patch, and leave any cleanups for when the vmalloc area
change is implemented.

Thanks,
Alex

> 
> Thanks,
> drew
> 
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/arm/mmu.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index e1a72fe4941f..8f936acafe8b 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
> >  	}
> >  }
> >  
> > -void *setup_mmu(phys_addr_t phys_end, void *unused)
> > +void *setup_mmu(phys_addr_t unused0, void *unused1)
> >  {
> >  	struct mem_region *r;
> >  
> > -	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
> > -	if (phys_end > (3ul << 30))
> > -		phys_end = 3ul << 30;
> > -
> >  #ifdef __aarch64__
> >  	init_alloc_vpage((void*)(4ul << 30));
> >  
> > -- 
> > 2.37.1
> > 
