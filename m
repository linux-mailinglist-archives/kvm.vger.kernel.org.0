Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459E9602DE5
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJROF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJROF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:05:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11204C4DB4
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2789B81F73
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A267C433B5;
        Tue, 18 Oct 2022 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666101921;
        bh=7enIwia2O0x8eQSQ3lN0e02m+bCbVuNSE08teTk7wfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MzeEm2IeAqmyEeS0iezWjjHpiUfqP+9+5hX7TTmS103U478iW/gmgo7sD8vtU0FFN
         uvp8EzPv3dOeRqrmpe/VuaWbES13WD7M9qAOmgwEqCWUrbPOosKsPDwZsT8BkfsNMF
         rQHFNAkQsaVZXeNZKOBgdRmW71P/4kSQFhWeHc3cQwJGknSjreQAgLFeVG6/NQ0fhs
         ojsDVGW2ieCZAE2bZFkkamJ+uVaq4NZ8eJJtP5ogpEdgjqafMspcZ8SVVcFLhhCyBn
         99O2Wi6NjuSeZD/wFDuESSE4a8r7kxvlBgKAhGiy8smBMB7UmGDc7kvk5/WP/l2ebc
         cwMtPl6VpHw9A==
Date:   Tue, 18 Oct 2022 15:05:14 +0100
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20221018140514.GA3323@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-15-will@kernel.org>
 <Y06Iihi/RPAOMuwR@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y06Iihi/RPAOMuwR@FVFF77S0Q05N>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

Cheers for having a look.

On Tue, Oct 18, 2022 at 12:06:14PM +0100, Mark Rutland wrote:
> On Mon, Oct 17, 2022 at 12:51:58PM +0100, Will Deacon wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index d3a3b47181de..b77215630d5c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -14,6 +14,7 @@
> >  #include <nvhe/early_alloc.h>
> >  #include <nvhe/gfp.h>
> >  #include <nvhe/memory.h>
> > +#include <nvhe/mem_protect.h>
> >  #include <nvhe/mm.h>
> >  #include <nvhe/spinlock.h>
> >  
> > @@ -25,6 +26,12 @@ unsigned int hyp_memblock_nr;
> >  
> >  static u64 __io_map_base;
> >  
> > +struct hyp_fixmap_slot {
> > +	u64 addr;
> > +	kvm_pte_t *ptep;
> > +};
> > +static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);
> > +
> >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >  				  unsigned long phys, enum kvm_pgtable_prot prot)
> >  {
> > @@ -212,6 +219,93 @@ int hyp_map_vectors(void)
> >  	return 0;
> >  }
> >  
> > +void *hyp_fixmap_map(phys_addr_t phys)
> > +{
> > +	struct hyp_fixmap_slot *slot = this_cpu_ptr(&fixmap_slots);
> > +	kvm_pte_t pte, *ptep = slot->ptep;
> > +
> > +	pte = *ptep;
> > +	pte &= ~kvm_phys_to_pte(KVM_PHYS_INVALID);
> > +	pte |= kvm_phys_to_pte(phys) | KVM_PTE_VALID;
> > +	WRITE_ONCE(*ptep, pte);
> > +	dsb(nshst);
> > +
> > +	return (void *)slot->addr;
> > +}
> > +
> > +static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
> > +{
> > +	kvm_pte_t *ptep = slot->ptep;
> > +	u64 addr = slot->addr;
> > +
> > +	WRITE_ONCE(*ptep, *ptep & ~KVM_PTE_VALID);
> > +	dsb(nshst);
> > +	__tlbi_level(vale2, __TLBI_VADDR(addr, 0), (KVM_PGTABLE_MAX_LEVELS - 1));
> > +	dsb(nsh);
> > +	isb();
> > +}
> 
> Does each CPU have independent Stage-1 tables at EL2? i.e. each has a distinct
> root table?

No, the CPUs share the same stage-1 table at EL2.

> If the tables are shared, you need broadcast maintenance and ISH barriers here,
> or you risk the usual issues with asynchronous MMU behaviour.

Can you elaborate a bit, please? What we're trying to do is reserve a page
of VA space for each CPU, which is only ever accessed explicitly by that
CPU using a normal memory mapping. The fixmap code therefore just updates
the relevant leaf entry for the CPU on which we're running and the TLBI
is there to ensure that the new mapping takes effect.

If another CPU speculatively walks another CPU's fixmap slot, then I agree
that it could access that page after the slot had been cleared. Although
I can see theoretical security arguments around avoiding that situation,
there's a very real performance cost to broadcast invalidation that we
were hoping to avoid on this fast path.

Of course, in the likely event that I've purged "the usual issues" from
my head and we need broadcasting for _correctness_, then we'll just have
to suck it up!

Cheers,

Will
