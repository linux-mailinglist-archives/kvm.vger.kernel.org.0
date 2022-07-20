Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746D557BDA3
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbiGTSUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiGTSUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936761E3EB
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 11:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19EFB61923
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2ECC3411E;
        Wed, 20 Jul 2022 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658341213;
        bh=RFIC0wPWWnsb7x9huQFBiUskEG9V1MexNTrQ63YkjCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kh/XOeAj9yTK6Ny2ATKcdQn0Cqn2oJ+nbYN4qPBr0RDH22FynIsbmXDzNbcz76MwE
         Zgs1fqLrmj92GDLs4GILCkfVGANlveeYouqnKONFvJ2PEc59+9t7RnUgzb5U9pi14R
         eaLFTLt7887tOS6D4j5Q3Tn5sMcfLTyqpWv4x/v7xP9GJwL/88sbBd2NxRQ2LtovPR
         K+COdA12gkXBDZxmEV4ZKTTGyQHh/6D0+iuF6IIz9FUiffRk+Iw6lpaTsQ41c0SC19
         9/kRFMCFhjwspjT7l/5siBgxzZGRZe1aGvdBveMkfY1sFJiYWy9pohSAOeIgu0911r
         lcVH8wNo2eRlw==
Date:   Wed, 20 Jul 2022 19:20:05 +0100
From:   Will Deacon <will@kernel.org>
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/24] KVM: arm64: Introduce shadow VM state at EL2
Message-ID: <20220720182005.GB16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-13-will@kernel.org>
 <YtWpBYPrBcdyp9r6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWpBYPrBcdyp9r6@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vincent,

Thanks for going through this.

On Mon, Jul 18, 2022 at 07:40:05PM +0100, Vincent Donnefort wrote:
> [...]
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 9f339dffbc1a..2d6b5058f7d3 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -288,6 +288,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >   */
> >  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
> >  
> > +/*
> 
> /** ?
> 
> > + * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
> > + * @vtcr:	Content of the VTCR register.
> > + *
> > + * Return: the size (in bytes) of the stage-2 PGD
> > + */

I'll also check this is valid kernel-doc before adding the new comment
syntax!

> > +/*
> > + * Holds the relevant data for maintaining the vcpu state completely at hyp.
> > + */
> > +struct kvm_shadow_vcpu_state {
> > +	/* The data for the shadow vcpu. */
> > +	struct kvm_vcpu shadow_vcpu;
> > +
> > +	/* A pointer to the host's vcpu. */
> > +	struct kvm_vcpu *host_vcpu;
> > +
> > +	/* A pointer to the shadow vm. */
> > +	struct kvm_shadow_vm *shadow_vm;
> 
> IMHO, those declarations are already self-explanatory. The comments above don't
> bring much.

Agreed, and Sean has ideas to rework bits of this as well. I'll drop the
comments.

> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 99c8d8b73e70..77aeb787670b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -7,6 +7,9 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/mm.h>
> >  #include <nvhe/fixed_config.h>
> > +#include <nvhe/mem_protect.h>
> > +#include <nvhe/memory.h>
> 
> I don't think this one is necessary, it is already included in mm.h.

I thought it was generally bad form to rely on transitive includes, as it
makes header rework even more painful than it already is.

> > +static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
> > +			     unsigned int nr_vcpus)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_vcpus; i++) {
> > +		struct kvm_vcpu *host_vcpu = shadow_vcpu_states[i].host_vcpu;
> 
> IIRC, checkpatch likes an empty line after declarations.

We can fix that!

> > +static unsigned int insert_shadow_table(struct kvm *kvm,
> > +					struct kvm_shadow_vm *vm,
> > +					size_t shadow_size)
> > +{
> > +	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
> > +	unsigned int shadow_handle;
> > +	unsigned int vmid;
> > +
> > +	hyp_assert_lock_held(&shadow_lock);
> > +
> > +	if (unlikely(nr_shadow_entries >= KVM_MAX_PVMS))
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Initializing protected state might have failed, yet a malicious host
> > +	 * could trigger this function. Thus, ensure that shadow_table exists.
> > +	 */
> > +	if (unlikely(!shadow_table))
> > +		return -EINVAL;
> > +
> > +	/* Check that a shadow hasn't been created before for this host KVM. */
> > +	if (unlikely(__exists_shadow(kvm)))
> > +		return -EEXIST;
> > +
> > +	/* Find the next free entry in the shadow table. */
> > +	while (shadow_table[next_shadow_alloc])
> > +		next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;
> 
> Couldn't it be merged with __exists_shadow which already knows the first free
> shadow_table idx?

Good idea, that would save us going through it twice.

> 
> > +	shadow_handle = idx_to_shadow_handle(next_shadow_alloc);
> > +
> > +	vm->kvm.arch.pkvm.shadow_handle = shadow_handle;
> > +	vm->shadow_area_size = shadow_size;
> > +
> > +	/* VMID 0 is reserved for the host */
> > +	vmid = next_shadow_alloc + 1;
> > +	if (vmid > 0xff)
> 
> Couldn't the 0xff be found with get_vmid_bits() or even from host_kvm.arch.vtcr?
> Or does that depends on something completely different?
> 
> Also, appologies if this has been discussed already and I missed it, maybe
> KVM_MAX_PVMS could be changed for that value - 1. Unless we think that archs
> supporting 16 bits would waste way too much memory for that?

We should probably clamp the VMID based on KVM_MAX_PVMS here, as although
some CPUs support 16-bit VMIDs, we don't currently support that with pKVM.
I'll make that change to avoid hard-coding the constant here.

Thanks!

Will
