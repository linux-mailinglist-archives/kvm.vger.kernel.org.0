Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AF45B34C8
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIIKFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiIIKEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:04:49 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BABE266E;
        Fri,  9 Sep 2022 03:04:46 -0700 (PDT)
Date:   Fri, 9 Sep 2022 11:04:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662717884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAYIHP+5okh1OBy0npVyjWSJCHPvarSH75P9UOmP2gY=;
        b=Xc4YtLmnMk9UMIltU2T6jAMcxCVLjBTM6REusu7WFdxNshnChTBrhcb7ICp6jdLMTCmKwm
        9w0kU7AqzOeD5t2eWDxeP3ew40EYNzn/C7oDpICH04pNMes3iaQJBedEW7zAv+E5be5Ndc
        cuJg4M4g8qPjMkt3n4MrAXyJ734Mbj4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Quentin Perret <qperret@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
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
Message-ID: <YxsPtT6DXxl2q/OG@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
 <Yxdaw1qng/Or0LLA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxdaw1qng/Or0LLA@google.com>
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

On Tue, Sep 06, 2022 at 02:35:47PM +0000, Quentin Perret wrote:
> Hi Oliver,
> 
> On Tuesday 30 Aug 2022 at 19:41:20 (+0000), Oliver Upton wrote:
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
> > +
> > +	mm_ops->put_page(ptep);
> > +	mm_ops->free_removed_table(childp, level + 1, pgt);
> 
> By the look of it, __kvm_pgtable_visit() has saved the table PTE on the
> stack prior to calling the TABLE_PRE callback, and it then uses the PTE
> from its stack and does kvm_pte_follow() to find the childp, and walks
> from there. Would that be a UAF now?

Sure would, I suppose the actual UAF is hidden by the use of RCU later
in the series. Nonetheless, I'm going to adopt David's suggestion of
just rereading the PTE which should tidy this up.

Thanks for catching this.

--
Best,
Oliver
