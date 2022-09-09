Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EFF5B3424
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiIIJim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiIIJif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:38:35 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36859E89D;
        Fri,  9 Sep 2022 02:38:33 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:38:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662716312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbjsJsmK8eNNPB1/qbrlalcNvip2GURuJ8l1XpwCdtA=;
        b=w5aYW3X82xa4eYEqN9xPSlbdWVdlzhVTNhVkxtP9f3wiaVyoildIroHN4Zy7CmcTTPA9wN
        SoANTcLFct9zHRFs4lgnTLNq94CjWzDWlcEX4gscm56lXU4biERICyRPbokXJYe5ydUMBs
        el+dRzkfzb1LVpFUKALFGbST86619Q8=
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
Subject: Re: [PATCH 06/14] KVM: arm64: Return next table from map callbacks
Message-ID: <YxsJj3ojGyhNw5Jn@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-7-oliver.upton@linux.dev>
 <YxkN7XmHiU3ddknR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxkN7XmHiU3ddknR@google.com>
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

Hi David,

On Wed, Sep 07, 2022 at 02:32:29PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:24PM +0000, Oliver Upton wrote:
> > The map walkers install new page tables during their traversal. Return
> > the newly-installed table PTE from the map callbacks to point the walker
> > at the new table w/o rereading the ptep.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 331f6e3b2c20..f911509e6512 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -202,13 +202,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
> >  		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
> >  					     KVM_PGTABLE_WALK_LEAF);
> > -		pte = *ptep;
> > -		table = kvm_pte_table(pte, level);
> >  	}
> >  
> >  	if (ret)
> >  		goto out;
> 
> Rather than passing a pointer to the local variable pte and requiring
> all downstream code to update it (and deal with dereferencing to read
> the old pte), wouldn't it be simpler to just re-read the PTE here?

Yeah, you're right. I had some odd rationalization about this, but
there's no need to force a walker to descend into the new table level as
it is wasted work if another thread unlinks it.

[...]

> >  
> > +	table = kvm_pte_table(pte, level);
> >  	if (!table) {
> 
> nit: Technically there's no reason to set @table again. e.g. This could
> just be:
> 
>         if (!kvm_pte_table(pte, level)) {

Sure, I'll squish these lines together.

--
Thanks,
Oliver
