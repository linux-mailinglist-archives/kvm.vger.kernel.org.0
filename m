Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938BC60310C
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJRQwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJRQw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:52:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF774EB74B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:52:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AB5E113E;
        Tue, 18 Oct 2022 09:52:33 -0700 (PDT)
Received: from lakrids (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E1813F7D8;
        Tue, 18 Oct 2022 09:52:25 -0700 (PDT)
Date:   Tue, 18 Oct 2022 17:52:18 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 14/25] KVM: arm64: Add per-cpu fixmap infrastructure
 at EL2
Message-ID: <Y07Zwsn+oFbMWeKI@lakrids>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-15-will@kernel.org>
 <Y06Iihi/RPAOMuwR@FVFF77S0Q05N>
 <20221018140514.GA3323@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018140514.GA3323@willie-the-truck>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 03:05:14PM +0100, Will Deacon wrote:
> Hi Mark,
> 
> Cheers for having a look.
> 
> On Tue, Oct 18, 2022 at 12:06:14PM +0100, Mark Rutland wrote:
> > On Mon, Oct 17, 2022 at 12:51:58PM +0100, Will Deacon wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > index d3a3b47181de..b77215630d5c 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > @@ -14,6 +14,7 @@
> > >  #include <nvhe/early_alloc.h>
> > >  #include <nvhe/gfp.h>
> > >  #include <nvhe/memory.h>
> > > +#include <nvhe/mem_protect.h>
> > >  #include <nvhe/mm.h>
> > >  #include <nvhe/spinlock.h>
> > >  
> > > @@ -25,6 +26,12 @@ unsigned int hyp_memblock_nr;
> > >  
> > >  static u64 __io_map_base;
> > >  
> > > +struct hyp_fixmap_slot {
> > > +	u64 addr;
> > > +	kvm_pte_t *ptep;
> > > +};
> > > +static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);
> > > +
> > >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> > >  				  unsigned long phys, enum kvm_pgtable_prot prot)
> > >  {
> > > @@ -212,6 +219,93 @@ int hyp_map_vectors(void)
> > >  	return 0;
> > >  }
> > >  
> > > +void *hyp_fixmap_map(phys_addr_t phys)
> > > +{
> > > +	struct hyp_fixmap_slot *slot = this_cpu_ptr(&fixmap_slots);
> > > +	kvm_pte_t pte, *ptep = slot->ptep;
> > > +
> > > +	pte = *ptep;
> > > +	pte &= ~kvm_phys_to_pte(KVM_PHYS_INVALID);
> > > +	pte |= kvm_phys_to_pte(phys) | KVM_PTE_VALID;
> > > +	WRITE_ONCE(*ptep, pte);
> > > +	dsb(nshst);
> > > +
> > > +	return (void *)slot->addr;
> > > +}
> > > +
> > > +static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
> > > +{
> > > +	kvm_pte_t *ptep = slot->ptep;
> > > +	u64 addr = slot->addr;
> > > +
> > > +	WRITE_ONCE(*ptep, *ptep & ~KVM_PTE_VALID);
> > > +	dsb(nshst);
> > > +	__tlbi_level(vale2, __TLBI_VADDR(addr, 0), (KVM_PGTABLE_MAX_LEVELS - 1));
> > > +	dsb(nsh);
> > > +	isb();
> > > +}
> > 
> > Does each CPU have independent Stage-1 tables at EL2? i.e. each has a distinct
> > root table?
> 
> No, the CPUs share the same stage-1 table at EL2.

Ah, then I think there's a problem here.

> > If the tables are shared, you need broadcast maintenance and ISH barriers here,
> > or you risk the usual issues with asynchronous MMU behaviour.
> 
> Can you elaborate a bit, please? What we're trying to do is reserve a page
> of VA space for each CPU, which is only ever accessed explicitly by that
> CPU using a normal memory mapping. The fixmap code therefore just updates
> the relevant leaf entry for the CPU on which we're running and the TLBI
> is there to ensure that the new mapping takes effect.
> 
> If another CPU speculatively walks another CPU's fixmap slot, then I agree
> that it could access that page after the slot had been cleared. Although
> I can see theoretical security arguments around avoiding that situation,
> there's a very real performance cost to broadcast invalidation that we
> were hoping to avoid on this fast path.

The issue is that any CPU could walk any of these entries at any time
for any reason, and without broadcast maintenance we'd be violating the
Break-Before-Make requirements. That permits a number of things,
including "amalgamation", which would permit the CPU to consume some
arbitrary function of the old+new entries. Among other things, that can
permit accesses to entirely bogus physical addresses that weren't in
either entry (e.g. making speculative accesses to arbitrary device
addresses).

For correctness, you need the maintenance to be broadcast to all PEs
which could observe the old and new entries.

> Of course, in the likely event that I've purged "the usual issues" from
> my head and we need broadcasting for _correctness_, then we'll just have
> to suck it up!

As above, I believe you need this for correctness.

I'm not sure if FEAT_BBM level 2 gives you the necessary properties to
relax this on some HW.

Thanks,
Mark.
