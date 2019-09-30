Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC70C240C
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfI3POh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbfI3POh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:14:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A0C2285542;
        Mon, 30 Sep 2019 15:14:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D3795D9C3;
        Mon, 30 Sep 2019 15:14:34 +0000 (UTC)
Date:   Mon, 30 Sep 2019 17:14:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, mark.rutland@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 2/3] lib: arm/arm64: Add function to clear
 the PTE_USER bit
Message-ID: <20190930151432.zgcaxtn7glrffkkn@kamzik.brq.redhat.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
 <20190930142508.25102-3-alexandru.elisei@arm.com>
 <20190930145357.o7pq5ysttui2pjjm@kamzik.brq.redhat.com>
 <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33705e8-fd12-86db-be64-dca9900a5555@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 30 Sep 2019 15:14:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 04:09:49PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On 9/30/19 3:53 PM, Andrew Jones wrote:
> 
> > On Mon, Sep 30, 2019 at 03:25:07PM +0100, Alexandru Elisei wrote:
> > > The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
> > > (EL0, on arm64, or PL0, on arm) can read and write from that memory
> > > location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
> > > when is set [3]. Add a function to clear the bit which we can use when we
> > > want to execute code from that page or the prevent access from lower
> > > exception levels.
> > > 
> > > Make it available to arm too, in case someone needs it at some point.
> > > 
> > > [1] ARM DDI 0406C.d, Table B3-6
> > > [2] ARM DDI 0487E.a, table D5-28
> > > [3] ARM DDI 0487E.a, table D5-33
> > > 
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >   lib/arm/asm/mmu-api.h |  1 +
> > >   lib/arm/mmu.c         | 15 +++++++++++++++
> > >   2 files changed, 16 insertions(+)
> > > 
> > > diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> > > index df3ccf7bc7e0..8fe85ba31ec9 100644
> > > --- a/lib/arm/asm/mmu-api.h
> > > +++ b/lib/arm/asm/mmu-api.h
> > > @@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
> > >   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
> > >   			       phys_addr_t phys_start, phys_addr_t phys_end,
> > >   			       pgprot_t prot);
> > > +extern void mmu_clear_user(unsigned long vaddr);
> > >   #endif
> > > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > > index 3d38c8397f5a..78db22e6af14 100644
> > > --- a/lib/arm/mmu.c
> > > +++ b/lib/arm/mmu.c
> > > @@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
> > >   	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
> > >   	return addr;
> > >   }
> > > +
> > > +void mmu_clear_user(unsigned long vaddr)
> > > +{
> > > +	pgd_t *pgtable;
> > > +	pteval_t *pte;
> > > +
> > > +	if (!mmu_enabled())
> > > +		return;
> > > +
> > > +	pgtable = current_thread_info()->pgtable;
> > > +	pte = get_pte(pgtable, vaddr);
> > > +
> > > +	*pte &= ~PTE_USER;
> > > +	flush_tlb_page(vaddr);
> > > +}
> > > -- 
> > > 2.20.1
> > > 
> > This is fine, but I think you could just export get_pte() and then
> > implement the PTE_USER clearing in the cache unit test instead. Anyway,
> 
> I thought about that, but I opted to make this a library function because I
> would like to modify it to also act on block mappings and use it in patch #4
> from the EL2 series (the patch that adds the prefetch abort test), and send
> that change as part of the EL2 series. I am assuming that this patch set
> will get merged before the EL2 series.

Yeah, I need to get back to that EL2 series. I just need to wrap up a
couple more things and then I'll be able to focus on it. If you have
some plans to refresh it, then feel free to do that now. When I get
back to it, I'll just jump into the refreshed version.

Thanks,
drew
