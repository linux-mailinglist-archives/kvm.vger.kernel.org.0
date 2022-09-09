Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3A5B34D2
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiIIKIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiIIKIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:08:15 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4824EA611;
        Fri,  9 Sep 2022 03:08:11 -0700 (PDT)
Date:   Fri, 9 Sep 2022 11:07:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662718090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gNzaPZG1mLQyJyRsZVtVFOttl8uuZk01rBnRTGZpE+s=;
        b=uk4H9WhHFnTUkmuLpAFALPIaa+FU2UKVZ2XPdSwdnhtmtIobV8lxEqLkVO7Y7jbn01QNbB
        1IXt1sYeBb3Il0++CysKXgK+Hj0N/NTHW8+zOLFKdpKtjUJ+HWy/8ou2g7YtsfTllff+lu
        2L610rpZepsKnUQVPIxZalH6CRJXp8U=
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
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <YxsQfwJ++izBQuEi@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
 <YxkFrSmSKdBFEoZp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxkFrSmSKdBFEoZp@google.com>
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

On Wed, Sep 07, 2022 at 01:57:17PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:20PM +0000, Oliver Upton wrote:
> [...]
> >  
> > +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > +				struct stage2_map_data *data);
> > +
> >  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> >  				     kvm_pte_t *ptep,
> >  				     struct stage2_map_data *data)
> >  {
> > -	if (data->anchor)
> 
> Should @anchor and @childp be removed from struct stage2_map_data? This
> commit removes the only remaining references to them.

Yup, I'll toss those in the next spin.

> > -		return 0;
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> > +	struct kvm_pgtable *pgt = data->mmu->pgt;
> > +	int ret;
> >  
> >  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
> >  		return 0;
> >  
> > -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
> >  	kvm_clear_pte(ptep);
> >  
> >  	/*
> [...]
> >  static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  			     enum kvm_pgtable_walk_flags flag, void * const arg)
> > @@ -883,11 +849,9 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
> >  	case KVM_PGTABLE_WALK_LEAF:
> >  		return stage2_map_walk_leaf(addr, end, level, ptep, data);
> > -	case KVM_PGTABLE_WALK_TABLE_POST:
> > -		return stage2_map_walk_table_post(addr, end, level, ptep, data);
> 
> kvm_pgtable_stage2_set_owner() still uses stage2_map_walker() with
> KVM_PGTABLE_WALK_TABLE_POST.

Good catch, I'll drop the TABLE_POST flag there as well.

Appreciate the reviews on the series.

--
Thanks,
Oliver
