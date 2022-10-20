Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44D605A00
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJTIfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJTIet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:34:49 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACD83E753
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:34:35 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:34:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666254872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qzX6SzV6RdnXytSM2ouehoSyV7++gCHengCJvmVIT7s=;
        b=ha7Agfr0EZ1HqBNwRgfdeT84BnPAGCdqCmWxiw8zIoxjGznrHHmeb8r2ZOT6kEIhjttnjI
        JvxjjwysVU/zudV3hs35G+nF2vyB/lOZmRkFRbJiEHOWfZ3PgsVHrBtc/g4SKQQcQZBtBN
        V/iHop8+q44+UHjRL4hZo422bZj8pPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1EIEOoelp+ZG3+I@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-9-oliver.upton@linux.dev>
 <Y1CIdN5kcJPaZdqv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1CIdN5kcJPaZdqv@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 11:29:56PM +0000, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Oliver Upton wrote:
> > The use of RCU is necessary to safely change the stage-2 page tables in
> > parallel. Acquire and release the RCU read lock when traversing the page
> > tables.
> > 
> > Use the _raw() flavor of rcu_dereference when changes to the page tables
> > are otherwise protected from parallel software walkers (e.g. holding the
> > write lock).
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> 
> ...
> 
> > @@ -32,6 +39,33 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
> >  	return pteref;
> >  }
> >  
> > +static inline void kvm_pgtable_walk_begin(void) {}
> > +static inline void kvm_pgtable_walk_end(void) {}
> > +
> > +#else
> > +
> > +typedef kvm_pte_t __rcu *kvm_pteref_t;
> > +
> > +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> > +{
> > +	if (shared)
> > +		return rcu_dereference(pteref);
> > +
> > +	return rcu_dereference_raw(pteref);
> 
> Rather than use raw, use rcu_dereference_check().  If you can plumb down @kvm or
> @mmu_lock, the ideal check would be (apparently there's no lockdep_is_held_write()
> wrapper?)
> 
> 	return READ_ONCE(*rcu_dereference_check(ptep, lockdep_is_held_type(mmu_lock, 0)));
> 
> If getting at mmu_lock is too difficult, this can still be
> 
> 	return READ_ONCE(*rcu_dereference_check(ptep, !shared);
> 
> Doubt it matters for code generation, but IMO it's cleaner overall.

As the page table walkers can be used outside of the context of a VM
(such as hyp stage-1), I think option #2 is probably a bit easier.

--
Thanks,
Oliver
