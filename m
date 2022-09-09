Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103295B34A7
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIIJ4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiIIJ4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:56:35 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5C112D19E;
        Fri,  9 Sep 2022 02:56:10 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:55:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662717368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lDpC67NopcBY3WkfHCdst9Y40eb0+fWa3aZaj8C1P74=;
        b=LVUcgLVEKlJeyJh274QBbSm2SunUsd/+Fnhi8Oa83s4LnsBzI0E2D1UEwYFcXtQEulUU+W
        LVnoIby+wN2xFlyIPs/26HCtShwG9QsGAppu7ff2QUan911DOy14slnZlOYJWqyTLNYjZD
        NI3YBiakBpwSB/KZjauRUKa3/8sbkjE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Message-ID: <YxsNr+79UUm5Go9x@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-9-oliver.upton@linux.dev>
 <YxkRXLsLuhjBNanT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxkRXLsLuhjBNanT@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 02:47:08PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:26PM +0000, Oliver Upton wrote:
> > The use of RCU is necessary to change the paging structures in parallel.
> > Acquire and release an RCU read lock when traversing the page tables.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
> >  2 files changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 78fbb7be1af6..7d2de0a98ccb 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
> >   */
> >  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> >  
> > +#if defined(__KVM_NVHE_HYPERVISOR___)
> > +
> 
> Future readers will wonder why NVHE stubs out RCU support and how that
> is even correct. Some comments here would be useful explain it.

Good point.

> > +static inline void kvm_pgtable_walk_begin(void) {}
> > +static inline void kvm_pgtable_walk_end(void) {}
> > +
> > +#define kvm_dereference_ptep rcu_dereference_raw
> 
> How does NVHE have access rcu_dereference_raw()?

rcu_dereference_raw() is inlined and simply recasts the pointer into the
kernel address space.

Perhaps it is less confusing to template this on kvm_pte_read() to avoid
polluting nVHE with an otherwise benign reference to RCU.

> > +
> > +#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
> > +
> > +#define kvm_pgtable_walk_begin	rcu_read_lock
> > +#define kvm_pgtable_walk_end	rcu_read_unlock
> > +#define kvm_dereference_ptep	rcu_dereference
> > +
> > +#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
> > +
> >  static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
> >  {
> > -	return READ_ONCE(*ptep);
> > +	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
> > +
> > +	return READ_ONCE(*kvm_dereference_ptep(p));
> 
> What about all the other places where page table memory is accessed?
> 
> If RCU is going to be used to protect page table memory, then all
> accesses have to go under an RCU critical section. This means that page
> table memory should only be accessed through __rcu annotated pointers
> and dereferenced with rcu_dereference().

Let me play around with this a bit, as the annoying part is trying to
sprinkle in RCU annotations w/o messing with nVHE. 

--
Thanks,
Oliver
