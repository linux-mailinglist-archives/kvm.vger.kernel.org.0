Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1656F5F9748
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 05:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiJJD6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 23:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJJD6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 23:58:35 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AED4A105;
        Sun,  9 Oct 2022 20:58:33 -0700 (PDT)
Date:   Mon, 10 Oct 2022 03:58:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665374311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wy3CjO6m956FMVfpB0zMg7+XC0RTalCctjYSru1fYVw=;
        b=oWVAWjcVpjNvfw3SFVK1hv9hT41eVbN7mHBpbGOxDtRXsg5GY1AFAAAkuJRwIAznZbxpU5
        nc9ffUv45N30VWIHBvEDUPuQNvrtLIBLaFrl/OQ2zk9saqP75Oaalht3sM03S3i4iFLXvV
        LU80PITJOklUELxX1kHc62yxI2dgUWA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <Y0OYYZwoaW36UQK/@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
 <YyEeOxDndbEVHuxE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyEeOxDndbEVHuxE@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Ricardo,

On Tue, Sep 13, 2022 at 05:20:11PM -0700, Ricardo Koller wrote:

[...]

> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index d8127c25424c..5c0c8028d71c 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -763,17 +763,21 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  	return 0;
> >  }
> >  
> > +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > +				struct stage2_map_data *data);
> > +
> >  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> >  				     kvm_pte_t *ptep,
> >  				     struct stage2_map_data *data)
> >  {
> > -	if (data->anchor)
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
> > @@ -782,8 +786,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> >  	 * individually.
> >  	 */
> >  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> > -	data->anchor = ptep;
> > -	return 0;
> > +
> > +	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> 
> I think this always ends up calling stage2_map_walker_try_leaf() (at
> least it should). In that case, I think it might be clearer to do so, as
> the intention is to just install a block.

Yikes, I missed this in v2. I do agree with your point, it reads a bit
odd to call something that could reinstall a table.

Picked up the fix for v3. Thanks!

--
Best,
Oliver
